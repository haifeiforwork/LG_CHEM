<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 수정                                                 */
/*   Program ID   : E17HospitalChange.jsp                                       */
/*   Description  : 의료비를 수정할 수 있도록 하는 화면                         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김성일                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                  2005-12-26  @v1.1 C2005121301000001097 신용카드/현금구분추가*/
/*   Update       : 2007-02-23  @v1.2 구체적증상 체크로직에 추가                */
/*                : 2008-07-01  @v1.5 CSR ID:1290227 배우자/자녀한도 300만원 → 500만원 */
/*                  2014-08-08  이지은D [CSR ID:2589455] (SAP DB 암호화 관련) e-HR 임직원 신청 정보 중 '질병' 정보 입력 시 [*] 입력방지 시스템 로직 보완 건   */
/*                  2014-08-26  이지은D [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원 */
/*                  2015-07-31  이지은D [CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가 */
/*                  2015-08-19  이지은D [CSR ID:2849361] 사내부부 의료비관룐의 건 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>

<%
    WebUserData user               = (WebUserData)session.getAttribute("user");

    String      last_RCPT_NUMB     = (String)request.getAttribute("last_RCPT_NUMB");
    Vector      E17HospitalData_vt = (Vector)request.getAttribute("E17HospitalData_vt");
    Vector      E17BillData_vt     = (Vector)request.getAttribute("E17BillData_vt");
    Vector      AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");
    E17SickData e17SickData        = (E17SickData)request.getAttribute("e17SickData");
//    String      P_Flag             = (String)request.getAttribute("P_Flag");
    String      COMP_sum           = (String)request.getAttribute("COMP_sum");
    String      CompanyCoupleYN           = (String)request.getAttribute("CompanyCoupleYN");	//[CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가
    double     COMP_sum_d         = 0.0;

    String RequestPageName = (String)request.getAttribute("RequestPageName");

    if( COMP_sum != null && !COMP_sum.equals("") ) {
        COMP_sum_d         = Double.parseDouble( COMP_sum );
    } else {
        COMP_sum = "";
    }

    DataUtil.fixNull(e17SickData);

//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e17SickData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다

    int last_num = 0;
    if( last_RCPT_NUMB != null && !last_RCPT_NUMB.equals("") ) {
        last_num = Integer.parseInt(last_RCPT_NUMB);
    }
    int medi_count = 5;
    if( E17HospitalData_vt.size() > medi_count ) {
        medi_count = E17HospitalData_vt.size();
    }
    if( e17SickData.medi_count != null && ! e17SickData.medi_count.equals("") ){
        medi_count = Integer.parseInt(e17SickData.medi_count) ;
    }

//  2003.03.14 배우자 공제한도 예외자 CHECK 로직 추가 - 예외자(E_FLAG = 'Y')는 공제한도를 CHECK하지 않는다.
//             - PAGE이동시마다 데이터를 가지고 다녀야해서 .JSP에서 조회함.
    E17MedicCheckYNRFC checkYN = new E17MedicCheckYNRFC();

    String E_FLAG = checkYN.getE_FLAG( DataUtil.getCurrentYear(), user.empNo );

    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
%>
<html>
<head>
<title>e-HR</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
/*관리번호 버튼 막기*/
function disable_radio(){/*onload 시 실행
/*document.form1.is_new_num.disabled = 1;*/
  document.form1.is_new_num[0].disabled = 1;
  document.form1.is_new_num[1].disabled = 1;
}

/*관리번호 버튼 풀기*/
function enable_radio(){
/*document.form1.is_new_num.disabled = 0;*/
  document.form1.is_new_num[0].disabled = 0;
  document.form1.is_new_num[1].disabled = 0;
}

/*수정*/
function do_change() {
    enable_radio();
    if( check_data() ) {
        if ( document.form1.PROOF.checked == true ) {
            document.form1.PROOF.value = "X";
        } else {
            document.form1.PROOF.value = "";
        }
        document.form1.jobid.value = "change";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E17Hospital.E17HospitalChangeSV";
        document.form1.method = "post";
        document.form1.submit();
    }
    disable_radio();
}

/*취소*/
function do_back() {
  location.href = "<%=WebUtil.ServletURL%>hris.E.E17Hospital.E17HospitalDetailSV?AINF_SEQN=<%= e17SickData.AINF_SEQN %>";
}

function chg_opt(obj){
    va = obj.name;
    val = Number(va.substring(9));
    eval("document.form1.x_EMPL_WONX"+val+".value = '';");
}

// 진료일중 가장 큰 건을 찾기위한 로직 (2005.06.01 이후 건에 대해서는 최초진료 금액한도를 10만원으로 처리하기 위한 작업)
var l_exam_date_max = 0;

/* 본인 실부담액 합계구하기 */
function multiple_won(gubun) {
    var hap = 0;
    var l_exam_date = 0;
    l_exam_date_max = 0;
    for( k = 0 ; k < <%=medi_count%> ; k++){
        val = eval("removeComma(document.form1.EMPL_WONX"+k+".value)");
        
        hap = hap + Number(val);

// 진료일중 가장 큰 건을 찾기위한 로직 (2005.06.01 이후 건에 대해서는 최초진료 금액한도를 10만원으로 처리하기 위한 작업)
        if( gubun == "Chk" ) {
            l_exam_date = eval("removePoint(document.form1.EXAM_DATE"+k+".value)");
            if( l_exam_date_max < l_exam_date ) {
                l_exam_date_max = l_exam_date;
            }
        }
// 진료일중 가장 큰 건을 찾기위한 로직 (2005.06.01 이후 건에 대해서는 최초진료 금액한도를 10만원으로 처리하기 위한 작업)
    }
    
    if( hap > 0 ) {
        if( document.form1.WAERS.value == "KRW" ) {
            hap = pointFormat(hap, 0);
        } else {
            hap = pointFormat(hap, 2);
        }

        document.form1.EMPL_WONX_tot.value = insertComma(hap+"");
    }else if( hap == 0 ){
        document.form1.EMPL_WONX_tot.value = "";
    }
}

/*최초/ 동일 진료 버튼 선택시 처리*/
/*onChange event 입원/외래
function chg_medi_code(num){
    inx = eval("document.form1.MEDI_CODE"+num+".selectedIndex;");
    eval("document.form1.MEDI_TEXT"+num+".value = document.form1.opt_MEDI_TEXT"+inx+".value;");
}
*/
/*onChange event 영수증 구분
function chg_rcpt_code(num){
    inx = eval("document.form1.RCPT_CODE"+num+".selectedIndex;");
    eval("document.form1.RCPT_TEXT"+num+".value = document.form1.opt_RCPT_TEXT"+inx+".value;");
}
*/

/*의료비 입력항목 1개 추가*/
function more_hospital_field(){
    siz = Number(document.form1.medi_count.value);
    if(siz >= 19) {
      alert("의료비 신청 입력항목을 더이상 늘일수 없습니다. \n\n 지금까지의 항목을 신청하시고 동일진료로 다시 추가해 주세요");
      return;
    }
    document.form1.RowCount_hospital.value = siz ;
    document.form1.medi_count.value = siz + 1 ;
    enable_radio();
    document.form1.jobid.value = "AddOrDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E17Hospital.E17HospitalChangeSV";
    document.form1.method = "post";
    document.form1.submit();
}

/*라디오버튼 선택된 의료비 입력항목 지우기*/
function remove_hospital_item(){
    siz = Number(document.form1.medi_count.value);
    if(siz <= 1) {
      alert("의료비 신청 입력항목을 더이상 줄일수 없습니다. ");
      return;
    }

    var command = "";
    var size = "";
    flag = false;
    if( isNaN( document.form1.radiobutton.length ) ){
      size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = "0";
            flag = true;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = i+"";
            flag = true;
        }
    }
    if( ! flag ){
        alert("삭제할 항목을 먼저 선택하세요");
        return;
    }else{
        document.form1.RowCount_hospital.value = siz;
        document.form1.medi_count.value = siz - 1 ;
        eval("document.form1.use_flag"+command+".value = 'N'");
    }
    enable_radio();
    document.form1.jobid.value = "AddOrDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E17Hospital.E17HospitalChangeSV";
    document.form1.method = "post";
    document.form1.submit();
}

/*진료비계산서 입력으루 가기*/
function go_bill(){

    var command = "";
    var size = "";
    flag = false;
    if( isNaN( document.form1.radiobutton.length ) ){
      size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = "0";
            flag = true;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = i+"";
            flag = true;
        }
    }
    if( ! flag ){
        alert("입력할 진료비계산서 항목을 먼저 선택하세요");
        return;
    }else{
        siz = Number(document.form1.medi_count.value);
        document.form1.RowCount_hospital.value = siz;
        document.form1.radio_index.value = command;
    }

    gubun = eval("document.form1.RCPT_CODE"+command+".value;");
    if( gubun != "0002" ){/*영수증 구분이 진료비계산서(0002) 가 아니면 에러*/
        alert("선택한 항목의 영수증은 진료비계산서가 아닙니다. \n\n  '영수증 구분'을 확인해 주세요");
        return;
    }

    enable_radio();
    document.form1.jobid.value = "change_first";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E17Hospital.E17BillControlSV";
        document.form1.method = "post";
        document.form1.submit();
}

/* check_data ********************************************************************************************* */
function check_data() {

//  상병명-30 입력시 길이 제한
    x_obj = document.form1.SICK_NAME;
    xx_value = x_obj.value;
    //@v1.3
    if( checkNull(document.form1.TREA_CODE, "진료과를") == false )  
        return false;  

    if( checkNull(x_obj, "상병명을") == false ) {
        return false;
    } else {
        if( xx_value != "" && checkLength(xx_value) > 30 ){
            alert("상병명은 한글 15자, 영문 30자 이내여야 합니다.");
            x_obj.focus();
            x_obj.select();
            return false;
        }
    }

//[CSR ID:2589455] *(42) 제거 로직 추가----------------------------
	var tmpText="";
    for ( var i = 0; i < xx_value.length; i++ ){
    	if(xx_value.charCodeAt(i) != 42){
          tmpText = tmpText+xx_value.charAt(i);
      }
    }
    x_obj.value = tmpText;
//-----------------------------------------------------------------

 /* 필수 입력값 .. 의료기관, 사업자등록번호, 진료일, 영수증 구분, 본인 실납부액 */
    hasNoData = true;
    chk_inx   = -1;
    for( inx = 0 ; inx < <%=medi_count%> ; inx++ ){
        medi_name =             eval("document.form1.MEDI_NAME"+inx+".value");
        medi_numb = removeResBar2(eval("document.form1.MEDI_NUMB"+inx+".value"));
        telx_numb = eval("document.form1.TELX_NUMB"+inx+".value");
        exam_date = removePoint(eval("document.form1.EXAM_DATE"+inx+".value"));
        empl_wonx =             eval("document.form1.EMPL_WONX"+inx+".value");
        if( medi_name == "" && medi_numb == "" && exam_date == "" && empl_wonx == "" ){
//          마지막에 입력한 의료기관 정보를 얻기위해서
            if( chk_inx < 0 && hasNoData == false ) {
                chk_inx = inx - 1;
            }
        }else if(medi_name != "" && medi_numb != "" && exam_date != "" && empl_wonx != ""){
            hasNoData = false;

//          2002.05.10. 의료기관 길이 제한 - 20자
            if( checkLength(medi_name) > 20 ){
                alert("의료기관명은 한글 10자, 영문 20자 이내여야 합니다.");
                eval("document.form1.radiobutton["+inx+"].checked = true;");
                return false;
            }
//          2002.05.10. 의료기관 길이 제한 - 20자
            if( checkLength(telx_numb) < 5 ){
                alert("전화번호는 5자 이상 입력 하셔야 합니다.");
                return false;
            }


 /* 진료계산서의 본인부담금액과 입력한 본인부담금액이 다르면 Error처리함 */
            gubunja = eval("document.form1.RCPT_CODE"+inx+".value;");
 /* alert(gubunja); */
            if( gubunja == "0002" ){
                int_empl_wonx     = eval("Number(removeComma(document.form1.EMPL_WONX"+inx+".value))");
                int_empl_wonx_tot = eval("Number(removeComma(document.form1.x_EMPL_WONX"+inx+".value))") +
                                    eval("Number(removeComma(document.form1.MEAL_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.APNT_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.ROOM_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.CTXX_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.MRIX_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.SWAV_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.ETC1_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.ETC2_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.ETC3_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.ETC4_WONX"+inx+".value))")   +
                                    eval("Number(removeComma(document.form1.ETC5_WONX"+inx+".value))")   -
                                    eval("Number(removeComma(document.form1.DISC_WONX"+inx+".value))");
                if( int_empl_wonx_tot == 0 ){
                    alert(" \"진료비계산서\"가 입력되지 않았습니다.\n\n \"진료비계산서 입력\" 버튼을 눌러 \"진료비계산서\"를 입력해주세요");
                    eval("document.form1.radiobutton["+inx+"].checked = true;");
                    return false;
                }
                if(int_empl_wonx_tot != int_empl_wonx){
                    alert("진료계산서의 본인부담금액과 입력한 본인실납부액이 다릅니다. \n\n \"진료비계산서 입력\" 버튼을 눌러 다시한번 확인해 주세요");
                    eval("document.form1.radiobutton["+inx+"].checked = true;");
                    eval("document.form1.EMPL_WONX"+inx+".focus();");
                    eval("document.form1.EMPL_WONX"+inx+".select();");
                    return false;
                }
            }
        }else{
            alert("\"의료기관\", \"사업자등록번호\", \"전화번호\", \"진료일\", \"본인 실납부액\"은 필수 항목입니다.\n\n 누락된 값을 입력해주세요");
            eval("document.form1.radiobutton["+inx+"].checked = true;");
            if(medi_name == ""){
                eval("document.form1.MEDI_NAME"+inx+".focus();");
            }else if(medi_numb == ""){
                eval("document.form1.MEDI_NUMB"+inx+".focus();");
            }else if(telx_numb == ""){
                eval("document.form1.TELX_NUMB"+inx+".focus();");
            }else if(exam_date == ""){
                eval("document.form1.EXAM_DATE"+inx+".focus();");
            }else if(empl_wonx == ""){
                eval("document.form1.EMPL_WONX"+inx+".focus();");
            }
            return false;
        }
    }
    if(hasNoData){
        alert("입력된 의료비 영수증이 없습니다. \n\n \"의료기관\", \"사업자등록번호\", \"전화번호\", \"진료일\", \"본인 실납부액\"은 필수 항목입니다.");
        return false;
    }

//  배우자, 자녀일 경우 해당년도 회사지원총액이 300만원을 넘으면 에러처리함.(본인은 2000만원을 넘으면 에러처리함)
    if( (document.form1.GUEN_CODE.value == "0002" && <%= !E_FLAG.equals("Y") %>) || document.form1.GUEN_CODE.value == "0003" ) {
        if( "<%= COMP_sum_d %>" >= 10000000 ) {
            alert("해당년도 의료비 지원총액은 배우자 및 자녀 합산 1000만원입니다.");//[CSR ID:2598080] 의료비 지원한도 적용 수정
            return false;
        }
     } else if( document.form1.GUEN_CODE.value == "0001" ) {
        if( "<%= COMP_sum_d %>" >= 20000000 ) {
            alert("해당년도 의료비 지원총액은 2,000만원입니다.");
            return false;
        }
     }

//  진료일을 기준으로 3개월까지만 신청이 가능하도록 한다. 2002.05.02. 확인자:성경호, 수정자:김도신
//  마지막에 입력한 진료일에 대해서만 체크한다.
    if( chk_inx >= 0 ) {
        begin_date = removePoint(document.form1.BEGDA.value);           // 신청일..
        exam_date  = removePoint(eval("document.form1.EXAM_DATE"+chk_inx+".value"));

        betw = getAfterMonth(addSlash(exam_date), 3);
        diff = dayDiff(addSlash(begin_date), addSlash(betw));

        if(diff < 0) {
            alert('진료일을 기준으로 3개월까지만 신청이 가능합니다.');
            eval("document.form1.radiobutton["+chk_inx+"].checked = true;");
            return false;
        }
    }
//  진료일을 기준으로 3개월까지만 신청이 가능하도록 한다. 2002.05.02. 확인자:성경호, 수정자:김도신
//  마지막에 입력한 진료일에 대해서만 체크한다.

 /* 최초 진료시 본인부담액이 5만원 이하인 경우 Error처리함 ▶ 2005.06.01 이후 신청분에 대해서는 10만원 이하인 경우 Error처리함 */
<%
    if ( !(PERNR_Data.E_WERKS.equals("EA00")||PERNR_Data.E_WERKS.equals("EB00")) ) {  // 2005.09.15 수정 - 인사영역이 EA00(지사), EB00(J/V)인 경우는 예외로 함.
%>          
    if( document.form1.is_new_num[0].checked && document.form1.WAERS.value == "KRW" ) {         // 최초진료이면서 원화일경우만..
        multiple_won("Chk");
        int_tt_wonx = Number(removeComma(document.form1.EMPL_WONX_tot.value));
        
        if( l_exam_date_max >= "20050601" ) {
            if( int_tt_wonx <= 100000 ){
                alert(" 최초 진료시 본인부담액이 10만원 초과일 경우에 의료비 신청이 가능합니다. ");
                return false;
            }
        } else {
            if( int_tt_wonx <= 50000 ){
                alert(" 최초 진료시 본인부담액이 5만원 초과일 경우에 의료비 신청이 가능합니다. ");
                return false;
            }
        }
    }
<%
  }
%>

 /* ?????? 회사 지원액이 본인부담금액을 초과시 Error처리함 */
 /* 진료비계산서 입력시 본인 부담금액이 10만원 이상인 경우만 허용함. */
    textArea_to_TextFild(document.form1.SICK_DESC.value);

//  2003.04.17 구제적증상 필수입력 - edskim
    if( document.form1.SICK_DESC1.value == "" && document.form1.SICK_DESC2.value == "" &&
        document.form1.SICK_DESC3.value == "" && document.form1.SICK_DESC4.value == "" ) {
        alert("구체적증상을 입력하세요.");
        document.form1.SICK_DESC.focus();
        return false;
    }

	//[CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가
    if( "Y"=="<%=CompanyCoupleYN%>") {
	    if (document.form1.GUEN_CODE.value == "0002" ){
            alert("사내부부 입니다.\n\n배우자 의료비 신청은 불가하며,임직원 본인의 의료비는 본인이 신청하시길 바랍니다.");
            return false;
        }
	    if (document.form1.GUEN_CODE.value == "0003" ){
            alert("사내배우자가 있습니다.\n\n의료비는 중복지원이 불가하오니 기신청내역여부 확인바랍니다.");
        }
    }
    
    if ( check_empNo() ){
        return false;
    }
    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
    for(var inxx = 0 ; inxx< <%=medi_count%> ; inxx++){
        eval("document.form1.MEDI_NUMB"+inxx+".value = removeResBar2(document.form1.MEDI_NUMB"+inxx+".value);");
        eval("document.form1.EXAM_DATE"+inxx+".value = removePoint(document.form1.EXAM_DATE"+inxx+".value);");
        eval("document.form1.EMPL_WONX"+inxx+".value = removeComma(document.form1.EMPL_WONX"+inxx+".value);");
    }

    return true;
}
/* check_data ********************************************************************************************* */

function textArea_to_TextFild(text) {
    var tmpText="";
    var tmplength = 0;
    var count = 1;
    var flag = true;

//[CSR ID:2589455] *(42) 제거 로직 추가----------------------------
    for ( var i = 0; i < text.length; i++ ){
    	if(text.charCodeAt(i) != 42 ){
          tmpText = tmpText+text.charAt(i);
      }
    }
    text = tmpText;
    tmpText = "";
//-----------------------------------------------------------------

    for ( var i = 0; i < text.length; i++ ){
        tmplength = checkLength(tmpText);

/*      enter 키 입력시 값에 엔터키 코드(13)을 제거하기 위한 부분 추가.. 김성일 */
//      2003.04.16 << text.charCodeAt(i) != 10 >> 추가함 13과 10을 동시에 check해야함 - 김도신
        if( (text.charCodeAt(i) != 13 && text.charCodeAt(i) != 10) && Number( tmplength ) < 70 ){
            tmpText = tmpText+text.charAt(i);
            flag = true
        } else {
            flag = false;
            tmpText.trim;

            if( text.charCodeAt(i) == 13 ) {
                eval("document.form1.SICK_DESC"+count+".value="+"tmpText");
                count++;
            }
            else if (Number( tmplength ) >= 70) { // @v1.2
                eval("document.form1.SICK_DESC"+count+".value="+"tmpText");
                count++;
                i=i-1;
            }              
            tmpText="";   //text.charAt(i);

            if( count > 4 ){
                break;
            }
        }
/*    enter 키 입력시 값에 엔터키 코드(13)을 제거하기 위한 부분 추가.. 김성일 */
    }

    if( flag ) {
        eval("document.form1.SICK_DESC"+count+".value="+"tmpText");
    }
/* debug(); */
}

/*달력 사용*/
function fn_openCal(Objectname){
   var lastDate;
   lastDate = eval("document.form1." + Objectname + ".value");
   small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
}
/*달력 사용*/

// 통화키가 변경되었을경우 금액을 재 설정해준다.
function moneyChkReSetting() {
    moneyChkForLGchemR3(document.form1.EMPL_WONX_tot,'WAERS');

    for( inx = 0 ; inx < <%=medi_count%> ; inx++ ){
        empl_wonx_obj = eval("document.form1.EMPL_WONX"+inx);
        moneyChkForLGchemR3_onBlur(empl_wonx_obj, 'WAERS');
    }
    multiple_won("");                 // 본인 실납부액 합계 구하기..
}
// 통화키가 변경되었을경우 금액을 재 설정해준다.

function change_child() {
<%
//  자녀일때 자녀를 선택할 수 있도록 한다.
    if( e17SickData.GUEN_CODE.equals("0003")&& !e17SickData.REGNO.equals("") ) {
%>
    document.form1.REGNO_dis.value = "<%= e17SickData.REGNO.substring(0, 6) + "-*******" %>";
    
    var begin_date = removePoint(document.form1.BEGDA.value);
    var d_datum    = addSlash("<%= e17SickData.DATUM_21 %>");
    
    dif = dayDiff(addSlash(begin_date), d_datum);

    if( dif < 0 ) {
        document.form1.Message.value = document.form1.ENAME.value + "는 " + d_datum.substring(0,4) + "년 " + d_datum.substring(5,7) + "월 부터 자녀의료비지원 대상에서 제외되며, " + d_datum.substring(5,7) + "월 전월 의료비까지 지원 가능합니다."
    }
<%
    }
%>
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="multiple_won('');disable_radio();change_child();">
<form name="form1" method="post">
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
                  <td class="title02" width="780"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">의료비 신청 수정</td>
                  <td class="titleRight"></td>
                </tr>
              </table></td>
          </tr>
          
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/PersonInfo.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    }
%>
          <tr>
            <td>
              <!-- 상단 입력 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr>
                  <td class="tr01">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                      <tr>
                        <td width="90" class="td01">신청일자</td>
                        <td width="660" class="td09">
                          <input type="text" name="BEGDA" value="<%= e17SickData.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(e17SickData.BEGDA) %>" size="20" class="input04" readonly>
                        </td>
                      </tr>
                      <tr>
                        <td class="td01">관리번호&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09">
                          <input type="radio" name="is_new_num" value="Y" <%= e17SickData.CTRL_NUMB.substring(7,9).equals("01") ? "checked" : "" %> > 최초진료
                          <input type="radio" name="is_new_num" value="N" <%= e17SickData.CTRL_NUMB.substring(7,9).equals("01") ? "" : "checked" %> > 동일진료&nbsp;&nbsp;
                          <input type="text" name="CTRL_NUMB"  value="<%= e17SickData.CTRL_NUMB %>" size="20" class="input04" readonly>
                        </td>
                      </tr>
                      <tr>
                        <td class="td01">구분&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09">
                          <input type="text"   name="GUEN_TEXT"  value="<%= WebUtil.printOptionText((new E17GuenCodeRFC()).getGuenCode(e17SickData.PERNR), e17SickData.GUEN_CODE) %>" size="20" class="input04" readonly>
                          <input type="hidden" name="GUEN_CODE"  value="<%= e17SickData.GUEN_CODE %>" size="20" class="input04" readonly>
                            &nbsp;&nbsp;&nbsp;<input type="checkbox" name="PROOF" value="" size="20" class="input03" <%= e17SickData.PROOF.equals("X") ? "checked" : "" %>>&nbsp;<font color="#006699">연말정산반영여부</font>
                        </td>
                      </tr>
<%
//  자녀일때 자녀를 선택할 수 있도록 한다.
    if( e17SickData.GUEN_CODE.equals("0003") ) {
%>
                      <tr>
                        <td class="td01">자녀이름</td>
                        <td class="td09">
                          <input type="text" name="ENAME"     value="<%= e17SickData.ENAME %>" size="14" class="input04" readonly>
                          <input type="text" name="REGNO_dis" value="" size="14" class="input04" readonly><br>
                          <input type="text" name="Message"   value="" size="100" class="input04" readonly>
                        </td>
                      </tr>
<%
    }
%>
<!--@v1.3-->
                      <tr>
                        <td class="td01">진료과&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09">
                          <select name="TREA_CODE" class="input03" onChange="javascript:document.form1.TREA_TEXT.value = this.options[this.selectedIndex].text;">
                          <option value="">--------</value>
<%= WebUtil.printOption((new E17MedicTreaRFC()).getMedicTrea(), e17SickData.TREA_CODE) %>
                          </select>
                        </td>
                      </tr>
                      <input type="hidden" name="TREA_TEXT" value="<%= e17SickData.TREA_TEXT %>">
                      <tr>
                        <td class="td01">상병명&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09">
                          <input type="text" name="SICK_NAME" value="<%= e17SickData.SICK_NAME %>" size="40" class="input03">
                      </td>
                    </tr>
                    <tr>
                      <td class="td01">구체적증상&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09">
                          <textarea name="SICK_DESC" wrap="VIRTUAL" cols="70" class="input03" rows="4"><%= ( !e17SickData.SICK_DESC.equals("") ) ? e17SickData.SICK_DESC : e17SickData.SICK_DESC1 +"\n"+ e17SickData.SICK_DESC2 +"\n"+ e17SickData.SICK_DESC3 +"\n"+ e17SickData.SICK_DESC4  %></textarea>
                      </td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td colspan="2">
                        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02">
                          <tr>
                            <td class="td03" width="30">선택</td>
                            <td class="td03" width="90">의료기관&nbsp;<font color="#006699"><b>*</b></font></td>
                            <td class="td03" width="85">사업자<br>등록번호&nbsp;<font color="#0000FF"><b>*</b></font></td>
                            <td class="td03" width="80">전화번호&nbsp;<font color="#006699"><b>*</b></font></td>
                            <td class="td03" width="150">진료일&nbsp;<font color="#006699"><b>*</b></font></td>
                            <td class="td03" width="55">입원<br>/외래&nbsp;<font color="#006699"><b>*</b></font></td>
                            <td class="td03" width="110">영수증 구분&nbsp;<font color="#006699"><b>*</b></font></td>
                            <td class="td03" width="80">결재수단</td>
                            <td class="td03" width="75">본인<br>실납부액&nbsp;<font color="#006699"><b>*</b></font></td>
                          </tr>
<%
    Vector MediCode_vt = (new E17MediCodeRFC()).getMediCode();
    MediCode_vt = SortUtil.sort_num(MediCode_vt ,"code", "desc");    
    
    Vector RcptCode_vt = (new E17RcptCodeRFC()).getRcptCode();

    for( int i = 0 ; i < E17HospitalData_vt.size() ; i++ ){
        E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
%>
                          <input type="hidden" name="use_flag<%=i%>"  value="Y">
                          <input type="hidden" name="RCPT_NUMB<%=i%>" value="<%= (last_num + 1) + i %>"> <!-- No. 영수증번호    -->

                          <tr>
                            <td class="td04">
                              <input type="radio" name="radiobutton" value="<%=i%>"  <%=(i==0) ? "checked" : "" %>>
                            </td>
                            <td class="td04">
                              <input type="text" name="MEDI_NAME<%=i%>" value="<%= e17HospitalData.MEDI_NAME.trim() %>" size="14" class="input03">
                            </td>
                            <td class="td04">
                              <input type="text" name="MEDI_NUMB<%=i%>" value="<%= e17HospitalData.MEDI_NUMB.equals("") ? "" : DataUtil.addSeparate2(e17HospitalData.MEDI_NUMB) %>" size="11" class="input03" maxlength="12" onBlur="businoFormat(this);">
                            </td>
                            <td class="td04">
                              <input type="text" name="TELX_NUMB<%=i%>" value="<%= e17HospitalData.TELX_NUMB %>" size="11" class="input03" maxlength="13" onBlur="phone_1(this);">
                            </td>
                            <td class="td04">
                              <input type="text" name="EXAM_DATE<%=i%>" value="<%= e17HospitalData.EXAM_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(e17HospitalData.EXAM_DATE) %>" size="8" class="input03" onBlur="dateFormat(this);">
                              <!-- 날짜검색-->
                              <a href="javascript:fn_openCal('EXAM_DATE<%=i%>')">
                              <img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="날짜검색"></a>
                              <!-- 날짜검색-->
                            </td>
                            <td class="td04">
                              <select name="MEDI_CODE<%=i%>" class="input03">
                                <!--  option -->
                                <%= WebUtil.printOption(MediCode_vt, e17HospitalData.MEDI_CODE)%>
                                <!--  option -->
                              </select>
                            </td>
                            <td class="td04">
                              <select name="RCPT_CODE<%=i%>" onChange="javascript:chg_opt(this);" class="input03">
                                <!--  option -->
                                <%= WebUtil.printOption(RcptCode_vt, e17HospitalData.RCPT_CODE)%>
                                <!--  option -->
                              </select>
                            </td>
                            <td class="td04"><!--@v1.1-->
                              <select name="MEDI_MTHD<%=i%>" class="input03">
                              <option value="2" <%= e17HospitalData.MEDI_MTHD.equals("2") ? "selected" : "" %>>신용카드</option>       
                              <option value="3" <%= e17HospitalData.MEDI_MTHD.equals("3") ? "selected" : "" %>>현금영수증</option>       
                              <option value="1" <%= e17HospitalData.MEDI_MTHD.equals("1") ? "selected" : "" %>>현금</option>
                              </select>
                            </td>        
                            <td class="td04">
                              <input type="text" name="EMPL_WONX<%=i%>" value="<%= e17HospitalData.EMPL_WONX.equals("") ? "" : WebUtil.printNumFormat(DataUtil.removeStructur(e17HospitalData.EMPL_WONX,","),currencyValue) %>" size="10" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS');javascript:multiple_won('');" class="input03">
                            </td>
                          <input type="hidden" name="YTAX_WONX<%=i%>" value="">
                            
                          </tr>
                          
<%
    }
%>
<%
    for( int i = E17HospitalData_vt.size() ; i < medi_count ; i++ ){
%>
                          <input type="hidden" name="use_flag<%=i%>" value="Y">
                          <input type="hidden" name="RCPT_NUMB<%=i%>" value="<%= (last_num + 1) + i %>"> <!-- No. 영수증번호    -->

                          <tr>
                            <td class="td04">
                              <input type="radio" name="radiobutton" value="<%=i%>">
                            </td>
                            <td class="td04">
                              <input type="text" name="MEDI_NAME<%=i%>" value="" size="14" class="input03">
                            </td>
                            <td class="td04"> 
                              <input type="text" name="MEDI_NUMB<%=i%>" value="" size="11" class="input03" maxlength="12" onBlur="businoFormat(this);">
                            </td>
                            <td class="td04">
                              <input type="text" name="TELX_NUMB<%=i%>" value="" onBlur="phone_1(this);" size="11" class="input03" maxlength="13">
                            </td>
                            <td class="td04">
                              <input type="text" name="EXAM_DATE<%=i%>" onBlur="dateFormat(this);" value="" size="8" class="input03">
                               <!-- 날짜검색-->
                               <a href="javascript:fn_openCal('EXAM_DATE<%=i%>')">
                               <img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="날짜검색"></a>
                               <!-- 날짜검색-->
                            </td>
                            <td class="td04">
                              <select name="MEDI_CODE<%=i%>" class="input03">
                                <!--  option -->
                                <%= WebUtil.printOption(MediCode_vt)%>
                                <!--  option -->
                              </select>
                            </td>
                            <td class="td04">
                              <select name="RCPT_CODE<%=i%>" onChange="javascript:chg_opt(this);" class="input03">
                                <!--  option -->
                                <%= WebUtil.printOption(RcptCode_vt)%>
                                <!--  option -->
                              </select>
                            </td>
                            <td class="td04"><!--@v1.1-->
                              <select name="MEDI_MTHD<%=i%>" class="input03">
                              <option value="2">신용카드</option>       
                              <option value="3">현금영수증</option>       
                              <option value="1">현금</option>
                              </select>
                            </td>        
                            <td class="td04">
                              <input type="text" name="EMPL_WONX<%=i%>" value="" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS');javascript:multiple_won('');" size="10" class="input03">
                            </td>
                          <input type="hidden" name="YTAX_WONX<%=i%>" value="">
                            
                          </tr>
<%
    }
%>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class="td09" width="500"> <a href="javascript:more_hospital_field();">
                              <img src="<%= WebUtil.ImageURL %>btn_add.gif" align="absmiddle" border="0"></a>
                              <a href="javascript:remove_hospital_item();"> <img src="<%= WebUtil.ImageURL %>btn_delete.gif" border="0" align="absmiddle"></a>
                              <a href="javascript:go_bill();"> <img src="<%= WebUtil.ImageURL %>btn_hosbill.gif" border="0" align="absmiddle"></a>
                              <font color="#006699">&nbsp;※ 약국영수증인 경우 처방전을 첨부하세요.</font>
                            </td>
                            <td width="280">
                              <table width="250" border="0" cellspacing="0" cellpadding="2" align="right">
                                <tr align="right">
                                  <td width="60" class="td03">계</td>
                                  <td>
                                    <input type="text" name="EMPL_WONX_tot" size="17" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" style="text-align:right" class="input03" readonly>
                                    <select name="WAERS" class="input03" onChange="javascript:moneyChkReSetting();">
                                      <!-- 통화키 가져오기-->
                                      <%= WebUtil.printOption((new CurrencyCodeRFC()).getCurrencyCode(), e17SickData.WAERS) %>
                                      <!-- 통화키 가져오기-->
                                    </select>
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td class="td09" colspan="2"> <font color="#006699"><b>*</b>
                              는 필수 입력사항입니다.</font> </td>
                          </tr>
<%
    if( e17SickData.GUEN_CODE.equals("0002") ) {
%>
                          <tr>
                            <td class="td09" colspan="2"> <font color="#006699">※
                              배우자의 의료비를 연말정산에 반영해야 할 경우 반드시 배우자 연말정산반영여부를 체크하여
                              주시기 바랍니다.</font> </td>
                          </tr>
                          <tr>
                            <td class="td09" colspan="2"> <font color="#006699">※
                              배우자의 의료비 연말정산과 관련하여 각각 배우자 공제(이중공제)로 신청할 경우 세금추징
                              등의 불이익을 받게 되므로<br>
                              &nbsp;&nbsp;&nbsp;&nbsp;이점 양지하시기 바랍니다.</font>
                            </td>
                          </tr>
<%
    }
%>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
            <!--상단 입력 테이블 끝-->
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="750" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="font01"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                  결재정보</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <!-- 결재자 입력 테이블 시작-->
            <%= hris.common.util.AppUtil.getAppChange(AppLineData_vt,e17SickData.PERNR) %>
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
                <td align="center"> <a href="javascript:do_change();"> <img src="<%= WebUtil.ImageURL %>btn_input.gif" align="absmiddle" border="0"></a>
                  <a href="javascript:do_back();"> <img src="<%= WebUtil.ImageURL %>btn_cancel.gif" align="absmiddle" border="0"></a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<!-- hidden field : common -->
    <input type="hidden" name="jobid"             value="">
    <input type="hidden" name="fromJsp"           value="E17HospitalChange.jsp">
    <input type="hidden" name="radio_index"       value="">
    <input type="hidden" name="last_RCPT_NUMB"    value="<%= last_RCPT_NUMB %>">
<!--    <input type="hidden" name="P_Flag"            value="P_Flag"> -->
    <input type="hidden" name="COMP_sum"          value="<%= COMP_sum %>">
    <input type="hidden" name="RowCount_hospital" value="<%= E17HospitalData_vt.size() %>">
    <input type="hidden" name="RowCount_report"   value="<%= E17BillData_vt.size() %>">
<!-- hidden field : common -->
<!-- hidden field : E17SickData -->
    <input type="hidden" name="PERNR"           value="<%= e17SickData.PERNR%>">
    <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
    <input type="hidden" name="medi_count" value="<%= medi_count %>">
    <input type="hidden" name="AINF_SEQN"  value="<%= e17SickData.AINF_SEQN %>">
    <!--<input type="hidden" name="CTRL_NUMB"  value="">  관리번호   -->
    <input type="hidden" name="SICK_DESC1" value=""> <!-- 구체적증상 -->
    <input type="hidden" name="SICK_DESC2" value=""> <!-- 구체적증상 -->
    <input type="hidden" name="SICK_DESC3" value=""> <!-- 구체적증상 -->
    <input type="hidden" name="SICK_DESC4" value=""> <!-- 구체적증상 -->
<!-- hidden field : E17SickData -->

    <input type="hidden" name="ORG_CTRL"   value="<%= e17SickData.ORG_CTRL %>"> <!-- 동일진료시 선택한원래관리번호CSR ID:1361257  -->
    <input type="hidden" name="LAST_CTRL"  value="<%= e17SickData.LAST_CTRL %>"> <!-- 동일진료시 선택한원래관리번호의 마지막번호CSR ID:1361257  -->

<!-- hidden field : E17BillData -->
<%
    for( int i = 0 ; i < E17BillData_vt.size() ; i++ ){
        E17BillData e17BillData = (E17BillData)E17BillData_vt.get(i);
%>
    <input type="hidden" name="CTRL_NUMB<%=i%>"   value="<%= e17BillData.CTRL_NUMB %>"> <!-- 관리번호          -->
    <input type="hidden" name="x_RCPT_NUMB<%=i%>" value="<%= e17BillData.RCPT_NUMB %>"> <!-- 영수증번호        -->
    <input type="hidden" name="AINF_SEQN<%=i%>"   value="<%= e17BillData.AINF_SEQN %>"> <!-- 결재정보 일련번호 -->
    <input type="hidden" name="TOTL_WONX<%=i%>"   value="<%= e17BillData.TOTL_WONX %>"> <!-- 총 진료비         -->
    <input type="hidden" name="ASSO_WONX<%=i%>"   value="<%= e17BillData.ASSO_WONX %>"> <!-- 조합 부담금       -->
    <input type="hidden" name="x_EMPL_WONX<%=i%>" value="<%= e17BillData.EMPL_WONX %>"> <!-- 본인 부담금       -->
    <input type="hidden" name="MEAL_WONX<%=i%>"   value="<%= e17BillData.MEAL_WONX %>"> <!-- 식대              -->
    <input type="hidden" name="APNT_WONX<%=i%>"   value="<%= e17BillData.APNT_WONX %>"> <!-- 지정 진료비       -->
    <input type="hidden" name="ROOM_WONX<%=i%>"   value="<%= e17BillData.ROOM_WONX %>"> <!-- 상급 병실료 차액  -->
    <input type="hidden" name="CTXX_WONX<%=i%>"   value="<%= e17BillData.CTXX_WONX %>"> <!-- C T 검사비        -->
    <input type="hidden" name="MRIX_WONX<%=i%>"   value="<%= e17BillData.MRIX_WONX %>"> <!-- M R I 검사비      -->
    <input type="hidden" name="SWAV_WONX<%=i%>"   value="<%= e17BillData.SWAV_WONX %>"> <!-- 초음파 검사비     -->
    <input type="hidden" name="DISC_WONX<%=i%>"   value="<%= e17BillData.DISC_WONX %>"> <!-- 할인금액          -->
    <input type="hidden" name="ETC1_WONX<%=i%>"   value="<%= e17BillData.ETC1_WONX %>"> <!-- 기타1 의 금액     -->
    <input type="hidden" name="ETC1_TEXT<%=i%>"   value="<%= e17BillData.ETC1_TEXT %>"> <!-- 기타1 의 항목명   -->
    <input type="hidden" name="ETC2_WONX<%=i%>"   value="<%= e17BillData.ETC2_WONX %>"> <!-- 기타2 의 금액     -->
    <input type="hidden" name="ETC2_TEXT<%=i%>"   value="<%= e17BillData.ETC2_TEXT %>"> <!-- 기타2 의 항목명   -->
    <input type="hidden" name="ETC3_WONX<%=i%>"   value="<%= e17BillData.ETC3_WONX %>"> <!-- 기타3 의 금액     -->
    <input type="hidden" name="ETC3_TEXT<%=i%>"   value="<%= e17BillData.ETC3_TEXT %>"> <!-- 기타3 의 항목명   -->
    <input type="hidden" name="ETC4_WONX<%=i%>"   value="<%= e17BillData.ETC4_WONX %>"> <!-- 기타4 의 금액     -->
    <input type="hidden" name="ETC4_TEXT<%=i%>"   value="<%= e17BillData.ETC4_TEXT %>"> <!-- 기타4 의 항목명   -->
    <input type="hidden" name="ETC5_WONX<%=i%>"   value="<%= e17BillData.ETC5_WONX %>"> <!-- 기타5 의 금액     -->
    <input type="hidden" name="ETC5_TEXT<%=i%>"   value="<%= e17BillData.ETC5_TEXT %>"> <!-- 기타5 의 항목명   -->
<%
    }
%>
<%
    for( int i = E17BillData_vt.size() ; i < medi_count ; i++ ){
%>
    <input type="hidden" name="CTRL_NUMB<%=i%>"   value=""> <!-- 관리번호          -->
    <input type="hidden" name="x_RCPT_NUMB<%=i%>" value=""> <!-- 영수증번호        -->
    <input type="hidden" name="AINF_SEQN<%=i%>"   value=""> <!-- 결재정보 일련번호 -->
    <input type="hidden" name="TOTL_WONX<%=i%>"   value=""> <!-- 총 진료비         -->
    <input type="hidden" name="ASSO_WONX<%=i%>"   value=""> <!-- 조합 부담금       -->
    <input type="hidden" name="x_EMPL_WONX<%=i%>" value=""> <!-- 본인 부담금       -->
    <input type="hidden" name="MEAL_WONX<%=i%>"   value=""> <!-- 식대              -->
    <input type="hidden" name="APNT_WONX<%=i%>"   value=""> <!-- 지정 진료비       -->
    <input type="hidden" name="ROOM_WONX<%=i%>"   value=""> <!-- 상급 병실료 차액  -->
    <input type="hidden" name="CTXX_WONX<%=i%>"   value=""> <!-- C T 검사비        -->
    <input type="hidden" name="MRIX_WONX<%=i%>"   value=""> <!-- M R I 검사비      -->
    <input type="hidden" name="SWAV_WONX<%=i%>"   value=""> <!-- 초음파 검사비     -->
    <input type="hidden" name="DISC_WONX<%=i%>"   value=""> <!-- 할인금액          -->
    <input type="hidden" name="ETC1_WONX<%=i%>"   value=""> <!-- 기타1 의 금액     -->
    <input type="hidden" name="ETC1_TEXT<%=i%>"   value=""> <!-- 기타1 의 항목명   -->
    <input type="hidden" name="ETC2_WONX<%=i%>"   value=""> <!-- 기타2 의 금액     -->
    <input type="hidden" name="ETC2_TEXT<%=i%>"   value=""> <!-- 기타2 의 항목명   -->
    <input type="hidden" name="ETC3_WONX<%=i%>"   value=""> <!-- 기타3 의 금액     -->
    <input type="hidden" name="ETC3_TEXT<%=i%>"   value=""> <!-- 기타3 의 항목명   -->
    <input type="hidden" name="ETC4_WONX<%=i%>"   value=""> <!-- 기타4 의 금액     -->
    <input type="hidden" name="ETC4_TEXT<%=i%>"   value=""> <!-- 기타4 의 항목명   -->
    <input type="hidden" name="ETC5_WONX<%=i%>"   value=""> <!-- 기타5 의 금액     -->
    <input type="hidden" name="ETC5_TEXT<%=i%>"   value=""> <!-- 기타5 의 항목명   -->
<%
    }
%>
<!-- hidden field : E17BillData -->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
