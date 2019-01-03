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
		<div class="printTitle">개인정보보호 서약서(개인정보 취급자용_2018년)</div>
		<div class="printNote">
			개인정보보호 서약서(개인정보 취급자용)  
			<br><br>
			본인은 LG MMA(이하 회사 라 함)의 업무 목적 상 고객(이하  정보주체 라 함)의 개인정보를 취급/운영/관리를 함에 있어 아래의 사항을 준수할 것을 서약합니다.
		</div>
		<div class="numList">
			<ul>
				<li>본인은 회사의 회사 업무 처리를 목적으로 개인정보에 대한 접근권한을 가지고 개인정보를 수집/저장/이용/보관/제공/파기(이하 취급 이라 함) 하는 등의 실무</li>
				<li>본인은 업무 수행을 위해 필요한 최소한의 개인정보만을 수집할 것이며, 수집된 개인정보는 정보주체의 정보제공 목적에 한해서만 이용할 것이며 개인정보 취급업무는 반드시 전사 정보보안지침을 준수할 것임을 서약합니다. </li>
				<li>본인은 업무 수행을 위해 부득이하게 개인정보를 취급 위탁을 주거나 제3자에게 제공할 경우 전사 정보보안규정 및 전사 개인정보보호규칙에서 정의한 제반 정책과 절차를 준수할 것이며 해당 위탁업체 및 제3자에 대한 관리,감독을 철저히 하여 이로 인한 개인정보유출 또는 침해사고가 발생되지 않도록 노력할 것임을 서약합니다.   </li>
				<li>본인은 개인정보에 대해 관련 법에서 정의한 정보주체의 권리를 최대한 보장하고 고객의 요구나 Claim에 대해 지체 없이 적절한 조치를 취할 것임을 서약합니다.  </li>
				<li>본인은 회사에 근무 재직하는 동안 취득하거나 직무상 알게 되는 개인정보를 침해, 유출 또는 훼손·누설하지 않으며, 이를 정보주체가 동의한 제공 목적 이외의 다른 목적이나 기타 부정한 목적으로 사용하지 않을 것을 서약합니다.  </li>
				<li>본인은 퇴직 후에도 위의 사항을 준수할 것을 약속합니다.  </li>
				<li>본인이 본 서약을 위반하였을 경우, 본인은 사규에 따른 징계, 개인정보보호법, 정보통신망 이용 촉진에 관한 법률 및 기타 관계 법령에 따라 귀사에 대하여 손해배상 책임을 포함한 민·형사상의 모든 책임을 질 것을 서약합니다.</li>
			</ul>
		</div>
		<div class="printNote">
			본인은 본 서약서를 주의를 다하여 읽었는 바, 본인에게 부과될 의무를 완전히 이해하였으며<br>
			자발적이고 자유로운 의사에 의하여 본 서약서에 서명하였음을 확인합니다.
			<br><br><br>
			<a href="/download/pledgeForm_new/pledgeFormB2.pdf" target="_blank" class="textLink">개인정보보호 서약서(2018년) 원문보기</a>
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