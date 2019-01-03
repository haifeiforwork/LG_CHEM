<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.*" %>

<%
    String empNo = request.getParameter("empNo"); 

    GetPhotoURLRFC func = new GetPhotoURLRFC();
    String imgUrl = func.getPhotoURL( empNo );

//    request.setAttribute("imgUrl", imgUrl);
%>
<% if(imgUrl != "") { %>
  <img border="0" src="<%= imgUrl %>" width=90 align=absmiddle>
<% } else { %>
  <font size="2" color="#CCCCCC"><br>&nbsp;등록된 사진이<br>&nbsp;없습니다.</font>
<% } %>
