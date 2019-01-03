<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E18Hospital.*" %>
<%@ page import="hris.E.E18Hospital.rfc.*" %>

<%
    WebUserData     user_m               = (WebUserData)session.getAttribute("user_m");
    Vector          E18BillDetailData_vt = ( Vector ) request.getAttribute( "E18BillDetailData_vt" ) ;
    String          CNT1_WONX            = ( String ) request.getAttribute( "CNT1_WONX"  ) ;
    String          CNT2_WONX            = ( String ) request.getAttribute( "CNT2_WONX"  ) ;

    E18BillDetailData e18BillData = (E18BillDetailData)E18BillDetailData_vt.get(0) ;

//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e18BillData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="36">
      <td width="15">&nbsp;</td>
      <td class="td02">
        <font color="#0000FF"><%= "▶ " + user_m.ename + " " + user_m.e_titel + "의 HR정보입니다." + ( user_m.i_stat2.equals("0") ? " (퇴직자)" : "" ) %></font>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="title01">진료비 계산서 조회</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td><td>&nbsp;</td>
    </tr>
<%
    for ( int i = 0 ; i < E18BillDetailData_vt.size() ; i++ ) {
        E18BillDetailData data = ( E18BillDetailData ) E18BillDetailData_vt.get( i ) ;
%>
    <tr>
      <td width="15">&nbsp;</td>
      <td align="center">
        <table width="304" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td class="font01" valign="bottom"><font color="#7897FC">■</font>
              보험급여</td>
          </tr>
          <tr>
            <td>
              <table width="300" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr>
                  <td class="td03" width="100">총 진료비</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.TOTL_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.TOTL_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03">조합부담금</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.ASSO_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.ASSO_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03">본인부담금①</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.EMPL_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.EMPL_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="font01" valign="bottom"><font color="#7897FC">■</font>
              보험 비급여</td>
          </tr>
          <tr>
            <td>
              <table width="300" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr>
                  <td class="td03" width="100">식 대</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.MEAL_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.MEAL_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03">지정진료비</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.APNT_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.APNT_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03">상급병실료차액</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.ROOM_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.ROOM_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03">C T</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.CTXX_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.CTXX_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03">MRI</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.MRIX_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.MRIX_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03">초음파</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.SWAV_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.SWAV_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03"><%= data.ETC1_TEXT %></td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.ETC1_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.ETC1_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03"><%= data.ETC2_TEXT %></td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.ETC2_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.ETC2_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03"><%= data.ETC3_TEXT %></td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.ETC3_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.ETC3_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03"><%= data.ETC4_TEXT %></td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.ETC4_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.ETC4_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03"><%= data.ETC5_TEXT %></td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.ETC5_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.ETC5_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td class="td03">소 계②</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(CNT1_WONX).equals("0") ? "" : WebUtil.printNumFormat(CNT1_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="font01"><font color="#7897FC">■</font> 할인금액</td>
          </tr>
          <tr>
            <td>
              <table width="300" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr>
                  <td class="td03" width="100">할인금액③</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(data.DISC_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.DISC_WONX,currencyValue) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="font01"><font color="#7897FC">■</font> 본인부담금 총액</td>
          </tr>
          <tr>
            <td>
              <table width="300" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr>
                  <td class="td03" width="110">① + ② - ③</td>
                  <td class="td02" align=right><%= WebUtil.printNumFormat(CNT2_WONX,currencyValue) %>&nbsp;<%= e18BillData.WAERS %>&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
<%
    }
%>
    <tr>
      <td width="15">&nbsp;</td><td>&nbsp;</td>
    </tr>

  </table>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	   <td  align="center">
	    <div class="buttonArea">
	    <ul class="btn_crud">
	      <li><a href="javascript:history.back()"><span><!--뒤로가기--><%=g.getMessage("BUTTON.COMMON.BACK")%></span></a></li>
	    </ul>
	  </div>
	   </td>
	  </tr>
	</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
