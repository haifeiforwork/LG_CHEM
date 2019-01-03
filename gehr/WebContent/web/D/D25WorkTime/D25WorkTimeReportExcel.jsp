<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트 Excel
/*   Program ID   : D25WorkTimeReportExcel.jsp
/*   Description  : 실 근무시간 레포트 Excel 화면
/*   Note         : 
/*   Creation     : 2018-05-25 성환희 [WorkTime52]
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

<%
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=WorkTimeReport.xls");
	response.setContentType("application/vnd.xls;charset=utf-8");
    /*----------------------------------------------------------------------------- */
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
	<table width="2040" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="15">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
					<c:choose>
						<c:when test="${SEARCH_GUBUN eq 'W' && EMPGUB eq 'S'}">
							<td colspan="15"><b><spring:message code='LABEL.D.D25.0074' /></b><!-- 주간 근무현황 --></td>
						</c:when>
						<c:when test="${SEARCH_GUBUN eq 'W' && EMPGUB eq 'H'}">
							<td colspan="15"><b><spring:message code='LABEL.D.D25.0014' /></b><!-- 주간 실근무현황 --></td>
						</c:when>
						<c:when test="${SEARCH_GUBUN eq 'M' && EMPGUB eq 'S'}">
							<td colspan="15"><b><spring:message code='LABEL.D.D25.0075' /></b><!-- 월간 근무현황 --></td>
						</c:when>
						<c:when test="${SEARCH_GUBUN eq 'M' && EMPGUB eq 'H'}">
							<td colspan="15"><b><spring:message code='LABEL.D.D25.0015' /></b><!-- 월간 실근무현황 --></td>
						</c:when>
					</c:choose>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="15" height="10"></td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="15">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="15">
							<spring:message code='LABEL.D.D25.0016' /><!-- 사번 --> : ${PERNR}(${E_NAME})
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="15" height="10"></td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="15">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<c:if test="${SEARCH_GUBUN eq 'W'}">
							<c:choose>
								<c:when test="${EMPGUB eq 'S'}">
									<td colspan="15"><b><spring:message code='LABEL.D.D25.0072' /></b><!-- 1.주당 근무시간 현황 --></td>
								</c:when>
								<c:otherwise>
									<td colspan="15"><b><spring:message code='LABEL.D.D25.0007' /></b><!-- 1.주당 실 근무시간 현황 --></td>
								</c:otherwise>
							</c:choose>
						</c:if>
						<c:if test="${SEARCH_GUBUN eq 'M'}">
							<c:choose>
								<c:when test="${EMPGUB eq 'S'}">
									<td colspan="15"><b><spring:message code='LABEL.D.D25.0066' /></b><!-- 1.주당 평균 근무시간 현황 --></td>
								</c:when>
								<c:otherwise>
									<td colspan="15"><b><spring:message code='LABEL.D.D25.0011' /></b><!-- 1.주당 평균 실 근무시간 현황 --></td>
								</c:otherwise>
							</c:choose>
						</c:if>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="2">
				<c:if test="${SEARCH_GUBUN eq 'W'}">
				<table border="1" cellpadding="0" cellspacing="1">
					<thead>
		            	<tr>
		            	<c:if test="${not empty T_HEADER}">
		            		<th width="60" style="background-color:#CEECF5;"><spring:message code='LABEL.D.D25.0018' /><!-- 구분 --></th>
		            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
		            			<th width="60" height="30" style="background-color:#CEECF5;">
		            				<c:choose>
		            					<c:when test="${fn:contains(head.GUBUN, '주차')}">
		            						<c:set var="gubunText" value="${fn:join(fn:split(head.GUBUN, ' '), '<br/>')}" />
		            						${gubunText}
		            					</c:when>
		            					<c:otherwise>
		            						${head.GUBUN}(${fn:replace(fn:substring(head.BEGDA, 5, 10), '-', '.')}~${fn:replace(fn:substring(head.ENDDA, 5, 10), '-', '.')})
		            					</c:otherwise>
		            				</c:choose>
		            			</th>
		            		</c:forEach>
		            	</c:if>
		            	</tr>
		            </thead>
		            <tbody>
		            	<tr class="borderRow">
		            	<c:if test="${not empty T_HEADER}">
		            		<th width="60">
		            			<c:choose>
									<c:when test="${EMPGUB eq 'S'}"><spring:message code='LABEL.D.D25.0062' /><!-- 근무시간 --></c:when>
									<c:otherwise><spring:message code='LABEL.D.D25.0022' /><!-- 실 근무시간 --></c:otherwise>
								</c:choose>
							</th>
		            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
		            			<td width="60" style="text-align:center;">${head.RWKTM}</td>
		            		</c:forEach>
		            	</c:if>
		            	</tr>
		            </tbody>
				</table>
				</c:if>
				<c:if test="${SEARCH_GUBUN eq 'M'}">
					<c:choose>
						<c:when test="${EMPGUB eq 'S'}">
						<table border="1" cellpadding="0" cellspacing="1">
				            <thead>
				            	<tr>
				            		<th width="60" style="background-color:#CEECF5;"><spring:message code='LABEL.D.D25.0018' /><!-- 구분 --></th>
				            		<th width="60" style="background-color:#CEECF5;"><spring:message code='LABEL.D.D25.0065' /><!-- 월 근무시간 (유급휴가 포함) --></th>
				            		<th width="60" style="background-color:#CEECF5;"><spring:message code='LABEL.D.D25.0067' /><!-- 주당 평균 근무시간 --></th>
				            	</tr>
				            </thead>
				            <tbody>
				            	<c:if test="${not empty ES_HEADER}">
				            	<tr class="borderRow">
				            		<th width="60"><spring:message code='LABEL.D.D25.0062' /><!-- 근무시간 --></th>
				            		<td width="60" style="text-align:center;">${ES_HEADER.MONSUM}</td>
				            		<td width="60" style="text-align:center;">${ES_HEADER.WEKAVR}</td>
				            	</tr>
				            	</c:if>
				            </tbody>
			            </table>
			            </c:when>
			            <c:otherwise>
			            	<c:set var="displayYear" value="${fn:substring(T_HEADER[0].YYYYMM, 0, 4)}" />
							<c:set var="displayMonth" value="${fn:substring(T_HEADER[0].YYYYMM, 4, 6)}" />
							<c:choose>
								<c:when test="${displayMonth eq '01' || displayMonth eq '02' || displayMonth eq '03'}">
									<c:set var="headerMonth1" value="LABEL.D.D04.0022" /><!-- 1월 -->
									<c:set var="headerMonth1Range" value="(${displayYear - 1}.12.21~${displayYear}.01.20)" />
									<c:set var="headerMonth2" value="LABEL.D.D04.0023" /><!-- 2월 -->
									<c:set var="headerMonth2Range" value="(${displayYear}.01.21~${displayYear}.02.20)" />
									<c:set var="headerMonth3" value="LABEL.D.D04.0024" /><!-- 3월 -->
									<c:set var="headerMonth3Range" value="(${displayYear}.02.21~${displayYear}.03.20)" />
								</c:when>
								<c:when test="${displayMonth eq '04' || displayMonth eq '05' || displayMonth eq '06'}">
									<c:set var="headerMonth1" value="LABEL.D.D04.0025" /><!-- 4월 -->
									<c:set var="headerMonth1Range" value="(${displayYear}.03.21~${displayYear}.04.20)" />
									<c:set var="headerMonth2" value="LABEL.D.D04.0026" /><!-- 5월 -->
									<c:set var="headerMonth2Range" value="(${displayYear}.04.21~${displayYear}.05.20)" />
									<c:set var="headerMonth3" value="LABEL.D.D04.0027" /><!-- 6월 -->
									<c:set var="headerMonth3Range" value="(${displayYear}.05.21~${displayYear}.06.20)" />
								</c:when>
								<c:when test="${displayMonth eq '07' || displayMonth eq '08' || displayMonth eq '09'}">
									<c:set var="headerMonth1" value="LABEL.D.D04.0028" /><!-- 7월 -->
									<c:set var="headerMonth1Range" value="(${displayYear}.06.21~${displayYear}.07.20)" />
									<c:set var="headerMonth2" value="LABEL.D.D04.0029" /><!-- 8월 -->
									<c:set var="headerMonth2Range" value="(${displayYear}.07.21~${displayYear}.08.20)" />
									<c:set var="headerMonth3" value="LABEL.D.D04.0030" /><!-- 9월 -->
									<c:set var="headerMonth3Range" value="(${displayYear}.08.21~${displayYear}.09.20)" />
								</c:when>
								<c:when test="${displayMonth eq '10' || displayMonth eq '11' || displayMonth eq '12'}">
									<c:set var="headerMonth1" value="LABEL.D.D04.0031" /><!-- 10월 -->
									<c:set var="headerMonth1Range" value="(${displayYear}.09.21~${displayYear}.10.20)" />
									<c:set var="headerMonth2" value="LABEL.D.D04.0032" /><!-- 11월 -->
									<c:set var="headerMonth2Range" value="(${displayYear}.10.21~${displayYear}.11.20)" />
									<c:set var="headerMonth3" value="LABEL.D.D04.0033" /><!-- 12월 -->
									<c:set var="headerMonth3Range" value="(${displayYear}.11.21~${displayYear}.12.20)" />
								</c:when>
							</c:choose>
				            <table border="1" cellpadding="0" cellspacing="1">
				            	<thead>
					            	<tr>
					            		<th width="60" style="background-color:#CEECF5;"><spring:message code='LABEL.D.D25.0018' /><!-- 구분 --></th>
					            		<th width="60" style="background-color:#CEECF5;"><spring:message code='<c:out value="${headerMonth1}" />' /><!-- 월 --> <c:out value="${headerMonth1Range}" /></th>
					            		<th width="60" style="background-color:#CEECF5;"><spring:message code='<c:out value="${headerMonth2}" />' /><!-- 월 --> <c:out value="${headerMonth2Range}" /></th>
					            		<th width="60" style="background-color:#CEECF5;"><spring:message code='<c:out value="${headerMonth3}" />' /><!-- 월 --> <c:out value="${headerMonth3Range}" /></th>
					            		<th width="60" style="background-color:#CEECF5;"><spring:message code='LABEL.D.D25.0046' /><!-- 계 --></th>
					            	</tr>
					            </thead>
					            <tbody>
					            	<c:if test="${not empty T_HEADER}">
					            	<c:set var="totalSum" value="${T_HEADER[0].MONSUM + T_HEADER[1].MONSUM + T_HEADER[2].MONSUM}" />
			            			<c:set var="totalWorkDay" value="${T_HEADER[0].WKDAY + T_HEADER[1].WKDAY + T_HEADER[2].WKDAY}" />
					            	<tr>
					            		<td width="60"><spring:message code='LABEL.D.D25.0022' /><!-- 실 근무시간 --></td>
					            		<td width="60" style="text-align:center;">${T_HEADER[0].MONSUM eq null ? 0 : T_HEADER[0].MONSUM}</td>
					            		<td width="60" style="text-align:center;">${T_HEADER[1].MONSUM eq null ? 0 : T_HEADER[1].MONSUM}</td>
					            		<td width="60" style="text-align:center;">${T_HEADER[2].MONSUM eq null ? 0 : T_HEADER[2].MONSUM}</td>
					            		<td width="60" style="text-align:center;"><fmt:formatNumber value="${totalSum}" pattern=".00" /></td>
					            	</tr>
					            	<tr>
					            		<td width="60"><spring:message code='LABEL.D.D25.0021' /><!-- 주당 평균 실 근무시간 --></td>
					            		<td width="60" style="text-align:center;">${T_HEADER[0].WEKAVR eq null ? 0 : T_HEADER[0].WEKAVR}</td>
					            		<td width="60" style="text-align:center;">${T_HEADER[1].WEKAVR eq null ? 0 : T_HEADER[1].WEKAVR}</td>
					            		<td width="60" style="text-align:center;">${T_HEADER[2].WEKAVR eq null ? 0 : T_HEADER[2].WEKAVR}</td>
					            		<td width="60" style="text-align:center;"><fmt:formatNumber value="${totalSum / totalWorkDay * 7}" pattern=".00" /></td>
					            	</tr>
					            	</c:if>
					            </tbody>
				            </table>
			            </c:otherwise>
					</c:choose>
				</c:if>
			</td>
		</tr>
		<tr>
			<td colspan="15" height="10"></td>
		</tr>
		<c:if test="${SEARCH_GUBUN eq 'M'}">
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="15">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="15">
						<c:choose>
							<c:when test="${EMPGUB eq 'S'}">
								<spring:message code='LABEL.D.D25.0068' /><!-- 주당 평균 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일)-->
							</c:when>
							<c:otherwise>
								<spring:message code='LABEL.D.D25.0017' /><!-- 주당 평균 실 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일)-->
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		</c:if>
		<tr>
			<td colspan="15" height="10"></td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="15">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="15"><b><spring:message code='LABEL.D.D25.0008' /></b><!-- 2.세부 현황 --></td>
					</tr>
					<tr>
						<td colspan="15">
						<c:choose>
							<c:when test="${EMPGUB eq 'S'}">
								<b><spring:message code='LABEL.D.D25.0069' /></b><!-- 근무시간 = 정상근무 + 초과근무 - 휴게 - 비근무 -->
							</c:when>
							<c:otherwise>
								<b><spring:message code='LABEL.D.D25.0059' /></b><!-- 실근무시간 = 정상근무 + 초과근무 + 교육 - 휴게/비근무 -->
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="2">
				<table border="1" cellpadding="0" cellspacing="1">
					<thead>
		            	<tr>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2"><spring:message code='LABEL.D.D25.0023' /><!-- 일자 --></th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2"><spring:message code='LABEL.D.D25.0024' /><!-- 정상근무시간 --></th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2"><spring:message code='LABEL.D.D25.0025' /><!-- 초과근무 --></th>
		            		<c:if test="${EMPGUB eq 'H'}">
		            			<th width="60" style="background-color:#CEECF5;" rowspan="2"><spring:message code='LABEL.D.D25.0060' /><!-- 교육 --></th>
		            		</c:if>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2"><spring:message code='LABEL.D.D25.0026' /><!-- 휴게시간 --></th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">
		            		<c:choose>
	            				<c:when test="${EMPGUB eq 'S'}"><spring:message code='LABEL.D.D25.0070' /><!-- 비근무차감 --></c:when>
	            				<c:otherwise><spring:message code='LABEL.D.D25.0027' /><!-- 비근무 --></c:otherwise>
	            			</c:choose>
		            		</th>
		            		<c:if test="${not empty T_NWKTYP}">
		            			<th width="60" style="background-color:#CEECF5;" colspan="${fn:length(T_NWKTYP)}">
		            				<c:choose>
	            						<c:when test="${EMPGUB eq 'S'}"><spring:message code='LABEL.D.D25.0071' /><!-- 유급휴가 --></c:when>
	            						<c:otherwise><spring:message code='LABEL.D.D25.0028' /><!-- 비근무 --></c:otherwise>
	            					</c:choose>
		            			</th>
		            		</c:if>
			            	<th width="60" style="background-color:#CEECF5;" rowspan="2">
			            	<c:choose>
			            		<c:when test="${EMPGUB eq 'S'}">
			            			<spring:message code='LABEL.D.D25.0062' /><!-- 근무시간 -->
			            		</c:when>
			            		<c:otherwise>
			            			<spring:message code='LABEL.D.D25.0029' /><!-- 실 근무시간 -->
			            		</c:otherwise>
			            	</c:choose>
			            	</th>
			            	<c:if test="${SEARCH_GUBUN eq 'M' && EMPGUB eq 'S'}">
		            			<th width="60" style="background-color:#CEECF5;" rowspan="2"><spring:message code='LABEL.D.D25.0076' /><!-- 평일 누적근무시간 --></th>
		            		</c:if>
		            	</tr>
		            	<tr>
	            		<c:if test="${not empty T_NWKTYP}">
	            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
		            			<th width="60" style="background-color:#CEECF5;">${nwktyp.NWKTXT}</th>
		            		</c:forEach>
	            		</c:if>
		            	</tr>
		            </thead>
		            <c:if test="${not empty T_BODY}">
		            <tbody>
		            	<c:set var="SUM_NORTM" value="0" scope="request" />
		            	<c:set var="SUM_OVRTM" value="0" scope="request" />
		            	<c:set var="SUM_EDUTM" value="0" scope="request" />
		            	<c:set var="SUM_BRKTM" value="0" scope="request" />
		            	<c:set var="SUM_NWKTM" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP1" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP2" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP3" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP4" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP5" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP6" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP7" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP8" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP9" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP10" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP11" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP12" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP13" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP14" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP15" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP16" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP17" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP18" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP19" value="0" scope="request" />
		            	<c:set var="SUM_NWKTYP20" value="0" scope="request" />
		            	<c:set var="SUM_RWKTM" value="0" scope="request" />
		            	
	            		<c:forEach var="body" items="${T_BODY}" varStatus="status">
	            		<c:choose>
	           				<c:when test="${fn:indexOf(body.DAYTX, '소계') > -1}">
	           					<c:set var="bgColor" value="background-color:#FFFF00;" />
	           					<c:set var="bgColor2" value="" />
	           				</c:when>
	           				<c:when test="${body.BASOVR eq 'X'}">
	           					<c:set var="bgColor" value="" />
	           					<c:set var="bgColor2" value="background-color:#e9ffd2;" />
	           				</c:when>
	           				<c:otherwise>
	           					<c:set var="bgColor" value="" />
	           					<c:set var="bgColor2" value="" />
	           				</c:otherwise>
	           			</c:choose>
		            	<tr>
	            			<td width="60" style="text-align:center;${bgColor}">${body.DAYTX}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.NORTM}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.OVRTM}</td>
	            			<c:if test="${EMPGUB eq 'H'}">
		            			<td width="60" style="text-align:center;${bgColor}">${body.EDUTM}</td>
	            			</c:if>
	            			<td width="60" style="text-align:center;${bgColor}">${body.BRKTM}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.NWKTM}</td>
	            			<c:if test="${not empty T_NWKTYP}">
		            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
			            			<td width="60" style="text-align:center;${bgColor}">${body[nwktyp.FLDNM]}</td>
			            			<c:choose>
			            				<c:when test="${status.count eq 1}"><c:set var="SUM_NWKTYP1" value="${SUM_NWKTYP1 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 2}"><c:set var="SUM_NWKTYP2" value="${SUM_NWKTYP2 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 3}"><c:set var="SUM_NWKTYP3" value="${SUM_NWKTYP3 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 4}"><c:set var="SUM_NWKTYP4" value="${SUM_NWKTYP4 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 5}"><c:set var="SUM_NWKTYP5" value="${SUM_NWKTYP5 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 6}"><c:set var="SUM_NWKTYP6" value="${SUM_NWKTYP6 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 7}"><c:set var="SUM_NWKTYP7" value="${SUM_NWKTYP7 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 8}"><c:set var="SUM_NWKTYP8" value="${SUM_NWKTYP8 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 9}"><c:set var="SUM_NWKTYP9" value="${SUM_NWKTYP9 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 10}"><c:set var="SUM_NWKTYP10" value="${SUM_NWKTYP10 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 11}"><c:set var="SUM_NWKTYP11" value="${SUM_NWKTYP11 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 12}"><c:set var="SUM_NWKTYP12" value="${SUM_NWKTYP12 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 13}"><c:set var="SUM_NWKTYP13" value="${SUM_NWKTYP13 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 14}"><c:set var="SUM_NWKTYP14" value="${SUM_NWKTYP14 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 15}"><c:set var="SUM_NWKTYP15" value="${SUM_NWKTYP15 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 16}"><c:set var="SUM_NWKTYP16" value="${SUM_NWKTYP16 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 17}"><c:set var="SUM_NWKTYP17" value="${SUM_NWKTYP17 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 18}"><c:set var="SUM_NWKTYP18" value="${SUM_NWKTYP18 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 19}"><c:set var="SUM_NWKTYP19" value="${SUM_NWKTYP19 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            				<c:when test="${status.count eq 20}"><c:set var="SUM_NWKTYP20" value="${SUM_NWKTYP20 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
			            			</c:choose>
			            		</c:forEach>
		            		</c:if>
	            			<td width="60" style="text-align:center;background-color:#FFFF00;">${body.RWKTM}</td>
	            			<c:if test="${SEARCH_GUBUN eq 'M' && EMPGUB eq 'S'}">
	            				<td width="60" style="text-align:center;${bgColor2}">${body.RWSUMA ne '0' ? body.RWSUMA : ''}</td>
	            			</c:if>
		            	</tr>
		            	
		            	<c:set var="SUM_NORTM" value="${SUM_NORTM +body.NORTM}" />
		            	<c:set var="SUM_OVRTM" value="${SUM_OVRTM +body.OVRTM}" />
		            	<c:set var="SUM_EDUTM" value="${SUM_EDUTM +body.EDUTM}" />
		            	<c:set var="SUM_BRKTM" value="${SUM_BRKTM +body.BRKTM}" />
		            	<c:set var="SUM_NWKTM" value="${SUM_NWKTM +body.NWKTM}" />
		            	<c:set var="SUM_RWKTM" value="${SUM_RWKTM +body.RWKTM}" />
		            	
	            		</c:forEach>
	            		<c:if test="${SEARCH_GUBUN eq 'M'}">
		            		<tr style="background-color: #F6CEF5;">
		            			<td style="text-align:center;font-weight:bold;">합계</td>
		            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_NORTM}" pattern=".00" /></td>
		            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_OVRTM}" pattern=".00" /></td>
		            			<c:if test="${EMPGUB eq 'H'}">
		            				<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_EDUTM}" pattern=".00" /></td>
		            			</c:if>
		            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_BRKTM}" pattern=".00" /></td>
		            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_NWKTM}" pattern=".00" /></td>
		            			<c:if test="${not empty T_NWKTYP}">
			            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
				            			<td style="text-align:center;font-weight:bold;">
				            				<c:set var="fName" value="SUM_NWKTYP${status.count}" scope="request" />
				            				<fmt:formatNumber value="${requestScope[fName]}" pattern=".00" />
				            			</td>
				            		</c:forEach>
			            		</c:if>
		            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_RWKTM}" pattern=".00" /></td>
		            			<c:if test="${EMPGUB eq 'S'}">
		            				<td style="text-align:center;font-weight:bold;"></td>
		            			</c:if>
		            		</tr>
		            	</c:if>
		            </tbody>
	            	</c:if>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="15" height="10"></td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="15">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="15">
						<c:choose>
							<c:when test="${EMPGUB eq 'S'}">
								※  <spring:message code='LABEL.D.D25.0073' /><!--근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.-->
							</c:when>
							<c:otherwise>
								※  <spring:message code='LABEL.D.D25.0009' /><!--실 근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.-->
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</form>
</body>
</html>