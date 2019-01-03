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
    String attachmentName = "근무 입력 현황 - 월별";
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
table thead th, table tbody td {height:20pt; border:solid 0.1pt #000000; font-size:9pt; text-align:center; vertical-align:middle}
table thead th {background-color:#f5f5f5}
table thead td, table tbody th {border:none}
.worktime-sum {background-color:#fff9db}
.green {color:#40c057}
.yellow {color:#fab005}
.red {color:#fa5252}
</style>
</head>
<body>
<table>
    <colgroup>
        <col style="width: 60px" />
        <col style="width:100px" /><%-- 이름 --%>
        <col style="width:200px" /><%-- 소속 --%>
        <col style="width:100px" /><%-- 직책 --%>
        <col style="width:150px" /><%-- 당월근무시간(연차/보상휴가 포함) --%>
        <col style="width:100px" /><%-- 월 기본 근무시간 --%>
        <col style="width:190px" /><%-- 월 기본 근무시간 잔여 --%>
        <col style="width:100px" /><%-- 법정 최대 한도 근무시간 --%>
        <col style="width:120px" /><%-- 법정 최대 한도 근무시간 잔여 --%>
        <col style="width:100px" /><%-- 비근무 --%>
        <col style="width:100px" /><%-- 업무재개 --%>
        <col style="width:100px" /><%-- 인정 근무시간 --%>
        <col style="width:100px" /><%-- GAP(개인-인정) --%>
        <col style="width: 40px" /><%-- 상태 --%>
    </colgroup>
    <thead>
        <tr>
            <td></td>
            <td colspan="13"></td>
        </tr>
        <tr>
            <td></td>
            <th rowspan="3">이름</th>
            <th rowspan="3">소속</th>
            <th rowspan="3">직책</th>
            <th colspan="7">개인입력</th>
            <th rowspan="3">인정<br />근무시간</th>
            <th rowspan="3">GAP<br />(개인 - 인정)</th>
            <th rowspan="3">상태</th>
        </tr>
        <tr>
            <td></td>
            <th rowspan="2">당월근무시간<br />(연차/보상휴가 포함)</th>
            <th colspan="2">월 기본 근무시간</th>
            <th colspan="2">법정 최대 한도 근무시간</th>
            <th colspan="2">기타시간</th>
        </tr>
        <tr>
            <td></td>
            <th>기본</th>
            <th>잔여</th>
            <th>기본</th>
            <th>잔여</th>
            <th>비근무</th>
            <th>업무재개</th>
        </tr>
    </thead>
    <tbody>
<c:choose><c:when test="${empty TABLES or empty TABLES.T_ORGMONT}">
        <tr>
            <td></td>
            <td colspan="13">해당하는 데이타가 존재하지 않습니다.</td>
        </tr>
</c:when><c:otherwise>
<%
    List<Map<String, Object>> list = (List<Map<String, Object>>) ((Map<String, Object>) request.getAttribute("TABLES")).get("T_ORGMONT");
    for (Map<String, Object> rowData : list) {
%>
        <tr><c:set var="rowData" value="<%= rowData %>" />
            <th></th>
            <td>${ rowData.ENAME }</td><%-- 이름 --%>
            <td>${ rowData.ORGTX }</td><%-- 소속 --%>
            <td>${ rowData.JIKKT }</td><%-- 직책 --%>
            <td class="worktime-sum"><%= humanize(rowData, "CCOLWT") %></td><%-- 당월근무시간(유급휴가포함) --%>
            <td><%= humanize(rowData, "CBASWT") %></td><%-- 월 기본 근무시간 --%>
            <td><%= humanize(rowData, "CBRMWT") %></td><%-- 월 기본 근무시간 잔여 --%>
            <td><%= humanize(rowData, "CMAXWT") %></td><%-- 법정 최대 한도 근무시간 --%>
            <td><%= humanize(rowData, "CMRMWT") %></td><%-- 법정 최대 한도 근무시간 잔여 --%>
            <td><%= humanize(rowData, "CABSTD") %></td><%-- 비근무 --%>
            <td><%= humanize(rowData, "CAREWK") %></td><%-- 업무재개 --%>
            <td><%= humanize(rowData, "CRWKTM") %></td><%-- 회사인정 근무시간 --%>
            <td><%= humanize(rowData, "CGAPTM") %></td><%-- GAP(개인 - 회사) --%>
            <td class="${rowData.WSTATS eq 1 ? 'green' : (rowData.WSTATS eq 2 ? 'yellow' : (rowData.WSTATS eq 3 ? 'red' : 'none'))}">●</td><%-- 상태 --%>
        </tr>
<%
    }
%>
</c:otherwise></c:choose>
    </tbody>
    <tfoot>
        <tr>
            <td></td>
            <td colspan="13"></td>
        </tr>
        <tr>
            <td></td>
            <td colspan="13">
                - 상태 설명 : 월 기본 근무시간 잔여 평균<br /><br />
                <span class="green" >●</span> 7시간 이상 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <span class="yellow">●</span> 6시간 이상 7시간 미만 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <span class="red"   >●</span> 6시간 미만
            </td>
        </tr>
    </tfoot>
</table>
</body>
</html>