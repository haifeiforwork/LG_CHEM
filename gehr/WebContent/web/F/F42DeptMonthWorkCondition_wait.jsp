<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 월간 부서 근태 집계표 wait 창                                         */
/*   Program ID   : F42DeptMonthWorkCondition_m.jsp                                   */
/*   Description  : 월간 부서 근태 집계표 wait 창                                         */
/*   Note         : 없음                                                        */
/*   Creation     : 2009-03-01  김종서                                         */
/*   Update       :                                          */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
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

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="doSubmit()" >
<form name="form1" method="post" action="" onsubmit="return false">
</form>

<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" class="td04" ><font color="#CC3300"><!-- 조회중입니다.  잠시만 기다려주십시요. --><%=g.getMessage("MSG.F.F41.0005")%></font></td>
  </tr>
</table>
</body>
</html>
