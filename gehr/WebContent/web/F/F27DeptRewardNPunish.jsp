<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 포상/징계 내역
*   Program ID   : F27DeptRewardNPunish.jsp
*   Description  : 부서별 포상/징계 내역 조회를 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%

	// 웹로그 메뉴 코드명
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptReward_vt = (Vector)request.getAttribute("DeptReward_vt");
    Vector DeptPunish_vt = (Vector)request.getAttribute("DeptPunish_vt");

    HashMap empCnt1 = (HashMap)request.getAttribute("empCnt1");
    HashMap empCnt2 = (HashMap)request.getAttribute("empCnt2");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//Execl Down 하기.
function excelDown() {
    frm = document.form1;
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F27DeptRewardNPunishSV";
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
<input type="hidden" name="viewEmpno"   value="">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >


<!-- 화면에 보여줄 영역 시작 -->
<div class="listArea">
    <div class="listTop">
<%
    //부서명, 조회된 건수.
    if ( (DeptReward_vt != null && DeptReward_vt.size() > 0 ) || (DeptPunish_vt != null && DeptPunish_vt.size() > 0) ) {
%>
	    <h2 class="subtitle buttons"><spring:message code='LABEL.F.FCOMMON.0001'/><!--부서명  --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
        <div class="buttonArea">
            <ul class="btn_mdl">
                <li><a  onClick="javascript:excelDown();" class="unloading"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
            </ul>
        </div>
<%} else{%>
	    <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!--부서명  --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
<%} %>
        <div class="clear"></div>
    </div>

<%
    //부서명, 조회된 건수.
    if ( DeptReward_vt != null && DeptReward_vt.size() > 0 ) {
%>
<h2 class="subtitle"><spring:message code="MSG.A.A06.0001"/><%--포상--%></h2><span class="listCnt"><<!-- 총 --><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptReward_vt.size()%><spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건  -->></span>

<div class="listArea">
	<div class="wideTable" style="border-top: 2px solid #c8294b;">
	    <table class="listTable">
	    <thead>
	        <tr>
<%
	if( user.area == Area.KR ){
%>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%}else{%>
				<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%} %>
				<th><spring:message code="LABEL.F.F27.0001"/><!-- 포상일 --></th>
				<th><spring:message code="LABEL.F.F27.0002"/><!-- 포상유형 --></th>
				<th><spring:message code="LABEL.F.F27.0003"/><!-- 포상사유 --></th>
				<th class="lastCol"><spring:message code="LABEL.F.F27.0004"/><!-- 비고 --></th>
			</tr>
			</thead>

<%
		if( user.area == Area.KR ){
			String oldPer="";
			String sRow = "";
	        for( int i = 0; i < DeptReward_vt.size(); i++ ){
                F27DeptRewardNPunish01Data data = (F27DeptRewardNPunish01Data)DeptReward_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작
                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(data.PERNR);
                }
                oldPer = data.PERNR;
%>
          <tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.JIKCT %></td>
				<td nowrap <%= sRow %>><%= data.TRFST %></td>
				<td nowrap <%= sRow %>><%= data.VGLST %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
            <td nowrap><%= WebUtil.printDate(data.BEGDA) %></td>
            <td nowrap><%= data.PRZTX %></td>
            <td nowrap><%= data.PRZRN %></td>
            <td nowrap class="lastCol"><%= data.COMNT %></td>
          </tr>
<%
			} //end for...
		}else{
			String oldPer="";
			String sRow = "";
	        for( int i = 0; i < DeptReward_vt.size(); i++ ){
                F27DeptRewardNPunish01GlobalData dataG = (F27DeptRewardNPunish01GlobalData)DeptReward_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(dataG.PERNR, request); //암호화를 위한 작
                if(oldPer.equals(dataG.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(dataG.PERNR);
                }
                oldPer = dataG.PERNR;
%>
          <tr class="borderRow">
          <%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><%= dataG.NAME1 %></td>
				<td nowrap <%= sRow %>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= dataG.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= dataG.ENAME %></td>
				<td nowrap <%= sRow %>><%= dataG.ORGTX %></td>
				<td nowrap <%= sRow %>><%= dataG.JIKKT %></td>
				<td nowrap <%= sRow %>><%= dataG.JIKWT %></td>
				<td nowrap <%= sRow %>><%= dataG.VGLST %></td>
				<td nowrap <%= sRow %>><%= (dataG.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(dataG.DAT01) %></td>
			<%} %>
            <td nowrap><%= WebUtil.printDate(dataG.BEGDA) %></td>
            <td nowrap><%= dataG.AWRD_NAME %></td>
            <td nowrap><%= dataG.AWDTP %></td>
            <td nowrap class="lastCol"><%= dataG.AWRD_DESC %></td>
          </tr>
<%
			} //end for...
		}
%>

        </table>
    </div>
</div>

<%
}else{ //end if...
%>
<h2 class="subtitle"><spring:message code="MSG.A.A06.0001"/><%--포상--%></h2><span class="listCnt"><<!-- 총 --><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptReward_vt.size()%><spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건  -->></span>

<div class="listArea">
	<div class="table">
	    <table class="listTable">
	        <tr>
<%
	int colSpan = 0;
	if( user.area == Area.KR ){
		colSpan = 13;
%>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%}else{
		colSpan = 12;
%>
				<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%} %>
				<th><spring:message code="LABEL.F.F27.0001"/><!-- 포상일 --></th>
				<th><spring:message code="LABEL.F.F27.0002"/><!-- 포상유형 --></th>
				<th><spring:message code="LABEL.F.F27.0003"/><!-- 포상사유 --></th>
				<th class="lastCol"><spring:message code="LABEL.F.F27.0004"/><!-- 비고 --></th>
			</tr>
			<tr class="oddRow">
				<td class="lastCol" colSpan = "<%= colSpan%>"><spring:message code="MSG.F.FCOMMON.0002"/></td>
			</tr>
		</table>
	</div>
</div>


<%
}
    //부서명, 조회된 건수.
    if ( DeptPunish_vt != null && DeptPunish_vt.size() > 0 ) {
%>

<h2 class="subtitle"><spring:message code="LABEL.F.F27.0009"/><%--징계--%></h2>
<span class="listCnt"><<!-- 총 --><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptPunish_vt.size()%><spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건 -->></span>
<div class="listArea">
	<div class="wideTable" style="border-top: 2px solid #c8294b;">
	    <table class="listTable">
	        <tr>
<%

	if( user.area == Area.KR ){
%>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%}else{%>
				<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%} %>
				<th><spring:message code="LABEL.F.F27.0005"/><!-- 징계시작일 --></th>
				<th><spring:message code="LABEL.F.F27.0006"/><!-- 징계종료일 --></th>
				<th><spring:message code="LABEL.F.F27.0007"/><!-- 징계유형 --></th>
				<th class="lastCol"><spring:message code="LABEL.F.F27.0008"/><!-- 징계내역 --></th>
			</tr>

<%
		if( user.area == Area.KR ){
			String oldPer="";
			String sRow = "";
	        for( int i = 0; i < DeptPunish_vt.size(); i++ ){
	        	F27DeptRewardNPunish02Data punishData = (F27DeptRewardNPunish02Data)DeptPunish_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(punishData.PERNR, request); //암호화를 위한 작
                if(oldPer.equals(punishData.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt2.get(punishData.PERNR);
                }
                oldPer = punishData.PERNR;
%>
          <tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
	            <td nowrap <%= sRow %>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= punishData.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= punishData.ENAME %></td>
				<td nowrap <%= sRow %>><%= punishData.ORGTX %></td>
				<td nowrap <%= sRow %>><%= punishData.JIKKT %></td>
				<td nowrap <%= sRow %>><%= punishData.JIKWT %></td>
				<td nowrap <%= sRow %>><%= punishData.JIKCT %></td>
				<td nowrap <%= sRow %>><%= punishData.TRFST %></td>
				<td nowrap <%= sRow %>><%= punishData.VGLST %></td>
				<td nowrap <%= sRow %>><%= (punishData.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(punishData.DAT01) %></td>
			<%} %>
            <td nowrap><%= WebUtil.printDate(punishData.BEGDA) %></td>
            <td nowrap><%= WebUtil.printDate(punishData.ENDDA) %></td>
            <td nowrap><%= punishData.PUNTX %></td>
            <td nowrap class="lastCol"><%= punishData.PTEXT %></td>
          </tr>
<%
			} //end for...
		}else{
			String oldPer="";
			String sRow = "";
	        for( int i = 0; i < DeptPunish_vt.size(); i++ ){
	        	F27DeptRewardNPunish02GlobalData punishDataG = (F27DeptRewardNPunish02GlobalData)DeptPunish_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(punishDataG.PERNR, request); //암호화를 위한 작
                if(oldPer.equals(punishDataG.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt2.get(punishDataG.PERNR);
                }
                oldPer = punishDataG.PERNR;
%>
          <tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><%= punishDataG.NAME1 %></td>
				<td nowrap <%= sRow %>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= punishDataG.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= punishDataG.ENAME %></td>
				<td nowrap <%= sRow %>><%= punishDataG.ORGTX %></td>
				<td nowrap <%= sRow %>><%= punishDataG.JIKKT %></td>
				<td nowrap <%= sRow %>><%= punishDataG.JIKWT %></td>
				<td nowrap <%= sRow %>><%= punishDataG.VGLST %></td>
				<td nowrap <%= sRow %>><%= (punishDataG.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(punishDataG.DAT01) %></td>
			<%} %>
	            <td nowrap><%= WebUtil.printDate(punishDataG.BEGDA) %></td>
	            <td nowrap><%= WebUtil.printDate(punishDataG.ENDDA) %></td>
	            <td nowrap><%= punishDataG.PUNTX %></td>
	            <td nowrap class="lastCol"><%= punishDataG.PUNRS %></td>
          </tr>
<%
			} //end for...
		}
%>

        </table>
   </div>
   	<%//부서명, 조회된 건수.
	    if ( (DeptReward_vt != null && DeptReward_vt.size() > 0 ) || (DeptPunish_vt != null && DeptPunish_vt.size() > 0) ) {
	%>
	<div class="buttonArea">
	    <ul class="btn_mdl">
	        <li><a  onClick="javascript:excelDown();" class="unloading"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	    </ul>
	</div>
	<%} %>
</div>
<%
    }else{ //end if...
%>
   <!-- 화면에 보여줄 영역 끝 -->

<h2 class="subtitle"><spring:message code="LABEL.F.F27.0009"/><%--징계--%></h2>
<span class="listCnt"><<spring:message code="LABEL.F.FCOMMON.0006"/> <!-- 총 --><%=DeptPunish_vt.size()%><spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건 -->></span>
<div class="listArea">
	<div class="table">
	    <table class="listTable">
	        <tr>
<%
	int colSpan = 0;
	if( user.area == Area.KR ){
		colSpan = 13;

%>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%}else{
		colSpan = 12;
%>
				<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
                <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
<%} %>
				<th><spring:message code="LABEL.F.F27.0005"/><!-- 징계시작일 --></th>
				<th><spring:message code="LABEL.F.F27.0006"/><!-- 징계종류일 --></th>
				<th><spring:message code="LABEL.F.F27.0007"/><!-- 징계유형 --></th>
				<th class="lastCol"><spring:message code="LABEL.F.F27.0008"/><!-- 징계내역 --></th>
			</tr>
			<tr class="oddRow">
				<td class="lastCol" colspan="<%= colSpan %>"><spring:message code="MSG.F.FCOMMON.0002"/></td>
			</tr>
		</table>
	</div>
	<%//부서명, 조회된 건수.
	    if ( (DeptReward_vt != null && DeptReward_vt.size() > 0 ) || (DeptPunish_vt != null && DeptPunish_vt.size() > 0) ) {
	%>
	<div class="buttonArea">
	    <ul class="btn_mdl">
	        <li><a  onClick="javascript:excelDown();" class="unloading"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	    </ul>
	</div>
	<%} %>
</div>
<%
    }
%>

</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
