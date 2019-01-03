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
			<h2 class="subtitle">소액대출신청 조회</h2>
			<div class="table">
				<table class="tableGeneral">
				<caption>소액대출신청</caption>
				<colgroup>
					<col class="col_15p"/>
					<col class="col_85p"/>
				</colgroup>
				<tbody>
				<tr>
					<th><label for="inputText02-1">신청일</label></th>
					<td class="tdDate">
						<input class="readOnly" type="text" name="BEGDA" id="BEGDA"  value=""  />
					</td>
				</tr>
				<input type="hidden" name="DLART" size="50" class="input03" value='0080'>
				<tr>
					<th><span class="textPink">*</span><label for="input-radio01-1">신청금액</label></th>
					<td>
						<input type="radio" name="REQU_MONY" value=1000000 id="REQU_MONY"  onClick="javascript:click_radio(this);" checked="checked" /><label for="input-radio01-1">100만원</label>
						<input type="radio" name="REQU_MONY" value=2000000 id="REQU_MONY"  onClick="javascript:click_radio(this);"/><label for="input-radio01-2">200만원</label>
						<input type="radio" name="REQU_MONY" value=3000000 id="REQU_MONY"  onClick="javascript:click_radio(this);"/><label for="input-radio01-3">300만원</label>
						<input type="radio" name="REQU_MONY" value=5000000 id="REQU_MONY"  onClick="javascript:click_radio(this);"/><label for="input-radio01-4">500만원</label>
                             </td>
				</tr>	
				<tr>
					<th><span class="textPink">*</span><label for="input-radio02-1">상환방법</label></th>
					<td>
                             	<input type="radio" name="GUBN_FLAG" value="P" id="GUBN_FLAG" onClick="javascript:click_radio(this);" checked="checked" /><label for="input-radio02-1">급여(24회 2년상환)</label>
						<input type="radio" name="GUBN_FLAG" value="O" id="GUBN_FLAG" onClick="javascript:click_radio(this);"/><label for="input-radio02-2">급여(12회 1년상환)</label>
<%
		if( user.e_persk.equals("31") ) {
%>
						<input type="radio" name="GUBN_FLAG" value="B" id="GUBN_FLAG" onClick="javascript:click_radio(this);" /><label for="input-radio02-3">급여+정기상여(40회)</label>
						<input type="radio" name="GUBN_FLAG" value="C" id="GUBN_FLAG" onClick="javascript:click_radio(this);" /><label for="input-radio02-4">급여+정기상여(20회)</label>
<%
		} 
%>     
                             </td>
                         </tr>
                         <tr>
					<th><label for="inputText01-3">월 상환금</label></th>
					<td>
						<input class="inputMoney w120 readOnly" type="text" id="TILBT" name="TILBT" value="" readonly/>원
					</td>
				</tr>			
				</tbody>
				</table>
			</div>
			<div class="tableComment">
				<p><span class="bold">매월 21일부터 말일까지는 소액대출 신규 신청을 할 수 없습니다.</span></p>
			</div>
		</div>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
      </form>
	</div>
<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getSmlendingDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				$('input:radio[name="REQU_MONY"]:input[value='+removeComma(response.storeData.REQU_MONY)+']').prop("checked", true);
				$("#TILBT").val(response.storeData.TILBT.format());
			}else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
	}
	
	var setDetail = function(item){
		setTableText(item, "detailForm");
		fncSetFormReadOnly($("#detailForm"), true);
// 		click_radio();
	}
	
	$(document).ready(function(){
		detailSearch();
	});
	
	function click_radio(obj) {
		if($(':radio[name="REQU_MONY"]:checked').val()!=null
		&&	$(':radio[name="GUBN_FLAG"]:checked').val()!=null){
			$("#TILBT").val(cal_money());
		}
	}

	var cal_money = function() {
		var requMony =0;
		var gubnFlag = "";
		var count = 0;
		var money = 0;
		requMony = $(':radio[name="REQU_MONY"]:checked').val();
		gubnFlag = $(':radio[name="GUBN_FLAG"]:checked').val();

	    if( gubnFlag == "P" ){
	    	count = 24;
	    }else if (gubnFlag == "O"){
	    	count = 12;
	    }else if (gubnFlag == "B"){
	    	count = 40;
	    }else if (gubnFlag == "C"){
	    	count = 20;
	    }
	    money = requMony / count;
	    money =  nelim(money);
	    money = money.format();
	    return money;
	}
	
	var reqModifyActionCallBack = function() {
		var periodpicker = $('.mydatepicker');
		for(var i=0;i<periodpicker.length;i++){
			//date 찾아오기
			var dateInput = $(periodpicker[i]).find('input');
			$.each(dateInput, function(i, data){
				var fid = dateInput[0].id;
				$(data).datepicker({
		        });
			});
		}
		fncSetFormReadOnly($("#detailForm"), false,new Array("BEGDA","TILBT"));
	}
	
	var reqSaveActionCallBack = function() {
		if (smlendingCheck()) {
			if (confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateSmlending',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
					success : function(response) {
						if (response.success) {
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
		} else {
			return false;
		}
	};
	
	var smlendingCheck = function(){
		$("#TILBT").val(removeComma($("#TILBT").val()));
		return true;
	}
	
	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteSmlending',
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

