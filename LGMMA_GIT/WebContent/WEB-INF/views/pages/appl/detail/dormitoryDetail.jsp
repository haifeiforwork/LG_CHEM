<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%

%>

	<form id="detailForm">
	<div class="tableArea">
		<h2 class="subtitle">사택(기숙사) 신청 상세내역</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>사택(기숙사) 신청 상세내역</caption>
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
				<th><span class="textPink">*</span><label for="detailMoveDate">입주희망일</label></th>
				<td class="tdDate datepicker">
					<input class="readOnly datepicker" type="text" id="detailMoveDate" name="MOVE_DATE" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailZchouseGubun1">구분 </label></th>
				<td>
					<input type="radio" id="detailZchouseGubun1" name="ZCHOUSE_GUBUN" value="C" disabled /><label for="detailZchouseGubun1">사택</label>
					<input type="radio" id="detailZchouseGubun2" name="ZCHOUSE_GUBUN" value="D" disabled /><label for="detailZchouseGubun2">기숙사</label>
				</td>
				<th>무주택여부</th>
				<td>
					<input type="checkbox" id="detailNohouse" name="NOHOUSE" value="X" disabled >
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">제출서류 안내</span></p>
			<p>지방세 세목별과세증명서(배우자 포함), 부양가족이 등재된 주민등록등본 </p>
		</div>
	</div>
	<div class="listArea">
		<h2 class="subtitle">동거인 목록</h2>
		<div id="mateGridForDetail">
	</div>
	<br/>
	<div class="listArea">
		<div class="agreeCheckText">
			<ul>
				<strong>준 수 사 항</strong>
				<li>
					<span class="no">1.</span> 
					<p>출퇴근 가능지역내 무주택자로서 사규 및 사택관리규정을 준수하여 사택에 입주한다.  
					   가족 소유주택의 경우에는 사택으로 입주할 수 없으며, <br>사실상 본인 및 가족소유주택의 경우에도 사택으로 입주할 수 없다.</p>
				</li>
				<li>
					<span class="no">2.</span> 
					<p>사택입주 도중 출퇴근 가능지역내에 주택을 구입하게 될 경우 이 사실을 관리부서에 통보하고 사택을 퇴거해야 한다.</p>
				</li>
				<li>
					<span class="no">3.</span> 
					<p>임대차계약관련 다음과 같은 중대한 사안이 발행하였을 경우에는 관리부서에 즉시 통보한다.</p>  
					<ul>
						<li>① 임차사택의 소유권이 변경될 경우</li>  
						<li>② 임대차계약 또는 임차보증금 회수에 중대한 영향을 미칠만한 사유가 발생한 경우</li>
					</ul>
				</li>
				<li>
					<span class="no">4.</span>
					<p>사택의 효율적 관리와 원활한 운영을 위해 협조한다.</p>
				</li>
			</ul> 	
			<input class="readOnly" type="checkbox" id="detailPromise" name="PROMISE" value="X" disabled >위의 준수사항을 확인합니다.
		</div>
	</div>
	<input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
	</form>



<script type="text/javascript">

	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getDomitoryDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				setDetailView(response.storeData);
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
	
	 $(function() {
		$("#mateGridForDetail").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: true,
			fields: [
				{ title: "관계", name: "MATE_RELA", type: "text", align: "center", width: 33 },
				{ title: "성명", name: "MATE_NAME", type: "text", align: "center", width: 33 },
				{ title: "직업", name: "MATE_WORK", type: "text", align: "center", width: 34 }
			]
		});
	});
	
	var setDetailView = function(data) {
		var arrayData = [];
		if(data.MATE_RELA !="" || data.MATE_NAME !="" || data.MATE_WORK !="")
			arrayData.push({"MATE_RELA" : data.MATE_RELA, "MATE_NAME" : data.MATE_NAME, "MATE_WORK" : data.MATE_WORK});
		if(data.MATE_RELA2 !="" || data.MATE_NAME2 !="" || data.MATE_WORK2 !="")
			arrayData.push({"MATE_RELA" : data.MATE_RELA2, "MATE_NAME" : data.MATE_NAME2, "MATE_WORK" : data.MATE_WORK2});
		if(data.MATE_RELA3 !="" || data.MATE_NAME3 !="" || data.MATE_WORK3 !="")
			arrayData.push({"MATE_RELA" : data.MATE_RELA3, "MATE_NAME" : data.MATE_NAME3, "MATE_WORK" : data.MATE_WORK3});
		if(data.MATE_RELA4 !="" || data.MATE_NAME4 !="" || data.MATE_WORK4 !="")
			arrayData.push({"MATE_RELA" : data.MATE_RELA4, "MATE_NAME" : data.MATE_NAME4, "MATE_WORK" : data.MATE_WORK4});
		if(data.MATE_RELA5 !="" || data.MATE_NAME5 !="" || data.MATE_WORK5 !="")
			arrayData.push({"MATE_RELA" : data.MATE_RELA5, "MATE_NAME" : data.MATE_NAME5, "MATE_WORK" : data.MATE_WORK5});

		$("#mateGridForDetail").jsGrid({
			autoload: true,
			data: arrayData
 		});
 	}
	
	var isCanAddMate = function(grid) {
		var valid = true;
		$.each(grid.data, function(i, item) {
			if(item.MATE_RELA == "" || item.MATE_NAME == "") {
				alert("동거인 관계/성명을 입력후 추가 가능합니다.");
				valid = false;
				return false;
			}
		});
		return valid;
	}
	
	var customSerialize = function(data, param) {
		//MATE_RELA, MATE_RELA2 ... 인 모델객체 때문에 별도 구현
		$.each(data, function(i, row){
			for (var key in row) {
				if (row.hasOwnProperty(key)) {
					if(i > 1)
						param.push({name:key+(i+1), value:row[key]});
					else
						param.push({name:key, value:row[key]});
				}
			}
		});
	}
	
	var checkReqDomitoryFormValid = function() {
		//기존 편집중 데이터를 비활성화 시킨다.
		$("#mateGridForDetail").find(".jsgrid-update-button").click();
		if(!isCanAddMate($("#mateGridForDetail").jsGrid())) {
			return false;
		}
		if($("#detailMoveDate").val().trim().length == 0) {
			alert("입주희망일을 입력하세요.");
			$("#detailMoveDate").focus();
			return false;
		} 
		if($("#detailPromise").is(":checked") == false) {
			alert("준수사항을 확인하세요.");
			$("#detailPromise").focus();
			return false;
		}
		return true;
	}
	
	
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		$("#detailMoveDate").removeClass("readOnly").prop("readOnly",false).datepicker();
		$("input:radio[name='ZCHOUSE_GUBUN']").removeClass("readOnly").prop("disabled",false);
		$("#detailNohouse").removeClass("readOnly").prop("disabled",false);
		$("#detailPromise").removeClass("readOnly").prop("disabled",false);
		
		$("#mateGridForDetail").jsGrid({
			height: "auto",
            width: "100%",
            //sorting: true,
            paging: false,
            confirmDeleting: false,
            //autoload: true,
            //inserting: true,
            editing: true,
            invalidMessage: "",
            onItemInserting: function(args) {
            	if(args.grid.data.length > 4) {
            		args.cancel = true;
            		alert("동거인 5명까지 추가 가능합니다.");
            	} else {
            		args.cancel = !isCanAddMate(args.grid);
            	}
            },
			fields: [
				{ title: "관계", name: "MATE_RELA", type: "text", align: "center", width: 33 },
				{ title: "성명", name: "MATE_NAME", type: "text", align: "center", width: 33 },
				{ title: "직업", name: "MATE_WORK", type: "text", align: "center", width: 34 },
				{ type: "control", editButton: true, modeSwitchButton: false, width: 16,
					headerTemplate: function() {
						return $("<a class='inlineBtn'><span>추가</span></a>")
								.on("click", function () {
									//기존 편집중 데이터를 비활성화 시킨다.
									$("#mateGridForDetail").find(".jsgrid-update-button").click();
									var newItem = {"MATE_RELA" : "", "MATE_NAME" : "", "MATE_WORK" : ""};
									$("#mateGridForDetail").jsGrid("insertItem" , newItem);
									$("#mateGridForDetail").jsGrid("rowByItem", newItem).click();
								});
					}
				}
			]
		});
		
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
				url : '/appl/deleteDomitory',
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
		$("#mateGridForDetail").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: true,
			data : $.noop,
			fields: [
				{ title: "관계", name: "MATE_RELA", type: "text", align: "center", width: 33 },
				{ title: "성명", name: "MATE_NAME", type: "text", align: "center", width: 33 },
				{ title: "직업", name: "MATE_WORK", type: "text", align: "center", width: 34 }
			]
		});
		
		detailSearch();
		
		$("#detailMoveDate").addClass("readOnly").prop("readOnly",true);
		$("input:radio[name='ZCHOUSE_GUBUN']").addClass("readOnly").prop("disabled",true);
		$("#detailNohouse").addClass("readOnly").prop("disabled",true);
		$("#detailPromise").addClass("readOnly").prop("disabled",true);
		
		destroydatepicker("detailForm");
	}
	
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(checkReqDomitoryFormValid()){
			if(confirm("저장하시겠습니까?")) {
				if ($("#detailNohouse").is(':checked')) {
					$("#detailNohouse").val("X");
				} else {
					 $("#detailNohouse").val("");
				}
				$("#reqSaveBtn").prop("disabled", true);
				$("#detailAinfSeqn").val('${AINF_SEQN}');
				
				var param = $("#detailForm").serializeArray();
				customSerialize($("#mateGridForDetail").jsGrid("option", "data"), param);
				$("#detailDecisioner").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateDomitory',
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