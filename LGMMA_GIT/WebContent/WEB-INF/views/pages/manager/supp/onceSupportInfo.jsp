<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E09House.*" %>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.E.E06Rehouse.*" %>
<%@ page import="hris.E.E06Rehouse.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E36OnceSupport.*" %>
<%@ page import="hris.E.E36OnceSupport.rfc.*" %> 

<%
	WebUserData user = (WebUserData)session.getValue("managedUser");
	Vector      PersLoanData_vt    = (Vector)request.getAttribute("PersLoanData_vt");
	String  flag = (String)request.getAttribute("flag");
%>
<!--// Page Title start -->
<div class="title">
	<h1>구입전환일시지원금</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">구입전환일시지원금</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab1 start -->
<div class="tabUnder tab1">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">구입전환일시지원금 조회</h2>
		<div class="clear"></div>
			<form id = "onceListForm">
			<div id="onceHouse" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
				<input type="hidden" id="SUBTY" name="SUBTY" value="">
				<input type="hidden" id="BEGDA" name="BEGDA" value="">
				<input type="hidden" id="ENDDA" name="ENDDA" value="">
				<input type="hidden" id="BETRG" name="BETRG" value="">
				<input type="hidden" id="ONCE_FLAG" name="ONCE_FLAG" value="">
			</form>
	</div>
	<!--// list end -->
	<!--// Table start -->
	<div class="tableArea">
		<h2 class="subtitle">구입전환일시지원금 상세내역</h2>
		<div class="clear"></div>
		<h3 class="subsubtitle">- 융자현황</h3>
		<div class="table pb30">
			<table class="tableGeneral">
			<caption>융자현황</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th>융자금액</th>
				<td class="alignRight" id="ONCE_E_DARBT"></td>
				<th>월 상환원금</th>
				<td id="ONCE_E_TILBT"></td>
			</tr>
			<tr>
				<th>융자일자</th>
				<td id="ONCE_E_DATBW"></td>
				<th>월 상환이자</th>
				<td id="ONCE_E_BETRG"></td>
			</tr>	
			<tr>
				<th>총상환기간</th>
				<td id="ONCE_E_FROM"></td>
				<th>월 상환금</th>
				<td id="ONCE_E_TILBT_BETRG"></td>
			</tr>
			<tr>
				<th>총상환횟수</th>
				<td id="ONCE_E_ZZRPAY_CONT"></td>
				<th>보증구분</th>
				<td id="ONCE_E_ZZSECU_FLAG"></td>
			</tr>
			</tbody>
			</table>
		</div>
		
		<h3 class="subsubtitle">- 상환내역</h3>
		<div class="table pb30">
			<table class="tableGeneral">
			<caption>상환내역</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th>상환원금누계</th>
				<td class="alignRight" id="ONCE_E_TOTAL_DARBT"></td>
				<th>상환일자</th>
				<td id="ONCE_E_DARBT_BEGDA"></td>
			</tr>
			<tr>
				<th>상환이자누계</th>
				<td id="ONCE_E_TOTAL_INTEREST"></td>
				<th>상 환 횟 수</th>
				<td id="ONCE_E_TOTAL_CONT"></td>
			</tr>
			</tbody>
			</table>
		</div>
		
		<h3 class="subsubtitle">- 잔여금</h3>
		<div class="table">	
			<table class="tableGeneral">
			<caption>상환내역</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th>잔여원금</th>
				<td class="alignRight" id="ONCE_E_REMAIN_BETRG"></td>
				<th>잔여횟수</th>
				<td id="ONCE_E_REMAIN_CONT"></td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>
	<!--// Table end -->
</div>
<!--// Tab1 end -->
<!--------------- layout body end --------------->
<script type="text/javascript">

	$(document).ready(function(){
		getRequMonyGubunCode();
		getMoneyGubunCode();
		getOnceRequestList();
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=35&gridDivId=decisionerGrid');
		$('#refunddecisioner').load('/common/getDecisionerGrid?upmuType=36&gridDivId=refunddecisionerGrid');
		
		// 구입전환일시지원금 조회
		$("#tab1").click(function(){
			$("#onceHouse").jsGrid("search");
		});
		
		// 구입전환일시지원금 신청 금액 조회
		$("#tab2").click(function(){
			getRequMonyGubunCode();
			getMoneyGubunCode();
			getOnceRequestList();
		});
		
		// 구입전환일시지원금 상환 신청 금액 조회
		$("#tab3").click(function(){
			getResotreOnceSupportDetail();
		});
	});
	
	//신청금액에 대한 금액 변경 코드
	var getRequMonyGubunCode = function() {
		
		var money = $(':radio[name="MONEY_GUBUN"]:checked').val();
		
		if (money == "B") {
			$("#REQU_MONY").val("17000000");
		}else if (money == "C") {
			$("#REQU_MONY").val("15000000");
		}else if (money == "D") {
			$("#REQU_MONY").val("8000000");
		}else if (money =="E") {
			$("#REQU_MONY").val("6000000");
		}else if (money =="F") {
			$("#REQU_MONY").val("3000000");
		}else if (money =="G") {
			$("#REQU_MONY").val("20000000");
		}else if(money =="A") {
			$("#REQU_MONY").val("30000000");
		}
	};
	
	// 구입전환일시지원금 신청 금액 조회
	$('input[name="MONEY_GUBUN"]').change(function(){
		getRequMonyGubunCode();
		getMoneyGubunCode();
	}); 
	
	// 구입전환일시지원금 상환 신청 조회
	var getResotreOnceSupportDetail = function() {
		jQuery.ajax({
			type : 'POST',
			url : '/manager/supp/resotreOnceSupportDetail.json',
			cache : false,
			dataType : 'json',
			async :false,
			success : function(response) {
				if(response.success){
						var item = response.storeData[0];
						var itemKey = response.keyData[0];
						var dateKeyFrom = itemKey.I_DATE.substring(0,4) +"."+itemKey.I_DATE.substring(4,6)+"."+itemKey.I_DATE.substring(6,8);
						$("#E_RPAY_AMNT").val(item.E_RPAY_AMNT.format());
						$("#E_INTR_AMNT").val(parseFloat(item.E_INTR_AMNT).toFixed(0).format());
						$("#TOTAL_AMNT").val(item.E_TOTAL_AMNT.format());
						$("#I_DATE").val(dateKeyFrom);
						$("#E_TOTAL_AMNT").val(parseFloat(item.E_TOTAL_AMNT).toFixed(0).format());
						$("#E_DARBT").val(item.E_DARBT.format());
						$("#E_DATBW").val(item.E_DATBW);
						$("#E_ALREADY_AMNT").val(item.E_ALREADY_AMNT.format());
						$("#E_REMAIN_AMNT").val(item.E_REMAIN_AMNT.format());
						$("#E_ZZSECU_FLAG").val(item.E_ZZSECU_TXT);
						$("#I_BETRG").val(itemKey.I_BETRG);
						$("#dataCountRefund").hide();
						$("#onceSupportRefundForm").show();
						$("#decisionerForm").show();
						$("#refunddecisionerForm").show();
					}else{
						$("#dataCountRefund").show();
						$("#onceSupportRefundForm").hide();
						$("#decisionerForm").hide();
						$("#refunddecisionerForm").hide();
					}
			}
		});
	};
	
	// 구입전환일시지원금 신청조회
	var getOnceRequestList = function() {
		jQuery.ajax({
			type : 'POST',
			url : '/manager/supp/getOnceRequestList.json',
			cache : false,
			dataType : 'json',
			async :false,
			success : function(response) {
				if(response.success){
					var item = response.storeData[0];
					$("#E_STRAS").val(item.E_STRAS);
					$("#E_YEARS").val(item.E_YEARS);
					if( "<%=flag%>" == "true" ){
						$("#onceSupportForm").hide();
						$("#decisionerForm").hide();
						$("#dataCountRequest").show();
						$("#refunddecisionerForm").show();
					}else{
						$("#onceSupportForm").show();
						$("#decisionerForm").show();
						$("#dataCountRequest").hide();
						$("#refunddecisionerForm").hide();
					} 
				}else{
					alert("구입전환일시 지원금 신청조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	//구입전환일시지원금 신청 금액 조회
	var getMoneyGubunCode = function() {
		jQuery.ajax({
			type : 'POST',
			url : '/manager/supp/getOnceSupportCode.json',
			cache : false,
			dataType : 'json',
			data : {
				"MONEY_GUBUN" : $(':radio[name="MONEY_GUBUN"]:checked').val(),
				"REFND_GUBUN" : $(':radio[name="REFND_GUBUN"]:checked').val()
			},
			async :false,
			success : function(response) {
				if(response.success){
					var item = response.storeData[0];
					$("#REFND_MONEY").val(item.REFND_MONEY.format());
					$("#REFND_COUNT").val(parseInt(item.REFND_COUNT));
				}else{
					alert("구입전환일시금 신청금액 조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	// 구입전환일시 지원금 조회 그리드
	$(function() {
		$("#onceHouse").jsGrid({
			height: "auto",
			width: "100%",
			paging: true,
			autoload: true,
			pageSize: 10,
			pageButtonCount: 10,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/manager/supp/getOnceSupportList.json",
						dataType : "json",
					}).done(function(response) {
						if(response.success){
							d.resolve(response.storeData);
						}else{
							alert("조회시 오류가 발생하였습니다. " + response.message);
						}
					});
					return d.promise();
				}
			},
			fields: [
				{ title: "선택", name: "th1", align: "center", width: "8%"
					,itemTemplate: function(value, storeData) {
						if(storeData.FLAG == "Y")
							return $("<input name='courRadio' id='courRadio' disabled>").attr("type", "radio")
						else
							return $("<input name='courRadio' id='courRadio' checked>")
									.attr("type", "radio")
									.on("click", function(e) {
										$("#SUBTY").val(storeData.SUBTY);
										$("#BEGDA").val(storeData.BEGDA);
										$("#ENDDA").val(storeData.ENDDA);
										$("#BETRG").val(storeData.BETRG);
										$("#ONCE_FLAG").val(storeData.FLAG);
										
										if( storeData.FLAG == "Y" ){
											alert("대출 진행중인 건에 대해서만 상세조회가 가능합니다.");
											return false;
										}else{
											selectEduChageValue();
										}
									});
					},
				},
				{ title: "융자일자", name: "DATBW", type: "text", align: "center", width: "10%" },
				{ title: "융자형태", name: "STEXT", type: "text", align: "center", width: "16%" },
				{ title: "융자원금", name: "DARBT", type: "text", align: "right", width: "14%"
					,itemTemplate: function(value) {
						return value.format();
					}
				},
				{ title: "상환원금", name: "REDEMPTION", type: "text", align: "right", width: "14%"
					,itemTemplate: function(value) {
						return value.format();
					}
				},
				{ title: "잔여원금", name: "BETRG", type: "text", align: "right", width: "14%"
					,itemTemplate: function(value) {
						return value.format();
					}
				},
				{ title: "상환완료일자", name: "ZAHLD", type: "text", align: "center", width: "10%"
					,itemTemplate: function(value,storeData) {
						return (storeData.FLAG == "Y") ? (value == "0000-00-00" ? "" : value) : ""
					}
				},
				{ title: "일시상환금액", name: "REDARBT", type: "text", align: "right", width: "14%"
					,itemTemplate: function(value,storeData) {
						return (storeData.FLAG == "Y") ? value.format() : ""
					}
				}
			]
		});
	});
	
	// 구입전환일시지원금 상세 조회
	var selectEduChageValue = function(){
		jQuery.ajax({
			type : 'GET',
			url : '/manager/supp/getOnceSupportDetail.json',
			cache : false,
			dataType : 'json',
			data : $('#onceListForm').serialize(),
			async :false,
			success : function(response) {
				if(response.success){
					var item = response.storeData;
					var E_ZZRPAY_MNTH = item.E_ZZRPAY_MNTH.substring(0,4) + "." + item.E_ZZRPAY_MNTH.substring(4,6);
					var E_ENDDA       = item.E_ENDDA.substring(0,4)       + "." + item.E_ENDDA.substring(4,6)      ;
					var E_DARBT_BEGDA = item.E_DARBT_BEGDA.substring(0,4) + "." + item.E_DARBT_BEGDA.substring(4,6);
					var E_DARBT_ENDDA = item.E_DARBT_ENDDA.substring(0,4) + "." + item.E_DARBT_ENDDA.substring(4,6);
					
					//융자현황
					$("#ONCE_E_DARBT").html(item.E_DARBT.format() == "0" ? "" :item.E_DARBT.format());
					$("#ONCE_E_TILBT").html(item.E_TILBT.format() == "0" ? "" :item.E_TILBT.format());
					$("#ONCE_E_DATBW").html(item.E_DATBW);
					$("#ONCE_E_BETRG").html(item.E_BETRG.format() == "0" ? "" :item.E_BETRG.format());
					$("#ONCE_E_FROM").html(E_ZZRPAY_MNTH+ " ~ "+E_ENDDA);
					
					$("#ONCE_E_TILBT_BETRG").html(item.E_TILBT_BETRG.format() == "0" ? "" :item.E_TILBT_BETRG.format());
					$("#ONCE_E_ZZRPAY_CONT").html(parseFloat(item.E_ZZRPAY_CONT));
					$("#ONCE_E_ZZSECU_FLAG").html(item.E_ZZSECU_FLAG == "Y" ? "보증인" :"보험보증가입");
					
					//상환내역
					$("#ONCE_E_TOTAL_DARBT").html(item.E_TOTAL_DARBT.format() == "0" ? "" :item.E_TOTAL_DARBT.format());
					if(item.E_TOTAL_CONT == "0000"){
						
					}else{
						$("#ONCE_E_DARBT_BEGDA").html(E_DARBT_BEGDA+ " ~ "+E_DARBT_ENDDA);
					}
					
					$("#ONCE_E_TOTAL_INTEREST").html(item.E_TOTAL_INTEREST.format() == "0" ? "" :item.E_TOTAL_INTEREST.format());
					$("#ONCE_E_TOTAL_CONT").html(parseFloat(item.E_TOTAL_CONT));
					
					//잔여금
					$("#ONCE_E_REMAIN_BETRG").html(item.E_REMAIN_BETRG.format() == "0" ? "" :item.E_REMAIN_BETRG.format());
					$("#ONCE_E_REMAIN_CONT").html(parseFloat(item.E_REMAIN_CONT) == "0" ? "" :parseFloat(item.E_REMAIN_CONT));
					
				}else{
					alert("조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	
	// 구입전환일시 지원금 신청 validation
	var OnceClientCheck = function() {
		
		if(!checkNullField("onceSupportForm")){
			return false;
		}
		
		if($("#REFND_MONEY").val() == "0" ) {
			alert("신청금액과 상환방법을 입력하세요");
			return false;
		}
		
		//결재자 체크
		if( $("#RowCount").val() < 1 ){
			alert("결재자 정보가 없습니다.");
			return false;
		}
		return true;
	} 
	// 구입전환일시 지원금 신청
	var OnceClient = function() {
		if(confirm("신청 하시겠습니까?")){
			$("#onceSupportBtn").prop("disabled", true);
			$("#onceSupportForm #RowCount").val($("#decisionerGrid").jsGrid("dataCount"));
			if( OnceClientCheck() ) { 
				var param = $("#onceSupportForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'POST',
					url : '/manager/supp/requestOnceSupport.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							// 초기화
							$("#onceSupportForm")[0].reset();
							$("#onceSupport").jsGrid("search");
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#onceSupportBtn").prop("disabled", false);
					}
				}); 
			}
		}
	}
	
	// 구입전환일시지원금 상환신청 validation
	var OnceSupportRefundClientCheck = function() {
		
		if(!checkNullField("onceSupportRefundForm")){
			return false;
		}
		
		var now = new Date();
		var sysDate = now.getDate();
		
		if ( sysDate >= 21 && sysDate <=31 ) {
			alert("매월 21일부터 말일까지는 상환 신청을 할 수 없습니다.");
			return false;
		}
		
		
		if(!checkdate($("#I_DATE"))){
			return false;
		}
		
		var date_from  = $("#onceSupportRefundForm #BEGDA").val().replace(/\./g,'');
		var date_to    = $("#onceSupportRefundForm #I_DATE").val().replace(/\./g,'');
		
		dif = dayDiff(addSlash(date_from), addSlash(date_to));
		
		if( dif > 7) {
			alert("입금일자는 신청일 1주일 이내만 가능합니다.");
			return false;
		}
		
		if($("#E_REMAIN_AMNT").val() == "0"){
			alert("대출잔액이 없습니다.");
			return false;
		}
		
		//결재자 체크
		if( $("#onceSupportRefundForm #RowCount").val() < 1 ){
			alert("결재자 정보가 없습니다.");
			return false;
		}
		return true;
	} 
	// 구입전환일시지원금 상환신청
	var OnceSupportRefundClient = function() {
		if(confirm("신청 하시겠습니까?")){
			$("#onceSupportRefundBtn").prop("disabled", true);
			$("#onceSupportRefundForm #RowCount").val($("#refunddecisionerGrid").jsGrid("dataCount"));
			if( OnceSupportRefundClientCheck() ) { 
				var param = $("#onceSupportRefundForm").serializeArray();
				$("#refunddecisionerGrid").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'POST',
					url : '/manager/supp/requestOnceSupportRefund.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							// 초기화
							$("#onceSupportRefundForm")[0].reset();
							$("#onceSupportRefund").jsGrid("search");
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#onceSupportRefundBtn").prop("disabled", false);
					}
				}); 
			}
		}
	}
</script>