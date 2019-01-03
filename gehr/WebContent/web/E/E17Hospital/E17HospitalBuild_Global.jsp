<%/***************************************************************************************/
/*    System Name   : g-HR                                                                                                                          */
/*   1Depth Name        : Application                                                                                                                   */
/*   2Depth Name        : Benefit Management                                                                                                        */
/*   Program Name   : Medical Fee                                                                                                                   */
/*   Program ID         : E17HospitalBuild.jsp                                                                                                      */
/*   Description        : 의료비 신청 화면                                                                                                                     */
/*   Note               : 없음                                                                                                                                        */
/*   Creation           : 2002-01-08 김성일                                                                                                                */
/*   Update             : 2005-02-16 윤정현                                                                                                                */
/*                          : 2005-12-26 @v1.1 [C2005121301000001097] 신용카드/현금구분추가                                           */
/*                          : 2006-01-03 @v1.2 [C2006010301000000913] 최초진료시 차감금액 변경                                         */
/*                          : 2006-02-23 @v1.3 [C2006022001000000648] 진료과추가                                                         */
/*                          : 2007-02-23 @v1.4 구체적증상 체크로직에 추가                                                                           */
/*   Update             : 2009-05-13 jungin @v1.5 [C20090513_54934] 대만법인 소수점 입력 방지.                                 */
/*                          : 2009-05-18 jungin @v1.6 [C20090514_56175] 보험가입 여부 'ZINSU' 필드 추가.                          */
/*    Update             : 2013-12-19 lixinxin @v1.7 [C20131211_51591] 医疗申请画面增加字段*/
/*   Creation            : 2016-11-18 ShiQuan [C20160928_78417] Fileupload                                                            */
/***************************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ page import="hris.common.PersonData" %>

<%
	WebUserData user = WebUtil.getSessionUser(request);
    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
    String PERNR = (String)request.getAttribute("PERNR");

    //E17HospitalDetailData hdata = (E17HospitalDetailData)request.getAttribute("E17HospitalDetailData");
    String      wtem                 = (String)request.getAttribute("wtem");

    String      COMP_sum     = (String)request.getAttribute("COMP_sum");
    double    COMP_sum_d  = 0.0;
    if(COMP_sum != null && !COMP_sum.equals("")) {
        COMP_sum_d = Double.parseDouble( COMP_sum );
    } else {
        COMP_sum = "";
    }

    //DataUtil.fixNull(hdata);

//////////////////////////////////////////////////////////////////////////////////////////////////// 2005.05.31

	// 통화키에 따른 소수자리수를 가져온다
    String E_BUKRS = PERNR_Data.E_BUKRS;

    // 반올림 변수.      2009-05-13      jungin      @v1.5 [C20090513_54934]
    int decimalNum = 2;
    if(E_BUKRS != null && (E_BUKRS == "G220" || E_BUKRS.equals("G220"))){
        decimalNum = 0;
    }
    String E_DAT02  = PERNR_Data.E_DAT02;

    String ZINSU = (String)request.getAttribute("ZINSU");
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="wtem" value="<%=wtem %>" />
<c:set var="E_BUKRS" value="<%=E_BUKRS %>" />
<c:set var="E_DAT02" value="<%=E_DAT02 %>" />
<c:set var="decimalNum" value="<%=decimalNum %>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_MEDI_EXPA" upload="${upload}">

<tags:script>
<script>
/* 최초 동일 진료 버튼 선택시 처리 */
function click_radio(obj) {
    if(document.form1.is_new_num[0].checked){ /* 최초진료 */
        document.form1.CTRL_NUMB.value  = "";
        document.form1.SICK_NAME.value  = "";
        document.form1.SICK_DESC.value  = "";
    }else if(document.form1.is_new_num[1].checked){ /* 동일진료 */
        if( document.form1.hidden_CTRL_NUMB.value == '' ) {         //신청한 의료비가 존재하지 않을경우 동일진료 신청을 막는다.
            alert("신청된 의료비가 존재하지 않습니다.\n최초진료로 신청하세요.");
            document.form1.is_new_num[0].checked = true;
            return;
        }
        document.form1.CTRL_NUMB.value  = document.form1.hidden_CTRL_NUMB.value;
        document.form1.SICK_NAME.value  = document.form1.hidden_SICK_NAME.value;
        document.form1.SICK_DESC.value  = document.form1.hidden_SICK_DESC1.value +"\n"+
                                        document.form1.hidden_SICK_DESC2.value +"\n"+
                                        document.form1.hidden_SICK_DESC3.value +"\n"+
                                        document.form1.hidden_SICK_DESC4.value ;
    }
}

function chg_medi_code(num){
    inx = eval("document.form1.MEDI_CODE"+num+".selectedIndex;");
    eval("document.form1.MEDI_TEXT"+num+".value = document.form1.opt_MEDI_TEXT"+inx+".value;");
}

 /*달력 사용*/
function fn_openCal(Objectname){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window=window.open("${g.jsp}common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0&optionvalue=","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=285,top=" + document.body.clientHeight/2 + ",left=" + document.body.clientWidth/2);
}
 /* 달력 사용 */

function go_print(){
    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650,left=100,top=60");
    document.form1.jobid.value = "print_form";
    document.form1.target = "essPrintWindow";
    document.form1.action = '${g.servlet}hris.E.E17Hospital.E17BillControlSV';
    document.form1.method = "post";
    document.form1.submit();
}

// 통화키가 변경되었을경우 금액을 재 설정해준다.
function moneyChkReSetting() {
    moneyChkForLGchemR3(document.form1.EMPL_WONX_tot,'WAERS');

    for( inx = 0 ; inx < 1 ; inx++ ){
        empl_wonx_obj = eval("document.form1.EMPL_WONX"+inx);
        moneyChkForLGchemR3_onBlur(empl_wonx_obj, 'WAERS');
    }
    multiple_won("");                 // 본인 실납부액 합계 구하기..
}
// 통화키가 변경되었을경우 금액을 재 설정해준다.

function change_guen(obj) {
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
      size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }

    siz = Number(document.form1.medi_count.value);
    document.form1.RowCount_hospital.value = siz;

    document.form1.jobid.value = "change_guen";
    document.form1.action = "${g.servlet}hris.E.E17Hospital.E17HospitalBuildSV";
    document.form1.method = "post";
    document.form1.submit();
}

function calculate(tem){
    tem = removeComma(tem);
    if(!isNaN(tem)){
        //document.form1.PAAMT.value=insertComma(banolim1(Number(removeComma(document.form1.CERT_BETG_C.value))*0.01*Number(document.form1.PRATE.value),2)+'');
        tem = insertComma(tem);
    }
}

function calculate1(){
    var tem = document.form1.MTYPE[document.form1.MTYPE.selectedIndex].value;
    if(tem=='3'){
        document.form1.PAAMT.value=insertComma(''+Number(removeComma(document.form1.PAAMT_BALANCE.value)) * 0.5);
    }
}

function fn_pop(){
    small_window=window.open("","CurrencyPop","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=430,left=100,top=100");
    small_window.focus();
    document.form1.target ="CurrencyPop";
    document.form1.action = "/web/common/CurrencyPop.jsp";
    document.form1.submit();
}

function evaluation(tem){
    document.form1.WAERS.value=tem;
    document.form1.WAERS3.value=tem;
}

function ajax_change(){
    var tem =  document.getElementById("PAAMT"); // 값이 변환되어서 찍혀야할 필드.
    var waers1 = document.form1.WAERS.value;
    var waers2 = document.form1.WAERS1.value;
    var betrg = removeComma(document.form1.EXPENSE.value);
    var time= new Date();

    if(tem!=null){
        //var url = '/servlet/servlet.hris.E.Global.E17Hospital.E17HospitalAjax';
        //var pars = 'waers1=' + document.form1.WAERS.value+'&waers2='+document.form1.WAERS1.value+ "&betrg=" + removeComma(document.form1.EXPENSE.value)+ "&time=" + new Date();
        //alert(document.form1.WAERS.value + "," + document.form1.WAERS1.value + " ," + removeComma(document.form1.EXPENSE.value));
        //var myAjax = new Ajax.Request(url,{method: 'get',parameters: pars,onComplete: showResponse});

        jQuery.ajax({
            type:"POST",
            url:'${g.servlet}hris.E.Global.E17Hospital.E17HospitalAjax',
            data: {waers1 : waers1, waers2 : waers2, betrg : betrg, time : time  },
            success:function(data){
                if($(data).length < 6)
            	    showResponse(data);
            },
            error:function(e){
                alert(e.responseText);
            }
       	});
    }
}

function showResponse(originalRequest){
    if (originalRequest!=''){
        var arr= new Array();
        arr=originalRequest.split('|');
        $('#rcrest').html(arr[0]);
        //doSubmit1();
    }
}

function ajax_change3(){
   // var url = '/servlet/servlet.hris.E.Global.E17Hospital.E17HospitalAjax3';

    var ZINSU   = document.form1.ZINSU.value;
    var BEGDA   = removePoint(document.form1.BEGDA.value);
    var WAERS   = document.form1.WAERS.value;
	var PERNR    = ${PERNR};

	jQuery.ajax({
         type:"POST",
         url:'${g.servlet}hris.E.Global.E17Hospital.E17HospitalAjax3',
         data: {PERNR : PERNR, ZINSU : ZINSU, BEGDA : BEGDA, WAERS : WAERS  },
         success:function(data){
        	 showResponse3(data);
         },
         error:function(e){
             alert(e.responseText);
         }
   	});

}

function showResponse3(originalRequest){
    if (originalRequest!=''){
        var arr= new Array();
        arr=originalRequest.split('|');
        $('#PAMT').html(arr[0]);
        $('#PAMT1').html(arr[1]);

        document.form1.PLIMIT.value = removeComma(document.form1.PLIMIT.value);

        if(document.form1.ZINSU.value == "O" && document.form1.PLIMIT.value == "0.00"){
        	alert("<spring:message code='MSG.E.E21.0001' />"); //alert("Input number must less than Balance Amount.");
            return;
        }
    }
}

function check_data1(){
	var validText = "";

    if(document.form1.FAMI_CODE.value == "999"){
    	validText = $("#FAMI_CODE").attr("placeholder");
    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");  // alert("Please Select Name.");
        document.form1.FAMI_CODE.focus();
        return false;
    }
    if( document.form1.EXDATE.value == "" ) {
    	validText = $("#EXDATE").attr("placeholder");
    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
        document.form1.EXDATE.focus();
        return false;
    }
    /*if(document.form1.MTYPE.options[document.form1.MTYPE.selectedIndex].value == "" ) {
        alert("Please Select Medical Type.");
        document.form1.MTYPE.focus();
        return false;
    }
    if(document.form1.ZINSU.options[document.form1.ZINSU.selectedIndex].value == "" ) {
        alert("Please Select Insurance.");
        document.form1.ZINSU.focus();
        return false;
    }*/
//2013-12-19 lixinxin @v1.7 [C20131211_51591] 医疗申请画面增加字段*/ begin

       if(document.form1.MED_LOCATION.value == "999" || document.form1.MED_LOCATION.value == ""){
        	validText = $("#MED_LOCATION").attr("placeholder");
        	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please Select Treatment Location.");
            document.form1.MED_LOCATION.focus();
            return false;
       }else if(document.form1.MED_LOCATION.value == "Korea"){
            if(document.form1.MED_REASON.value == "999"){
            	validText = $("#MED_REASON").attr("placeholder");
            	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please Select Reason.");
                document.form1.MED_REASON.focus();
                return false;
            }
            if(document.form1.MED_ELIANAPR.value == "999"){
                alert("Please Select Elian Approval.");
                document.form1.MED_ELIANAPR.focus();
                return false;
            }
        }
        if(document.form1.MED_TYPE.value == "999" || document.form1.MED_TYPE.value == ""){
        	validText = $("#MED_TYPE").attr("placeholder");
        	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("Please Select Medical Type.");
            document.form1.MED_TYPE.focus();
            return false;
        }
        if(document.form1.MED_PRESCRIPTION.value == "999" || document.form1.MED_PRESCRIPTION.value == ""){
        	validText = $("#MED_PRESCRIPTION").attr("placeholder");
        	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("Please Select Prescription.");
            document.form1.MED_PRESCRIPTION.focus();
            return false;
        }
        if(document.form1.MED_DIAGNOSIS.value == "999" || document.form1.MED_DIAGNOSIS.value == ""){
        	validText = $("#MED_DIAGNOSIS").attr("placeholder");
        	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please Select Diagnosis Certificate.");
            document.form1.MED_DIAGNOSIS.focus();
            return false;
        }
//2013-12-19 lixinxin @v1.7 [C20131211_51591] 医疗申请画面增加字段*/ end
    if( document.form1.DISEASE.value == "" ) {
    	validText = $("#DISEASE").attr("placeholder");
    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("Please Select Prescription.");
        document.form1.DISEASE.focus();
        return false;
    }

    if( document.form1.EXPENSE.value == "") {
    	validText = $("#EXPENSE").attr("placeholder");
    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("Please Select Prescription.");
        document.form1.EXPENSE.focus();

        return false;
    } else {
        document.form1.EXPENSE.value = removeComma(document.form1.EXPENSE.value);
        if( isNaN(document.form1.EXPENSE.value) ) {
            alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
            document.form1.EXPENSE.value = insertComma(document.form1.EXPENSE.value);
            document.form1.EXPENSE.focus();
            return false;
        }
    }
    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
    document.form1.EXDATE.value = removePoint(document.form1.EXDATE.value);
    document.form1.ENAME.value= document.form1.FAMI_CODE.options[document.form1.FAMI_CODE.selectedIndex].text;
    return true;
}

function numberFormat(){
    document.form1.EXPENSE.value = insertComma(document.form1.EXPENSE.value);
    document.form1.PAAMT.value = insertComma(document.form1.PAAMT.value);
    document.form1.PAMT_BALANCE.value = insertComma(document.form1.PAMT_BALANCE.value);
    document.form1.PAAMT_BALANCE.value = insertComma(document.form1.PAAMT_BALANCE.value);
    document.form1.CERT_BETG_C.value = insertComma(document.form1.CERT_BETG_C.value);
}

function backFormat(){
    document.form1.EXPENSE.value = removeComma(document.form1.EXPENSE.value);
    document.form1.PAAMT.value = removeComma(document.form1.PAAMT.value);
    document.form1.PAMT_BALANCE.value = removeComma(document.form1.PAMT_BALANCE.value);
    document.form1.PAAMT_BALANCE.value = removeComma(document.form1.PAAMT_BALANCE.value);
    document.form1.CERT_BETG_C.value = removeComma(document.form1.CERT_BETG_C.value);
}

//function doSubmit1() {
function beforeSubmit() {

    if(check_data1()){
        var str=/^\d+(\.\d+)?$/;
        backFormat();
        if(!str.test(document.form1.EXPENSE.value)){
        	alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
            document.form1.EXPENSE.focus();
            return;
        }
        if(Number(document.form1.CERT_BETG_C.value)=='0'){
        	alert("<spring:message code='MSG.E.E23.0004' />"); //alert("Exchange rate does not exist.");
            dateFormat(document.form1.EXDATE);
            numberFormat();
            document.form1.EXPENSE.focus();
            return;
        }
        if(Number(document.form1.CERT_BETG_C.value)>Number(removeComma(document.form1.PAMT_BALANCE.value))){
        	alert("<spring:message code='MSG.E.E21.0001' />"); // alert("Input number must less than Balance Amount.");
            dateFormat(document.form1.EXDATE);
            numberFormat();
            document.form1.EXPENSE.focus();
            return;
        }
        return true;
        //if ( !check_empNo() ){
        //    buttonDisabled();
        //    document.form1.jobid.value = "create";
        //    document.form1.target ="_self" ;
        //    document.form1.action = "${g.servlet}hris.E.E17Hospital.E17HospitalBuildSV";
        //    document.form1.method = "post";
        //    document.form1.submit();
        //}
    }
}

function onlyNumber1() {
    if (!((window.event.keyCode >=48) && (window.event.keyCode <= 57)||(window.event.keyCode == 46))) {
        window.event.keyCode = 0 ;
    }
}

function onlyNumber(tem) {
    var frm = document.form1;

    // 대만법인 소수점 입력 방지.      2009-05-13      jungin
    <c:if test="${E_BUKRS eq 'G220'}">
            if( (window.event.keyCode == 110) || (window.event.keyCode == 190) ){
            	alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
                frm.EXPENSE.value = "";
                frm.PAAMT.value = "";
                frm.EXPENSE.focus();
                return;
            }
    </c:if>

    if( ((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) || ((window.event.keyCode >= 96) && (window.event.keyCode <= 105)) ) {   //2009-05-13    jungin
        calculate(tem.value);
    }else if((window.event.keyCode==8)||(window.event.keyCode==46)){
        calculate(tem.value);
    }else if((window.event.keyCode==13||window.event.keyCode==37)||(window.event.keyCode==38)||(window.event.keyCode==39)||(window.event.keyCode==40)){
    }else{
        moneyChkEventForWorld(tem);
        //window.event.keyCode = 0 ;
    }

    setTimeout(function() {ajax_change();}
   , 500);
}

function on_Blur(){
    dateFormat(document.form1.EXDATE);
}

var flag = 0 ;

function doKeyPress(maxLen,obj){
    var str=obj.value;
    //var oSR=document.selection.createRange();
    var oSR = document.getElementById("LLINESS").value;

    if(str.length<maxLen){
      return true;
    //}else if(oSR.text.length>0){
    }else if(!checkNull(oSR, "Conditions of  Illness" ) == true){
      return true;
    }else{
      return false;
    }
}

//-------------------------------------------------------------------------
// Textarea Maxlength for Paste
//-------------------------------------------------------------------------
function checkPaste(maxLen,obj){
    var str = obj.value;
    //var oSR = document.selection.createRange();
    var oSR = document.getElementById("LLINESS").value;
    var strData = clipboardData.getData('text');
    //var iLenPaste = maxLen-str.length+oSR.text.length;
    var iLenPaste = maxLen-str.length+oSR.length;
    //oSR.text = strData.substring(0,iLenPaste);
    oSR = strData.substring(0,iLenPaste);
}

// : 2013-12-19 lixinxin @v1.7 [C20131211_51591] 医疗申请画面增加字段  function new create
function viewReason(obj){
    if(obj == "Korea" ){
        document.form1.MED_REASON.value = "999";
        document.form1.MED_ELIANAPR.value = "999";
        document.getElementById("reason").style.display = (document.getElementById("reason").style.display=="")?"none":"";
    }else{
        document.form1.MED_REASON.value = "999";
        document.form1.MED_ELIANAPR.value = "999";
        document.getElementById("reason").style.display = "none"
    }
}

//첨부 파일 보안
function fileCheck(object){
	if( object.value != "" ){
		var FileFilter = /\.(jpg|jpeg|gif|tif|bmp|png|xls|xlsx|ppt|pptx|doc|docx|pdf|hwp)$/i;
		var extArray = new Array(".jpg", ".gif", ".tif", ".bmp", ".png", ".xls", ".ppt", ".doc");

		if( !object.value.match(FileFilter)){
		     alert("<spring:message code='MSG.COMMON.UPLOAD.EXTFAIL' /> \n\n"  + "( ex:" + (extArray.join("  ")) + ")" );
		     object.select();
		     document.selection.clear();
		}
	}
}



</script>
</tags:script>
<!-- 상단 입력 테이블 시작-->
	<%--@elvariable id="resultData" type="hris.E.E17Hospital.E17HospitalDetailData1"--%>
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
				<colgroup>
            		<col width="15%" />
            		<col width="30%" />
            		<col width="15%" />
            		<col width="" />
            	</colgroup>

            	<tr>
	                <th><span class="textPink">*</span><!--Name--><spring:message code="LABEL.E.E18.0004" /></th>
	                <td colspan="3"><input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
	                   <select name="FAMI_CODE" id="FAMI_CODE" placeholder="<spring:message code="LABEL.E.E18.0004"/>" style="width:140px;">
	                            <option value="999"><!--Select--><spring:message code="LABEL.E.E18.0004" /></option>
								${f:printCodeOption(memberList, resultData.FAMI_CODE )}
	                            <!-- %= WebUtil.printOption((new E17HospitalFmemberRFC()).getCodeVector(PERNR)) % -->
	                    </select>
	                    <span class="commentOne"><spring:message code="LABEL.E.E18.0060" /><!--Please register your families first. (Menu : Personnel HR Info ->Family)--></span>
	                </td>
              </tr>
              <tr>
                 <th><span class="textPink">*</span><!--Examination Date--><spring:message code="LABEL.E.E18.0005" /></th>
                 <td>
                    <input type="text" class="date" id="EXDATE" name="EXDATE" placeholder="<spring:message code="LABEL.E.E18.0005"/>" size="10" value="${resultData.EXDATE}">
                 </td>
                 <th class="th02"><span class="textPink">*</span><!--Medical Type--><spring:message code="LABEL.E.E18.0012" /></th>
                 <td>
                    <select name="MTYPE" id="MTYPE"  style="width:140px;" placeholder="<spring:message code="LABEL.E.E18.0012"/>">
                    	${f:printCodeOption(mediCodeList, resultData.MTYPE  )}
                            <!--  %= WebUtil.printOption((new E17HospitalCodeRFC()).getMediCode()) %  -->
                            <!--  %= WebUtil.printOption(mediCodeList) % -->
                    </select>
                 </td>
              </tr>
  <!--  : 2013-12-19 lixinxin @v1.7 [C20131211_51591] 医疗申请画面增加字段 begin  -->
              <tr>
                 <th><span class="textPink">*</span><!--Treatment Location--><spring:message code="LABEL.E.E18.0046" /></th>
                 <td colspan="3">
                    <select name="MED_LOCATION" id="MED_LOCATION"  placeholder="<spring:message code="LABEL.E.E18.0046"/>" style="width:140px;" onChange="javascript:viewReason(this.value);">
                            <option value="999"><!--Select--><spring:message code="LABEL.E.E18.0014" /></option>
                            <option value="china">China</option>
                            <option value="Korea">Korea</option>
                    </select>
                    <script>document.form1.MED_LOCATION.value = '${resultData.MED_LOCATION}'</script>
                </td>
              </tr>
              <tr id="reason" style="display:none;">
                 <th><span class="textPink">*</span><!--Reason--><spring:message code="LABEL.E.E18.0061" /></th>
                 <td>
                    <select name="MED_REASON" id="MED_REASON" placeholder="<spring:message code="LABEL.E.E18.0061" />" style="width:140px;">
                            <option value="999"><!--Select--><spring:message code="LABEL.E.E18.0014" /></option>
                            <option value="Business trip"><!--Business Trip--><spring:message code="LABEL.E.E18.0047" /></option>
                            <option value="Individual"><!--Individual--><spring:message code="LABEL.E.E18.0048" /></option>
                    </select>
                    <script>document.form1.MED_REASON.value = '${resultData.MED_REASON}'</script>
                 </td>
                 <th class="th02"><!--Elian Approval--><spring:message code="LABEL.E.E18.0049" /></th>
                 <td>
                    <select name="MED_ELIANAPR" id="MED_ELIANAPR" style="width:140px;">
                            <option value="999"><!--Select--><spring:message code="LABEL.E.E18.0014" /></option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                    </select>
                    <script>document.form1.MED_ELIANAPR.value =  '${resultData.MED_ELIANAPR}'</script>
                </td>
                <script>
              		<c:if test="${resultData.MED_LOCATION eq 'Korea'}">
              			document.getElementById("reason").style.display = "";
              		</c:if>
              		<c:if test="${resultData.MED_LOCATION eq 'china'}">
           				document.getElementById("reason").style.display = "none";
           			</c:if>
              	</script>

              </tr>
               <tr>
                 <th><span class="textPink">*</span><!--Medical Type--><spring:message code="LABEL.E.E18.0012" /></th>
                 <td colspan="3">
                    <select name="MED_TYPE" id="MED_TYPE" placeholder="<spring:message code="LABEL.E.E18.0012"/>" style="width:140px;">
                            <option value="999"><!--Select--><spring:message code="LABEL.E.E18.0014" /></option>
                            <option value="Surgery"><!--Surgery--><spring:message code="LABEL.E.E18.0050" /></option>
                            <option value="Clinic"><!--Clinic--><spring:message code="LABEL.E.E18.0051" /></option>
                            <option value="Purchase Medicine"><!--Purchase Medicine--><spring:message code="LABEL.E.E18.0052" /></option>
                    </select>
                    <script>document.form1.MED_TYPE.value =  '${resultData.MED_TYPE}'</script>
                </td>
              </tr>
              <tr>
              	 <th><span class="textPink">*</span><!--Prescription--><spring:message code="LABEL.E.E18.0053" /></th>
                 <td>
                    <select name="MED_PRESCRIPTION" id="MED_PRESCRIPTION" style="width:140px;" placeholder="<spring:message code="LABEL.E.E18.0053"/>">
                            <option value="999"><!--Select--><spring:message code="LABEL.E.E18.0014" /></option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                    </select>
                    <script>document.form1.MED_PRESCRIPTION.value =  '${resultData.MED_PRESCRIPTION}'</script>
                 </td>
                 <th class="th02"><span class="textPink">*</span><!--Diagnosis Certificate--><spring:message code="LABEL.E.E18.0054" /></th>
                 <td>
                    <select name="MED_DIAGNOSIS" id="MED_DIAGNOSIS"  placeholder="<spring:message code="LABEL.E.E18.0054"/>" style="width:140px;">
                            <option value="999"><!--Select--><spring:message code="LABEL.E.E18.0014" /></option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                    </select>
                    <script>document.form1.MED_DIAGNOSIS.value =  '${resultData.MED_DIAGNOSIS}'</script>
                </td>
              </tr>
<!--: 2013-12-19 lixinxin @v1.7 [C20131211_51591] 医疗申请画面增加字段 end  -->
              <tr>
                <th><span class="textPink">*</span><!--Disease Name--><spring:message code="LABEL.E.E18.0006" /></th>
                <td colspan="3"><input type="text" name="DISEASE" id="DISEASE" value="${resultData.DISEASE}" placeholder="<spring:message code="LABEL.E.E18.0006"/>"  size="110" ></td>
              </tr>
              <tr>
                <th><!--Conditions of Illness--><spring:message code="LABEL.E.E18.0055" /></th>
                <td colspan="3">
	                <textarea cols="108" rows="4"  id="LLINESS" name="LLINESS" style="border:1px #b8b8b8 solid;padding-top:2px;" onkeypress="event.returnValue=doKeyPress(200,this)" onPaste="event.returnValue=checkPaste(200,this);" value="" size="100" >${resultData.LLINESS1}${resultData.LLINESS2}${resultData.LLINESS3}</textarea>
                </td>
              </tr>
              <tr>
                <th><!--Balance Amount--><spring:message code="LABEL.E.E18.0056" /></th>
                <td><span id="PAMT" name="PAMT"><input type="text" name="PAMT_BALANCE"  value="${f:printNumFormat(resultData.PAMT_BALANCE, 2)}" class="noBorder" size="10" readonly style="text-align:right;"></span>
                <c:choose>
                	<c:when test="${pageKind eq 'change' }">
						<input type="text" name="WAERS1"  value="${ resultData.WAERS1 }" class="noBorder" size="4" readonly>
                	</c:when>
                	<c:otherwise>
						<input type="text" name="WAERS1"  value="${ resultData.WAERS }" class="noBorder" size="4" readonly>
					</c:otherwise>
               	</c:choose>
                </td>
                <th class="th02"><span class="textPink">*</span><!--Insurance--><spring:message code="LABEL.E.E18.0062" /></th>
                <td>
                    <select name="ZINSU" id="ZINSU" placeholder="<spring:message code="LABEL.E.E18.0062"/>" onChange="javascript:ajax_change3();">
                        <option value="In" <c:if test="${resultData.ZINSU eq 'In' }"> selected</c:if> >In</option>
                        <option value="O" <c:if test="${resultData.ZINSU eq 'O' }"> selected</c:if> >Out</option>
                    </select>

                </td>
              </tr>
              <tr>
                <th><!--Total Paid Amount--><spring:message code="LABEL.E.E18.0057" /></th>
                <td colspan="3"><span id="PAMT1" name="PAMT1"><input type="text" name="PAAMT_BALANCE" style="text-align:right;" class="noBorder"  value="${f:printNumFormat(resultData.PAAMT_BALANCE, 2)}"  size="10" readonly></span>
                <c:choose>
                	<c:when test="${pageKind eq 'change' }">
						<input type="text" name="WAERS2"  value="${ resultData.WAERS1 }" class="noBorder" size="4" readonly>
                	</c:when>
                	<c:otherwise>
						<input type="text" name="WAERS2"  value="${ resultData.WAERS }" class="noBorder" size="4" readonly>
					</c:otherwise>
               	</c:choose>
                </td>
              </tr>
              <tr>
                <th><span class="textPink">*</span><!--Medical Expense--><spring:message code="LABEL.E.E18.0007" /></th>
                <td colspan="3"> <input type="text" name="EXPENSE" id="EXPENSE" placeholder="<spring:message code="LABEL.E.E18.0007"/>" style="text-align:right;" maxlength="10" value='${resultData.EXPENSE == ""? 0 : f:printNumFormat(resultData.EXPENSE, decimalNum)}' size="10" onkeyup="onlyNumber(this);" onchange="ajax_change();" />
                						<input type="text" name="WAERS"  value="${wtem}" class="noBorder" size="4" readonly/>&nbsp;
            	</td>
              </tr>
              <tr>
                <th><!--Converted Amount--><spring:message code="LABEL.E.E18.0058" /></th>
                <td colspan="3">

                <span id="rcrest" name="rcrest">
                <input type="text" name="PAAMT" id="PAAMT" style="text-align:right;" maxlength="7" value='${resultData.PAAMT == ""? 0 : f:printNumFormat(resultData.PAAMT, 2)}' size="10" class="noBorder"  readonly />
                <c:choose>
                	<c:when test="${pageKind eq 'change' }">
						<input type="text" name="WAERS3"  value="${ resultData.WAERS1 }" class="noBorder" size="4" readonly>
                	</c:when>
                	<c:otherwise>
						<input type="text" name="WAERS3"  value="${ resultData.WAERS }" class="noBorder" size="4" readonly>
					</c:otherwise>
               	</c:choose>
                <input type="hidden" name="CERT_BETG_C" style="text-align:right;" value="${resultData.CERT_BETG_C}" class="noBorder"  size="10" readonly></span></td>
            </tr>
              <!-- <span id="CERT_BETG_C" name="CERT_BETG_C"><input type="hidden" name="CERT_BETG_C" value=""></span>  -->
                <input type="hidden" name="PRATE" value="${resultData.PRATE}"/>
                <input type="hidden" name="PAMT" value="${resultData.PAAMT_BALANCE}"/>
                <input type="hidden" name="ENAME" value=""/>

			   <!-- 2016-11-18 ShiQuan [C20160928_78417] Fileupload  -->
			   <c:choose>
                	<c:when test="${ mode eq 'Build' }">
						<tr>
			                <th><spring:message code="LABEL.E.E21.0022" /> Ⅰ</th>
			                <td colspan="3">
			                	<input name="File01" size="80" type="file" onchange="javascript:fileCheck(this);" />
			            	</td>
			              </tr>
			              <tr>
			                <th><spring:message code="LABEL.E.E21.0022" /> Ⅱ</th>
			                <td colspan="3">
			                	<input name="File02" size="80" type="file" onchange="javascript:fileCheck(this);"/>
			            	</td>
			              </tr>
			              <tr>
			                <th><spring:message code="LABEL.E.E21.0022" /> Ⅲ</th>
			                <td colspan="3">
			                	<input name="File03" size="80" type="file" onchange="javascript:fileCheck(this);" />
			            	</td>
			              </tr>
			              <tr>
			                <th><spring:message code="LABEL.E.E21.0022" /> Ⅳ</th>
			                <td colspan="3">
			                	<input name="File04" size="80" type="file" onchange="javascript:fileCheck(this);" />
			            	</td>
			              </tr>
			              <tr>
			                <th><spring:message code="LABEL.E.E21.0022" /> Ⅴ</th>
			                <td colspan="3">
			                	<input name="File05" size="80" type="file" onchange="javascript:fileCheck(this);" />
			            	</td>
			              </tr>
                	  </c:when>
                	  <c:otherwise>
						   <c:forEach var="row" items="${E17HdataFile_vt}" varStatus="status">
						   <tr>
			              		<th><!--Attachment File --><spring:message code="LABEL.E.E21.0022" /></th>
			              		<td colspan="3">
			              		<a href="<c:out value='${g.servlet}'/>hris.common.DownloadedFile?fileName=<c:out value='${row.FILE_NM}'/><c:out value='${row.FILE_TYPE}'/>&filePath=<c:out value='${row.FILE_PATH}'/>"><c:out value='${row.FILE_NM}'/></a>
			              		</td>
			               </tr>
						   </c:forEach>
					  </c:otherwise>
	              </c:choose>


              <!-- 2016-11-18 ShiQuan [C20160928_78417] Fileupload  -->
        	</table>
        </div> <!-- end class="table" -->

        <div class="commentsMoreThan2">
        	<div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
        </div>
		<!-- 상단 입력 테이블 끝-->
		<!-- HIDDEN으로 처리 -->

		<!-- HIDDEN으로 처리 -->

    </div> <!-- end class="tableArea" -->

</tags-approval:request-layout>
</tags:layout>