<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="err/error.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="com.lgcns.*"%>
<%@ page session="true" %>
<%
		//Crypto cr = new Crypto();
		//String aa;
		//aa = cr.Encrypt("6702251335013");
		//out.println(" 6702251335013      97: 복호화:"+aa);
		//aa = cr.Encrypt("7908221155918");
		//out.println(" 7908221155918      97: 복호화:"+aa);
		// 
		//out.println("decrypt:"+cr.Decrypt("PgYdvIlmoFJRBX+ssAXxEg=="));
		//out.println(cr.Decrypt(aa));	         
		out.println("    97 " );  

%>
<html>
<head>
  <title>ESS</title>
  <link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">
	
	<Script Language="javascript">
	<!--
	function EnterCheck(i){
	if (event.keyCode ==13 && i == 1)  {
		document.log.webUserPwd.focus();
	}
    if (event.keyCode ==13 && i == 2) {
        document.log.empNo.focus();
    }
	if (event.keyCode ==13 && i == 3 ){
		Check_Data() ;
	}
}

    function Check_Data(){ 
	
    if ( document.log.webUserId.value == "" )  
	{ 
		alert("Login ID를 확인 하세요!") 
		document.log.webUserId.focus();
		return ;  
	}
	if (document.log.webUserPwd.value == "" ){
		alert("PassWord를 확인 하세요!") ;
		document.log.webUserPwd.focus() ;
		return ; 
	}	
    if (document.log.empNo.value == "" ){
		alert("검색사번을 확인 하세요!") ;
		document.log.empNo.focus() ;
		return ; 
	}	
	   _actionPerform();
    }

	function _actionPerform() {
		//"로그인" 버튼을 누른경우
	
			document.log.method = "post";
			document.log.action = "<%= WebUtil.ServletURL %>hris.AdminLoginSV";
			//document.log.action = "<%= WebUtil.ServletURL %>hris.DirectLoginSV";
			_submit();
	}
		
	
	function _submit() {
		document.log.submit();
	}
	//-->
	</Script>
	</head>
	
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<% Logger.debug.println(this ,request.getRemoteAddr());%>

<table width="600" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr>
    <td>
      <table width="600" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%= WebUtil.ImageURL %>login/login01.gif" width="300" height="150"></td>
          <td><img src="<%= WebUtil.ImageURL %>login/login03.gif" width="300" height="150"></td>
        </tr>
        <tr> 
          <td><img src="<%= WebUtil.ImageURL %>login/login02.gif" width="300" height="150"></td>
          <td valign="bottom"> 
            <form name="log" method="post">
              <table width="270" border="0" cellspacing="1" cellpadding="2" align="center">
                <tr> 
                  <td class="td03" width="100">Login ID</td>
                  <td width="115" align="center"> 
                    <input type="text" name="webUserId" size="15" value="" class="input03" onKeyDown="EnterCheck(1)">
                  </td>
                  <td width="55">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="td03" width="100">Password</td>
                  <td align="center" width="115"> 
                    <input type="password" name="webUserPwd" size="15" value="" class="input03" onKeyDown="EnterCheck(2)">
                  </td>
                  <td width="55">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="td03" width="100">검색사번</td>
                  <td width="115" align="center"> 
                    <input type="text" name="empNo" size="15" value="" class="input03" onKeyDown="EnterCheck(3)">
                  </td>
                 <td width="55"><a href="javascript:Check_Data()"><IMG src="<%= WebUtil.ImageURL %>login/btn_login.gif" BORDER=0></a></td>
                </tr>
              </table>
              <input type=hidden name=remoteIP value="165.243.32.213">
            </form>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>

