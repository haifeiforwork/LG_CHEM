<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트 Excel - 현장직 주간
/*   Program ID   : D25WorkTimeReportHWeekExcel.jsp
/*   Description  : 실 근무시간 현장직 주간 레포트 Excel 화면
/*   Note         : 
/*   Creation     : 2018-06-25 성환희 [WorkTime52]
/*   Update       : 
/******************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setContentType("Application/Msexcel;charset=UTF-8"); 
    response.setHeader("Content-Disposition", "ATTachment; Filename=WorkTimeReportHWeek.xls"); 
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
						<td colspan="15"><b>주간 근무실적현황</b></td>
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
							사번 : ${PERNR}(${E_NAME})
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
						<td colspan="15"><b>1.주당 실 근무시간 현황</b></td>
					</tr>
					<%-- <tr>
						<td colspan="15">
							<b>근무제 유형 : ${E_WTCATTX} (${fn:join(fn:split(E_BEGDA, '-'), '.')} ~ ${fn:join(fn:split(E_ENDDA, '-'), '.')})</b>
						</td>
					</tr> --%>
				</table>
			</td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="2">
				<c:set var="headerCount" value="${fn:length(T_HEADER)}" />
        		<fmt:parseNumber var="rowCount" value="${((headerCount - 1) / 6) + 1}" integerOnly="true" />
        		<fmt:parseDate value="${fn:join(fn:split(SEARCH_DATE, '.'), '')}" pattern="yyyyMMdd" var="convertSearchDate" />
				<table border="1" cellpadding="0" cellspacing="1">
				<c:forEach begin="1" end="${rowCount}" varStatus="rowStatus">
	            	<c:set var="beginNum" value="${(rowStatus.count - 1) * 6}" />
	            	<c:set var="endNum" value="${(rowStatus.count * 6) - 1}" />
	            	<tr>
	            		<th width="60" style="background-color:#CEECF5;">구분</th>
	            		<c:choose>
	            			<c:when test="${headerCount < 6}">
	            				<c:forEach var="result" items="${T_HEADER}" varStatus="headerStatus">
	            					<fmt:parseDate value="${fn:join(fn:split(result.BEGDA, '-'), '')}" pattern="yyyyMMdd" var="convertBegda" />
		            				<fmt:parseDate value="${fn:join(fn:split(result.ENDDA, '-'), '')}" pattern="yyyyMMdd" var="convertEndda" />
	            					<th width="60" style="background-color:${(convertSearchDate ge convertBegda && convertSearchDate le convertEndda) ? '#E9FFD2;' : '#CEECF5;'}">
	            						${result.GUBUN}
	            					</th>
	            				</c:forEach>
	            			</c:when>
	            			<c:otherwise>
	            				<c:forEach var="header" begin="${beginNum}" end="${endNum}" varStatus="headerStatus">
	            					<fmt:parseDate value="${fn:join(fn:split(T_HEADER[headerStatus.index].BEGDA, '-'), '')}" pattern="yyyyMMdd" var="convertBegda" />
		            				<fmt:parseDate value="${fn:join(fn:split(T_HEADER[headerStatus.index].ENDDA, '-'), '')}" pattern="yyyyMMdd" var="convertEndda" />
									<th width="60" style="background-color:${(convertSearchDate ge convertBegda && convertSearchDate le convertEndda) ? '#E9FFD2;' : '#CEECF5;'}">
										${T_HEADER[headerStatus.index].GUBUN eq null ? '' : T_HEADER[headerStatus.index].GUBUN}
									</th>
								</c:forEach>
	            			</c:otherwise>
	            		</c:choose>
						<c:if test="${rowStatus.count eq 1 && !(S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W')}">
	            			<th width="60" style="background-color:#CEECF5;">주당 평균 실 근무시간</th>
	            		</c:if>
	            	</tr>
	            	<tr>
	            		<td width="60">실 근무시간</td>
	            		<c:choose>
	            			<c:when test="${headerCount < 6}">
	            				<c:forEach var="result" items="${T_HEADER}" varStatus="headerStatus">
	            					<fmt:parseDate value="${fn:join(fn:split(result.BEGDA, '-'), '')}" pattern="yyyyMMdd" var="convertBegda" />
		            				<fmt:parseDate value="${fn:join(fn:split(result.ENDDA, '-'), '')}" pattern="yyyyMMdd" var="convertEndda" />
			            			<c:choose>
			            				<c:when test="${result.ZOVER eq 'X'}"><c:set var="bgColor" value="background-color:#FFB6C1;" /></c:when>
			            				<c:when test="${result.ZOVER ne 'X' && convertSearchDate ge convertBegda && convertSearchDate le convertEndda}"><c:set var="bgColor" value="background-color:#E9FFD2;" /></c:when>
			            				<c:otherwise><c:set var="bgColor" value="" /></c:otherwise>
			            			</c:choose>
	            					<td width="60" style="text-align:center;${bgColor}">
	            						<fmt:formatNumber var="decimalPoint" value="${(result.RWKTM % 1) % 0.1}" />
		            					<fmt:formatNumber value="${result.RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
	            					</th>
	            				</c:forEach>
	            			</c:when>
	            			<c:otherwise>
	            				<c:forEach var="header" begin="${beginNum}" end="${endNum}" varStatus="headerStatus">
			            			<fmt:parseDate value="${fn:join(fn:split(T_HEADER[headerStatus.index].BEGDA, '-'), '')}" pattern="yyyyMMdd" var="convertBegda" />
		            				<fmt:parseDate value="${fn:join(fn:split(T_HEADER[headerStatus.index].ENDDA, '-'), '')}" pattern="yyyyMMdd" var="convertEndda" />
			            			<c:choose>
			            				<c:when test="${T_HEADER[headerStatus.index].ZOVER eq 'X'}"><c:set var="bgColor" value="background-color:#FFB6C1;" /></c:when>
			            				<c:when test="${T_HEADER[headerStatus.index].ZOVER ne 'X' && convertSearchDate ge convertBegda && convertSearchDate le convertEndda}"><c:set var="bgColor" value="background-color:#E9FFD2;" /></c:when>
			            				<c:otherwise><c:set var="bgColor" value="" /></c:otherwise>
			            			</c:choose>
									<td width="60" style="text-align:center;${bgColor}">
										<fmt:formatNumber var="decimalPoint" value="${(T_HEADER[headerStatus.index].RWKTM % 1) % 0.1}" />
		            					<fmt:formatNumber value="${T_HEADER[headerStatus.index].RWKTM eq null ? '' : T_HEADER[headerStatus.index].RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
									</th>
								</c:forEach>
	            			</c:otherwise>
	            		</c:choose>
						<c:if test="${rowStatus.count eq 1 && !(S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W')}">
							<fmt:parseNumber var="limitNumber" value="52" />
							<fmt:parseNumber var="convertWKAVR" value="${E_WKAVR}" />
							<td width="60" style="text-align:center;<c:if test="${convertWKAVR ge limitNumber}">background-color:#FFB6C1;</c:if>" rowspan="${(rowCount * 2) - 1}">
								<fmt:formatNumber var="decimalPoint" value="${(E_WKAVR % 1) % 0.1}" />
            					<fmt:formatNumber value="${E_WKAVR - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
							</td>
						</c:if>
	            	</tr>
	            </c:forEach>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="15" height="10"></td>
		</tr>
		<tr>
			<td colspan="15" height="10"></td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="15">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="15"><b>2.세부 현황</b></td>
					</tr>
					<tr>
						<td colspan="15">
							<b>실근무시간 = 정상근무 + 초과근무 + 교육 - 휴게 - 비근무</b>
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
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">일자</th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">정상근무</th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">초과근무</th>
	            			<th width="60" style="background-color:#CEECF5;" rowspan="2">교육</th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">휴게시간</th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">비근무</th>
		            		<c:if test="${not empty T_NWKTYP}">
		            			<th width="60" style="background-color:#CEECF5;" colspan="${fn:length(T_NWKTYP)}">
	            					비근무
		            			</th>
		            		</c:if>
			            	<th width="60" style="background-color:#CEECF5;" rowspan="2">실 근무시간</th>
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
	            		<c:forEach var="body" items="${T_BODY}" varStatus="status">
	            		<c:choose>
	           				<c:when test="${fn:indexOf(body.DAYTX, '소계') > -1}">
	           					<c:set var="bgColor" value="background-color:#FFFF00;" />
	           				</c:when>
	           				<c:otherwise>
	           					<c:set var="bgColor" value="" />
	           				</c:otherwise>
	           			</c:choose>
		            	<tr>
	            			<td width="60" style="text-align:center;${bgColor}">${body.DAYTX}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.NORTM}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.OVRTM}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.EDUTM}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.BRKTM}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.NWKTM}</td>
	            			<c:if test="${not empty T_NWKTYP}">
		            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
			            			<td width="60" style="text-align:center;${bgColor}">${body[nwktyp.FLDNM]}</td>
			            		</c:forEach>
		            		</c:if>
		            		<fmt:parseNumber var="convertRWKTM" value="${body.RWKTM}" />
	            			<td width="60" style="text-align:center;background-color:${convertRWKTM ge limitNumber ? '#FFB6C1;' : '#FFFF00;'}">
	            				<fmt:formatNumber var="decimalPoint" value="${(body.RWKTM % 1) % 0.1}" />
	            				<fmt:formatNumber value="${body.RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
	            			</td>
		            	</tr>
	            		</c:forEach>
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
							※  실 근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.
						</td>
					</tr>
					<tr>
						<td colspan="15">
							※  현재일 기준으로 계획근무일정을 반영한 예상 근무시간입니다.
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</form>
</body>
</html>