<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    TaxAdjustFlagData taxAdjustFlagData = ((TaxAdjustFlagData)session.getAttribute("taxAdjust"));
    Logger.debug.println(this, "###### taxAdjustFlagData : " + taxAdjustFlagData);
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess2.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function go_build(){
    if( <%= taxAdjustFlagData.canBuild %> ){
        document.form1.jobid.value = "first";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustDetailSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    } else {
        alert("소득공제신고서를 신청/수정/조회할 수 있는 기간이 아닙니다.");
    }
}

function go_detail(){
    if( <%= taxAdjustFlagData.canDetail %> ){

        document.form1.jobid.value = "";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D14TaxAdjustDetailSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    } else {
        alert("연말정산 내역조회를 할 수 있는 기간이 아닙니다.");
    }
}

//연말정산안내 메뉴 배경색 및 text Color 변경하기
function bgc(id) {
  if (id == "first") {
    first.style.backgroundColor="#7897FC" ;
    second.style.backgroundColor="#EBEBEB" ;
    third.style.backgroundColor="#EBEBEB" ;
  }
  if (id == "second") {
    first.style.backgroundColor="#EBEBEB" ;
    second.style.backgroundColor="#6699FF" ;
    third.style.backgroundColor="#EBEBEB" ;
  }
  if (id == "third") {
    first.style.backgroundColor="#EBEBEB" ;
    second.style.backgroundColor="#EBEBEB" ;
    third.style.backgroundColor="#6699FF" ;
  }
}

function fcg(id) {
  if (id == "forth") {
    forth.style.color="#FFFFFF";
    fifth.style.color="#333333";
    six.style.color="#333333";
  }
  if (id == "fifth") {
    forth.style.color="#333333";
    fifth.style.color="#FFFFFF";
    six.style.color="#333333";
  }
  if (id == "six") {
    forth.style.color="#333333";
    fifth.style.color="#333333";
    six.style.color="#FFFFFF";
  }
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="bgc('first');fcg('forth')">
<form name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td class="title01">연말정산안내</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>
        <table width="624" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="right">
            <a href="javascript:go_build();">
            <img src="<%= WebUtil.ImageURL %>btn_income.gif" width="110" height="20" border="0"></a> 
            <a href="javascript:go_detail();">
            <img src="<%= WebUtil.ImageURL %>btn_Tex.gif" width="122" height="20" border="0"></a></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
        <table width="624" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="386"> 
              <table width="386" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr> 
                  <td class="td03" width="80" id="first">
                  <a id="forth" href="<%=((WebUserData)session.getAttribute("user")).companyCode%>/D10YeartexDetail01.htm" onclick="bgc('first');fcg('forth')" target="Detail">주의사항</a></td>
                  <td class="td03" width="170" id="second">
                  <a id="fifth" href="<%=((WebUserData)session.getAttribute("user")).companyCode%>/D10YeartexDetail02.htm" onclick="bgc('second');fcg('fifth')" target="Detail">연말정산 
                    징수내역 계산절차</a></td>
                  <td class="td03" width="120" id="third">
                  <a id="six" href="<%=((WebUserData)session.getAttribute("user")).companyCode%>/D10YeartexDetail03.htm" onclick="bgc('third');fcg('six')" target="Detail">연말정산 
                    신청안내</a></td>
                </tr>
              </table>
            </td>
            <td class="font01" align="right"><%=taxAdjustFlagData.targetYear%></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
<!-- 숨겨진 필드 -->
    <input type="hidden" name="jobid"      value="">
    <input type="hidden" name="targetYear" value="<%=taxAdjustFlagData.targetYear%>">
<!-- 숨겨진 필드 -->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
