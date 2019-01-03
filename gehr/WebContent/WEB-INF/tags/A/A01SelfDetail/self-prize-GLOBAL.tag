<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(prizeList) - 1}"/>

<h2 class="subtitle"><spring:message code="MSG.A.A06.0001"/><%--포상--%></h2>

<!-- 포상내역 리스트 테이블 시작-->
<div class="listArea">
    <div class="table">
        <table class="listTable">
            <thead>
            <tr>
                <th style="width:80px;"><spring:message code="MSG.A.A06.0003"/><%--Award Date--%></th>
                <th style="width:280px;"><spring:message code="MSG.A.A06.0014"/><%--Award Name--%></th>
                <th style="width:80px;"><spring:message code="MSG.A.A06.0015"/><%--Award Type--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A06.0016"/><%--Description--%></th>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="prizeList" type="java.util.Vector<hris.A.A06PrizDetailData>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${prizeList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}">
                    <td>${f:printDate(row.BEGDA)}</td>
                    <td>${row.AWRD_NAME}</td>
                    <td>${row.AWDTX}</td>
                    <td class="lastCol">${row.AWRD_DESC}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${prizeList}" col="4" />
            </c:if>
        </table>
        </table>
    </div>
</div>
