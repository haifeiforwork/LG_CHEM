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


	<div class="tableArea">
		<h2 class="subtitle">인포멀 가입신청 상세내역</h2>
		<div class="table">
		<form id="detailForm" name="detailForm">
			<table class="tableGeneral">
			<caption>인포멀 가입신청 상세내역</caption>
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
				<th><span class="textPink">*</span><label for="inputText01-2">인포멀회</label></th>
				<td colspan="3">
					<input class="readOnly w150" type="text" name="STEXT" id="STEXT" readonly vname="인포멀회" required />
				</td>
			</tr>
			<tr>
				<th><label for="inputText01-3">간사</label></th>
				<td>
					<input class="readOnly w150" type="text" name="ENAME" id="ENAME" readonly vname="간사" required />
				</td>
				<th><label for="inputText01-4">연락처</label></th>
				<td>
					<input class="readOnly w150" type="text" name="USRID" id="USRID" readonly vname="연락처" required/>
				</td>
			</tr>
			</tbody>
			</table>
			<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
		</form>
		</div>
	</div>
		
	
<script>
var detailSearch= function() {

	$.ajax({
		type : "get",
		url : "/appl/getJoinInformalDetail.json",
		dataType : "json",
		data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
	}).done(function(response) {
		if(response.success) {
			console.log(response.InfoListData_vt);
			setDetail(response.InfoListData_vt);
			console.log(response.e25infoSetter_vt);
			setDetail(response.e25infoSetter_vt);
			
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


var reqDeleteActionCallBack = function(){
	if(confirm("삭제 하시겠습니까?")) {
		$("#reqDeleteBtn").prop("disabled", true);
		$("#AINF_SEQN").val('${AINF_SEQN}');
		var param = $("#detailForm").serializeArray();
		$("#detailDecisioner").jsGrid("serialize", param);
		jQuery.ajax({
			type : 'post',
			url : '/appl/deleteJoinInformal',
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
	
	