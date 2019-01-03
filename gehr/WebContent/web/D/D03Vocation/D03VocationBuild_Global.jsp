<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Application                                                  																	*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Leave                                               																			*/
/*   Program ID   		: D03VocationBuild.jsp                                              															*/
/*   Description  		: 휴가(Leave)신청을 하는 화면                           																			*/
/*   Note         		:                                                             																		*/
/*   Creation     		: 2002-01-03 김도신                                          																		*/
/*   Update       		: 2005-02-16 윤정현                                          																		*/
/*   Update       		: 2007-09-19 li hui                                          																	*/
/*   			       		: 2008-01-11 jungin @v1.0                                        														*/
/*   			       		: 2008-02-20 jungin @v1.1 휴가유형에 따른 selectbox 업무코드를 가져온다.                        				*/
/*							: 2009-11-16 jungin @v1.2 [C20091113_59521] 잔여휴가일수에 따른 휴가유형 신청 방지.					*/
/*							: 2009-11-17 jungin @v1.3 [C20091116_60330] 연차휴가 신청 방지 주석처리.									*/
/*							: 2011-01-19 liu kuo @v1.4  [C20110118_09919]Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청	*/
/*							: 2011-07-19 liu kuo @v1.5  [C20110719_28774]사가 신청 시간 제간 취소 요청의 건	*/
/*							: 2013-08-01 dongxiaomian @v1.6  [C20130724_75535]LG DAGU法人修改“病假（半天）”设置为上下半天固定时间段	*/
/*							: 2013-11-12 lixinxin @v1.7  [C20131107_33148]LG BOTIAN法人修改“病假（半天）”设置为上下半天固定时间段	*/
/*							: 2013-11-29 lixinxin @v1.8  [C20131129_45281]G280,G150法人修改“病假（半天）”设置为上下半天固定时间段	*/
/*							：2013-12-05 dongxiaomian@1.9[C20131203_47576] 申请休假的时候，光标移到time里保存，导致时间错乱*/
/*							：2014-02-24 dongxiaomian@2.0[C20140224_92331] 设置大沽法人有年休假时不能申请事假*/
/*							：2014-08-08 pangxiaolin@2.1[C20140731_85157 20140808] 台湾法人病假超过30天系统设置 */
/*							: 2014-08-13 pangxiaolin@2.2[C20140814_92625] E-HR设置申请【重要】*/
/*							: 2015-01-06 pangxiaolin@2.3[C20150106_74247] 有关年假/事假休假事宜*/
/*							: 2015-07-17 li ying zhe @v2.4  [SI -> SM]Global e-HR Add JV(G450)                                    */
/*							: 2016-02-24 pangxiaolin@v2.5[C20160222_91744] G170法人增加不同类型护理假时间选择限制              */
/*							: 2016-03-17 pangxiaolin@v2.6[C20160315_11000] G220法人Pregnancy-Check Leave时间选择修改              */
/*                 		: 2016-09-20 통합구축 - 김승철                     */
/*                         : 2017-03-20  eunha [CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가   */
/*                         : 2017-11-01  eunha [CSR ID:3522425] 事假+事假休职全年累计超过30个工作日后HR增加提示框限制申请事假 */
/*                         : 2017-12-06 이지은   [CSR ID:3544114] [LGCTW]Request of Global HR Portal system Compensatory Leave(補休假) function increasing   */
/*                         : 2018-03-19 강동민    @PJ.광저우 법인(G570) Roll-Out ( G180 남경 Copy )                                */
/* 						: 2018-03-22 	cykim  [CSR ID:3568065] 근태관리 로직 변경의 건  */
/*                         : 2018-04-21 이지은  [CSR ID:3667428] LGCNJ 휴가 신청 화면 기능 오류 수정   */
/*                         : 2018-06-07 변지현 LGCLC 생명과학 북경법인(G610)  Rollout  프로젝트 적용    */
/*                         : 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out    */
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
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>

<%
    WebUserData user  = (WebUserData)session.getAttribute("user");
	String      message = (String)request.getAttribute("message");

    /* 휴가신청 */
    Vector	d03VocationData_vt = null;
    D03VocationData data          = null;
    d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    data               		= (D03VocationData)d03VocationData_vt.get(0);

    if( message == null ){
    	message = "";
    }

    String  subty1         = (String)request.getAttribute("subty1");
    if(subty1 == null)
    {
  		subty1 = "";
    }
    Vector holidayVT = new D17HolidayTypeRFC().getHolidayType(data.PERNR);
    D03RemainVocationData dataRemain = (D03RemainVocationData)request.getAttribute("d03RemainVocationData");
	String remainDays = dataRemain.ANZHL_GEN.equals("0")? "0" : Float.toString(NumberUtils.toFloat(dataRemain.ANZHL_USE)  / NumberUtils.toFloat(dataRemain.ANZHL_GEN) * 100);
	Logger.debug.println("---------- data:"+data)	;

	Boolean isUpdate = (Boolean)request.getAttribute("isUpdate");
	if (isUpdate==null) isUpdate=false;

    String P_STDAZ2 		= "";
    String P_CELTY 		= ""; // 가족목록구분
    String P_CELDT 		= ""; // 가족목록구분
	if(isUpdate){
	    Vector  HolidayAbsenceData_vt = new Vector();
	    HolidayAbsenceData_vt = (new D03HolidayAbsenceRFC()).getHolidayAbsence(user.empNo, data.AWART);

	    for(int i=0; i<HolidayAbsenceData_vt.size(); i++){
	     D03HolidayAbsenceData data2 = (D03HolidayAbsenceData)HolidayAbsenceData_vt.get(i);
	    	if(data.AINF_SEQN2.equals(data2.AINF_SEQN)){
	    	   P_CELTY = data2.CELTY;
	    	   P_CELDT = data2.CELDT;
	    	   P_STDAZ2 = data2.ABSN_DATE;
	    	}
	    }
		Logger.debug.println("---------- P_STDAZ2:"+P_STDAZ2)	;
		Logger.debug.println("---------- P_CELDT:"+P_CELDT)	;
		Logger.debug.println("---------- P_CELTY:"+P_CELTY)	;
	}

    String rdcamel = "LABEL.D.D03.0036";

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
<c:set var="dataRemain" value="<%=dataRemain%>"/>
<c:set var="remainDays" value="<%=remainDays%>"/>
<c:set var="isUpdate" value="<%=isUpdate%>"/>
<c:set var="subty1" value="<%=subty1%>"/>
<c:set var="P_STDAZ2" value="<%=P_STDAZ2%>"/>
<c:set var="P_CELDT" value="<%=P_CELDT%>"/>
<c:set var="P_CELTY" value="<%=P_CELTY%>"/>


<tags:layout css="ui_library_approval.css"  script="dialog.js" >

<jsp:include page="${g.jsp }D/D01OT/D0103common.jsp"/>
<script language="JavaScript">

$(function(){


	check_upmuCode();
	<c:choose>
	<c:when test ='${isUpdate!=true}'>
		$('#-approvalLine-table').html(""); // 초기 결재라인 재거 *KSC
		document.form1.AWART.selectedIndex=0;
	</c:when>
	<c:otherwise>
		ajax_change("${P_CELTY}", "0000-00-00", "${data.FAMY_CODE}")
		js_change();
		document.form1.APPL_FROM.value = "${f:printDate(data.APPL_FROM)}";
		document.form1.APPL_TO.value = "${f:printDate(data.APPL_TO)}";
		document.form1.BEGUZ.value = ("${data.BEGUZ}" =='00:00:00') ? '': '${f:printTime(data.BEGUZ)}';
		document.form1.ENDUZ.value = ("${data.ENDUZ}"=='00:00:00') ? '' : '${f:printTime(data.ENDUZ)}';
		document.form1.I_STDAZ.value = "${data.STDAZ}";
		document.form1.FAMY_CODE.value = "${data.FAMY_CODE}";
		document.form1.FAMY_TEXT.value = "${data.FAMY_TEXT}";
		document.form1.P_STDAZ2.value = "${P_STDAZ2}";
		document.form1.E_ABRTG.value = "${ f:printNumFormat(data.ABRTG,2)}";
	</c:otherwise>
	</c:choose>
})

function beforeSubmit() {

	if( check_data() ) {
		if (document.form1.ENAME != undefined){
			$("#APPL_REAS").val(document.form1.ENAME.value);
		}

	      if((document.form1.AWART.value == '0110') || (document.form1.AWART.value == '0111X')){
	           if(Number(document.form1.E_ABRTG.value)>Number(document.form1.ANZHL_BAL.value)){
				         alert("<spring:message code='MSG.D.D03.0035'/>");//Request days should be less than quota days.
				         return false;
			       }
	       } else{
	       	 if((document.form1.AWART.value =='0120') || (document.form1.AWART.value =='0121')){
	       	      if(document.form1.P_STDAZ2.value == ""){
	       	      		 //경조휴가 신청과 경조금 신청을 분리.	2008-01-11.
	       	      	     //alert("Searching Celebration/Condolence is required. Select Celebration/Condolence item.");
			  		      //   return false;
	       	      }
			       	  if(Number(document.form1.E_ABRTG.value) > Number(document.form1.P_STDAZ2.value)){
					         alert("<spring:message code='MSG.D.D03.0035'/>");//Request days should be less than quota days.
			  		         return false;
				      }
				}
			    /*
			    if((document.form1.AWART.value == '0142') && (Number(document.form1.E_ABRTG.value) == '0')){
			    	alert("");
			    	return;
			    }
			    */
	       }
			//dongxiaomian add begin
			//2014-08-08 pangxiaolin@2.1[C20140731_85157 20140808] 台湾法人病假超过30天系统设置
			var E_BUKRS		= '${ E_BUKRS }';
			 if(E_BUKRS == "G220" && document.form1.AWART.value == '0210'){
	          var appl_from=document.form1.APPL_FROM.value.substring(0,4);
	          var appl_to=document.form1.APPL_TO.value.substring(0,4);
	          //alert(appl_from+","+appl_to);
	          if(appl_from!=appl_to){
	          	alert("<spring:message code='MSG.D.D03.0041'/>");//Your application date should be in the calendar year(1.1-12.31)
	          	return false;
	          }
	       }

	       //2016-03-17 pangxiaolin@v2.6[C20160315_11000] G220法人Pregnancy-Check Leave时间选择修改 start
	       if(E_BUKRS == "G220" && document.form1.AWART.value == '0131X'){
	       	var ENDUZ = document.form1.ENDUZ.value.substring(3,5);
	       	var BEGUZ = document.form1.BEGUZ.value.substring(3,5);
	       	if(ENDUZ!=BEGUZ){
	       		alert("<spring:message code='MSG.D.D03.0042'/>");//Minimum unit is 1 hour
	       		return false;
	       	}
	       }
	       //2016-03-17 pangxiaolin@v2.6[C20160315_11000] G220法人Pregnancy-Check Leave时间选择修改 end

			//dongxiaomian add end
			//2014-08-08 pangxiaolin@2.1[C20140731_85157 20140808] 台湾法人病假超过30天系统设置
			//2016-02-24 pangxiaolin@2.5[C20160222_91744] LGYX 护理假7天、8天15天申请时间限制 start
			if(E_BUKRS == "G170"&&(document.form1.AWART.value == "0142"||document.form1.AWART.value == "0146"||document.form1.AWART.value == "0147")){
				var appl_from = removePoint(document.form1.APPL_FROM.value)	;
	          	var appl_to = removePoint(document.form1.APPL_TO.value);
	          	var day = appl_to-appl_from+1;
	          	if(document.form1.AWART.value == "0142"&& day<7){
	          		alert("<spring:message code='MSG.D.D03.0043'/>");//Minimum of 7 calendar days allowed for attendance/absence type 0142
	          		return false;
	          	}
	          	if(document.form1.AWART.value == "0146"&& day<8){
	          		alert("<spring:message code='MSG.D.D03.0044'/>");//Minimum of 8 calendar days allowed for attendance/absence type 0146
	          		return false;
	          	}
	          	if(document.form1.AWART.value == "0147"&& day<15){
	          		alert("<spring:message code='MSG.D.D03.0045'/>");//Minimum of 15 calendar days allowed for attendance/absence type 0147
	          		return false;
	          	}
			}
			//2016-02-24 pangxiaolin@2.5[C20160222_91744] LGYX 护理假7天、8天15天申请时间限制 end
		    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
	        //2013-12-05 dongxiaomian@1.9[C20131203_47576] 申请休假的时候，光标移到time里保存，导致时间错乱 begin
	       //buttonDisabled();
	        if(confirm("<spring:message code='MSG.D.D03.0052'/>")) {//Please check again to assure the application date is right?
					//buttonDisabled();
			 }else{
			 		return false;
			 }
	        //2013-12-05 dongxiaomian@1.9[C20131203_47576] 申请休假的时候，光标移到time里保存，导致时间错乱  end
	       document.form1.APPL_FROM.value	= removePoint(document.form1.APPL_FROM.value);
	       document.form1.APPL_TO.value		= removePoint(document.form1.APPL_TO.value);

	       if(document.form1.BEGUZ.value!=""){
	        	document.form1.BEGUZ.value = removeColonKsc(document.form1.BEGUZ.value) + "00";
	       }

	       if(document.form1.ENDUZ.value!=""){
	        	document.form1.ENDUZ.value = removeColonKsc(document.form1.ENDUZ.value) + "00";
	       }

	       if( document.form1.timeopen.value == 'T' ) {
	       	document.form1.AWART1.value = document.form1.AWART.value.substring(0,document.form1.AWART.value.length-1);
	       }else{
	       	document.form1.AWART1.value = document.form1.AWART.value;
	       }

	//        document.form1.jobid.value	= "create";
	//        document.form1.action			= "${ g.servlet }hris.D.D03Vocation.D03VocationBuildSV?AINF_SEQN2="+document.form1.AINF_SEQN2.value;
	//        document.form1.method 		= "post";
	//        document.form1.submit();

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
// 	check_Time();
}

function f_timeFormat(obj){
	if(flag == 1){
		flag = 0;
		return;
	}
	timeFormat(obj);
// 	check_Time();
}

//data check
function check_data(){
   // 휴가구분
   // awart_temp  = document.form1.AWART.value;

   if(checkNull(document.form1.APPL_REAS, "<spring:message code='MSG.D.D12.0008'/>") == false){//Application Period
       return false;
   }
   if(checkNull(document.form1.APPL_FROM, "<spring:message code='MSG.D.D03.0019'/>") == false){//Application Period
       return false;
   }
   if(checkNull(document.form1.APPL_TO, "<spring:message code='MSG.D.D03.0019'/>") == false){ //Application Period
       return false;
   }
   if(document.form1.timeopen.value == 'T'){
      if(checkNull(document.form1.BEGUZ, "<spring:message code='MSG.D.D03.0036'/>") == false){//Application Time
         return false;
      }
	   if(checkNull(document.form1.ENDUZ, "<spring:message code='MSG.D.D03.0036'/>") == false){//Application Time
	       return false;
	   }
	   return true;
   }


 // 신청관련 단위 모듈에서 필히 넣어야할 항목
//  if ( check_empNo() ){
//    return false;
//  }

return true;
}





function reload() {
   frm =  document.form1;
   frm.jobid.value = "first";
   frm.action = "${ g.servlet }hris.D.D03Vocation.D03VocationBuildGlobalSV";
   frm.target = "";
   frm.submit();
}

function  check_Time(){

	if(document.form1.AWART.value == ""){
		alert("<spring:message code='MSG.D.D03.0048'/>");//Please select Absence Type.
		document.form1.APPL_FROM.value= "";
		return;
	}
   if(document.form1.timeopen.value == 'F'){

	    //[CSR ID:3568065] 근태관리 로직 변경의 건 start 중국 휴가 신청시 종료일자 check로 해당 로직 주석처리함.
		/* if(document.form1.APPL_TO.value == ""){
			document.form1.APPL_TO.value = document.form1.APPL_FROM.value;
		} */
		//[CSR ID:3568065] 근태관리 로직 변경의 건 end

		//-----------신청기간의 일수를 가져옴 -----------
		if((document.form1.APPL_TO.value != "") && (document.form1.APPL_FROM.value != "")){
		      document.form1.APPL_FROM.value		= removePoint(document.form1.APPL_FROM.value);
		      document.form1.APPL_TO.value     	= removePoint(document.form1.APPL_TO.value);
		      document.form1.BEGUZ.value       	= "0000";
		      document.form1.ENDUZ.value       	= "0000";

		      var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildGlobalSV';
			  var pars = 'PERNR=${data.PERNR}&APPL_FROM=' + document.form1.APPL_FROM.value + "&APPL_TO=" +
				  document.form1.APPL_TO.value + "&AWART=" + document.form1.AWART.value + "&jobid=check&BEGUZ=" +
				  document.form1.BEGUZ.value + "&ENDUZ=" + document.form1.ENDUZ.value + "&TMP_UPMU_CODE=" +
				  document.form1.TMP_UPMU_CODE.value;
//			  var myAjax = Ajax.request(url,{method: 'get',parameters: pars,onComplete: showResponse});
//			$.ajax({type:'GET', url: url, data: pars, dataType: 'text', success: showResponse()});
			 	blockFrame();
			  $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
		}

   }else{

      if(document.form1.APPL_TO.value == ""){
         document.form1.APPL_TO.value = document.form1.APPL_FROM.value;
       }

      //-----------신청기간의 일수를 가져옴 (반차)-----------
      if((document.form1.APPL_TO.value != "") && (document.form1.APPL_FROM.value != "") &&
   		   (document.form1.BEGUZ.value != "") &&
   		   (document.form1.ENDUZ.value != "")){
	        document.form1.APPL_FROM.value	= removePoint(document.form1.APPL_FROM.value);
           document.form1.APPL_TO.value    	= removePoint(document.form1.APPL_TO.value);
           document.form1.BEGUZ.value      	= removeColonKsc(document.form1.BEGUZ.value);
           document.form1.ENDUZ.value      	= removeColonKsc(document.form1.ENDUZ.value);


	        var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildGlobalSV';
			var pars = 'PERNR=${data.PERNR}&APPL_FROM=' + document.form1.APPL_FROM.value + "&APPL_TO=" +
			document.form1.APPL_TO.value + "&AWART=" + document.form1.AWART.value + "&jobid=check&BEGUZ=" +
			document.form1.BEGUZ.value + "&ENDUZ=" + document.form1.ENDUZ.value + "&TMP_UPMU_CODE=" +
			document.form1.TMP_UPMU_CODE.value;
//			var myAjax =$.ajax(url,{method: 'get',parameters: pars,onComplete: showResponse});
			blockFrame();
			  $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
	    }
   }

   //--------------------------------------------------------------------------------------//
   date_from  = removePoint(document.form1.APPL_FROM.value);
   date_to    = removePoint(document.form1.APPL_TO.value);
/*
   if( date_from > date_to ) {
     	alert("<spring:message code='MSG.D.D03.0024'/>");//신청시작일이 신청종료일보다 큽니다.
     	document.form1.APPL_TO.value="";
     	return false;
   }
    */
}

//----------------- 휴가유형이 선택될때  발생하는 function ---------------------
function js_change() {

	var awart = document.form1.AWART.value ;
	var E_BUKRS		= '${ E_BUKRS }';
	var ANZHL_BAL	= '${ f:printNumFormat(ANZHL_BAL,2) }';

   $('#ENAME_DIV').html('');

 	<c:if test='${!isUpdate }'>
		 $("#APPL_REAS").val("");
	 </c:if>

	// 잔여휴가일수가 남았을 경우.	@v1.2
	if(ANZHL_BAL != null && ANZHL_BAL != "0"){
	//2014-02-24 dongxiaomian@2.0[C20140224_92331] 设置大沽法人有年休假时不能申请事假 begin
		//if(E_BUKRS == "G100"){
		//if(E_BUKRS == "G100"||E_BUKRS == "G110"){
		//20140813 C20140814_92625 pangxiaolin@2.2[C20140814_92625] E-HR设置申请【重要】 begin
		//2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out start
		//2018-06-07 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout
		//2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
		if(E_BUKRS == "G100"||E_BUKRS == "G110"||E_BUKRS =="G170"||E_BUKRS =="G180"||E_BUKRS =="G240"||E_BUKRS =="G360"||E_BUKRS =="G570"||E_BUKRS =="G610"||E_BUKRS =="G620"){
		//2018-06-07 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout  end
		//2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
		//20140813 C20140814_92625 pangxiaolin@2.2[C20140814_92625] E-HR设置申请【重要】 end
	//2014-02-24 dongxiaomian@2.0[C20140224_92331] 设置大沽法人有年休假时不能申请事假 end
			if(document.form1.AWART.value == "0220" || document.form1.AWART.value == "0221X"){
				//2015-01-06 pangxiaolin@2.3[C20150106_74247] 有关年假/事假休假事宜 begin
				//alert("You can not apply if your quota balance is not zero.");
				//document.form1.AWART.value = "";
				//return;
				//2015-01-06 pangxiaolin@2.3[C20150106_74247] 有关年假/事假休假事宜 end
			}
		}
		if(E_BUKRS == "G150"){
			if(document.form1.AWART.value == "0210" || document.form1.AWART.value == "0211X" ||
					document.form1.AWART.value == "0220" ||
					document.form1.AWART.value == "0221X"){
				//2015-01-06 pangxiaolin@2.3[C20150106_74247] 有关年假/事假休假事宜 begin
				//alert("You can not apply if your quota balance is not zero.");
				//document.form1.AWART.value = "";
				//return;
				//2015-01-06 pangxiaolin@2.3[C20150106_74247] 有关年假/事假休假事宜 end
			}
		}

	}


	//[CSR ID:3544114] 휴가 구분이 Compensatory Leave 이면, 신청기간 우측이 "시간" 으로 보여짐
	if(E_BUKRS == "G170" || E_BUKRS == "G220" && (document.form1.AWART.value == "0160" )){
		document.all['G220CompText'].innerHTML = "<spring:message code='LABEL.D.D01.0008'/>";
	}else{
		document.all['G220CompText'].innerHTML = "<spring:message code='LABEL.D.D03.0036'/> ";     // <!-- hours:days -->
	}

		//
	  // :0120
	  // :0121
  	if((awart== '0120' || awart== '0121')){	//남경특화
		   document.form1.P_STDAZ2.value		= "";
		   document.form1.FAMY_TEXT.value	= "";
		   form1.ATEXT.value = form1.AWART.options[form1.AWART.selectedIndex].text;
		   sp1.style.visibility = '';
		   sp2.style.visibility = '';
		   sp3.style.visibility = '';
		   // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Staret
		   // 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
		   if("${ E_BUKRS }"=="G180" || "${ E_BUKRS }"=="G570" || "${ E_BUKRS }"=="G620"){
		   //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
			    $('#APPL_REAS').attr('readonly', (awart == '0121' ?  true : false ) );
	 		    $('#APPL_REAS').css('display', (awart == '0121' ? 'none' : 'inline-block') );
	 			ENAME_DIV.style.display = (awart == '0121' ? 'inline-block' : 'none');
		   }
	}else	{
		sp1.style.visibility = 'hidden';
		sp2.style.visibility = 'hidden';
		sp3.style.visibility = 'hidden';
		// 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
		// 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
	   if("${ E_BUKRS }"=="G180" || "${ E_BUKRS }"=="G570" || "${ E_BUKRS }"=="G620"){
       // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out end
		    ENAME_DIV.style.display = 'none';
		    $('#APPL_REAS').attr('readonly', false);
			$('#APPL_REAS').css('display', 'inline-block' );
	   }
	}
	document.form1.timeopen.value= document.form1.AWART.value.substring(document.form1.AWART.value.length-1,document.form1.AWART.value.length)==('X')  ? 'T' : 'F'  ;

	document.form1.APPL_FROM.value	= "";
	document.form1.APPL_TO.value		= "";
	document.form1.BEGUZ.value			= "";
	document.form1.ENDUZ.value			= "";
	document.form1.E_ABRTG.value		= "";
	document.form1.I_STDAZ.value		= "";

	/* @v1.3
	if(document.form1.AWART.value=='0110'||document.form1.AWART.value=='0111X'){
		if((document.form1.checkmess.value != null)&&(document.form1.checkmess.value!='')){
			alert(document.form1.checkmess.value);
			document.form1.AWART.value='';
			document.form1.AWART.focus();
		}
	}
	*/

	check_upmuCode();
	getApp();		// 결제자변경.

}

//*************************************************************************
//휴가유형 selectbox에 따른 각 업무코드.		2008-02-20.
function check_upmuCode(){
// 	var UPMU_CODE_LIST = document.getElementsByName("upmu_code"); //UPMU_CODE
// 	//alert(UPMU_CODE[document.form1.AWART.selectedIndex].value);
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

function showResponse(originalRequest)	{

	 $.unblockUI();
	 var E_BUKRS = '${ E_BUKRS }';
	//put returned XML in the textarea
//	if (originalRequest.responseText!='')
//		arr = originalRequest.responseText.split(',');
	if (originalRequest != "")
		arr = originalRequest.split(',');

	var E_MESSAGE ;
	E_MESSAGE =  (arr[1]);

	// 근태기간완료된것을 신청하는  check (li hui)
   var flag = (arr[4]).substring(0,1); // println 으로 /r/n  붙어서 들어옴.2016/12/20ksc
	if(arr[0]=="E"){
		flag = "E" ;
// 		   alert(E_MESSAGE); //You can't apply this data in payroll period
// 		   return;
	}

	if( E_MESSAGE.charAt(0)=="E" || E_MESSAGE.charAt(0)=="W"){	//2008-01-30
		E_MESSAGE = E_MESSAGE.substring(9, E_MESSAGE.length);
	}

	//[CSR ID:3522425] 事假+事假休职全年累计超过30个工作日后HR增加提示框限制申请事假 START
	if(flag == "F"){
		alert("<spring:message code='MSG.D.D03.0073'/>"); //This year, you have more than 30 working days for your personal leave.You can't apply again
  	    document.form1.APPL_FROM.value	= "";
        document.form1.APPL_TO.value     	= "";
        document.form1.BEGUZ.value       	= "";
        document.form1.ENDUZ.value       	= "";
        document.form1.E_ABRTG.value     	= "";
        document.form1.P_STDAZ2.value    	= "";
        document.form1.I_STDAZ.value     	= "";
		document.form1.APPL_FROM.focus();
		return;
	}else if (flag == "G"){
		//[CSR ID:3544114] G220 의 경우 대체휴가 잔여한도 부족.
		alert("<spring:message code='MSG.D.D03.0074'/>"); //대체휴가 한도 부족
  	    document.form1.APPL_FROM.value	= "";
        document.form1.APPL_TO.value     	= "";
        document.form1.BEGUZ.value       	= "";
        document.form1.ENDUZ.value       	= "";
        document.form1.E_ABRTG.value     	= "";
        document.form1.P_STDAZ2.value    	= "";
        document.form1.I_STDAZ.value     	= "";
		document.form1.APPL_FROM.focus();
		return;
	}else if(flag == "N"){
		//[CSR ID:3522425] 事假+事假休职全年累计超过30个工作日后HR增加提示框限制申请事假 END
	   alert("<spring:message code='MSG.D.D03.0047'/>"); //You can't apply this data in payroll period
	   document.form1.APPL_FROM.value	= "";
       document.form1.APPL_TO.value     	= "";
       document.form1.BEGUZ.value       	= "";
       document.form1.ENDUZ.value       	= "";
       document.form1.E_ABRTG.value     	= "";
       document.form1.P_STDAZ2.value    	= "";
       document.form1.I_STDAZ.value     	= "";
	   document.form1.APPL_FROM.focus();
	   return;
	}

	//dongxiaomian add TPxiugai begin
	//2014-08-08 pangxiaolin@2.1[C20140731_85157 20140808] 台湾法人病假超过30天系统设置
	if(arr.length>=6){
/*		var flag1 = (arr[5]);

		if(flag1.charAt(0) == "N"){
			alert("<spring:message code='MSG.D.D03.0050'/>");//Your sick leave applied over 30 days ,please choose unpaid sick leave.
			document.form1.APPL_FROM.value	= "";
			document.form1.APPL_TO.value     	= "";
			document.form1.BEGUZ.value       	= "";
			document.form1.ENDUZ.value       	= "";
			document.form1.E_ABRTG.value     	= "";
			document.form1.P_STDAZ2.value    	= "";
			document.form1.I_STDAZ.value     	= "";
			document.form1.APPL_FROM.focus();
			return;
		}
*/

//[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  START
		var dateCheckFlag = (arr[5]);
		if(dateCheckFlag.charAt(0) == "E"){
			//[CSR ID:3568065] 근태관리 로직 변경의 건 @조현애K 문구수정요청.
			//alert("<spring:message code='MSG.D.D01.0106'/>"); //It could be only allowed from yesterday.
			alert("<spring:message code='MSG.D.D01.0110'/>");
			document.form1.APPL_FROM.value	= "";
			document.form1.APPL_TO.value     	= "";
			document.form1.BEGUZ.value       	= "";
			document.form1.ENDUZ.value       	= "";
			document.form1.E_ABRTG.value     	= "";
			document.form1.P_STDAZ2.value    	= "";
			document.form1.I_STDAZ.value     	= "";
			document.form1.APPL_FROM.focus();
			return;
		}
		//[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  END

	}
	//dongxiaomian add TPxiugai end
	//2014-08-08 pangxiaolin@2.1[C20140731_85157 20140808] 台湾法人病假超过30天系统设置

	if(document.form1.APPL_FROM.value!=""){
		document.form1.APPL_FROM.value = addPointAtDate(document.form1.APPL_FROM.value);
	}
   if(document.form1.APPL_TO.value!=""){
		document.form1.APPL_TO.value = addPointAtDate(document.form1.APPL_TO.value);
	}

   text	= document.form1.BEGUZ.value ;
   text1	= document.form1.ENDUZ.value ;

   if((text == "0000") && (text1 == "0000")){
	   	document.form1.BEGUZ.value = "";
	   	document.form1.ENDUZ.value = "";
   }else{
	   if(text1.length==4){
		   	document.form1.ENDUZ.value	= text1.substring(0,2) + ":" + text1.substring(2,4);
	     	document.form1.BEGUZ.value	= text.substring(0,2) + ":" + text.substring(2,4);
	   }
   }

   var E_ABRTG = (arr[0]);
	if( flag=="E" || E_MESSAGE.charAt(0)=="E" || E_MESSAGE.charAt(0)=="W"){	//2008-01-30
	 	alert(E_MESSAGE);
	    document.form1.APPL_FROM.value	= "";
       document.form1.APPL_TO.value     	= "";
       document.form1.BEGUZ.value       	= "";
       document.form1.ENDUZ.value       	= "";
       document.form1.E_ABRTG.value     	= "";
       document.form1.P_STDAZ2.value    = "";
       document.form1.I_STDAZ.value     	= "";

	}else{

//	    $('#ENDUZ').val( arr[2].substring(0,5));
		if((document.form1.AWART.value =='0120') || (document.form1.AWART.value =='0121')){
				$('#E_ABRTG').val( pointFormat(arr[0],2));
				if(document.form1.timeopen.value == "T"){
					$('#I_STDAZ').val( arr[1]);
				}
	     }else{
		       if(E_ABRTG.charAt(0)=="."){
		       		$('#E_ABRTG').val(pointFormat(E_ABRTG,2));
					if(document.form1.timeopen.value == "T"){
						$('#I_STDAZ').val( arr[1]);
					}
		       }else{
		       		$('#E_ABRTG').val( arr[0]);
					if(document.form1.timeopen.value == "T"){
						$('#I_STDAZ').val( arr[1]);
					}
		       }
		 }

		//$('sp').innerHTML = originalRequest.responseText;

		 //20150429 pangxiaolin start
		 // if((E_BUKRS == "G180") || (E_BUKRS == "G240")){
		 //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
		 //2018-06-07 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout
		 //2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
		  if((E_BUKRS == "G180") || (E_BUKRS == "G240") || (E_BUKRS == "G100") || (E_BUKRS == "G450")|| (E_BUKRS == "G570")|| (E_BUKRS == "G610")|| (E_BUKRS == "G620")){//Global e-HR Add JV(G450)  	2015-07-17		li ying zhe	@v1.1 [SI -> SM]
		  //2018-06-07 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout  end
		  //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
		  	if( document.form1.timeopen.value == 'F' ) {
				      	getApp();		// 결재자 변경
			      }
          }

		//20150429 pangxiaolin start
         if((E_BUKRS == "G280") || (E_BUKRS == "G110") || (E_BUKRS == "G170") || (E_BUKRS == "G150") || (E_BUKRS == "G370")){  // Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청  	2011-01-19		liukuo		@v1.4 [C20110118_09919]
		          if((document.form1.AWART.value =='0211X') || ((document.form1.AWART.value =='0221X')  && (E_BUKRS != "G110")) || (document.form1.AWART.value =='0111X')){    // 사가 신청 시간 제간 취소 요청의 건  	2011-07-19		liukuo		@v1.5 [C20110719_28774]
		          		checkTime();
		          }
	       }


	 }

}


//---------------- 경조휴가를 가져올때 사용하는 pop----------------------------
function f_pop() {
	if((document.form1.AWART.value =='0120') || (document.form1.AWART.value =='0121')){
	   window.open("/web/D/D03Vocation/D03VocationPop.jsp?PERNR=${data.PERNR}&AWART="+document.form1.AWART.value,"DeptPers",
	   "toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
	}
}




//----------- 가족유형을 선택할때 발생하는 function------------

function ajax_change(CELTY, CELDT, FAMY_CODE){
	//2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
	//[CSR ID:3667428]  || 로직 && 로 수정
	//2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
    <c:if test="${ user.companyCode ne 'G180' && user.companyCode ne 'G570' && user.companyCode ne 'G620' }">
    //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
    return;
    </c:if>

	  if(FAMY_CODE == ""){
	      document.form1.FAMY_CODE.focus();
	      return;
	  }

	var PERNR = "${data.PERNR}";
	var FAMSA = "";//document.form1.FAMSA.value;
	var rmd = new Date().toString();
	var OBJPS = '${data.APPL_REAS}';

	  jQuery.ajax({
	      type:"POST",
	      url:'${g.servlet}hris.E.E19Congra.E19CongraAjax',
	      data: {Itype : CELTY, PERNR : PERNR, CELTY : CELTY , CELDT:CELDT,FAMSA:FAMSA,FAMY_CODE: FAMY_CODE, OBJPS:OBJPS},
	      success:function(data){
	      	callback(data);
	      },
	      error:function(e){
	          alert(e.responseText);
	      }
	  });

}


var tmpENAME="";
var tmpOBJPS="";

<%-- 가족선택시 신청사유에 가족명 넣어주기--%>
function callback(originalRequest)
{
		//put returned XML in the textarea
		if (originalRequest!='') {
				   var arr= new Array();
				   arr=originalRequest.split('|');
				   $('#ENAME_DIV').html(unescape(arr[0]));
				   $('#ENAME_DIV').css('display','in-line');
		 			ENAME_DIV.style.display =  'inline-block' ;
				   $("#APPL_REAS").val(document.form1.ENAME.value);
				   $('#APPL_REAS').css('display',  'none'  );
				//    $('#base').html(arr[1]);
				//    $('#paym').html(arr[2]);
				//    $('#clac').html(arr[3]);
				//    $('#limit').html(arr[4]);
				//    $('#absn').html(arr[5]);
				//    $('#syear').html(arr[6]);
				//    $('#FAMSA').html(value = arr[7]);

			// 		 APPL_REAS.style.display='none';

				   <c:if test="${isUpdate}">
						if (tmpENAME == "" && tmpOBJPS == ""){
							if(typeof(form1.OBJPS) != 'undefined'){
								tmpOBJPS = form1.OBJPS.value;
							}
							tmpENAME = form1.ENAME.value;
						}

// 						document.getElementById("OBJPS").selectedIndex = "${data.FAMY_CODE}";
					</c:if>

		   }

}

function objpsOnchange(selectedIndex){
	$("#APPL_REAS").val(document.form1.OBJPS.options[selectedIndex].text);
}

//---------------- 반차일때 근무스케쥴을 선택할수있는 pop-----------------------
function f_pop2() {
	  if((document.form1.APPL_FROM.value=="") || (document.form1.APPL_TO.value=="")){
	       alert("<spring:message code='MSG.D.D03.0040'/>");//please input Application Period.
	       return;
	  }

	  if(document.form1.timeopen.value == 'T') {
	      document.form1.sDate.value = removePoint(document.form1.APPL_FROM.value);
// 		   var newwin = window.open("/web/D/D03Vocation/D03VocationPop2.jsp?PERNR=${data.PERNR}&AWART="+
// 				   document.form1.AWART.value.substring(0,document.form1.AWART.value.length-1) +
// 				   "&APPL_FROM="+document.form1.sDate.value,"DeptPers",
// 		   			"toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=no,width=430,height=220,left=100,top=100");
// 		   newwin.focus();
		   var retVal =window.showModalDialog("/web/D/D03Vocation/D03VocationPop2.jsp?PERNR=${data.PERNR}&AWART="+
				   document.form1.AWART.value.substring(0,document.form1.AWART.value.length-1) +
				   "&APPL_FROM="+document.form1.sDate.value,	"","dialogWidth:450px;dialogHeight:300px;");
			if (retVal != undefined){
			     $("#BEGUZ").val( retVal.BEGUZ);
			     $("#ENDUZ").val( retVal.ENDUZ);
			     check_Time();
			}
	   } else {
	       alert("<spring:message code='MSG.D.D03.0049'/>");//Application time can be inputted when absence type is applies for the leave (quite a while).
	   }
}
//-->

//----------------- 결재자 변경-----------------------------------------------
function getApp(){
		blockFrame();
       var url = '${ g.servlet }hris.D.D03Vocation.D03VocationBuildGlobalSV';
       var pars = 'jobid=getApp&E_ABRTG=' + document.form1.E_ABRTG.value + '&PERNR=${PERNR}&AWART=' +
       		document.form1.AWART.value + "&rmd=&TMP_UPMU_CODE="+document.form1.TMP_UPMU_CODE.value;
//        var myAjax = $.ajax(url,{method: 'get',parameters: pars,onComplete: setApp});
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

}
 */
//-----------------반차에서 입력한 시간단위의 정확성 판단-----------------------
function checkTime(){
    $("#BEGUZ").val( removeColonKsc($("#BEGUZ").val()));
    $("#ENDUZ").val( removeColonKsc($("#ENDUZ").val()));

    var url = '${ g.servlet }hris.D.D03Vocation.D03VocationBuildGlobalSV';
    var pars = 'jobid=checkTime&BEGUZ=' + $("#BEGUZ").val() +"&ENDUZ="+$("#ENDUZ").val() /*+ "&rmd=" + new Date().toString()*/;
//     var myAjax = $.ajax(url,{method: 'get',parameters: pars,onComplete: getCheckTime});
 	$.ajax({type:'get', url: url, data: pars, dataType: 'html', success: function(data){
		getCheckTime(data);
 	}});
//  	check_Time();
}

function addColon(text){//형식 체크후 문자형태의 시간 0000을 00:00으로 바꾼다 값이 없을시는 0을 리턴

    if( text!="" ){
        if( text.length == 4 ){
            var tmpTime = text.substring(0,2)+":"+text.substring(2,4);
            return tmpTime;
        }
    } else {
        return "";
    }
}

function getCheckTime(originalRequest){


 	if($("#BEGUZ").val() !=""){
// 		document.form1.BEGUZ.value   = addPointAtTime(document.form1.BEGUZ.value);
		$("#BEGUZ").val( addColon($("#BEGUZ").val()));
	}

   if($("#ENDUZ").val()){
// 		document.form1.ENDUZ.value   = addPointAtTime(document.form1.ENDUZ.value);
		$("#ENDUZ").val( addColon($("#ENDUZ").val()));
	}

	var resTxt = originalRequest;

	if(resTxt != ''){
    	if(resTxt == "N"){
    		alert("<spring:message code='MSG.D.D03.0051'/>"); //Input at 30 minute unit.
    		$("#BEGUZ").val("");
    		$("#ENDUZ").val("");
           document.form1.E_ABRTG.value  = "";
           document.form1.I_STDAZ.value  = "";
           document.form1.BEGUZ.focus();
    	}    	if(resTxt != "Y"){
		 	alert(resTxt);
    	}
	}
}


//시간 선택
function fn_openTime(Objectname){
	 if((document.form1.APPL_FROM.value=="") || (document.form1.APPL_TO.value=="")){
	     alert("<spring:message code='MSG.D.D03.0040'/>");//please input Application Period.
	     return;
	 }

		// 반날선택하였을때  (2가지경우 시간을 선택입력할수있는pop, 그리고 근무스케쥴에 따라 나누어진 pop)
	 if( document.form1.timeopen.value == 'T' || document.form1.AWART.value == "0143"){

	      var E_BUKRS = '${ E_BUKRS }';
	      if (document.form1.AWART.value == "0143X"){
	             small_window = window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname, "","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=200,top=300,left=300");
	             small_window.focus();
	      }else if((E_BUKRS == "G280")||(E_BUKRS == "G110")||(E_BUKRS == "G150")||(E_BUKRS == "G370")){  // Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청 	2011-01-19		liukuo		@v1.4 [C20110118_09919]

			 		//2013-08-01 dongxiaomian @v1.6  [C20130724_75535]LG DAGU法人修改“病假（半天）”设置为上下半天固定时间段  begin**********************
			 		//if(document.form1.AWART.value == "0111X"){// 注释掉
			 		//2013-11-12 lixinxin @v1.7  [C20131107_33148 ]LG BOTIAN法人修改“病假（半天）”设置为上下半天固定时间段 --begin
			 		//if((document.form1.AWART.value == "0111X")||((E_BUKRS == "G110")&&(document.form1.AWART.value == "0211X"))){//注释掉
			 		//2013-11-29 lixinxin @v1.8  [C20131129_45281]G280,G150法人修改“病假（半天）”设置为上下半天固定时间段 --begin
			 		//if((document.form1.AWART.value == "0111X")||(((E_BUKRS == "G110" || E_BUKRS == "G370" ))&&(document.form1.AWART.value == "0211X"))){//增加LG DAGU法人和LG BOTIAN法人“病假（半天）”设置为上下半天固定时间段判断
			 		if((document.form1.AWART.value == "0111X")||document.form1.AWART.value == "0211X"){ //0111X-有薪年假半天  0211X-病假半天
			 		//2013-11-29 lixinxin @v1.8  [C20131129_45281]G280,G150法人修改“病假（半天）”设置为上下半天固定时间段 --end
			 		//2013-11-12 lixinxin @v1.7  [C20131107_33148 ]LG BOTIAN法人修改“病假（半天）”设置为上下半天固定时间段 --end
			 		//2013-08-01 dongxiaomian @v1.6  [C20130724_75535]LG DAGU法人修改“病假（半天）”设置为上下半天固定时间段  end**********************
			 			f_pop2();
			 		}else{
			 			 small_window = window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname, "essTime","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=200,top=300,left=400");
	                  small_window.focus();
			 		}
			 		//2016-03-17 pangxiaolin@v2.6[C20160315_11000] G220法人Pregnancy-Check Leave时间选择修改 start
			 		//[CSR ID:3544114] 0161X(Compensatory Leave(half) 추가)
	      }else if(E_BUKRS == "G170"||(E_BUKRS == "G220"&&(document.form1.AWART.value =="0131X"||(document.form1.AWART.value =="0161X")))){
	    	  //시/분 직접 선택 입력
	      		//2016-03-17 pangxiaolin@v2.6[C20160315_11000] G220法人Pregnancy-Check Leave时间选择修改 end
	      	    small_window = window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname, "essTime","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=200,top=300,left=400");
	             small_window.focus();
	      }else{
	    	//정해진 근무일정에 맞춘 시간
	         f_pop2();
	      }

	 } else {
	     alert("<spring:message code='MSG.D.D03.0049'/>");//Application time can be inputted when absence type is applies for the leave (quite a while).
	 }
}


//-->
</script>

		<jsp:include page="${g.jsp }D/timepicker-include.jsp"/>
    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO" representative="true">
        <!-- 상단 입력 테이블 시작-->

        <tags:script>

		</tags:script>

		  <input type="hidden" name="sDate"  value="">
		  <input type="hidden" name="checkmess" value="${ checkmess }">
		  <input type="hidden" name="ATEXT" value="">
		  <input type="hidden" name="timeopen">
		  <input type="hidden" name="AWART1">
		  <input type="hidden" name="TMP_UPMU_CODE" value="">



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

                      <tr>
                        <th ><span  class="textPink">*</span>
                        	<spring:message code='LABEL.D.D19.0016'/><!--  Absence Type&nbsp;-->
                        </th>
                        <td colspan=3 >

		                         <select name="AWART" class="input03" onchange="javascript:js_change()">
		                         	<c:if test='${isUpdate==false }'>
			                         	<option value="">Select</option>
		                         	</c:if>
		                             ${ f:printOption2(holidayVT, data.AWART ) }<!-- printOption2 -->
		                          </select>
		                             <!-- 각 휴가 유형에 따른 업무코드를 hidden값으로 가져온다.	2008-02-20. -->
									 ${ f:printOption3(holidayVT, subty1) }<!-- printOption3 -->


	                          <a  id="sp1" style="visibility:hidden; float:none;"  class="inlineBtn"  href="#" onclick="f_pop();">
                         			<span  >
                         					<spring:message code='LABEL.D.D03.0024'/><!--Search family type-->
                         			</span>
                         		</a>

	                            <!-- 혼가/상가 신청시 선택한  FAMY_TEXT를 출력. -->
	                            <span id="sp3" style="visibility:hidden">
	                             	<input type="text" name="FAMY_TEXT" value=""  size="30" class="input04" readOnly>
	                             	<input type="hidden" name="FAMY_CODE" value="" readOnly>
	                            </span>


                          </td>
                      </tr>


                      <tr>
                        <th><span  class="textPink">*</span><spring:message code='LABEL.D.D19.0005'/><!--Application Reason&nbsp;-->
                      	</th>
                        <td colspan=3 >

                            <input type="text" id="APPL_REAS" name="APPL_REAS" value="${ data.APPL_REAS }" class="input03" size="65"
                            	maxlength="100" style="ime-mode:active">
                         	<span id="ENAME_DIV" style="display:none">
	                         	<input type=\"text\" name=\"ENAME\"  value="" class=\"input04\"   size=\"100\" readonly>
                         	</span>
                        </td>
                      </tr>


                      <tr>
                        <th><spring:message code='LABEL.D.D03.0025'/><!--Quota Balance--></th>
                        <td >

                            <input type="text" name="ANZHL_BAL" value="${ f:printNumFormat(data.ANZHL_BAL,2) }"
                            	class="input04" size="4" maxlength="7" style="ime-mode:active;text-align:right;" readonly>
                                <c:choose>
	                            <c:when test="${E_BUKRS eq 'G170'}" >
	                             	<spring:message code="LABEL.D.D01.0008"/>
	                             </c:when>
	                             <c:otherwise>
	                              	<spring:message code="LABEL.D.D03.0031"/>       <!-- hours:days -->
                              	</c:otherwise>
                              	</c:choose>

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

<%--                               <input type="text" name="APPL_FROM" value="${ f:printDate(data.APPL_FROM) }"  --%>
                              <input type="text" name="APPL_FROM" value="${ f:printDate(data.APPL_FROM)}"
                             	size="8" class="date required" onkeypress="EnterCheck2(this)"
                             	onChange="check_Time()" > <!-- onBlur="f_dateFormat(this);"  -->
                             		<!-- a href="javascript:fn_openCal('APPL_FROM','')" >
                                 			<img src="${ g.image }icon_diary.gif" align="absmiddle" border="0" alt="">  </a-->
                             &nbsp;~&nbsp;
                             <input type="text" name="APPL_TO"   value="${ f:printDate(data.APPL_TO)   }"
                             	size="8" class="date required"  onkeypress="EnterCheck2(this)"   onChange="check_Time()" > <!-- onBlur="f_dateFormat(this);"  -->
                             	 <!-- a href="javascript:fn_openCal('APPL_TO','check_Time()')" >
                                	  <img src="${ g.image }icon_diary.gif" align="absmiddle" border="0" alt="">  </a-->

                              <input type="text" name="E_ABRTG"  ID="E_ABRTG"     size="4" style="text-align:right;" readonly>
								<!-- [CSR ID:3544114] G220 법인에서 Compensatory Leave(half) 신청 시 시간으로 표시 -->
								<span id="G220CompText">
                                <%--[CSR ID:3544114] 동적으로 바뀌도록 변경
                                 <c:choose>
	                            <c:when test="${E_BUKRS eq 'G170' }" >
	                             	<spring:message code="LABEL.D.D01.0008"/>
	                             </c:when>
	                             <c:otherwise>
	                              	<spring:message code="LABEL.D.D03.0036"/>       <!-- hours:days -->
                              	</c:otherwise>
                              	</c:choose> --%>
                              	</span>


                              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                              <span id="sp2" style="visibility:hidden"  ><spring:message code='LABEL.D.D03.0026'/><!--Maximum Available&nbsp;-->
                              <input type="text" name="P_STDAZ2" value=" ${data.STDAZ } " size="2" maxlength="7"
                              			style="ime-mode:active;text-align:right;" readonly>
	                            <c:choose>
	                            <c:when test="${E_BUKRS eq 'G170'}" >
	                             	<spring:message code="LABEL.D.D01.0008"/>
	                             </c:when>
	                             <c:otherwise>
	                              	<spring:message code="LABEL.D.D03.0036"/>       <!-- hours:days -->
                              	</c:otherwise>
                              	</c:choose>
                              </span>

                                   <input type="hidden" name="AINF_SEQN2" value=""  size="3" class="input04" readonly>


                      			</td>
                      </tr>


                      <tr>
                        <th><spring:message code="LABEL.D.D03.0023"/><!-- Application Time --></th>
                        <td colspan=3  colspan=10>

                                <input type="text" id="BEGUZ" name="BEGUZ" value='${ (f:printTime(data.BEGUZ)) }' size="10"
                                		 readonly onkeypress="EnterCheck3(this)"   onChange="f_timeFormat(this); " 		 >  <!-- onBlur="f_timeFormat(this);" -->
                          <a href="javascript:fn_openTime('BEGUZ');"  ><img src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>

                                &nbsp;~&nbsp;
                                <input type="text" id="ENDUZ" name="ENDUZ" value='${  (f:printTime(data.ENDUZ)) }' size="10"
                                		readonly onkeypress="EnterCheck3(this)"   onChange="f_timeFormat(this); "   		 > <!-- onBlur="f_timeFormat(this);"  -->
                                <a href="javascript:fn_openTime('ENDUZ');" ><img src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>

                                <input type="text" id="I_STDAZ"  name="I_STDAZ"   size="4"
                                		readonly style="text-align:right;"> <spring:message code="LABEL.D.D01.0008"/><!--  hour(s)-->

                       </td>

                      </tr>
                    </table></td>
                </tr>

              <!-- 상단 입력 테이블 끝-->

          <tr>
            	<td >

	        		<div class="commentsMoreThan2">
				         <div><spring:message code="MSG.COMMON.0061"/></div>
				         <!-- 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out  Start-->
				         <!-- 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out -->
			            <c:if test='${ user.companyCode==("G180") || user.companyCode==("G570")|| user.companyCode==("G620") }'>
			             <!-- 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out  End-->
				            <div><spring:message code='MSG.D.D01.0100'/><!-- MSG.D.D01.0100 = 먼저 연차 휴가를 사용한 다음 일반 휴가를 신청하십시오.--></div>
			            </c:if>
			         </div>
		         </td><!-- &nbsp;&nbsp;*: Required Field -->
          </tr>

		</table>
	</div>
</div>


<!-- HIDDEN  처리해야할 부분 시작 (default = 전일휴가), frdate, todate는 선택된 기간에 개인의 근무일정을 가져오기 위해서.. -->
      <input type="hidden" name="DEDUCT_DATE" value="${ data.DEDUCT_DATE }">
<!-- HIDDEN  처리해야할 부분 끝   -->

   </tags-approval:request-layout>

<form name="form3" method="post">
      　
      <input type="hidden" name = "PERNR" value="${data.PERNR}">
</form>

  <!--@v1.9-->
  <form name="family" method="post">
      <input type="hidden" name = "PERNR" value="">
      <input type="hidden" name = "OBJ"   value="">
      <input type="hidden" name = "CONG_CODE" value="">
      <input type="hidden" name = "RELA_CODE"   value="">
      <input type="hidden" name = "PersonData"   value="${PERNR_Data}">
  </form>

</tags:layout>


<iframe name="ifHidden" width="0" height="0" />

