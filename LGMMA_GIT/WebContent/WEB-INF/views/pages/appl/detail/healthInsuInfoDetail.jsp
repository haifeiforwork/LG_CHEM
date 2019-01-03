<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareREQRFC"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareEnrollRFC"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareTargetNameRFC"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareIssueRFC"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareReIssueRFC"%>
<%@ page import="hris.E.E02Medicare.E02MedicareNameData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
%>
<form id="detailForm">
<div class="tableArea">
	<h2 class="subtitle">건강보험 정보변경 신청</h2>
	<div class="table">
		<table class="tableGeneral">
		<caption>건강보험 정보변경 신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="detailBegda">신청일</label></th>
			<td colspan="3" class="tdDate">
				<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly />
			</td>
		</tr>
		<!-- 신청구분 셀렉트 옵션에 따라 div id="healthModifyLayer1~3" display -->
		<tr>
			<th><span class="textPink">*</span><label for="detailApplType2">신청구분</label></th>
			<td>
				<select class="readOnly" id="detailApplType2" name="APPL_TYPE2" vname="신청구분" disabled >
					<option value =''>-------선택-------</option>
					<%= WebUtil.printOption((new E02MedicareREQRFC()).getRequest()) %>
				</select>
			</td>
			<th><span class="textPink">*</span><label for="detailEname">대상자 성명</label></th>
			<td>
				<select class="readOnly" id="detailEname" name="ENAME" vname="대상자 성명" disabled >
					<option value =''>-------선택-------</option>
<%
			Vector<E02MedicareNameData> tergetName_vt = (new E02MedicareTargetNameRFC()).getName(userData.empNo);
			for(int i = 0 ; i < tergetName_vt.size() ; i++){
				E02MedicareNameData data = tergetName_vt.get(i);
%>
					<option value ="<%=data.LNMHG.trim() + " " + data.FNMHG.trim()%>" 
							SUBTY="<%=data.SUBTY%>" 
							OBJPS="<%=data.OBJPS%>" >
							<%=data.LNMHG.trim() + " " + data.FNMHG.trim()%></option>
<%
			}
%>
				</select>
			</td>
		</tr>
		</tbody>
		</table>
	</div>
	<div class="tableComment">
		<p><span class="bold">제출서류 : 기재사항변경의 경우 주민등록등본, 건강보험증 각 1부 </span></p>
	</div>
</div>
<!--// Table start -->
<div class="tableArea" id="healthModifyLayer1" style="display:none;">
	<h2 class="subtitle">기재사항변경</h2>
	<div class="table">
		<table class="tableGeneral">
		<caption>기재사항변경</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><span class="textPink">*</span><label for="detailApplType3">변경항목</label></th>
			<td colspan="3">
				<select class="readOnly" id="detailApplType3" name="APPL_TYPE3" vname="변경항목" disabled >
					<option value =''>-------선택-------</option>
					<%= WebUtil.printOption((new E02MedicareEnrollRFC()).getEnroll()) %>
				</select>
				<input class="readOnly w120" type="text" id="detailEtcText3" name="ETC_TEXT3" onKeyUp="check_length(this,60)" readOnly/>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailChngBefore">변경전Data</label></th>
			<td>
				<input class="readOnly w150" type="text" id="detailChngBefore" name="CHNG_BEFORE" onKeyUp="check_length(this,60)" vname="변경전Data" readOnly />
			</td>
			<th><span class="textPink">*</span><label for="detailChngAfter">변경후Data</label></th>
			<td>
				<input class="readOnly w150" type="text" id="detailChngAfter" name="CHNG_AFTER" onKeyUp="check_length(this,60)" vname="변경후Data" readOnly />
			</td>
		</tr>
		</tbody>
		</table>
	</div>
</div>
<!--// Table start -->
<div class="tableArea" id="healthModifyLayer2" style="display:none;">
	<h2 class="subtitle">추가발급</h2>
	<div class="table">
		<table class="tableGeneral">
		<caption>추가발급</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><span class="textPink">*</span><label for="detailApplType4">발급사유</label></th>
			<td>
				<select class="readOnly" id="detailApplType4" name="APPL_TYPE4" disabled >
					<option value =''>-------선택-------</option>
					<%= WebUtil.printOption((new E02MedicareIssueRFC()).getIssue()) %>
				</select>
				<input class="readOnly w60" type="text" id="detailEtcText4" name="ETC_TEXT4" onKeyUp="check_length(this,60)" vname="발급사유" readOnly /> 
			</td>
			<th><span class="textPink">*</span><label for="detailAddNum">발행부수</label></th>
			<td>
				<input class="readOnly w2" type="text" id="detailAddNum" name="ADD_NUM" maxlength="3" vname="발햏부수" readOnly />
			</td>
		</tr>
		</tbody>
		</table>
	</div>
</div>
<!--// Table start -->
<div class="tableArea" id="healthModifyLayer3" style="display:none;">
	<h2 class="subtitle">재발급</h2>
	<div class="table">
		<table class="tableGeneral">
		<caption>재발급</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><span class="textPink">*</span><label for="detailApplType5">신청사유</label></th>
			<td>
				<select class="readOnly" id="detailApplType5" name="APPL_TYPE5" vname="신청사유" disabled >
					<option value =''>-------선택-------</option>
					<%= WebUtil.printOption( (new E02MedicareReIssueRFC()).getReIssue() ) %>
				</select>
				<input class="readOnly w6" type="text" id="detailEtcText5" name="ETC_TEXT5" onKeyUp="check_length(this,60)" readOnly /> 
			</td>
			<th><label for="detailAddNum1">발행부수</label></th>
			<td>
				<input class="readOnly w60" type="text" id="detailAddNum1" name="ADD_NUM1" readOnly />
			</td>
		</tr>
		</tbody>
		</table>
	</div>
</div>
<input type="hidden" id="detailAinfSeqn" name="AINF_SEQN" />
<input type="hidden" id="detailSubty" name="SUBTY" />
<input type="hidden" id="detailObjps" name="OBJPS" />
</form>

<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getHealthInsuInfoDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				$("#detailApplType2").change();
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
		}
	}
	
	
	$(document).ready(function(){
		// 초기화
		detailSearch();
	});
	
	$("#detailApplType2").change(function(){
		if($("#detailApplType2").val() == "01") {
			$("#healthModifyLayer1").show();
			
			$("#detailApplType3").attr("required","required").change();
			$("#detailChngBefore").attr("required","required");
			$("#detailChngAfter").attr("required","required");
			
		} else {
			$("#healthModifyLayer1").hide();
			//초기화
			$("#detailApplType3").val("").attr("required",null);
			$("#detailEtcText3").val("").hide();
			$("#detailChngBefore").val("").attr("required",null);
			$("#detailChngAfter").val("").attr("required",null);
		}
		
		if($("#detailApplType2").val() == "02") {
			$("#healthModifyLayer2").show();
			
			$("#detailApplType4").attr("required","required").change();
			$("#detailAddNum").attr("required","required");
		} else {
			$("#healthModifyLayer2").hide();
			//초기화
			$("#detailApplType4").val("").attr("required",null);
			$("#detailEtcText4").val("").hide();
			$("#detailAddNum").val("").attr("required",null);
		}
		
		if($("#detailApplType2").val() == "03") {
			$("#healthModifyLayer3").show();
			
			$("#detailApplType5").attr("required","required").change();
		} else {
			$("#healthModifyLayer3").hide();
			//초기화
			$("#detailApplType5").val("").attr("required",null);
			$("#detailEtcText5").val("").hide();
			$("#detailAddNum1").val("");
		}
	});
	
	// 대상자 성명 변경시
	$("#detailEname").change(function(){
		$("#detailSubty").val($("#detailEname option:selected").attr("SUBTY"));
		$("#detailObjps").val($("#detailEname option:selected").attr("OBJPS"));
	});
	
	// 변경항목 변경시
	$("#detailApplType3").change(function(){
		if( $("#detailApplType3 option:selected").val() == "04" ){
			$("#detailEtcText3").show();
		} else {
			$("#detailEtcText3").hide();
			$("#detailEtcText3").val("");
		}
	});
	
	// 발급사유 변경시
	$("#detailApplType4").change(function(){
		if( $("#detailApplType4 option:selected").val() == "05" ){
			$("#detailEtcText4").show();
		} else {
			$("#detailEtcText4").hide();
			$("#detailEtcText4").val("");
		}
	});
	
	// 신청사유 변경시
	$("#detailApplType5").change(function(){
		if( $("#detailApplType5 option:selected").val() == "04" ){
			$("#detailEtcText5").show();
		} else {
			$("#detailEtcText5").hide();
			$("#detailEtcText5").val("");
		}
	});
	
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		$("#detailApplType2").removeClass('readOnly').prop("disabled",false);
		$("#detailEname").removeClass('readOnly').prop("disabled",false);
		$("#detailApplType3").removeClass('readOnly').prop("disabled",false);
		$("#detailEtcText3").removeClass('readOnly').prop("readOnly",false);
		$("#detailChngBefore").removeClass('readOnly').prop("readOnly",false);
		$("#detailChngAfter").removeClass('readOnly').prop("readOnly",false);
		$("#detailApplType4").removeClass('readOnly').prop("disabled",false);
		$("#detailEtcText4").removeClass('readOnly').prop("readOnly",false);
		$("#detailAddNum").removeClass('readOnly').prop("readOnly",false);
		$("#detailApplType5").removeClass('readOnly').prop("disabled",false);
		$("#detailEtcText5").removeClass('readOnly').prop("readOnly",false);
		$("#detailAddNum1").removeClass('readOnly').prop("readOnly",false);
		
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
				url : '/appl/deleteHealthInsuInfo',
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
		
		$("#detailApplType2").addClass('readOnly').prop("disabled",true);
		$("#detailEname").addClass('readOnly').prop("disabled",true);
		$("#detailApplType3").addClass('readOnly').prop("disabled",true);
		$("#detailEtcText3").addClass('readOnly').prop("readOnly",true);
		$("#detailChngBefore").addClass('readOnly').prop("readOnly",true);
		$("#detailChngAfter").addClass('readOnly').prop("readOnly",true);
		$("#detailApplType4").addClass('readOnly').prop("disabled",true);
		$("#detailEtcText4").addClass('readOnly').prop("readOnly",true);
		$("#detailAddNum").addClass('readOnly').prop("readOnly",true);
		$("#detailApplType5").addClass('readOnly').prop("disabled",true);
		$("#detailEtcText5").addClass('readOnly').prop("readOnly",true);
		$("#detailAddNum1").addClass('readOnly').prop("readOnly",true);
	}
	
	
	// 건강보험 정보변경 신청시 체크 사항
	var updateHealthInsuranceCheck = function(){
		if(!checkNullField("detailForm")){
			return false;
		}
		
		//주민등록번호일때 유효성 체크
		if($("#detailApplType3 option:selected").val() == "02" ){//주민등록번호
			if( ! resno_chk('detailChngAfter')){
				return false;
			}
		}
		
		if( $("#detailApplType3 option:selected").val() == "04" ){
			if( $("#detailEtcText3").val() == "" ){
				alert("변경항목이 기타입니다. 내용을 입력하세요 ");
				$("#detailEtcText3").focus();
				return false;
			}
		}
		
		if( $("#detailApplType4 option:selected").val() == "05" ){
			if( $("#detailEtcText4").val() == "" ){
				alert("발급사유가 기타입니다. 내용을 입력하세요 ");
				$("#detailEtcText4").focus();
				return false;
			}
		}
		
		if( $("#detailApplType5 option:selected").val() == "04" ){
			if( $("#detailEtcText5").val() == "" ){
				alert("신청사유가 기타입니다. 내용을 입력하세요 ");
				$("#detailEtcText5").focus();
				return false;
			}
		}
		
		return true;
	};
	
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(updateHealthInsuranceCheck()){
			if(confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#detailAinfSeqn").val('${AINF_SEQN}');
				
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateHealthInsuInfo',
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
	}


</script>

