<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String gubun = request.getParameter("gubun");
%>

<html>
<head>
<title>Job Description</title>
<link rel="stylesheet" href="<%= WebUtil.JspURL %>help_online/images/skin/style.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>tree/MakeTree_help.js"></script>
<script language="javascript">
<!--
function goOnLoad(){
		document.form1.action = "<%= WebUtil.JspURL %>J/J01JobMatrix/J01FuncObjecTree.jsp?gubun=<%= gubun %>";
    document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="8" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:goOnLoad();">
<form name="form1" method="post" action="">
  <input type="hidden" name="gubun" value="">

<table width="228" height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
  <td width="1" bgcolor="#cccccc"></td>
  <td valign="top">
    <table width="227" height="25" cellspacing="0" cellpadding="0" border="0">
      <tr>
        <td bgcolor="#cccccc" colspan="2"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="1"></td>
      </tr>
      <tr height="387">
        <td align=center><OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
 codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"
 WIDTH="169" HEIGHT="71" id="loading" ALIGN=""><PARAM NAME=movie VALUE="<%= WebUtil.ImageURL %>jms/loading.swf"><PARAM NAME=quality VALUE=high><PARAM NAME=bgcolor VALUE=#FFFFFF> <EMBED src="<%= WebUtil.ImageURL %>jms/loading.swf" quality=high bgcolor=#FFFFFF  WIDTH="169" HEIGHT="71" NAME="loading20030602" ALIGN=""
 TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer"></EMBED>
</OBJECT>
        </td>
	    </tr>
	  </table>
  </td>
</tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
