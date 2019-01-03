<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금/마이라이프 조회                                    */
/*   Program ID   : E11PersonalDetail.jsp                                       */
/*   Description  : 개인연금/마이라이프 상세조회                                */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E11Personal.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    E11PersonalData data = (E11PersonalData)request.getAttribute("detailData");
    String PERNR = (String)request.getAttribute("PERNR");
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
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E11Personal.E11AnnulmentBuildSV";
    document.form1.method = "post";
    document.form1.submit();
  }
}
function check_data() {
//하나 이상의 건이 있을수 있고, 동시에 해약된 상태나 진행중일수 없으므로 버튼은 보여주고 아래처럼 체크를 한다.
  if( document.form1.STATUS.value == "만기" || document.form1.STATUS.value == "해약" ) {
    alert("이미 만기되었거나 해약된 개인연금/마이라이프는 해약신청할 수 없습니다.");
    return false;
  }

  document.form1.MNTH_AMNT.value = removeComma( document.form1.MNTH_AMNT.value );
  document.form1.CMPY_FROM.value = removePoint( document.form1.CMPY_FROM.value );
  document.form1.CMPY_TOXX.value = removePoint( document.form1.CMPY_TOXX.value );
  document.form1.PERL_AMNT.value = removeComma( document.form1.PERL_AMNT.value );
  document.form1.CMPY_AMNT.value = removeComma( document.form1.CMPY_AMNT.value );
  document.form1.SUMM_AMNT.value = removeComma( document.form1.SUMM_AMNT.value );
  document.form1.ENTR_DATE.value = removePoint( document.form1.ENTR_DATE.value );
  return true;
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>개인연금/마이라이프 상세조회</h1></div>

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
                    <th>연금구분</th>
                    <td>
                        <input type="text"   name="PENT_TEXT2" size="20" value="<%= data.PENT_TEXT %>" readonly>
                        <input type="hidden" name="PENT_TYPE2" size="20" value="<%= data.PENT_TYPE %>">
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
                    <td><input type="text" name="CMPY_FROM_M" size="14" value="<%= WebUtil.printDate( data.CMPY_FROM ).substring(0,7) %>" readonly> </td>
                    <th class="th02">월납입액</th>
                    <td><input type="text" name="MNTH_AMNT" size="14" value="<%= WebUtil.printNumFormat( data.MNTH_AMNT ) %> "  style="text-align:right" readonly ></td>
                </tr>
                <tr>
                    <th>가입기간</th>
                    <td><input type="text" name="ENTR_TERM" size="14" value="<%= Integer.toString( Integer.parseInt( data.ENTR_TERM ) ) %>" readonly> </td>
                    <th class="th02">불입누계</th>
                    <td><input type="text" name="SUMM_AMNT" size="14" value="<%= WebUtil.printNumFormat( data.SUMM_AMNT ) %> " style="text-align:right" readonly ></td>
                </tr>
                <tr>
                    <th>만기연월</th>
                    <td><input type="text" name="CMPY_TOXX_M" size="14" value="<%= WebUtil.printDate( data.CMPY_TOXX ).substring(0,7) %>" readonly > </td>
                    <th class="th02">해약일자</th>
                    <td><input type="text" name="ABDN_DATE" size="14" value="<%= WebUtil.printDate( data.ABDN_DATE ) %>" readonly > </td>
                </tr>
                <tr>
                    <th>잔여월수</th>
                    <td colspan="3"><input type="text" name="LAST_MNTH" size="14" value="<%=  data.LAST_MNTH %>" readonly > </td>
                </tr>
                <tr>
                    <th>가입보험사</th>
                    <tdcolspan="3"> <input type="text" name="BANK_TEXT" size="14" value="<%= data.BANK_TEXT %>" readonly > </td>
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
<%
    if( data.STATUS.equals("진행중") ) {
%>
              <!--<a href="javascript:doSubmit()"><img src="<%= WebUtil.ImageURL %>btn_annulment.gif" align="absmiddle" border="0"></a>--><%
    }
%>
        </ul>
    </div>

</div>
</form>

<%@ include file="/web/common/commonEnd.jsp" %>

