<%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
<%--
    2018-06-04 rdcamel [CSR ID:3704184] 유연근로제 동의 관련 기능 추가 건 - Global HR Portal
    2018-08-13 [WorkTime52] Draggable ne 'Y' : 근무시간입력 화면 layer popup draggable 처리를 위해
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<body style="padding-bottom:0; ${not empty bodyWidth ? bodyWidth : ''}"<% if (!WebUtil.isLocal(request)) { %><%-- param.subView eq 'Y' || param.click eq 'Y' || --%>
 <c:if test="${viewSource ne 'true' and isUpdate ne true}">oncontextmenu="return false"${Draggable ne 'Y' ? ' ondragstart="return false"' : ''} onselectstart="return false" onkeyup="ClipBoardClear()"</c:if><% } %>
 <%-- [CSR ID:3704184] 조건 추가 --%>
 <c:if test="${param.MSSYN ne 'Y' and param.popCheck eq 'N'}">onload="policyAgree('${param.popCheck}')"</c:if>
>
<div class="subWrapper${param.subView eq 'Y' ? ' iframeWrap' : ''}${param.always eq 'true' ? ' always' : ''}">
<c:if test="${!empty param.title}">
    <c:choose><c:when test="${param.subView eq 'Y'}">
    <%-- 내용부의 서브타이틀 --%>
    <h2 class="subtitle"><spring:message code="${param.title}"/></h2>
    </c:when><c:otherwise>
    <%-- 일반 타이블 --%>
    <div class="title${param.always eq 'true' ? ' always' : ''}"><h1><spring:message code="${param.title}"/></h1></div>
    </c:otherwise></c:choose>
</c:if>
