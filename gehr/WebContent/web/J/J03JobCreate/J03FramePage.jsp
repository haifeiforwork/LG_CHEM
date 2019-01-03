<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    String    i_QKid = request.getParameter("QKID");    
    String    i_rows = request.getParameter("rows");    
%>

<script>
</script>
<html>
<head>
<title>Competency List</title>
<meta http-equiv="X-UA-Compatible" content="IE=8;" />
</head>

<frameset rows="200,*,0"> 
  <frame name="J03CompetencyTop"  src="<%= WebUtil.JspURL %>J/J03JobCreate/J03SearchCondition.jsp?QKID=<%= i_QKid %>&rows=<%= i_rows %>" scrolling="NO" frameborder="NO" marginwidth="0" marginheight="0" noresize>
  <frame name="J03CompetencyMain" src="<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03CompetencyListSV?QKID=<%= i_QKid %>&rows=<%= i_rows %>" frameborder="NO" marginwidth="0" marginheight="0" noresize>
  <frame name="J03CompetencyBottom" src="" frameborder="NO" marginwidth="0" marginheight="0" noresize>
</frameset>

<noframes> 
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes> 
</html>
  