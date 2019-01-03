<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 국민연금 자격변경                                           */
/*   Program Name : 국민연금 자격변경사항 신청 수정                             */
/*   Program ID   : E04PensionChngChange.jsp                                    */
/*   Description  : 국민연금 자격변경을 수정할 수 있도록 하는 화면              */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  최영호                                          */
/*   Update       : 2005-03-01  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E04Pension.*" %>
<%@ page import="hris.E.E04Pension.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    /* 자격면허 레코드를 vector로 받는다*/
    Vector e04PensionChngData_vt  = (Vector)request.getAttribute("e04PensionChngData_vt");

    E04PensionChngData data  = (E04PensionChngData)e04PensionChngData_vt.get(0);

    /* 결제정보를 vector로 받는다*/
    Vector    AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) {//v2.0
  window.open(theURL,winName,features);
}

function do_change() {
    if( check_data() ) {
        document.form1.jobid.value = "change";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";
        document.form1.CHNG_TEXT.value = document.form1.CHNG_TYPE.options[document.form1.CHNG_TYPE.selectedIndex].text;
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E04Pension.E04PensionChngChangeSV";
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

}
function check1() {
    form1.CHNG_BEFORE.focus();
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

    if(document.form1.CHNG_TYPE.value == 02){
        data = document.form1.CHNG_BEFORE;
        data1 = document.form1.CHNG_AFTER;

        if( chkResnoObj_1(data) == true ){
           if(chkResnoObj_1(data1) == true){
               document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
               return true;
           }else{
               return false;
           }
        }else{
            return false
        }
    }

    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);

    return true;
}

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post" action="">

<div class="subWrapper">

    <div class="title"><h1>국민연금 자격변경사항 수정</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/PersonInfo.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일자</th>
                    <td><input type="text" name="BEGDA" value='<%= WebUtil.printDate(data.BEGDA,".") %>' readonly></td>
                </tr>
            </table>
        </div>
    </div>

    <h2 class="subtitle">자격사항 변경 </h2>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th><span class="textPink">*</span>변경항목</th>
                    <td colspan="3">
                        <select name="CHNG_TYPE" onChange="javascript: check1()">
                            <option value="" >------------</option>
                            <%= WebUtil.printOption((new E04PensionChngGradeRFC()).getPensionChngGrade(), data.CHNG_TYPE) %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>변경전 Data</th>
                    <td>
                        <input type="text" name="CHNG_BEFORE" maxlength="15" value="<%= data.CHNG_BEFORE %>">
                    </td>
                    <th class="th02"><span class="textPink">*</span>변경후 Data</th>
                    <td><input type="text" name="CHNG_AFTER" maxlength="15" value="<%= data.CHNG_AFTER %>"></td>
                </tr>
            </table>
            <span class="commentOne"><span class="textPink">*</span> 는 필수 입력사항입니다.</span>
        </div>
    </div>
    <!--상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppChange(AppLineData_vt,data.PERNR) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:do_change();"><span>저장</span></a></li>
            <li><a href="javascript:history.back();"><span>취소</span></a></li>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 시작-->
   <input type="hidden" name="jobid"     value="">
   <input type="hidden" name="AINF_SEQN" value="">
   <input type="hidden" name="CHNG_TEXT" value="">
   <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
</div>

<%@ include file="/web/common/commonEnd.jsp" %>
