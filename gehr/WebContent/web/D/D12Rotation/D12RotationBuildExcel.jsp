<%/***************************************************************************************
*		System Name	: g-HR
*   	1Depth Name 	: Organization & Staffing
*   	2Depth Name 	: Org.Unit/Level
*   	Program Name	: 소속별/직급별 인원현황
*   	Program ID   	: F01DeptPositionClassExcel.jsp
*   	Description  	: 소속별/직급별 인원현황 Excel 저장을 위한 jsp 파일
*   	Note         		: 없음
*   	Creation     	:
*		Update			:
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.lang.reflect.*" %>
<%@ page import="java.util.Vector" %>
<%
    request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");                           	// 세션

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=excel_Layout_Temp.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body>
<table>
	<tr style="border: 1px; border-color: black;">
		<td><spring:message code="LABEL.D.D12.0017"/><!-- 사원번호--></td>
		<td><spring:message code="LABEL.D.D15.0206"/><!-- 일자--></td>
		<td><spring:message code="LABEL.D.D12.0067"/><!-- 전일지시자--></td>
		<td><spring:message code="LABEL.D.D12.0020"/><!-- 시작시간--></td>
	    <td><spring:message code="LABEL.D.D12.0021"/><!-- 종료시간--></td>
        <td><spring:message code="LABEL.D.D12.0068"/> <!-- 휴식시간1--></td>
        <td><spring:message code="LABEL.D.D12.0069"/> <!-- 휴식종료1--></td>
        <td><spring:message code="LABEL.D.D12.0070"/> <!-- 휴식시간2--></td>
        <td><spring:message code="LABEL.D.D12.0071"/> <!-- 휴식종료2--></td>
        <td><spring:message code="LABEL.D.D12.0072"/> <!-- 사유--></td>
	</tr>
	<tr>
		<td style='mso-number-format:"\@";'>10000001</td>
		<td style='mso-number-format:"\@";'>20161121</td>
		<td style='mso-number-format:"\@";'>X</td>
		<td style='mso-number-format:"\@";'>200000</td>
		<td style='mso-number-format:"\@";'>220000</td>
		<td style='mso-number-format:"\@";'></td>
		<td style='mso-number-format:"\@";'></td>
		<td style='mso-number-format:"\@";'></td>
		<td style='mso-number-format:"\@";'></td>
		<td style='mso-number-format:"\@";'> TEST</td>
	</tr>
</table>
</body>
</html>
