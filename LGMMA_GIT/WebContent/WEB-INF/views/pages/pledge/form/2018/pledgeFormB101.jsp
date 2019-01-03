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
    				$("#agreeTD").html("<img src=\"/web-resource/images/sub/btn_yes.gif\" alt=\"서약완료\">");
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
		<div class="printTitle">정보보안서약서(2018년)</div>
		<div class="printNote">
			본인은 LG MMA(주) (이하 "회사"라 함)의 지적재산에 관한 권리 및 하기 "비밀정보"가<br>
			"회사"의 가장 중요한 자산에 속한다는 사실을 충분히 인식하고, 본인의 "회사" 입사/재직 중<br>
			"회사"의 경영에 있어 경쟁적 우위를 주는 정보를 개발, 취득하거나 그에 접근할 수 있음을 인식하는바,<br>
			본인은 "회사"에 근무/재직함에 있어 다음 사항을 준수할 것을 서약합니다.
			<br><br>
			(아래 임직원의 정보보안 서약서-원문보기를 통해 내용을 확인하여 주시기 바랍니다.)
		</div>
		<div class="numList">
			<p class="numTitle">■ 임직원의 정보보안 서약서 주요내용</p>
			<ul>
				<li>비밀의 유지</li>
				<li>장비 무단반입 금지</li>
				<li>정보자산의 적법한 사용</li>
				<li>적법한 유무선 통신행위</li>
				<li>경쟁금지 및 유도금지</li>
				<li>장비 무단반출 금지</li>
				<li>지적 재산의 양도 금지</li>
				<li>정보보안 주의의무 준수</li>
				<li>규정의 준수</li>
			</ul>
		</div>
		<div class="printNote">
			본인은 본 서약서를 주의를 다하여 읽었는 바, 본인에게 부과될 의무를 완전히 이해하였으며<br>
			자발적이고 자유로운 의사에 의하여 본 서약서에 서명하였음을 확인합니다.
			<br><br><br>
			<a href="/download/pledgeForm_new/pledgeFormB1.pdf" target="_blank" class="textLink">정보보안 서약(2018년) 원문보기</a>
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
						<img src="/web-resource/images/sub/btn_yes.gif" alt="서약완료">
						<% } else { %>
						<div class="buttonArea alignCenter">
							<ul class="btn_crud">
								<li><a href="#" id="agreefBtn"><span>서약</span></a></li>								
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