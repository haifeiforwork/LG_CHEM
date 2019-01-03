<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="punishList" required="true" type="java.util.Vector" %>

<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(punishList) - 1}"/>

<%-- ESS or 징계내역 조회 권한이 잇을 경우만 조회 가능 --%>
<%--<c:if test="${pageType == 'E' or check_A02 == 'Y'}">--%>

<h2 class="subtitle"><spring:message code="MSG.A.A06.0008"/><%--징계--%></h2>

<!--징계내역 리스트 테이블 시작-->
<div class="listArea">
    <div class="table">
        <table class="listTable">
            <colgroup>
                <col>
                <col width="80">
                <col width="80">
                <col width="80">
                <col >
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.A.A06.0009"/><%--징계유형--%></th>
                <th><spring:message code="MSG.A.A06.0010"/><%--징계기간--%></th>
                <th><spring:message code="MSG.A.A06.0011"/><%--징계시작일--%></th>
                <th><spring:message code="MSG.A.A06.0012"/><%--징계종료일--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A06.0013"/><%--징계내역--%></th>
            </tr>
            </thead>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${punishList[status.index]}" />
            <tr class="${f:printOddRow(status.index)}">
                <td>${row.PUNTX}</td>
                <td>${row.ZDISC_DAYS}</td> <!--C20130611_47348-->
                <td>${f:printDate(row.BEGDA)}</td>
                <td>${f:printDate(row.ENDDA)}</td>
                <td class="lastCol">
                    <c:choose>
                        <c:when test="${limitBlank != true}">
                            ${row.PUNRS}
                            <br>
                            ${row.TEXT1}${row.TEXT2}${row.TEXT3}
                        </c:when>
                        <c:otherwise>
                            <c:if test="${not empty row}">
                            [${row.PUNRS}]&nbsp;${row.TEXT1}${row.TEXT2}${row.TEXT3}
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </td>
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

<%--</c:if>--%>