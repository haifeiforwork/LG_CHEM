<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Calendar" %>
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

    private int getDay(String day) {

        day = day.replaceAll("[^\\d]", "");

        Calendar calendar = Calendar.getInstance();
        calendar.set(Integer.parseInt(day.substring(0, 4)), Integer.parseInt(day.substring(4, 6)) - 1, Integer.parseInt(day.substring(6, 8)));

        return calendar.get(Calendar.DAY_OF_WEEK);
    }
%>
<%
    String attachmentName = "근무 입력 현황 - 일별";
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
.holiday {background-color:#fff3f3}
.weekday {background-color:#ffffff}
.weekend {background-color:#f6f6f6}
.worktime-sum {background-color:#fff9db}
</style>
</head>
<body>
<table>
    <colgroup>
        <col style="width: 60pt" />
        <col style="width:100pt" /><%-- 이름 --%>
        <col style="width:200pt" /><%-- 소속 --%>
        <col style="width: 60pt" /><%-- 직책 --%>
        <col style="width: 40pt" /><%-- 계 --%><c:if test="${!empty TABLES and !empty TABLES.T_TLDAYS}"><c:forEach items="${TABLES.T_TLDAYS}">
        <col style="width: 30pt" /></c:forEach></c:if>
    </colgroup>
    <thead>
        <tr>
            <td></td>
            <td colspan="${fn:length(TABLES.T_TLDAYS) + 4}"></td>
        </tr>
        <tr>
            <td></td>
            <th>이름</th>
            <th>소속</th>
            <th>직책</th>
            <th class="worktime-sum">계</th>
            <c:if test="${!empty TABLES and !empty TABLES.T_TLDAYS}">
            <%
                List<Map<String, Object>> days = (List<Map<String, Object>>) ((Map<String, Object>) request.getAttribute("TABLES")).get("T_TLDAYS");
                for (Map<String, Object> dayData : days) {
                    boolean isWeekend = getDay(Objects.toString(dayData.get("WKDAT"), "")) % 6 == 1;
                    String styleClass = "X".equals(Objects.toString(dayData.get("HOLID"), "")) ? "holiday" : (isWeekend ? "weekend" : "weekday");
            %>
            <th class="<%= styleClass %>"><%= dayData.get("WDAYS") %><br />(<%= dayData.get("WOTAG") %>)</th>
            <%
                }
            %>
            </c:if>
        </tr>
    </thead>
    <tbody>
<c:choose><c:when test="${empty TABLES or empty TABLES.T_ORGDAYS}">
        <tr>
            <td></td>
            <td colspan="${fn:length(TABLES.T_TLDAYS) + 4}">해당하는 데이타가 존재하지 않습니다.</td>
        </tr>
</c:when><c:otherwise>
<%
    List<Map<String, Object>> list = (List<Map<String, Object>>) ((Map<String, Object>) request.getAttribute("TABLES")).get("T_ORGDAYS");
    for (Map<String, Object> rowData : list) {
%>
        <tr>
            <th></th>
            <td><%= rowData.get("ENAME") %></td><%-- 이름 --%>
            <td><%= rowData.get("ORGTX") %></td><%-- 소속 --%>
            <td><%= rowData.get("JIKKT") %></td><%-- 직책 --%>
            <td class="worktime-sum"><%= rowData.get("CTOTDW") %></td><%-- 계 --%>
            <%
                List<Map<String, Object>> days = (List<Map<String, Object>>) ((Map<String, Object>) request.getAttribute("TABLES")).get("T_TLDAYS");
                for (Map<String, Object> dayData : days) {
                    boolean isWeekend = getDay(Objects.toString(dayData.get("WKDAT"), "")) % 6 == 1;
                    String styleClass = "X".equals(Objects.toString(dayData.get("HOLID"), "")) ? "holiday" : (isWeekend ? "weekend" : "weekday");
            %>
            <td class="<%= styleClass %>"><%= rowData.get("CDWS" + dayData.get("WDAYS")) %></td>
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