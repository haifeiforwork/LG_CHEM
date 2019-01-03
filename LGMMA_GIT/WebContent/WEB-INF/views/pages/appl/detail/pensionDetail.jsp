<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E04Pension.rfc.E04PensionChngGradeRFC"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="tableArea">
	<h2 class="subtitle">국민연금 자격변경 신청 조회</h2>
	<div class="table">
	<form id="detailForm" name="detailForm">
		<table class="tableGeneral">
		<caption>국민연금 자격변경 신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText01-1">신청일</label></th>
			<td colspan="3" class="tdDate">
			<input class="readOnly" type="text" name="BEGDA" id="BEGDA" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="inputText01-2">변경항목</label></th>
			<td colspan="3">
			<select id="CHNG_TYPE" name="CHNG_TYPE" class="readOnly" readOnly disabled> 
			<option>-------선택-------</option>
			<%= WebUtil.printOption((new E04PensionChngGradeRFC()).getPensionChngGrade()) %>
			</select> 
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="inputText01-3">변경전Data</label></th>
			<td>
			<input class="w150 readOnly" type="text" name="CHNG_BEFORE" id="CHNG_BEFORE" readonly />
			</td>
			<th><span class="textPink">*</span><label for="inputText01-4">변경후Data</label></th>
			<td>
			<input class="w150 readOnly" type="text" name="CHNG_AFTER" id="CHNG_AFTER" readonly />
			</td>
		</tr>
		</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
		</form>
	</div>
</div>	
<!--// Table end -->
<script>
	var detailSearch= function() {
		$.ajax({
			type : "get",
			url : "/appl/getPensionDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
			}
			else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		var setDetail = function(item){
			setTableText(item, "detailForm");
		}
	};
	
	$(document).ready(function(){
		detailSearch();
	});
	
	var reqModifyActionCallBack = function(){
		fncSetFormReadOnly($("#detailForm"), false, new Array("BEGDA"));
	}
	
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
				url : '/appl/deletePension',
				cache : false,
				dataType : 'json',
				data : param,
				async : false,
				success : function(response) {
					if(response.success) {
						alert("삭제 되었습니다.");
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
	
	var reqCancelActionCallBack = function(){
		$("#detailForm").each(function(){
			this.reset();
		});
		detailSearch();
		fncSetFormReadOnly($("#detailForm"), true, new Array("BEGDA"));
	}
	
	var reqSaveActionCallBack = function(){
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(checkDetailFormValid()) {
			if(confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'post',
					url : '/appl/updatePension',
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
		}else{
			return false;
		}
	};
	var checkDetailFormValid = function() {
		if($("#detailForm #CHNG_TYPE").prop("selectedIndex")==0){
			alert("변경항목을 선택하세요");
			$("#detailForm #CHNG_TYPE").focus();
			return false;
			}
		if($("#detailForm #CHNG_BEFORE").val() == "") {
			alert("변경전 Data를 입력하세요 ");
			$("#detailForm #CHNG_BEFORE").focus();
			return false;
			}
		if($("#detailForm #CHNG_AFTER").val() == "") {
			alert("변경후 Data를 입력하세요 ");
			$("#detailForm #CHNG_AFTER").focus();
			return false;
			}
		if($("#CHNG_TYPE option:selected").val() == "02"){
			if(!chkResnoBefore($("#detailForm #CHNG_BEFORE"))){
				return false;
			}
		}
		if($("#CHNG_TYPE option:selected").val() == "02"){
			if(!chkResnoAfter($("#detailForm #CHNG_AFTER"))) {
				return false;
			}
		}
		return true;
	}
	var chkResnoBefore = function(id){
		var resno = id.val();
		if( resno.length == 13 ){
			tempStr = resno.substring(0,6) + "-" + resno.substring(6,13);
		} else if( resno.length == 14 ){
			tempStr = resno;
		} else if( resno.length == 0 ){
		  return true;
		} else {
			alert("주민등록번호 형식이 적당하지 않습니다.");
			id.focus();
			id.select();
			return false;
		}
		if(chkResno(tempStr)){
			$("#detailForm #CHNG_BEFORE").val(tempStr);
			return true;
		} else {
			alert("주민등록번호가 유효하지 않습니다.");
			id.focus();
			id.select();
			return false;
		}
	}
	
	var chkResnoAfter = function(id){
		var resno = id.val();
		if( resno.length == 13 ){
			tempStr = resno.substring(0,6) + "-" + resno.substring(6,13);
		} else if( resno.length == 14 ){
			tempStr = resno;
		} else if( resno.length == 0 ){
		  return true;
		} else {
			alert("주민등록번호 형식이 적당하지 않습니다.");
			id.focus();
			id.select();
			return false;
		}
		if(chkResno(tempStr)){
			$("#detailForm #CHNG_AFTER").val(tempStr);
			return true;
		} else {
			alert("주민등록번호가 유효하지 않습니다.");
			id.focus();
			id.select();
			return false;
		}
	}
</script>
