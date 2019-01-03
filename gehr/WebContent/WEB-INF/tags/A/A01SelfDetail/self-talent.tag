<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(talentList) - 1}"/>

<h2 class="subtitle"><spring:message code="MSG.A.A01.054" /><%--인재육성--%></h2>
<div class="listArea">
    <div class="table">
        <table class="listTable" cellspacing="0">
            <colgroup>
                <col>
                <col width="80">
                <col width="80">
                <col>
                <col>
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.APPROVAL.0012" /><%--구분--%></th>
                <th><spring:message code="LABEL.D.D15.0152" /><%--시작일--%></th>
                <th><spring:message code="LABEL.D.D15.0153" /><%--종료일--%></th>
                <th><spring:message code="MSG.A.A01.060" /><%--육성결과--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A01.061" /><%--비고(국가)--%></th>
            </tr>
            </thead>

            <tbody>
            <%--@elvariable id="talentList" type="java.util.Vector<hris.A.A01SelTalentData>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${talentList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}" align="center">
                    <td>${row.STEXT}</td>
                    <td>${f:printDate(row.BEGDA)}</td>
                    <td>${f:printDate(row.ENDDA)}</td>
                    <td>${row.RES_DEVE}</td>
                    <td class="lastCol">${row.LANDX}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${talentList}" col="5" />
            </c:if>
            </tbody>
        </table>
    </div>
</div>