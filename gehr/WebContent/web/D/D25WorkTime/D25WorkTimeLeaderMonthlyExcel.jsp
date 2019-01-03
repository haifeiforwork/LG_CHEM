<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderMonthlyExcel.jsp
/*   Description  : 월별 근무 입력 현황 Excel
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

    String attachmentName = g.getMessage("LABEL.D.D25.N1009") + " - " + g.getMessage("TAB.COMMON.0121"); // 근무 입력 현황 - 월별
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
table thead th, table tbody td {height:20pt; border:solid 0.1pt #000000; font-size:9pt; text-align:center; vertical-align:middle}
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
        <col style="width: 90pt" /><%-- 당월근무시간(유급휴가포함) --%>
        <col style="width: 90pt" /><%-- 월 기본 근무시간 --%>
        <col style="width:120pt" /><%-- 월 기본 근무시간 잔여 --%>
        <col style="width: 90pt" /><%-- 법정 최대 한도 근무시간 --%>
        <col style="width:120pt" /><%-- 법정 최대 한도 근무시간 잔여 --%>
        <col style="width: 90pt" /><%-- 비근무 --%>
        <col style="width: 90pt" /><%-- 업무재개 --%>
        <col style="width: 90pt" /><%-- 회사인정 근무시간 --%>
        <col style="width: 90pt" /><%-- GAP(개인 - 회사) --%>
        <col style="width: 40pt" /><%-- 상태 --%>
    </colgroup>
    <thead>
        <tr>
            <td></td>
            <td colspan="13"></td>
        </tr>
        <tr>
            <td></td>
            <th rowspan="3"><spring:message code="LABEL.D.D25.N2172" /></th><%-- 이름 --%>
            <th rowspan="3"><spring:message code="LABEL.D.D25.N2173" /></th><%-- 소속 --%>
            <th rowspan="3"><spring:message code="LABEL.D.D25.N2174" /></th><%-- 직책 --%>
            <th colspan="7"><spring:message code="LABEL.D.D25.N2183" /></th><%-- 개인입력 --%>
            <th><spring:message code="LABEL.D.D25.N2184" /></th><%-- 회사인정 --%>
            <th rowspan="3"><spring:message code="LABEL.D.D25.N2186" /></th><%-- GAP<br />(개인 - 회사) --%>
            <th rowspan="3" class="lastCol"><spring:message code="LABEL.D.D25.N2187" /></th><%-- 상태 --%>
        </tr>
        <tr>
            <td></td>
            <th rowspan="2"><spring:message code="LABEL.D.D25.N2175" /></th><%-- 당월근무시간<br />(유급휴가포함) --%>
            <th colspan="2"><spring:message code="LABEL.D.D25.N2176" /></th><%-- 월 기본 근무시간 --%>
            <th colspan="2"><spring:message code="LABEL.D.D25.N2177" /></th><%-- 법정 최대 한도 근무시간 --%>
            <th colspan="2"><spring:message code="LABEL.D.D25.N2178" /></th><%-- 기타 시간 --%>
            <th rowspan="2"><spring:message code="LABEL.D.D25.N2185" /></th><%-- 근무시간 --%>
        </tr>
        <tr>
            <td></td>
            <th><spring:message code="LABEL.D.D25.N2179" /></th><%-- 기본 --%>
            <th><spring:message code="LABEL.D.D25.N2180" /></th><%-- 잔여 --%>
            <th><spring:message code="LABEL.D.D25.N2179" /></th><%-- 기본 --%>
            <th><spring:message code="LABEL.D.D25.N2180" /></th><%-- 잔여 --%>
            <th><spring:message code="LABEL.D.D25.N2181" /></th><%-- 비근무 --%>
            <th><spring:message code="LABEL.D.D25.N2182" /></th><%-- 업무재개 --%>
        </tr>
    </thead>
    <tbody>
<c:choose><c:when test="${empty TABLES or empty TABLES.T_ORGMONT}">
        <tr>
            <td></td>
            <td colspan="13"><spring:message code="MSG.COMMON.0004"/></td><%-- 해당하는 데이타가 존재하지 않습니다. --%>
        </tr>
</c:when><c:otherwise><c:forEach items="${TABLES.T_ORGMONT}" var="rowData">
        <tr>
            <th></th>
            <td>${ rowData.ENAME }</td><%-- 이름 --%>
            <td>${ rowData.ORGTX }</td><%-- 소속 --%>
            <td>${ rowData.JIKKT }</td><%-- 직책 --%>
            <td class="worktime-sum">${ f:humanize(rowData.CCOLWT, hours, minutes)  }</td><%-- 당월근무시간(유급휴가포함) --%>
            <td>${ f:humanize(rowData.CBASWT, hours, minutes) }</td><%-- 월 기본 근무시간 --%>
            <td>${ fn:replace(f:humanize(rowData.CBRMWT, hours, minutes), "-", "&Delta; ") }</td><%-- 월 기본 근무시간 잔여 --%>
            <td>${ f:humanize(rowData.CMAXWT, hours, minutes) }</td><%-- 법정 최대 한도 근무시간 --%>
            <td>${ fn:replace(f:humanize(rowData.CMRMWT, hours, minutes), "-", "&Delta; ") }</td><%-- 법정 최대 한도 근무시간 잔여 --%>
            <td>${ f:humanize(rowData.CABSTD, hours, minutes) }</td><%-- 비근무 --%>
            <td>${ f:humanize(rowData.CAREWK, hours, minutes) }</td><%-- 업무재개 --%>
            <td>${ f:humanize(rowData.CRWKTM, hours, minutes) }</td><%-- 회사인정 근무시간 --%>
            <td>${ f:humanize(rowData.CGAPTM, hours, minutes) }</td><%-- GAP(개인 - 회사) --%>
            <td class="${rowData.WSTATS eq 1 ? 'green' : (rowData.WSTATS eq 2 ? 'yellow' : (rowData.WSTATS eq 3 ? 'red' : 'none'))}">●</td><%-- 상태 --%>
        </tr>
</c:forEach></c:otherwise></c:choose>
    </tbody>
    <tfoot>
        <tr>
            <td></td>
            <td colspan="13"></td>
        </tr>
        <tr>
            <td></td>
            <td colspan="13">
                - <spring:message code="MSG.D.D25.N0043" /> : <spring:message code="MSG.D.D25.N0044" /><%-- 상태 설명 : 월 기본 근무시간 잔여 평균 --%><br /><br />
                <span class="green" >●</span> <spring:message code="MSG.D.D25.N0045" /> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <span class="yellow">●</span> <spring:message code="MSG.D.D25.N0046" /> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <span class="red"   >●</span> <spring:message code="MSG.D.D25.N0047" />
            </td>
        </tr>
    </tfoot>
</table>
</body>
</html>