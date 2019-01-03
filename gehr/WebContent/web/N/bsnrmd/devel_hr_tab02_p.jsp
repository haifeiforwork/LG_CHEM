<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.N.EHRCommonUtil" %>
<%@ page import="hris.C.C03LearnDetailData" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.common.Utils" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	String VFLAG = WebUtil.nvl(request.getParameter("VFLAG"));
	String searchPrsn = request.getParameter("searchPrsn");
	String I_ORGEH= WebUtil.nvl(request.getParameter("I_ORGEH"));
	HashMap resultMap = (HashMap)request.getAttribute("resultVT");
	Vector EduResultList_vt = (Vector)request.getAttribute("resultList_vt"); // [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청
	Vector cdpVT = (Vector)resultMap.get("T_CDP");
	Vector actVT = (Vector)resultMap.get("T_ACT");
	Vector edulVT = (Vector)resultMap.get("T_EDU");
	int sctSize =actVT.size();
	int eduSize =  edulVT.size();
%>


<jsp:include page="/include/header.jsp">
	<jsp:param name="modal" value="true"/>
</jsp:include>
	<script type="text/javascript">

		function popup(theURL,winName,features) {
		  window.open(theURL,winName,features);
		}

		function pageMove(command){
			var aForm = document.ehrForm;
			aForm.command.value = command;
			aForm.action ="<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendPTSV";

			blockFrame();

			aForm.submit();
		}
	</script>

<style type="text/css" >
	.contentBody h3 {padding-bottom:7px;}
	.tb_def th, .tb_def td {padding-top:3px;padding-bottom:3px;}
</style>

<jsp:include page="/include/pop-body-header.jsp">
	<jsp:param name="title" value="LABEL.N.N01.0032"/>
</jsp:include>
<form name="ehrForm" method="post">
<input type= "hidden" name="searchPrsn" value="<%=searchPrsn %>">
<input type= "hidden" name="I_ORGEH" value="<%=I_ORGEH %>">
<input type= "hidden" name="command" value="">

	<div class="tabArea">
		<ul class="tab">
			<li><a id="tab_1" class="-tab-link " href="javascript:void(0);" onclick="pageMove('INIT', 'tab_1')" ><spring:message code="LABEL.N.N01.0033" /><%--인적사항--%></a></li>
			<li><a id="tab_2" class="-tab-link selected" href="javascript:void(0);" onclick="pageMove('SUP', 'tab_2')" ><spring:message code="LABEL.N.N01.0034" /><%--인재육성--%></a></li>
			<li><a id="tab_3" class="-tab-link" href="javascript:void(0);" onclick="pageMove('PST', 'tab_3')" ><spring:message code="LABEL.N.N01.0035" /><%--Post 필요역량--%></a></li>
		</ul>
	</div>


		<h3><spring:message code="LABEL.N.N01.0031" /><!-- CDP 현황 --></h3>
		<div class="btnBottom right" style="margin-top:-20px">
			<a href="javascript:popup('<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendPTSV?command=CDP&searchPrsn=<%=searchPrsn %>','CDP','scrollbars=no,width=980,height=600')"><img src="<%= WebUtil.ImageURL %>ehr_button/btn_viewtable.gif" alt="도표 확인하기" /></a>
		</div>

			<!-- 테이블 시작 -->
			<table class="tb_def fixed" summary="" >
				<caption></caption>
				<col width="80" /><col  /><col  /><col  /><col  /><col  />
				<thead>
					<tr>
						<th><spring:message code="LABEL.N.N01.0070" /><!-- 육성 항목 --></th>
						<th colspan="5"><spring:message code="LABEL.N.N01.0071" /><!-- 육성 내용 --></th>
					</tr>
				</thead>
				<tbody>
<%
if(cdpVT.size() > 0 ){
	HashMap<String, String> cdpinfo = new HashMap<String, String>();
	for(int k = 0 ; k < cdpVT.size() ; k++){
		cdpinfo = (HashMap)cdpVT.get(k);
		String ITEM = cdpinfo.get("ITEM");
		String TEXT1  = cdpinfo.get("TEXT1");
		String TEXT2      = cdpinfo.get("TEXT2");
		String TEXT3      = cdpinfo.get("TEXT3");
		String TEXT4     = cdpinfo.get("TEXT4");
		String TEXT5      = cdpinfo.get("TEXT5");


%>
					<tr>
						<td><%=WebUtil.nvl(ITEM) %></td>
						<td><%=WebUtil.nvl(TEXT1) %></td>
						<td><%=WebUtil.nvl(TEXT2) %></td>
						<td><%=WebUtil.nvl(TEXT3) %></td>
						<td><%=WebUtil.nvl(TEXT4) %></td>
						<td><%=WebUtil.nvl(TEXT5) %></td>
					</tr>
<%}

	}else{%>

					<tr>
						<td colspan="6"><spring:message code="LABEL.N.N01.0052" /><!-- 조회된 데이터가 없습니다. --></td>
					</tr>
<%} %>
				</tbody>
			</table>

			<!-- 테이블 끝 -->
		<div style="float:left;width:460px;">
		<h3><spring:message code="LABEL.N.N01.0072" /><!-- 발령 사항 --></h3>
		<!-- div >
			<a href="javascript:popup('devel_hr_tab02_set_p.html','','scrollbars=no,width=600,height=500').html" class="btn"><span class="btnDef">개인화 설정</span><span class="btnDef_tail">&nbsp;</span></a>
		</div -->
		<div style="float:left;width:460px;">

			<!-- 테이블 시작 -->
			<table class="tb_def" summary="" >
				<caption></caption>
				<col width="75" /><col width="65" /><col  /><col width="50" /><col width="70" /><col width="50" />
				<thead>

					<tr>
						<th><spring:message code="LABEL.N.N01.0073" /><!-- 발령구분 --></th>
						<th><spring:message code="LABEL.N.N01.0074" /><!-- 발령일자 --></th>
						<th><spring:message code="LABEL.N.N01.0021" /><!-- 소속 --></th>
						<th><spring:message code="LABEL.N.N01.0075" /><!-- 직급 --></th>
						<th><%-- //[CSR ID:3456352]<spring:message code="LABEL.N.N01.0023" /><!-- 직위/연차 --> --%>
						<spring:message code="LABEL.N.N01.0094" />/<spring:message code="LABEL.N.N02.0027" /><!-- 직위/직급호칭/연차 -->
						</th>
						<th><spring:message code="LABEL.N.N01.0024" /><!-- 직책 --></th>
					</tr>

				</thead>
				<tbody>
<%

if(sctSize > 0 ){

	if(sctSize >10){
		sctSize = 10;
	}
	HashMap<String, String> actinfo = new HashMap<String, String>();
	for(int k = 0 ; k < sctSize; k++){
		actinfo = (HashMap)actVT.get(k);
		String MNTXT = actinfo.get("MNTXT");
		String BEGDA  = WebUtil.printDate(actinfo.get("BEGDA"));
		String ORGTX      = actinfo.get("ORGTX");
		String TRFGR      = actinfo.get("TRFGR");
		String TITEL     = actinfo.get("TITEL");
		String TITLE_YEAR      = actinfo.get("TITLE_YEAR");
		String TITL2      = actinfo.get("TITL2");


%>
					<tr>
						<td><%=WebUtil.nvl(MNTXT) %></td>
						<td><%=WebUtil.nvl(BEGDA.substring(2)) %></td>
						<td><%=WebUtil.nvl(ORGTX) %></td>
							<td><%=WebUtil.nvl(TRFGR) %></td>
						<td><%=TITEL%>/<%=EHRCommonUtil.reIntString(WebUtil.nvl(TITLE_YEAR)) %></td>
						<td><%=WebUtil.nvl(TITL2) %></td>
					</tr>
<%}
}else{
	%>
					<tr>
						<td colspan="6"><spring:message code="LABEL.N.N01.0052" /><!-- 조회된 데이터가 없습니다. --></td>
					</tr>
<%} %>

				</tbody>
			</table>
			<!-- 테이블 끝 -->
		</div>
		</div>

		<div style="float:right;width:460px;">
		<h3><spring:message code="LABEL.N.N01.0076" /><!-- 교육 이력 --></h3>
		<!-- div class="" style="">
			<a href="javascript:popup('devel_hr_tab02_set_p.html','','scrollbars=no,width=600,height=500').html" class="btn"><span class="btnDef">개인화 설정</span><span class="btnDef_tail">&nbsp;</span></a>
		</div !-->
		<div style="float:right;width:460px;">
			<!-- 테이블 시작 -->
			<table class="tb_def" summary="" >
				<caption></caption>
				<col width="26" /><col  width=""/><col  width="115"/><col  width="80" />
				<thead>
					<tr>
						<th><spring:message code="LABEL.N.N01.0077" /><!-- No. --></th>
						<th><spring:message code="LABEL.N.N01.0078" /><!-- 과정명 --></th>
						<th><spring:message code="LABEL.N.N01.0079" /><!-- 교육연수기간 --></th>
						<th><spring:message code="LABEL.N.N01.0080" /><!-- 교육기관 --></th>
					</tr>
				</thead>
				<tbody>
<%
if(Utils.getSize(EduResultList_vt) > 0 ){
	/*	 [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청
	f(eduSize >10){
		eduSize = 10;
	}*/

	HashMap<String, String> eduinfo = new HashMap<String, String>();
		/*
		[CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청
		for(int k = 0 ; k < eduSize ; k++){
		eduinfo  = (HashMap)edulVT.get(k);
		String STEXT_D = eduinfo .get("STEXT_D");
		String PERIOD  = eduinfo .get("PERIOD");
		String MC_STEXT      = eduinfo .get("MC_STEXT");
		*/

	for(int k = 0 ; k <Utils.getSize(EduResultList_vt) ; k++){
		C03LearnDetailData data = (C03LearnDetailData)EduResultList_vt.get(k);
		String STEXT_D = data.DVSTX;
		String PERIOD  = data.PERIOD;
		String MC_STEXT  = data.TESTX;
%>

					<tr>
						<td><%=k+1 %></td>
						<td class="left"><%=WebUtil.nvl(STEXT_D) %></td>
						<td><%=WebUtil.nvl(PERIOD) %></td>
						<td><%=WebUtil.nvl(MC_STEXT) %></td>
					</tr>
<%}
}else{
	%>
					<tr>
						<td colspan="4"><spring:message code="LABEL.N.N01.0052" /><!-- 조회된 데이터가 없습니다. --></td>
					</tr>

<%} %>
				</tbody>
			</table>
			<!-- 테이블 끝 -->
		</div>
		</div>
		<div class="clear"></div>


	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="javascript:pageMove('INIT', 'tab_1')"><span><spring:message code="LABEL.N.N01.0033"/><%--인적사항--%></span></a></li>
			<li><a href="javascript:pageMove('PST', 'tab_3')"><span><spring:message code="LABEL.N.N01.0035"/><%--Post 필요역량--%></span></a></li>
			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
		</ul>
	</div>


</form>
<jsp:include page="/include/pop-body-footer.jsp"/>

<jsp:include page="/include/footer.jsp"/>