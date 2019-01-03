<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 인사기록부 wait 창                                          */
/*   Program ID   : A01PersonalCardWait_m.jsp                                   */
/*   Description  : 인사기록부 wait 창                                          */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-21  윤정현                                          */
/*   Update       : 2006-03-20  @v1.1 조직통계->global 인재pool에서 상세조회연결추가*/
/*                                                                              */
/*   Update       : 2014-02-10 C20140210_84209  구분추가*/
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
 
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
 
<%
    WebUserData user = WebUtil.getSessionUser(request);
    String targetPage     = request.getParameter("targetPage");
    String pernr     = request.getParameter("pernr"); //@v1.1
    String Screen  = (String)request.getParameter("Screen"); //C20140210_84209
    
    if( pernr != null && !pernr.equals("") ){
        targetPage = targetPage + "&pernr="+ pernr+"&Screen="+Screen;
    }

%>

<html>
<head>
<title>사원 검색중...</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

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
    <td align="center" class="td04" ><font color="#CC3300">조회중입니다.  잠시만 기다려주십시오.</font></td>
  </tr>
</table>
</body>
</html>
