<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사용방법안내                                                */
/*   Program ID   : helpLink.jsp                                                */
/*   Description  : 사용방법안내 링크를 위한 jsp 파일                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-04-01 윤정현                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import = "com.sns.jdf.util.*"%>
<html>
<head>
<title>e-HR</title>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form_j" method="post">
</form>
<script language="JavaScript">
<!--

open_help();

function open_help() {
    small_window=window.open('<%= WebUtil.JspURL %>help_online/help.jsp?param=contents.html', 'essHelp', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=no,width=850,height=600,left=100,top=100");
    document.form_j.target="essHelp";
    small_window.focus();    
}

//-->
</script>
</body>
</html>
