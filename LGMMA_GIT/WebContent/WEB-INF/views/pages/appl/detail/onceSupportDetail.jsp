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
	<h2 class="subtitle">구입전환일시지원금 신청</h2>
	<div class="table" >
	<form id="detailForm">
		<table class="tableGeneral">
		<caption>구입전환일시지원금 신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_85p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="detailBegda">신청일</label></th>
			<td class="tdDate">
				<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="detailEStras">현주소</label></th>
			<td>
				<input class="readOnly wPer" type="text" id="detailEStras"  name="E_STRAS" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="detailEYears">근속년수</label></th>
			<td>
				<input class="alignRight w120 readOnly" type="text" id="detailEYears" name="E_YEARS" readonly /> 년
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailMoneyGubun1">신청금액</label></th>
			<td>
				<input type="radio" class="readOnly" id="detailMoneyGubun1" name="MONEY_GUBUN" value="A" disabled /><label for="detailMoneyGubun1">3,000만원</label>
				<input type="radio" class="readOnly" id="detailMoneyGubun2" name="MONEY_GUBUN" value="G" disabled /><label for="detailMoneyGubun2">2,000만원</label>
				<input type="radio" class="readOnly" id="detailMoneyGubun3" name="MONEY_GUBUN" value="B" disabled /><label for="detailMoneyGubun3">1,700만원</label>
				<input type="radio" class="readOnly" id="detailMoneyGubun4" name="MONEY_GUBUN" value="C" disabled /><label for="detailMoneyGubun4">1,500만원</label>
				<input type="radio" class="readOnly" id="detailMoneyGubun5" name="MONEY_GUBUN" value="D" disabled /><label for="detailMoneyGubun5">800만원</label>
				<input type="radio" class="readOnly" id="detailMoneyGubun6" name="MONEY_GUBUN" value="E" disabled /><label for="detailMoneyGubun6">600만원</label>
				<input type="radio" class="readOnly" id="detailMoneyGubun7" name="MONEY_GUBUN" value="F" disabled /><label for="detailMoneyGubun7">300만원</label>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailGubnFlag1">상환방법</label></th>
			<td>
				<input type="radio" class="readOnly" id="detailGubnFlag1" name="GUBN_FLAG" value="P" disabled /><label for="detailGubnFlag1">정기급여 상환</label>
				<% if ( user.e_persk.equals("31")){  %> 
					<input type="radio" class="readOnly" id="detailGubnFlag2" name="GUBN_FLAG" value="E" disabled /><label for="detailGubnFlag2"> 정기급여 + 정기상여 상환</label> 
					<input type="radio" class="readOnly" id="detailGubnFlag3" name="GUBN_FLAG" value="F" disabled /><label for="detailGubnFlag3">정기상여 상환</label>
					<input type="radio" class="readOnly" id="detailGubnFlag4" name="GUBN_FLAG" value="G" disabled /><label for="detailGubnFlag4">년말년초 상환(12, 2월)</label>
				<% } %>
			</td>
		</tr>
		<tr>
			<th><label for="detailRefndMoney">상환원금</label></th>
			<td>
				<input class="inputMoney w120 readOnly" type="text" id="detailRefndMoney" name="REFND_MONEY" readonly /> 원
			</td>
		</tr>
		<tr>
			<th><label for="detailRefndCount">상환횟수</label></th>
			<td>
				<input class="inputMoney w120 readOnly" type="text" id="detailRefndCount" name="REFND_COUNT" readonly / >
			</td>
		</tr>
		<tr>
			<th><label for="detailZzsecuFlag1">보증여부</label></th>
			<td>
				<input type="radio" class="readOnly" id="detailZzsecuFlag1" name="ZZSECU_FLAG" value="N" disabled /><label for="detailZzsecuFlag1">보증보험 가입</label>
				<!-- <input type="radio" class="readOnly" id="detailZzsecuFlag2" name="ZZSECU_FLAG" value="R" disabled /><label for="detailZzsecuFlag2">퇴직금 담보</label> -->
			</td>
		</tr>
		</tbody>
		</table>
	<input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
	<input type="hidden" name="DLART" value="0030">
	<input type="hidden" id="detailRefndIntrt" name="REFND_INTRT" />
	<input type="hidden" id="detailRefndSum" name="REFND_SUM" />
	<input type="hidden" id="detailRequMony" name="REQU_MONY" >
	</form>
	</div>
</div>

<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getOnceSupportDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response);
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(response){
			setTableText(response.storeData, "detailForm");
			setTableText(response.E05PersInfoData, "detailForm");
			setTableText(response.e36TempLoanEatraData, "detailForm");
			
			$("#detailRefndMoney").val(insertComma(parseInt($("#detailRefndMoney").val()).toString()));
			$("#detailRefndCount").val(insertComma(parseInt($("#detailRefndCount").val()).toString()));
			$("#detailRefndIntrt").val(insertComma(parseInt($("#detailRefndIntrt").val()).toString()));
			$("#detailRefndSum").val(insertComma(parseInt($("#detailRefndSum").val()).toString()));
			
		}
	}
	
	$(document).ready(function(){
		// 초기화
		detailSearch();
	});
	$('input[name="MONEY_GUBUN"]').change(function(){
		getRequMonyGubunCode();
		getMoneyGubunCode();
	});
	
	$('input[name="GUBN_FLAG"]').change(function(){
		getRequMonyGubunCode();
		getMoneyGubunCode();
	});
	
	// 구입전환일시지원금 신청 금액 조회
	$('input[name="ZZSECU_FLAG"]').change(function(){
		getRequMonyGubunCode();
		getMoneyGubunCode();
	});
	
	//신청금액에 대한 금액 변경 코드
	var getRequMonyGubunCode = function() {
		
		var money = $(':radio[name="MONEY_GUBUN"]:checked').val();
		
		if (money == "B") {
			$("#detailRequMony").val("17000000");
		}else if (money == "C") {
			$("#detailRequMony").val("15000000");
		}else if (money == "D") {
			$("#detailRequMony").val("8000000");
		}else if (money =="E") {
			$("#detailRequMony").val("6000000");
		}else if (money =="F") {
			$("#detailRequMony").val("3000000");
		}else if (money =="G") {
			$("#detailRequMony").val("20000000");
		}else if(money =="A") {
			$("#detailRequMony").val("30000000");
		}
	};
	
	//구입전환일시지원금 신청 금액 조회
	var getMoneyGubunCode = function() {
		jQuery.ajax({
			type : 'POST',
			url : '/appl/getOnceSupportCode.json',
			cache : false,
			dataType : 'json',
			data : {
				"MONEY_GUBUN" : $(':radio[name="MONEY_GUBUN"]:checked').val(),
				"REFND_GUBUN" : $(':radio[name="GUBN_FLAG"]:checked').val()
			},
			async :false,
			success : function(response) {
				if(response.success){
					var item = response.storeData[0];
					$("#detailRefndMoney").val(item.REFND_MONEY.format());
					$("#detailRefndCount").val(parseInt(item.REFND_COUNT));
				}else{
					alert("구입전환일시금 신청금액 조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		$("input:radio[name='MONEY_GUBUN']").removeClass("readOnly").prop("disabled",false);
		$("input:radio[name='GUBN_FLAG']").removeClass("readOnly").prop("disabled",false);
		$("input:radio[name='ZZSECU_FLAG']").removeClass("readOnly").prop("disabled",false);
	}
	
	
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
				url : '/appl/deleteOnceSupport',
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
	
	
	// 취소(수정 취소) 버튼 클릭
	var reqCancelActionCallBack = function(){
		$("#detailForm").each(function(){
			this.reset();
		});
		
		detailSearch();
		
		$("input:radio[name='MONEY_GUBUN']").addClass("readOnly").prop("disabled",true);
		$("input:radio[name='REFND_GUBUN']").addClass("readOnly").prop("disabled",true);
		$("input:radio[name='ZZSECU_FLAG']").addClass("readOnly").prop("disabled",true);
	}
	
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(confirm("저장하시겠습니까?")) {
			$("#reqSaveBtn").prop("disabled", true);
			$("#detailAinfSeqn").val('${AINF_SEQN}');
			
			$("#detailRefndMoney").val( parseInt($("#detailRefndMoney").val() == "" ? "0" : removeComma($("#detailRefndMoney").val() ) ) );
			$("#detailRefndCount").val( parseInt($("#detailRefndCount").val() == "" ? "0" : removeComma($("#detailRefndCount").val() ) ) );
			$("#detailRefndIntrt").val( parseInt($("#detailRefndIntrt").val() == "" ? "0" : removeComma($("#detailRefndIntrt").val() ) ) );
			$("#detailRefndSum").val( parseInt($("#detailRefndSum").val() == "" ? "0" : removeComma($("#detailRefndSum").val() ) ) );
			
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'post',
				url : '/appl/updateOnceSupport',
				cache : false,
				dataType : 'json',
				data : param,
				async : false,
				success : function(response) {
					if(response.success) {
						alert("저장되었습니다.");
						$('#applDetailArea').html('');
						$("#reqApplGrid").jsGrid("search");
						return true;
					} else {
						alert("저장시 오류가 발생하였습니다. " + response.message);
						return false;
					}
					$("#reqSaveBtn").prop("disabled", false);
				}
			});
			
			
		}
	}

</script>