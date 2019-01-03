<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustMedicalPrint.jsp                                */
/*   Description  : 의료비지급명세서 Print 화면                                 */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-01  윤정현                                          */
/*                  2006-11-21  @v1.1 lsa 1.금액 -> 의료비총액/신용카드분/현금영수증분/현금으로 나누어 입력 */
/*                  2008-11-20  CSR ID:1361257 2008년말정산반영                 */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%
    String targetYear = (String)request.getAttribute("targetYear" );
    Vector medi_vt    = (Vector)request.getAttribute("medi_vt"    );
    String print_seq = (String)request.getAttribute("PNT_SEQ");//@2014 연말정산 소득공제신고서 seq 추가

    //CSR ID:2013_9999
    String pdfYn = (String)session.getAttribute("pdfYn");

%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>
<style type="text/css">

  .td05 {font-size: 7pt;
	background-color: #FFFFFF;
	text-align: center;
	padding-top: 3px;
	height:20px;
	color: #585858;
	}
</style>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="font01" align="center"><font size="5"><spring:message code="LABEL.D.D11.0186" /><!-- 의료비지급명세서 --></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size ="3"><%=print_seq %></font></td><!-- //@2014 연말정산 소득공제신고서 seq 추가 -->
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
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="74"  style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0085" /><!-- 성 명 --></td>
            <td class="td04" width="240" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;' colspan="3">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;</td>
            <td class="td03" width="90"  style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'><spring:message code="LABEL.D.D11.0006" /><!-- 주민등록번호 --></td>
            <td class="td04" width="240" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;'>&nbsp;&nbsp;<%= DataUtil.addSeparate(((WebUserData)session.getAttribute("user")).e_regno) %></td>
          </tr>
          <tr>
            <td class="td03" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0086" /><!-- 주 소 --></td>
            <td class="td04" colspan="5" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;'>&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_stras %>&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_locat %></td>
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
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> <%= targetYear %>  <spring:message code="LABEL.D.D11.0187" /><!-- 년도 의료비 지급내역 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--특별공제의료비 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" rowspan="2" width="20" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0088" /><!-- No. --></td>
            <td class="td03" rowspan="2" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></td>
            <td class="td03" rowspan="2" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0176" /><!-- 건수 --></td>
            <td class="td03" rowspan="2" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0188" /><!-- 지급금액 --></td>

            <td class="td03" rowspan="2" width="110" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0189" /><!-- 의료비<br>내용 --></td>
            <td class="td03" rowspan="2" width="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0190" /><!-- 지급처<br>(상호) --></td>
            <td class="td03" rowspan="2" width="100" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0172" /><!-- 의료증빙유형 --></td>
            <td class="td03" rowspan="2" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0173" /><!-- 안경<br>콘택트 --></td>
            <td class="td03" colspan="3"  style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0193" /><!-- 대상자 --></td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" rowspan="2" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></td>
<%
   }
%>
          </tr>
          <tr>
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" width="50"style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" width="45"style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0191" /><!-- 장애 -->/<BR><spring:message code="LABEL.D.D11.0192" /><!-- 경로 --></td>
          </tr>
<%
    double total = 0.0;

    double BETRG_C = 0.0;
    int  C_CNT = 0;
    double total_1 = 0.0;
    double total_2 = 0.0;
    double total_C = 0.0;
    double total_3 = 0.0;
    int  total_cnt = 0;
    int  total_3cnt = 0;
    int  no =0;
    for( int i = 0 ; i < medi_vt.size() ; i++ ){
        D11TaxAdjustMedicalData data = (D11TaxAdjustMedicalData)medi_vt.get(i);
        if (!data.OMIT_FLAG.equals("X")){ //연말정산삭제여부
        total = total + Double.parseDouble(data.BETRG);
        BETRG_C = Double.parseDouble(data.CC_BETRG)+Double.parseDouble(data.CR_BETRG);
        total_1 = total_1 + Double.parseDouble(data.CC_BETRG);
        total_2 = total_2 + Double.parseDouble(data.CR_BETRG);
        total_C = total_1 + total_2;
        total_3 = total_3 + Double.parseDouble(data.CA_BETRG);
        C_CNT   = Integer.parseInt(data.CC_CNT)+Integer.parseInt(data.CR_CNT);
        total_cnt   = total_cnt + Integer.parseInt(data.CC_CNT)+Integer.parseInt(data.CR_CNT);
        total_3cnt   = total_3cnt+ Integer.parseInt(data.CA_CNT);
        no++;
%>
          <tr>
            <td class="td04" nowrap style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= no %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.GUBUN.equals("1") ? "회사<br>지원" : "추가<br>입력" %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= Integer.parseInt(data.CA_CNT) %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.CA_BETRG.equals("") ? "" : WebUtil.printNumFormat(data.CA_BETRG) %>&nbsp;</td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.CONTENT.equals("") ? "&nbsp;" : data.CONTENT %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.BIZ_NAME.equals("") ? "&nbsp;" : data.BIZ_NAME %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.METYP_NAME.equals("") ? "&nbsp;" : data.METYP_NAME %></td><!--CSR ID:1361257-->
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.GLASS_CHK.equals("X") ? "check.gif" : "uncheck.gif" %>"></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= WebUtil.printOptionText((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%=  data.F_ENAME  %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">
<%
        if( data.OLDD.equals("X") && data.OBST.equals("X") ) {
%>
            <spring:message code="LABEL.D.D11.0191" /><!-- 장애 -->,<spring:message code="LABEL.D.D11.0192" /><!-- 경로 -->
<%
        } else if ( data.OLDD.equals("X") ) {
%>
            <spring:message code="LABEL.D.D11.0192" /><!-- 경로 -->
<%
        } else if ( data.OBST.equals("X") ) {
%>
            <spring:message code="LABEL.D.D11.0191" /><!-- 장애 -->
<%
        } else {
%>
            &nbsp;
<%
        }
%>
            </td>
<%
   if (pdfYn.equals("Y")){
%>

            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.GUBUN.equals("9") ? "check.gif" : "uncheck.gif" %>"></td><!--CSR ID:2013_9999 PDF -->
<%
   }
%>
          </tr>

<%
      } //삭제여부END
    }
%>

<%
    if ( no < 20) {

        int cnt = 20 - no;
        for ( int j = 0; j < cnt; j++) {
%>
          <tr>
            <td class="td04" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">&nbsp;</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">&nbsp;</td><!--CSR ID:2013_9999 PDF -->
<%
   }
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
          </tr>
<%
        }
    }
%>
          <tr>
            <td class="td03" colspan="2" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0194" /><!-- 계 --></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_3cnt) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_3) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">&nbsp;</td><!--CSR ID:2013_9999 PDF -->
<%
   }
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">&nbsp;</td>
          </tr>
        </table>
        <!--특별공제의료비 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0195" /><!-- 소득세법 제 52조 및 소득세법 시행령 제113조 제1항의 규정에 의하여 의료비를 공제 받고자 --></td>
          </tr>
          <tr>
            <td style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0196" /><!-- 의료비지급명세서를 제출합니다. --></td>
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
        <table width="644" border="0" cellspacing="0" cellpadding="2">
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
            &nbsp;&nbsp;<spring:message code="LABEL.D.D11.0197" /><!-- 구비서류 : 의료비지급영수증 -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0108" /><!-- 매 -->
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
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
