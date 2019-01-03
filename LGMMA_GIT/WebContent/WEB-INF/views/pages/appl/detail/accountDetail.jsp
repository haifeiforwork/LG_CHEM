<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%
	WebUserData user = (WebUserData)session.getValue("user");
%>
<div class="tabUnder tab2 ">
	<form id="detailForm">
		<!--// Table start -->	
		<div class="tableArea">
		<h3 class="subsubtitle">급여계좌 조회</h3>
		<div class="table">
			<table class="tableGeneral">
				<caption>계좌신청</caption>
				<colgroup>
					<col class="col_13p" />
					<col class="*" />
				</colgroup>
				<tbody>
					<tr>
						<th>신청일자</th>
						<td class="tdDate">
							<input type="text" name="BEGDA" id="BEGDA" value="" class="readOnly" readonly></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>은행코드</th>
						<td><select class="fixedWidth" name="BANK_CODE" id="BANK_CODE"  vname="은행코드" required>
						<option value="">-------------</option>
						</select></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>계좌번호</th>
						<td>
							<input class="w200" type="text" name="BANKN" id="BANKN" value=""  vname="계좌번호" required/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!--// table end -->
		</div>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
		<input type="hidden" id="BNKSA" name="BNKSA" value="<c:out value="${BNKSA}"/>">
		<input type="hidden" id="BANK_FLAG" name="BANK_FLAG" value="" >
		<input type="hidden" id="BANK_NAME" name="BANK_NAME" value="" >
      </form>
	</div>
<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getAccountDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>',
					"BNKSA" : '<c:out value="${BNKSA}"/>'
			}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				var BANK_CODE = response.storeData.BANK_CODE;
				var BANKN = response.storeData.BANKN;
				bankCode(BANK_CODE,BANKN);
				$("#BANKN").val(BANKN);
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
		fncSetFormReadOnly($("#detailForm"), false,new Array("BEGDA"));
	}
	
	var reqSaveActionCallBack = function() {
		if (saLcheck_data()) {
			if (confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateAccount',
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
	
	var saLcheck_data = function(){
		if($("#BANK_CODE").val()==""){
			alert("은행코드를 선택하세요");
			return false;
		}
		if($("#BANKN").val()==""){
			alert("계좌번호를 입력하세요");
			return false;
		}
		 if(isNaN($("#BANKN").val())) {
			alert("숫자만 입력가능합니다.");
			$("#BANKN").focus();
			return false;
		}
		$("#BEGDA").val(removePoint($("#BEGDA").val()));
		$("#BANK_FLAG").val("01");      // 급여계좌
		return true;
	};
	
	var bankCode = function(BANK_CODE,BANKN){
		jQuery.ajax({
    		type : "POST",
    		url : "/appl/getChangeBankCode.json",
    		cache : false,
    		dataType : "json",
    		data :{
    			"BNKSA" : $("#BNKSA").val()
    		},
    		async :false,
    		success : function(response) {
    			if(response.success){
    				var jsonData = response.storeData;
    				bankCodeOption(jsonData, BANK_CODE, BANKN);
    			}
    			else{
    				alert("은행코드 정보가 존재하지 않습니다." + response.message);
    			}
    		}
		});
    };
    
	var bankCodeOption = function(jsonData, data, BANKN) {
		$("#BANK_CODE").empty();
		$("#BANK_CODE").append('<option value="">----</option>');
        $.each(jsonData, function (key, value) {
       		if(value.BANK_CODE==data){
       			$("#BANK_CODE").append('<option BANKN = '+ BANKN +' value=' + value.BANK_CODE +' selected>' + value.BANK_NAME + '</option>');
       		}else{
       			$("#BANK_CODE").append('<option value=' + value.BANK_CODE +'>' + value.BANK_NAME + '</option>');
       		}
        });
	}
	
	//급여계좌 변경시
	$("#BANK_CODE").change(function(){
		$("#BANK_NAME").val($("#BANK_CODE option:selected").text());
	}); 
	
	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteAccount',
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

