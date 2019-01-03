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
		본인은 직무를 수행함에 있어 다음 사항을 준수할 것을 서약합니다.

		</div>
		<div class="numList">
			<ul>
				<li>
				구성원을 존중하고, 공정거래를 통해 협력업체와 상호 발전하며, 경쟁사와 정정당당한 경쟁을 통해 고객에게 최고의 가치를 정직하게 제공하고, 
				주주와 사회에 대한 책임과 의무를 다하겠습니다.
			    </li>
				<li>
				LG의 임직원으로서 조직 내 정도경영 문화를 정착시키고 실천하기 위한 책임과 의무를 다하겠습니다.
			    </li>
				<li>
				업무를 수행함에 있어 규정을 몰랐다는 이유로 면책되지 않음을 이해하고, LG윤리규범을 포함한 사내 규정을 숙지하고 공정거래법 등 Compliance 관련 의무사항을 준수하며  
				이를 위반하는 어떠한 부당한 행위도 하지 않겠습니다.
			    </li>
				<li>
				업무수행과정에서 회사 임직원의 불공정 거래 및 부정 · 비리 행위를 인지하였을 경우나, 거래처로부터 부정 · 비리 행위를 제안 받는 경우 즉시 회사(경영진단팀)에 알리겠습니다. 
			    </li>
				<li>
				LG 윤리규범 위반 행위 또는 Compliance 위반 행위에 대한 정기 및 수시 조사 진행 시, 회사가 요청하는 관련자료(서류 및 E-Mail, 회사PC와 VDI 에 저장된 파일 등 전자기록 포함)를 제출하고, 
				동 자료를 회사가 검토 및 이용하는 것에 동의하며 모든 협조의무를 반드시 준수하겠습니다.
			    </li>
				<li>
				만약 이 서약서를 위반할 경우 이에 따르는 모든 책임을 감수하겠습니다.
			    </li>
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