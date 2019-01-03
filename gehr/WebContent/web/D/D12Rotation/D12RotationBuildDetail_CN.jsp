<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : 신청
*   2Depth Name  : 부서근태
*   Program Name : 부서일일근태관리
*   Program ID   : D12Rotation|D12RotationDetail.jsp
*   Description  : 부서일일근태관리 화면
*   Note         :
*   Update       :
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="hris.D.D12Rotation.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-nodata-d" tagdir="/WEB-INF/tags/D" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags-common" tagdir="/WEB-INF/tags/common" %>

<%
WebUserData user    = (WebUserData)session.getAttribute("user");                                          //세션.
String I_BEGDA = (String)request.getAttribute("I_BEGDA");
String I_ENDDA = (String)request.getAttribute("I_ENDDA");
if( I_BEGDA == null || I_BEGDA.equals("") ) {
	//I_BEGDA = DataUtil.getCurrentDate();
	I_BEGDA = DataUtil.getAfterDate(DataUtil.getCurrentDate(), -1);
}
if( I_ENDDA == null || I_ENDDA.equals("") ) {
	I_ENDDA = DataUtil.getCurrentDate();
}

String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                  //부서코드
String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                                //부서명
String saveAfter = (String)request.getAttribute("saveAfter");
int totalSize = (Integer)request.getAttribute("totalSize") == null ? 0 : (Integer)request.getAttribute("totalSize");
int failSize = (Integer) request.getAttribute("failSize") == null ? 0 : (Integer) request.getAttribute("failSize");
%>

<c:set var="I_ENDDA" value="<%=I_ENDDA %>" />
<c:set var="I_BEGDA" value="<%=I_BEGDA %>" />
<jsp:include page="/include/header.jsp" />
<script language="JavaScript">

var flag = 0 ;
var lastIndex = ${fn:length(D12RotationBuildDetailData_vt)}-1;
var saveAfter = "<%=saveAfter%>";
 var totalSize = "<%=totalSize%>";
var failSize = "<%=failSize%>";

function after_listSetting(){
	if(_ajax_isreturned == false){
		setTimeout(after_listSetting,500);//1초후 재귀호출 //사번검색ajax결과 대기중.
		return;
	};
	
	if( document.form1.I_BEGDA.value > document.form1.I_ENDDA.value){
		alert("<spring:message code='MSG.D.D12.0027'/>");
		document.form1.I_BEGDA.value = "";
		return;
	}
	blockFrame();
	document.form1.hdn_excel.value = "";
  	document.form1.jobid.value="search";
  	document.form1.target="_self";
	document.form1.action="${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV";
    document.form1.submit();
}

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
	frm = document.form1;

	frm.hdn_deptId.value = deptId;
	frm.hdn_deptNm.value = deptNm;
	document.form1.hdn_excel.value = "";
	frm.action = "${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV";
	frm.target = "_self";
	frm.submit();
 }

/* 해당 로우에 데이타 셋팅 */
function setRow($row, obj) {
    if(obj) {
        /* input box set */
        $row.find("input").each(function() {
            var $this = $(this);

            $this.formatVal(obj[$this.prop("name").replace("LIST_", "")]);
        });
    }
}

/* 행추가 */
function addRow(obj) {
	alert("<spring:message code='MSG.D.D12.0036'/>"); //사번 또는 이름을 입력하고 검색 하세요
    var $row;

    if(!$row) {
        var templateText = $("#template").text();
        templateText = templateText.replace(/#idx#/g, ++lastIndex);
        $row = $(templateText);
    }

    setRow($row, obj);

    $("#-listTable-body").append($row);
    $("#-nodata-body").parents("tr").remove();

    setValidate($("#form1"));
	addDatePicker($('.date'));

	$('.timeRoBe').timepicker({
		currentText:"", showButtonPanel:false,
		controlType: 'select',oneLine: true,
		hourMin:0, hourMax:23,
		buttonImage:"/web/images/icon_time.gif",
		timeFormat: 'HH:mm:ss',
		onClose:function(time){
            var element = $(this);
            if(element.val() == "" || element.val() == "__:__:__"){
            	element.val("00:00:00");
            }
		}
	});
	$('.timeRoEn').timepicker({
		currentText:"", showButtonPanel:false,
		controlType: 'select',oneLine: true,
		hourMin:0, hourMax:24,
		buttonImage:"/web/images/icon_time.gif",
		timeFormat: 'HH:mm:ss',
		onClose:function(){
            var element = $(this);
            if(element.val() == "" || element.val() == "__:__:__"){
            	element.val("00:00:00");
            }
		}
	});
	$("#PERNR"+lastIndex).focus();
	 var successSizeResult = "<spring:message code='COMMON.PAGE.TOTAL' arguments='"+(lastIndex+1)+"' />";
	$("#-result-cnt").empty();
    $("#-result-cnt").html(successSizeResult);
}

/* 행삭제 */
function deleteRow(){
	if($("input[name=checkRow]:checkbox:checked").length == 0){
        alert('<spring:message code="MSG.D.D12.0016" />'); //삭제할 DATA를 선택하세요.
        return;
    }else{
    	if(confirm("<spring:message code='MSG.D.D12.0035' arguments='"+$("input[name=checkRow]:checkbox:checked").length+"'/>")){
		    for( var i = 0; i < $("input[name='checkRow']").length; i++){
		    	if( document.getElementsByName("checkRow")[i].checked ){
		   			document.getElementsByName("LIST_ZCHECK")[i].value = "X";
		    	}else{
		   			document.getElementsByName("LIST_ZCHECK")[i].value = "";
		    	}
		   	}
			document.form1.jobid.value="deleteRow";
			document.form1.action="${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV";
		    document.form1.submit();
    	}
    }
}

/*저장 */
function doSave() {
	if($("input[name=checkRow]:checkbox:checked").length == 0){
        alert('<spring:message code="MSG.D.D12.0028" />'); //저장할 DATA를 선택하세요.
        return;
    }
    for( var i = 0; i < $("input[name='checkRow']").length; i++){
    	if( document.getElementsByName("checkRow")[i].checked ){
   			document.getElementsByName("LIST_ZCHECK")[i].value = "X";
    	}else{
   			document.getElementsByName("LIST_ZCHECK")[i].value = "";
    	}
    	if( document.getElementsByName("VTKEN")[i].checked ){
   			document.getElementsByName("LIST_VTKEN")[i].value = "X";
    	}
   	}
	document.form1.jobid.value="save";
	document.form1.action="${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV";
    document.form1.submit();
}

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

/* 전체 체크 */
function checkAllChange() {
    if($("#checkAll").is(":checked")) {
        $(".-row-check").prop("checked", true);
    } else {
        $(".-row-check").prop("checked", false);
    }
}

function vtken_check(obj){
	if( obj.checked ){
		obj.value = "X";
	}else{
		obj.value = "";
	}
}

function on_Blur(obj) {
    date_n = Number(removePoint(obj.value));
    if( obj.value != "" && dateFormat(obj) ) {//get work date and time
        var url = '${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV';
        var pars = 'jobid=check&I_BEGDA=' + removePoint($('#I_BEGDA').val()) + '&PERNR=' + $('#PERNR').val() + "&rmd=" + new Date().toString();
  	  $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
    }

}

function showResponse(originalRequest){
    if(originalRequest == "N" ){
       alert("<spring:message code='MSG.D.D01.0050'/>");//You can't apply this data in payroll period
    }
}

function getBegdaCheck(obj, idx){
	document.getElementsByName("LIST_CENDDA")[idx].value = addPointAtDate(obj.value);
    if( obj.value != "" && dateFormat(obj) ) {//get work date and time
        var url = '${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV';
        var pars = 'jobid=check&I_BEGDA=' + removePoint(obj.value) + '&PERNR=' + $('#PERNR').val() + "&rmd=" + new Date().toString();
  	  $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponseCheck(data, obj, idx)}});
    }
}

function showResponseCheck(originalRequest, obj, idx){
    if(originalRequest == "N" ){
       alert("<spring:message code='MSG.D.D12.0033'/>");//You can't apply this data in payroll period
       obj.value="";
       document.getElementsByName("LIST_CENDDA")[idx].value = "";
    }
}

function autoCheck(row){
	$("#checkRow"+row).prop("checked", true);
}

function timeCheck(object){
	var str = object.value;
 	var strlen =str.length;
 	var ret = "";
 	var alen = 6 - strlen;
 	var astr = "";

	if( strlen == 1 ){
 		for (i=0; i<alen-1; ++i){
  			astr = astr + "0";
 		}
	 	ret = "0"+str + astr; //뒤에서 채우기
	}else{
 		for (i=0; i<alen; ++i){
  			astr = astr + "0";
 		}
	 	ret = str + astr; //뒤에서 채우기
	}

 	object.value = ret;
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.jobid.value="search";
    frm.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationBuildDetailCnSV";
    frm.target = "hidden";
    frm.submit();
}


 $(document).ready(function(){

// 		$("#searchDeptNm").css("width","300px");
		
 	if( saveAfter == "Y" ){
 		alert("<spring:message code='LABEL.D.D12.0081'/> : "+ totalSize + " <spring:message code='LABEL.D.D12.0083'/> <spring:message code='LABEL.D.D12.0082'/> : "+ failSize + "<spring:message code='LABEL.D.D12.0083'/>");
 	}
 	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
  });


</script>

<jsp:include page="${g.jsp }D/D13ScheduleChange/D1213common.jsp"/>
<jsp:include page="${g.jsp}D/timepicker-include.jsp"/>
<jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="jobid"  value="search" />
<input type="hidden" name="check_val"  value="" />
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="I_VALUE1"  value="">
<!--   부서검색 보여주는 부분 시작   -->
<%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>
<!--   부서검색 보여주는 부분  끝    -->
<div class="tableInquiry">
  <table border="0" cellpadding="0" cellspacing="0">
    <tr>
      <th width="90"><spring:message code='LABEL.D.D12.0077'/><!-- 조회일자 --></th>
      <td>
                <input type="text" id="I_BEGDA" name="I_BEGDA" class="date required" value="${f:printDate(I_BEGDA)}" size="10" placeholder="조회기간 시작일" onchange= "javascript:on_Blur(this);">
                &nbsp; ~
                <input type="text" id="I_ENDDA" name="I_ENDDA" class="date required" value="${f:printDate(I_ENDDA)}" size="10" placeholder="조회기간 종료일" >
            &nbsp;&nbsp;
            
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
		
            &nbsp;&nbsp;
        <div class="tableBtnSearch tableBtnSearch2">
        	<a href="javascript:after_listSetting()" class="search">
        		<span><spring:message code='BUTTON.COMMON.SEARCH'/><!--조회--></span></a>
        </div>
      </td>
    </tr>
  </table>
</div>
<div class="listArea">
	<div class="listTop">
		<span class="listCnt"  id="-result-cnt"><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(D12RotationBuildDetailData_vt)}' /><!--총 건--></span>
		<c:if test="${fn:length(D12RotationBuildDetailData_vt) > 0}">
		<div class="buttonArea">
		    <ul class="btn_mdl">
		        <li><a class="unloading" href="javascript:excelDown();" ><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
		    </ul>
		</div>
		</c:if>
	</div>
    <div class="wideTable" style="border-top: 2px solid #c8294b; height:360px; overflow:auto;">
        <table class="listTable tablesorter" >
            <thead>
            <tr>
                <th><input type="checkbox" id="checkAll" name="checkAll" onclick="checkAllChange()"/></th>
                <th style="min-width:95px;"><spring:message code="LABEL.D.D12.0017"/> <!-- 사원번호--></th>
                <th style="min-width:50px;"><spring:message code="LABEL.D.D12.0018"/> <!-- 이름--></th>
                <th style="min-width:95px;"><spring:message code="LABEL.D.D12.0078"/> <!-- 시작일자--></th>
                <th style="min-width:95px;"><spring:message code="LABEL.D.D12.0079"/> <!-- 종료일자--></th>
                <th style="min-width:25px;"><spring:message code="LABEL.D.D12.0067"/> <!-- 전일지시자--></th>
                <th style="min-width:80px;"><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
                <th style="min-width:80px;"><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
                <th style="min-width:80px;"><spring:message code="LABEL.D.D12.0068"/> <!-- 휴식시간1--></th>
                <th style="min-width:80px;"><spring:message code="LABEL.D.D12.0069"/> <!-- 휴식종료1--></th>
                <th style="min-width:80px;"><spring:message code="LABEL.D.D12.0070"/> <!-- 휴식시간2--></th>
                <th style="min-width:80px;"><spring:message code="LABEL.D.D12.0071"/> <!-- 휴식종료2--></th>
                <th><spring:message code="LABEL.D.D12.0072"/> <!-- 사유--></th>
                <th><spring:message code="LABEL.D.D12.0073"/> <!-- 초과근무(hr)--></th>
                <th><spring:message code="LABEL.D.D12.0074"/> <!-- 근무일정규칙--></th>
                <th><spring:message code="LABEL.D.D12.0075"/> <!-- 일일근무일정--></th>
                <th><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
                <th><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
                <th><spring:message code="LABEL.D.D12.0076"/> <!-- 근무시간--></th>
                <th class="lastCol"><spring:message code="LABEL.COMMON.0015"/> <!-- 비고--></th>
            </tr>
            </thead>
            <tbody id = "-listTable-body">
			<c:forEach var="row" items="${D12RotationBuildDetailData_vt}" varStatus="status">
			<tr  id="-pay-row-${status.index}" class="${f:printOddRow(status.index)}">
				<td><input type="checkbox" id="checkRow${status.index}" name="checkRow" value="${status.index}" class="-row-check" /></td>
				<c:choose>
				<c:when test="${f:printDate(row.BEGDA) != '' }">
					<td><input type="text" id="PERNR${status.index}" name="LIST_PERNR" value="${row.PERNR == '00000000' ? '' : row.PERNR}"  size="8" style="width:58px" readonly/>
						  <img src="${g.image}sshr/ico_magnify.png" />
					</td>
				</c:when>
				<c:otherwise>
					<td><input type="text" id="PERNR${status.index}" name="LIST_PERNR" value="${row.PERNR ==  '00000000' ? '' : row.PERNR}"  size="8" onkeydown="searchPerson(${status.index});" onChange="autoCheck(${status.index});" style="width:60px"/>
						  <a onclick="searchPerson(${status.index});" ><img src="${g.image}sshr/ico_magnify.png" /></a>
					</td>
				</c:otherwise>
				</c:choose>
				<td><input type="text" id="ENAME${status.index}" name="LIST_ENAME" value="${row.ENAME}" readonly size="10"  /></td>
				<td><input type="text" id="CBEGDA${status.index}" name="LIST_CBEGDA" value="${f:printDate(row.CBEGDA)}" class="date" size="10" style="width:65px;" onChange="javascript:getBegdaCheck(this, ${status.index}); autoCheck(${status.index});"/></td>
				<td><input type="text" id="CENDDA${status.index}" name="LIST_CENDDA" value="${f:printDate(row.CENDDA)}" class="date" size="10" style="width:65px;" onChange="autoCheck(${status.index});"/></td>
				<td><input type="checkbox" id="VTKENCB${status.index}" name="VTKEN" onclick="javascript:vtken_check(this);"  value="${row.VTKEN}" ${row.VTKEN == "X" ? "checked" : "" } onChange="autoCheck(${status.index});" size="2" />
					  <input type="hidden" id="VTKEN${status.index}" name="LIST_VTKEN" value="${row.VTKEN}"  />
				</td>
				<td><input type="text" id="BEGUZ${status.index}" name="LIST_BEGUZ" value="${(row.BEGUZ == row.ENDUZ && row.BEGUZ ==  '00:00:00') ? '' : row.BEGUZ}" size="6" class="timeRoBe" onBlur="timeCheck(this);" onChange="autoCheck(${status.index});" style="width:50px;" /></td>
				<td><input type="text" id="ENDUZ${status.index}" name="LIST_ENDUZ" value="${(row.BEGUZ == row.ENDUZ && row.ENDUZ ==  '00:00:00') ? '' : row.ENDUZ}" size="6" class="timeRoEn" onBlur="timeCheck(this);" onChange="autoCheck(${status.index});" style="width:50px;" /></td>
				<td><input type="text" id="PBEG1${status.index}" name="LIST_PBEG1" value="${(row.PBEG1 == row.PEND1 && row.PBEG1 ==  '00:00:00') ? '' : row.PBEG1}" size="6" class="timeRoBe" onBlur="timeCheck(this);" onChange="autoCheck(${status.index});" style="width:50px;" /></td>
				<td><input type="text" id="PEND1${status.index}" name="LIST_PEND1" value="${(row.PBEG1 == row.PEND1 && row.PEND1 ==  '00:00:00') ? '' : row.PEND1}" size="6" class="timeRoEn" onBlur="timeCheck(this);" onChange="autoCheck(${status.index});" style="width:50px;" /></td>
				<td><input type="text" id="PBEG2${status.index}" name="LIST_PBEG2" value="${(row.PBEG2 == row.PEND2 && row.PBEG2 ==  '00:00:00') ? '' : row.PBEG2}" size="6" class="timeRoBe" onBlur="timeCheck(this);" onChange="autoCheck(${status.index});" style="width:50px;" /></td>
				<td><input type="text" id="PEND2${status.index}" name="LIST_PEND2" value="${(row.PBEG2 == row.PEND2 && row.PEND2 ==  '00:00:00') ? '' : row.PEND2}" size="6" class="timeRoEn" onBlur="timeCheck(this);" onChange="autoCheck(${status.index});" style="width:50px;"/></td>
				<td><input type="text" id="REASON${status.index}" name="LIST_REASON" value="${row.REASON}" size="30" maxlength="30" onChange="autoCheck(${status.index});"/></td>
				<td><input type="text" id="OTTIM${status.index}" name="LIST_OTTIM" value="${f:printNumFormat(row.OTTIM, 2)}" size="3" style="align:center;" readonly/></td>
				<td><input type="text" id="RTEXT${status.index}" name="LIST_RTEXT" value="${row.RTEXT}" size="15" readonly /></td>
				<td><input type="text" id="TTEXT${status.index}" name="LIST_TTEXT" value="${row.TTEXT}" size="15" readonly /></td>
				<td><input type="text" id="SOBEG${status.index}" name="LIST_SOBEG" value="${row.SOBEG == '00:00:00' ? '' : row.SOBEG}"  size="7" readonly/></td>
				<td><input type="text" id="SOEND${status.index}" name="LIST_SOEND" value="${row.SOEND == '00:00:00' ? '' : row.SOEND}" size="7" readonly /></td>
				<td><input type="text" id="SOLLZ${status.index}" name="LIST_SOLLZ" value="${row.SOLLZ}" size="4" readonly/></td>
				<td nowrap class="lastCol"><input type="text" id="ZMSG${status.index}" name="LIST_ZMSG" value="${row.ZMSG}" size="30" readonly /></td>
				<input type="hidden" id="ZCHECK${status.index}"name="LIST_ZCHECK" value="" />
				<input type="hidden" id="SUBTY${status.index}"name="LIST_SUBTY" value="${row.SUBTY }" />
				<input type="hidden" id="OBJPS${status.index}"name="LIST_OBJPS" value="${row.OBJPS }" />
				<input type="hidden" id="SPRPS${status.index}"name="LIST_SPRPS" value="${row.SPRPS }" />
				<input type="hidden" id="SEQNR${status.index}"name="LIST_SEQNR" value="${row.SEQNR }" />
				<input type="hidden" id="INFTY${status.index}"name="LIST_INFTY" value="${row.INFTY}" />
				<input type="hidden" id="STDAZ${status.index}"name="LIST_STDAZ" value="${row.STDAZ}" />
				<input type="hidden" id="PBEZ1${status.index}"name="LIST_PBEZ1" value="${row.PBEZ1}" />
				<input type="hidden" id="PUNB1${status.index}"name="LIST_PUNB1" value="${row.PUNB1}" />
				<input type="hidden" id="PBEZ2${status.index}"name="LIST_PBEZ2" value="${row.PBEZ2}" />
				<input type="hidden" id="PUNB2${status.index}"name="LIST_PUNB2" value="${row.PUNB2}" />
				<input type="hidden" id="PBEG3${status.index}"name="LIST_PBEG3" value="${row.PBEG3}" />
				<input type="hidden" id="PEND3${status.index}"name="LIST_PEND3" value="${row.PEND3}" />
				<input type="hidden" id="PBEZ3${status.index}"name="LIST_PBEZ3" value="${row.PBEZ3}" />
				<input type="hidden" id="PUNB3${status.index}"name="LIST_PUNB3" value="${row.PUNB3}" />
				<input type="hidden" id="PBEG4${status.index}"name="LIST_PBEG4" value="${row.PBEG4}" />
				<input type="hidden" id="PEND4${status.index}"name="LIST_PEND4" value="${row.PEND4}" />
				<input type="hidden" id="PBEZ4${status.index}"name="LIST_PBEZ4" value="${row.PBEZ4}" />
				<input type="hidden" id="PUNB4${status.index}"name="LIST_PUNB4" value="${row.PUNB4}" />
				<input type="hidden" id="VERSL${status.index}"name="LIST_VERSL" value="${row.VERSL}" />
				<input type="hidden" id="AUFKZ${status.index}"name="LIST_AUFKZ" value="${row.AUFKZ}" />
				<input type="hidden" id="BWGRL${status.index}"name="LIST_BWGRL" value="${row.BWGRL}" />
				<input type="hidden" id="TRFGR${status.index}"name="LIST_TRFGR" value="${row.TRFGR}" />
				<input type="hidden" id="TRFST${status.index}"name="LIST_TRFST" value="${row.TRFST}" />
				<input type="hidden" id="PRAKN${status.index}"name="LIST_PRAKN" value="${row.PRAKN}" />
				<input type="hidden" id="PRAKZ${status.index}"name="LIST_PRAKZ" value="${row.PRAKZ}" />
				<input type="hidden" id="OTYPE${status.index}"name="LIST_OTYPE" value="${row.OTYPE}" />
				<input type="hidden" id="PLANS${status.index}"name="LIST_PLANS" value="${row.PLANS}" />
				<input type="hidden" id="EXBEL${status.index}"name="LIST_EXBEL" value="${row.EXBEL}" />
				<input type="hidden" id="HRSIF${status.index}"name="LIST_HRSIF" value="${row.HRSIF}" />
				<input type="hidden" id="WAERS${status.index}"name="LIST_WAERS" value="${row.WAERS}" />
				<input type="hidden" id="WTART${status.index}"name="LIST_WTART" value="${row.WTART}" />
				<input type="hidden" id="TDLANGU${status.index}"name="LIST_TDLANGU" value="${row.TDLANGU}" />
				<input type="hidden" id="TDSUBLA${status.index}"name="LIST_TDSUBLA" value="${row.TDSUBLA}" />
				<input type="hidden" id="TDTYPE${status.index}"name="LIST_TDTYPE" value="${row.TDTYPE}" />
				<input type="hidden" id="BEGDA${status.index}"name="LIST_BEGDA" value="${row.BEGDA}" />
				<input type="hidden" id="ENDDA${status.index}"name="LIST_ENDDA" value="${row.ENDDA}" />
				<input type="hidden" id="CPERNR${status.index}"name="LIST_CPERNR" value="${row.PERNR}" />
				<input type="hidden" id="CENAME${status.index}"name="LIST_CENAME" value="${row.ENAME}" />
				<input type="hidden" id="CVTKEN${status.index}"name="LIST_CVTKEN" value="${row.VTKEN}" />
				<input type="hidden" id="CBEGUZ${status.index}"name="LIST_CBEGUZ" value="${row.BEGUZ}" />
				<input type="hidden" id="CENDUZ${status.index}"name="LIST_CENDUZ" value="${row.ENDUZ}" />
				<input type="hidden" id="CPBEG1${status.index}"name="LIST_CPBEG1" value="${row.PBEG1}" />
				<input type="hidden" id="CPEND1${status.index}"name="LIST_CPEND1" value="${row.PEND1}" />
				<input type="hidden" id="CPBEG2${status.index}"name="LIST_CPBEG2" value="${row.PBEG2}" />
				<input type="hidden" id="CPEND2${status.index}"name="LIST_CPEND2" value="${row.PEND2}" />
				<input type="hidden" id="CREASON${status.index}"name="LIST_CREASON" value="${row.REASON}" />
			</tr>
			</c:forEach>
			</tbody>
			<tags-nodata-d:table-row-nodata-D list="${D12RotationBuildDetailData_vt}" col="20" />
		</table>
		<textarea id="template" style="display: none; top: -99999px; height: 0px; ">
			<tr  id="-pay-row-#idx#" class="borderRow">
				<td><input type="checkbox" id="checkRow#idx#" name="checkRow" value="" class="-row-check" checked/></td>
				<td><input type="text" id="PERNR#idx#" name="LIST_PERNR" value="${row.PERNR == '00000000' ? '' : row.PERNR}"  size="8" onkeydown="searchPerson(#idx#);" style="width:60px"/>
					  <a onclick="searchPerson(#idx#);" ><img src="${g.image}sshr/ico_magnify.png" /></a>
				</td>
				<td><input type="text" id="ENAME#idx#" name="LIST_ENAME" value="" readonly size="10"  /></td>
				<td><input type="text" id="CBEGDA#idx#" name="LIST_CBEGDA" value="" class="date" size="10" style="width:65px;" onChange="javascript:getBegdaCheck(this, #idx#);"/></td>
				<td><input type="text" id="CENDDA#idx#" name="LIST_CENDDA" value="" class="date" size="10" style="width:65px;" /></td>
				<td><input type="checkbox" id="VTKENCB#idx#" name="VTKEN" onclick="javascript:vtken_check(this);"  value="" ${row.VTKEN == "X" ? "checked" : "" } size="2" />
					  <input type="hidden" id="VTKEN#idx#" name="LIST_VTKEN" value=""  />
				</td>
				<td><input type="text" id="BEGUZ#idx#" name="LIST_BEGUZ" value="" size="6" class="timeRoBe" onBlur="timeCheck(this);" style="width:50px;" /></td>
				<td><input type="text" id="ENDUZ#idx#" name="LIST_ENDUZ" value="" size="6" class="timeRoEn" onBlur="timeCheck(this);" style="width:50px;" /></td>
				<td><input type="text" id="PBEG1#idx#" name="LIST_PBEG1" value="" size="6" class="timeRoBe" onBlur="timeCheck(this);" style="width:50px;" /></td>
				<td><input type="text" id="PEND1#idx#" name="LIST_PEND1" value="" size="6" class="timeRoEn" onBlur="timeCheck(this);" style="width:50px;" /></td>
				<td><input type="text" id="PBEG2#idx#" name="LIST_PBEG2" value="" size="6" class="timeRoBe" onBlur="timeCheck(this);" style="width:50px;" /></td>
				<td><input type="text" id="PEND2#idx#" name="LIST_PEND2" value="" size="6" class="timeRoEn" onBlur="timeCheck(this);" style="width:50px;"/></td>
				<td><input type="text" id="REASON#idx#" name="LIST_REASON" value="" size="30" /></td>
				<td><input type="text" id="OTTIM#idx#" name="LIST_OTTIM" value="" size="3" style="align:center;" readonly/></td>
				<td><input type="text" id="RTEXT#idx#" name="LIST_RTEXT" value="" size="15" readonly /></td>
				<td><input type="text" id="TTEXT#idx#" name="LIST_TTEXT" value="" size="15" readonly /></td>
				<td><input type="text" id="SOBEG#idx#" name="LIST_SOBEG" value="" size="7" readonly/></td>
				<td><input type="text" id="SOEND#idx#" name="LIST_SOEND" value="" size="7" readonly /></td>
				<td><input type="text" id="SOLLZ#idx#" name="LIST_SOLLZ" value="" size="4" readonly/></td>
				<td nowrap class="lastCol"><input type="text" id="ZMSG#idx#" name="LIST_ZMSG" value="" size="30" readonly /></td>
				<input type="hidden" id="ZCHECK#idx#"name="LIST_ZCHECK" value="" />
				<input type="hidden" id="SUBTY#idx#"name="LIST_SUBTY" value="" />
				<input type="hidden" id="OBJPS#idx#"name="LIST_OBJPS" value="" />
				<input type="hidden" id="SPRPS#idx#"name="LIST_SPRPS" value="" />
				<input type="hidden" id="SEQNR#idx#"name="LIST_SEQNR" value="" />
				<input type="hidden" id="INFTY#idx#"name="LIST_INFTY" value="" />
				<input type="hidden" id="STDAZ#idx#"name="LIST_STDAZ" value="" />
				<input type="hidden" id="PBEZ1#idx#"name="LIST_PBEZ1" value="" />
				<input type="hidden" id="PUNB1#idx#"name="LIST_PUNB1" value="" />
				<input type="hidden" id="PBEZ2#idx#"name="LIST_PBEZ2" value="" />
				<input type="hidden" id="PUNB2#idx#"name="LIST_PUNB2" value="" />
				<input type="hidden" id="PBEG3#idx#"name="LIST_PBEG3" value="" />
				<input type="hidden" id="PEND3#idx#"name="LIST_PEND3" value="" />
				<input type="hidden" id="PBEZ3#idx#"name="LIST_PBEZ3" value="" />
				<input type="hidden" id="PUNB3#idx#"name="LIST_PUNB3" value="" />
				<input type="hidden" id="PBEG4#idx#"name="LIST_PBEG4" value="" />
				<input type="hidden" id="PEND4#idx#"name="LIST_PEND4" value="" />
				<input type="hidden" id="PBEZ4#idx#"name="LIST_PBEZ4" value="" />
				<input type="hidden" id="PUNB4#idx#"name="LIST_PUNB4" value="" />
				<input type="hidden" id="VERSL#idx#"name="LIST_VERSL" value="" />
				<input type="hidden" id="AUFKZ#idx#"name="LIST_AUFKZ" value="" />
				<input type="hidden" id="BWGRL#idx#"name="LIST_BWGRL" value="" />
				<input type="hidden" id="TRFGR#idx#"name="LIST_TRFGR" value="" />
				<input type="hidden" id="TRFST#idx#"name="LIST_TRFST" value="" />
				<input type="hidden" id="PRAKN#idx#"name="LIST_PRAKN" value="" />
				<input type="hidden" id="PRAKZ#idx#"name="LIST_PRAKZ" value="" />
				<input type="hidden" id="OTYPE#idx#"name="LIST_OTYPE" value="" />
				<input type="hidden" id="PLANS#idx#"name="LIST_PLANS" value="" />
				<input type="hidden" id="EXBEL#idx#"name="LIST_EXBEL" value="" />
				<input type="hidden" id="HRSIF#idx#"name="LIST_HRSIF" value="" />
				<input type="hidden" id="WAERS#idx#"name="LIST_WAERS" value="" />
				<input type="hidden" id="WTART#idx#"name="LIST_WTART" value="" />
				<input type="hidden" id="TDLANGU#idx#"name="LIST_TDLANGU" value="" />
				<input type="hidden" id="TDSUBLA#idx#"name="LIST_TDSUBLA" value="" />
				<input type="hidden" id="TDTYPE#idx#"name="LIST_TDTYPE" value="" />
				<input type="hidden" id="BEGDA#idx#"name="LIST_BEGDA" value="" />
				<input type="hidden" id="ENDDA#idx#"name="LIST_ENDDA" value="" />
				<input type="hidden" id="CPERNR#idx#"name="LIST_CPERNR" value="" />
				<input type="hidden" id="CENAME#idx#"name="LIST_CENAME" value="" />
				<input type="hidden" id="CVTKEN#idx#"name="LIST_CVTKEN" value="" />
				<input type="hidden" id="CBEGUZ#idx#"name="LIST_CBEGUZ" value="" />
				<input type="hidden" id="CENDUZ#idx#"name="LIST_CENDUZ" value="" />
				<input type="hidden" id="CPBEG1#idx#"name="LIST_CPBEG1" value="" />
				<input type="hidden" id="CPEND1#idx#"name="LIST_CPEND1" value="" />
				<input type="hidden" id="CPBEG2#idx#"name="LIST_CPBEG2" value="" />
				<input type="hidden" id="CPEND2#idx#"name="LIST_CPEND2" value="" />
				<input type="hidden" id="CREASON#idx#"name="LIST_CREASON" value="" />
			</tr>
		</textarea>
	</div>

<div class="listTop">
	<div class="listTop_inner">
		<span class="textPink">*</span><spring:message code="MSG.D.D12.0029"/><br><!-- 전일지시자 : 야간조의 경우 전일부터 계속 근무하여 당일에 초과근무한 경우로, 초과근무는 전날로 평가되어 처리됩니다. -->
		<span class="textPink">*</span><spring:message code="MSG.D.D12.0030"/><br><!-- 저장시 에러 발생된 데이터에는 메세지가 표시됩니다. -->
		<span class="textPink">*</span><spring:message code="MSG.D.D12.0031"/><!-- 체크된 항목에 대하여 삭제나, 저장이 가능합니다. -->
	</div>
	<div class="buttonArea">
	    <ul class="btn_mdl">
	        <li><a href="javascript:;" onclick="addRow();"><span><spring:message code="BUTTON.COMMON.LINE.ADD"/></span></a></li>
	        <li><a href="javascript:;" onclick="deleteRow();"><span><spring:message code="BUTTON.COMMON.LINE.DELETE"/></span></a></li>
	    </ul>
	</div>
	<div class="buttonArea">
	    <ul class="btn_crud">
	            <li id="sc_button"><a class="darken" href="javascript:;" onclick="doSave();"><span><spring:message code="BUTTON.COMMON.SAVE"/></span></a></li>
	    </ul>
	</div>
	<div class="clear"> </div>
</div></div>

</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
