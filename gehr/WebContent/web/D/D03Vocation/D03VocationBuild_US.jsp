<%/***************************************************************************************/			
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Application                                                  																	*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Leave                                               																			*/
/*   Program ID   		: D03VocationBuildUsa.jsp                                              													*/
/*   Description  		: 휴가(Leave)신청을 하는 화면 (USA)                           															*/
/*   Note         		:                                                             																		*/
/*   Creation     		: 2010-11-25 jungin	@v1.0                                                       								 			*/
/*							: 2011-11-15 jo @v1.1  Global e-HR 미국 CMI 법인 추가에 따른 WEB 수정 요청									*/
/*							 @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel                           */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ page import="org.apache.commons.lang.math.NumberUtils"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%
    WebUserData user	= (WebUserData)session.getAttribute("user");
    
    String	 PERNR    		= (String)request.getAttribute("PERNR");
    String	 jobid   			= (String)request.getAttribute("jobid");
    String	 message 		= (String)request.getAttribute("message");
//     String	 checkmess 	= (String)request.getAttribute("checkmess");
    String	 E_BUKRS 		= (String)request.getAttribute("E_BUKRS");
//     phonenumdata	 phonenumdata		= (phonenumdata)request.getAttribute("phonenumdata");
    PersonData	 personData		= (PersonData)request.getAttribute("PersonData");

    // 입사일
//     String joinDate = phonenumdata.E_DAT01.replace("-","");
    String joinDate = personData.E_DAT02.replace("-","");
    String currentDate = DataUtil.getCurrentDate();
    
    // 입사일과 오늘 날짜의 차이를 구한다.
    double joinedDateLapse = DataUtil.getBetween(joinDate, currentDate);
    Logger.debug.println(">>>>>>>>>> joinedDateLapse: "+joinedDateLapse);
    /* 휴가신청 */
    Vector	d03VocationData_vt = null;
    D03VocationData data          = null;
    d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    data               		= (D03VocationData)d03VocationData_vt.get(0);
    
    String	 ANZHL_BAL	= data.ANZHL_BAL;
 
    if (message == null) {
    	message = "";
    }

    /* 결제정보를 vector로 받는다 */
    Vector AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
     
    String  subty1 = (String)request.getAttribute("subty1");
    if (subty1 == null) {
  		subty1 = "";
    }
    
    String btnSubmit = "btn_build.gif";
    if (user.e_area.equals("10")||user.e_area.equals("32")){//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
    	btnSubmit = "btn_Summit.gif";
    }

    Vector holidayVT = new D17HolidayTypeRFC().getHolidayType(data.PERNR);
    D03RemainVocationData dataRemain = (D03RemainVocationData)request.getAttribute("d03RemainVocationData");
	String remainDays = dataRemain.ANZHL_GEN.equals("0")?"0":Float.toString(NumberUtils.toFloat(dataRemain.ANZHL_USE)  / NumberUtils.toFloat(dataRemain.ANZHL_GEN) * 100);

	Boolean isUpdate = (Boolean)request.getAttribute("isUpdate");
	if (isUpdate==null) isUpdate=false;
%> 

<c:set var="user" value="<%=user%>"/>
<c:set var="data" value="<%=data%>"/>
<c:set var="PERNR" value="<%=(String)request.getAttribute("PERNR")%>"/>
<c:set var="jobid" value="<%=(String)request.getAttribute("jobid")%>"/>
<c:set var="message" value="<%=(String)request.getAttribute("message")%>"/>
<%-- <c:set var="checkmess" value="<%=(String)request.getAttribute("checkmess")%>"/> --%>
<c:set var="E_BUKRS" value="<%=(String)request.getAttribute("E_BUKRS")%>"/>
<c:set var="ANZHL_BAL" value="<%=data.ANZHL_BAL%>"/>
<c:set var="holidayVT" value="<%=holidayVT%>"/>

<c:set var="isUpdate" value="<%=isUpdate%>"/>

<c:set var="subty1" value="<%=subty1%>"/>
<c:set var="dataRemain" value="<%=dataRemain%>"/>
<c:set var="remainDays" value="<%=remainDays%>"/>
<c:set var="joinedDateLapse" value="<%=joinedDateLapse%>"/>

<tags:layout css="ui_library_approval.css"  script="dialog.js" >

<jsp:include page="${g.jsp }D/D01OT/D0103common.jsp"/>
	<jsp:include page="${g.jsp }D/timepicker-include.jsp"/>

<script language="JavaScript">

$(function(){

	   text	= document.form1.BEGUZ.value ;
	   text1	= document.form1.ENDUZ.value ;
	   if((text == "00:00") && (text1 == "00:00")){ 
		   	document.form1.BEGUZ.value = "";
		   	document.form1.ENDUZ.value = "";
	   }else{
		   if(text1.length==4){
			   	document.form1.ENDUZ.value	= text1.substring(0,2) + ":" + text1.substring(2,4);
		     	document.form1.BEGUZ.value	= text.substring(0,2) + ":" + text.substring(2,4);
		   }
	   }
	   
	check_upmuCode();   
	switch_timeopen();

	

})

function switch_timeopen(){
	var p_awart = document.form1.AWART.value;
	document.form1.timeopen.value = p_awart.substring(p_awart.length-1, p_awart.length)==('X')  ? 'T' : 'F'  ;
	$(".timeiconclass").css("display", document.form1.timeopen.value=='T' ? "inline-block" : "none" );	


	// 날짜와 시간 모두 체크
	    if ((document.form1.APPL_TO.value != "" && document.form1.APPL_FROM.value != "") &&
	    		(document.form1.BEGUZ.value != "" && document.form1.ENDUZ.value != "")) {		
    		document.form1.mode.value			= "dateTime";
	// 날짜만 체크		
		} else if ((document.form1.APPL_TO.value != "" && document.form1.APPL_FROM.value != "") && 
				(document.form1.BEGUZ.value == "" && document.form1.ENDUZ.value == "")) {		
    		document.form1.mode.value			= "date";
		}
}

function timeStartFocus(){
	if ($('#BEGUZ').attr('readonly')==true){                     
           $('.timeStart').timepicker('hide');
     }else{
            $('.timeStart').timepicker('show');
     }
}

function timeEndFocus(){
	if ($('#ENDUZ').attr('readonly')==true){                     
           $('.timeEnd').timepicker('hide');
     }else{
            $('.timeEnd').timepicker('show');
     }
}

// 달력 사용
function fn_openCal(Objectname) {
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window = window.open("${g.jsp}common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+
    		lastDate+"&iflag=0&optionvalue=","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=285,top=" + 
    		document.body.clientHeight/2 + ",left=" + document.body.clientWidth/2);
    small_window.focus();
}

function fn_openCal(Objectname, moreScriptFunction) {
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    lastDate = addPointAtDate(lastDate);
    small_window = window.open("${g.jsp}common/calendar.jsp?moreScriptFunction="+moreScriptFunction+
    		"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+
    		"&iflag=0&optionvalue=","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=285,top=" + 
    		document.body.clientHeight/2 + ",left=" + document.body.clientWidth/2);
    small_window.focus();
}

// 메시지
function show_waiting_smessage(div_id ,message) {
      var _x = document.body.clientWidth/2 + document.body.scrollLeft-210;
      var _y = document.body.clientHeight/2 + document.body.scrollTop-100;
      job_message.innerHTML = message;
      document.all[div_id].style.posLeft=_x;
      document.all[div_id].style.posTop=_y;
      document.all[div_id].style.visibility='visible';
}
   
function beforeSubmit() {
  
  var E_BUKRS		= "${ E_BUKRS }"; 
  
 if (check_data()) {
 		/*
 		LGCPI G400은 Quota가 있기 때문에 Quota Balance 내에서 사용하도록 처리
	    LGCAI G340은 Quota가 없음. 사용가능 일수 체크로직 필요 없음
 		*/
        if ((document.form1.AWART.value == '0100X') 
        	|| (document.form1.AWART.value == '0230X') 
        	|| (document.form1.AWART.value == '0240X')
        	|| (document.form1.AWART.value == '0530X' && E_BUKRS == 'G400')
        	) { 
            if (Number(document.form1.E_ABRTG.value) > Number(document.form1.ANZHL_BAL.value)) {
		         alert("<spring:message code='MSG.D.D03.0035'/>");//Request days should be less than quota days.");
		         document.form1.APPL_FROM.value	= "";
       			 document.form1.APPL_TO.value = "";
       			 document.form1.E_ABRTG.value = "";
       			 document.form1.AWART.value = ""
       			 document.form1.AWART.focus();
       			 
       			 sp1.style.visibility = 'hidden';
			   	 sp2.style.visibility = 'hidden';
			   	 sp3.style.visibility = 'hidden'; 
       			 
		         return false;
			}        
        }
        
        //Bereavement의 경우는 Search family type을 선택하지 않고  신청하는 경우 신청 불가 되도록 처리
        // LGCMI의 경우 만 체크하도록 한다.
        if (E_BUKRS == 'G380'){
	        if (document.form1.AWART.value == '0530X'){
	        	if (document.form1.FAMY_CODE.value == ''){
	        		alert("<spring:message code='MSG.D.D03.0046'/>");//You have to choose Family Relations.');
	        		return false;
	        	}
	        }
	        
	        // Maximun Available 보다 더 많은 날을 신청 시에 신청이 되고 있는데, 신청이 되지 않도록 처리.(
	        if (document.form1.AWART.value == '0530X'){
	        	if(Number(document.form1.E_ABRTG.value) > Number(document.form1.P_STDAZ2.value)){
			         alert("<spring:message code='MSG.D.D03.0053'/>");//Request days should be less than Maximun Available days.");
	  		         return false;
		      }        	
	        }
        }
        
        // 신청관련 단위 모듈에서 필히 넣어야할 항목-Approval Infomation 의 정보가 필히 있어야 한다.
        /*
        	기존 로직에서는 absendce type 의 값의 마지막 값이 X 가 아닐  경우만 체크를 하였는데
        	모두 다 체크하는것으로 바꿈
        */
        var e_area = '${user.e_area}'        
//         if (e_area == '10'){
// 		  	if (check_empNo()) {
// 		    	return;
// 			}
// 		}
        
	    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
        document.form1.APPL_FROM.value	= removePoint(document.form1.APPL_FROM.value);
        document.form1.APPL_TO.value		= removePoint(document.form1.APPL_TO.value);
         
        if (document.form1.BEGUZ.value != "") {
        	document.form1.BEGUZ.value = removeColon(document.form1.BEGUZ.value) + "00";
        }  
        
        if (document.form1.ENDUZ.value != "") {
        	document.form1.ENDUZ.value = removeColon(document.form1.ENDUZ.value) + "00";
        }
        
        if (document.form1.timeopen.value == "T") {
        	document.form1.AWART1.value = document.form1.AWART.value.substring(0,document.form1.AWART.value.length-1);
        } else {
        	document.form1.AWART1.value = document.form1.AWART.value;
        }
        
		if (document.form1.E_ABRTG.value  == "" || document.form1.E_ABRTG.value  == null) {
			alert("<spring:message code='MSG.D.D03.0034'/>");//Application Period Days must be inputed. \n Please try again after a while!
			return false;
		}        
        
// 		buttonDisabled();     
        //show_waiting_smessage("waiting","Now saving.... Please wait for a moment!");
//         document.form1.jobid.value	= "create";
//         document.form1.action			= "${ g.servlet}hris.D.D03Vocation.D03VocationBuildEurpSV?AINF_SEQN2="+document.form1.AINF_SEQN2.value;
//         document.form1.method 		= "post";
//         document.form1.submit();
		return true;
    }
	return false;
}

var flag = 0 ; 

function EnterCheck2(object) {
	if (event.keyCode == 13) {
		flag = 1;
		dateFormat(object);
		check_Time();
	}
}

function EnterCheck3(object) {
	if(event.keyCode == 13) {
		flag = 1;
		timeFormat(object);
		check_Time();
	}
}

function f_dateFormat(obj) {
	if (flag == 1) { 
		flag = 0;
		return;
	}
	dateFormat(obj);
	check_Time();
}

function f_timeFormat(obj) {
	if (flag == 1) { 
		flag = 0;
		return;
	}
	timeFormat(obj);
	check_Time();
}

// data check
function check_data() {
 
    if (checkNull(document.form1.APPL_REAS, "<spring:message code='LABEL.D.D15.0157'/>") == false){//Application Reason
        return false;
    }
    if (checkNull(document.form1.APPL_FROM, "<spring:message code='LABEL.D.D12.0003'/>") == false){ //Application Period
        return false;
    }
    if (checkNull(document.form1.APPL_TO, "<spring:message code='LABEL.D.D12.0003'/>") == false){ //Application Period
        return false;
    }
    
    if (document.form1.timeopen.value == "T") {
    	if (document.form1.mode.value == "dateTime") {
      		if (checkNull(document.form1.BEGUZ, "<spring:message code='LABEL.D.D03.0023'/>") == false){//Application Time
          		return false;
       		}
	   		if (checkNull(document.form1.ENDUZ, "<spring:message code='LABEL.D.D03.0023'/>") == false){//Application Time
	       		return false;
	   		}	
	   	}
	   	return true;
    }
    
    // 다른 프로젝트 호완을 위해 남겨둔다.
//     if (check_empNo()) {
//     	return false;
// 	}
  	
  
	return true;
}

function reload() {
    frm = document.form1;
    frm.jobid.value = "first";
    frm.action = "${ g.servlet}hris.D.D03Vocation.D03VocationBuildEurpSV";
    frm.target = "";
    frm.submit();
}

function check_Time() {
 	
	if (document.form1.AWART.value == "") {
		alert("<spring:message code='MSG.D.D03.0048'/>");//Please select Absence Type
		document.form1.APPL_FROM.value= "";
		return;
	}
 		
	document.form1.E_ABRTG.value = "";
	document.form1.I_STDAZ.value = "";
	
	var E_BUKRS = "${ E_BUKRS }";
	
    if (document.form1.timeopen.value == "F") {
    
		if (document.form1.APPL_TO.value == "") {
			document.form1.APPL_TO.value = document.form1.APPL_FROM.value;          
		}
		
		//-----------신청기간의 일수를 가져옴 -----------
		if ((document.form1.APPL_TO.value != "") && (document.form1.APPL_FROM.value != "")) {
		      document.form1.APPL_FROM.value		= removePoint(document.form1.APPL_FROM.value);
		      document.form1.APPL_TO.value     	= removePoint(document.form1.APPL_TO.value);
		      document.form1.BEGUZ.value       	= "0000";
		      document.form1.ENDUZ.value       	= "0000";

		      var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildEurpSV';
			  var pars = 'PERNR=${data.PERNR}&APPL_FROM=' + document.form1.APPL_FROM.value + "&APPL_TO=" + 
			  document.form1.APPL_TO.value + "&AWART=" + document.form1.AWART.value + "&jobid="+"check" + "&BEGUZ=" +
			  document.form1.BEGUZ.value + "&ENDUZ=" + document.form1.ENDUZ.value + "&TMP_UPMU_CODE=" +
			  document.form1.TMP_UPMU_CODE.value;	
//			  var myAjax = $.ajax(url,{method: 'get',parameters: pars,onComplete: showResponse});
			  $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});

		}
    } else {
    
		if (document.form1.APPL_TO.value == "") {
		   document.form1.APPL_TO.value = document.form1.APPL_FROM.value;          
		}
	
		// 날짜와 시간 모두 체크
   	    if ((document.form1.APPL_TO.value != "" && document.form1.APPL_FROM.value != "") &&
   	    		(document.form1.BEGUZ.value != "" && document.form1.ENDUZ.value != "")) {		
     			document.form1.APPL_FROM.value	= removePoint(document.form1.APPL_FROM.value);
		    	document.form1.APPL_TO.value    	= removePoint(document.form1.APPL_TO.value);
		    	document.form1.BEGUZ.value      	= removeColon(document.form1.BEGUZ.value);
        		document.form1.ENDUZ.value      	= removeColon(document.form1.ENDUZ.value);
        		document.form1.mode.value			= "dateTime";

             	var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildEurpSV';
				var pars = 'PERNR=${data.PERNR}&APPL_FROM=' + document.form1.APPL_FROM.value + "&APPL_TO=" + 
				document.form1.APPL_TO.value + "&AWART=" + document.form1.AWART.value + "&jobid=" + "check" + "&BEGUZ=" +
				document.form1.BEGUZ.value + "&ENDUZ=" + document.form1.ENDUZ.value + "&TMP_UPMU_CODE=" + 
				document.form1.TMP_UPMU_CODE.value;	
//				var myAjax = new $.ajax(url,{method: 'get',parameters: pars,onComplete: showResponse});
				$.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
		
		// 날짜만 체크		
 		} else if ((document.form1.APPL_TO.value != "" && document.form1.APPL_FROM.value != "") && 
 				(document.form1.BEGUZ.value == "" && document.form1.ENDUZ.value == "")) {		
 		     	document.form1.APPL_FROM.value	= removePoint(document.form1.APPL_FROM.value);
		    	document.form1.APPL_TO.value    	= removePoint(document.form1.APPL_TO.value);
		    	document.form1.BEGUZ.value      	= removeColon(document.form1.BEGUZ.value);
        		document.form1.ENDUZ.value      	= removeColon(document.form1.ENDUZ.value);
        		document.form1.mode.value			= "date";

             	var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildEurpSV';
				var pars = 'PERNR=${data.PERNR}&APPL_FROM=' + document.form1.APPL_FROM.value + "&APPL_TO=" + 
				document.form1.APPL_TO.value + "&AWART=" + document.form1.AWART.value + "&jobid=" + "check" + "&BEGUZ=" +
				document.form1.BEGUZ.value + "&ENDUZ=" + document.form1.ENDUZ.value + "&TMP_UPMU_CODE=" +
				document.form1.TMP_UPMU_CODE.value;	
//				var myAjax = new $.ajax(url,{method: 'get',parameters: pars,onComplete: showResponse});
				$.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
 		}
	}    
}
  
function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
	var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr; 
	for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  	if (!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  	if (!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

//----------------- 휴가유형이 선택될때  발생하는 function ---------------------
function js_change(  ) {
	var E_BUKRS		= "${ E_BUKRS }"; 
	var ANZHL_BAL	= "${ ANZHL_BAL }"; 
	switch_timeopen();

	
	// 잔여휴가일수가 남았을 경우.	@v1.2
	/*
	if(ANZHL_BAL != null && ANZHL_BAL != "0"){
	
		if(E_BUKRS == "G380"){
			if(document.form1.AWART.value == "0530X"){   
				alert("You can not apply if your quota balance is not zero.");
				document.form1.AWART.value = "";
				return;
			}
		}
	}
	*/

	// LGCMI의 경우 만 type 을 선택하게 한다.
	if (E_BUKRS == "G380" ){
		if(document.form1.AWART.value == '0530X'){
		   document.form1.P_STDAZ2.value		= "";
		   document.form1.FAMY_TEXT.value	= "";
		   document.form1.FAMY_CODE.value   = "";
		   form1.ATEXT.value = form1.AWART.options[form1.AWART.selectedIndex].text;
		   sp1.style.visibility = '';
		   sp2.style.visibility = '';
		   sp3.style.visibility = '';
	   }else{
	   	   sp1.style.visibility = 'hidden';
	   	   sp2.style.visibility = 'hidden';
	   	   sp3.style.visibility = 'hidden';  	 
	   }
   }
   
   // 입사일 90일 이후에 신청 가능하도록 처리
   var joinedDateLapse = '${joinedDateLapse}';
   
   
   // LGCMI의 경우 Personal Time 휴가 신청 시에 입사일 90일 이후에 신청 가능하도록 처리
   if (E_BUKRS == "G380" 
   			&& document.form1.AWART.value == '0230X'
   			&& joinedDateLapse < 90){
   		alert("<spring:message code='MSG.D.D03.0054'/>");//Personal Time is only available 90 days after the date of hire');
   		document.form1.AWART.value = "";
   		return;
   }
	
	document.form1.APPL_FROM.value	= "";
	document.form1.APPL_TO.value		= "";
	document.form1.BEGUZ.value			= "";
	document.form1.ENDUZ.value			= "";
	document.form1.E_ABRTG.value		= "";
	document.form1.I_STDAZ.value		= "";
	
	check_upmuCode();
   
    getQuotaBalance();
   
	getApp();		// 결제자변경.
	
 }




//시간 선택
function fn_openTime(Objectname) {
	 
	 if ((document.form1.APPL_FROM.value == "") || (document.form1.APPL_TO.value == "")) {
	     alert("please input Application Period.");
	     return;
	 }
	
		// 반날선택하였을때  (2가지경우 시간을 선택입력할수있는pop, 그리고 근무스케쥴에 따라 나누어진 pop)
	 if (document.form1.timeopen.value == "T" || document.form1.AWART.value == "0110") {
	      var E_BUKRS = "${E_BUKRS}";  
	  	var scrleft = screen.width/3;
		var scrtop = screen.height/2-100;
		     //if (document.form1.AWART.value == "0110X") {
				small_window = window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname, "","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=150,top="+scrtop+",left="+scrleft);
				small_window.focus();
			//}
	
	 } else {
	     alert("Application time can be inputted when absence type is applies for the leave (quite a while).");
	 }
}



function cfParamEscape(paramValue) {
    return encodeURIComponent(paramValue);
}

// 콤보박스 선택에 대한 Quota 재조회
function getQuotaBalance() {
	var url = '${ g.servlet}hris.D.D03Vocation.D03VocationBuildEurpSV';
	var awart = cfParamEscape(document.form1.AWART.value);
	var pars = 'jobid=getQuotaBalance&E_ABRTG=' + document.form1.E_ABRTG.value + '&PERNR=${data.PERNR}' +
	"&AWART=" + awart + "&rmd=&TMP_UPMU_CODE="+document.form1.TMP_UPMU_CODE.value;            
// 	var myAjax = new $.ajax(url,{method: 'post',parameters: pars,onComplete: setQuotaBalance});
	blockFrame();
	$.ajax({type:'post', url: url, data: pars, dataType: 'html', success: function(data){setQuotaBalance(data)}});
}

function setQuotaBalance(originalRequest) {
	var resTxt = originalRequest; 

	 $.unblockUI();
	 if(resTxt != ''){
		arr = resTxt.split(',');
     	$('#ANZHL_BAL').val( unescape(arr[0]));
     	$('#ANZHL_GEN').val( unescape(arr[1]));
     	$('#ANZHL_USE').val( unescape(arr[2]));
    	var remainDays = $('#ANZHL_GEN').val()==0 ?  0 : parseFloat($('#ANZHL_USE').val()  / $('#ANZHL_GEN').val() * 100);
    	$('#REMAINDAYS').val( pointFormat(remainDays,2) );
	}
}

//*************************************************************************
// 휴가유형 selectbox에 따른 각 업무코드.		2008-02-20.
function check_upmuCode() {		
	var UPMU_CODE_LIST = document.getElementsByName("upmu_code");
	var selected_idx = document.form1.AWART.selectedIndex + ${isUpdate==true?0:-1};
	if(${isUpdate==false} && selected_idx == -1){
	}else{
		document.form1.TMP_UPMU_CODE.value = UPMU_CODE_LIST[selected_idx].value;
	}
}
//*************************************************************************
 
function showResponse(originalRequest) {
//function showResponse(reqdata) {
 
	// put returned XML in the textarea
// 	if (originalRequest.responseText != "")
// 		arr = originalRequest.responseText.split(',');
	if (originalRequest != "")
		arr = originalRequest.split(',');
	
// 		arr = reqdata.resultList;
		
	var E_MESSAGE ;
	E_MESSAGE =  (arr[1]);

	// 근태기간완료된것을 신청하는  check (li hui)
    var flag = (arr[0]); 
	
	if(flag == "E"){ 
	   	document.form1.ENDUZ.value	= "";//text1.substring(0,2) + ":" + text1.substring(2,4);
     	document.form1.BEGUZ.value	= "";//text.substring(0,2) + ":" + text.substring(2,4);
	   	document.form1.APPL_FROM.value	= "";//text1.substring(0,2) + ":" + text1.substring(2,4);
     	document.form1.APPL_TO.value	= "";//text.substring(0,2) + ":" + text.substring(2,4);
     	document.form1.E_ABRTG.value	= "";//text.substring(0,2) + ":" + text.substring(2,4);
     	document.form1.I_STDAZ.value	= "";//text.substring(0,2) + ":" + text.substring(2,4);
     	/* 
		   text	= document.form1.BEGUZ.value ;
		   text1	= document.form1.ENDUZ.value ;
		   if(text.length==4){
			   	document.form1.ENDUZ.value	= "";//text1.substring(0,2) + ":" + text1.substring(2,4);
		     	document.form1.BEGUZ.value	= "";//text.substring(0,2) + ":" + text.substring(2,4);
		   }
			document.form1.APPL_FROM.value = addPointAtDate(document.form1.APPL_FROM.value);
			document.form1.APPL_TO.value = addPointAtDate(document.form1.APPL_TO.value);
		 */   
			E_MESSAGE = E_MESSAGE.substring(9, E_MESSAGE.lenth);
			alert(E_MESSAGE); //You can't apply this data in payroll period
		   return;
	} 

    var flag = (arr[4]); 
	if (flag == "N") {
		 alert("<spring:message code='MSG.D.D03.0047'/>");//You can't apply this data in payroll period
   	       document.form1.APPL_FROM.value	= "";
           document.form1.APPL_TO.value     	= "";
           document.form1.BEGUZ.value       	= "";
           document.form1.ENDUZ.value       	= "";
           document.form1.E_ABRTG.value     	= "";
		   // document.form1.P_STDAZ2.value	= "";
           document.form1.I_STDAZ.value     	= "";
		   document.form1.APPL_FROM.focus();
		   return;
	}
	 
	if (document.form1.APPL_FROM.value != "") {
		document.form1.APPL_FROM.value = addPointAtDate(document.form1.APPL_FROM.value);
	}
	
    if (document.form1.APPL_TO.value != "") {
		document.form1.APPL_TO.value = addPointAtDate(document.form1.APPL_TO.value);
	}
	
    text	= document.form1.BEGUZ.value;
    text1	= document.form1.ENDUZ.value;
    
    if ((text == "0000") && (text1 == "0000") || document.form1.mode.value == "date") { 
    	document.form1.BEGUZ.value = "";
    	document.form1.ENDUZ.value = "";
    	
    } else {
      	document.form1.BEGUZ.value	= text.substring(0,2) + ":" + text.substring(2,4);
      	document.form1.ENDUZ.value	= text1.substring(0,2) + ":" + text1.substring(2,4);
    }
 
    var E_ABRTG = (arr[0]);
	if (E_MESSAGE.charAt(0) == "E" || E_MESSAGE.charAt(0) == "W") {	// 2008-01-30
	 	alert(E_MESSAGE.substring(9, E_MESSAGE.length));
	    document.form1.APPL_FROM.value	= "";
        document.form1.APPL_TO.value     	= "";
        document.form1.BEGUZ.value       	= "";
        document.form1.ENDUZ.value       	= "";
        document.form1.E_ABRTG.value     	= "";
		// document.form1.P_STDAZ2.value	= "";
        document.form1.I_STDAZ.value     	= "";

	} else {
	  
	  $('#BEGUZ').val(arr[3].substring(0,5));
	  $('#ENDUZ').val(arr[2].substring(0,5));

       if (E_ABRTG.charAt(0) == ".") {
       	$('#E_ABRTG').val( "0" + arr[0]);
			if (document.form1.timeopen.value == "T") {
				$('#I_STDAZ').val(arr[1]);
			}
       } else {
       	   $('#E_ABRTG').val(arr[0]);
     	       	
			if (document.form1.timeopen.value == "T" && document.form1.mode == "dateTime") {
				$('#I_STDAZ').val( arr[1]);
			}
       }

		var E_BUKRS = "${ E_BUKRS }"; 
		 
		getApp();		// 결재자 변경
	 }
	switch_timeopen();
}
	
//---------------- 경조휴가를 가져올때 사용하는 pop---------------------------- 	
function f_pop() {
	if ((document.form1.AWART.value == "0120") || (document.form1.AWART.value == "0121") || 
			(document.form1.AWART.value == "0530X")) {
	  window.open("/web/D/D03Vocation/D03VocationPop.jsp?E_BUKRS=${E_BUKRS}&PERNR=${data.PERNR}&AWART="+
			  document.form1.AWART.value,"DeptPers",
	   "toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");	  
	}
}

//---------------- 반차일때 근무스케쥴을 선택할수있는 pop-----------------------
function f_pop2() { 
   if ((document.form1.APPL_FROM.value == "") || (document.form1.APPL_TO.value == "")) {
        alert("please input Application Period.");
        return;
   } 
   if (document.form1.timeopen.value == "T") {
       document.form1.sDate.value = removePoint(document.form1.APPL_FROM.value);
	   window.open("/web/D/D03Vocation/D03VocationPop2.jsp?PERNR=${data.PERNR}&AWART="+
			   document.form1.AWART.value.substring(0,document.form1.AWART.value.length-1) + "&APPL_FROM="+
			   document.form1.sDate.value,"DeptPers",
	   "toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=no,width=430,height=180,left=100,top=100");
    } else {
        alert("<spring:message code='MSG.D.D03.0049'/>");//Application time can be inputted when absence type is applies for the leave (quite a while).
    }
}
//-->

//----------------- 결재자 변경-----------------------------------------------
function getApp() {
	var url = '${ g.servlet}hris.D.D03Vocation.D03VocationBuildEurpSV';
	var pars = 'jobid=getApp&E_ABRTG=' + document.form1.E_ABRTG.value + '&PERNR=' + $('#PERNR').val() + "&AWART=" 
		+ document.form1.AWART.value + "&rmd=&TMP_UPMU_CODE="+document.form1.TMP_UPMU_CODE.value;            
// 	$.ajax(url,{method: 'get',parameters: pars,onComplete: setApp});
	$.ajax({type:'get', url: url, data: pars, dataType: 'html', success: function(data){setApp(data)}});

}
/* 
function setApp(originalRequest){
	var resTxt = originalRequest; 
	if(resTxt != ''){
		$('#-approvalLine-layout').html(unescape(resTxt));
     	<c:if test='${isUpdate==false }'>		
			parent.resizeIframe(document.body.scrollHeight);
		</c:if>
	}

    $("a,.unloading").click(function() {			
        if(!$(this).hasClass("loading")) {
            window.onbeforeunload = null;
            setTimeout(setBeforeUnload, 1000);
        }
    });

} */

//-----------------반차에서 입력한 시간단위의 정확성 판단-----------------------
function checkTime() {
     document.form1.BEGUZ.value = removeColon(document.form1.BEGUZ.value);
     document.form1.ENDUZ.value = removeColon(document.form1.ENDUZ.value);
     
     var url = '${ g.servlet}hris.D.D03Vocation.D03VocationBuildEurpSV';
     var pars = 'jobid=checkTime&BEGUZ=' + document.form1.BEGUZ.value+"&ENDUZ="+document.form1.ENDUZ.value ;
//      var myAjax = $.ajax(url,{method: 'get',parameters: pars,onComplete: getCheckTime});
 	$.ajax({type:'get', url: url, data: pars, dataType: 'html', success: function(data){getCheckTime(data)}});
}

function getCheckTime(originalRequest) {
  	if (document.form1.BEGUZ.value != "") {
		document.form1.BEGUZ.value   = addPointAtTime(document.form1.BEGUZ.value);
	}
    if (document.form1.ENDUZ.value != "") {
		document.form1.ENDUZ.value   = addPointAtTime(document.form1.ENDUZ.value);
	}
	
	var resTxt = originalRequest; 
	if (resTxt != "") {
     	if (resTxt == "N") {
     		alert("Input at 30 minute unit.");
     		document.form1.BEGUZ.value		= "";
            document.form1.ENDUZ.value  	= "";
            document.form1.E_ABRTG.value  = "";
            document.form1.I_STDAZ.value  = "";
            document.form1.BEGUZ.focus();
            return;
     	}
	}
}
//-->
</script>

    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO" representative="true">
        <!-- 상단 입력 테이블 시작-->

    <div class="tableArea">
        <div class="table">
        
		  <table class='tableGeneral tableApproval' border="0" cellspacing="0" cellpadding="0">

           	<colgroup>
            	<col width=15%/>
            	<col width=35%/>
            	<col width=15%/>
            	<col width=35%/>
          	</colgroup>
              <input type="hidden" name="BEGDA"  size="10" 	value="${isUpdate == true ? data.BEGDA : f:currentDate() }" readonly> 
                       
			
			  <input type="hidden" name="sDate" value="">
			  <input type="hidden" name="checkmess" value="${ checkmess }">
			  <input type="hidden" name="timeopen">
			  <input type="hidden" name="AWART1">
			  <input type="hidden" name="TMP_UPMU_CODE" value="">
			  <input type="hidden" name="mode" value="">
    
          <tr>
                    
                        <th ><span  class="textPink">*</span>
                        	<spring:message code='LABEL.D.D19.0016'/><!--  Absence Type&nbsp;-->
                        </th>
                        <td colspan=3 >
	                        
		                         <select name="AWART" class="input03" onchange="javascript:js_change(this.value)">
	                         <c:if test='${isUpdate==false }'>
		                         	<option value="">Select</option>
                         	</c:if>
		                             ${ f:printOption2(holidayVT, data.AWART) }
		                          </select>
		                             <!-- 각 휴가 유형에 따른 업무코드를 hidden값으로 가져온다.	2008-02-20. -->
									 ${ f:printOption3(holidayVT, subty1) }
									 <input type="hidden" name="ATEXT" value="">
	                          
	                          <a  id="sp1" style="visibility:hidden" class="inlineBtn" href="#">
                         			<span  onclick="f_pop();">
                         					<spring:message code='LABEL.D.D03.0024'/><!--Search family type-->
                         			</span>
                         		</a>
	                            <!-- 혼가/상가 신청시 선택한  FAMY_TEXT를 출력. -->
	                            <span id="sp3" style="visibility:hidden">
	                             	<input type="text" name="FAMY_TEXT" value=""  size="30"  readOnly>
	                             	<input type="hidden" name="FAMY_CODE" value="" readOnly>
	                            </span>
			                      
                          </td>  
                      </tr>
                      <tr> 
                        <th ><span  class="textPink">*</span>
                        	<spring:message code='LABEL.D.D19.0005'/><!--Application Reason&nbsp;-->
                        </th>
                        <td colspan=3 > 
                       		<input type="text" name="APPL_REAS" value="${ data.APPL_REAS }" class="input03" size="65" maxlength="100" style="ime-mode:active">
                         
                        </td>
                      </tr>
                      <tr>
                        <th ><spring:message code='LABEL.D.D03.0025'/><!--Quota Balance--></th>
                        <td >
                            	<input type="text" id="ANZHL_BAL"  name="ANZHL_BAL" 
                            	value="${  f:printNumFormat(data.ANZHL_BAL ,2) }"  size="3" maxlength="7" 
                            	style="ime-mode:active;text-align:right;" readonly>
									<spring:message code="LABEL.D.D03.0031"/> 
                            </td>
		                            
		                 <th class="th02">
		                 		<spring:message code='LABEL.D.D03.0200'/><!-- Use rate(%) -->
		               	</th>
		               	<td >
		               		 <input class="noBorder" type="text" id="REMAINDAYS" name="REMAINDAYS"  size="4" value="${f:printNumFormat(remainDays,2)}" />(
		               		 <input class="noBorder" type="text" id="ANZHL_USE" name="ANZHL_USE" size="4" value="${dataRemain.ANZHL_USE}" />/
		               		 <input class="noBorder" type="text" id="ANZHL_GEN" name="ANZHL_GEN" size="4" value="${dataRemain.ANZHL_GEN}" />)
		                 </td>
                      </tr>
                       
                      <tr> 
                        <th ><span  class="textPink">*</span>
                        	<spring:message code='LABEL.D.D12.0003'/><!--Application Period&nbsp;-->
                        </th>
                        <td colspan=3 >
                        	<input type="text" id="APPL_FROM"  name="APPL_FROM"  
                              	onChange="check_Time();"
                             value="${  f:printDate(data.APPL_FROM) }" 
                             size="10" class="date required" onkeypress="EnterCheck2(this)"  > <!-- onBlur="f_dateFormat(this);"  -->
                             
                             ~&nbsp;<input type="text" id="APPL_TO"    name="APPL_TO"   
                              	onChange="check_Time();"
                             value="${  f:printDate(data.APPL_TO)   }" 
                             size="10" class="date required" onkeypress="EnterCheck2(this)"  > <!-- onBlur="f_dateFormat(this);"  -->
                             
                             	<input type="text" name="E_ABRTG" ID="E_ABRTG" value="${data.ABRTG}"  size="3"  style="text-align:right;" 
                             	readonly>Days
                             	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                             	<span id="sp2" style="visibility:hidden"><spring:message code='LABEL.D.D03.0026'/><!--Maximum Available&nbsp;-->
                             	<input type="text" name="P_STDAZ2" value=""  size="2" maxlength="7" 
                             	style="ime-mode:active;text-align:right;" readonly>
                             	<c:if test='${E_BUKRS==("G380")}'>                        
	                           day
	                           </c:if>
	                           </span>
                             </td>
                             <input type="hidden" name="AINF_SEQN2" value=""  size="3"  readonly>
                          </tr>
                      
                      <tr> 
                        <th ><spring:message code="LABEL.D.D03.0023"/><!-- Application Time --></th>
                        <td colspan=3 >
                         	<input type="text"  id="BEGUZ" name="BEGUZ" value="${ f:printTime(data.BEGUZ) }" 
                                size="7"  readonly  onkeypress="EnterCheck3(this)"> <!-- class="timeStart"  onBlur="timeFormat(this);" onFocus="timeStartFocus();" -->
                              <a href="javascript:fn_openTime('BEGUZ');"  >
                              <img class="timeiconclass" src="${g.image }icon_time.gif" align="absmiddle" border="0"></a>
                                
                                &nbsp;~&nbsp;<input type="text"  id="ENDUZ" name="ENDUZ" value="${ f:printTime(data.ENDUZ) }"
                                 size="7" readonly onkeypress="EnterCheck3(this)" ><!-- class="timeEnd"   onBlur="timeFormat(this);" onFocus="timeEndFocus();"-->
                               <a href="javascript:fn_openTime('ENDUZ');"  >
                               <img class="timeiconclass" src="${g.image }icon_time.gif" align="absmiddle" border="0"></a>
                                 
                                <input type="text" id="I_STDAZ" name="I_STDAZ" value="${data.i_STDAZ }" size="3"  
                                readonly style="text-align:right;">hour(s)
                                </td>
                             </tr>
                        
                  
              <!-- 상단 입력 테이블 끝-->
             
			</table>

       		<div class="commentsMoreThan2">
		         <spring:message code="MSG.COMMON.0061"/><!-- &nbsp;&nbsp;*: Required Field -->	
	        </div>

			</div></div>

		<!-- HIDDEN  처리해야할 부분 시작 (default = 전일휴가), frdate, todate는 선택된 기간에 개인의 근무일정을 가져오기 위해서.. -->
		<input type="hidden" name="DEDUCT_DATE" value="${ data.DEDUCT_DATE }">
		<!-- HIDDEN  처리해야할 부분 끝   -->

   </tags-approval:request-layout>
	
	<form name="form3" method="post">
		<input type="hidden" name="PERNR" value="${ data.PERNR }">
	</form>

</tags:layout>

<iframe name="ifHidden" width="0" height="0" />
