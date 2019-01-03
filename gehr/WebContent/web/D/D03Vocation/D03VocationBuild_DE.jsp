<%/***************************************************************************************/			
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Application                                                  																	*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Leave                                               																			*/
/*   Program ID   		: D03VocationBuildDe.jsp                                              															*/
/*   Description  		: 휴가(Leave)신청을 하는 화면[독일]                           																			*/
/*   Note         		:                                                             																		*/
/*   Creation     		: 2010-07-28 yji 															*/
/*                           2016-09-07 [CSR ID:3163684] 휴가 신청 관련 수정요청                                         																		*/
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
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>

<%
    WebUserData user    	= (WebUserData)session.getAttribute("user");
    
    String	 PERNR    		= (String)request.getAttribute("PERNR");
    String	 jobid   			= (String)request.getAttribute("jobid");
    String	 message 		= (String)request.getAttribute("message");
//     String	 checkmess 	= (String)request.getAttribute("checkmess");
    String	 E_BUKRS 		= (String)request.getAttribute("E_BUKRS");
    
    /* 휴가신청 */
    Vector	d03VocationData_vt = null;
    D03VocationData data          = null;
    d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    data               		= (D03VocationData)d03VocationData_vt.get(0);
    
    String	 ANZHL_BAL	= data.ANZHL_BAL;
 
    if( message == null ){
    	message = "";
    }

    String  subty1               = (String)request.getAttribute("subty1");
    if(subty1 == null)
    {
  		subty1 = "";
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

<tags:layout css="ui_library_approval.css"  script="dialog.js" >

<jsp:include page="${g.jsp }D/D01OT/D0103common.jsp"/>
		<jsp:include page="${g.jsp }D/timepicker-include.jsp"/>

	<script language="JavaScript">


$(function(){
	check_upmuCode();  
	//js_change();
  
	
	<c:choose>
	<c:when test ='${isUpdate!=true}'>
		$('#-approvalLine-table').html(""); // 초기 결재라인 재거 *KSC
		document.form1.AWART.selectedIndex=0;
	</c:when>
	<c:otherwise>
		document.form1.APPL_FROM.value = "${f:printDate(data.APPL_FROM)}";
		document.form1.APPL_TO.value = "${f:printDate(data.APPL_TO)}"; 
		document.form1.BEGUZ.value = ("${data.BEGUZ}" =='00:00:00') ? '': '${f:printTime(data.BEGUZ)}';
		document.form1.ENDUZ.value = ("${data.ENDUZ}"=='00:00:00') ? '' : '${f:printTime(data.ENDUZ)}';
		document.form1.I_STDAZ.value = "${data.STDAZ}";
		document.form1.E_ABRTG.value = "${ f:printNumFormat(data.ABRTG,2)}";
	</c:otherwise>
	</c:choose>
	
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
	if ($('#BEGUZ').attr('readonly')){                     
           $('.timeStart').timepicker('hide');
     }else{
            $('.timeStart').timepicker('show');
     }
}

function timeEndFocus(){
	if ($('#ENDUZ').attr('readonly')){                     
           $('.timeEnd').timepicker('hide');
     }else{
            $('.timeEnd').timepicker('show');
     }
}

// 달력 사용
function fn_openCal(Objectname){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window = window.open("${g.jsp}common/calendar.jsp?formname=form1&fieldname="+
    		Objectname+"&curDate="+lastDate+
    		"&iflag=0&optionvalue=","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=285,top=" + 
    		document.body.clientHeight/2 + ",left=" + document.body.clientWidth/2);
    small_window.focus();
}

function fn_openCal(Objectname, moreScriptFunction){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    lastDate = addPointAtDate(lastDate);
    small_window = window.open("${g.jsp}common/calendar.jsp?moreScriptFunction="+
    		moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+
    		"&iflag=0&optionvalue=","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=285,top=" + 
    		document.body.clientHeight/2 + ",left=" + document.body.clientWidth/2);
    small_window.focus();
}

  
  //메시지
  function show_waiting_smessage(div_id ,message)
  {
      var _x = document.body.clientWidth/2 + document.body.scrollLeft-210;
      var _y = document.body.clientHeight/2 + document.body.scrollTop-100;
      job_message.innerHTML = message;
      document.all[div_id].style.posLeft=_x;
      document.all[div_id].style.posTop=_y;
      document.all[div_id].style.visibility='visible';
  }
   
function beforeSubmit() {
   
 if( check_data() ) {
	    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
        document.form1.APPL_FROM.value	= removePoint(document.form1.APPL_FROM.value);
        document.form1.APPL_TO.value		= removePoint(document.form1.APPL_TO.value);
         
        if(document.form1.BEGUZ.value!=""){
        	document.form1.BEGUZ.value = removeColon(document.form1.BEGUZ.value) + "00";
        }  
        
        if(document.form1.ENDUZ.value!=""){
        	document.form1.ENDUZ.value = removeColon(document.form1.ENDUZ.value) + "00";
        }
        
        if( document.form1.timeopen.value == 'T' ) {
        	document.form1.AWART1.value = document.form1.AWART.value.substring(0,document.form1.AWART.value.length-1);
        }else{
        	document.form1.AWART1.value = document.form1.AWART.value;
        }
        
		if(document.form1.E_ABRTG.value  == "" || document.form1.E_ABRTG.value  == null){
			alert("<spring:message code='MSG.D.D03.0034'/>");//Application Period Days must be inputed. \n Please try again after a while!
			return false;
		}        
        
// 		buttonDisabled();     
        //show_waiting_smessage("waiting","Now saving.... Please wait for a moment!");
        document.form1.jobid.value	= "create";
        document.form1.action			= "${ g.servlet }hris.D.D03Vocation.D03VocationBuildEurpSV?AINF_SEQN2="+
        		document.form1.AINF_SEQN2.value;
        document.form1.method 		= "post";
        //document.form1.submit();
        return true;
    }
	return false;
}

var flag = 0 ; 

function EnterCheck2(object){
	if(event.keyCode == 13){
		flag = 1;
		dateFormat(object);
		check_Time();
	}
}

function EnterCheck3(object){
	if(event.keyCode == 13){
		flag = 1;
		timeFormat(object);
		check_Time();
	}
}

function f_dateFormat(obj){
	if(flag == 1){ 
		flag = 0;
		return;
	}
	dateFormat(obj);
	check_Time();
}

function f_timeFormat(obj){
	if(flag == 1){ 
		flag = 0;
		return;
	}
	timeFormat(obj);
	check_Time();
}

// data check
function check_data(){
 
    if(checkNull(document.form1.APPL_REAS, "<spring:message code='LABEL.D.D15.0157'/>") == false){//Application Reason
        return false;
    }
    if(checkNull(document.form1.APPL_FROM, "<spring:message code='LABEL.D.D12.0003'/>") == false){ //Application Period
        return false;
    }
    if(checkNull(document.form1.APPL_TO, "<spring:message code='LABEL.D.D12.0003'/>") == false){ //Application Period
        return false;
    }
    if(document.form1.timeopen.value == 'T'){
       if(checkNull(document.form1.BEGUZ, "<spring:message code='LABEL.D.D03.0023'/>") == false){//Application Time
          return false;
       }
	   if(checkNull(document.form1.ENDUZ, "<spring:message code='LABEL.D.D03.0023'/>") == false){//Application Time
	       return false;
	   }
	   return true;
    }

  // 신청관련 단위 모듈에서 필히 넣어야할 항목
//   if ( check_empNo() ){
//     return false;
//   }
  
 return true;
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "${ g.servlet }hris.D.D03Vocation.D03VocationBuildEurpSV";
    frm.target = "";
    frm.submit();
}

 function  check_Time(){
	 
	if(document.form1.AWART.value == ""){
		alert("<spring:message code='MSG.D.D03.0048'/>");//Please select Absence Type
		document.form1.APPL_FROM.value= "";
		return;
	}

    //--------------------------------------------------------------------------------------//
    date_from  = removePoint(document.form1.APPL_FROM.value);
    date_to    = removePoint(document.form1.APPL_TO.value);

    if( date_from > date_to && (date_to > "") ) {
      	alert("<spring:message code='MSG.D.D03.0024'/>");//신청시작일이 신청종료일보다 큽니다.
      	document.form1.APPL_TO.value="";
      	return false;
    }
    
 
    if(document.form1.timeopen.value == 'F'){
    
		if(document.form1.APPL_TO.value == ""){
			document.form1.APPL_TO.value = document.form1.APPL_FROM.value;          
		}
		
		//-----------신청기간의 일수를 가져옴 -----------
		if((document.form1.APPL_TO.value != "") && (document.form1.APPL_FROM.value != "")){
		      document.form1.APPL_FROM.value		= removePoint(document.form1.APPL_FROM.value);
		      document.form1.APPL_TO.value     	= removePoint(document.form1.APPL_TO.value);
		      document.form1.BEGUZ.value       	= "0000";
		      document.form1.ENDUZ.value       	= "0000";

		      var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildEurpSV';
			  var pars = 'PERNR=${data.PERNR}&APPL_FROM=' + document.form1.APPL_FROM.value + "&APPL_TO=" + document.form1.APPL_TO.value + 
			  		"&AWART=" + document.form1.AWART.value + "&jobid="+"check" + "&BEGUZ=" + document.form1.BEGUZ.value + "&ENDUZ=" + document.form1.ENDUZ.value + 
			  		"&TMP_UPMU_CODE=" + document.form1.TMP_UPMU_CODE.value;	
// 			  var myAjax = new $.ajax(url,{method: 'get',parameters: pars,onComplete: showResponse});
			  $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
		  }
         
    }else{
    
       if(document.form1.APPL_TO.value == ""){
          document.form1.APPL_TO.value = document.form1.APPL_FROM.value;          
       }
        
       //-----------신청기간의 일수를 가져옴 (반차)-----------
       //반차의 경우 시간이 있어야지만  일수를 리턴해올 수 있다.
       //그러므로 시간을 선택한 경우에만 제대로 된 일수를 리턴해올 수 있다.
       if((document.form1.APPL_TO.value != "") && (document.form1.APPL_FROM.value != "") && (document.form1.BEGUZ.value != "") && (document.form1.ENDUZ.value != "")){
	        document.form1.APPL_FROM.value	= removePoint(document.form1.APPL_FROM.value);
            document.form1.APPL_TO.value    	= removePoint(document.form1.APPL_TO.value);
            document.form1.BEGUZ.value      	= removeColon(document.form1.BEGUZ.value);
            document.form1.ENDUZ.value      	= removeColon(document.form1.ENDUZ.value);
            
	        var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildEurpSV';
			var pars = 'PERNR=${data.PERNR}&APPL_FROM=' + document.form1.APPL_FROM.value + "&APPL_TO=" + document.form1.APPL_TO.value + 
			"&AWART=" + document.form1.AWART.value + "&jobid=" + "check" + "&BEGUZ=" + document.form1.BEGUZ.value + "&ENDUZ=" + 
			document.form1.ENDUZ.value + "&TMP_UPMU_CODE=" + document.form1.TMP_UPMU_CODE.value;	
// 			var myAjax = new $.ajax(url,{method: 'get',parameters: pars,onComplete: showResponse});
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
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

//----------------- 휴가유형이 선택될때  발생하는 function ---------------------
function js_change() {

	var E_BUKRS		= '${ E_BUKRS }'; 
	var ANZHL_BAL	= '${ ANZHL_BAL }'; 
	
   	sp1.style.visibility = 'hidden';
//   	sp2.style.visibility = 'hidden';
   	sp3.style.visibility = 'hidden';  	 
	
	document.form1.timeopen.value= document.form1.AWART.value.substring(document.form1.AWART.value.length-1,document.form1.AWART.value.length)==('X')  ? 'T' : 'F'  ;
	$("#BEGUZ").attr("readonly", (document.form1.timeopen.value=='F') );	// ksc 추가부분
	$("#ENDUZ").attr("readonly", (document.form1.timeopen.value=='F') );  // ksc 추가부분

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

function cfParamEscape(paramValue) 
{
    return encodeURIComponent(paramValue);
}

// 콤보박스 선택에 대한 Quota 재조회
function getQuotaBalance(){
        var url = '${ g.servlet }hris.D.D03Vocation.D03VocationBuildEurpSV';
		var awart = cfParamEscape(document.form1.AWART.value);
        var pars = 'jobid=getQuotaBalance&E_ABRTG=' + document.form1.E_ABRTG.value + '&PERNR=' + $('#PERNR').val() + 
        "&AWART=" + awart + "&rmd=&TMP_UPMU_CODE="+document.form1.TMP_UPMU_CODE.value;            
//         var myAjax = new $.ajax(url,{method: 'post',parameters: pars,onComplete: setQuotaBalance});
    	$.ajax({type:'post', url: url, data: pars, dataType: 'html', success: function(data){setQuotaBalance(data)}});
}

function setQuotaBalance(originalRequest){
	var resTxt = originalRequest; 

	 $.unblockUI();
	if(resTxt != ''){
		arr = resTxt.split(',');
     	$('#ANZHL_BAL').val( unescape(arr[0]));
     	$('#ANZHL_GEN').val( unescape(arr[1]));
     	$('#ANZHL_USE').val( unescape(arr[2]));
	}
}


//*************************************************************************
// 휴가유형 selectbox에 따른 각 업무코드.		2008-02-20.
 function check_upmuCode(){		
// 	var UPMU_CODE_LIST = document.getElementsByName("upmu_code");
// 	document.form1.TMP_UPMU_CODE.value = UPMU_CODE_LIST[document.form1.AWART.selectedIndex].value;
// 	if(document.form1.AWART.selectedIndex == 0 && ${!isUpdate}){ // 입력모드에서 select를 선택하면 오류방지
// 		document.form1.TMP_UPMU_CODE.value = "";
// 	} else {
// 		document.form1.TMP_UPMU_CODE.value = UPMU_CODE_LIST[document.form1.AWART.selectedIndex - ${isUpdate?0:1}].value;
// 	}
	

	var UPMU_CODE_LIST = document.getElementsByName("upmu_code");
	var selected_idx = document.form1.AWART.selectedIndex + ${isUpdate==true?0:-1};
	if(${isUpdate==false} && selected_idx == -1){
	}else{
		document.form1.TMP_UPMU_CODE.value = UPMU_CODE_LIST[selected_idx].value;
	}
	
 }
//*************************************************************************
 
 function showResponse(originalRequest){

	 $.unblockUI();

	//put returned XML in the textarea
	if (originalRequest!='')
		arr = originalRequest.split(',');
	
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
	if(flag == "N"){
		   alert("<spring:message code='MSG.D.D03.0047'/>");//You can't apply this data in payroll period
   	       document.form1.APPL_FROM.value	= "";
           document.form1.APPL_TO.value     	= "";
           document.form1.BEGUZ.value       	= "";
           document.form1.ENDUZ.value       	= "";
           document.form1.E_ABRTG.value     	= "";
//           document.form1.P_STDAZ2.value    	= "";
           document.form1.I_STDAZ.value     	= "";
		   document.form1.APPL_FROM.focus();
		   return;
	}
	 
	if(document.form1.APPL_FROM.value!=""){
		document.form1.APPL_FROM.value = addPointAtDate(document.form1.APPL_FROM.value);
	}
	
    if(document.form1.APPL_TO.value!=""){
		document.form1.APPL_TO.value = addPointAtDate(document.form1.APPL_TO.value);
	}
	
    text	= document.form1.BEGUZ.value ;
    text1	= document.form1.ENDUZ.value ;
    
    if((text == "0000") && (text1 == "0000") || text.length < 4 || text1.length<4 ){ 
    	document.form1.BEGUZ.value = "";
    	document.form1.ENDUZ.value = "";
    	
    }else{
 	   	document.form1.ENDUZ.value	= text1.substring(0,2) + ":" + text1.substring(2,4);
      	document.form1.BEGUZ.value	= text.substring(0,2) + ":" + text.substring(2,4);
    }
 
    var E_ABRTG = (arr[0]); 
	if(E_MESSAGE.charAt(0)=="E" || E_MESSAGE.charAt(0)=="W"){	//2008-01-30
	 	alert(E_MESSAGE.substring(9, E_MESSAGE.length));
	    document.form1.APPL_FROM.value	= "";
        document.form1.APPL_TO.value     	= "";
        document.form1.BEGUZ.value       	= "";
        document.form1.ENDUZ.value       	= "";
        document.form1.E_ABRTG.value     	= "";
//        document.form1.P_STDAZ2.value    = "";
        document.form1.I_STDAZ.value     	= "";

	}else{
	  
	  $('#ENDUZ').value = arr[3].substring(0,5);
	  

	       if(E_ABRTG.charAt(0)=="."){
	       	$('#E_ABRTG').val( "0" + arr[0]);
				if(document.form1.timeopen.value == "T"){
					$('#I_STDAZ').val( arr[1]);
				}
	       }else{
	       	    $('#E_ABRTG').val( arr[0]);
				if(document.form1.timeopen.value == "T"){
					$('#I_STDAZ').val(arr[1]);
				}
	       }

		 var E_BUKRS = '${ E_BUKRS }'; 
		 
			      	getApp();		// 결재자 변경
	 }
}
	
//---------------- 경조휴가를 가져올때 사용하는 pop---------------------------- 	
function f_pop() {
	if((document.form1.AWART.value =='0120') || (document.form1.AWART.value =='0121')){
	   window.open("/web/D/D03Vocation/D03VocationPop.jsp?PERNR=${data.PERNR}&AWART="+document.form1.AWART.value,"DeptPers",
	   "toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
	}
}

//---------------- 반차일때 근무스케쥴을 선택할수있는 pop-----------------------
function f_pop2() { 
   if((document.form1.APPL_FROM.value=="") || (document.form1.APPL_TO.value=="")){
        alert("please input Application Period.");
        return;
   } 
   if(document.form1.timeopen.value == 'T') {
       document.form1.sDate.value = removePoint(document.form1.APPL_FROM.value);
	   window.open("/web/D/D03Vocation/D03VocationPop2.jsp?PERNR=${data.PERNR}&AWART="+document.form1.AWART.value.substring(0,document.form1.AWART.value.length-1) + "&APPL_FROM="+document.form1.sDate.value,"DeptPers",
	   "toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=no,width=430,height=180,left=100,top=100");
    } else {
        alert("<spring:message code='MSG.D.D03.0049'/>");//Application time can be inputted when absence type is applies for the leave (quite a while).
    }
}
//-->

//----------------- 결재자 변경-----------------------------------------------
function getApp(){
        var url = '${ g.servlet }hris.D.D03Vocation.D03VocationBuildEurpSV';
        var pars = 'jobid=getApp&E_ABRTG=' + document.form1.E_ABRTG.value + '&PERNR=' + $('#PERNR').val() + "&AWART=" +
        document.form1.AWART.value + "&rmd=&TMP_UPMU_CODE="+document.form1.TMP_UPMU_CODE.value;            
//         var myAjax = new $.ajax(url,{method: 'get',parameters: pars,onComplete: setApp});
    	$.ajax({type:'get', url: url, data: pars, dataType: 'html', success: function(data){setApp(data)}});
}



//-----------------반차에서 입력한 시간단위의 정확성 판단-----------------------
function checkTime(){
     document.form1.BEGUZ.value       = removeColon(document.form1.BEGUZ.value);
     document.form1.ENDUZ.value       = removeColon(document.form1.ENDUZ.value);
     
     var url = '${ g.servlet }hris.D.D03Vocation.D03VocationBuildEurpSV';
     var pars = 'jobid=checkTime&BEGUZ=' + document.form1.BEGUZ.value+"&ENDUZ="+document.form1.ENDUZ.value ; 
//      var myAjax = new $.ajax(url,{method: 'get',parameters: pars,onComplete: getCheckTime});
  	$.ajax({type:'get', url: url, data: pars, dataType: 'html', success: function(data){getCheckTime(data)}});
}

function getCheckTime(originalRequest){
  	if(document.form1.BEGUZ.value!=""){
		document.form1.BEGUZ.value   = addPointAtTime(document.form1.BEGUZ.value);
	}
    if(document.form1.ENDUZ.value!=""){
		document.form1.ENDUZ.value   = addPointAtTime(document.form1.ENDUZ.value);
	}
	
// 	var resTxt = originalRequest.responseText; 
	var resTxt = originalRequest; 
	if(resTxt != ''){
     	if(resTxt == "N"){
     		alert("Input at 30 minute unit.");
     		document.form1.BEGUZ.value		= "";
            document.form1.ENDUZ.value  	= "";
            document.form1.E_ABRTG.value  = "";
            document.form1.I_STDAZ.value  = "";
            document.form1.BEGUZ.focus();
     	}
	}
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
	    
		     //if (document.form1.AWART.value == "0110X") {
				small_window = window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname, "","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=150,top=300,left=300");
				small_window.focus();
			//}
	
	} else {
	   alert("Application time can be inputted when absence type is applies for the leave (quite a while).");
	}
}

//-->
</script>


    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO" representative="true">
        <!-- 상단 입력 테이블 시작-->

        <tags:script>


</tags:script>





    <div class="tableArea">
        <div class="table">
        
		  <table class='tableGeneral tableApproval' border="0" cellspacing="0" cellpadding="0">
           	<colgroup>
            	<col width=15%/>
            	<col width=35%/>
            	<col width=15%/>
            	<col width=35%/>
          	</colgroup>
                     <input type="hidden" name="BEGDA"  size="10" 	value="${ f:currentDate()  }" readonly> 
             
			
<%-- 			  <input type="hidden" name ="PERNR" id="PERNR" value="${data.PERNR}"> --%>
			  <input type="hidden" name="sDate"  value="">
			  <input type="hidden" name="checkmess" value="${ checkmess }">
			  <input type="hidden" name="ATEXT" value="">
			  <input type="hidden" name="timeopen">
			  <input type="hidden" name="AWART1">
			  <input type="hidden" name="TMP_UPMU_CODE" value="">
  			  <input type="hidden" name="mode" value="">
 

                    <tr> 
                      <th ><span  class="textPink">*</span>
                      	<spring:message code='LABEL.D.D19.0016'/><!--  Absence Type&nbsp;-->
                      </th>
                      
                      <td colspan=3 >	                        
                         <select name="AWART" class="input03" onchange="javascript:js_change()">
                         <c:if test='${isUpdate==false }'>
                         	<option value="">Select</option>
                      	</c:if>
                             ${ f:printOption2(holidayVT, data.AWART)}
                          </select>
                             <!-- 각 휴가 유형에 따른 업무코드를 hidden값으로 가져온다.	2008-02-20. -->
							 ${ f:printOption3(holidayVT,subty1) }
							 
                         <a  id="sp1" class="inlineBtn"  style="visibility:hidden" href="#">
                       			<span style="visibility:hidden" onclick="f_pop();">
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
                     
                          	<input type="text"  id="ANZHL_BAL" name="ANZHL_BAL" 
                          		value="${ f:printNumFormat(data.ANZHL_BAL,2) }"  size="3"
                          	 	maxlength="7" style="ime-mode:active;text-align:right;" readonly>
                          		<spring:message code="LABEL.D.D03.0031"/>  
                         
                      </td>
                
                 <th class="th02">
                 		<spring:message code='LABEL.D.D03.0200'/><!-- Use rate(%) -->
               	</th>
               	<td >
               		 <input class="noBorder" type="text" name="REMAINDAYS" size="4" value="${f:printNumFormat(remainDays,2)}" />(
               		 <input class="noBorder" type="text" name="ANZHL_USE" size="4" value="${dataRemain.ANZHL_USE}" />/
               		 <input class="noBorder" type="text" name="ANZHL_GEN" size="4" value="${dataRemain.ANZHL_GEN}" />)
                 </td>
                    </tr>  
                    
                    
                    <tr> 
                      <th ><span  class="textPink">*</span>
                      	<spring:message code='LABEL.D.D12.0003'/><!--Application Period&nbsp;-->
                     	</th>
                      <td colspan=3 >
                          		<input type="text" name="APPL_FROM" 
                          		onChange="f_dateFormat(this);"
                          		value="${  f:printDate(data.APPL_FROM) }" 
                          		size="10" class="date"
                          		onkeypress="EnterCheck2(this)"  >      <!--  onBlur=""  -->                        		                           
                          		 ~&nbsp;
                           <input type="text" name="APPL_TO"
                           		onChange="f_dateFormat(this);"   
                           		value="${  f:printDate(data.APPL_TO)   }" 
                           		size="10" class="date" 
                           		onkeypress="EnterCheck2(this)"  > <!-- onBlur=""  -->
                    		
                           	<input type="text" name="E_ABRTG"  ID="E_ABRTG"  value=""  size="3"  style="text-align:right;" readonly>
                           	<spring:message code="LABEL.D.D03.0031"/>  
<%--                             	
                              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <span id="sp2"><spring:message code='LABEL.D.D03.0026'/> <!--Maximum Available&nbsp;-->
                              <input type="text" name="P_STDAZ2" value=""  size="2" maxlength="7"
                               style="ime-mode:active;text-align:right;" readonly>day
                              </span>
 --%>                                
                           </td>
                                 <input type="hidden" name="AINF_SEQN2" value=""  size="3"  readonly>
                        </tr>

                    <tr> 
                      <th ><spring:message code="LABEL.D.D03.0023"/><!-- Application Time --></th>
                      <td colspan=3 >
                              <input type="text" id="BEGUZ" name="BEGUZ" value="${ f:printTime(data.BEGUZ) }" size="7" 
	                     		 onChange="timeFormat(this); check_Time()"		
                              	 readonly  onkeypress="EnterCheck3(this)"><!-- onFocus="timeStartFocus();"  onBlur="timeFormat(this);"  -->
                              <a href="javascript:fn_openTime('BEGUZ');"  ><img src="${g.image }icon_time.gif" align="absmiddle" border="0"></a>
                              &nbsp;~&nbsp;
                              <input type="text" id="ENDUZ" name="ENDUZ"  value="${ f:printTime(data.ENDUZ) }" size="7" 
	                    		onChange="timeFormat(this); check_Time()"
                               readonly onkeypress="EnterCheck3(this)" > <!--onFocus="timeEndFocus();"   onBlur="timeFormat(this);"  -->
                             <a href="javascript:fn_openTime('ENDUZ');"  ><img src="${g.image }icon_time.gif" align="absmiddle" border="0"></a>
                                    
                             <input type="text" id="I_STDAZ"  name="I_STDAZ" value="${data.i_STDAZ }"  size="3" readonly
                               style="text-align:right;"> <spring:message code="LABEL.D.D01.0008"/> 
                        
                     </td>
                   
              </tr>        
	</table>
              <!-- 상단 입력 테이블 끝-->
    
         
       		<div class="commentsMoreThan2">
		         <spring:message code="MSG.COMMON.0061"/><!-- &nbsp;&nbsp;*: Required Field -->	
	 
			</div>
         
		</div></div>
		<!-- HIDDEN  처리해야할 부분 시작 (default = 전일휴가), frdate, todate는 선택된 기간에 개인의 근무일정을 가져오기 위해서.. -->
		   
		      <input type="hidden" name="DEDUCT_DATE" value="${ data.DEDUCT_DATE }">
		<!-- HIDDEN  처리해야할 부분 끝   -->

   </tags-approval:request-layout>
	<form name="form3" method="post">
	      　
	      <input type="hidden" name = "PERNR" value="${data.PERNR}">
	</form>
</tags:layout>


<iframe name="ifHidden" width="0" height="0" />
