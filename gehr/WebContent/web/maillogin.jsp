<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page session="false" %>
<%
    String SSNO         = (String)request.getParameter("SSNO");
    String SServer      = (String)request.getParameter("SServer");
    String AINF_SEQN    = (String)request.getParameter("AINF_SEQN");
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

<Script Language="javascript">
<!--
	function EnterCheck(i)
	{
	    if (event.keyCode ==13 && i == 2) {
	        Check_Data();
	    }
	}

	function Check_Data()
	{
	    if (document.form1.webUserPwd.value == "" ){
	        alert("Password를 입력하세요!") ;
	        document.form1.webUserPwd.focus() ;
	        return ;
	    }
	    _actionPerform();
	}
	
	function _actionPerform() 
	{
	
	    var webUserPwd = document.form1.webUserPwd.value;
	    document.form1.webUserPwd.value = webUserPwd.toUpperCase( );
	    document.form1.method = "post";
	    document.form1.action = "<%= WebUtil.ServletURL %>hris.MailAutoLoginSV";
	    _submit();
	}

	function _submit() 
	{
	    document.form1.submit();
	}

//-->
</Script>
</head>
<body background="<%= WebUtil.ImageURL %>login/log_bg.gif" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="document.form1.webUserPwd.value='';document.form1.webUserPwd.focus();">
<table width="566" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="127" valign="bottom"><img src="<%= WebUtil.ImageURL %>login/log01_2.gif"></td>
  </tr>
  <tr>
    <td width="566" height="189" valign="top" background="<%= WebUtil.ImageURL %>login/log02.gif"><table width="566" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" colspan="3">&nbsp;</td>
        </tr>
        <tr> 
          <td width="282">&nbsp;</td>
          <td width="262" background="<%= WebUtil.ImageURL %>login/log09.gif"><table width="262" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="11"><img src="<%= WebUtil.ImageURL %>login/log03.gif"></td>
              </tr>
              <tr> 
                <td width="18" height="24">&nbsp;</td>
              </tr>
              <tr> 
                <td width="15"> 
                  <!--패스워드 테이블 시작-->
                  <form name="form1" method="post">
                  <input type="hidden" name="jobid"  value="login">
                    <table width="262" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="16">&nbsp;</td>
                        <td width="8"><img src="<%= WebUtil.ImageURL %>login/log08.gif" width="4" height="11"></td>
                        <td class="td03" width="58">패스워드</td>
                        <td width="100"> 
                        <input type="hidden" name="SSNO"  value="<%=SSNO%>">
                        <input type="hidden" name="SServer" value="<%=SServer%>">
                        <input type="hidden" name="AINF_SEQN" value="<%=AINF_SEQN%>">
                        <input type="password" name="webUserPwd" size="14" class="input03" onKeyDown="EnterCheck(2)"> 
                        </td>
                        <td><a href="javascript:Check_Data()"><img src="<%= WebUtil.ImageURL %>login/log_btn.gif" border="0"></a></td>
                      </tr>
                    </table>
                  </form>
                  <!--패스워드 테이블 끝-->
                </td>
              </tr>
              <tr align="center"> 
                <td><img src="<%= WebUtil.ImageURL %>login/log05.gif" width="242" height="1"></td>
              </tr>
              <tr> 
                <td height="16"></td>
              </tr>
              
              <tr> 
                <td height="12">&nbsp;</td>
              </tr>
              <tr> 
                <td height="13"><img src="<%= WebUtil.ImageURL %>login/log04.gif"></td>
              </tr>
            </table></td>
          <td width="22">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
