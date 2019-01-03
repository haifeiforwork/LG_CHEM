<%/***************************************************************************************
*   System Name    : g-HR
*   1Depth Name        : Organization & Staffing
*   2Depth Name    : Headcount
*   Program Name   : Org.Unit/Length of Service
*                            (Org.Unit/Continuous)
*   Program ID         : F06DeptPositionClassService.jsp
*   Description        : 소속별/직급별 평균근속 조회를 위한 jsp 파일
*   Note               :
*   Creation           :
*    Update                :
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%
    request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");                           // 세션
    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);      // 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                   // 부서명

    Vector F06DeptServiceTitle_vt = (Vector)request.getAttribute("F06DeptServiceTitle_vt");         // 제목
    HashMap meta = (HashMap)request.getAttribute("meta");                                                   // 내용
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(paramA, paramB, paramC, paramD, paramE, paramF, value) {
    frm = document.form1;

    if (value!= "" && value!= "0") {
        /*if(paramC!= ""){
            paramC = paramC.substring(6,8);
        }*/
        if (paramB == 'TOTAL') {
            paramA = '00000000';
        }
        frm.hdn_gubun.value  = "11";                        // 소속별/직급별 평균근속
        frm.hdn_deptId.value = "<%=  deptId %>";    // 조회된 부서코드.
        frm.hdn_paramA.value = paramA;                  // 선택된 부서코드.
        frm.hdn_paramB.value = paramB;                  // 선택된 부서명
        frm.hdn_paramC.value = paramC;
        frm.hdn_paramD.value = paramD;
        frm.hdn_paramE.value = paramE;
        frm.hdn_paramF.value = paramF;
        if(paramD == ''){
            frm.hdn_paramF.value = '';
        }
        frm.hdn_excel.value = "";
        frm.action = "<%=  WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%=  WebUtil.ServletURL %>hris.F.F06DeptPositionClassServiceSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>

<jsp:include page="/include/header.jsp" />
 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId" value="<%=  deptId %>">
<input type="hidden" name="hdn_deptNm" value="<%=  deptNm %>">
<input type="hidden" name="hdn_excel" value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">

<input type="hidden" name="hdn_gubun" value="">
<input type="hidden" name="hdn_sText" value="">
<input type="hidden" name="hdn_paramA" value="">
<input type="hidden" name="hdn_paramB" value="">
<input type="hidden" name="hdn_paramC" value="">
<input type="hidden" name="hdn_paramD" value="">
<input type="hidden" name="hdn_paramE" value="">
<input type="hidden" name="hdn_paramF" value="">

<%
    if (F06DeptServiceTitle_vt != null && F06DeptServiceTitle_vt.size() > 0 ) {
%>

    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=  WebUtil.nvl(deptNm, user.e_obtxt) %><span class="commentOne"><spring:message code='MSG.F.F00.0003'/></span></h2>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
        </div>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
          <table class="listTable">
          	<thead>
            <tr>
              <th colspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F06.0001'/><!-- 1 YR.Under --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F06.0002'/><!-- 1~2 YR. --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F06.0003'/><!-- 2~3 YR. --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F06.0004'/><!-- 3~5 YR. --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F06.0005'/><!-- 5~7 YR. --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F06.0006'/><!-- 7~9 YR. --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F06.0007'/><!-- 9~11 YR. --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F06.0008'/><!-- 11 YR.Over --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
            </tr>
            </thead>
<%
    String temp = "";
    String tmpCode = "";
    for (int i = 0 ; i < F06DeptServiceTitle_vt.size() ; i ++) {
        F06DeptPositionClassServiceTitleGlobalData entity = (F06DeptPositionClassServiceTitleGlobalData) F06DeptServiceTitle_vt.get(i);
%>
    <tr class="borderRow">
        <%
            if ((!temp.equals(entity.STEXT)) || (!tmpCode.equals(entity.OBJID))) {
        %>
<%
                //내용 타이틀 병합.
                int noteCnt     = 1;
                int setCnt       = 0;

                 for( int inx = i; inx < F06DeptServiceTitle_vt.size(); inx++ ){
                 	F06DeptPositionClassServiceTitleGlobalData dataTitl = (F06DeptPositionClassServiceTitleGlobalData)F06DeptServiceTitle_vt.get(inx);

                     //병합을 위한 비교.
                     if( !dataTitl.JIKGT.equals("Sub-sum") ){
                         noteCnt++;
                     }else{
                         break;
                     } //end if
                 } //end for.
%>
        <td nowrap rowspan="<%= noteCnt%>" class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>' <%= entity.STEXT.equals("TOTAL")?"colspan='2'":"" %>>
            <%
                if (entity.ZLEVEL.equals(""))
                    entity.ZLEVEL = "0";
            %>
            <%= entity.STEXT %>
        </td>
        <%
            }
                if (!entity.STEXT.equals("TOTAL")){
        %>
        <td nowrap class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <%= entity.JIKGT%>
        </td>
        <%} %>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID %>','<%= entity.STEXT %>','<%= entity.JIKGU %>','1','LT','','<%= entity.F1 %>')"><%= WebUtil.printNumFormat(entity.F1) %></a>
        </td>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID %>','<%= entity.STEXT %>','<%= entity.JIKGU %>','1','BT','2','<%= entity.F2 %>')"><%= WebUtil.printNumFormat(entity.F2) %></a>
        </td>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID %>','<%= entity.STEXT %>','<%= entity.JIKGU %>','2','BT','3','<%= entity.F3 %>')"><%= WebUtil.printNumFormat(entity.F3) %></a>
        </td>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID %>','<%= entity.STEXT %>','<%= entity.JIKGU %>','3','BT','5','<%= entity.F4 %>')"><%= WebUtil.printNumFormat(entity.F4) %></a>
        </td>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID %>','<%= entity.STEXT %>','<%= entity.JIKGU %>','5','BT','7','<%= entity.F5 %>')"><%= WebUtil.printNumFormat(entity.F5) %></a>
        </td>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID %>','<%= entity.STEXT %>','<%= entity.JIKGU %>','7','BT','9','<%= entity.F6 %>')"><%= WebUtil.printNumFormat(entity.F6) %></a>
        </td>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID %>','<%= entity.STEXT %>','<%= entity.JIKGU %>','9','BT','11','<%= entity.F7 %>')"><%= WebUtil.printNumFormat(entity.F7) %></a>
        </td>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID%>','<%= entity.STEXT %>','<%= entity.JIKGU %>','11','GE','','<%= entity.F8 %>')"><%= WebUtil.printNumFormat(entity.F8) %></a>
        </td>
        <td class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a href="javascript:goDetail('<%= entity.OBJID %>','<%= entity.STEXT %>','<%= entity.JIKGU %>','','','<%= entity.F9 %>')"><%= WebUtil.printNumFormat(entity.F9) %></a>
        </td>
    </tr>
<%
        temp = entity.STEXT;
        tmpCode = entity.OBJID;
    }
%>
            </table>
        </div>
    </div>

</div>

<%
}else{
%>

    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %></h2>
        </table>
        <div class="table">
          <table class="listTable">
            <tr>
              <th colspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/> <!-- Org.Unit --></th>
              <th><spring:message code='LABEL.F.F06.0001'/><!-- 1 YR.Under --></th>
              <th><spring:message code='LABEL.F.F06.0002'/><!-- 1~2 YR. --></th>
              <th><spring:message code='LABEL.F.F06.0003'/><!-- 2~3 YR. --></th>
              <th><spring:message code='LABEL.F.F06.0004'/><!-- 3~5 YR. --></th>
              <th><spring:message code='LABEL.F.F06.0005'/><!-- 5~7 YR. --></th>
              <th><spring:message code='LABEL.F.F06.0006'/><!-- 7~9 YR. --></th>
              <th><spring:message code='LABEL.F.F06.0007'/><!-- 9~11 YR. --></th>
              <th><spring:message code='LABEL.F.F06.0008'/><!-- 11 YR.Over --></th>
              <th class="lastCol"><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
            </tr>
            <tr><td class="lastCol" colspan="11"><spring:message code='MSG.F.FCOMMON.0002'/></td></tr>
          </table>
    </div>
   </div>
  </div>
<%}%>
</form>
</body>
</html>
