<%/******************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 연봉협의서 wait 창                                          */
/*   Program ID     : A11AnnSalaryAgreementPrintEurpWait.jsp                                   */
/*   Description     : 연봉협의서 wait 창                                          */
/*   Note             : 없음                                                        */
/*   Creation        : 2010-07-21  yji                                          */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
 
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
 
<%
    WebUserData user = (WebUserData)session.getAttribute("user");
    String targetPage     = request.getParameter("targetPage");
    String pernr     = request.getParameter("pernr");  
    
    if( pernr != null && !pernr.equals("") ){
        targetPage = targetPage + "&pernr="+ pernr;
    }

%>

<html>
<head>
<title>연봉협의서 검색중...</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="javascript">
<!--
function doSubmit(){
    document.form1.action = "<%=targetPage%>";
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
    <td align="center" class="td04" ><font color="#CC3300">Checking now. Please wait for a while.</font></td>
  </tr>
</table>
</body>
</html>
