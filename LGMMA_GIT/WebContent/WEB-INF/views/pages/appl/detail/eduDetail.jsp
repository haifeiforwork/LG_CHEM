<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hris.C.C09Educ.rfc.C09EducRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<div class="tableArea">
	<h2 class="subtitle">교육과정 선택</h2>
	<div class="table">
		<form id="detailForm">
		<table class="tableGeneral">
		<caption>교육신청</caption>
		<colgroup>
			<col class="col_10p" />
			<col class="col_10p" />
			<col class="col_10p" />
			<col class="col_16p" />
			<col class="col_10p" />
			<col class="col_14p" />
			<col class="col_10p" />
			<col class="col_20p" />
		</colgroup>
		<tbody>
			<tr>
				<th><span class="textPink">*</span><label for="detailEducYear">교육년도</label></th>
				<td>
					<select class="w90 readOnly" id="detailEducYear" name="EDUC_YEAR" vname="교육년도" disabled >
						<option value="">----</option>
						<%= WebUtil.printOption((new C09EducRFC()).getCodeType("","","","","3")) %>
					</select>
				</td>
				<th><span class="textPink">*</span><label for="detailOrgaCode">교육기관</label></th>
				<td>
					<select class="wPer readOnly" id="detailOrgaCode" name="ORGA_CODE" vname="교육기관" disabled >
						<option value="">---------</option>
						<%= WebUtil.printOption((new C09EducRFC()).getCodeType("","","","","1")) %>
					</select>
				</td>
				<th><span class="textPink">*</span><label for="detailCataCode">교육분야 </label></th>
				<td>
					<select class="wPer readOnly" id="detailCataCode" name="CATA_CODE" vname="교육분야" disabled >
						<option value="">--------</option>
						<%= WebUtil.printOption((new C09EducRFC()).getCodeType("","","","","2")) %>
					</select>
				</td>
				<th><span class="textPink">*</span><label for="detailCourCode">교육과정</label></th>
				<td>
					<select class="wPer readOnly" id="detailCourCode" name="COUR_CODE" vname="교육과정" disabled>
						<option value="">------------------------</option>
					</select>
				</td>
			</tr>
		</tbody>
		</table>
		
		<input type="hidden" id="detailGubun"    name="GUBUN" />
		<input type="hidden" id="detailBegda"    name="BEGDA" />
		<input type="hidden" id="detailSubty"    name="SUBTY" />
		<input type="hidden" id="detailObjps"    name="OBJPS" />
		<input type="hidden" id="detailUpmutype" name="UPMUTYPE" />
		<input type="hidden" id="detailFamid"    name="FAMID" />
		<input type="hidden" id="detailAinfSeqn" name="AINF_SEQN" />
		
		<input type="hidden" id="detailOrgaName" name="ORGA_NAME" />
		<input type="hidden" id="detailCataName" name="CATA_NAME" />
		<input type="hidden" id="detailCourName" name="COUR_NAME" />
		<input type="hidden" id="detailCourSche" name="COUR_SCHE" />
		<input type="hidden" id="detailEducBegd" name="EDUC_BEGD" />
		<input type="hidden" id="detailEducEndd" name="EDUC_ENDD" />
		<input type="hidden" id="detailEducCost" name="EDUC_COST" />
		<input type="hidden" id="detailEducTime" name="EDUC_TIME" />
		<input type="hidden" id="detailPassFlag" name="PASS_FLAG" />
		<input type="hidden" id="detailEsseFlag" name="ESSE_FLAG" />
		<input type="hidden" id="detailApprMark" name="APPR_MARK" />
		<input type="hidden" id="detailEmplFlag" name="EMPL_FLAG" />
		<input type="hidden" id="detailSemiFlag" name="SEMI_FLAG" />
		
		<input type="hidden" id="detailOrgaCode1" name="ORGA_CODE_1" value="2000" />
		<input type="hidden" id="detailCataCode1" name="CATA_CODE_1" />
		<input type="hidden" id="detailEducYear1" name="EDUC_YEAR_1" />
		<input type="hidden" id="detailCourCode1" name="COUR_CODE_1" />
		<input type="hidden" id="detailCheck"     name="CHECK" />
		</form>
		
	</div>
</div>
<div class="listArea">
	<h2 class="subtitle">교육과정 상세정보</h2>
	<!-- 교육과정 정보 출력 -->
	<div id="TDLINE_TEXT" class="eduDetailInfo">
	</div>
	<!-- 교육과정 상세 선택 -->
	<div id="curriculumGrid"></div>
</div>
<!--// list end -->

<script type="text/javascript">

	//onChange CategoryCode
	var CHANGE_CODE = function() {
		$("#detailCourCode").lenth = 1;
		$("#detailCourCode").val("");
		
		$("#detailGubun").val("4");
		$("#detailOrgaCode1").val($("#detailOrgaCode").val());
		$("#detailCataCode1").val($("#detailCataCode").val());
		$("#detailEducYear1").val($("#detailEducYear").val());
		$("#detailCourCode1").val($("#detailCourCode").val());
		
		getCategoryCode();
		
		if( $('#detailEducYear').val() != "" && $('#detailOrgaCode').val() != "" && $('#detailCataCode').val() != "" ) {
			$("#detailTdlineText").text("");
			$("#curriculumGrid").jsGrid("search");
		}
	};
	
	//교육차수에 대한 데이터 가져오기
	var getCategoryCode = function() {
		jQuery.ajax({
			type : "POST",
			url : "/edu/getCategoryList.json",
			cache : false,
			dataType : "json",
		data : {
				 "ORGA_CODE" : "2000"
				,"CATA_CODE" : $("#detailCataCode1").val()
				,"EDUC_YEAR" : $("#detailEducYear1").val()
				,"COUR_CODE" : $("#detailCourCode1").val()
				,"GUBUN" : "4"
			},
			async :false,
			success : function(response) {
				if(response.success){
					setVectorOption("detailCourCode",response.storeData);
				}
				else{
					alert("급여사유 조회시 오류가 발생하였습니다. " + response.message);
				}
		}
		});
	};
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getEduDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				$('#detailCourCode').val(response.storeData.COUR_CODE);
				$("#curriculumGrid").jsGrid("search").done(function(){
					$("input:radio[name='courRadio']:input[value='" + response.storeData.COUR_SCHE + "']").prop("checked",true);
				});
				setTextareaChange(response.C09EducTextData_vt_2);
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
			CHANGE_CODE();
		}
	}
	
	// 교육과정 상세정보
	$(function() {
		$("#curriculumGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: false,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/edu/getCurriculumList.json",
						dataType : "json",
						data :  {
							   "ORGA_CODE" : $("#detailOrgaCode").val()
							  ,"CATA_CODE" : $("#detailCataCode").val()
							  ,"EDUC_YEAR" : $("#detailEducYear").val()
							  ,"COUR_CODE" : $("#detailCourCode").val()
							  ,"GUBUN"     : "5"
						}
					}).done(function(response) {
						if(response.success){
							d.resolve(response.storeData[0]);
							setTextareaChange(response.storeData[1]);
						}
						else{
							alert("조회시 오류가 발생하였습니다. " + response.message);
						}
					});
					return d.promise();
				}
			},
			fields: [
				{	title: "선택", name: "th1", align: "center", width: "5%"
					,itemTemplate: function(_, item) {
						return $("<input name='courRadio' disabled>")
								.attr("type", "radio")
								.val(item.COUR_SCHE)
								.on("click", function(e) {
									$("#detailCourSche").val(item.COUR_SCHE);
									$("#detailEducBegd").val(item.EDUC_BEGD);
									$("#detailEducEndd").val(item.EDUC_ENDD);
									$("#detailEducCost").val(item.EDUC_COST);
									$("#detailEducTime").val(item.EDUC_TIME);
									$("#detailApprMark").val(item.APPR_MARK);
									$("#detailPassFlag").val(item.PASS_FLAG);
									$("#detailEsseFlag").val(item.ESSE_FLAG);
									$("#detailEmplFlag").val(item.EMPL_FLAG);
									$("#detailSemiFlag").val(item.SEMI_FLAG);
								});
					}
				},
				{	title: "차수", name: "COUR_SCHE", type: "text", align: "center", width: "15%" },
				{	title: "교육기간", name: "EDUC_BEGD", type: "text", align: "center", width: "21%"
					,itemTemplate: function(value, storeData) {
						return storeData.EDUC_BEGD + " ~ " + storeData.EDUC_ENDD;
					}
				},
				{	title: "교육비", name: "EDUC_COST", type: "number", align: "center", width: "16%"
					,itemTemplate: function(value, storeData) {
						return value.format();
					}
				},
				{	title: "교육시간", name: "EDUC_TIME", type: "number", align: "center", width: "16%"
					,itemTemplate: function(value, storeData) {
						return value.format();
					}
				},
				{	title: "필수여부",name: "ESSE_FLAG", align: "center", width: "8%"
					,itemTemplate: function(value, item) {
						if(value=="X")
							return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
						else
							return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
					}
				},
				{	title: "고용보험", name: "EMPL_FLAG", align: "center", width: "8%"
					,itemTemplate: function(value, item) {
						if(value=="X")
							return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
						else
							return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
					}
				},
				{	title: "세미나과정", name: "SEMI_FLAG", align: "center", width: "8%"
					,itemTemplate: function(value, item) {
						if(value=="X")
							return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
						else
							return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
					}
				}
			]
		});
	});
	
	// 교육과정 상세 정보 변경
	var setTextareaChange= function(storeData) {
		$.each(storeData, function (key, value) {
			$("#TDLINE_TEXT").append(value.TDLINE + "<br>");
        });
	};
	
	$(document).ready(function(){
		// 초기화
		CHANGE_CODE();
		
		detailSearch();
	});
	
	
	$("#detailEducYear, #detailOrgaCode, #detailCataCode").change(function(){
		CHANGE_CODE();
	});
	
	$("#detailCourCode").change(function(){
		$("#curriculumGrid").jsGrid("search").done(function(){
			$("input:radio[name='courRadio']").prop("disabled",false);
		});
	});
	
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		$("#detailEducYear").removeClass("readOnly").prop("disabled",false);
		$("#detailOrgaCode").removeClass("readOnly").prop("disabled",false);
		$("#detailCataCode").removeClass("readOnly").prop("disabled",false);
		$("#detailCourCode").removeClass("readOnly").prop("disabled",false);
		$("input:radio[name='courRadio']").prop("disabled",false);
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
				url : '/appl/deleteEdu',
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
		$("#curriculumGrid").jsGrid({"data":$.noop});
		detailSearch().done(function(){
			$("input:radio[name='courRadio']").prop("disabled",true);
		});
		
		$("#detailEducYear").addClass("readOnly").prop("disabled",true);
		$("#detailOrgaCode").addClass("readOnly").prop("disabled",true);
		$("#detailCataCode").addClass("readOnly").prop("disabled",true);
		$("#detailCourCode").addClass("readOnly").prop("disabled",true);
		
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
			$("#detailOrgaName").val($("#detailOrgaCode option:selected").text());
			$("#detailCataName").val($("#detailCataCode option:selected").text());
			$("#detailCourName").val($("#detailCourCode option:selected").text());
			
			
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'post',
				url : '/appl/updateEdu',
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