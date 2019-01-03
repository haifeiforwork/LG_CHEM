<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트 Excel - 사무직 주간
/*   Program ID   : D25WorkTimeReportSWeekExcel.jsp
/*   Description  : 실 근무시간 사무직 주간 레포트 Excel 화면
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
    response.setHeader("Content-Disposition","attachment;filename=WorkTimeReportSWeek.xls");
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
						<td colspan="15"><b>주간 근무현황</b></td>
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
						<td colspan="15"><b>1.주당 근무시간 현황</b></td>
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
		            	<c:if test="${not empty T_HEADER}">
		            		<th width="60" style="background-color:#CEECF5;">구분</th>
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
		            		<th width="60">근무시간</th>
		            		<fmt:parseNumber var="limitNumber" value="64" />
		            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
		            			<fmt:parseNumber var="convertRWKTM" value="${head.RWKTM}" />
		            			<c:choose>
		            				<c:when test="${convertRWKTM ge limitNumber}"><c:set var="bgColor" value="background-color:#F6CEF5;" /></c:when>
		            				<c:otherwise><c:set var="bgColor" value="" /></c:otherwise>
		            			</c:choose>
		            			<c:choose>
		            				<c:when test="${fn:length(T_HEADER) eq status.count}">
		            					<td width="60" style="text-align:center;background-color:#FFFF00;">${head.RWKTM}</td>
		            				</c:when>
		            				<c:otherwise>
		            					<td width="60" style="text-align:center;${bgColor}">${head.RWKTM}</td>
		            				</c:otherwise>
		            			</c:choose>
		            		</c:forEach>
		            	</c:if>
		            	</tr>
		            </tbody>
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
							<b>근무시간 = 정상근무 + 초과근무 - 휴게 - 비근무</b>
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
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">휴게시간</th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">비근무차감</th>
		            		<c:if test="${not empty T_NWKTYP}">
		            			<th width="60" style="background-color:#CEECF5;" colspan="${fn:length(T_NWKTYP)}">
		            				<c:choose>
	            						<c:when test="${EMPGUB eq 'S'}">유급휴가</c:when>
	            						<c:otherwise>비근무</c:otherwise>
	            					</c:choose>
		            			</th>
		            		</c:if>
			            	<th width="60" style="background-color:#CEECF5;" rowspan="2">근무시간</th>
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
	           				<c:when test="${body.ZWEEK ne '00'}">
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
	            			<td width="60" style="text-align:center;${bgColor}">${body.BRKTM}</td>
	            			<td width="60" style="text-align:center;${bgColor}">${body.NWKTM}</td>
	            			<c:if test="${not empty T_NWKTYP}">
		            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
			            			<td width="60" style="text-align:center;${bgColor}">${body[nwktyp.FLDNM]}</td>
			            		</c:forEach>
		            		</c:if>
		            		<fmt:parseNumber var="convertRWKTM" value="${body.RWKTM}" />
	            			<td width="60" style="text-align:center;background-color:${convertRWKTM ge limitNumber ? '#F6CEF5;' : '#FFFF00;'}">${body.RWKTM}</td>
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
							※  근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</form>
</body>
</html>