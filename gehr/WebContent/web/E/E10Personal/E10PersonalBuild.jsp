<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금 신청                                               */
/*   Program ID   : E10PersonalBuild.jsp                                        */
/*   Description  : 개인연금을 신청할 수 있도록 하는 화면                       */
/*   Note         :                                                             */
/*   Creation     : 2002-02-03  이형석                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/*               2015-05-08  이지은D  [CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정요청   */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E10Personal.rfc.*" %>
<%@ page import="hris.E.E10Personal.*" %>
<%@ page import="hris.E.E11Personal.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>

<%
    WebUserData  user  = (WebUserData)session.getAttribute("user");

    Vector              AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
//  E10PentionMoneyData data_money_1   = (E10PentionMoneyData)request.getAttribute("data_money_1");  //개인연금 지원액
    E10PentionMoneyData data_money_2   = (E10PentionMoneyData)request.getAttribute("data_money_2");  //마이라이프 지원액
    E10PersonalData     data           = (E10PersonalData)request.getAttribute("E10PersonalData");
    E11PersonalData     edata          = (E11PersonalData)request.getAttribute("E11PersonalData");
    String      cautionMsg             = (String)request.getAttribute("cautionMsg");
    D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
    Vector DupCheckData_vt = null;
    DupCheckData_vt = d16OTHDDupCheckRFC.getCheckList( data.PERNR, "02" );
    String E_FLAG ="";

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
        buttonDisabled();
        document.form1.BEGDA.value     =removePoint( document.form1.BEG_DA.value);
        document.form1.PENT_TYPE.value = document.form1.PENT_TYPE[form1.PENT_TYPE.selectedIndex].value;
        document.form1.BANK_TYPE.value = document.form1.BANK_TYPE[form1.BANK_TYPE.selectedIndex].value;
        document.form1.PENT_TEXT.value = document.form1.PENT_TYPE[form1.PENT_TYPE.selectedIndex].text;
        document.form1.BANK_TEXT.value = document.form1.BANK_TYPE[form1.BANK_TYPE.selectedIndex].text;
        document.form1.jobid.value = "create";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E10Personal.E10PersonalBuildSV";
        document.form1.method = "post";
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

<%
    if ( DupCheckData_vt != null && DupCheckData_vt.size() > 0 ) {

        D16OTHDDupCheckData3 data3 = (D16OTHDDupCheckData3)DupCheckData_vt.get(0);
        E_FLAG = d16OTHDDupCheckRFC.getCheckField( data.PERNR, "02" );
        if ( E_FLAG.equals("T") ) {
%>
            alert("<%=(data3.BEGDA).substring(0,4)%>년 <%=(data3.BEGDA).substring(5,7)%>월 <%=(data3.BEGDA).substring(8,10)%>일에 신청된 건이 있으므로 중복신청 불가합니다.\n\n결재진행현황에서 확인하세요.");
            return false;
<%
        }
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
        document.form1.ENTR_TERM.disabled = 0;
        ENTRin.innerHTML = "<select name=ENTR_TERM class=input03 onChange=javascript:viewChange(this)><option value=3>3</option><option value =5>5</option><option value =7>7</option><option value =10>10</option></select>";
        //document.form1.ENTR_TERM.disabled = 0;
        mylife.style.display = "block";
    } else if(val == "0001") {
        document.form1.PERLAMNT.value     = "<%= WebUtil.printNumFormat(data.PERL_AMNT) %>";
        document.form1.CMPYAMNT.value     = "<%= WebUtil.printNumFormat(data.CMPY_AMNT) %>";
        document.form1.MNTHAMNT.value     = "<%= WebUtil.printNumFormat(data.MNTH_AMNT) %>";
        //document.form1.ENTR_TERM.value    = "<%= data.ENTR_TERM %>";
        //document.form1.ENTR_TERM.disabled = 1;
        ENTRin.innerHTML = "<input type=text name=ENTR_TERM size=14 class=input03 style=text-align:right value='<%= data.ENTR_TERM %>' disabled>";
        mylife.style.display = "none";
    }

    if(val == "3") {
        mylife.style.display = "block";
    } else if(val == "5"||val == "7"||val == "10") {
        mylife.style.display = "none";
    }
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.E.E10Personal.E10PersonalBuildSV";
    frm.target = "";
    frm.submit();
}

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=data.PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>개인연금/마이라이프 가입신청</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>
<%
    if ( cautionMsg.equals("") ) {
%>

    <!-- 상단 입력 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>신청일자</th>
                    <td><input type="text" name="BEG_DA" size="14" value="<%= WebUtil.printDate(data.BEGDA) %>" readonly> </td>
                    <th class="th02"><span class="textPink">*</span>연금구분</th>
                    <td>
                        <select name="PENT_TYPE" onChange="javascript:viewChange(this)" >
                        <%= WebUtil.printOption((new DivideCodeRFC()).getDivideCode()) %> </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>가입기간</th>
                    <td><span id="ENTRin"><input type="text" name="ENTR_TERM" size="14" style="text-align:right" value="<%= data.ENTR_TERM %>" disabled></span> 년</td>
                    <th class="th02"><span class="textPink">*</span>가입보험사</th>
                    <td>
                        <select name="BANK_TYPE">
                            <%= WebUtil.printOption((new InsureCodeRFC()).getInsureCode()) %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>개인부담금</th>
                    <td><input type="text" name="PERLAMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.PERL_AMNT) %>" readonly>원</td>
                    <th class="th02">회사지원액</th>
                    <td><input type="text" name="CMPYAMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.CMPY_AMNT) %>" readonly>원</td>
                </tr>
                <tr>
                    <th>월실납액</th>
                    <td colspan="3"><input type="text" name="MNTHAMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.MNTH_AMNT) %>" readonly>원</td>
                </tr>
            </table>
            <div class="commentsMoreThan2">
                <div><span class="textPink">*</span> 는 필수 입력사항입니다.</div>
                <div id=mylife name=mylife style="display:none">마이라이프 3년 가입시에는 2년 후인 5년째 되는 날에 수령이 가능합니다.</div>
            </div>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,data.PERNR) %> </td>


 <%
            //  장학자금 신청을 신분구분이 계약직, 계약직(자문/고문)인 사람들은 못하도록 한다. 2004.09.17 재수정
            if( user.e_persk.equals("14") ){// [CSR ID:2766987] 14 삭제 누락으로 같이 수정
                //---
            } else {
%>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a href="javascript:doSubmit()"><span>신청</span></a></li>
        </ul>
    </div>

<%
            }
%>


          <input type="hidden" name="ThisJspName" value="">
          <input type="hidden" name="BEGDA" value="">
          <input type="hidden" name="PERL_AMNT" value="">
          <input type="hidden" name="CMPY_AMNT" value="">
          <input type="hidden" name="MNTH_AMNT" value="">
          <input type="hidden" name="PENT_TEXT" value="">
          <input type="hidden" name="BANK_TEXT" value="">
<%
    } else {
%>

    <div class="align_center">
        <p><%= cautionMsg %></p>
    </div>

<%
    }
%>
          <input type="hidden" name="jobid" value="">

</div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
