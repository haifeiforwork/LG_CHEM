<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData     user               = (WebUserData)session.getAttribute("user");

//  휴가신청
    Vector          d03VocationData_vt = null;
    D03VocationData data               = null;

//  결제정보를 vector로 받는다
    Vector          AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess3.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
// 달력 사용
function fn_openCal(Objectname){
  var lastDate;
  lastDate = eval("document.form1." + Objectname + ".value");
  small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
  small_window.focus();
}

function fn_openCal(Objectname, moreScriptFunction){
  var lastDate;
  lastDate = eval("document.form1." + Objectname + ".value");
  small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?moreScriptFunction="+moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
  small_window.focus();
}

// 신청..
function doSubmit() {
    if( check_data() ) {
//     buttonDisabled();
        document.form1.jobid.value = "create";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D07Maternity.D07MaternityBuildSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

// data check..
function check_data(){
  if( checkNull(document.form1.APPL_FROM, "신청기간을") == false ||
      checkNull(document.form1.APPL_TO,   "신청기간을") == false ) {
    return false;
  }

  if( checkNull(document.form1.RMDDA, "출산예정일을") == false ) {
    return false;
  }

//  보호휴가 기간이 45일 이상 확보되는지 check한다.
  l_temp    = getAfterDate(document.form1.RMDDA.value, 44);                 // 45일 이상 확보

  l_date_to = removePoint(document.form1.APPL_TO.value);
  l_date_rm = removePoint(document.form1.RMDDA.value);

  if( l_date_to < l_temp ) {
    alert("보호휴가는 산후에 45일 이상 확보되어야 합니다.");
    return false;
  }

  // 신청관련 단위 모듈에서 필히 넣어야?l 항목...
  if ( check_empNo() ){
    return false;
  }
  // 신청관련 단위 모듈에서 필히 넣어야?l 항목...

  // default값 setting..
  document.form1.BEGDA.value       = removePoint(document.form1.BEGDA.value);
  document.form1.APPL_FROM.value   = removePoint(document.form1.APPL_FROM.value);
  document.form1.APPL_TO.value     = removePoint(document.form1.APPL_TO.value);
  document.form1.RMDDA.value       = removePoint(document.form1.RMDDA.value);

  return true;
}

//휴가시작일로 휴가종료일 계산하기
function after_APPL_TO_Setting(){
  APPL_TO_Setting(document.form1.APPL_FROM);
}

function APPL_TO_Setting(obj) {
  if( obj.value != "" && dateFormat(obj) ) {
//  휴가일수에 따라 휴가종료일을 설정한다.
    var l_pbez4 = 0;
    for(var i = 0 ; i < document.form1.PBEZ4.length ; i++) {
      if(document.form1.PBEZ4[i].checked) {
        l_pbez4 = Number(document.form1.PBEZ4[i].value) - 1;                     // 89일, 44일

        document.form1.APPL_TO.value = getAfterDate(obj.value, l_pbez4);         // 90일, 45일
        document.form1.APPL_TO.value = addPointAtDate(document.form1.APPL_TO.value);
      }
    }
  }
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');">
<form name="form1" method="post" action="">
<div class="subWrapper">

    <div class="title"><h1>산전후 휴가신청</h1></div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일</th>
                    <td>
                        <input type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>신청기간</th>
                    <td>
                        <input type="text" name="APPL_FROM" value="" size="20" onBlur="javascript:APPL_TO_Setting(this);">
                        <a href="javascript:fn_openCal('APPL_FROM','after_APPL_TO_Setting()')">
                            <img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0" alt="날짜검색">
                        </a>
                        부터
                        <input type="text" name="APPL_TO"   value="" size="20" readonly>
                        까지
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>출산예정일</th>
                    <td>
                        <input type="text" name="RMDDA" value="" size="20" onBlur="javascript:dateFormat(this);">
                        <a href="javascript:fn_openCal('RMDDA')">
                            <img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0" alt="날짜검색">
                        </a>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>휴가일수</th>
                    <td>
                        <input type="radio" name="PBEZ4" value="90" checked onClick="javascript:after_APPL_TO_Setting();">90일
                        &nbsp;
                        <input type="radio" name="PBEZ4" value="45" onClick="javascript:after_APPL_TO_Setting();">45일
                    </td>
                </tr>
            </table>
            <div class="commentsMoreThan2">
                <div><span class="textPink">*</span> 는 필수 입력사항입니다.</div>
                <div>휴가 신청기간은 최대 90일 입니다.</div>
                <div>출산예정일과 휴가종료일 사이의 기간은 45일 이상 확보되어야 합니다.</div>
            </div>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,user.empNo) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a href="javascript:doSubmit();"><span>신청</span></a></li>
        </ul>
    </div>

</div>
<!-- HIDDEN  처리해야할 부분 시작 -->
      <input type="hidden" name="jobid"     value="">
      <input type="hidden" name="AWART"     value="0160">             <!-- 산전산후휴가 -->
<!-- HIDDEN  처리해야할 부분 끝   -->
</form>
<form name="form3" method="post">
      <input type="hidden" name="APPL_FROM" value="">
      <input type="hidden" name="APPL_TO"   value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
