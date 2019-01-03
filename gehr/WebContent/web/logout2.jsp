<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
  	session.removeAttribute("user");
	
	String userSabun =(String) session.getAttribute("user");  
	//String mssUserSabun = (String)session.getAttribute("se_mssUserSabun");
	/**세션 종료  **/
	if(userSabun==null && userSabun.equals("")){
		session.invalidate();
	}
	
  if(userSabun == null){
    out.println("<script language=\"javascript\">");
    out.println("  top.location.href=\"/web/common/commonProcess.jsp\"; ");
    //out.println("  top.location.href=\"/eland/_admin.jsp\"; ");
    out.println("</script>");
  }else{
	out.println("<script language=\"javascript\">");
    out.println("  top.location.href=\"/web/common/commonProcess.jsp\"; ");
    //out.println("  top.location.href=\"/eland/_admin.jsp\"; ");
    out.println("</script>");
  }
%>
<body>
ddddddddddd
</body>