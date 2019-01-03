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
		<div class="printTitle">정도경영 실천 서약서</div>
		<div class="printNote">
			본인은 직무를 수행함에 있어 고객에게는 정직하고,<br>
			협력업체에 대해서는 공정한 거래를 통한 상호발전을 추구하며,<br>
			경쟁사와는 정정당당하게 경쟁하여 주주와 사회에 책임과 의무를 다하기 위하여<br>
			다음 사항을 준수할 것을 서약합니다.
		</div>
		<div class="numList">
			<ul>
				<li>업무를 수행함에 있어서 LG윤리규범을 준수하여 어떠한 불공정 거래 및 부정ㆍ비리 행위도 하지 않겠습니다.</li>
				<li>업무 수행과정에서 회사 임직원의 불공정 거래 및 부정ㆍ비리행위를 인지하였을 경우나, 거래선으로부터 부정ㆍ비리행위의 제안을 받았을 경우에는 즉시 (경영진단팀)에 알리겠습니다.</li>
				<li>LG윤리규범을 위배하는 불공정 거래 및 부정ㆍ비리 행위여부에 대한 정기 및 수시 조사가 진행될 경우, 회사가 요청하는 관련자료 (불공정 거래 및 부정ㆍ비리 행위를 조사하는데 필요한 서류)의 제출 등 모든 협조를 다하겠습니다.</li>
				<li>만약 이 서약서를 위반할 경우 이에 따르는 모든 책임을 감수하겠습니다.</li>
			</ul>
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
						<!-- <img src="../web-resource/images/sub/btn_yes.gif" alt="서약완료"> -->
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</body>
</html>