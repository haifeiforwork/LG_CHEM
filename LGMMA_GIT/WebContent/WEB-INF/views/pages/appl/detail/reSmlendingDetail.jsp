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
			<h2 class="subtitle">소액대출 상환신청 조회</h2>
			<div class="table">
				<table class="tableGeneral">
				<caption>소액대출 상환신청</caption>
				<colgroup>
					<col class="col_15p"/>
					<col class="col_85p"/>
				</colgroup>
				<tbody>
				<tr>
					<th><label for="inputText03-1">신청일</label></th>
					<td class="tdDate">
						<input class="readOnly" type="text" name="BEGDA" id="BEGDA" value=""  />
					</td>
				</tr>
				<tr>
					<th><label for="inputText03-2">상환원금</label></th>
					<td>
                               <input class="inputMoney w120 readOnly" name="RPAY_AMNT" type="text" id="RPAY_AMNT" value=""  readonly> 원
                             </td>
                         </tr>
				<tr>
                             <th><label for="inputDateDay">상환액 입금일자</label></th>
					<td colspan="3" class="tdDate">
                                <input type="text" size="10" id="REPT_DATE" name="REPT_DATE" value=""/>
                             </td>
				</tr>
				<tr>
					<th><label for="inputText03-3">대출금액</label></th>
					<td>
						<input class="inputMoney w120 readOnly" type="text" name="DARBT" id="DARBT" value="" readonly> 원
                             </td>
				</tr>	
				<tr>
					<th><label for="inputText03-4">대출일자</label></th>
					<td>
						<input class="w80 readOnly" type="text" name="DATBW" id="DATBW" value="" readonly>
                             </td>
				</tr>	
				<tr>
					<th><label for="inputText03-5">기상환액</label></th>
					<td>
						<input class="inputMoney w120 readOnly" type="text" name="ALREADY_AMNT" id="ALREADY_AMNT" value="" readonly> 원
				    </td>
				</tr>	
				<tr>
					<th><label for="inputText03-6">대출잔액</label></th>
					<td>
						<input class="inputMoney w120 readOnly" type="text" name="REMAIN_AMNT" id="REMAIN_AMNT" value="" readonly> 원
                             </td>
				</tr>					
				</tbody>
				</table>
			</div>
			<div class="tableComment">
				<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA</span></p>
				<ul>
					<li>소액대출을 입금할 경우 본인임을 확인할 수 있도록 무통장 입금증에 본인의 실명을 입력하여 주십시오.</li>
					<li>매월 21일부터 말일까지는 소액대출을 상환할 수 없습니다. </li>
					<li>2009. 07. 01일부터 기상환액이 대출원금의 85% 이상일 경우에만 상환신청이 가능합니다. </li>
				</ul>
			</div>
		</div>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
      </form>
	</div>
<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getReSmlendingDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				$("#RPAY_AMNT").val(response.storeData.RPAY_AMNT.format());
				$("#DARBT").val(response.storeData.DARBT.format());
				$("#ALREADY_AMNT").val(response.storeData.ALREADY_AMNT.format());
				$("#REMAIN_AMNT").val((response.storeData.DARBT-response.storeData.ALREADY_AMNT).format());
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
	
	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteReSmlending',
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

