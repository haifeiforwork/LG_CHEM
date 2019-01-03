<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*"%>
<%@ page session="false" %>
<%
    String empNo = request.getParameter("empNo");
%>

<HTML>
<HEAD>
<TITLE> 비밀번호 초기화</TITLE>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<style type=text/css>
/*ixss*/

table{border-top:solid 2px #ee8aa3;}
td { font-size: 12px; font-family: malgun gothic ;color:#6a6a6a;padding:5px 3px 4px 3px;border-bottom:solid 1px #dfdfdf;}
img {border: none;}
a {text-decoration:none}
a:hover {text-decoration: underline}

/*form*/
input {font-size: 12px; font-family: 굴림 ; color:#000000;}
.box03 { font-size:12px; font-family: 굴림 ; border:1px solid #B6AE9B; color:#666666; padding:2 0 0 5px}

/*color*/
.c, a.c:link, a.c:visited, a.c:hover, a.c:active{color:#6a6a6a}
</style>
<Script Language="javascript">
<!--
function CheckReg(obj) {
  //chkResnoObj_1(obj); [CSR ID:2645061] 인사 password 초기화 기능 수정 외국인의 경우 수정을 할 수 없음.
}

function EnterCheck(i){
  if (event.keyCode ==13 && i == 2) {
    searchPW();
  }
}

function searchPW(){
    if( document.form1.empname.value == "" ) {
       alert("성명을 입력하세요.");
       document.form1.empname.focus();
       return;
    }

    if( document.form1.regno.value == "" ) {
       alert("주민번호를 입력하세요.");
       document.form1.regno.focus();
       return;
    }

    document.form1.empNo.value = "<%= empNo %>";
    //document.form1.action = "<%= WebUtil.ServletURL %>hris.SearchPasswordSV";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.InitPasswordSV";
    document.form1.submit();
}

-->
</script>
</HEAD>

<BODY onload="document.form1.empname.focus();">
<form method=post name=form1>
<table width=300 border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td width=150 height=30 bgcolor=#F5F5F5 style='padding:0 0 0 15' class='c'>성명</td>
		<td width=150 style='padding-left:15px'><input type=text name=empname style='width:136px' class='box03'></td>
	</tr>
	<tr>
		<td height=29 bgcolor=#F5F5F5 style='padding:0 0 0 15' class='c'>생년월일</td>
		<td style='padding-left:15px'><input type=text name=regno style='width:136px' class='box03' onKeyDown="EnterCheck(2)" maxlength="6" onBlur="CheckReg(this)"></td>
	</tr>
	<tr>
		<td colspan="2" style="border:none;">			
			<div style="color:#e46a88;font-size:11px;padding-bottom:7px;">※ 생년월일 : 주민등록번호 앞 여섯자리를 입력하세오.</div>	
		</td>
	</tr>
	<tr>
	<!-- [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정 : 이미지 수정  -->
		<td colspan=2 align=center style='padding-top:5px;border:0 none;'>&nbsp;
			<a href="javascript:searchPW()"><IMG src="<%= WebUtil.ImageURL %>btn_reset_2.gif" alt="초기화" BORDER=0></a>&nbsp;
			<a href="javascript:this.close()"><IMG src="<%= WebUtil.ImageURL %>btn_close.gif" alt="닫기" BORDER=0></a></td>
	</tr>
</table>
<input type="hidden" name="webUserPwd"  value="">
<input type="hidden" name="empNo" value="">
</form>
</BODY>
</HTML>
