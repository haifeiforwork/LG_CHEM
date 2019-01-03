<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%
    String      mName = request.getParameter("param");
%>

<html>
<head>
</head>
<%
    if( mName.equals("contents.html") ) {
%>
<frameset rows="*" frameborder="NO" border="0" framespacing="0"> 
    <frame name="topPage" src="<%= mName %>" noresize frameborder="NO" marginwidth="0" marginheight="0" scrolling="NO">
</frameset>
<%
    } else {
%>
<frameset rows="50,*" frameborder="NO" border="0" framespacing="0"> 
    <frame name="topPage" src="/help_online/help_N100/helpMenu.jsp?param=<%= mName %>" noresize frameborder="NO" marginwidth="0" marginheight="0" scrolling="NO">
    <frame name="endPage" src="/help_online/help_N100/<%= mName %>" marginwidth="0" marginheight="0" frameborder="NO" scrolling="AUTO">
</frameset>
<%
    }
%>
<noframes> 
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes> 
</html>
