<%/***************************************************************************************/
/*	  System Name  	: g-HR																															*/
/*   1Depth Name		: Application                                                 																	*/
/*   2Depth Name		: Benefit Management                                                														*/
/*   Program Name	: Language Fee                                             																	*/
/*   Program ID   		: E23LanguageChnage.jsp                                         															*/
/*   Description  		: 어학비 신청 수정 화면                                            																		*/
/*   Note         		: 없음                                                        																				*/
/*   Creation     		: heli                                                            																	*/
/*   Update       		: 2007-09-13 heli	   @v1.0 global hr update                          													*/
/*							: 2008-02-26 jungin @v1.1 Payment Period는 '0'이상이 신청가능.													*/
/*                         : 2009-05-13 jungin @v1.2 [C20090513_54934] 대만법인 소수점 입력 방지.                                   */
/*                         : 2009-09-11 jungin @v1.3 [C20090911_23467] ZMONTH_TOT 항목 수정.						            */
/*							: 2010-01-21 jungin @v1.4 [C20100120_96671] Payment Rate 출력 및 로직 처리.							*/
/*							: 2010-06-25 jungin @v1.5 [C20100617_86310] Monthly Payment Limit 금액 계산.							*/
/*							: 2010-12-22 liukuo  @v1.6 [C20101222_94456] Payment Amount计算逻辑修改.							*/
/*                         : 2012-01-11 lixinxin @v1.7 [C20111227_22387 ] 添加对语言费申请的修改画面的申请金额的check。    */
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

    // 반올림 변수.		2009-05-13		jungin		@v1.2
    int decimalNum = 2;
    if(E_BUKRS != null && (E_BUKRS == "G220" || E_BUKRS.equals("G220"))){
    	decimalNum = 0;
    }
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="E_BUKRS" value="<%=E_BUKRS %>" />
<c:set var="decimalNum" value="<%=decimalNum %>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
	<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_LANG_EXPA">
	<tags:script>
		<script>
		function rComm(){
			var frm = document.form1;
			frm.REIM_BET.value = removeComma(frm.REIM_BET.value);

			if(document.getElementById('REIM_AMT')!=null){
				frm.REIM_AMT.value = removeComma(frm.REIM_AMT.value);
			}
			if(document.getElementById('REIM_AMTH')!=null){
				frm.REIM_AMTH.value = removeComma(frm.REIM_AMTH.value);
			}

			frm.REIM_CAL.value = removeComma(frm.REIM_CAL.value);
		}

		function aComm(){
			var frm = document.form1;
			frm.REIM_BET.value = insertComma(frm.REIM_BET.value);

			if(document.getElementById('REIM_AMT')!=null){
			  frm.REIM_AMT.value = insertComma(frm.REIM_AMT.value);
			}
			if(document.getElementById('REIM_AMTH')!=null){
			  frm.REIM_AMTH.value = insertComma(frm.REIM_AMTH.value);
			}

			frm.REIM_CAL.value = insertComma(frm.REIM_CAL.value);
		}

		function ajax_change2(){

			var tem = document.getElementById("REIM_AMTH");
			var waers1 = document.form1.REIM_WAR.value;
		    var waers2 = document.form1.WAERS1.value;

		    var betrg = removeComma(document.form1.REIM_CAL.value);

			if(tem != null){

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
				if(Number(removeComma(document.form1.REIM_AMTH.value))> Number(document.form1.REIM_AMT.value)){
					alert("<spring:message code='MSG.E.E23.0002' />"); //alert("Payment Amount is more than Monthly Payment Limit!\nIf you click<确定>,the amount should be fixed as high limited automatically .");
					var reimAmtMonth = document.form1.REIM_AMT_MONTH.value;
					var prid = document.form1.COUR_PRID.value;
					document.form1.REIM_AMTH.value=reimAmtMonth*prid;
					document.form1.REIM_CAL.value=Math.floor((reimAmtMonth*prid*exRate*100),2)/100;
				}
			}
		}

		//function doSubmit() {
		function beforeSubmit() {
			rComm();
			if(check_data()){
		 	    var str = /^\d+$/;
				if(!str.test(document.form1.COUR_PRID.value)){
					alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
				    document.form1.COUR_PRID.focus();
				    return;
				}
				if(document.getElementById("REIM_AMT") != null){

					if(document.form1.WAERS1.value == document.form1.REIM_WAR.value){

						if(Number(document.form1.REIM_CAL.value) > (Number(document.form1.REIM_AMT.value) * Number(document.form1.REIM_RAT.value))){
						  //alert( Number(document.form1.REIM_CAL.value)  + " > " +  (Number(document.form1.REIM_AMT.value) * Number(document.form1.REIM_RAT.value)));
						  PeriodChange(document.form1.COUR_PRID.value);
						  alert("<spring:message code='MSG.E.E23.0003' />"); //alert("Payment Amount must be less than Monthly Payment Limit.");
						  aComm();
						  document.form1.REIM_BET.focus();
						  return;
						}
					}

					if(Number(document.form1.REIM_AMTH.value) == 0){
						alert("<spring:message code='MSG.E.E23.0004' />"); //alert("Exchange rate does not exit.");
						aComm();
						document.form1.REIM_BET.focus();
						return;
					}

					// @v1.4
					var REIM_AMT			= document.form1.REIM_AMT.value;
					var REIM_AMT_TOT	= Number(document.form1.REIM_AMT_MONTH.value) * Number(document.form1.COUR_PRID.value) ;
					if(Number(document.form1.REIM_AMTH.value) > REIM_AMT_TOT ){
						document.form1.REIM_AMT.value = REIM_AMT_TOT;
						//alert( Number(document.form1.REIM_AMTH.value)  +   "  >  " +  Number(REIM_AMT_TOT) );
						PeriodChange(document.form1.COUR_PRID.value);
						alert("<spring:message code='MSG.E.E23.0005' />"); //alert("Payment Amount must be less than Monthly Payment Limit.");
						aComm();
						document.form1.REIM_BET.focus();
						document.form1.REIM_AMT.value = REIM_AMT;
						return;
				  	}
				}
				if(Number(document.form1.COUR_PRID.value)>Number(document.form1.ZMONTH_REST.value)){
					alert("<spring:message code='MSG.E.E23.0006' />"); //alert("Input number must less than Rest Period.");
				  aComm();
				  document.form1.COUR_PRID.focus();
				  return;
				}
				// ZMONTH_TOT Recalculate  2010.11.15   liukuo
				document.form1.ZMONTH_TOT.value=Number(document.form1.ZMONTH_TOT.value)-Number(document.form1.REIM_AMT_PRID.value)+Number(document.form1.COUR_PRID.value);

				return true;
			}
		}

		function check_data(){
			if( checkNull(document.form1.SCHL_NAME, "Education Institute" ) == false ) {
				document.form1.SCHL_NAME.focus();
		    	return false;
		  	}
		  	if( checkNull(document.form1.REIM_BET, "Lesson Fee" ) == false ) {
		  		document.form1.REIM_BET.focus();
		    	return false;
		  	} else {
		    	if( isNaN(document.form1.REIM_BET.value) ) {
		    		alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
		      		document.form1.REIM_BET.focus();
		      		return false;
		    	}
		  	}

		    if( checkNull(document.form1.COUR_PRID, "Payment Period" ) == false ) {
				document.form1.COUR_PRID.focus();
			    return false;
			} else {
				if( isNaN(document.form1.COUR_PRID.value) ) {
					alert("<spring:message code='MSG.COMMON.0041' />"); //alert("Please input Number.");
				    document.form1.COUR_PRID.focus();
				    return false;
				}
			}

			// Payment Period는 '0'이상이 신청가능.		2008-02-26		jungin
			if(document.form1.COUR_PRID.value <= 0){
				alert("<spring:message code='MSG.E.E23.0009' />"); //alert("Please apply over 0 hours.");
				document.form1.COUR_PRID.focus();
			  	return false;
			}

		  	document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value);
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
				document.form1.REIM_CAL.value   = insertComma(banolim1(Number(tem) * 0.01*Number(document.form1.REIM_RAT.value),2) + "");
				document.form1.REIM_BET.value   = insertComma(tem);
			}
		}

		function onlyNumber(tem) {
			var frm = document.form1;

			// 대만법인 소수점 입력 방지.		2009-05-13		jungin
			<c:if test="${E_BUKRS eq 'G220'}">
					if( (window.event.keyCode == 110) || (window.event.keyCode == 190) ){
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

			if( ((window.event.keyCode >=  48) && (window.event.keyCode <= 57)) || ((window.event.keyCode >= 96) && (window.event.keyCode <= 105)) )	{	//2009-05-13	jungin
				calculate(tem.value);
			}else if((window.event.keyCode == 8)||(window.event.keyCode == 46)){
				calculate(tem.value);
			}else if((window.event.keyCode == 37)||(window.event.keyCode == 38)||(window.event.keyCode == 39)||(window.event.keyCode == 40)){
			}else if (window.event.keyCode == 13){

		    }else{
				moneyChkEventForWorld(tem);
				//window.event.keyCode = 0 ;
			}
			setTimeout(function() {ajax_change2()}, 500);
		}

		function onlyNumber1(tem1)	{
			if( ((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) || ((window.event.keyCode >= 96) && (window.event.keyCode <= 105)) ) {

			}else if((window.event.keyCode == 8)||(window.event.keyCode == 46)){

			}else if((window.event.keyCode == 37)||(window.event.keyCode == 38)||(window.event.keyCode == 39)||(window.event.keyCode == 40)){

			}else if(window.event.keyCode == 13){
				PeriodChange(document.form1.COUR_PRID.value);
			}else{
				moneyChkEventForWorld(tem1);
				window.event.keyCode = 0 ;
			}
		}

		function evaluation(tem){
		 	document.form1.REIM_WAR.value=tem;
		 	document.form1.REIM_WAR3.value=tem;
		 	ajax_change2();
			<%--
			if(typeof(eval(document.form1.FAMI_CODE))=='undefined'){
		 		ajax_change(document.form1.PERS_GUBN.options[document.form1.PERS_GUBN.options.selectedIndex].value);
		 	}else{
		 		ajax_change1(document.form1.FAMI_CODE.options[document.form1.FAMI_CODE.options.selectedIndex].value);
		 	}
		 	--%>
		}

		function PeriodChange(period){	//2010-06-25	jungin
			var reimAmtMonth = document.form1.REIM_AMT_MONTH.value;
			document.form1.REIM_AMT.value = (Number(reimAmtMonth) * Number(period)) + ".00";
			calculate(document.form1.REIM_BET.value);  //2010-12-23  liukuo
		}

		function load(){
			var month = document.form1.REIM_AMT_MONTH.value;
			var period = document.form1.REIM_AMT_PRID.value;
			document.form1.REIM_AMT_MONTH.value = month / period;

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
	<%--
									<select name="PERS_GUBN" class="input03" onChange="ajax_change(this.options[this.options.selectedIndex].value)" >
			    	                      <%= WebUtil.printOption((Vector)languageCode.get(0),data==null ? "01" : data.PERS_GUBN) %>
			                         </select>
	 --%>
	     				<input type="text" name="pname" value="${f:printOptionValueText(perType, resultData.PERS_GUBN  )}" class="noBorder" readonly>
	     				<input type="hidden" name="PERS_GUBN" value="${resultData.PERS_GUBN}">
	               		</span>
					 </td>
	                 <th class="th02"><span class="textPink">*</span><!--Family Type--><spring:message code="LABEL.E.E23.0002" /></th>
	                 <td>
	                 	<span id="fcode" name="fcode">

<c:if test = "${resultData.FAMI_CODE ne '' }" >
<%--
								 <select name="FAMI_CODE" class="input03" onChange="ajax_change1(this.options[this.options.selectedIndex].value)"  <%= data.FAMI_CODE.equals("") ? "disabled" : "" %>>
		    	                      <%= WebUtil.printOption((Vector)languageCode.get(1),data==null ? "1" : data.FAMI_CODE) %>
		                         </select>
--%>
      					<input type="text" name="ftname" value="${f:printOptionValueText(famiCode, resultData.FAMI_CODE )}" readonly>
      					<input type="hidden" name="FAMI_CODE" value="${resultData.FAMI_CODE}">
</c:if>
						</span>
                    </td>
                </tr>

            	<tr>
	                <th><span class="textPink">*</span><!--Name--><spring:message code="LABEL.E.E23.0003" /></th>
	                <td colspan="3">
	                 	<span id="ename" name="ename">
	                   		<input type="text" name="ENAME"  value="${resultData.ENAME}" class="noBorder" size="50" readonly>
	                   	</span>
	                 </td>
                </tr>

                <tr>
                <%--  2012-01-11 lixinxin @v1.7 [C20111227_22387 ] 添加对语言费申请的修改画面的申请金额的check。
                     <td class="td01" width="120"><span id="mpl" name="mpl"><% if(data.PERS_GUBN.equals("02")){ %>Payment&nbsp;Rate<% }else{ %>Month&nbsp;Payment&nbsp;Limit<%} %></span></td>
                 --%>
	                 <th><span id="mpl" name="mpl"><!--Payment Rate--><spring:message code="LABEL.E.E23.0008" /></span></th>
	                 <td>
	                 	<span id="rarest" name="rarest">
	<%--2012-01-11 lixinxin @v1.7 [C20111227_22387 ] 添加对语言费申请的修改画面的申请金额的check。
		 if(data.PERS_GUBN.equals("02")){ --%>
						<input type="text" name="REIM_RAT" size="10" style="text-align:right;" value="${f:printNum(resultData.REIM_RAT) }" class="noBorder" readonly>&nbsp;%
	<%-- }else{  --%>
	                  	<input type="text" id="REIM_AMT" name="REIM_AMT" style="text-align:right;width:60px;" value="${f:printNumFormat(resultData.REIM_AMT, 2) }" class="noBorder" readonly>
	                  	<input type="text" name="WAERS1"  value="${resultData.WAERS1}" class="noBorder" size="4" readonly>
	<%-- } --%>
	                 	</span>
                	 </td>
	                 <th class="th02"><!--Rest Period--><spring:message code="LABEL.E.E23.0005" /></th>
	                 <td><span id="zrest" name="zrest">
	                		<input type="text" name="ZMONTH_REST" style="text-align:center;" value="${resultData.ZMONTH_REST}" class="noBorder" size="1" readonly></span>
							<!--Months--><spring:message code="LABEL.E.E23.0006" />
	                </td>
                </tr>

                <%--2012-01-11 lixinxin @v1.7 [C20111227_22387 ] 添加对语言费申请的修改画面的申请金额的check。
                <tr id="cptr" name="cptr" style="display:<% if(data.PERS_GUBN.equals("02")){ %>none<%}else{%>block<%} %>">
                 --%>
                <tr id="cptr" name="cptr" >
                    <th><span id="cp" name="cp"><!--Converted Payment--><spring:message code="LABEL.E.E23.0007" /></span></th>
                    <td colspan="3">
                  	<span id="rcrest" name="rcrest">

                    <input type="text" id="REIM_AMTH" name="REIM_AMTH" style="text-align:right;" value="${f:printNumFormat(resultData.REIM_AMTH, 2) }" class="noBorder" readonly>
                    <input type="text" name="REIM_WAR2" value="${resultData.WAERS1}" class="noBorder" size="4" readonly >

                  	</span>
                  	</td>
            	</tr>

            	<tr>
                	<th><span class="textPink">*</span><!--Education Institute--><spring:message code="LABEL.E.E23.0009" /></th>
                	<td colspan="3">
                	<span id="sname" name="sname">
                		<input type="text" name="SCHL_NAME"  value="${resultData.SCHL_NAME}" size="120" maxlength="60" >
                	</span>
                	</td>
              	</tr>
              	<tr>
	                <th><span class="textPink">*</span><!--Lesson Fee--><spring:message code="LABEL.E.E23.0010" /></th>
	               	<td>
                 		<input type="text" name="REIM_BET" style="text-align:right;" size="20" value="${f:printNumFormat(resultData.REIM_BET, decimalNum) }" maxlength="20"  onkeyup="onlyNumber(this);" onchange="ajax_change2();"/ >
                 		<span id="rwar1" name="rwar1">
                 			<input type="text" name="REIM_WAR3" size="4"  value="${resultData.REIM_WAR}" class="noBorder" readonly>
                   		</span>
                 	</td>
					<th class="th02"><span class="textPink">*</span><!--Payment Period--><spring:message code="LABEL.E.E23.0011" /></th>
	                <td><span id="payper"  name="payper">
					<input type="text" name="COUR_PRID"  style="text-align:right;" value="${resultData.COUR_PRID}" size="4"  maxlength="3"  onkeypress="onlyNumber1(this);" onBlur="PeriodChange(document.form1.COUR_PRID.value);"></span>
					&nbsp;<!--Months--><spring:message code="LABEL.E.E23.0006" />
		            </td>
	            </tr>
	            <tr>
	                <th><!--Payment Amount--><spring:message code="LABEL.E.E23.0012" /></th>
	                <td colspan="3">

	                <input type="text" name="REIM_CAL" size="20" style="text-align:right;" value="${f:printNumFormat(resultData.REIM_CAL, decimalNum) }" class="noBorder" readonly>

	                <span id="rwar2" name="rwar2"><input type="text" name="REIM_WAR"  value="${resultData.REIM_WAR}" class="noBorder" readonly></span>
					<span id="crate" name="crate"><input type="hidden" name="crate" value=""></span>
	   				<span id="CERT_BETG_C" name="CERT_BETG_C"><input type="hidden" name="CERT_BETG_C" value="${resultData.CERT_BETG_C}"></span>

	                </td>
              	</tr>


           	</table>
		</div>  <!-- end class="table" -->

		<div class="commentsMoreThan2">
        	<div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
        </div>
		<!-- 상단 입력 테이블 끝-->

		<input type="hidden" name="REIM_AMT_MONTH" value="${resultData.REIM_AMT}">
		<input type="hidden" name="REIM_AMT_PRID" value="${resultData.COUR_PRID}">

		<!-- HIDDEN으로 처리 -->
		<span id="hwaers" name="hwaers">
		<%--: 2012-01-11 lixinxin @v1.7 [C20111227_22387 ] 添加对语言费申请的修改画面的申请金额的check。   if(data.PERS_GUBN.equals("02")) --%>
		<input type="hidden" name="WAERS9" value="${resultData.WAERS1}" >
		<%--} --%>
		</span>

         <input type="hidden" name="PERS_TEXT"  value="${resultData.PERS_TEXT}">
         <input type="hidden" name="FAMI_TEXT"  value="${resultData.FAMI_TEXT}">

         <input type="hidden" name="ZMONTH"  value="${resultData.ZMONTH}">
         <span id="zmonth_tot" name="zmonth_tot">
         	<input type="hidden" name="ZMONTH_TOT"  value="${resultData.ZMONTH_TOT}">
		 </span>

         <input type="hidden" name="CERT_BETG"  value="${resultData.CERT_BETG}">
         <input type="hidden" name="PERNR_D"  value="${resultData.PERNR_D}">
         <input type="hidden" name="ZUNAME"  value="${resultData.ZUNAME}">
		 <input type="hidden" name="OBJPS"  value="${resultData.OBJPS}">
         <input type="hidden" name="UNAME"  value="${resultData.UNAME}">
		 <!-- HIDDEN으로 처리 -->

	</div> <!-- end class="tableArea" -->

	</tags-approval:request-layout>
</tags:layout>
