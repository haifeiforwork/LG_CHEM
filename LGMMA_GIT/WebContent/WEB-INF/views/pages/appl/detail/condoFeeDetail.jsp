<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="tableArea">
	<h2 class="subtitle">콘도지원비 신청 조회</h2>
	<div class="table">
		<form id="detailForm" name="detailForm">
			<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
			<input type="hidden" id="CODE_CONDO" name="CODE_CONDO">
			<input type="hidden" id="LOCA_CONDO" name="LOCA_CONDO">
			<input type="hidden" id="SIZE_ROOM" name="SIZE_ROOM">
			<table class="tableGeneral">
				<caption>콘도지원비 신청</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_35p" />
					<col class="col_15p" />
					<col class="col_35p" />
				</colgroup>
				<tbody>
					<tr>
						<th><label for="inputText02-1">신청일</label></th>
						<td colspan="3" class="tdDate"><input class="readOnly"
							type="text" name="BEGDA"
							value=""
							id="BEGDA" readonly /></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputDateFrom">사용기간</label></th>
						<td colspan="3" class="tdDate"><input class="readOnly"
							type="text" value="" id="DAY_IN" name="DAY_IN" readonly /> ~ <input
							class="readOnly" type="text" value="" id="DAY_OUT" name="DAY_OUT"
							readonly /> <input class="readOnly w40" type="text"
							name="DAY_USE" value="" id="DAY_USE" readonly /> 박</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputText02-3">콘도명</label></th>
						<td colspan="3"><input class="readOnly w80" type="text"
							name="NAME_CONDO" value="" id="NAME_CONDO" readonly /> <input
							class="readOnly w80" type="text" name="NAME_LOCA" value=""
							id="NAME_LOCA" readonly /> <input class="readOnly w80"
							type="text" name="NAME_SIZE" value="" id="NAME_SIZE" readonly />
							<input class="readOnly w40" type="text" name="CUNT_ROOM" value=""
							id="CUNT_ROOM" readonly /> (객실수)</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputText02-4">신청금액</label></th>
						<td><input class="inputMoney w150" type="text" name="MONEY"
							id="MONEY" onkeyup="cmaComma(this);" onchange="cmaComma(this);"
							value=""></td>
						<th><span class="textPink">*</span><label for="inputDate01">결제일</label></th>
						<td class="mydatepicker"><input type="text" id="DATE_CARD"
							name="DATE_CARD" /></td>
					</tr>
					<!--tr>
						<th><label for="input_radio02_1">결제구분</label></th>
						<td><input type="radio" name="METHOD" id="input_radio02_1"
							value="1" /><label for="input_radio02_1">개인카드</label>
							<input type="radio" name="METHOD" id="input_radio02_2" value="2" /><label
							for="input_radio02_1">현금</label></td>
						<th><label for="inputText02-6">카드번호</label></th>
						<td><input class="w150" type="text" name="NUMBER_CARD"
							value="" id="NUMBER_CARD" /><span class="noteItem">('-' 표시 없이)</span></td>
					</tr-->
				</tbody>
			</table>
		</form>
	</div>
</div>
<!--// Table end -->
<script>
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getCondoFeeDetail.json",
			dataType : "json",
			data : {
				"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'
			}
		}).done(function(response) {
			if (response.success) {
				setDetail(response.storeData);
			} else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		var setDetail = function(item) {
			item.DAY_USE = parseInt(item.DAY_USE);
			item.MONEY = parseInt(item.MONEY).format();
			setTableText(item, "detailForm");
			if (item.CODE_CONDO == "08") { //생활연수원일 경우 뒤에 selectbox 못하게
				$("#LOCA_CONDO").hide();
				$("#SIZE_ROOM").hide();
				$("#CUNT_ROOM").hide();
			}
			setCondoName(item);
			fncSetFormReadOnly($("#detailForm"), true);
			//setMethodType(item.METHOD);
		}
	};

	$(document).ready(function() {
		detailSearch();
	});

	var setCondoName = function(item) {
		$.ajax({
			type : "get",
			url : "/common/getCondoCodeList.json",
			dataType : "json",
			data : {"CODE_CONDO" : item.CODE_CONDO,
				"LOCA_CONDO" : item.LOCA_CONDO,
				"SIZE_ROOM" : item.SIZE_ROOM,
				"DAY_IN" : item.DAY_IN,
				"DAY_OUT" : item.DAY_OUT}
			}).done(function(response) {
				if(response.success) {
					var res = response.storeData;
					var result = $.grep(res[0], function(element, index) {
						   return (element.CODE_CONDO === item.CODE_CONDO);
					});
					$("#detailForm #NAME_CONDO").val(result[0].NAME_CONDO);

					var result = $.grep(res[1], function(element, index) {
						   return (element.LOCA_CONDO === item.LOCA_CONDO);
					});
					$("#detailForm #NAME_LOCA").val(result[0].NAME_LOCA);

					var result = $.grep(res[2], function(element, index) {
						   return (element.SIZE_ROOM === item.SIZE_ROOM);
					});
					if(result.length > 0)
						$("#detailForm #NAME_SIZE").val(result[0].NAME_SIZE);
				}
				else
					alert("콘도코드 조회시 오류가 발생하였습니다. " + response.message);
			});
	}

	var reqModifyActionCallBack = function() {
		var periodpicker = $('.mydatepicker');
		
		for(var i=0;i<periodpicker.length;i++){
			//date 찾아오기
			var dateInput = $(periodpicker[i]).find('input');
			$.each(dateInput, function(i, data){
				var fid = dateInput[0].id;
				$(data).datepicker({
		        });
			});
		}
		fncSetFormReadOnly($("#detailForm"), false, new Array("BEGDA","DAY_USE","DAY_IN","DAY_OUT","NAME_CONDO","NAME_LOCA","NAME_SIZE","CUNT_ROOM"));
	}

	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteCondoFee',
				cache : false,
				dataType : 'json',
				data : param,
				async : false,
				success : function(response) {
					if (response.success) {
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

	var reqCancelActionCallBack = function() {
		$("#detailForm").each(function() {
			this.reset();
		});
		$("#CODE_CONDO").empty();
		$("#LOCA_CONDO").empty();
		$("#SIZE_ROOM").empty();
		$("#DATE_CARD").datepicker("destroy");
		detailSearch();
	}

	var setMethodType = function(type) {
		if(type == "2") {
			$("#detailForm #NUMBER_CARD").prop("disabled", true );
			$("#detailForm #NUMBER_CARD").val("");
		} else {
			$("#detailForm #NUMBER_CARD").prop("disabled", false );
		}
	}

	//지원비신청용
	/*
	$('#detailForm input:radio[name="METHOD"]').click(function() {
		setMethodType(this.value);
	});
	*/
	
	var reqSaveActionCallBack = function() {
		if (checkDetailFormValid()) {
			if (confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				param.push({name:"METHOD", value:"2"});
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateCondoFee',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
					success : function(response) {
						if (response.success) {
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
		} else {
			return false;
		}

	};
	var checkDetailFormValid = function() {
		if($("#detailForm #MONEY").val() == "" ) {
			alert("신청금액을 입력하세요.");
			$("#detailForm #MONEY").focus();
			return false;
			}
			if(removeComma($("#detailForm #MONEY").val()) > 200000){
			alert("200,000 원이 초과 하였습니다. 신청금액을 확인하시기 바랍니다.");
			return false;
			}
		if($("#detailForm #DATE_CARD").val() == "" ) {
			alert("결재일을 입력하세요.");
			$("#detailForm #DATE_CARD").focus();
			return false;
		}
		
		if(!isDate($("#detailForm #DATE_CARD").val())) {
			alert("결재일을 입력하세요.");
			$("#detailForm #DATE_CARD").focus();
			return false;
		}
		/*
		if($('#detailForm input:radio[name="METHOD"]:checked').val() == "1"){
			if($("#detailForm #NUMBER_CARD").val() == "" ) {
				alert("카드번호를 입력하세요.");
				$("#detailForm #NUMBER_CARD").focus();
				return false;
			}
			if( !isCardNumber($("#detailForm #NUMBER_CARD").val()) ) {
				alert("카드번호를 정확히 입력하세요.");
				$("#detailForm #NUMBER_CARD").focus();
				return false;
			} 
		}*/
		return true;
	}
</script>
