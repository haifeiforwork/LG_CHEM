<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ attribute name="button" type="com.common.vo.BodyContainer"  %>
<%@ attribute name="buttonType" type="java.lang.String"  required="true" %>
<%@ attribute name="disable" type="java.lang.Boolean"  %>
<%@ attribute name="disableUpdate" type="java.lang.Boolean"  %>

<%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
<c:choose>
    <%-- 신청 --%>
    <c:when test="${buttonType == 'R'}">
        <div class="buttonArea">
            <ul class="btn_crud">
                ${button}
                <c:if test="${disable != true}">
                <li><a class="-request-button darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.REQUEST"/><%--신청--%></span></a></li>
                </c:if>
            <c:if test="${!empty RequestPageName or not empty param.cancelPage}">
                <li><a href="${not empty param.cancelPage ? param.cancelPage : 'javascript:history.back();'}"><span><spring:message code="BUTTON.COMMON.CANCEL" /><%--취소--%></span></a></li>
                <%--<li><a class="darken" href="${RequestPageName}"><span>목록</span></a></li>--%>
            </c:if>
            </ul>
        </div>
    </c:when>

    <c:when test="${buttonType == 'D'}">
        <div class="buttonArea" style="${not empty buttonWidth ? buttonWidth : ''}">
            <ul class="btn_crud">
                    ${button}
            <c:if test="${approvalHeader.MODFL == 'X' && disable != true}">
                <c:if test="${disableUpdate != true}">
                <li><a class="-update-button darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.UPDATE" /><%--수정--%></span></a></li>
                </c:if>
                <li><a class="-delete-button darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.DELETE" /><%--삭제--%></span></a></li>
            </c:if>
            <c:if test="${approvalHeader.CANCFL == 'X'}">
                <li><a class="-approval-cancel-button darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.APPROVAL.CANCEL" /><%--승인취소--%></span></a></li>
            </c:if>
            <c:if test="${approvalHeader.ACCPFL == 'X' && disable != true}">
                <li><a class="-accept-dialog-button darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.APPROVAL" /><%--승인--%></span></a></li>
                <li><a class="-reject-dialog-button darken" href="javascript:;"><span><spring:message code="BUTTON.COMMON.REJECT" /><%--반려--%></span></a></li>
            </c:if>
            <c:if test="${!empty RequestPageName or param.external == true}">
                <li><a class="darken loading" href="${not empty RequestPageName ? RequestPageName : 'javascript:history.back();'}"><span><spring:message code="BUTTON.COMMON.LIST" /><%--목록--%></span></a></li>
            </c:if>
            </ul>
        </div>
    </c:when>

</c:choose>

