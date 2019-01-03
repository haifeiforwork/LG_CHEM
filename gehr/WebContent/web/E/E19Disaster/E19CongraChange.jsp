<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해신청 조회                                               */
/*   Program ID   : E19CongraChange.jsp                                         */
/*   Description  : 재해 신청을 수정하는 화면                                   */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-28  윤정현                                          */
/*  CSR ID : 2511881 재해신청 시스템 수정요청 20140327 이지은D  1) 재해신청일자 < 신청일 validation
 *                                                                                    2) 신청일이 시작일이 아니고, 재해신청일자가 BEGDA
 *                                                                                    3) 재해신청일자 입력 화면 변경(재해피해신고서로 옮김)  */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Disaster.*" %>

<%
    WebUserData      user                 = (WebUserData)session.getAttribute("user");
    E19CongcondData  e19CongcondData      = (E19CongcondData)request.getAttribute("e19CongcondData");

    /* 재해피해신고서 입력된 vector를 받는다*/
    Vector          E19DisasterData_vt    = (Vector)request.getAttribute("E19DisasterData_vt");
    Vector          AppLineData_vt        = (Vector)request.getAttribute("AppLineData_vt");

    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    Vector          AccountData_pers_vt   = (Vector)request.getAttribute("AccountData_pers_vt");
    AccountData     AccountData_hidden    = (AccountData)request.getAttribute("AccountData_hidden");

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
/****** 원화일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWon(this);" *******/
function moneyChkEventForWon(obj){
    val = obj.value;
    if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
        addComma(obj);
    }
    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}
/**************************************************************** 문의 :  김성일 ****/
//달력 사용
function fn_openCal(Objectname,moreScriptFunction){
   var lastDate;
   lastDate = eval("document.form1." + Objectname + ".value");
  small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?moreScriptFunction="+moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
}
//달력 사용

//조회화면으로 가기
function go_back(){
    location.href = "<%=WebUtil.ServletURL%>hris.E.E19Disaster.E19CongraDetailSV?AINF_SEQN=<%= e19CongcondData.AINF_SEQN %>";
}

function do_change(){
  document.form1.checkSubmit.value = "Y";
  if( !check_data() ){
    document.form1.checkSubmit.value = "";
    return;
  }
}

function do_change_submit(){
  document.form1.jobid.value = "change";
  document.form1.AINF_SEQN.value = "<%= e19CongcondData.AINF_SEQN %>";

  document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19CongraChangeSV";
  document.form1.method = "post";
  document.form1.submit();
}

function check_data(){
    if( checkNull(document.form1.CONG_DATE, "재해발생일자를") == false ) {
      return false;
    }

//은행 관련자료도 필수 항목이다
    if( document.form1.BANK_NAME.value == "" || document.form1.BANKN.value == "" ) {
      alert("입금될 계좌정보가 명확하지 않습니다.\n\n  인사담당자에게 문의해 주세요");
      return false;
    }
//은행 관련자료도 필수 항목이다

    vt_size = '<%=E19DisasterData_vt.size()%>';
    if( document.form1.CONG_CODE.value=="0005" && vt_size == 0 ) {
        if( confirm("재해 경조시에는 재해피해신고서 등록을 하셔야 합니다.\n\n 재해신고서를 작성하시겠습니까?") ){
            open_report_build();
            return false;
        }else {
            return false;
        }
    }

    if ( check_empNo() ){
        return false;
    }

    x_CONG_WONX = removeComma(document.form1.CONG_WONX.value);
    if( isNaN(x_CONG_WONX) ){
        alert(" 입력값이 적합하지 않습니다. ");
        document.form1.CONG_WONX.focus();
        return false;
    } else if( x_CONG_WONX == "0" ){
        alert(" 입력값이 적합하지 않습니다. ");
        document.form1.CONG_WONX.focus();
        return false;
    }

//경조사 발생 3개월초과시 에러처리
    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);

    betw = getAfterMonth(addSlash(congra_date), 3);
    dif = dayDiff(addSlash(begin_date), addSlash(betw));

    betw2 = getAfterMonth(addSlash(begin_date), 1);
    dif2 = dayDiff(addSlash(congra_date), addSlash(betw2));

    if(dif < 0){
        str = '        경조를 신청할수 없습니다.\n\n 경조발생일로부터 3개월 이내에 신청해야합니다. ';
        alert(str);
        return false;
    }
    if(dif2 < 0) {
        str = '        경조를 신청할수 없습니다.\n\n 경조발생일로부터 1개월 이전에 신청해야합니다. ';
//str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
        alert(str);
        return false;
    }

    // 재해발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다.
    event_CONG_DATE(document.form1.CONG_DATE);
    // 재해발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다.

    document.form1.BEGDA.value = begin_date;
    document.form1.CONG_DATE.value = congra_date;

    document.form1.CONG_WONX.value = x_CONG_WONX;
    document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value);

    return true;
}

//재해피해신고서입력 버튼 클릭시 호출 MM_openBrWindow('E19ReportBuild.htm','','width=550,height=500')"
function open_report_build(){
    document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value);
    document.form1.CONG_WONX.value = removeComma(document.form1.CONG_WONX.value);
    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);
    document.form1.BEGDA.value = begin_date;
    document.form1.CONG_DATE.value = congra_date;

    document.form1.jobid.value = "";
    document.form1.AINF_SEQN.value = "<%= e19CongcondData.AINF_SEQN %>"; //build.jsp 에는 없음
    document.form1.action = '<%=WebUtil.ServletURL%>hris.E.E19Disaster.E19ReportControlSV';
    document.form1.method = "post";

    document.form1.submit();
}


//돌반지, 조화대일경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
//    if( disa == "0005" ){
//        view_Rela(document.form1.CONG_CODE);
//    }

//onClick="MM_openBrWindow('E19ReportBuild.htm','','width=550,height=500')"
function MM_openBrWindow(theURL,winName,features) {//v2.0
  window.open(theURL,winName,features);
}

function event_CONG_DATE_ReadOnly(){
    alert("재해발생일자는 재해피해 신고서에서 입력해주시기 바랍니다.");
        return;
}
//-->
</script>

</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>재해신청 수정</h1></div>

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
                    <th>신청일</th>
                    <td>
                      <input type="text" name="BEGDA" value="<%= e19CongcondData.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(e19CongcondData.BEGDA) %>"  size="20" readonly>
                      <a class="inlineBtn" href="javascript:open_report_build();"><span>재해피해신고서</span></a>
                      <span>&nbsp;<%= (E19DisasterData_vt.size() > 0) ? E19DisasterData_vt.size()+ "&nbsp;건" : "&nbsp;※ 재해피해 신고서를 반드시 입력해 주세요" %></span>
                      <input type="hidden" name="disa_name" value="재해" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>재해발생일자</th>
                    <td>
                        <input type="text" name="CONG_DATE" value="<%= e19CongcondData.CONG_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(e19CongcondData.CONG_DATE) %>" size="20" onClick="event_CONG_DATE_ReadOnly();" onBlur="event_CONG_DATE(this);" readonly>
                        <!-- <a href="javascript:fn_openCal('CONG_DATE','after_event_CONG_DATE()')">
                            <img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="날짜검색">
                        </a>  -->
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table"
            <table class="tableGeneral">
<!--
                  <tr>
                    <td width="100" class="td01">통상임금</td>
                    <td class="td09" colspan="3">
                      <input type="text" name="WAGE_WONX" value="<%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%>" style="text-align:right" size="20" class="input04" readonly> 원
                    </td>
                  </tr>
                  <tr>
                    <td class="td01">지급율</td>
                    <td class="td09" colspan="3">
                      <input type="hidden" name="xCONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" >
                      <input type="text" name="CONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" class="input04" style="text-align:right" size="20" readonly> %
                    </td>
                  </tr>
-->
                      <input type="hidden" name="WAGE_WONX"  value="<%= e19CongcondData.WAGE_WONX %>" >
                      <input type="hidden" name="xCONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" >
                      <input type="hidden" name="CONG_RATE"  value="<%= e19CongcondData.CONG_RATE %>" >

                  <tr>
                    <th>재해위로금액</th>
                    <td colspan="3">
                      <input type="hidden" name="xCONG_WONX" value="<%=e19CongcondData.CONG_WONX.equals("") ? "" : WebUtil.printNumFormat(e19CongcondData.CONG_WONX)%>">
                      <input type="text" name="CONG_WONX" value="<%=e19CongcondData.CONG_WONX.equals("") ? "" : WebUtil.printNumFormat(e19CongcondData.CONG_WONX)%>" style="text-align:right" size="20" readonly> 원
                    </td>
<!-- 재해발생일자 기준의 근속년월을 가져오기 ---------------------------------------------------------------------->
<SCRIPT LANGUAGE="JavaScript">
<!--
function after_event_CONG_DATE(){
    event_CONG_DATE(document.form1.CONG_DATE);
}
function event_CONG_DATE(obj){
    if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() ){
        document.form3.CONG_DATE.value = removePoint(document.form1.CONG_DATE.value);
        document.form3.action="<%=WebUtil.JspURL%>E/E19Disaster/E19Hidden4WorkYear.jsp";
        document.form3.target="ifHidden";
        document.form3.submit();
    }
}

function event_CONG_DATE_ReadOnly(){
    alert("재해발생일자는 재해피해 신고서에서 입력해주시기 바랍니다.");
    return;
}

function chkInvalidDate(){
//경조사 발생 3개월초과시 에러처리
    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);

    betw = getAfterMonth(addSlash(congra_date), 3);
    dif = dayDiff(addSlash(begin_date), addSlash(betw));

    betw2 = getAfterMonth(addSlash(begin_date), 1);
    dif2 = dayDiff(addSlash(congra_date), addSlash(betw2));

    if(dif < 0){
        str = '        경조를 신청할수 없습니다.\n\n 경조발생일로부터 3개월 이전부터 신청할수 있습니다. ';
        alert(str);
        return false;
    }
    if(dif2 < 0) {
        str = '        경조를 신청할수 없습니다.\n\n 경조발생일로부터 1개월 이후에는 신청할수 없습니다. ';
        //str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
        alert(str);
        return false;
    }
    return true;
}
//-->
</SCRIPT>
                      </tr>
                      <tr>
                        <th>이체은행명</th>
                        <td>
                          <input type="text" name="BANK_NAME" value="<%=  e19CongcondData.BANK_NAME %>" size="30" class="input04" readonly>
                        </td>
                        <th class="th02">은행계좌번호</th>
                        <td>
                          <input type="text" name="BANKN" value="<%=  e19CongcondData.BANKN %>" size="30" readonly>
                        </td>
                      </tr>
                      <tr>
                        <th>근속년수</th>
                        <td colspan="3">
                          <input type="text" name="WORK_YEAR" value="<%= ( e19CongcondData.WORK_YEAR.equals("") || e19CongcondData.WORK_YEAR.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>" style="text-align:right" size="6" readonly> 년
                          <input type="text" name="WORK_MNTH" value="<%= (e19CongcondData.WORK_MNTH.equals("") || e19CongcondData.WORK_MNTH.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>" style="text-align:right" size="6" readonly> 개월
                        </td>
                      </tr>
            </table>
            <span class="commentOne"><span class="textPink">*</span>는 필수 입력사항입니다.</span>
        </div>
    </div>

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppChange(AppLineData_vt,e19CongcondData.PERNR) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:do_change();"><span>저장</span></a></li>
            <li><a href="javascript:go_back();"><span>취소</span></a></li>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="jobid"           value="">
      <input type="hidden" name="PERNR"           value="<%= e19CongcondData.PERNR%>">
      <input type="hidden" name="AINF_SEQN"       value="<%= e19CongcondData.AINF_SEQN %>">
      <input type="hidden" name="CONG_CODE"       value="0005">
      <input type="hidden" name="RELA_CODE"       value="">
      <input type="hidden" name="EREL_NAME"       value="">
      <input type="hidden" name="CONG_RATE"       value="0">
      <input type="hidden" name="HOLI_CONT"       value="0">
      <input type="hidden" name="fromJsp"         value="E19CongraChange.jsp">
      <input type="hidden" name="fromJsp2"         value="E19CongraChange.jsp">
      <input type="hidden" name="RowCount_report" value="<%=E19DisasterData_vt.size()%>">
      <input type="hidden" name="checkSubmit"     value="">
      <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
<%
    for(int i = 0 ; i < E19DisasterData_vt.size() ; i++){
        E19DisasterData data_vt = (E19DisasterData)E19DisasterData_vt.get(i);
%>
      <input type="hidden" name="DISA_RESN<%= i %>" value="<%= data_vt.DISA_RESN   %>">
      <input type="hidden" name="DISA_CODE<%= i %>" value="<%= data_vt.DISA_CODE   %>">
      <input type="hidden" name="DREL_CODE<%= i %>" value="<%= data_vt.DREL_CODE   %>">
      <input type="hidden" name="DISA_RATE<%= i %>" value="<%= data_vt.DISA_RATE   %>">
      <input type="hidden" name="CONG_DATE<%= i %>" value="<%= data_vt.CONG_DATE   %>">
      <input type="hidden" name="DISA_DESC1<%= i %>" value="<%= data_vt.DISA_DESC1  %>">
      <input type="hidden" name="DISA_DESC2<%= i %>" value="<%= data_vt.DISA_DESC2  %>">
      <input type="hidden" name="DISA_DESC3<%= i %>" value="<%= data_vt.DISA_DESC3  %>">
      <input type="hidden" name="DISA_DESC4<%= i %>" value="<%= data_vt.DISA_DESC4  %>">
      <input type="hidden" name="DISA_DESC5<%= i %>" value="<%= data_vt.DISA_DESC5  %>">
      <input type="hidden" name="EREL_NAME<%= i %>" value="<%= data_vt.EREL_NAME   %>">
      <input type="hidden" name="INDX_NUMB<%= i %>" value="<%= data_vt.INDX_NUMB   %>">
      <input type="hidden" name="PERNR<%= i %>" value="<%= data_vt.PERNR       %>">
      <input type="hidden" name="REGNO<%= i %>" value="<%= data_vt.REGNO       %>">
      <input type="hidden" name="STRAS<%= i %>" value="<%= data_vt.STRAS       %>">
      <input type="hidden" name="AINF_SEQN<%= i %>" value="<%= data_vt.AINF_SEQN   %>">
<%
    }
%>
      <input type="hidden" name="AccountData_pers_RowCount" value="<%=AccountData_pers_vt.size()%>">
<%
    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    for(int i = 0 ; i < AccountData_pers_vt.size() ; i++){
        AccountData data_vt = (AccountData)AccountData_pers_vt.get(i); //은행계좌번호 BANKN , 은행명 BANKA
%>
      <input type="hidden" name="p_LIFNR<%= i %>" value="<%= data_vt.LIFNR %>">
      <input type="hidden" name="p_BANKN<%= i %>" value="<%= data_vt.BANKN %>">
      <input type="hidden" name="p_BANKA<%= i %>" value="<%= data_vt.BANKA %>">
      <input type="hidden" name="p_BANKL<%= i %>" value="<%= data_vt.BANKL %>">
<%
    }
%>
<!--  HIDDEN  처리해야할 부분 끝-->
  </form>

  <form name="form2" method="post">
      <input type="hidden" name="jobid" value="hiddenAction">
      <input type="hidden" name="LIFNR" value="">
      <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
  </form>
  <form name="form3" method="post">
      <input type="hidden" name="CONG_DATE" value="">
      <input type="hidden" name="PERNR"     value="<%= e19CongcondData.PERNR%>">
      <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
  </form>
</div>
<iframe name="ifHidden" height="0" width="0" />
<%@ include file="/web/common/commonEnd.jsp" %>
