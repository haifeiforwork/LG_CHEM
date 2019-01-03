<%/******************************************************************************/
/*                                                                              */
/*   System Name  : tag                                                         */
/*   1Depth Name  : tag                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 발령 용 tag                                    */
/*   Program ID   : self-career.tag                                       */
/*   Description  : 인사기록부 발령 조회                                             */
/*   Note         : 없음                                                        */
/*   Creation     :                                           */
/*   Update       : 2017-07-10 [CSR ID:3428773] 인사기록부 수정 요청                               */
/*                      */
/*                      */
/*                              */
/********************************************************************************/%>
<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="careerList" required="true" type="java.util.Vector" %>

<%@ attribute name="limit" type="java.lang.Integer" %>
<%@ attribute name="limitBlank" type="java.lang.Boolean" %>

<c:set var="limit" value="${limit != null and limitBlank == true ? limit - 1: fn:length(careerList) - 1}"/>

<h2 class="subtitle"><spring:message code="TAB.COMMON.0008" /><%--경력사항--%></h2>

<%--@elvariable id="careerList" type="java.util.Vector<hris.A.A09CareerDetailData>"--%>
<div class="listArea">
    <div class="table">
        <table class="listTable">
            <colgroup>
                <col width="160">
                <col>
                <col width="120">
                <col width="120">
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.A.A09.0002" /><%--근무기간--%></th>
                <th><spring:message code="MSG.A.A09.0003" /><%--근무처--%></th>
                <!-- [CSR ID:3428773] [CSR ID:3456352]
				<th><spring:message code="MSG.A.A09.0004" /><%--직위--%></th>  -->
				<th><spring:message code="MSG.A.A01.0083" /><%--직위/직급호칭--%></th>
                <th class="lastCol"><spring:message code="MSG.A.A09.0005" /><%--직무--%></th>
            </tr>
            </thead>
            <tbody>
            <%--@elvariable id="resultList" type="java.util.Vector<hris.A.A09CareerDetailData>"--%>
            <c:if test="${limit > -1}">
            <c:forEach begin="0" varStatus="status" end="${limit}">
                <c:set var="row" value="${careerList[status.index]}" />
                <tr class="${f:printOddRow(status.index)}">
                    <td>${row.PERIOD}</td>
                    <td>${row.ARBGB}</td>
                    <td>${row.JIKWT}</td>
                    <td class="lastCol">${row.STLTX}</td>
                </tr>
            </c:forEach>
            </c:if>
            <c:if test="${limitBlank != true}">
                <tags:table-row-nodata list="${careerList}" col="4" />
            </c:if>
            </tbody>
        </table>
    </div>
</div>