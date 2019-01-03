<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트 Excel - 사무직 월간
/*   Program ID   : D25WorkTimeReportSMonthExcel.jsp
/*   Description  : 실 근무시간 사무직 월간 레포트 Excel 화면
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
    response.setHeader("Content-Disposition", "ATTachment; Filename=WorkTimeReportSMonth.xls"); 
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
						<td colspan="15"><b>월간 근무실적현황</b></td>
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
						<td colspan="15"><b>1.주당 평균 근무시간 현황</b></td>
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
		            		<th width="60" style="background-color:#CEECF5;">구분</th>
		            		<th width="60" style="background-color:#CEECF5;">월 근무시간 (연차/보상휴가 포함)</th>
		            		<th width="60" style="background-color:#CEECF5;">주당 평균 근무시간</th>
		            	</tr>
		            </thead>
		            <tbody>
		            	<c:if test="${not empty ES_HEADER}">
		            	<tr class="borderRow">
		            		<th width="60">근무시간</th>
		            		<td width="60" style="text-align:center;">${ES_HEADER.MONSUM}</td>
		            		<td width="60" style="text-align:center;">${ES_HEADER.WEKAVR}</td>
		            	</tr>
		            	</c:if>
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
							주당 평균 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일)
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
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">정상근무</th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">초과근무</th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">휴게시간</th>
		            		<th width="60" style="background-color:#CEECF5;" rowspan="2">비근무차감</th>
		            		<c:if test="${not empty T_NWKTYP}">
		            			<th width="60" style="background-color:#CEECF5;" colspan="${fn:length(T_NWKTYP)}">
	            					연차/보상휴가
		            			</th>
		            		</c:if>
			            	<th width="60" style="background-color:#CEECF5;" rowspan="2">근무시간</th>
	            			<th width="60" style="background-color:#CEECF5;" rowspan="2">평일 누적근무시간</th>
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
            				<td width="60" style="text-align:center;${bgColor2}">${body.RWSUMA ne '0' ? body.RWSUMA : ''}</td>
		            	</tr>
		            	
		            	<c:set var="SUM_NORTM" value="${SUM_NORTM +body.NORTM}" />
		            	<c:set var="SUM_OVRTM" value="${SUM_OVRTM +body.OVRTM}" />
		            	<c:set var="SUM_EDUTM" value="${SUM_EDUTM +body.EDUTM}" />
		            	<c:set var="SUM_BRKTM" value="${SUM_BRKTM +body.BRKTM}" />
		            	<c:set var="SUM_NWKTM" value="${SUM_NWKTM +body.NWKTM}" />
		            	<c:set var="SUM_RWKTM" value="${SUM_RWKTM +body.RWKTM}" />
		            	
	            		</c:forEach>
	            		<tr style="background-color: #F6CEF5;">
	            			<td style="text-align:center;font-weight:bold;">합계</td>
	            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_NORTM}" pattern="0.00" /></td>
	            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_OVRTM}" pattern="0.00" /></td>
	            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_BRKTM}" pattern="0.00" /></td>
	            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_NWKTM}" pattern="0.00" /></td>
	            			<c:if test="${not empty T_NWKTYP}">
		            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
			            			<td style="text-align:center;font-weight:bold;">
			            				<c:set var="fName" value="SUM_NWKTYP${status.count}" scope="request" />
			            				<fmt:formatNumber value="${requestScope[fName]}" pattern="0.00" />
			            			</td>
			            		</c:forEach>
		            		</c:if>
	            			<td style="text-align:center;font-weight:bold;"><fmt:formatNumber value="${SUM_RWKTM}" pattern="0.00" /></td>
            				<td style="text-align:center;font-weight:bold;"></td>
	            		</tr>
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