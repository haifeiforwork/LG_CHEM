<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
                    <div class="tableArea">
						<form id="detailForm">
                        <h2 class="subtitle">급여이체 결재 신청 상세내역</h2>
						<div class="table">
							<table class="tableGeneral">
								<caption>급여이체 신청</caption>
								<colgroup>
									<col class="col_10p">
									<col class="col_23p">
									<col class="col_10p">
									<col class="col_22p">
									<col class="col_15p">
									<col class="col_20p">
								</colgroup>
								<tbody>
                                    <tr>
                                        <th><label for="inputText01-1">신청일</label></th>
                                        <td class="tdDate"><input class="readOnly" type="text" id="BEGDA" name="BEGDA" readonly="readonly"></td>
                                        <th><label for="a1">결재일</label></th>
                                        <td class="tdDate" colspan="4"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
                                    </tr>
									<tr>
										<th><label for="a2">제목</label></th>
										<td colspan="5">
											<input class="readOnly wPer" type="text" id="TEXT" name="TEXT" readonly="readonly">
										</td>
									</tr>
									<tr>
										<th><label for="a3">전체건수</label></th>
										<td><input type="text" readonly="readonly" id="SEQNO" name="SEQNO" class="readOnly w80 inputMoney"/></td>
										<th><label for="a4">총금액</label></th>
										<td>
											<input type="text" readonly="readonly" id="BETRG" name="BETRG" class="readOnly w120 inputMoney"/>										
										</td>
										<th><label for="a5">실지급일</label></th>
										<td><input type="text" readonly="readonly" id="PAYDT" name="PAYDT" class="readOnly w80"/></td>
									</tr>
									<tr>
										<th><label for="a6">차감지급건수</label></th>
										<td><input type="text" readonly="readonly" id="SEQNO1" name="SEQNO1" class="readOnly w80 inputMoney"/></td>
										<th><label for="a7">차감지급금액</label></th>
										<td>
											<input type="text" readonly="readonly" id="BETRG1" name="BETRG1" class="readOnly w120 inputMoney"/>										
										</td>
										<th><label for="a8">비정기급여지급기준일</label></th>
										<td><input type="text" readonly="readonly" id="BONDT" name="BONDT" class="readOnly w80"/></td>
									</tr>									
								</tbody>
							</table>							
                        </div>
                        <!-- end .table --> 		
						</form>
                    </div>
                    <!-- end .tableArea -->
					
					<div class="pb30">
						<div id="payTransferDetailGrid" class="grid-scrolls"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
<script>
$(document).ready(function(){
	//detailSearch();
});

$(function() {
	$("#payTransferDetailGrid").jsGrid({
		height:$(this).find(".jsgrid-grid-body tr:eq(0) td:eq(0)").outerHeight() * 12 ,
		width:"100%",
		sorting : true,
		autoload : true,
		controller : {
			loadData : function() {
				var d = $.Deferred();
				$.ajax({
					type : "get",
					url : "/appr/getPayTransferDetail.json",
					dataType : "json",
					data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
				}).done(function(response) {
					if(response.success) {
						setDetail(response.storeData);
						d.resolve(response.storeData.items);
					}
					else
						alert("조회시 오류가 발생하였습니다. " + response.message);
				});
				return d.promise();
			}
		},
		fields : [
			{
				name : "TYPE_NAME", 
				title : "구분",
				type: "text",
				width: "90",
				align: "center"
			},
			{
				name : "ESRRE", 
				title : "인포멀회/기타공제",
				type: "text",
				width: "172"
			},
			{
				name : "BANKL", 
				title : "은행코드",
				type: "text",
				width: "60",
				align: "center"
			},
			{
				name : "SEQNO", 
				title : "순번",
				type: "text",
				width: "60",
				align: "center"
			},
			{
				name : "ORGTX", 
				title : "부서명",
				type: "text",
				width: "164",
				align: "center"
			},
			{
				name : "PERNR", 
				title : "사번",
				type: "text",
				width: "72",
				align: "center"
			},
			{
				name : "ENAME", 
				title : "이름",
				type: "text",
				width: "82",
				align: "center"
			},
			{
				name : "BANKN", 
				title : "계좌번호",
				type: "text",
				width: "153",
				align: "center"
			},
			{
				name : "BETRG", 
				title : "금액",
				type: "text",
				width: "*",
				align: "right"
			},
		]
	});
});
var setDetail = function(item){
	setTableText(item, "detailForm");
	fncSetFormReadOnly($("#detailForm"), false);
	fncSetFormReadOnly($("#detailForm"), true, new Array("labelReturn", "rejectTxt"));
}

</script>
					</div><!-- end .pb30 -->
