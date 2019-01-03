<%@page import="com.lgmma.ess.app.controller.ApplController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>



					<div class="tableArea">
						<h2 class="subtitle">주택자금 상환신청 상세내역</h2>
						<div class="table">
						<form id="detailForm" name="detailForm">
							<table class="tableGeneral">
							<caption>신청서 작성</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td class="tdDate">

									<input class="readOnly" type="text"  name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputSelect01-2">주택융자유형</label></th>
								<td>
                                   <select class="w150" id="I_LOAN_CODE" name="I_LOAN_CODE" required vname="주택융자유형" disabled> 
                                   		<option value="">------------</option>
										<%= WebUtil.printOption((new E05LoanCodeRFC()).getLoanType()) %>
									</select>
                                </td>
                            </tr>
                            <tr>
								<th><label for="inputText01-3">상환원금</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="RPAY_AMNT"  name="RPAY_AMNT" readonly> 원
								</td>
							</tr>
							<tr>
								<th><label for="inputText01-4">주택자금이자</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="INTR_AMNT" name="INTR_AMNT"  readonly> 원	
								</td>
							</tr>
							<tr>
								<th><label for="inputText01-5"><strong class="colorBlue">총상환금액</strong></label></th>
								<td>
									<input class="inputMoney w120 readOnly colorBlue" type="text" id="TOTL_AMNT" name="TOTL_AMNT" readonly> 원
								</td>
							</tr>
							<tr>
                                <th><span class="textPink">*</span><label for="inputDateDay">상환액 입금일자</label></th>
								<td colspan="3" class="tdDate">
                                   <input class="datepicker readOnly" type="text" size="5" id="REPT_DATE" name="REPT_DATE" required vname="상환액 입금일자" readonly/>
                                </td>
							</tr>
							<tr>
								<th><label for="inputSelect01-7">대출금액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="DARBT" name="DARBT"  readonly> 원
                                </td>
							</tr>	
							<tr>
								<th><label for="inputSelect01-7">대출일자</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DATBW" name="DATBW" readonly>
                                </td>
							</tr>	
							<tr>
								<th><label for="input-radio02-1">기상환액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="ALREADY_AMNT" name="ALREADY_AMNT"  readonly> 원
							    </td>
							</tr>	
							<tr>
								<th><label for="inputSelect01-7">대출잔액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="REMAIN_AMNT" name="REMAIN_AMNT" readonly> 원
                                </td>
							</tr>	
							<tr>
								<th><label for="input-radio02-1">보증여부</label></th>
								<td><input type="hidden" name="E_ZZSECU_FLAG" id="ZZSECU_FLAG" >
									<input type="hidden" name="I_BETRG" id="I_BETRG" >
									<input type="hidden" name="idate" id="idate" >
									<input type="hidden" name="fromdate" id="fromdate"  >
								
									<input class="w120 readOnly" type="text" id="E_ZZSECU_TXT"  readonly>
							    </td>
							</tr>
							</tbody>
							</table>
							<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
							</form>
						</div>
						<div class="tableComment">
							<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA</span></p>
							<ul>
								<li>주택자금을 입금할 경우 본인임을 확인할 수 있도록 무통장 입금증에 본인의 실명을 입력하여 주십시오.</li>
								<li>매월 21일부터 말일까지는 주택자금을 상환할 수 없습니다.</li>
							</ul>
						</div>
					</div>



<script>

var detailSearch= function() {

	$.ajax({
		type : "get",
		url : "/appl/getHouseRefundDetail.json",
		dataType : "json",
		data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
	}).done(function(response) {
		if(response.success) {
			console.log(response.storeData);
			setDetail(response.storeData);

		}
		else
			alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
	});
	var setDetail = function(item){
		setTableText(item, "detailForm");
		
		$('#REMAIN_AMNT').val((item.DARBT - item.ALREADY_AMNT));
		
		$('#I_LOAN_CODE').val(item.DLART);
		
		
		if(item.ZZSECU_FLAG=='Y'){
			$('#E_ZZSECU_TXT').val("연대보증인 입보");
		}else if(item.ZZSECU_FLAG=='N'){
			$('#E_ZZSECU_TXT').val("보증보험가입희망");
		}else{
			$('#E_ZZSECU_TXT').val("");
		}
		
	}
};

$(document).ready(function(){
	detailSearch();

});


var reqDeleteActionCallBack = function(){
	if(confirm("삭제 하시겠습니까?")) {
		$("#reqDeleteBtn").prop("disabled", true);
		$("#AINF_SEQN").val('${AINF_SEQN}');
		var param = $("#detailForm").serializeArray();
		$("#detailDecisioner").jsGrid("serialize", param);
		jQuery.ajax({
			type : 'post',
			url : '/appl/deleteHouseRefund',
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


</script>








