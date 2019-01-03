<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 인원현황 각각의 상세화면
*   Program ID   : F00DeptDetailList.jsp
*   Description  : 인원현황 각각의 상세화면 조회를 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
*
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>


<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
    // 웹로그 메뉴 코드명
    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

    WebUserData user    = (WebUserData)session.getAttribute("user");                    //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
    String gubun        = WebUtil.nvl(request.getParameter("hdn_gubun"));           //구분값.
    String checkYN      = WebUtil.nvl(request.getParameter("chck_yeno"));           //하위부서여부.
    String paramA       = WebUtil.nvl(request.getParameter("hdn_paramA"));          //파라메타
    String paramB       = WebUtil.nvl(request.getParameter("hdn_paramB"));          //파라메타
    String paramC       = WebUtil.nvl(request.getParameter("hdn_paramC"));          //파라메타
    String paramD       = WebUtil.nvl(request.getParameter("hdn_paramD"));          //파라메타
    String paramE       = WebUtil.nvl(request.getParameter("hdn_paramE"));          //파라메타
    Vector F00DeptDetailListData_vt  = (Vector)request.getAttribute("F00DeptDetailListData_vt");    //내용
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

//목록으로 가기.
function do_list(){
    history.back();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_gubun.value  = "<%= gubun %>";      //구분값
    frm.hdn_deptId.value = "<%= deptId %>";     //부서코드
    frm.chck_yeno.value  = "<%= checkYN %>";    //하위부서여부
    frm.hdn_paramA.value = "<%= paramA %>";     //파라메타
    frm.hdn_paramB.value = "<%= paramB %>";     //파라메타
    frm.hdn_paramC.value = "<%= paramC %>";     //파라메타
    frm.hdn_paramD.value = "<%= paramD %>";     //파라메타
    frm.hdn_paramE.value = "<%= paramE %>";     //파라메타
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
    frm.target = "hidden";
    frm.submit();
}

function popupView(winName, width, height, pernr) {
    var formN = document.form1;
    formN.viewEmpno.value = pernr;

    var screenwidth = (screen.width-width)/2;
    var screenheight = (screen.height-height)/2;
    var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr;

     var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

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

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="chck_yeno"   value="">
<input type="hidden" name="hdn_paramA"  value="">
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="">
<input type="hidden" name="hdn_paramE"  value="">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">

<div class="subWrapper">
    <div class="title">
          <h1><spring:message code='LABEL.F.F00.0001'/><!-- 인원현황 상세목록 --></h1>
    </div>

<%
    if ( F00DeptDetailListData_vt != null && F00DeptDetailListData_vt.size() > 0 ) {
%>


<h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><<spring:message code='LABEL.F.FCOMMON.0006'/> <!-- 총 --><%=F00DeptDetailListData_vt.size()%><spring:message code='LABEL.F.FCOMMON.0007'/><!-- 건 -->></span>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:do_list();"><span><spring:message code='LABEL.F.F01.0038'/><!-- 목록 --></span></a></li>
                    <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
        </div>
        <div class="table">
          <table class="listTable">
          	<thead>
            <tr>
              <th><spring:message code='LABEL.F.F00.0002'/><!-- 사번 --></th>
              <th><spring:message code='LABEL.F.F00.0003'/><!-- 이름 --></th>
              <th><spring:message code='LABEL.F.F00.0004'/><!-- 소속 --></th>
              <th><spring:message code='LABEL.F.F00.0005'/><!-- 소속약어 --></th>
              <th><spring:message code='LABEL.F.F00.0006'/><!-- 신분 --></th>
              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              <%--<th><spring:message code='LABEL.F.F00.0007'/><!-- 직위 --></th> --%>
              <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
              <th><spring:message code='LABEL.F.F00.0008'/><!-- 직책 --></th>
              <th><spring:message code='LABEL.F.F00.0009'/><!-- 직급 --></th>
              <th><spring:message code='LABEL.F.F00.0010'/><!-- 호봉 --></th>
              <th><spring:message code='LABEL.F.F00.0011'/><!-- 년차 --></th>
              <th><spring:message code='LABEL.F.F00.0012'/><!-- 직무 --></th>
              <th><spring:message code='LABEL.F.F00.0013'/><!-- 입사일자 --></th>
              <th><spring:message code='LABEL.F.F00.0014'/><!-- 생년월일 --></th>
              <th class="lastCol"><spring:message code='LABEL.F.F00.0015'/><!-- 근무지 --></th>
            </tr>
            </thead>

<%
        //내용.
        for( int i = 0; i < F00DeptDetailListData_vt.size(); i++ ){
            F00DeptDetailListData data = (F00DeptDetailListData)F00DeptDetailListData_vt.get(i);
            String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작
%>
        <tr class="borderRow">
          <td><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
          <td><%= data.ENAME %></td>
          <td><%= data.STEXT %></td>
          <td><%= data.ORGTX %></td>
          <td><%= data.PTEXT %></td>
          <td><%= data.TITEL %></td>
          <td><%= data.TITL2 %></td>
          <td><%= data.TRFGR %></td>
          <td><%= data.TRFST %></td>
          <td><%= data.VGLST %></td>
          <td><%= data.STELL_TEXT %></td>
          <td><%= (data.DAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT) %></td>
          <td><%= (data.GBDAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.GBDAT) %></td>
          <td class="lastCol"><%= data.BTEXT %></td>
        </tr>
<%
        } //end for...
%>
            </table>
        </div>
    </div>

    <div class="buttonArea">
        <ul class="btn_mdl">
            <li><a href="javascript:do_list();"><span><spring:message code='LABEL.F.F01.0038'/><!-- 목록 --></span></a></li>
            <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
        </ul>
    </div>

</div>

<%
    }else{
%>


    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
        </div>
        <div class="table">
          <table class="listTable">
            <tr>
              <th><spring:message code='LABEL.F.F00.0002'/><!-- 사번 --></th>
              <th><spring:message code='LABEL.F.F00.0003'/><!-- 이름 --></th>
              <th><spring:message code='LABEL.F.F00.0004'/><!-- 소속 --></th>
              <th><spring:message code='LABEL.F.F00.0005'/><!-- 소속약어 --></th>
              <th><spring:message code='LABEL.F.F00.0006'/><!-- 신분 --></th>
              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              <%--<th><spring:message code='LABEL.F.F00.0007'/><!-- 직위 --></th> --%>
              <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
              <th><spring:message code='LABEL.F.F00.0008'/><!-- 직책 --></th>
              <th><spring:message code='LABEL.F.F00.0009'/><!-- 직급 --></th>
              <th><spring:message code='LABEL.F.F00.0010'/><!-- 호봉 --></th>
              <th><spring:message code='LABEL.F.F00.0011'/><!-- 년차 --></th>
              <th><spring:message code='LABEL.F.F00.0012'/><!-- 직무 --></th>
              <th><spring:message code='LABEL.F.F00.0013'/><!-- 입사일자 --></th>
              <th><spring:message code='LABEL.F.F00.0014'/><!-- 생년월일 --></th>
              <th class="lastCol"><spring:message code='LABEL.F.F00.0015'/><!-- 근무지 --></th>
            </tr>
            <tr class="oddRow">
            	<td colspan="14"><spring:message code='MSG.F.FCOMMON.0002'/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
            </tr>
           </table>
           </div>
               <div class="buttonArea">
        <ul class="btn_mdl">
            <li><a href="javascript:do_list();"><span><spring:message code='LABEL.F.F01.0038'/><!-- 목록 --></span></a></li>
        </ul>
    </div>
    </div>

<%
    } //end if...
%>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

