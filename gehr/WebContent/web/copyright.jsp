<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="hris.common.WebUserData" %>
<%
    WebUserData commonEndWebUserData = (WebUserData)session.getAttribute("user");
%>

<HTML>
<head>
<title>ESS</title>
</head>
<BODY>
  <table width="805" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td><img src="<%= WebUtil.ImageURL %>view/<%=commonEndWebUserData.companyCode.equals("C100") ? "copy_chem.gif": "copy_petro.gif" %>" width="805" height="30"></td>
    </tr>
  </table>
</BODY>
</HTML>
