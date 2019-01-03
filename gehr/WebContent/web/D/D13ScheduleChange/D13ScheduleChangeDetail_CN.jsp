<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 일일근무일정변경	조회												*/
/*   Program ID   : D13SceduleChange|D13SceduleChangeDetail_CN.jsp						*/
/*   Description  : 일일근무일정변경 화면												*/
/*   Note         : 															*/
/*   Creation     : 2016-10-20 GEHR 남경일근태조회	(김승철-C03참조함)											*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="hris.D.D13ScheduleChange.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-nodata-d" tagdir="/WEB-INF/tags/D" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags-common" tagdir="/WEB-INF/tags/common" %>

<%
	WebUserData user = WebUtil.getSessionUser(request);
	String PERNR = (String)request.getAttribute("PERNR");
	String I_BEGDA = (String)request.getAttribute("I_BEGDA");
	String I_ENDDA = (String)request.getAttribute("I_ENDDA");
//     String I_ORGEH  = WebUtil.nvl(request.getParameter("I_ORGEH"));          //기간
//     String deptNm = (String)request.getAttribute("deptNm");
	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                  //부서코드
	String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                                //부서명
	if( I_BEGDA == null || I_BEGDA.equals("") ) {
		I_BEGDA = DataUtil.getAfterDate(DataUtil.getCurrentDate(), -1);
	}
	if( I_ENDDA == null || I_ENDDA.equals("") ) {
		I_ENDDA = DataUtil.getCurrentDate();
	}

//     if(I_ORGEH == null || I_ORGEH.equals("")){
//     	WebUserData user = WebUtil.getSessionUser(request);
//     	I_ORGEH = user.e_orgeh;
//     }

//     String deptId       = I_ORGEH;                      //부서코드
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="I_ENDDA" value="<%=I_ENDDA %>" />
<c:set var="I_BEGDA" value="<%=I_BEGDA %>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<%--@elvariable id="resultList" type="java.util.Vector<hris.D.D13ScheduleChange.D13ScheduleChangeData>"--%>

<jsp:include page="/include/header.jsp" >
     <jsp:param name="script" value="jquery.tablesorter.min.js"/>
     <jsp:param name="css" value="/blue/style.css"/>
</jsp:include>

<!-- body header 부 title 및 body 시작 부 선언 -->

<script>

	function change_perpage(){
		$(".wideTable").css('max-height', $("#listNumber").val());
		$(".wideTable").attr('height', $("#listNumber").val());
		if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
	}
	
	//조회에 의한 부서ID와 그에 따른 조회.
	function setDeptID(deptId, deptNm){
		frm = document.all.form1;
		var urlName = frm.urlName.value;

		// 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
		if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
			//alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
			alert("<spring:message code='MSG.F.F41.0003'/>   ");
			return;
		}
		
		document.form1.txt_deptNm.value = deptNm;
		frm.hdn_deptId.value = deptId;
		frm.hdn_deptNm.value = deptNm;
// 		frm.I_ORGEH.value = deptId;
		frm.I_SEARCHDATA.value = deptId;
		frm.action = urlName;
		frm.action = "${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN";
		
// 		frm.target = "listFrame";
		frm.target = "_self";
		frm.jobid.value = "search";
// 		blockFrame();
		frm.submit();

	}

	//-->

	function autoResize(target) {
		target.height = 0;
		var iframeHeight =  target.contentWindow.document.body.scrollHeight;
		target.height = iframeHeight + 50;
	}
	
	

	var lastIndex = ${fn:length(resultList)};

	/**
	 * 로우추가
	 */
	function addRow() {
		console.log("--- addROw -- ");

		var templateText = $("#template").text();
		templateText = templateText.replace(/#idx#/g, ++lastIndex);
		var $row = $(templateText);

		$("#-listTable-body").append($row);
		addMaskFilter($row);
		addDatePicker($row.find(".date"));
		$("#PERNR"+lastIndex).focus();

		if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
		alert("<spring:message code='MSG.D.D12.0036'/>"); //사번 또는 이름을 입력하고 검색 하세요
	}


	/**
	 * 전체 체크
	 */
	function checkAllChange() {
		if($("#checkAll").is(":checked")) {
			$(".-row-check").prop("checked", true);
		} else {
			$(".-row-check").prop("checked", false);
		}
	}

	$(function() {
		if('${msg}' > '' )			alert('${msg}');
// 		$("#searchDeptNm").css("width","250px");
		
// 		if($(".-pay-type").length == 0) {
// 			$("#-listTable-body").empty();
// 			addRow();
// 		}

        $("#-schedule-change-table").tablesorter();
		if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
	});


	var _searchPersonIdx = null;



	function removeSearchPerson(idx) {
		$("#PERNR" + idx).val('');
	}


	/**
	 * 사원 검색 팝업
	 
	function searchPerson(idx, type) {
		_searchPersonIdx = idx;

		if(event.keyCode && event.keyCode != 13) return;

//                 var type = $("#APPR_SEARCH_GUBUN" + idx).val();

		var _jobid = type == "1" ? "pernr" : "ename";
		if(type=="1"){
			var _value = $("#PERNR" + idx).val();
		}else{
			var _value = $("#ENAME" + idx).val();
		}

		if ( _.isEmpty(_value)) {
			if(type == "1")
				alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED'/>");//검색할 부서원 사번을 입력하세요
			if(type == "2")
				alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.REQUIRED'/>");//검색할 부서원 성명을 입력하세요

			$("#PERNR" + idx).focus();
			return;
		}

		var url = "${g.jsp}common/SearchDeptPersonsWait_T.jsp?I_GUBUN=" + type + "&I_VALUE1=" + encodeURIComponent(_value) + "&jobid=" + _jobid;

		var searchApprovalHeaderPop = window.open(url,"DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=450,top=00");
		
	}
	*/

	/* 사원 검색 팝업 */
	function searchPerson(idx) {
	    _searchPersonIdx = idx;

	    if(event.keyCode && event.keyCode != 13) return;

	    var  numCK = /^[0-9]+$/;
	    var type = numCK.test($("#PERNR" + idx).val()) ? "1": "2";

	    var _jobid = type == "1" ? "pernr" : "ename";
	    var _value = $("#PERNR" + idx).val();

	    if ( _.isEmpty(_value)) {
	       alert("<spring:message code='MSG.D.D12.0034'/>"); // 검색할 부서원 사번 또는 이름을 입력하세요.

	       $("#PERNR" + idx).focus();
	        return;
	    }

	    var url = "${g.jsp}common/SearchDeptPersonsWait_T.jsp?I_GUBUN=" + type + "&I_VALUE1=" + encodeURIComponent(_value) + "&jobid=" + _jobid;
	    var searchApprovalHeaderPop = window.open(url,"DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=450,top=00");
	}
<%--
/* request-layout.tag의  pers_search() 내용 ksc */
    function pers_search(idx) {
	    _searchPersonIdx = idx;

        if(event.keyCode && event.keyCode != 13) return;

	    var  numCK = /^[0-9]+$/;
	    var type = numCK.test($("#PERNR" + idx).val()) ? "1": "2";

	    var _jobid = type == "1" ? "pernr" : "ename";
	    var _value = $("#PERNR" + idx).val();

	    if ( _.isEmpty(_value)) {
	       alert("<spring:message code='MSG.D.D12.0034'/>"); // 검색할 부서원 사번 또는 이름을 입력하세요.

	       $("#PERNR" + idx).focus();
	        return;
	    }

	    /*
	    var url = "${g.jsp}common/SearchDeptPersonsWait_T.jsp?I_GUBUN=" + type + "&I_VALUE1=" + encodeURIComponent(_value) + "&jobid=" + _jobid;
		*/
        url = "${g.jsp}common/SearchDeptPersonsWait_R.jsp?I_GUBUN=" + type + "&I_VALUE1=" + encodeURIComponent(_value) + "&jobid=" + _jobid;
	    var searchApprovalHeaderPop = window.open(url,"DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=450,top=00");
    }
--%>
    
	function doSearchTprog(idx  ){
// 	            window.open('${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?I_DATE=' +"&rowNum="+idx,
//             			'tariningHistoryPop', "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,width=570,height=450,left=50%,top=200");
		var _pernr = $("#PERNR" + idx).val();
		var retVal = window.showModalDialog('${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?PERNR='+_pernr+'&I_DATE=' +"&rowNum="+idx,
				'', "dialogWidth:650px,dialogHeight:450");
		if(retVal != undefined){
			$("#SOLLZ" + idx).val(retVal.SOLLZ);
			$("#SOBEG" + idx).val(retVal.SOBEG);
			$("#SOEND" + idx).val(retVal.SOEND);
			$("#SOBEG_TXT" + idx).val(retVal.SOBEG_TXT);
			$("#SOEND_TXT" + idx).val(retVal.SOEND_TXT);
	
			$("#TPROG" + idx).val(retVal.TPROG);
			$("#TPROG2_" + idx).val(retVal.TPROG);
			$("#RTEXT" + idx).val(retVal.TTEXT);
			$("#VARIA2" + idx).val(retVal.VARIA);
			$("#TTEXT" + idx).val(retVal.TTEXT);
			autoCheck(idx);
		}
//             	$('#ifpopup').attr("src","${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?I_DATE=" +
//             			"&rowNum="+idx);
//             	showPop();
	}

	function setEndDate(row){
		if($("#CENDDA"+row).val()==""){
			$("#CENDDA"+row).val($("#CBEGDA"+row).val());
			
		}
	}
	
	/**
				개인별 현황 팝업
	*/
	function doSearchSchdule( pernr , i_begda, rowNum ){
	
		if (i_begda=="0000-00-00"){
		}else{
			i_begda = getAfterDate(i_begda, -2);
			var i_endda = getAfterDate(addPointAtDate(i_begda), 7);
			window.open('${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?jobid=schedule&PERNR='+pernr+"&I_DATE=" +i_begda+"&I_ENDDA="+i_endda+"&rowNum="+rowNum,
					'tariningHistoryPop', "toolbar=no,location=no,directories=no,scrollbars=yes,status=no,menubar=no,resizable=yes,width=900,height=662,left=50%,top=100");
		}
//             	$('#ifschedule').attr("src","${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?jobid=schedule&PERNR="+pernr+"&I_DATE=${I_DATE}" +
//             			"&I_ENDDA=${I_ENDDA}&rowNum="+rowNum);
//             	showSchedule();
	}

	/* 행삭제
	function deleteAjax(){
		var paramArr = new Array();

		$(".-row-check:checked").each(function() {
			var $this = $(this);
			if($this.is(":checked")) {
				var $inputs = $this.parents("tr").find("input");

				var obj = new Object();
				$inputs.each(function() {
					var $input = $(this);
					obj[$input.prop("name").replace("LIST_", "")] = $input.val();
				});

				paramArr.push(obj);
			}
		});


		jQuery.ajaxSettings.traditional = true;
		$.ajax({type:'POST',
			url: '${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN',
			data: {jobid:"delete", paramArr: JSON.stringify(paramArr)},
			dataType: 'json',
			success: function(data){
				alert(data);
				$(".-row-check:checked").parents("tr").remove();
			},
			error:function(e){
				alert(e.responseText);
			}});
	}
 */
	/**	권한검사	*/
	function setPersInfo(obj) {
		var pernr = obj.PERNR;
		var ename = obj.ENAME;
	    var url = '${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV';
	    var pars = 'jobid=searchPerson&PERNR=' + obj.PERNR;
		  $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){
			  if( data == "S"){
				  $("#PERNR" + _searchPersonIdx).val(pernr);
				  $("#ENAME" + _searchPersonIdx).val(ename);
			  }else if( data == "E" ){
				  alert("<spring:message code='MSG.F.F46.0002'/>");
				  $("#PERNR" + _searchPersonIdx).val("");
				  $("#ENAME" + _searchPersonIdx).val("");
			  }}});
	}
	
	/**	기준일자검사	*/
	 function on_Blur(obj, _init_yn) {
	     date_n = Number(removePoint(obj.value));
	     if( obj.value != "" && dateFormat(obj) ) {//get work date and time
	         var url = '${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV';
	         var pars = 'jobid=check&I_BEGDA=' + date_n + '&PERNR=${PERNR}' ;
	   	     $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){
			    if(data == "N" ){
				       alert("<spring:message code='MSG.D.D01.0050'/>");//You can't apply this data in payroll period
				       if(_init_yn=="Y"){
				    	   obj.value="";
				       }
				    }
	   	  		}
	   	  });
	     }
	
	 }

	 


	 <%--
	 	/**
	 	 * 로우 삭제
	 	 */
	 	function deleteRow() {
	 		$(".-row-check:checked").parents("tr").remove();
	 		lastIndex--;

	 		if($("#-listTable-body tr").length == 0) {
	 			addRow();
	 			$("#checkAll").prop("checked", false);
	 			/*$("#-listTable-body").append($("<tr/>").append($("<td colspan='7'/>").text("<spring:message code="MSG.COMMON.0004" />")));*/
	 		}
	 	}
	 --%>
	 
	/* 일괄삭제처리 */
	function deleteRow(){
		if($("input[name=checkRow]:checkbox:checked").length == 0){
	        alert('<spring:message code="MSG.D.D12.0016" />'); //삭제할 DATA를 선택하세요.
	        return;
	    }else{
	    	if(confirm("<spring:message code='MSG.D.D12.0035' arguments='"+$("input[name=checkRow]:checkbox:checked").length+"'/>")){

		    	/* 저장되지않은 임시라인부터 삭제 */
			    for( var i =  $("input[name='checkRow']").length -1; i > 0;  i--){
					if( document.getElementsByName("checkRow")[i].checked && document.getElementsByName("LIST_DEL")[i].value=="Y" ){
// 				 		$(".-row-check:checked").parents("tr").remove();
				 		$("#-pay-row-"+(i+1)).remove();
				 		lastIndex--;
			    	}
			   	}

				beforeSubmit();
			    
		    	if($("input[name=checkRow]:checkbox:checked").length > 0){
					document.form1.jobid.value="deleteRow";
					document.form1.action="${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN";
// 					blockFrame();
				    document.form1.submit();
			    }
	    	}
	    }
	}

/*
 * 공통모듈 SearchDeptInfoPernr.jsp에는 해외에는 부서찾기밖에 없어서 사번찾기 추가
 */
		
	function doSearch() {

		if(_ajax_isreturned == false){
			setTimeout(doSearch,500);//1초후 재귀호출 //사번검색ajax결과 대기중.
			return;
		};
		
		if(document.form1.txt_pernr.value > ""){
			document.form1.txt_pernr.value = ltrim(rtrim(document.form1.txt_pernr.value));
		}
		document.form1.I_BEGDA.value  = removePoint(document.form1.I_BEGDA.value);
		document.form1.I_ENDDA.value  = removePoint(document.form1.I_ENDDA.value);
		document.form1.jobid.value="search";
	  	document.form1.target="_self";
		document.form1.action="${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN";
// 		blockFrame();
		document.form1.submit();
	}

	function beforeSubmit() {
		for( var i = 0; i < $("input[name='checkRow']").length; i++){
			if( document.getElementsByName("checkRow")[i].checked ){
				document.getElementsByName("LIST_ZCHECK")[i].value = "X";
	    	}else{
	   			document.getElementsByName("LIST_ZCHECK")[i].value = "";
			}
	    	$("#SOBEG" + i).val(addSec($("#SOBEG"+i).val()));
	    	$("#SOEND" + i).val(addSec($("#SOEND"+i).val()));
	   	}

	}
	
	/*저장 */
	function doSave() {
		if($("input[name=checkRow]:checkbox:checked").length == 0){
			alert('<spring:message code="MSG.D.D12.0028" />'); //저장할 DATA를 선택하세요.
			return;
		}

		beforeSubmit();
		
		document.form1.jobid.value="save";
		document.form1.row_count.value=    	lastIndex;
		document.form1.action="${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN";
		document.form1.submit();
// 		blockFrame();
	}

	function addSec( text ){
		if(text !='' && text != undefined){
			  if( text.length == 5){
	// 		    time = removeColon(text);
			    return text+":00";
			  } else if( text.length < 6){
				    return "";
			  } else {
			    return text;
			  }
		}
	}

		function autoCheck(row){
			//document.form1.checkRow[row].checked = true;
			$("#checkRow"+row).prop("checked", true);
		}


		//Execl Down 하기.
		function excelDown() {

		    var vObj = document.form1;

		    vObj.target = "ifHidden";
		    vObj.jobid.value = "excel";
		    document.form1.action = "${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN";
// 		    document.form1.action = "${g.jsp}D/D13ScheduleChange/D13ScheduleExcel.jsp";
		    document.form1.method = "post";
		    document.form1.submit();
		    $.unblockUI();

		}
</script>

<jsp:include page="${g.jsp }D/D13ScheduleChange/D1213common.jsp"/>
		 
<%-- <tags:layout title="" script="jquery.tablesorter.min.js" css="/blue/style.css"> --%>

<jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y"/>
</jsp:include>

		<c:if test="${user.area == 'PL'}" >
			<tags:script>
				<script>
					function openPopHistory() {
						window.open('${g.servlet}hris.C.C03LearnDetailHistoryPopSV', 'tariningHistoryPop', "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,width=900,height=662,left=0,top=2");
					}
				</script>
			</tags:script>

		</c:if>
		
<form id="form1" name="form1" method="post"   onsubmit="return false">
	<%@include file="/web/common/SearchDeptInfoPernr.jsp" %>

	<div class="tableInquiry" >
		<span class="textPink">*</span><spring:message code='LABEL.D.D12.0077'/> <!-- 조회기간-->
		<input type="text" id="I_BEGDA" name="I_BEGDA" class="date required" value="${f:printDate(I_BEGDA)}" size="10" 
				onchange= "javascript:on_Blur(this,'N');" placeholder="<spring:message code='LABEL.D.D12.0078'/>">
		&nbsp; ~
		<input type="text" id="I_ENDDA" name="I_ENDDA" class="date required" value="${f:printDate(I_ENDDA)}" size="10" 
		onchange= "javascript:on_Blur(this,'N');" 	placeholder="<spring:message code='LABEL.D.D12.0079'/>" >&nbsp;
		
		<spring:message code="LABEL.D.D12.0017" /><!--사번-->
		<input 
			type="text" 
			id="searchPernr" 
			name="txt_pernr" 
			size=8 maxlength=8
			value="${txt_pernr }" 
			onKeyDown="if(event.keyCode == 13) on_change_pernr(this);" 
			onChange="on_change_pernr(this);" 
			style="ime-mode:active" >
		
		<div class="tableBtnSearch tableBtnSearch2">
			<a class="search" href="javascript:;" onclick="doSearch();"><span><spring:message code='LABEL.D.D12.0014'/> <!--조회--></span></a>
		</div>

	</div>


	<c:set var="PERNR" value="<%= (String)request.getAttribute("PERNR") %>"/>


	<!--일일근태현황 리스트 테이블 시작-->


	<input type="hidden" name="jobid"  value="search" />
	<input type="hidden" name="PERNR"  value="${PERNR }" />
	<input type="hidden" name="row_count"  value="" />
	<input type="hidden" name="hdn_deptId"  value="${deptId}">
	<input type="hidden" name="hdn_deptNm"  value="${deptNm}">
<%-- 	<input type="hidden" name="I_ORGEH"  value="${deptId}"> --%>
	<input type="hidden" name="I_SEARCHDATA"  value="${I_SEARCHDATA}">
	<input type="hidden" name="subView" value="Y">
	<input type="hidden" name="urlName" value="">
	<input type="hidden" name="I_VALUE1"  value="">
	<input type="hidden" name="sMenuCode"  value="${sMenuCode}">
	<input type="hidden" name="retir_chk"  value="">


<!-- 	<div class="listArea" style="text-align:right; "> -->
	<div class="listArea" >
			<div class="listTop">
				<div class="listTop_inner">
					<span class="listCnt" style="vertical-align:middle;"><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(resultList)}' /><!--총 건-->
						</span>
			<%-- 통일성을 위해 기능정지
						<span style="margin-left:70px;">
						<select id="listNumber" name="listNumber" title="listNumber" onchange="change_perpage();">
							<option value="360px">12<spring:message code='LABEL.D.D15.0148'/></option>
							<option value="460px">15<spring:message code='LABEL.D.D15.0148'/></option>
							<option value="560px">19<spring:message code='LABEL.D.D15.0148'/></option>
							<option value="630px">21<spring:message code='LABEL.D.D15.0148'/></option>
						</select>
					</span>
				 --%>
				</div>
				<div class="buttonArea">
					<ul class="btn_mdl" style="display: inline;padding-left: 50px;" >
						<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
					</ul>
				</div>
				<div class="clear"> </div>
			</div>

    <div class="wideTable" style="border-bottom:#eee 1px solid; border-top: 2px solid #c8294b; overflow:auto; max-height:360px; ">
 
    		<table id="-schedule-change-table" class="listTable tablesorter" style="width:1484px;" >
    		<colgroup>
    		<col width=20px/>	<!-- 선택-->
    		<col width=120px/>	<!-- 사원번호-->
    		<col width=90px/>	<!-- 이름-->
    		<col width=140px/>	<!-- 시작일-->
    		<col width=140px/>	<!-- 종료일-->
    		<col width=170px/>	<!-- 대체유형-->
    		<col width=120px/>	<!-- 일일근무일정-->
    		<col width=100px/>	<!-- 근무일정규칙-->
    		<col width=110px/>	<!-- 근무일정명-->
    		<col width=70px/>	<!-- 시작시간-->
    		<col width=70px/>	<!-- 종료시간-->
    		<col width=70px/>	<!-- 근무시간-->
    		<col />					<!-- 오류메시지-->
    		</colgroup>
    		
			<thead>
			<tr>
				<th><input type="checkbox" id="checkAll" name="checkAll" onclick="checkAllChange()"/></th>
				<th ><spring:message code="LABEL.D.D12.0017"/> <!-- 사원번호--></th>
				<th><spring:message code="LABEL.D.D12.0018"/> <!-- 이름--></th>
				<th ><spring:message code="LABEL.D.D15.0152"/> <!-- 시작일--></th>
				<th ><spring:message code="LABEL.D.D15.0153"/> <!-- 종료일--></th>
				<th ><spring:message code="LABEL.D.D13.0014"/> <!-- 대체유형--></th>
				<th ><spring:message code="LABEL.D.D13.0015"/> <!-- 일일근무일정--></th>
				<th ><spring:message code="LABEL.D.D14.0001"/> <!-- 근무일정규칙--></th>
				<th ><spring:message code="LABEL.D.D13.0016"/> <!-- 근무일정명--></th>
				<th ><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
				<th ><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
				<th><spring:message code="LABEL.D.D13.0017"/> <!-- 근무시간--></th>
				<th  class="lastCol"><spring:message code="MSG.COMMON.UPLOAD.BIGO"/> <!-- 오류메시지--></th>
			</tr>
			</thead>
			<tbody id="-listTable-body">

			<c:forEach var="row" items="${resultList}" varStatus="status">
				<tr  id="-pay-row-${status.index}" class="borderRow ${f:printOddRow(status.index)}" ${row.ZBIGO>"" ? "style='background-color:#FEE4E4'" : ""  	} onchange="" 
				 style="border-bottom:#eee 1 solid;border-top:0; border-right:0;border-left:0">
					<td ><input type="checkbox" id="checkRow${status.index}" name="checkRow" class="-row-check" value="X"/></td>
					<td >
						<c:choose>
						<c:when test='${row.PERNR == "00000000"}'> 
							<input type="text"  id="PERNR${status.index}" 	name="LIST_PERNR" 	 size="8"  onchange="searchPerson(${status.index}); autoCheck(${status.index});" value="">
							<a onclick="searchPerson(${status.index});" ><img src="${g.image}sshr/ico_magnify.png" /></a>
						</c:when>
						<c:otherwise>
							<a href="#" onClick="javascript:doSearchSchdule(${row.PERNR}, '${row.CBEGDA}', ${status.index})"	>
								${row.PERNR == "00000000" ? "" : row.PERNR}</a>
							<input type="hidden" id="PERNR${status.index}" 	name="LIST_PERNR" 		value="${ row.PERNR}" 	  readonly	/>	</td>
						</c:otherwise>
						</c:choose>
					<td >
						<input type="text" id="ENAME${status.index}" 	name="LIST_ENAME" 	value="${row.ENAME}" size="5" 	readonly /></a>              		</td>
					<td ><input type="text" id="CBEGDA${status.index}" 	name="LIST_CBEGDA" 	value="${ row.CBEGDA == "0000-00-00" ? "" : row.CBEGDA 	}" size="10"  onChange="on_Blur(this,'Y');setEndDate(${status.index}); autoCheck(${status.index});" class="date required" placeholder="<spring:message code='LABEL.D.D15.0152'		/>">	</td>
					<td ><input type="text" id="CENDDA${status.index}" 	name="LIST_CENDDA" 	value="${ row.CENDDA == "0000-00-00" ? "" : row.CENDDA	}" size="10"  onChange="on_Blur(this,'Y');autoCheck(${status.index});"  class="date required" placeholder="<spring:message code='LABEL.D.D15.0153'		/>"> </td>
					<td ><select id="VTART${status.index}" name="LIST_VTART" class="required -pay-type fixCol" onchange="autoCheck(${status.index});" placeholder="<spring:message code='LABEL.D.D08.0004' />">
						<option value="01" data-infty="01" ${row.VTART=='01'?'selected'	:''	}><spring:message code='LABEL.D.D13.0028'/></option>
						<option value="02" data-infty="02" ${row.VTART=='02'?'selected':''		}><spring:message code='LABEL.D.D13.0029'/></option>
					</select>	                </td>
					<td ><input type="text" id="TPROG${status.index}" 	name="LIST_TPROG" 	value="${row.TPROG	}" size="5"  class="required" onChange="autoCheck(${status.index});"  placeholder="<spring:message code='LABEL.D.D13.0015'		/>">
						<a href="javascript:doSearchTprog(${status.index});">
							<img src="${g.image}sshr/ico_magnify.png"  name="image" align="absmiddle" border="0">
						</a>					</td>
					<td >	<input type="text" id="RTEXT${status.index}"		name="LIST_RTEXT" 	value="${row.RTEXT	}" size="10"  	class="noBorder"  readonly></td>
					<td>	<input type="text" id="TTEXT${status.index}" 		name="LIST_TTEXT" 	value="${row.TTEXT	}" size="12"  	class="noBorder" readonly></td>
					<td >	<input type="text" id="SOBEG_TXT${status.index}" 	name="LIST_SOBEG_TXT"	value="${(row.SOBEG == "00:00:00" && row.SOLLZ=="0") ? "" : f:printTime(row.SOBEG)	}" size="3"  	class="noBorder" readonly></td>
					<td >	<input type="text" id="SOEND_TXT${status.index}" 	name="LIST_SOEND_TXT"	value="${(row.SOEND == "00:00:00" && row.SOLLZ=="0") ? "" : f:printTime(row.SOEND)}" size="3" 		class="noBorder"	readonly	></td>
					<td >	<input type="text" id="SOLLZ${status.index}" 		name="LIST_SOLLZ" 	    value="${row.SOLLZ	}"     size="4" 		class="align_right noBorder"	readonly	></td>
					<td class="lastCol " >
						<input type="text"   id="ZBIGO${status.index}"  size=56 name="LIST_ZBIGO" 	readonly  value="${row.ZBIGO}"
							style="color:#c8294b ; border:none; padding-top:2px;overflow:hidden; background-color:transparent; line-height:1;" />
<%-- 						<textarea    id="ZBIGO${status.index}"  lines=1 	name="LIST_ZBIGO" 	readonly wrap="VIRTUAL"  scrollbars=no  --%>
<%-- 							style="color:#c8294b ; border:none; padding-top:2px;overflow:hidden; background-color:transparent; line-height:1;">${row.ZBIGO	}</textarea> --%>

					</td>
						<input type="hidden" id="BEGDA${status.index}" 		name="LIST_BEGDA" 	value="${row.BEGDA}" />
						<input type="hidden" id="ENDDA${status.index}" 		name="LIST_ENDDA" 	value="${row.ENDDA}" />
						<input type="hidden" id="SOBEG${status.index}" 		name="LIST_SOBEG" 	value="${row.SOBEG}" />
						<input type="hidden" id="SOEND${status.index}" 		name="LIST_SOEND" 	value="${row.SOEND}" />
						<input type="hidden" id="ZCHECK${status.index}" 	name="LIST_ZCHECK" 	 />
						<input type="hidden" id="DEL${status.index}" 			name="LIST_DEL" 		value="N" />
						<input type="hidden" id="SUBTY${status.index}" 		name="LIST_SUBTY" 	value="${row.SUBTY}" />
						<input type="hidden" id="OBJPS${status.index}"  		name="LIST_OBJPS" 		value="${row.OBJPS}" />
						<input type="hidden" id="SPRPS${status.index}"  		name="LIST_SPRPS" 		value="${row.SPRPS}" />
						<input type="hidden" id="SEQNR${status.index}" 		name="LIST_SEQNR" 	value="${row.SEQNR}" />
						<input type="hidden" id="TPROG2_${status.index}" 	name="LIST_TPROG2" 	value="${row.SUBTY}" />
						<input type="hidden" id="VARIA2${status.index}"  		name="VARIA2"  			value="${row.VARIA2}"  />
						<input type="hidden" id="ZLINE${status.index}"  		name="ZLINE"  			value="${status.index}"  />				</tr>
			</c:forEach>
			<%--             <tags:table-row-nodata list="${resultList}" col="13" /> --%>
			</tbody>
		</table>


		<textarea id="template" style="display: none; top: -99999px; height: 0px; ">
		        <tr id="-pay-row-#idx#" >
		            <td>  <input type="checkbox" id="checkRow#idx#" name="checkRow" class="-row-check" value="X" />            </td>
		            <td>
		                	<input type="number" id="PERNR#idx#" name="LIST_PERNR" class="-search-person required"
								   size=8 maxlength="8" onchange="searchPerson(#idx#); autoCheck(#idx#);" value="" style="width: 60px;" />
		                	<a onclick="searchPerson(#idx#);" ><img src="${g.image}sshr/ico_magnify.png" /></a>           
					</td>
		            <td>	<input type="text" id="ENAME#idx#" name="LIST_ENAME"  value=""  size=5 readonly />
<%-- 		                	<a onclick="searchPerson(#idx#,2);" ><img src="${g.image}sshr/ico_magnify.png" /></a>            --%>
					</td>
		         	<td >	<input type="text" id="CBEGDA#idx#" 	name="LIST_CBEGDA" 	value="" size="4"  onChange="on_Blur(this,'Y'); setEndDate('#idx#'); autoCheck(#idx#);"  class="date required" placeholder="<spring:message code='LABEL.D.D15.0152'		/>"><%-- 시작일--%>	</td>
		            <td >	<input type="text" id="CENDDA#idx#" 	name="LIST_CENDDA" 	value="" size="4"  onchange="on_Blur(this,'Y'); autoCheck(#idx#);"  class="date required" placeholder="<spring:message code='LABEL.D.D15.0153'		/>"><%-- 종료일--%> </td>
		            <td>	<select id="VTART#idx#" name="LIST_VTART" class="required -pay-type" onchange="autoCheck(#idx#);" placeholder="<spring:message code="LABEL.D.D08.0004" /><%-- 임금유형 --%>">
		                    <option value="">-----------------</option>
		                    <option value="01" data-infty="01"><spring:message code='LABEL.D.D13.0028'/></option><!-- Moving Sat/Sunday -->
		                    <option value="02" data-infty="02"><spring:message code='LABEL.D.D13.0029'/></option><!--Changing Daily W/S -->
			                </select>			</td>
		            <td >	<input type="text" id="TPROG#idx#" 	name="LIST_TPROG" 	value="" size="5"  class="required" placeholder="<spring:message code='LABEL.D.D13.0015'		/>"><%--- 일일근무일정--%>
		                      <a href="#" onClick="javascript:doSearchTprog(#idx#);"> <img src="${g.image}sshr/ico_magnify.png"  name="image" align="absmiddle" border="0"></a>
                     </td>
		            <td >	<input type="text" id="RTEXT#idx#"   name="LIST_RTEXT" 	value="" size="10"  	readonly /><%-- 근무일정규칙--%>            </td>
		            <td >	<input type="text" id="TTEXT#idx#" 	name="LIST_TTEXT" 	value="" size="10"  readonly	/><%-- 근무일정명--%></td>
		            <td >	<input type="text" id="SOBEG_TXT#idx#" 	name="LIST_SOBEG_TXT" 	value="" size="5"    readonly	/><%-- 시작시간--%></td>
		            <td >	<input type="text" id="SOEND_TXT#idx#" 							value="" size="5"   readonly /><%-- 근무시간--%></td>
		            <td >	<input type="text" id="SOLLZ#idx#"  	 	    				value="" size="5"   readonly /></td>
		            <td class="lastCol" nowrap>
		            		<input type="text"    id="ZBIGO#idx#"   	name="LIST_ZBIGO"  class="noBorder" readonly /><%-- 비고--%>
					    	<input type="hidden" id="BEGDA#idx#"   	name="LIST_BEGDA"  value=""/> 
					    	<input type="hidden" id="ENDDA#idx#"   	name="LIST_ENDDA"  />
					    	<input type="hidden" id="SOBEG#idx#"   	name="LIST_SOBEG"  value=""/> 
					    	<input type="hidden" id="SOEND#idx#"   	name="LIST_SOEND"  value=""/> 
					    	<input type="hidden" id="ZCHECK#idx#" 	name="LIST_ZCHECK" value=""  />
		                    <input type="hidden" id="DEL#idx#" 		name="LIST_DEL"  value="Y"	/>
							<input type="hidden" id="SUBTY#idx#" 	name="LIST_SUBTY"  />
							<input type="hidden" id="OBJPS#idx#" 		name="LIST_OBJPS" />
							<input type="hidden" id="SPRPS#idx#" 		name="LIST_SPRPS"  />
							<input type="hidden" id="SEQNR#idx#" 	name="LIST_SEQNR"  />
							<input type="hidden" id="ZLINE#idx#" 	name="LIST_ZLINE"  VALUE="#idx#"/>
					    	<input type="hidden" id="TPROG2_#idx#" name="TPROG2"   /><!-- popup에서 들어오는 값저장 -->
		       		</td>
		        </tr>
		    </textarea>

	</div>
	
	<div class="listTop">
		<div class="listTop_inner">
			<span class="textPink">*</span><spring:message code="MSG.D.D13.0002"/><!--체크된 항목에 대하여 삭제나 저장이 가능합니다.  -->
		</div>	
		<div class="buttonArea">
			<ul class="btn_mdl"  >
				<li><a href="javascript:;" onclick="addRow();"><span><spring:message code="BUTTON.COMMON.LINE.ADD"/></span></a></li>
				<%--                 <li><a href="javascript:;" onclick="deleteRow();"><span><spring:message code="BUTTON.COMMON.LINE.DELETE"/></span></a></li> --%>
				<li><a href="javascript:;" onclick="deleteRow();"><span><spring:message code="BUTTON.COMMON.LINE.DELETE"/></span></a></li>
				<li><img src="${g.image}/sshr/brdr_buttons.gif" alt="" /></li>
				<li id="sc_button"><a class="darken" href="javascript:;" onclick="doSave();"><span><spring:message code="BUTTON.COMMON.SAVE"/></span></a></li>
			</ul>
	
		</div>
		
	<div class="clear"> </div>
	</div>
	
</div>


</form>

<!-------hidden------------>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->