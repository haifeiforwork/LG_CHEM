<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D12IncomePrint.jsp                                          */
/*   Description  : 근로소득자 소득공제 신고서 Print 화면                       */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-01  윤정현                                          */
/*                  2005-12-05  @v1.1 특별공제 항목에 의료비와기부금합산처리    */
/*                  2006-11-23  @v1.2 특별공제교육비:국세청자료추가,부양가족공제자:금액으로변경  */
/*                  2008-11-20  CSR ID:1361257 2008년말정산반영                 */
/*                  2013-12-10  CSR ID:2013_9999  전통시장추가,월세항목추가 PDF여부추가  */
/*                              교육비: 장애인교육비 추가 ,재활비삭제            */
/*				월세:임대인성명, 임대인주민등록번호, 입대차계약서 상 주소지  추가*/
/*				특별공제,기타세액공제 :PDF추가		 	*/
/*				인적공제:장애코드 추가		 	        */
/*				PDF삭제는 제외처리		 	        */
/*  				2018-01-07 cykim [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector person_vt  = (Vector)request.getAttribute("person_vt"  );
    Vector special_vt = (Vector)request.getAttribute("special_vt" );
    Vector edu_vt     = (Vector)request.getAttribute("edu_vt"     );
    Vector tax_vt     = (Vector)request.getAttribute("tax_vt"     );
    Vector medi_vt    = (Vector)request.getAttribute("medi_vt"    );
    Vector family_vt  = (Vector)request.getAttribute("family_vt"  );
    Vector preWork_vt = (Vector)request.getAttribute("preWork_vt" );
    Vector preWorkHeadNm_vt = (Vector)request.getAttribute("preWorkHeadNm_vt" );
    Vector pension_vt = (Vector)request.getAttribute("pension_vt" );
    Vector rent_vt = (Vector)request.getAttribute("rent_vt" );
    String print_seq = (String)request.getAttribute("PNT_SEQ");//@2014 연말정산 소득공제신고서 seq 추가
    String pdfOnlyYN = (String)request.getAttribute("PDF_ONLY_YN");//@2014 연말정산 소득공제신고서 seq 추가

    Vector card_vt    = (Vector)request.getAttribute("card_vt"    );
    Vector medi_vt2    = (Vector)request.getAttribute("medi_vt2"    );
    Vector gibu_vt    = (Vector)request.getAttribute("gibu_vt"    );

    Vector houseLoan_vt = (Vector)request.getAttribute("houseLoan_vt"    );//@2015 연말정산 주택자금 상환 추가

//  전근무지 메뉴를 해당년도 입사자인 경우에만 메뉴를 보여준다.

    //CSR ID:2013_9999
    String pdfYn = (String)session.getAttribute("pdfYn");
    //@v1.1기부금공제

    WebUserData  user = (WebUserData)session.getAttribute("user");

    D11TaxAdjustGibuRFC   rfc   = new D11TaxAdjustGibuRFC();
    //Vector gibu_vt = new Vector();
    //gibu_vt = rfc.getGibu( user.empNo, targetYear );

    D11TaxAdjustHouseHoleCheckRFC   rfcHC   = new D11TaxAdjustHouseHoleCheckRFC();
    //D11TaxAdjustPersonCheckRFC      rfcPC   = new D11TaxAdjustPersonCheckRFC();  [CSR ID:3569665] 주석
    String begda = targetYear + "0101";
    String endda = targetYear + "1231";
    String E_HOLD =  rfcHC.getChk(  user.empNo, targetYear,begda,endda,""); //세대주체크여부
    //String E_CHG =  rfcPC.getChk(  user.empNo, targetYear,begda,endda,""); //인적공제변동여부  [CSR ID:3569665] 주석
    String Prev_YN="";
    if( user.e_dat03.substring(0,4).equals(targetYear) ) {
    	Prev_YN ="Y";
    }
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

</head>
<style type="text/css">
  .td03 {  font-size: 8pt;background-color: #F0EEDF; text-align: center; color: #585858; padding-top: 3px; height:20px;}

  .td04 {font-size: 8pt;
	background-color: #FFFFFF;
	text-align: center;
	padding-top: 3px;
	height:20px;
	color: #585858;
	}
  .td03_s {font-size: 8pt;
	background-color: #FFFFFF;
	text-align: center;
	padding-top: 3px;
	height:20px;
	color: #585858;
	}
    .td05 {font-size: 7pt;
	background-color: #FFFFFF;
	text-align: center;
	padding-top: 3px;
	height:20px;
	color: #585858;
	}
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
.stitle {  font-family: "굴림", "굴림체"; font-size: 9pt; line-height: 15pt; font-weight: bold}
</style>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="font01" align="center"><font size="5"><%= targetYear %> 근로소득자 소득공제 신고서</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size ="3"><%=print_seq %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PDF 외 : <%=pdfOnlyYN %></font></td><!-- //@2014 연말정산 소득공제신고서 seq 추가 -->
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
            <td class="td03" width="60" rowspan="3" style='border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>소득자</td>
            <td class="td03" width="60"  style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>부서명</td>
            <td class="td04" width="290" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;' colspan="3">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_obtxt %>&nbsp;</td>
            <td class="td03" width="104"  style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>성명</td>
            <td class="td04" width="130" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;</td>
          </tr>
          <tr>
            <td class="td03" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>입사일자</td>
            <td class="td04" width="150" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;;text-align:left;'>&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_dat03.substring(0,4) + "년 " + ((WebUserData)session.getAttribute("user")).e_dat03.substring(5,7) + "월 " + ((WebUserData)session.getAttribute("user")).e_dat03.substring(8,10) +"일" %></td>
            <td class="td03" width="60"  style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>사번</td>
            <td class="td04" width="80" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).empNo %>&nbsp;</td>
            <td class="td03" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>주민등록번호</td>
            <td class="td04" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center;'>&nbsp;&nbsp;<%= DataUtil.addSeparate(((WebUserData)session.getAttribute("user")).e_regno) %></td>
          </tr>
          <tr>
            <td class="td03" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>주소</td>
            <td class="td04" colspan="5" style='border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;'>&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_stras %>&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_locat %></td>
          </tr>
        </table>
        <!--개인정보 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="font01">

            <input type="checkbox" name="checkbox3" value="P_CHG"  <%-- <%= E_CHG.equals("X")  ? "checked" : "" %> --%> disabled>   인적공제 변동여부
            &nbsp;&nbsp;&nbsp;<input type="checkbox" name="FSTID" value="P_CHG"  <%= E_HOLD.equals("X")  ? "checked" : "" %>  disabled>세대주 여부
            </td>
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
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 인적공제</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--인적공제 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2"  bordercolor="#999999">
          <tr>
            <td class="td03" rowspan="2" width="66" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">관계</td>
            <td class="td03" rowspan="2" width="67" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">성명</td>
            <td class="td03" nowrap rowspan="2" width="90" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주민번호</td>
            <td class="td03" rowspan="2" width="73" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기본공제</td>
            <td class="td03" colspan="4" style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;">추가공제</td>
            <td class="td03" rowspan="2"  width="51" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">위탁<BR>아동</td><!-- [CSR ID:3569665] 위치 수정 -->
          </tr>
          <tr>
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">경로우대</td>
            <td class="td03" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">장애자(코드)</td><!--CSR ID: 2013_9999 -->
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">부녀자</td>
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">한부모<br>가족</td><!--CSR ID: 2013_9999 -->
            <!-- @2014 연말정산 자녀양육비/출산입양 삭제
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">자녀<BR>양육비</td>
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">출산·<BR>입양</td>  -->
          </tr>
<%
    for( int i = 0 ; i < person_vt.size() ; i++ ){
        D11TaxAdjustPersonData data = (D11TaxAdjustPersonData)person_vt.get(i);
        if( data.STEXT.equals("합계") ) {
%>
          <tr>
            <td class="td04" colspan="3" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;border-left:.5pt solid windowtext;"><%= data.STEXT %></td>
<%
        } else {
%>
          <tr>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;border-left:.5pt solid windowtext;"><%= data.STEXT.equals("") ? "&nbsp;" : data.STEXT %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= data.ENAME %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;" nowrap><%= data.REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.REGNO) %></td>
<%
        }
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG01.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.BETRG01) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG02.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.BETRG02) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG03.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.BETRG03) %><%= data.HNDCD.equals("") ? "" : "("+data.HNDCD+")" %>&nbsp;</td><!--CSR ID: 2013_9999 장애코드-->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG04.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.BETRG04) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG07.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.BETRG07) %>&nbsp;</td><!--CSR ID:2013_9999 한부모 가족-->
            <!-- @2014 연말정산 자녀양육비/출산입양 삭제
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">< %= data.BETRG05.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.BETRG05) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">< %= data.BETRG06.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.BETRG06) %>&nbsp;</td>  -->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.FSTID.equals("X")  ? "O" : "" %>&nbsp;</td>
          </tr>
<%
    }
%>
        </table>
        <!--인적공제 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 보험금/의료비/기부금</td> <!-- @2014 연말정산 특별공제 명칭 변경 --><!-- @2015 연말정산 주택자금상환 분리 -->
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--특별공제 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" rowspan="2" width="290" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">구분</td>
            <td class="td03" rowspan="2" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">개인추가분</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" rowspan="2" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td><!--CSR ID:2013_9999-->
<%
   }
%>
            <td class="td03" colspan="2" style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;">자동반영분</td>
          </tr>
          <tr>
            <td class="td03" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
            <td class="td03" width="180" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">내용</td>
          </tr>
<%
    for( int i = 0 ; i < special_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)special_vt.get(i);
        double hap = 0.0;

       // if( !data.ADD_BETRG.equals("0.0") || !data.AUTO_BETRG.equals("0.0") ) {
       if( !data.OMIT_FLAG.equals("X")  ) { //CSR ID:2013_9999 PDF 삭제 제외

%>
          <tr>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-left:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;<%= data.GUBN_TEXT %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.ADD_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ADD_BETRG)  %>&nbsp;</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.ACT_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ACT_BETRG)  %>&nbsp;</td><!--PDF CSR ID:2013_9999-->
<%
   }
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.AUTO_BETRG.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.AUTO_BETRG) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;<%= data.AUTO_TEXT %></td>
          </tr>
<%
        }
    }
%>
        </table>
        <!--특별공제 테이블 끝-->

        <!-- @2015 연말정산 주택자금공제 항목 추가 -->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 주택자금 공제</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--주택자금공제  테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="35%" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">구분</td>
            <td class="td03" width="13%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">최초차입일</td>
            <td class="td03" width="13%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">최종상환예정일</td>
            <td class="td03" width="13%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">대출기간(년)</td><!-- @2016연말정산 -->
            <td class="td03" width="15%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
            <td class="td03" width="5%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">고정금리</td>
            <td class="td03" width="5%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">비거치</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" width="5%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
          </tr>
<%
    for( int i = 0 ; i < houseLoan_vt.size() ; i++ ){
        D11TaxAdjustHouseLoanData data = (D11TaxAdjustHouseLoanData)houseLoan_vt.get(i);
        if(  !data.SUBTY.equals("") && !data.OMIT_FLAG.equals("X")  ) { //CSR ID:2013_9999 PDF 삭제 제외
%>
          <tr>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-left:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.SUBTY.equals("")  ? "&nbsp;" : WebUtil.printOptionText((new D11TaxAdjustPensionCodeRFC()).getHouseLoanType(targetYear,"3",""), data.SUBTY) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%=data.RCBEG.equals("0000-00-00") ? "&nbsp;" : WebUtil.printDate(data.RCBEG, ".") %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= data.RCEND.equals("0000-00-00") ? "&nbsp;" : WebUtil.printDate(data.RCEND, ".") %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.LNPRD.equals("000")  ? "" : WebUtil.printNumFormat(data.LNPRD) %>&nbsp;</td><!-- @2016연말정산 -->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.NAM01.equals("")  ? "" : WebUtil.printNumFormat(data.NAM01) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.FIXRT.equals("X")  ?  "○" : "&nbsp;"  %> </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.NODEF.equals("X")  ? "○" : "&nbsp;"  %> </td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.GUBUN.equals("9") ? "○" : "&nbsp;" %></td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
          </tr>
<%
        }
    }
%>
        </table>
        <!--주택자금공제 테이블 끝-->


      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 교육비</td><!-- @2014 연말정산 특별공제 교육비 명칭 변경 -->
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--특별공제 교육비 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="80" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">관계</td>
            <td class="td03" width="60" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">성명</td>
            <td class="td03" width="90" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주민등록번호</td>
            <td class="td03" width="60" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">학력</td>
            <td class="td03" width="" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" width="" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">교복<BR>구입비</td>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
			<td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">현장<BR>학습비</td>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">장애인<br>교육비</td>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
			<td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">학자금<BR>상환</td>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">회사<br>지원분</td>
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">국세청<br>자료</td>
          </tr>
<%
    for( int i = 0 ; i < edu_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)edu_vt.get(i);
        if(  !data.BETRG.equals("0.0") && !data.OMIT_FLAG.equals("X")  ) { //CSR ID:2013_9999 PDF 삭제 제외
%>
          <tr>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-left:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= data.STEXT.equals("")  ? "&nbsp;" :data.STEXT %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%=data.F_ENAME.equals("")  ? "&nbsp;" : data.F_ENAME %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= data.F_REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.F_REGNO) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%=data.FATXT.equals("")  ? "&nbsp;" : data.FATXT %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.BETRG)  %>&nbsp;</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.GUBUN.equals("9") ? "○" : "&nbsp;" %></td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.EXSTY.equals("X") ? "○" : "&nbsp;" %></td>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
			<td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.EXSTY.equals("F") ? "○" : "&nbsp;" %></td>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.ACT_CHECK.equals("X") ? "○" : "&nbsp;" %></td>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
			<td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.LOAN.equals("X") ? "○" : "&nbsp;" %></td>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.GUBUN.equals("1") ? "○" : "&nbsp;" %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.CHNTS.equals("X") ? "○" : "&nbsp;" %></td>
          </tr>
<%
        }
    }
%>
        </table>
        <!--특별공제 교육비 테이블 끝-->




      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
<%  if (pension_vt.size() >0 ) { %>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 연금/저축 공제</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="23%" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">구분</td>
            <td class="td03" width="23%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">유형</td>
            <td class="td03" width="20%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금융기관</td>
            <td class="td03" width="15%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">가입일</td><!-- @2015 연말정산 추가 -->
            <td class="td03" width="" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">증권보험/<br>계좌번호</td>
            <td class="td03" width="10%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" width="5%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td03" width="5%" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">종(전)<BR>근무지</td>
          </tr>

<%
    for( int i = 0 ; i < pension_vt.size() ; i++ ){
        D11TaxAdjustPensionData data = (D11TaxAdjustPensionData)pension_vt.get(i);
        if(  !data.OMIT_FLAG.equals("X")  ) { //CSR ID:2013_9999 PDF 삭제 제외

%>
          <tr>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-left:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left""><%= WebUtil.printOptionText((new D11TaxAdjustPensionCodeRFC()).getPension(targetYear,"1",""), data.SUBTY) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"">
                 <%
        Vector D11TaxAdjustPensionCodeData_vt  =     (new D11TaxAdjustPensionCodeRFC()).getPensionGubn(targetYear,"2",data.SUBTY);
        for( int j = 0 ; j < D11TaxAdjustPensionCodeData_vt.size() ; j++ ) {
            D11TaxAdjustPensionCodeData data1 = (D11TaxAdjustPensionCodeData)D11TaxAdjustPensionCodeData_vt.get(j);
            if (data.PNSTY.equals(data1.GOJE_CODE)) {
%>
            <%= data1.GOJE_TEXT%>
<%          }
        }
%>
            </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= WebUtil.printOptionText((new D11TaxAdjustFincoCodeRFC()).getPension(""), data.FINCO) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center">&nbsp;<%=data.RCBEG.equals("0000-00-00")  ? "":data.RCBEG%></td><!-- @2015 연말정산 추가 가입일-->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;<%=data.ACCNO.equals("")  ? "": data.ACCNO%></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.NAM01.equals("")  ? "" : WebUtil.printNumFormat(data.NAM01) %>&nbsp;</td>

<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.PDF_FLAG.equals("X")  ? "○" : "&nbsp;" %> </td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">
            <%= data.PREIN.equals("X")  ?  "○" : "&nbsp;" %> &nbsp;</td>
          </tr>

<%
	}
    }
%>
        </table>

        <!--연금/저축 테이블 끝-->
      </td>
    </tr>
<%  } %>
<%  if (tax_vt.size() >0 ) { %>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>

    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 신용카드 등 및 기타</td> <!-- @2014 연말정산 기타/세액공제 명칭 수정 -->
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--기타/세액공제 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" rowspan="2" width="240" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">구분</td>
            <td class="td03" rowspan="2" width="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">개인추가분</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" rowspan="2" width="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td03" colspan="2" width="324"  style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;">자동반영분</td>
          </tr>
          <tr>
            <td class="td03" width="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
            <td class="td03" width="244" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">내용</td>
          </tr>
<%
    for( int i = 0 ; i < tax_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)tax_vt.get(i);
        if(   !data.OMIT_FLAG.equals("X") ) { //CSR ID:2013_9999 PDF 삭제 제외

%>
          <tr>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-left:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;<%= data.GUBN_TEXT %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.ADD_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ADD_BETRG)  %>&nbsp;</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.ACT_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ACT_BETRG)  %>&nbsp;</td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.AUTO_BETRG.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.AUTO_BETRG) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;<%= data.AUTO_TEXT %></td>
          </tr>
<%
        }
    }
%>
        </table>
        <!--기타/세액공제 테이블 끝-->
      </td>
    </tr>

    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
<%  } %>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 부양가족공제자 명세</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--부양가족공제자 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="55" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">관계</td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">성명</td>
            <td class="td03" width="65" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">구분</td>
            <td class="td03" width="28" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기본<br>공제</td>
            <td class="td03" width="20" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">장애인</td>
            <!-- @2015 연말정산
            <td class="td03" width="27" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">자녀<br>양육비</td> -->
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">보험료</td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">의료비</td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">교육비</td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">신용<br>카드</td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">직불<br>카드등</td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">현금<br>영수증</td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부금</td>
          </tr>
<%
    for( int i = 0 ; i < family_vt.size() ; i++ ){
        D11TaxAdjustFamilyData data = (D11TaxAdjustFamilyData)family_vt.get(i);
%>
          <tr>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-left:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.FAMI_RLNM.equals("") ? "&nbsp;" : data.FAMI_RLNM %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.FAMI_NAME.equals("") ? "&nbsp;" : data.FAMI_NAME %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.E_GUBUN %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.FAMI_B001.equals("X") ? "○" : "&nbsp;" %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.FAMI_B002.equals("X") ? "○" : "&nbsp;" %></td>
            <!-- @2015 연말정산
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.FAMI_B003.equals("X") ? "○" : "&nbsp;" %></td> -->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.INSUR.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.INSUR) %>  </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.MEDIC.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.MEDIC) %>  </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.EDUCA.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.EDUCA) %>  </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.CREDIT.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.CREDIT) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.DEBIT.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.DEBIT) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.CASHR.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.CASHR) %>  </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.GIBU.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.GIBU) %>    </td>
          </tr>
<%
    }
%>
        </table>
        <!--부양가족공제자 테이블 끝-->
      </td>
    </tr>

<%  if (rent_vt.size() >0 ) { %>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 월세 공제</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">임대인성명</td><!--CSR ID:2013_9999 2013-->
            <td class="td03" width="85" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">등록번호</td><!--CSR ID:2013_9999 2013-->
 			<td class="td03" width="65" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주택유형</td><!-- @2014 연말정산 월세에 주택유형/면적 추가 -->
 			<td class="td03" width="45" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">면적</td><!-- @2014 연말정산 월세에 주택유형/면적 추가 -->
            <td class="td03" width="263" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주소지</td><!--CSR ID:2013_9999 2013-->
            <td class="td03" width="63" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">계약시작일</td>
            <td class="td03" width="63" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">계약종료일</td>
            <td class="td03" width="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
          </tr>

<%
    for( int i = 0 ; i < rent_vt.size() ; i++ ){
        D11TaxAdjustRentData data = (D11TaxAdjustRentData)rent_vt.get(i);
%>
          <tr>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-left:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= data.LDNAM %>&nbsp;</td><!--CSR ID:2013_9999 2013 임대인성명-->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.LDREG %></td><!--CSR ID:2013_9999 2013 등록번호-->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.HOSTX %></td><!-- @2014 연말정산 월세에 주택유형/면적 추가 -->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.FLRAR %></td><!-- @2014 연말정산 월세에 주택유형/면적 추가 -->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.ADDRE %></td><!--CSR ID:2013_9999 2013 주소지-->
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.RCBEG.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCBEG) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.RCEND.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCEND) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.NAM01.equals("")  ? "" : WebUtil.printNumFormat(data.NAM01) %></td>

          </tr>

<%
    }
%>
        </table>

        <!--연금/저축 테이블 끝-->
      </td>
    </tr>
<%  } %>

<%
//  전근무 데이터의 경우 올해 입사자만 해당되므로 HEADER도 보이지 않도록 한다.
    if( preWork_vt.size() > 0 ) {
%>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 전근무지</td>
    </tr>

    <tr>
      <td width="15">&nbsp;</td>
      <td height=100%>
        <!--전근무지 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="0" bordercolor="#999999">
        <tr>

<%

    int preWork_count = 3;
    Vector preWorkModify_vt = new Vector();
    D11TaxAdjustPreWorkData dataD11TaxAdjustPreWorkData = new D11TaxAdjustPreWorkData();

    for ( int j = 0 ; j < preWork_vt.size()  ; j++ ) {
        D11TaxAdjustPreWorkData data = (D11TaxAdjustPreWorkData)preWork_vt.get(j);
            preWorkModify_vt.addElement(data);
    }

    for ( int j = preWork_vt.size() ; j < preWork_count  ; j++ ) {
            dataD11TaxAdjustPreWorkData.BEGDA="";
            dataD11TaxAdjustPreWorkData.ENDDA="";
            dataD11TaxAdjustPreWorkData.PERNR="";
            dataD11TaxAdjustPreWorkData.SEQNR="";
            dataD11TaxAdjustPreWorkData.BIZNO="";
            dataD11TaxAdjustPreWorkData.COMNM="";
            dataD11TaxAdjustPreWorkData.TXPAS="";
            dataD11TaxAdjustPreWorkData.PABEG="";
            dataD11TaxAdjustPreWorkData.PAEND="";
            dataD11TaxAdjustPreWorkData.EXBEG="";
            dataD11TaxAdjustPreWorkData.EXEND="";
            dataD11TaxAdjustPreWorkData.LGA01="";
            dataD11TaxAdjustPreWorkData.BET01="";
            dataD11TaxAdjustPreWorkData.LGA02="";
            dataD11TaxAdjustPreWorkData.BET02="";
            dataD11TaxAdjustPreWorkData.LGA03="";
            dataD11TaxAdjustPreWorkData.BET03="";
            dataD11TaxAdjustPreWorkData.LGA04="";
            preWorkModify_vt.addElement(dataD11TaxAdjustPreWorkData);
    }


    String BET00[] = new String[45];
    String Inx = "";
    for( int i = 0 ; i < preWorkModify_vt.size() ; i++ ){
        D11TaxAdjustPreWorkData data = (D11TaxAdjustPreWorkData)preWorkModify_vt.get(i);

%>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#999999">

          <tr>
            <td class="td03" width="100" style="border-top:.5pt solid windowtext;<%= i==0 ? "border-left:.5pt solid windowtext;" : "" %>border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">사업자번호</td>
            <td class="td04" width="160" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.BIZNO.equals("") ? "&nbsp;" : DataUtil.addSeparate2(data.BIZNO) %>
            <%  if (!data.BIZNO.equals("")) { %>
            <img src="<%= WebUtil.ImageURL %><%= data.TXPAS.equals("X") ? "check.gif" : "uncheck.gif" %>">납세조합
            <%  }else{ %>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <img src="<%= WebUtil.ImageURL %>uncheck.gif">납세조합
            <% }%>
            </td>
          </tr>

          <tr>
            <td class="td03" style="border-bottom:.5pt solid windowtext;<%= i==0 ? "border-left:.5pt solid windowtext;" : "" %>border-right:.5pt solid windowtext">회사이름</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.COMNM.equals("") ? "&nbsp;" : data.COMNM  %>
            <!--<a href="javascript:fn_openSearch(<%=i%>)"><img src="<%= WebUtil.ImageURL %>btn_Taxserch.gif" border="0" align="absmiddle"></a>
            --></td>
          </tr>
          <tr>
            <td class="td03" style="border-bottom:.5pt solid windowtext;<%= i==0 ? "border-left:.5pt solid windowtext;" : "" %>border-right:.5pt solid windowtext">근무기간</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext" wrap><%= data.PABEG.equals("0000-00-00")||data.PABEG.equals("") ? "&nbsp;" : WebUtil.printDate(data.PABEG)+" - " %>
            <%= data.PAEND.equals("0000-00-00") ? "" : WebUtil.printDate(data.PAEND) %></td>
          </tr>
          <tr>
            <td class="td03" style="border-bottom:.5pt solid windowtext;<%= i==0 ? "border-left:.5pt solid windowtext;" : "" %>border-right:.5pt solid windowtext">감면기간</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext" wrap><%= data.EXBEG.equals("0000-00-00")||data.EXBEG.equals("") ? "&nbsp;" : WebUtil.printDate(data.EXBEG)+" - " %>
            <%= data.EXEND.equals("0000-00-00") ? "" : WebUtil.printDate(data.EXEND) %></td>
          </tr>
<%
         BET00[0]  = WebUtil.nvl(data.BET01,"");
         BET00[1]  = WebUtil.nvl(data.BET02,"");
         BET00[2]  = WebUtil.nvl(data.BET03,"");
         BET00[3]  = WebUtil.nvl(data.BET04,"");
         BET00[4]  = WebUtil.nvl(data.BET05,"");
         BET00[5]  = WebUtil.nvl(data.BET06,"");
         BET00[6]  = WebUtil.nvl(data.BET07,"");
         BET00[7]  = WebUtil.nvl(data.BET08,"");
         BET00[8]  = WebUtil.nvl(data.BET09,"");
         BET00[9]  = WebUtil.nvl(data.BET10,"");
         BET00[10] = WebUtil.nvl(data.BET11,"");
         BET00[11] = WebUtil.nvl(data.BET12,"");
         BET00[12] = WebUtil.nvl(data.BET13,"");
         BET00[13] = WebUtil.nvl(data.BET14,"");
         BET00[14] = WebUtil.nvl(data.BET15,"");
         BET00[15] = WebUtil.nvl(data.BET16,"");
         BET00[16] = WebUtil.nvl(data.BET17,"");
         BET00[17] = WebUtil.nvl(data.BET18,"");
         BET00[18] = WebUtil.nvl(data.BET19,"");
         BET00[19] = WebUtil.nvl(data.BET20,"");
         BET00[20] = WebUtil.nvl(data.BET21,"");
         BET00[21] = WebUtil.nvl(data.BET22,"");
         BET00[22] = WebUtil.nvl(data.BET23,"");
         BET00[23] = WebUtil.nvl(data.BET24,"");
         BET00[24] = WebUtil.nvl(data.BET25,"");
         BET00[25] = WebUtil.nvl(data.BET26,"");
         BET00[26] = WebUtil.nvl(data.BET27,"");
         BET00[27] = WebUtil.nvl(data.BET28,"");
         BET00[28] = WebUtil.nvl(data.BET29,"");
         BET00[29] = WebUtil.nvl(data.BET30,"");
         BET00[30] = WebUtil.nvl(data.BET31,"");
         BET00[31] = WebUtil.nvl(data.BET32,"");
         BET00[32] = WebUtil.nvl(data.BET33,"");
         BET00[33] = WebUtil.nvl(data.BET34,"");
         BET00[34] = WebUtil.nvl(data.BET35,"");
         BET00[35] = WebUtil.nvl(data.BET36,"");
         BET00[36] = WebUtil.nvl(data.BET37,"");
         BET00[37] = WebUtil.nvl(data.BET38,"");
         BET00[38] = WebUtil.nvl(data.BET39,"");
         BET00[39] = WebUtil.nvl(data.BET40,"");
         BET00[40] = WebUtil.nvl(data.BET41,"");
         BET00[41] = WebUtil.nvl(data.BET42,"");
         BET00[42] = WebUtil.nvl(data.BET43,"");
         BET00[43] = WebUtil.nvl(data.BET44,"");
         BET00[44] = WebUtil.nvl(data.BET45,"");


         for( int j = 1 ; j < preWorkHeadNm_vt.size() +1; j++ ){
             D11TaxAdjustPreWorkNmData dataNm = (D11TaxAdjustPreWorkNmData)preWorkHeadNm_vt.get(j-1);
             Inx = Integer.toString(j);
             Inx = DataUtil.fixEndZero(Inx , 2);
%>
          <tr>
            <td class="td03" style="border-bottom:.5pt solid windowtext;<%= i==0 ? "border-left:.5pt solid windowtext;" : "" %>border-right:.5pt solid windowtext"><%= dataNm.LGTXT.equals("") ? "&nbsp;" : dataNm.LGTXT   %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= BET00[j-1].equals("0.0") || BET00[j-1].equals("") ? "&nbsp;" : WebUtil.printNumFormat(BET00[j-1]) %>&nbsp;&nbsp;</td>
           <input type="hidden" name="LGA<%=Inx%><%=i%>" value="<%= dataNm.LGART %>">
          </tr>
<%       } %>

      </table>
    </td>
<%
    }
%>

        </tr>

        </table>
        <!--전근무지 테이블 끝-->
      </td>
    </tr>
<%
    }
%>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td class="font01" width="200">* 전근무지 원천징수 영수증 첨부</td>
            <td class="font01">
              <input type="checkbox" name="checkbox" value="checkbox">
              Y
              <input type="checkbox" name="checkbox2" value="checkbox">
              N </td>
            <td class="font01" width="150">* 해외근무 대상자 여부</td>
            <td class="font01">
              <input type="checkbox" name="checkbox3" value="checkbox">
              Y
              <input type="checkbox" name="checkbox22" value="checkbox">
              N </td>
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
            <td align="right" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'><%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;일 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 날인 또는 서명)&nbsp;&nbsp;&nbsp;&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>


    <!-- @@@@@@@ 신용카드 출력 추가 @@@@@@@ -->
<%if(card_vt.size() >0){ %>
        <tr style="page-break-before: always;">
      <td width="15">&nbsp; </td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="font01" align="center"><font size="5">신용카드지급명세서</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size ="3"><%=print_seq %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PDF 외 : <%=pdfOnlyYN %></font></td><!-- //@2014 연말정산 소득공제신고서 seq 추가 -->
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
            <td class="td03" width="74"  style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">성 명</td>
            <td class="td04" width="240" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;' colspan="3">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;</td>
            <td class="td03" width="90"  style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>주민등록번호</td>
            <td class="td04" width="240" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;'>&nbsp;&nbsp;<%= DataUtil.addSeparate(((WebUserData)session.getAttribute("user")).e_regno) %></td>
          </tr>
          <tr>
            <td class="td03" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주 소</td>
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
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> <%= targetYear %>  년도 신용카드 지급내역</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--특별공제신용카드 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" width="20" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">No.</td>
            <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">관계</td>
            <td class="td03" width="60" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">성명</td>
            <td class="td03" width="110" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">주민번호</td>
            <td class="td03" width="142" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">구분</td>
            <td class="td03" width="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">공제대상액</td>
            <td class="td03" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">전통<br>시장</td>
            <td class="td03" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">대중<br>교통</td><!-- CSR ID:2013_9999 대중교통추가-->
            <!-- [CSR ID:3569665] @2017연말정산 사용기간 삭제로 주석처리 -->
            <!-- <td class="td03" width="50" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">사용<br>기간</td>@2014 연말정산 사용기간추가 -->
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">PDF</td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td03" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">사업관련<br>비용</td>

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

        	if (data.TRDMK.equals("X") ) { //전통시장

        		if (data.E_GUBUN.equals("2") ) { //현금영수증
        		    total_money_trdmk = total_money_trdmk +( Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경
        		} else if (data.E_GUBUN.equals("1") ) {  //신용카드
        		    total_card_trdmk = total_card_trdmk + (Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경
        		} else if (data.E_GUBUN.equals("6") ) {  //직불/선불카드
        		    total_check_trdmk = total_check_trdmk + (Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경

        		}
        	}else if (data.CCTRA.equals("X") ) { //CSR ID:2013_9999 대중교통추가

        		if (data.E_GUBUN.equals("2") ) { //현금영수증
        		    total_money_cctra = total_money_cctra +( Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경
        		} else if (data.E_GUBUN.equals("1") ) {  //신용카드
        		    total_card_cctra = total_card_cctra + (Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경

        		} else if (data.E_GUBUN.equals("6") ) {  //직불/선불카드
        		    total_check_cctra = total_check_cctra + (Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경

        		}
        	}else{
        		if (data.E_GUBUN.equals("2") ) { //현금영수증
        		    total_money = total_money +( Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경
        		} else if (data.E_GUBUN.equals("1") ) {  //신용카드
        		    total_card = total_card + (Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경
        		} else if (data.E_GUBUN.equals("6") ) {  //직불/선불카드
        		    total_check = total_check + (Double.parseDouble(data.BETRG));//-Double.parseDouble(data.BETRG_B));//@2014 연말정산 사업관련비용 -였는데 변경
        		}


        	}

      // }

%>
        	  <tr>
        	    <td class="td04" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= no %></td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= WebUtil.printOptionText((new A12FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.F_ENAME.equals("") ? "&nbsp;" : data.F_ENAME%></td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.F_REGNO.equals("") ? "" : DataUtil.addSeparate(data.F_REGNO) %></td>
        	    <td class="td04" nowrap="nowrap" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.GU_NAME %></td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.BETRG.equals("") ? "" : WebUtil.printNumFormat(data.BETRG) %>&nbsp;</td>
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.TRDMK.equals("X") ? "check.gif" : "uncheck.gif" %>"></td><!--C20121213_34842 2012  전통시장여부 -->
        	    <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.CCTRA.equals("X") ? "check.gif" : "uncheck.gif" %>"></td><!-- CSR ID:2013_9999 대중교통추가-->
        	    <!-- [CSR ID:3569665] @2017연말정산 사용기간 삭제로 주석처리 -->
        	    <%--
        	    <td class="td04" nowrap="nowrap" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.EXPRD.equals("1") ? "15년" : data.EXPRD.equals("4") ? "14년" : data.EXPRD.equals("3") ? "16년" :"추가분" %></td><!-- @2014 연말정산 사용기간추가 @2015 연말정산 년도 수정-->
 				--%>
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
            <!-- [CSR ID:3569665] @2017연말정산 사용기간 삭제로 주석처리 -->
            <!-- <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td> --><!-- @2014 연말정산 사용기간추가-->
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
            <!-- <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right">&nbsp;</td>@2014 연말정산 사용기간추가 -->
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
          <<%=targetYear %> 년도 사용액>
          </td>
          </tr>
          <tr>
          <td class="td03_s" width="100" align=right>신 용 카 드 (일반)</td>
          <td class="td04" width="100" style="text-align:right"><%= WebUtil.printNumFormat(total_card) %>&nbsp;</td>
          <td class="td03_s" width="122" align=right>신 용 카 드 (전통시장)</td>
          <td class="td04" width="100" style="text-align:right"><%= WebUtil.printNumFormat(total_card_trdmk) %>&nbsp;</td>
          <td class="td03_s" width="122" align=right>신 용 카 드(대중교통)</td>
          <td class="td04" width="100" style="text-align:right"><%= WebUtil.printNumFormat(total_card_cctra) %>&nbsp;</td>
          </tr>
          <tr>
          <td class="td03_s" align=right>현금영수증(일반)</td>
          <td class="td04" style="text-align:right"><%= WebUtil.printNumFormat(total_money) %>&nbsp;</td>
          <td class="td03_s" align=right>현금영수증(전통시장)</td>
          <td class="td04" style="text-align:right"><%= WebUtil.printNumFormat(total_money_trdmk) %>&nbsp;</td>
          <td class="td03_s" align=right>현금영수증(대중교통)</td>
          <td class="td04" style="text-align:right"><%= WebUtil.printNumFormat(total_money_cctra) %>&nbsp;</td>
          </td>
          </tr>
          <tr>
          <td class="td03_s"  align=right>직 불 체 크 (일반)</td>
          <td class="td04"  style="text-align:right"><%= WebUtil.printNumFormat(total_check) %>&nbsp;</td>
          <td class="td03_s"  align=right>직 불 체 크 (전통시장)</td>
          <td class="td04"  style="text-align:right"><%= WebUtil.printNumFormat(total_check_trdmk) %>&nbsp;</td>
          <td class="td03_s"  align=right>직 불 체 크 (대중교통)</td>
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
            <%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;일&nbsp;&nbsp;
            </td>
          </tr>
          <tr>
            <td align="right" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            제출자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 서명 또는 인 )&nbsp;&nbsp;</td>
            </td>
          </tr>
          <tr>
            <td align="center" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>귀하</td>
          </tr>
          <tr>
            <td width="15">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="left" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;구비서류 : 신용카드지급영수증&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매
            </td>
          </tr>

        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>

 <%}//신용카드 끝
if(medi_vt2.size() >0){%>
  <!-- @@@@@@의료비 지원내역 추가 -->
      <tr style="page-break-before: always;">
      <td width="15">&nbsp; </td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="font01" align="center"><font size="5">의료비지급명세서</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size ="3"><%=print_seq %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PDF 외 : <%=pdfOnlyYN %></font></td><!-- //@2014 연말정산 소득공제신고서 seq 추가 -->
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
            <td class="td03" width="74"  style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">성 명</td>
            <td class="td04" width="240" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;' colspan="3">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;</td>
            <td class="td03" width="90"  style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>주민등록번호</td>
            <td class="td04" width="240" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;'>&nbsp;&nbsp;<%= DataUtil.addSeparate(((WebUserData)session.getAttribute("user")).e_regno) %></td>
          </tr>
          <tr>
            <td class="td03" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주 소</td>
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
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> <%= targetYear %>  년도 의료비 지급내역</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--특별공제의료비 테이블 시작-->
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" rowspan="2" width="20" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">No.</td>
            <td class="td03" rowspan="2" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">구분</td>
            <td class="td03" rowspan="2" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">건수</td>
            <td class="td03" rowspan="2" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">지급금액</td>

            <td class="td03" rowspan="2" width="110" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">의료비<br>내용</td>
            <td class="td03" rowspan="2" width="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">지급처<br>(상호)</td>
            <td class="td03" rowspan="2" width="100" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">의료증빙유형</td>
            <td class="td03" rowspan="2" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">안경<br>콘택트</td>
            <td class="td03" rowspan="2" width="30" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">난임<br>시술비</td><!-- @2015연말정산 추가 -->
            <td class="td03" colspan="3"  style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext">대상자</td>
<%
   if (pdfYn.equals("Y")){
%>
            <td class="td03" rowspan="2" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td>
<%
   }
%>
          </tr>
          <tr>
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">관계</td>
            <td class="td03" width="50"style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">성명</td>
            <td class="td03" width="45"style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">장애/<BR>경로</td>
          </tr>
<%
    double totalMedic = 0.0;

    double BETRG_C = 0.0;
    int  C_CNT = 0;
    double total_1 = 0.0;
    double total_2 = 0.0;
    double total_C = 0.0;
    double total_3 = 0.0;
    int  total_cnt = 0;
    int  total_3cnt = 0;
    int  noMedic =0;
    for( int i = 0 ; i < medi_vt2.size() ; i++ ){
        D11TaxAdjustMedicalData data = (D11TaxAdjustMedicalData)medi_vt2.get(i);
        if (!data.OMIT_FLAG.equals("X")){ //연말정산삭제여부
        totalMedic = totalMedic + Double.parseDouble(data.BETRG);
        BETRG_C = Double.parseDouble(data.CC_BETRG)+Double.parseDouble(data.CR_BETRG);
        total_1 = total_1 + Double.parseDouble(data.CC_BETRG);
        total_2 = total_2 + Double.parseDouble(data.CR_BETRG);
        total_C = total_1 + total_2;
        total_3 = total_3 + Double.parseDouble(data.CA_BETRG);
        C_CNT   = Integer.parseInt(data.CC_CNT)+Integer.parseInt(data.CR_CNT);
        total_cnt   = total_cnt + Integer.parseInt(data.CC_CNT)+Integer.parseInt(data.CR_CNT);
        total_3cnt   = total_3cnt+ Integer.parseInt(data.CA_CNT);
        noMedic++;
%>
          <tr>
            <td class="td04" nowrap style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= noMedic %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.GUBUN.equals("1") ? "회사<br>지원" : "추가<br>입력" %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= Integer.parseInt(data.CA_CNT) %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.CA_BETRG.equals("") ? "" : WebUtil.printNumFormat(data.CA_BETRG) %>&nbsp;</td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.CONTENT.equals("") ? "&nbsp;" : data.CONTENT %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.BIZ_NAME.equals("") ? "&nbsp;" : data.BIZ_NAME %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%= data.METYP_NAME.equals("") ? "&nbsp;" : data.METYP_NAME %></td><!--CSR ID:1361257-->
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.GLASS_CHK.equals("X") ? "check.gif" : "uncheck.gif" %>"></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><img src="<%= WebUtil.ImageURL %><%= data.DIFPG_CHK.equals("X") ? "check.gif" : "uncheck.gif" %>"></td><!-- @2015 연말정산 난임 시술비 추가 -->
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= WebUtil.printOptionText((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%=  data.F_ENAME  %></td>
            <td class="td05" nowrap style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">
<%
        if( data.OLDD.equals("X") && data.OBST.equals("X") ) {
%>
            장애,경로
<%
        } else if ( data.OLDD.equals("X") ) {
%>
            경로
<%
        } else if ( data.OBST.equals("X") ) {
%>
            장애
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
    if ( noMedic < 20) {

        int cnt = 20 - noMedic;
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
            <td class="td03" colspan="2" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">계</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_3cnt) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_3) %>&nbsp;</td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;</td>
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
            &nbsp;&nbsp;&nbsp;소득세법 제 52조 및 소득세법 시행령 제113조 제1항의 규정에 의하여 의료비를 공제 받고자</td>
          </tr>
          <tr>
            <td style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;&nbsp;의료비지급명세서를 제출합니다.</td>
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
            <%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;일&nbsp;&nbsp;
            </td>
          </tr>
          <tr>
            <td align="right" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            제출자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 서명 또는 인 )&nbsp;&nbsp;</td>
            </td>
          </tr>
          <tr>
            <td align="center" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>귀하</td>
          </tr>
          <tr>
            <td width="15">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="left" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;구비서류 : 의료비지급영수증&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매
            </td>
          </tr>

        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
<%}//의료비 완료
 if(gibu_vt.size() >0){%>
<!-- @@@@@@@@@기부금 내역 추가@@@@@@@@ -->
<tr style="page-break-before: always;">
      <td width="15">&nbsp; </td>
      <td>
        <table width="<%= Prev_YN.equals("Y") ? "644" :"644"  %>" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="font01" align="center"><font size="5">기부금명세서</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size ="3"><%=print_seq %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PDF 외 : <%=pdfOnlyYN %></font></td><!-- //@2014 연말정산 소득공제신고서 seq 추가 -->
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
            <td class="td03" width="74"  style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">성 명</td>
            <td class="font02" width="240" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;' colspan="3">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;</td>
            <td class="td03" width="90"  style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;'>주민등록번호</td>
            <td class="font02" width="260" style='border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left;'>&nbsp;&nbsp;<%= DataUtil.addSeparate(((WebUserData)session.getAttribute("user")).e_regno) %></td>
          </tr>
          <tr>
            <td class="td03" style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주 소</td>
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
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> <%= targetYear %>  년도 기부금 지급내역</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--특별공제기부금 테이블 시작-->
<%  if (Prev_YN.equals("Y")  ) { %>
        <table width="644"" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" nowrap  width="18"  rowspan=2 style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">No.</td>
            <td class="td03" nowrap  width="60"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부금<br>유형</td>
            <td class="td03" nowrap  width="18"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">코드</td>
            <td class="td03" nowrap  width="45"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부<br>년월</td>
            <td class="td03" width="10"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td><!-- CSR ID:2013_9999 PDF -->
            <td class="td03" width="83"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부금<br>내용</td>
            <td class="td03" width="145" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부처</td>
            <td class="td03" nowrap width="120" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부자</td>
            <td class="td03" nowrap  width="70"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
            <td class="td03" nowrap width="85" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;border-right:.5pt solid windowtext;">이월공제</td>
          </tr>
          <tr>
            <td class="td03" nowrap width1="80" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">상호<br>(법인명)</td>
            <td class="td03" nowrap width1="65" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">사업자번호</td>
            <td class="td03" nowrap width1="55" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">성명</td>
            <td class="td03" nowrap width1="65" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주민번호</td>
            <td class="td03" nowrap width="25" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">년도</td>
            <td class="td03" nowrap width="60" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">전년까지<br>공제액</td>
          </tr>
<% }else{ %>
        <table width="644" border="0" cellspacing="0" cellpadding="2" bordercolor="#999999">
          <tr>
            <td class="td03" nowrap  width="20"  rowspan=2 style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">No.</td>
            <td class="td03" nowrap  width="70"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부금유형</td>
            <td class="td03" nowrap  width="20"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">코드</td>
            <td class="td03" nowrap  width="50"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부<br>년월</td>
            <td class="td03" width="30"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td><!-- CSR ID:2013_9999 PDF -->
            <td class="td03" width="134"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부금<br>내용</td>
            <td class="td03" width="160" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부처</td>
            <td class="td03" nowrap width="130" colspan=2 style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;border-right:.5pt solid windowtext;">기부자</td>
            <td class="td03" nowrap  width="70"  rowspan=2 style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
          </tr>
          <tr>
            <td class="td03" nowrap width="90" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">상호<br>(법인명)</td>
            <td class="td03" nowrap width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">사업자번호</td>
            <td class="td03" nowrap width="60" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">성명</td>
            <td class="td03" nowrap width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">주민번호</td>

          </tr>
<% } %>
<%
    double totalGibu    = 0.0;
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
    int  noGibu =0;
    for( int i = 0 ; i < gibu_vt.size() ; i++ ){
        D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibu_vt.get(i);

        if (!data.OMIT_FLAG.equals("X")){ //연말정산삭제여부
        noGibu++;
        totalGibu = totalGibu + Double.parseDouble(data.DONA_AMNT);
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
            <td class="<%= Prev_YN.equals("Y") ? "font021" :"font02" %>" nowrap style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;"><%= noGibu %></td>
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
    if ( noGibu < 12) {

        int cnt = 12 - noGibu;
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
            <td class="font02" rowspan=5 style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">소계</td>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">가.「소득세법」제34조 제2항의 기부금(법정기부금,코드10)&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_10) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>
            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_10_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">나.「조세특례제한법」제76조의 기부금(정치자금,코드20)&nbsp;</td>
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
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">다.「소득세법」제34조 제1항의 기부금(지정기부금,코드40)&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_40) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>

            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_40_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ㄱ.「소득세법」제34조 제1항의 기부금 중 종교단체 기부금(종교단체 기부금부금,코드41)&nbsp;</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_41) %>&nbsp;</td>
            <% if ( Prev_YN.equals("Y") ){ %>

            <td class="font02" colspan=2 style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(total_41_prev) %>&nbsp;</td>
	    <% } %>
          </tr>
          <tr>
            <td class="font02" colspan=<%=PCol%> style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left">라.「조세특례제한법」제88조의 4의 우리사주조합기부금(우리사주기부금,코드42)&nbsp;</td>
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
            <td class="td03" colspan=<%=PCol+1%> style="border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">계</td>
            <td class="font02" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= WebUtil.printNumFormat(totalGibu) %>&nbsp;</td>
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
            &nbsp;&nbsp;&nbsp;소득세법 제 52조 및 소득세법 시행령 제113조 제1항의 규정에 의하여 기부금을 공제 받고자</td>
          </tr>
          <tr>
            <td style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;&nbsp;기부금명세서를 제출합니다.</td>
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
            <%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;일&nbsp;&nbsp;
            </td>
          </tr>
          <tr>
            <td align="right" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            제출자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 서명 또는 인 )&nbsp;&nbsp;</td>
            </td>
          </tr>
          <tr>
            <td align="center" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>귀하</td>
          </tr>
          <tr>
            <td width="15">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="left" style='font-family: "굴림", "굴림체"; font-size: 9pt; color: #000000;'>
            &nbsp;&nbsp;구비서류 : 기부금영수증&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매
            </td>
          </tr>

        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
<%}//기부금 완료 %>
  </table>
<%@ include file="/web/common/commonEnd.jsp" %>
