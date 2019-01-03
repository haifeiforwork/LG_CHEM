<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 소속별 인종,성별 인원현황
*   Program ID   : F10DeptRaceClass_Global.jsp
*   Description  : 소속별 인종,성별 인원현황 조회를 위한 jsp 파일
*   Note         :
*   Update       :
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.common.util.*" %>

<%
    request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");                                    //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);            //부서코드
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));   //부서명
    Vector DeptRaceClassTitle_vt = (Vector)request.getAttribute("DeptRaceClassTitle_vt");         //제목
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
    HashMap meta = (HashMap)request.getAttribute("meta");
    Integer han = (Integer)request.getAttribute("han_sum");         //내용
    Integer chosen = (Integer)request.getAttribute("chosen_sum");         //내용
    Integer man = (Integer)request.getAttribute("man_sum");         //내용
    Integer other = (Integer)request.getAttribute("other_sum");         //내용
    Integer total = (Integer)request.getAttribute("total_sum");         //내용
    int han_sum = han == null ? 0 :han.intValue();
    int chosen_sum = chosen == null ? 0 :chosen.intValue();
    int man_sum = man == null ? 0 :man.intValue();
    int other_sum = other == null ? 0 :other.intValue();
    int total_sum = total == null ? 0 :total.intValue();
    //total_sum = 1;
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(paramA, paramB, paramC, paramD, paramE, value){
    frm = document.form1;

    if( value!= "" && value!= "0"){
        if( paramB == 'TOTAL' ){
            paramA = '00000000';//'<%//= ((F10DeptRaceClassTitleGlobalData)DeptRaceClassTitle_vt.get(0)).OBJID %>';
        }
        frm.hdn_gubun.value  = "15";             //직무별/최종학력별
        frm.hdn_deptId.value = "<%= deptId %>";  //조회된 부서코드.
        frm.hdn_paramA.value = paramA;           //선택된 부서코드.
        frm.hdn_paramB.value = paramB;           //선택된 부서명
        frm.hdn_paramC.value = paramC;
        frm.hdn_paramD.value = paramD;
        frm.hdn_paramE.value = paramE;
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
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F10DeptRaceClassSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>

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
<%
    if ( DeptRaceClassTitle_vt != null && DeptRaceClassTitle_vt.size() > 0 ) {
%>

    <%
        int signal = 0;
        if(han_sum > 0)
            signal ++;
        if(chosen_sum > 0)
            signal ++;
        if(man_sum > 0)
            signal ++;
        if(other_sum > 0)
            signal ++;
        if(total_sum > 0)
            signal ++;
    %>
    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%><span class="commentOne"><spring:message code='MSG.F.F00.0003'/><!-- Expatriate is not included. --></span></h2>
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
              <th colspan="2" rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/></th>
              <th colspan="<%=signal %>"><spring:message code='LABEL.F.F10.0001'/><!-- Ethnic --></th>
              <th colspan="3"><spring:message code='LABEL.F.F10.0002'/><%-- Gender --%></th>
              <!-- td class="td03" rowspan="2" width="60px;">TOTAL</td -->
            </tr>
            <tr>
              <%
                if(han_sum>0){
              %>
              <th width="100" nowrap><spring:message code='LABEL.F.F10.0003'/><!-- Han Zu --></th>
              <%
              }if(chosen_sum>0){
               %>
              <th width="100" nowrap><spring:message code='LABEL.F.F10.0009'/><!-- Chaoxian Zu --></th>
              <%
              }if(man_sum>0){
              %>
              <th width="100" nowrap><spring:message code='LABEL.F.F10.0005'/><!-- Man Zu --></th>
              <%
              }
              if(other_sum>0){
              %>
              <th width="100" nowrap><spring:message code='LABEL.F.F42.0069'/><!-- Others --></th>
              <%
              }
              if(total_sum>0){
              %>
              <th width="100" nowrap><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></th>
              <%
              }
              %>
              <th width="100" nowrap><spring:message code='LABEL.F.F10.0007'/><!-- Male --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F10.0008'/><!-- Female --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></th>
            </tr>
            </thead>
<%
    String temp = "";
    String tmpCode = "";
    for(int i = 0 ; i < DeptRaceClassTitle_vt.size() ; i ++){
        F10DeptRaceClassTitleGlobalData entity = (F10DeptRaceClassTitleGlobalData) DeptRaceClassTitle_vt.get(i);
%>
    <tr class="borderRow">
        <%
            if(!temp.equals(entity.STEXT) || !tmpCode.equals(entity.OBJID)){
        %>
        <td nowrap rowspan="<%=meta.get(entity.STEXT + entity.OBJID) %>" class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>' <%=entity.STEXT.equals("TOTAL")?"colspan='2'":""%>>
            <%
                if(entity.ZLEVEL.equals(""))
                    entity.ZLEVEL = "0";
            %>
            <%=entity.STEXT %>
        </td>
        <%
            }if(!entity.STEXT.equals("TOTAL")){
        %>
        <td nowrap class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'><%=entity.JIKGT%>
        </td>
        <%}
            if(han_sum>0){
        %>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','RACKY','01','<%=entity.F1%>')">
        <%=WebUtil.printNumFormat(entity.F1)%>
        </a>
        </td>
        <%
            }if(chosen_sum>0){
        %>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','RACKY','10','<%=entity.F2%>')">
        <%=WebUtil.printNumFormat(entity.F2)%>
        </a>
        </td>
        <%
            }if(man_sum>0){
         %>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','RACKY','11','<%=entity.F3%>')">
        <%=WebUtil.printNumFormat(entity.F3)%>
        </a>
        </td>
        <%
            }
            if(other_sum>0){
        %>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','RACKY','88','<%=entity.F4%>')">
        <%=WebUtil.printNumFormat(entity.F4)%>
        </a>
        </td>
        <%
            }
            if(total_sum>0){
        %>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','RACKY','99','<%=entity.F5%>')">
        <%=WebUtil.printNumFormat(entity.F5)%>
        </a>
        </td>
        <%
            }
        %>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','GESCH','1','<%=entity.F6%>')">
        <%=WebUtil.printNumFormat(entity.F6)%>
        </a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','GESCH','2','<%=entity.F7%>')">
        <%=WebUtil.printNumFormat(entity.F7)%>
        </a>
        </td>
        <td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"" %>'>
        <a title="<%=entity.STEXT %>" href="javascript:goDetail('<%=entity.OBJID%>','<%=entity.STEXT%>','<%=entity.JIKGU%>','','','<%=entity.F8%>')">
        <%=WebUtil.printNumFormat(entity.F8)%>
        </a>
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
            <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
        </div>
        <div class="table">
          <table border="0" cellpadding="0" cellspacing="1" class="table02" align="left" >
            <tr>
              <th colspan="2" rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --></th>
              <th colspan="5"><spring:message code='LABEL.F.F10.0001'/><!-- Ethnic --></th>
              <th class="lastCol" colspan="3"><spring:message code='LABEL.F.F10.0002'/><!-- Gender --></th>
              <!-- td class="td03" rowspan="2" width="60px;">TOTAL</td -->
            </tr>
            <tr>

              <th><spring:message code='LABEL.F.F10.0003'/><!-- Han Zu --></th>
              <th><spring:message code='LABEL.F.F10.0004'/><!-- Chosen Zu --></th>
              <th><spring:message code='LABEL.F.F10.0005'/><!-- Man Zu --></th>
              <th><spring:message code='LABEL.F.F42.0069'/><!-- Others --></th>
              <th><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></th>
              <th><spring:message code='LABEL.F.F10.0007'/><!-- Male --></th>
              <th><spring:message code='LABEL.F.F10.0008'/><!-- Female --></th>
              <th class="lastCol"><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></th>
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

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

