<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 국민연금 자격변경                                           */
/*   Program Name : 국민연금 자격변경사항 신청                                  */
/*   Program ID   : E04PensionChngBuild.jsp                                     */
/*   Description  : 국민연금 자격변경사항을 신청할 수 있도록 하는 화면          */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  최영호                                          */
/*   Update       : 2005-02-17  윤정현                                          */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/*                     2015-04-16 이지은D [CSR ID:2753943] 고문실 복리후생 신청 권한 제한 요청 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E04Pension.rfc.*" %>

<%
    WebUserData   user    =   (WebUserData)session.getAttribute("user");
    /* 자격등급 입력된 결제정보를 vector로 받는다 */
    Vector    AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
    String PERNR = (String)request.getAttribute("PERNR");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ui_library_approval.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) {
  window.open(theURL,winName,features);
}

function doSubmit() {
    if( check_data() ) {
    buttonDisabled();
        document.form1.jobid.value = "create";
        document.form1.CHNG_TEXT.value = document.form1.CHNG_TYPE.options[document.form1.CHNG_TYPE.selectedIndex].text;
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E04Pension.E04PensionChngBuildSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function check(data) {
    if(document.form1.CHNG_TYPE.value == 02){
        chkResnoObj_1(data);
    }else{
        return;
    }
  return true;
}

function check_data(){

  if( document.form1.CHNG_TYPE.selectedIndex == 0 ){
        alert("변경항목을 선택하세요");
        form1.CHNG_TYPE.focus();
        return false;
  }

  if( document.form1.CHNG_BEFORE.value == "" ){
        alert("변경전 Data를 입력하세요 ");
        document.form1.CHNG_BEFORE.focus();
        return false;
  }
  if( document.form1.CHNG_AFTER.value == "" ){
        alert("변경후 Data를 입력하세요 ");
        document.form1.CHNG_AFTER.focus();
        return false;
  }

  if ( check_empNo() ){
        return false;
  }

  document.form1.BEGDA.value    = removePoint(document.form1.BEGDA.value);

  return true;
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.E.E04Pension.E04PensionChngBuildSV";
    frm.target = "";
    frm.submit();
}

//-->
</script>
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>국민연금 자격변경사항 신청</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:doSubmit();"><span>신청</span></a></li>
        </ul>
    </div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
                <tr>
                    <th>신청일자</th>
                    <td><input name="BEGDA" type="text" value='<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>' size="14" readonly>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <h2 class="subtitle">자격사항 변경<span class="commentOne"><span class="textPink">*</span>는 필수 입력사항입니다.</span></h2>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
                <tr>
                    <th><span class="textPink">*</span>변경항목</th>
                    <td colspan="3">
                      <select name="CHNG_TYPE" >
                        <option value="">------------</option>
                        <%= WebUtil.printOption((new E04PensionChngGradeRFC()).getPensionChngGrade()) %>
                      </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>변경전 Data</th>
                    <td><input type="text" name="CHNG_BEFORE" maxlength="15" onBlur="check(this); "></td>
                    <th class="th02"><span class="textPink">*</span>변경후 Data</th>
                    <td> <input type="text" name="CHNG_AFTER" maxlength="15"onBlur="check(this);"></td>
                </tr>
            </table>
        </div>
    </div>
    <!--상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,PERNR) %>
    <!-- 결재자 입력 테이블 End-->

<%
// [CSR ID:2753943] 고문실 복리후생 신청 권한 제한 요청 @20150415 계약직(자문/고문)의 경우 복리후생 쪽 신청이 불가하도록(건강보험피부양자, 건강보험재발급 빼고 다)
    if( (user.e_persk).equals("14") ){
        //---
    } else {
%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a class="darken" href="javascript:doSubmit();"><span>신청</span></a></li>
        </ul>
    </div>
<%
    }
%>

    <!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid"     value="">
    <input type="hidden" name="CHNG_TEXT" value="">
    <!--  HIDDEN  처리해야할 부분 끝-->

</div>

<%@ include file="/web/common/commonEnd.jsp" %>
