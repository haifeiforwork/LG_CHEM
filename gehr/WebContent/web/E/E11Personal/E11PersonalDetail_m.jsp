<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금                                                    */
/*   Program ID   : E11PersonalDetail_m.jsp                                     */
/*   Description  : 개인연금/마이라이프 상세조회                                */
/*   Note         :                                                             */
/*   Creation     : 2002-02-01  박영락                                          */
/*   Update       : 2005-01-25  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E11Personal.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    E11PersonalData data = (E11PersonalData)request.getAttribute("detailData");
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E11Personal.E11PersonalDetailSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>개인연금/마이라이프 상세조회</h1></div>

    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->

<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>연금구분</th>
                    <td>
                        <input type="text"   name="PENT_TEXT" size="20" value="<%= data.PENT_TEXT %>" readonly>
                        <input type="hidden" name="PENT_TYPE" size="20" value="<%= data.PENT_TYPE %>">
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>가입년월</th>
                    <td><input type="text" name="CMPY_FROM_M" size="14" value="<%= WebUtil.printDate( data.CMPY_FROM ).substring(0,7) %>" readonly></td>
                    <th class="th02">월납입액</th>
                    <td><input type="text" name="MNTH_AMNT" size="14" value="<%= WebUtil.printNumFormat( data.MNTH_AMNT ) %> "  style="text-align:right" readonly ></td>
                </tr>
                <tr>
                    <th>가입기간</th>
                    <td><input type="text" name="ENTR_TERM" size="14" value="<%= Integer.toString( Integer.parseInt( data.ENTR_TERM ) ) %>" readonly></td>
                    <th class="th02">불입누계</th>
                    <td><input type="text" name="SUMM_AMNT" size="14" value="<%= WebUtil.printNumFormat( data.SUMM_AMNT ) %> " style="text-align:right" readonly ></td>
                </tr>
                <tr>
                    <th>만기연월</th>
                    <td><input type="text" name="CMPY_TOXX_M" size="14" value="<%= WebUtil.printDate( data.CMPY_TOXX ).substring(0,7) %>" readonly ></td>
                    <th>해약일자</th>
                    <td><input type="text" name="ABDN_DATE" size="14" value="<%= WebUtil.printDate( data.ABDN_DATE ) %>" readonly ></td>
                </tr>
                <tr>
                    <th>잔여월수</th>
                    <td colspan="3"><input type="text" name="LAST_MNTH" size="14" value="<%=  data.LAST_MNTH %>" readonly ></td>
                </tr>
                <tr>
                    <th>가입보험사</th>
                    <td colspan="3"><input type="text" name="BANK_TEXT" size="14" value="<%= data.BANK_TEXT %>" readonly ></td>
                </tr>
            </table>
        </div>
    </div>

    <input type="hidden" name="CMPY_FROM" value="<%= data.CMPY_FROM %>" >
    <input type="hidden" name="CMPY_TOXX" value="<%= data.CMPY_TOXX %>" >
    <input type="hidden" name="BEGDA"     value="<%= data.BEGDA     %>" >
    <input type="hidden" name="ENDDA"     value="<%= data.ENDDA     %>" >
    <input type="hidden" name="PENT_TYPE" value="<%= data.PENT_TYPE %>" >
    <input type="hidden" name="BANK_TYPE" value="<%= data.BANK_TYPE %>" >
    <input type="hidden" name="ENTR_DATE" value="<%= data.ENTR_DATE %>" >
    <input type="hidden" name="PERL_AMNT" value="<%= data.PERL_AMNT %>" >
    <input type="hidden" name="CMPY_AMNT" value="<%= data.CMPY_AMNT %>" >
    <input type="hidden" name="PENT_TEXT" value="<%= data.PENT_TEXT %>" >
    <input type="hidden" name="STATUS"    value="<%= data.STATUS %>" >
    <!-- 상단 입력 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back()"><span>목록</span></a></li>
        </ul>
    </div>


</div>
<%
}
%>
</form>

<%@ include file="/web/common/commonEnd.jsp" %>

