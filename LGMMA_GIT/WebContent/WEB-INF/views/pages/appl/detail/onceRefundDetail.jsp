<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>

<%
	WebUserData user = (WebUserData)session.getValue("user");
%>

<div class="tableArea">
	<h2 class="subtitle">구입전환일시지원금 상환신청</h2>
	<div class="table">
	<form id="detailForm">
		<table class="tableGeneral">
		<caption>구입전환일시지원금 상환신청</caption>
		<colgroup>
			<col class="col_20p"/>
			<col class="col_80p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="detailBegda">신청일</label></th>
			<td class="tdDate">
				<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailDlart">주택융자유형</label></th>
			<td>
				<select class="readOnly w150" id="detailDlart" name="DLART" disabled>
					<option value="0030" selected>구입전환일시지원금</option> 
				</select>
			</td>
		</tr>
		
		<tr>
			<th><label for="detailRpayAmnt">상환원금</label></th>
			<td>
				<input class="inputMoney w120 readOnly" type="text" id="detailRpayAmnt" name="RPAY_AMNT" readonly > 원
			</td>
		</tr>
		<tr>
			<th><label for="detailIntrAmnt">구입전환일시지원금 이자</label></th>
			<td>
				<input class="inputMoney w120 readOnly" type="text" id="detailIntrAmnt" name="INTR_AMNT" readonly> 원
			</td>
		</tr>
		<tr>
			<th><label for="detailTotalAmnt"><strong class="colorBlue">총상환금액</strong></label></th>
			<td>
				<input class="inputMoney w120 readOnly colorBlue" type="text" id="detailTotalAmnt" name="TOTL_AMNT" readonly> 원
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailReptDate">상환액 입금일자</label></th>
			<td colspan="3" class="tdDate">
				<input class="datepicker" type="text" size="5" id="detailReptDate" name="REPT_DATE" vname="상환액 입금일자" />
			</td>
		</tr>
		<tr>
			<th><label for="detailDarbt">대출금액</label></th>
			<td>
				<input class="inputMoney w120 readOnly" type="text" id="detailDarbt" name="DARBT" readonly > 원
			</td>
		</tr>
		<tr>
			<th><label for="detailDatbw">대출일자</label></th>
			<td>
				<input class="w120 readOnly" type="text" id="detailDatbw" name="DATBW" readonly >
			</td>
		</tr>
		<tr>
			<th><label for="detailAlreadyAmnt">기상환액</label></th>
			<td>
				<input class="inputMoney w120 readOnly" type="text" id="detailAlreadyAmnt" name="ALREADY_AMNT" readonly> 원
			</td>
		</tr>
		<tr>
			<th><label for="detailRemainAmnt">대출잔액</label></th>
			<td>
				<input class="inputMoney w120 readOnly" type="text" id="detailRemainAmnt" name="REMAIN_AMNT" readonly> 원
			</td>
		</tr>
		<tr>
			<th><label for="detailZzsecuFlag">보증여부</label></th>
			<td>
				<input class="readOnly w120" id="detailZzsecuFlag" name="ZZSECU_FLAG" readonly>
			</td>
		</tr>
		</tbody>
		</table>
	<input type="hidden" id="detailAinfSeqn" name="AINF_SEQN" />
	</form>
	</div>
	<div class="tableComment">
<% if ( user.e_grup_numb.equals("02")) {  %>
		<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA</span></p><!-- 여수  -->
<% } else { %>
		<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA </span></p><!-- 서울 -->
<% } %>
		<ul>
			<li>구입전환일시지원금을 입금할 경우 본인임을 확인할 수 있도록 무통장 입금증에 본인의 실명을 입력하여 주십시오.</li>
			<li>매월 21일부터 말일까지는 구입전환일시지원금을 상환할 수 없습니다.</li>
		</ul>
	</div>
</div>

<script type="text/javascript">
	
	var detailSearch = function(){
		$.ajax({
			type : "get",
			url : "/appl/getOnceRefundDetail.json",
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
			
			$("#REMAIN_AMNT").val(parseFloat( item.DARBT == "" ? "0" : item.DARBT) - parseFloat(item.ALREADY_AMNT == "" ? "0" :item.ALREADY_AMNT));
			
		}
	}
	
	
	$(document).ready(function(){
		// 초기화
		detailSearch();
	});
	
	
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
				url : '/appl/deleteOnceRefund',
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
	
	
</script>