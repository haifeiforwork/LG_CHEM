<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderWeeklyExcel.jsp
/*   Description  : 주별 근무 입력 현황 Excel
/*   Note         : 
/*   Creation     : 2018-06-30 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/
--%><%
%><%@ page contentType="text/html; charset=utf-8" %><%
%><%@ page import="java.net.URLEncoder" %><%
%><%@ page import="org.apache.commons.lang.ObjectUtils" %><%
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %><%
%><%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %><%
%><%@ include file="/web/D/D25WorkTime/D25WorkTimeCommonPreprocess.jsp" %><%

    String attachmentName = g.getMessage("LABEL.D.D25.N1009") + " - " + g.getMessage("TAB.COMMON.0122"); // 근무 입력 현황 - 주별
    String filename = null;

    String userAgent = request.getHeader("User-Agent");
    if (userAgent.indexOf("Trident") > -1 || userAgent.indexOf("MSIE") > -1) {
        filename = URLEncoder.encode(attachmentName, "UTF-8").replaceAll("\\+", "%20");
    } else {
        filename = new String(attachmentName.getBytes("UTF-8"), "ISO-8859-1");
    }

    response.setHeader("Content-Disposition", "attachment; filename=" + filename + "(" + ObjectUtils.toString(request.getParameter("I_YYMON")).replaceAll("^(\\d{4})", "$1.").replaceAll("\\r|\\n", "") + ").xls");
    response.setContentType("application/vnd.ms-excel; charset=utf-8");

    request.setAttribute("hours", g.getMessage("LABEL.D.D25.N7001")); // 시간
    request.setAttribute("minutes", g.getMessage("LABEL.COMMON.0039")); // 분

%><!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=utf-8">
<style type="text/css">
html * {font-family:'맑은 고딕'}
body {margin:0; padding:0; background-color:#ffffff}
br {mso-data-placement:same-cell}
table thead th {height:35pt; border:solid 0.1pt #000000; font-size:9pt; text-align:center; vertical-align:middle}
table tbody td {height:20pt; border:solid 0.1pt #000000; font-size:9pt; text-align:center; vertical-align:middle}
table thead th {background-color:#f5f5f5}
table thead td, table tbody th {border:none}
.worktime-sum {background-color:#faf6e1}
.green {color:#40c057}
.yellow {color:#fab005}
.red {color:#fa5252}
</style>
</head>
<body>
<table>
    <colgroup>
        <col style="width: 60pt" />
        <col style="width:100pt" /><%-- 이름 --%>
        <col style="width:200pt" /><%-- 소속 --%>
        <col style="width: 60pt" /><%-- 직책 --%>
        <col style="width:100pt" /><%-- 계 --%><c:if test="${!empty TABLES and !empty TABLES.T_TLWEEKS}"><c:forEach items="${TABLES.T_TLWEEKS}">
        <col style="width:100pt" /></c:forEach></c:if>
    </colgroup>
    <thead>
        <tr>
            <td></td>
            <td colspan="${fn:length(TABLES.T_TLWEEKS) + 4}"></td>
        </tr>
        <tr>
            <td></td>
            <th><spring:message code="LABEL.D.D25.N2172" /></th><%-- 이름 --%>
            <th><spring:message code="LABEL.D.D25.N2173" /></th><%-- 소속 --%>
            <th><spring:message code="LABEL.D.D25.N2174" /></th><%-- 직책 --%>
            <th class="worktime-sum"><spring:message code="LABEL.D.D25.N2116" /></th><%-- 계 --%><c:if test="${!empty TABLES and !empty TABLES.T_TLWEEKS}"><c:forEach items="${TABLES.T_TLWEEKS}" var="weekData">
            <th>${weekData.TWEEKS}<br />${weekData.TPERIOD}</th></c:forEach></c:if>
        </tr>
    </thead>
    <tbody>
<c:choose><c:when test="${empty TABLES or empty TABLES.T_ORGWEEK}">
        <tr>
            <td></td>
            <td colspan="${fn:length(TABLES.T_TLWEEKS) + 4}"><spring:message code="MSG.COMMON.0004"/></td><%-- 해당하는 데이타가 존재하지 않습니다. --%>
        </tr>
</c:when><c:otherwise><c:forEach items="${TABLES.T_ORGWEEK}" var="rowData">
        <tr>
            <th></th>
            <td>${ rowData.ENAME }</td><%-- 이름 --%>
            <td>${ rowData.ORGTX }</td><%-- 소속 --%>
            <td>${ rowData.JIKKT }</td><%-- 직책 --%>
            <td class="worktime-sum">${ f:humanize(rowData.CTOTWKS, hours, minutes) }</td><%-- 계 --%><c:forEach items="${TABLES.T_TLWEEKS}" varStatus="week">
            <td>${ f:humanize(rowData[fn:replace('CWKS0#', '#', week.count)], hours, minutes) }</td></c:forEach>
        </tr>
</c:forEach></c:otherwise></c:choose>
    </tbody>
</table>
</body>
</html>