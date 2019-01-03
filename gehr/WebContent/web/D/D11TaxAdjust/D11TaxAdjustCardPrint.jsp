<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustCardPrint.jsp                                   */
/*   Description  : 신용카드지급명세서 Print 화면                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2006-11-30  lsa                                             */
/*                  2008-11-20  CSR ID:1361257 2008년말정산반영                 */
/*                  2012-12-21  C20121213_34842 2012 년말정산  전통시장여부추가 */
/*                  2013-12-10  CSR ID:2013_9999 대중교통추가                   */
/*                  2014-12-03 @2014 연말정산 사용기간 추가                                                            */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String targetYear = (String)request.getAttribute("targetYear" );
    Vector card_vt    = (Vector)request.getAttribute("card_vt"    );
    String print_seq = (String)request.getAttribute("PNT_SEQ");//@2014 연말정산 소득공제신고서 seq 추가

    //CSR ID:2013_9999
    String pdfYn = (String)session.getAttribute("pdfYn");

%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<style type="text/css">
  .td03_s {font-size: 8pt;
	background-color: #FFFFFF;
	text-align: center;
	padding-top: 3px;
	height:20px;
	color: #585858;
	}
	.stitle {  font-family: "굴림", "굴림체"; font-size: 9pt; line-height: 15pt; font-weight: bold}
</style>

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="font01" align="center"><font size="5"><spring:message code="LABEL.D.D11.0084" /><!-- 신용카드지급명세서 --></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size ="3"><%=print_seq %></font></td><!-- //@2014 연말정산 소득공제신고서 seq 추가 -->
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
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> <%= targetYear %>  <spring:message code="LABEL.D.D11.0087" /><!-- 년도 신용카드 지급내역 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--특별공제신용카드 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="20" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0088" /><!-- No. --></td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" width="60" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" width="110" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>
            <td class="td03" width="142" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></td>
            <td class="td03" width="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0048" /><!-- 공제대상액 --></td>
            <td class="td03" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0074" /><!-- 전통<br>시장 --></td>
            <td class="td03" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0075" /><!-- 대중<br>교통 --></td><!-- CSR ID:2013_9999 대중교통추가-->
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0089" /><!-- 사용<br>기간 --></td><!-- @2014 연말정산 사용기간추가-->
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td03" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><spring:message code="LABEL.D.D11.0090" /><!-- 사업관련<br>비용 --></td>

          </tr>
<%
    double total = 0.0;
    double total_card = 0.0;   //1 신용카드
    double total_money = 0.0;  //2 현금영수증
    double total_check = 0.0;  //6 직불/선불카드
    double total_card_trdmk = 0.0;   //1 신용카드_전통시장
    double total_money_trdmk = 0.0;  //2 현금영수증_전통시장
    double total_check_trdmk = 0.0;  //6 직불/선불카드_전통시장
    //CSR ID:2013_9999 대중교통추가
    double total_card_cctra = 0.0;   //1 신용카드_대중교통
    double total_money_cctra = 0.0;  //2 현금영수증_대중교통
    double total_check_cctra = 0.0;  //6 직불/선불카드_대중교통
    double total_B = 0.0;
    double total_O = 0.0;
    //double cash_total = 0.0;
    //String old_regno = "";
    //card_vt = SortUtil.sort_num(card_vt ,"F_REGNO", "asc");

   // Vector card_new_vt    = new Vector();
   // Vector card_hap_vt    = new Vector();

    int  no =0;
    D11TaxAdjustCardData data_new = new D11TaxAdjustCardData();

    for( int i = 0 ; i < card_vt.size() ; i++ ){
        D11TaxAdjustCardData data = (D11TaxAdjustCardData)card_vt.get(i);
        if (!data.OMIT_FLAG.equals("X")){ //연말정산삭제여부
        	no++;
        	total = total + Double.parseDouble(data.BETRG);
        	total_B = total_B + Double.parseDouble(data.BETRG_B);
        	total_O = total_O + Double.parseDouble(data.BETRG_O);
        	//C20121213_34842 2012
        	if(!data.EXPRD.equals("1")){
	        	if (data.TRDMK.equals("X") ) { //전통시장

	        		if (data.E_GUBUN.equals("2") ) { //현금영수증
	        		    total_money_trdmk = total_money_trdmk +( Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));
	        		} else if (data.E_GUBUN.equals("1") ) {  //신용카드
	        		    total_card_trdmk = total_card_trdmk + (Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));

	        		} else if (data.E_GUBUN.equals("6") ) {  //직불/선불카드
	        		    total_check_trdmk = total_check_trdmk + (Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));

	        		}
	        	}else if (data.CCTRA.equals("X") ) { //CSR ID:2013_9999 대중교통추가

	        		if (data.E_GUBUN.equals("2") ) { //현금영수증
	        		    total_money_cctra = total_money_cctra +( Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));
	        		} else if (data.E_GUBUN.equals("1") ) {  //신용카드
	        		    total_card_cctra = total_card_cctra + (Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));

	        		} else if (data.E_GUBUN.equals("6") ) {  //직불/선불카드
	        		    total_check_cctra = total_check_cctra + (Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));

	        		}
	        	}else{
	        		if (data.E_GUBUN.equals("2") ) { //현금영수증
	        		    total_money = total_money +( Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));
	        		} else if (data.E_GUBUN.equals("1") ) {  //신용카드
	        		    total_card = total_card + (Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));
	        		} else if (data.E_GUBUN.equals("6") ) {  //직불/선불카드
	        		    total_check = total_check + (Double.parseDouble(data.BETRG)-Double.parseDouble(data.BETRG_B));
	        		}


	        	}
        	}



%>
        	  <tr>
        	    <td class="td04" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= no %></td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= WebUtil.printOptionText((new A12FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.F_ENAME.equals("") ? "&nbsp;" : data.F_ENAME%></td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.F_REGNO.equals("") ? "" : DataUtil.addSeparate(data.F_REGNO) %></td>
        	    <td class="td04" nowarp style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.GU_NAME %></td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG.equals("") ? "" : WebUtil.printNumFormat(data.BETRG) %>&nbsp;</td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.TRDMK.equals("X") ? "check.gif" : "uncheck.gif" %>"></td><!--C20121213_34842 2012  전통시장여부 -->
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.CCTRA.equals("X") ? "check.gif" : "uncheck.gif" %>"></td><!-- CSR ID:2013_9999 대중교통추가-->
        	    <td class="td04" nowarp style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.EXPRD.equals("1") ? "13년" : data.EXPRD.equals("2") ? "14년上" :"14년下" %></td><!-- @2014 연말정산 사용기간추가 -->
<%
   if (pdfYn.equals("Y")){
%>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.GUBUN.equals("9") ? "check.gif" : "uncheck.gif" %>"></td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG_B.equals("") ? "" : WebUtil.printNumFormat(data.BETRG_B) %>&nbsp;</td>

        	  </tr>
<%  	}
    }
    if ( no < 18) {

        int cnt = 18 - no;
        for ( int j = 0; j < cnt; j++) {
%>
          <tr>
            <td class="td04" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td><!-- CSR ID:2013_9999 대중교통추가-->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td><!-- @2014 연말정산 사용기간추가-->
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td><!-- CSR ID:2013_9999 PDF-->
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
            <td class="td03" colspan="2" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">계</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td><!-- CSR ID:2013_9999 대중교통추가-->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td><!-- @2014 연말정산 사용기간추가-->
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_B) %>&nbsp;</td>
          </tr>
        </table>
        <!--특별공제신용카드 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
     <tr>
     <td align=center colspan=2>
          <table border=0 width=644 cellspacing="0" cellpadding="2">
          <tr>
          <td colspan=6 class="stitle">
          <spring:message code="LABEL.D.D11.0091" /><!-- <2014년도 사용액> -->
          </td>
          </tr>
          <tr>
          <td class="td03_s" width="100" align=right><spring:message code="LABEL.D.D11.0092" /><!-- 신 용 카 드 (일반) --></td>
          <td class="td04" width="100" style="text-align:right"><%= WebUtil.printNumFormat(total_card) %>&nbsp;</td>
          <td class="td03_s" width="122" align=right><spring:message code="LABEL.D.D11.0093" /><!-- 신 용 카 드 (전통시장) --></td>
          <td class="td04" width="100" style="text-align:right"><%= WebUtil.printNumFormat(total_card_trdmk) %>&nbsp;</td>
          <td class="td03_s" width="122" align=right><spring:message code="LABEL.D.D11.0094" /><!-- 신 용 카 드(대중교통) --></td>
          <td class="td04" width="100" style="text-align:right"><%= WebUtil.printNumFormat(total_card_cctra) %>&nbsp;</td>
          </tr>
          <tr>
          <td class="td03_s" align=right><spring:message code="LABEL.D.D11.0095" /><!-- 현금영수증(일반) --></td>
          <td class="td04" style="text-align:right"><%= WebUtil.printNumFormat(total_money) %>&nbsp;</td>
          <td class="td03_s" align=right><spring:message code="LABEL.D.D11.0096" /><!-- 현금영수증(전통시장) --></td>
          <td class="td04" style="text-align:right"><%= WebUtil.printNumFormat(total_money_trdmk) %>&nbsp;</td>
          <td class="td03_s" align=right><spring:message code="LABEL.D.D11.0097" /><!-- 현금영수증(대중교통) --></td>
          <td class="td04" style="text-align:right"><%= WebUtil.printNumFormat(total_money_cctra) %>&nbsp;</td>
          </td>
          </tr>
          <tr>
          <td class="td03_s"  align=right><spring:message code="LABEL.D.D11.0098" /><!-- 직 불 체 크 (일반) --></td>
          <td class="td04"  style="text-align:right"><%= WebUtil.printNumFormat(total_check) %>&nbsp;</td>
          <td class="td03_s"  align=right><spring:message code="LABEL.D.D11.0099" /><!-- 직 불 체 크 (전통시장) --></td>
          <td class="td04"  style="text-align:right"><%= WebUtil.printNumFormat(total_check_trdmk) %>&nbsp;</td>
          <td class="td03_s"  align=right><spring:message code="LABEL.D.D11.0100" /><!-- 직 불 체 크 (대중교통) --></td>
          <td class="td04"  style="text-align:right"><%= WebUtil.printNumFormat(total_check_cctra) %>&nbsp;</td>
          </td>
          </tr>
          </table>
      </td>
    </tr>
<!--<tr>
      <td align=center colspan=2>
          <table border=0 width=550><tr>
          <td class="td04" width="350" align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;기본공제가 아닌 대상자에게 지출된 의료비카드사용액</td>

          <td class="td04" width="200" align=left>
            <input type="text" name="BETRG_ETC" style="border:none" value="" size="15" class="input03" readonly style="text-align:right">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          </td>
          </tr>
          </table>
      </td>
    </tr>  -->
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
            &nbsp;&nbsp;<spring:message code="LABEL.D.D11.0107" /><!-- 구비서류 : 신용카드지급영수증 -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0108" /><!-- 매 -->
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
