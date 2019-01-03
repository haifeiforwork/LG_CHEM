<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ attribute name="css" type="java.lang.String" %>
<%@ attribute name="script" type="java.lang.String" %>
<%@ attribute name="title" type="java.lang.String" %>
<%@ attribute name="help" type="java.lang.String" %>
<%@ attribute name="pop" type="java.lang.Boolean" %>
<%@ attribute name="always" type="java.lang.String" %>
<%@ attribute name="unblock" type="java.lang.Boolean" %>

<c:set var="bodyHeader" value="${pop ? 'pop-body-header.jsp' : 'body-header.jsp' }" />
<c:set var="bodyFooter" value="${pop ? 'pop-body-footer.jsp' : 'body-footer.jsp' }" />

<jsp:include page="/include/header.jsp">
    <jsp:param name="css" value="${css}" />
    <jsp:param name="script" value="${script}" />
    <jsp:param name="unblock" value="${unblock}" />

</jsp:include>
<jsp:include page="/include/${bodyHeader}">
    <jsp:param name="title" value="${title}"/>
    <jsp:param name="help" value="${help}"/>
    <jsp:param name="always" value="${always}"/>
</jsp:include>

<jsp:doBody/>

<c:forEach var="scriptRow" items="${JSP_SCRIPT_LIST}">
${scriptRow}
</c:forEach>

<jsp:include page="/include/${bodyFooter}" />

<jsp:include page="/include/footer.jsp"/>