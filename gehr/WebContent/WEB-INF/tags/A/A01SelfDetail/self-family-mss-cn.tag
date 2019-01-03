<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="familyList" required="true" type="java.util.Vector" %>

<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(familyList) - 1}"/>

<h2 class="subtitle"><spring:message code="MSG.A.A04.0001" /><%--가족사항--%></h2>
<div class="listArea">
    <div class="table">
        <table class="listTable" cellspacing="0">
            <colgroup>
                <col width="20%"/>
                <col width="15%"/>
                <col width="15%"/>
                <col width="40%"/>
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="LABEL.A.A12.0035" /><%--가족유형--%></th>
                <th><spring:message code="LABEL.A.A12.0036" /><%--성명--%></th>
                <th><spring:message code="LABEL.A.A12.0005" /><%--생년월일--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A01.0023" /><%--추가개인데이터--%></th>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="familyList" type="java.util.Vector<hris.A.A04FamilyDetailData>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${familyList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}" align="center">
                    <td>${row.FAMSA}</td>
                    <td>${row.ENAME}</td>
                    <td>${f:printDate(row.FGBDT)}</td>
                    <td class="lastCol">${row.ADDAT} </td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${familyList}" col="4" />
            </c:if>
            </tbody>
        </table>
    </div>
</div>

