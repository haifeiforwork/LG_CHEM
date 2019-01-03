<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import="java.util.*" %>

<%

			
			//{MINFO=[{GRUP_NAME=서울본사, PERNR=00205452, TELNO=261-7001, EMAIL=MARCO@LGCHEM.COM, ENAME=고아라}]}
			HashMap<String, String> hMINFO = new HashMap<String, String>();
			HashMap mhm= (HashMap)request.getAttribute("mentMailData");
			
			if(mhm != null){
				Vector menVT = (Vector)mhm.get("MINFO");
				hMINFO = (HashMap)menVT.get(0);
			}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
	
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!--[if lt IE 9]> 
	<script src="http://getbootstrap.com/2.3.2/assets/js/html5shiv.js"></script>
	<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js">IE7_PNG_SUFFIX=".png";</script> 
	<![endif]--> 
	<title>LG화학 e-HR 시스템</title>
	<meta name="description" content="LG화학 e-HR 시스템" />
	<link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL  %>/css/ehr_style.css" />
	
	<script type="text/javascript">

		function rePopup(theURL,winName) { 
		
		 var feature = "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=815	,height=400";
		  window.open(theURL,winName,feature);
		}	
		
		var queCount = 10;
		
		window.onload = function(){    radioCheck(queCount); } 
		
		
		function radioCheck(queCnt){ 
		   var totalSum = 0; 
		   for(var q = 1; q <= queCnt; q++ ){ 
		      var ansCnt = document.getElementsByName("t"+q).length 
		      var checkValue = 0; 
		      for(var a = 0 ; a < document.getElementsByName("t"+q).length ; a++ ){ 
		         if( document.getElementsByName("t"+q)[a].checked == true){ 
		            checkValue = document.getElementsByName("t"+q)[a].value; 
		            totalSum += Number(checkValue); 
		         } 
		         document.getElementsByName("t"+q)[a].onclick = function(){radioCheck(queCnt)}; 
		      } 
		   } 
		  
		   document.getElementById("ResultDiv").innerHTML = "" + totalSum 
		} 
		
	</script>
</head>

<body id="subBody">  
<form name="psyForm" mothod="post">
<input type="hidden" name ="RECEIVER" value="<%= hMINFO.get("EMAIL")%>">
<div class="subWrapper eap"> 
	<div class="subHead"><h2>심리 상담</h2></div>
	<div class="contentBody">
		<h3>스트레스 자가 진단</h3>
		<div class="tMent">
			스트레스는 질병이나 성격적인 특성이 아니며, 현재 나의 몸과 마음의 기능 수준이 어느 정도인지 알아보기 위한 검사로서 참고용으로만 사용하시기 바랍니다.
		</div>
		
		<!-- 테이블 시작 -->
		<table class="tb_def fixed" summary="" >
			<caption></caption>
			<col  /><col width="80" /><col width="80" /><col width="80" /><col width="80" />
			<thead>
				<tr>
					<th>내용</th>
					<th>전혀<br />그렇지 않다</th>
					<th>약간<br />그렇다</th>
					<th>대체로<br />그렇다</th>
					<th>매우<br />그렇다</th>
				</tr>
			</thead>
			<tfoot>
				<td>총점</td>
				
				<td colspan="4"><div id="ResultDiv"></div></td>
			</tfoot>
			<tbody>
				<tr>
					<td class="left">1. 쉽게 짜증이 나고 기분의 변동이 심하다.</td> 
					<td><input type="radio" name="t1" value="1">1</td> 
					<td><input type="radio" name="t1" value="2">2</td> 
					<td><input type="radio" name="t1" value="3">3</td> 
					<td><input type="radio" name="t1" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">2. 피부가 거칠고 각종 피부 질환이 심해졌다.</td> 
					<td><input type="radio" name="t2" value="1">1</td> 
					<td><input type="radio" name="t2" value="2">2</td> 
					<td><input type="radio" name="t2" value="3">3</td> 
					<td><input type="radio" name="t2" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">3. 온 몸의 근육이 긴장되고 여기저기 쑤신다.</td> 
					<td><input type="radio" name="t3" value="1">1</td> 
					<td><input type="radio" name="t3" value="2">2</td> 
					<td><input type="radio" name="t3" value="3">3</td> 
					<td><input type="radio" name="t3" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">4. 잠을 잘 못 들거나 깊은 잠을 못 자고 자주 잠에서 깬다.</td> 
					<td><input type="radio" name="t4" value="1">1</td> 
					<td><input type="radio" name="t4" value="2">2</td> 
					<td><input type="radio" name="t4" value="3">3</td> 
					<td><input type="radio" name="t4" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">5. 매사에 자신감이 없고 자기비하를 많이 한다.</td> 
					<td><input type="radio" name="t5" value="1">1</td> 
					<td><input type="radio" name="t5" value="2">2</td> 
					<td><input type="radio" name="t5" value="3">3</td> 
					<td><input type="radio" name="t5" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">6. 별다른 이유 없이 불안하고 초조하다.</td> 
					<td><input type="radio" name="t6" value="1">1</td> 
					<td><input type="radio" name="t6" value="2">2</td> 
					<td><input type="radio" name="t6" value="3">3</td> 
					<td><input type="radio" name="t6" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">7. 쉽게 피로감을 느낀다.</td> 
					<td><input type="radio" name="t7" value="1">1</td> 
					<td><input type="radio" name="t7" value="2">2</td> 
					<td><input type="radio" name="t7" value="3">3</td> 
					<td><input type="radio" name="t7" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">8. 매사에 집중이 잘 안 되고 일(학습)의 능률이 떨어진다.</td> 
					<td><input type="radio" name="t8" value="1">1</td> 
					<td><input type="radio" name="t8" value="2">2</td> 
					<td><input type="radio" name="t8" value="3">3</td> 
					<td><input type="radio" name="t8" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">9. 식욕이 없어 잘 안 먹거나 갑자기 폭식을 한다.</td> 
					<td><input type="radio" name="t9" value="1">1</td> 
					<td><input type="radio" name="t9" value="2">2</td> 
					<td><input type="radio" name="t9" value="3">3</td> 
					<td><input type="radio" name="t9" value="4">4</td> 
				</tr> 
				<tr>
					<td class="left">10. 기억력이 나빠져 잘 잊어버린다.</td> 
					<td><input type="radio" name="t10" value="1">1</td> 
					<td><input type="radio" name="t10" value="2">2</td> 
					<td><input type="radio" name="t10" value="3">3</td> 
					<td><input type="radio" name="t10" value="4">4</td> 
				</tr>  
			</tbody>
		</table>
		<!-- 테이블 끝 -->		 
		
		<div class="btnCenter">
		
		<%	
			if(mhm != null){
		%>
			<a href="<%=WebUtil.JspPath %>N/EAP/mental/mentalCounsel_apply.jsp?RECEIVER=<%= hMINFO.get("EMAIL")%>" class="btn"><span class="btnDef">심리상담 신청하기</span><span class="btnDef_tail">&nbsp;</span></a>
		<%
		    }
		%>
			<a href="javascript:rePopup('<%=WebUtil.JspPath %>N/EAP/mental/mentalCounsel_result.jsp','pop1')" class="btn"><span class="btnDef">검사결과보기</span><span class="btnDef_tail">&nbsp;</span></a>
		</div> 
		 
		
		<h3>전사 심리상담실 현황</h3>
		
		<!-- 테이블 시작 -->
		<table class="tb_def fixed" summary="" >
			<caption></caption>
			<col width="200" /><col width="90" /><col width="160" /><col />
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