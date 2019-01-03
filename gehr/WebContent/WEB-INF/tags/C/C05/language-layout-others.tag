<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>

<%@ attribute name="title" type="java.lang.String"  required="true" %>
<%@ attribute name="rows" type="java.util.List" required="true" %>
<%@ attribute name="colTitle" type="java.lang.String" required="true" %>
<%@ attribute name="colName" type="java.lang.String" required="true" %>

<h2 class="subtitle"><spring:message code="${title}" /></h2>
<div class="listArea">
    <div class="table">
        <table class="listTable">
            <thead>
            <tr>
                <th width="150"><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                <th class="lastCol"><spring:message code="${colTitle}" /></th>
            </tr>
            </thead>
            <c:forEach var="row" items="${rows}" varStatus="status">
                <tr class="${f:printOddRow(status.index)}">
                    <td>${f:printDate(row.BEGDA)}</td>
                    <td class="lastCol">
                        <font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row[colName]}</font>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
</div>

