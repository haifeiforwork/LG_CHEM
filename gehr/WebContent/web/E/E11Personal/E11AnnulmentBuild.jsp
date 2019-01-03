<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금/마이라이프 해약신청                                */
/*   Program ID   : E11AnnulmentBuild.jsp                                       */
/*   Description  : 개인연금/마이라이프 해약신청                                */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E11Personal.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String UPMU_TYPE = "26";

    E11PersonalData data = (E11PersonalData)request.getAttribute("E11PersonalData");
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function doSubmit() {
    if( check_data() ) {
        buttonDisabled();
        document.form1.BEGDA.value     = removePoint( document.form1.BEGDA.value );
        document.form1.MNTH_AMNT.value = removeComma( document.form1.MNTH_AMNT.value );
        document.form1.CMPY_FROM.value = removePoint( document.form1.CMPY_FROM.value );
        document.form1.CMPY_TOXX.value = removePoint( document.form1.CMPY_TOXX.value );
        document.form1.PERL_AMNT.value = removeComma( document.form1.PERL_AMNT.value );
        document.form1.CMPY_AMNT.value = removeComma( document.form1.CMPY_AMNT.value );
        document.form1.SUMM_AMNT.value = removeComma( document.form1.SUMM_AMNT.value );
        document.form1.ENTR_DATE.value = removePoint( document.form1.ENTR_DATE.value );

        document.form1.jobid.value  = "create"
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E11Personal.E11AnnulmentBuildSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function check_data() {
    if ( check_empNo() ){
        return false;
    }
    return true;
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=data.PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>개인연금/마이라이프 해약신청</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>해약신청일</th>
                    <td><input type="text" name="BEGDA" size="14" value="<%= WebUtil.printDate( DataUtil.getCurrentDate() ) %>" readonly> </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>연금구분</th>
                    <td colspan="3"><input type="text" name="PENT_TEXT2" size="14" value="<%= data.PENT_TEXT %>" readonly> </td>
                </tr>
                <tr>
                    <th>가입년월</th>
                    <td colspan="3"><input type="text" name="CMPY_FROM_M" size="14" value="<%= WebUtil.printDate( data.CMPY_FROM ).substring(0,7) %>" readonly></td>
                </tr>
                <tr>
                    <th>가입기간</th>
                    <td colspan="3"><input type="text" name="ENTR_TERM" size="14" value="<%= Integer.toString( Integer.parseInt( data.ENTR_TERM ) ) %>" readonly> </td>
                </tr>
                <tr>
                    <th>만기연월</th>
                    <td colspan="3"><input type="text" name="CMPY_TOXX_M" size="14" value="<%= WebUtil.printDate( data.CMPY_TOXX ).substring(0,7) %>" readonly > </td>
                </tr>
                <tr>
                    <th>잔여월수</th>
                    <td><input type="text" name="LAST_MNTH" size="14" value="<%= data.LAST_MNTH  %>" readonly > </td>
                    <th class="th02">월납입액</th>
                    <td><input type="text" name="MNTH_AMNT" size="14" value="<%= WebUtil.printNumFormat( data.MNTH_AMNT ) %>" readonly ></td>
                </tr>
                <tr>
                    <th>가입보험사</th>
                    <td><input type="text" name="BANK_TEXT" size="14" value="<%= data.BANK_TEXT %>" readonly > </td>
                    <th class="th02">불입누계</th>
                    <td><input type="text" name="SUMM_AMNT" size="14" value="<%= WebUtil.printNumFormat( data.SUMM_AMNT ) %>" readonly ></td>
                </tr>
            </table>
            <span class="commentOne"><span class="textPink">*</span> 는 필수 입력사항입니다.</span>
        </div>
    </div>

    <input type="hidden" name="CMPY_FROM" value="<%= WebUtil.printDate( data.CMPY_FROM ) %>" >
    <input type="hidden" name="CMPY_TOXX" value="<%= WebUtil.printDate( data.CMPY_TOXX ) %>" >
    <input type="hidden" name="PENT_TYPE" value="<%= data.PENT_TYPE %>" >
    <input type="hidden" name="BANK_TYPE" value="<%= data.BANK_TYPE %>" >
    <input type="hidden" name="ENTR_DATE" value="<%= WebUtil.printDate( data.ENTR_DATE ) %>" >
    <input type="hidden" name="PERL_AMNT" value="<%= WebUtil.printNumFormat( data.PERL_AMNT ) %>" >
    <input type="hidden" name="CMPY_AMNT" value="<%= WebUtil.printNumFormat( data.CMPY_AMNT ) %>" >
    <input type="hidden" name="PENT_TEXT" value="<%= data.PENT_TEXT %>" >
    <input type="hidden" name="jobid"     value="" >
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppBuild( data.PERNR, UPMU_TYPE ) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a href="javascript:doSubmit()"><span>신청</span></a></li>
        </ul>
    </div>

</div>
</form>

<%@ include file="/web/common/commonEnd.jsp" %>
