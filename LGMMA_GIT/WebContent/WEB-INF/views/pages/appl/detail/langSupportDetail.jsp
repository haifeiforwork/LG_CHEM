<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hris.C.C07Language.rfc.C07StudTypeRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="tableArea">
	<h2 class="subtitle">어학지원내역 상세</h2>
	<div class="table">
	<form id="detailForm">
		<table class="tableGeneral">
		<caption>신청서 신청</caption>
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
			<th><span class="textPink">*</span><label for="detailSbegDate">학습시작일</label></th>
			<td class="tdDate">
				<input class="datepicker readOnly" type="text" size="5" id="detailSbegDate" name="SBEG_DATE" readonly />
			</td>
			<th><span class="textPink">*</span><label for="detailSendDate">학습종료일</label></th>
			<td class="tdDate">
				<input class="datepicker readOnly" type="text" size="5" id="detailSendDate" name="SEND_DATE" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailStudText">학습형태</label></th>
			<td>
				<select class="w150 readOnly" id="detailStudType" name="STUD_TYPE" vname="학습형태" disabled >
					<option value="">-----------------</option>
					<%= WebUtil.printOption((new C07StudTypeRFC()).getDetail()) %>
				</select>
			</td>
			<th><label for="detailLectTime">수강시간</label></th>
			<td><input class="readOnly w100" type="text" id="detailLectTime" name="LECT_TIME" readonly /></td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailStudInst">학습기관</label></th>
			<td colspan="3">
				<input class="readOnly wPer" type="text" id="detailStudInst" name="STUD_INST" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailLectSbjt">수강과목</label></th>
			<td colspan="3">
				<input class="readOnly wPer" type="text" id="detailLectSbjt" name="LECT_SBJT" readonly />
			</td>
		</tr>	
		<tr>
			<th><span class="textPink">*</span><label for="SELT_GUBN">결제구분</label></th>
			<td>
				<input type="radio" id="detailSeltGubn1" name="SELT_GUBN" value="P" disabled /><label for="detailSeltGubn1">개인카드</label>
				<input type="radio" id="detailSeltGubn2" name="SELT_GUBN" value="X" disabled /><label for="detailSeltGubn2">기타</label>
				<input class="readOnly w150" type="text" id="detailMethodBigo" name="METHOD_BIGO" readonly />
			</td>
			<th><span class="textPink">*</span><label for="detailSeltDate">결제일</label></th>
			<td class="tdDate">
				<input class="datepicker readOnly" type="text" id="detailSeltDate" name="SELT_DATE" readonly />
			</td>
		</tr>
<!-- 		<tr>
			<th><label for="detailCardNumb">카드번호</label></th>
			<td>
				<input class="readOnly w180" type="text" id="detailCardNumb" name="CARD_NUMB" readonly />
			</td>
		</tr>
 -->		<tr>
			<th><span class="textPink">*</span><label for="detailSetlWonx">결제금액</label></th>
			<td>
				<input class="readOnly inputMoney w100" type="text" id="detailSetlWonx" name="SETL_WONX" onkeyup="cmaComma(this);" onchange="cmaComma(this);" readonly > 원
			</td>
			<th><span class="textPink">*</span><label for="detailCardCmpy">학습기관<br/>사업자등록번호</label></th>
			<td>
				<input class="readOnly w180" type="text" id="detailCardCmpy" name="CARD_CMPY" readonly />
			</td>
		</tr>
		</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
		<input type="hidden" id="detailCmpyWonx" name="CMPY_WONX" />
	</form>
	</div>
</div>

<script type="text/javascript">
	
	var detailSearch = function(){
		$.ajax({
			type : "get",
			url : "/appl/getLangSupportDetail.json",
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
			setTableText(item, "detailForm");
			$("#detailSetlWonx").val(insertComma(parseInt( $("#detailSetlWonx").val() ).toString()));
			$('input:radio[name="SELT_GUBN"]:input[value=' + item.SELT_GUBN + ']').prop("checked", true);
			
		}
	}
	
	$(document).ready(function(){
		// 초기화
		detailSearch();
	});
	
	
	$('input:radio[name="SELT_GUBN"]').click(function(){
		if($(this).val() == 'P'){
			//$("#detailCardNumb").removeClass("readOnly").prop("readOnly",false);
			$("#detailMethodBigo").addClass("readOnly").prop("readOnly",true).val("");
		}else{
			//$("#detailCardNumb").addClass("readOnly").prop("readOnly",true).val("");
			$("#detailMethodBigo").removeClass("readOnly").prop("readOnly",false);
		}
	});
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		$("#detailSbegDate").removeClass("readOnly").prop("readOnly",false).datepicker({
			defaultDate: "+1w",
			onClose: function( selectedDate ) {
				$("#detailSendDate").datepicker( "option", "minDate", selectedDate );
			}
		});
		$("#detailSendDate").removeClass("readOnly").prop("readOnly",false).datepicker({
			defaultDate: "+1w",
			onClose: function( selectedDate ) {
				$("#detailSbegDate").datepicker( "option", "maxDate", selectedDate );
			}
		});
		$("#detailStudType").removeClass("readOnly").prop("disabled",false);
		$("#detailLectTime").removeClass("readOnly").prop("readOnly",false);
		$("#detailStudInst").removeClass("readOnly").prop("readOnly",false);
		$("#detailLectSbjt").removeClass("readOnly").prop("readOnly",false);
		$("#detailSetlWonx").removeClass("readOnly").prop("readOnly",false);
		$("#detailSeltGubn1").removeClass("readOnly").prop("disabled",false);
		$("#detailSeltGubn2").removeClass("readOnly").prop("disabled",false);
		$("#detailSetlWonx").removeClass("readOnly").prop("readOnly",false);
		$("#detailSeltDate").removeClass("readOnly").prop("readOnly",false).datepicker();
		$("#detailCardCmpy").removeClass("readOnly").prop("readOnly",false);
		
		if($('input:radio[name="SELT_GUBN"]').filter(':checked').val() == 'P'){
			//$("#detailCardNumb").removeClass("readOnly").prop("readOnly",false);
			$("#detailMethodBigo").addClass("readOnly").prop("readOnly",true);
		}else{
			//$("#detailCardNumb").addClass("readOnly").prop("readOnly",true);
			$("#detailMethodBigo").removeClass("readOnly").prop("readOnly",false);
		}
		
	}
	
	
	// 삭제 버튼 클릭
	var reqDeleteActionCallBack = function(){
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#detailAinfSeqn").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteLangSupport',
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
		
		$("#detailSbegDate").addClass("readOnly").prop("readOnly",true);
		$("#detailSendDate").addClass("readOnly").prop("readOnly",true);
		$("#detailStudType").addClass("readOnly").prop("disabled",true);
		$("#detailLectTime").addClass("readOnly").prop("readOnly",true);
		$("#detailStudInst").addClass("readOnly").prop("readOnly",true);
		$("#detailLectSbjt").addClass("readOnly").prop("readOnly",true);
		$("#detailSetlWonx").addClass("readOnly").prop("readOnly",true);
		$("#detailSeltGubn1").addClass("readOnly").prop("disabled",true);
		$("#detailSeltGubn2").addClass("readOnly").prop("disabled",true);
		$("#detailMethodBigo").addClass("readOnly").prop("readOnly",true);
		$("#detailSetlWonx").addClass("readOnly").prop("readOnly",true);
		$("#detailSeltDate").addClass("readOnly").prop("readOnly",true);
		//$("#detailCardNumb").addClass("readOnly").prop("readOnly",true);
		$("#detailCardCmpy").addClass("readOnly").prop("readOnly",true);
		
		destroydatepicker("detailForm");
	}
	
	var updateLangCheck = function(){
		
		var fr_date = $("#detailSbegDate").val();
		var to_date = $("#detailSendDate").val();
		
		if( fr_date > to_date ) {
			alert("학습시작일이 학습종료일보다 큽니다.");
			return false;
		}
		
		//학습기관-40 입력시 길이 제한 
		if( $("#detailStudInst").val().length > 40 ){
			alert("학습기관은 한글 20자, 영문 40자 이내여야 합니다.");
			$("#detailStudInst").focus();
			$("#detailStudInst").select();
			return false;
		}
		
		//수강과목-50 입력시 길이 제한 
		if( $("#detailLectSbjt").val().length > 50 ){
			alert("수강과목은 한글 25자, 영문 50자 이내여야 합니다.");
			$("#detailLectSbjt").focus();
			$("#detailLectSbjt").select();
			return false;
		}
		
		//결재구분이 카드일경우
		if( $('input:radio[name="SELT_GUBN"]').filter(':checked').val() == "P" ) {
			//  카드번호, 사업자등록번호 중 한 항목만 입력시 error처리함
			if( $("#detailCardCmpy").val() == "") {
				alert("사업자등록번호를 입력하세요.");
				$("#detailCardCmpy").focus();
				return false;
			}
			//  카드번호 입력시 16자리를 check한다.
/* 			if( $("#detailCardNumb").val().length < 16 ){
				alert("카드번호 16자리를 입력하세요.");
				$("#detailCardNumb").focus();
				$("#detailCardNumb").select();
				return false;
			}
 */		}
		
		//사업자등록번호-30 입력시 길이 제한 
		if($("#detailCardCmpy").val().length > 30){
			alert("사업자등록번호은 한글 15자, 영문 30자 이내여야 합니다.");
			$("#detailCardCmpy").focus();
			$("#detailCardCmpy").select();
			return false;
		}
		
		return true;
	}
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(updateLangCheck()){
			if(confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#detailAinfSeqn").val('${AINF_SEQN}');
				$("#detailSetlWonx").val( parseInt($("#detailSetlWonx").val() == "" ? "0" : removeComma($("#detailSetlWonx").val() ) ) );
				
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateLangSupport',
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
