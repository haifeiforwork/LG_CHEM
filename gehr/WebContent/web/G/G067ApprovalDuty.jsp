<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: HR Approval Box                                                 															*/
/*   2Depth Name  	: Requested Document                                                   													*/
/*   Program Name 	: Duty Application                                                																*/
/*   Program ID   		: G67ApprovalDuty.jsp                                             															*/
/*   Description  		: 직반(Duty)을 결재 하는 화면                           																			*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 					                                          																		*/
/*   Update       		: 2008-06-10 jungin @v1.0 [C20080528_73407] 결제자 직반유형 변경저장.										*/
/*							: 2008-12-05 jungin @v1.1 [C20081202_66724] 근무시간과 Duty신청시간의 중복체크						*/
/*							: 2009-04-23 jungin @v1.2 [C20090413_38010] 공휴일 직반 신청 및 방지.										*/
/*							: 2009-12-23 jungin	@v1.3 [C20091222_81370] BOHAI법인 통문시간 출력										*/
/*							: 2010-04-28 jungin	@v1.4 [C20100427_55533] DAGU법인 통문시간 출력										*/
/*							: 2011-01-19 liu kuo @v1.5  [C20110118_09919]Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청	*/
/***************************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<tags:layout css="ui_library_approval.css" script="dialog.js" >
<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
<tags-approval:detail-layout titlePrefix="TAB.COMMON.0037" updateUrl="${g.servlet}hris.D.D19Duty.D19DutyChangeSV">
	<tags:script>
		<script>
		<!--

		jQuery(function(){
			on_Load();
		});

		function on_Load(){

			var PERNR = "<c:out value='${resultData.PERNR}'/>";
			var jobid = "check";
			var DUTY_DATE = removePoint(document.form1.DUTY_DATE.value) ;

			//alert('DUTY_DATE='+DUTY_DATE);
		    jQuery.ajax({
		        type:"post",
		        //dataType: "json",
		        url:'${g.servlet}hris.D.D19Duty.D19DutyCheckSV',
		        data: {jobid : jobid, PERNR : PERNR, DUTY_DATE : DUTY_DATE },
		        success:function(data){
		        	showResponse1(data);
		        },
		        error:function(e){
		            alert("error="+e.responseText);
		        }
		    });
	    }

		function showResponse1(originalRequest){
		    var resText = originalRequest;
		    //var resText = originalRequest.split(",")[0];
		    resText = unescape(resText);
		    var t = eval('(' + resText + ')');

		   // alert(resText);return;

		    $("#ZJIKCH").val( t.ZJIKCH);
		    $("#ZJIKCH1").val( t.TTOUT);

		    /*for(i in t){
				  if(typeof(i) != 'Function' && i != 'toJSONString'){
					  try{
						  	if(eval("t." + i) != ''){

						  	//	alert('aaaaaaaaa='+ eval("t." + i)  );		//alert('bbbb='+ i   );
						  	//	alert('cccc='+eval("$('"+i+"')").type   );

						  		if(eval("$('"+i+"')").type == 'text')
						  			eval("$('"+i+"')").value = eval("t." + i) == '|' ? "" : eval("t." + i);
						  		else(eval("$('"+i+"')").tagName == 'span')
						  			eval("$('"+i+"')").innerText = eval("t." + i) == '|' ? "" : eval("t." + i);
						  	}
					  }catch(e){
					  }
				  }
			}*/

		    $("#TPROG1").val( t.TPROG1 );
			$("#TTEXT1").html( t.TTEXT1 );
			$("#BEGUZ1").val( t.BEGUZ1 );
			$("#ENDUZ1").val( t.ENDUZ1 );
			$("#TPROG2").val( t.TPROG2 );
			$("#TTEXT2").html( t.TTEXT2 );
			$("#BEGUZ2").val( t.BEGUZ2 );
			$("#ENDUZ2").val( t.ENDUZ2 );
			$("#TTOUT").val( t.TTOUT );

		    /*for(i in t){
		          if(typeof(i) != 'Function' && i != 'toJSONString'){
		              try{
		                    if(eval("t." + i) != ''){
		                        if(eval("$('"+i+"')").type == 'text')
		                            eval("$('"+i+"')").value = eval("t." + i) == '|' ? "" : eval("t." + i);
		                        else(eval("$('"+i+"')").tagName == 'span')
		                            eval("$('"+i+"')").innerText = eval("t." + i) == '|' ? "" : eval("t." + i);
		                    }
		              }catch(e){
		              }
		          }
		    }*/

			$('#ZJIKCH').html( t.ZJIKCH );
			$('#HOLIDAY').html( t.ZHOLIDAY == 'X'?'Holiday':'Non Holiday' );
			$('#ZHOLIDAY2').val( t.ZHOLIDAY );
		}

		 //---------- 직반 유형선택할때 직반금액변화------------
	    function ajax_change(tem){

	    	var frm = document.form1;

	  		//ZHOLIDAY1 필드 추가.	2008.01.17
	  		document.form1.time.value = document.form1.ZHOLIDAY1.value;
		    frm.DUTY_DATE.value = removePoint(frm.DUTY_DATE.value);

		    var today = frm.DUTY_DATE.value;
			var JIKCH = frm.ZJIKCH.value;
			var time = frm.time.value;
			var ANZHL = frm.ANZHL.value;

			var PERNR = "<c:out value='${resultData.PERNR}'/>";

		    jQuery.ajax({
		        type:"post",
		        //dataType: "json",
		        url:'${g.servlet}hris.G.G067DutyAjax',
		        data: {Itype : tem, PERNR : PERNR, today : today, JIKCH:JIKCH, time : time ,ANZHL : ANZHL },
		        success:function(data){
		        	frm.DUTY_DATE.value = addPointAtDate(frm.DUTY_DATE.value);
		        	showResponse(data);
		        },
		        error:function(e){
		            alert("error="+e.responseText);
		        }
		    });
	    }

		function showResponse(originalRequest){
			//put returned XML in the textarea
			if (originalRequest!=''){
				var arr= new Array();
				//arr = originalRequest.responseText.split('|');
				arr = originalRequest.split('|');
				//alert(' arr[0]=  '  + arr[0] );
				$('#BETRG').html ( arr[0] );
				//alert(' arr[1]=  '  + arr[1] );
				$('#WAERS').html( arr[1] );
			    $('#message').val(arr[2]);
			}
		}

		function beforeAccept() {
           	var frm = document.form1;

           	var flag= "<c:out value='${flag}'/>";

           	if(flag != "Y"){
        		alert("You can't apply this data in payroll period");
        		return;
        	}else{
        		//**************************************************************************************************************
	   			 // 근무시간과 Duty신청시간의 중복체크.		2008-12-05		jungin		@v1.1 [C20081202_66724]
	                // Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청  	2011-01-19		liukuo		@v1.5 [C20110118_09919]
	   			 if( document.form1.BUKRS.value != null && (document.form1.BUKRS.value == "G110" || document.form1.BUKRS.value == "G280" || document.form1.BUKRS.value == "G370")){

	   				 if((document.form1.BEGUZ.value != '' && document.form1.ENDUZ.value != '') && document.form1.TPROG1.value != "OFF"){

	   			 		if(document.form1.ZHOLIDAY2.value == "X"){		// 법정공휴일.	2009-04-13		jungin		@v1.2 [C20090413_38010]

	   					}else{

	   						//check whether overtime overlaps work time
	   						if(document.form1.BEGUZ1.value < document.form1.ENDUZ1.value){
	   							if(document.form1.BEGUZ.value != ''){
	   								if(document.form1.BEGUZ.value < document.form1.ENDUZ1.value && document.form1.BEGUZ.value > document.form1.BEGUZ1.value){
	   									alert('Duty time overlaps with working time , please enter right time period.');
	   									return;
	   								}
	   								if(document.form1.ENDUZ.value > document.form1.BEGUZ1.value && document.form1.ENDUZ.value < document.form1.ENDUZ1.value){
	   									alert('Duty time overlaps with working time , please enter right time period.');
	   									return;
	   								}
	   								if(document.form1.ENDUZ.value >= document.form1.ENDUZ1.value && document.form1.BEGUZ.value <= document.form1.BEGUZ1.value){
	   									alert('Duty time overlaps with working time , please enter right time period.');
	   									return;
	   								}
	   								if( document.form1.ENDUZ.value <= document.form1.BEGUZ1.value && document.form1.BEGUZ.value <= document.form1.BEGUZ1.value && document.form1.BEGUZ.value >= document.form1.ENDUZ.value){
	   									alert('Duty time overlaps with working time , please enter right time period.');
	   									return;
	   								}
	   								if(document.form1.ENDUZ.value >= document.form1.ENDUZ1.value && document.form1.BEGUZ.value >= document.form1.ENDUZ1.value && document.form1.BEGUZ.value >= document.form1.ENDUZ.value){
	   									alert('Duty time overlaps with working time , please enter right time period.');
	   									return;
	   								}
	   							}
	   						}
	   						if(document.form1.BEGUZ1.value > document.form1.ENDUZ1.value){
	   						     if(document.form1.BEGUZ.value != ''){
	   						       if(document.form1.BEGUZ.value >= document.form1.BEGUZ1.value || document.form1.BEGUZ.value < document.form1.ENDUZ1.value){
	   						       	    alert('Duty time overlaps with working time , please enter right time period.');
	   									return;
	   								}
	   						       if(document.form1.ENDUZ.value > document.form1.BEGUZ1.value || document.form1.ENDUZ.value <= document.form1.ENDUZ1.value){
	   						       	    alert('Duty time overlaps with working time , please enter right time period.');
	   									return;
	   								}
	   						       if(document.form1.BEGUZ.value >= document.form1.ENDUZ.value && document.form1.ENDUZ.value > document.form1.ENDUZ1.value && document.form1.BEGUZ.value < document.form1.BEGUZ1.value){
	   						       	    alert('Duty time overlaps with working time , please enter right time period.');
	   									return;
	   								}
	   							 }
	   						}
	   					}
	   				}
	   			}
	   		    //**************************************************************************************************************

       		}

	        var frm = document.form1;
	        if(frm.BETRG == undefined){
	 	        alert("Please input Reimburse Amount.");
	 	        return;
	 		} // end if

	 		/*afterAccept 로 이동
	 		frm.BEGDA.value = removePoint(frm.BEGDA.value);
	 		frm.DUTY_DATE.value = removePoint(frm.DUTY_DATE.value);
	 		if(frm.BEGUZ1.value != '')
	  			frm.BEGUZ1.value = frm.BEGUZ1.value.replace(":","") + "00";
	 		if(frm.ENDUZ1.value != '')
	 			frm.ENDUZ1.value = frm.ENDUZ1.value.replace(":","") + "00";
	 		if(frm.BEGUZ2.value != '')
	 			frm.BEGUZ2.value = frm.BEGUZ2.value.replace(":","") + "00";
	 		if(frm.ENDUZ2.value != '')
	 			frm.ENDUZ2.value = frm.ENDUZ2.value.replace(":","") + "00";
	 		if(frm.BEGUZ.value != '')
	 			frm.BEGUZ.value = frm.BEGUZ.value.replace(":","") + "00";
	 		if(frm.ENDUZ.value != '')
	 			frm.ENDUZ.value = frm.ENDUZ.value.replace(":","") + "00"; */

	     	//***********************************************************************************
	 		// 결제자 직반유형 변경저장.		2008-06-10		jungin		[C20080528_73407] @v1.0
	       // 	frm.DUTY_CON.value = frm.DUTY_CON1.options[form1.DUTY_CON1.selectedIndex].value;
	        	//alert("DUTY_CON				:		"		+ frm.DUTY_CON.value);
	        	//***********************************************************************************


        	return true;
     	}

		function afterAccept() {
	    	var frm = document.form1;

	    	frm.BEGDA.value = removePoint(frm.BEGDA.value);
	   		frm.DUTY_DATE.value = removePoint(frm.DUTY_DATE.value);
	   		if(frm.BEGUZ1.value != '')
	    			frm.BEGUZ1.value = frm.BEGUZ1.value.replace(":","") + "00";
	   		if(frm.ENDUZ1.value != '')
	   			frm.ENDUZ1.value = frm.ENDUZ1.value.replace(":","") + "00";
	   		if(frm.BEGUZ2.value != '')
	   			frm.BEGUZ2.value = frm.BEGUZ2.value.replace(":","") + "00";
	   		if(frm.ENDUZ2.value != '')
	   			frm.ENDUZ2.value = frm.ENDUZ2.value.replace(":","") + "00";
	   		if(frm.BEGUZ.value != '')
	   			frm.BEGUZ.value = frm.BEGUZ.value.replace(":","") + "00";
	   		if(frm.ENDUZ.value != '')
	   			frm.ENDUZ.value = frm.ENDUZ.value.replace(":","") + "00";

	       	//***********************************************************************************
	   		// 결제자 직반유형 변경저장.		2008-06-10		jungin		[C20080528_73407] @v1.0
	       	frm.DUTY_CON.value = frm.DUTY_CON1.options[form1.DUTY_CON1.selectedIndex].value;
	       	//alert("DUTY_CON				:		"		+ frm.DUTY_CON.value);
	       	//***********************************************************************************
	   }

	   function beforeReject() {
           var frm = document.form1;
			/*
           frm.BEGDA.value = removePoint(frm.BEGDA.value);
	 		frm.DUTY_DATE.value = removePoint(frm.DUTY_DATE.value);
	 		if(frm.BEGUZ1.value != '')
	 		frm.BEGUZ1.value = frm.BEGUZ1.value.replace(":","") + "00";
	 		if(frm.ENDUZ1.value != '')
			frm.ENDUZ1.value = frm.ENDUZ1.value.replace(":","") + "00";
			if(frm.BEGUZ2.value != '')
			frm.BEGUZ2.value = frm.BEGUZ2.value.replace(":","") + "00";
			if(frm.ENDUZ2.value != '')
			frm.ENDUZ2.value = frm.ENDUZ2.value.replace(":","") + "00";
			if(frm.BEGUZ.value != '')
			frm.BEGUZ.value = frm.BEGUZ.value.replace(":","") + "00";
			if(frm.ENDUZ.value != '')
			frm.ENDUZ.value = frm.ENDUZ.value.replace(":","") + "00";
	        frm.DUTY_CON.value = frm.DUTY_CON1.value;
           */

            return true;
       }


		//-->

		</script>
	</tags:script>

	<%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>
	<div class="tableArea">
          <div class="table">
              <table class="tableGeneral">
               <colgroup>
	           		<col width="20%" />
            		<col width="25%" />
            		<col width="15%" />
            		<col width="" />
	           	</colgroup>

	           	<tr>
                    <th><span class="textPink">*</span> <!--Duty Date--><spring:message code="LABEL.D.D19D.0001" /></th>
                    <td colspan="3">
                    	<input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" />
                        <input type="text" name="DUTY_DATE" id="DUTY_DATE" size="15" value="${f:printDate(resultData.DUTY_DATE)}" readonly />
                    </td>
                </tr>
                <tr>
					<th><span class="textPink">*</span><spring:message code="LABEL.D.D19D.0002" />(<spring:message code="LABEL.D.D19D.0010" />) <!-- Duty Type(Request)--></th>
					<td>
						<input type="hidden" name="DUTY_REQ" id="DUTY_REQ" value="<c:out value='${resultData.DUTY_REQ}'/>" />
						<input type="text" name="DUTY_TXT" size="20" value="${f:printOptionValueText(duty, resultData.DUTY_REQ  )}" class="noBorder" readonly />
					</td>
					<th class="th02"><span class="textPink">*</span><spring:message code="LABEL.D.D19D.0002" />(<spring:message code="LABEL.D.D19D.0011" />) <!-- Duty Type(Confirm)--></th>
					<td>

						<c:choose>
                        	<c:when test="${APPU_TYPE eq '02'}">
                        		<select name="DUTY_CON1" style="width:110px;" onChange="ajax_change(this.options[this.options.selectedIndex].value)">
			    	               ${f:printCodeOption(duty, resultData.DUTY_REQ == "" ? "0001" : resultData.DUTY_REQ)}
			                    </select>
			                    <input type="hidden" value="<c:out value='${resultData.LGART}'/>" name="LGART" id="LGART" />
                        	</c:when>
                        	<c:otherwise>
                        		<select name="DUTY_CON1" style="width:110px;" disabled >
			    	               ${f:printCodeOption(duty, resultData.DUTY_REQ == "" ? "0001" : resultData.DUTY_REQ)}
			                    </select>
                        	</c:otherwise>
                        </c:choose>
                        <input type="hidden" value="<c:out value='${ resultData.DUTY_REQ}'/>" name="DUTY_CON"  id="DUTY_CON" />

					</td>
                </tr>

                <tr>
					<th><span class="textPink">*</span><!-- Duty Time--><spring:message code="LABEL.D.D19D.0003" /></th>

					<c:choose>
						<c:when test="${ E_BUKRS eq 'G110' || E_BUKRS eq 'G280' || E_BUKRS eq 'G370' }" >
						<td>
	                         <input type="text" name="BEGUZ" size="7" class="noBorder"  value="${ f:printTime( resultData.BEGUZ ) }"  readonly />
	                         ~
	                         <input type="text" name="ENDUZ" size="7" class="noBorder"  value="${ f:printTime( resultData.ENDUZ ) }" readonly />&nbsp;
	                         <input type="text" name="ANZHL" size="3" class="noBorder"  value="<c:out value='${ resultData.ANZHL}'/>"  readonly  style="text-align:right;">
	                        <!--hour(s)--><spring:message code="LABEL.D.D19D.0004" />

                        </td>
                        <th class="th02"><span class="textPink">*</span> Act. Time</th>
	                    <td>
	                   		${f:printDate(E_BEGDATE)} &nbsp;${ f:printTime( E_BEGTIME ) } ~ ${f:printDate(E_ENDDATE)} &nbsp;${ f:printTime( E_ENDTIME ) }
	                    </td>
						</c:when>

						<c:otherwise>
						<td colspan="3">
							<input type="text" name="BEGUZ" id="BEGUZ" size="7" value="${ f:printTime( resultData.BEGUZ ) }" readonly />
							~
							<input type="text" name="ENDUZ" id="ENDUZ" size="7" value="${ f:printTime( resultData.ENDUZ ) }" readonly />&nbsp;
							<input type="text" name="ANZHL" id="ANZHL" size="3" value="<c:out value='${ resultData.ANZHL}'/>" class="noBorder"  readonly style="text-align:right;">
							<!--hour(s)--><spring:message code="LABEL.D.D19D.0004" />
						</td>
						</c:otherwise>
					</c:choose>

          	    </tr>
          	    <tr>
			        <th><span class="textPink">*</span> <!--Application Reason--><spring:message code="LABEL.D.D19D.0005" /></th>
					<td colspan="3">
					<input type="text" name="ZREASON" id="ZREASON" size="105" value="<c:out value='${ resultData.ZREASON }'/>" maxlength="100" readonly/>
					</td>
                </tr>
                <tr>
	                <th><span class="textPink">*</span>Duty Allowance Amount</th>
	                <td colspan="3">
	                	<span id="BETRG" name="BETRG"> <input type="text" name="BETRG" size="10" class="noBorder" value="<c:out value='${ resultData.BETRG }'/>" readonly ></span>
	                	<span id="WAERS" name="WAERS"><input type="text" name="WAERS" size="4" class="noBorder" value="<c:out value='${ resultData.WAERS }'/>" readonly ></span>
					</td>
                </tr>

                <tr>
					<th><!--Date Character--><spring:message code="LABEL.D.D19D.0006" /></th>
					<td>
					    <input type="hidden" name="HOLIDAY1" id="HOLIDAY1" value="">
					    <span id="HOLIDAY" style="width:103px">${resultData.ZHOLIDAY eq 'X'? "Holiday" : "Non Holiday" }</span>
					</td>
	                <th class="th02"><!--Level--><spring:message code="LABEL.D.D19D.0007" /></th>
	                <td>

	                 	 <input type="text" name="ZJIKCH1" id="ZJIKCH1" size="7" class="noBorder" value=""  readonly />
	                 	 <span id="TTOUT" style="width:120"></span>
                    	 <input type="hidden" name="ZJIKCH" value="<c:out value='${ resultData.ZJIKCH }'/>"/>
					</td>
                </tr>
                <tr>
					<th><!--Daily Work Schedule(On day)--><spring:message code="LABEL.D.D19D.0008" /></th>
					<td>
						<input type="text" name="TPROG1" id="TPROG1" class="noBorder" value="<c:out value='${ resultData.TPROG1 }'/>" readonly />
						<span id="TTEXT1" style="width:80"></span>
					</td>
					<td colspan="2">
						<input type="text" name="BEGUZ1" id="BEGUZ1"  size="6" class="noBorder" value="${ f:printTime( resultData.BEGUZ1 ) }" readonly />
						~
						<input type="text" name="ENDUZ1" id="ENDUZ1"  size="6" class="noBorder" value="${ f:printTime( resultData.ENDUZ1 ) }" readonly />&nbsp;
					</td>
               </tr>

               <tr>
					<th><!--Daily Work Schedule(Next day)--><spring:message code="LABEL.D.D19D.0009" /></th>
					<td>
						<input type="text" name="TPROG2" id="TPROG2" class="noBorder"  value="<c:out value='${ resultData.TPROG2 }'/>" readonly />
						<span id="TTEXT2" style="width:80"></span>
					</td>
					<td colspan="2">
						<input type="text" name="BEGUZ2" id="BEGUZ2"  size="6" class="noBorder" value="${ f:printTime( resultData.BEGUZ2 ) }" readonly />
						~
						<input type="text" name="ENDUZ2" id="ENDUZ2"  size="6" class="noBorder" value="${ f:printTime( resultData.ENDUZ2 ) }" readonly />&nbsp;
					</td>
                </tr>



                </table>
          </div><!--  end table -->

		<!-----   hidden field ---------->
		<input type="hidden" name="ZHOLIDAY1"  id="ZHOLIDAY1" value="<c:out value='${ resultData.ZHOLIDAY1 }'/>">
		<input type="hidden" name="ZHOLIDAY2"  id="ZHOLIDAY2"  value="">
		<input type="hidden" name="time" value="">
		<input type="hidden" name="BUKRS" value="<c:out value='${PersonData.e_BUKRS}' />" />
		<input type="hidden" name="PERNR"        value="<c:out value='${ resultData.PERNR }'/>" />
		<input type="hidden" name="ZPERNR"        value="<c:out value='${ resultData.ZPERNR }'/>" />

		<!-----   hidden field ---------->

        <!-- 상단 입력 테이블 끝-->
      </div> <!--  end tableArea -->


</tags-approval:detail-layout>

</tags:layout>