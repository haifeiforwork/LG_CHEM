<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    String    i_QKid = request.getParameter("QKID");    
    String    i_rows = request.getParameter("rows");        
%>

<html>
<head>

<title>ESS</title>

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<script language="JavaScript">
<!--
function doSearch(gubun,find1,find2) {

    document.form1.I_GUBUN.value = gubun;
    document.form1.I_INX_S.value = find1;
    document.form1.I_INX_E.value = find2;

    if ( gubun == "1" ) {
      document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03CompetencyListSV?rows=<%= i_rows %>";
    } else if ( gubun == "2" ) {    
        if ( document.form1.I_FIND.value == "" ) {
            alert("검색할 단어를 입력하세요!") 
            document.form1.I_FIND.focus();
            return;
        } else {
             document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03CompetencyListSV?rows=<%= i_rows %>";
        }
    }

    document.form1.method = "post";
    document.form1.target = "J03CompetencyMain";    
    document.form1.submit();
}  

function EnterCheck(i){
    if (event.keyCode == 13 && i == 2)  {
	    doSearch(i,'','');
	  }    
}

//--> 
</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="18" topmargin="18" rightmargin="18" bottommargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" onsubmit="return false">
  <input type="hidden" name="I_GUBUN" value="">
  <input type="hidden" name="I_INX_S" value="">
  <input type="hidden" name="I_INX_E" value="">
  <input type="hidden" name="QKID" value="<%= i_QKid %>">  

<table cellspacing=1 cellpadding=0 border=0 bgcolor=#999999 width=100%>
  <tr>
    <td bgcolor=#ffffff>
      <table cellspacing=0 cellpadding=0 border=0 width=100%>
        <tr>
          <td class=title01>&nbsp;&nbsp;Competency List</td>
          <td align=right><img src="<%= WebUtil.ImageURL %>jms/mvbg.jpg"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br>
<table cellspacing=1 cellpadding=0 border=0 width=100%>
  <tr>
    <td align=center background="<%= WebUtil.ImageURL %>jms/CompetencyList_bg.gif">
      <table width=624 border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td colspan=2><IMG SRC="<%= WebUtil.ImageURL %>jms/CompetencyList_01.gif" ALT="ㅈ" border="0" usemap="#Map"></TD>
        </tr>
        <tr>
          <td><IMG SRC="<%= WebUtil.ImageURL %>jms/CompetencyList_02.gif" ALT=""></td>
          <td>
            <table cellspacing=0 cellpadding=0 border=0 background="<%= WebUtil.ImageURL %>jms/CompetencyList_03.gif" width=275 height=34>
              <tr valign=top>
            	  <td width=212><input type="text" name="I_FIND" size=35 onKeyDown="javascript:EnterCheck('2')"></td>
            	  <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1><br><a href="javascript:doSearch('2','','');"><img src="<%= WebUtil.ImageURL %>jms/btn_search.gif" border=0 alt="조회"></a></td>
            	</tr>
            </table>
          </td>
        </tr>	
      </table>
    </td>
  </tr>
</table>
</form>
<map name="Map">
  <area shape="circle" coords="28,29,10" href="javascript:doSearch('1','가','나');" alt="ㄱ">
  <area shape="circle" coords="55,29,10" href="javascript:doSearch('1','나','다');" alt="ㄴ">
  <area shape="circle" coords="82,29,10" href="javascript:doSearch('1','다','라');" alt="ㄷ">
  <area shape="circle" coords="108,29,10" href="javascript:doSearch('1','라','마');" alt="ㄹ">
  <area shape="circle" coords="134,29,10" href="javascript:doSearch('1','마','바');" alt="ㅁ">
  <area shape="circle" coords="160,29,10" href="javascript:doSearch('1','바','사');" alt="ㅂ">
  <area shape="circle" coords="186,29,10" href="javascript:doSearch('1','사','아');" alt="ㅅ">
  <area shape="circle" coords="214,29,10" href="javascript:doSearch('1','아','자');" alt="ㅇ">
  <area shape="circle" coords="241,29,10" href="javascript:doSearch('1','자','차');" alt="ㅈ">  
  <area shape="circle" coords="268,29,10" href="javascript:doSearch('1','차','카');" alt="ㅊ">
  <area shape="circle" coords="294,29,10" href="javascript:doSearch('1','카','타');" alt="ㅋ">
  <area shape="circle" coords="320,29,10" href="javascript:doSearch('1','타','파');" alt="ㅌ">
  <area shape="circle" coords="346,29,10" href="javascript:doSearch('1','파','하');" alt="ㅍ">
  <area shape="circle" coords="371,29,10" href="javascript:doSearch('1','하','하');" alt="ㅎ">
  
  <area shape="rect" coords="21,47,36,65" href="javascript:doSearch('1','A','B');" alt="A">
  <area shape="rect" coords="39,47,54,65" href="javascript:doSearch('1','B','C');" alt="B">
  <area shape="rect" coords="56,47,71,65" href="javascript:doSearch('1','C','D');" alt="C">
  <area shape="rect" coords="73,47,88,65" href="javascript:doSearch('1','D','E');" alt="D">
  <area shape="rect" coords="91,47,106,65" href="javascript:doSearch('1','E','F');" alt="E">
  <area shape="rect" coords="108,47,123,65" href="javascript:doSearch('1','F','G');" alt="F">
  <area shape="rect" coords="125,47,142,65" href="javascript:doSearch('1','G','H');" alt="G">
  <area shape="rect" coords="143,47,158,65" href="javascript:doSearch('1','H','I');" alt="H">
  <area shape="rect" coords="159,47,173,65" href="javascript:doSearch('1','I','J');" alt="I">
  <area shape="rect" coords="173,47,187,65" href="javascript:doSearch('1','J','K');" alt="J">
  <area shape="rect" coords="188,47,202,65" href="javascript:doSearch('1','K','L');" alt="K">
  <area shape="rect" coords="205,47,219,65" href="javascript:doSearch('1','L','M');" alt="L">
  <area shape="rect" coords="222,47,238,65" href="javascript:doSearch('1','M','N');" alt="M">
  <area shape="rect" coords="242,47,257,65" href="javascript:doSearch('1','N','O');" alt="N">
  <area shape="rect" coords="260,47,274,65" href="javascript:doSearch('1','O','P');" alt="O">
  <area shape="rect" coords="276,47,293,65" href="javascript:doSearch('1','P','Q');" alt="P">
  <area shape="rect" coords="295,47,310,65" href="javascript:doSearch('1','Q','R');" alt="Q">
  <area shape="rect" coords="312,47,327,65" href="javascript:doSearch('1','R','S');" alt="R">
  <area shape="rect" coords="329,47,347,65" href="javascript:doSearch('1','S','T');" alt="S">
  <area shape="rect" coords="346,47,362,65" href="javascript:doSearch('1','T','U');" alt="T">
  <area shape="rect" coords="363,47,378,65" href="javascript:doSearch('1','U','V');" alt="U">
  <area shape="rect" coords="380,47,395,65" href="javascript:doSearch('1','V','W');" alt="V">
  <area shape="rect" coords="398,47,415,65" href="javascript:doSearch('1','W','X');" alt="W">
  <area shape="rect" coords="418,47,433,65" href="javascript:doSearch('1','X','Y');" alt="X">
  <area shape="rect" coords="434,47,448,65" href="javascript:doSearch('1','Y','Z');" alt="Y">
  <area shape="rect" coords="450,47,464,65" href="javascript:doSearch('1','Z','Z');" alt="Z">
</map>
<%@ include file="/web/common/commonEnd.jsp" %>
