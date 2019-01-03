<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : LG화학 Edu-World                                            */
/*   Program Name : LG화학 Edu-World                                            */
/*   Program ID   : EduWorldLogin.jsp                                           */
/*   Description  : LG화학 Edu-World 로그인 후 창 띄움                          */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-02  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = (WebUserData)session.getAttribute( "user" );
%>

<html>
<head>
<title>ESS</title>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form_j" method="post">
</form>
<script language="JavaScript">
<!--

openMatrix('R', 'JobMatrix');

// <<< Job Description 관리 >>>
//팀원 Job Description 조회('R', 'JobMatrix'), Job Description 조회ㆍ수정ㆍ생성('C', 'JobCreate')
function openMatrix(gubun, windowName) {
    width  = screen.width*8/10;
    height = screen.height*6/10;
    vleft  = screen.width*1/10;
    vtop   = screen.height*1/10;

    window.open("",windowName,"toolbar=no,location=no,directories=no,status=yes,menubar=yes,resizable=yes,scrollbars=yes,left="+vleft+",top="+vtop+",width="+width+",height="+height);
    document.form_j.action="<%= WebUtil.JspURL %>J/J_main.jsp?gubun="+gubun;

    document.form_j.target=windowName;
    document.form_j.submit();
}

//-->
</script>
</body>
</html>
