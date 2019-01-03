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
		<div class="printTitle">유연근무제 및 보상휴가 근로자 동의서</div>
		<div class="printNote">
			본인은 2018년 11월 1일자로 근로기준법에 규정된 <br>유연근무제(제51조, 제52조, 제58조) 및 보상휴가제(제57조)를 도입/시행함에 동의한다. <br>
			
			<br>
			또한, 근로기준법 조항의 요건에 따른 근로자 대표와의 서면 합의 및 취업규칙 개정관련하여 <br>본인이 소속된 사원협의체 대표가 사무기술직 근로자 대표로서 본인을 대리하며, 추인하는 것에 동의한다.<br>
		</div>
		<div class="printNote">

			<img src="/web-resource/images/sub/worktime_content.gif" alt="내용" style="width: 700; height: 370">

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