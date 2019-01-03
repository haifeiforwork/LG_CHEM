<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String gubun = request.getParameter("gubun");
%>

<html>
<head>
<title>Job Description</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="8" topmargin="8" marginwidth="0" marginheight="0">
<table cellspacing=0 cellpadding=0 border=0 bgcolor=#999999 width=995 height=38>
  <tr>
    <td bgcolor=#ffffff>
      <table cellspacing=0 cellpadding=0 border=0 width=100% height=100%>
        <tr>
            <td width="780"> <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td class="title01"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">&nbsp;Job Description<%= gubun.equals("R") ? "" : " 생성.수정.삭제" %></td>
                  <td align=right></td>
                </tr>
              </table></td>        
	      </tr>
	    </table>
    </td>
  </tr>
</table>
<%@ include file="/web/common/commonEnd.jsp" %>
