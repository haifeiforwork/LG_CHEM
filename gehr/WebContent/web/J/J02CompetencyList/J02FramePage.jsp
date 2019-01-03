<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
%>

<html>
<head>
<title>ESS</title>
</head>

<frameset rows="220,*"> 
  <frame name="CompetencyTop"  src="<%= WebUtil.JspURL %>J/J02CompetencyList/J02SearchCondition.jsp" scrolling="NO" frameborder="NO" marginwidth="0" marginheight="0" noresize>
  <frame name="CompetencyMain" src="<%= WebUtil.ServletURL %>hris.J.J02CompetencyList.J02CompetencyListSV" frameborder="NO" marginwidth="0" marginheight="0" noresize>
</frameset>

<noframes> 
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes> 
</html>
