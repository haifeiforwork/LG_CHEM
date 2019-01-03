<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    String      gubun = request.getParameter("gubun");
%>

<html>
<head>
<title>Job Description</title>
</head>

<frameset rows="56,*" cols="*" framespacing="0">
  <frame name="J_topmenu" src="<%= WebUtil.JspURL %>J/J_tmenu.jsp?gubun=<%= gubun %>" scrolling="no" frameborder="NO" marginwidth="0" marginheight="0" noresize>
  <frameset rows="*" cols="238,4,*" framespacing="0">
    <frameset rows="64%,36%" cols="*" framespacing="0">
      <frame name="J_leftTop"  src="<%= WebUtil.JspURL %>J/J01JobMatrix/J01FuncObjecWait.jsp?gubun=<%= gubun %>" scrolling="NO" frameborder="NO" marginwidth="0" marginheight="0" noresize>
      <frame name="J_leftDown" src="" scrolling="NO" frameborder="NO" marginwidth="0" marginheight="0" noresize>
    </frameset>
    <frame name="J_bg"    src="<%= WebUtil.JspURL %>J/J_bgFrame.html" scrolling="NO" frameborder="NO" marginwidth="0" marginheight="0" noresize>
    <frameset rows="610,*" cols="*" framespacing="0">
      <frame name="J_right"     src="" scrolling="AUTO" frameborder="NO" marginwidth="0" marginheight="0" noresize>
      <frame name="J_rightDown" src="<%= WebUtil.JspURL %>J/J_copyright.jsp" scrolling="NO" frameborder="NO" marginwidth="0" marginheight="0" noresize>
    </frameset>
  </frameset>
</frameset>

<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes> 
</html>
