<%@ page session="false" contentType="text/html; charset=utf-8" %>

<%! java.text.SimpleDateFormat df = 
      new java.text.SimpleDateFormat("yyyyMMdd/HH:mm:ss"); %>

<html>
<title>IBM WebSphere V3 Request Monitor</title>
<body>
<h4>IBM WebSphere V3 Request Monitor version 1.1 </h4>
<% java.util.Date now = new java.util.Date(); %>
CurrentTime: <%= df.format(now) %><br><br>
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
NOTE: This is only for debugging so we do NOT support this feature officially.<br>
WonYoung Lee. lwy@kr.ibm.com, javaservice@hanmail.net IBM Korea.
</body>
</html>
