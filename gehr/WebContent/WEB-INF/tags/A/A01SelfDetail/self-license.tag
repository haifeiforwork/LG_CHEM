<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="licenseList" required="true" type="java.util.Vector" %>
<%@ attribute name="isLiceseLink" type="java.lang.Boolean" %>

<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(licenseList) - 1}"/>

<c:set var="isLiceseLink" value="${isLiceseLink == null ? true : isLiceseLink}" />

<tags:script>
    <c:if test="${isLiceseLink}">
        <script>
            function view_detail(code) {
                window.open('${g.servlet}hris.A.A01SelfDetailLicensePopSV?licn_code=' + code, 'essPopup', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=552,height=565,left=100,top=100");
            }
        </script>
    </c:if>
</tags:script>
<h2 class="subtitle"><spring:message code="MSG.A.A01.0069" /><%--자격면허--%></h2>
<div class="listArea">
    <div class="table">
        <table class="listTable" cellspacing="0">
            <colgroup>
                <col width=""/>
                <col width="80"/>
                <c:if test="${user.area == 'KR'}">
                <col width="60"/>
                </c:if>
                <col width=""/>
                <col width="80"/>
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.A.A01.0070" /><%--자격면허--%></th>
                <th><spring:message code="MSG.A.A01.0071" /><%--취득일--%></th>
                <c:if test="${user.area == 'KR'}">
                    <th><spring:message code="MSG.A.A01.0072" /><%--등급--%></th>
                </c:if>
                <th><spring:message code="MSG.A.A01.0073" /><%--발행기관--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A01.0074" /><%--법정선임사유--%></th>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="licenseList" type="java.util.Vector<hris.A.A01SelfDetailLicenseData>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${licenseList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}" align="center">
                    <td>
                    <c:choose>
                        <c:when test="${isLiceseLink && row.FLAG == 'X'}">
                            <a href="javascript:;" onclick="view_detail('${row.LICNCD}')">${row.LICNNM}</a>
                        </c:when>
                        <c:otherwise>
                            ${row.LICNNM}
                        </c:otherwise>
                    </c:choose>
                    </td>
                    <td>${f:printDate(row.OBNDAT)}</td>
                    <c:if test="${user.area == 'KR'}">
                        <td>${row.LGRDNM}</td>
                    </c:if>
                    <td>${row.PBORGH}</td>
                    <td class="lastCol">${row.LAW == 'N' ? '' : row.LAW}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${licenseList}" col="5" />
            </c:if>
            </tbody>
        </table>
    </div>
</div>