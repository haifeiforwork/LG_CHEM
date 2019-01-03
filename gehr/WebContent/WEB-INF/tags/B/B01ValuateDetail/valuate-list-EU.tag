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

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(evalList) - 1}"/>

<h2 class="subtitle"><spring:message code="MSG.B.B01.0036" /><%--평가사항 조회--%></h2>

<!--평가사항 리스트 테이블 시작-->
<div class="listArea">

    <div class="table">
            <%--@elvariable id="evalList" type="java.util.Vector<hris.B.B01ValuateDetailData>"--%>
        <table class="listTable">
            <thead>
            <tr>
                <th width="15%"><spring:message code="MSG.B.B01.0037" /><%--Year--%></th>
                <th width="40%"><spring:message code="MSG.B.B01.0038" /><%--Org.Unit--%></th>
                <th width="15%"><spring:message code="MSG.B.B01.0056" /><%--Level--%></th>
                <th width="15%"><spring:message code="MSG.B.B01.0057" /><%--Score--%></th>
                <th class="lastCol" width="15%"><spring:message code="MSG.B.B01.0058" /><%--Grade--%></th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${evalList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}">
                    <td>${row.ZYEAR}</td>
                    <td>${row.ORGTX}</td>
                    <td>${row.JILVL}</td>
                    <td>${f:defaultIfZero(row.RATING, '')}</td>
                    <td class="lastCol">${row.RTEXT}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${evalList}" col="5"/>
            </c:if>
            </tbody>
        </table>


    </div>
</div>
