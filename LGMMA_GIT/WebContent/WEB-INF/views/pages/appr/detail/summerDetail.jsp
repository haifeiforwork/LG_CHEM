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
	<h2 class="subtitle">하계조직활성화비 신청 상세내역</h2>
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
				<td class="tdDate" colspan="3">
					<input class="readOnly" type="text" id="requestSummerResortBegda" name="BEGDA" value=""  readonly />
				</td>
            </tr>
            <tr>
            	<th><label for="a1">결재일</label></th>
            	<td class="tdDate"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
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
		fncSetFormReadOnly($("#detailForm"), false);
		fncSetFormReadOnly($("#detailForm"), true, new Array("labelReturn"));
		$("#rejectTxt").css("background", "white");
	}
	
	$(document).ready(function(){
		detailSearch();
	});
	
</script>