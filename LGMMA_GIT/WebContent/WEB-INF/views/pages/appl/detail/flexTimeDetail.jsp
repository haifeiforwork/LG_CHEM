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
						<li><input type="radio" name="SCHKZ_CD" value="1" id="SCHKZ_CD_1" data-start="070000" data-end="160000" disabled/><label for="input_SCHKZ_CD_1">07:00 ~ 16:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="3" id="SCHKZ_CD_3" data-start="080000" data-end="170000" disabled/><label for="input_SCHKZ_CD_3">08:00 ~ 17:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="7" id="SCHKZ_CD_7" data-start="090000" data-end="180000" disabled/><label for="input_SCHKZ_CD_7">09:00 ~ 18:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="6" id="SCHKZ_CD_6" data-start="100000" data-end="190000" disabled/><label for="input_SCHKZ_CD_6">10:00 ~ 19:00</label></li>
						</br>
						<li><input type="radio" name="SCHKZ_CD" value="2" id="SCHKZ_CD_2" data-start="073000" data-end="163000" disabled/><label for="input_SCHKZ_CD_2">07:30 ~ 16:30</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="4" id="SCHKZ_CD_4" data-start="083000" data-end="173000" disabled/><label for="input_SCHKZ_CD_4">08:30 ~ 17:30</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="5" id="SCHKZ_CD_5" data-start="093000" data-end="183000" disabled/><label for="input_SCHKZ_CD_5">09:30 ~ 18:30</label></li>
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
									<option value="30" selected>30</option>
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
									<option value="30" selected>30</option>
								</select>
							</label>
						</li>
					</ul>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputDateFrom">적용기간</label></th>
				<td>
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

	var prevSelectedRadioValue = '';
	
	// 자유선택시간 셀렉트박스 기본 셋팅
	$.setFreetimeSelectbox = function() {
		var flexBuz = $('#FLEX_BUZ').val().split(':');
		var flexEuz = $('#FLEX_EUZ').val().split(':');
		
		$('#begin_time').val(flexBuz[0]).prop('selected', true);
		$('#begin_minute').val(flexBuz[1]).prop('selected', true);
		$('#end_time').val(flexEuz[0]).prop('selected', true);
		$('#end_minute').val(flexEuz[1]).prop('selected', true);
	}
	
	// 자유선택시간 form전송 값 구성
	$.makeFlexRequestTime = function() {
		$('#FLEX_BUZ').val($('#begin_time').val() + $('#begin_minute').val() + '00');
		$('#FLEX_EUZ').val($('#end_time').val() + $('#end_minute').val() + '00');
	}
	
	// 시간선택 라디오버튼 핸들러
	$.selectRadioTimeHandler = function() {
		$('[name=SCHKZ_CD]').click(function(e) {
			// 자유시간 선택시
			if($(this).is(':checked') && $(this).val() == '8') {
				if(prevSelectedRadioValue != '8') {
    				$('#begin_time').prop('disabled', false);
    				$('#begin_minute').prop('disabled', false);
				
    				$('#FLEX_END')
						.val($('#FLEX_BEG').val())
						.datepicker("option", "disabled", true);
				}
				
				$.makeFlexRequestTime();
				
				prevSelectedRadioValue = $(this).val();
			// 고정시간 선택시
			} else {
				if(prevSelectedRadioValue == '8') {
    				$('#begin_time').prop('disabled', true)
    							.find('option').eq(0).prop('selected', true);
    				$('#end_time').find('option').eq(10).prop('selected', true);
    				$('#begin_minute').prop('disabled', true)
								.find('option').eq(1).prop('selected', true);
    				$('#end_minute').find('option').eq(1).prop('selected', true);
    				
    				$('#FLEX_END')
    					.datepicker("setDate", new Date('12/31/' + (new Date()).getFullYear()))
						.datepicker("option", "disabled", false);
				}
				
				$('#FLEX_BUZ').val($(this).data('start'));
				$('#FLEX_EUZ').val($(this).data('end'));
				
				prevSelectedRadioValue = $(this).val();
			}
		});
	}
	
	// 자유시간 선택시 종료시각 자동 셋팅
	$.setEndTime = function() {
		var start_time = $('#begin_time').val();
		var end_time = parseInt(start_time, 10) + 9;
		
		if(end_time < 10) {
			end_time = '0' + end_time;
		} else if (end_time > 23) {
			end_time = end_time - 24;
			end_time = '0' + end_time;
		}
		
		$('#end_time').val(end_time).prop('selected', true);
	}
	
	// 자유시간 선택시 시작일따라 자동으로 종료일 셋팅
	$.changeFlextimeBegdateHandler = function() {
		$('#FLEX_BEG').change(function() {
			if(prevSelectedRadioValue == '8') {
				$('#FLEX_END').val($(this).val());
			}
		});
	}
	
	// 자유시간 선택시 시작시간 변경 핸들러
	$.changeBeginTimeHandler = function() {
		$('#begin_time').change(function() {
			var selectTime = $(this).val();
			if(selectTime == '10') {
				$('#begin_minute').val('30').prop('selected', true);
				$('#end_minute').val('30').prop('selected', true);
			}
			
			$.setEndTime();
			$.makeFlexRequestTime();
		});
	}
	
	// 자유시간 선택시 시작분 변경 핸들러
	$.changeBeginMinuteHandler = function() {
		$('#begin_minute').change(function() {
			var startTime = $('#begin_time').val();
			if(startTime == '10') {
				$(this).val('30').prop('selected', true);
			}
			
			$('#end_minute').val($(this).val()).prop('selected', true);
			
			$.makeFlexRequestTime();
		});
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
			} else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item.flexTimeData, "detailForm");
			
			prevSelectedRadioValue = $("input:radio[name='SCHKZ_CD']").filter(":checked").val();
			if(prevSelectedRadioValue == '8') {
				$.setFreetimeSelectbox();
			}
			
			// 적용일자 셋팅(시작일)
			var eBegda = item.eBegda;
			if(eBegda == null || eBegda == '') {
				eBegda = new Date();
			} else if(eBegda.indexOf('.') > -1) {
				eBegda = eBegda.split('.').join('-');
				eBegda = new Date(eBegda);
			} else if(eBegda.indexOf('-') > -1) {
				eBegda = new Date(eBegda);
			} else {
				eBegda = new Date();
			}
			
			$('#FLEX_BEG')
				.datepicker()
				.datepicker("option", "minDate", eBegda)
				.datepicker("option", "disabled", true);
			$('#FLEX_END')
				.datepicker()
				.datepicker("option", "minDate", eBegda)
				.datepicker("option", "disabled", true);
		}
	};
	
	$(document).ready(function(){

		detailSearch();
		
		// Flextime 신청 처리
		$("#requestFlexTimeBtn").click(function(){
			requestFlexTime(false);
		});
		//$("#requestNapprovalBtn").click(function(){
		//	requestVacation(true);
		//});
		
		$.selectRadioTimeHandler();
		$.changeFlextimeBegdateHandler();
		$.changeBeginTimeHandler();
		$.changeBeginMinuteHandler();
		
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
				
				$('#FLEX_END').datepicker("option", "disabled", false);
				
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
		var radioCheck = $("input:radio[name='SCHKZ_CD']").filter(":checked").val();
		var begDateCheck = $("#FLEX_BEG").val();  
		var endDateCheck = $("#FLEX_END").val();  
		var reasonCheck = $("#REASON").val();
		
		if(radioCheck == undefined || radioCheck == ""){
			alert("근로시간을 선택해 주세요.");
			return false;
		}
		if(begDateCheck == "" || endDateCheck == ""){
			alert("적용기간을 선택해 주세요.");
			return false;
		}
		if(reasonCheck == ""){
			alert("신청 사유를 입력해 주세요.");
			return false;
		}

		return true;
	}
	
	var reqModifyActionCallBack = function(){
		$("input:radio[name='SCHKZ_CD']").removeClass('readOnly').prop("disabled",false);
		$("#REASON").removeClass('readOnly').prop("readOnly",false);
		
		if($("input:radio[name='SCHKZ_CD']").filter(":checked").val() == '8') {
			$('#begin_time').prop('disabled', false);
			$('#begin_minute').prop('disabled', false);
		} else {
			$('#FLEX_END').prop('readOnly', false).datepicker("option", "disabled", false);
		}
		
		$('#FLEX_BEG').prop('readOnly', false).datepicker("option", "disabled", false);
	}

	var reqCancelActionCallBack = function(){
		$("#detailForm").each(function(){
			this.reset();
		});
		
		detailSearch();
		
		// 자유선택 시간 selectbox setting
		if($("input:radio[name='SCHKZ_CD']").filter(":checked").val() == '8') {
			$.setFreetimeSelectbox();
		}

		$("input:radio[name='SCHKZ_CD']").addClass('readOnly').prop("disabled",true);
		$("#REASON").addClass('readOnly').prop("readOnly",true);
		
		$('#begin_time').prop('disabled', true);
		$('#begin_minute').prop('disabled', true);
		$('#FLEX_BEG').prop('readOnly', true).datepicker("option", "disabled", true);
		$('#FLEX_END').prop('readOnly', true).datepicker("option", "disabled", true);
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
				
				$('#FLEX_END').datepicker("option", "disabled", false);
				
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