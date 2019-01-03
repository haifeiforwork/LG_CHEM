<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="java.util.*,java.net.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.N.EHRCommonUtil" %>

<%

	String SSNO       = (String)session.getAttribute("SYSTEM_ID");
	String SServer    = (String)request.getParameter("SServer");
	String MustPWChng = (String)request.getParameter("MustPWChng");
	String returnUrl  =WebUtil.nvl( (String)request.getParameter("returnUrl"));
	String menuCode  = WebUtil.nvl((String)request.getParameter("menuCode"));
	String AINF_SEQN  = WebUtil.nvl((String)request.getParameter("AINF_SEQN"));
	String year  = WebUtil.nvl((String)request.getParameter("year"));
	String month  = WebUtil.nvl((String)request.getParameter("month"));

	// 월별 일별 근태
	if(returnUrl.startsWith("OT") || returnUrl.startsWith("MW")){
  		HashMap valueHM= EHRCommonUtil.dataConvert(returnUrl);
  		menuCode = (String)valueHM.get("menuCode");
  		year    = (String)valueHM.get("year");
  		month = (String)valueHM.get("month");
  		returnUrl ="Y";
  	}

	boolean isMustPWChng = false;

	if (MustPWChng != null && !MustPWChng.equals("")) {
	    Logger.debug.println(this ,MustPWChng);
	    isMustPWChng = new Boolean(MustPWChng).booleanValue();
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<title>LG화학 e-HR 시스템</title>
	<meta name="description" content="LG화학 e-HR 시스템" />
<style>
body {font-family: dotum, '돋움', Arial, Helvetica, sans-serif;}
ul, li {list-style:none;}
img {border:none;}
.loginBox {position: absolute;left: 50%;top: 50%;width: 704px;height: 321px;margin: -160px 0 0 -352px;background: #ffffff;}
.loginHeader {position: relative;height: 39px;border-top: 1px solid #000000;border-bottom: 1px solid #000000;background: url(../../images/bg_header.gif) repeat-x;margin-bottom:-16px;}
.loginHeader img {position: absolute;left: 0px;top: 0px;}

.loginContent {position: relative;height: 233px;width: 702px;border-left: 1px solid #d9d9d9;border-right: 1px solid #d9d9d9;}
.loginContent .mainImage {position: absolute;left: 24px;top: 22px;}
.loginContent ul {position: absolute;top: 24px;left: 359px;}
.loginContent ul.inputGr {position: absolute;left: 320px;top: 6px;}
.loginContent ul.inputGr li {width: 219px;height: 32px;}
.loginContent ul.inputGr li.input_pw {background: url(../../images/sshr/input_password.gif) no-repeat;margin: 8px 0 0 0;}
.loginContent ul.inputGr li input {background: none;border: none;color: #000000;font-size: 14px;margin: 7px 0 0 90px;width: 120px;}
.loginContent .btn_login {position: absolute;top: 22px;left: 587px;}
.loginContent div.option {position: absolute;top: 127px;left: 315px;}
.loginContent div.option label.chck01 {font-weight: bold;color: #888;}
.loginContent div.option ul {position: absolute;top: 0;left: 110px;width: 220px;text-align: left;}
.loginContent div.option ul li {display: inline;color: #888888;margin-left:5px;}
.loginContent div.option ul li input {position:relative; top:2px;}
.loginContent div.option ul label {font-size: 11px;}
.loginContent ul.btnArea {position: relative;top: 175px;left:428px;}
.loginContent ul.btnArea li {display: inline;margin-right: 2px;}

.loginFooter {position: relative;height: 45px;width: 702px;background: #f1f1f1;border: 1px solid #d9d9d9;border-top: none;}
.loginFooter h1 {font-size: 11px;color: #888888;position: absolute;top: 12px;left: 25px;}
.loginFooter h1 span {margin: 0 10px 0 7px;font-weight: 100;}
.loginFooter img {position: absolute;right: 27px;top: 15px;}
</style>


<script Language="javascript">
<!--

	function EnterCheck(i)
	{

	    if (event.keyCode ==13 ) {
	        Check_Data();
	    }
	}

	function Check_Data()
	{
	    if (document.form1.webUserPwd.value == "" ){
	        alert("Password를 입력하세요!") ;
	        document.form1.webUserPwd.focus() ;
	        return ;
        } // end if

	    _actionPerform();
	}

	function _actionPerform()
	{

	    var webUserPwd = document.form1.webUserPwd.value;
	    document.form1.webUserPwd.value = webUserPwd.toUpperCase();
	    document.form1.method = "post";
	    document.form1.action = "<%= WebUtil.ServletURL %>hris.EPLoginSV";
	    _submit();
	}

	function _submit()
	{
	    document.form1.submit();
	}

	function chgPassword()
	{
	    var v_no        = document.form1.SSNO.value;
	    var v_returnUrl = document.form1.returnUrl.value;
	    //C20130813_86689
	    window.open( "<%= WebUtil.JspURL %>newpopup.jsp?SSNO="+v_no+"&returnUrl="+v_returnUrl+"&menuCode=<%=menuCode%>&AINF_SEQN=<%=AINF_SEQN%>&year=<%=year%>&month=<%=month%>", "chgPW", "width=440,height=250,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
	}

	function searchPassword() {
	    var v_no        = document.form1.SSNO.value;
	    var v_returnUrl = document.form1.returnUrl.value;
	    window.open( "<%= WebUtil.JspURL %>newpwmail.jsp?empNo="+v_no+"&returnUrl="+v_returnUrl+"&menuCode=<%=menuCode%>&AINF_SEQN=<%=AINF_SEQN%>&year=<%=year%>&month=<%=month%>", "chgPW", "width=320,height=140,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
	}

// [CSR ID:2574807]
	function initPassword() {
		var v_no        = document.form1.SSNO.value;
	    var v_returnUrl = document.form1.returnUrl.value;
	    window.open( "<%= WebUtil.JspURL %>newpwmail.jsp?empNo="+v_no+"&returnUrl="+v_returnUrl+"&menuCode=<%=menuCode%>&AINF_SEQN=<%=AINF_SEQN%>&year=<%=year%>&month=<%=month%>", "chgPW", "width=320,height=140,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
	}

	function init()
	{
	   var day = "<%=DataUtil.getCurrentDay()%>";
	   var time = <%=Integer.parseInt(DataUtil.getCurrentTime())%>;
	   var date = "<%=DataUtil.getCurrentDate()%>";
	  // var  datetm =  <%=DataUtil.getCurrentDate()%><%=Integer.parseInt(DataUtil.getCurrentTime())%>;
	   var  datetm =  <%=DataUtil.getCurrentDate()%><%= DataUtil.getCurrentTime() %>;

	   //매주일요일 20-24, 월요일:0-1시까지 eloffice백업으로시스템 shutdown
	   if ( (day == 1 && time>200000 ) || (day == 2 && time<010000 ) )
	      winNoticOpen('backup');

	   if ( (datetm >= 20080715000000  ) && (datetm <= 20080720090000  ) )

	      winNoticOpen('0609');

	   if(<%=isMustPWChng%>) {
	       chgPassword();
	   } else {
	       document.form1.webUserPwd.value='';
               //document.form1.webUserPwd.focus();
	   } // end if
	   //winNoticOpen('notice');
	} // end function

  //알림추가05.12.01
  function winNoticOpen(gubun){
    var url="<%=WebUtil.JspURL%>"+"notice.jsp?gubun="+gubun;
    var win = window.open(url,"notice","width=440,height=300,left=365,top=70,scrollbars=no");
  	win.focus();
  }
//-->

</script>
</head>
<body id="loginBody" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onload="init()">

<div class="loginBox">
  <div class="loginHeader">
    <img src="<%= WebUtil.ImageURL %>sshr/logo_header.gif" />
  </div>
  <div class="loginContent">
    <img class="mainImage" src="<%= WebUtil.ImageURL %>sshr/img_main.png" alt="메인이미지" />
	<form name="form1" method="post" id="ehrLogin">
    <ul class="inputGr">
        <li class="input_pw" style="margin-top:0;">
      		<input type="hidden" name="jobid"  value="login">
      	 	<input type="hidden" name="SSNO"   value="">
          	<input type="hidden" name="SServer"   value="<%=SServer%>">
            <input type="hidden" name="returnUrl" value="<%=returnUrl%>">
            <input type="hidden" name="menuCode" value="<%=menuCode%>">
            <input type="hidden" name="AINF_SEQN" value="<%=AINF_SEQN%>">
            <input type="hidden" name="year" value="<%=year%>">
            <input type="hidden" name="month" value="<%=month%>">
            <input type="hidden" name="potalYN" value="Y">
        	<input type="password" value="1234" name="webUserPwd" onclick="this.style.backgroundImage='none'" onKeyDown="EnterCheck(2)" />
        </li>
    </ul>
      <a class="btn_login" href="javascript:Check_Data()"><img src="<%= WebUtil.ImageURL %>sshr/btn_login_small.gif" alt="로그인" /></a>
    <div class="option" style="top:45px;">
      <ul>
        <li><input type="radio" id="rdo01" class="radio" name="mode" checked="checked"><label for="rdo01">Korean</label></li>
        <li><input type="radio" id="rdo02" class="radio" name="mode"><label for="rdo02">Chinese</label></li>
        <li><input type="radio" id="rdo03" class="radio" name="mode"><label for="rdo03">English</label></li>
      </ul>
    </div>
	<ul class="btnArea">
		<li><a href="javascript:initPassword();"><img src="<%= WebUtil.ImageURL %>sshr/btn_pwreset.gif" alt="패스워드 초기화" /></a></li>
		<li><a href="javascript:chgPassword();"><img src="<%= WebUtil.ImageURL %>sshr/btn_pwchange.gif" alt="패스워드 수정" /></a></li>
	</ul>
	</form>
  </div>
  <div class="loginFooter">
    <h1><span>You need an password.</span></h1>
    <img src="<%= WebUtil.ImageURL %>logo_lgchem.gif" alt="logo" />
  </div>
</div>
</body>
</html>