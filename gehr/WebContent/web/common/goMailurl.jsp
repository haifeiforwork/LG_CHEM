<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="com.sns.jdf.Config" %>
<%@ page import="com.sns.jdf.Configuration" %>
<%@ page contentType="text/html; charset=utf-8" %>

<%
    String url = (String)request.getAttribute("url");
    Config conf           = new Configuration();


    String targetURL = "http://"+conf.getString("com.sns.jdf.mail.ResponseURL")+ WebUtil.ServletURL + "hris.ESBApprovalAutoLoginSV?AINF_SEQN=" + request.getAttribute("AINF_SEQN");

%>
<SCRIPT LANGUAGE="JavaScript">

    <%-- top.location ="<%= url %>"; --%>
    /*document.location ="<%= url %>";*/
    document.location.href = "<%=targetURL %>";
 
</SCRIPT> 
