<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%

%>
<div class="tableArea">
<form id="detailForm">
	<h2 class="subtitle">하계조직활성화비 조회</h2>
	<div class="table">
		<table class="tableGeneral">
			<caption>하계조직활성화비 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="requestSummerResortBegda">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" id="requestSummerResortBegda" name="BEGDA" value=""  readonly />
				</td>
				<th><label for="requestSummerResortMoney">신청금액</label></th>
				<td class="tdDate">
					<input class="inputMoney w150 readOnly" type="text" id="requestSummerResortMoney" name="MONEY" value="" readOnly />
				</td>
			</tr>	
			</tbody>
			</table>
		</div>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
		<div class="tableComment">
			<p><span class="bold">제출증빙 안내</span></p>
			<p>개인카드 또는 현금소득공제용 영수증 (식당, 숙박업소만 가능)</p>
		</div>
	</div>
	</form>
</div>	
<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getSummerDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				$("#requestSummerResortMoney").val(response.storeData.MONEY.format());
			}else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
	}
	
	var setDetail = function(item){
		setTableText(item, "detailForm");
		fncSetFormReadOnly($("#detailForm"), true);
	}
	
	$(document).ready(function(){
		detailSearch();
	});
	
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
		fncSetFormReadOnly($("#detailForm"), false, new Array("requestSummerResortBegda","requestSummerResortMoney"));
	}
	
	var reqSaveActionCallBack = function() {
		if (summerCheck()) {
			if (confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateSummer',
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
	var summerCheck = function(){
		$("#requestSummerResortBegda").val(removePoint($("#requestSummerResortBegda").val())); 
		$("#requestSummerResortMoney").val(removeComma($("#requestSummerResortMoney").val()));
		return true;
	}
	
	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteSummer',
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
</script>