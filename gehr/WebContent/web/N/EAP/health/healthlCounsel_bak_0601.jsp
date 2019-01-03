<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import="java.util.*" %>
<%
			//{MINFO=[{GRUP_NAME=서울본사, PERNR=00205452, TELNO=261-7001, EMAIL=MARCO@LGCHEM.COM, ENAME=고아라}]}
			HashMap<String, String> hMINFO = new HashMap<String, String>();
			HashMap mhm= (HashMap)request.getAttribute("healMailData");
			
			if(mhm != null){
				Vector menVT = (Vector)mhm.get("MINFO");
				hMINFO = (HashMap)menVT.get(0);
			}
%>

<html>
	
<head>
	
	<!--[if lt IE 9]> 
	<script src="http://getbootstrap.com/2.3.2/assets/js/html5shiv.js"></script>
	<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js">IE7_PNG_SUFFIX=".png";</script> 
	<![endif]--> 
	<title>LG화학 e-HR 시스템</title>
	<meta name="description" content="LG화학 e-HR 시스템" />
	<link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL %>/css/ehr_style.css" />
	
	<script type="text/javascript">
		
		function popup(theURL,winName,features) { 
		  window.open(theURL,winName,features);
		}	
	</script>
</head>

<body id="subBody">  
<form name="healForm" method="post">
<input type="hidden" name ="RECEIVER" value="<%= hMINFO.get("EMAIL")%>">
<div class="subWrapper eap"> 
	<div class="subHead"><h2>4대질환 기준지표</h2></div>
	<div class="contentBody">
		<h3>스트레스 자가 진단</h3>
		<div class="tMent">
			스트레스는 질병이나 성격적인 특성이 아니며, 현재 나의 몸과 마음의 기능 수준이 어느 정도인지 알아보기 위한 검사로서 참고용으로만 사용하시기 바랍니다.
		</div>
		
		<!-- 테이블 시작 -->
		<table class="tb_def fixed" summary="" >
			<caption></caption>
			<col width="20%" /><col width="20%" /><col width="20%" /><col width="20%" /><col width="20%" />
			<thead>
				<tr>
					<th colspan="2" rowspan="2">구분</th>
					<th rowspan="2">정상</th>
					<th colspan="2">유소견자</th>
				</tr>
				<tr>
					<th>주의자</th>
					<th>질환자</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="2">고혈압</td> 
					<td>120/80 이하</td> 
					<td class="colorStr">140/90 이상</td> 
					<td><span class="strTxt b">160/110이상</span></td> 
				</tr> 
				<tr>
					<td rowspan="3">간장질환</td> 
					<td>GOT</td> 
					<td>40 이하</td> 
					<td class="colorStr">51 이상</td> 
					<td><span class="strTxt b">100이상</span></td> 
				</tr> 
				<tr>
					<td>GPT</td> 
					<td>35 이하</td> 
					<td class="colorStr">46 이상</td> 
					<td><span class="strTxt b">100이상</span></td> 
				</tr>
				<tr>
					<td>V-GTP</td> 
					<td>63 이하</td> 
					<td class="colorStr">78 이상</td> 
					<td><span class="strTxt b">200이상</span></td> 
				</tr>
				<tr>
					<td rowspan="4">고지혈증</td> 
					<td>총콜레스테롤</td> 
					<td>200 이하</td> 
					<td class="colorStr">240 이상</td> 
					<td><span class="strTxt b">300이상</span></td> 
				</tr> 
				<tr>
					<td>중성지방</td> 
					<td>150 이하</td> 
					<td class="colorStr">200 이상</td> 
					<td><span class="strTxt b">500이상</span></td> 
				</tr>
				<tr>
					<td>저밀도</td> 
					<td>130 이하</td> 
					<td class="colorStr">200 이상</td> 
					<td><span class="strTxt b">190 이상</span></td> 
				</tr>
				<tr>
					<td>고밀도</td> 
					<td>60 이상</td> 
					<td class="colorStr">40 이상</td> 
					<td><span class="strTxt b">30 미만</span></td> 
				</tr>
				<tr>
					<td>당뇨</td> 
					<td>혈당</td> 
					<td>110 이하</td> 
					<td class="colorStr">120 이상</td> 
					<td><span class="strTxt b">200 이상</span></td> 
				</tr>
			</tbody>
		</table>
		<!-- 테이블 끝 -->		 


<%
			 
		if(mhm != null){				%>		
		<div class="btnCenter">
		
			<a href="<%=WebUtil.JspPath %>N/EAP/health/health_apply.jsp?RECEIVER=<%= hMINFO.get("EMAIL")%>" class="btn"><span class="btnDef">건강상담 신청하기</span><span class="btnDef_tail">&nbsp;</span></a>
		</div> 
		 <%} %>
		<h3>전사 보건관리자 현황</h3>
		
		<!-- 테이블 시작 -->
		<table class="tb_def fixed" summary="" >
			<caption></caption>
			<col width="200" /><col width="150" /><col width="200" /><col />
			<thead>
				<tr>
					<th>사업장</th>
					<th>상담사</th>
					<th>연락처</th>
					<th>이메일</th>
				</tr>
			</thead>

			<tbody>
			<%if(mhm != null){
				%>
				<tr>
					<td ><%= hMINFO.get("GRUP_NAME")%></td> 
					<td><%= hMINFO.get("ENAME")%></td> 
					<td><%= hMINFO.get("TELNO")%></td> 
					<td class="left"><a href="mailto:<%= hMINFO.get("EMAIL")%>"><%= hMINFO.get("EMAIL")%></a></td> 
				</tr> 
				<%
				
			}else{ %>
				<tr>
					<td colspan="4">데이터가 없습니다.</td> 
					
				</tr> 
			<%} %>
			</tbody>
		</table>
		<!-- 테이블 끝 -->		
		 
		
		
	</div>
</div><!-- /subWrapper -->
</form>
</body>
</html>
<%@ include file="/web/N/common/responseMsg.jsp" %>