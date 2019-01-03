<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : 포탈로그인                                                  */
/*   2Depth Name  : 포탈로그인                                                  */
/*   Program Name : 포탈로그인                                                  */
/*   Program ID   : eplogin.jsp                                                 */
/*   Description  : 포탈로그인                                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-28 이승희                                           */
/*   Update       : C20130813_86689  2003-08-12 패스워드 수정창 사이즈 수정     */
/*   Update       :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="java.util.*,java.net.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%
    //String SSNO       = (String)request.getParameter("SSNO");
    //05.10.19 sso인증을 거쳐야 session 정보에 담기므로 보안을 위해서는 sso인증을 거쳐는지 확인하기위하여 수정함
    String SSNO       = (String)session.getAttribute("SYSTEM_ID");
    String SServer    = (String)request.getParameter("SServer");
    String MustPWChng = (String)request.getParameter("MustPWChng");
    String returnUrl  = (String)request.getParameter("returnUrl");

    if(returnUrl == null)
    {
  	  //returnUrl = "";
  	  returnUrl = WebUtil.ServletURL + "hris.A.A01SelfDetailSV";
	  }

    boolean isMustPWChng = false;

    if (MustPWChng != null && !MustPWChng.equals("")) {
        Logger.debug.println(this ,MustPWChng);
        isMustPWChng = new Boolean(MustPWChng).booleanValue();
    } // end if
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
        } // end if

	    _actionPerform();
	}

	function _actionPerform()
	{

	    var webUserPwd = document.form1.webUserPwd.value;
	    document.form1.webUserPwd.value = webUserPwd.toUpperCase( );
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
	    window.open( "<%= WebUtil.JspURL %>newpopup.jsp?SSNO="+v_no+"&returnUrl="+v_returnUrl, "chgPW", "width=440,height=250,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
	}

	function searchPassword() {
	    var v_no        = document.form1.SSNO.value;
	    var v_returnUrl = document.form1.returnUrl.value;
	    window.open( "<%= WebUtil.JspURL %>newpwmail.jsp?empNo="+v_no+"&returnUrl="+v_returnUrl, "chgPW", "width=320,height=140,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
	}

// [CSR ID:2574807]	
	function initPassword() {
		var v_no        = document.form1.SSNO.value;
	    var v_returnUrl = document.form1.returnUrl.value;
	    window.open( "<%= WebUtil.JspURL %>newpwmail.jsp?empNo="+v_no+"&returnUrl="+v_returnUrl, "chgPW", "width=320,height=140,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
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

</Script>
</head>
<body background="<%= WebUtil.ImageURL %>login/log_bg.gif" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
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
                          <input type="hidden" name="SSNO"   value="">
                          <input type="hidden" name="SServer"   value="<%=SServer%>">
                          <input type="hidden" name="returnUrl" value="<%=returnUrl%>">
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
              <tr align="center">
                <td>
                  <!--패스워드 찾기버튼 테이블 시작-->
                  <table width="200" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <!-- [CSR ID:2574807] -->
                      <!-- <td><a href="javascript:searchPassword();"><img src="<%= WebUtil.ImageURL %>login/log06.gif" width="89" height="14" border="0"></a></td>  -->
                      <td><a href="javascript:initPassword();"><img src="<%= WebUtil.ImageURL %>login/btn_reset.gif" border="0"></a></td>
                      <td width="17">&nbsp;</td>
                      <td><a href="javascript:chgPassword();"><img src="<%= WebUtil.ImageURL %>login/btn_modify.gif" border="0"></a></td>
                    </tr>
                  </table>
                  <!--패스워드 찾기버튼 테이블 끝-->
                </td>
              </tr>
              <tr>
                <td height="12">&nbsp;</td>
              </tr>
              <tr>
                <td height="13"><img src="<%= WebUtil.ImageURL %>login/log04.gif"></td>
              </tr>
            </table>
          </td>
          <td width="22">&nbsp;</td>
        </tr>

      </table></td>
  </tr>
  <tr>
    <td height="25" class="td05"><!-- ※ 패스워드는 기존 ESS 와 동일 합니다.--></td>
  </tr>
</table>
</body>
<form name=test>
<input type=hidden name=ser value="97">
</form>
</html>
<%
Logger.debug.println(this, "[encoding system_id:" + java.net.);
Logger.debug.println(this, "[encoding system_id:" + (String)session.getAttribute("SSO_ID"));
%>