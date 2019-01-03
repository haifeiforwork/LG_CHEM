<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E01Medicare.rfc.E01HealthGuarReqsRFC"%>
<%@ page import="hris.E.E01Medicare.rfc.E01TargetNameRFC"%>
<%@ page import="hris.E.E01Medicare.E01TargetNameData"%>
<%@ page import="hris.E.E01Medicare.rfc.E01HealthGuarAccqRFC"%>
<%@ page import="hris.E.E01Medicare.rfc.E01HealthGuarLossRFC"%>
<%@ page import="hris.E.E01Medicare.rfc.E01HealthGuarHintchRFC"%>

<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
%>

<form id="detailForm">
<div class="tableArea">
	<h2 class="subtitle withButtons">건강보험 자격변경 신청</h2>
	<div class="buttonArea">
		<ul class="btn_mdl">
			<li><a href="#" id="addMemberBtn" class="darken" style="display:none;" ><span>추가</span></a></li>
			<li><a href="#" id="clearBtn" style="display:none;" ><span>취소</span></a></li>
		</ul>
	</div>
	<div class="clear"> </div>
	<div class="table">
		<table class="tableGeneral">
		<caption>건강보험 자격변경 신청</caption>
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
				<input class="readOnly" type="text" id="detailBegda" readOnly />
			</td>
		</tr>
		<!-- 신청구분 셀렉트 옵션에 따라 tr id="healthLayer1" 또는 tr id="healthLayer2" display -->
		<tr>
			<th><span class="textPink">*</span><label for="detailApplType">신청구분</label></th>
			<td colspan="3">
				<select class="readOnly" id="detailApplType" vname="신청구분" disabled >
					<option value =''>------선택------</option>
					<%= WebUtil.printOption((new E01HealthGuarReqsRFC()).getHealthGuarReqs()) %>
				</select>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailEname">대상자 성명</label></th>
			<td>
				<select class="readOnly" id="detailEname" vname="대상자 성명" disabled >
					<option value =''>------선택------</option>
<%
				Vector<E01TargetNameData> e01TargetNameData_vt =  (new E01TargetNameRFC()).getTargetName(userData.empNo);
				for ( int i = 0 ; i < e01TargetNameData_vt.size() ; i++ ) {
					E01TargetNameData data_name = e01TargetNameData_vt.get(i);
%>
					<option value="<%=data_name.LNMHG.trim() + ' ' + data_name.FNMHG.trim()%>" 
							SUBTY="<%=data_name.SUBTY %>"
							OBJPS="<%=data_name.OBJPS %>"
							><%=data_name.LNMHG.trim() + ' ' + data_name.FNMHG.trim()%></option>
<%
				}
%>
				</select>
			</td>
			<th><label for="detailAprtCode">원격지발급여부</label></th>
			<td>
				<input class="readOnly" type="checkbox" id="detailAprtCode" value="X" disabled >
			</td>
		</tr>
		<tr id="healthLayer1" style="display:none;">
			<th><span class="textPink">*</span><label for="detailAccqDate">취득일자</label></th>
			<td>
				<input class="readOnly datepicker w80" type="text" id="detailAccqDate" vname="취득일자" readOnly />
			</td>
			<th><span class="textPink">*</span><label for="detailAccqType">취득사유</label></th>
			<td>
				<select class="readOnly" id="detailAccqType" vname="취득사유" disabled >
					<option value =''>-------------------선택-------------------</option>
					<%= WebUtil.printOption((new E01HealthGuarAccqRFC()).getHealthGuarAccq()) %>
				</select>
			</td>
		</tr>
		<tr id="healthLayer2" style="display:none;">
			<th><span class="textPink">*</span><label for="detailLossDate">상실일자</label></th>
			<td>
				<input class="readOnly datepicker w80" type="text" id="detailLossDate" vname="상실일자" readOnly />
			</td>
			<th><span class="textPink">*</span><label for="detailLossType">상실사유</label></th>
			<td>
				<select class="readOnly" id="detailLossType" vname="상실사유" disabled > 
					<option value =''>-------------------선택-------------------</option>
					<%= WebUtil.printOption((new E01HealthGuarLossRFC()).getHealthGuarLoss()) %>
				</select>
			</td>
		</tr>
		<tr>
			<th><label for="detailHitchType">장애인</label></th>
			<td colspan="3">
				종별부호
				<select class="readOnly" id="detailHitchType" disabled >
					<option value =''>-----선택-----</option>
					<%= WebUtil.printOption((new E01HealthGuarHintchRFC()).getHealthGuarHintch()) %>
				</select>
				<span class="pl20">
					<label for="detailHitchGrade">등급</label>
					<input class="readOnly w30" type="text" id="detailHitchGrade" readOnly />
				</span>
				<span class="pl20">	
					<label for="detailHitchDate">등록일</label>
					<input class="readOnly datepicker w70" type="text" id="detailHitchDate" readOnly />
				</span>
			</td>
		</tr>
		</tbody>
		</table>
	</div>
	<div class="tableComment">
		<p><span class="bold">제출서류 : 호적등본, 주민등록등본, 건강보험증 각 1부</span></p>
		<p>(단, 사망의 경우 건강보험증, 사망진단서 또는 호적등본 1부)</p>
	</div>
</div>
<input type="hidden" id="detailAinfSeqn" />
<input type="hidden" id="detailAccqLossDate" />
<input type="hidden" id="detailAccqLossType" />
<input type="hidden" id="detailAccqLossText" />
<input type="hidden" id="detailApplText" />
<input type="hidden" id="detailHitchText" />
</form>
<div class="listArea">
	<h2 class="subtitle">신청 대상자</h2>
	<div class="buttonArea">
		<ul class="btn_mdl">
			<li><a href="#" id="detailListEditBtn" style="display:none;" ><span>수정</span></a></li>
			<li><a href="#" id="detailListDeletelistBtn" style="display:none;" ><span>삭제</span></a></li>
		</ul>
	</div>
	<div id="addGuaranteeGrid"></div>
</div>

<script type="text/javascript">
	var targetItem;
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getHealthInsuDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				$("#addGuaranteeGrid").jsGrid({
					autoload: true,
					controller : {
						loadData : function() {
							var d = $.Deferred();
							d.resolve(response.storeData);
							return d.promise();
						}
					}
				});
				
				($("input:radio[name='chk']")[0]).click();
				
				setDetail(response.storeData[0]);
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			$("#detailAinfSeqn").val(item.AINF_SEQN);
			$("#detailBegda").val(item.BEGDA);
			
			$("#detailEname").val(item.ENAME);
			$("#detailAccqLossDate").val(item.ACCQ_LOSS_DATE);
			$("#detailAccqLossType").val(item.ACCQ_LOSS_TYPE);
			$("#detailAccqLossText").val(item.ACCQ_LOSS_TEXT);
			$("#detailAprtCode").val(item.APRT_CODE);
			$("#detailHitchType").val(item.HITCH_TYPE); 
			$("#detailHitchText").val(item.HITCH_TEXT);
			$("#detailHitchGrade").val(item.HITCH_GRADE);
			$("#detailHitchDate").val(item.HITCH_DATE);
			$("#detailApplType").val(item.APPL_TYPE);
			
			
			$("#detailApplType").change();
			
			if(item.APPL_TYPE == "0001"){
				 $("#detailAccqDate").val(item.ACCQ_LOSS_DATE == "0000-00-00" ? "" : item.ACCQ_LOSS_DATE);
				 $("#detailAccqType").val(item.ACCQ_LOSS_TYPE);
			}
			if(item.APPL_TYPE == "0002"){
				 $("#detailLossDate").val(item.ACCQ_LOSS_DATE == "0000-00-00" ? "" : item.ACCQ_LOSS_DATE);
				 $("#detailLossType").val(item.ACCQ_LOSS_TYPE);
			}
			
			$("#detailHitchGrade").val(item.HITCH_GRADE == "00"  ? "" : item.HITCH_GRADE);
			
			if(item.APRT_CODE == "X") { $("#detailAprtCode").prop("checked", true); }else{ $("#detailAprtCode").prop("checked", false); }
		}
	}
	
	
	$(document).ready(function(){
		// 초기화
		detailSearch();
	});
	
	$("#detailApplType").change(function(){
		if($("#detailApplType").val()=="0001") {
			$("#healthLayer1").show();
			$("#detailAccqDate").attr("required","required");
			$("#detailAccqType").attr("required","required");
		} else {
			$("#healthLayer1").hide();
			
			$("#detailAccqDate").val("").attr("required",null);
			$("#detailAccqType").val("").attr("required",null);
		}
		
		if($("#detailApplType").val()=="0002") {
			$("#healthLayer2").show();
			$("#detailLossDate").attr("required","required");
			$("#detailLossType").attr("required","required");
		} else {
			$("#healthLayer2").hide();
			
			$("#detailLossDate").val("").attr("required",null);
			$("#detailLossType").val("").attr("required",null);
		}
		
	});
	
	// 신청 대상자 그리드
	$(function() {
		$("#addGuaranteeGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: false,
			fields: [
				{ title: "선택", type: "text", align: "center", width: "4%" 
					,itemTemplate: function(_, item) {
						return	$("<input name='chk' disabled >")
						.attr("type", "radio")
						.on("click",function(e){
							targetItem = item;
							
							$("#detailBegda").val(item.BEGDA)
							$("#detailEname").val(item.ENAME);
							if(item.APRT_CODE == "X") { $("#detailAprtCode").prop("checked", true); }else{ $("#detailAprtCode").prop("checked", false); }

							$("#detailApplType").val(item.APPL_TYPE);
							
							if( item.APPL_TYPE == "0001" ) { // 취득
								$("#detailAccqDate").val(item.ACCQ_LOSS_DATE);
								$("#detailAccqType").val(item.ACCQ_LOSS_TYPE);
							} else if( item.APPL_TYPE == "0002" ) { // 상실
								$("#detailLossDate").val(item.ACCQ_LOSS_DATE);
								$("#detailLossType").val(item.ACCQ_LOSS_TYPE);
							}
							
							$("#detailHitchType").val(item.HITCH_TYPE);
							$("#detailHitchGrade").val(item.HITCH_GRADE == "00" ? "" : item.HITCH_GRADE);
							$("#detailHitchDate").val(item.HITCH_DATE == "0000.00.00" ? "" : item.HITCH_DATE);
							$("#detailApplType").change();
							
						});
					}
				},
				{ title: "신청구분", name: "APPL_TEXT", type: "text", align: "center", width: "8%" },
				{ title: "대상자<br>성명", name: "ENAME", type: "text", align: "center", width: "8%" },
				{ title: "취득일자<br>/상실일자", name: "ACCQ_LOSS_DATE", type: "text", align: "center", width: "7%" },
				{ title: "취득사유<br>/상실사유", name: "ACCQ_LOSS_TEXT", type: "text", align: "center", width: "34%" },
				{ title: "원격지<br>발급여부", name: "APRT_CODE", type: "text", align: "center", width: "6%" },
				{ title: "장애인<br>종별부호", name: "HITCH_TEXT", type: "text", align: "center", width: "8%" },
				{ title: "장애인<br>등급", name: "HITCH_GRADE", type: "text", align: "center", width: "5%" 
					,itemTemplate: function(value, item) {
						return value == "00" ? "" : value;
					}
				},
				{ title: "장애인<br>등록일", name: "HITCH_DATE", type: "text", align: "center", width: "8%" 
					,itemTemplate: function(value, item) {
						return value == "0000.00.00" ? "" : value;
					}
				},
				{ name: "BEGDA", type: "text", visible: false },
				{ name: "APPL_TYPE", type: "text", visible: false },
				{ name: "ACCQ_LOSS_TYPE", type: "text", visible: false },
				{ name: "SUBTY", type: "text", visible: false },
				{ name: "OBJPS", type: "text", visible: false },
				{ name: "HITCH_TYPE", type: "text", visible: false }
			]
		});
	});
	
	
	// 건강보험 자격변경자 추가시 체크 사항
	var detailCheck = function(){
		if(!checkNullField("detailForm")){
			return false;
		}
		
		if( $("#detailHitchType").val() != "" ) {
			if( $("#detailHitchGrade").val() == "") {
				alert("장애 등급을 입력하세요");
				return false;
			}
			
			if( $("#detailHitchDate").val() == "") {
				alert("장애 등록일을 입력하세요");
				return false;
			}
			
		}
		
		return true;
	};
	
	// 그리드 명단 추가
	$("#addMemberBtn").click(function(){
		if(detailCheck()){
			
			if(targetItem == null){
				// 신청구분에 따른 값 설정
				if( $("#detailApplType").val()=="0001" ) { // 취득
					$("#detailAccqLossDate").val($("#detailAccqDate").val());
					$("#detailAccqLossType").val($("#detailAccqType").val());
					$("#detailAccqLossText").val($("#detailAccqType option:selected").text());
				} else if( $("#detailApplType").val()=="0002" ) { // 상실
					$("#detailAccqLossDate").val($("#detailLossDate").val());
					$("#detailAccqLossType").val($("#detailLossType").val());
					$("#detailAccqLossText").val($("#detailLossType option:selected").text());
				}
				
				//장애인 종별 부호에 따른 값 설정
				if( $("#detailHitchType").val() != "" ) {
					$("#detailHitchText").val( $("#detailHitchType option:selected").text() );
					$("#detailHitchDate").val( $("#detailHitchDate").val() );
				}
				
				//원격지발급여부 값 설정
				if($("#detailAprtCode").is(":checked")){
					$("#detailAprtCode").val("X");
				}else{
					$("#detailAprtCode").val("");
				}
				
				$("#addGuaranteeGrid").jsGrid(
						"insertItem" , {
							  "AINF_SEQN" : $("#detailAinfSeqn").val()
							, "BEGDA" : $("#detailBegda").val()
							, "APPL_TEXT" : $("#detailApplType option:selected").text()
							, "ENAME" : $("#detailEname option:selected").val()
							, "ACCQ_LOSS_DATE" : $("#detailAccqLossDate").val()
							, "ACCQ_LOSS_TYPE" : $("#detailAccqLossType").val()
							, "ACCQ_LOSS_TEXT" : $("#detailAccqLossText").val()
							, "APRT_CODE" : $("#detailAprtCode").val()
							, "HITCH_TYPE" : $("#detailHitchType").val() 
							, "HITCH_TEXT" : $("#detailHitchText").val()
							, "HITCH_GRADE" : $("#detailHitchGrade").val()
							, "HITCH_DATE" : $("#detailHitchDate").val()
							, "APPL_TYPE" : $("#detailApplType").val()
							, "SUBTY" : $("#detailEname option:selected").attr("SUBTY")
							, "OBJPS" : $("#detailEname option:selected").attr("OBJPS")
						}
				).done(function(){
					
					$("#detailEname").val("");
					$("#detailAccqDate").val("");
					$("#detailAccqType").val("");
					$("#detailLossDate").val("");
					$("#detailLossType").val("");
					$("#detailAccqLossDate").val("");
					$("#detailAccqLossType").val("");
					$("#detailAccqLossText").val("");
					$("#detailAprtCode").val("").prop("checked",false);
					$("#detailHitchType").val(""); 
					$("#detailHitchText").val("");
					$("#detailHitchGrade").val("");
					$("#detailHitchDate").val("");
					$("#detailApplType").val("");
					
					$("#healthLayer1").hide();
					$("#healthLayer2").hide();
					
					$("input:radio[name='chk']").prop("disabled",false);
					targetItem = null;
				});
			}else{
				 alert("상세 조회 중입니다.\n추가 하시려면 취소버튼을 눌러 입력창을 초기화 해 주세요.");
			}
		}
	});
	
	// 신청 입력창 초기화
	$("#clearBtn").click(function(){
		
		$("#detailEname").val("");
		$("#detailAccqDate").val("");
		$("#detailAccqType").val("");
		$("#detailLossDate").val("");
		$("#detailLossType").val("");
		$("#detailAccqLossDate").val("");
		$("#detailAccqLossType").val("");
		$("#detailAccqLossText").val("");
		$("#detailAprtCode").val("").prop("checked",false);
		$("#detailHitchType").val(""); 
		$("#detailHitchText").val("");
		$("#detailHitchGrade").val("");
		$("#detailHitchDate").val("");
		$("#detailApplType").val("");
		
		$("#healthLayer1").hide();
		$("#healthLayer2").hide();
		
		
		targetItem = null;
	});
	
	$("#detailListEditBtn").click(function(){
		if(targetItem == null){
			alert("변경 대상이 없습니다");
		}else{
			// 신청구분에 따른 값 설정
			if( $("#detailApplType").val()=="0001" ) { // 취득
				$("#detailAccqLossDate").val($("#detailAccqDate").val());
				$("#detailAccqLossType").val($("#detailAccqType").val());
				$("#detailAccqLossText").val($("#detailAccqType option:selected").text());
			} else if( $("#detailApplType").val()=="0002" ) { // 상실
				$("#detailAccqLossDate").val($("#detailLossDate").val());
				$("#detailAccqLossType").val($("#detailLossType").val());
				$("#detailAccqLossText").val($("#detailLossType option:selected").text());
			}
			
			//장애인 종별 부호에 따른 값 설정
			if( $("#detailHitchType").val() != "" ) {
				$("#detailHitchText").val( $("#detailHitchType option:selected").text() );
				$("#detailHitchDate").val( $("#detailHitchDate").val() );
			}
			
			//원격지발급여부 값 설정
			if($("#detailAprtCode").is(":checked")){
				$("#detailAprtCode").val("X");
			}else{
				$("#detailAprtCode").val("");
			}
			
			$("#addGuaranteeGrid").jsGrid(
					"updateItem" 
					, targetItem
					, {
						"APPL_TEXT" : $("#detailApplType option:selected").text(),
						"ENAME" : $("#detailEname option:selected").val(),
						"ACCQ_LOSS_DATE" : $("#detailAccqLossDate").val(),
						"ACCQ_LOSS_TYPE" : $("#detailAccqLossType").val(),
						"ACCQ_LOSS_TEXT" : $("#detailAccqLossText").val(),
						"APRT_CODE" : $("#detailAprtCode").val(),
						"HITCH_TYPE" : $("#detailHitchType").val(), 
						"HITCH_TEXT" : $("#detailHitchText").val(),
						"HITCH_GRADE" : $("#detailHitchGrade").val(),
						"HITCH_DATE" : $("#detailHitchDate").val(),
						"APPL_TYPE" : $("#detailApplType").val(),
						"SUBTY" : $("#detailEname option:selected").attr("SUBTY"),
						"OBJPS" : $("#detailEname option:selected").attr("OBJPS")
					}
			).done(function(){
				$("#detailEname").val("");
				$("#detailAccqDate").val("");
				$("#detailAccqType").val("");
				$("#detailLossDate").val("");
				$("#detailLossType").val("");
				$("#detailAccqLossDate").val("");
				$("#detailAccqLossType").val("");
				$("#detailAccqLossText").val("");
				$("#detailAprtCode").val("").prop("checked",false);
				$("#detailHitchType").val(""); 
				$("#detailHitchText").val("");
				$("#detailHitchGrade").val("");
				$("#detailHitchDate").val("");
				$("#detailApplType").val("");
				
				$("#healthLayer1").hide();
				$("#healthLayer2").hide();
				
				targetItem = null;
				$("input:radio[name='chk']").prop("disabled",false);
			});
		}
	});
	
	$("#detailListDeletelistBtn").click(function(){
		if(targetItem == null){
			alert("삭제 대상이 없습니다");
		}else{
			$("#addGuaranteeGrid").jsGrid(
					"deleteItem"
					,targetItem
			).done(function(){
				$("#detailForm").each(function(){
					this.reset();
				});
				targetItem = null;
			});
		}
		
	});
	
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		$("#detailEname").val("");
		$("#detailAccqDate").val("");
		$("#detailAccqType").val("");
		$("#detailLossDate").val("");
		$("#detailLossType").val("");
		$("#detailAccqLossDate").val("");
		$("#detailAccqLossType").val("");
		$("#detailAccqLossText").val("");
		$("#detailAprtCode").val("").prop("checked",false);
		$("#detailHitchType").val(""); 
		$("#detailHitchText").val("");
		$("#detailHitchGrade").val("");
		$("#detailHitchDate").val("");
		$("#detailApplType").val("");
		
		$("#healthLayer1").hide();
		$("#healthLayer2").hide();
		
		targetItem = null;
		
		$("#detailApplType").removeClass("readOnly").prop("disabled",false);
		$("#detailEname").removeClass("readOnly").prop("disabled",false);
		$("#detailAprtCode").removeClass("readOnly").prop("disabled",false);
		$("#detailAccqDate").removeClass("readOnly").prop("readOnly",false);
		$("#detailAccqType").removeClass("readOnly").prop("disabled",false);
		$("#detailLossDate").removeClass("readOnly").prop("readOnly",false);
		$("#detailLossType").removeClass("readOnly").prop("disabled",false);
		$("#detailHitchType").removeClass("readOnly").prop("disabled",false);
		$("#detailHitchGrade").removeClass("readOnly").prop("readOnly",false);
		$("#detailHitchDate").removeClass("readOnly").prop("readOnly",false);
		
		$("#addMemberBtn").show();
		$("#clearBtn").show();
		$("#detailListEditBtn").show();
		$("#detailListDeletelistBtn").show();
		
		$("#detailAccqDate").datepicker();
		$("#detailLossDate").datepicker();
		$("#detailHitchDate").datepicker();
		
		$("input:radio[name='chk']").prop("disabled",false);
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
			$("#addGuaranteeGrid").jsGrid("serialize", param);
			$("#detailDecisioner").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteHealthInsu',
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
		$("#addGuaranteeGrid").jsGrid({"data":$.noop});
		
		$("#detailEname").val("");
		$("#detailAccqDate").val("");
		$("#detailAccqType").val("");
		$("#detailLossDate").val("");
		$("#detailLossType").val("");
		$("#detailAccqLossDate").val("");
		$("#detailAccqLossType").val("");
		$("#detailAccqLossText").val("");
		$("#detailAprtCode").val("").prop("checked",false);
		$("#detailHitchType").val(""); 
		$("#detailHitchText").val("");
		$("#detailHitchGrade").val("");
		$("#detailHitchDate").val("");
		$("#detailApplType").val("");
		
		detailSearch();
		
		$("#detailApplType").addClass("readOnly").prop("disabled",true);
		$("#detailEname").addClass("readOnly").prop("disabled",true);
		$("#detailAprtCode").addClass("readOnly").prop("disabled",true);
		$("#detailAccqDate").addClass("readOnly").prop("readOnly",true);
		$("#detailAccqType").addClass("readOnly").prop("disabled",true);
		$("#detailLossDate").addClass("readOnly").prop("readOnly",true);
		$("#detailLossType").addClass("readOnly").prop("disabled",true);
		$("#detailHitchType").addClass("readOnly").prop("disabled",true);
		$("#detailHitchGrade").addClass("readOnly").prop("readOnly",true);
		$("#detailHitchDate").addClass("readOnly").prop("readOnly",true);
		
		$("input:radio[name='chk']").prop("disabled",true);
		
		$("#addMemberBtn").hide();
		$("#clearBtn").hide();
		$("#detailListEditBtn").hide();
		$("#detailListDeletelistBtn").hide();
		destroydatepicker("detailForm");
		
	}
	
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if( $("#addGuaranteeGrid").jsGrid("dataCount") < 1 ) {
			alert("신청할 데이터가 저장되지 않았습니다.");
			return;
		}
		
		if( $("#detailDecisioner").jsGrid("dataCount") < 1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(confirm("저장하시겠습니까?")) {
			$("#reqSaveBtn").prop("disabled", true);
			$("#detailAinfSeqn").val('${AINF_SEQN}');
			
			//var param = $("#detailForm").serializeArray();
			var param = [];
			$("#addGuaranteeGrid").jsGrid("serialize", param);
			$("#detailDecisioner").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'post',
				url : '/appl/updateHealthInsu',
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