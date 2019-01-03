<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E25InfoJoin.*" %>
<%@ page import="hris.E.E25InfoJoin.rfc.* "%>
<%@ page import="hris.E.E25InformalAccountInfo.*" %>
<%@ page import="hris.E.E25InformalAccountInfo.rfc.* "%>

<%
	
	Vector InfoListDataNew_vt = new Vector();
	Vector InfoPayData_vt = new Vector();
	
	InfoListDataNew_vt = (new E25InformalAccountInfoListNewRFC()).getInfoList();
    InfoPayData_vt = (new E25InformalAccountInfoPayRFC()).getInfoPay();
	
%>


<div class="tabUnder tab1">	
	<!--// Table start -->	
<form id="detailForm" name="detailForm" method="post">
<input type="hidden" name="LGTXT" id="LGTXT" />
<input type="hidden" name="MGART_TX" id="MGART_TX" />
<input type="hidden" name="RECI_NAME" id="RECI_NAME" />
<input type="hidden" name="WORK_TYPE" id="WORK_TYPE" value="46"/>
<input type="hidden" name="JOB_TYPE" id="JOB_TYPE" value="3"/>
<input type="hidden" name="TYPE" id="TYPE" value="U"/>
<input type="hidden" name="AINF_SEQN" id="AINF_SEQN" value="${AINF_SEQN}"/>

<!-- 
<input type="hidden" name="AEDTM" id="AEDTM" />
<input type="hidden" name="UNAME" id="UNAME" />
<input type="hidden" name="REJECT_CODE" id="REJECT_CODE" />
<input type="hidden" name="REJECT_NAME" id="REJECT_NAME" />
-->

	<div class="tableArea">
		<h2 class="subtitle">간사계좌변경 조회</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>간사계좌변경 신청 조회</caption>
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
					<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-2">인포멀회유형</label></th>
				<td>
					<span id="MGART_TXT"></span>
					<input type="hidden" name="MGART" id="DETAIL_MGART"/>
				</td>
				<th><span class="textPink">*</span><label for="inputText01-2">입금유형</label></th>
				<td>
					<span id="LGTXT_TXT"></span>
					<input type="hidden" name="LGART" id="DETAIL_LGART"/>
					<input class="w30 readOnly" type="text" name="LGART_CODE"  id="LGART_CODE" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="INFO_BEG">등록기간</label></th>
				<td colspan="3" class="tdDate">
					<input type="text" id="inputDateFromCustom" name="INFO_BEG" placeholder="시작일" vname="시작일" disabled="disabled" required />
					~
					<input type="text" class="readOnly" id="inputDateTo_" name="INFO_END" placeholder="종료일" vname="종료일" value="9999.12.31" readonly="readonly" required />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-3">간사사번</label></th>
				<td>
					<input class="" style="width:102px" type="text" name="PERN_NUMB" id="PERN_NUMB" vname="간사사번" onkeydown="onlyNumber(this)" disabled="disabled" required />
				</td>
				<th><span class="textPink">*</span><label for="inputText01-4">연락처</label></th>
				<td>
					<input class="w150" type="text" name="PERN_TELE" id="PERN_TELE" vname="연락처" disabled="disabled" required/>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span>은행코드</th>
				<td><select class="fixedWidth" name="BANK_CODE" id="BANK_CODE"  vname="은행코드" disabled="disabled" required>
					<option value="">-------------</option>
					</select>
					<input class="w30 readOnly" type="text" name="BANK_CODE_VALUE"  id="BANK_CODE_VALUE" readonly />
				</td>
				<th><span class="textPink">*</span>계좌번호</th>
				<td>
					<input class="w150" type="text" name="BANKN" id="BANKN" value=""  vname="계좌번호" onkeydown="onlyNumber(this)" disabled="disabled" required/>
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<!-- <div class="tableComment">
			<p><span class="bold">신규 인포멀유형 등록후 신청하시기 바랍니다.</span></p>
		</div> -->
	</div>
	</form>
	
</div>
<!--// Tab1 end -->
<!--------------- layout body end --------------->


<script type="text/javascript">
	
	var detailSearch = function() {
	
		$.ajax({
			type : "get",
			url : "/appl/getinformalAccountInfoDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>',"UPMU_TYPE" : '<c:out value="${UPMU_TYPE}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				setDetailEtc(response.storeData);
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
		}
		var setDetailEtc = function(item){
			$("#BEGDA").val("<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>");
			$("#LGART_CODE").val(item[0].LGART);
			$("#BANK_CODE_VALUE").val(item[0].BANK_CODE);
			
			$("#LGTXT_TXT").text(item[0].LGTXT);
			$("#MGART_TXT").text(item[0].MGART_TX);
			$("#PERN_NUMB").val( item[0].PERN_NUMB.substring(4,8) );
		}
	}
	
	
	var reqModifyActionCallBack = function(){
		//detailSearch();
		$("#detailForm input").prop("disabled",false);
		$("#detailForm select").prop("disabled",false);
		
		//날짜 기간 datepicker
		$( "#inputDateFromCustom" ).datepicker({
			defaultDate: "+1w",
			dateFormat: 'yy.mm.01',
			onClose: function( selectedDate ) {
				$( "#inputDateTo" ).datepicker( "option", "minDate", selectedDate );
			}
		});
	}
	
	var reqCancelActionCallBack = function(){
		$("#detailForm").each(function(){
			this.reset();
			$("#detailForm input").prop("disabled",true);
			$("#detailForm select").prop("disabled",true);
			$( "#inputDateFromCustom" ).datepicker( "destroy" );
		});
		
		detailSearch();
	}
	
	var reqSaveActionCallBack = function(){
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(InformalAccountJoinClientCheck()){
			if(confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				
				var param = $("#detailForm").serializeArray();

				$("#decisionerGrid").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestInformalAccountInfo.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("저장되었습니다.");
							$('#applDetailArea').html('');
							$("#reqApplGrid").jsGrid("search");
							return true;
						}else{
							alert("저장시 오류가 발생하였습니다. " + response.message);
							return false;
						}
						$("#reqSaveBtn").prop("disabled", false);
					}
				}); 
				
			}
		}
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
				url : '/appl/deleteinformalAccountInfoDetail',
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
	
	//간사계좌신청 validation
	var InformalAccountJoinClientCheck = function() {
		if(!checkNullField("detailForm")){
			return false;
		}
		if( $("#MEMBER").val() == "1") {
			alert("이미 회원입니다.");
			return false;
		}
		return true;
	}
	

	function onlyNumber(obj) {
	    $(obj).keyup(function(){
	         $(this).val($(this).val().replace(/[^0-9]/g,""));
	    }); 
	}
	
	var bankCode = function(param_div){
		var params = "0";
		jQuery.ajax({
    		type : "POST",
    		url : "/salary/getChangeBankCode.json",
    		cache : false,
    		dataType : "json",
    		data :{
    			"BNKSA" : params
    		},
    		async :false,
    		success : function(response) {
    			if(response.success){
    				var jsonData = response.storeData;
    				var data = response.adata;
    				bankCodeOption(jsonData, data, param_div);
    			}
    			else{
    				alert("은행코드 정보가 존재하지 않습니다." + response.message);
    			}
    		}
		});
    };
    
	var bankCodeOption = function(jsonData, data, param_div) {
		$("#"+param_div+"BANK_CODE").empty();
		$("#"+param_div+"BANK_CODE").append('<option value="">----</option>');
        $.each(jsonData, function (key, value) {
        	$("#"+param_div+"BANK_CODE").append('<option value=' + value.BANK_CODE +'>' + value.BANK_NAME + '</option>');
        });
	}
	//은행 변경시
	$("#BANK_CODE").change(function(){
		$("#BANK_CODE_VALUE").val($("#BANK_CODE option:selected").val());
	});
	
	//임금유형 변경시
	$("#LGART").change(function(){
		$("#LGTXT").val($("#LGART option:selected").text());
		$("#LGART_CODE").val($("#LGART option:selected").val());
	});
	
	//인포멀회 변경시
	$("#MGART").change(function(){
		$("#MGART_TX").val($("#MGART option:selected").text());
	});
	
	
	$( document ).ready(function() {
		bankCode("");
		detailSearch();
		
	});
</script>