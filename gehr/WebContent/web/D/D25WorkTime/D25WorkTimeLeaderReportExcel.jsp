<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 실근무 실적현황 사무직 Excel
/*   Program ID   : D25WorkTimeLeaderReportExcel.jsp
/*   Description  : 실근무 실적현황 사무직 Excel 화면
/*   Note         : 
/*   Creation     : 2018-05-29 성환희 [WorkTime52]
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
    response.setHeader("Content-Disposition","attachment;filename=WorkTimeLeaderReport.xls");
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
						<c:if test="${SEARCH_GUBUN eq 'W'}">
							<td colspan="15"><b>주간 실근무현황</b></td>
						</c:if>
						<c:if test="${SEARCH_GUBUN eq 'M'}">
							<td colspan="15"><b>월간 실근무현황</b></td>
						</c:if>
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
							신분 : 사무직
						</td>
					</tr>
					<tr>
						<td colspan="15">
							<c:if test="${SEARCH_GUBUN eq 'W'}">
							조회기준일 : <c:out value="${SEARCH_DATE}" />
							</c:if>
							<c:if test="${SEARCH_GUBUN eq 'M'}">
							조회년/월 : <c:out value="${fn:substring(SEARCH_DATE, 0, 7)}" />
							</c:if> 
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
						<td colspan="15">
						<c:choose>
							<c:when test="${SEARCH_EMPGUBUN eq 'S' && SEARCH_GUBUN eq 'W'}">
								<b>근무시간 = 정상근무 + 초과근무 - 휴게/비근무</b>
							</c:when>
							<c:when test="${SEARCH_EMPGUBUN eq 'S' && SEARCH_GUBUN eq 'M'}">
								<b>당월 근무시간 = 정상근무 + 초과근무 - 휴게/비근무</b>
							</c:when>
						</c:choose>
						</td>
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
							<th rowspan="2" width="60" style="background-color:#CEECF5;">사번</th>
							<th rowspan="2" width="60" style="background-color:#CEECF5;">이름</th>
							<th rowspan="2" width="60" style="background-color:#CEECF5;">소속</th>
							<th rowspan="2" width="60" style="background-color:#CEECF5;">직책</th>
							<c:if test="${not empty T_TWEEKS}">
								<c:forEach var="tweeks" items="${T_TWEEKS}" varStatus="status">
									<th colspan="4" style="background-color:#CEECF5;">${tweeks.TWEEKS}${tweeks.TPERIOD}</th>
								</c:forEach>
							</c:if>
						</tr>
						<tr>
							<c:if test="${not empty T_TWEEKS}">
								<c:forEach var="tweeks" items="${T_TWEEKS}" varStatus="status">
									<th class="th02" style="width:50px;background-color:#CEECF5;">정상근무</th>
									<th class="th02" style="width:50px;background-color:#CEECF5;">초과근무</th>
									<th class="th02" style="width:50px;background-color:#CEECF5;">휴게/비근무</th>
									<th class="th02" style="width:50px;background-color:#CEECF5;">근무시간</th>
								</c:forEach>
							</c:if>
						</tr>
		            </thead>
		            <tbody>
		            	<c:if test="${not empty T_LIST}">
		            		<fmt:parseNumber var="limitNumber" value="64" />
							<c:set var="tweeksSize" value="${fn:length(T_TWEEKS)}" />
							<c:forEach var="list" items="${T_LIST}" varStatus="status">
								<tr <c:if test="${status.first}">style="background-color: #F6EDB8;"</c:if>>
									<c:choose>
										<c:when test="${status.first}">
											<td width="60" style="text-align:center;">${list.ENAME}</td>
											<td width="60" style="text-align:center;">${list.PERNR}</td>
										</c:when>
										<c:otherwise>
											<td width="60" style="text-align:center;">${list.PERNR}</td>
											<td width="60" style="text-align:center;">${list.ENAME}</td>
										</c:otherwise>
									</c:choose>
									<td width="60" style="text-align:center;">${list.ORGTX}</td>
									<td width="60" style="text-align:center;">${list.JIKKT}</td>
									<c:forEach begin="1" end="${tweeksSize}" step="1" var="x">
									<c:set var="NORTM" value="NORTM${x}" />
									<c:set var="OVRTM" value="OVRTM${x}" />
									<c:set var="EDUTM" value="EDUTM${x}" />
									<c:set var="BRKTM" value="BRKTM${x}" />
									<c:set var="NWKTM" value="NWKTM${x}" />
									<c:set var="RWKTM" value="RWKTM${x}" />
										<td width="60" style="text-align:center;">${list[NORTM]}</td>
										<fmt:formatNumber var="tempSum" value="${list[OVRTM] + list[EDUTM]}" pattern="0.00" />
										<td width="60" style="text-align:center;">${tempSum eq '0.00' ? '0' : tempSum}</td>
										<fmt:formatNumber var="tempSum" value="${list[BRKTM] + list[NWKTM]}" pattern="0.00" />
										<td width="60" style="text-align:center;">${tempSum eq '0.00' ? '0' : tempSum}</td>
										<fmt:parseNumber var="convertRWKTM" value="${list[RWKTM]}" />
										<c:choose>
											<c:when test="${convertRWKTM ge limitNumber}"><c:set var="bgColor" value="#F6CEF5" /></c:when>
											<c:otherwise><c:set var="bgColor" value="#F6EDB8" /></c:otherwise>
										</c:choose>
										<td width="60" style="text-align:center;background-color:${bgColor};">${list[RWKTM]}</td>
									</c:forEach>
								</tr>
							</c:forEach>
						</c:if>
		            </tbody>
				</table>
				</c:if>
				<c:if test="${SEARCH_GUBUN eq 'M'}">
					<table border="1" cellpadding="0" cellspacing="1">
			            <thead>
			            	<tr>
								<th width="60" style="background-color:#CEECF5;">사번</th>
								<th width="60" style="background-color:#CEECF5;">이름</th>
								<th width="60" style="background-color:#CEECF5;">소속</th>
								<th width="60" style="background-color:#CEECF5;">직책</th>
								<th width="60" style="background-color:#CEECF5;">정상근무</th>
								<th width="60" style="background-color:#CEECF5;">초과근무</th>
								<th width="60" style="background-color:#CEECF5;">휴게/비근무</th>
								<th width="60" style="background-color:#CEECF5;">당월 근무시간</th>
								<th width="60" style="background-color:#CEECF5;">주당 평균 실 근무시간</th>
							</tr>
			            </thead>
			            <tbody>
			            	<c:if test="${not empty T_LIST}">
			            		<fmt:parseNumber var="limitNumber" value="52" />
								<c:forEach var="list" items="${T_LIST}" varStatus="status">
									<tr <c:if test="${status.first}">style="background-color: #F6EDB8;"</c:if>>
										<c:choose>
											<c:when test="${status.first}">
												<td width="60" style="text-align:center;">${list.ENAME}</td>
												<td width="60" style="text-align:center;">${list.PERNR}</td>
											</c:when>
											<c:otherwise>
												<td width="60" style="text-align:center;">${list.PERNR}</td>
												<td width="60" style="text-align:center;">${list.ENAME}</td>
											</c:otherwise>
										</c:choose>
										<td width="60" style="text-align:center;">${list.ORGTX}</td>
										<td width="60" style="text-align:center;">${list.JIKKT}</td>
										<td width="60" style="text-align:center;">${list.NORTM}</td>
										<td width="60" style="text-align:center;">${list.OVRTM}</td>
										<fmt:formatNumber var="tempSum" value="${list.BRKTM + list.NWKTM}" pattern="0.00" />
										<td width="60" style="text-align:center;">${tempSum eq '0.00' ? '0' : tempSum}</td>
										<td width="60" style="text-align:center;background-color:#F6EDB8;">${list.MONSUM}</td>
										<fmt:parseNumber var="convertAVRTM" value="${list.AVRTM}" />
										<c:choose>
											<c:when test="${convertAVRTM ge limitNumber}"><c:set var="bgColor" value="#F6CEF5" /></c:when>
											<c:otherwise><c:set var="bgColor" value="#F6EDB8" /></c:otherwise>
										</c:choose>
										<td width="60" style="text-align:center;background-color:${bgColor};">${list.AVRTM}</td>
									</tr>
								</c:forEach>
							</c:if>
			            </tbody>
		            </table>
				</c:if>
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
							※  실 근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</form>
</body>
</html>