<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hris.E.E34Body.rfc.E34BodyTrainEntRFC" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="tableArea">
	<h2 class="subtitle">체력단련비 신청 상세내역</h2>
	<div class="table">
		<form id="detailForm">
		<table class="tableGeneral">
			<caption>체력단련비 상세내역</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="detailBegda">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly />
				</td>
				<th><label for="a1">결재일</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailDayIn">이용일</label></th>
				<td colspan="3" class="tdDate">
					<input class="datepicker readOnly" type="text" id="detailDayIn" name="DAY_IN" readonly />
					~
					<input class="datepicker readOnly" type="text" id="detailDayOut" name="DAY_OUT" readonly />
					<input class="readOnly w80" type="text" id="detailTrvlGign" name="TRVL_GIGN" readonly />
					<input type="hidden" id="detailDayUse" name="DAY_USE" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailNameGym">이용업체</label></th>
				<td>
					<input class="readOnly w150" type="text" id="detailNameGym" name="NAME_GYM" readonly />
				</td>
				<th><span class="textPink">*</span><label for="detailJomokName">종목</label></th>
				<td colspan="3">
					<select class="readOnly" id="detailJomokCd" name="JOMOK_CD" OnChange="checkEtc()" vname="종목" disabled >
						<option value="">--------</option>
						<%= WebUtil.printOption((new E34BodyTrainEntRFC()).getCodeType()) %>
					</select>
					<input type="text" id="detailJomokTx" name="JOMOK_TX" style="display:none" >
					<input type="hidden" id="detailJomokName" name="JOMOK_NAME" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailMoney">신청금액</label></th>
				<td>
					<input class="inputMoney readOnly w150" type="text" id="detailMoney" name="MONEY" readonly onkeyup="cmaComma(this);" onchange="cmaComma(this);" />
				</td>
				<th><span class="textPink">*</span><label for="detailDateCard">결제일</label></th>
				<td>
					<input class="readOnly w150" type="text" id="detailDateCard" name="DATE_CARD" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="detailMethod1">결제구분</label></th>
				<td colspan="3">
					<input type="radio" id="detailMethod1" name="METHOD" value="1" disabled /><label for="detailMethod1">개인카드</label>
					<input type="radio" id="detailMethod2" name="METHOD" value="2" disabled /><label for="detailMethod2">기타</label>
					<input class="readOnly w80" type="text" id="detailMethodBigo" name="METHOD_BIGO" >
				</td>
<!-- 				<th><label for="inputText02-6">카드번호</label></th>
				<td>
					<input class="readOnly w150" type="text" id="detailNumberCard" name="NUMBER_CARD" readonly />
				</td>
 -->			</tr>
			</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
		</form>
	</div>
</div>

<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getHealthTrainDetail.json",
			dataType : "json",
			data : { "AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>' }
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				$("#detailMoney").val(insertComma(parseInt( $("#detailMoney").val() ).toString()));
				
				$("#detailTrvlGign").val( response.storeData.DAY_USE == "" ? response.storeData.DAY_USE : "(" + response.storeData.DAY_USE + ")" );
			}
			else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
		}
	}
	
	$(document).ready(function(){
		detailSearch();
	});
	
	var checkEtc = function(){
		$("#detailJomokName").val($("#detailJomokCd option:selected").text());
		
		if( "12" == $("#detailJomokCd").val() ){
			$("#detailJomokTx").val("");
			$("#detailJomokTx").show();
		}else{
			
			$("#detailJomokTx").hide();
		}
	}

	$("#detailDayIn, #detailDayOut").change(function(){
		
		if( ($("#detailDayIn").val() != "") && ($("#detailDayOut").val() != "") ){
			var begd  = removePoint($("#detailDayIn").val());
			var endd  = removePoint($("#detailDayOut").val());
			var diff  = parseInt(endd) - parseInt(begd);
			
			$("#detailTrvlGign").val("");
			$("#detailDayUse").val("");
			
			if (diff >0) {
				bday = new Date(begd.substring(0,4),begd.substring(4,6)-1,begd.substring(6,8));
				eday = new Date(endd.substring(0,4),endd.substring(4,6)-1,endd.substring(6,8));
				var betday     = getDayInterval(bday,eday);
				
				$("#detailTrvlGign").val("("+ parseInt(betday-1) +")");
				$("#detailDayUse").val(parseInt(betday-1));
				
			}
		}
	});
	
	function getDayInterval(date1,date2){
		var day = 1000 * 3600 *24 
		return parseInt((date2-date1)/day,10)+1;
	}
		
	
	
</script>