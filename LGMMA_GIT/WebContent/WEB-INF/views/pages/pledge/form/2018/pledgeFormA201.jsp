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
		<div class="printTitle">부패방지 법규 준수 서약서</div>
		<div class="printNote">
			본인은 직무를 수행함에 있어 평등한 참여 기회 속에 자유 경쟁의 원칙에 따른 투명하고 공정한 거래를 이념으로 하는 자사의 경영원칙을 추구하고, ‘부정청탁 및 금품 등 수수의 금지에 관한 법률’과 ‘국제상거래에 있어서 외국공무원에 대한 뇌물방지법’을 비롯한 국내외 부패방지 관련 제반 법규를 준수할 것을 서약합니다.
		</div>
		<div class="numList">
			<ul>
				<li>국내 및 국제 상거래 활동 시 부패방지에 관한 회사의 정책을 따른다.</li>
				<li>국내외 반부패 법규 및 자사의 부패방지를 위한 실천지침 등을 숙지하며, 이에 따라 국내외 공직자 등에게 부정한 청탁을 하거나, 뇌물 또는 기타 수수금지 금품 등을 약속, 공여 또는 공여의 의사표시를 하지 않는다.</li>
				<li>반부패 법규 및 자사의 실천지침 등과 관련하여, 국내외 협력회사 및 에이전트 등 제3자에 의한 부정청탁 또는 뇌물 공여 등 행위를 방지하는 데에 선량한 주의 감독 의무를 다한다.</li>
				<li>반부패 법규 및 자사의 실천지침 등에 위배되는 행위로 인해 회사에 피해가 발생할 수 있음을 인식하고, 향후 본인이 제반 법규를 위반하는 경우 이에 대해서 회사가 징계 등의 불이익 조치를 취할 수 있음을 이해한다.</li>
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
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</body>
</html>