<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hris.A.A17Licence.rfc.A17LicenceGradeRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="tableArea">
	<h2 class="subtitle">자격면허등록 조회</h2>
	<div class="table">
	<form id="detailForm">
		<table class="tableGeneral">
		<caption>자격면허등록</caption>
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
			<th><span class="textPink">*</span><label for="detailLicnName">자격증</label></th>
			<td>
				<input class="readOnly w200" type="text" id="detailLicnName" name="LICN_NAME" vname="자격증" readOnly />
				<a class="icoSearch" href="#" id="searchLicensePopupBtn"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
				<span class="noteItem colorRed">※ 직접 입력 마시고, 검색버튼 눌러서 입력하시기 바랍니다. </span>
				<input type="hidden" id="detailLicnCode" name="LICN_CODE" >
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailLicnGrad">자격등급</label></th>
			<td>
				<select class="readOnly" id="detailLicnGrad" name="LICN_GRAD" vname="자격등급" readOnly >
					<option value="">--------선택--------</option>
					<%= WebUtil.printOption((new A17LicenceGradeRFC()).getLicenceGrade()) %>
				</select>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailPublOrgh">발행처</label></th>
			<td>
				<input class="readOnly w250" type="text" id="detailPublOrgh" name="PUBL_ORGH" vname="발행처" readOnly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailLicnNumb">자격증번호</label></th>
			<td>
				<input class="readOnly w250" type="text" id="detailLicnNumB" name="LICN_NUMB" vname="자격증번호" readOnly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="inputDateDay">취득일</label></th>
			<td class="tdDate">
				<input type="text" class="datepicker readOnly" id="inputDateDay" name="OBN_DATE" vname="취득일" required readOnly />
			</td>
		</tr>
		</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
		<input type="hidden" id="detailGradName" name="GRAD_NAME" />
		
	</form>
	</div>
</div>
<!-- popup : 자격증 검색start -->
<div class="layerWrapper layerSizeS" id="popLayerLicense" style="display:inherit !important">
	<form id="popupLicenseForm">
	<div class="layerHeader">
		<strong>자격증 검색</strong>
		<a href="#" class="btnClose popLayerLicense_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="tableInquiry item1">
				관련 검색어
				<input type="text" id="popupLicnName" name="LICN_NAME" class="w155" onkeyup="javascript:if ( event.keyCode == 13){ $('#licensePopupGrid').jsGrid('search'); }" />
				<a href="#" id="searchLicenseBtn"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
			</div>
			<div class="listArea pb10">
				<div id="licensePopupGrid"></div>
			</div>
			<!--// Content end  -->
		</div>
	</div>
	</form>
</div>

<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getLicenseDetail.json",
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
		}
	}
	
	$(document).ready(function(){
		if($(".layerWrapper").length){
			$("#popLayerLicense").popup();
		};
		
		$("#searchLicensePopupBtn").hide();
		detailSearch();
	});
	
	// 자격증 popup 버튼 클릭
	$("#searchLicensePopupBtn").click(function(){
		$("#popupLicenseForm").each(function() {
			this.reset();
		});
		$("#licensePopupGrid").jsGrid({"data":$.noop}); //초기화 방안 재확인 필요
		
		$("#popLayerLicense").popup('show');
	});
	
	// popup 자격증 검색 버튼 클릭
	$("#searchLicenseBtn").click(function(){
		$("#licensePopupGrid").jsGrid("search");
	});
	
	// 자격면허증 popup grid 검색
	$(function() {
		$("#licensePopupGrid").jsGrid({
			height: "auto",
			width: "100%",
			paging: true,
			sorting: true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "post",
						url : "/base/getLicensePopupList.json",
						dataType : "json",
						data : { "LICN_NAME" : $("#popupLicnName").val() }
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
					title: "선택", name: "th1", align: "center", width: "10%",
					itemTemplate: function(_, item) {
						return $("<input>")
								.attr("type", "radio")
								.on("click",function(e){
									$("#detailLicnCode").val(item.LICN_CODE);
									$("#detailLicnName").val(item.LICN_NAME);
									//$("#detailFildType").val(item.FILD_TYPE);
									//$("#detailLicnType").val(item.LICN_TYPE);
									$("#popLayerLicense").popup('hide');
								});
					}
				},
				{ title: "자격증 종류", name: "LICN_NAME", type: "text", align: "left", width: "90%" },
				{ name:"LICN_CODE", type:"text", visible: false },
				{ name:"LICN_NAME", type:"text", visible: false }
			]
		});
	});
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		//$("#detailLicnName").removeClass("readOnly").prop("readOnly",false);
		$("#detailLicnGrad").removeClass("readOnly").prop("disabled",false);
		$("#detailPublOrgh").removeClass("readOnly").prop("readOnly",false);
		$("#detailLicnNumB").removeClass("readOnly").prop("readOnly",false);
		$("#inputDateDay").removeClass("readOnly").prop("readOnly",false);
		$("#searchLicensePopupBtn").show();
		
		$( "#inputDateDay" ).datepicker();
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
				url : '/appl/deleteLicense',
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
		//$("#detailLicnName").addClass("readOnly").prop("readOnly",true);
		$("#detailLicnGrad").addClass("readOnly").prop("disabled",true);
		$("#detailPublOrgh").addClass("readOnly").prop("readOnly",true);
		$("#detailLicnNumB").addClass("readOnly").prop("readOnly",true);
		$("#inputDateDay").addClass("readOnly").prop("readOnly",true);
		$("#searchLicensePopupBtn").hide();
		destroydatepicker("detailForm");
		detailSearch();
		
	}
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(confirm("저장하시겠습니까?")) {
			$("#reqSaveBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			$("#detailGradName").val($("#detailLicnGrad option:selected").text());
			
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'post',
				url : '/appl/updateLicense',
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