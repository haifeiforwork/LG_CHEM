<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="tableArea">
	<h2 class="subtitle">재직증명서 신청 조회</h2>
	<div class="table">
		<form id="detailForm" name="detailForm">
			<table class="tableGeneral">
				<caption>근로소득/갑근세 원천징수 영수증 신청서 작성</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_85p" />
				</colgroup>
				<tbody>
					<tr>
						<th>신청일</th>
						<td class="tdDate"><input class="readOnly" type="text"
							name="BEGDA" id="BEGDA" size="20"
							value=""
							readonly="readonly" /></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>구분</th>
						<td><select name="LANG_TYPE" id="LANG_TYPE" class="w100">
								<option value="1">한글</option>
								<option value="2">영문</option>
						</select> <span class="noteItem">※ 비자발급용은 국문으로 신청하셔도 가능합니다.</span></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>발행부수</th>
						<td><select name="PRINT_NUM" id="PRINT_NUM" class="w100">
								<option value="1" selected>1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
								<option value="6">6</option>
								<option value="7">7</option>
								<option value="8">8</option>
								<option value="9">9</option>
								<option value="10">10</option>
						</select></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>발행방법</th>
						<td>
						<input type="radio" name="PRINT_CHK" value="1" id="print_chk1" /><label for="input-radio01-1">본인 발행</label>
						<input type="radio" name="PRINT_CHK" value="2" id="print_chk2" checked="checked"/><label for="input-radio01-2">담당부서 요청발행</label>
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>현주소</th>
						<td><input class="w400" type="text" name="ADDRESS1"
							id="ADDRESS1" value="" /> <input class="w400"
							type="text" name="ADDRESS2" id="ADDRESS2" value="" />
							<p class="noteItem">※ 영문증명서를 신청하실 경우 현주소에 영문으로 입력해주세요.</p></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>제출처</th>
						<td><input class="w200" type="text" name="SUBMIT_PLACE"
							id="SUBMIT_PLACE" value="" /></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>용도</th>
						<td><input class="w200" type="text" name="USE_PLACE"
							id="USE_PLACE" value="" /> <span class="noteItem">※ 보증용의
								경우 배우자 또는 배우자 부재시 부모 합의서 제출요망</span></td>
					</tr>
					<tr>
						<th>특기사항</th>
						<td><textarea name="SPEC_ENTRY" id="SPEC_ENTRY" cols="40"
								rows="4"> </textarea> <input type="hidden" name="SPEC_ENTRY1"
							id="SPEC_ENTRY1"> <input type="hidden" name="SPEC_ENTRY2"
							id="SPEC_ENTRY2"> <input type="hidden" name="SPEC_ENTRY3"
							id="SPEC_ENTRY3"> <input type="hidden" name="SPEC_ENTRY4"
							id="SPEC_ENTRY4"> <input type="hidden" name="SPEC_ENTRY5"
							id="SPEC_ENTRY5"></td>
					</tr>
				</tbody>
				<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
			</table>
		</form>
	</div>
</div>
<!--// Table end -->
<script>
	var printChk;
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getIssueDetail.json",
			dataType : "json",
			data : {
				"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'
			}
		}).done(function(response) {
			if (response.success) {
				setDetail(response.storeData);
			} else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		var setDetail = function(item) {
			item.PRINT_NUM = parseInt(item.PRINT_NUM);
			setTableText(item, "detailForm");
			printChk = item.PRINT_CHK;
			$("#detailForm #SPEC_ENTRY").val($("#detailForm #SPEC_ENTRY1").val() + $("#detailForm #SPEC_ENTRY2").val() + $("#detailForm #SPEC_ENTRY3").val() + $("#detailForm #SPEC_ENTRY4").val() + $("#detailForm #SPEC_ENTRY5").val());
			fncSetFormReadOnly($("#detailForm"), true);
		}
	};

	$(document).ready(function() {
		detailSearch();
	});
	
	var setPRINT_CHK =  function(val, obj){
		var stat = false;
		//본인발행
		if(val=="1") stat = true;
		$(obj).val("1");
		setObjReadOnly(obj, stat);
	};
	
	var reqModifyActionCallBack = function() {
		fncSetFormReadOnly($("#detailForm"), false, new Array("BEGDA"));
		
		setPRINT_CHK(printChk, $("#PRINT_NUM"));
		
		$("[name='PRINT_CHK']").click(this, function(){
			setPRINT_CHK($(this).val(), $("#PRINT_NUM"));
		});
		
	}

	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteIssue',
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

	var reqCancelActionCallBack = function() {
		$("#detailForm").each(function() {
			this.reset();
		});
		detailSearch();
	}

	var reqSaveActionCallBack = function() {
		if (checkDetailFormValid()) {
			if (confirm("저장하시겠습니까?")) {
				$("#PRINT_NUM").prop("disabled", false);
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateIssue',
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
	var checkDetailFormValid = function() {
		var address1 = $("#detailForm #ADDRESS1").val();//주소
		var address2 = $("#detailForm #ADDRESS2").val();
		var use_place = $("#detailForm #USE_PLACE").val();
		var spec_entry = $("#detailForm #SPEC_ENTRY").val();

		if( address1 == ""){
			alert("현주소를 입력하여 주십시요");
			$("#detailForm #ADDRESS1").focus();
			return false;
		} else {
			if( $("#detailForm #LANG_TYPE option:selected").val() == 2 ){
				if( !checkEnglish( $("#detailForm #ADDRESS1").val() ) ){
					alert("영문 주소 입력만 가능합니다.");
					$("#detailForm #ADDRESS1").focus();
					$("#detailForm #ADDRESS1").select();
					return false;
				}
				if( $("#detailForm #ADDRESS2").val() != "" ){
					if( !checkEnglish( $("#detailForm #ADDRESS2").val() ) ){
						alert("영문 주소 입력만 가능합니다.");
						$("#detailForm #ADDRESS2").focus();
						$("#detailForm #ADDRESS2").select();
						return false;
					}
				}
			}
		}
		//subtype = document.form1.SUBF_TYPE[document.form1.SUBF_TYPE.selectedIndex].value;
		 
		var submit_plac = $("#detailForm #SUBMIT_PLACE").val();//제출처
		if( submit_plac == "" ){
			alert("제출처를 입력하여 주십시요");
			$("#detailForm #SUBMIT_PLACE").focus();
			return false;
		}

		if( use_place == "" ){
			alert("용도를 입력하여 주십시요");
			$("#detailForm #USE_PLACE").focus();
			return false;
		}
/* 
		if ( check_empNo() ){
			return false;
		}
*/
		if ( spec_entry != "" ) {
			textArea_to_TextFild_1( spec_entry );
		}
		return true;
	}
	// 글자수입력제한
	$("#ADDRESS1, #ADDRESS2").keyup(function(event){
	    val = $(this).val();
	    nam = this.name;
	    len = checkLength($(this).val());

	    if (event.keyCode ==13 )  {
			if(nam=="ADDRESS1"){
				$("#detailForm #ADDRESS2").focus();
	        }else if(nam=="ADDRESS2"){
	            this.blur();
	        }
		}

	    if( len > 79 ) {
	        vala = limitKoText(val,79);
	        this.blur();
	        $(this).val(vala);
	        $(this).focus();
	    }
	});
	var textArea_to_TextFild_1 = function(text) {
		for(var i = 1 ; i < 6 ; i++) {
			$("#detailForm #SPEC_ENTRY"+i).val(""); 
		}
	    var tmpText="";
	    var tmplength = 0;
	    var count = 1;
	    var flag = true;
	    for ( var i = 0; i < text.length; i++ ){
			tmplength = checkLength(tmpText);
			if( text.charCodeAt(i) != 13 && Number( tmplength ) < 60 ){
				tmpText = tmpText+text.charAt(i);
				flag = true
			} else {
				flag = false;
				tmpText.trim;
				$("#detailForm #SPEC_ENTRY"+count).val(tmpText); 
				tmpText=text.charAt(i);
				count++;
				if( count > 5 ){
					break;
				}
			}
		}

	   if( flag ) {
			$("#detailForm #SPEC_ENTRY"+count).val(tmpText); 
	   }
	}
</script>
