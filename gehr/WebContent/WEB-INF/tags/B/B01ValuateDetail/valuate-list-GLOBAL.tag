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

<%--<c:set var="limit" value="${limit != null and limitBlank == true ? limit * 5 - 1: fn:length(evalList) - 1}"/>--%>
<c:set var="loop" value="${fn:length(evalList) - 1}"/>
<c:if test="${limitBlank == true}">
    <c:set var="loop" value="${fn:length(evalList) > limit * 5 ?  limit * 5 - 1 : loop}"/>
</c:if>

<h2 class="subtitle"><spring:message code="TAB.COMMON.0009" /><!-- Year-end Evaluation --></h2>

<!--평가사항 리스트 테이블 시작-->
<div class="listArea">

    <div class="table">
        <%--@elvariable id="evalList" type="java.util.Vector<hris.B.B01ValuateDetailData>"--%>
        <table class="listTable">
            <thead>
            <tr>
                <th rowspan="2" width="15%"><spring:message code="MSG.B.B01.0037" /><%--Year--%></th>
                <th rowspan="2" width="40%"><spring:message code="MSG.B.B01.0038" /><%--Org.Unit--%></th>
                <th rowspan="2" width="15%"><spring:message code="MSG.B.B01.0056" /><%--Level--%></th>
                <th colspan="4" width="20%"><spring:message code="MSG.B.B01.0059" /><%--Quarter--%></th>
                <th rowspan="2" class="lastCol" width="10%"><spring:message code="MSG.B.B01.0060" /><%--Year End--%></th>
            </tr>
            <tr>
                <th><spring:message code="MSG.B.B01.0061" arguments="1"/></th>
                <th><spring:message code="MSG.B.B01.0061" arguments="2"/></th>
                <th><spring:message code="MSG.B.B01.0061" arguments="3"/></th>
                <th><spring:message code="MSG.B.B01.0061" arguments="4"/></th>
            </tr>
            </thead>
            <tbody>
            <c:set var="rowCount" value="0" />

            <c:if test="${loop > -1}">
                <c:forEach begin="0" varStatus="status" end="${loop}">
                    <c:set var="row" value="${evalList[status.index]}" />
                    <c:choose>
                        <%-- 이전 year 와 비교 틀릴 경우 신규 로우 시작 --%>
                        <c:when test="${row.ZYEAR !=  year}">
                            <tr class="${f:printOddRow(status.index)}">
                            <td>${row.ZYEAR}</td>
                            <td>${row.ORGTX}</td>
                            <td>${row.JILVL}</td>
                            <%-- 1Q --%>
                            <td>${f:defaultString(row.RTEXT, f:defaultIfZero(row.RATING, ''))}</td>
                        </c:when>
                        <c:otherwise>
                            <%-- 2Q, 3Q, 4Q, YEAREND --%>
                            <td class="${row.PERIOD == 'YEAREND' ? "lastCol": ""}">${f:defaultString(row.RTEXT, f:defaultIfZero(row.RATING, ''))}</td>
                            <c:if test="${row.PERIOD == 'YEAREND'}">
                                </tr>
                                <c:set var="rowCount" value="${rowCount + 1}" />
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                    <%-- 이전 year --%>
                    <c:set var="year" value="${row.ZYEAR}" />

                </c:forEach>
            </c:if>


            <c:if test="${limit > -1}">
                <c:forEach begin="${rowCount}" varStatus="status" end="${limit - 1}">
                    <tr class="${f:printOddRow(status.index)}">
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td class="lastCol"></td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${evalList}" col="8"/>
            </c:if>
            </tbody>
        </table>


    </div>
</div>