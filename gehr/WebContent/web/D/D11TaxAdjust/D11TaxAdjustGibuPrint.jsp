<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustGibuPrint.jsp                                   */
/*   Description  : 기부금지급명세서 Print 화면                                 */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-11-23  lsa                                             */
/*                  2006.11.22 lsa  @v1.2  국체청자료 체크추가                  */
/*                  2008-11-20  CSR ID:1361257 2008년말정산반영                 */
/*                  2013-12-10  CSR ID:2013_9999 문구삭제,PDF추가               */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector gibu_vt    = (Vector)request.getAttribute("gibu_vt"    );
    String print_seq = (String)request.getAttribute("PNT_SEQ");//@2014 연말정산 소득공제신고서 seq 추가
    String Prev_YN="";
    //  전근무지 메뉴를 해당년도 입사자인 경우에만 메뉴를 보여준다.
    if( user.e_dat03.substring(0,4).equals(targetYear) ) {
    	Prev_YN ="Y";
    }

%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<style type="text/css">
  .font02 {font-size: 11px;
	background-color: #FFFFFF;
	text-align: center;
	padding-top: 3px;
	height:20px;
	color: #585858;
	}

.font021 { font-size: 10px;
	background-color: #FFFFFF;
	text-align: center;
	padding-top: 3px;
	height:20px;
	color: #585858;}
.font031 {  font-family: "굴림", "굴림체"; font-size: 18pt; background-color: #FFFFFF; color: #333333}
.font041 {  font-family: "굴림", "굴림체"; font-size: 10pt; background-color: #FFFFFF; color: #333333}
</style>



</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <table width="<%= Prev_YN.equals("Y") ? "644" :"644"  %>" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="font01" align="center"><font size="5"><spring:message code="LABEL.D.D11.0141" /><!-- 기부금명세서 --></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size ="3"><%=print_seq %></font></td><!-- //@2014 연말정산 소득공제신고서 seq 추가 -->
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--개인정보 테이블 시작-->
        <table width="<%= Prev_YN.equals("Y") ? "644" :"644"  %>" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="74"  style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0085" /><!-- 성 명 --></td>
            <td class="font02" width="240" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;' colspan="3">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;</td>
            <td class="td03" width="90"  style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'><spring:message code="LABEL.D.D11.0006" /><!-- 주민등록번호 --></td>
            <td class="font02" width="260" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;'>&nbsp;&nbsp;<%= DataUtil.addSeparate(((WebUserData)session.getAttribute("user")).e_regno) %></td>
          </tr>
          <tr>
            <td class="td03" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0086" /><!-- 주 소 --></td>
            <td class="font02" colspan="5" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;'>&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_stras %>&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_locat %></td>
          </tr>
        </table>
        <!--개인정보 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> <%= targetYear %>  <spring:message code="LABEL.D.D11.0142" /><!-- 년도 기부금 지급내역 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--특별공제기부금 테이블 시작-->
<%  if (Prev_YN.equals("Y")  ) { %>
        <table width="644"" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" nowrap  width="18"  rowspan=2 style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0088" /><!-- No. --></td>
            <td class="td03" nowrap  width="60"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0143" /><!-- 기부금<br>유형 --></td>
            <td class="td03" nowrap  width="18"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0144" /><!-- 코드 --></td>
            <td class="td03" nowrap  width="45"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0145" /><!-- 기부<br>년월 --></td>
            <td class="td03" width="10"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></td><!-- CSR ID:2013_9999 PDF -->
            <td class="td03" width="83"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0146" /><!-- 기부금<br>내용 --></td>
            <td class="td03" width="145" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0135" /><!-- 기부처 --></td>
            <td class="td03" nowrap width="120" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0131" /><!-- 기부자 --></td>
            <td class="td03" nowrap  width="70"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></td>
            <td class="td03" nowrap width="85" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0142" /><!-- 이월공제 --></td>
          </tr>
          <tr>
            <td class="td03" nowrap width1="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0148" /><!-- 상호<br>(법인명) --></td>
            <td class="td03" nowrap width1="65" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></td>
            <td class="td03" nowrap width1="55" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" nowrap width1="65" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>
            <td class="td03" nowrap width="25" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0149" /><!-- 년도 --></td>
            <td class="td03" nowrap width="60" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0138" /><!-- 전년까지<br>공제액 --></td>
          </tr>
<% }else{ %>
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" nowrap  width="20"  rowspan=2 style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0088" /><!-- No. --></td>
            <td class="td03" nowrap  width="70"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0132" /><!-- 기부금유형 --></td>
            <td class="td03" nowrap  width="20"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0144" /><!-- 코드 --></td>
            <td class="td03" nowrap  width="50"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0145" /><!-- 기부<br>년월 --></td>
            <td class="td03" width="30"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></td><!-- CSR ID:2013_9999 PDF -->
            <td class="td03" width="134"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0146" /><!-- 기부금<br>내용 --></td>
            <td class="td03" width="160" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0135" /><!-- 기부처 --></td>
            <td class="td03" nowrap width="130" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0131" /><!-- 기부자 --></td>
            <td class="td03" nowrap  width="70"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></td>
          </tr>
          <tr>
            <td class="td03" nowrap width="90" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0148" /><!-- 상호<br>(법인명) --></td>
            <td class="td03" nowrap width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></td>
            <td class="td03" nowrap width="60" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" nowrap width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>

          </tr>
<% } %>
<%
    double total    = 0.0;
    double total_prev = 0.0;
    double total_10 = 0.0;
    double total_20 = 0.0;
    double total_21 = 0.0;
    double total_30 = 0.0;
    double total_31 = 0.0;
    double total_40 = 0.0;
    double total_41 = 0.0;
    double total_42 = 0.0;
    double total_50 = 0.0;
    double total_10_prev = 0.0;
    double total_20_prev = 0.0;
    double total_21_prev = 0.0;
    double total_30_prev = 0.0;
    double total_31_prev = 0.0;
    double total_40_prev = 0.0;
    double total_41_prev = 0.0;
    double total_42_prev = 0.0;
    double total_50_prev = 0.0;
    int  no =0;
    for( int i = 0 ; i < gibu_vt.size() ; i++ ){
        D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibu_vt.get(i);

        if (!data.OMIT_FLAG.equals("X")){ //연말정산삭제여부
        no++;
        total = total + Double.parseDouble(data.DONA_AMNT);
        total_prev = total_prev + Double.parseDouble(data.DONA_DEDPR);
        if (data.DONA_CODE.equals("10")){
            total_10 = total_10 + Double.parseDouble(data.DONA_AMNT);
            total_10_prev = total_10_prev + Double.parseDouble(data.DONA_DEDPR);
        } else if (data.DONA_CODE.equals("20")) {
            total_20 = total_20 + Double.parseDouble(data.DONA_AMNT);
            total_20_prev = total_20_prev + Double.parseDouble(data.DONA_DEDPR);
        } else if (data.DONA_CODE.equals("21")) {
            total_21 = total_21 + Double.parseDouble(data.DONA_AMNT);
            total_21_prev = total_21_prev + Double.parseDouble(data.DONA_DEDPR);
        } else if (data.DONA_CODE.equals("30")) {
            total_30 = total_30 + Double.parseDouble(data.DONA_AMNT);
            total_30_prev = total_30_prev + Double.parseDouble(data.DONA_DEDPR);
        } else if (data.DONA_CODE.equals("31")) {
            total_31 = total_31 + Double.parseDouble(data.DONA_AMNT);
            total_31_prev = total_31_prev + Double.parseDouble(data.DONA_DEDPR);
        } else if (data.DONA_CODE.equals("40")) {
            total_40 = total_40 + Double.parseDouble(data.DONA_AMNT);
            total_40_prev = total_40_prev + Double.parseDouble(data.DONA_DEDPR);
        } else if (data.DONA_CODE.equals("41")) {
            total_41 = total_41 + Double.parseDouble(data.DONA_AMNT);
            total_41_prev = total_41_prev + Double.parseDouble(data.DONA_DEDPR);
        } else if (data.DONA_CODE.equals("42")) {
            total_42 = total_42 + Double.parseDouble(data.DONA_AMNT);
            total_42_prev = total_42_prev + Double.parseDouble(data.DONA_DEDPR);
        } else if (data.DONA_CODE.equals("50")) {
            total_50 = total_50 + Double.parseDouble(data.DONA_AMNT);
            total_50_prev = total_50_prev + Double.parseDouble(data.DONA_DEDPR);
        }
%>
          <tr>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= no %></td>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.DONA_NAME.equals("") ? "&nbsp;" : data.DONA_NAME %>&nbsp;</td>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.DONA_CODE.equals("") ? "&nbsp;" : data.DONA_CODE %></td>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.DONA_YYMM.equals("") ? "&nbsp;" : data.DONA_YYMM.substring(0,4)+"."+data.DONA_YYMM.substring(4,6) %></td>

            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.GUBUN.equals("9") ? "check.gif" : "uncheck.gif" %>"></td><!-- CSR ID:2013_9999 PDF -->
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;<%= data.DONA_DESC %></td>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;<%= data.DONA_COMP.equals("") ? "&nbsp;" : data.DONA_COMP %></td>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.DONA_NUMB.equals("") ? "&nbsp;" : data.DONA_NUMB %></td>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;<%= data.F_ENAME.equals("") ? "&nbsp;" : data.F_ENAME %></td>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.F_REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.F_REGNO) %></td>
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.DONA_AMNT.equals("") ? "" : WebUtil.printNumFormat(data.DONA_AMNT) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>
            <td class="font021" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.DONA_CRVYR.equals("0000") ? "&nbsp;" : data.DONA_CRVYR %></td><!--이월공제년도-->
            <td class="font021" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.DONA_DEDPR.equals("")||data.DONA_DEDPR.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.DONA_DEDPR) %></td>
            <% } %>
          </tr>
<%
	}

    }
    if ( no < 12) {

        int cnt = 12 - no;
        for ( int j = 0; j < cnt; j++) {
%>
          <tr>
            <td class="font02" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td><!-- CSR ID:2013_9999 -->
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <% } %>
          </tr>
<%
        }
    }
%>

<%  int PCol=0;
    if (Prev_YN.equals("Y")  ) {
        PCol = 9;
    }else {
        PCol = 9;
    }
%>
          <tr>
            <td class="font02" rowspan=5 style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0150" /><!-- 소계 --></td>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><spring:message code="LABEL.D.D11.0151" /><!-- 가.「소득세법」제34조 제2항의 기부금(법정기부금,코드10) -->&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_10) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>
            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_10_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><spring:message code="LABEL.D.D11.0152" /><!-- 나.「조세특례제한법」제76조의 기부금(정치자금,코드20) -->&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_20) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>
            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_20_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
<!--          <tr>
            <td class="font02" colspan=8 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">다.「조세특례제한법」제73조 제1항 제1호의 기부금(진흥기금출연,코드21)&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_21) %>&nbsp;</td>
            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_21_prev) %>&nbsp;</td>
          </tr>  -->
<!-- CSR ID:2013_9999 문구삭제
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">다.「조세특례제한법」제73조 제1항(동항 제1호를 제외합니다)의 기부금(조특법 73,코드30)&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_30) %>&nbsp;</td>
            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_30_prev) %>&nbsp;</td>
          </tr>
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">라.「조세특례제한법」제73조 제1항 제11호에 따른 공익법인기부신탁 기부금 공제금액(조특법 73,코드31)&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_31) %>&nbsp;</td>
            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_31_prev) %>&nbsp;</td>
          </tr>
-->
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><spring:message code="LABEL.D.D11.0153" /><!-- 다.「소득세법」제34조 제1항의 기부금(지정기부금,코드40) -->&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_40) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>

            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_40_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0154" /><!-- ㄱ.「소득세법」제34조 제1항의 기부금 중 종교단체 기부금(종교단체 기부금부금,코드41) -->&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_41) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>

            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_41_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><spring:message code="LABEL.D.D11.0155" /><!-- 라.「조세특례제한법」제88조의 4의 우리사주조합기부금(우리사주기부금,코드42) -->&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_42) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>
            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_42_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
<!-- CSR ID:2013_9999 문구삭제
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">사.&nbsp;&nbsp;기타 기부금(기타,코드50)&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_50) %>&nbsp;</td>
            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_50_prev) %>&nbsp;</td>
          </tr>-->
          <tr>
            <td class="td03" colspan=<%=PCol+1%> style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0156" /><!-- 계 --></td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>

            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
        </table>
        <!--특별공제기부금 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="<%= Prev_YN.equals("Y") ? "644" :"644"  %>" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0157" /><!-- 소득세법 제 52조 및 소득세법 시행령 제113조 제1항의 규정에 의하여 기부금을 공제 받고자 --></td>
          </tr>
          <tr>
            <td style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0158" /><!-- 기부금명세서를 제출합니다. --></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="<%= Prev_YN.equals("Y") ? "644" :"644"  %>" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td align="right" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            <%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;<spring:message code="LABEL.D.D11.0101" /><!-- 년 -->&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;<spring:message code="LABEL.D.D11.0102" /><!-- 월 -->&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;<spring:message code="LABEL.D.D11.0103" /><!-- 일 -->&nbsp;&nbsp;
            </td>
          </tr>
          <tr>
            <td align="right" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            <spring:message code="LABEL.D.D11.0104" /><!-- 제출자 -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0105" /><!-- ( 서명 또는 인 ) -->&nbsp;&nbsp;</td>
            </td>
          </tr>
          <tr>
            <td align="center" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'><spring:message code="LABEL.D.D11.0106" /><!-- 귀하 --></td>
          </tr>
          <tr>
            <td width="15">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="left" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;<spring:message code="LABEL.D.D11.0159" /><!-- 구비서류 : 기부금영수증 -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매
            </td>
          </tr>

        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
<%@ include file="/web/common/commonEnd.jsp" %>
