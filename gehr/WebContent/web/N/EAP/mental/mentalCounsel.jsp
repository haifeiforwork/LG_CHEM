<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import="java.util.*" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%



			HashMap<String, String> hMINFO = new HashMap<String, String>();
			HashMap<String, String> sMINFO = new HashMap<String, String>();
			Vector nurVT = new Vector();
			Vector strVT = new Vector();
			HashMap mhm= (HashMap)request.getAttribute("mentMailData");
			HashMap strhm= (HashMap)request.getAttribute("strData");


			int mhSize = 0 ;
			if(mhm != null){
				nurVT = (Vector)mhm.get("T_MINFO");

				mhSize = nurVT.size();


			}
			String recode = "";
			if(strhm != null){
				strVT = (Vector)strhm.get("MINFO");
				recode = (String)strhm.get("returnCode");
				sMINFO = (HashMap)strVT.get(0);

			}

%>

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
	<link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL  %>/css/ehr_wsg.css" />

    <script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js?v1"></script>
	<script type="text/javascript" src="<%= WebUtil.ImageURL %>js/jquery-latest.js"></script>    
	<script type="text/javascript">

		function rePopup(theURL,winName, width, height) {

		  var screenwidth = (screen.width-width)/2;
          var screenheight = (screen.height-height)/2;
		  winitem = 'height='+height+',width='+width+',top='+screenheight+',left='+screenwidth+',scrollbars=no,toolbar=no,location=no,directories=no,status=no,menubar=no';
		  var totsum= document.psyForm.totalSum.value;
		  window.open(theURL+"?totalSum="+totsum,winName,winitem);
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
		   document.psyForm.totalSum.value = totalSum;

		   document.getElementById("ResultDiv").innerHTML = "" + totalSum

		}

		function popupP(theURL,width, height, retURL) {

		   var screenwidth = (screen.width-width)/2;
           var screenheight = (screen.height-height)/2;

		  pop_window = window.open(theURL,"_newfin","width="+width+",height="+height+",toolbar=no,location=no,resizable=no,scrollbars=yes,top="+screenheight+",left="+screenwidth);
		  	pop_window.focus();
		}

	    function fnMove(divname){
	        var offset = $("#" + divname).offset();
	        $('html, body').animate({scrollTop : offset.top}, 400);
	    }

	</script>
</head>

<body id="subBody" class="eapSubBody" oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
<form name="psyForm" mothod="post">
<input type="hidden" name="totalSum" value="">
<div class="subWrapper eapSub">
	<div class="psyTop"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_sub_top.jpg" alt="EAP 서비스" /></div>
	<div class="psyTopMent"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_ment.jpg" alt="EAP 서비스 - 심리상담" /></div>
	<div class="psyLink">
		<a href="#" onclick="fnMove('locSec01');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_link_01.gif" alt="제공프로그램" /></a><a
			 href="#" onclick="fnMove('locSec02');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_link_02.gif" alt="사용방법" /></a><a
			 href="#" onclick="fnMove('locSec04');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_link_03.gif" alt="Green Letter" /></a><a
			 href="#" onclick="fnMove('locSec05');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_link_04.gif" alt="운영현황" /></a><a
			 href="#" onclick="fnMove('locSec06');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_link_05.gif" alt="심리상담 신청하기" /></a>
	</div>
	<div class="contentBody">


<div id="locSec01">
			<h3><a name="sec01"><img src="<%= WebUtil.ImageURL %>/ehr_common/psy_title_01.gif" alt="제공 프로그램" /></a></h3>
	
			<ul class="psySec01">
				<li class="item01"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_sec01_img_01.jpg" alt="심리검사" /></li>
				<li class="item02"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_sec01_img_02.jpg" alt="개인상담" /></li>
				<li class="item03"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_sec01_img_03.jpg" alt="팀상담" /></li>
			</ul>
				<div class="clear"></div>
</div>
		
			<div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>

<div id="locSec02">
			<h3><a name="sec02"><img src="<%= WebUtil.ImageURL %>/ehr_common/psy_title_02.gif" alt="심리상담 서비스를 효과적으로 사용하는 방법" /></a></h3>
			<p class="ment">
				개인에 따른 맞춤형 심리검사 및 상담 진행이가능합니다. 다양한 정서적상황에 따른 아래 예시를 참고하시기 바랍니다.
			</p>
			<ul class="psySec02">
				<li class="item01"></li>
				<li class="item02"></li>
				<li class="item03"></li>
				<li class="item04"></li>
			</ul>
</div>
		
		<div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>


<div id="locSec03">
			<h3><a name="sec03"><img src="<%= WebUtil.ImageURL %>/ehr_common/psy_title_03.gif" alt="심리검사" /></a></h3>
			<p class="ment">
				  간단한 스트레스 자가 진단 Tool을 통해 간략한 개인의 상태를 확인해보실 수 있습니다. 다만 간단한 자기 수준 이해를 위한 참고용 이오니, 심리상담실을 직접 방문하시면 보다 정확한 이해가 가능합니다.
			</p>
			<!-- 테이블 시작 -->
			<div class="table">
			<table class="listTable" >
				<caption></caption>
				<col  /><col width="80" /><col width="80" /><col width="80" /><col width="80" />
				<thead>
					<tr>
						<th>내용</th>
						<th>전혀<br />그렇지 않다</th>
						<th>약간<br />그렇다</th>
						<th>대체로<br />그렇다</th>
						<th class="lastCol">매우<br />그렇다</th>
					</tr>
				</thead>
				<tfoot>
					<tr class="sumRow">
						<td>총점</td>
						<td class="lastCol" colspan="4"><div id="ResultDiv"></div></td>
					</tr>
				</tfoot>
				<tbody>
					<tr class="oddRow">
						<td class="left">1. 쉽게 짜증이 나고 기분의 변동이 심하다.</td>
						<td><input type="radio" name="t1" value="1">1</td>
						<td><input type="radio" name="t1" value="2">2</td>
						<td><input type="radio" name="t1" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t1" value="4">4</td>
					</tr>
					<tr>
						<td class="left">2. 피부가 거칠고 각종 피부 질환이 심해졌다.</td>
						<td><input type="radio" name="t2" value="1">1</td>
						<td><input type="radio" name="t2" value="2">2</td>
						<td><input type="radio" name="t2" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t2" value="4">4</td>
					</tr>
					<tr class="oddRow">
						<td class="left">3. 온 몸의 근육이 긴장되고 여기저기 쑤신다.</td>
						<td><input type="radio" name="t3" value="1">1</td>
						<td><input type="radio" name="t3" value="2">2</td>
						<td><input type="radio" name="t3" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t3" value="4">4</td>
					</tr>
					<tr>
						<td class="left">4. 잠을 잘 못 들거나 깊은 잠을 못 자고 자주 잠에서 깬다.</td>
						<td><input type="radio" name="t4" value="1">1</td>
						<td><input type="radio" name="t4" value="2">2</td>
						<td><input type="radio" name="t4" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t4" value="4">4</td>
					</tr>
					<tr class="oddRow">
						<td class="left">5. 매사에 자신감이 없고 자기비하를 많이 한다.</td>
						<td><input type="radio" name="t5" value="1">1</td>
						<td><input type="radio" name="t5" value="2">2</td>
						<td><input type="radio" name="t5" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t5" value="4">4</td>
					</tr>
					<tr>
						<td class="left">6. 별다른 이유 없이 불안하고 초조하다.</td>
						<td><input type="radio" name="t6" value="1">1</td>
						<td><input type="radio" name="t6" value="2">2</td>
						<td><input type="radio" name="t6" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t6" value="4">4</td>
					</tr>
					<tr class="oddRow">
						<td class="left">7. 쉽게 피로감을 느낀다.</td>
						<td><input type="radio" name="t7" value="1">1</td>
						<td><input type="radio" name="t7" value="2">2</td>
						<td><input type="radio" name="t7" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t7" value="4">4</td>
					</tr>
					<tr>
						<td class="left">8. 매사에 집중이 잘 안 되고 일(학습)의 능률이 떨어진다.</td>
						<td><input type="radio" name="t8" value="1">1</td>
						<td><input type="radio" name="t8" value="2">2</td>
						<td><input type="radio" name="t8" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t8" value="4">4</td>
					</tr>
					<tr class="oddRow">
						<td class="left">9. 식욕이 없어 잘 안 먹거나 갑자기 폭식을 한다.</td>
						<td><input type="radio" name="t9" value="1">1</td>
						<td><input type="radio" name="t9" value="2">2</td>
						<td><input type="radio" name="t9" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t9" value="4">4</td>
					</tr>
					<tr>
						<td class="left">10. 기억력이 나빠져 잘 잊어버린다.</td>
						<td><input type="radio" name="t10" value="1">1</td>
						<td><input type="radio" name="t10" value="2">2</td>
						<td><input type="radio" name="t10" value="3">3</td>
						<td class="lastCol"><input type="radio" name="t10" value="4">4</td>
					</tr>
				</tbody>
			</table>
			</div>
			<!-- 테이블 끝 -->
</div>

		<div class="btnCenter">
			<a href="javascript:rePopup('<%=WebUtil.JspPath %>N/EAP/mental/mentalCounsel_result.jsp','pop1','815','400')"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_viewresult.gif" alt="검사 결과보기" /></a>
		</div>
		<div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>
<%
String returnUrl = WebUtil.JspURL+"N/EAP/mental/greenLetter_list.jsp";
%>

<div id="locSec04">
		<h3><a name="sec04"><img src="<%= WebUtil.ImageURL %>/ehr_common/psy_title_04.gif" alt="Green Letter" /></a></h3>
		<div class="psySec04"><a href="javascript:popupP('<%=WebUtil.ServletURL %>hris.N.common.CommonFAQListSV?I_CODE=0002&I_PFLAG=X&returnUrl=<%=returnUrl %>','850','680')">
			<img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_grnletter.gif" alt="그린레터 바로가기"  class="btn" /></a></div>
		<div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>
</div>

<div id="locSec05">
			<h3><a name="sec05"><img src="<%= WebUtil.ImageURL %>/ehr_common/psy_title_05.gif" alt="심리 상담실 운영 현황" /></a></h3>
			<div class="psySec05">
			<%
			if(mhm != null){
					for(int i = 0 ; i < mhSize ; i ++){
						hMINFO = (HashMap)nurVT.get(i);
			%>
				<ul <%if(i ==3){%>class="last" <%} %>>
					<li class="pic"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_sec05_pic_0<%=(i+1) %>.jpg" /></li>
					<li class="loc"><%= hMINFO.get("GRUP_NAME")%></li>
					<li class="name"><%= hMINFO.get("ENAME")%> 상담사</li>
					<li class="tel"><%= hMINFO.get("TELNO")%></li>
					<li class="email"><a href="mailto:<%= hMINFO.get("EMAIL").toLowerCase()%>"><%= hMINFO.get("EMAIL").toLowerCase()%></a></li>
				</ul>
	
							<%
					}
			}
				%>
				<div class="clear"></div>
			</div>
</div>		

<div id="locSec06">	
		<div class="btnCenter">
			<%
				if(recode.equals("S")){
			%>
				<a href="<%=WebUtil.JspPath %>N/EAP/mental/mentalCounsel_apply.jsp?RECEIVER=<%= sMINFO.get("EMAIL").toLowerCase()%>" name="sec06"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_psy_btn_apply.gif" alt="심리상담 신청하기" /></a>
			<%
			    }
			%>
		</div>
		<div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>
	<div style="height:300px;"></div>
	</div>
</div>

</div><!-- /subWrapper -->
</form>
</body>
</html>
<%@ include file="/web/N/common/responseMsg.jsp" %>