<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(tripList) - 1}"/>

<h2 class="subtitle"><spring:message code="TAB.COMMON.0059" /><%--해외 경험--%></h2>
<div class="listArea">
    <div class="table">
        <table class="listTable" cellspacing="0">
            <colgroup>
                <col width="15%">
                <col width="15%">
                <col width="20%">
                <col width="28%">
                <col width="">
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.A.A13.011" /><%--국가--%></th>
                <th><spring:message code="MSG.A.A01.050" /><%--도시--%></th>
                <th><spring:message code="MSG.A.A01.051" /><%--체류기간--%></th>
                <th><spring:message code="MSG.A.A01.052" /><%--활동구분--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A01.053" /><%--활동내역--%></th>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="tripList" type="java.util.Vector<hris.A.A01SelfTripFormData>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${tripList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}" align="center">
                    <td>${row.DEST_ZONE}</td>
                    <td>${row.DEST_CITY}</td>
                    <td>${row.PERIOD}</td>
                    <td>${row.RESN_TEXT}</td>
                    <td class="lastCol">${row.RESN_DESC}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${tripList}" col="5" />
            </c:if>
            </tbody>
        </table>
    </div>
</div>