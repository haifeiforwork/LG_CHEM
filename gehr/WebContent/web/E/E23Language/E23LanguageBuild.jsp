<%/***************************************************************************************/
/*    System Name   : g-HR                                                                                                                            */
/*   1Depth Name        : Application                                                                                                                   */
/*   2Depth Name        : Benefit Management                                                                                                        */
/*   Program Name   : Language Fee                                                                                                              */
/*   Program ID         : E23LanguageBuild.jsp                                                                                                      */
/*   Description        : 어학비 신청 화면                                                                                                                     */
/*   Note               : 없음                                                                                                                                        */
/*   Creation           : heli                                                                                                                              */
/*   Update             : 2007-09-13 heli      @v1.0 global hr update                                                                           */
/*                          : 2008-02-26 jungin @v1.1 Payment Period는 '0'이상이 신청가능.                                                  */
/*                         : 2009-05-13 jungin @v1.2 [C20090513_54934] 대만법인 소수점 입력 방지.                                   */
/*                         : 2009-09-11 jungin @v1.3 [C20090911_23467] ZMONTH_TOT 항목 수정.                                    */
/*                          : 2010-01-21 jungin @v1.4 [C20100120_96671] Payment Rate 출력 및 로직 처리.                            */
/*                          : 2010-06-25 jungin @v1.5 [C20100617_86310] Monthly Payment Limit 금액 계산.                            */
/*                          : 2010-12-22 liukuo  @v1.6 [C20101222_94456] Payment Amount计算逻辑修改.                          */
/*                          : 2011-08-12 liukuo  @v1.7 [C20110728_35671] Family 有关家属医疗费逻辑条件增加申请                 */
/*                          : 2011-09-09 liukuo  @v1.8 [C20110908_60581] 语言费申请时增加判断条件，如果没有录入家属来排遣地日期不允许申请 */
/*                          : 2011-05-11 lixinxin @v1.9 [C20120510_06459] 语言费申请有问题，当申请人的有一个小孩是，申请不了语言费                  */
/*                                                       解决办法：(1)当第一次登陆语言费申请画面的时候，为该页面返回objps_ost变量，此变量的作用是避免直接去取form表单里面的objps_one得值时报错，如果objps_ost有值，则说明form表单里的objps_one现在还没有不能直接取值*/
/*                                                                                (2)当Family Type发生变化时走change事件,此时将objps_ost清空，程序就会checkfrom表单里的objps_one是否有值，并传到后台去。此功能修复*/
/**/
/**/
/**/
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

    //Vector a04FamilyDetailData_vt   = (Vector)request.getAttribute("a04FamilyDetailData_vt");  //liukuo add 2011-07-29

    String PERNR = (String)request.getAttribute("PERNR");

    String pwaers       = (String)request.getAttribute("p_waers");
    String uname        = (String)request.getAttribute("uname");
    String cour_prid    = (String)request.getAttribute("cour_prid");
    String objps_ost  = (String)request.getAttribute("objps_ost");
    String E_BUKRS  = PERNR_Data.E_BUKRS;
    String E_DAT02  = PERNR_Data.E_DAT02;

    // 반올림 변수.      2009-05-13      jungin      @v1.2
    int decimalNum = 2;
    if(E_BUKRS != null && (E_BUKRS == "G220" || E_BUKRS.equals("G220"))){
        decimalNum = 0;
    }
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="pwaers" value="<%=pwaers %>" />
<c:set var="uname" value="<%=uname %>" />
<c:set var="cour_prid" value="<%=cour_prid %>" />
<c:set var="objps_ost" value="<%=objps_ost %>" />
<c:set var="E_BUKRS" value="<%=E_BUKRS %>" />
<c:set var="E_DAT02" value="<%=E_DAT02 %>" />
<c:set var="decimalNum" value="<%=decimalNum %>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >

	<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_LANG_EXPA">

	<tags:script>
		<script>
		function rComm(){
		    var frm = document.form1;
		    frm.REIM_BET.value = removeComma(frm.REIM_BET.value);

		    if(document.getElementById("REIM_AMT") != null){
		        frm.REIM_AMT.value = removeComma(frm.REIM_AMT.value);
		    }
		    if(document.getElementById("REIM_AMTH") != null){
		        frm.REIM_AMTH.value = removeComma(frm.REIM_AMTH.value);
		    }

		    frm.REIM_CAL.value = removeComma(frm.REIM_CAL.value);
		}

		function aComm(){
		    var frm = document.form1;
		    frm.REIM_BET.value = insertComma(frm.REIM_BET.value);

		    if(document.getElementById("REIM_AMT") != null){
		      frm.REIM_AMT.value = insertComma(frm.REIM_AMT.value);
		    }
		    if(document.getElementById("REIM_AMTH") != null){
		      frm.REIM_AMTH.value = insertComma(frm.REIM_AMTH.value);
		    }

		    frm.REIM_CAL.value = insertComma(frm.REIM_CAL.value);
		}

		function ajax_change(tem){
		    document.form1.REIM_BET.value           = "";
		    document.form1.REIM_CAL.value       = "";
		    document.form1.ZMONTH_TOT.value     = "0";
		    var PERNR = ${PERNR};
		    var rmd = new Date().toString();
		    var reim_war = document.form1.REIM_WAR.value;

		    jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.E.Global.E23Language.E23LanguageAjax',
		        data: {Itype : tem, PERNR : PERNR, rmd : rmd, REIM_WAR : reim_war  },
		        success:function(data){
		            showResponse(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		    });

		}

		function showResponse(originalRequest){
		    //put returned XML in the textarea
		    //if (originalRequest.responseText != ""){
		    if (originalRequest != ""){
		        var arr = new Array();

		        //arr = originalRequest.responseText.split("|");
		        arr = originalRequest.split("|");
		        $('#fcode').html(arr[0]);
		        $('#ename').html(unescape(arr[1]));
		        $('#rarest').html(arr[2]);
		        $('#zrest').html(arr[3]);
		        $('#rcrest').html(arr[4]);

		        if(arr[4] == "none"){
		            document.getElementById("cptr").style.display = "none";
		        }else{
		            document.getElementById("cptr").style.display = "";
		        }

		        $('#REIM_RAT0').html(arr[7]);
		        $('#mpl').html(arr[8]);
		        $('#cp').html(arr[9]);
		        $('#payper').html(arr[10]);
		        $('#hwaers').html(arr[11]);
		        $("#pr").html(arr[12]);
		        //$('zmonth_tot').innerHTML = arr[14];
		        $("#reim_rat").html(arr[13]);
		        $("#ZMONTH_TOT").val(arr[14]);
		    }
		}

		function ajax_change1(tem){
		    document.form1.REIM_BET.value           = "";
		    document.form1.REIM_CAL.value       = "";
		    document.form1.ZMONTH_TOT.value     = "0";

		    // 2011-05-11 lixinxin @v1.9 [C20120510_06459] row 1
		    document.form1.objps_ost.value         = "";
		    var PERNR = ${PERNR};
		    var rmd = new Date().toString();
		    var reim_war = document.form1.REIM_WAR.value;

		    jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.E.Global.E23Language.E23LanguageAjax1',
		        data: {Itype : tem, PERNR : PERNR, rmd : rmd, REIM_WAR : reim_war  },
		        success:function(data){
		            showResponse1(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		    });
		}

		function showResponse1(originalRequest)	{
		//put returned XML in the textarea

		    if (originalRequest != ""){
		        var arr = new Array();
		        arr = originalRequest.split("|");

		        $('#fcode').html(arr[0]);
		        $('#ename').html(unescape(arr[1]));
		        $('#rarest').html(arr[2]);
		        $('#zrest').html(arr[3]);
		        $('#rcrest').html(arr[4]);

		        $('#REIM_RAT0').html(arr[7]);
		        $('#mpl').html(arr[8]);
		        $('#cp').html(arr[9]);
		        $('#payper').html(arr[10]);
		        $('#hwaers').html(arr[11]);
		        $("#pr").html(arr[12]);
		        $("#reim_rat").html(arr[13]);
		    }
		}

		function ajax_change2(){  // 실행 되는지 확인 하자.
			var tem = document.getElementById("REIM_AMTH");

		    var waers1 = document.form1.REIM_WAR.value;
		    var waers2 = document.form1.WAERS1.value;
		    var betrg = removeComma(document.form1.REIM_CAL.value);
		    if(tem != null){
		    //var url = "/servlet/servlet.hris.E.Global.E23Language.E23LanguageAjax2";
		    //var pars = "waers1=" + document.form1.REIM_WAR.value + "&waers2=" + document.form1.WAERS1.value + "&betrg=" + removeComma(document.form1.REIM_CAL.value);
		    //var myAjax = new Ajax.Request(url,{method: 'get', parameters: pars, onComplete: showResponse2});

		    jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.E.Global.E23Language.E23LanguageAjax2',
		        data: {waers1 : waers1, waers2 : waers2, betrg : betrg  },
		        success:function(data){
		        	showResponse2(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		    });

		    }
		}

		function showResponse2(originalRequest) {
		    //put returned XML in the textarea
		    if (originalRequest != ""){
		        var arr = new Array();
		        arr = originalRequest.split("|");
		        $("#rcrest").html(arr[0]);

		        //if Payment Amount more than Monthly Payment Limit ,set Payment Amount equal Monthly Payment Limit.  --liukuo add 2010.12.21
		        var exRate=arr[1];
		        //20160421 add
		        document.form1.REIM_AMT.value = document.form1.REIM_AMT.value.replace(",","");
		        if(Number(removeComma(document.form1.REIM_AMTH.value))> Number(document.form1.REIM_AMT.value)){
		            alert("<spring:message code='MSG.E.E23.0002' />"); // Payment Amount is more than Monthly Payment Limit!\nIf you click<确定>,the amount should be fixed as high limited automatically .
		            //var reimAmtMonth = document.form1.REIM_AMT_MONTH.value;
		            //20160419
		            if(document.form1.PERS_GUBN.value == "02"){
		                var reimAmtMonth = 200;
		            }else{
		                var reimAmtMonth = document.form1.REIM_AMT_MONTH.value;
		                reimAmtMonth = reimAmtMonth.replace(",","");
		            }
		            var prid = document.form1.COUR_PRID.value;
		            document.form1.REIM_AMTH.value=reimAmtMonth*prid;
		            document.form1.REIM_CAL.value=Math.floor((reimAmtMonth*prid*exRate*100),2)/100;
		        }
		    }
		}

		function ajax_change3(tem){
			var objps1 = eval("document.form1.objps" + tem + ".value");
			var Itype = document.form1.FAMI_CODE.value;
			var PERNR = ${PERNR};
		    var rmd = new Date().toString();

			jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.E.Global.E23Language.E23LanguageAjax3',
		        data: {Itype : Itype, PERNR : PERNR, rmd : rmd, objps : objps1  },
		        success:function(data){
		            showResponse3(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		    });
		}

		function showResponse3(originalRequest) {
			//put returned XML in the textarea
			if (originalRequest != ""){
				var arr = new Array();
				arr = originalRequest.split("|");

				$('#rarest').html(arr[0]);
				$('#zrest').html(unescape(arr[1]));
				$('#hwaers').html(arr[2]);
			}
		}

		//function doSubmit() {
		function beforeSubmit() {

		    rComm();

		    if( check_data() ) {
		        var str = /^\d+$/;
		        if(!str.test(document.form1.COUR_PRID.value)){
		        	alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
		            document.form1.COUR_PRID.focus();
		            return;
		        }
		        if(document.getElementById("REIM_AMT") != null){

		                if(document.form1.WAERS1.value == document.form1.REIM_WAR.value){

		                    if(Number(document.form1.REIM_CAL.value) > (Number(document.form1.REIM_AMT.value) * Number(document.form1.REIM_RAT.value))){
		                      //alert(Number(document.form1.REIM_CAL.value)  + " > " +  (Number(document.form1.REIM_AMT.value) * Number(document.form1.REIM_RAT.value)));
		                      PeriodChange(document.form1.COUR_PRID.value);
		                      alert("<spring:message code='MSG.E.E23.0003' />"); //Payment Amount must be less than Monthly Payment Limit.
		                      aComm();
		                      document.form1.REIM_BET.focus();
		                      return;
		                    }
		                }

		                if(Number(document.form1.REIM_AMTH.value) == 0){
		                    alert("<spring:message code='MSG.E.E23.0004' />"); //Exchange rate does not exit.
		                    aComm();
		                    document.form1.REIM_BET.focus();
		                    return;
		                }

		                // @v1.4
		                var REIM_AMT            = document.form1.REIM_AMT.value;
		                var REIM_AMT_TOT    = Number(document.form1.REIM_AMT_MONTH.value) * Number(document.form1.COUR_PRID.value);
		                if(Number(document.form1.REIM_AMTH.value) > REIM_AMT_TOT ){

		                    document.form1.REIM_AMT.value = REIM_AMT_TOT;
		                    //alert(Number(document.form1.REIM_AMTH.value)  +   "  >  " +  Number(REIM_AMT_TOT) );
		                    alert("<spring:message code='MSG.E.E23.0005' />"); //alert("Payment Amount must be less than Monthly Payment Limit.");
		                    aComm();
		                    PeriodChange(document.form1.COUR_PRID.value);
		                    document.form1.REIM_BET.focus();
		                    document.form1.REIM_AMT.value = REIM_AMT;
		                    return;
		                }
		        }
		        if(Number(document.form1.COUR_PRID.value) > Number(document.form1.ZMONTH_REST.value)){
		        	alert("<spring:message code='MSG.E.E23.0006' />"); //alert("Input number must less than Rest Period.");
		          aComm();
		          document.form1.COUR_PRID.focus();
		          return;
		        }
		        //Employee entry over 1 year,family over 2 years,can not apply language fee     --liukuo 2010.12.28
		        var hireDate = document.form1.HIRE_DATE.value;
		        var family = document.getElementsByName("FNAME");
		        var eDate = document.getElementsByName("ENTRY_DATE");
		        var entryDate=hireDate;
		        for(k=0;k<family.length;k++){
		            if(document.form1.ENAME.value.replace(/\s/g,"")==family[k].value.replace(/\s/g,"")){
		            	entryDate=eDate[k].value;
		            }
		        }
		        //20160418 start
		        //if(document.form1.PERS_GUBN.value=="01"){
		        //  if(new Date() > new Date((Number(hireDate.substring(0,4))+1)+"/"+hireDate.substring(5,7)+"/"+hireDate.substring(8,10))){
		        //      alert("You should apply it in the limited period.");
		        //      return;
		        //  }
		        //}
		        //20160418 end
		        //如果家属来排遣地日为空则根据员工入职日期判断，如果有来排遣地日期则判断从该日期开始超过2年不能申请。 2011-08-12 liukuo   @v1.7 [C20110728_35671]
		        //如果家属来排遣地日为空则提示需要先录入该日期。  2011-09-09   liukuo  @v1.8 [C20110908_60581]
		        //如果家属来排遣地日为空则根据员工入职日期判断，如果有来排遣地日期则判断从该日期开始超过1年不能申请。 20141216 pangxiaolin
		        if(document.form1.PERS_GUBN.value=="02"){
		        	if(entryDate==""){
		                //entryDate=hireDate;
		                alert("<spring:message code='MSG.E.E23.0007' />");//alert("Please input the Entry Date in Family page.");
		                return;
		            }
		            //20160817 start
		            //if(new Date() > new Date((Number(entryDate.substring(0,4))+1)+"/"+entryDate.substring(5,7)+"/"+entryDate.substring(8,10))){
		            if(new Date() > new Date((Number(entryDate.substring(0,4))+1.5)+"/"+entryDate.substring(5,7)+"/"+entryDate.substring(8,10))){
		            //20160817 end
		                alert("<spring:message code='MSG.E.E23.0008' />");//alert("You should apply it in the limited period.");
		                return;
		            }
		        }
		        var objps_ost = eval("document.form1.ZMONTH_TOT.value");
		         //alert('sssssssssssssss='+document.form1.ZMONTH_TOT.value);
		         //alert('objps_ost='+objps_ost);
		         //return;

	            // 2011-05-11 lixinxin @v1.9 [C20120510_06459] row 6
	            var objps_ost = eval("document.form1.objps_ost.value");
	            if(objps_ost != "objps_ost"){
	                var objps_one = eval("document.form1.objps_one.value");
	                if(objps_one != null && objps_one != ""){
	                    document.form1.OBJPS.value = objps_one;
	                }
	            }

	            return true;

	            //document.form1.jobid.value  = "create";
	            //document.form1.target           ="_self";
	            //document.form1.action           = "${g.servlet}hris.E.Global.E23Language.E23LanguageBuildSV";
	            //document.form1.method       = "post";
	            //document.form1.submit();
		    }
		}

		function check_data(){
			var validText = "";
			if(document.form1.SCHL_NAME.value == "" ) {
				validText = $("#SCHL_NAME").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.SCHL_NAME.focus();
		        return false;
		    }
		    if(document.form1.REIM_BET.value == "" ) {
		    	validText = $("#REIM_BET").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		    	document.form1.REIM_BET.focus();
		        return false;
		    } else {
		      if(isNaN(document.form1.REIM_BET.value) ) {
		    	  alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
		          document.form1.REIM_BET.focus();
		          return false;
		      }
		    }
		    if(document.form1.COUR_PRID.value == "" ) {
		    	validText = "<spring:message code='LABEL.E.E23.0011' />";
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		    	document.form1.COUR_PRID.focus();
		        return false;
		    } else {
		      if(isNaN(document.form1.COUR_PRID.value)) {
		    	  alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
		          document.form1.COUR_PRID.focus();
		          return false;
		      }
		    }

		     // Payment Period는 '0'이상이 신청가능.        2008-02-26      jungin
		     if(document.form1.COUR_PRID.value <= 0){
		    	alert("<spring:message code='MSG.E.E23.0009' />"); // alert("Please apply over 0 hours.");
		        document.form1.COUR_PRID.focus();
		        return false;
		     }

		     document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value);

		     if(document.form1.ENAME.tagName == "SELECT"){
		        document.form1.OBJPS.value = eval("document.form1.objps" + document.form1.ENAME.options.selectedIndex + ".value");
		     }
		     return true;
		}

		function banolim1(num, pos) {
		    if( !isNaN(Number(num)) ){
		        var posV = Math.pow(10, (pos ? pos : 0));
		        return Math.round(num*posV)/posV;
		    } else {
		    }
		    return num;
		}

		function calculate(tem){
		    tem = removeComma(tem);
		    if(!isNaN(tem)){
		        document.form1.REIM_CAL.value   = insertComma(banolim1(Number(tem) * 0.01*Number(document.form1.REIM_RAT.value), 2) + "");
		        document.form1.REIM_BET.value   =  insertComma(tem);
		    }
		}

		function checkNum(tem){
		    if(isNaN(tem.value)){
		    	alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
		        document.form1.REIM_BET.focus();
		    }
		}

		function onlyNumber(tem)	{
		    var frm = document.form1;

		    // 대만법인 소수점 입력 방지.      2009-05-13      jungin
	    	<c:if test="${E_BUKRS eq 'G220'}">

		            if ( (window.event.keyCode == 110) || (window.event.keyCode == 190) ){
		            	alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
		                frm.REIM_BET.value = "";
		                frm.REIM_CAL.value = "";

		                if(frm.PERS_GUBN.value == "01"){
		                    frm.REIM_AMTH.value = "0.00";
		                }
		                frm.REIM_BET.focus();
		                return;
		            }
		    </c:if>

		    if( ((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) || ((window.event.keyCode >= 96) && (window.event.keyCode <= 105)) ) {   //2009-05-13    jungin
		        calculate(tem.value);
		    }else if((window.event.keyCode == 8) || (window.event.keyCode == 46)){
		        calculate(tem.value);
		    }else if((window.event.keyCode == 37) || (window.event.keyCode == 38) || (window.event.keyCode == 39) || (window.event.keyCode == 40)){
		        calculate(tem.value);
		    }else if (window.event.keyCode == 13){

		    } else{
		        moneyChkEventForWorld(tem);
		      //  window.event.keyCode = 0 ;
		    }
		    setTimeout(function() {ajax_change2()}, 500);
		}

		function onlyNumber1(tem1)	{
		    if( ((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) || ((window.event.keyCode >= 96) && (window.event.keyCode <= 105)) ){

		    }else if((window.event.keyCode == 8) || (window.event.keyCode == 46)){

		    }else if((window.event.keyCode == 37) || (window.event.keyCode == 38) || (window.event.keyCode == 39) ||( window.event.keyCode == 40)){

		    }else if(window.event.keyCode == 13){
		        PeriodChange(document.form1.COUR_PRID.value);
		    }else{
		        moneyChkEventForWorld(tem1);
		        window.event.keyCode = 0 ;
		    }
		}

		function evaluation(tem){
		    document.form1.REIM_WAR.value   = tem;
		    document.form1.REIM_WAR3.value  = tem;
		    ajax_change2();
		    <%--
		        if(typeof(eval(document.form1.FAMI_CODE))=='undefined'){
		            ajax_change(document.form1.PERS_GUBN.options[document.form1.PERS_GUBN.options.selectedIndex].value);
		        }else{
		            ajax_change1(document.form1.FAMI_CODE.options[document.form1.FAMI_CODE.options.selectedIndex].value);
		        }
		    --%>
		}

		function PeriodChange(period){  //2010-06-25    jungin
		    //var reimAmtMonth = document.form1.REIM_AMT_MONTH.value;
		    //20160419
		    if(document.form1.PERS_GUBN.value == "02"){
		        var reimAmtMonth = 200;
		    }else{
		    	var reimAmtMonth = document.form1.REIM_AMT_MONTH.value;
		        reimAmtMonth = reimAmtMonth.replace(",","");
		    }
		    document.form1.REIM_AMT.value = (Number(reimAmtMonth) * Number(period)) + ".00";
		    calculate(document.form1.REIM_BET.value);  //2010-12-23  liukuo
		}

		</script>
	</tags:script>

	<!-- 상단 입력 테이블 시작-->
	<%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
				<colgroup>
            		<col width="15%" />
            		<col width="20%" />
            		<col width="15%" />
            		<col width="" />
            	</colgroup>
				<tr>
                    <th><span class="textPink">*</span><!--Pers. Type--><spring:message code="LABEL.E.E23.0001" /></th>
                    <td>
                    	<input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
                        <span id="gubn" name="gubn">

<c:if test = "${resultData != null }" >
                              <select name="PERS_GUBN" style="width:135px;" onChange="ajax_change(this.options[this.options.selectedIndex].value)">
                                  ${f:printCodeOption(perType, resultData == null ? "01" : resultData.PERS_GUBN)}
                              </select>
</c:if>

						</span>
                    </td>
                    <th class="th02"><span class="textPink">*</span><!--Family Type--><spring:message code="LABEL.E.E23.0002" /></th>
                    <td>
                        <span id="fcode" name="fcode">

<c:if test = "${resultData != null && (!resultData.FAMI_CODE eq '' ) }" >
                             <select name="FAMI_CODE" id="FAMI_CODE" style="width:135px;" onChange="ajax_change1(this.options[this.options.selectedIndex].value)" disabled>
                                   ${f:printCodeOption(famiCode, resultData == null ? "1" : resultData.FAMI_CODE)}
                             </select>
</c:if>
                        </span>
                    </td>
                </tr>

                <tr>
                    <th><span class="textPink">*</span><!--Name--><spring:message code="LABEL.E.E23.0003" /></th>
                    <td colspan="3">
                        <span id="ename" name="ename">

                        <c:choose>
                        	<c:when test="${uname != null}">
                        		<input type="text" name="ENAME" class="noBorder" value="${uname}" size="50" readonly>
                        	</c:when>
                        	<c:otherwise>
                        		<input type="text" name="ENAME"  class="noBorder" value="${resultData.ENAME}" size="50" readonly>
                        	</c:otherwise>
                        </c:choose>

                        </span>
                    </td>
                </tr>
                <tr>
                    <th><span id="mpl" name="mpl"><!--Monthly Payment Limit--><spring:message code="LABEL.E.E23.0004" /></span></th>
                    <td>
                        <span id="rarest" name="rarest">
                            <input type="text" id="REIM_AMT" name="REIM_AMT" style="text-align:right;" value="${resultData == null ? "" : f:printNumFormat(resultData.REIM_AMT, 2)}"  class="noBorder" size="20" readonly>
                            <input type="text" name="WAERS1"  value="${resultData.REIM_WAR}" class="noBorder" size="4" readonly />
                        </span>
                    </td>
                    <th class="th02"><!--Rest Period--><spring:message code="LABEL.E.E23.0005" /></th>
                    <td>
                        <span id="zrest" name="zrest">
                            <input type="text" name="ZMONTH_REST" style="text-align:right;"  value="${resultData.ZMONTH_REST}" class="noBorder" size="1" readonly>
                        </span>&nbsp;<!--Months--><spring:message code="LABEL.E.E23.0006" />
                    </td>
                </tr>

                <tr id="cptr" name="cptr">
                    <th><span id="cp" name="cp"><!--Converted Payment--><spring:message code="LABEL.E.E23.0007" /></span></th>
                    <td>
                        <span id="rcrest" name="rcrest">
                            <input type="text" id="REIM_AMTH" name="REIM_AMTH" class="noBorder" style="text-align:right;" value="${resultData == null ? "" : f:printNumFormat(resultData.REIM_AMTH, decimalNum)}"  readonly>
                            <input type="text" name="REIM_WAR2" class="noBorder" value="${resultData.REIM_WAR}" size="4" readonly >
                        </span>
                    </td>
                    <th class="th02"><span id="pr" name="pr"><!--Payment Rate--><spring:message code="LABEL.E.E23.0008" /></span></th>
                    <td>
                        <span id="reim_rat" name="reim_rat">
                            <input type="text" id="reim_rat" name="reim_rat" class="noBorder" style="text-align:right;" value="${resultData == null ? "" : f:printNum(resultData.REIM_RAT)}"  size="1" readonly>
                        </span>&nbsp;%
                   </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><!--Education Institute--><spring:message code="LABEL.E.E23.0009" /></th>
                    <td colspan="3">
                        <span id="sname" name="sname">
                            <input type="text" name="SCHL_NAME" id="SCHL_NAME" placeholder="<spring:message code="LABEL.E.E23.0009"/>" value="" size="120" maxlength="60" >
                        </span>
                    </td>
                </tr>
                <tr>
                     <th><span class="textPink">*</span><!--Lesson Fee--><spring:message code="LABEL.E.E23.0010" /></th>
                     <td>
                        <input type="text" name="REIM_BET" id="REIM_BET" placeholder="<spring:message code="LABEL.E.E23.0010" />" style="text-align:right;" size="20" value="" maxlength="7"   onkeyup="onlyNumber(this);" onchange="ajax_change2();" />
                        <span id="rwar1" name="rwar1">
                            <input type="text" name="REIM_WAR3" size="4" value="${pwaers}" class="noBorder" readonly>
                        </span>
                    </td>
                    <th class="th02"><span class="textPink">*</span><!--Payment Period--><spring:message code="LABEL.E.E23.0011" /></th>
                    <td>
                        <span id="payper" name="payper">
                            <input type="text" name="COUR_PRID" id="COUR_PRID" style="text-align:right;" value="1" size="4" maxlength="3" onkeypress="onlyNumber1(this);" onBlur="PeriodChange(document.form1.COUR_PRID.value);">
                        </span>&nbsp;<!--Months--><spring:message code="LABEL.E.E23.0006" />
                    </td>
                </tr>
                <tr>
                    <th><!--Payment Amount--><spring:message code="LABEL.E.E23.0012" /></th>
                    <td colspan="3">
                        <input type="text" name="REIM_CAL" size="20" style="text-align:right;" class="noBorder" value="" readonly>

                        <span id="rwar2" name="rwar2"><input type="text" name="REIM_WAR" size="4" class="noBorder" value="${pwaers}" readonly></span>
                        <span id="crate" name="crate"> <input type="hidden" name="crate" value=""></span>
                        <span id="CERT_BETG_C" name="CERT_BETG_C"><input type="hidden" name="CERT_BETG_C" value="${resultData.CERT_BETG_C }"></span>
                        <span id="REIM_RAT0" name="REIM_RAT0"><input type="hidden" name="REIM_RAT"  value="${resultData.REIM_RAT }"></span>
                    </td>
                </tr>
			</table>
		</div>  <!-- end class="table" -->

		<div class="commentsMoreThan2">
        	<div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
        </div>
		<!-- 상단 입력 테이블 끝-->

	<!-- 2011-05-11 lixinxin @v1.9 [C20120510_06459] row 1  -->
	<input type="hidden" name="objps_ost" value="${objps_ost}"/>
	<input type="hidden" name="REIM_AMT_MONTH" value="${resultData == null ? "" : f:printNumFormat(resultData.REIM_AMT, 2)}">
	<input type="hidden" name="HIRE_DATE" value="${E_DAT02}">

	<!-- HIDDEN으로 처리 -->
	<span id="hwaers" name="hwaers"></span>
	<!-- <input type="hidden" name="jobid"  value=""> -->
	<input type="hidden" name="PERS_TEXT"  value="${resultData.PERS_TEXT}">
	<input type="hidden" name="FAMI_TEXT"  value="${resultData.FAMI_TEXT}">
	<input type="hidden" name="OBJPS"  value="">
	<input type="hidden" name="ZMONTH"  value="${resultData.ZMONTH}">

	<input type="hidden" id="ZMONTH_TOT" name="ZMONTH_TOT"  value="${data==null ? "0" : data.ZMONTH_TOT}">

	<input type="hidden" name="CERT_BETG"  value="${resultData.CERT_BETG}">
	<input type="hidden" name="PERNR_D"  value="${resultData.PERNR_D}">
	<input type="hidden" name="ZUNAME"  value="${resultData.ZUNAME}">
	<input type="hidden" name="AEDTM"  value="${resultData.AEDTM}">
	<input type="hidden" name="UNAME"  value="${resultData.UNAME}">

	<c:forEach var="row" items="${a04FamilyDetailData_vt}" varStatus="status">
	<input type="hidden" name="FNAME"  value="<c:out value='${row.ENAME}'/>">
    <input type="hidden" name="ENTRY_DATE"  value="<c:out value='${row.ENTDT}'/>">
	</c:forEach>

	<!-- HIDDEN으로 처리 -->

	</div> <!-- end class="tableArea" -->

	</tags-approval:request-layout>

</tags:layout>