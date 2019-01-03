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
	<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>css/ehr_style.css" />
	
	
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
<div class="loginWrapper">
	<div class="loginBox"> 
		<div class="visual"></div>
		<div class="loginForm">
			<h2><span>e HR System</span></h2>
			<div class="ment"><span>안녕하세요,</span> <br />eHR시스템에 오신 것을 환영합니다.</div>		
			<form name="form1" method="post" id="ehrLogin">
				<div class="loginInput" id="txtPw">
					<div class="pwInput">
                  		<input type="hidden" name="jobid"  value="login">				
                  	 	<input type="hidden" name="SSNO"   value="">
                      	<input type="hidden" name="SServer"   value="<%=SServer%>">
                        <input type="hidden" name="returnUrl" value="<%=returnUrl%>">
                        <input type="hidden" name="menuCode" value="<%=menuCode%>">
                        <input type="hidden" name="AINF_SEQN" value="<%=AINF_SEQN%>">
                        <input type="hidden" name="year" value="<%=year%>">
                        <input type="hidden" name="month" value="<%=month%>">
                        <input type="hidden" name="potalYN" value="Y">	
						<label for="password">password</label><input type="password" name="webUserPwd" onclick="this.style.backgroundImage='none'" onKeyDown="EnterCheck(2)">
						<a href="javascript:Check_Data()"><img src="<%= WebUtil.ImageURL %>ehr_common/login_btn.gif" alt="로그인" /></a>	
					</div>
				</div>
			<div class="btn">
				<a href="javascript:initPassword();" class="resetPw">패스워드 <strong>초기화</strong></a>
				<a href="javascript:chgPassword();" class="editPw">패스워드 <strong>수정</strong></a>
			</div>
			</form>
		</div><!-- /loginForm  -->
		
		<!-- logout -->
		<div class="loginForm" style="top:160px;display:none;">
			<h2><span>e HR System</span></h2>
			<div class="ment"><span style="font-weight:bold;">LOG OUT</span> <br />로그아웃 되었습니다.</div>	
		</div><!-- /logoutForm  -->
		
	</div><!-- /loginBox  -->
</div><!-- /loginWrapper -->
<div class="loginFooter"><span>(C) Copyright 2015 by LG Chem. All Rights reserved.</span></div>
						
</body>
</html>