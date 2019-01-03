<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Application                                                  																	*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Duty                                               																				*/
/*   Program ID   		: D19DutyBuild.jsp                                              																*/
/*   Description  		: 직반(Duty)신청을 하는 화면                           																			*/
/*   Note         		:                                                             																		*/
/*   Creation     		: 2002-01-15 박영락                                          																		*/
/*   Update       		: 2005-03-03 윤정현                                          																		*/
/*   Update       		: 2007-10-09 huang peng xiao                               																*/
/*   			       		: 2008-01-14 jungin @v1.0 HOLIDAY1 필드 추가                                        										*/
/*							: 2008-01-15 jungin @v1.1 ZHOLIDAY1 필드 추가 																	*/
/*							: 2008-06-18 jungin @v1.2 신청시 직반금액 필수 필드 																*/
/*							: 2008-12-05 jungin @v1.3 [C20081202_66724] 근무시간과 Duty신청시간의 중복체크.						*/
/*							: 2009-04-23 jungin @v1.4 [C20090413_38010] 공휴일 직반 신청 및 방지.										*/
/*							: 2009-10-14 jungin @v1.5 [C20091014_40674] 공휴일 직반 신청 방지 로직 제거.								*/
/*							: 2009-10-16 jungin @v1.6 공휴일 근무시간 중복체크 해제.															*/
/*							: 2011-01-19 liu kuo @v1.7  [C20110118_09919]Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청	*/
/***************************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ page import="hris.common.PersonData" %>

<%
	PersonData phonenum = (PersonData) request.getAttribute("PersonData");
	String E_BUKRS = phonenum.E_BUKRS;

	String message	= (String)request.getAttribute("message");

	if( message == null ){
        message = "";
    }

	//String PERNR = (String)request.getAttribute("PERNR");
%>

<c:set var="message" value="<%=message%>" />
<c:set var="E_BUKRS" value="<%=E_BUKRS %>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
<tags-approval:request-layout  titlePrefix="TAB.COMMON.0037">
	<tags:script>
		<script>

		<!--
		jQuery(function(){
			msg();
			on_Blur( document.form1.DUTY_DATE );
			<c:if test="${E_BUKRS eq 'G280'}">
				timeFoc();
			</c:if>
		});

		//msg 를 보여준다.
		function msg(){

		<c:if test="${message ne '' }">
		     alert("${message}");
		</c:if>

		}

		function beforeSubmit() { // function doSubmit(){
			//alert( $('UPMU').value );
			var validText = "";
			if( $('#DUTY_DATE').val() == '' ){
				validText = "<spring:message code='LABEL.D.D19D.0001' />";
			    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please input duty date.");
		        document.form1.DUTY_DATE.focus();
		        return;
			}

			if( document.form1.DUTY_REQ.selectedIndex == 0 ){  // form1.DUTY_REQ.selectedIndex
				validText = "<spring:message code='LABEL.D.D19D.0002' />";
			    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please input request type.");
		        document.form1.DUTY_REQ.focus();
		        return;
			}
			if( $('#BEGUZ1').val() =='' || $('#BEGUZ2').val() =='' || $('#ENDUZ1').val() == ''|| $('#ENDUZ2').val() =='' ){
				alert("Schedule error,can`t build.");
				return;
			}
		    if( check_Data() && other_check()) {

			    // 2004.2.11 - 중복을 체크하는 로직 추가. 같은 날짜와 시간일 경우 중복경고.
			    var c_WORK_DATE, c_BEGUZ, c_ENDUZ
			    c_WORK_DATE = document.form1.DUTY_DATE.value;
			    c_WORK_DATE = c_WORK_DATE.replace(".","-").replace(".","-");
			    c_BEGUZ     = document.form1.BEGUZ.value.replace(":","");
			    c_ENDUZ     = document.form1.ENDUZ.value.replace(":","");
			    // 2004.2.11

			    if( document.form1.ZREASON.value == "" ){//신청사유
			    	validText = "<spring:message code='LABEL.D.D19D.0005' />";
				    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please input reason.");
			        document.form1.ZREASON.focus();
			        return;
			    }
				document.form1.BEGUZ1.value = document.form1.BEGUZ1.value.replace(":","") + "00";
				document.form1.ENDUZ1.value = document.form1.ENDUZ1.value.replace(":","") + "00";
				document.form1.BEGUZ2.value = document.form1.BEGUZ2.value.replace(":","") + "00";
				document.form1.ENDUZ2.value = document.form1.ENDUZ2.value.replace(":","") + "00";

			    var dayCount = dayDiff(document.form1.BEGDA.value, document.form1.DUTY_DATE.value);
			    var cDT = new Date();


		        if( copy_Entity() ){

					 //*****************************************************************
					 // 신청시 직반금액 필수 필드.		2008-06-18		jungin		@v1.2
					 document.form1.DUTY_DATE.value = removePoint( document.form1.DUTY_DATE.value );
					 //*****************************************************************
					 return true;
		        }
		    }
		}

		function getBetweenTime(currentTime, intervalTime)	{
		    var hh1 = 0, mm1 = 0;
		    var hh2 = 0, mm2 = 0;
		    var d_hh = 0, d_mm = 0, interval_time = 0;

		    hh1 =currentTime.substring(0,2);
		    mm1 =currentTime.substring(2,4);

		    hh2 =intervalTime.substring(0,2);
		    mm2 =intervalTime.substring(3,5);

		    d_hh = hh2 - hh1;
		    d_mm = mm2 - mm1;

		    if( d_mm >= 0 ){
		        d_mm = d_mm / 60;
		    } else {
		        d_hh = d_hh - 1;
		        d_mm = (60 + d_mm) /60;
		    }
		    interval_time = d_hh + d_mm;

		    return interval_time;
		}

		function doCheck() {
		    if( check_Data() ) {
		    	if( other_check() ){
				   	if( copy_Entity() ){
						document.form1.BEGUZ.value = addColon(document.form1.BEGUZ.value);
						document.form1.ENDUZ.value = addColon(document.form1.ENDUZ.value);
						/*
						document.form1.BEGUZ.value = addColon(document.form1.BEGUZ.value);
						document.form1.ENDUZ.value = addColon(document.form1.ENDUZ.value);
						document.form1.BEGUZ.value = addColon(document.form1.BEGUZ.value);
						document.form1.ENDUZ.value = addColon(document.form1.ENDUZ.value);
					    document.form1.ANZHL.value = addColon(document.form1.ANZHL.value);
					    */
				    }
				    document.form1.BEGDA.value = addPointAtDate(document.form1.BEGDA.value);
		    		document.form1.DUTY_DATE.value = addPointAtDate(document.form1.DUTY_DATE.value);
				 }
		    }
		}

		function copy_Entity(){
		    document.form1.BEGDA.value = removePoint( document.form1.BEGDA.value );
		    document.form1.DUTY_DATE.value = removePoint( document.form1.DUTY_DATE.value );
		    document.form1.BEGUZ.value = addSec( document.form1.BEGUZ.value );
		    document.form1.ENDUZ.value = addSec( document.form1.ENDUZ.value );

		    // ZHOLIDAY1 필드 추가.		2008-01-15		jungin		@v1.1
		    //alert("HOLIDAY1	 : " + document.form1.HOLIDAY1.value);

			if(document.form1.HOLIDAY1.value == "X"){
				document.form1.ZHOLIDAY1.value = "Y";
				//alert("ZHOLIDAY1 : " + document.form1.ZHOLIDAY1.value);
			}else{
				if(document.form1.TPROG2.value == "OFF"){
					document.form1.ZHOLIDAY1.value = "";
					//alert("ZHOLIDAY1_1 : " + document.form1.ZHOLIDAY1.value);
				}else{
					document.form1.ZHOLIDAY1.value = "X";
					//alert("ZHOLIDAY1_2  : " + document.form1.ZHOLIDAY1.value);
				}
			}

			//**************************************************************************
			// 신청시 직반금액 필수 필드.		2008-06-18		jungin		@v1.2
			ajax_change(document.form1.DUTY_REQ.options[document.form1.DUTY_REQ.selectedIndex].value);
			//**************************************************************************

		    return true;
		}

		//*************************************************************************************
		// 신청시 직반금액 필수 필드.		2008-06-18		jungin		@v1.2
		//---------- 직반 유형선택할때 직반금액변화------------
		function ajax_change(tem){
			var frm = document.form1;

		    // ZHOLIDAY1 필드 추가.		2008-01-15		jungin		@v1.1
			document.form1.time.value = document.form1.ZHOLIDAY1.value;
			frm.DUTY_DATE.value = removePoint(frm.DUTY_DATE.value);

			var today = frm.DUTY_DATE.value;
			var JIKCH = frm.ZJIKCH.value;
			var time = frm.time.value;
			var ANZHL = frm.ANZHL.value;
			//var betrg = removeComma(document.form1.REIM_TOTL.value);

			var PERNR = "<c:out value='${resultData.PERNR}'/>";

			jQuery.ajax({
		        type:"POST",
		        url:'${g.servlet}hris.G.G067DutyAjax',
		        data: {Itype : tem, PERNR : PERNR, today : today, JIKCH:JIKCH, time : time ,ANZHL : ANZHL },
		        success:function(data){
		        	showResponse1(data);
		        },
		        error:function(e){
		            alert(e.responseText);
		        }
		   	});
		}

		function showResponse1(originalRequest){
			//put returned XML in the textarea
			if (originalRequest!=''){
				var arr= new Array();
				//arr = originalRequest.responseText.split('|');
				arr = originalRequest.split('|');
				//alert(' arr[0]=  '  + arr[0] );
				$('#BETRG').html ( arr[0] );
				$('#WAERS').html( arr[1] );
			    $('#message').val(arr[2]);
			}
		}
		//*************************************************************************************

		// keep <==

		// 시간 선택
		function fn_openTime(Objectname){
		  var lastDate = eval("document.form1." + Objectname + ".value");

		  var sWidth = "350";// 띄울 창의 너비
		  var sHeight = "220";// 띄울 창의 높이
		  var ml = (screen.availWidth - sWidth) / 2;// 가운데 띄우기위한 창의 x위치
		  var mt = (screen.availHeight - sHeight) / 2;// 가운데 띄우기위한 창의 y위치

		  small_window=window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname+"&curTime=" + lastDate ,"essTime","toolbar=0,location=0,status=0,menubar=0,resizable=0,width="+sWidth+",height="+sHeight+",left="+ml+",top="+mt);
		  small_window.focus();
		}

		function addSec( text ){
		  if( text != ""){
		    time = removeColon(text);
		    return time+"00";
		  } else {
		    return "";
		  }
		}

		function addColon(text){//형식 체크후 문자형태의 시간 0000을 00:00으로 바꾼다 값이 없을시는 0을 리턴
		    if( text!="" ){
		        if( text.length == 4 ){
		            var tmpTime = text.substring(0,2)+":"+text.substring(2,4);
		            return tmpTime;
		        }else if( text.length == 6 ){
		            var tmpTime = text.substring(0,2)+":"+text.substring(2,4);
		            return tmpTime;
		        }
		    } else {
		        return "";
		    }
		}

		//  ==> keep
		function cal_time( time1, time2 ){
			//alert('in cal_time \n time1=' + time1 + '\n' + 'time2=' + time2);
		    var tmp_HH1  = 0;//이것이 문제다....
		    var tmp_MM1  = 0;
		    var tmp_HH2  = 0;
		    var tmp_MM2  = 0;
		    if( time1.length == 4 ){
		        tmp_HH1 = time1.substring(0,2);
		        tmp_MM1 = time1.substring(2,4);
		    } else if( time1.length == 3 ){
		        tmp_HH1 = time1.substring(0,1);
		        tmp_MM1 = time1.substring(1,3);
		    }
		    if( time2.length == 4 ){
		        tmp_HH2 = time2.substring(0,2);
		        tmp_MM2 = time2.substring(2,4);
		    } else if( time2.length == 3 ){
		        tmp_HH2 = time2.substring(0,1);
		        tmp_MM2 = time2.substring(1,3);
		    }

		    var tmp_hour = tmp_HH2-tmp_HH1;
		    var tmp_min  = tmp_MM2-tmp_MM1;
		    var interval_time = 0;

		    if( tmp_hour < 0 ){
		        tmp_hour = 24+tmp_hour;
		    }
		    if( tmp_min >= 0 ){
		        tmp_min = banolim( (tmp_min/60), 2 );
		    } else {
		        tmp_hour = tmp_hour - 1;
		        tmp_min  = banolim( ( 60 + tmp_min )/60, 2 );
		    }
			//alert('in cal_time \n interval_time1=' + interval_time);
		    interval_time = tmp_hour+tmp_min+"";
			//alert('in cal_time \n interval_time2=' + interval_time);
		    return interval_time;
		}

		// 메인시간 계산용(총 초과 근무시간 계산용)
		function cal_time2( time1, time2 ){
			//alert('in cal_time2 \n time1=' + time1 + '\n' + 'time2=' + time2);
		    var tmp_HH1  = 0;//이것이 문제다....
		    var tmp_MM1  = 0;
		    var tmp_HH2  = 0;
		    var tmp_MM2  = 0;
		    if( time1.length == 4 ){
		        tmp_HH1 = time1.substring(0,2);
		        tmp_MM1 = time1.substring(2,4);
		    } else if( time1.length == 3 ){
		        tmp_HH1 = time1.substring(0,1);
		        tmp_MM1 = time1.substring(1,3);
		    }
		    if( time2.length == 4 ){
		        tmp_HH2 = time2.substring(0,2);
		        tmp_MM2 = time2.substring(2,4);
		    } else if( time2.length == 3 ){
		        tmp_HH2 = time2.substring(0,1);
		        tmp_MM2 = time2.substring(1,3);
		    }

		    var tmp_hour = tmp_HH2-tmp_HH1;
		    var tmp_min  = tmp_MM2-tmp_MM1;
		    var interval_time = 0;

		    if( tmp_hour < 0 ){
		        tmp_hour = 24+tmp_hour;
		    }
		    if( tmp_min >= 0 ){
		        tmp_min = banolim( (tmp_min/60), 2 );
		    } else {
		        tmp_hour = tmp_hour - 1;
		        tmp_min  = banolim( ( 60 + tmp_min )/60, 2 );
		    }
		    interval_time = tmp_hour+tmp_min+"";
		    if( interval_time == 0 ){
		        interval_time = 24;
		    }
			//alert('in cal_time2 \n interval_time=' + interval_time);
		    return interval_time;
		}

		function other_check(){	//check start time

			/*
			if(document.form1.BEGUZ.value != '' && document.form1.BEGUZ.value < document.form1.ENDUZ1.value){
				alert('The time started of working duty must be later than quitting time.');
				document.form1.BEGUZ.select();
				document.form1.BEGUZ.focus();
				return false;
			}
			*/

		    //**************************************************************************************************************
		    // 근무시간과 Duty신청시간의 중복체크.		2008-12-05		jungin		@v1.3 [C20081202_66724]
		    // Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청  	2011-01-19		liukuo		@v1.7 [C20110118_09919]
			 //if(< %= phonenum.E_BUKRS != null && (phonenum.E_BUKRS.equals("G110") || phonenum.E_BUKRS.equals("G280") || phonenum.E_BUKRS.equals("G370")) %>){

			 <c:if test="${E_BUKRS eq 'G110' || E_BUKRS eq 'G280' || E_BUKRS eq 'G370' }">

			 	if((document.form1.BEGUZ.value != '' && document.form1.ENDUZ.value != '') && document.form1.TPROG1.value != "OFF" ){

				 	 // 법정공휴일.								2009-04-17		jungin		@v1.4 [C20090413_38010]
				 	 // 공휴일 근무시간 중복체크 해제.		2009-10-16		jungin		@v1.6
				 	 //if(document.form1.ZHOLIDAY2.value == "X" && document.form1.TPROG1.value == "OFF"){
					 if(document.form1.ZHOLIDAY2.value == "X"){

					 }else{

					 	//check whether overtime overlaps work time
						if(document.form1.BEGUZ1.value < document.form1.ENDUZ1.value){
							if(document.form1.BEGUZ.value != ''){
								if(document.form1.BEGUZ.value < document.form1.ENDUZ1.value && document.form1.BEGUZ.value > document.form1.BEGUZ1.value){
									alert("<spring:message code='MSG.G.G01.0001' />");//alert('Duty time overlaps with working time , please enter right time period.');
									document.form1.BEGUZ.value = '';
									document.form1.ENDUZ.value = '';
									document.form1.ANZHL.value = '';
									return false;
								}
								if(document.form1.ENDUZ.value > document.form1.BEGUZ1.value && document.form1.ENDUZ.value < document.form1.ENDUZ1.value){
									alert("<spring:message code='MSG.G.G01.0001' />");//alert('Duty time overlaps with working time , please enter right time period.');
									document.form1.BEGUZ.value = '';
									document.form1.ENDUZ.value = '';
									document.form1.ANZHL.value = '';
									return false;
								}
								if(document.form1.ENDUZ.value >= document.form1.ENDUZ1.value && document.form1.BEGUZ.value <= document.form1.BEGUZ1.value){
									alert("<spring:message code='MSG.G.G01.0001' />");//alert('Duty time overlaps with working time , please enter right time period.');
									document.form1.BEGUZ.value = '';
									document.form1.ENDUZ.value = '';
									document.form1.ANZHL.value = '';
									return false;
								}
								if(document.form1.ENDUZ.value <= document.form1.BEGUZ1.value && document.form1.BEGUZ.value <= document.form1.BEGUZ1.value && document.form1.BEGUZ.value >= document.form1.ENDUZ.value){
									alert("<spring:message code='MSG.G.G01.0001' />");//alert('Duty time overlaps with working time , please enter right time period.');
									document.form1.BEGUZ.value = '';
									document.form1.ENDUZ.value = '';
									document.form1.ANZHL.value = '';
									return false;
								}
								if(document.form1.ENDUZ.value >= document.form1.ENDUZ1.value && document.form1.BEGUZ.value >= document.form1.ENDUZ1.value && document.form1.BEGUZ.value >= document.form1.ENDUZ.value){
									alert("<spring:message code='MSG.G.G01.0001' />");//alert('Duty time overlaps with working time , please enter right time period.');
									document.form1.BEGUZ.value = '';
									document.form1.ENDUZ.value = '';
									document.form1.ANZHL.value = '';
									return false;
								}
							}
						}
						if(document.form1.BEGUZ1.value > document.form1.ENDUZ1.value){
						     if(document.form1.BEGUZ.value != ''){
						       if(document.form1.BEGUZ.value >= document.form1.BEGUZ1.value || document.form1.BEGUZ.value < document.form1.ENDUZ1.value){
						    	    alert("<spring:message code='MSG.G.G01.0001' />");//alert('Duty time overlaps with working time , please enter right time period.');
									document.form1.BEGUZ.value = '';
									document.form1.ENDUZ.value = '';
									document.form1.ANZHL.value = '';
									return false;
								}
						       if(document.form1.ENDUZ.value > document.form1.BEGUZ1.value || document.form1.ENDUZ.value <= document.form1.ENDUZ1.value){
						    	    alert("<spring:message code='MSG.G.G01.0001' />");//alert('Duty time overlaps with working time , please enter right time period.');
									document.form1.BEGUZ.value = '';
									document.form1.ENDUZ.value = '';
									document.form1.ANZHL.value = '';
									return false;
								}
						       if(document.form1.BEGUZ.value >= document.form1.ENDUZ.value && document.form1.ENDUZ.value > document.form1.ENDUZ1.value && document.form1.BEGUZ.value < document.form1.BEGUZ1.value){
						    	    alert("<spring:message code='MSG.G.G01.0001' />");//alert('Duty time overlaps with working time , please enter right time period.');
									document.form1.BEGUZ.value = '';
									document.form1.ENDUZ.value = '';
									document.form1.ANZHL.value = '';
									return false;
								}
							 }
						}

					 }

				}
			</c:if>
			//}
			 //**************************************************************************************************************

			return true;
		}

		function check_Data(){
			var validText = "";
			// 필수 필드의 형식 체크
		    if( !dateFormat(document.form1.DUTY_DATE) ){
		        return false;
		    }
		    if( !timeFormat(document.form1.BEGUZ) ){//24:00일때 00:00으로 변환 필요
		        return false;
		    } else {
		        if( document.form1.BEGUZ.value == "24:00" ){
		            document.form1.BEGUZ.value = "00:00";
		        }
		    }
		    if( !timeFormat(document.form1.ENDUZ) ){//00:00일때 24:00으로 변환 필요
		        return false;
		    } else {
		        if( document.form1.ENDUZ.value == "00:00" ){
		            document.form1.ENDUZ.value = "24:00";
		        }
		    }

		    var DUTY_DATE = document.form1.DUTY_DATE.value;

		    var BEGUZ  = removeColon( document.form1.BEGUZ.value );
		    var ENDUZ  = removeColon( document.form1.ENDUZ.value );
		    var ANZHL  = document.form1.ANZHL.value;

		    if( BEGUZ == "" ){// 시작시간
		    	validText = "<spring:message code='LABEL.D.D19D.0003' />";
			    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please input duty start time.");
		        document.form1.BEGUZ.focus();
		        return false;
		    }

		    if( ENDUZ == "" ){// 종료시간
		    	validText = "<spring:message code='LABEL.D.D19D.0003' />";
			    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please input duty end time.");
		        document.form1.ENDUZ.focus();
		        return false;
		    }

		    // 휴식시간 계산  // 잘못된 값 억제.
		    tmpSTDAZ = cal_time2( BEGUZ, ENDUZ )+"";
			var STDAZ = "";
		    if( tmpSTDAZ == 0 ){
		        STDAZ = "";
		    } else {
		        STDAZ = banolim( tmpSTDAZ,2 );
		    }
		    document.form1.ANZHL.value = STDAZ;

		    return true;
		}

		// 휴식시간 첵크 로직
		function freetime_check( BEGUZ, ENDUZ, CHECKTIME ){
		    if( CHECKTIME != "" ){
		        if( BEGUZ > ENDUZ ){
		            if( Number( CHECKTIME ) < Number( BEGUZ ) ){// 경우 잘못된값  true 리턴
		                if( Number( CHECKTIME ) > Number( ENDUZ ) ){
		                    return true;
		                }
		            }
		            return false;
		        } else if( BEGUZ < ENDUZ ){// 주의  flag에 따라 체크 방법이 틀림
		            if( Number( BEGUZ ) <= Number( CHECKTIME ) ){
		                if( Number( CHECKTIME ) <= Number( ENDUZ ) ){
		                    return false;
		                }
		            } else if ( CHECKTIME == 0 && ENDUZ == 2400 ){
		                return false;
		            }
		            return true;
		        }
		    }
		    return false;
		}

		var flag = 0 ;

		function EnterCheck2(){
		    if (event.keyCode == 13)  {
				flag = 1;
			    doCheck();
		    }
		}

		function f_timeFormat(obj){
		    valid_chk = true;

		    t = obj.value;
		    if( t == "" || t == 0){
		        return true;
		    } else {
		      if( !isNaN ( t ) ){
		          if( 99.99 > t && t>0){
		              t = t+"";
		              d_index = t.indexOf(".");
		              if( d_index != -1 ){
		                  tmpstr = t.substring( d_index+1, t.length );
		                  if( tmpstr.length > 2 ){//소수점 2제자리가 넘는경우
		                	  alert("<spring:message code='MSG.D.D01.0008' />"); //alert( "The input format is wrong. \nPlease input by this format(##.##).");
		                      obj.focus();
		                      obj.select();
		                      return false;
		                  }
		              }
		              return true;
		          }
		      }
		      alert("<spring:message code='MSG.D.D01.0008' />"); //alert("The input format is wrong. \nPlease input by this format(##.##).");
		      obj.focus();
		      obj.select();
		      return false;
		    }
		}

		function check_Time(){
			if( $('#DUTY_DATE').val() == "" ){//duty date
				var validText = "<spring:message code='LABEL.D.D19D.0001' />";
			    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("Please input duty date.");
		        $('#BEGUZ').val(""); // == '';
		        $('#ENDUZ').val(""); // == '';
		        document.form1.DUTY_DATE.focus();
		        return false;
		    }
			if( document.form1.BEGUZ.value != "" && document.form1.ENDUZ.value != "" ){
			  	doCheck();
			}
		}

		// 2003.01.17 - 초과근무신청을 막는다. //////////////////////////////
		function after_fn_openCal(){
		    on_Blur(document.form1.DUTY_DATE);
		}

		function on_Blur(obj) {//get work date and time
		    if( obj.value != "" && dateFormat(obj) ) {

			    var PERNR = "<c:out value='${resultData.PERNR}'/>";
			    var jobid = "check";
			    var DUTY_DATE = removePoint(document.form1.DUTY_DATE.value) ;

			    jQuery.ajax({
			        type:"post",
			        //dataType: "json",
			        url:'${g.servlet}hris.D.D19Duty.D19DutyCheckSV',
			        data: {jobid : jobid, PERNR : PERNR, DUTY_DATE : DUTY_DATE },
			        success:function(json){
			            showResponse(json);
			        },
			        error:function(e){
			            alert("error="+e.responseText);
			        }
			    });
		    }
		}

		var ss = [];

		function showResponse(originalRequest){// json ajax

			var flag = originalRequest.split(",")[1];
				if(flag == "N" ){
				   alert("<spring:message code='MSG.D.D01.0050' />"); //alert("You can't apply this data in payroll period");
		       	   document.form1.DUTY_DATE.value = "" ;
				   document.form1.DUTY_DATE.focus();
				   return;
				}

				//alert('1111='+ originalRequest.split(",")[0] );

				var resText = originalRequest.split(",")[0];
				resText = unescape(resText);

				var t = eval('(' + resText + ')');

				$("#TPROG1").val( t.TPROG1 );
				$("#TTEXT1").html( t.TTEXT1 );
				$("#BEGUZ1").val( t.BEGUZ1 );
				$("#ENDUZ1").val( t.ENDUZ1 );
				$("#TPROG2").val( t.TPROG2 );
				$("#TTEXT2").html( t.TTEXT2 );
				$("#BEGUZ2").val( t.BEGUZ2 );
				$("#ENDUZ2").val( t.ENDUZ2 );
				$("#TTOUT").val( t.TTOUT );
				$("#ZJIKCH").val( t.ZJIKCH );

				/*for(i in t){
				  if(typeof(i) != 'Function' && i != 'toJSONString'){
					  //alert('3333='+ i );
					  try{
						  	if(eval("t." + i) != ''){
						  		//alert('aaaaaaaaa='+ eval("t." + i)  );		//alert('bbbb='+ i   );
						  		//alert('cccc='+eval("$('"+i+"')").type   );

						  		if(eval("$('"+i+"')").type == 'text') {

						  			eval("$('"+i+"')").value = eval("t." + i) == '|' ? "" : eval("t." + i);
						  			//alert('text  aaaaaaaaa='+ eval("$('"+i+"')").value );

						  		}else if(eval("$('"+i+"')").tagName == 'span') {
						  			//alert('span  aaaaaaaaa='+  eval("t." + i) );
						  			eval("$('"+i+"')").html ( eval("t." + i) == '|' ? "" : eval("t." + i) );
						  		}
						  	}
					  }catch(e){
					  }
				  }
				}*/

				$('#ZJIKCH1').html( t.ZJIKCH ); //$('#ZJIKCH1').innerText = t.ZJIKCH;

				$('#HOLIDAY').html( t.ZHOLIDAY == 'X'?'Holiday':'Non Holiday' );
				$('#ZHOLIDAY2').val( t.ZHOLIDAY );

				//************************************************
				//HOLIDAY1 추가.		2008-01-14		jungin		@v1.0
				//$('HOLIDAY1').innerText = t.ZHOLIDAY1 == 'X'?'X':'';
				//$('#HOLIDAY1').html(t.ZHOLIDAY1); //$('HOLIDAY1').innerText = t.ZHOLIDAY1;
				$('#HOLIDAY1').val(t.ZHOLIDAY1);
				//************************************************

				ss = t.sels;
				sRemove();

				addOption('','Select', document.form1.DUTY_REQ );
				for(var i = 0 ; i < t.sels.length ; i ++){
					var obj = t.sels[i];
					addOption(obj.DUTY, obj.DUTY_TXT, document.form1.DUTY_REQ );
				}
				selectSels("<c:out value='${resultData.DUTY_REQ}'/>");

				if(t.ZHOLIDAY == "X"){
					DutyTypechange();
				}
				other_check();
		}

		function addOption(code,val,target){
			var op = document.createElement('option');
			op.text = val;
			op.value = code;
			target.options.add(op);
		}

		function selectSels(val){
			var sels = document.form1.DUTY_REQ;
			for(var i = 1 ; i < sels.options.length ; i ++){
				if(sels.options[i].value == val){
					sels.selectedIndex = i;
				}
			}
		}

		function sRemove(){  // document.form1.DUTY_REQ.options[document.form1.DUTY_REQ.selectedIndex].value
			for(var i = 0 ; i < document.form1.DUTY_REQ.options.length ; i ++){
				document.form1.DUTY_REQ.options.remove(0);
				sRemove();
			}
		}

		function reload() {
		    frm =  document.form1;
		    frm.jobid.value = "first";
		    frm.action = "${g.servlet}hris.D.D19Duty.D19DutyBuildSV";
		    frm.target = "";
		    frm.submit();
		}

		function DutyTypechange(){//change approval people

			var frm = document.form1;

			//if ( frm.DUTY_REQ.options[frm.DUTY_REQ.selectedIndex].value == "" ) {
			if(frm.DUTY_REQ.selectedIndex == 0){
				//alert(111111111111);
				$('#UPMU').val("");
			}else{
				//$('#LGART').val( ss[$('#DUTY_REQ').selectedIndex - 1].LGART );
				frm.LGART.value =  ss[frm.DUTY_REQ.selectedIndex - 1].LGART;


				//if($('#BEGUZ').val() != "" || $('#ENDUZ').val() != "") {
					//$('BEGUZ').value = "";
					//$('ENDUZ').value = "";
				//}

				// ******************************************************************************************
				// 법정공휴일에는 직반공휴만 신청가능.		2009-04-23		jungin		@v1.4 [C20090413_38010]
				// 공휴일 직반 신청 방지 로직 제거.			2009-10-14		jungin		@v1.5 [C20091014_40674]
				// ******************************************************************************************

				var PERNR = "<c:out value='${resultData.PERNR}'/>";
			    var jobid = "changeApp";
			    var UPMU = document.form1.UPMU.value ;

			    //  $('#UPMU').val( ss[frm.DUTY_REQ.selectedIndex - 1].UPMU );

			    document.form1.UPMU.value =  ss[frm.DUTY_REQ.selectedIndex - 1].UPMU ;

			    var DUTY_DATE = removePoint(document.form1.DUTY_DATE.value) ;

			    jQuery.ajax({
			        type:"POST",
			        //dataType: "json",
			        url:'${g.servlet}hris.D.D19Duty.D19DutyBuildSV',
			        data: {jobid : jobid, PERNR : PERNR, DUTY_DATE : DUTY_DATE, UPMU : document.form1.UPMU.value },
			        success:function(json){
			        	changeApp(json);
			        },
			        error:function(e){
			            alert("error="+e.responseText);
			        }
			    });

			}
			//20160517

			<c:if test="${E_BUKRS eq 'G280'}">
				if(document.form1.DUTY_REQ.value == "0006"){
						document.form1.BEGUZ.value = "17:30";
						document.form1.ENDUZ.value = "08:30";
						document.getElementById("BEGUZ").readOnly=true;
						document.getElementById("ENDUZ").readOnly=true;

						$('#timeFoc img').hide();

						//btime.style.visibility = 'hidden';
						//etime.style.visibility = 'hidden';
						check_Time();
				}else if(document.form1.DUTY_REQ.value == "0005"){
						document.form1.BEGUZ.value = "08:30";
						document.form1.ENDUZ.value = "17:30";
						document.getElementById("BEGUZ").readOnly=true;
						document.getElementById("ENDUZ").readOnly=true;
						$('#timeFoc img').hide();
						//btime.style.visibility = 'hidden';
						//etime.style.visibility = 'hidden';
						check_Time();
				}else{
					document.form1.BEGUZ.value = "";
					document.form1.ENDUZ.value = "";
					document.getElementById("BEGUZ").readOnly=false;
					document.getElementById("ENDUZ").readOnly=false;
					document.form1.ANZHL.value = "";
					$('#timeFoc img').show();
					//btime.style.visibility = '';
					//etime.style.visibility = '';
				}
			</c:if>
			//20160517 end
		}

		function timeFoc(){
			$('#timeFoc img').hide();
		}

		function changeApp(originalRequest){
		    //var flag = originalRequest.responseText.split(",")[1];

		    var flag = originalRequest;
			if(flag == "N" ){
				alert("<spring:message code='MSG.D.D01.0050' />"); //alert("You can't apply this data in payroll period");
		     	document.form1.DUTY_DATE.value = "" ;
			    document.form1.DUTY_DATE.focus();
			    return;
			}
		}

		function timeBlur(obj){
			if(flag == 1){
				flag = 0;
				return;
			}
			if(obj.value != "" && timeFormat(obj)){
				check_Time();
			}
		}

		function timeFocus(time){

			if ($(time).val()=="") {
				$(time).val("0000");
			}
		}

		//-->

		</script>
	</tags:script>
	<!-- 상단 입력 테이블 시작-->
	<%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>

	<jsp:include page="${g.jsp }D/timepicker-include.jsp"/>

	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
				<colgroup>
            		<col width="16%" />
            		<col width="18%" />
            		<col width="15%" />
            		<col width="" />
            	</colgroup>

            	<tr>
                    <th><span class="textPink">*</span> <!--Duty Date--><spring:message code="LABEL.D.D19D.0001" /></th>
                    <td colspan="3">
                    	<input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
                        <input type="text" name="DUTY_DATE" id="DUTY_DATE" size="7" value="${f:printDate(resultData.DUTY_DATE)}" class="date"  onchange="after_fn_openCal();" />
                          <!-- a href="javascript:fn_openCal('DUTY_DATE','after_fn_openCal()');">
                          <img src="${g.image}icon_diary.gif" align="absmiddle" border="0">
                          </a  -->
                    </td>
                </tr>
                <tr>
					<th><span class="textPink">*</span><!-- Duty Type--><spring:message code="LABEL.D.D19D.0002" /></th>
					<td colspan="3">
						<select name="DUTY_REQ" id="DUTY_REQ" style="width:170px;" onchange="javascript:DutyTypechange()">
							<option>Select</option>
						</select>
						<input type="hidden" name="UPMU" id="UPMU" value="<c:out value='${resultData.UPMU}'/>" />
					</td>
               </tr>

               <tr>
					<th><span class="textPink">*</span><!-- Duty Time--><spring:message code="LABEL.D.D19D.0003" /></th>
					<td colspan="3"  id="timeFoc">

							<input type="text" name="BEGUZ" id="BEGUZ" size="7" class="time" value="${ f:printTime( resultData.BEGUZ ) }" onKeyPress = "javascript:EnterCheck2();" onblur="timeBlur(this);" readonly />
							<!-- span id="btime" style={visibility:}; ><a href="javascript:fn_openTime('BEGUZ');"  ><img src="${g.image}icon_time.gif" align="absmiddle" border="0"></a> </span -->
							~
							<input type="text" name="ENDUZ" id="ENDUZ" size="7" class="time" value="${ f:printTime( resultData.ENDUZ ) }" onKeyPress = "javascript:EnterCheck2();" onblur="timeBlur(this);" readonly />&nbsp;
							<!-- <span id="etime" style={visibility:}; ><a href="javascript:fn_openTime('ENDUZ');" ><img src="${g.image}icon_time.gif" align="absmiddle" border="0"></a></span -->

						<input type="text" name="ANZHL" id="ANZHL" size="3" value="<c:out value='${resultData.ANZHL}'/>"  class="noBorder"  readonly style="text-align:right;">
						<!--hour(s)--><span class="inputText"><spring:message code="LABEL.D.D19D.0004" /></span>
					</td>
          	   </tr>

          	   <tr>
			        <th><span class="textPink">*</span> <!--Application Reason--><spring:message code="LABEL.D.D19D.0005" /></th>
					<td colspan="3">
					<input type="text" name="ZREASON" id="ZREASON" size="105" value="<c:out value='${ resultData.ZREASON }'/>" maxlength="100">
					</td>
               </tr>

               <tr>
					<th><!--Date Character--><spring:message code="LABEL.D.D19D.0006" /></th>
					<td>
						<span id="HOLIDAY" style="width:103px">${resultData.ZHOLIDAY eq 'X'? "Holiday" : "Non Holiday" }</span>
					    <input type="hidden" name="HOLIDAY1" id="HOLIDAY1" value="">
					</td>
	                <th class="th02"><!--Level--><spring:message code="LABEL.D.D19D.0007" /></th>
	                <td>
	                 	 <input type="text" name="TTOUT" id="TTOUT" size="7" class="noBorder" value="<c:out value='${ resultData.ZJIKCH }'/>" readonly />
						 &nbsp;&nbsp;&nbsp;&nbsp;
						 <span id="ZJIKCH1" style="width:120;visibility: hidden"></span>
		                 <input type="hidden" name="ZJIKCH" id="ZJIKCH" value="" >
					</td>
               </tr>

               <tr>
					<th><!--Daily Work Schedule(On day)--><spring:message code="LABEL.D.D19D.0008" /></th>
					<td>
						<input type="text" name="TPROG1" id="TPROG1" size="10" value="<c:out value='${ resultData.TPROG1 }'/>" readonly />
						<span id="TTEXT1" style="width:80"></span>
					</td>
					<td colspan="2">
						<input type="text" name="BEGUZ1" id="BEGUZ1" size="7" value="${ f:printTime( resultData.BEGUZ1 ) }" readonly />
						~
						<input type="text" name="ENDUZ1" id="ENDUZ1" size="7" value="${ f:printTime( resultData.ENDUZ1 ) }" readonly />&nbsp;
					</td>
               </tr>

               <tr>
					<th><!--Daily Work Schedule(Next day)--><spring:message code="LABEL.D.D19D.0009" /></th>
					<td>
						<input type="text" name="TPROG2" id="TPROG2" size="10"  value="<c:out value='${ resultData.TPROG2 }'/>" readonly />
						<span id="TTEXT2" style="width:80"></span>
					</td>
					<td colspan="2">
						<input type="text" name="BEGUZ2" id="BEGUZ2" size="7" value="${ f:printTime( resultData.BEGUZ2 ) }" readonly />
						~
						<input type="text" name="ENDUZ2" id="ENDUZ2" size="7" value="${ f:printTime( resultData.ENDUZ2 ) }" readonly />&nbsp;
					</td>
                </tr>

            </table>

        </div> <!-- end class="table" -->

       	<span class="inlineComment">
		<span class="textPink">*</span><!--는 필수 입력사항입니다.--><spring:message code="LABEL.E.E05.0017" />
		</span>
		<!-- 상단 입력 테이블 끝-->

	<!-- Hidden Field -->
	<input type="hidden" name="sdate" value="">
	<input type="hidden" name="edate" value="">
	<input type="hidden" name="ZHOLIDAY1" id="ZHOLIDAY1" value="">
	<input type="hidden" name="ZHOLIDAY2" id="ZHOLIDAY2" value="">
	<input type="hidden" name="LGART" id="LGART" value="">
	<input type="hidden" name="time" value="">
	<span id="BETRG"  name="BETRG"  style="display:none"><input type="text" name="BETRG"  size="7" class="noBorder" value="" readonly ></span>
	<span id="WAERS" name="WAERS" style="display:none"><input type="text" name="WAERS" size="1" class="noBorder" value="" readonly ></span>

	<!-- Hidden Field -->

    </div>  <!-- end class="tableArea" -->

</tags-approval:request-layout>
</tags:layout>

