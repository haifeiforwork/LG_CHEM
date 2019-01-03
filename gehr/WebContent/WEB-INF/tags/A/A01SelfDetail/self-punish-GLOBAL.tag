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

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(punishList) - 1}"/>

<h2 class="subtitle"><spring:message code="MSG.A.A06.0008"/><%--징계--%></h2>


<!--징계내역 리스트 테이블 시작-->
<div class="listArea">
    <div class="table">
        <table class="listTable">
            <colgroup>
                <col width="180">
                <col >
                <col >
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.A.A06.0010"/><%--징계기간--%></th>
                <th><spring:message code="MSG.A.A06.0009"/><%--징계유형--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A06.0013"/><%--징계사유--%></th>
            </tr>
            </thead>
            <%--@elvariable id="punishList" type="java.util.Vector"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${punishList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}">
                    <td>${f:printDate(row.BEGDA)} ${f:printDate(row.ENDDA) != "" ? "~" : ""} ${f:printDate(row.ENDDA)}</td>
                    <td>${row.PUNTX}</td>
                    <td class="lastCol" >${row.PUNRS}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${punishList}" col="5" />
            </c:if>
        </table>
    </div>
</div>
<!--징계내역 리스트 테이블 끝-->