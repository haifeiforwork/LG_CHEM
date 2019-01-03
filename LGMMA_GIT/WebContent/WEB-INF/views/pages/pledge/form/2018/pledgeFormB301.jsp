<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="hris.common.*"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<% 
	PledgeDetailData data = (PledgeDetailData)request.getAttribute("data");
	WebUserData user   = (WebUserData)session.getValue("user");
%>
<html>
<head>
<title>LG MMA</title>
<!-- basic -->
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_jquery.css" />
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-1.9.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-ui-1.10.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/common.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$("#agreefBtn").click(function(){
		jQuery.ajax({
    		type : "POST",
    		url : "/pledge/agreeRequest.json",
    		cache : false,
    		dataType : "json",
    		data : {"ATYPE" : "<%=data.ATYPE%>"
    				,"ZYEAR" :"<%=data.ZYEAR%>"
    				,"ZSEQ" : "<%=data.ZSEQ%>" },
    		async :false,
    		success : function(response) {
    			if(response.success){
    				if(response.mssg!="") alert(response.mssg);
    				$("#agreeTD").html("");
    				$("#agreeTD").html("<img src=\"/web-resource/images/sub/btn_ok.gif\" alt=\"동의완료\">");
    			}
    			else{
    				alert(response.message);
    			}
    		}
		});
		
	});
	
});

</script>
</head>
<body>
<div class="printCenter">
	<div class="printForm">
		<div class="printTitle">개인정보제공동의서(2018년 개정)</div>
		<div class="printNote">
			LG MMA(이하 “회사”라 함)는 『개인정보 보호법』 등 관련 법규에 규정된 내용에 의거하여,<br>
			임직원 본인의 동의를 통한 개인정보 수집 · 이용 및 이를 제3자에게 제공하고자 합니다. <br>
			아래 임직원의 개인정보 수집 · 이용 및 제3자 제공 동의서-원문보기를 통해 내용을 확인하여 주시기 바랍니다. 
			<br><br>
			수집하는 개인정보는 회사의 사내 각종 전산 프로그램의 사용 권한 부여 및 보안통제, 근로관계 설정·유지·이행 및<br>
			관리, 그 외 법령, 정부기관, 법원 등의 요청 또는 명령 준수를 위한 필수항목으로써 업무처리 외 용도로는<br>
			절대 이용 · 제공되지 않으며, 회사 내부 규정 및 지침에 따라 안전한 방법으로 저장 관리하고 있습니다.<br>
			임직원은 정보주체로서 개인정보의 삭제 · 처리정지 요구와 개인정보의 수집 · 이용 및 제공에 대한 동의<br>
			거부를 할 수 있으나, 이 경우 회사의 관련 업무수행이 불가합니다.
		</div>
		<div class="numberList">
			<p class="numberTitle">■ 개인정보 수집 및 이용 안내</p>
			<ul>
				<li>가. 위 사항과 관련하여 귀하의 개인정보 수집 · 이용 및 제3자 제공에 동의하십니까?</li>
			</ul>
		</div>
		<div class="numberList">
			<p class="numberTitle">■ 고유식별정보의 수집 및 이용 안내</p>
			<ul>
				<li>나. 위 사항과 관련하여 귀하의 고유식별정보 수집 · 이용 및 제3자 제공에 동의하십니까?</li>
			</ul>
		</div>
		<div class="numberList">
			<p class="numberTitle">■ 민감정보의 수집 및 이용 안내  </p>
			<ul>
				<li> 다. 위 사항과 관련하여 귀하의 민감정보 수집 · 이용 및 제3자 제공에 동의하십니까? </li>
			</ul>
		</div>
		<div class="printNote">
			본인은 본 동의서를 주의를 다하여 읽었는바, 본인은 정보주체로서 상기 사항의 개인정보 수집 · 이용 및<br>
			제3자 제공 동의에 대한 내용을 완전히 이해하였으며 자발적이고 자유로운 의사에 의하여 본 동의서에 동의하여<br>
			서명하였음을 확인합니다.
			<br><br><br>
			<a href="/download/pledgeForm_new/pledgeFormB3_new.pdf" target="_blank" class="textLink">개인정보제공동의서(2018년 개정) 원문보기</a>
		</div>
		<div class="printDate">
		<% if(data.AGR_YN.equals("동의")){%>
		<%=DataUtil.setKorDate(data.AGR_DATE) %>
		<% } else { %>
		<%=DataUtil.setKorDate(	DataUtil.getCurrentDate())%>			
		<% } %>
		</div>
		<div class="signTBWrap">
			<table class="signTB">
				<tr>
					<td width="200"><strong>LG MMA 귀중</strong></td>
					<td>
						<strong>소&nbsp;&nbsp;&nbsp;&nbsp;속</strong> : <%=data.ORGTX %><br>
						<strong>사&nbsp;&nbsp;&nbsp;&nbsp;번</strong> : <%=user.empNo %><br>
						<strong>성&nbsp;&nbsp;&nbsp;&nbsp;명</strong> : <%=data.ENAME %>
					</td>
					<td width="80" align="center" id="agreeTD">
						<% if(data.AGR_YN.equals("동의")){%>
						<img src="/web-resource/images/sub/btn_ok.gif" alt="동의완료">
						<% } else { %>
						<div class="buttonArea alignCenter">
							<ul class="btn_crud">
								<li><a href="#" id="agreefBtn"><span>동의</span></a></li>								
							</ul>
						</div>
						<% } %>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</body>
</html>