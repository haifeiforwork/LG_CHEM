<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.servlet.Box"%>
<%@ page import="hris.A.*"%>
<%@ page import="hris.A.A14Bank.*"%>
<%@ page import="hris.A.A14Bank.rfc.*"%>
<%@ page import="hris.A.rfc.*"%>

<!--// Page Title start -->
<div class="title">
	<h1>급여계좌</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">급여</a></span></li>
			<li class="lastLocation"><span><a href="#">계좌정보</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" name="tab1" onclick="switchTabs(this, 'tab1');" class="selected">급여계좌신청</a></li>
		<li><a href="#" id="tab2" name="tab2" onclick="switchTabs(this, 'tab2');">경비계좌신청</a></li>
		<li><a href="#" id="tab3" name="tab3" onclick="switchTabs(this, 'tab3');">계좌내역</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<form name="saLform" id="saLform" method="post" action="">
<input type="hidden" name="BANK_NAME" id="BANK_NAME" value="">
<input type="hidden" name="BNKSA" id="BNKSA" value="">
<input type="hidden" name="BANK_FLAG" id="BANK_FLAG" value="01">
<div class="tabUnder tab1">
	<!--// table start -->
	<div class="tableArea">
		<h3 class="subsubtitle">급여계좌신청 정보</h3>
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
							<input type="text" name="BEGDA" value="<%=WebUtil.printDate(DataUtil.getCurrentDate(), ".")%>" class="readOnly" readonly></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>은행코드</th>
						<td><select class="fixedWidth" name="BANK_CODE" id="BANK_CODE"  vname="은행코드" required>
						</select></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>계좌번호</th>
						<td>
							<input class="w200" type="text" name="BANKN" id="BANKN" value=""  vname="계좌번호" required/>
							<span class="noteItem">※ 계좌번호 입력시 '-'는 입력하지 마시기 바랍니다.</span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!--// table end -->
		<div class="tableComment">
			<p>
				<span class="bold">통장사본 1부는 담당자에게 제출하시기 바랍니다.</span>
			</p>
		</div>
	</div>
	<!--// list start -->
	<!--// list end -->
	</form>
	<div class="listArea" id="decisioner"></div>
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" id="salBtn" href="javascript:SalaryClient();"><span>신청</span></a></li>
		</ul>
	</div>
</div>

<!--// Tab1 end -->

<!--// Tab2 start -->
<form name="exTform" id="exTform" method="post" action="">
<input type="hidden" name="BANK_NAME" id="BANK_NAME" value="">
<input type="hidden" name="BNKSA" id="BNKSA" value="">
<input type="hidden" name="BANK_FLAG" id="BANK_FLAG" value="01">
<div class="tabUnder tab2 Lnodisplay">
	<!--// table start -->
	<div class="tableArea">
		<h3 class="subsubtitle">경비계좌신청 정보</h3>
		<div class="buttonArea">
			<ul class="btn_mdl">
			<li><a class="hue" href="/download/salaryForm/계좌변경신청서.ppt" target="_blank"><span>결제계좌 변경신고서</span></a></li>
			</ul>
		</div>	
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
						<td class="tdDate"><input type="text" name="BEGDA" value="<%=WebUtil.printDate(DataUtil.getCurrentDate(), ".")%>" class="readOnly" readonly></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>은행코드</th>
						<td><select class="fixedWidth" name="BANK_CODE" id="BANK_CODE"  vname="은행코드" required>
						</select></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>계좌번호</th>
						<td>
							<input class="w200" type="text" name="BANKN" id="BANKN" value=""  vname="계좌번호" required/>
							<span class="noteItem">※ 계좌번호 입력시 '-'는 입력하지 마시기 바랍니다.</span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">통장사본 1부는 HR담당자에게 제출하시기 바랍니다.</span></p>
			<p><span class="bold colorOrg">경비계좌 변경 시 동일계좌로 법인카드 결제계좌 변경 필수<br/>(개별법인/하이패스카드 사용자 해당)</span></p>
			<ul>
				<li><span class="bold">제출서류 : 결제계좌 변경신고서 1부, 신분증사본 1부, 통장사본 1부</span></li>
				<li><span class="bold">제출처 : 경영지원팀 인혜숙(02-6930-3800)</span></li>
			</ul>
		</div>
	</div>
	<!--// table end -->
	<!--// list start -->
	<!--// list end -->
	</form>
	<div class="listArea" id="extdecisioner"></div>
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" id="extBtn" href="#" onclick="javascript:ExtAccountClient();"><span>신청</span></a></li>
		</ul>
	</div>
</div>

<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<h3 class="subsubtitle">계좌내역</h3>
		<div id="addListGrid"></div>
	</div>
	<!--// list end -->
</div>

<script language="JavaScript">
//최초 로딩시
$(document).ready(function(){
	$('#decisioner').load('/common/getDecisionerGrid?upmuType=10&gridDivId=decisionerGrid');
	$('#extdecisioner').load('/common/getDecisionerGrid?upmuType=80&gridDivId=extdecisionerGrid');
	$("#saLform #BNKSA").val("0");
	bankCode();
	
	$("#tab1").click(function(){
		$("#saLform #BNKSA").val("0");
		$("#exTform #BNKSA").val("");
		bankCode();
	});
	
	$("#tab2").click(function(){
		$("#exTform #BNKSA").val("9");
		$("#saLform #BNKSA").val("");
		bankCode();
	});
	
	$("#tab3").click(function(){
		$("$addListGrid").jsGrid("search");
	});
	
	if($(".layerWrapper").length){
		
	};
 });
	var bankCode = function(){
		var params = "";
		if($("#saLform #BNKSA").val()=="0" && $("#exTform #BNKSA").val() == ""){
			params = $("#saLform #BNKSA").val();
		}else if($("#exTform #BNKSA").val()=="9" && $("#saLform #BNKSA").val() == ""){
			params = $("#exTform #BNKSA").val();
		}
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
    				bankCodeOption(jsonData, data);
    			}
    			else{
    				alert("은행코드 정보가 존재하지 않습니다." + response.message);
    			}
    		}
		});
    };
    
	var bankCodeOption = function(jsonData, data) {
		if(data.BNKSA == "0"){
			$("#saLform #BANK_CODE").empty();
			$("#saLform #BANK_CODE").append('<option value="">----</option>');
		}else if(data.BNKSA == "9"){
			$("#exTform #BANK_CODE").empty();
			$("#exTform #BANK_CODE").append('<option value="">----</option>');
		}
        $.each(jsonData, function (key, value) {
        	if(data.BNKSA == "0"){
        		if(value.BANK_CODE==data.BANK_CODE){
        			$("#saLform #BANK_CODE").append('<option BANKN = '+ data.BANKN +' value=' + value.BANK_CODE +' selected>' + value.BANK_NAME + '</option>');
        			$("#saLform #BANKN").val(data.BANKN);
        		}else{
        			$("#saLform #BANK_CODE").append('<option value=' + value.BANK_CODE +'>' + value.BANK_NAME + '</option>');
        		}
        	}else if(data.BNKSA == "9"){
        		if(value.BANK_CODE==data.BANK_CODE){
        			$("#exTform #BANK_CODE").append('<option BANKN = '+ data.BANKN +'  value=' + value.BANK_CODE +' selected>' + value.BANK_NAME + '</option>');
        			$("#exTform #BANKN").val(data.BANKN);
        		}else{
        			$("#exTform #BANK_CODE").append('<option value=' + value.BANK_CODE +'>' + value.BANK_NAME + '</option>');
        		}
        	}
        });
	}
	
	//급여계좌 변경시
	$("#saLform #BANK_CODE").change(function(){
		$("#saLform #BANKN").val($("#saLform #BANK_CODE option:selected").attr("BANKN"));
		$("#saLform #BANK_NAME").val($("#saLform #BANK_CODE option:selected").text());
	}); 
	
	//경비계좌 변경시
	$("#exTform #BANK_CODE").change(function(){
		$("#exTform #BANKN").val($("#exTform #BANK_CODE option:selected").attr("BANKN"));
		$("#exTform #BANK_NAME").val($("#exTform #BANK_CODE option:selected").text());
	}); 
	

 
// 계좌 내역 그리드
$(function() {
	$("#addListGrid").jsGrid({
		height : "auto",
		width : "100%",
		sorting : true,
		paging : false,
		autoload : true,
		controller : {
			loadData : function() {
				var d = $.Deferred();

				$.ajax({
					type : "GET",
					url : "/salary/getAccountList.json",
					dataType : "json"
				}).done(function(response) {
					d.resolve(response.storeData);
					if(response.success)
						d.resolve(response.storeData);
	    			else
	    				alert("조회시 오류가 발생하였습니다. " + response.message);
				});
				return d.promise();
			}
		},

		fields : [ {
			name : "BNKSA",
			title : "유형",
			align : "center",
			type : "text",
			width : 30,
			itemTemplate : function(value) {
				return (value == 0) ? " 급여계좌" : "경비계좌";
			}
		}, {
			name : "BANK_NAME",
			title : "은행/증권",
			align : "center",
			type : "text",
			width : 35
		}, {
			name : "BANKN",
			title : "계좌번호",
			align : "center",
			type : "number",
			width : 35
		}, ]
	});
});

	// 급여계좌 validation
	var saLcheck_data = function(){
		if($("#saLform #BANK_CODE").val()==""){
			alert("은행코드를 선택하세요");
			return false;
		}
		if($("#saLform #BANKN").val()==""){
			alert("계좌번호를 입력하세요");
			return false;
		}
		return true;
	};

	// 경비계좌 validation
	var exTcheck_data = function(){
		if($("#exTform #BANK_CODE").val()==""){
			alert("은행코드를 선택하세요");
			return false;
		}
		if($("#exTform #BANKN").val()==""){
			alert("계좌번호를 입력하세요");
			return false;
		}
		return true;
	};
//급여계좌신청
	var SalaryClient = function() {
		if( saLcheck_data() ) {
			if(confirm("신청 하시겠습니까?")){
				$("#salBtn").prop("disabled", true);
				$("#saLform #RowCount").val($("#decisionerGrid").jsGrid("dataCount"));
				var param = $("#saLform").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'POST',
					url : '/salary/requestAccount.json',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
					success : function(response) {
		    			if(response.success){
		    				alert("신청 되었습니다.");
		    				// 초기화
		    				$("#saLform #BANK_CODE").val("");
		    				$("#saLform #BANKN").val("");
		    			}else{
		    				alert("신청시 오류가 발생하였습니다. " + response.message);
		    			}
						$("#salBtn").prop("disabled", false);
		    		}
				});
			}
		}
	};
//경비계좌신청
	var ExtAccountClient = function() {
		if( exTcheck_data() ) {
			if(confirm("신청 하시겠습니까?")){
				$("#extBtn").prop("disabled", true);
				$("#exTform #RowCount").val($("#extdecisionerGrid").jsGrid("dataCount"));
				var param = $("#exTform").serializeArray();
				$("#extdecisionerGrid").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'POST',
					url : '/salary/requestAccount.json',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
					success : function(response) {
		    			if(response.success){
		    				alert("신청 되었습니다.");
		    				// 초기화
		    				$("#exTform #BANK_CODE").val("");
		    				$("#exTform #BANKN").val("");
		    			}else{
		    				alert("신청시 오류가 발생하였습니다. " + response.message);
		    			}
						$("#extBtn").prop("disabled", false);
		    		}
				});
			}
		}
	};
</script>