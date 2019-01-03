<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="hris.A.A18Deduct.rfc.A18GuenTypeRFC" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% 
String curYear = DataUtil.getCurrentYear();
String curMonth = DataUtil.getCurrentMonth();
%>
<div class="tableArea">
	<h2 class="subtitle">근로소득·갑근세 원천징수 영수증 신청 조회</h2>
	<div class="table">
		<form id="detailForm" name="detailForm">
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
			<table class="tableGeneral">
				<caption>제증명 신청서 작성</caption>
				<colgroup>
					<col class="col_15p"/>
					<col class="col_35p"/>
					<col class="col_15p"/>
					<col class="col_35p"/>
				</colgroup>
				<tbody>
					<tr>
						<th>신청일</th>
						<td colspan="3" class="tdDate"><input class="readOnly" type="text"
							name="BEGDA" id="BEGDA" size="20"
							value=""
							readonly="readonly" /></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>구분</th>
						<td><select name="GUEN_TYPE" id="GUEN_TYPE">
                      <option>-------------------------</option>
<%= WebUtil.printOption((new A18GuenTypeRFC()).getGuenType()) %>
						</select>
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
						<td colspan="3">
						<input type="radio" name="PRINT_CHK" value="1" id="print_chk1" /><label for="input-radio01-1">본인 발행</label>
						<input type="radio" name="PRINT_CHK" value="2" id="print_chk2" checked="checked"/><label for="input-radio01-2">담당부서 요청발행</label>
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span>제출처</th>
						<td>
							<input class="w200" type="text" name="SUBMIT_PLACE" id="SUBMIT_PLACE" value=""/>
						</td>
						<th><span class="textPink">*</span>사용목적</th>
						<td>
							<input class="w200" type="text" name="USE_PLACE" id="USE_PLACE" value=""/>
						</td>
					</tr>	
					<tr id="duringLayer1">
						<th><span class="textPink">*</span>선택기간</th>
						<td colspan="3">
							<input type="text" size="6" name="EBEGDA" id="EBEGDA" readonly/> 
							~
							<input type="text" class="monthpicker" size="6" name="EENDDA" id="EENDDA" readonly/>
							<span class="noteItem">※  선택기간은 출력하기를 원하는 1년 단위의 기간을 입력한다. </span>
						</td>
					</tr>
					<tr>
						<th>특기사항</th>
						<td colspan="3">
							<textarea name="SPEC_ENTRY" id="SPEC_ENTRY" cols="40" rows="4"> </textarea>
							<input type="hidden" name="SPEC_ENTRY1" id="SPEC_ENTRY1" >
				            <input type="hidden" name="SPEC_ENTRY2" id="SPEC_ENTRY2" >
				            <input type="hidden" name="SPEC_ENTRY3" id="SPEC_ENTRY3" >
				            <input type="hidden" name="SPEC_ENTRY4" id="SPEC_ENTRY4" >
				            <input type="hidden" name="SPEC_ENTRY5" id="SPEC_ENTRY5" >
						</td>
					</tr>	
				</tbody>
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
			url : "/appl/getIncomeTaxDetail.json",
			dataType : "json",
			data : {
				"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'
			}
		}).done(function(response) {
			if (response.success) {
				setDetail(response.storeData);
				
				$('.monthpicker').monthpicker('destroy');
			} else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		var setDetail = function(item) {
			item.PRINT_NUM = parseInt(item.PRINT_NUM);
			item.GUEN_TYPE = '00'+item.GUEN_TYPE;
			setTableText(item, "detailForm");
			if(item.GUEN_TYPE == "0001") $("#duringLayer1").hide();
			if(item.GUEN_TYPE == "0002") {
				$("#EBEGDA").val(item.EBEGDA.substr(0,7));
				$("#EENDDA").val(item.EENDDA.substr(0,7));
			}
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
		
		$('.monthpicker').monthpicker();
		
		setPRINT_CHK(printChk, $("#PRINT_NUM"));
		
		$("[name='PRINT_CHK']").click(this, function(){
			setPRINT_CHK($(this).val(), $("#PRINT_NUM"));
		});
		
		fncSetFormReadOnly($("#detailForm"), false, new Array("BEGDA","EBEGDA", "EENDDA"));
		$('#EENDDA').removeClass("readOnly");
	}

	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteIncomeTax',
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
					url : '/appl/updateIncomeTax',
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
	
	$("#EENDDA").change(function() {
		chkCurDate();
		
	});
	
	var chkCurDate = function(){
		var toYear = $("#EENDDA").val();
		var year = toYear.substr(0,4);
		var month = toYear.substr(5,7);
		
		if(Number(year)>Number("<%=curYear%>")||(Number(year)==Number("<%=curYear%>") && Number(month)>Number("<%=curMonth%>"))) {
			alert("현재일 이후는 입력하실 수 없습니다.");
			$("#EENDDA").val("");
			$("#EENDDA").focus();
		}
		
		calEbegda();
	}
	
	
	var calEbegda = function(){
		$("#EBEGDA").val("");
		//1년계산함
		var toYear = $("#EENDDA").val();
		if(toYear=="") return;
		var year = toYear.substr(0,4);
		var month = toYear.substr(5,7);
		month = Number(month)+1;
		
		if(month==13) {
			month = "01";
		} else {
			year = Number(year)-1;
			if(month<10) month = "0"+month;
		}
		
		$("#EBEGDA").val(year+"."+month);
	}
	
	var checkDetailFormValid = function() {
		if($("#detailForm #GUEN_TYPE option:selected").index() == 0){
			alert("구분을 선택하세요.");
			$("#detailForm #GUEN_TYPE").focus();
			return false;
		}

		//R3에서 필드 길이의 원인모를 에러로 도메인의 데이터 타입, 길이를 테이블과 맞출수가 없어서.. 이 방법으로 처리함.
		guen_type = $("#detailForm #GUEN_TYPE option:selected").val();
		//controller 에서 substring 하는것으로 변경
		//$("#detailForm #GUEN_TYPE").val(guen_type.substring(2, 4));

		if( $("#detailForm #SUBMIT_PLACE").val() == "" ){
			alert("제출처를 입력하여 주십시요");
			$("#detailForm #SUBMIT_PLACE").focus();
			return false;
		}

		if( $("#detailForm #USE_PLACE").val() == "" ){
			alert("사용목적을 입력하여 주십시요");
			$("#detailForm #USE_PLACE").focus();
			return false;
		}

		if( guen_type == "0002" ) {
			calEbegda();
			if($("#EBEGDA").val()=="" || $("#EENDDA").val()==""){
				alert("선택기간은 필수입력 항목입니다.");
				$("#EENDDA").focus();
				return false;
			}
			chkCurDate();
		}
		if ( $("#detailForm #SPEC_ENTRY").val() != "" ) {
			textArea_to_TextFild_1( $("#detailForm #SPEC_ENTRY").val() );
		}

		return true;
	}

	$("#GUEN_TYPE").on("change", function() {
		$("#incomeTaxForm #EBEGDA").val("");
		$("#incomeTaxForm #EENDDA").val("");
		
		if($(this).find(":selected").val() == "0002"){ //갑근세 원천징수 증명서
			$("#duringLayer1").show();
		} else {
			$("#duringLayer1").hide();
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
				flag = true;
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
