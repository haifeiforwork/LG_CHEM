<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.common.Utils" %>
<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%

	HashMap resultMap = (HashMap)request.getAttribute("resultVT");
	Vector cdpVT = (Vector)resultMap.get("T_CDP2");
	String HIRDT = (String)resultMap.get("E_HIRDT");
	//
	//해당기간 현재 년도에서 입사일.......
	int iHIRDT = 0;
	int gapSize  = 0;
	int totalYear  =0;

	//
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">

<head>


	<title>LG화학 e-HR 시스템</title>
	<meta name="description" content="LG화학 e-HR 시스템" />
	<link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL %>css/ehr_style.css" />
	<script type="text/javascript">

		function popup(theURL,winName,features) {
		  window.open(theURL,winName,features);
		}


	function onTooltip(idx) {

	    //tooltip2.style.visibility= "visible";  // 툴팁 보이기
	    eval("tooltip"+idx).style.visibility= "visible";  // 툴팁 보이기
	}

	function offTooltip(idx) {
		eval("tooltip"+idx).style.visibility= "hidden";  // 툴팁 보이기


	}
	</script>
</head>

<body id="subBody" style="margin-bottom:0;padding-bottom:0;">
<form name="cartForm" method="post">
	<style type="text/css" >
		.contentBody h3 {padding-bottom:7px;}
		.tb_def th, .tb_def td {padding-top:3px;padding-bottom:3px;}
	</style>
<div class="subWrapper eap" style="margin-bottom:0;padding-bottom:0;">
	<div class="subHead" class="subHead" style="width:930px;" ><h2><spring:message code="LABEL.N.N01.0031" /><!-- CDP 현황 --></h2></div>
	<div class="contentBody" style="width:930px;">

		<!-- 탭 시작 -->

		<!-- 탭 끝 -->


		<h3><spring:message code="LABEL.N.N01.0031" /><!-- CDP 현황 --></h3>

			<!-- 테이블 시작 -->
			<div class="devHr_graphWrap">
				<!-- 첫번째 컬럼 제외한 전체 가로값 850px -->
<%
int topSize =26 ;
if(Utils.getSize(cdpVT) > 0 ){
	String tempNo = "0";
	String eqYear ="";
	//겹치는 년도가 있을 경우 처리한다.
	double mstartCell =0;


	HashMap<String, String> schinfo = new HashMap<String, String>();

	String YEAR = DataUtil.getCurrentYear();
	int sYEAR =  Integer.parseInt(YEAR.substring(2,4));


	if(!StringUtils.isBlank(HIRDT) && HIRDT.length() > 4 ){
		gapSize = Integer.parseInt(YEAR) - Integer.parseInt(HIRDT.substring(0,4));
		iHIRDT =Integer.parseInt(HIRDT.substring(2,4));
		totalYear = gapSize+iHIRDT;
		// // 28
		//  // 87

	}
	double onefillCell = (850/(Double.parseDouble(gapSize+"")+1));

	String beEndDate ="";
	//

	for(int k = 0 ; k < cdpVT.size() ; k++){
		schinfo = (HashMap)cdpVT.get(k);
		String NO              = schinfo.get("NO");
		String GUBUN_TX  = schinfo.get("GUBUN_TX");
		String STEXT      = schinfo.get("STEXT");
		String BEGYR      = schinfo.get("BEGYR");
		String ENDYR     = schinfo.get("ENDYR");
		String BEGDA = schinfo.get("BEGDA").substring(0,4);
		String sBeg = schinfo.get("BEGDA");

		String ENDDA = schinfo.get("ENDDA");
		//cell 한칸의 길이

		String nBEGDA = DataUtil.removeStructur(sBeg,"-");
		String nENDDA = DataUtil.removeStructur(ENDDA,"-");
		//
	 	//
		if(nENDDA.startsWith("0000")){
			nENDDA = DataUtil.getCurrentDate();
		}
		int nInterYear = DataUtil.getBetween(nBEGDA,nENDDA);
		//int nInterYear =  Integer.parseInt(nENDDA) - Integer.parseInt(nBEGDA);
		//
		double dInterYear = nInterYear/365.0;
		//
		double realInterYear = dInterYear * onefillCell;

		int ib = Integer.parseInt(BEGDA);
		int ie =0;

		if(ENDDA.startsWith("0000")){
			ie = Integer.parseInt(YEAR);
		}else{
			ie = Integer.parseInt(ENDDA.substring(0,4));
		}

		//	starCell 구하기
		int leftCell =79;
		if(gapSize%2 ==0){
			leftCell = 78;
		}
		double starCell  = (   (ib- Double.parseDouble(HIRDT.substring(0,4))) *onefillCell)+leftCell;
		int smonthCell = Integer.parseInt(sBeg.substring(5,7));
		double starCelladd = Double.parseDouble(smonthCell+".0")/12;
		double saddCell =onefillCell*starCelladd;
		starCell = starCell + saddCell;
		int splitCell = Integer.parseInt(ENDDA.substring(5,7));
		//여러건일 경우 처리 로직
		if(NO.equals(tempNo)  ){
			if(eqYear.startsWith(BEGDA)){
				int termMonth = smonthCell -Integer.parseInt(beEndDate);
				double tmonth = Double.parseDouble(termMonth+".0")/12*onefillCell;
				starCell = mstartCell + tmonth; //같은년도이면 1px  생성해 준다.
			}else{
				//
				//
				if(mstartCell  > starCell){
					double gap = mstartCell - starCell;
					starCell =starCell+( gap+0.5);
				}
			}
		}



		//ToolTip 위치는 NO 를 따른다.
		//사업가 후보부터 시작하지 않을 경우
		if(k == 0){
			if(!NO.equals("1")){
				topSize = -23;
			}
		}

		if(!NO.equals("")){
			if(!NO.equals("1")){
				if(!NO.equals(tempNo)  ){
//					중간에 없을수도 있다.
					int inb = Integer.parseInt(NO)  - Integer.parseInt(tempNo);

					if(inb == 1){
						topSize = topSize+53;
					}else if(inb == 2){
						//topSize = topSize +53;
						topSize = topSize +106;
					}else if(inb == 3){
						//topSize = topSize +106;
						topSize = topSize +159;
					}else if(inb == 4){
						//topSize = topSize +159;
						topSize = topSize +212;
					}
				}

			}
		}


		String Bcolor ="";



%>

		<a onMouseOver="onTooltip('<%=k %>')" onMouseOut="offTooltip('<%=k %>')">
		<div class="bar0<%=NO %>"   style="left:<%=starCell %>px;width:<%=realInterYear%>px;">
			<table>
				<tr>
					<td>
					</td>
				</tr>
			</table>
		</div>
		</a>

		<div id="tooltip<%=k %>" style="color:#747474;font-family:malgun gothic;font-size:11px; background:#ededed; border:solid 1px #cacaca; width:160px; height:34px;position:absolute; left:90px; top:<%=topSize+9 %>px; z-index:10; visibility:hidden;layer-background-color:rgb(1,97,152); ">
		<br>&nbsp;&nbsp <%=STEXT %> (<%=BEGYR %>~<%=ENDYR %>)<br>

		</div>
<%

			tempNo = NO;
			eqYear   = ie+"";
			mstartCell = starCell+realInterYear;
			beEndDate = splitCell+""; //전 년도의 종료일
			//minterCell = interYear;
	     }
	}
	%>
				<table class="tb_def fixed" summary="" >
					<caption></caption>
					<col width="79" /><col with="" />
<%
	//고정으로 돌리는 row수  6개
	for(int r=0; r < 6 ; r ++){
		if(r ==0){ // thead 구분
%>
					<thead>
						<tr>
							<th><spring:message code="LABEL.N.N01.0016" /><!-- 구분 --></th>
<%
			for (int i = iHIRDT ; i <= totalYear ; i ++){
				String stem = i+""; // 년도 표시
				if(stem.length() ==3){
					stem = stem.substring(1);
				}
%>
							<th><%=stem %></th>
<%
			}
%>
</tr>
</thead>
<%
		}else{   //tbody : 1이 아니면

			%>
				<%if(r ==1 ){%>
					<tbody>
				<%} %>
						<tr>
				<%
					//명칭
					String stext = "사업가 후보";

					if(r==2){
						stext = "사업 경험";
					}else if(r==3){
						stext = "수행 직무";
					}else if(r==4){
						stext = "수행 직책";
					}else if(r==5){
						stext = "해외 경험";
					}
				%>
							<td><%= stext%></td>
<%
			for (int i = iHIRDT ; i <= totalYear ; i ++){
%>
							<td></td>
<%} %>

						</tr>


				<%if(r ==5 ){%>
					<tbody>
				<%} %>
<%	}
	}
%>
				</table>
			</div>

	</div>

</div><!-- /subWrapper -->
</form>
</body>
</html>