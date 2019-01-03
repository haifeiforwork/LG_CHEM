<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Objects" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%!
    private String humanize(Map<String, Object> rowData, String key) {

        return WebUtil.humanize((String) rowData.get(key));
    }
%>
<%
    String attachmentName = "근무 입력 현황 - 주별";
    String filename = null;

    String userAgent = request.getHeader("User-Agent");
    if (userAgent.indexOf("Trident") > -1 || userAgent.indexOf("MSIE") > -1) {
        filename = URLEncoder.encode(attachmentName, "UTF-8").replaceAll("\\+", "%20");
    } else {
        filename = new String(attachmentName.getBytes("UTF-8"), "ISO-8859-1");
    }

    response.setHeader("Content-Disposition", "attachment; filename=" + filename + "(" + Objects.toString(request.getParameter("I_YYMON"), "").replaceAll("^(\\d{4})", "$1.").replaceAll("\\r|\\n", "") + ").xls");
    response.setContentType("application/vnd.ms-excel; charset=utf-8");
%>
<!DOCTYPE html>
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
.worktime-sum {background-color:#fff9db}
</style>
</head>
<body>
<table>
    <colgroup>
        <col style="width: 60px" />
        <col style="width:100px" /><%-- 이름 --%>
        <col style="width:200px" /><%-- 소속 --%>
        <col style="width: 60px" /><%-- 직책 --%>
        <col style="width:100px" /><%-- 계 --%><c:if test="${!empty TABLES and !empty TABLES.T_TLWEEKS}"><c:forEach items="${TABLES.T_TLWEEKS}">
        <col style="width:100px" /></c:forEach></c:if>
    </colgroup>
    <thead>
        <tr>
            <td></td>
            <td colspan="${fn:length(TABLES.T_TLWEEKS) + 4}"></td>
        </tr>
        <tr>
            <td></td>
            <th>이름</th>
            <th>소속</th>
            <th>직책</th>
            <th class="worktime-sum">계</th><c:if test="${!empty TABLES and !empty TABLES.T_TLWEEKS}"><c:forEach items="${TABLES.T_TLWEEKS}" var="weekData">
            <th>${weekData.TWEEKS}<br />${weekData.TPERIOD}</th></c:forEach></c:if>
        </tr>
    </thead>
    <tbody>
<c:choose><c:when test="${empty TABLES or empty TABLES.T_ORGWEEK}">
        <tr>
            <td></td>
            <td colspan="${fn:length(TABLES.T_TLWEEKS) + 4}">해당하는 데이타가 존재하지 않습니다.</td>
        </tr>
</c:when><c:otherwise>
<%
    List<Map<String, Object>> list = (List<Map<String, Object>>) ((Map<String, Object>) request.getAttribute("TABLES")).get("T_ORGWEEK");
    for (Map<String, Object> rowData : list) {
%>
        <tr><c:set var="rowData" value="<%= rowData %>" />
            <th></th>
            <td><%= rowData.get("ENAME") %></td><%-- 이름 --%>
            <td><%= rowData.get("ORGTX") %></td><%-- 소속 --%>
            <td><%= rowData.get("JIKKT") %></td><%-- 직책 --%>
            <td class="worktime-sum"><%= humanize(rowData, "CTOTWKS") %></td><%-- 계 --%>
            <%
                List<Map<String, Object>> weeks = (List<Map<String, Object>>) ((Map<String, Object>) request.getAttribute("TABLES")).get("T_TLWEEKS");
                for (int i = 1; i <= weeks.size(); i++) {
            %>
            <td><%= humanize(rowData, "CWKS0" + i) %></td>
            <%
                }
            %>
        </tr>
<%
    }
%>
</c:otherwise></c:choose>
    </tbody>
</table>
</body>
</html>