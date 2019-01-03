<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.N.EHRCommonUtil" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%

	String VFLAG = WebUtil.nvl(request.getParameter("VFLAG"));
	//조회할 사번
	String searchPrsn = request.getParameter("searchPrsn");
	String I_ORGEH= WebUtil.nvl(request.getParameter("I_ORGEH"));
	HashMap resultMap = (HashMap)request.getAttribute("resultVT");
	//


	Vector pinfoVT = (Vector)resultMap.get("T_BINFO");
	Vector schVT = (Vector)resultMap.get("T_ACADEMY");
	Vector evalVT = (Vector)resultMap.get("T_APPRAISAL");
	Vector lanVT = (Vector)resultMap.get("T_LANGUAGE");
	Vector carVT = (Vector)resultMap.get("T_CAREER");
	Vector punVT = (Vector)resultMap.get("T_PENALTY");

%>
<jsp:include page="/include/header.jsp">
	<jsp:param name="modal" value="true"/>
</jsp:include>
<script type="text/javascript">

	function popup(theURL,winName,features) {
		window.open(theURL,winName,features);
	}

	function pageMove(command, tabid){
		var aForm = document.ehrForm;
		aForm.command.value = command;
		aForm.action ="<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendPTSV";

		blockFrame();

		aForm.submit();

//		$(".-tab-link").removeClass("selected");
//		$("#" + tabid).addClass("selected");
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
			<li><a id="tab_1" class="-tab-link selected" href="javascript:void(0);" onclick="pageMove('INIT', 'tab_1')" ><spring:message code="LABEL.N.N01.0033" /><%--인적사항--%></a></li>
			<li><a id="tab_2" class="-tab-link" href="javascript:void(0);" onclick="pageMove('SUP', 'tab_2')" ><spring:message code="LABEL.N.N01.0034" /><%--인재육성--%></a></li>
			<li><a id="tab_3" class="-tab-link" href="javascript:void(0);" onclick="pageMove('PST', 'tab_3')" ><spring:message code="LABEL.N.N01.0035" /><%--Post 필요역량--%></a></li>
		</ul>
	</div>


	<h3><spring:message code="LABEL.N.N01.0036" /><!-- 기본 사항 --></h3>
	<%

		String PERNR	 = "";//PERSNO	NUMC	8	0	사원 번호
		String ENAME = ""; // 이름
		String STEXT	= "";//STEXT	CHAR	40	0	오브젝트 이름
		String TITEL	= "";//TITEL	CHAR	15	0	제목
		String TITLE_YEAR = ""; //	ZTYEAR	NUMC	3	0	직위년차
		String TITL2       = ""; //	TITL2	CHAR	15	0	직함 2
		String GBDAT = ""; //	GBDAT	DATS	8	0	생년월일
		String ENTDT = ""; //	ZENTG_DATE	DATS	8	0	그룹입사일자
		String HIRDT = ""; //	HIREDATE	DATS	8	0	입사일
		String URI	="" ; //CHAR	4096	0	SAP 아카이브링크: 절대 URI의 data element
		String RECRUIT_NAME ="";//		ZRNAME	CHAR	30	0	입사구분명
		String GNSOK = ""; 			//	ZGNSOK	DEC	6	2	근속년수
		String OLDS = ""; 		//	ZOLDS	DEC	6	2	연령

		if(pinfoVT.size() > 0 ){
			HashMap<String, String> hinfo = new HashMap<String, String>();
			hinfo = (HashMap)pinfoVT.get(0);
			ENAME = hinfo.get("ENAME"); // 이름
			STEXT	= hinfo.get("STEXT");//
			TITEL	= hinfo.get("TITEL");			//직위
			TITLE_YEAR = hinfo.get("TITLE_YEAR"); //직위년차
			TITL2       = hinfo.get("TITL2"); //	직함 2
			GBDAT = hinfo.get("GBDAT"); 	//	생년월일
			ENTDT = hinfo.get("ENTDT"); 	//	그룹입사일자
			HIRDT = hinfo.get("HIRDT"); 	//	입사일
			URI	= hinfo.get("URI");  	// 절대 URI의 data element
			RECRUIT_NAME =hinfo.get("RECRUIT_NAME");	//입사구분명
			GNSOK = hinfo.get("GNSOK"); 			//근속년수
			OLDS = hinfo.get("OLDS"); 		//	연령

		}
	%>
	<div style="float:left;width:81px;"><img src="<%= URI %>" class="reco_bsnm_pic" /></div>
	<div style="float:right;width:840px;height:120px;">
		<!-- 테이블 시작 -->
		<table class="tb_def fixed" summary="" >
			<caption></caption>
			<col width="90" /><col /><col width="90" /><col /><col width="90" /><col />
			<tbody>
			<tr>
				<th><spring:message code="LABEL.N.N01.0022" /><!-- 성명 --></th>
				<td class="left"><%= WebUtil.nvl(ENAME)%></td>
				<th><spring:message code="LABEL.N.N01.0021" /><!-- 소속 --></th>
				<td class="left" colspan="3"><%= WebUtil.nvl(STEXT)%></td>
			</tr>
			<tr>
				<th><%-- //[CSR ID:3456352]<spring:message code="LABEL.N.N01.0037" /><!-- 직위 --> --%>
				<spring:message code="LABEL.N.N01.0094" /><!-- 직위/직급호칭 -->
				</th>
				<td class="left"><%= WebUtil.nvl(TITEL)%></td>
				<th><spring:message code="LABEL.N.N01.0038" /><!-- 연차 --></th>
				<td class="left"><%= EHRCommonUtil.reIntString(WebUtil.nvl(TITLE_YEAR))%></td>
				<th><spring:message code="LABEL.N.N01.0024" /><!-- 직책 --></th>
				<td class="left"><%= WebUtil.nvl(TITL2)%></td>
			</tr>
			<tr>
				<th><spring:message code="LABEL.N.N01.0039" /><!-- 생년월일 --></th>
				<td class="left"><%= WebUtil.printDate(WebUtil.nvl(GBDAT))%></td>
				<th><spring:message code="LABEL.N.N01.0040" /><!-- 그룹입사일 --></th>
				<td class="left"><%= WebUtil.printDate(WebUtil.nvl(ENTDT))%></td>
				<th><spring:message code="LABEL.N.N01.0041" /><!-- 자사입사일 --></th>
				<td class="left"><%= WebUtil.printDate(WebUtil.nvl(HIRDT))%></td>
			</tr>
			<tr>
				<th><spring:message code="LABEL.N.N01.0042" /><!-- 입사구분 --></th>
				<td class="left"> <%= WebUtil.nvl(RECRUIT_NAME)%></td>
				<th><spring:message code="LABEL.N.N01.0043" /><!-- 근속 --></th>
				<td class="left"><%= WebUtil.nvl(GNSOK)%></td>
				<th><spring:message code="LABEL.N.N01.0044" /><!-- 연령 --></th>
				<td class="left"><%= WebUtil.nvl(OLDS)%></td>
			</tr>
			</tbody>
		</table>
		<!-- 테이블 끝 -->
	</div>
	<div class="clear"></div>
	<div style="float:left;width:460px;">
		<h3><spring:message code="LABEL.N.N01.0045" /><!-- 학력 사항 --></h3>

		<!-- 테이블 시작 -->
		<table class="tb_def" summary="" >
			<caption></caption>
			<col width="50" /><col  /><col width="80" /><col width="45" /><col width="80" /><col width="50" /><col width="50" />
			<thead>
			<tr>
				<th><spring:message code="LABEL.N.N01.0016" /><!-- 구분 --></th>
				<th><spring:message code="LABEL.N.N01.0046" /><!-- 학교 --></th>
				<th><spring:message code="LABEL.N.N01.0047" /><!-- 전공 --></th>
				<th><spring:message code="LABEL.N.N01.0048" /><!-- 학력 --></th>
				<th><spring:message code="LABEL.N.N01.0049" /><!-- 기간 --></th>
				<th><spring:message code="LABEL.N.N01.0050" /><!-- 졸업 --></th>
				<th><spring:message code="LABEL.N.N01.0051" /><!-- 소재지 --></th>
			</tr>
			</thead>
			<tbody>
			<%
				if(schVT.size() > 0 ){
					HashMap<String, String> schinfo = new HashMap<String, String>();
					for(int k = 0 ; k < schVT.size() ; k++){
						schinfo = (HashMap)schVT.get(k);
						String GUBUN = schinfo.get("GUBUN");
						String LART_TEXT  = schinfo.get("LART_TEXT");
						String FTEXT      = schinfo.get("FTEXT");
						String SLTXT      = schinfo.get("SLTXT");
						String PERIOD     = schinfo.get("PERIOD");
						String SATXT      = schinfo.get("SATXT");
						String SOJAE      = schinfo.get("SOJAE");

			%>
			<tr>
				<td><%=WebUtil.nvl(GUBUN) %></td>
				<td><%=WebUtil.nvl(LART_TEXT) %></td>
				<td><%=WebUtil.nvl(FTEXT) %></td>
				<td><%=WebUtil.nvl(SLTXT) %></td>
				<td><%=WebUtil.nvl(PERIOD) %></td>
				<td><%=WebUtil.nvl(SATXT) %></td>
				<td><%=WebUtil.nvl(SOJAE) %></td>
			</tr>
			<%}
			}else{
			%>

			<tr>
				<td colspan="7"><spring:message code="LABEL.N.N01.0052" /><!-- 조회된 데이터가 없습니다. --></td>

			</tr>
			<%} %>

			</tbody>
		</table>
		<!-- 테이블 끝 -->
		<h3><spring:message code="LABEL.N.N01.0053" /><!-- 평가 사항 --></h3>

		<!-- 테이블 시작 -->
		<table class="tb_def" summary="" >
			<caption></caption>
			<col width="60" /><col  /><col width="80" /><col width="50" /><col width="90" />
			<thead>
			<tr>
				<th><spring:message code="LABEL.N.N01.0054" /><!-- 연도 --></th>
				<th><spring:message code="LABEL.N.N01.0021" /><!-- 소속 --></th>
				<th><spring:message code="LABEL.N.N01.0037" /><!-- 직위 --></th>
				<th><spring:message code="LABEL.N.N01.0055" /><!-- 최종평가 --></th>
				<th><spring:message code="LABEL.N.N01.0056" /><!-- 평가자 --></th>
			</tr>
			</thead>
			<tbody>
			<%
				if(evalVT.size() > 0 ){
					HashMap<String, String> evalinfo = new HashMap<String, String>();
					for(int k = 0 ; k < evalVT.size() ; k++){
						evalinfo = (HashMap)evalVT.get(k);
						String eYEAR = evalinfo.get("YEAR"); //
						String eORGTX  = evalinfo.get("ORGTX"); //
						String eTITEL      = evalinfo.get("TITEL"); //
						String eRTEXT      = evalinfo.get("RTEXT"); //
						String eBOSS_NAME     = evalinfo.get("BOSS_NAME"); //


			%>
			<tr>
				<td><%=WebUtil.nvl(eYEAR) %></td>
				<td class="left"><%=WebUtil.nvl(eORGTX) %></td>
				<td><%=WebUtil.nvl(eTITEL) %></td>
				<td><%=WebUtil.nvl(eRTEXT) %></td>
				<td><%=WebUtil.nvl(eBOSS_NAME) %></td>
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
	<div style="float:right;width:460px;">
		<h3><spring:message code="LABEL.N.N01.0057" /><!-- 어학 능력 --></h3>
		<!-- 테이블 시작 -->
		<table class="tb_def" summary="" >
			<caption></caption>
			<col  /><col  /><col  /><col  />
			<thead>
			<tr>
				<th><spring:message code="LABEL.N.N01.0058" /><!-- 검정구분 --></th>
				<th><spring:message code="LABEL.N.N01.0059" /><!-- 검정일 --></th>
				<th><spring:message code="LABEL.N.N01.0010" /><!-- 점수 --></th>
				<th><spring:message code="LABEL.N.N01.0060" /><!-- 등급 --></th>
			</tr>
			</thead>
			<tbody>
			<%
				if(lanVT.size() > 0 ){
					HashMap<String, String> laninfo = new HashMap<String, String>();
					for(int k = 0 ; k < lanVT.size() ; k++){
						laninfo = (HashMap)lanVT.get(k);
						String aSTEXT = laninfo.get("STEXT"); //
						String aBEGDA  = laninfo.get("BEGDA"); //
						String aPOINT      = laninfo.get("POINT"); //
						String aRATING      = laninfo.get("RATING"); //

			%>
			<tr>
				<td><%=WebUtil.nvl(aSTEXT) %></td>
				<td><%=WebUtil.printDate(WebUtil.nvl(aBEGDA)) %></td>
				<td><%=WebUtil.nvl(aPOINT) %></td>
				<td>
					<%=EHRCommonUtil.reIntString(WebUtil.nvl(aRATING)) %>
					<%
								if(!WebUtil.nvl(aRATING).equals("")){
							%><spring:message code="LABEL.N.N01.0061" /><!-- 급 -->

					<%} %>
				</td>
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

		<h3><spring:message code="LABEL.N.N01.0062" /><!-- 경력 사항 --></h3>
		<!-- 테이블 시작 -->
		<table class="tb_def" summary="" >
			<caption></caption>
			<col  /><col  /><col  /><col  />
			<thead>
			<tr>
				<th><spring:message code="LABEL.N.N01.0063" /><!-- 근무처 --></th>
				<th><spring:message code="LABEL.N.N01.0064" /><!-- 근무기간 --></th>
				<th><spring:message code="LABEL.N.N01.0037" /><!-- 직위 --></th>
				<th><spring:message code="LABEL.N.N01.0065" /><!-- 직무 --></th>
			</tr>
			</thead>
			<tbody>
			<%
				if(carVT.size() > 0 ){
					HashMap<String, String> carinfo = new HashMap<String, String>();
					for(int k = 0 ; k < carVT.size() ; k++){
						carinfo = (HashMap)carVT.get(k);
						String cARBGB = carinfo.get("ARBGB"); //
						String cPERIOD  = carinfo.get("PERIOD"); //
						String cTITL_TEXT      = carinfo.get("TITL_TEXT"); //
						String cJOBB_TEXT      = carinfo.get("JOBB_TEXT"); //

			%>
			<tr>
				<td><%=WebUtil.nvl(cARBGB) %></td>
				<td><%=WebUtil.nvl(cPERIOD) %></td>
				<td><%=WebUtil.nvl(cTITL_TEXT) %></td>
				<td><%=WebUtil.nvl(cJOBB_TEXT) %></td>
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

		<h3><spring:message code="LABEL.N.N01.0066" /><!-- 징계 사항 --></h3>
		<!-- 테이블 시작 -->
		<table class="tb_def" summary="" >
			<caption></caption>
			<col  /><col  /><col  />
			<thead>
			<tr>
				<th><spring:message code="LABEL.N.N01.0067" /><!-- 징계유형 --></th>
				<th><spring:message code="LABEL.N.N01.0068" /><!-- 징계일자 --></th>
				<th><spring:message code="LABEL.N.N01.0069" /><!-- 징계내역 --></th>
			</tr>
			</thead>
			<tbody>
			<%
				if(punVT.size() > 0 ){
					HashMap<String, String> puninfo = new HashMap<String, String>();
					for(int k = 0 ; k < punVT.size() ; k++){
						puninfo = (HashMap)punVT.get(k);
						String PUNTX = puninfo.get("PUNTX");
						String DISC_DATE  = puninfo.get("DISC_DATE");
						String PUNTY_RESN      = puninfo.get("PUNTY_RESN");
			%>
			<tr>
				<td><%=WebUtil.nvl(PUNTX) %></td>
				<td><%=WebUtil.printDate(WebUtil.nvl(DISC_DATE)) %></td>
				<td><%=WebUtil.nvl(PUNTY_RESN) %></td>
			</tr>
			<%}
			}else{%>
			<tr>
				<td colspan="3"><spring:message code="LABEL.N.N01.0052" /><!-- 조회된 데이터가 없습니다. --></td>
			</tr>
			<%} %>
			</tbody>
		</table>
		<!-- 테이블 끝 -->
	</div>
	<div class="clear"></div>

	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="javascript:pageMove('SUP', 'tab_2')"><span><spring:message code="LABEL.N.N01.0034"/><%--인재육성--%></span></a></li>
			<li><a href="javascript:pageMove('PST', 'tab_3')"><span><spring:message code="LABEL.N.N01.0035"/><%--Post 필요역량--%></span></a></li>
			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
		</ul>
	</div>


</form>
<jsp:include page="/include/pop-body-footer.jsp"/>

<jsp:include page="/include/footer.jsp"/>