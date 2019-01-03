<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="hris.D.D03Vocation.rfc.D03VocationAReasonRFC"%>
<%@ page import="hris.D.D03Vocation.D03VocationReasonData"%>
<%@ page import="hris.E.E19Congra.rfc.E19CongCodeRFC"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
%>

<div class="tableArea">
	<h2 class="subtitle">휴가 신청 상세내역</h2>
	<div class="table">
		<form id="detailForm">
		<input type="hidden" name="E_AUTH" />
		<table class="tableGeneral">
		<caption>휴가신청</caption>
		<colgroup>
			<col class="col_15p">
			<col class="col_35p">
			<col class="col_15p">
			<col class="col_35p">
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText01-1">신청일</label></th>
			<td class="tdDate">
				<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly="readonly" />
			</td>
			<th><label for="a1">결재일</label></th>
			<td class="tdDate">
				<input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly">
			</td>
		</tr>
		<tr id="vocaTypePanel" style="display:none;">
			<th><span class="textPink">*</span><label for="input_radio01_1">휴가유형</label></th>
			<td colspan="3"><span id="vocaTypeTxt"></span></td>
		</tr>
		<tr id="vocaType0Panel" style="display:none;">
			<th><span class="textPink">*</span><label for="input_radio01_1">휴가구분</label></th>
			<td colspan="3">
				<ul class="tdRadioList">
					<li><input type="radio" name="awartRadio" value="0111" id="input_radio02_1" disabled /><label for="input_radio02_1">전일휴가</label></li>
					<li><input type="radio" name="awartRadio" value="0112" id="input_radio02_2" disabled /><label for="input_radio02_2">반일휴가(전반)</label></li>
					<li><input type="radio" name="awartRadio" value="0113" id="input_radio02_3" disabled /><label for="input_radio02_3">반일휴가(후반)</label></li>
				</ul>
			</td>
		</tr>
		<tr id="vocaType1Panel" style="display:none;">
			<th><span class="textPink">*</span><label for="input_radio01_1">휴가구분</label></th>
			<td colspan="3">
				<ul class="tdRadioList">
					<li><input type="radio" id="input_radio01_1" name="awartRadio" value="0110" disabled /><label for="input_radio01_1">전일휴가</label></li>
					<li><input type="radio" id="input_radio01_2" name="awartRadio" value="0123" disabled /><label for="input_radio01_2">반일휴가(전반)</label></li>
					<li><input type="radio" id="input_radio01_3" name="awartRadio" value="0124" disabled /><label for="input_radio01_3">반일휴가(후반)</label></li>
					<li><input type="radio" id="input_radio01_4" name="awartRadio" value="0190" disabled /><label for="input_radio01_4">모성보호휴가</label></li>
					<li><input type="radio" id="input_radio01_5" name="awartRadio" value="0340" disabled /><label for="input_radio01_5">유휴</label></li>
					<li><input type="radio" id="input_radio01_6" name="awartRadio" value="0140" disabled /><label for="input_radio01_6">하계휴가</label></li>
					<li><input type="radio" id="input_radio01_7" name="awartRadio" value="0130" disabled /><label for="input_radio01_7">경조공가</label></li>
					<li><input type="radio" id="input_radio01_8" name="awartRadio" value="0170" disabled /><label for="input_radio01_8">전일공가</label></li>
					<li><input type="radio" id="input_radio01_8" name="awartRadio" value="0180" disabled /><label for="input_radio01_9">시간공가 </label></li>
					<li><input type="radio" id="input_radio01_10" name="awartRadio" value="0150" disabled /><label for="input_radio01_10">보건휴가</label></li>
					<li><input type="radio" id="input_radio01_11" name="awartRadio" value="0220" disabled /><label for="input_radio01_11">지각</label></li>
					<li><input type="radio" id="input_radio01_12" name="awartRadio" value="0230" disabled /><label for="input_radio01_12">조퇴</label></li>
					<li><input type="radio" id="input_radio01_14" name="awartRadio" value="0133" disabled /><label for="input_radio01_14">난임휴가(유급)</label></li>
					<li><input type="radio" id="input_radio01_13" name="awartRadio" value="0134" disabled /><label for="input_radio01_13">난임휴가(무급)</label></li>
				</ul>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailReason">신청사유</label></th>
			<td colspan="3">
				<select class="readOnly" id="detailOvtmCode1" name="OVTM_CODE1" vname="신청사유" disabled >
					<option value="">---------선택---------</option>
<%
				//전일 공가  추가 ( 이세희 대리)
				Vector D03VocationAReason_vt1  = (new D03VocationAReasonRFC()).getSubtyCode(userData.companyCode, userData.empNo, "0170" , DataUtil.getCurrentDate());
					for( int j = 0 ; j < D03VocationAReason_vt1.size() ; j++ ){
					D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt1.get(j);
					CodeEntity code_data = new CodeEntity();
%>
					<option value ="<%=old_data.SCODE%>"><%=old_data.STEXT %></option>
<%
				}
%>
				</select>
				<select class="readOnly" id="detailOvtmCode2" name="OVTM_CODE2" vname="신청사유" disabled>
					<option value="">---------선택---------</option>
<%
				//전일 공가  추가 ( 이세희 대리)
				Vector D03VocationAReason_vt2  = (new D03VocationAReasonRFC()).getSubtyCode(userData.companyCode, userData.empNo, "0180" , DataUtil.getCurrentDate());
				for( int j = 0 ; j < D03VocationAReason_vt2.size() ; j++ ){
					D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt2.get(j);
					CodeEntity code_data = new CodeEntity();
%>
					<option value ="<%=old_data.SCODE%>"><%=old_data.STEXT %></option>
<%
				}
%>
				</select>
				<select class="readOnly" id="detailCongCode" name="CONG_CODE" vname="신청사유" disabled >
					<option value="">---------선택---------</option>
					<%= WebUtil.printOption((new E19CongCodeRFC()).getCongCode(userData.companyCode,"X") )%>
				</select>
				
				<input class="readOnly" type="text" id="detailReason" name="REASON" vname="신청사유" readOnly />
			</td>
		</tr>
		<tr>
			<th><label for="detailOvtmName">대근자</label></th>
			<td colspan="3">
				<input class="fixedWidth readOnly" type="text" id="detailOvtmName" name="OVTM_NAME" readOnly />
				<span class="noteItem colorRed">※ 교대조는 필수입력 사항입니다. </span>
			</td>
		</tr>
		<tr>
			<th><label for="detailPRemain">잔여휴가일수</label></th>
			<td colspan="3">
				<input class="fixedWidth readOnly alignCenter" type="text" id="detailPRemain" name="P_REMAIN" readonly/> 일
				<span id="detailRemainText" class="noteItem colorBlue"></span>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailApplFrom">휴가기간</label></th>
			<td class="tdDate" colspan="3">
				<input class="datepicker readOnly" type="text" id="detailApplFrom" name="APPL_FROM" size="5" vname="휴가시작일" />
				~
				<input class="datepicker readOnly" type="text" id="detailApplTo" name="APPL_TO" size="5" vname="휴가종료일" />
			</td>
		</tr>
		 <tr>
			<th><label for="detailBeguzHh">신청시간</label></th>
			<td colspan="3">
				<select class="w50 readOnly" id="detailBeguzHh" name="BEGUZ_HH" disabled >
<%
			for( int i = 0 ; i < 24 ; i++ ) {
				String temp = Integer.toString(i);
%>
					<option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
			}
%>
				</select>
				:
				<select class="w50 readOnly" id="detailBeguzMm" name="BEGUZ_MM" disabled >
<%
			for( int i = 0 ; i < 60 ; i++ ) {
				String temp = Integer.toString(i);
%>
					<option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
			}
%>
				</select>
				~
				<select class="w50 readOnly" id="detailEnduzHh" name="ENDUZ_HH" disabled >
<%
			for( int i = 0 ; i < 24 ; i++ ) {
				String temp = Integer.toString(i);
%>
					<option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
			}
%>
				</select>
				:
				<select class="w50 readOnly" id="detailEnduzMm" name="ENDUZ_MM" disabled >
<%
			for( int i = 0 ; i < 60 ; i++ ) {
				String temp = Integer.toString(i);
%>
					<option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
			}
%>
				</select>
				<span id="timeItemInfoTxt" class="noteItem colorRed"></span>
			</td>
		</tr>
		<tr>
			<th><label for="detailDeductDate">휴가공제일수</label></th>
			<td colspan="3"><input class="readOnly" type="text" id="detailDeductDate" name="DEDUCT_DATE" readOnly /> 일</td>
		</tr>
		</tbody>
		</table>
		
		<input type="hidden" id="AINF_SEQN"        name="AINF_SEQN" />
		<input type="hidden" id="detailAwart"      name="AWART" />
		<input type="hidden" id="detailBeguz"      name="BEGUZ" />
		<input type="hidden" id="detailEnduz"      name="ENDUZ" />
		<input type="hidden" id="detailVacatiDate" name="VACATI_DATE" />
		<input type="hidden" id="detailRemainDate" name="REMAIN_DATE" />
		
		<input type="hidden" id="detailBeAlloDay"  name="BE_ALLO_DAY" />
		<input type="hidden" id="detailSelectC"    name="SELECT_C" />
		<input type="hidden" id="detailOvtmCode"   name="OVTM_CODE" />
		</form>
	</div>
	<div class="tableComment">
		<p><span class="bold">유휴(휴일비근무)는 전문기술직 전용 휴가구분입니다. </span></p>
		<p><span class="bold">난임휴가는 연간 3일 한도로(최초 1일 유급, 나머지 2일 무급)사용 가능합니다.</span></p>
		<p><span class="bold">여성에 한하여 근태월 기준 월1일의 보건휴가(무급) 또는 모성보호휴가(임신 시, 유급) 사용 가능합니다.</span></p>
		
		<p id="Message_1" name="Message_1">
			<span class="colorRed">6일 이상의 경조휴가 기간 중 유급휴무일인 토요일은 경조휴가 일수에 포함되므로 휴가기간 입력시 반드시 토요일을 포함하여 시작일, 종료일을 입력해야 합니다.</span>
		</p>
	</div>
</div>


<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getVacationDetail.json",
			dataType : "json",
			data : {
					"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>',
					"PERNR" : '<c:out value="${PERNR}" />'
			}
		}).done(function(response) {
			if(response.success) {
				var eAuth = response.eAuth
					, iMode = response.iMode
					, vacationData = response.storeData
					, remainData = response.d03RemainVocationData
					, PRemain
					, PRemainTxt;
				
				$('input[name=E_AUTH]').val(eAuth);
				
				if(eAuth == 'Y') {
					$('#input_radio01_11').parent().hide();
					$('#input_radio01_12').parent().hide();
					$('#vocaTypePanel').show();
					if(iMode == 'A') {
						$('#vocaTypeTxt').text('휴가(연차,경조,공가 등)');
						$('#vocaType1Panel').show();
						
						PRemain = remainData.E_REMAIN == "0" ? "0" : insertComma(parseFloat(remainData.E_REMAIN).toString());
						PRemain += "/";
						PRemain += remainData.ZKVRB2 =="0" ? "0" : insertComma(parseFloat(remainData.ZKVRB2).toString());
						PRemain += "/";
						PRemain += remainData.VACATION =="0" ? "0" : insertComma(parseFloat(remainData.VACATION).toString());
						
						PRemainTxt = '(연월차/선택적보상/하계)';
					} else {
						$('#vocaTypeTxt').text('보상휴가');
						$('#vocaType0Panel').show();
						
						PRemain = remainData.E_REMAIN == "0" ? "0" : insertComma(parseFloat(remainData.E_REMAIN).toString());
						
						PRemainTxt = remainData.ZKVRBTX;
					}
					
					$('#timeItemInfoTxt').text('※ 신청시간은 시간공가의 경우에만 입력 가능합니다.');
				} else {
					$('#vocaType1Panel').show();
					
					PRemain = response.d03RemainVocationData.P_REMAIN == "0" ? "0" : insertComma(parseFloat(response.d03RemainVocationData.P_REMAIN).toString());
					PRemain += "/";
					PRemain += response.d03RemainVocationData.P_SELECT_C =="0" ? "0" : insertComma(parseFloat(response.d03RemainVocationData.P_SELECT_C).toString());
					PRemain += "/";
					PRemain += response.d03RemainVocationData.P_VACATION =="0" ? "0" : insertComma(parseFloat(response.d03RemainVocationData.P_VACATION).toString());
					
					PRemainTxt = '(연월차/선택적보상/하계)';
					
					$('#timeItemInfoTxt').text('※ 신청시간은 반일휴가,시간공가,지각,조퇴의 경우에만 입력 가능합니다.');
				}
				
				setDetail(response.storeData);
				
				$("#detailPRemain").val(PRemain);
				
				var remainText = "";
				//if(response.d03RemainVocationData.P_BE_ALLO != "0"){
				//	remainText += "/사전부여";
				//}
				
				$("#detailRemainText").text(PRemainTxt);
				
				// 경조공가
				if(response.storeData.AWART == '0130'){
					$("#detailCongCode").val(response.storeData.CONG_CODE);
				}
				// 전일공가
				if(response.storeData.AWART == '0170'){
					$("#detailOvtmCode1").val(response.storeData.OVTM_CODE);
				}
				// 시간공가
				if(response.storeData.AWART == '0180'){
					$("#detailOvtmCode2").val(response.storeData.OVTM_CODE);
				}
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
			$("input:radio[name='awartRadio']:input[value=" + item.AWART + "]").prop("checked", true);
			$("input:radio[name='awartRadio']").change();
			
			$("#detailDeductDate").val(Number(item.DEDUCT_DATE));
			$("#detailReason").val(item.REASON);
			
			if(item.BEGUZ != ""){
				$("#detailBeguzHh").val(item.BEGUZ.substring(0,2));
				$("#detailBeguzMm").val(item.BEGUZ.substring(2,4));
			}
			if(item.ENDUZ != ""){
				$("#detailEnduzHh").val(item.ENDUZ.substring(0,2));
				$("#detailEnduzMm").val(item.ENDUZ.substring(2,4));
			}
			
			$("#detailBeguzHh").prop("disabled",true).addClass('readOnly');
			$("#detailBeguzMm").prop("disabled",true).addClass('readOnly');
			$("#detailEnduzHh").prop("disabled",true).addClass('readOnly');
			$("#detailEnduzMm").prop("disabled",true).addClass('readOnly');
		}
	}
	
	
	$(document).ready(function(){
		// 초기화
		detailSearch();
	});
	
	// 휴가구분 변경시
	$("input:radio[name='awartRadio']").change(function(){
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		$("#detailReason").val("");

		// 경조공가
		if(radioCheck == '0130'){
			$("#detailCongCode").show();
			$("#Message_1").show();
		}else{
			$("#detailCongCode").hide().val("");
			$("#Message_1").hide();
		}
		
		// 전일공가
		if(radioCheck == '0170'){
			$("#detailOvtmCode1").show();
		}else{
			$("#detailOvtmCode1").hide().val("");
		}
		
		// 시간공가
		if(radioCheck == '0180'){
			$("#detailOvtmCode2").show();
		}else{
			$("#detailOvtmCode2").hide().val("");
		}
		
		// 신청시간 체크
		var eAuth = $('input[name=E_AUTH]').val();
		// 사무직 - 시간공가
		if(eAuth == 'Y' && radioCheck == '0180') {
			$("#detailBeguzHh").prop("disabled",false).removeClass('readOnly');
			$("#detailBeguzMm").prop("disabled",false).removeClass('readOnly');
			$("#detailEnduzHh").prop("disabled",false).removeClass('readOnly');
			$("#detailEnduzMm").prop("disabled",false).removeClass('readOnly');
		}
		// 현장직 - 반일휴가(전반, 후반), 시간공가, 지각, 조퇴
		else if(eAuth != 'Y' && (radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' || radioCheck == '0220' || radioCheck == '0230')) { // 반일휴가(전반, 후반), 시간공가
			$("#detailBeguzHh").prop("disabled",false).removeClass('readOnly');
			$("#detailBeguzMm").prop("disabled",false).removeClass('readOnly');
			$("#detailEnduzHh").prop("disabled",false).removeClass('readOnly');
			$("#detailEnduzMm").prop("disabled",false).removeClass('readOnly');
		}
		// 나머지 휴가구분의 경우
		else {
			$("#detailBeguzHh").val("00").prop("disabled",true).addClass('readOnly');
			$("#detailBeguzMm").val("00").prop("disabled",true).addClass('readOnly');
			$("#detailEnduzHh").val("00").prop("disabled",true).addClass('readOnly');
			$("#detailEnduzMm").val("00").prop("disabled",true).addClass('readOnly');
		}
		
		$("#detailAwart").val(radioCheck);
		
		// 공제일수
		if( radioCheck =='0110' || radioCheck =='0111' ) { // 전일휴가
			$("#detailDeductDate").val('1');
		} else if( radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0112' || radioCheck == '0113' ){   // 반일휴가(전반, 후반)
			$("#detailDeductDate").val('0.5');
		}else if( radioCheck == '0180' ){   // 시간공가
			$("#detailDeductDate").val('0');
		} else {
			$("#detailDeductDate").val('0');
		}
	});
	
</script>