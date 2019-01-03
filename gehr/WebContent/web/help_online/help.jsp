<%@ page contentType="text/html; charset=utf-8" %>
<%--@ include file="/web/common/popupPorcess.jsp" --%> 
<%@ page import="hris.common.*" %>  
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>
<%
    WebUserData user = null;
    user = (WebUserData)session.getAttribute("epuser");
    if(user == null)
        user = (WebUserData)session.getAttribute("user");
    //session.removeAttribute("user");
%>

<html>
<head>
<title>e-HR 사용방법안내</title>
<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>css/help_style.css">
</head>

<frameset rows="51,*,26" cols="*" frameborder="NO" border="0" framespacing="0">
  <frame name="helpTop" scrolling="NO" noresize src="/web/help_online/helpTop.jsp" marginwidth="0" marginheight="0" frameborder="NO">
  <frameset cols="200,*" cols="*" frameborder="NO" border="0" framespacing="0">
    <frame name="helpLeft" src="/web/help_online/help_<%= user.companyCode %>/helpTree.jsp?param=<%= request.getParameter("param") %>" marginwidth="0" marginheight="0" frameborder="NO">
    <frame name="Display"  src="/web/help_online/help_<%= user.companyCode %>/helpMain.jsp?param=<%= request.getParameter("param") %>" marginwidth="0" marginheight="0" frameborder="NO">
    </frameset>
  <frame name="helpBottom" src="/web/help_online/helpBottom.jsp" marginwidth="0" marginheight="0" frameborder="NO">
</frameset>


<noframes><body></body></noframes>
</html>
