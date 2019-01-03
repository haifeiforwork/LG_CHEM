<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 부서근태
/*   Program Name : 실근무 실적현황 wait 창
/*   Program ID   : D40WorkTimeReport_wait.jsp
/*   Description  : 실근무 실적현황 wait 창
/*   Note         : 
/*   Creation     : 2018-06-04 성환희 [WorkTime52]
/*   Update       : 
/******************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.Logger" %>
<%@ include file="/include/includeCommon.jsp"%>

<%
    String targetPage     = request.getParameter("targetPage");
	Logger.debug.println("\n---------------------targetPage : "+targetPage);
	String[] t_url = targetPage.split(",");
	String url = "";
	for (int i=0; i<t_url.length; i++ ){
		if(i==0)
			url = url+t_url[i];
		else
			url = url+"&"+t_url[i];
	}
	Logger.debug.println("\n---------------------url : "+url);
%>

<html>
<head>
<title><!-- 부서 근태 검색중... --><%=g.getMessage("MSG.F.F41.0004")%></title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="javascript">
<!--
function doSubmit(){

    document.form1.action = "<%=url%>";

    document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="doSubmit()">
<form name="form1" method="post" action="" onsubmit="return false">
</form>

<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" class="td04" ><font color="#CC3300"><!-- 조회중입니다.  잠시만 기다려주십시요. --><%=g.getMessage("MSG.F.F41.0005")%></font></td>
  </tr>
</table>
</body>
</html>
