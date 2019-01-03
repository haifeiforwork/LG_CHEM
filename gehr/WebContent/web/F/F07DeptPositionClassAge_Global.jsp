<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 소속별 평균연령(해외)
*   Program ID   : F07DeptPositionClassAge_Global.jsp
*   Description  : 소속별 평균연령(해외) 조회를 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>

<%
    request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");                                    //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);            //부서코드
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                          //부서명
    Vector F07DeptAgeTitle_vt = (Vector)request.getAttribute("F07DeptAgeTitle_vt");                 //제목
    HashMap meta = (HashMap)request.getAttribute("meta");          //내용
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(paramA, paramB, paramC, paramD, paramE, paramF, value){
    frm = document.form1;

    if( value!= "" && value!= "0"){
        /*if(paramC!= ""){
            paramC = paramC.substring(6,8);
        } */
        if( paramB == 'TOTAL' ){
            paramA = '00000000';
        }
        frm.hdn_gubun.value  = "12";             //소속별/직급별 평균연령
        frm.hdn_deptId.value = "<%= deptId %>";  //조회된 부서코드.
        frm.hdn_paramA.value = paramA;           //선택된 부서코드.
        frm.hdn_paramB.value = paramB;           //선택된 부서명
        frm.hdn_paramC.value = paramC;
        frm.hdn_paramD.value = paramD;
        frm.hdn_paramE.value = paramE;
        frm.hdn_paramF.value = paramF;
        if(paramD == ''){
            frm.hdn_paramF.value = '';
        }
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F07DeptPositionClassAgeSV";
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
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_sText"   value="">
<input type="hidden" name="hdn_paramA"  value="">
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="">
<input type="hidden" name="hdn_paramE"  value="">
<input type="hidden" name="hdn_paramF"  value="">
<%
    if ( F07DeptAgeTitle_vt != null && F07DeptAgeTitle_vt.size() > 0 ) {
%>

    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%><span class="commentOne"><spring:message code='MSG.F.F00.0003'/><!-- Expatriate and Contractor is not included. --></span></h2>
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
                  <th width="100" nowrap><spring:message code='LABEL.F.F06.0010'/><!-- 18 Age.Under --></th>
                  <th width="100" nowrap><spring:message code='LABEL.F.F06.0011'/><!-- 18~19 Age. --></th>
                  <th width="100" nowrap><spring:message code='LABEL.F.F06.0012'/><!-- 20~24 Age. --></th>
                  <th width="100" nowrap><spring:message code='LABEL.F.F06.0013'/><!-- 25~29 Age. --></th>
                  <th width="100" nowrap><spring:message code='LABEL.F.F06.0014'/><!-- 30~34 Age. --></th>
                  <th width="100" nowrap><spring:message code='LABEL.F.F06.0015'/><!-- 35~39 Age. --></th>
                  <th width="100" nowrap><spring:message code='LABEL.F.F06.0016'/><!-- 40 Age.Over --></th>
                  <th width="100" nowrap><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
                </tr>
                </thead>
<%
    String temp = "";
    String tmpCode = "";
    for(int i = 0 ; i < F07DeptAgeTitle_vt.size() ; i ++){
    	F07DeptPositionClassAgeTitleGlobalData entity = (F07DeptPositionClassAgeTitleGlobalData) F07DeptAgeTitle_vt.get(i);
%>
    <tr class="borderRow">
        <%
            if(!temp.equals(entity.STEXT) || !tmpCode.equals(entity.OBJID)){
        %>
        <td nowrap rowspan="<%=meta.get(entity.STEXT + entity.OBJID) %>" class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>' <%=entity.STEXT.equals("TOTAL")?"colspan='2'":""%> >
            <%
                if(entity.ZLEVEL.equals(""))
                    entity.ZLEVEL = "0";
                //for( int j = 0 ; j < Integer.parseInt(entity.ZLEVEL); j ++){
            %>

            <%
                //}
            %>
            <%=entity.STEXT %>
        </td>
        <%
            }if(!entity.STEXT.equals("TOTAL")){
        %>
        <td nowrap class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <%=entity.JIKGT%>
        </td>
        <%} %>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','18','LT','','<%=entity.F1%>')"><%=WebUtil.printNumFormat(entity.F1)%></a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','18','BT','19','<%=entity.F2%>')"><%=WebUtil.printNumFormat(entity.F2)%></a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','20','BT','24','<%=entity.F3%>')"><%=WebUtil.printNumFormat(entity.F3)%></a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','25','BT','29','<%=entity.F4%>')"><%=WebUtil.printNumFormat(entity.F4)%></a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','30','BT','34','<%=entity.F5%>')"><%=WebUtil.printNumFormat(entity.F5)%></a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','35','BT','39','<%=entity.F6%>')"><%=WebUtil.printNumFormat(entity.F6)%></a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','40','GE','<%=entity.F7%>')"><%=WebUtil.printNumFormat(entity.F7)%></a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','','','<%=entity.F8%>')"><%=WebUtil.printNumFormat(entity.F8)%></a>
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
            <h2 class="subtitle">Org.Unit : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></div>
        </div>
        <div class="table">
             <table class="listTable">
                <tr>
                  <th colspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/></th>
                  <th><spring:message code='LABEL.F.F06.0017'/><!-- 20 Age.Under --></th>
                  <th><spring:message code='LABEL.F.F06.0012'/><!-- 20~24 Age. --></th>
                  <th><spring:message code='LABEL.F.F06.0013'/><!-- 25~29 Age. --></th>
                  <th><spring:message code='LABEL.F.F06.0014'/><!-- 30~34 Age. --></th>
                  <th><spring:message code='LABEL.F.F06.0015'/><!-- 35~39 Age. --></th>
                  <th><spring:message code='LABEL.F.F06.0016'/><!-- 40 Age.Over --></th>
                  <th class="lastCol"><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
                </tr>
                <tr><td class="lastCol" colspan="11"><spring:message code='LABEL.F.FCOMMON.0002'/></td></tr>
            </table>
        </div>
    </div>
</div>
<%
    } //end if...
%>
</form>
</body>
</html>

