<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금 수정                                               */
/*   Program ID   : E10PersonalChange.jsp                                       */
/*   Description  : 개인연금을 수정할 수 있도록 하는 화면                       */
/*   Note         :                                                             */
/*   Creation     : 2002-02-03  이형석                                          */
/*   Update       : 2005-02-23  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E10Personal.rfc.*" %>
<%@ page import="hris.E.E10Personal.*" %>
<%@ page import="hris.E.E11Personal.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector              Personal_vt    = (Vector)request.getAttribute("Personal_vt");
    Vector              AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
    E10PentionMoneyData data_money_1   = (E10PentionMoneyData)request.getAttribute("data_money_1");     //개인연금 지원액
    E10PentionMoneyData data_money_2   = (E10PentionMoneyData)request.getAttribute("data_money_2");     //마이라이프 지원액
    E10PersonalData     data           = (E10PersonalData)Personal_vt.get(0);
    E11PersonalData     edata          = (E11PersonalData)request.getAttribute("E11PersonalData");
    String cautionMsg          = (String)request.getAttribute("cautionMsg");

    String RequestPageName     = (String)request.getAttribute("RequestPageName");
    PersonData personData2 = (PersonData)request.getAttribute("PersonData");
%>
<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function doSubmit(){
    if(check_data()) {
        document.form1.BEGDA.value     = removePoint( document.form1.BEG_DA.value);
        document.form1.PENT_TYPE.value = document.form1.PENT_TYPE[form1.PENT_TYPE.selectedIndex].value;
        document.form1.BANK_TYPE.value = document.form1.BANK_TYPE[form1.BANK_TYPE.selectedIndex].value;
        document.form1.jobid.value     = "change";
        document.form1.action          = "<%= WebUtil.ServletURL %>hris.E.E10Personal.E10PersonalChangeSV";
        document.form1.method          = "post";
        document.form1.submit();
    }
}

function check_data(){
    val = document.form1.PENT_TYPE[document.form1.PENT_TYPE.selectedIndex].value;

<%
    if( edata.STATUS != null && edata.STATUS.equals("진행중") ) {
%>
        alert("신청 자격이 없습니다.");
        return false;
<%
    }
%>

//  2002.07.13. 성별과 나이를 구분하여 신청자격을 체크한다.
//              남자 : 20세 이상 ~ 45세 이하 -> 개인연금
//                     20세 미만, 46세 이상  -> 마이라이프
//              여자 : 20세 이상 ~ 45세 이하 -> 개인연금, 마이라이프 둘 중 하나만 선택가능
//                     20세 미만, 46세 이상  -> 마이라이프
<%
    if( user.companyCode.equals("C100") ) {         // LG화학
%>
    chk_bit = "<%= personData2.E_REGNO.substring(6, 7) %>";
    regNo   = "<%= personData2.E_REGNO.substring(0, 6) %>" + "-" + "<%= personData2.E_REGNO.substring(6, 13) %>"
    age_value = getAge(regNo);

    if( chk_bit == "1" || chk_bit == "3" || chk_bit == "5" || chk_bit == "7" || chk_bit == "9" ) {        // 남자
        if( val == "0001" ) {
            if( age_value >= 20 && age_value <= 45 ) {
//              신청가능
            } else {
                alert("연령 제한으로 신청 자격이 없습니다.");
                return false;
            }
        } else if( val == "0002" ) {
            if( age_value >= 20 && age_value <= 45 ) {
                alert("연령 제한으로 신청 자격이 없습니다.");
                return false;
            } else {
//              신청가능
            }
        }
    } else if( chk_bit == "2" || chk_bit == "4" || chk_bit == "6" || chk_bit == "8" || chk_bit == "0" ) { // 여자
        if( val == "0001" ) {
            if( age_value >= 20 && age_value <= 45 ) {
//              신청가능
            } else {
                alert("연령 제한으로 신청 자격이 없습니다.");
                return false;
            }
        }
    }
<%
    }
%>
//  2002.07.13. 성별과 나이를 구분하여 신청자격을 체크한다.

    if( checkNull(document.form1.ENTR_TERM, "가입기간을") == false ) {
        document.form1.ENTR_TERM.focus();
        return false;
    }

    if( onlyNumber(document.form1.ENTR_TERM,"가입기간") == false ){
        document.form1.ENTR_TERM.focus();
        return false;
    }

    if ( check_empNo() ) {
        return false;
    }

//  2003.02.25 어떤 경우인지 모르나 미입력되는 경우가 있어서 체크하는 로직을 추가함.
    if( document.form1.CMPYAMNT.value == "0" || document.form1.MNTHAMNT.value == "0" ) {
        alert("회사지원액, 월실납액을 확인바랍니다. 필수입력사항입니다.");
        return false;
    } else {
        document.form1.PERL_AMNT.value    = removeComma( document.form1.PERLAMNT.value );
        document.form1.CMPY_AMNT.value    = removeComma( document.form1.CMPYAMNT.value );
        document.form1.MNTH_AMNT.value    = removeComma( document.form1.MNTHAMNT.value );
        document.form1.ENTR_TERM.disabled = 0;

        return true;
    }
}

function viewChange(obj){
    val = obj[obj.selectedIndex].value;
<%
    if( edata.STATUS != null && edata.STATUS.equals("진행중") ) {
%>
        alert("신청 자격이 없습니다.");
        return false;
<%
    }
%>

    if(val == "0002") {
        document.form1.PERLAMNT.value     = "<%= WebUtil.printNumFormat(Double.toString( Double.parseDouble(data_money_2.DEDUCT) - Double.parseDouble(data_money_2.ASSIST) )) %>";
        document.form1.CMPYAMNT.value     = "<%= WebUtil.printNumFormat(data_money_2.ASSIST) %>";
        document.form1.MNTHAMNT.value     = "<%= WebUtil.printNumFormat(Double.toString( Double.parseDouble(data_money_2.DEDUCT) + Double.parseDouble(data_money_2.DISCOUNT) )) %>";
        //document.form1.ENTR_TERM.value    = "3";
        //document.form1.ENTR_TERM.disabled = 0;
      <% if(data.PENT_TYPE.equals("0002")) { %>
        ENTRin.innerHTML = "<select name=ENTR_TERM class=input03 onChange=javascript:viewChange(this)><option value=3<%if(WebUtil.printNumFormat(data.ENTR_TERM).equals("3")){%> selected <%}%>>3</option><option value=5<%if(WebUtil.printNumFormat(data.ENTR_TERM).equals("5")){%> selected <%}%>>5</option><option value=7<%if(WebUtil.printNumFormat(data.ENTR_TERM).equals("7")){%> selected <%}%>>7</option><option value=10<%if(WebUtil.printNumFormat(data.ENTR_TERM).equals("10")){%> selected <%}%>>10</option></select>";
        <% if(WebUtil.printNumFormat(data.ENTR_TERM).equals("3")) { %>
          mylife.style.display = "block";
        <% } %>
      <% } else { %>
        ENTRin.innerHTML = "<select name=ENTR_TERM class=input03 onChange=javascript:viewChange(this)><option value=3>3</option><option value=5>5</option><option value=7>7</option><option value=10>10</option></select>";
        mylife.style.display = "block";
      <% } %>
    } else if(val == "0001") {
        document.form1.PERLAMNT.value     = "<%= WebUtil.printNumFormat(Double.toString( Double.parseDouble(data_money_1.DEDUCT) - Double.parseDouble(data_money_1.ASSIST) )) %>";
        document.form1.CMPYAMNT.value     = "<%= WebUtil.printNumFormat(data_money_1.ASSIST) %>";
        document.form1.MNTHAMNT.value     = "<%= WebUtil.printNumFormat(Double.toString( Double.parseDouble(data_money_1.DEDUCT) + Double.parseDouble(data_money_1.DISCOUNT) )) %>";
        //document.form1.ENTR_TERM.value    = "10";
        //document.form1.ENTR_TERM.disabled = 1;
        ENTRin.innerHTML = "<input type=text name=ENTR_TERM size=13 class=input03 style=text-align:right value='10' disabled>";
        mylife.style.display = "none";
    }

    if(val == "3") {
        mylife.style.display = "block";
    } else if(val == "5"||val == "7"||val == "10") {
        mylife.style.display = "none";
    }
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>개인연금/마이라이프 가입신청 수정</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>
<%
    if ( cautionMsg.equals("") ) {
%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일자</th>
                    <td><input type="text" name="BEG_DA" size="14" value="<%= WebUtil.printDate(data.BEGDA) %>" readonly></td>
                    <th class="th02"><span class="textPink">*</span>연금구분</th>
                    <td>
                        <select name="PENT_TYPE" onChange="javascript:viewChange(this)">
                            <%= WebUtil.printOption((new DivideCodeRFC()).getDivideCode(), data.PENT_TYPE) %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>가입기간</th>
                    <td>
                        <span id="ENTRin">
                     <% if(data.PENT_TYPE.equals("0001")) { %>
                        <input type="text" name="ENTR_TERM" size="13" style="text-align:right" value="<%= WebUtil.printNumFormat(data.ENTR_TERM) %>" disabled>
                     <% } else if(data.PENT_TYPE.equals("0002")) { %>
                        <select name=ENTR_TERM onChange=javascript:viewChange(this)>
                          <option value=3<%if(WebUtil.printNumFormat(data.ENTR_TERM).equals("3")){%> selected <%}%>>3</option>
                          <option value=5<%if(WebUtil.printNumFormat(data.ENTR_TERM).equals("5")){%> selected <%}%>>5</option>
                          <option value=7<%if(WebUtil.printNumFormat(data.ENTR_TERM).equals("7")){%> selected <%}%>>7</option>
                          <option value=10<%if(WebUtil.printNumFormat(data.ENTR_TERM).equals("10")){%> selected <%}%>>10</option></select>
                     <% } %>
                        </span>&nbsp;년
                    </td>
                    <th class="th02"><span class="textPink">*</span>가입보험사</th>
                    <td>
                        <select name="BANK_TYPE">
                        <%= WebUtil.printOption((new InsureCodeRFC()).getInsureCode(),data.BANK_TYPE) %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>개인부담금</th>
                    <td><input type="text" name="PERLAMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.PERL_AMNT) %>" readonly>원 </td>
                    <th class="th02">회사지원액</th>
                    <td><input type="text" name="CMPYAMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.CMPY_AMNT) %>" readonly>원</td>
                </tr>
                <tr>
                    <th>월실납액</th>
                    <td colspan="3"><input type="text" name="MNTHAMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.MNTH_AMNT) %>" readonly>원 </td>
                </tr>
            </table>
            <div class="commentsMoreThan2">
                <div><span class="textPink">*</span> 는 필수 입력사항입니다.</div>
                <div id=mylife name=mylife
                  <% if(data.PENT_TYPE.equals("0002")&&WebUtil.printNumFormat(data.ENTR_TERM).equals("3")) { %>
                  style="display:block"
                  <% } else { %>
                  style="display:none"
                  <% } %>>마이라이프 3년 가입시에는 2년 후인 5년째 되는 날에 수령이 가능합니다.
                </div>
            </div>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <%= hris.common.util.AppUtil.getAppChange(data.AINF_SEQN) %>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:doSubmit();"><span>저장</span></a></li>
            <li><a href="javascript:history.back();"><span>취소</span></a></li>
        </ul>
    </div>

    <input type="hidden" name="BEGDA" value="">
    <input type="hidden" name="AINF_SEQN" value="<%= data.AINF_SEQN %>">
    <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
    <input type="hidden" name="PERL_AMNT" value="">
    <input type="hidden" name="CMPY_AMNT" value="">
    <input type="hidden" name="MNTH_AMNT" value="">

<%
    } else {
%>

    <div class="align_center">
        <p><%= cautionMsg %></p>
    </div>

<%
    }
%>

</div>
<input type="hidden" name="jobid" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
