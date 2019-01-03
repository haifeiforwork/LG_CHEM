<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustButton.jsp                                      */
/*   Description  : 연말정산공제신청 입력 header include                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005.11.17 lsa                                              */
/*   Update       : CSR ID:2013_9999 장애인코드 등록안한경우 Check              */
/*                      2014-12-03 @2014 연말정산                                                        */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.rfc.*" %>
<%
    
    //소득공제신고서발행tab을 위함
    D11TaxAdjustMedicalRFC   rfc   = new D11TaxAdjustMedicalRFC();
    Vector print_medi_vt = new Vector();
    Vector medical_vt = new Vector();
    medical_vt = rfc.getMedical( user.empNo, targetYear );

    for( int i = 0 ; i < medical_vt.size() ; i++ ) {
        D11TaxAdjustMedicalData dataMd = (D11TaxAdjustMedicalData)medical_vt.get(i);

        if (!dataMd.OMIT_FLAG.equals("X")){ //연말정산삭제여부        
        print_medi_vt.addElement(dataMd);
        }
    }

    //기부금공제신고서발행tab을 위함
    D11TaxAdjustGibuRFC   rfcG   = new D11TaxAdjustGibuRFC();
    Vector print_gibu_vt = new Vector();
    print_gibu_vt = rfcG.getGibu( user.empNo, targetYear );  
  
    //신용카드 소득공제신고서발행tab을 위함
    D11TaxAdjustCardRFC   rfcC   = new D11TaxAdjustCardRFC();
    Vector print_card_vt = new Vector();
    print_card_vt = rfcC.getCard( user.empNo, targetYear,"1" );
    
    int simu_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.SIMU_FROM,"-"));
    int simu_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.SIMU_TOXX,"-"));
     
    D11TaxAdjustHouseHoleCheckRFC   rfcHC   = new D11TaxAdjustHouseHoleCheckRFC();
    D11TaxAdjustPersonCheckRFC      rfcPC   = new D11TaxAdjustPersonCheckRFC();
    String begda = targetYear + "0101";
    String endda = targetYear + "1231";
    String E_HOLD =  rfcHC.getChk(  user.empNo, targetYear,begda,endda,""); //세대주체크여부
    String E_CHG =  rfcPC.getChk(  user.empNo, targetYear,begda,endda,""); //인적공제변동여부
	
    //********************* 2013.07.01 추가 *********************//
    String pdfYn = (String)session.getAttribute("pdfYn");
	//********************* 2013.07.01 추가 *********************//
    // 2002.12.04. 연말정산 확정여부 조회
    D11TaxAdjustYearCheckRFC rfc_c = new D11TaxAdjustYearCheckRFC();
    String c_flag = rfc_c.getO_FLAG( user.empNo, targetYear );
    
    String conFrimYn = "N";
    Vector retYN            = new Vector();
    retYN = ( new D11TaxAdjustScreenControlRFC() ).getFLAG( user.empNo ,targetYear,DataUtil.getCurrentDate() );   
    conFrimYn = (String)retYN.get(1); //회사별로 확정프로세스 사용여부가 옴 
                
    //CSR ID:2013_9999 장애인코드 등록안한경우 Check
    D11TaxAdjustPersonRFC    rfcPerson   = new D11TaxAdjustPersonRFC();   
    String  msg="";            
    Vector personVt = rfcPerson.getPerson( user.empNo, targetYear );
    for( int i = 0 ; i < personVt.size() ; i++ ){
        D11TaxAdjustPersonData dataPerson = (D11TaxAdjustPersonData)personVt.get(i);
        if (dataPerson.HNDEE.equals("X") && dataPerson.HNDCD.equals("")) {
            msg =dataPerson.ENAME+"에 대한 장애인 코드를 등록하세요.";
        }
    }
    
    //@2014 연말정산 부서구분에 따른 numbering 추가(소득공제신고서 출력용) , only pdf 만 사용하는지에 대한 여부 체크
    DeptCodeNumberingRFC rfc_n = new DeptCodeNumberingRFC();
    PdfOnlyYnCheckRFC rfc_only_pdf_yn = new PdfOnlyYnCheckRFC();
%>
<SCRIPT LANGUAGE="JavaScript">
<!--

// 연말정산 신청안내
function do_TaxGuide() {
//    if( chk_change() ) {
//        do_build();
//    } else {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxFirstSV?targetYear=<%= targetYear %>";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
//    }
}

// 인적공제
function do_Tax01() {
	var msg ="※ 연간 소득금액의 합계액이 100만원 이하\n";
	msg += "① 해당소득 : 양도소득/근로소득/퇴직소득/사업소득/연금소득/이자배당소득/기타소득\n";
	//msg += "② 근로소득이자 : 총급여의 합계액 500만원\n";
	msg += "② 근로소득이자 : 총급여의 합계액 3,333,333원\n";//@2014 연말정산
	msg += "③ 이자·배당소득이 2,000만원\n";
	msg += "☞ ’<%=targetYear%>년의 연간 소득유무 여부를 반드시 확인하여 주시기 바랍니다.";
	alert(msg);
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPersonSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}

// 주택자금상환/4대보험
function do_Tax02() {

    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustSpecialSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}

// 특별공제 교육비(미사용)
function do_Tax03_old() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEduSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}
// 교육비(수정)
function do_Tax03() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEducationSV?jobid=";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}
// 기타세액공제
function do_Tax04() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustTaxSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}

// 의료비
function do_Tax05() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}
// @v1.1 기부금
function do_Tax06() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}

// 전근무지
function do_Tax08() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPreWorkSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}

// 소득공제신고서
function do_TaxPrint() {
	if("<%=c_flag%>"!="X" && "<%=conFrimYn%>"=="Y"){
		alert("연말정산확정을 하셔야 소득공제신고서를 출력하실 수 있습니다.\n연말정산신청내역을 확인하신 후 [연말정산확정] 버튼을 클릭하셔서 연말정산내역을 확정해주세요.");
		//return;//@2014 연말정산 주석 삭제필요!!!!!!
	}
<%    String deptNum = rfc_n.getDeptCodeNumber(user.empNo, targetYear); 	
		session.setAttribute("PNT_SEQ", deptNum);//@2014 연말정산 소득공제신고서에 seq 붙이기 위함. 
		String pdfOnlyYN = rfc_only_pdf_yn.getOnlyPdfYN(user.empNo, targetYear);;
		session.setAttribute("PDF_ONLY_YN", pdfOnlyYN);//@2014 연말정산 소득공제신고서에 pdf만 사용한건지 여부 표시
%>
    if( do_Check(1) ) {
        window.open("<%= WebUtil.ServletURL %>hris.D.D12IncomePrintSV", 'essPrintWindow', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650');
        window.open("<%= WebUtil.ServletURL %>hris.D.D12IncomePrintSV2", 'essPrintWindow', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650');
       /*if (  < %= print_medi_vt.size()%> > 0 ) {
            window.open("< %= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV?jobid=first_print", 'essPrintWindow2', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650');
        } 
       if (  < %= print_gibu_vt.size()%> > 0 ) {
            window.open("< %= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV?jobid=first_print", 'essPrintWindow3', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650');
        }
        if (  < %= print_card_vt.size()%> > 0 ) {
            window.open("< %= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV?jobid=first_print&tab_gubun=1", 'essPrintWindow4', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650');
        }  */  
    }
}

// @v1.1신청현황조회
function do_Tax07() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustFamilySV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}
// @v1.2신용카드 
function do_Tax09() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV?tab_gubun=1";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}
// @v1.2보험료
function do_Tax10() {
    //if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV?tab_gubun=2";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}
// 연말정산 내역조회
function do_Detail() {
    //if( do_Check(2) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D14TaxAdjustDetailSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}
// 월세공제
function do_Tax12() {
    //if( do_Check(1) ) {        
     
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustRentSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}
// 연금저축공제
function do_Tax11() {
    //if( do_Check(1) ) {
    
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPensionSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    //}
}

// 연말정산입력방법
function do_TaxInfo() {

    document.location.href  = "<%= WebUtil.JspPath %>D/D11TaxAdjust/screen/TaxInfoGuide.ppt";
    //small_window=window.open("<%= WebUtil.JspPath %>D/D11TaxAdjust/D11TaxAdjustInfo.html","TaxInfo", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes, resizable=no,width=800,height=600,left=100,top=100");
    //small_window=window.open("<%= WebUtil.JspPath %>D/D11TaxAdjust/screen/TaxInfoGuide.ppt","TaxInfo", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes, resizable=no,left=100,top=100");
    //small_window.focus();
}

// 연말정산 입력(1), 연말정산 내역조회(2)가 가능한지 check
function do_Check(gubun) {
    if( gubun == "1" ) {
        if( <%= simu_from %> <= 0 && <%= simu_toxx %> >= 0) {
            return true;
        } else {
            alert("연말정산 입력기간이 아닙니다.");
            return false;
        }
    } else if( gubun == "2" ) {
        if( <%= disp_from %> <= 0 && <%= disp_toxx %> >= 0 ) {
            return true;
        } else {
            alert("연말정산 내역조회 기간이 아닙니다.");
            return false;
        }
    }
}

//********************* 2013.07.01 추가 *********************//
//PDF 업로드 호출
function do_PdfUp(){
	//document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D99PdfUpload.D99PdfUploadSV";
    document.form1.action = "<%= WebUtil.JspPath %>upload/D11TaxAdjust/upload.jsp";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
//********************* 2013.07.01 추가 *********************//

//연말정산 확정
function do_confirm(){
	
	//CSR ID:2013_9999
	if (  "<%=msg%>" !=""   ){ //인적공제 tab이 아니면서 장애코드가입력되지 않은경우
	    alert("<%=msg%>"); 
   	    if ("<%=Gubn%>" != "Tax01") {  
	    	    do_Tax01();
	    }
	    
	}else{
	
		if(!confirm("확정하게 되면 연말정산내역 입력과 수정이 불가능합니다.\n연말정산 내역을 확정하시겠습니까?")) return;
		document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustFamilySV?jobid=confirm";
		document.form1.method      = "post";
		document.form1.target      = "menuContentIframe";
		document.form1.submit();                             
	}
}



//-->
</SCRIPT>
<%
   if (!Gubn.equals("Detail")) {  
%>     

    <tr>
      <td width="780">
        <table width="780" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td height="5" colspan="2"></td>
          </tr>
          <tr>
            <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">연말정산공제신청 입력</td>
            <td align="right"></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td height="10">&nbsp;</td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td class="font01" width="30%">연도: <%= targetYear %> &nbsp;&nbsp;&nbsp;
<%         
        if(  Double.parseDouble( DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"))   <= Double.parseDouble(currentDate) &&   Double.parseDouble(DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"))   >= Double.parseDouble(currentDate)) {
%>        
           확인기간 : <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-")) %> ~ <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-")) %>
<%
        }else if(  Double.parseDouble(DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"))   <= Double.parseDouble(currentDate) &&   Double.parseDouble(DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"))   >= Double.parseDouble(currentDate) ) {
%>
           신청기간 : <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-")) %> ~ <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-")) %>

<%      }
%>   
           </td>
<!--            <td class="font01" width="550">연도: <%= targetYear %> &nbsp;&nbsp;&nbsp;본인내역조회기간 : 2008.1.11~2008.1.17</td>-->
            <td align="right" width="70%">
<%
        if (Gubn.equals("TaxInfo")) {  
%>     
              <img name="TaxInfo" border="0" src="<%= WebUtil.ImageURL %>btn_TaxInfo.gif" alt="연말정산입력방법"></a>
<%
        } else {
%>
              <a href="javascript:do_TaxInfo();"><img name="TaxInfo" border="0" src="<%= WebUtil.ImageURL %>btn_TaxInfo.gif" alt="연말정산입력방법"></a>
<%
        }
    	if (!c_flag.equals("X") &&  conFrimYn.equals("Y")) {  
%>
		<a href="javascript:do_confirm();">
         <img src="<%= WebUtil.ImageURL %>btn_tax_confirm.gif"  border="0" alt="연말정산확정"></a>
<%
    	}
        if (Gubn.equals("TaxPrint")) {  
%>     
              <img name="TaxPrint" border="0" src="<%= WebUtil.ImageURL %>btn_TaxPrint.gif" alt="소득공제신고서발행"></a>
<%
        } else {
%>
              <a href="javascript:do_TaxPrint();"><img name="TaxPrint" border="0" src="<%= WebUtil.ImageURL %>btn_TaxPrint.gif" alt="소득공제신고서발행"></a>
<%
        }
      if (Gubn.equals("Detail")) {  
%>     
              <img name="TaxDis" border="0" src="<%= WebUtil.ImageURL %>btn_TaxDis.gif" alt="연말정산 내역조회"><font color="#FFFFFF">＿＿＿</font>
<%
        } else {
%>
              <a href="javascript:do_Detail();"><img name="TaxDis" border="0" src="<%= WebUtil.ImageURL %>btn_TaxDis.gif" alt="연말정산 내역조회"></a><font color="#FFFFFF">＿＿＿</font>
<%
        }
%>

            </td>
          </tr>
        </table>
      </td>
    </tr>
<%
    } else {
%> 
      <td class="font01" align="right">
<%
        if (Gubn.equals("TaxInfo")) {  
%>     
              <img name="TaxInfo" border="0" src="<%= WebUtil.ImageURL %>btn_TaxInfo.gif" alt="연말정산입력방법"></a>
<%
        } else {
%>
              <a href="javascript:do_TaxInfo();"><img name="TaxInfo" border="0" src="<%= WebUtil.ImageURL %>btn_TaxInfo.gif" alt="연말정산입력방법"></a>
<%
        }
    	if (!c_flag.equals("X") &&  conFrimYn.equals("Y")) {  
%>
		<a href="javascript:do_confirm();">
         <img src="<%= WebUtil.ImageURL %>btn_tax_confirm.gif"  border="0" alt="연말정산확정"></a>
<%
    	}

        if (Gubn.equals("TaxPrint")) {  
%>     
        <img name="TaxPrint" border="0" src="<%= WebUtil.ImageURL %>btn_TaxPrint.gif" alt="소득공제신고서발행"></a>
<%
        } else {
%>
        <a href="javascript:do_TaxPrint();"><img name="TaxPrint" border="0" src="<%= WebUtil.ImageURL %>btn_TaxPrint.gif" alt="소득공제신고서발행"></a>
<%
        }
      if (Gubn.equals("Detail")) {  
%>     
        <img name="TaxDis" border="0" src="<%= WebUtil.ImageURL %>btn_TaxDis.gif" alt="연말정산 내역조회"><font color="#FFFFFF">＿＿＿</font>
<%
        } else {
%>
        <a href="javascript:do_Detail();"><img name="TaxDis" border="0" src="<%= WebUtil.ImageURL %>btn_TaxDis.gif" alt="연말정산 내역조회"></a><font color="#FFFFFF">＿＿＿</font>
        
<%
        }
%>
      </td>
<%
    } 
%> 
    <tr>
      <td>
        <!--개인정보 테이블 시작-->
        <table  border="0" cellspacing="0" cellpadding="0" height="22">
          <tr>
<%
   if (Gubn.equals("TaxGuide")) {  
%>     
            <td>
              <img name="TaxGuide" border="0" src="<%= WebUtil.ImageURL %>btn_TaxGuide_on.gif" height="22" alt="연말정산안내">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_TaxGuide();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('TaxGuide','','<%= WebUtil.ImageURL %>btn_TaxGuide_on.gif',1)"><img name="TaxGuide" border="0" src="<%= WebUtil.ImageURL %>btn_TaxGuide_off.gif" height="22" alt="연말정산안내"></a>
            </td>
<% } %>

<!--********************* 2013.07.01 추가 *********************-->  
<%
   //  전근무지 메뉴를 해당년도 입사자인 경우에만 메뉴를 보여준다. //@2014 연말정산 위치변경
    if( user.e_dat03.substring(0,4).equals(targetYear) ) {
   //   if( targetYear.equals("2010") ) { 
        if (Gubn.equals("Tax08")) {  
%>     
            <td width="85">
              <img name="Tax08" border="0" src="<%= WebUtil.ImageURL %>btn_Tax08_on.gif" height="22" alt="전근무지">
            </td>
<%
        } else { 
%>
            <td width="85">
              <a href="javascript:do_Tax08();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax08','','<%= WebUtil.ImageURL %>btn_Tax08_on.gif',1)"><img name="Tax08" border="0" src="<%= WebUtil.ImageURL %>btn_Tax08_off.gif" height="22" alt="전근무지"></a>
            </td>
<%
        }
   }    
%>

<%
   if (pdfYn.equals("Y")){
   		if (Gubn.equals("PDF")) {  
%>
			<td>
              <img name="PDF" border="0" src="<%= WebUtil.ImageURL %>btn_PDF_on.gif" height="22" alt="PDF파일업로드">
            </td>
<% 	} else { %>
			<td>
              <a href="javascript:do_PdfUp();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('PDF','','<%= WebUtil.ImageURL %>btn_PDF_on.gif',1)"><img name="PDF" border="0" src="<%= WebUtil.ImageURL %>btn_PDF_off.gif" height="22" alt="PDF파일업로드"></a>
            </td>
<%	
		}
   	} 
%>
<!--********************* 2013.07.01 추가 *********************-->

<%
   if (Gubn.equals("Tax01")) {  
%>     
            <td>
              <img name="Tax01" border="0" src="<%= WebUtil.ImageURL %>btn_Tax01_on.gif" height="22" alt="인적공제">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_Tax01();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax01','','<%= WebUtil.ImageURL %>btn_Tax01_on.gif',1)"><img name="Tax01" border="0" src="<%= WebUtil.ImageURL %>btn_Tax01_off.gif" height="22" alt="인적공제"></a>
            </td>
<% } %>  
<%   if (Gubn.equals("Tax10")) {  
%>     
            <td>
              <img name="Tax10" border="0" src="<%= WebUtil.ImageURL %>btn_Tax10_on.gif" height="22" alt="보험료">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_Tax10();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax10','','<%= WebUtil.ImageURL %>btn_Tax10_on.gif',1)"><img name="Tax10" border="0" src="<%= WebUtil.ImageURL %>btn_Tax10_off.gif" height="22" alt="보험료"></a>
            </td>
<% }  %>
<%
   if (Gubn.equals("Tax05")) {  
%>     
            <td>
              <img name="Tax05" border="0" src="<%= WebUtil.ImageURL %>btn_Tax05_on.gif" height="22" alt="의료비">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_Tax05();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax05','','<%= WebUtil.ImageURL %>btn_Tax05_on.gif',1)"><img name="Tax05" border="0" src="<%= WebUtil.ImageURL %>btn_Tax05_off.gif" height="22" alt="의료비"></a>
            </td>
<% } %>

<%
   if (Gubn.equals("Tax03")) {  
%>     
            <td>
              <img name="Tax03" border="0" src="<%= WebUtil.ImageURL %>btn_Tax03_on.gif" height="22" alt="교육비">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_Tax03();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax03','','<%= WebUtil.ImageURL %>btn_Tax03_on.gif',1)"><img name="Tax03" border="0" src="<%= WebUtil.ImageURL %>btn_Tax03_off.gif" height="22" alt="교육비"></a>
            </td>
<% } %>
      
<%
   if (Gubn.equals("Tax02")) {  
%>     
            <td>
              <img name="Tax02" border="0" src="<%= WebUtil.ImageURL %>btn_Tax02_on.gif" height="22" alt="주택자금상환/4대보험">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_Tax02();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax02','','<%= WebUtil.ImageURL %>btn_Tax02_on.gif',1)"><img name="Tax02" border="0" src="<%= WebUtil.ImageURL %>btn_Tax02_off.gif" height="22" alt="주택자금상환/4대보험"></a>
            </td>
<% } %> 
<%
   if (Gubn.equals("Tax06")) {  
%>     
            <td>
              <img name="Tax06" border="0" src="<%= WebUtil.ImageURL %>btn_Tax06_on.gif" height="22" alt="기부금">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_Tax06();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax06','','<%= WebUtil.ImageURL %>btn_Tax06_on.gif',1)"><img name="Tax06" border="0" src="<%= WebUtil.ImageURL %>btn_Tax06_off.gif" height="22" alt="기부금"></a>
            </td>
<% } 
   if (Gubn.equals("Tax11")) {  
%>     
            <td>
              <img name="Tax11" border="0" src="<%= WebUtil.ImageURL %>btn_Tax11_on.gif" height="22" alt="연금/저축공제">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_Tax11();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax11','','<%= WebUtil.ImageURL %>btn_Tax11_on.gif',1)"><img name="Tax11" border="0" src="<%= WebUtil.ImageURL %>btn_Tax11_off.gif" height="22" alt="연금/저축공제"></a>
            </td>
<% } 
   if (Gubn.equals("Tax09")) {  
%>     
            <td width="62">
              <img name="Tax09" border="0" src="<%= WebUtil.ImageURL %>btn_Tax09_on.gif" width="62" height="22" alt="신용카드">
            </td>
<% } else { %>
            <td width="62">
              <a href="javascript:do_Tax09();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax09','','<%= WebUtil.ImageURL %>btn_Tax09_on.gif',1)"><img name="Tax09" border="0" src="<%= WebUtil.ImageURL %>btn_Tax09_off.gif" width="62" height="22" alt="신용카드"></a>
            </td>
<% } %>
<%   if (Gubn.equals("Tax04")) {  
%>     
            <td>
              <img name="Tax04" border="0" src="<%= WebUtil.ImageURL %>btn_Tax04_on.gif" height="22" alt="기타세액공제">
            </td>
<% } else { %>
            <td>
              <a href="javascript:do_Tax04();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax04','','<%= WebUtil.ImageURL %>btn_Tax04_on.gif',1)"><img name="Tax04" border="0" src="<%= WebUtil.ImageURL %>btn_Tax04_off.gif" height="22" alt="기타세액공제"></a>
            </td>
<% } 
   if (Gubn.equals("Tax07")) {  
%> 
       <td width="84">
         <img name="Tax07" border="0" src="<%= WebUtil.ImageURL %>btn_Tax07_on.gif" width="84" height="22" alt="신청현황조회">
       </td>
<%
   } else {
%>
       <td width="84">
         <a href="javascript:do_Tax07();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax07','','<%= WebUtil.ImageURL %>btn_Tax07_on.gif',1)"><img name="Tax07" border="0" src="<%= WebUtil.ImageURL %>btn_Tax07_off.gif" width="84" height="22" alt="신청현황조회"></a>
       </td>
<%
   } 
   if (Gubn.equals("Tax12")) {  
%> 
       <td>
         <img name="Tax07" border="0" src="<%= WebUtil.ImageURL %>btn_Tax12_on.gif" height="22" alt="월세공제">
       </td>
<%
   } else {
%>
       <td>
         <a href="javascript:do_Tax12();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax12','','<%= WebUtil.ImageURL %>btn_Tax12_on.gif',1)"><img name="Tax12" border="0" src="<%= WebUtil.ImageURL %>btn_Tax12_off.gif" height="22" alt="월세공제"></a>
       </td>
<%
   }    
%>


          </tr>
          

        </table>
        <!--개인정보 테이블 끝-->
      </td>
    </tr>
<%
   if (!Gubn.equals("TaxGuide")) {  

   if (Gubn.equals("Tax01")||Gubn.equals("Tax02")||Gubn.equals("Tax11")||Gubn.equals("Tax12")||Gubn.equals("PDF")) {  
%> 
    
    <tr>
      <td>
      <input type="checkbox" name="P_CHG" value="X" class="input02" <%= E_CHG.equals("X")  ? "checked" : "" %> disabled>인적공제 변동여부
      &nbsp;&nbsp;&nbsp;<input type="checkbox" name="FSTID" value="X" <%= E_HOLD.equals("X")  ? "checked" : "" %> class="input02">세대주 여부
      </td>
    </tr>
<%
   }else {  
%> 
    <tr>
      <td>
      <input type="checkbox" name="P_CHG" value="X" class="input02" <%= E_CHG.equals("X")  ? "checked" : "" %> disabled>인적공제 변동여부
      &nbsp;&nbsp;&nbsp;<input type="checkbox" name="FSTID" value="X" <%= E_HOLD.equals("X")  ? "checked" : "" %> class="input02" disabled>세대주 여부
      </td>
    </tr>
<%
   }
   }
%> 
