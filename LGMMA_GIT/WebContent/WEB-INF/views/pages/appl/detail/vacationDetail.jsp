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
	<h2 class="subtitle">휴가신청</h2>
	<div class="table">
		<form id="detailForm">
		<input type="hidden" name="E_AUTH" value="" />
		<table class="tableGeneral">
		<caption>휴가신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_85p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText01-1">신청일</label></th>
			<td class="tdDate">
				<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly="readonly" />
			</td>
		</tr>
		<tr id="vocaTypePanel" style="display:none;">
			<th><span class="textPink">*</span><label for="input_radio01_1">휴가유형</label></th>
			<td>
				<ul class="tdRadioList">
					<li style="width:160px;"><input type="radio" name="vocaType" value="A" id="voca_radio01_1" disabled /><label for="voca_radio01_1">휴가(연차,경조,공가 등)</label></li>
					<li><input type="radio" name="vocaType" value="B" id="voca_radio01_0" disabled /><label for="voca_radio01_0">보상휴가</label></li>
				</ul>
			</td>
		</tr>
		<tr id="vocaType0Panel" style="display:none;">
			<th><span class="textPink">*</span><label for="input_radio01_1">휴가구분</label></th>
			<td>
				<ul class="tdRadioList">
					<li><input type="radio" name="awartRadio" value="0111" id="input_radio02_1" disabled /><label for="input_radio02_1">전일휴가</label></li>
					<li><input type="radio" name="awartRadio" value="0112" id="input_radio02_2" disabled /><label for="input_radio02_2">반일휴가(전반)</label></li>
					<li><input type="radio" name="awartRadio" value="0113" id="input_radio02_3" disabled /><label for="input_radio02_3">반일휴가(후반)</label></li>
				</ul>
			</td>
		</tr>
		<tr id="vocaType1Panel" style="display:none;">
			<th><span class="textPink">*</span><label for="input_radio01_1">휴가구분</label></th>
			<td>
				<ul class="tdRadioList">
					<li><input type="radio" id="input_radio01_1" name="awartRadio" value="0110" disabled /><label for="input_radio01_1">전일휴가</label></li>
					<li><input type="radio" id="input_radio01_2" name="awartRadio" value="0123" disabled /><label for="input_radio01_2">반일휴가(전반)</label></li>
					<li><input type="radio" id="input_radio01_3" name="awartRadio" value="0124" disabled /><label for="input_radio01_3">반일휴가(후반)</label></li>
<%
				//  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다.
				if( !userData.e_regno.equals("") && userData.e_regno.substring(6,7).equals("2") ) {
%>
					<li><input type="radio" id="input_radio01_4" name="awartRadio" value="0190" disabled /><label for="input_radio01_4">모성보호휴가</label></li>
<%
				}
%>
					<li><input type="radio" id="input_radio01_5" name="awartRadio" value="0340" disabled /><label for="input_radio01_5">유휴</label></li>
					<li><input type="radio" id="input_radio01_6" name="awartRadio" value="0140" disabled /><label for="input_radio01_6">하계휴가</label></li>
					<li><input type="radio" id="input_radio01_7" name="awartRadio" value="0130" disabled /><label for="input_radio01_7">경조공가</label></li>
					<li><input type="radio" id="input_radio01_8" name="awartRadio" value="0170" disabled /><label for="input_radio01_8">전일공가</label></li>
					<li><input type="radio" id="input_radio01_9" name="awartRadio" value="0180" disabled /><label for="input_radio01_9">시간공가</label></li>
<%
				//  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다.
				if( !userData.e_regno.equals("") && userData.e_regno.substring(6,7).equals("2") ) {
%>
					<li><input type="radio" id="input_radio01_10" name="awartRadio" value="0150" disabled /><label for="input_radio01_10">보건휴가</label></li>
<%
				}
%>
				<c:if test="${!(user.e_titl2 eq 'CFO' || user.e_titl2 eq '담당(관리자)' || user.e_titl2 eq '실장' || user.e_titl2 eq '연구소장')}">
					<li><input type="radio" id="input_radio01_11" name="awartRadio" value="0220" disabled /><label for="input_radio01_11">지각</label></li>
					<li><input type="radio" id="input_radio01_12" name="awartRadio" value="0230" disabled /><label for="input_radio01_12">조퇴</label></li>
				</c:if>
					<li><input type="radio" id="input_radio01_14" name="awartRadio" value="0133" disabled /><label for="input_radio01_14">난임휴가(유급)</label></li>
					<li><input type="radio" id="input_radio01_13" name="awartRadio" value="0134" disabled /><label for="input_radio01_13">난임휴가(무급)</label></li>
				</ul>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailReason">신청사유</label></th>
			<td>
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
				
				<span class="buttonArea">
					<ul class="btn_crud">
						<li><a class="darken" href="#" id="EventMoneyListBtn" ><span>경조금조회</span></a></li>
					</ul>
				</span>
			</td>
		</tr>
		<tr>
			<th><label for="detailOvtmName">대근자</label></th>
			<td>
				<input class="fixedWidth readOnly" type="text" id="detailOvtmName" name="OVTM_NAME" readOnly />
				<span class="noteItem colorRed">※ 교대조는 필수입력 사항입니다. </span>
			</td>
		</tr>
		<tr>
			<th><label for="detailPRemain">잔여휴가일수</label></th>
			<td>
				<input class="fixedWidth readOnly alignCenter" type="text" id="detailPRemain" name="P_REMAIN" readonly/> 일
				<span id="detailRemainText" class="noteItem colorBlue"></span>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailApplFrom">휴가기간</label></th>
			<td class="tdDate">
				<input class="datepicker readOnly" type="text" id="detailApplFrom" name="APPL_FROM" size="5" vname="휴가시작일" />
				~
				<input class="datepicker readOnly" type="text" id="detailApplTo" name="APPL_TO" size="5" vname="휴가종료일" />
			</td>
		</tr>
		 <tr>
			<th><label for="detailBeguzHh">신청시간</label></th>
			<td>
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
			<td><input class="readOnly" type="text" id="detailDeductDate" name="DEDUCT_DATE" readOnly /> 일</td>
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
		
		<!-- 경조금 -->
		<input type="hidden" name="DETAIL_PERNR"  id="DETAIL_PERNR" />
		<input type="hidden" name="DETAIL_AINF_SEQN"  id="DETAIL_AINF_SEQN" />
		<input type="hidden" name="DETAIL_CONG_CODE"  id="DETAIL_CONG_CODE" />
		<input type="hidden" name="DETAIL_CONG_NAME"  id="DETAIL_CONG_NAME" />
		<input type="hidden" name="DETAIL_RELA_CODE"  id="DETAIL_RELA_CODE" />
		<input type="hidden" name="DETAIL_RELA_NAME"  id="DETAIL_RELA_NAME" />
		<input type="hidden" name="DETAIL_CONG_DATE"  id="DETAIL_CONG_DATE" />
		<input type="hidden" name="DETAIL_HOLI_CONT"  id="DETAIL_HOLI_CONT" />
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

<!-- popup 경조금 조회 -->
<!-- // 대상자선택 popup -->
<div class="layerWrapper layerSizeP" id="popLayerEventMoneyList">
	<div class="layerHeader">
		<strong>대상자 선택</strong>
		<a href="#" class="btnClose popLayerEventMoneyList_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<form id="contactForm">
				<div class="tableArea tablePopup">
					<!-- // 가족사항 grid -->
					<div id="eventMoneyGrid" ></div>
				</div>
				<div class="buttonArea buttonCenter">
					<ul class="btn_crud">
						<li><a class="darken" href="#" id="popLayerEventMoneyListSave"><span>확인</span></a></li>
						<li><a href="#" id="popLayerEventMoneyListCansel"><span>취소</span></a></li>
					</ul>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- popup 경조금 조회 -->

<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getVacationDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
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
					$('#vocaTypePanel').show();
					$('input[name=vocaType][value='+iMode+']').prop('checked', true);
					$('#input_radio01_11').parent().hide();
					$('#input_radio01_12').parent().hide();
					if(iMode == 'A') {
						$('#vocaType1Panel').show();
						
						PRemain = remainData.E_REMAIN == "0" ? "0" : insertComma(parseFloat(remainData.E_REMAIN).toString());
						PRemain += "/";
						PRemain += remainData.ZKVRB2 =="0" ? "0" : insertComma(parseFloat(remainData.ZKVRB2).toString());
						PRemain += "/";
						PRemain += remainData.VACATION =="0" ? "0" : insertComma(parseFloat(remainData.VACATION).toString());
						
						PRemainTxt = '(연월차/선택적보상/하계)';
					} else {
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
				
				setDetail(vacationData);
				
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
		$("#EventMoneyListBtn").hide();
		
		//대상자선택 popup  경조금조회
		$("#EventMoneyListBtn").click(function(){
			$("#eventMoneyGrid").jsGrid("search");
			$("#popLayerEventMoneyList").popup('show');  //popLayerFamilyList 참조
		});
		
		//대상자선택 popup 저장
		$("#popLayerEventMoneyListSave").click(function(){
			var DETAIL_AINF_SEQN = $('#DETAIL_AINF_SEQN').val();	//결제일련번호
			var DETAIL_CONG_NAME = $('#DETAIL_CONG_NAME').val();	//경조내역
			var DETAIL_RELA_NAME = $('#DETAIL_RELA_NAME').val();	//관계
			var DETAIL_CONG_DATE = $('#DETAIL_CONG_DATE').val();	//경조발생일
			
			if(DETAIL_AINF_SEQN.length > 0){
				var str = DETAIL_CONG_NAME + "/" + DETAIL_RELA_NAME + "/" + DETAIL_CONG_DATE
				$('#detailReason').val(str);
			}
			
			$("#popLayerEventMoneyList").popup('hide');
		});
		//대상자선택 popup 취소
		$("#popLayerEventMoneyListCansel").click(function(){
			$("#popLayerEventMoneyList").popup('hide');
		});
		
	});
	
	// 휴가유형 변경시
	$('input:radio[name="vocaType"]').change(function() {
		$("input:radio[name='awartRadio']").filter(":checked").prop('checked', false);
		$("#detailReason").val("");
		$('#detailApplFrom').val("");
		$('#detailApplTo').val("").removeClass('readOnly').prop("disabled",false);
		$("#detailBeguzMm").val("00").prop("disabled",true).addClass('readOnly');
		$("#detailBeguzHh").val("00").prop("disabled",true).addClass('readOnly');
		$("#detailEnduzMm").val("00").prop("disabled",true).addClass('readOnly');
		$("#detailEnduzMm").val("00").prop("disabled",true).addClass('readOnly');
		$("#detailDeductDate").val("0");
		
		var chkVocaType = $("input:radio[name='vocaType']").filter(":checked").val();
		if(chkVocaType == 'B') {
			$('#vocaType0Panel').show();
			$('#vocaType1Panel').hide();
		} else {
			$('#vocaType0Panel').hide();
			$('#vocaType1Panel').show();
		}
		
		jQuery.ajax({
			type : 'POST',
			url : '/work/getRemainVacation.json',
			cache : false,
			dataType : 'json',
			data : {"I_MODE":chkVocaType},
			async :false,
			success : function(response) {
				if(response.success){
					var E_REMAIN = response.storeData.E_REMAIN == 0 ? 0 : parseFloat(response.storeData.E_REMAIN).toFixed(2);
					var ZKVRB2 = response.storeData.ZKVRB2 == 0 ? 0 : parseFloat(response.storeData.ZKVRB2).toFixed(1);
					var VACATION = response.storeData.VACATION == 0 ? 0 : parseFloat(response.storeData.VACATION).toFixed(1);
					var ZKVRBTX = response.storeData.ZKVRBTX;
					
					if(chkVocaType == 'A') {
						$('#detailPRemain').val(E_REMAIN + '/' + ZKVRB2 + '/' + VACATION);
						$('#detailRemainText').text('(연월차/선택적보상/하계)');
					} else {
						$('#detailPRemain').val(E_REMAIN);
						$('#detailRemainText').text(ZKVRBTX);
					}
				}else{
					alert("잔여휴가 조회 오류가 발생하였습니다. \n\n" + response.message);
				}
			}
		});
	});
	
	// 최초 휴가유형 판단 - TODO :: 신청된 유형에 따라 panel show
	$('#vocaType0Panel').hide();
	
	// 휴가구분 변경시
	$("input:radio[name='awartRadio']").change(function(){
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		$("#detailReason").val("");
		
		$('#detailApplTo').datepicker('option', 'disabled', false);

		// 경조공가
		if(radioCheck == '0130'){
			$("#detailCongCode").show();
			$("#Message_1").show();
			
			if($("input:radio[name='awartRadio']").attr("disabled") == null){
				$("#EventMoneyListBtn").show();
				$("#detailReason").attr("readonly","true");
				$("#detailReason").addClass("readOnly");	
			}
		
		} else {
			// 지각,조퇴,난임휴가(유급)
			if(radioCheck == '0220' || radioCheck == '0230' || radioCheck == '0133') {
				$('#detailApplTo')
					.val($('#detailApplFrom').val())
					.datepicker('option', 'disabled', true);
			}
			$("#detailCongCode").hide().val("");
			$("#Message_1").hide();
			
			$("#EventMoneyListBtn").hide();
			if($("input:radio[name='awartRadio']").attr("disabled") == null){
				$("#detailReason").removeAttr('readonly');
				$("#detailReason").removeClass("readOnly");
			}
			initDeatilInfo();
			
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
		
		var eAuth = $('input[name=E_AUTH]').val();
		// 사무직 - 시간공가
		if(eAuth == 'Y' && radioCheck == '0180') {
			$("#detailBeguzHh").prop("disabled",false).removeClass('readOnly');
			$("#detailBeguzMm").prop("disabled",false).removeClass('readOnly');
			$("#detailEnduzHh").prop("disabled",false).removeClass('readOnly');
			$("#detailEnduzMm").prop("disabled",false).removeClass('readOnly');
		}
		// 현장직 - 반일휴가(전반, 후반), 시간공가, 지각, 조퇴
		else if( eAuth != 'Y' && (radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' || radioCheck == '0220' || radioCheck == '0230') ) {
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
		} else if( radioCheck == '0180' ){   // 시간공가
			$("#detailDeductDate").val('0');
		} else {
			$("#detailDeductDate").val('0');
		}
	});
	
	// 날짜변경시
	$('#detailApplFrom').change(function() {
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		
		if(radioCheck == '0220' || radioCheck == '0230' || radioCheck == '0133') {
			$('#detailApplTo').val($('#detailApplFrom').val());
		}
	});
	
	//경조공가 팝업창에서 셋팅된 값 초기화
	var initDeatilInfo = function() {
		$('#DETAIL_PERNR').val("");
		$('#DETAIL_AINF_SEQN').val("");
		$('#DETAIL_BEGDA').val("");
		$('#DETAIL_CONG_CODE').val("");
		$('#DETAIL_CONG_NAME').val("");
		$('#DETAIL_RELA_CODE').val("");
		$('#DETAIL_RELA_NAME').val("");
		$('#DETAIL_CONG_DATE').val("");
		$('#DETAIL_HOLI_CONT').val("");
	}
	
	// 결조공가 사유 선택시
	$("#detailCongCode").change(function(){
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		if (radioCheck == '0130' && $("#detailCongCode option:selected").val() == "9001" ) {//자녀출산(유급)
			$("#detailAwart").val("0131");
			$("#EventMoneyListBtn").hide();
			
			$("#detailReason").removeAttr('readonly');
			$("#detailReason").removeClass("readOnly");
		} else if (radioCheck == '0130' && $("#detailCongCode option:selected").val() == "9002" ) {//자녀출산(무급)
			$("#detailAwart").val("0132");
			$("#EventMoneyListBtn").hide();
			
			$("#detailReason").removeAttr('readonly');
			$("#detailReason").removeClass("readOnly");
		} else if (radioCheck == '0130' && ( $("#detailCongCode option:selected").val() != "9001" && $("#detailCongCode option:selected").val() != "9002"  )) {//경조공가
			$("#detailAwart").val("0130");
			$("#EventMoneyListBtn").show();
		
			$("#detailReason").val("");
			$("#detailReason").attr("readonly","true");
			$("#detailReason").addClass("readOnly");	
		
		}
	});
	

	$("#detailBeguzHh, #detailBeguzMm").change(function(){
		$("#detailBeguz").val($("#detailBeguzHh").val() + $("#detailBeguzMm").val());
	});
	
	$("#detailEnduzHh, #detailEnduzMm").change(function(){
		$("#detailEnduz").val($("#detailEnduzHh").val() + $("#detailEnduzMm").val());
	});
	
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		
		$("input:radio[name='vocaType']").removeClass('readOnly').prop("disabled",false);
		$("input:radio[name='awartRadio']").removeClass('readOnly').prop("disabled",false);
		
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		// 신청시간 체크
		var eAuth = $('input[name=E_AUTH]').val();
		if(eAuth != 'Y' && (radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' || radioCheck == '0220' || radioCheck == '0230')) { // 반일휴가(전반, 후반), 시간공가, 지각, 조퇴
			$("#detailBeguzHh").prop("disabled",false).removeClass('readOnly');
			$("#detailBeguzMm").prop("disabled",false).removeClass('readOnly');
			$("#detailEnduzHh").prop("disabled",false).removeClass('readOnly');
			$("#detailEnduzMm").prop("disabled",false).removeClass('readOnly');
		}
		
		$("#detailOvtmCode1").removeClass('readOnly').prop("disabled",false);
		$("#detailOvtmCode2").removeClass('readOnly').prop("disabled",false);
		$("#detailCongCode").removeClass('readOnly').prop("disabled",false);
		
		$("#detailReason").removeClass('readOnly').prop("readOnly",false);
		$("#detailOvtmName").removeClass('readOnly').prop("readOnly",false);
		$("#detailApplFrom").removeClass("readOnly").prop("readOnly",false).datepicker({
			defaultDate: "+1w",
			onClose: function( selectedDate ) {
				$("#detailApplTo").datepicker( "option", "minDate", selectedDate );
			}
		});
		$("#detailApplTo").removeClass("readOnly").prop("readOnly",false).datepicker({
			defaultDate: "+1w",
			onClose: function( selectedDate ) {
				$("#detailApplFrom").datepicker( "option", "maxDate", selectedDate );
			}
		});
		
		//경조공가
		if( radioCheck == '0130'){
			$("#EventMoneyListBtn").show();
			
			//기존 경조휴가 seq가 없어서 초기화 처리(P_A024_SEQN)
			$("#detailCongCode").val("");
			$("#detailReason").val("");
			$("#detailReason").attr("readonly","true");
			$("#detailReason").addClass("readOnly");
		}
		
	}
	
	// 삭제 버튼 클릭
	var reqDeleteActionCallBack = function(){
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteVacation',
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
		
		$("#detailOvtmCode1").addClass('readOnly').prop("disabled",true);
		$("#detailOvtmCode2").addClass('readOnly').prop("disabled",true);
		$("#detailCongCode").addClass('readOnly').prop("disabled",true);
		
		$("input:radio[name='vocaType']").addClass('readOnly').prop("disabled",true);
		$("input:radio[name='awartRadio']").addClass('readOnly').prop("disabled",true);
		$("#detailReason").addClass('readOnly').prop("readOnly",true);
		$("#detailOvtmName").addClass('readOnly').prop("readOnly",true);
		$("#detailApplFrom").addClass("readOnly").prop("readOnly",true);
		$("#detailApplTo").addClass("readOnly").prop("readOnly",true);
		
		destroydatepicker("detailForm");
	}
	
	var updateVacationChk = function(){
		if(!$("input:radio[name='awartRadio']").is(":checked")){
			alert("휴가구분을 선택하세요.");
			return false;
		}
			
		if(!checkNullField("detailForm")){
			return false;
		}
		
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		
		
		//하계휴가 신청시 잔여 하계휴가일수를 check한다. (2004.03.08)
		if( radioCheck == '0140' ) {
			if( $("#detailVacatiDate").val() == "0" ) {
				alert("하계휴가 잔여일수가 존재하지 않습니다.");
				return false;
			}
		}
		
		if( radioCheck == '0130'){
			if($("#detailCongCode option:selected").val()==""){
				alert("경조공가 신청사유를 선택해주세요.");
				return false;
			}
		}else if( radioCheck == '0170'){
			if($("#detailOvtmCode1 option:selected").val()==""){
				alert("전일공가 신청사유를 선택해주세요.");
				return false;
			}
		}else if( radioCheck == '0180'){
			if($("#detailOvtmCode2 option:selected").val()==""){
				alert("시간공가 신청사유를 선택해주세요.");
				return false;
			}
		}
		
		// 전일 공가와 시간 공가  선택한 경우  ( 이동엽D)
		if ( radioCheck == '0170' ) {
			$("#detailOvtmCode").val($("#detailOvtmCode1 option:selected").val());
		}
		if ( radioCheck == '0180' ) {
			$("#detailOvtmCode").val($("#detailOvtmCode2 option:selected").val()); 
		}
		
		// 신청사유-80 입력시 길이 제한 
		if( $("#detailReason").val() != "" && checkLength($("#detailReason").val()) > 80 ){
			$("#detailReason").val(limitKoText($("#detailReason").val(), 80));
			alert("신청사유는 한글 40자, 영문 80자 이내여야 합니다.");
			$("#detailReason").focus();
			$("#detailReason").select();
			return false;
		}
		
		date_from  = removePoint($("#detailApplFrom").val());
		date_to    = removePoint($("#detailApplTo").val());

		var eAuth = $('input[name=E_AUTH]').val();
		if( radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' || radioCheck == '0112' || radioCheck == '0113' ) { // 반일휴가(전반, 후반), 시간공가
			if( date_from != date_to ) {
				alert("반일휴가는 신청기간이 하루입니다.");
				return false;
			}
			
			// 현장직 체크-  반일휴가일경우 신청시간 체크..??
			if(eAuth != 'Y' && $("#detailBeguz").val() > $("#detailEnduz").val()) {
				alert("신청시작 시간이 신청종료 시간보다 큽니다.");
				return false;
			}

<%
	//  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다.
	if( !userData.e_regno.equals("") && userData.e_regno.substring(6,7).equals("2") ) {
%>
		}else if( radioCheck == '0150'){
			if( date_from != date_to ) {
				alert("잔여(보건) 휴가는 신청기간이 하루입니다.");
				return false;
			}
<%
	}
%>
		}else{
			if( date_from > date_to ) {
				alert("신청시작일이 신청종료일보다 큽니다.");
				return false;
			}
		}
		
		return true;
	}
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(updateVacationChk()){
			if(confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				
				if($('#detailApplTo').is(':disabled')) {
					$('#detailApplTo').datepicker('option', 'disabled', false);
				}
				
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateVacation',
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
							alert("저장시 오류가 발생하였습니다. \n\n" + response.message);
							return false;
						}
						$("#reqSaveBtn").prop("disabled", false);
					}
				});
				
			}
		}
	}
	
	//경조금 지원내역 그리드
	$(function() {

		$("#eventMoneyGrid").jsGrid({
			height: "auto",
	        width: "100%",
	        sorting: true,
	        paging: true,
	        autoload: false,
			controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/supp/getEventMoneyListForVacation.json",
   						dataType : "json"
  					}).done(function(response) {
   						if(response.success)
   							d.resolve(response.storeData);
   		    			else
   		    				alert("조회시 오류가 발생하였습니다. " + response.message);
   					});
   					return d.promise();
   				}
   			},
			fields: [
           		{
           			title: "선택",
           			name: "th1",
           			itemTemplate: function(_, item) {
           				return $("<input name='chk'>")
           					   .attr("type", "radio")
           					   .on("click", function(e) {
           						    $('#DETAIL_PERNR').val(item.PERNR);
	           						$('#DETAIL_AINF_SEQN').val(item.AINF_SEQN);
	           						$('#DETAIL_BEGDA').val(item.BEGDA);
	           						$('#DETAIL_CONG_CODE').val(item.CONG_CODE);

	           						$('#DETAIL_CONG_NAME').val(item.CONG_NAME);
	           						$('#DETAIL_RELA_CODE').val(item.RELA_CODE);
	           						$('#DETAIL_RELA_NAME').val(item.RELA_NAME);
	           						$('#DETAIL_CONG_DATE').val(item.CONG_DATE);
	           						$('#DETAIL_HOLI_CONT').val(item.HOLI_CONT);           						  
           					   });
           			},
           			align: "center",
           			width: "12%"
           		},
           		{ title: "경조구분", name: "CONG_NAME", type: "text", align: "center", width: "22%" },
           		{ title: "관 계", name: "RELA_NAME", type: "text", align: "center", width: "22%" },
           		{ title: "경조발생일", name: "CONG_DATE", type: "text", align: "center", width: "22%" },
           		{ title: "경조휴가일수", name: "HOLI_CONT", type: "text", align: "center", width: "22%" }

       		]
		});
	});
	
</script>