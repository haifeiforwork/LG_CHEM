<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : 패스워드 수정                                               */
/*   2Depth Name  : 패스워드 수정                                               */
/*   Program Name : 패스워드 수정                                               */
/*   Program ID   : newpopup.jsp                                                */
/*   Description  : 패스워드 수정                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-28 이승희                                           */
/*   Update       : C20130813_86689  2013-08-12 문자+숫자 조합 시 10자리 이상, 문자+숫자+특수문자 조합 시 8자리 이상으로 설정  */
/*   Update       :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정 (복잡도 부분 수정)                      */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils" %>
<%@ page session="false" %>

<%
   String SSNO  = (String)request.getParameter("SSNO");
	String message = (String)request.getAttribute("msg");
    String jobid = (String)request.getAttribute("jobid");    
%>

<HTML>
<HEAD>
<TITLE> 비밀번호 수정 </TITLE>
<style type=text/css>
/*ixss*/
table{border-top:solid 2px #ee8aa3;}
td { font-size: 12px; font-family: malgun gothic ;color:#6a6a6a;padding:5px 3px 4px 3px;border-bottom:solid 1px #dfdfdf;}
img {border: none;}
a {text-decoration:none}
a:hover {text-decoration: underline}

/*form*/
input {font-size: 12px; font-family: 굴림 ; color:#6a6a6a;}
.box03 { font-size:12px; font-family: 굴림 ; border:1px solid #B6AE9B; color:#666666; padding:2 0 0 5px}

/*color*/
.c, a.c:link, a.c:visited, a.c:hover, a.c:active{color:#6a6a6a}
</style>
<script>
<!--
function isSameID(str,val){
    IDval = str.elements[0].value;
    if(val == IDval){
        alert("아이디와 비밀번호가 같습니다.\n보안 상의 이유로 아이디와 같은 비밀번호는 허용하지 않습니다.");
        return false;
    }else{
        return true;
    }
}

	function EnterCheck(i)
	{
	    thisFrm = document.form1;
	    if (event.keyCode ==13 && i == 1) {
	      thisFrm.new_webUserPwd1.focus();
	    } else if (event.keyCode ==13 && i == 2) {
	      thisFrm.new_webUserPwd2.focus();
	    } else if (event.keyCode ==13 && i == 3) {
	      submitModPwd();
	    }
	}

	function submitModPwd()
	{
	    thisFrm = document.form1;
	    /**
	    * 비밀번호 체크
	    * 1) 빈값 던지는거 막기
	    * 2) 중간에 space 막기
	    * 3) 소문자+숫자+자릿수 넣기 
	    */
	    if( thisFrm.webUserPwd.value == "" ) {
	       alert("비밀번호를 입력하세요.");
	       thisFrm.webUserPwd.focus();
	       return;
	    } // end if
	    
	    if( thisFrm.new_webUserPwd1.value == "" ) {
           alert("새 비밀번호를 입력하세요.");
           thisFrm.new_webUserPwd1.focus();
           return;
        } // end if
        
        if( thisFrm.new_webUserPwd2.value == "" ) {
           alert("새 비밀번호 확인을 입력하세요.");
           thisFrm.new_webUserPwd2.focus();
           return;
        } // end if
	    
        /*if( thisFrm.new_webUserPwd1.value != thisFrm.new_webUserPwd2.value ) {
           alert("새 비밀번호와 새 비밀번호 확인이 \n 다르게 입력 되었습니다");
           thisFrm.new_webUserPwd1.select();
           thisFrm.new_webUserPwd1.focus();
           return;
        } // end if
        
         if( thisFrm.webUserPwd.value == thisFrm.new_webUserPwd1.value ) {
           alert("현재 비밀번호와 새 비밀번호 같습니다.\n 다르게 입력하세요");
           thisFrm.webUserPwd.focus();
           return;
        } // end if
        
         if( thisFrm.SSNO.value == thisFrm.new_webUserPwd1.value ) {
           alert("사번과 새 비밀번호 같습니다.\n 다르게 입력하세요");
           thisFrm.webUserPwd.focus();
           return;
        } // end if
        */
        
	    
	    if(!validPWD(thisFrm.new_webUserPwd1.value)){
//	       thisFrm.new_webUserPwd1.select();
//	       thisFrm.new_webUserPwd1.focus();
	       thisFrm.webUserPwd.focus();
	       return;
	    }

	    thisFrm.webUserPwd.value = thisFrm.webUserPwd.value.toUpperCase();
	    thisFrm.new_webUserPwd1.value = thisFrm.new_webUserPwd1.value.toUpperCase();
	    thisFrm.new_webUserPwd2.value = thisFrm.new_webUserPwd2.value.toUpperCase();//[CSR ID:2574807]sap에서 password 체크로 인해 확인 값 추가 
	    thisFrm.action = "<%= WebUtil.ServletURL %>hris.ChangePasswordSV";
	    thisFrm.submit();
	}

    function validPWD(str) 
    {
	    /* check whether input value is included space or not  */
	    if( checkSpace( str )) {
	        alert("비밀번호는 빈공간 없이 연속된 영문 소문자와 숫자만 사용할 수 있습니다.");
	        clear();
	        return false;
	    } // end if
	    
	   /* SAP에서 동시 체크부분 삭제
	   var cnt=0;
	    for( var i=0; i < str.length; ++i) {
	        if( str.charAt(0) == str.substring( i, i+1 ) ) ++cnt;
	    } // end for

	    if( cnt == str.length ) {
	        alert("보안상의 이유로 한 문자로 연속된 비밀번호는 허용하지 않습니다.");
	        return false;
	    }*/
	
	    /* limitLength */
	    var isPW = /^[a-zA-Z0-9]{10,13}$/;
	    
            //2013.08.12 modi  특수문자 체크                                                                                                   
	    //var isPW = /([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9]){8,13}$/; //문자, 숫자, 특수문자   

	    
	    if( !isPW.test(str) ) {
	        alert("비밀번호는 10~13자의 영문 소문자와 숫자만 사용할 수 있습니다.");
	        //alert("비밀번호는 8~13자의 중간에 문자, 숫자, 특수문자를 포함하는 조합으로 사용할 수 있습니다.");
	        clear();
	        return false;
	    }
	    //C20130813_86689  2013.08.12 add
   	    var RegN = /([0-9])/; 
   	    var RegA = /([a-zA-Z])/; 
   	    
   	    if ( !( RegN.test(str) && RegA.test(str) )) { 
   	        alert("비밀번호는 문자, 숫자의 조합으로 10자리 이상 13자리 이내로 입력해주세요."); 
   	        clear();
   	        return false; 
   	    }  
	    /* SAP에서 동시 체크부분 삭제
   	    if(/(\w)\1\1/.test(str))
   	    {
	        alert("비밀번호에 같은 문자를 3번 이상 사용하실수 없습니다");
	        return false;
   	    }*/

	    return true;
	}

	function checkSpace( str )
	{
	    if(str.search(/\s/) != -1){
	        return true;
	    } else {
	        return false;
	    }
	}

function validRPWD(str ,order){
    val = str.elements[order].value;
    if(val == ""){
        alert("비밀번호 확인을 입력하세요.");
        return 2;
    }
    preVal = str.elements[order-1].value;
    if(val != preVal){
        alert('비밀번호가 일치하지 않습니다');
        return 0
    }
    return 1;
}

function init(){
<% if (message != null && !message.equals("")) {%>
        alert('<%= message %>');
    <% } // end if %>
}

function clear(){
	 thisFrm = document.form1;
	 thisFrm.webUserPwd.value = "";
	 thisFrm.new_webUserPwd1.value = "";
	 thisFrm.new_webUserPwd2.value = "";
}
-->
</script>
</HEAD>

<BODY onload="document.form1.webUserPwd.focus();init();">
<form method=post name=form1>

 <table width=430 style="border:0;">
 
   <tr><td class="td02" width="100%" style="border:0;">
      <div style="color:#e46a88;font-weight:bold;padding-bottom:7px;">※ 비밀번호 규칙</div>
     
     	<div style="padding-bottom:5px">
     	- 10~13자의 영문,숫자 를 조합하여 사용하실 수 있습니다.
      <br>- 생년월일,전화번호 등 개인정보와 관련된 숫자,연속된 숫자와 같이 쉬운
      <br>&nbsp;&nbsp;&nbsp;비밀번호는 다른 사람이 쉽게 알아낼 수 있으니 사용을 자제해 주세요.
		</div>
     </td></tr>  
 </table>
<table width=430 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td width=200 height=30 bgcolor=#F5F5F5 style='padding:0 0 0 15' class='c'>아이디</td>
        <td width=200 style='padding-left:15px'><input type=text name="webUserId" style='width:136px' class='box03' value="<%=ServletRequestUtils.getStringParameter(request, "webUserId", "")%>" ></td>
    </tr>
  <tr>
    <td width=200 height=30 bgcolor=#F5F5F5 style='padding:0 0 0 15' class='c'>현재 비밀번호</td>
    <td width=200 style='padding-left:15px'><input type=password name="webUserPwd" style='width:136px' class='box03' onKeyDown="EnterCheck(1)"></td>
  </tr>
  <tr>
    <td height=29 bgcolor=#F5F5F5 style='padding:0 0 0 15' class='c'>새 비밀번호</td>
    <td style='padding-left:15px'>
        <input type=password name="new_webUserPwd1" style='width:136px' class='box03' onfocus="this.select()" onKeyDown="EnterCheck(2)">
    </td>
  </tr>
  <tr>
    <td height=29 bgcolor=#F5F5F5 style='padding:0 0 0 15' class='c'>새 비밀번호 확인</td>
    <td style='padding-left:15px'>
        <input type=password name="new_webUserPwd2" style='width:136px' class='box03' onfocus="this.select()" onKeyDown="EnterCheck(3)">
    </td>
  </tr>
  <tr>
    <td colspan=2 align=center style='padding-top:12px;border:0 none;'>
    	<a href="javascript:submitModPwd()"><IMG src="<%= WebUtil.ImageURL %>ehr_button/btn_save.gif" alt="저장" BORDER=0></a>
    	<a href="javascript:document.forms[0].reset();document.forms[0].pwd.focus();"><IMG src="<%= WebUtil.ImageURL %>btn_cancel.gif" alt="취소" BORDER=0></a>
    	<a href="javascript:this.close()"><IMG src="<%= WebUtil.ImageURL %>btn_close.gif" alt="닫기" BORDER=0></a></td>
  </tr>
</table>
<input type="hidden" name="SSNO" value="<%=SSNO%>">
<input type="hidden" name="jobid"  value="chngpw">
</form>
</BODY>
</HTML>
