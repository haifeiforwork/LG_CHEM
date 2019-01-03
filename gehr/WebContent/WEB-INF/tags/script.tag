<%@ tag import="java.util.List" %>
<%@ tag import="com.google.common.collect.Lists" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<jsp:doBody var="SCRIPT_BODY" />
<%
    List<String> scriptList = (List<String>) request.getAttribute("JSP_SCRIPT_LIST");
    if(scriptList == null) scriptList = Lists.newArrayList();
    scriptList.add((String) jspContext.getAttribute("SCRIPT_BODY"));
    request.setAttribute("JSP_SCRIPT_LIST", scriptList);
%>