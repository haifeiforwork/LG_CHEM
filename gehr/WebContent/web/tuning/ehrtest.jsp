<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>

<%! java.text.SimpleDateFormat df = 
      new java.text.SimpleDateFormat("yyyyMMdd/HH:mm:ss"); %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.*" %>

<html>
<title>모니터링</title>
<body>
<meta HTTP-EQUIV="refresh" content="2">     
<h4>[ e-HR 모니터링 ]</h4>
<% java.util.Date now = new java.util.Date(); %>
현재시간: <%= df.format(now) %><br><br>
<% String sip = java.net.InetAddress.getLocalHost().getHostAddress(); %>
서버IP : <font color=#3366CC><b><%=sip%></b></font><br><br>
<%
    CurrentDateRFC func = new CurrentDateRFC();
    String currDate = func.getCurrent();
%>
<% if(currDate != "") { %>
RFC Test : <font color=#3366CC><b>성공</b></font>&nbsp;&nbsp;&nbsp;<%=currDate%>
<% } else { %>
RFC Test : <font color=#CC0066><b>실패</b></font>
<% } %>
<%
WebUserData user = new WebUserData() ;
			if(session != null){
				user = ( WebUserData ) session.getAttribute( "user" ) ;
			}
%>
<% String system_id = (String)session.getAttribute("SYSTEM_ID");%>
<%=system_id%>
<br>
<%=user%>
<br>
<pre>
<%= "CALL TIME\t\tELASPED\tIP ADDRESS\t\tURI" %>
-------------------------------------------------------------------------------
<% String ip =java.net.InetAddress.getLocalHost().getHostAddress();
   org.jdf.requestmon.ServiceTrace trace = org.jdf.requestmon.ServiceTrace.getInstance();
   java.util.Hashtable list = trace.getActiveList();
   java.util.Enumeration enum = ((java.util.Hashtable)list.clone()).elements();
   while(enum.hasMoreElements()){
      org.jdf.requestmon.TraceObject obj = (org.jdf.requestmon.TraceObject)enum.nextElement();

%><%= 
df.format(new java.util.Date(obj.getStartTime())) %><%=
"\t" + (now.getTime()-obj.getStartTime())%><%=
"\t"+obj.getRemoteAddr()+ " \t" + obj.getURI() %>
<%
   }
%>-------------------------------------------------------------------------------
</pre>
<br>
</body>
</html>
