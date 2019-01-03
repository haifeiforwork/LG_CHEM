<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="commonProcess_m.jsp" %>

<html>
<head>
<title>ESS</title>
<script language="javascript">
    function f_print(){
              parent.beprintedpage.focus();
              parent.beprintedpage.print();
    }              
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="624" border="0" cellspacing="0" cellpadding="0" height="30">
  <tr>
    <td align="right" valign="bottom">
      <a href="javascript:f_print();">
      <img src="<%= WebUtil.ImageURL %>btn_print.gif" width="59" height="20" border="0"></a> 
      </td>
  </tr>
</table>
<%@ include file="commonEnd.jsp" %>
