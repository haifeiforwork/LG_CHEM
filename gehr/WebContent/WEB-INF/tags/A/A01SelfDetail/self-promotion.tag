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

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(promotionList) - 1}"/>

<c:if test="${user.area == 'KR' and fn:startsWith(user.e_persk, '3')}">
    <h2 class="subtitle"><spring:message code="MSG.A.A05.0011" /><%--승급사항--%></h2>

    <!--승급사항 테이블시작 -->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th width="300"><spring:message code="MSG.A.A05.0012" /><%--승급구분--%></th>
                    <th width="120"><spring:message code="MSG.A.A05.0013" /><%--승급일자--%></th>
                    <th width="120"><spring:message code="MSG.A.A05.0014" /><%--직급--%></th>
                    <th width="120"><spring:message code="MSG.A.A05.0015" /><%--호봉--%></th>
                    <th class="lastCol" width="120"><spring:message code="MSG.A.A05.0016" /><%--년차/생활급--%></th>
                </tr>
                    <%--@elvariable id="promotionList" type="java.util.Vector<hris.A.A05AppointDetail2Data>"--%>
                <c:if test="${limit > -1}">
                <c:forEach begin="0" varStatus="status" end="${limit}">
                    <c:set var="row" value="${promotionList[status.index]}" />
                    <tr class="${status.index % 2 == 0 ? 'oddRow' : ''}">
                        <td>${row.RTEXT}</td>
                        <td>${f:printDate(row.BEGDA)}</td>
                        <td>${row.TRFGR}</td>
                        <td>${row.TRFST}</td>
                        <td class="lastCol">${row.VGLST}</td>
                    </tr>
                </c:forEach>
                </c:if>
                <c:if test="${limitBlank != true}">
                    <tags:table-row-nodata list="${promotionList}" col="5" />
                </c:if>
            </table>
        </div>
    </div>
</c:if>