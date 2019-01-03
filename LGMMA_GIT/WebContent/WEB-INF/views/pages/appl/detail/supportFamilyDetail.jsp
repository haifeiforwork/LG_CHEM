<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="hris.A.A12Family.rfc.A12HandicapRFC"%>


<div class="tableArea">
	<h3 class="subsubtitle">대상자</h3>
	<form id="detailForm">
	<div class="table">
		<table class="tableGeneral">
			<caption>연락처 수정</caption>
			<colgroup>
				<col class="col_15p" />
				<col class="col_35p" />
				<col class="col_15p" />
				<col class="col_35p" />
			</colgroup>
			<tbody>
			<tr>
				<th><label for="detailLnmhg">성명(한글)</label></th>
				<td>
					<input class="w50 readOnly" type="text" id="detailLnmhg" name="LNMHG" readonly />
					<input class="w100 readOnly" type="text" id="detailFnmhg" name="FNMHG" readonly />
				</td>
				<th><label for="detailStext">가족유형</label></th>
				<td>
					<input class="readOnly" type="text" id="detailStext" name="STEXT" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="detailRegno">주민등록번호</label></th>
				<td>
					<input class="readOnly" type="text" id="detailRegno" name="REGNO" readonly />
				</td>
				<th><label for="detailAtext">관계</label></th>
				<td>
					<input class="readOnly" type="text" id="detailAtext" name="ATEXT" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="detailFgbdt">생년월일</label></th>
				<td>
					<input class="w40 readOnly" type="text" id="detailYear" name="year" readonly /> 년
					<span class="pl5"><input class="w20 readOnly" type="text" id="detailMonth" name="month" readonly /> 월</span>
					<span class="pl5"><input class="w20 readOnly" type="text" id="detailDay" name="day" readonly /> 일</span>
				</td>
				<th><label>성별</label></th>
				<td>
					<input class="readOnly" type="radio" id="detailFasex1" name="FASEX" value="1" disabled /> 남
					<input class="readOnly" type="radio" id="detailFasex2" name="FASEX" value="2" disabled  /> 여
				</td>
			</tr>
			<tr>
				<th><label for="detailFgbot">출생지</label></th>
				<td><input class="readOnly" type="text" id="detailFgbot" name="FGBOT" readonly /></td>
				<th><label for="detailStext1">학력</label></th>
				<td><input class="readOnly" type="text" id="detailStext1" name="STEXT1" readonly /></td>
			</tr>
			<tr>
				<th><label for="detailLandx">출생국</label></th>
				<td><input class="readOnly" type="text" id="detailLandx" name="LANDX" readonly /></td>
				<th><label for="detailFasin">교육기관</label></th>
				<td><input class="readOnly" type="text" id="detailFasin" name="FASIN" readonly /></td>
			</tr>
			<tr>
				<th><label for="detailNatio">국적</label></th>
				<td><input class="readOnly" type="text" id="detailNatio" name="NATIO" readonly /></td>
				<th><label for="detailFajob">직업</label></th>
				<td><input class="readOnly" type="text" id="detailFajob" name="FAJOB" readonly /></td>
			</tr>
			</tbody>
		</table>
	</div>
	<div class="tableComment mb30">
		<p><span class="bold">부양가족여부는 연말정산자료로서 자격요건에 해당하는 경우에만 신청하시기 바랍니다.</span></p>
		<p>신청하시기전에 [사용방법안내] 에서 자격요건과 제출서류를 반드시 확인해 주시기 바랍니다.</p>
	</div>
	<div class="tableArea pb0">
		<h3 class="subsubtitle">종속성</h3>
		<div class="table">
			<table class="tableGeneral" id="detailTB">
				<caption>종속성 테이블</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_45p" />
					<col class="col_15p" />
					<col class="col_25p" />
				</colgroup>
				<tbody>
				<tr>
					<th>세금</th>
					<td>
						<input class="readOnly" type="checkbox" id="detailDptid" name="DPTID" value="X" disabled/><label for="detailDptid">부양가족</label>
						<input class="readOnly" type="checkbox" id="detailBalid" name="BALID" value="X" disabled/><label for="detailBalid">수급자</label>
						<input class="readOnly" type="checkbox" id="detailHndid" name="HNDID" value="X" disabled/><label for="detailHndid">장애인</label>
						<input class="readOnly" type="checkbox" id="detailChdid" name="CHDID" value="X" disabled/><label for="detailChdid">자녀보호</label>
					</td>
					<th>기타</th>
					<td>
						<input class="readOnly" type="checkbox" id="detailLivid" name="LIVID" value="X" disabled /><label for="detailLivid">동거여부</label>
						<input class="readOnly" type="checkbox" id="detailHELID" name="HELID"  value="X" disabled/><label for="detailHELID">건강보험</label>
					</td>
				</tr>
				<tr>
					<th>장애코드</th>
					<td >
						<select class="readOnly"  id = "supportFamilyHNDCD" name = "HNDCD" disabled>
							<option value="">------------</option>
							<%= WebUtil.printOption((new A12HandicapRFC()).getFamilyRelation(""),"HNDCD") %>
						</select>
					</td>
				
					<th><label for="inputDateFrom">장애(예상)기간</label></th>
					<td  >
						<input class="datepicker"  id="HNBEG" name="HNBEG" type="text" value=""  />
						~
						<input class="datepicker"  id="HNEND" name="HNEND" type="text" value=""  />
					</td>
								
				</tr>
				
				
				<tr id="periodYN">
					<th>적용시기</th>
					<td colspan="3">
						<select class="readOnly" name="PERIOD" id="popPeriod" disabled>
							<option value="">현재년도</option>
							<option value="X">직전년도</option>
						</select>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
	</div>
	<input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
	<input type="hidden" id="detailGubun" name="GUBUN" /> <!-- 구분 'X':부양가족, ' ':가족수당 -->
	<input type="hidden" id="detailBegda" name="BEGDA" value=""/>
	<input type="hidden" id="detailSubty" name="SUBTY" />
	<input type="hidden" id="detailObjps" name="OBJPS" />
	<input type="hidden" id="detailUPMUTYPE"  name="UPMUTYPE" />
	<input type="hidden" id="detailFamid" name="FAMID" />
	</form>
</div>

<script type="text/javascript">
	
	var HNFlag = false;
	
	var detailSearch = function() {

		$.ajax({
			type : "get",
			url : "/appl/getSupportFamilyDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.A12FamilyListData);
				if(response.periodYN=="Y"){
					$("#periodYN").show();
				} else {
					$("#periodYN").hide();
				}
				
				
				setDetail(response.storeData);
				$("#detailRegno").val(addResBar(response.A12FamilyListData.REGNO));
				$("#detailYear").val(response.A12FamilyListData.FGBDT.substring(0, 4));
				$("#detailMonth").val(response.A12FamilyListData.FGBDT.substring(5, 7));
				$("#detailDay").val(response.A12FamilyListData.FGBDT.substring(8, 10));
				$('input:radio[name="FASEX"]:input[value='+response.A12FamilyListData.FASEX+']').prop("checked", true);
				
				if(response.A12FamilyListData.SUBTY =="2") { $("#detailChdid").show(); }else{ $("#detailChdid").hide(); }
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
		}
		
		fncSetFormReadOnly($("#detailTB"), true);

		
	}
	
	$(document).ready(function(){
		
		detailSearch();



	});
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){

		fncSetFormReadOnly($("#detailTB"), false);

		$('#HNBEG').datepicker();

		$('#HNEND').datepicker();

	};
	
	
	$("#detailHndid").click(function(){
		if($("#detailHndid").is(':checked')){
			HNFlag = true;
		}else{
			HNFlag = false;
			
		}
	});
	
	
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
				url : '/appl/deleteSupportFamily',
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
		
	fncSetFormReadOnly($("#detailTB"), true);
	destroydatepicker("detailTB");
	
	}

	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function() {
		if ($("#detailDecisioner").jsGrid("dataCount") < 1) {
			alert("결재자 정보가 없습니다.");
			return;
		}
	
		if ($("#detailHndid").is(':checked')) {
			if( $("#supportFamilyHNDCD").val()=="" ){
				alert("장애코드를 입력해주세요.");
				return;
			}
			if( $("#HNBEG").val()=="" || $("#HNEND").val()=="" ){
				alert("장애(예상)기간을 입력해주세요.");
				return;
			}
			
		}else{
			$("#supportFamilyHNDCD").val("");
			$("#HNBEG").val("");
			$("#HNEND").val("");
		}
		
		
		if (confirm("저장 하시겠습니까?")) {

			if ($("#detailDptid").is(':checked')) {
				$("#detailDptid").val("X");
			} else {
				$("#detailDptid").val("");
			}
			if ($("#detailBalid").is(':checked')) {
				$("#detailBalid").val("X");
			} else {
				$("#detailBalid").val("");
			}
			if ($("#detailHndid").is(':checked')) {
				$("#detailHndid").val("X");
			} else {
				$("#detailHndid").val("");
			}
			if ($("#detailChdid").is(':checked')) {
				$("#detailChdid").val("X");
			} else {
				$("#detailChdid").val("");
			}
			if ($("#detailLivid").is(':checked')) {
				$("#detailLivid").val("X");
			} else {
				$("#detailLivid").val("");
			}
			
			if ($("#detailHELID").is(':checked')) {
				$("#detailHELID").val("X");
			} else {
				$("#detailHELID").val("");
			}			
			

			$('#supportFamilyUPMUTYPE').val("07");
			$("#reqSaveBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			$("#detailRegno").val(removeResBar($("#detailRegno").val()));
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);

			jQuery.ajax({
				type : 'post',
				url : '/appl/updateSupportFamily',
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

	}
</script>
