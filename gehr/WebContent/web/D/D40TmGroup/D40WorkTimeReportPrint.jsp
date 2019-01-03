<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 부서근태
/*   Program Name : 실근무 실적현황
/*   Program ID   : D40WorkTimeReportPrint.jsp
/*   Description  : 실근무 실적현황 레포트 출력 화면
/*   Note         : 
/*   Creation     : 2018-06-04 성환희 [WorkTime52]
/*   Update       : 
/******************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/include/header.jsp" />

<style type="text/css">
P.breakhere {
	page-break-before: always
}
</style>

<SCRIPT type="text/javascript">
<!--
function prevDetail() {
	switch (location.hash)  {
		case "#page2":
			location.hash ="#page1";
		break;
	} // end switch
}

function nextDetail() {
	switch (location.hash)  {
		case "":
		case "#page1":
			location.hash ="#page2";
		break;
	} // end switch
}

function click() {
    if (event.button==2) {
      //alert('마우스 오른쪽 버튼은 사용할수 없습니다.');
      //alert('오른쪽 버튼은 사용할수 없습니다.');
      alert('<%=g.getMessage("MSG.F.F41.0006")%>');

   return false;
    }
  }

 function keypressed() {
      //alert('키를 사용할 수 없습니다.');
       return false;
  }

  document.onmousedown=click;
  document.onkeydown=keypressed;

//-->
</SCRIPT>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

	<form name="form1" method="post" onsubmit="return false">
		<div class="winPop">
			<div class="header">
				<span>
					<spring:message code='LABEL.D.D25.0042' /><!-- 실근무 실적현황 -->
				</span> 
				<a href="" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
			</div>
		</div>
		<div class="subWrapper iframeWrap wideTable" style="height:550px; overflow:auto">
			<div class="body" class="iframeWrap">
				
				<h2 class="subtitle"><spring:message code='LABEL.D.D25.0057' /><!-- 실근무시간 = 정상근무 + 초과근무/교육 - 휴게/비근무 --></h2>
				<c:choose>
					<c:when test="${SEARCH_GUBUN eq 'M'}">
						<c:choose>
							<c:when test="${DISPLAY_MONTH eq '01' || DISPLAY_MONTH eq '02' || DISPLAY_MONTH eq '03'}">
								<c:set var="headerMonth1" value="LABEL.D.D04.0022" /><!-- 1월 -->
								<c:set var="headerMonth1Range" value="(${DISPLAY_YEAR - 1}.12.21 ~ ${DISPLAY_YEAR}.01.20)" />
								<c:set var="headerMonth2" value="LABEL.D.D04.0023" /><!-- 2월 -->
								<c:set var="headerMonth2Range" value="(${DISPLAY_YEAR}.01.21 ~ ${DISPLAY_YEAR}.02.20)" />
								<c:set var="headerMonth3" value="LABEL.D.D04.0024" /><!-- 3월 -->
								<c:set var="headerMonth3Range" value="(${DISPLAY_YEAR}.02.21 ~ ${DISPLAY_YEAR}.03.20)" />
							</c:when>
							<c:when test="${DISPLAY_MONTH eq '04' || DISPLAY_MONTH eq '05' || DISPLAY_MONTH eq '06'}">
								<c:set var="headerMonth1" value="LABEL.D.D04.0025" /><!-- 4월 -->
								<c:set var="headerMonth1Range" value="(${DISPLAY_YEAR}.03.21 ~ ${DISPLAY_YEAR}.04.20)" />
								<c:set var="headerMonth2" value="LABEL.D.D04.0026" /><!-- 5월 -->
								<c:set var="headerMonth2Range" value="(${DISPLAY_YEAR}.04.21 ~ ${DISPLAY_YEAR}.05.20)" />
								<c:set var="headerMonth3" value="LABEL.D.D04.0027" /><!-- 6월 -->
								<c:set var="headerMonth3Range" value="(${DISPLAY_YEAR}.05.21 ~ ${DISPLAY_YEAR}.06.20)" />
							</c:when>
							<c:when test="${DISPLAY_MONTH eq '07' || DISPLAY_MONTH eq '08' || DISPLAY_MONTH eq '09'}">
								<c:set var="headerMonth1" value="LABEL.D.D04.0028" /><!-- 7월 -->
								<c:set var="headerMonth1Range" value="(${DISPLAY_YEAR}.06.21 ~ ${DISPLAY_YEAR}.07.20)" />
								<c:set var="headerMonth2" value="LABEL.D.D04.0029" /><!-- 8월 -->
								<c:set var="headerMonth2Range" value="(${DISPLAY_YEAR}.07.21 ~ ${DISPLAY_YEAR}.08.20)" />
								<c:set var="headerMonth3" value="LABEL.D.D04.0030" /><!-- 9월 -->
								<c:set var="headerMonth3Range" value="(${DISPLAY_YEAR}.08.21 ~ ${DISPLAY_YEAR}.09.20)" />
							</c:when>
							<c:when test="${DISPLAY_MONTH eq '10' || DISPLAY_MONTH eq '11' || DISPLAY_MONTH eq '12'}">
								<c:set var="headerMonth1" value="LABEL.D.D04.0031" /><!-- 10월 -->
								<c:set var="headerMonth1Range" value="(${DISPLAY_YEAR}.09.21 ~ ${DISPLAY_YEAR}.10.20)" />
								<c:set var="headerMonth2" value="LABEL.D.D04.0032" /><!-- 11월 -->
								<c:set var="headerMonth2Range" value="(${DISPLAY_YEAR}.10.21 ~ ${DISPLAY_YEAR}.11.20)" />
								<c:set var="headerMonth3" value="LABEL.D.D04.0033" /><!-- 12월 -->
								<c:set var="headerMonth3Range" value="(${DISPLAY_YEAR}.11.21 ~ ${DISPLAY_YEAR}.12.20)" />
							</c:when>
						</c:choose>
						<div class="listArea" style="margin-bottom:0px;">
							<div class="table">
								<table class="listTable">
									<colgroup>
						        		<col style="width:8%" />
						        		<col style="width:8%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        		<col style="width:6%" />
						        	</colgroup>
									<thead>
										<tr>
											<th rowspan="2" class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0016' /><!-- 사번 --></th>
											<th rowspan="2" class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0040' /><!-- 이름 --></th>
											<th colspan="4" class="th02" style="border-bottom:solid 1px #cdcdcd;"><spring:message code='${headerMonth1}' /><!-- 월 --> ${headerMonth1Range}</th>
											<th colspan="4" class="th02" style="border-bottom:solid 1px #cdcdcd;"><spring:message code='${headerMonth2}' /><!-- 월 --> ${headerMonth2Range}</th>
											<th colspan="4" class="th02" style="border-bottom:solid 1px #cdcdcd;"><spring:message code='${headerMonth3}' /><!-- 월 --> ${headerMonth3Range}</th>
											<th colspan="2" class="th02 lastCol" style="border-bottom:solid 1px #cdcdcd;"><spring:message code='LABEL.D.D25.0047' /><!-- 3개월 계 --></th>
										</tr>
										<tr>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0038' /><!-- 정상근무 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0079' /><!-- 초과근무/교육 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0052' /><!-- 휴게/비근무 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0053' /><!-- 실 근무시간 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0038' /><!-- 정상근무 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0079' /><!-- 초과근무/교육 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0052' /><!-- 휴게/비근무 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0053' /><!-- 실 근무시간 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0038' /><!-- 정상근무 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0079' /><!-- 초과근무/교육 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0052' /><!-- 휴게/비근무 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0053' /><!-- 실 근무시간 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0019' /><!-- 실 근무시간 --></th>
											<th class="th02" style="width:5%;"><spring:message code='LABEL.D.D25.0048' /><!-- 주당 평균 --></th>
										</tr>
									</thead>
									<tbody id="reportContents">
										<c:if test="${not empty T_LIST}">
											<fmt:parseNumber var="limitNumber" value="52" />
											<c:forEach var="list" items="${T_LIST}" varStatus="status">
												<tr <c:if test="${status.first}">class="sumRow"</c:if><c:if test="${!status.first}">class="borderRow"</c:if>>
													<c:choose>
														<c:when test="${status.first}">
															<c:set var="tdStyle" value="background-color:#F6EDB8;" />
															<td style="${tdStyle}">${list.ENAME}</td>
															<td style="${tdStyle}">${list.PERNR}</td>
														</c:when>
														<c:otherwise>
															<c:set var="tdStyle" value="" />
															<td>${list.PERNR}</td>
															<td>${list.ENAME}</td>
														</c:otherwise>
													</c:choose>
													<td style="${tdStyle}">${list.NORTM1}</td>
													<td style="${tdStyle}">${list.OVRTM1}</td>
													<fmt:formatNumber var="tempSum" value="${list.BRKTM1 + list.NWKTM1}" pattern="0.00" />
													<td style="${tdStyle}">${tempSum eq '0.00' ? '0' : tempSum}</td>
													<td style="${tdStyle}">${list.MONSUM1}</td>
													<td style="${tdStyle}">${list.NORTM2}</td>
													<td style="${tdStyle}">${list.OVRTM2}</td>
													<fmt:formatNumber var="tempSum" value="${list.BRKTM2 + list.NWKTM2}" pattern="0.00" />
													<td style="${tdStyle}">${tempSum eq '0.00' ? '0' : tempSum}</td>
													<td style="${tdStyle}">${list.MONSUM2}</td>
													<td style="${tdStyle}">${list.NORTM3}</td>
													<td style="${tdStyle}">${list.OVRTM3}</td>
													<fmt:formatNumber var="tempSum" value="${list.BRKTM3 + list.NWKTM3}" pattern="0.00" />
													<td style="${tdStyle}">${tempSum eq '0.00' ? '0' : tempSum}</td>
													<td style="${tdStyle}">${list.MONSUM3}</td>
													<td style="font-weight:bold;background-color:#F6EDB8;">${list.TMONSUM}</td>
													<fmt:parseNumber var="convertTABRTM" value="${list.TAVRTM}" />
													<td <c:if test="${convertTABRTM ge limitNumber}">class="td11"</c:if> style="font-weight:bold;<c:if test="${convertTABRTM lt limitNumber}">background-color:#F6EDB8;</c:if>">${list.TAVRTM}</td>
												</tr>
											</c:forEach>
										</c:if>
									</tbody>
								</table>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<div class="listArea" style="margin-bottom:0px;">
							<div class="table">
								<table class="listTable">
									<colgroup>
						        		<col style="width:10%" />
						        		<col />
										<c:if test="${not empty T_TWEEKS}">
											<fmt:parseNumber var="colWidth" value="${90 / (fn:length(T_TWEEKS) * 4)}" integerOnly="true" />
											<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
												<col style="width:${colWidth}%" />
												<col style="width:${colWidth}%" />
												<col style="width:${colWidth}%" />
												<col style="width:${colWidth}%" />
											</c:forEach>
										</c:if>
						        	</colgroup>
									<thead>
										<tr>
											<th rowspan="2" class="th02"><spring:message code='LABEL.D.D25.0016' /><!-- 사번 --></th>
											<th rowspan="2" class="th02"><spring:message code='LABEL.D.D25.0040' /><!-- 이름 --></th>
											<c:if test="${not empty T_TWEEKS}">
												<c:forEach var="tweeks" items="${T_TWEEKS}" varStatus="status">
													<th colspan="4" class="th02" style="border-bottom:solid 1px #cdcdcd;">${tweeks.TWEEKS}${tweeks.TPERIOD}</th>
												</c:forEach>
											</c:if>
										</tr>
										<tr>
											<c:if test="${not empty T_TWEEKS}">
												<c:forEach var="tweeks" items="${T_TWEEKS}" varStatus="status">
													<th class="th02"><spring:message code='LABEL.D.D25.0038' /><!-- 정상근무 --></th>
													<th class="th02"><spring:message code='LABEL.D.D25.0079' /><!-- 초과근무/교육 --></th>
													<th class="th02"><spring:message code='LABEL.D.D25.0052' /><!-- 휴게/비근무 --></th>
													<th class="th02"><spring:message code='LABEL.D.D25.0053' /><!-- 실 근무시간 --></th>
												</c:forEach>
											</c:if>
										</tr>
									</thead>
									<tbody id="reportContents">
										<c:if test="${not empty T_LIST}">
											<fmt:parseNumber var="limitNumber" value="64" />
											<c:set var="tweeksSize" value="${fn:length(T_TWEEKS)}" />
											<c:forEach var="list" items="${T_LIST}" varStatus="status">
												<tr class="borderRow">
													<c:choose>
														<c:when test="${status.first}">
															<c:set var="tdStyle" value="background-color:#F6EDB8;" />
															<td style="${tdStyle}">${list.ENAME}</td>
															<td style="${tdStyle}">${list.PERNR}</td>
														</c:when>
														<c:otherwise>
															<c:set var="tdStyle" value="" />
															<td>${list.PERNR}</td>
															<td>${list.ENAME}</td>
														</c:otherwise>
													</c:choose>
													<c:forEach begin="1" end="${tweeksSize}" step="1" var="x">
													<c:set var="NORTM" value="NORTM${x}" />
													<c:set var="OVRTM" value="OVRTM${x}" />
													<c:set var="BRKTM" value="BRKTM${x}" />
													<c:set var="NWKTM" value="NWKTM${x}" />
													<c:set var="RWKTM" value="RWKTM${x}" />
														<td style="${tdStyle}">${list[NORTM]}</td>
														<td style="${tdStyle}">${list[OVRTM]}</td>
														<fmt:formatNumber var="tempSum" value="${list[BRKTM] + list[NWKTM]}" pattern="0.00" />
														<td style="${tdStyle}">${tempSum eq '0.00' ? '0' : tempSum}</td>
														<fmt:parseNumber var="convertRWKTM" value="${list[RWKTM]}" />
														<td <c:if test="${convertRWKTM ge limitNumber}">class="td11"</c:if> style="font-weight:bold;<c:if test="${convertRWKTM lt limitNumber}">background-color:#F6EDB8;</c:if>">${list[RWKTM]}</td>
													</c:forEach>
												</tr>
											</c:forEach>
										</c:if>
									</tbody>
								</table>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
					
				<div class="commentOne">
					<span><spring:message code='LABEL.D.D25.0009' /><!--실 근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.--></span>
				</div>
				
				<br/>
				<div class="commentOne">
					<span><spring:message code='LABEL.D.D25.0055' /><!--현재일 기준으로 계획근무일정을 반영한 예상 근무시간입니다.--></span>
				</div>
				
			</div>
		</div>
	</form>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />