<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:choose><c:when test="${TPGUB eq 'C'}">

<%-- 사무직 실근무시간 현황 table 시작 --%>
<table class="listTable worktime">
    <colgroup>
        <col class="col_20p" />
        <col class="col_30p" />
        <col class="col_30p" />
        <col class="col_20p" />
    </colgroup>
    <thead>
        <tr>
            <th>유형구분</th>
            <th>신청</th>
            <th>결재</th>
            <th>실적확정</th>
        </tr>
    </thead>
    <tbody>
        <c:if test="${empty T_LIST}">
        <tr class="oddRow">
            <td colspan="4">해당하는 데이타가 존재하지 않습니다.</td>
        </tr>
        </c:if>
        <c:forEach items="${T_LIST}" var="item">
        <tr>
            <td>${item.TYPTX}</td>
            <td>${item.REQTX}</td>
            <td>${item.APPTX}</td>
            <td>${item.AFTTX}</td>
        </tr>
        </c:forEach>
    </tbody>
</table>
<%-- 사무직 실근무시간 현황 table 종료 --%>

</c:when><c:when test="${TPGUB eq 'D'}">

<%-- 현장직 실근무시간 현황 table 시작 --%>
<table class="listTable worktime">
    <colgroup>
        <col class="col_34p" />
        <col class="col_33p" />
        <col class="col_33p" />
    </colgroup>
    <thead>
        <tr>
            <th>유형구분</th>
            <th>신청</th>
            <th>결재</th>
        </tr>
    </thead>
    <tbody>
        <c:if test="${empty T_LIST}">
        <tr class="oddRow">
            <td colspan="3">해당하는 데이타가 존재하지 않습니다.</td>
        </tr>
        </c:if>
        <c:forEach items="${T_LIST}" var="item">
        <tr>
            <td>${item.TYPTX}</td>
            <td>${item.REQTX}</td>
            <td>${item.APPTX}</td>
        </tr>
        </c:forEach>
    </tbody>
</table>
<%-- 현장직 실근무시간 현황 table 종료 --%>

</c:when></c:choose>