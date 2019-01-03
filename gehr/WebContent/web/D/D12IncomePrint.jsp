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
/*				미사용 소스		 	        */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>


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

    //@v1.1기부금공제 

    WebUserData  user = (WebUserData)session.getAttribute("user");

    D11TaxAdjustGibuRFC   rfc   = new D11TaxAdjustGibuRFC();
    Vector gibu_vt = new Vector();
    gibu_vt = rfc.getGibu( user.empNo, targetYear );  

    D11TaxAdjustHouseHoleCheckRFC   rfcHC   = new D11TaxAdjustHouseHoleCheckRFC();
    D11TaxAdjustPersonCheckRFC      rfcPC   = new D11TaxAdjustPersonCheckRFC();
    String begda = targetYear + "0101";
    String endda = targetYear + "1231";
    String E_HOLD =  rfcHC.getChk(  user.empNo, targetYear,begda,endda,""); //세대주체크여부
    String E_CHG =  rfcPC.getChk(  user.empNo, targetYear,begda,endda,""); //인적공제변동여부


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
  .td03 {  font-size: 8pt;background-color: #F0EEDF; text-align: center; color: #585858; padding-top: 3px; height:20px;}

  .td04 {font-size: 8pt;
	background-color: #FFFFFF;
	text-align: center;
	padding-top: 3px;
	height:20px;
	color: #585858;
	}
  .td05 {  font-size: 7pt;background-color: #F0EEDF; text-align: center; color: #585858; padding-top: 3px; height:20px;}
</style>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <table width="644" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="font01" align="center"><font size="5"><%= targetYear %> 근로소득자 소득공제 신고서</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size ="3"><%=print_seq %></font></td><!-- //@2014 연말정산 소득공제신고서 seq 추가 -->
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
            
            <input type="checkbox" name="checkbox3" value="P_CHG"  <%= E_CHG.equals("X")  ? "checked" : "" %> disabled>   인적공제 변동여부
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
            <td class="td03" colspan="7" style="border-top:.5pt solid windowtext;border-right:.5pt solid windowtext;">추가공제</td>
          </tr>
          <tr>
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">경로우대</td>
            <td class="td03" width="70" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">장애자(코드)</td><!--CSR ID: 2013_9999 -->
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">부녀자</td>
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">한부모<br>가족</td><!--CSR ID: 2013_9999 -->
            <!-- @2014 연말정산 자녀양육비/출산입양 삭제 
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">자녀<BR>양육비</td>
            <td class="td03" width="53" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">출산·<BR>입양</td>  -->
            <td class="td03" width="51" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">위탁<BR>아동</td>
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
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 보험금/의료비/기부금/주택자금상환</td> <!-- @2014 연말정산 특별공제 명칭 변경 -->
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
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">장애인<br>교육비</td>
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
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.ACT_CHECK.equals("X") ? "○" : "&nbsp;" %></td>
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
            <td class="td03" width="90" style="border-top:.5pt solid windowtext;border-left:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">구분</td>
            <td class="td03" width="100" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">유형</td>
            <td class="td03" width="194" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금융기관</td>
            <td class="td03" width="90" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">증권보험/<br>계좌번호</td>
            <td class="td03" width="85" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">금액</td>
<%
   if (pdfYn.equals("Y")){
%>           
            <td class="td03" width="40" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">PDF</td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%>
            <td class="td03" width="45" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">종(전)<BR>근무지</td>
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
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:left"><%=data.ACCNO.equals("")  ? "&nbsp;":data.ACCNO%></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.NAM01.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.NAM01) %></td>

<%
   if (pdfYn.equals("Y")){
%>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:center"><%= data.PDF_FLAG.equals("X") ? "○" : "&nbsp;" %></td><!-- CSR ID:2013_9999 PDF-->
<%
   }
%> 
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext">
            <input type="checkbox" name="PREIN_<%=i%>" value="<%=data.PREIN%>" <%= data.PREIN.equals("X")  ? "checked" : "" %> disabled>
            &nbsp;</td> 
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
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 신용카드 등 및 기타/세액공제</td> <!-- @2014 연말정산 기타/세액공제 명칭 수정 -->
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
            <td class="td03" width="27" style="border-top:.5pt solid windowtext;border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;">자녀<br>양육비</td>
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
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext"><%= data.FAMI_B003.equals("X") ? "○" : "&nbsp;" %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right"><%= data.INSUR.equals("")  ? "" : WebUtil.printNumFormat(data.INSUR) %>  </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.MEDIC.equals("")  ? "" : WebUtil.printNumFormat(data.MEDIC) %>  </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.EDUCA.equals("")  ? "" : WebUtil.printNumFormat(data.EDUCA) %>  </td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.CREDIT.equals("")  ? "" : WebUtil.printNumFormat(data.CREDIT) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.DEBIT.equals("")  ? "" : WebUtil.printNumFormat(data.DEBIT) %></td>
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.CASHR.equals("")  ? "" : WebUtil.printNumFormat(data.CASHR) %>  </td>            
            <td class="td04" style="border-bottom:.5pt solid windowtext;border-right:.5pt solid windowtext;text-align:right""><%= data.GIBU.equals("")  ? "" : WebUtil.printNumFormat(data.GIBU) %>    </td>            
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
  </table>
<%@ include file="/web/common/commonEnd.jsp" %>
