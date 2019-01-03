<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 연급여                                                      */
/*   Program Name : 연급여                                                      */
/*   Program ID   : D06Mpayhwahak_m.jsp                                         */
/*   Description  : 개인의 월급여 프린트                                        */
/*   Note         :                                                             */
/*   Creation     : 2005-01-20  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);

    Vector d05MpayDetailData1_vt = (Vector)request.getAttribute( "d05MpayDetailData1_vt" ) ; // 해외급여 반영내역(항목) 내역

    Vector d05MpayDetailData2_vt = (Vector)request.getAttribute( "d05MpayDetailData2_vt" ) ; // 지급내역/공제내역
//  Vector d05ZocrsnTextData_vt  = (Vector)request.getAttribute( "d05ZocrsnTextData_vt" ) ;  // 급여사유 코드와 TEXT

    Vector d05MpayDetailData3_vt = (Vector)request.getAttribute( "d05MpayDetailData3_vt" ) ; // 과세추가내역
    Vector d05MpayDetailData4_vt = (Vector)request.getAttribute( "d05MpayDetailData4_vt" ) ; // 변형 과세추가내역

    Vector d05MpayDetailData5_vt = (Vector)request.getAttribute( "d05MpayDetailData5_vt" ) ; // 지급내역text
    Vector d05MpayDetailData6_vt = (Vector)request.getAttribute( "d05MpayDetailData6_vt" ) ; // 해외지급내역수정

    D05MpayDetailData4  d05MpayDetailData4 = (D05MpayDetailData4) request.getAttribute( "d05MpayDetailData4"  ) ; // 급여명세표 - 개인정보/환율 내역
    D05MpayDetailData5  d05MpayDetailData5 = (D05MpayDetailData5) request.getAttribute( "d05MpayDetailData5"  ) ; // 지급내역/공제내역의 합

    String year    = (String)request.getAttribute("year");
    String month   = (String)request.getAttribute("month");
    String ocrsn   = (String)request.getAttribute("ocrsn");
    String ocrsn_t = ocrsn.substring(0,2);
%>

<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 : 급여명세표 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D05.0003"/>  
    <jsp:param name="help" value="D06Mpay.html"/>    
</jsp:include>

<SCRIPT LANGUAGE="JavaScript">
<!--
function f_print(){
    self.print();
}
//-->
</SCRIPT>



<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20">&nbsp;</td>
    <td width="624"><table width="624" border="0" cellspacing="0" cellpadding="0"  align="center">
        <tr> 
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif" />
                    <%=g.getMessage("LABEL.D.D05.0003")%></td>
              </tr>
            </table></td>
        </tr>
  <tr>
    <td align="center">
      <table width="624" border="0" cellpadding="3" cellspacing="1" class="table02">
        <tr>
          <td width="120" ><%= year %><%=g.getMessage("LABEL.D.D15.0020")%> <%= month %><%=g.getMessage("LABEL.D.D15.0021")%></td>
          <td ><%=g.getMessage("LABEL.D.D05.0004")%> : &nbsp;<%= user_m.e_orgtx %></td>
          <td width="120" ><%=g.getMessage("LABEL.D.D05.0005")%> : &nbsp;<%= user_m.empNo %></td>
          <td width="120" ><%=g.getMessage("LABEL.D.D05.0006")%> : &nbsp;<%= user_m.ename %></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td height="10"></td>
  </tr>
  <tr>
    <td align="center">
      <!--급여명세 테이블 시작-->
            <table width="624" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td> <table width="624" border="0" cellpadding="2" cellspacing="1" class="table02">
                    <tr> 
                <td  width="60"><spring:message code="LABEL.D.D05.0075" /></td><!-- 총지급액 -->
                <td  width="110" align="right"><%= WebUtil.printNumFormat(d05MpayDetailData4.BET01) %>&nbsp;</td>
                <td  width="60"><spring:message code="LABEL.D.D05.0077" /></td><!-- 공제총액 -->
                <td  width="110" align="right"><%= WebUtil.printNumFormat(d05MpayDetailData4.BET02) %>&nbsp;</td>
                <td  width="70"><spring:message code="LABEL.D.D15.0019" /></td><!-- 차감지급액 -->
                <td  width="183" align="right"><%= WebUtil.printNumFormat(d05MpayDetailData4.BET03) %>&nbsp;</td>
                   </tr>
                  </table></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td align="center"> <table width="624" border="0" cellpadding="2" cellspacing="1" class="table02" >
                    <tr> 
                      <td  width="150"><spring:message code="LABEL.D.D05.0014" /></td><!-- 지급내역 -->
                      <td  width="50"><spring:message code="LABEL.D.D05.0037" /></td><!-- 시간, % -->
                      <td  width="128"><spring:message code="LABEL.D.D05.0015" /></td><!-- 금액 -->
                      <td  width="150"><spring:message code="LABEL.D.D05.0016" /></td><!-- 공제내역 -->
                      <td  width="128"><spring:message code="LABEL.D.D05.0015" /></td><!--금액 -->
              </tr>
              <tr valign="top">
                <td  height="120">
<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
        D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);

        if(!data5.LGTXT.equals("소급분총액")) {

            // 성과급 중, 30만원 해당임금에 대해 생산성향상금으로 표시(임시). 2004.7.20. mkbae.
            if(data5.LGTXT.equals("성과급")&&data5.BET01.equals("300000.00")) {
%>
         <spring:message code="LABEL.D.D05.0100" /><br><!--  생산성향상금 -->
<%
            }else {
%>
         <%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %><br>
<%
            }
        }
    }
%>

<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
        D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);

        if(data5.BET01.equals("0")){
%>
        &nbsp;<br><br>
<%
        }else{
            if(data5.LGTXT.equals("소급분총액")) {
%>
        &nbsp;<br><br>
        <%= data5.LGTXT.equals("") ? "" : data5.LGTXT%><br>
<%
            }
        }
    }
%>
                </td>
                <td  height="120" align="right">
<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
        D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);

        if(!data5.LGTXT.equals("소급분총액")) {
%>
                <%= data5.ANZHL.equals("0") ? "　" : WebUtil.printNumFormat(data5.ANZHL,1) %>&nbsp;<br>
<%
        }
    }
%>

<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
        D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);

        if(data5.LGTXT.equals("소급분총액")) {
%>
               <%= data5.ANZHL.equals("0") ? "　" : WebUtil.printNumFormat(data5.ANZHL,1) %>&nbsp;<br>
<%
        }
    }
%>
                </td>
                <td  height="120" align="right">
<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
        D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);

        if(!data5.LGTXT.equals("소급분총액")) {
%>
                <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
<%
        }
    }
%>

<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
        D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);

        if(data5.LGTXT.equals("소급분총액")) {
%>
               &nbsp;<br><br>
               <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
<%
        }
%>

<%
    }
%>
                </td>
                <td  height="120" align="right" style="vertical-align: top;">
<%
    for ( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
        D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
        if ( data2.LGTX1.equals("")) {
            if ( data2.BET02.equals("0")) {
                continue;
            }
        }else{
            if(data2.BET02.equals("0")){
%>
           &nbsp;
<%
            }else{
                if ( data2.LGTX1.equals("소급분공제총액")) {
%>
                <%= data2.LGTX1.equals("") ? "　" :  data2.LGTX1%>
<%
                } else {
%>
                <%= data2.LGTX1.equals("") ? "　" :  data2.LGTX1%><br>
<%
                }
            }
        }
    }
%>
                </td>
                <td  height="120" align="right" style="vertical-align: top;"> 
<%
    for ( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
        D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);

        if ( data2.LGTX1.equals("")) {
            if ( data2.BET02.equals("0")) {
                continue;
            }
        }else{
%>
                <%= data2.BET02.equals("0") ? "　" :WebUtil.printNumFormat(data2.BET02) %>&nbsp;<br>

<%
        }
    }
%>
                </td>
              </tr>
              <tr>
                <td ><spring:message code="LABEL.D.D05.0022" /></td><!--  지급계-->
                <td  align="right"><%= d05MpayDetailData5.ANZHL.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData5.ANZHL,1) %>&nbsp;</td>
                <td  align="right"><%= d05MpayDetailData5.BET01.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData5.BET01) %>&nbsp;</td>
                <td ><spring:message code="LABEL.D.D05.0023" /></td><!-- 공제계 -->
                <td  align="right"><%= d05MpayDetailData5.BET02.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData5.BET02) %>&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
<%
    if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {

        if(d05MpayDetailData4_vt.size() != 0 && d05MpayDetailData5_vt.size() != 0){
%>
        <tr>
          <td>
            <table width="500" border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                <spring:message code="LABEL.D.D05.0050" /></td><!-- 과세추가 내역 -->
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td align="center"> <table width="624" border="0" cellpadding="2" cellspacing="1" class="table02" >
<%
            if(d05MpayDetailData4_vt.size() == 0){
%>

              <tr>
                <td  width="180">&nbsp;</td>
                <td  width="122">&nbsp;</td>
                <td  width="180">&nbsp;</td>
                <td  width="121">&nbsp;</td>
              </tr>

<%
            } else {
%>
              <tr>
                <td  width="180">
<%
                for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
                    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
                    String kase_text ;
                    if( data4.LGTX1.length() > 4 ) {
                         kase_text = data4.LGTX1.substring(0,4);
                    } else {
                         kase_text = data4.LGTX1 ;
                    }

                    if ( kase_text.equals("과세반영")) {
%>
          <%= data4.LGTX1.equals("") ? "" : data4.LGTX1 %>&nbsp;<br>
<%
                    }else{
                        continue;
                    }
                }
%>
                </td>
                <td  width="122" align="right">
<%
                for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
                    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
                    String kase_text ;
                    if( data4.LGTX1.length() > 4 ) {
                         kase_text = data4.LGTX1.substring(0,4);
                    } else {
                         kase_text = data4.LGTX1 ;
                    }

                    if ( kase_text.equals("과세반영")) {
%>
          <%= data4.BET01.equals("0") ? "" : WebUtil.printNumFormat(data4.BET01) %>&nbsp;<br>
<%
                    }else{
                        continue;
                    }
                }
%>
                </td>
                <td  width="180">
<%
                for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
                    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
                    String kase_text ;
                    if( data4.LGTX1.length() > 4 ) {
                         kase_text = data4.LGTX1.substring(0,3);
                    } else {
                         kase_text = data4.LGTX1 ;
                    }

                    if ( kase_text.equals("소급분")) {
                        if(!data4.BET01.equals("0")) {
%>
          <%= data4.LGTX1.equals("") ? "" : data4.LGTX1 %>&nbsp;<br>
<%
                        }
                    }else{
                        continue;
                    }
                }
%>
                </td>
                <td  width="121" align="right">
<%
                for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
                    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
                    String kase_text ;
                    if( data4.LGTX1.length() > 4 ) {
                         kase_text = data4.LGTX1.substring(0,3);
                    } else {
                         kase_text = data4.LGTX1 ;
                    }

                    if ( kase_text.equals("소급분")) {
                        if(!data4.BET01.equals("0")) {
%>
          <%= data4.BET01.equals("0") ? "" : WebUtil.printNumFormat(data4.BET01) %>&nbsp;<br>
<%
                        }
%>
<%
                    }else{
                        continue;
                    }
                }
%>
                </td>
              </tr>
<%
            }
%>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
<%
        }
    }
%>

<%
    if(d05MpayDetailData1_vt.size() != 0){
%>
        <tr>
          <td align="center">
            <table width="624" border="0" cellpadding="2" cellspacing="1" >
              <tr>
                <td  class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                 <spring:message code="LABEL.D.D05.0060" /><!--  해외급여 반영내역 --></td>
<%
        if(d05MpayDetailData4.ZRATE.equals("0")) {
%>
                <td  width="150"><spring:message code="LABEL.D.D05.0061" /> : &nbsp;</td><!-- 환율 :  -->
<%
        }else{
            String zrate = d05MpayDetailData4.ZRATE.substring(0,5)+d05MpayDetailData4.ZRATE.substring(5,7);
%>
                <td  width="150"><spring:message code="LABEL.D.D05.0061" /><!-- 환율 :  --> : &nbsp;<%= zrate %></td>
<%
        }
%>
                <td ><spring:message code="LABEL.D.D05.0062" /><!-- 사용통화 :  --> : &nbsp;<%= d05MpayDetailData4.ZCURR %></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td align="center">
            <table width="624" border="0" cellpadding="2" cellspacing="1" class="table02" >
              <tr>
                <td  width="137"><spring:message code="LABEL.D.D05.0063" /></td><!-- 국내생계비 -->
                <td  align="right"><%= d05MpayDetailData4.BET04.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET04) %>&nbsp;</td>
                <td ><spring:message code="LABEL.D.D05.0064" /></td><!--  국내주택비-->
                <td  align="right"><%= d05MpayDetailData4.BET05.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET05) %>&nbsp;</td>
                <td ><spring:message code="LABEL.D.D05.0065" /></td><!-- 국내총액 -->
                <td  align="right"><%= d05MpayDetailData4.BET06.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET06) %>&nbsp;</td>
              </tr>
              <tr>
                <td ><spring:message code="LABEL.D.D06.0031" /></td><!-- 국내갑근세 -->
                <td  align="right"><%= d05MpayDetailData4.BET07.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET07) %>&nbsp;</td>
                <td ><spring:message code="LABEL.D.D06.0032" /></td><!-- 국내주민세 -->
                <td  align="right"><%= d05MpayDetailData4.BET08.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET08) %>&nbsp;</td>
                <td ><spring:message code="LABEL.D.D05.0068" /></td><!--세후총액  -->
                <td  align="right"><%= d05MpayDetailData4.BET09.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET09) %>&nbsp;</td>
              </tr>
              <tr>
                <td ><spring:message code="LABEL.D.D05.0071" /></td><!-- 해외수당 -->
                <td  align="right"><%= d05MpayDetailData4.BET10.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET10) %>&nbsp;</td>
                <td ><spring:message code="LABEL.D.D05.0072" /></td><!-- 급지수당 -->
                <td  align="right"><%= d05MpayDetailData4.BET11.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET11) %>&nbsp;</td>
                <td ><spring:message code="LABEL.D.D05.0073" /></td><!-- 국내NET -->
                <td  align="right"><%= d05MpayDetailData4.BET12.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET12) %>&nbsp;</td>
              </tr>
              <tr>
                <td ><spring:message code="LABEL.D.D05.0080" /></td>        <!-- 항목-->
                <td  width="80"><spring:message code="LABEL.D.D05.0015" /></td>     <!-- 금액 -->
                <td  width="80"><spring:message code="LABEL.D.D05.0074" /></td>     <!-- 현지화-->
                <td  width="137"><spring:message code="LABEL.D.D05.0080" /></td>        <!-- 항목-->
                <td  width="80"><spring:message code="LABEL.D.D05.0015" /></td>     <!-- 금액 -->
                <td  width="80"><spring:message code="LABEL.D.D05.0074" /></td>     <!-- 현지화-->
              </tr>
              <tr>
                <td  height="80">
<%
        for ( int i = 0 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
            D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                <%= data6.LGTXT %><br>
<%
        }
%>
                </td>
                <td  height="80" align="right">
<%
        for ( int i = 0 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
            D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                <%= data6.BET01.equals("0") ? "" : WebUtil.printNumFormat(data6.BET01) %>&nbsp;<br>
<%
        }
%>
                </td>
                <td  height="80" align="right">
<%
        for ( int i = 0 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
            D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                <%= data6.BET03.equals("0") ? "" : WebUtil.printNumFormat(data6.BET03) %>&nbsp;<br>
<%
        }
%>
                </td>
                <td  height="80">
<%
        for ( int i = 1 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
            D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                <%= data6.LGTXT %>&nbsp;<br>
<%
        }
%>
                </td>
                <td  height="80" align="right">
<%
        for ( int i = 1 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
            D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                <%= data6.BET01.equals("0") ? "" : WebUtil.printNumFormat(data6.BET01) %>&nbsp;<br>
<%
        }
%>
                </td>
                <td  height="80" align="right">
<%
        for ( int i = 1 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
        D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                <%= data6.BET03.equals("0") ? "" : WebUtil.printNumFormat(data6.BET03) %>&nbsp;<br>
<%
        }
%>
                </td>
              </tr>
              <tr>
                <td ><spring:message code="LABEL.D.D05.0010" /></td>        <!--  총지급액-->
                <td  align="right"><%= d05MpayDetailData4.BET01.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET01) %>&nbsp;</td>
                <td >&nbsp;</td>
                <td ><spring:message code="LABEL.D.D05.0076" /></td>        <!-- 국내입금액 -->
                <td  align="right"><%= d05MpayDetailData4.BET13.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET13) %>&nbsp;</td>
                <td >&nbsp;</td>
              </tr>
              <tr>
                <td ><spring:message code="LABEL.D.D05.0077" /></td>        <!-- 총공제액 -->
                <td  align="right"><%= d05MpayDetailData4.BET02.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET02) %>&nbsp;</td>
                <td >&nbsp;</td>
                <td ><spring:message code="LABEL.D.D05.0078" /></td>        <!-- 해외송금액 -->
                <td  align="right"><%= d05MpayDetailData4.BET14.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET14) %>&nbsp;</td>
                <td  align="right"><%= d05MpayDetailData4.BET15.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET15) %>&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
<%
    }
%>
<%
    if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {
%>
        <tr>
          <td align="center">
            <table width="624" border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                    <spring:message code="LABEL.D.D05.0081" /></td><!-- 근태현황 --> 
              </tr>
            </table>
            <table width="624" border="0" cellpadding="2" cellspacing="1" class="table02" >
              <tr>
                <td  width="100"><spring:message code="LABEL.D.D05.0082" /></td>    <!-- 근태일수 -->
                <td  width="108" align="right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK01),0) %>&nbsp;</td>
                <td  width="100"><spring:message code="LABEL.D.D05.0084" /></td>    <!-- 사용휴가일수 -->
                <td  width="108" align="right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK02),1) %>&nbsp;</td>
                <td  width="100"><spring:message code="LABEL.D.D05.0085" /></td>    <!-- 잔여휴가일수 -->
              <%  if (month.equals("12")) { %>
                <td  width="108" align="right">0.0&nbsp;</td>
              <%  }  else  {%>
                <td  width="108" align="right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK03),1) %>&nbsp;</td>
              <%  }  %>
              </tr>
            </table>
          </td>
        </tr>
<%
    } else {
%>
        <tr>
          <td>&nbsp;</td>
        </tr>
<%
    }
%>
      </table>
      <!--급여명세 테이블 시작-->
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="center">
<%
    if(user_m.companyCode.equals("C100")) {
%>
      <table width="624" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td ><spring:message code="LABEL.D.D15.0085" /><!-- 귀하의 노고에 진심으로 감사드립니다. --></td>
          <td width="122"><img src="<%= WebUtil.ImageURL %>img_logopay_hwahak.gif" width="122" height="27" align="absmiddle"></td>
        </tr>
      </table>
<%
    } else {
%>
      <table width="624" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td ><spring:message code="LABEL.D.D15.0085" /><!-- 귀하의 노고에 진심으로 감사드립니다. -->.</td>
          <td width="122"><img src="<%= WebUtil.ImageURL %>img_logopay_oil.gif" width="122" height="27" align="absmiddle"></td>
        </tr>
      </table>
<%
    }
%>
    </td>
  </tr>
<%
    if(user_m.e_trfar.equals("02") || user_m.e_trfar.equals("03") || user_m.e_trfar.equals("04")) {
%>
  <tr>
    <td>&nbsp;</td>
  </tr>
        <tr> 
          <td> <table width="624" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><font color="#CC3300"><spring:message code="MSG.D.D06.0002" />
                      <!-- ※ 개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 
                        사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며,<br>
                        &nbsp;&nbsp;&nbsp;&nbsp; 이를 위반시에는 취업규칙상의 규정과 절차에 따라 징계조치 
                        됨을 알려드립니다. -->
                        </font></td>
                    </tr>
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
<%
    }
%>
</table>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
