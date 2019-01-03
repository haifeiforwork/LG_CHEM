<%@ page contentType="text/html; charset=utf-8" %>
<%-- @ include file="/web/common/commonProcess.jsp" --%>
<%@ page errorPage="/web/err/error.jsp" %>
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
    WebUserData user_m = WebUtil.getSessionMSSUser(request);

    String webUserID = "";

    if (user.webUserId == null ||user.webUserId.equals("") )
        webUserID = "";
    else
        webUserID = user.webUserId.substring(0,6).toUpperCase();
 %>
<html>
<head>
<title>HR제도 안내</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/lgchem_ep.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>css/help_style.css">
</head>

<frameset rows="51,*,26" cols="*" frameborder="NO" border="0" framespacing="0">
  <frame name="helpTop" scrolling="NO" noresize src="/web/help_online/ruleTop.jsp" marginwidth="0" marginheight="0" frameborder="NO">
  <frameset cols="200,*" cols="*" frameborder="NO" border="0" framespacing="0">
    <frame name="helpLeft" src="/web/help_online/help_<%= user.companyCode %>/ruleTree.jsp?param=<%= request.getParameter("param") %>" marginwidth="0" marginheight="0" frameborder="NO">
    <frame name="Display"  src="/web/help_online/help_<%= user.companyCode %>/ruleMain.jsp?param=<%= request.getParameter("param") %>" marginwidth="0" marginheight="0" frameborder="NO">
    </frameset>
  <frame name="helpBottom" src="/web/help_online/ruleBottom.jsp" marginwidth="0" marginheight="0" frameborder="NO" scrolling="NO" >
</frameset>

<noframes><body></body></noframes>
</html>
