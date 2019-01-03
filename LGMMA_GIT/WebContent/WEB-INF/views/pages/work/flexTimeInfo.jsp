<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.lgmma.ess.common.util.Util"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="hris.D.D03Vocation.rfc.D03VocationAReasonRFC"%>
<%@ page import="hris.D.D03Vocation.D03VocationReasonData"%>
<%@ page import="hris.E.E19Congra.rfc.E19CongCodeRFC"%>

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
<c:if test="${param.FROM_ESS_OFW_WORK_TIME ne 'Y'}">
<!--// Page Title start -->
<div class="title">
	<h1>FlexTime</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">근태</a></span></li>
			<li class="lastLocation"><span><a href="#">FlexTime</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
</c:if>
<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this)" class="selected">FlexTime 신청</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this)">FlexTime 실적 조회</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
	<!--// Table start -->
	<form id="flexTimeForm">
	<div class="tableArea">
    	<h2 class="subtitle">FlexTime 신청</h2>
        <div class="buttonArea${TPGUB_CD ? '' : ' Lnodisplay'}">
            <ul class="btn_mdl">
                <li><a href="#" name="RADL-button"><span>신청/결재 기한</span></a></li>
            </ul>
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
					<input class="readOnly" type="text" name="BEGDA" value="<%=WebUtil.printDate(DataUtil.getCurrentDate(), ".")%>" id="BEGDA" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="input_radio01_1">근로시간 선택</label></th>
				<td>
					<ul class="tdRadioList">
						<li><input type="radio" name="SCHKZ_CD" value="1" id="SCHKZ_CD_1" data-start="070000" data-end="160000" /><label for="input_SCHKZ_CD_1">07:00 ~ 16:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="3" id="SCHKZ_CD_3" data-start="080000" data-end="170000" /><label for="input_SCHKZ_CD_3">08:00 ~ 17:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="7" id="SCHKZ_CD_7" data-start="090000" data-end="180000" /><label for="input_SCHKZ_CD_7">09:00 ~ 18:00</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="6" id="SCHKZ_CD_6" data-start="100000" data-end="190000" /><label for="input_SCHKZ_CD_6">10:00 ~ 19:00</label></li>
						</br>
						<li><input type="radio" name="SCHKZ_CD" value="2" id="SCHKZ_CD_2" data-start="073000" data-end="163000" /><label for="input_SCHKZ_CD_2">07:30 ~ 16:30</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="4" id="SCHKZ_CD_4" data-start="083000" data-end="173000" /><label for="input_SCHKZ_CD_4">08:30 ~ 17:30</label></li>
						<li><input type="radio" name="SCHKZ_CD" value="5" id="SCHKZ_CD_5" data-start="093000" data-end="183000" /><label for="input_SCHKZ_CD_5">09:30 ~ 18:30</label></li>
						<li style="width:220px;"><input type="radio" name="SCHKZ_CD" value="8" id="SCHKZ_CD_8" />
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
					<input type="text" id="FLEX_BEG" name="FLEX_BEG" size="15" vname="FLEX시작일" />
					<label for="FLEX_BEG">부터</label>
					<input type="text" id="FLEX_END" name="FLEX_END" size="15" vname="FLEX종료일" />
					<label for="FLEX_END">까지</label>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="REASON">신청 사유</label></th>
				<td>
					<input type="text" name="REASON" id="REASON" size="100" vname="신청사유" required />
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
	
	</form>
	<!--// Table end -->
	
	<!--// list start -->
	<div class="listArea" id="decisionerTab1"></div>
	<!--// list end -->
	
	<div class="buttonArea">
		<ul class="btn_crud">
		<c:if test="${selfApprovalEnable == 'Y'}">
			<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
		</c:if>
			<li><a href="#" id="requestFlexTimeBtn" class="darken" ><span>신청</span></a></li>
		</ul>
	</div>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
			<caption>FlexTime 실적조회</caption>
			<colgroup>
				<col class="col_10p" />
				<col class="col_90p" />

			</colgroup>
			<tbody>
				<tr>
					<th><label for="year">조회년도</label></th>
					<td>
						<select class="w90" id="year" name="year"> 
							<%= WebUtil.printOption(CodeEntity_vt, Integer.toString(endYear)) %>
						</select>
					</td>

				</tr>
			</tbody>
			</table>
		</div>
	</div>
	<!--// list start -->
	<div class="listArea">	
 <!-- flextime 실적조회 -->
		<div id="balSengListGrid"></div>
	</div>
	<!--// list end -->	
</div>
<!--// Tab2 end -->


<!-- popup : 월별 계획근무일정 start -->
<div class="layerWrapper layerSizeP" id="popLayerSchedule" style="display:none;">
	<div class="layerHeader">
		<strong>월별 계획근무일정</strong>
		<a href="#" class="btnClose popLayerSchedule_close">창닫기</a>
	</div>
</div>
<!-- popup : 월별 계획근무일정 end -->
<script type="text/javascript">

	// 플렉스타임 라디오버튼 이전 선택 값 전역변수
	var prevSelectedRadioValue = '';
	
	$(document).ready(function(){
		
		// 적용기간 datepicker
		$.setFlexDefaultDate();
		
		// flexttime selectbox init
		$.initTimeSelect();
		
		// flextime 신청 처리
		$("#requestFlexTimeBtn").click(function(){
			requestFlexTime(false);
		});
		
		$("#requestNapprovalBtn").click(function(){
			requestFlexTime(true);
		});
		
		
		
		$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=44&gridDivId=tab1ApplGrid');
		$("#tab1").bind("click", function(){
			$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=44&gridDivId=tab1ApplGrid');
		});
		$("#tab2").bind("click", function(){
			$("#balSengListGrid").jsGrid("search");
		});
		if('<%=tabId%>' == "1"){
			$("#tab1").click();
		}
		if('<%=tabId%>' == "2"){
			$("#tab2").click();
		}
		$attCancelHtml = $("#attCancelDiv").html();
		
		$.selectRadioTimeHandler();
		$.changeFlextimeBegdateHandler();
		$.changeBeginTimeHandler();
		$.changeBeginMinuteHandler();
	});
	
	$.initTimeSelect = function() {
		$('#begin_time').prop('disabled', true);
		$('#begin_minute').prop('disabled', true);
		
		var selectTime = $('#begin_time').val();
		if(selectTime == '10') {
			$('#begin_minute').val('30').prop('selected', true);
			$('#end_minute').val('30').prop('selected', true);
		}
		
		$.setEndTime();
	}
	
	$.setFlexDefaultDate = function() {
		// 적용시작일 - From SAP
		var eBegda = '${E_BEGDA}';
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
		
		$('#FLEX_BEG').datepicker()
			.datepicker("option", "minDate", eBegda)
			.datepicker("setDate", eBegda);
		$('#FLEX_END').datepicker()
			.datepicker("option", "minDate", eBegda);
			//.datepicker("setDate", new Date('12/31/' + (new Date()).getFullYear()));
	}
	
	$.makeFlexRequestTime = function() {
		$('#FLEX_BUZ').val($('#begin_time').val() + $('#begin_minute').val() + '00');
		$('#FLEX_EUZ').val($('#end_time').val() + $('#end_minute').val() + '00');
	}
	
	$.selectRadioTimeHandler = function() {
		$('[name=SCHKZ_CD]').click(function(e) {
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
			} else {
				if(prevSelectedRadioValue == '8') {
    				$('#begin_time').prop('disabled', true)
    							.find('option').eq(0).prop('selected', true);
    				$('#end_time').find('option').eq(10).prop('selected', true);
    				$('#begin_minute').prop('disabled', true)
								.find('option').eq(1).prop('selected', true);
    				$('#end_minute').find('option').eq(1).prop('selected', true);
				
    				$('#FLEX_END')
    					//.datepicker("setDate", new Date('12/31/' + (new Date()).getFullYear()))
    					.val('')
    					.datepicker("option", "disabled", false);
				}
				
				$('#FLEX_BUZ').val($(this).data('start'));
				$('#FLEX_EUZ').val($(this).data('end'));
				
				prevSelectedRadioValue = $(this).val();
			}
		});
	}
	
	$.changeFlextimeBegdateHandler = function() {
		$('#FLEX_BEG').change(function() {
			if(prevSelectedRadioValue == '8') {
				$('#FLEX_END').val($(this).val());
			}
		});
	}
	
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
	
	$ainf_seqn = "";
	$upmu_type = "";
	
	var getEduWorkCode = function(AWART) {
		var result = null;
	 	jQuery.ajax({
	 		type : 'POST',
	 		url : '/work/getEduWorkCode.json',
	 		cache : false,
	 		dataType : 'json',
	 		data : {
    		    "AWART" : AWART,
	 		    "PERNR" : $("#PERNR").val()
				},
	 		async :false,
	 		success : function(response) {
	 			if(response.success){
	 				result = response.storeData;
	 				//return response.storeData;
	 			}else{
	 				alert("신청사유코드 조회시 오류가 발생하였습니다. " + response.message);
	 			}
	 		}
	 	});
	 	return result;
	 };
	 
	 var getCongCode = function(AWART) {
		var result = null;
	 	jQuery.ajax({
	 		type : 'POST',
	 		url : '/work/getCongCode.json',
	 		cache : false,
	 		dataType : 'json',
	 		async :false,
	 		success : function(response) {
	 			if(response.success){
	 				result = response.storeData;
	 			}else{
	 				alert("신청사유코드 조회시 오류가 발생하였습니다. " + response.message);
	 			}
	 		}
	 	});
	 	return result;
	 };
	 	
	$("#year").change(function(){
		$("#balSengListGrid").jsGrid("search");
	});

	
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
							
							prevSelectedRadioValue = '';
							$.setFlexDefaultDate();
							$.initTimeSelect();
							
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
	
	// 휴가 발생 내역 그리드
	$(function() {
		$.fn.Rowspan = function(colIdx, isStats) {
			return this.each(function(){
				var that;
				$('tr', this).each(function(row) {
					$('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
						
						if ($(this).html() != '' && $(this).html() == $(that).html()
							&& (!isStats
									|| isStats && $(this).prev().html() == $(that).prev().html()
									)
							) {
							rowspan = $(that).attr("rowspan") || 1;
							rowspan = Number(rowspan)+1;

							$(that).attr("rowspan",rowspan);

							$(that).css('background-color', '#fff')
							$(this).hide();

						} else {
							that = this;
						}

						that = (that == null) ? this : that;
					});
				});
			});
		};
		
		$("#balSengListGrid").jsGrid({
	         height : "560px",
	         width : "100%",
	         sorting : false,
	         paging : false,
	         autoload : false,
	         controller : {
	             loadData : function() {
	                 var d = $.Deferred();
	                 $.ajax({
	                     type : "GET",
	                     url : "/work/getFlexTimeList.json",
	                     dataType : "json",
	                     data : {
	                    	 "year" : $("#year option:selected").val()
	                     }
	                 }).done(function(response) {
	                     if(response.success){
	                         d.resolve(response.storeData);
	                         
	                         $('.jsgrid-grid-body .jsgrid-table')
	                         		.Rowspan(12)
	                         		.Rowspan(11)
	                         		.Rowspan(10)
	                         		.Rowspan(9)
	                         		.Rowspan(8)
	                         		.Rowspan(7)
	                         		.Rowspan(6)
	                         		.Rowspan(5)
	                         		.Rowspan(4)
	                         		.Rowspan(3)
	                         		.Rowspan(2)
	                         		.Rowspan(1);
	                         		//.find('.jsgrid-row').each(function() { $(this).removeClass('jsgrid-row').addClass('jsgrid-alt-row') });
	                         
	                         $('.jsgrid-grid-header').css('overflow-y', 'scroll');
	                         $('.jsgrid-grid-body').css('overflow-y', 'scroll');
	                     }else{
	                         alert("조회시 오류가 발생하였습니다. " + response.message);
	                     }
	                 });
	                 return d.promise();
	             }
	         },
	         fields: [
	        		{ title: "구분", name: "ZDATE01", type: "text", align: "center", width: "5.2%",
	                     itemTemplate: function(value, item) {
	                    	 var day = Number(item.ZDATE01.substr(item.ZDATE01.length - 2, 2));
	                         return day + " 일";
	                     }
	                },
					{ title: "1월", name: "ZFLEXT01", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT01.split(' ').join('');
	                     }
	                },
					{ title: "2월", name: "ZFLEXT02", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT02.split(' ').join('');
	                     }
	                },
					{ title: "3월", name: "ZFLEXT03", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT03.split(' ').join('');
	                     }
	                },
					{ title: "4월", name: "ZFLEXT04", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT04.split(' ').join('');
	                     }
	                },
					{ title: "5월", name: "ZFLEXT05", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT05.split(' ').join('');
	                     }
	                },
					{ title: "6월", name: "ZFLEXT06", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT06.split(' ').join('');
	                     }
	                },
					{ title: "7월", name: "ZFLEXT07", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT07.split(' ').join('');
	                     }
	                },
					{ title: "8월", name: "ZFLEXT08", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT08.split(' ').join('');
	                     }
	                },
					{ title: "9월", name: "ZFLEXT09", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT09.split(' ').join('');
	                     }
	                },
					{ title: "10월", name: "ZFLEXT10", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT10.split(' ').join('');
	                     }
	                },
					{ title: "11월", name: "ZFLEXT11", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT11.split(' ').join('');
	                     }
	                },
					{ title: "12월", name: "ZFLEXT12", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT12.split(' ').join('');
	                     }
	                }
	         ]
	    });
	});



	
</script>