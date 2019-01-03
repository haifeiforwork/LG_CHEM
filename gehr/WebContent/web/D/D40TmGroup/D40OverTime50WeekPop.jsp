<%--
/********************************************************************************/
/*																				*/
/*   System Name	:  MSS														*/
/*   1Depth Name	:   부서근태													*/
/*   2Depth Name	:   초과근무													*/
/*   Program Name	:   주50시간 초과 근무자 경고 팝업								*/
/*   Program ID		: D40OverTime50WeekPop.jsp									*/
/*   Description	: 주50시간 초과 근무자 경고 팝업								*/
/*   Note			:             												*/
/*   Creation		: 2018-06-18  성환희 [Worktime52]                            */
/*   Update			:                                           				*/
/*                                                                             	*/
/********************************************************************************/
--%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<jsp:include page="/include/header.jsp" />

<script language="JavaScript">

	$(function() {
		var data = window.opener.ovtime50Data;
		var bodyContents = [];
		for(var i = 0; i < data.length; i++) {
			if(i % 2 == 0) bodyContents.push("<tr class=\"oddRow\">");
			else bodyContents.push("<tr>");

			bodyContents.push("<td>" + data[i].PERNR + "</td>");
			bodyContents.push("<td>" + data[i].ENAME + "</td>");
			bodyContents.push("<td>" + data[i].BEGDA + " ~ " + data[i].ENDDA + "</td>");
			bodyContents.push("<td>" + data[i].WWKTM + "</td>");
			bodyContents.push("</tr>");
		}
		
		$('#listData').html(bodyContents.join(''));
	});

</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
	<div class="winPop">
	
		<div class="header">
	    	<span><spring:message code="LABEL.D.D12.0086"/><%--주간 실근무시간 50시간 초과자--%></span>
	    	<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
	    </div>
	
		<div class="body">
			<h2 class="subtitle"><spring:message code='LABEL.D.D12.0087' /><!-- 주 50시간 초과 근무자입니다. 법정한도 초과시 입력불가하오니 기준 준수될 수 있도록 관리 바랍니다. --></h2>
			
			<div class="tableArea" >
    			<div class="table">
      				<table class="listTable">
						<colgroup>
							<col width="15%" />
							<col width="15%" />
							<col width="35%" />
							<col />
						</colgroup>
						<thead>
							<th><spring:message code="LABEL.D.D12.0017"/><!-- 사번 --></th>
							<th><spring:message code="LABEL.D.D12.0018"/><!-- 이름 --></th>
							<th><spring:message code="LABEL.D.D12.0088"/><!-- 주간 --></th>
							<th><spring:message code="LABEL.D.D12.0089"/><!-- 주간 실근무시간 --></th>
						</thead>
						<tbody id="listData">
						</tbody>
					</table>
				</div>
			</div>
	
			<div class="clear"></div>
		  	<div class="buttonArea" style="padding-right: 40px;">
		  		<ul class="btn_crud">
		  			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
		  		</ul>
		  	</div>
		</div>
	
	
	
	</div>
</body>

<jsp:include page="/include/footer.jsp"/>