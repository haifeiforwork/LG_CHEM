<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hris.C.C07Language.rfc.C07StudTypeRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="tableArea">
	<h2 class="subtitle">어학지원내역 신청 상세내역</h2>
	<div class="table">
	<form id="detailForm">
		<table class="tableGeneral">
		<caption>신청서 신청</caption>
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
			<th><span class="textPink">*</span><label for="detailSbegDate">학습시작일</label></th>
			<td class="tdDate">
				<input class="datepicker readOnly" type="text" size="5" id="detailSbegDate" name="SBEG_DATE" readonly />
			</td>
			<th><span class="textPink">*</span><label for="detailSendDate">학습종료일</label></th>
			<td class="tdDate">
				<input class="datepicker readOnly" type="text" size="5" id="detailSendDate" name="SEND_DATE" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailStudText">학습형태</label></th>
			<td>
				<select class="w150 readOnly" id="detailStudType" name="STUD_TYPE" vname="학습형태" disabled >
					<option value="">-----------------</option>
					<%= WebUtil.printOption((new C07StudTypeRFC()).getDetail()) %>
				</select>
			</td>
			<th><label for="detailLectTime">수강시간</label></th>
			<td><input class="readOnly w100" type="text" id="detailLectTime" name="LECT_TIME" readonly /></td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailStudInst">학습기관</label></th>
			<td colspan="3">
				<input class="readOnly wPer" type="text" id="detailStudInst" name="STUD_INST" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailLectSbjt">수강과목</label></th>
			<td colspan="3">
				<input class="readOnly wPer" type="text" id="detailLectSbjt" name="LECT_SBJT" readonly />
			</td>
		</tr>	
		<tr>
			<th><span class="textPink">*</span><label for="SELT_GUBN">결제구분</label></th>
			<td>
				<input type="radio" id="detailSeltGubn1" name="SELT_GUBN" value="P" disabled /><label for="detailSeltGubn1">개인카드</label>
				<input type="radio" id="detailSeltGubn2" name="SELT_GUBN" value="X" disabled /><label for="detailSeltGubn2">기타</label>
				<input class="readOnly w150" type="text" id="detailMethodBigo" name="METHOD_BIGO" readonly />
			</td>
			<th><span class="textPink">*</span><label for="detailSeltDate">결제일</label></th>
			<td class="tdDate">
				<input class="datepicker readOnly" type="text" id="detailSeltDate" name="SELT_DATE" readonly />
			</td>
		</tr>
<!-- 		<tr>
			<th><label for="detailCardNumb">카드번호</label></th>
			<td>
				<input class="readOnly w180" type="text" id="detailCardNumb" name="CARD_NUMB" readonly />
			</td>
		</tr>
 -->		<tr>
			<th><span class="textPink">*</span><label for="detailSetlWonx">결제금액</label></th>
			<td>
				<input class="readOnly inputMoney w100" type="text" id="detailSetlWonx" name="SETL_WONX" onkeyup="cmaComma(this);" onchange="cmaComma(this);" readonly > 원
			</td>
			<th><span class="textPink">*</span><label for="detailCardCmpy">학습기관<br/>사업자등록번호</label></th>
			<td>
				<input class="readOnly w180" type="text" id="detailCardCmpy" name="CARD_CMPY" readonly />
			</td>
		</tr>
		</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
		<input type="hidden" id="detailCmpyWonx" name="CMPY_WONX" />
	</form>
	</div>
</div>

<script type="text/javascript">
	
	var detailSearch = function(){
		$.ajax({
			type : "get",
			url : "/appl/getLangSupportDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
			$("#detailSetlWonx").val(insertComma(parseInt( $("#detailSetlWonx").val() ).toString()));
			$('input:radio[name="SELT_GUBN"]:input[value=' + item.SELT_GUBN + ']').prop("checked", true);
			
		}
	}
	
	$(document).ready(function(){
		// 초기화
		detailSearch();
	});
	
</script>
