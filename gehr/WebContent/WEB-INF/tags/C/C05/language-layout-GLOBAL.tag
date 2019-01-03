<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="language" tagdir="/WEB-INF/tags/C/C05" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(langList) - 1}"/>

<h2 class="subtitle"><spring:message code="MSG.C.C05.0001" /><%--Foreign Language Ability--%></h2>

<div class="listArea">
    <div class="table">
        <table class="listTable">
            <colgroup>
                <col>
                <col width="120">
                <col width="100">
                <col width="100">
            </colgroup>
            <thead>
            <tr>
                <th ><spring:message code="MSG.C.C05.0002" /><%--Language Certificate Name--%></th>
                <th ><spring:message code="MSG.C.C05.0003" /><%--Date of&nbsp;&nbsp;Acquisition--%></th>
                <th ><spring:message code="MSG.C.C05.0004" /><%--Scale--%></th>
                <th class="lastCol"><spring:message code="MSG.C.C05.0005" /><%--Language--%></th>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="langList" type="java.util.Vector<hris.C.C05FtestResult1Data>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${langList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}">
                    <td>${row.TENAM}</td>
                    <td>${f:printDate(row.BEGDA)}</td>
                    <td>${row.PTEXT2}</td>
                    <td class="lastCol">${row.LANTX}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
            <tags:table-row-nodata list="${langList}" col="4" />
            </c:if>
            </tbody>
        </table>
    </div>
</div>