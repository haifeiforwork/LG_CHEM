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
/* 					2018.01.04 cykim   [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건  */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
    //D11TaxAdjustPersonCheckRFC      rfcPC   = new D11TaxAdjustPersonCheckRFC();  [CSR ID:3569665] 주석
    String begda = targetYear + "0101";
    String endda = targetYear + "1231";
    String E_HOLD =  rfcHC.getChk(  user.empNo, targetYear,begda,endda,""); //세대주체크여부
  	//[CSR ID:3569665] @2017연말정산 인적공제변동여부 rfc 콜 막음
    //String E_CHG =  rfcPC.getChk(  user.empNo, targetYear,begda,endda,""); //인적공제변동여부  [CSR ID:3569665] 주석

    //********************* 2013.07.01 추가 *********************//
    String pdfYn = (String)session.getAttribute("pdfYn");
	//********************* 2013.07.01 추가 *********************//
    // 2002.12.04. 연말정산 확정여부 조회
    D11TaxAdjustYearCheckRFC rfc_c = new D11TaxAdjustYearCheckRFC();
    String c_flag = rfc_c.getO_FLAG( user.empNo, targetYear );

    String conFrimYn = "N";
    //[CSR ID:3569665] @2017연말정산 전근무지 예외자 여부
    String lastYn = "N";

    Vector retYN            = new Vector();
    retYN = ( new D11TaxAdjustScreenControlRFC() ).getFLAG( user.empNo ,targetYear,DataUtil.getCurrentDate() );
    conFrimYn = (String)retYN.get(1); //회사별로 확정프로세스 사용여부가 옴
    /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start */
	lastYn = (String)retYN.get(2); //전근무지 예외자 여부
    /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end */

    //CSR ID:2013_9999 장애인코드 등록안한경우 Check
    D11TaxAdjustPersonRFC    rfcPerson   = new D11TaxAdjustPersonRFC();
    String  msg="";
    Vector personVt = rfcPerson.getPerson( user.empNo, targetYear );
    for( int i = 0 ; i < personVt.size() ; i++ ){
        D11TaxAdjustPersonData dataPerson = (D11TaxAdjustPersonData)personVt.get(i);
        if (dataPerson.HNDEE.equals("X") && dataPerson.HNDCD.equals("")) {
            msg +=dataPerson.ENAME+g.getMessage("MSG.D.D11.0005")+"\\n";  //에 대한 장애인 코드를 등록하세요.
        }
        //[CSR ID:3569665] 자녀 값 입력 필수 항목 안 넣었을 경우 Check
        if (dataPerson.SUBTY.equals("2") && Double.parseDouble(dataPerson.BETRG06) > 0 && dataPerson.KDBSL.equals("")) {
            msg +=dataPerson.ENAME+" "+g.getMessage("MSG.D.D11.0108")+"\\n";  //자녀가 총 자녀인원 기준으로 몇 번째 자녀인지를 선택하시기 바랍니다.
        }
    }

    //@2014 연말정산 부서구분에 따른 numbering 추가(소득공제신고서 출력용) , only pdf 만 사용하는지에 대한 여부 체크
    DeptCodeNumberingRFC rfc_n = new DeptCodeNumberingRFC();
    PdfOnlyYnCheckRFC rfc_only_pdf_yn = new PdfOnlyYnCheckRFC();
%>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript">
<!--

// 연말정산 신청안내
function do_TaxGuide() {
//    if( chk_change() ) {
//        do_build();
//    } else {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxFirstSV?targetYear=<%= targetYear %>";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
//    }
}

// 인적공제
function do_Tax01() {
	var msg ="<spring:message code='MSG.D.D11.0006' />"; //※ 연간 소득금액의 합계액이 100만원 이하\n
	msg += "<spring:message code='MSG.D.D11.0007' />"; //① 해당소득 : 양도소득/근로소득/퇴직소득/사업소득/연금소득/이자배당소득/기타소득\n
	//msg += "② 근로소득이자 : 총급여의 합계액 500만원\n";
	//msg += "② 근로소득이자 : 총급여의 합계액 3,333,333원\n";//@2014 연말정산
	msg += "<spring:message code='MSG.D.D11.0008' />";//@2015 연말정산  //② 이자·배당소득이 2,000만원 이하\n
	//msg += "③ 이자·배당소득이 2,000만원\n";
	msg += "<spring:message code='MSG.D.D11.0009' />";//@2015 연말정산 //③ 근로소득만 있는 경우 총급여액 500만원 이하\n
	/* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start */
	msg += "<spring:message code='MSG.D.D11.0106' />";//@2017 연말정산 //④ 가족정보에 부양가족 등록 여부는 국세청 자료 조회와 무관함.\n
	msg += "<spring:message code='MSG.D.D11.0107' />";//@2017 연말정산 //⑤ PDF 파일에서 부양가족의 공제항목 조회가 불가능한 경우에는 국세청 간소화 사이트에서 부양가족이 자료 제공 동의 신청을 해야함.\n
	/* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end */
	msg += "<spring:message code='MSG.D.D11.0010' arguments='<%=targetYear%>'/>";  <%-- ☞ ’<%=targetYear%>년의 연간 소득유무 여부를 반드시 확인하여 주시기 바랍니다. --%>
	alert(msg);
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPersonSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}

// 주택자금상환/4대보험 @2015 연말정산 주택자금상환 분리
function do_Tax02() {

    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustSpecialSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}

// 특별공제 교육비(미사용)
function do_Tax03_old() {
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEduSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
// 교육비(수정)
function do_Tax03() {
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEducationSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
// 기타세액공제
function do_Tax04() {
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustTaxSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}

// 의료비
function do_Tax05() {
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
// @v1.1 기부금
function do_Tax06() {
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}

// 전근무지
function do_Tax08() {
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPreWorkSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}

// 소득공제신고서
function do_TaxPrint() {
	if( do_Check(1) ) {
		if("<%=c_flag%>"!="X" && "<%=conFrimYn%>"=="Y"){
			alert("<spring:message code='MSG.D.D11.0011' />"); //연말정산확정을 하셔야 소득공제신고서를 출력하실 수 있습니다.\n연말정산신청내역을 확인하신 후 [연말정산확정] 버튼을 클릭하셔서 연말정산내역을 확정해주세요.
			return;//@2014 연말정산 주석 삭제필요!!!!!!
		}
<%    String deptNum = rfc_n.getDeptCodeNumber(user.empNo, targetYear);
		session.setAttribute("PNT_SEQ", deptNum);//@2014 연말정산 소득공제신고서에 seq 붙이기 위함.
		String pdfOnlyYN = rfc_only_pdf_yn.getOnlyPdfYN(user.empNo, targetYear);;
		session.setAttribute("PDF_ONLY_YN", pdfOnlyYN);//@2014 연말정산 소득공제신고서에 pdf만 사용한건지 여부 표시
%>

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
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustFamilySV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
// @v1.2신용카드
function do_Tax09() {
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV?tab_gubun=1";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
// @v1.2보험료
function do_Tax10() {
    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV?tab_gubun=2";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
// 연말정산 내역조회
function do_Detail() {
    if( do_Check(2) ) {
    	//if(true){
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D14TaxAdjustDetailSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
// 월세공제
function do_Tax12() {
    if( do_Check(1) ) {

        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustRentSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
// 연금저축공제
function do_Tax11() {
    if( do_Check(1) ) {

        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPensionSV";
        document.form1.method = "post";
        document.form1.jobid.value = "";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
//주택자금상환 @2015 연말정산 4대보험, 주택자금공제 분할
function do_Tax13() {
    if( do_Check(1) ) {
	    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustHouseLoanSV";
	    document.form1.method = "post";
	    document.form1.jobid.value = "";
	    document.form1.target = "menuContentIframe";
	    document.form1.submit();
    }
}

// 연말정산입력방법
function do_TaxInfo() {
    if( do_Check(1) ) {
	    document.location.href  = "<%= WebUtil.JspPath %>D/D11TaxAdjust/screen/TaxInfoGuide.ppt";
	    //small_window=window.open("<%= WebUtil.JspPath %>D/D11TaxAdjust/D11TaxAdjustInfo.html","TaxInfo", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes, resizable=no,width=800,height=600,left=100,top=100");
	    //small_window=window.open("<%= WebUtil.JspPath %>D/D11TaxAdjust/screen/TaxInfoGuide.ppt","TaxInfo", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes, resizable=no,left=100,top=100");
	    //small_window.focus();
    }
}

// 연말정산 입력(1), 연말정산 내역조회(2)가 가능한지 check
function do_Check(gubun) {
    if( gubun == "1" ) {
        if( <%= simu_from %> <= 0 && <%= simu_toxx %> >= 0) {
            return true;
        } else {
            //alert("연말정산 입력기간이 아닙니다.");
            return true;
        }
    } else if( gubun == "2" ) {
        if( <%= disp_from %> <= 0 && <%= disp_toxx %> >= 0 ) {
            return true;
        } else {
            alert("<spring:message code='MSG.D.D11.0012' />"); //연말정산 내역조회 기간이 아닙니다.
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
	if( do_Check(1) ) {
		//CSR ID:2013_9999
		if (  "<%=msg%>" !=""   ){ //인적공제 tab이 아니면서 장애코드가입력되지 않은경우
		    alert("<%=msg%>");
	   	    if ("<%=Gubn%>" != "Tax01") {
		    	    do_Tax01();
		    }

		}else{

			if(!confirm("<spring:message code='MSG.D.D11.0013' />")) return;  //확정하게 되면 연말정산내역 입력과 수정이 불가능합니다.\n연말정산 내역을 확정하시겠습니까?
			document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustFamilySV?jobid=confirm";
			document.form1.method      = "post";
			document.form1.target      = "menuContentIframe";
			document.form1.submit();
		}
	}
}



//-->
</SCRIPT>
<%
   if (!Gubn.equals("Detail")) {
%>
<div >
  <div class="title">
    <h1><spring:message code="LABEL.D.D11.0001" /><!-- 연말정산공제신청 입력 --></h1>
  </div>

	<div style="float:left;">
  <span><strong><spring:message code="LABEL.D.D11.0002" /><!-- 연도 -->: <%= targetYear %></strong></span><br/>
<%
        if(  Double.parseDouble( DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"))   <= Double.parseDouble(currentDate) &&   Double.parseDouble(DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"))   >= Double.parseDouble(currentDate)) {
%>
  <span><spring:message code="LABEL.D.D11.0024" /><!-- 확인기간 --> : <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-")) %> ~ <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-")) %></span>
<%
        }else if(  Double.parseDouble(DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"))   <= Double.parseDouble(currentDate) &&   Double.parseDouble(DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"))   >= Double.parseDouble(currentDate) ) {
%>
  <span><spring:message code="LABEL.D.D11.0003" /><!-- 신청기간 --> : <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-")) %> ~ <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-")) %></span>
<%      }

%>
	</div>
  <div class="buttonArea">
    <ul class="btn_mdl">
<%
if (Gubn.equals("TaxInfo")) {
%>
      <li><a href="" class="selected"><span><spring:message code="LABEL.D.D11.0025" /><!-- 연말정산입력방법 --></span></a></li>
<%
} else {
%>
      <li><a href="javascript:do_TaxInfo();"><span><spring:message code="LABEL.D.D11.0025" /><!-- 연말정산입력방법 --></span></a></li>
<%
}

if (!c_flag.equals("X") &&  conFrimYn.equals("Y")) {
%>
      <li><a href="javascript:do_confirm();"><span><spring:message code="LABEL.D.D11.0026" /><!-- 연말정산확정 --></span></a></li>
<%
}
if (Gubn.equals("TaxPrint")) {
%>
      <li><a class="selected"><span><spring:message code="LABEL.D.D11.0027" /><!-- 소득공제신고서발행 --></span></a></li>
<%
} else {
%>
      <li><a href="javascript:do_TaxPrint();"><span><spring:message code="LABEL.D.D11.0027" /><!-- 소득공제신고서발행 --></span></a></li>
<%
}
if (Gubn.equals("Detail")) {
%>
      <li><a class="selected"><span><spring:message code="LABEL.D.D11.0028" /><!-- 연말정산 내역조회 --></span></a></li>
<%
} else {
%>
      <li><a href="javascript:do_Detail();"><span><spring:message code="LABEL.D.D11.0028" /><!-- 연말정산 내역조회 --></span></a></li>
<%
}
%>
    </ul>
  </div>
  </div>

<%
    } else {
%>
  <div class="buttonArea">
    <ul class="btn_mdl">
<%
if (Gubn.equals("TaxInfo")) {
%>
      <li><a class="selected"><span><spring:message code="LABEL.D.D11.0025" /><!-- 연말정산입력방법 --></span></a></li>
<%
} else {
%>
      <li><a href="javascript:do_TaxInfo();"><span><spring:message code="LABEL.D.D11.0025" /><!-- 연말정산입력방법 --></span></a></li>
<%
}
if (!c_flag.equals("X") &&  conFrimYn.equals("Y")) {
%>
      <li><a href="javascript:do_confirm();"><span><spring:message code="LABEL.D.D11.0026" /><!-- 연말정산확정 --></span></a></li>
<%
}

if (Gubn.equals("TaxPrint")) {
%>
      <li><a class="selected"><span><spring:message code="LABEL.D.D11.0027" /><!-- 소득공제신고서발행 --></span></a></li>
<%
} else {
%>
      <li><a href="javascript:do_TaxPrint();"><span><spring:message code="LABEL.D.D11.0027" /><!-- 소득공제신고서발행 --></span></a></li>
<%
}
if (Gubn.equals("Detail")) {
%>
      <li><a class="selected"><span><spring:message code="LABEL.D.D11.0028" /><!-- 연말정산 내역조회 --></span></a></li>
<%
} else {
%>
      <li><a href="javascript:do_Detail();"><span><spring:message code="LABEL.D.D11.0028" /><!-- 연말정산 내역조회 --></span></a></li>

<%
}
%>
    </ul>
  </div>
<%
}
%>

  <div class="clear" style="margin-bottom:20px;"></div>

<!--개인정보 테이블 시작-->


  <div class="tabArea">
    <ul class="tab">
<%
   if (Gubn.equals("TaxGuide")) {
%>
      <li ><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0029" /><!-- 연말정산안내 --></a></li>
<% } else { %>
      <li><a href="javascript:do_TaxGuide();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0029" /><!-- 연말정산안내 --></a></li>
<% } %>

<!--********************* 2013.07.01 추가 *********************-->
<%
   //  전근무지 메뉴를 해당년도 입사자인 경우에만 메뉴를 보여준다. //@2014 연말정산 위치변경
   // 1월 1일 입사자의 경우 제외
   /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start */
   /* org source */
   String temp = user.e_dat03.replace("-","");
   temp = temp.substring(4);
   if( (user.e_dat03.substring(0,4).equals(targetYear) && !(temp.equals("0101")||temp == "0101")) ||lastYn.equals("Y")){

	/* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end */
   //   if( targetYear.equals("2010") ) {
        if (Gubn.equals("Tax08")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0030" /><!-- 전근무지 --></a></li>
<%
        } else {
%>
      <li><a href="javascript:do_Tax08();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0030" /><!-- 전근무지 --></a></li>
<%
        }
   }
%>

<%
   if (pdfYn.equals("Y")){
      if (Gubn.equals("PDF")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0031" /><!-- PDF파일업로드 --></a></li>
<%  } else { %>
      <li><a href="javascript:" onclick="javascript:do_PdfUp();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0031" /><!-- PDF파일업로드 --></a></li>
<%
    }
    }
%>
<!--********************* 2013.07.01 추가 *********************-->

<%
   if (Gubn.equals("Tax01")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0008" /><!-- 인적공제 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax01();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0008" /><!-- 인적공제 --></a></li>
<% } %>
<%   if (Gubn.equals("Tax10")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0032" /><!-- 보혐료 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax10();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0032" /><!-- 보혐료 --></a></li>
<% }  %>
<%
   if (Gubn.equals("Tax05")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0033" /><!-- 의료비 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax05();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0033" /><!-- 의료비 --></a></li>
<% } %>

<%
   if (Gubn.equals("Tax03")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0034" /><!-- 교육비 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax03();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0034" /><!-- 교육비 --></a></li>
<% } %>

<%
   if (Gubn.equals("Tax02")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0035" /><!-- 4대보험 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax02();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0035" /><!-- 4대보험 --></a></li>
<% } %>
<%
   if (Gubn.equals("Tax06")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0036" /><!-- 기부금 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax06();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0036" /><!-- 기부금 --></a></li>
<% }
   if (Gubn.equals("Tax11")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0037" /><!-- 연금/저축공제 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax11();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0037" /><!-- 연금/저축공제 --></a></li>
<% }%>
<%
//@2015 연말정산 추가
   if (Gubn.equals("Tax13")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0038" /><!-- 주택자금상환 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax13();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0038" /><!-- 주택자금상환 --></a></li>
<% } %>
<%   if (Gubn.equals("Tax09")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0039" /><!-- 신용카드 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax09();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0039" /><!-- 신용카드 --></a></li>
<% } %>
<%   if (Gubn.equals("Tax12")) {//@2015 연말정산 월세공제 위치 수정
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0040" /><!-- 월세공제 --></a></li>
<%
   } else {
%>
      <li><a href="javascript:" onclick="javascript:do_Tax12();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0040" /><!-- 월세공제 --></a></li>
<%
   }
%>
<%   if (Gubn.equals("Tax04")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0041" /><!-- 기타세액공제 --></a></li>
<% } else { %>
      <li><a href="javascript:" onclick="javascript:do_Tax04();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0041" /><!-- 기타세액공제 --></a></li>
<% }%>
<%   if (Gubn.equals("Tax07")) {
%>
      <li><a class="selected" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0042" /><!-- 신청현황조회 --></a></li>
<%
   } else {
%>
      <li><a href="javascript:" onclick="javascript:do_Tax07();" style="padding: 0 1px"><spring:message code="LABEL.D.D11.0042" /><!-- 신청현황조회 --></a></li>
<%}%>

    </ul>
  </div>
        <!--개인정보 테이블 끝-->
  <div>
<%
   if (!Gubn.equals("TaxGuide")) {
	 %>
	  	<!-- [CSR ID:3569665] @2017 연말정산 : 2017년부터 인적공제 변동여부 unchecked 로 수정함. : start -->
	  	<%
	  	if(Integer.parseInt(targetYear) < 2017){
	  	%>
	    <input type="checkbox" name="P_CHG" value="X" class="input02"  disabled><spring:message code="LABEL.D.D11.0043" /><!-- 인적공제 변동여부 -->
	    <%}else{ %>
		<!--<input type="checkbox" name="P_CHG" value="X" class="input02" < %= E_CHG.equals("X")  ? "" : "" %> disabled><spring:message code="LABEL.D.D11.0043" /> 인적공제 변동여부 -->
		<input type="checkbox" name="P_CHG" value="" class="input02"  disabled><spring:message code="LABEL.D.D11.0043" /><!-- 인적공제 변동여부 //[CSR ID:3569665] 값 안넘기도록 수정-->
		<%}

   if (Gubn.equals("Tax01")||Gubn.equals("Tax11")) { //Gubn.equals("Tax02")|| @2015 연말정산 수정  , Gubn.equals("Tax12")||Gubn.equals("PDF") [CSR ID:3569665]
%>

    <!-- [CSR ID:3569665] @2017 연말정산 : 2017년부터 인적공제 변동여부 unchecked 로 수정함. : end -->
    <input type="checkbox" name="FSTID" value="X" <%= E_HOLD.equals("X")  ? "checked" : "" %> class="input02"><spring:message code="LABEL.D.D11.0044" /><!-- 세대주 여부 -->
<%
   }else {
%>
    <!-- [CSR ID:3569665] @2017 연말정산 : 2017년부터 인적공제 변동여부 unchecked 로 수정함. : end -->
    <input type="checkbox" name="FSTID" value="X" <%= E_HOLD.equals("X")  ? "checked" : "" %> class="input02" disabled><spring:message code="LABEL.D.D11.0044" /><!-- 세대주 여부 -->
<%
   }
}
%>
  </div>