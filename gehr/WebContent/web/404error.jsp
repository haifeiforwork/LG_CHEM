<%@ page contentType="text/html; charset=utf-8"%>  
<%@ page import = "com.sns.jdf.util.*"%>
<% response.setStatus(200); %>

<html>
<head>
<title>Page Not Found</title>
<script language="javascript">
function cbOnBeforeLoad() {}
</script>
</head>

<body style="text-align:center;background:#f0f0f0;padding:20px 0 0 0;">
<div style="width:800px;margin:0 auto;font-family:verdana;border:solid 1px #ddd;padding:20px;background:#fff;">
	<!-- Content Start -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	 <tr>
	  <td >&nbsp;
	   <table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr valign="top">
	     <td width="200" rowspan="6"><img src="<%=WebUtil.ImageURL%>error.gif" width="200" /></td>
	     <td  style="font-size:18px;color:#ef4674;font-weight:bold;">Page Not Found</td>
	    </tr>
	    <tr valign="top">
	     <td >&nbsp;</td>
	    </tr>
	    <tr valign="top">
	     <td style="font-size:15px;color:#909090;font-weight:bold;"> Sorry! We couldn't find your document. </td>
	    </tr>
	    <tr valign="top">
	     <td >&nbsp;</td>
	    </tr>
	    <tr valign="top">
	     <td style="font-size:12px;color:#666">
The file that you requested could not be found on this server. If you provided the URL, please check to ensure that it is correct or try a search above. <BR><BR>
If you are certain that this URL is valid, please send us feedback about the broken link. <BR><BR>
Thank you<BR><BR>
</td>
	    </tr>
	    <tr valign="top">
	     <td style="font-size:12px;color:#666;border-top:solid 1px #ddd;padding:12px 0 0 0">
	     	E-mail us at wordy@lgchem.com<br>
	      Call us at 02-3773-7642
	     </td>
	    </tr>
	   </table></td>
	 </tr>
	 <tr>
	  <td width="832" height="14" ></td>
	 </tr>
	 <tr>
	  <td height="1" class="bg_gray_a6a6a6"></td>
	 </tr>
	 <tr>
	  <td height="2" class="bg_gray_efefef"></td>
	 </tr>
	 <tr>
	  <td height="7"></td>
	 </tr>
	 <tr>
	  <td height="7">
	  	<div style="text-align:left;padding:0 0 20px 200px;">
	  		<input name="submit2322" type="button" style="background:#9a9a9a;color:#fff;font-family:verdana;font-weight:bold;border:solid 1px #9a9a9a;" value="&lt;  Back" onclick="history.back()">
	  	</div>
	  	</td>
	 </tr>
	</table>
</div>
</body>
</html>