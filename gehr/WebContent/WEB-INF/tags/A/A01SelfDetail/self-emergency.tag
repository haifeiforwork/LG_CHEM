<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<h2 class="subtitle"><spring:message code="MSG.A.A20.0009"/><%--Emergency Contacts--%></h2>

<div class="listArea">
    <div class="table">
        <table class="listTable">
            <colgroup>
                <col width="10%">
                <col width="">
                <col width="">
                <col width="">
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.A.A20.0003" /><%--Relationship--%></th>
                <th><spring:message code="MSG.A.A20.0008" /><%--Rel. Name--%></th>
                <th><spring:message code="MSG.A.A20.0006" /><%--Emerg. Ph#1--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A20.0007" /><%--Emerg. Ph#2--%></th>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="emergencyList" type="java.util.Vector<hris.A.A09CareerDetailData>"--%>
            <c:forEach var="row" items="${emergencyList}" varStatus="status">
                <tr>
                    <td>${row.RLSHPTX}</td>
                    <td>${row.RLNAME}</td>
                    <td>${row.EMGPH1}</td>
                    <td class="lastCol">${row.EMGPH2}</td>
                </tr>
            </c:forEach>
            <tags:table-row-nodata list="${emergencyList}" col="4" />
            </tbody>
        </table>
    </div>

    <%-- ESS 일 경우에만 --%>
    <c:if test="${pageType == 'E'}">
        <div class="buttonArea">
                <%-- button --%>
            <ul class="btn_crud">
                <c:choose>
                    <c:when test="${empty emergencyList}">
                        <li><a href="${g.servlet}hris.A.A20EmergencyContactsBuildSV" ><span><spring:message code="BUTTON.COMMON.INSERT" /><%--입력--%></span></a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${g.servlet}hris.A.A20EmergencyContactsChangeSV" ><span><spring:message code="BUTTON.COMMON.UPDATE" /><%--수정--%></span></a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </c:if>
</div>