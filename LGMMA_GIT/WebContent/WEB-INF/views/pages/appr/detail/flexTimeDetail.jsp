<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@page import="com.lgmma.ess.common.util.Util"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="hris.D.D03Vocation.rfc.D03VocationAReasonRFC"%>
<%@ page import="hris.E.E19Congra.rfc.E19CongCodeRFC"%>
<%@ page import="hris.D.D03Vocation.D03VocationReasonData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
	String tabId = (String)request.getAttribute("TAB_ID");
	
	Vector CodeEntity_vt = new Vector();
	int endYear = Integer.parseInt( DataUtil.getCurrentYear() );
	for( int i = endYear-9 ; i <= endYear+1 ; i++ ){
		CodeEntity entity = new CodeEntity();
		entity.code  = Integer.toString(i);
		entity.value = Integer.toString(i);
		CodeEntity_vt.addElement(entity);
	}

	String curDate = DataUtil.getCurrentDate();
	
	String yyyymm =   DataUtil.getAfterMonth(curDate, 1).substring(0, 6); // 다음달 yyyymm
	
	String yyyymm1 = DataUtil.getAfterMonth(curDate, 1).substring(0, 6); // 1개월뒤 yyyymm1
	String yyyymm2 = DataUtil.getAfterMonth(curDate, 2).substring(0, 6); // 2개월뒤 yyyymm1
	String yyyymm3 = DataUtil.getAfterMonth(curDate, 3).substring(0, 6); // 3개월뒤 yyyymm1

	String toDate1 = DataUtil.getLastDay(yyyymm1.substring(0,4) ,yyyymm1.substring(4,6) ,1 ) ; //1개월뒤 yyyymmdd
	String toDate2 = DataUtil.getLastDay(yyyymm2.substring(0,4) ,yyyymm2.substring(4,6) ,1 ) ; //1개월뒤 yyyymmdd
	String toDate3 = DataUtil.getLastDay(yyyymm3.substring(0,4) ,yyyymm3.substring(4,6) ,1 ) ; //1개월뒤 yyyymmdd
	
	String fromDate = yyyymm + "01";
	fromDate = Util.convertDateStrFormat(fromDate, Util.Ymd, Util.YmdFmt);
	toDate1 = Util.convertDateStrFormat(toDate1, Util.Ymd, Util.YmdFmt);
	toDate2 = Util.convertDateStrFormat(toDate2, Util.Ymd, Util.YmdFmt);
	toDate3 = Util.convertDateStrFormat(toDate3, Util.Ymd, Util.YmdFmt);
	
	
%>

<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
	<!--// Table start -->
	<form id="detailForm">
	<div class="tableArea">
	<h2 class="subtitle">FlexTime 신청</h2>
	<div class="buttonArea">

	</div>
		<div class="table">
			<table class="tableGeneral">
			<caption>FlexTime 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_85p"/>
				
			</colgroup>
			<tbody>
			<tr>
				<th><label for="inputText01-1">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" name="BEGDA" id="BEGDA" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="input_radio01_1">근로시간 선택</label></th>
				<td>
					<ul class="tdRadioList">
						<li><input type="radio" name="SCHKZ_CD" value="1" id="SCHKZ_CD_1" disabled /><label for="input_SCHKZ_CD_1">07:00 ~ 16:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="3" id="SCHKZ_CD_3" disabled/><label for="input_SCHKZ_CD_3">08:00 ~ 17:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="7" id="SCHKZ_CD_7" disabled/><label for="input_SCHKZ_CD_7">09:00 ~ 18:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="6" id="SCHKZ_CD_6" disabled/><label for="input_SCHKZ_CD_6">10:00 ~ 19:00</label></li>
						</br>
						<li><input type="radio" name="SCHKZ_CD" value="2" id="SCHKZ_CD_2" disabled/><label for="input_SCHKZ_CD_2">07:30 ~ 16:30</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="4" id="SCHKZ_CD_4" disabled/><label for="input_SCHKZ_CD_4">08:30 ~ 17:30</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="5" id="SCHKZ_CD_5" disabled/><label for="input_SCHKZ_CD_5">09:30 ~ 18:30</label></li>
						<li style="width:220px;"><input type="radio" name="SCHKZ_CD" value="8" id="SCHKZ_CD_8" disabled />
							<label for="input_SCHKZ_CD_8">
								<select id="begin_time" disabled>
									<c:set var="timeRange" value="${fn:split('0,1,2,3,4,5,6,10,11,12,13,14,15,16,17,18,19,20,21,22,23', ',')}" scope="application" />
									<c:forEach var="tm" items="${timeRange}">
										<fmt:formatNumber value="${tm}" pattern="00" var="tmConvert" />
										<option value="${tmConvert}">${tmConvert}</option>
									</c:forEach>
								</select>
								<select id="begin_minute" disabled>
									<option value="00">00</option>
									<option value="30">30</option>
								</select>
								~
								<select id="end_time" disabled>
									<c:set var="n" value="0" />
									<c:forEach begin="0" end="23">
										<fmt:formatNumber value="${n}" pattern="00" var="nConvert" />
										<option value="${nConvert}">${nConvert}</option>
										<c:set var="n" value="${n+1}" />
									</c:forEach>
								</select>
								<select id="end_minute" disabled>
									<option value="00">00</option>
									<option value="30">30</option>
								</select>
							</label>
						</li>
					</ul>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputDateFrom">적용기간</label></th>
				<td>
				    &nbsp;&nbsp;신청 기간 :  
					<input type="text" id="FLEX_BEG" name="FLEX_BEG" size="15" vname="FLEX시작일" readonly />
					~
					<input type="text" id="FLEX_END" name="FLEX_END" size="15" vname="FLEX종료일" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="REASON">신청 사유</label></th>
				<td>
					<input class="readOnly" type="text" name="REASON" id="REASON" size="100" vname="신청사유" required readOnly />
				</td>
			</tr>



			</tbody>
			</table>
		</div>

	</div>
	<input type="hidden" id="AWART"       name="AWART" />
	<input type="hidden" id="DEDUCT_DATE" name="DEDUCT_DATE" />

	<input type="hidden" id="OVTM_CODE"   name="OVTM_CODE"  />
	<input type="hidden" id="BEGUZ"       name="BEGUZ" />
	<input type="hidden" id="ENDUZ"       name="ENDUZ" />
	<input type="hidden" name="timeopen"  id="timeopen" />  
	
	<input type="hidden" name="FLEX_BUZ"  id="FLEX_BUZ" />  
	<input type="hidden" name="FLEX_EUZ"  id="FLEX_EUZ" />  
	<input type="hidden" id="AINF_SEQN"        name="AINF_SEQN" />
	
	</form>
	<!--// Table end -->
	

	

</div>
<!--// Tab1 end -->



<!-- popup : 월별 계획근무일정 end -->
<script type="text/javascript">
	
	$.setFreetimeSelectbox = function() {
		var flexBuz = $('#FLEX_BUZ').val().split(':');
		var flexEuz = $('#FLEX_EUZ').val().split(':');
		
		$('#begin_time').val(flexBuz[0]).prop('selected', true);
		$('#begin_minute').val(flexBuz[1]).prop('selected', true);
		$('#end_time').val(flexEuz[0]).prop('selected', true);
		$('#end_minute').val(flexEuz[1]).prop('selected', true);
	}
	
	var detailSearch = function() {

		$.ajax({
			type : "get",
			url : "/appl/getFlexTimeDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item.flexTimeData, "detailForm");
			
			if($("input:radio[name='SCHKZ_CD']").filter(":checked").val() == '8') {
				$.setFreetimeSelectbox();
			}
			
			console.log(item);
		}
	}
	
	$(document).ready(function(){

		detailSearch();
		
		// 휴가 신청 처리
		$("#requestFlexTimeBtn").click(function(){
			requestFlexTime(false);
		});
		//$("#requestNapprovalBtn").click(function(){
		//	requestVacation(true);
		//});
		
		$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=44&gridDivId=tab1ApplGrid');
		$attCancelHtml = $("#attCancelDiv").html();
	});

	var reqDeleteActionCallBack = function(){
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteFlexTime',
				cache : false,
				dataType : 'json',
				data : param,
				async : false,
				success : function(response) {
					if(response.success) {
						alert("삭제되었습니다.");
						$('#applDetailArea').html('');
						$("#reqApplGrid").jsGrid("search");
					} else {
						alert("삭제시 오류가 발생하였습니다. " + response.message);
					}
					$("#reqDeleteBtn").prop("disabled", false);
				}
			});
		}
	}
	
	var requestFlexTime = function(self) {
		if(requestFlexTimeChk()){
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			tab1ApplGridChangeAppLine(self);
			if(confirm(msg + "신청 하시겠습니까?")){
				$("#requestVacationBtn").prop("disabled", true);
				$("#requestNapprovalBtn").prop("disabled", true);
				
				var param = $("#flexTimeForm").serializeArray();
				$("#tab1ApplGrid").jsGrid("serialize", param);
				param.push({"name":"selfAppr", "value" : self});
				jQuery.ajax({
					type : 'POST',
					url : '/work/requestFlexTime.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							$("#flexTimeForm").each(function() {
								this.reset();
							});
							$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=44&gridDivId=tab1ApplGrid');
							
						}else{
							alert("신청시 오류가 발생하였습니다. \n\n" + response.message);
						}
						$("#requestFlexTimeBtn").prop("disabled", false);
						$("#requestNapprovalBtn").prop("disabled", false);
					}
				});
			} else {
				tab1ApplGridChangeAppLine(false);
			}
		}
	}
	
	var requestFlexTimeChk = function(){

		return true;
	}
	
	
	var reqModifyActionCallBack = function(){
		
		$("input:radio[name='SCHKZ_CD']").removeClass('readOnly').prop("disabled",false);
		$("#FLEX_MON").removeClass('readOnly').prop("disabled",false);
		$("#REASON").removeClass('readOnly').prop("readOnly",false);
	}

	var reqCancelActionCallBack = function(){
		$("#detailForm").each(function(){
			this.reset();
		});
		
		detailSearch();

		$("input:radio[name='SCHKZ_CD']").addClass('readOnly').prop("disabled",true);
		$("#FLEX_MON").addClass('readOnly').prop("readOnly",true);
		$("#REASON").addClass('readOnly').prop("readOnly",true);
		
	}
	
	var reqSaveActionCallBack = function(){
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(requestFlexTimeChk()){
			if(confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateFlexTime',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
					success : function(response) {
						if(response.success) {
							alert("저장되었습니다.");
							$('#applDetailArea').html('');
							$("#reqApplGrid").jsGrid("search");
							return true;
						} else {
							alert("저장시 오류가 발생하였습니다. \n\n" + response.message);
							return false;
						}
						$("#reqSaveBtn").prop("disabled", false);
					}
				});
				
			}
		}
	}
	
	
</script>