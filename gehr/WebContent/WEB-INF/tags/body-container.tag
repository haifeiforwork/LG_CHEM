<%@ tag language="java" pageEncoding="utf-8" %>
<%@ attribute name="bodyContainer" type="com.common.vo.BodyContainer" required="true" %>
<jsp:doBody var="body" /><% bodyContainer.setBody((String) jspContext.getAttribute("body")); %>