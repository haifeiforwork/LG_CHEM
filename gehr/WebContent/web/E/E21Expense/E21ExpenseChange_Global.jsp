<%/***************************************************************************************/
/*	  System Name  	: g-HR																															*/
/*   1Depth Name		: Application                                                 																	*/
/*   2Depth Name		: Benefit Management                                                														*/
/*   Program Name	: Tuition Fee                                             																		*/
/*   Program ID   		: E21ExpenseChange.jsp                                         															*/
/*   Description  		: 장학금 신청 수정 화면                                            																		*/
/*   Note         		: 없음                                                        																				*/
/*   Creation     		: 2002-01-03  김성일                                          																		*/
/*   Update       		: 2005-03-01  윤정현                                          																		*/
/*                  		: 2005-12-13 lsa @v1.1 [C2005121201000000126]                  												*/
/*                  		: 2006-01-04 lsa @v1.2 [C2006010401000000276] 장학자금 신청화면에서 신청년도 1월만 2005년도 신청처리 */
/*                  		: 2006-11-30 lsa @v1.3 예외처리                              																	*/
/*   Update				: 2007-10-12 heli @v1.4 global hr update                                                            					*/
/*                         : 2009-05-13 jungin @v1.5 [C20090513_54934] 대만법인 소수점 입력 방지.                                    */

/*                         : 2011-08-29 liukuo @v1.6 [C20110829_53054] Tuition Fee申请记录修改页面增加申请金额字段长度.      */
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
    String E_BUKRS = PERNR_Data.E_BUKRS;

    // 반올림 변수.		2009-05-13		jungin		@v1.5 [C20090513_54934]
    int decimalNum = 2;
    if(E_BUKRS != null && (E_BUKRS == "G220" || E_BUKRS.equals("G220"))){
    	decimalNum = 0;
    }
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="E_BUKRS" value="<%=E_BUKRS %>" />
<c:set var="decimalNum" value="<%=decimalNum %>" />
<c:set var="E_BUKRS" value="<%=E_BUKRS %>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
	<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_TUTI_EXPA">
	<tags:script>
		<script>
		<!--

		var decimalNum = ${decimalNum};

		jQuery(function(){
			loads();
		});

		function loads(){

			var begda = removePoint(document.form1.BEGDA.value);
			var waers = document.form1.REIM_WAERS.value;
			var subty = document.form1.SUBTY.value;
			var schl_type = document.form1.SCHL_TYPE.value;
			var PERNR = ${PERNR};

			jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.E.Global.E21Expense.E21ExpenseAjax',
		        data: {WAERS : waers, PERNR : PERNR, BEGDA : begda, SUBTY:subty,SCHL_TYPE : schl_type, rmd : new Date().toString(), OBJPS:document.form1.OBJPS.value  },
		        success:function(data){
		        	showResponse(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		   	});
		}

		function ajax_change(){
			var begda = removePoint(document.form1.BEGDA.value);
			var waers = document.form1.REIM_WAERS.value;
			var subty = document.form1.SUBTY.value;
			var schl_type = document.form1.SCHL_TYPE.value;
			var obtem = 'objp'+document.form1.CHLD_NAME.options.selectedIndex;
			var PERNR = ${PERNR};
			if(document.getElementById(obtem)!=null){
				 document.form1.OBJPS.value = eval('document.form1.objp'+document.form1.CHLD_NAME.options.selectedIndex+'.value');
			}

			jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.E.Global.E21Expense.E21ExpenseAjax',
		        data: {WAERS : waers, PERNR : PERNR, BEGDA : begda, SUBTY:subty,SCHL_TYPE : schl_type, rmd : new Date().toString(), OBJPS:document.form1.OBJPS.value  },
		        success:function(data){
		        	showResponse(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		   	});
		}

		//2007.10.10
		//select total money
		 function ajax_change1(){
		 	if(document.form1.WAERS.value!=''){

				var waers1 = document.form1.REIM_WAERS.value;
				var waers2 = document.form1.WAERS.value;
				var betrg = removeComma(document.form1.REIM_TOTL.value);
				var time = new Date();

				jQuery.ajax({
			        type:"POST",
			        url:'/${g.servlet}hris.E.Global.E21Expense.E21ExpenseAjax1',
			        data: {waers1 : waers1, waers2 : waers2, betrg : betrg, time : time  },
			        success:function(data){
			        	showResponse1(data);
			        },
			        error:function(e){
			            alert(e.responseText);
			        }
			   	});

			}else{
				beforeSubmit();
			}
		}

		function showResponse1(originalRequest){
			if (originalRequest !='' ){
				var arr= new Array();
				arr=originalRequest.split('|');
				$('#CERT_BETG_C2').html(arr[0]);
				beforeSubmit();
			}
		}

		//select currency
		function ajax_change2(){
			var waers1 = document.form1.REIM_WAERS.value;
			var waers2 = document.form1.WAERS.value;
			var betrg = removeComma(document.form1.REIM_TOTL.value);
			var time = new Date();

			jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.E.Global.E21Expense.E21ExpenseAjax1',
		        data: {waers1 : waers1, waers2 : waers2, betrg : betrg, time : time  },
		        success:function(data){
		        	showResponse2(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		   	});
		}

		function showResponse2(originalRequest) {
			if (originalRequest!=''){
				var arr= new Array();
				arr=originalRequest.split('|');
				$('#CERT_BETG_C2').html(arr[0]);
			}
		}

		//change condition change the calculate money
		//change condition change the calculate money
		function ajax_change(){
			var begda = removePoint(document.form1.BEGDA.value);
			var waers = document.form1.REIM_WAERS.value;
			var subty = document.form1.SUBTY.value;
			var schl_type = document.form1.SCHL_TYPE.value;
			var obtem = 'objp'+document.form1.CHLD_NAME.options.selectedIndex;
			var PERNR = ${PERNR};
			if(document.getElementById(obtem)!=null){
				 document.form1.OBJPS.value = eval('document.form1.objp'+document.form1.CHLD_NAME.options.selectedIndex+'.value');
			}

			jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.E.Global.E21Expense.E21ExpenseAjax',
		        data: {WAERS : waers, PERNR : PERNR, BEGDA : begda, SUBTY:subty,SCHL_TYPE : schl_type, rmd : new Date().toString(), OBJPS:document.form1.OBJPS.value  },
		        success:function(data){
		        	showResponse(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		   	});
		}

		function showResponse(originalRequest){
			if (originalRequest!=''){
				var arr= new Array();
				arr=originalRequest.split('|');
				//alert('arr[122]='+arr[5]);
				$('#REIM_CNTH_REST').html(arr[0]);
				$('#balance').html(arr[1]);
				$('#REIM_AMTH_REST').html(unescape(arr[2]));
				$('#REIM_WAERS').html(unescape(arr[3]));
				$('#REIM_RATE1').html(unescape(arr[4]));
				$('#REIM_RATE2').html(unescape(arr[5]));
				$('#REIM_RATE3').html(unescape(arr[6]));
				$('#REIM_RATE4').html(unescape(arr[7]));
				$('#REIM_RATE5').html(unescape(arr[8]));
				$('#mtitle').html(unescape(arr[9]));
				$('#CERT_BETG_C2').html(unescape(arr[10]));
				$('#hiddData').html(unescape(arr[11]));
				$('#Attachment').html(unescape(arr[12]));

				//$('#ATTC_NORL').html(unescape(arr[13]));
				if(!document.form1.ATTC_NORL[1].checked){
					$('#ATTC_NORL').html(unescape(arr[13]));
				}

				if(document.form1.ATTC_NORL!=null){
					if(document.form1.ATTC_NORL[1].checked){
						document.form1.REIM_RAT1.value='100';
					}
				}
				if(document.form1.SUBTY.value=='0003'){     //change school also change condition
					document.getElementById("entrancefee").style.display="none";
					document.getElementById("lessionfee").style.display="none";
					document.getElementById("attendingfee").style.display="none";
					document.getElementById("contribution").style.display="none";
					document.form1.REIM_BET1.value='';
					document.form1.REIM_BET3.value='';
					document.form1.REIM_BET4.value='';
					document.form1.REIM_BET5.value='';
					document.form1.REIM_RAT1.value='';
					document.form1.REIM_RAT3.value='';
					document.form1.REIM_RAT4.value='';
					document.form1.REIM_RAT5.value='';
					document.form1.REIM_CAL1.value='';
					document.form1.REIM_CAL3.value='';
					document.form1.REIM_CAL4.value='';
					document.form1.REIM_CAL5.value='';
				}else if(document.form1.SUBTY.value=='0004'){
					document.getElementById("entrancefee").style.display="";
					document.getElementById("tuitionfee").style.display="";
					document.getElementById("lessionfee").style.display="";
					document.getElementById("attendingfee").style.display="none";
					document.getElementById("contribution").style.display="none";
					document.form1.REIM_BET4.value='';
					document.form1.REIM_BET5.value='';
					document.form1.REIM_RAT4.value='';
					document.form1.REIM_RAT5.value='';
					document.form1.REIM_CAL4.value='';
					document.form1.REIM_CAL5.value='';
				}else{
					document.getElementById("entrancefee").style.display="";
					document.getElementById("tuitionfee").style.display="";
					document.getElementById("lessionfee").style.display="";
					document.getElementById("attendingfee").style.display="";
					document.getElementById("contribution").style.display="";
				}
					Calculation();
			}
		}

		function attachmentChange(){
			document.form1.REIM_RAT1.value='100';
			Calculation();
		}

		function check_data1(){
		   var validText = "";

		   if( document.form1.CHLD_NAME.value == "" ) {
			    validText = $("#CHLD_NAME").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.CHLD_NAME.focus();
			    return false;
		   }
		   if( document.form1.SUBTY.value == "" ) {
			    validText = $("#SUBTY").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.SUBTY.focus();
			    return false;
		    }
		    if( document.form1.SCHL_TYPE.value == "" ) {
			    validText = $("#SCHL_TYPE").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.SCHL_TYPE.focus();
			    return false;
		    }
		    if( document.form1.SCHL_NAME.value == "" ) {
			    validText = $("#SCHL_NAME").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.SCHL_NAME.focus();
			    return false;
		    }
		    if( document.form1.SCHL_GRAD.value == "" ) {
			    validText = $("#SCHL_GRAD").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.SCHL_GRAD.focus();
			    return false;
		    }
		    if( document.form1.TERM_TEXT.value == "" ) {
			    validText = $("#TERM_TEXT").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.TERM_TEXT.focus();
			    return false;
		    }
		    if( document.form1.TERM_BEGD.value == "" ) {
			    validText = $("#TERM_BEGD").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.TERM_BEGD.focus();
			    return false;
		    }
		    if( document.form1.TERM_ENDD.value == "" ) {
			    validText = $("#TERM_ENDD").attr("placeholder");
		    	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");
		        document.form1.TERM_ENDD.focus();
			    return false;
		    }

			  document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
			  document.form1.TERM_BEGD.value = removePoint(document.form1.TERM_BEGD.value);
			  document.form1.TERM_ENDD.value = removePoint(document.form1.TERM_ENDD.value);
			  return true;
			}

			//function doSubmit() {
			function beforeSubmit() {
				if(check_data1()){
			 	    var str=/^\d+(\.\d+)?$/;
					if(!str.test(document.form1.SCHL_GRAD.value)) {
						alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
					  document.form1.SCHL_GRAD.focus();
					  return;
					}

					numFormat();

					if((document.form1.REIM_BET1.value!='')&&(!str.test(document.form1.REIM_BET1.value))) {
						alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
					    document.form1.REIM_BET1.focus();
					    return;
					}
					if((document.form1.REIM_BET2.value!='')&&(!str.test(document.form1.REIM_BET2.value))) {
						alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
					    document.form1.REIM_BET2.focus();
					    return;
					}
					if((document.form1.REIM_BET3.value!='')&&(!str.test(document.form1.REIM_BET3.value))) {
						alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
					    document.form1.REIM_BET3.focus();
					    return;
					}
					if((document.form1.REIM_BET4.value!='')&&(!str.test(document.form1.REIM_BET4.value))) {
						alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
					    document.form1.REIM_BET4.focus();
					    return;
					}
					if((document.form1.REIM_BET5.value!='')&&(!str.test(document.form1.REIM_BET5.value))) {
						alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
					  document.form1.REIM_BET5.focus();
					  return;
					}
					if(document.form1.REIM_BET1.value=='' && document.form1.REIM_BET2.value=='' && document.form1.REIM_BET3.value=='' && document.form1.REIM_BET4.value=='' && document.form1.REIM_BET5.value==''){
						var validText = "<spring:message code='LABEL.E.E21.0012' />";
			           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //	alert("please input Application Amount.");
					    document.form1.REIM_BET1.focus();
					    return;
					}
					var cbc=document.getElementById("CERT_BETG_C");
					if(cbc!=null){
			 			if(Number(document.form1.CERT_BETG_C.value)>Number(document.form1.REIM_AMTH_REST.value)){
			 			  alert("<spring:message code='MSG.E.E21.0001' />"); //alert("input number must less than Balance");
						  document.form1.REIM_TOTL.focus();
						  Calculation();
						  dateFormat(document.form1.BEGDA);
						  dateFormat(document.form1.TERM_BEGD);
						  dateFormat(document.form1.TERM_ENDD);
						  return;
						 }
			 		}

					return true;
				}
			}

			//change currency
			 function fn_pop(){
			    small_window=window.open("","CurrencyPop","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=430,left=100,top=100");
			    small_window.focus();
			    document.form1.target ="CurrencyPop";
			    document.form1.action = "/web/common/CurrencyPop.jsp";
			    document.form1.submit();
			}

			function evaluation(tem){
			 	document.form1.REIM_WAR1.value=tem;
			 	document.form1.REIM_WAR2.value=tem;
			 	document.form1.REIM_WAR3.value=tem;
			 	document.form1.REIM_WAR4.value=tem;
			 	document.form1.REIM_WAR5.value=tem;
			 	document.form1.REIM_WAR11.value=tem;
			 	document.form1.REIM_WAR22.value=tem;
			 	document.form1.REIM_WAR33.value=tem;
			 	document.form1.REIM_WAR44.value=tem;
			 	document.form1.REIM_WAR55.value=tem;
			    document.form1.REIM_WAERS.value=tem;
			 	ajax_change();
			}

			function banolim1(num, pos) {
				if( !isNaN(Number(num)) ){
					var posV = Math.pow(10, (pos ? pos : 0));
					return Math.round(num*posV)/posV;
				} else {
				}
				return num;
			}

			//calculate the money
			  function Calculation(){
			  	document.form1.REIM_CAL1.value=insertComma(''+banolim1(Number(removeComma(document.form1.REIM_BET1.value))*0.01*Number(document.form1.REIM_RAT1.value), decimalNum));
			  	document.form1.REIM_CAL2.value=insertComma(''+banolim1(Number(removeComma(document.form1.REIM_BET2.value))*0.01*Number(document.form1.REIM_RAT2.value), decimalNum));
			  	document.form1.REIM_CAL3.value=insertComma(''+banolim1(Number(removeComma(document.form1.REIM_BET3.value))*0.01*Number(document.form1.REIM_RAT3.value), decimalNum));
			  	document.form1.REIM_CAL4.value=insertComma(''+banolim1(Number(removeComma(document.form1.REIM_BET4.value))*0.01*Number(document.form1.REIM_RAT4.value), decimalNum));
			  	document.form1.REIM_CAL5.value=insertComma(''+banolim1(Number(removeComma(document.form1.REIM_BET5.value))*0.01*Number(document.form1.REIM_RAT5.value), decimalNum));
			  	document.form1.REIM_TOTL.value=insertComma(''+banolim1(Number(removeComma(document.form1.REIM_CAL1.value))+Number(removeComma(document.form1.REIM_CAL2.value))+Number(removeComma(document.form1.REIM_CAL3.value))+Number(removeComma(document.form1.REIM_CAL4.value))+Number(removeComma(document.form1.REIM_CAL5.value)), decimalNum));
			  	var tem = document.getElementById("CERT_BETG_C");
			 	if(tem!=null){
			 		if(Number(removeComma(document.form1.REIM_TOTL.value))>0){
			  	  	 ajax_change2();
			  	  }
			  	}
			  	var tbalance = document.getElementById("REIM_AMTH_REST");
			  	if(tbalance!=null){
			  		document.form1.REIM_AMTH_REST.value=insertComma(document.form1.REIM_AMTH_REST.value);
			  	}

			  	document.form1.REIM_BET1.value=insertComma(document.form1.REIM_BET1.value);
			  	document.form1.REIM_BET2.value=insertComma(document.form1.REIM_BET2.value);
			  	document.form1.REIM_BET3.value=insertComma(document.form1.REIM_BET3.value);
			  	document.form1.REIM_BET4.value=insertComma(document.form1.REIM_BET4.value);
			  	document.form1.REIM_BET5.value=insertComma(document.form1.REIM_BET5.value);
			  }

			//number format
			function numFormat(){
				document.form1.REIM_BET1.value=removeComma(document.form1.REIM_BET1.value);
				document.form1.REIM_BET2.value=removeComma(document.form1.REIM_BET2.value);
				document.form1.REIM_BET3.value=removeComma(document.form1.REIM_BET3.value);
				document.form1.REIM_BET4.value=removeComma(document.form1.REIM_BET4.value);
				document.form1.REIM_BET5.value=removeComma(document.form1.REIM_BET5.value);

				document.form1.REIM_CAL1.value=removeComma(document.form1.REIM_CAL1.value);
				document.form1.REIM_CAL2.value=removeComma(document.form1.REIM_CAL2.value);
				document.form1.REIM_CAL3.value=removeComma(document.form1.REIM_CAL3.value);
				document.form1.REIM_CAL4.value=removeComma(document.form1.REIM_CAL4.value);
				document.form1.REIM_CAL5.value=removeComma(document.form1.REIM_CAL5.value);
				document.form1.REIM_TOTL.value=removeComma(document.form1.REIM_TOTL.value);
			  	var tbalance = document.getElementById("REIM_AMTH_REST");
			  	if(tbalance!=null){
			  		document.form1.REIM_AMTH_REST.value=removeComma(document.form1.REIM_AMTH_REST.value);
			  	}
			  	var tem = document.getElementById("CERT_BETG_C");
			  	if(tem!=null){
			  		document.form1.CERT_BETG_C.value=removeComma(document.form1.CERT_BETG_C.value);
			  	}
			}

			function calculate1(){
				document.form1.REIM_CAL1.value=banolim1(Number(document.form1.REIM_BET1.value)*0.01*Number(document.form1.REIM_RAT1.value), decimalNum);
				Calculation();
			}

			function calculate2(){
				document.form1.REIM_CAL2.value=banolim1(Number(document.form1.REIM_BET2.value)*0.01*Number(document.form1.REIM_RAT2.value), decimalNum);
				Calculation();
			}

			function calculate3(){
				document.form1.REIM_CAL3.value=banolim1(Number(document.form1.REIM_BET3.value)*0.01*Number(document.form1.REIM_RAT3.value), decimalNum);
				Calculation();
			}

			function calculate4(){
				document.form1.REIM_CAL4.value=banolim1(Number(document.form1.REIM_BET4.value)*0.01*Number(document.form1.REIM_RAT4.value), decimalNum);
				Calculation();
			}

			function calculate5(){
				document.form1.REIM_CAL5.value=banolim1(Number(document.form1.REIM_BET5.value)*0.01*Number(document.form1.REIM_RAT5.value), decimalNum);
				Calculation();
			}

			function onlyNumber1(){
				if (!((window.event.keyCode >=48) && (window.event.keyCode <= 57)||(window.event.keyCode == 46)))
				{
					window.event.keyCode = 0 ;
				}
			}

			//check only number
			function onlyNumber(tem, num){
				var frm = document.form1;

				// 대만법인 소수점 입력 방지.		2009-05-13		jungin
				<c:if test="${E_BUKRS eq 'G220'}">
						if( (window.event.keyCode == 110) || (window.event.keyCode == 190) ){
							alert("Please input integer.");
							if(num == "1"){
								frm.REIM_BET1.value = "";
								frm.REIM_CAL1.value = "0";
							}else if(num =="2"){
								frm.REIM_BET2.value = "";
								frm.REIM_CAL2.value = "0";
							}else if(num =="3"){
								frm.REIM_BET3.value = "";
								frm.REIM_CAL3.value = "0";
							}else if(num =="4"){
								frm.REIM_BET4.value = "";
								frm.REIM_CAL4.value = "0";
							}else if(num =="5"){
								frm.REIM_BET5.value = "";
								frm.REIM_CAL5.value = "0";
							}
							document.form1.REIM_TOTL.value=insertComma(''+banolim1(Number(removeComma(document.form1.REIM_CAL1.value))+Number(removeComma(document.form1.REIM_CAL2.value))+Number(removeComma(document.form1.REIM_CAL3.value))+Number(removeComma(document.form1.REIM_CAL4.value))+Number(removeComma(document.form1.REIM_CAL5.value)), decimalNum));
						}
				</c:if>

				if( ((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) || ((window.event.keyCode >= 96) && (window.event.keyCode <= 105)) )	{	//2009-05-13	jungin
					Calculation();
				}else if((window.event.keyCode==8)||(window.event.keyCode==46)){
					Calculation();
				}else if((window.event.keyCode==37)||(window.event.keyCode==38)||(window.event.keyCode==39)||(window.event.keyCode==40)){
				}else{
					moneyChkEventForWorld(tem);
					window.event.keyCode = 0 ;
				}
			}

			var flag = 0 ;
			function EnterCheck2(object){
			    if(event.keyCode == 13){
			        flag = 1;
			        dateFormat(object);
			    }
			}

			//-->

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
	                <th><span class="textPink">*</span><!--Name--><spring:message code="LABEL.E.E21.0001" /></th>
	                <td colspan="3">
	                <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
	                    <select name="CHLD_NAME" id="CHLD_NAME" placeholder="<spring:message code="LABEL.E.E21.0001"/>" style="width:150px;" onChange="javascript:ajax_change();">
	                        <option value=""><!--Select--><spring:message code="LABEL.E.E21.0002" /></option>

							<c:if test="${not empty nameDetailData_vt}" >
							<c:forEach var="row" items="${nameDetailData_vt}" varStatus="status">
							<option value="${row}" <c:if test = "${resultData.CHLD_NAME eq row }" >selected</c:if> >${row}</option>
							</c:forEach>
							</c:if>

                    	</select>

                    	<c:forEach var="row" items="${nameObjData_vt}" varStatus="inx">
                    	<c:set var="index" value="${inx.index}"/>
                    	<input type="hidden" name="objp${index+1}" id="objp${index+1}" value="<c:out value="${row}"/>">
						</c:forEach>

                    <span class="commentOne"><spring:message code="LABEL.E.E21.0003" /><!--Please&nbsp; register&nbsp; your&nbsp; families&nbsp;first. &nbsp;(Menu &nbsp;:&nbsp;Personnel &nbsp;HR &nbsp;Info&nbsp; -> &nbsp;Family)--></span>
               	 	</td>
                </tr>

				<tr>
					<th><span class="textPink">*</span><!--School--><spring:message code="LABEL.E.E21.0004" /></th>
	                <td>
						<c:if test="${not empty schoolsKind}" >
		                <select name="SUBTY" id="SUBTY" placeholder="<spring:message code="LABEL.E.E21.0004"/>" style="width:150px;" onChange="javascript:ajax_change();">
		                     <option value=""><!--Select--><spring:message code="LABEL.E.E21.0002" /></option>
		                     ${f:printCodeOption(schoolsKind, resultData.SUBTY)}
		                </select>
						</c:if>
					</td>
					<th class="th02"><span id="Attachment" name="Attachment"><!--Attachment--><span class="textPink">*</span><spring:message code="LABEL.E.E21.0027" /></span></th>
                    <td>
	                    <span id="ATTC_NORL" name="ATTC_NORL">
	                    <input type="radio" name="ATTC_NORL" value="N" onclick="javascript:ajax_change();" <c:if test = "${resultData.ATTC_NORL eq 'N' }" >checked</c:if> disabled><!--Normal--><spring:message code="LABEL.E.E21.0026" />&nbsp;&nbsp;&nbsp;
	                    <input type="radio" name="ATTC_NORL" value="A" onclick="javascript:attachmentChange();" <c:if test = "${resultData.ATTC_NORL eq 'A' }" >checked</c:if> disabled><!--Attachment--><spring:message code="LABEL.E.E21.0027" />&nbsp;&nbsp;&nbsp;&nbsp;
	                    </span>
                    </td>
				</tr>

				<tr>
	                <th><span class="textPink">*</span><!--School Type--><spring:message code="LABEL.E.E21.0005" /></th>
	                <td>
					<c:if test="${not empty schoolsType}" >
		                <select name="SCHL_TYPE" id="SCHL_TYPE" placeholder="<spring:message code="LABEL.E.E21.0005"/>" style="width:150px;" onChange="javascript:ajax_change();">
		                	 <option value=""><!--Select--><spring:message code="LABEL.E.E21.0002" /></option>
		                     ${f:printCodeOption(schoolsType, resultData.SCHL_TYPE)}
		                </select>
					</c:if>
	                </td>
	                <th class="th02"><span class="textPink">*</span><!--School Name--><spring:message code="LABEL.E.E21.0006" /></th>
	                <td>
	                    <input type="text" name="SCHL_NAME" id="SCHL_NAME" placeholder="<spring:message code="LABEL.E.E21.0006"/>" value="${resultData.SCHL_NAME}" size="20">
	                </td>
              	</tr>

              	<tr>
	                <th><span class="textPink">*</span><!--Grade--><spring:message code="LABEL.E.E21.0007" /></th>
	                <td>
	                	<input type="text" name="SCHL_GRAD" id="SCHL_GRAD" value="${resultData.SCHL_GRAD}" size="2" placeholder="<spring:message code="LABEL.E.E21.0007"/> onkeypress="onlyNumber1();" maxlength="2"> <!--Grade--><span class="inputText"><spring:message code="LABEL.E.E21.0007" /></span>
	                	<input type="text" name="TERM_TEXT" id="TERM_TEXT" value="${resultData.TERM_TEXT}" size="2" placeholder="<spring:message code="LABEL.E.E21.0009"/> onkeypress="onlyNumber1();" maxlength="2"> <spring:message code="LABEL.E.E21.0009" /></span>
	                </td>
	                <th class="th02"><span class="textPink">*</span><!--Period--><spring:message code="LABEL.E.E21.0008" /></th>
	                <td>
					<input type="text" name="TERM_BEGD" id="TERM_BEGD" class="date required" value="${f:printDate(resultData.TERM_BEGD)}" size="10" readonly>~
					<input type="text" name="TERM_ENDD" id="TERM_ENDD" class="date required" value="${f:printDate(resultData.TERM_ENDD)}" size="10" readonly>
                	</td>
              	</tr>

              	<tr>
                  	<th><!--Rest Period--><spring:message code="LABEL.E.E21.0010" /></th>
                  	<td class="td09"><span id="REIM_CNTH_REST" name="REIM_CNTH_REST">
                  		<input type="text" name="REIM_CNTH_REST" style="text-align:right;" value="${resultData.REIM_CNTH_REST}" size="2" class="noBorder" readonly></span>
                  		&nbsp;<!--Times--><span class="inputText"><spring:message code="LABEL.E.E21.0023" /></span>
                  	</td>
                  	<th class="th02"><span id="balance" name="balance">Balance</span></th>
                  	<td>
                  		<span id="REIM_AMTH_REST" name="REIM_AMTH_REST">
                  			<input type="text" name="REIM_AMTH_REST" style="text-align:right;" value="${f:printNumFormat(resultData.REIM_AMTH_REST, 2) }" size="20" class="noBorder" readonly>
                  		</span>&nbsp;
                  		<span id="REIM_WAERS" name="REIM_WAERS">
                  			<input type="text" name="WAERS" value="${resultData.WAERS}" size="5" class="noBorder" readonly>
                  		</span>
              		</td>
                </tr>

           	</table>
		</div>  <!-- end class="table" -->
	</div> <!-- end class="tableArea" -->

	<div class="listArea">
       	<div class="table">
        	<table class="listTable">
          		<tr>
                	<th class="divide"><!--Application Fee Type--><spring:message code="LABEL.E.E21.0011" /></th>
                    <th><span class="textPink">*</span><!--Application Amount--><spring:message code="LABEL.E.E21.0012" /></th>
                    <th><!--Payment Rate--><spring:message code="LABEL.E.E21.0013" /></th>
                    <th class="lastCol"><!--Payment Amount--><spring:message code="LABEL.E.E21.0029" /></th>
            	</tr>

            	<tr class="oddRow" id="entrancefee" name="entrancefee">
	                <td class="divide"><!--Entrance Fee--><spring:message code="LABEL.E.E21.0015" /></td>
	                <td>
		                <input type="text" name="REIM_BET1" value="${f:printNumFormat(resultData.REIM_BET1, decimalNum) }" style="text-align:right;ime-mode:disabled;" size="10"  maxlength="10" onkeypress="" onkeyup="onlyNumber(this,1);" >&nbsp;
		                <input type="text" name="REIM_WAR1" value="${resultData.REIM_WAR1}" class="noBorder" size="4" readonly>
	                </td>
	                <td>
	                	<span id="REIM_RATE1" name="REIM_RATE1"><input type="text" style="text-align:right;" class="noBorder" name="REIM_RAT1" value="${f:printNum(resultData.REIM_RAT1) }" size="4" readonly></span>&nbsp;%
                	</td>
	                <td class="lastCol">
	                	<input type="text" name="REIM_CAL1" value="${f:printNumFormat(resultData.REIM_CAL1, decimalNum)}" style="text-align:right;" class="noBorder" size="10" readonly>&nbsp;&nbsp;
	                	<input type="text" name="REIM_WAR11" value="${resultData.REIM_WAR1}" class="noBorder" size="4" readonly>
	                </td>
                </tr>

                <tr id="tuitionfee" name="tuitionfee">
	                <td class="divide" ><!--Tuition Fee--><spring:message code="LABEL.E.E21.0016" /></td>
	                <td>
	                    <input type="text" name="REIM_BET2" value="${f:printNumFormat(resultData.REIM_BET2, decimalNum) }" style="text-align:right;ime-mode:disabled;" size="10" maxlength="12"  onkeypress="" onkeyup="onlyNumber(this,2);" >&nbsp;
	                    <input type="text" name="REIM_WAR2" value="${resultData.REIM_WAR2}" class="noBorder" size="4" readonly>
	                </td>
	                <td>
	                	<span id="REIM_RATE2" name="REIM_RATE2"><input type="text" style="text-align:right;" name="REIM_RAT2" value="${f:printNum(resultData.REIM_RAT2) }" size="4" class="noBorder" readonly></span>&nbsp;%
	                </td>
	                <td class="lastCol">
	                    <input type="text" name="REIM_CAL2" value="${f:printNumFormat(resultData.REIM_CAL2, decimalNum) }" style="text-align:right;" class="noBorder" size="10" readonly />&nbsp;&nbsp;
	                    <input type="text" name="REIM_WAR22" value="${resultData.REIM_WAR2}" size="4" class="noBorder" readonly/>
	                </td>
                </tr>

                <tr class="oddRow" id="lessionfee" name="lessionfee">
	                <td class="divide"><!--Lesson Fee--><spring:message code="LABEL.E.E21.0017" /></td>
	                <td>
	                    <input type="text" name="REIM_BET3" value="${f:printNumFormat(resultData.REIM_BET3, decimalNum) }" style="text-align:right;ime-mode:disabled;" size="10"  maxlength="10" onkeypress="" onkeyup="onlyNumber(this,3);" >&nbsp;
	                    <input type="text" name="REIM_WAR3" value="${resultData.REIM_WAR3}" class="noBorder" size="4" readonly />
	                </td>
	                <td>
	                    <span id="REIM_RATE3" name="REIM_RATE3"><input type="text" style="text-align:right;" name="REIM_RAT3" value="${f:printNum(resultData.REIM_RAT3) }" size="4" class="noBorder" readonly/></span>&nbsp;%
	                </td>
	                <td class="lastCol">
	                	<input type="text" name="REIM_CAL3" value="${f:printNumFormat(resultData.REIM_CAL3, decimalNum) }" size="10" style="text-align:right;" class="noBorder" readonly/>&nbsp;&nbsp;
						<input type="text" name="REIM_WAR33" value="${resultData.REIM_WAR3}" class="noBorder" size="4" readonly/>
	                </td>
                </tr>

                <tr id="attendingfee" name="attendingfee">
	                <td class="divide"><!--Attending Fee--><spring:message code="LABEL.E.E21.0018" /></td>
	                <td>
	                	<input type="text" name="REIM_BET4" value="${f:printNumFormat(resultData.REIM_BET4, decimalNum) }" style="text-align:right;ime-mode:disabled;" maxlength="10" size="10" onkeypress="" onkeyup="onlyNumber(this,4);" >&nbsp;
	                	<input type="text" name="REIM_WAR4" value="${resultData.REIM_WAR4}" class="noBorder" size="4" readonly>
	                </td>
	                <td>
	                	  <span id="REIM_RATE4" name="REIM_RATE4"><input type="text" style="text-align:right;" name="REIM_RAT4" value="${f:printNum(resultData.REIM_RAT4) }" size="4" class="noBorder" readonly></span>&nbsp;%
	                </td>
	                <td class="lastCol">
	                    <input type="text" name="REIM_CAL4" value="${f:printNumFormat(resultData.REIM_CAL4, decimalNum) }" style="text-align:right;" size="10" class="noBorder" readonly>&nbsp;&nbsp;
	                    <input type="text" name="REIM_WAR44" value="${resultData.REIM_WAR4}" size="4" class="noBorder" readonly>
	                </td>
                </tr>

                <tr class="oddRow" id="contribution" name="contribution">
               	    <td class="divide"><!--Contribution--><spring:message code="LABEL.E.E21.0019" /></td>
                    <td>
                  	    <input type="text" name="REIM_BET5" value="${f:printNumFormat(resultData.REIM_BET5, decimalNum) }" style="text-align:right;ime-mode:disabled;" maxlength="10" size="10" onkeypress="" onkeyup="onlyNumber(this,5);" >&nbsp;
                  	     <input type="text" name="REIM_WAR5" value="${resultData.REIM_WAR5}" class="noBorder" size="4" readonly>
                    </td>
                    <td>
                  	    <span id="REIM_RATE5" name="REIM_RATE5"><input type="text" name="REIM_RAT5" style="text-align:right;" value="${f:printNum(resultData.REIM_RAT5) }" size="4" class="noBorder" readonly></span>&nbsp;%
                    </td>
                    <td class="lastCol">
                        <input type="text" name="REIM_CAL5" value="${f:printNumFormat(resultData.REIM_CAL5, decimalNum) }" style="text-align:right;" size="10" class="noBorder" readonly>&nbsp;&nbsp;
                        <input type="text" name="REIM_WAR55" value="${resultData.REIM_WAR5}" size="4" class="noBorder" readonly>
                    </td>
                </tr>


           	</table>
        </div>  <!-- end class="table" -->

        <div class="buttonArea">
		    <span class="inlineComment"><span class="textPink">*</span><!--Required Field--><spring:message code="LABEL.E.E21.0020" /></span>
		    <span name="totalReim"><!--Total Payment--> <spring:message code="LABEL.E.E21.0021" /></span>
		    <input type="text" name="REIM_TOTL" style="text-align:right;" value="${resultData.REIM_TOTL}" class="noBorder" size="10" readonly/>
		    <input type="text" name="REIM_WAERS" value="${resultData.REIM_WAERS}" size="4" class="noBorder" readonly />
            &nbsp;
		    <span id="mtitle" name="mtitle"></span>
		    <span id="CERT_BETG_C2" name="CERT_BETG_C2"></span>
	    </div>
        <c:if test="${not empty E17HdataFile_vt}">
        <!-- end class=""listArea"" -->
		<div class="listArea">
            <div class="table">
            	<table class="tableGeneral">
            		<colgroup>
	            		<col width="15%" />
	            		<col width="" />
	            	</colgroup>
        			<c:forEach var="row" items="${E17HdataFile_vt}" varStatus="status">
				  	<tr>
	              		<th><!--Attachment File --><spring:message code="LABEL.E.E21.0022" /></th>
	              		<td colspan="3" style="text-align: left;">
	              		<a href="<c:out value='${g.servlet}'/>hris.common.DownloadedFile?fileName=<c:out value='${row.FILE_NM}'/><c:out value='${row.FILE_TYPE}'/>&filePath=<c:out value='${row.FILE_PATH}'/>"><c:out value='${row.FILE_NM}'/></a>
	              		</td>
	              	</tr>
				  	</c:forEach>
            	</table>
            </div>
		</div>
		</c:if>
	    <span id="hiddData" name="hiddData">
           <input type="hidden" name="PAST_COUNT" value="${resultData.REIM_CONT}">
			<input type="hidden" name="REIM_CONT" value="${resultData.REIM_CONT}">
           <input type="hidden" name="REIM_CNTH" value="${resultData.REIM_CNTH}">
			<input type="hidden" name="REIM_AMT" value="${resultData.REIM_AMT}">
           <input type="hidden" name="REIM_AMTH" value="${resultData.REIM_AMTH }">
           <input type="hidden" name="REIM_AMTH_CONV" value="${resultData.REIM_AMTH}">
       </span>
       <span id="CERT_BETG_C1" name="CERT_BETG_C1"><input type="hidden" name="CERT_BETG_C1" value=""></span>

	    <!-- Hidden Field -->
	    <input type="hidden" name = "PERNR" value="${PERNR}">
		<input type="hidden" name="OBJPS" value="${resultData.OBJPS}">

		<!-- Hidden Field -->

    </div>   	<!-- end class=""listArea"" -->


	</tags-approval:request-layout>
</tags:layout>
