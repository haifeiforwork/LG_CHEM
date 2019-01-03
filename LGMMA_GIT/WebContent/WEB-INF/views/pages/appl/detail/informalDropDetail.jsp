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
	 	<h2 class="subtitle">인포멀 탈퇴신청 상세내역</h2>

			<form id="detailForm" name="detailForm">
				<table class="tableGeneral">
					<caption>인포멀 탈퇴신청 상세내역</caption>
					<div id="informalDrop"></div>
				<!--// list end -->
				<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
				</table>
			</form>

	</div>	



<script>

var detailSearch= function() {

	$.ajax({
		type : "get",
		url : "/appl/getDropInformalDetail.json",
		dataType : "json",
		data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
	}).done(function(response) {
		if(response.success) {
			setDetail(response.E26InfoStateData_vt);
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
			url : '/appl/deleteDropInformal',
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


// 인포멀 가입내역 리스트
$(function() {
	$("#informalDrop").jsGrid({
		height: "auto",
		width: "100%",
		paging: true,
		autoload: true,
		controller : {
			loadData : function() {
				var d = $.Deferred();
				$.ajax({
					type : "GET",
					url : "/appl/getDropInformalDetail.json",
					dataType : "json",
					data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
				}).done(function(response) {
					//console.log(response.E26InfoStateData_vt);
					//console.log(response.e25infoSetter_vt);
					
					
					if(response.success){
						d.resolve(response.E26InfoStateData_vt);
						//console.log(response.E26InfoStateData_vt);
						
					}else{
						alert("조회시 오류가 발생하였습니다. " + response.message);
					}
				});
				return d.promise();
			}
		},
		fields: [
			{ title: "가입일", name: "BEGDA", type: "text", align: "center", width: "19%" },
			{ title: "인포멀회", name: "STEXT", type: "text", align: "center", width: "18%" },
			{ title: "회비(원)", name: "BETRG", type: "text", align: "center", width: "18%" },
			{ title: "간사", name: "ENAME", type: "text", align: "center", width: "18%" },
			{ title: "연락처", name: "USRID", type: "text", align: "center", width: "19%" },
		]
	});
});

</script>