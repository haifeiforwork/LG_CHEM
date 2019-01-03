<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.C.C07Language.*" %>
<%@ page import="hris.C.C07Language.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    /* 입력된 결제정보를 vector로 받는다 */
    Vector AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");
//  어학지원 중복신청을 check한다.
    Vector c07LangDupCheck_vt = (Vector)request.getAttribute("c07LangDupCheck_vt");
    String cmpy_wonx = ( String )request.getAttribute("cmpy_wonx");

%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
// 달력 사용
function fn_openCal(obj){
  var lastDate;
  lastDate = eval("document.form1." + obj + ".value");
  small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+obj+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
  small_window.focus();
}

//원화일때 포멧 체크
function moneyChkEventForWon(obj){
  val = obj.value;
  if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
    addComma(obj);
  } else {
    obj.value = "";
  }
}

//결제금액의 50%를 회사지원금액에 반영한다.
function set_CMPY_WONX(obj){
  var val     = removeComma(obj.value);
  var val_int = 0;
  var money   = 0;
  var t_money = 0;
  var l_money = 0;
  var t_cmpy_wonx = 0;
  var company = '<%= user.companyCode %>';
  t_cmpy_wonx = Number(<%= cmpy_wonx %>)*100;
  var stud_type;

  stud_type = document.form1.STUD_TYPE.options[document.form1.STUD_TYPE.selectedIndex].value;

  if( val != "" ){
    val_int = Number(val) / 2;

    money = olim(val_int, 0);
    t_money = t_cmpy_wonx + money;

    if( company == 'N100' && ( stud_type == '02' || stud_type == '03' )){
      if(t_money > 500000) {
        l_money = t_money - 500000;
        alert("회사지원액이"+insertComma(l_money+"")+"원 초과됐습니다.");
        form1.SETL_WONX.focus();
        return false;
      }
    }
    document.form1.CMPY_WONX.value = insertComma(money+"");
  }
}

function isNum(obj){
  val = obj.value;
  if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
//    addComma(obj);
  } else {
    obj.value = "";
  }
}

function doSubmit() {
    if( check_data() ) {
    buttonDisabled();
        document.form1.jobid.value = "create";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C07Language.C07LanguageBuildSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function check_data(){
  if( checkNull(document.form1.SBEG_DATE, "학습시작일을") == false ) {
    return false;
  }

  if( checkNull(document.form1.SEND_DATE, "학습종료일을") == false ) {
    return false;
  }

  var fr_date = Number(removePoint(document.form1.SBEG_DATE.value));
  var to_date = Number(removePoint(document.form1.SEND_DATE.value));

  if( fr_date > to_date ) {
    alert("학습시작일이 학습종료일보다 큽니다.");
    return false;
  }

  var stud_type;
  stud_type = document.form1.STUD_TYPE.options[document.form1.STUD_TYPE.selectedIndex].value;
if( stud_type == '01' ){
//학습시작일, 종료일의 중복신청을 check한다.
<%
    for( int i = 0 ; i < c07LangDupCheck_vt.size() ; i++ ) {
        C07LangDupCheckData c_Data = (C07LangDupCheckData)c07LangDupCheck_vt.get(i);

        long sbeg_date = Long.parseLong(DataUtil.removeStructur(c_Data.SBEG_DATE,"-"));
        long send_date = Long.parseLong(DataUtil.removeStructur(c_Data.SEND_DATE,"-"));
%>
      if( (<%= sbeg_date %> <= fr_date && <%= send_date %> >= fr_date) ||
          (<%= sbeg_date %> <= to_date && <%= send_date %> >= to_date) ||
          (<%= sbeg_date %> >= fr_date && <%= send_date %> <= to_date) ) {
<%
        if( c_Data.INFO_FLAG.equals("I") ) {
%>
            alert("중복되는 기간에 이미 어학지원금을 받았습니다.");
<%
        } else if( c_Data.INFO_FLAG.equals("T") ) {
%>
            alert("중복되는 기간에 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
<%
        }
%>
            return false;
      }
<%
    }
%>
}
  if( document.form1.STUD_TYPE.selectedIndex == 0 ){
    alert("학습형태를 선택하세요.");
    form1.STUD_TYPE.focus();
    return false;
  }

//학습기관-40 입력시 길이 제한
  x_obj = document.form1.STUD_INST;
  xx_value = x_obj.value;
  if( checkNull(x_obj, "학습기관을") == false ) {
    return false;
  } else {
    if( xx_value != "" && checkLength(xx_value) > 40 ){
        x_obj.value = limitKoText(xx_value, 40);
        alert("학습기관은 한글 20자, 영문 40자 이내여야 합니다.");
        x_obj.focus();
        x_obj.select();
        return false;
    }
  }

//수강과목-50 입력시 길이 제한
  x_obj = document.form1.LECT_SBJT;
  xx_value = x_obj.value;
  if( checkNull(x_obj, "수강과목을") == false ) {
    return false;
  } else {
    if( xx_value != "" && checkLength(xx_value) > 50 ){
        x_obj.value = limitKoText(xx_value, 50);
        alert("수강과목은 한글 25자, 영문 50자 이내여야 합니다.");
        x_obj.focus();
        x_obj.select();
        return false;
    }
  }

  if( checkNull(document.form1.SETL_WONX, "결제금액을") == false ) {
    return false;
  }

  if( checkNull(document.form1.SELT_DATE, "결제일을") == false ) {
    return false;
  }

//신청일 기준으로 같은 년도의 결제분만 지원가능함
  if( document.form1.BEGDA.value.substring(0, 4) != document.form1.SELT_DATE.value.substring(0, 4) ) {
    alert("해당년도의 어학지원만 신청가능합니다.");
    return false;
  }

//카드번호, 카드회사는 한 항목만 입력시 error처리함
  if( (document.form1.CARD_NUMB.value == "" && document.form1.CARD_CMPY.value != "") ||
      (document.form1.CARD_NUMB.value != "" && document.form1.CARD_CMPY.value == "") ) {
    alert("카드번호, 카드회사를 모두 입력하세요.");
    return false;
  }

//카드번호 입력시 16자리를 check한다.
  x_obj = document.form1.CARD_NUMB;
  xx_value = x_obj.value;
  if( xx_value != "" && checkLength(xx_value) < 16 ){
      alert("카드번호 16자리를 입력하세요.");
      x_obj.focus();
      x_obj.select();
      return false;
  }

//카드회사-30 입력시 길이 제한
  x_obj = document.form1.CARD_CMPY;
  xx_value = x_obj.value;
  if( xx_value != "" && checkLength(xx_value) > 30 ){
      x_obj.value = limitKoText(xx_value, 30);
      alert("카드회사은 한글 15자, 영문 30자 이내여야 합니다.");
      x_obj.focus();
      x_obj.select();
      return false;
  }

//결재정보 CHECK
  if ( check_empNo() ){
    return false;
  }

  document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value);
  document.form1.SBEG_DATE.value = removePoint(document.form1.SBEG_DATE.value);
  document.form1.SEND_DATE.value = removePoint(document.form1.SEND_DATE.value);
  document.form1.SELT_DATE.value = removePoint(document.form1.SELT_DATE.value);

  document.form1.LECT_TIME.value = removeComma(document.form1.LECT_TIME.value);
  document.form1.SETL_WONX.value = removeComma(document.form1.SETL_WONX.value);
  document.form1.CMPY_WONX.value = removeComma(document.form1.CMPY_WONX.value);

  return true;
}
function f_print()
{
     self.print();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<form name="form1" method="post" action="">

<div class="subWrapper">

    <div class="title"><h1>어학지원 신청</h1></div>

    <!-- 상단 검색테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>부서명</th>
                    <td><%= user.e_orgtx %></td>
                    <td class="th02">사 번</td>
                    <td><%= user.empNo %></td>
                    <th class="th02">성 명</th>
                    <td><%= user.ename %></td>
                    <td><a class="inlineBtn" href="javascript:f_print()"><span>인쇄하기</span></a></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 검색테이블 끝-->

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일자</th>
                    <td colspan="3">
                        <input type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>학습시작일</th>
                    <td>
                        <input type="text" name="SBEG_DATE" value="" size="20" onBlur="dateFormat(this);">
                        <a href="javascript:fn_openCal('SBEG_DATE')">
                            <img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0" alt="날짜검색">
                        </a>
                    </td>
                    <th class="th02"><span class="textPink">*</span>학습종료일</th>
                    <td>
                        <input type="text" name="SEND_DATE" value="" size="20" onBlur="dateFormat(this);">
                        <a href="javascript:fn_openCal('SEND_DATE')">
                            <img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0" alt="날짜검색">
                        </a>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>학습형태</th>
                    <td>
                        <select name="STUD_TYPE">
                            <option value="">-----------------</option>
<%= WebUtil.printOption((new C07StudTypeRFC()).getDetail()) %>
                        </select>
                    </td>
                    <th class="th02">수강시간</th>
                    <td>
                        <input type="text" name="LECT_TIME" value="" size="20" maxlength="6" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right">
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>학습기관</th>
                    <td colspan="3"><input type="text" name="STUD_INST" value="" size="50" maxlength="40"></td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>수강과목</th>
                    <td colspan="3">
                        <input type="text" name="LECT_SBJT" value="" size="50" maxlength="50">
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>결제금액</th>
                    <td>
                        <input type="text" name="SETL_WONX" value="" size="20" onKeyUp="javascript:moneyChkEventForWon(this);" onBlur="javascript:set_CMPY_WONX(this);" style="text-align:right">
                    </td>
                    <th class="t02"><span class="textPink">*</span>결제일</th>
                    <td>
                        <input type="text" name="SELT_DATE" value="" size="20" onBlur="dateFormat(this);">
                        <a href="javascript:fn_openCal('SELT_DATE')">
                            <img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0" alt="날짜검색">
                        </a>
                    </td>
                </tr>
                <tr>
                    <th>카드번호</th>
                    <td colspan="3">
                        <input type="text" name="CARD_NUMB" value="" size="20" maxlength="16" onKeyUp="javascript:isNum(this);">
                    </td>
                </tr>
                <tr>
                    <th>카드회사</th>
                    <td colspan="3"><input type="text" name="CARD_CMPY" value="" size="50" maxlength="30"></td>
                </tr>
                <tr>
                    <th>회사지원금액</th>
                    <td colspan="3"><input type="text" name="CMPY_WONX" value="" style="text-align:right" readonly></td>
                </tr>
            </table>
            <span class="commentOne"><span class="textPink">*</span> 는 필수 입력사항입니다.</span>
        </div>
    </div>
    <!--상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,user.empNo) %>
    <!-- 결재자 입력 테이블 End-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a href="javascript:doSubmit();"><span>신청</span></a></li>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid"     value="">
<!--  HIDDEN  처리해야할 부분 끝-->
  </form>
</div>

<%@ include file="/web/common/commonEnd.jsp" %>
