<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<html>
<head>
<title>ESS</title>
</head>
<frameset rows="166,*" frameborder="NO" border="0" framespacing="0"> 
  <frame name="menu" scrolling="NO" noresize src="D10YeartexMenu.jsp" marginwidth="0" marginheight="0" frameborder="NO" >
  <frame name="Detail" src="<%=((WebUserData)session.getAttribute("user")).companyCode%>/D10YeartexDetail01.htm" marginwidth="0" marginheight="0" scrolling="AUTO" frameborder="NO">
</frameset>
<noframes> 
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes> 
</html>
