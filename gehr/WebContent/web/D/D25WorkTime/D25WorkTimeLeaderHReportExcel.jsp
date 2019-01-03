<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 실근무 실적현황 현장직 Excel
/*   Program ID   : D25WorkTimeLeaderHReportExcel.jsp
/*   Description  : 실근무 실적현황 현장직 Excel 화면
/*   Note         : 
/*   Creation     : 2018-07-25 성환희 [WorkTime52]
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
    response.setHeader("Content-Disposition","attachment;filename=WorkTimeLeaderHReport.xls");
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
						<td colspan="15"><b>근무 실적 현황</td>
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
							신분 : 현장직
						</td>
					</tr>
					<tr>
						<td colspan="15">
							조회기준일 : <c:out value="${SEARCH_DATE}" />
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
			<td colspan="2">
				<table border="1" cellpadding="0" cellspacing="1">
					<thead>
						<tr>
							<%-- <th width="60" rowspan="2" style="background-color:#CEECF5;">근무제유형</th> --%>
							<th width="60" rowspan="2" style="background-color:#CEECF5;">구분</th>
							<th width="60" rowspan="2" style="background-color:#CEECF5;">사번</th>
							<th width="60" rowspan="2" style="background-color:#CEECF5;">이름</th>
							<th width="60" rowspan="2" style="background-color:#CEECF5;">소속</th>
							<%-- <th width="60" rowspan="2" style="background-color:#CEECF5;">사업장 탄력/정상 근무기간</th>
							<th width="60" rowspan="2" style="background-color:#CEECF5;">개인 탄력/정상 근무기간</th> --%>
							<th width="60" rowspan="2" style="background-color:#CEECF5;">주당 실근무시간<br/>${T_RESULT[0].WTEXT}</th>
							<th width="60" colspan="3" style="background-color:#CEECF5;">기간별 주 평균시간</th>
						</tr>
						<tr>
							<th width="60" style="background-color:#CEECF5;">기준</th>
							<th width="60" style="background-color:#CEECF5;">실 근무시간</th>
							<th width="60" style="background-color:#CEECF5;">주평균시간</th>
						</tr>
		            </thead>
		            <tbody>
		            <c:if test="${not empty T_RESULT}">
						<fmt:parseNumber var="limitNumber" value="52" />
						<c:forEach var="result" items="${T_RESULT}" varStatus="status">
							<tr class="borderRow">
								<%-- <td width="60" style="text-align:center;">${result.WTCATTX}</td> --%>
								<td width="60" style="text-align:center;">${result.ADJUNTTX}</td>
								<td width="60" style="text-align:center;">${result.PERNR}</td>
								<td width="60" style="text-align:center;">${result.ENAME}</td>
								<td width="60" style="text-align:center;">${result.ORGEHTX}</td>
								<%-- <td width="60" style="text-align:center;">${result.OTEXT}</td>
								<td width="60" style="text-align:center;">${result.RTEXT}</td> --%>
								<td width="60" style="text-align:center;">
									<fmt:formatNumber var="decimalPoint" value="${(result.WRWKTM % 1) % 0.1}" />
         							<fmt:formatNumber value="${result.WRWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
								</td>
								<td width="60" style="text-align:center;">${result.RMAXTM}</td>
								<td width="60" style="text-align:center;">
									<fmt:formatNumber var="decimalPoint" value="${(result.RRWKTM % 1) % 0.1}" />
         							<fmt:formatNumber value="${result.RRWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
								</td>
								<fmt:parseNumber var="convertRAVRTM" value="${result.RAVRTM}" />
								<td width="60" style="text-align:center;<c:if test="${convertRAVRTM ge limitNumber}">background-color:#F6CEF5;</c:if>">
									<fmt:formatNumber var="decimalPoint" value="${(result.RAVRTM % 1) % 0.1}" />
            						<fmt:formatNumber value="${result.RAVRTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
								</td>
							</tr>
						</c:forEach>
					</c:if>
		            </tbody>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>