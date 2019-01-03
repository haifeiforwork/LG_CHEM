<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트 Excel 현장직 월간
/*   Program ID   : D25WorkTimeReportHMonthExcel.jsp
/*   Description  : 실 근무시간 현장직 월간 레포트 Excel 화면
/*   Note         : 
/*   Creation     : 2018-06-25 성환희 [WorkTime52]
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
    response.setHeader("Content-Disposition","attachment;filename=WorkTimeReportHMonth.xls");
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
						<td colspan="15"><b>월간 실근무현황</b></td>
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
						<td colspan="15"><b>1.주당 평균 실 근무시간 현황</b></td>
					</tr>
					<%-- <tr>
						<td colspan="15"><b>근무제 유형 : ${E_WTCATTX} (${fn:join(fn:split(E_BEGDA, '-'), '.')} ~ ${fn:join(fn:split(E_ENDDA, '-'), '.')})</b></td>
					</tr> --%>
				</table>
			</td>
		</tr>
		<tr>
			<td width="16">&nbsp;</td>
			<td colspan="2">
	            <table border="1" cellpadding="0" cellspacing="1">
	            	<thead>
	            		<tr>
	            			<th width="60" style="background-color:#CEECF5;">정산기간</th>
	            			<th width="60" style="background-color:#CEECF5;">법정기준</th>
	            			<th width="60" style="background-color:#CEECF5;">실 근무시간</th>
	            			<th width="60" style="background-color:#CEECF5;">주당 평균 실 근무시간</th>
	            		</tr>
		            </thead>
		            <tbody>
		            <fmt:parseNumber var="limitNumber" value="52" />
		            <c:forEach var="tHeader" items="${T_HEADER}" varStatus="status">
		            	<tr <c:if test="${status.index eq 0}">style="background-color:#FFFF00;"</c:if>>
		            		<td width="60">${tHeader.PERIOD}</td>
		            		<c:choose>
		            			<c:when test="${status.index eq 0}"><td width="60" style="text-align:center;">${tHeader.MAXTM}</td></c:when>
		            			<c:otherwise><td width="60" style="background-color:#e1e1e1;">&nbsp;</td></c:otherwise>
		            		</c:choose>
	            			<td width="60" style="text-align:center;">
	            				<fmt:formatNumber var="decimalPoint" value="${(tHeader.RWKTM % 1) % 0.1}" />
         						<fmt:formatNumber value="${tHeader.RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
	            			</td>
	            			<fmt:parseNumber var="convertAVRTM" value="${tHeader.AVRTM}" />
	            			<td style="text-align:center;<c:if test="${convertAVRTM ge limitNumber}">background-color:#FFB6C1;</c:if>">
	            				<fmt:formatNumber var="decimalPoint" value="${(tHeader.AVRTM % 1) % 0.1}" />
            					<fmt:formatNumber value="${tHeader.AVRTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
	            			</td>
		            	</tr>
		            </c:forEach>
		            </tbody>
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
							주당 평균 실 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일)
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
						<td colspan="15"><b>2.세부 현황</td>
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
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">정상근무시간</th>
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
		            	<fmt:parseNumber var="limitNumber" value="52" />
	            		<c:forEach var="body" items="${T_BODY}" varStatus="status">
	            		<c:choose>
	           				<c:when test="${body.DATUM eq '0000-00-00'}">
	           					<c:set var="bgColor" value="background-color:#F6CEF5;" />
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
	            			<td width="60" style="text-align:center;${bgColor ne '' ? bgColor : convertRWKTM ge limitNumber ? 'background-color:#F6CEF5;' : 'background-color:#FFFF00;'}">
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