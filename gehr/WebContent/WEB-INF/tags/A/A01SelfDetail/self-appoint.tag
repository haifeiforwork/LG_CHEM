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

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(appointList) - 1}"/>

<h2 class="subtitle"><spring:message code="MSG.A.A05.0001" /><%--발령사항--%></h2>

<!-- 발령사항 리스트 테이블 시작-->
<div class="listArea">
    <div class="table">
        <table class="listTable">
            <thead>
            <tr>
                <th width="14%"><spring:message code="MSG.A.A05.0002" /><%--발령유형--%></th>
                <th width="7%"><spring:message code="MSG.A.A05.0003" /><%--발령일자--%></th>
                <th width="20%"><spring:message code="MSG.A.A05.0005" /><%--소속--%></th>
                <c:if test="${user.area == 'KR'}">
                    <th width="10%"><spring:message code="MSG.A.A05.0006" /><%--신분--%></th>
                </c:if>
                 <!-- [CSR ID:3428773]  [CSR ID:3456352]
				<th width="10%"><spring:message code="MSG.A.A05.0007" /><%--직위--%></th>  -->
				<th width="10%"><spring:message code="MSG.A.A01.0083" /><%--직위/직급호칭--%></th>
                <th width="10%"><spring:message code="MSG.A.A05.0008" /><%--직급/연차--%></th>
                <th width="10%"><spring:message code="MSG.A.A05.0009" /><%--직책--%></th>
                <th  class = "${user.area == 'KR' ? '' : 'lastCol'}" width="10%"><spring:message code="MSG.A.A05.0010" /><%--직무--%></th>
                <!-- [CSR ID:3475163] 인사발령조회 항목 순서 변경  -->
                <c:if test="${user.area == 'KR'}">
                    <th class ="lastCol" width="10%"><spring:message code="MSG.A.A05.0004" /><%--근무지--%></th>
                </c:if>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="appointList" type="java.util.Vector<hris.A.A05AppointDetail1Data>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${appointList[status.index]}" />
                <tr class="${status.index % 2 == 0 ? 'oddRow' : ''}">
                    <td>${row.MNTXT}</td>
                    <td>${f:printDate(row.BEGDA)}</td>
                    <td>${row.ORGTX}</td>
                    <c:if test="${user.area == 'KR'}">
                        <td>${row.PKTXT}</td>
                    </c:if>
                    <td>
                            ${row.JIKWT}
                        <c:if test="${not empty row.KEEP_TITL2}"><br>(${row.KEEP_TITL2})</c:if>
                    </td>
                    <td>${row.VGLST}</td>
                    <td>${row.JIKKT}</td>
                    <td  class = "${user.area == 'KR' ? '' : 'lastCol'}" >${row.STLTX}</td>
                    <!-- [CSR ID:3475163] 인사발령조회 항목 순서 변경  -->
                    <c:if test="${user.area == 'KR'}">
                        <td class ="lastCol">${row.BTEXT}</td>
                    </c:if>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${appointList}" col="${user.area == 'KR' ? '9' : '7'}" />
            </c:if>
            </tbody>
        </table>
    </div>
</div>
<!-- 발령사항 리스트 테이블 끝-->