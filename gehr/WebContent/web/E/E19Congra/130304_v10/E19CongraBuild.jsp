<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : E19CongraBuild.jsp  최종                                        */
/*   Description  : 경조금 신청                                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-14  이승희                                          */
/*   Update       : 2005-02-24  윤정현                                          */
/*                  2005-12-07  @v1.1 lsa C2005112301000000543 경조화환 신청시 부서계좌 정보 조회기능 추가 */
/*                  2005-12-29  @v1.2 lsa C2005122801000000122 돌반지제외       */
/*                  2006-01-18  @v1.3 lsa C2006011801000000150 경조금 신청 제한 한시적 오픈 요청 */
/*                              @v1.4 lsa 통상금액(경조일 기준으로변경)         */
/*                              @v1.5 lsa 급여작업으로 막음                     */
/*                              @v1.5 lsa 5월급여작업으로 막음  전문기술직만    */
/*                              @v1.6 해외법인 임시로 품 71246:박선화           */
/*                  2006-06-14  @v1.8 경조대상자 조회                           */
/*                              @v1.9 -조부모 회갑 경조금 폐지                  */
/*                                    -배우자 형제자매상 50% 지급 추가 (2006/6월/21일 오픈으로 이전 경조일data는 체크함)*/
/*                              @v2.0 [CSR ID:1225704] -프로세스개선 임시 막음  */
/*                  2012-03-30  [CSR ID:C20120323_76012 ] 경조대상자 관계 변경시 대상자명칭 CLEAR  */
/*                  2012-04-23  [CSR ID:2094498] 문구 삭제,변경의건 */
/*                  2012-04-23  [CSR ID:C20130304_83585] 경조금 쌀화환:0010 추가요청 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %> 
<%@ page import="hris.common.*" %> 
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    E19CongcondData  e19CongcondData = (E19CongcondData)request.getAttribute("e19CongcondData");

    Vector E19CongcondData_opt  = (new E19CongRelaRFC()).getCongRela(e19CongcondData.PERNR);
    Vector E19CongcondData_rate = (new E19CongRateRFC()).getCongRate(e19CongcondData.PERNR);
    Vector AppLineData_vt       = (Vector)request.getAttribute("AppLineData_vt");
    Vector e19CongraDupCheck_vt = (Vector)request.getAttribute("e19CongraDupCheck_vt");
    Vector e19CongraLifnr_vt    = (Vector)request.getAttribute("e19CongraLifnr_vt");

    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    Vector      AccountData_pers_vt = (Vector)request.getAttribute("AccountData_pers_vt");
    AccountData AccountData_hidden  = (AccountData)request.getAttribute("AccountData_hidden");
    
    //@v1.7
    String webUserID = "";
    if (user.webUserId == null ||user.webUserId.equals("") )
        webUserID = "";
    else
        webUserID = user.webUserId.substring(0,6).toUpperCase();


    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");

    String Except3Month = "";
    
    if ( PERNR_Data.E_PERNR.equals("00204223") && Integer.parseInt(DataUtil.getCurrentDate())  <20120301 ) {
        Except3Month = "Y";        
    }

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
    //@v1.9 start
    var epUrl = new Array("","","","","");
    //인사정보
    epUrl[0]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url=";
    //신청
    epUrl[1]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url=";
    //사원인사정보
    epUrl[2]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHROrgStatMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHROrgStatMenu%2Fbegin&_windowLabel=portlet_EHROrgStatMenu_1&_pageLabel=Menu03_Book04_Page01&portlet_EHROrgStatMenu_1url=";
    //조직통계
    epUrl[3]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url=";
    //결재함
    epUrl[4]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url=";

    var docUpid = new Array("0_1006","0_1088","0_1089","0_1090","0_1091","0_1092","0_1285","1_1007","1_1066","1_1134","1_1163","1_1168","1_1222","1_1281","2_1033","2_1053","2_1056","2_1060","2_1063","3_1094","3_1137","3_1138","3_1139","3_1140","3_1141","4_1003");
    function openDoc(docID, upID, realPath)
    {
        var epReturnUrl = "";
        for (r=0;r<docUpid.length;r++) {
           if (upID == docUpid[r].substring(2,6)) {
              epReturnUrl = epUrl[docUpid[r].substring(0,1)]+realPath;
           }
        }
        clickDoc(docID,epReturnUrl);

    }
    
    function clickDoc(docID,epReturnUrl)
    {
       frm = document.form1;
       frm.action = epReturnUrl;
       frm.target = "_parent";
       frm.submit();
    } // end function  
    
/****** 원화일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWon(this);" *******/
function moneyChkEventForWon(obj){
    val = obj.value;
    if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
        addComma(obj);
    }
    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}

/**************************************************************** 문의 :  김성일 ****/
//달력 사용
function fn_openCal(Objectname, moreScriptFunction){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?moreScriptFunction="+moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
}
//달력 사용

function doSubmit() {  

    document.form1.checkSubmit.value = "Y";
    if( !check_data() ){
        document.form1.checkSubmit.value = "";
        return;
    }
    doSubmit_save();
}

function doSubmit_save() {
    //--------------------------------------------------------------------------------------------------------
    document.form1.CONG_WONX.value = removeComma(document.form1.CONG_WONX.value);   // 경조금액의 콤마를 없앤다.
    //--------------------------------------------------------------------------------------------------------
    document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value); //@v1.4
    document.form1.jobid.value = "create";
    document.form1.target = "main_ess";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Congra.E19CongraBuildSV";
    document.form1.method = "post";
    document.form1.submit();
    
}

function check_data(){

    if( checkNull(document.form1.CONG_CODE, "경조내역을") == false ) {
        return false;
    }
    if( checkNull(document.form1.RELA_CODE, "경조대상자를") == false ) {
        return false;
    }
    if( checkNull(document.form1.EREL_NAME, "경조대상자 성명을") == false ) {
        return false;
    }

    //  2003.02.20 - 경조금 신청시 중복신청을 체크하는 로직 추가
    //             - 신청사번에 대하여 동일 경조내역 & 동일 경조대상자 성명이 있는경우 신청하지 못한다
    var re, c_CONG_CODE, c_RELA_CODE, c_EREL_NAME;

    re = / /g;       //정규식 패턴을 만듭니다.

    c_CONG_CODE = document.form1.CONG_CODE.value;
    c_RELA_CODE = document.form1.RELA_CODE.value;
    c_EREL_NAME = document.form1.EREL_NAME.value;

    c_EREL_NAME = c_EREL_NAME.replace(re, "");    //re를 ""로 바꿉니다.
    document.form1.EREL_NAME.value = c_EREL_NAME;
    
    var LNMHG = document.form1.LNMHG.value; //대상자 성 
    var PER_LNMHG = document.form1.PER_LNMHG.value.substring(0,document.form1.LNMHG.value.length); //본인 성
      
    //@@@조위:0003 주민번호 뒷자리가 1이면서 백숙부상  임직원의 姓과 차이 있는 경우
    if ( c_CONG_CODE == "0003" && c_RELA_CODE =="0008" && "<%=PERNR_Data.E_REGNO.substring(6,7)%>" == "1" && PER_LNMHG!=  LNMHG   ) {
         var msg1="백숙부모상은 본인기준 큰아버지, 큰어머니, 작은아버지, 작은어머니만 해당되며, 그외 가족(외숙부모등)은 신청 불가합니다\n신청하시겠습니까?";
         
         if(!confirm(msg1)) {
             return;
         }
    }

    
<%
    for( int i = 0 ; i < e19CongraDupCheck_vt.size() ; i++ ) {
        E19CongraDupCheckData c_Data = (E19CongraDupCheckData)e19CongraDupCheck_vt.get(i);
%>
    if( "<%= user.companyCode %>" == "C100" && c_CONG_CODE == "0009" && c_RELA_CODE == "0001" ) {
        //      lg화학(C100) : 본인 재혼은 제외 - Temp Table만 체크한다.
        if( "<%= c_Data.CONG_CODE %>" == c_CONG_CODE && "<%= c_Data.RELA_CODE %>" == c_RELA_CODE
                                                     && "<%= c_Data.EREL_NAME %>" == c_EREL_NAME ) {
<%
        if( c_Data.INFO_FLAG.equals("T") ) {
%>
            alert("현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
            return false;
<%
        }
%>
        }
    } else if( "<%= user.companyCode %>" == "N100" && c_CONG_CODE == "0001" ) {
//      lg석유화학(N100) : 결혼은 제외
    } else {
        if( "<%= c_Data.CONG_CODE %>" == c_CONG_CODE && "<%= c_Data.RELA_CODE %>" == c_RELA_CODE
                                                     && "<%= c_Data.EREL_NAME %>" == c_EREL_NAME ) {
<%
        if( c_Data.INFO_FLAG.equals("I") ) {
%>
            alert("해당 경조내역에 이미 동명의 경조대상자가 있습니다.");
<%
        } else if( c_Data.INFO_FLAG.equals("T") ) {
%>
            alert("현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
<%
        }
%>
            return false;
        }
    }
<%
    }
%>
//  2003.02.20 - 경조금 신청시 중복신청을 체크하는 로직 추가

    //경조대상자 성명-10 입력시 길이 제한
    x_obj = document.form1.EREL_NAME;
    xx_value = x_obj.value;
    if( checkLength(xx_value) > 10 ){
        x_obj.value = limitKoText(xx_value, 10);
        alert("경조대상자 성명은 한글 5자, 영문 10자 이내여야 합니다.");
        x_obj.focus();
        x_obj.select();
        return false;
    }

    if( checkNull(document.form1.CONG_DATE, "경조발생일자를") == false ) {
      return false;
    }
    
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    if( disa == "0007" ){  //돌반지,  화환일 경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
<%  if ("Y".equals(user.e_representative) ) {  // 부서서무 담당일때  %>    
        if( checkNull(document.form1.LIFNR, "부서계좌번호를") == false ) {
            return false;
        }
<%  }  %>   
    }

    //은행 관련자료도 필수 항목이다
    if( document.form1.BANK_NAME.value == "" || document.form1.BANKN.value == "" ) {
      alert("입금될 계좌정보가 명확하지 않습니다.\n\n  인사담당자에게 문의해 주세요");
      return false;
    }
    //은행 관련자료도 필수 항목이다

    if ( check_empNo() ){
        return false;
    }

    x_CONG_WONX = removeComma(document.form1.CONG_WONX.value);
    if( isNaN(x_CONG_WONX) ){
        alert(" 입력값이 적합하지 않습니다. ");
        document.form1.CONG_WONX.focus();
        return false;
    } else if( x_CONG_WONX == "0" ){
        alert(" 입력값이 적합하지 않습니다. ");
        document.form1.CONG_WONX.focus();
        return false;
    }else{
        document.form1.CONG_WONX.value = x_CONG_WONX;
        document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value);
    }

    //경조사 발생 3개월초과시 에러처리
    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);

    betw = getAfterMonth(addSlash(congra_date), 3);
    dif = dayDiff(addSlash(begin_date), addSlash(betw));

    betw2 = getAfterMonth(addSlash(begin_date), 1);
    dif2 = dayDiff(addSlash(congra_date), addSlash(betw2));

    dif3 = begin_date - congra_date;

    if ( "<%= PERNR_Data.E_RECON %>" == "" ) {  // 퇴직자가 아닐때
        //@v1.3
        if(  ("<%=Except3Month%>" != "Y") && dif < 0){
            str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이후 3개월까지만 신청할 수 있습니다. ';
            alert(str);
            return false;
        }
    } else {
        var reday = "<%= PERNR_Data.E_REDAY %>";
        betwR = getAfterMonth(addSlash(reday), 3);
        difR  = dayDiff(addSlash(congra_date), betwR);
        if(  "<%=Except3Month%>" != "Y" && difR < 0){
            str = '        경조를 신청할수 없습니다.\n\n 퇴직일 이후 3개월까지만 신청할 수 있습니다. ';
            alert(str);
            return false;
        }        
    }
<%
    if( user.companyCode.equals("C100") ) {
%>
    var disadif = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    
    dif9 = dayDiff(addSlash(congra_date), addSlash(begin_date)); //CSR ID:1225704
    //if( "<%= PERNR_Data.E_RECON %>" != "D" && "<%= PERNR_Data.E_RECON %>" != "S" && disadif != "0007" && dif3 < 0 ){
    if( "<%= PERNR_Data.E_RECON %>" != "D" && "<%= PERNR_Data.E_RECON %>" != "S" && disadif != "0007" && dif9 < -7 ){
        str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이전에 신청할 수 없습니다. ';
        alert(str);
        return false;
    }
<%
    } else {
%>
    if(dif2 < 0) {
        str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이전 1개월 내에 신청할 수 있습니다. ';
        //str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
        alert(str);
        return false;
    }
<%
    }
%>


    // 경조발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다.
    event_CONG_DATE(document.form1.CONG_DATE);
    // 경조발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다.

    document.form1.BEGDA.value = begin_date;
    document.form1.CONG_DATE.value = congra_date;
    document.form1.CONG_WONX.disabled = 0;//경조금액 활성화
    document.form1.RELA_CODE.disabled = 0;//경조대상자 관계 활성화
    document.form1.EREL_NAME.disabled = 0;//경조대상자성명 활성화
    buttonDisabled();
    return true;
}

//경조대상자 관계코드 값에 따른 Action
function rela_action(obj) {
    var val = obj[obj.selectedIndex].value;//DREL_CODE
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    
    if ( "<%= PERNR_Data.E_RECON %>" == "D" && !(val == "0001" && (disa == "0003"||disa == "0007"))  ) {  // 사망퇴직이고 조위-본인이 아닐경우는 신청 못하도록 함.
        alert("사망 퇴직자는 조위-본인과 화환-본인만 경조금 신청할 수 있습니다.");
        document.form1.RELA_CODE[0].selected = true;
       
        return false;
    } 
    
    if ( "<%= PERNR_Data.E_RECON %>" == "S" && !(val == "0001" && disa == "0001")  ) {  // 여사원퇴직이고 결혼-본인이 아닐경우는 신청 못하도록 함.
        alert("미혼 여사원 퇴직자는 결혼-본인만 경조금 신청할 수 있습니다.");
        document.form1.RELA_CODE[0].selected = true;
        
        return false;
    }
    //C20130304_83585 경조쌀화환:0010

    if( disa == "0006" || disa == "0007"|| disa == "0010"  ){  //돌반지,  화환일 경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
        document.form1.CONG_WONX.disabled = 0;//경조금액 활성화
        document.form1.CONG_WONX.style.border = "1 solid #CCCCCC";
        document.form1.CONG_WONX.style.backgroundColor = "#FFFFFF";
        if( disa == "0007" ){ //화환  
          document.form1.CONG_WONX.value = insertComma("120000"+"");
        }else if( disa == "0010" ){ //경조쌀화환  
          document.form1.CONG_WONX.value = insertComma("160000"+"");
        }else {
          document.form1.CONG_WONX.value = " 금액을 입력해 주세요         ";
        }
<%
    for( int i = 0 ; i < E19CongcondData_rate.size() ; i++ ) {
        E19CongcondData data_rate = (E19CongcondData)E19CongcondData_rate.get(i);
%>
    } else if( val == "<%=data_rate.RELA_CODE%>" && disa == "<%=data_rate.CONG_CODE%>" ){
        document.form1.CONG_RATE.value = "<%=data_rate.CCON_RATE%>";//지급율 %

//      2002.07.03. 조위이면서 부모, 배우자부모일경우에는 일수가 아닌 text를 보여준다. 요청자 : 성경호, 수정자 : 김도신
        if( disa == "0003" && (val == "0002" || val == "0003") ) {
            document.form1.HOLI_TEXT.value  = "Help 참조　　　　";
            document.form1.HOLI_TEXT1.value = "";
//      2002.07.03. 조위이면서 부모, 배우자부모일경우에는 일수가 아닌 text를 보여준다. 요청자 : 성경호, 수정자 : 김도신
        } else {
            document.form1.HOLI_TEXT.value  = "<%=data_rate.HOLI_CONT.equals("") ? "" : WebUtil.printNum(data_rate.HOLI_CONT)%>";
            document.form1.HOLI_TEXT1.value = "일";
        }
        document.form1.HOLI_CONT.value = "<%=data_rate.HOLI_CONT.equals("") ? "" : WebUtil.printNum(data_rate.HOLI_CONT)%>";//경조휴가일수
        document.form1.CONG_WONX.value = cal_money();//계산된 경조금
<%
    }
%>
    }

    document.form1.EREL_NAME.value=""; //[CSR ID:C20120323_76012 ]    
    //@v1.9
    //if( document.form1.RELA_CODE.value != "" ){
    //   check1.style.display = "block";
    //} else{
    //   check1.style.display = "none";
    //}   
}

// 경조발생일자 변경에 따른 Action - 돌반지는 재계산하지 않는다.
function rela_action_1(obj) {
    var val = obj[obj.selectedIndex].value;//DREL_CODE
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    
    //돌반지, 화환일 경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
    //C20130304_83585 경조쌀화환:0010 160000만원고정
    if( disa == "0006" || disa == "0007" || disa == "0010"  ){ 
        // -------------
<%
    for( int i = 0 ; i < E19CongcondData_rate.size() ; i++ ) {
        E19CongcondData data_rate = (E19CongcondData)E19CongcondData_rate.get(i);
%>
    } else if( val == "<%=data_rate.RELA_CODE%>" && disa == "<%=data_rate.CONG_CODE%>" ){
        document.form1.CONG_RATE.value = "<%=data_rate.CCON_RATE%>";//지급율 %
        document.form1.HOLI_CONT.value = "<%=data_rate.HOLI_CONT.equals("") ? "" : WebUtil.printNum(data_rate.HOLI_CONT)%>";//경조휴가일수
        document.form1.CONG_WONX.value = cal_money();//계산된 경조금
<%
    }
%>
    }
}

function chk_limit(obj) {
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    var val = removeComma(obj.value);
    var val_int = Number(val);
    if( isNaN(val_int) ) {
        //obj.value = "";
        return;
    }

    if ( disa == "0006" ) {
        if( val_int > 100000 ) {
            alert('돌반지의 경조금액은 100,000 원을 넘지 못합니다.');
            obj.focus();
            obj.select();
            return;
        }
    } else if ( disa == "0007" ) {
        if( val_int > 120000 ) {
            alert('화환은 120,000 원을 넘지 못합니다.');
            obj.focus();
            obj.select();
            return;
        }
    } else if ( disa == "0010" ) { //C20130304_83585 경조쌀화환:0010
        if( val_int > 160000 ) {
            alert('쌀화환은 160,000 원을 넘지 못합니다.');
            obj.focus();
            obj.select();
            return;
        }
    }

    obj.value = insertComma(money_olim(val_int)+"");
}

//LG화학, LG석유화학 구분없이 1000 미만 단수절상
function money_olim(val_int){
    var money = 0;
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    //C2004011301000000544. mkbae.
    if(disa == "0006") {
        money = val_int;
    } else {
        money = olim(val_int, -3);
    }
    return money;
}

//경조금 계산(근속년수가 LG화학-1년미만, LG석유화학-6개월미만 시 지급율의 50%를 지급)
function cal_money(){
    var money = 0 ;
    var rate = 0;
    var wage = 0;
    var compCode = 0;

    rate = Number(document.form1.CONG_RATE.value);
    //wage = Number(document.form1.WAGE_WONX.value);
    //@v1.4 
    wage = Number(removeComma(document.form1.WAGE_WONX.value));
    
    //wage = Number("<%=e19CongcondData.WAGE_WONX%>");
    
    money = ( rate * wage )/100;
    compCode = "<%=user.companyCode%>";
    WORK_YEAR = Number(document.form1.WORK_YEAR.value);
    WORK_MNTH = Number(document.form1.WORK_MNTH.value);

    if( (compCode=="C100") && (WORK_YEAR < 1) ){//LG화학-1년미만
        money = money * 0.5 ;
        r_val = document.form1.CONG_RATE.value;
        document.form1.CONG_RATE.value = Number(document.form1.CONG_RATE.value) * 0.5 ;//지급율 % 도 50%로
    } else if( (compCode=="N100") && (WORK_YEAR < 1) && (WORK_MNTH < 6) ){//LG석유화학-6개월미만
        money = money * 0.5 ;
        document.form1.CONG_RATE.value = Number(document.form1.CONG_RATE.value) * 0.5 ;//지급율 % 도 50%로
    } else if(compCode != "C100" && compCode != "N100" ) {
        alert("회사코드를 얻지 못했습니다. 관리자에게 문의해주세요.");
        history.back();
    }
    money = money_olim(money);
    money = insertComma(money+"");
    return money;
}

function reset_Rate() {//
    document.form1.CONG_RATE.value  = "";//지급율 %
    document.form1.CONG_WONX.value  = "";//경조금액
    document.form1.HOLI_CONT.value  = "";//경조휴가일수
    document.form1.HOLI_TEXT.value  = "";//경조휴가일수 TEXT
    document.form1.HOLI_TEXT1.value = "";//경조휴가일수 일 TEXT

    document.form1.CONG_WONX.disabled = 1;
    document.form1.CONG_WONX.style.backgroundColor = "#EDEDED";
    document.form1.CONG_WONX.style.border = "1 solid #ECECEC";
}

function view_Rela(obj) {
    reset_Rate();//계산부분 reset

    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    
    if ( disa == "0007" ) {  // 화환일 경우만 부서계좌번호를 보여주고 입력할 수 있도록 함.
        <%  if ("Y".equals(user.e_representative) ) {  // 부서서무 담당일때  %>
        bubank.style.display = "block";
        document.form1.LIFNR[0].selected = true;
        <%  } else {  %>
		alert("화환은 부서담당이 대행 신청합니다.");
        document.form1.CONG_CODE.focus();
        document.form1.CONG_CODE[0].selected = true;
        document.form1.RELA_CODE[0].selected = true;
		return;
		<%  }  %>
    } else {
        bubank.style.display = "none";
    }

    var val = obj[obj.selectedIndex].value;//DISA_CODE 값
<%
    int inx = 0;
    String before = "";
    for( int i = 0 ; i < E19CongcondData_opt.size() ; i++ ) {
        E19CongcondData data = (E19CongcondData)E19CongcondData_opt.get(i);
        if( before.equals(data.CONG_CODE) ) {
          inx++;
%>
        document.form1.RELA_CODE.length = <%= inx %>;
        document.form1.RELA_CODE[<%= inx-1 %>].value = "<%=data.RELA_CODE%>";
        document.form1.RELA_CODE[<%= inx-1 %>].text  = "<%=data.RELA_NAME%>";
<%
        } else {
            inx = 2;
            if( i == 0 ) {
%>
    if( val == "<%=data.CONG_CODE%>" ) {
        document.form1.RELA_CODE.length = <%= inx %>;
        document.form1.RELA_CODE[<%= inx-1 %>].value = "<%=data.RELA_CODE%>";
        document.form1.RELA_CODE[<%= inx-1 %>].text  = "<%=data.RELA_NAME%>";
<%
            } else {
%>
    }else if( val == "<%=data.CONG_CODE%>" ) {
        document.form1.RELA_CODE.length = <%= inx %>;
        document.form1.RELA_CODE[<%= inx-1 %>].value = "<%=data.RELA_CODE%>";
        document.form1.RELA_CODE[<%= inx-1 %>].text  = "<%=data.RELA_NAME%>";
<%
            }
            before = data.CONG_CODE;
        }
    }
%>
    }

    if( val == "" ) {
        document.form1.RELA_CODE.length = 1;
    }
    document.form1.RELA_CODE[0].selected = true;
}

function view_Lifnr(obj) {
  var Lifnr_V = obj.value;
  var sIndex = obj.selectedIndex;
  var SearchFlag = false;
  <%
  E19CongLifnrRFC rfc_List         = new E19CongLifnrRFC();
  Vector E19CongLifnr_vt = null;
  if (e19CongcondData.PERNR!=null||!e19CongcondData.PERNR.equals("")) {
    E19CongLifnr_vt = rfc_List.getLifnr(user.companyCode, e19CongcondData.PERNR, "2");
  } else {
    E19CongLifnr_vt = rfc_List.getLifnr(user.companyCode, user.empNo, "2");
  }
    for( int i = 0 ; i < E19CongLifnr_vt.size() ; i++ ) {
        E19CongcondData data = (E19CongcondData)E19CongLifnr_vt.get(i);
   %>
        if( Lifnr_V == "<%=data.LIFNR%>" ) {
          document.form1.BANK_NAME.value = "<%=data.BANKA %>";
          document.form1.BANKN.value = "<%=data.BANKN %>";
          SearchFlag = true;
        } else if( Lifnr_V =="" ) {
          document.form1.BANK_NAME.value = "";
          document.form1.BANKN.value = "";
        }
   <%
    }
   %>
//    if (!SearchFlag)
//    if (<%=E19CongLifnr_vt.size()+1%>!=obj.length)
    if (document.form1.p_BANKN_SEARCHGUBN.value == "SEARCH")
       ifHidden.view_LifnrDept(obj.value,sIndex); //@v1.1
    
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%=WebUtil.ServletURL%>hris.E.E19Congra.E19CongraBuildSV";
    frm.target = "";
    frm.submit();
}

function firstHideshow() {
    bubank.style.display = "none";
}

//@v1.1 start부서계좌를 가지고 있는 사람 검색
function deptbank_search()
{
    val1 = document.form1.DEPT_NAME.value;
    val1 = rtrim(ltrim(val1));

    if ( val1 == "" ) {
        alert("검색할 성명을 입력하세요!");
        document.form1.DEPT_NAME.focus();
        return;
    } else {
        if( val1.length < 2 ) {

            alert("검색할 성명을 한 글자 이상 입력하세요!")
            document.form1.DEPT_NAME.focus();
            return;
        } // end if
    } // end if

    document.form1.target = "ifHidden";
    document.form1.action = "<%=WebUtil.JspURL%>E/E19Congra/E19HiddenLifnrByEname.jsp";
    document.form1.submit();
} // @v1.1 end function

//@v1.9[CSR ID:1225704]
function fn_relaNmPOP() {

    var win = window.open("","family","width=550,height=400,left=365,top=70,scrollbars=yes");

    frm =  document.family;
    frm.PERNR.value = "<%=e19CongcondData.PERNR%>"; 
    frm.OBJ.value   = "form1.EREL_NAME"; 
    frm.CONG_CODE.value = document.form1.CONG_CODE.value ;
    frm.RELA_CODE.value = document.form1.RELA_CODE.value ;
    
    frm.action = "<%=WebUtil.JspURL%>"+"E/E19Congra/E19CongraFamily_pop.jsp";
    frm.target = "family";
    frm.submit();
    win.focus();

  //var url="<%=WebUtil.JspURL%>"+"E/E19Congra/E19CongraFamily_pop.jsp?PERNR="+"<%=e19CongcondData.PERNR%>";
  var win = window.open("","family","width=680,height=480,left=365,top=70,scrollbars=auto");
  win.focus();

}
function openDocPOP() {
  //var url="<%=WebUtil.JspURL%>"+"E/E19Congra/E19CongraFamily_pop.jsp?PERNR="+"<%=e19CongcondData.PERNR%>";
  //var url="<%=WebUtil.JspURL%>"+"A/A12Family/A12FamilyBuild.jsp";
  var url= "<%=WebUtil.ServletURL%>hris.A.A12Family.A12FamilyBuildSV?SCREEN=E19" ;
  var win = window.open(url,"family","width=780,height=480,left=365,top=70,scrollbars=yes");
  //openDoc('1012','1007','/servlet/hris.A.A12Family.A12FamilyBuildSV')
  win.focus();

}
<!-- 경조발생일자 기준의 근속년월을 가져오기 ------------------------------------------>
<!--
function after_event_CONG_DATE(){
    event_CONG_DATE(document.form1.CONG_DATE);
}
function event_CONG_DATE(obj){

    if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() ){
        document.form3.CONG_DATE.value = removePoint(document.form1.CONG_DATE.value);
        //@v1.9
        document.form3.CONG_CODE.value = removePoint(document.form1.CONG_CODE.value);
        document.form3.RELA_CODE.value = removePoint(document.form1.RELA_CODE.value);
        document.form3.action="<%=WebUtil.JspURL%>E/E19Congra/E19Hidden4WorkYear.jsp";
        document.form3.target="ifHidden";
        document.form3.submit();
    }
    

}
function chkInvalidDate(){
    //경조사 발생 3개월초과시 에러처리
    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);

    betw = getAfterMonth(addSlash(congra_date), 3);
    dif = dayDiff(addSlash(begin_date), addSlash(betw));

    betw2 = getAfterMonth(addSlash(begin_date), 1);
    dif2 = dayDiff(addSlash(congra_date), addSlash(betw2));

    dif3 = begin_date - congra_date;

    if ( "<%= PERNR_Data.E_RECON %>" == "" ) {  // 퇴직자가 아닐때
        //@v1.3
        if( "<%=Except3Month%>" != "Y" &&  dif < 0){
            str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이후 3개월까지만 신청할 수 있습니다. ';
            alert(str);
            return false;
        }
    } else {
        var reday = "<%= PERNR_Data.E_REDAY %>";
        betwR = getAfterMonth(addSlash(reday), 3);
        difR  = dayDiff(addSlash(congra_date), betwR);
        if("<%=Except3Month%>" != "Y" && difR < 0){
            str = '        경조를 신청할수 없습니다.\n\n 퇴직일 이후 3개월까지만 신청할 수 있습니다. ';
            alert(str);
            return false;
        }
        
    }
  
<%
    if( user.companyCode.equals("C100") ) {
%>
    var disadif = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    dif9 = dayDiff(addSlash(congra_date), addSlash(begin_date)); //CSR ID:1225704
   
    //if( "<%= PERNR_Data.E_RECON %>" != "D" && "<%= PERNR_Data.E_RECON %>" != "S" && disadif != "0007" && dif3 < 0 ){
    if( "<%= PERNR_Data.E_RECON %>" != "D" && "<%= PERNR_Data.E_RECON %>" != "S" && disadif != "0007" && dif9 < -7 ){
        str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이전에 신청할 수 없습니다. ';
        alert(str);
        return false;
    }
    
<%
    } else {
%>
    if(dif2 < 0) {
        str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이전 1개월 내에 신청할 수 있습니다. ';
        //str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
        alert(str);
        return false;
    }
<%
    } //end if
%>

    return true;
}
//-->
<!-- 경조발생일자 기준의 근속년월을 가져오기 ---------------------------------------------------------------------->

//가족목록 팝업이 닫힐때
function openerPutLNMHG(LNMHG){
document.form1.LNMHG.value = LNMHG; 
} 

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:firstHideshow();">
<form name="form1" method="post">
  <input type="hidden" name = "PERNR" value="<%=e19CongcondData.PERNR%>">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780">
             <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">경조금 신청</td>
                  <td align="right"><a href="javascript:open_rule('Rule02Benefits06.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','<%= WebUtil.ImageURL %>btn_rule_on.gif',1)"><img name="Image5" border="0" src="<%= WebUtil.ImageURL %>btn_rule_off.gif" width="90" height="15" alt="제도안내"></a><a href="javascript:open_help('E19Congra.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr>
           <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>      
          </tr>
<%
    if ("Y".equals(user.e_representative) ) {
%>

          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons_R.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    }
%>

<%  //@v1.5
    //if (  ( ( (user.e_persk.equals("32")||user.e_persk.equals("33") ) && !"Y".equals(user.e_representative) ) || (PERNR_Data.E_PERSK.equals("32")||PERNR_Data.E_PERSK.equals("33") ) ) && Integer.parseInt(DataUtil.getCurrentDate()) >= 20060616 &&  Integer.parseInt(DataUtil.getCurrentDate())  < 20060623 ) { 
    String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( PERNR_Data.E_PERNR );
    
    if (O_CHECK_FLAG.equals("N") ) {

%>            
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="left">
                           <font color="red">※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.<br><br></font><!--@v1.1-->
                         </td>
                      </tr>
                                      <tr id="bubank"></tr>
            <!--  HIDDEN  처리해야할 부분 시작-->
            <input type="hidden" name="jobid"       value="">
            <input type="hidden" name="AINF_SEQN"   value="<%= e19CongcondData.AINF_SEQN %>">
            <input type="hidden" name="fromJsp"     value="E19CongraBuild.jsp">
            <input type="hidden" name="checkSubmit" value="">
            <input type="hidden" name="AccountData_pers_RowCount" value="<%=AccountData_pers_vt.size()%>">

                    </table>
<% } else {  //@v1.5 else %>            

<%
    if ( PERNR_Data.E_RECON.equals("Y") ) {  // 2005.04.14 수정 - 일반 퇴직은 신청 못한다.
%>
          <tr> 
            <td> 
              <table width="780" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                  <td class="td04"><table width="780" border="0" cellspacing="1" cellpadding="5" class="table01">
                      <tr> 
                        <td align="center" class="tr01"><br>
                          퇴직자는 신청할 수 없습니다.<br><br>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr id="bubank"></tr>
              </table>
            </td>
          </tr>     
<%
    //} else if ( PERNR_Data.E_WERKS.equals("EC00") ) {  // 2005.04.13 수정 - 해외법인(EC00)일 경우는 본인신청, 대리신청 못하도록 함.
    //} else if (!"Y".equals(user.e_representative) && PERNR_Data.E_WERKS.equals("EC00") ) {  // @v1.6임시로 품
    //} else if (PERNR_Data.E_WERKS.equals("EC00") && !user.empNo.equals("00071246") ) {  // @v1.6임시로 품
%>          
   <!--       <tr> 
            <td> 
              <table width="780" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                  <td class="td04"><table width="780" border="0" cellspacing="1" cellpadding="5" class="table01">
                      <tr> 
                        <td align="center" class="tr01"><br>
                          해외법인의 경우 해당 인사부서를 통해 신청하시기 바랍니다.<br><br>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr id="bubank"></tr>
              </table>
            </td>
          </tr>    -->     
<%
    } else {
%>
          <tr>
            <td>
              <!-- 상단 입력 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr>
                  <td class="tr01" width="330">
                    <table width="330" border="0" cellspacing="1" cellpadding="1">
                      <tr>
                        <td width="104" class="td01">신청일</td><td class="td09" colspan="2">
                        <input type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>"  size="16" class="input04" readonly></td>
                      </tr>
                      <tr>
                        <td class="td01">경조내역&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09">
                          <select name="CONG_CODE" class="input03" onChange="javascript:view_Rela(this);">
                            <option value="">-------------</option>
                              <!-- 경조내역 option @v1.2 -->
                            <% if ( !PERNR_Data.E_PERSK.equals("33") ) { %>
                              <%=  e19CongcondData.CONG_CODE.equals("") ? WebUtil.printOption((new E19CongCodeNewRFC()).getCongCode(user.companyCode,"")) : WebUtil.printOption((new E19CongCodeNewRFC()).getCongCode(user.companyCode,""), e19CongcondData.CONG_CODE )%>
                            <% } else { //기능직만 돌반지신청가능 %>
                              <%=  e19CongcondData.CONG_CODE.equals("") ? WebUtil.printOption((new E19CongCodeRFC()).getCongCode(user.companyCode)) : WebUtil.printOption((new E19CongCodeRFC()).getCongCode(user.companyCode), e19CongcondData.CONG_CODE )%>
                            <% } %>
                              <!-- 경조내역 option -->
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td class="td01">경조대상자 관계&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09" colspan="2">
                          <select name="RELA_CODE" class="input03" onChange="javascript:rela_action(this);">
                            <option value="">-------------</option>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td class="td01">경조대상자 성명&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09" colspan="2">
                          <table width=100% border="0" cellspacing="0" cellpadding="0">
                             <tr>
                             
                             <td width=55%><input type="text" name="EREL_NAME" value="<%= e19CongcondData.EREL_NAME %>" size="16" class="input04" style="ime-mode:active" readonly></td>
                             <!--[CSR ID:1225704]-->
                             <td width=45% align=left>
                             <a href="javascript:fn_relaNmPOP()" id="check1" style="display:block"><img src="<%= WebUtil.ImageURL %>btn_search_e19.gif" align="absmiddle" width=103 height=19 border="0" alt="가족검색"></a>
                            </td>
                             </tr>
                          </table>
                      </td>
                      </tr>
                      
                      <tr>
                        <td class="td01">경조발생일자&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09" colspan="2">
                          <input type="text" name="CONG_DATE" value="<%= e19CongcondData.CONG_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(e19CongcondData.CONG_DATE) %>" size="16" class="input03" onBlur="event_CONG_DATE(this);">
                          <!-- 날짜검색-->
                          <a href="javascript:fn_openCal('CONG_DATE','after_event_CONG_DATE()')">
                          <img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="날짜검색">
                          </a>
                          <!-- 날짜검색-->
                        </td>
                      </tr>
                    </table>
                  </td>
                  <td class="tr01" >
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="left">
<%  //@v2.0
   // if ( (webUserID.equals("EADMIN") || webUserID.equals("EMANAG") )) {
%>     
<!--                           <a href="javascript:parent.left.openDoc('1012');parent.left.hideIMG('1012')">  
                           <img src="<%= WebUtil.ImageURL %>btn_search2_e19.gif" align="absmiddle" border="0" ></a>
                           <br><br>-->
<%  //} else { //@v1.7%>
<!--                           <a href="javascript:openDoc('1012','1007','/servlet/hris.A.A12Family.A12FamilyBuildSV')">  
                           <img src="<%= WebUtil.ImageURL %>btn_search2_e19.gif" align="absmiddle" border="0" ></a>
                           <br><br>-->
<%  //} //@v1.7%>
                           <a href="javascript:openDocPOP()">  
                           <img src="<%= WebUtil.ImageURL %>btn_search2_e19.gif" align="absmiddle" border="0" ></a>
                           <br><br>
                          <font color="#CC3300">※</font> 경조금 신청은 경조사 발생 7일 이전부터 이후 3개월까지 신청하고, <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;경조휴가는 경조일을 포함하여 연속해 사용하시기 바랍니다.<br><br>
                           <font color="#CC3300">※</font> 경조금 지급기준 적용시 유의사항<br>
                                         &nbsp;- 조부모상/백숙부모상(큰아버지,큰어머니,작은아버지,작은어머니)의 경우<br>
                                         &nbsp;&nbsp;&nbsp;&nbsp;친가에 한하여 지원하며, 외가에는 지원되지 않음.<br>
                                         &nbsp;- 재혼인 경우 본인에 한해서 가능함.<!-CSR ID:2094498-->
                         </td>                  
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
            </tr>
            <tr><td height="10">&nbsp;</td></tr>
            <tr>
              <td class="tr01">
                <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">

 <%
                //대리신청시
		if ( user.empNo.equals( PERNR_Data.E_PERNR ) ) {
%>

				<tr>
                  <td width="100" class="td01">통상임금</td>
                  <td class="td09"> <input type="text" name="WAGE_WONX" value="<%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%>" style="text-align:right" size="20" class="input04" readonly>
                    원 </td>
                  <td class="td01">지급율</td>
                  <td class="td09"><input type="hidden" name="xCONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" >
                    <input type="text" name="CONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" class="input04" size="20" style="text-align:right" readonly>
                    % </td>
                </tr>
		<tr>
                  <td class="td01">경조금액</td>
                  <td colspan="3" class="td09"> 

                    <input type="text" name="CONG_WONX" value="<%=e19CongcondData.CONG_WONX.equals("") ? "" : WebUtil.printNumFormat(e19CongcondData.CONG_WONX)%>" size="20" class="input04" style="text-align:right" 
					onKeyUp="javascript:moneyChkEventForWon(this);" onBlur="javascript:chk_limit(this);" onFocus="this.select();" disabled>
                    원 </td>
                </tr>

<% } else { %>

                  <input type="hidden" name="WAGE_WONX" value="<%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%>" style="text-align:right" size="20" class="input04" readonly>
                  <input type="hidden" name="xCONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" >
                  <input type="hidden" name="CONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" class="input04" size="20" style="text-align:right" readonly>
                  <input type="hidden" name="CONG_WONX" value="<%= e19CongcondData.CONG_WONX %>" class="input04" size="20" style="text-align:right" readonly>
<%
    }
%>
                <tr>
                  <td class="td01">이체은행명</td>
                  <td class="td09" width="255"> <input type="text" name="BANK_NAME" value="<%= e19CongcondData.BANK_NAME %>" size="20" class="input04" readonly>
                  </td>
                  <td class="td01" width="100">은행계좌번호</td>
                  <td class="td09" width="254"> <input type="text" name="BANKN" value="<%= e19CongcondData.BANKN %>" size="20" class="input04" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td01">경조휴가일수</td>
                  <td class="td09"> <input type="text" name="HOLI_TEXT" value="<%= e19CongcondData.HOLI_CONT.equals("") ? "" : WebUtil.printNum(e19CongcondData.HOLI_CONT) + " 원" %>" size="15" class="input04" style="text-align:right" readonly>
                    <input type="text" name="HOLI_TEXT1" value="" size="15" class="input02" style="text-align:left;border:1" readonly>
                    <input type="hidden" name="HOLI_CONT" value="<%= e19CongcondData.HOLI_CONT.equals("") ? "" : WebUtil.printNum(e19CongcondData.HOLI_CONT) %>" size="10" class="input04" style="text-align:right" readonly>
                  </td>
                  <td class="td01">근속년수</td>
                  <td class="td09"><input type="text" name="WORK_YEAR" value="<%= ( e19CongcondData.WORK_YEAR.equals("") || e19CongcondData.WORK_YEAR.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>" class="input04" size="7" style="text-align:right" readonly>
                    년
                    <input type="text" name="WORK_MNTH" value="<%= ( e19CongcondData.WORK_MNTH.equals("") || e19CongcondData.WORK_MNTH.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>" size="8" class="input04" style="text-align:right" readonly>
                    개월</td>
                </tr>
                <tr id="bubank">
                  <td class="td01">부서계좌번호&nbsp;<font color="#006699"><b>*</b></font></td>
                  <td class="td09" colspan="3">
                    <!-- @v1.1 -->
                    <input type="text" name="DEPT_NAME" value="" size="16" class="input03" style="ime-mode:active">
                    &nbsp;<a href="javascript:deptbank_search()">
                    <img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="부서계좌검색">
                    </a>&nbsp;&nbsp;                          
                    <select name="LIFNR" class="input03" onChange="javascript:view_Lifnr(this);">
                      <option value="">-------------------</option>
   <%                   
    for( int i = 0 ; i < E19CongLifnr_vt.size() ; i++ ) {
        E19CongcondData data = (E19CongcondData)E19CongLifnr_vt.get(i);
   %>
        <option value="<%=data.LIFNR%>"><%=data.LIFNR%><%=data.NAME1 %>(<%=data.BVTXT %>)</option>
   <%
    }
   %>                      
                    </select>                  
                  </td>
                </tr>
              </table>
              </td>
            </tr>
            <tr>
              <td class="td09">
                <font color="#006699"><b>&nbsp;*</b> 는 필수 입력사항입니다.</font>
              </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>
                <table width="780" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 결재정보</td>
                  </tr>
                </table></td>
            </tr>
            <tr>
              <td>
              <!-- 결재자 입력 테이블 시작-->
              <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,e19CongcondData.PERNR) %>
              <!-- 결재자 입력 테이블 End-->
              </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>
                <table width="780" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="center">
                      <span id="sc_button"><a href="javascript:doSubmit();"><img src="<%= WebUtil.ImageURL %>btn_build.gif" name="image" align="absmiddle" border="0"></a></span>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
<%
    }  // end if 2005.04.13 수정 - 해외법인(EC00)일 경우는 본인신청, 대리신청 못하도록 함.
%>            
            <!--  HIDDEN  처리해야할 부분 시작-->
            <input type="hidden" name="jobid"       value="">
            <input type="hidden" name="AINF_SEQN"   value="<%= e19CongcondData.AINF_SEQN %>">
            <input type="hidden" name="fromJsp"     value="E19CongraBuild.jsp">
            <input type="hidden" name="checkSubmit" value="">
            <input type="hidden" name="AccountData_pers_RowCount" value="<%=AccountData_pers_vt.size()%>">
<%
    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    for(int i = 0 ; i < AccountData_pers_vt.size() ; i++){
        AccountData data_vt = (AccountData)AccountData_pers_vt.get(i);//은행계좌번호 BANKN , 은행명 BANKA
%>
            <input type="hidden" name="p_LIFNR<%= i %>" value="<%= data_vt.LIFNR %>">
            <input type="hidden" name="p_BANKN<%= i %>" value="<%= data_vt.BANKN %>">
            <input type="hidden" name="p_BANKA<%= i %>" value="<%= data_vt.BANKA %>">
            <input type="hidden" name="p_BANKL<%= i %>" value="<%= data_vt.BANKL %>">
<%
    }  // end for
%>
            <!--  HIDDEN  처리해야할 부분 끝-->
           </table>
         </td>
       </tr>
     </table>
   </td>
 </tr>
 <% } //@v1.5 end %>              

</table>
      <input type="hidden" name = "p_BANKN"  value="">
      <input type="hidden" name = "p_SWITCH" value="1">
      <input type="hidden" name = "P_PERNR" value="<%=e19CongcondData.PERNR%>">
      <input type="hidden" name = "p_BANKN_SEARCHGUBN"  value="">
      <input type="hidden" name = "REGNO"   value="">
      <input type="hidden" name="LNMHG" value=""><!--대상자姓:가족목록팝업에서선택한대상자의성 -->
      <input type="hidden" name="PER_LNMHG" value="<%=PERNR_Data.E_ENAME.substring(0,1 )%>"><!--신청자성-->

  </form>
  <form name="form3" method="post">
      <input type="hidden" name = "CONG_DATE" value="">
      <!--@v1.9-->
      <input type="hidden" name = "CONG_CODE" value="">
      <input type="hidden" name = "RELA_CODE" value="">
      <!--@v1.9-->
      <input type="hidden" name = "PERNR" value="<%=e19CongcondData.PERNR%>">
  </form>
  
  <!--@v1.9-->
  <form name="family" method="post">
      <input type="hidden" name = "PERNR" value="">  
      <input type="hidden" name = "OBJ"   value="">
      <input type="hidden" name = "CONG_CODE" value="">  
      <input type="hidden" name = "RELA_CODE"   value="">
      <input type="hidden" name = "PersonData"   value="<%=PERNR_Data%>">
  </form>
  <!--@v1.9-->
  
  <form name="test" method="post">
      <input type="hidden" name = "user" value="<%=user.empNo%>">
      <input type="hidden" name = "user" value="<%=user.e_persk%>">
      <input type="hidden" name = "E_ENAME" value="<%=PERNR_Data.E_ENAME%>">
      <input type="hidden" name = "E_PERSK" value="<%=PERNR_Data.E_PERSK%>">
  </form>
  
<iframe name="ifHidden" width="0" height="0" />
<%@ include file="/web/common/commonEnd.jsp" %>
