<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<html>
<head>
<title>ESS</title>
<script language="JavaScript">
<!--
function prev_page(){
    parent.beprintedpage.focus();
    top.beprintedpage.prevDetail();
}
function next_page(){
    parent.beprintedpage.focus();
    top.beprintedpage.nextDetail();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
<table width="95%" border="0" cellspacing="0" cellpadding="0" height="25">
  <tr>
    <td align="center" valign="middle">
      <a href="javascript:prev_page();">
      <img src="<%= WebUtil.ImageURL %>icon_arrow01.gif"  border="0"></a>
      <a href="javascript:next_page();">
      <img src="<%= WebUtil.ImageURL %>icon_arrow02.gif"  border="0"></a>
    </td>
  </tr>
</table>
</form>
<%@ include file="commonEnd.jsp" %>
