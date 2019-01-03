<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hris.E.E34Body.rfc.E34BodyTrainEntRFC" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="tableArea">
	<h2 class="subtitle">체력단련비 상세내역</h2>
	<div class="table">
		<form id="detailForm">
		<table class="tableGeneral">
			<caption>체력단련비 상세내역</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="detailBegda">신청일</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailDayIn">이용일</label></th>
				<td colspan="3" class="tdDate">
					<input class="datepicker readOnly" type="text" id="detailDayIn" name="DAY_IN" readonly />
					~
					<input class="datepicker readOnly" type="text" id="detailDayOut" name="DAY_OUT" readonly />
					<input class="readOnly w80" type="text" id="detailTrvlGign" name="TRVL_GIGN" readonly />
					<input type="hidden" id="detailDayUse" name="DAY_USE" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailNameGym">이용업체</label></th>
				<td>
					<input class="readOnly w150" type="text" id="detailNameGym" name="NAME_GYM" readonly />
				</td>
				<th><span class="textPink">*</span><label for="detailJomokName">종목</label></th>
				<td colspan="3">
					<select class="readOnly" id="detailJomokCd" name="JOMOK_CD" OnChange="checkEtc()" vname="종목" disabled >
						<option value="">--------</option>
						<%= WebUtil.printOption((new E34BodyTrainEntRFC()).getCodeType()) %>
					</select>
					<input type="text" id="detailJomokTx" name="JOMOK_TX" style="display:none" >
					<input type="hidden" id="detailJomokName" name="JOMOK_NAME" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailMoney">신청금액</label></th>
				<td>
					<input class="inputMoney readOnly w150" type="text" id="detailMoney" name="MONEY" readonly onkeyup="cmaComma(this);" onchange="cmaComma(this);" />
				</td>
				<th><span class="textPink">*</span><label for="detailDateCard">결제일</label></th>
				<td>
					<input class="readOnly w150" type="text" id="detailDateCard" name="DATE_CARD" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="detailMethod1">결제구분</label></th>
				<td colspan="3">
					<input type="radio" id="detailMethod1" name="METHOD" value="1" disabled /><label for="detailMethod1">개인카드</label>
					<input type="radio" id="detailMethod2" name="METHOD" value="2" disabled /><label for="detailMethod2">기타</label>
					<input class="readOnly w80" type="text" id="detailMethodBigo" name="METHOD_BIGO" >
				</td>
<!-- 
	2017.05.17 카드번호 제거 (김재만부장 요청)
				<th><label for="inputText02-6">카드번호</label></th>
				<td>
					<input class="readOnly w150" type="text" id="detailNumberCard" name="NUMBER_CARD" readonly />
				</td>
 -->
			</tr>
			</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
		</form>
	</div>
</div>

<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getHealthTrainDetail.json",
			dataType : "json",
			data : { "AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>' }
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				$("#detailMoney").val(insertComma(parseInt( $("#detailMoney").val() ).toString()));
				
				$("#detailTrvlGign").val( response.storeData.DAY_USE == "" ? response.storeData.DAY_USE : "(" + response.storeData.DAY_USE + ")" );
			}
			else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
		}
	}
	
	$(document).ready(function(){
		detailSearch();
	});
	
	var checkEtc = function(){
		$("#detailJomokName").val($("#detailJomokCd option:selected").text());
		
		if( "12" == $("#detailJomokCd").val() ){
			$("#detailJomokTx").val("");
			$("#detailJomokTx").show();
		}else{
			
			$("#detailJomokTx").hide();
		}
	}
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		$("#detailDayIn").removeClass("readOnly").prop("readOnly",false).datepicker({
			defaultDate: "+1w",
			onClose: function( selectedDate ) {
				$("#detailDayOut").datepicker( "option", "minDate", selectedDate );
			}
		});
		$("#detailDayOut").removeClass("readOnly").prop("readOnly",false).datepicker({
			defaultDate: "+1w",
			onClose: function( selectedDate ) {
				$("#detailDayIn").datepicker( "option", "maxDate", selectedDate );
			}
		});
		$("#detailNameGym").removeClass("readOnly").prop("readOnly",false);
		$("#detailJomokCd").removeClass("readOnly").prop("disabled",false);
		$("#detailMoney").removeClass("readOnly").prop("readOnly",false);
		$("#detailDateCard").removeClass("readOnly").prop("readOnly",false);
		$("#detailMethod1").removeClass("readOnly").prop("disabled",false);
		$("#detailMethod2").removeClass("readOnly").prop("disabled",false);
		$("#detailMethodBigo").removeClass("readOnly").prop("readOnly",false);
		//$("#detailNumberCard").removeClass("readOnly").prop("readOnly",false);
		
	}
	
	
	// 삭제 버튼 클릭
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
				url : '/appl/deleteHealthTrain',
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
	
	
	// 취소(수정 취소) 버튼 클릭
	var reqCancelActionCallBack = function(){
		$("#detailForm").each(function(){
			this.reset();
		});
		detailSearch();
		
		$("#detailDayIn").addClass("readOnly").prop("readOnly",true);
		$("#detailDayOut").addClass("readOnly").prop("readOnly",true);
		$("#detailNameGym").addClass("readOnly").prop("readOnly",true);
		$("#detailJomokCd").addClass("readOnly").prop("disabled",true);
		$("#detailMoney").addClass("readOnly").prop("readOnly",true);
		$("#detailDateCard").addClass("readOnly").prop("readOnly",true);
		$("#detailMethod1").addClass("readOnly").prop("disabled",true);
		$("#detailMethod2").addClass("readOnly").prop("disabled",true);
		$("#detailMethodBigo").addClass("readOnly").prop("readOnly",true);
		//$("#detailNumberCard").addClass("readOnly").prop("readOnly",true);
		
		destroydatepicker("detailForm");
	}
	
	
	var updateHealthCheck = function(){
/* 		
		if( $("input:radio[name='METHOD']").filter(":checked").val() == "1" ){
			if( !isCardNumber($("#detailNumberCard").val()) ) {
				alert("카드번호를 정확히 입력하세요.");
				$("#detailNumberCard").focus();
				return false;
			}
		}
 */		
		if( "12" == $("#detailJomokCd").val() ){
			if("" == $("#detailJomokTx").val()){
				alert("종목값을 직접 입력하세요");
				$("#detailJomokTx").focus();
				return false;
			}
		}
		
		if( ($("#detailDayIn").val() != "") && ($("#detailDayOut").val() != "") ){
			var begd  = removePoint($("#detailDayIn").val());
			var endd  = removePoint($("#detailDayOut").val());
			var cardd = removePoint($("#detailDateCard").val());
			var diff  = parseInt(endd) - parseInt(begd);
			var difc  = parseInt(cardd) - parseInt(begd);
			
			$("#detailTrvlGign").val("");
			$("#detailDayUse").val("");
			
			if (diff >0) {
				bday = new Date(begd.substring(0,4),begd.substring(4,6)-1,begd.substring(6,8));
				eday = new Date(endd.substring(0,4),endd.substring(4,6)-1,endd.substring(6,8));
				cday = new Date(cardd.substring(0,4),cardd.substring(4,6)-1,cardd.substring(6,8));
				var betday     = getDayInterval(bday,eday);
				var betcardday = getDayInterval(bday,cday);
				
				$("#detailTrvlGign").val(betday);
				$("#detailDayUse").val(betday);
				// 1년 넘게 신청 할 경우 alert
				if($("#detailTrvlGign").val() > 365){
					alert("신청기간은 1년을 넘을 수 없습니다.");
					return false;
				}
				
				if ( betcardday > 8 ){
					alert("시작일은 결제일의 7일전까지만 가능합니다. \n 현재는 결제일의 " + (betcardday+1) + "일 전입니다. 다시 한번 확인하세요. ");
					$("#detailDayIn").focus();
					return false;  
				}
			}
		}
		
		return true;
	}
	
	$("#detailDayIn, #detailDayOut").change(function(){
		
		if( ($("#detailDayIn").val() != "") && ($("#detailDayOut").val() != "") ){
			var begd  = removePoint($("#detailDayIn").val());
			var endd  = removePoint($("#detailDayOut").val());
			var diff  = parseInt(endd) - parseInt(begd);
			
			$("#detailTrvlGign").val("");
			$("#detailDayUse").val("");
			
			if (diff >0) {
				bday = new Date(begd.substring(0,4),begd.substring(4,6)-1,begd.substring(6,8));
				eday = new Date(endd.substring(0,4),endd.substring(4,6)-1,endd.substring(6,8));
				var betday     = getDayInterval(bday,eday);
				
				$("#detailTrvlGign").val("("+ parseInt(betday-1) +")");
				$("#detailDayUse").val(parseInt(betday-1));
				
			}
		}
	});
	
	function getDayInterval(date1,date2){
		var day = 1000 * 3600 *24 
		return parseInt((date2-date1)/day,10)+1;
	}
		
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(updateHealthCheck()){
			if(confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				$("#detailMoney").val( parseInt($("#detailMoney").val() == "" ? "0" : removeComma($("#detailMoney").val() ) ) );
				
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateHealthTrain',
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
							alert("저장시 오류가 발생하였습니다. " + response.message);
							return false;
						}
						$("#reqSaveBtn").prop("disabled", false);
					}
				});
			}
		}
	}
	
</script>