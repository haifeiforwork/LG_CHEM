<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="schoolList" required="true" type="java.util.Vector" %>
<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(schoolList) - 1}"/>

<h2 class="subtitle"><spring:message code="MSG.A.A01.0035" /><%--학력사항--%></h2>
<div class="listArea">
    <div class="table">
        <table class="listTable" cellspacing="0">
            <colgroup>
                <col width="20%"/>
                <col />
                <col />
                <col width="17%"/>
                <col />
                <col width="8%"/>
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.A.A01.0036" /><%--기간--%></th>
                <th><spring:message code="MSG.A.A01.0037" /><%--학교명--%></th>
                <th><spring:message code="MSG.A.A01.0038" /><%--전공--%></th>
                <th><spring:message code="MSG.A.A01.0039" /><%--졸업구분--%></th>
                <th><spring:message code="MSG.A.A01.0040" /><%--소재지--%></th>
                <th class="lastCol -small-font" ><spring:message code="MSG.A.A01.0041" /><%--입사시 학력--%></th>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="schoolList" type="java.util.Vector<hris.A.A02SchoolData>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}" >
                <c:set var="row" value="${schoolList[status.index]}" />
                <tr class="${status.index % 2 == 0 ? 'oddRow' : ''}" align="center">
                    <td>${row.PERIOD}</td>
                    <td>${row.SCHTX}</td>
                    <td>${row.SLTP1X}</td>
                    <td>${row.SLATX}</td><%-- ${row.SLTXT} 학력?--%>
                    <td>${row.SOJAE}</td>
                    <td class="lastCol">${row.EMARK == 'N' ? '' : row.EMARK}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
            <tags:table-row-nodata list="${schoolList}" col="6" />
            </c:if>
            </tbody>
        </table>
    </div>
</div>