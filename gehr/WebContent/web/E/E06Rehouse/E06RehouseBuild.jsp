<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 상환신청                                           */
/*   Program Name : 주택자금 상환신청                                           */
/*   Program ID   : E06ReHouseBuild.jsp                                         */
/*   Description  : 주택자금 상환신청을 할수 있도록 하는 화면                   */
/*   Note         :                                                             */
/*   Creation     : 2001-12-26  이형석                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                  2005-12-30  LSA C2005122901000000229   에러수정             */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E06Rehouse.*" %>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>

<%
    String         UPMU_TYPE       = "13";
    E06RehouseData e06RehouseData  = (E06RehouseData)request.getAttribute("e06RehouseData");
    E06RehouseKey  key             = (E06RehouseKey)request.getAttribute("e06RehouseKey");
    WebUserData    user            = (WebUserData)session.getAttribute("user");
    Vector         PersLoanData_vt = (Vector)request.getAttribute("PersLoanData_vt");
    Vector         AppLineData_vt  = (Vector)request.getAttribute("AppLineData_vt");

    if( PersLoanData_vt.size() > 0 ) {
        E05PersLoanData data = (E05PersLoanData)PersLoanData_vt.get(0);
    }

    String PERNR = (String)request.getAttribute("PERNR");
%>

<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ui_library_approval" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) {//v2.0
  window.open(theURL,winName,features);
}

function doSubmit() {
    if( checkNull(document.form1.idate, "상환액 입금일자를") == false ) {
        document.form1.idate.focus();
    }

    if(dateFormat(document.form1.idate) == false) {}

    if(check_data()) {
        if(check_empNo()) {
            return;
        }

        viewDetail();
        buttonDisabled();
        document.form1.jobid.value = "create";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E06Rehouse.E06RehouseBuildSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function viewDetail(){
  var val =  document.form1.I_LOAN_CODE[form1.I_LOAN_CODE.selectedIndex].value;
  var size = document.form1.rowCount.value;
  var tmp_flag = false;

    for( i = 0; i < size; i++) {
        temp_str = eval("document.form1.P_I_LOAN_CODE"+i+".value");
        if( temp_str == val ){
            tmp_flag = true;
        }
     }

     if( tmp_flag == false ){
      view_str = document.form1.I_LOAN_CODE[form1.I_LOAN_CODE.selectedIndex].text;
      alert(view_str+" 상환 신청을 할 수 없습니다.");

      if(document.form1.I_LOAN_CODE[form1.I_LOAN_CODE.selectedIndex].value == "0010") {
        form1.I_LOAN_CODE[1].selected = true;
      } else {
        form1.I_LOAN_CODE[0].selected = true;
      }
      return false;
    }

    if( check_data() ) {
        buttonDisabled();
        document.form1.jobid.value = "second";
        document.form1.I_LOAN_CODE.value = document.form1.I_LOAN_CODE[form1.I_LOAN_CODE.selectedIndex].value;
        document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E06Rehouse.E06RehouseBuildSV';
        document.form1.method = "post";
        document.form1.submit();
    }
}

function check_data() {
    datech = changeChar( document.form1.idate.value, ".", "" );

    if(datech.length == 8){

        if( dateFormat(document.form1.idate) == false ) {
            return false;
        }

//        2002.09.09. 임시적으로 막음.
//        def = dayDiff(document.form1.fromdate.value, document.form1.idate.value);
//        if( def < 0 ) {
//            alert("상환일의 범위가 올바르지 않습니다.");
//            return false;
//        }
//        2002.09.09. 임시적으로 막음.

        def = dayDiff(document.form1.fromdate.value, document.form1.idate.value);
        if( def > 7) {
            alert(" 입금일자는 신청일 1주일 이내만 가능합니다.")
            return false;
        }

        document.form1.BEGDA.value        = changeChar( document.form1.fromdate.value, ".", "" );
        document.form1.RPAY_AMNT.value    = changeChar( document.form1.erpayamnt.value, ",", "" );
        document.form1.INTR_AMNT.value    = changeChar( document.form1.eintramnt.value, ",", "" );
        document.form1.TOTL_AMNT.value    = changeChar( document.form1.etotalamnt.value, ",", "" );
        document.form1.I_DATE.value       = changeChar( document.form1.idate.value,".", "");
        document.form1.DARBT.value        = changeChar( document.form1.edarbt.value, ",", "" );
        document.form1.DATBW.value        = changeChar( document.form1.edatbw.value, ".", "" );
        document.form1.ALREADY_AMNT.value = changeChar( document.form1.ealreadyamnt.value, ",", "" );
        document.form1.REMAIN_AMNT.value  = changeChar( document.form1.eremainamnt.value, ",", "" );

        return true;
    }
}

//달력 사용
function fn_openCal(Objectname){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window  = window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+ Objectname + "&curDate=" + lastDate + "&afterAction=after_action()" + "&iflag=0","essCal", "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
}

function after_action() {

     viewDetail();
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.E.E06Rehouse.E06RehouseBuildSV";
    frm.target = "";
    frm.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>주택자금 상환신청</h1></div>

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

<%
    if( e06RehouseData.RPAY_AMNT == null || WebUtil.printNumFormat(e06RehouseData.RPAY_AMNT).equals("0") ) {
%>

    <div class="align_center">해당하는 데이터가 존재하지 않습니다. <br><br></div>

<%
    } else {
%>

    <!-- 상단 입력 테이블 시작-->

    <!--신청정보 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
                <tr>
                    <th>신청일</th>
                    <td>
                        <input type="hidden" name="BEGDA" value="">
                        <input type="text" name="fromdate" size="14" value='<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>' readonly>
                    </td>
                    <th class="th02"><span class="textPink">*</span>주택융자유형</th>
                    <td>
                        <select name="I_LOAN_CODE" onChange="javascript:viewDetail();" >
                          <%= WebUtil.printOption((new E05LoanCodeRFC()).getLoanType(), key.I_LOAN_CODE) %>
                        </select>
                    </td>
                </tr>
                <input type="hidden" name="RPAY_AMNT" value="">
                <input type="hidden" name="erpayamnt" size="20" class="input04" value='<%= WebUtil.printNumFormat(e06RehouseData.RPAY_AMNT) %>' style="text-align:right" readonly>
                <input type="hidden" name="INTR_AMNT" value="">
                <input type="hidden" name="eintramnt" size="20" class="input04" value='<%= WebUtil.printNumFormat(e06RehouseData.INTR_AMNT) %>' style="text-align:right" readonly>
                <input type="hidden" name="TOTL_AMNT" value="">
                <input type="hidden" name="etotalamnt" size="20" class="input04" value='<%= WebUtil.printNumFormat(e06RehouseData.TOTL_AMNT) %>' style="text-align:right;color:#006699" readonly>
                <tr>
                    <th><span class="textPink">*</span>상환액입금일자</th>
                    <td colspan="3">
                        <input type="hidden" name="I_DATE" value="" >
                        <input type="text" name="idate" size="14" value='<%= WebUtil.printDate(key.I_DATE) %>' onKeyUp="javascript:viewDetail();">
                        <a href="javascript:fn_openCal('idate')"><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png"></a>
                    </td>
                </tr>
                <tr>
                    <th>대출금액</th>
                    <td>
                        <input type="hidden" name="DARBT" value="">
                        <input type="text" name="edarbt" size="20" value='<%= WebUtil.printNumFormat(e06RehouseData.DARBT) %>' style="text-align:right" readonly>원</td>
                    <th class="th02">대출일자</th>
                    <td>
                        <input type="hidden" name="DATBW" value="">
                        <input type="text" name="edatbw" size="14" value='<%= WebUtil.printDate(e06RehouseData.DATBW) %>' readonly>
                    </td>
                </tr>
                <tr>
                    <th>기상환액</th>
                    <td>
                        <input type="hidden" name="ALREADY_AMNT" value="">
                        <input type="text" name="ealreadyamnt" size="20" value='<%= WebUtil.printNumFormat(e06RehouseData.ALREADY_AMNT) %>' style="text-align:right" readonly>원
                    </td>
                    <th class="th02">대출잔액</th>
                    <td>
                        <input type="hidden" name="REMAIN_AMNT" value="">
                        <input type="text" name="eremainamnt" size="20"  value='<%= WebUtil.printNumFormat(e06RehouseData.REMAIN_AMNT) %>' style="text-align:right" readonly>원
                    </td>
                </tr>
                <tr>
                    <th>보증여부</th>
                    <td colspan="3" >
                        <input type="hidden" name="ZZSECU_FLAG" value="<%=e06RehouseData.ZZSECU_FLAG %>">
                        <input type="text" name="ZZSECU_FLAG_TEXT" size="20" value='<%= e06RehouseData.E_ZZSECU_TXT %>' readonly>
                    </td>
                </tr>
            </table>
        </div>
        <div class="commentsMoreThan2">
            <div>주택자금을 입금할 경우 본인임을 확인할 수 있도록 무통장 입금증에 본인의 실명을 입력하여 주십시오.</div>
            <div>주매월 21일부터 말일까지는 주택자금을 상환할 수 없습니다.</div>
<%
        if( user.companyCode.equals("C100") ) {         // LG화학
%>
            <div><span class="textPink">*</span>는 필수 입력사항입니다.</div>
<%
        }
%>
        </div>
    </div>
    <!--신청정보 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,PERNR) %>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a class="darken" href="javascript:doSubmit();"><span>신청</span></a></li>
        </ul>
    </div>

          <!-----   hidden field ---------->
          <input type="hidden" name="rowCount" value="<%= PersLoanData_vt.size() %>">
          <%
        for( int i = 0 ; i < PersLoanData_vt.size(); i++ ) {
            E05PersLoanData  hData = (E05PersLoanData)PersLoanData_vt.get(i);
%>
          <input type="hidden" name="P_I_LOAN_CODE<%= i %>" value="<%=hData.DLART%>">
          <%
        }
    }
%>
          <input type="hidden" name="jobid" value="">

</div>

   </form>
<%@ include file="/web/common/commonEnd.jsp" %>
