<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E01Medicare.rfc.E01HealthGuarReqsRFC"%>
<%@ page import="hris.E.E01Medicare.rfc.E01HealthGuarAccqRFC"%>
<%@ page import="hris.E.E01Medicare.rfc.E01HealthGuarLossRFC"%>
<%@ page import="hris.E.E01Medicare.rfc.E01HealthGuarHintchRFC"%>
<%@ page import="hris.E.E01Medicare.rfc.E01TargetNameRFC"%>
<%@ page import="hris.E.E01Medicare.E01TargetNameData"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareREQRFC"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareTargetNameRFC"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareEnrollRFC"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareIssueRFC"%>
<%@ page import="hris.E.E02Medicare.rfc.E02MedicareReIssueRFC"%>
<%@ page import="hris.E.E02Medicare.E02MedicareNameData"%>
<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
%>
<!--// Page Title start -->
<div class="title">
	<h1>건강보험</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">건강보험</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">건강보험 자격변경 신청</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">건강보험 정보변경 신청</a></li>
		<li><a href="#" id="tab3" onclick="switchTabs(this, 'tab3');">건강보험내역</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
	<!--// Table start -->
	<form id="requestHealthInsuranceForm">
	<div class="tableArea">
		<h2 class="subtitle withButtons">건강보험 자격변경 신청</h2>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a href="#" id="addMemberBtn" class="darken" ><span>추가</span></a></li>
				<li><a href="#" id="clearBtn" ><span>취소</span></a></li>
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
				<th><label for="requestHealthInsuranceBegda">신청일</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" id="requestHealthInsuranceBegda" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>" readonly />
				</td>
			</tr>
			<!-- 신청구분 셀렉트 옵션에 따라 tr id="healthLayer1" 또는 tr id="healthLayer2" display -->
			<tr>
				<th><span class="textPink">*</span><label for="requestHealthInsuranceApplType">신청구분</label></th>
				<td colspan="3">
					<select id="requestHealthInsuranceApplType" vname="신청구분" required >
						<option value =''>------선택------</option>
						<%= WebUtil.printOption((new E01HealthGuarReqsRFC()).getHealthGuarReqs()) %>
					</select>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestHealthInsuranceEname">대상자 성명</label></th>
				<td>
					<select id="requestHealthInsuranceEname" vname="대상자 성명" required> 
						<option value =''>------선택------</option>
<%
					Vector e01TargetNameData_vt =  (new E01TargetNameRFC()).getTargetName(userData.empNo);
					for ( int i = 0 ; i < e01TargetNameData_vt.size() ; i++ ) {
						E01TargetNameData data_name = (E01TargetNameData)e01TargetNameData_vt.get(i);
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
				<th><label for="requestHealthInsuranceAprtCode">원격지발급여부</label></th>
				<td>
					<input type="checkbox" id="requestHealthInsuranceAprtCode" >
				</td>
			</tr>
			<tr id="healthLayer1" style="display:none;">
				<th><span class="textPink">*</span><label for="requestHealthInsuranceAccqDate">취득일자</label></th>
				<td>
					<input class="datepicker w80" type="text" id="requestHealthInsuranceAccqDate" vname="취득일자" />
				</td>
				<th><span class="textPink">*</span><label for="requestHealthInsuranceAccqType">취득사유</label></th>
				<td>
					<select id="requestHealthInsuranceAccqType" vname="취득사유"> 
						<option value =''>-------------------선택-------------------</option>
						<%= WebUtil.printOption((new E01HealthGuarAccqRFC()).getHealthGuarAccq()) %>
					</select>
				</td>
			</tr>
			<tr id="healthLayer2" style="display:none;">
				<th><span class="textPink">*</span><label for="requestHealthInsuranceLossDate">상실일자</label></th>
				<td>
					<input class="datepicker w80" type="text" id="requestHealthInsuranceLossDate" vname="상실일자"/>
				</td>
				<th><span class="textPink">*</span><label for="requestHealthInsuranceLossType">상실사유</label></th>
				<td>
					<select id="requestHealthInsuranceLossType" vname="상실사유" > 
						<option value =''>-------------------선택-------------------</option>
						<%= WebUtil.printOption((new E01HealthGuarLossRFC()).getHealthGuarLoss()) %>
					</select>
				</td>
			</tr>
			<tr>
				<th><label for="requestHealthInsuranceHitchType">장애인</label></th>
				<td colspan="3">
					종별부호
					<select id="requestHealthInsuranceHitchType" >
						<option value =''>-----선택-----</option>
						<%= WebUtil.printOption((new E01HealthGuarHintchRFC()).getHealthGuarHintch()) %>
					</select>
					<span class="pl20">
						<label for="requestHealthInsuranceHitchGrade">등급</label>
						<input class="w30" type="text" id="requestHealthInsuranceHitchGrade"  />
					</span>
					<span class="pl20">	
						<label for="requestHealthInsuranceHitchDate">등록일</label>
						<input class="datepicker w70" type="text" id="requestHealthInsuranceHitchDate" />
					</span>
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">제출서류 : 가족관계증명서, 주민등록등본, 건강보험증 각 1부</span></p>
			<p>(단, 사망의 경우 건강보험증, 사망진단서 또는 가족관계증명서 1부)</p>
		</div>
	</div>
	<input type="hidden" id="tab1RowCount" name="RowCount">
	<input type="hidden" id="requestHealthInsuranceAccqLossDate" name="ACCQ_LOSS_DATE" />
	<input type="hidden" id="requestHealthInsuranceAccqLossType" name="ACCQ_LOSS_TYPE" />
	<input type="hidden" id="requestHealthInsuranceAccqLossText" name="ACCQ_LOSS_TEXT" />
	<input type="hidden" id="requestHealthInsuranceApplText" name="APPL_TEXT" />
	<input type="hidden" id="requestHealthInsuranceHitchText" name="HITCH_TEXT" />
	</form>
	<div class="listArea">
		<h2 class="subtitle">신청 대상자</h2>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a href="#" id="requestListEditBtn" ><span>수정</span></a></li>
				<li><a href="#" id="requestListDeletelistBtn" ><span>삭제</span></a></li>
			</ul>
		</div>
		<div id="addGuaranteeGrid"></div>
	</div>
	<!--// Table end -->
	<!--// list start -->
	<div class="listArea" id="decisionerTab1">
	</div>
	<!--// list end -->
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="#" id="requestHealthInsuranceBtn" class="darken" ><span>신청</span></a></li>
		</ul>
	</div>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<!--// Table start -->
	<form id="updateHealthInsuranceForm">
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
				<th><label for="updateHealthInsuranceBegda">신청일</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" id="updateHealthInsuranceBegda" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>" readonly />
				</td>
			</tr>
			<!-- 신청구분 셀렉트 옵션에 따라 div id="healthModifyLayer1~3" display -->
			<tr>
				<th><span class="textPink">*</span><label for="updateHealthInsuranceApplType2">신청구분</label></th>
				<td>
					<select id="updateHealthInsuranceApplType2" name="APPL_TYPE2" onchange="healthModifySelectChange()" vname="신청구분" required >
						<option value =''>-------선택-------</option>
						<%= WebUtil.printOption((new E02MedicareREQRFC()).getRequest()) %>
					</select>
				</td>
				<th><span class="textPink">*</span><label for="updateHealthInsuranceEname">대상자 성명</label></th>
				<td>
					<select id="updateHealthInsuranceEname" name="ENAME" vname="대상자 성명" required >
						<option value =''>-------선택-------</option>
						<option value="<%= userData.ename %>" ><%= userData.ename %></option>
<%
					Vector tergetName_vt = (new E02MedicareTargetNameRFC()).getName(userData.empNo);
					for(int i = 0 ; i < tergetName_vt.size() ; i++){
						E02MedicareNameData data = (E02MedicareNameData)tergetName_vt.get(i);
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
				<th><span class="textPink">*</span><label for="updateHealthInsuranceApplType3">변경항목</label></th>
				<td colspan="3">
					<select id="updateHealthInsuranceApplType3" name="APPL_TYPE3" vname="변경항목">
						<option value =''>-------선택-------</option>
						<%= WebUtil.printOption((new E02MedicareEnrollRFC()).getEnroll()) %>
					</select>
					<input class="w120" type="text" id="updateHealthInsuranceEtcText3" name="ETC_TEXT3" onKeyUp="check_length(this,60)" //>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="updateHealthInsuranceChngBefore">변경전Data</label></th>
				<td>
					<input class="w150" type="text" id="updateHealthInsuranceChngBefore" name="CHNG_BEFORE" onKeyUp="check_length(this,60)" vname="변경전Data"/>
				</td>
				<th><span class="textPink">*</span><label for="updateHealthInsuranceChngAfter">변경후Data</label></th>
				<td>
					<input class="w150" type="text" id="updateHealthInsuranceChngAfter" name="CHNG_AFTER" onKeyUp="check_length(this,60)" vname="변경후Data"/>
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
				<th><span class="textPink">*</span><label for="updateHealthInsuranceApplType4">발급사유</label></th>
				<td>
					<select id="updateHealthInsuranceApplType4" name="APPL_TYPE4">
						<option value =''>-------선택-------</option>
						<%= WebUtil.printOption((new E02MedicareIssueRFC()).getIssue()) %>
					</select>
					<input class="w60" type="text" id="updateHealthInsuranceEtcText4" name="ETC_TEXT4" onKeyUp="check_length(this,60)" vname="발급사유"/> 
				</td>
				<th><span class="textPink">*</span><label for="updateHealthInsuranceAddNum">발행부수</label></th>
				<td>
					<input class="w2" type="text" id="updateHealthInsuranceAddNum" name="ADD_NUM" maxlength="3" vname="발햏부수"/>
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
				<th><span class="textPink">*</span><label for="updateHealthInsuranceApplType5">신청사유</label></th>
				<td>
					<select id="updateHealthInsuranceApplType5" name="APPL_TYPE5" vname="신청사유">
						<option value =''>-------선택-------</option>
						<%= WebUtil.printOption( (new E02MedicareReIssueRFC()).getReIssue() ) %>
					</select>
					<input class="w6" type="text" id="updateHealthInsuranceEtcText5" name="ETC_TEXT5" onKeyUp="check_length(this,60)" /> 
				</td>
				<th><label for="updateHealthInsuranceAddNum1">발행부수</label></th>
				<td>
					<input class="w60" type="text" id="updateHealthInsuranceAddNum1" name="ADD_NUM1" />
				</td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>
	<input type="hidden" id="tab2RowCount" name="RowCount">
	<input type="hidden" id="updateHealthInsuranceSubty" name="SUBTY" />
	<input type="hidden" id="updateHealthInsuranceObjps" name="OBJPS" />
	</form>
	<!--// Table end -->
	<!--// list start -->
	<div class="listArea" id="decisionerTab2">
	</div>
	<!--// list end -->
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="#" id="updateHealthInsuranceBtn" class="darken" ><span>신청</span></a></li>
		</ul>
	</div>
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle">건강보험내역</h2>
		<div id="healthInsuranceGrid1"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
	</div>
	<!--// list end -->
	<!--// list start -->
	<div class="tableArea">
		<h2 class="subtitle">대상정보</h2>	
		<div id="healthInsuranceGrid2"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
	</div>
	<!--// list end -->
	<!--// list start -->
	<div class="tableArea">
		<h2 class="subtitle">피보험 대상자</h2>	
		<div id="healthInsuranceGrid3"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
	</div>
	<!--// list end -->
</div>
<!--// Tab3 end -->

<script type="text/javascript">
	var targetItem;
	$(document).ready(function(){
		$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=20&gridDivId=tab1ApplGrid');
		$("#tab1RowCount").val($("#tab1ApplGrid").jsGrid("dataCount"));
		
		$("#tab1").click(function(){
			$("#requestHealthInsuranceForm").each(function(){
				this.reset();
			});
			
			$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=20&gridDivId=tab1ApplGrid');
			$("#tab1RowCount").val($("#tab1ApplGrid").jsGrid("dataCount"));
		});
		
		$("#tab2").click(function(){
			$("#updateHealthInsuranceForm").each(function(){
				this.reset();
			});
			$("#updateHealthInsuranceEtcText3").hide();
			$("#updateHealthInsuranceEtcText4").hide();
			$("#updateHealthInsuranceEtcText5").hide();
			$("#healthModifyLayer1").hide();
			$("#healthModifyLayer2").hide();
			$("#healthModifyLayer3").hide();
			
			$('#decisionerTab2').load('/common/getDecisionerGrid?upmuType=21&gridDivId=tab2ApplGrid');
			$("#tab2RowCount").val($("#tab2ApplGrid").jsGrid("dataCount"));
		});
		
		$("#tab3").click(function(){
			// 그리드 초기화
			$("#healthInsuranceGrid1").jsGrid({data: []});
			$("#healthInsuranceGrid2").jsGrid({data: []});
			$("#healthInsuranceGrid3").jsGrid({data: []});
			
			jQuery.ajax({
				type : 'POST',
				url : '/supp/healthInsuranceList.json',
				cache : false,
				dataType : 'json',
				async :false,
				success : function(response) {
					if(response.success){
						
						$.each(response.e30Health01_vt, function (key, value) {
							$("#healthInsuranceGrid1").jsGrid(
									"insertItem" , {  "LNMHG": value.LNMHG
													, "FNMHG": value.FNMHG
													, "REGNO": value.REGNO
													, "GRADE": tranGrade(value.GRADE)
													, "BEGDA": value.BEGDA }
							);
						});
						
						$("#healthInsuranceGrid2").jsGrid(
							"insertItem" , {  "E_MINUM": response.E_MINUM
											, "E_MICNR": response.E_MICNR }
						);
						
						$.each(response.e30Health02_vt, function (key, value) {
							$("#healthInsuranceGrid3").jsGrid(
									"insertItem" , {  "STEXT": value.STEXT
													, "LNMHG": value.LNMHG
													, "FNMHG": value.FNMHG
													, "REGNO": value.REGNO }
							);
						});
					}else{
						alert("조회시 오류가 발생하였습니다. " + response.message);
					}
				}
			});
			
		});
	});
	
	function tranGrade(val){
		val = (val*1)+"등급";
		return val;
	}
	
	// 신청 입력창 초기화
	$("#clearBtn").click(function(){
		$("#requestHealthInsuranceForm").each(function(){
			this.reset();
		});
		targetItem = null;
	});
	
	//건강보험 자격변경 신청 > 신청구분 selcet > 자격취득(health001)/자격상실(health002)
	$("#requestHealthInsuranceApplType").change(function(){
		
		if($("#requestHealthInsuranceApplType").val()=="0001") {
			$("#healthLayer1").show();
			$("#requestHealthInsuranceAccqDate").attr("required","required");
			$("#requestHealthInsuranceAccqType").attr("required","required");
		} else {
			$("#healthLayer1").hide();
			
			$("#requestHealthInsuranceAccqDate").val("").attr("required",null);
			$("#requestHealthInsuranceAccqType").val("").attr("required",null);
		}
		
		if($("#requestHealthInsuranceApplType").val()=="0002") {
			$("#healthLayer2").show();
			$("#requestHealthInsuranceLossDate").attr("required","required");
			$("#requestHealthInsuranceLossType").attr("required","required");
		} else {
			$("#healthLayer2").hide();
			
			$("#requestHealthInsuranceLossDate").val("").attr("required",null);
			$("#requestHealthInsuranceLossType").val("").attr("required",null);
		}
		
	});
	
	
	$("#requestHealthInsuranceHitchType").change(function(){
		if($("#requestHealthInsuranceHitchType option:selected").val() == ""){
			$("#requestHealthInsuranceHitchGrade").val("");
			$("#requestHealthInsuranceHitchDate").val("");
			$("#requestHealthInsuranceHitchText").val("");
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
						return	$("<input name='chk'>")
						.attr("type", "radio")
						.on("click",function(e){
							targetItem = item;
							
							$("#requestHealthInsuranceEname").val(item.ENAME);
							if(item.APRT_CODE == "X") { $("#requestHealthInsuranceAprtCode").prop("checked", true); }else{ $("#requestHealthInsuranceAprtCode").prop("checked", false); }

							$("#requestHealthInsuranceApplType").val(item.APPL_TYPE);
							
							if( item.APPL_TYPE == "0001" ) { // 취득
								$("#requestHealthInsuranceAccqDate").val(item.ACCQ_LOSS_DATE);
								$("#requestHealthInsuranceAccqType").val(item.ACCQ_LOSS_TYPE);
							} else if( item.APPL_TYPE == "0002" ) { // 상실
								$("#requestHealthInsuranceLossDate").val(item.ACCQ_LOSS_DATE);
								$("#requestHealthInsuranceLossType").val(item.ACCQ_LOSS_TYPE);
							}
							
							$("#requestHealthInsuranceHitchType").val(item.HITCH_TYPE);
							$("#requestHealthInsuranceHitchGrade").val(item.HITCH_GRADE);
							$("#requestHealthInsuranceHitchDate").val(item.HITCH_DATE);
							
						});
					}
				},
				{ title: "신청구분", name: "APPL_TEXT", type: "text", align: "center", width: "8%" },
				{ title: "대상자<br>성명", name: "ENAME", type: "text", align: "center", width: "8%" },
				{ title: "취득일자<br>/상실일자", name: "ACCQ_LOSS_DATE", type: "text", align: "center", width: "7%" },
				{ title: "취득사유<br>/상실사유", name: "ACCQ_LOSS_TEXT", type: "text", align: "center", width: "34%" },
				{ title: "원격지<br>발급여부", name: "APRT_CODE", type: "text", align: "center", width: "6%" },
				{ title: "장애인<br>종별부호", name: "HITCH_TEXT", type: "text", align: "center", width: "8%" },
				{ title: "장애인<br>등급", name: "HITCH_GRADE", type: "text", align: "center", width: "5%" },
				{ title: "장애인<br>등록일", name: "HITCH_DATE", type: "text", align: "center", width: "8%" },
				{ name: "APPL_TYPE", type: "text", visible: false },
				{ name: "ACCQ_LOSS_TYPE", type: "text", visible: false },
				{ name: "SUBTY", type: "text", visible: false },
				{ name: "OBJPS", type: "text", visible: false },
				{ name: "HITCH_TYPE", type: "text", visible: false }
			]
		});
	});
	
	// 그리드 명단 추가
	$("#addMemberBtn").click(function(){
		if(requestHealthInsuranceCheck()){
			
			if(targetItem == null){
				// 신청구분에 따른 값 설정
				if( $("#requestHealthInsuranceApplType").val()=="0001" ) { // 취득
					$("#requestHealthInsuranceAccqLossDate").val($("#requestHealthInsuranceAccqDate").val());
					$("#requestHealthInsuranceAccqLossType").val($("#requestHealthInsuranceAccqType").val());
					$("#requestHealthInsuranceAccqLossText").val($("#requestHealthInsuranceAccqType option:selected").text());
				} else if( $("#requestHealthInsuranceApplType").val()=="0002" ) { // 상실
					$("#requestHealthInsuranceAccqLossDate").val($("#requestHealthInsuranceLossDate").val());
					$("#requestHealthInsuranceAccqLossType").val($("#requestHealthInsuranceLossType").val());
					$("#requestHealthInsuranceAccqLossText").val($("#requestHealthInsuranceLossType option:selected").text());
				}
				
				//장애인 종별 부호에 따른 값 설정
				if( $("#requestHealthInsuranceHitchType").val() != "" ) {
					$("#requestHealthInsuranceHitchText").val( $("#requestHealthInsuranceHitchType option:selected").text() );
					$("#requestHealthInsuranceHitchDate").val( $("#requestHealthInsuranceHitchDate").val() );
				}
				
				//원격지발급여부 값 설정
				if($("#requestHealthInsuranceAprtCode").is(":checked")){
					$("#requestHealthInsuranceAprtCode").val("X");
				}else{
					$("#requestHealthInsuranceAprtCode").val("");
				}
				
				$("#addGuaranteeGrid").jsGrid(
						"insertItem" , {
							  "APPL_TEXT" : $("#requestHealthInsuranceApplType option:selected").text()
							, "ENAME" : $("#requestHealthInsuranceEname option:selected").val()
							, "ACCQ_LOSS_DATE" : $("#requestHealthInsuranceAccqLossDate").val()
							, "ACCQ_LOSS_TYPE" : $("#requestHealthInsuranceAccqLossType").val()
							, "ACCQ_LOSS_TEXT" : $("#requestHealthInsuranceAccqLossText").val()
							, "APRT_CODE" : $("#requestHealthInsuranceAprtCode").val()
							, "HITCH_TYPE" : $("#requestHealthInsuranceHitchType").val() 
							, "HITCH_TEXT" : $("#requestHealthInsuranceHitchText").val()
							, "HITCH_GRADE" : $("#requestHealthInsuranceHitchGrade").val()
							, "HITCH_DATE" : $("#requestHealthInsuranceHitchDate").val()
							, "APPL_TYPE" : $("#requestHealthInsuranceApplType").val()
							, "SUBTY" : $("#requestHealthInsuranceEname option:selected").attr("SUBTY")
							, "OBJPS" : $("#requestHealthInsuranceEname option:selected").attr("OBJPS")
						}
				).done(function(){
					$("#requestHealthInsuranceForm").each(function(){
						this.reset();
					});
					targetItem = null;
				});
			}else{
				 alert("상세 조회 중입니다.\n추가 하시려면 취소버튼을 눌러 입력창을 초기화 해 주세요.");
			}
		}
	});
	
	$("#requestListEditBtn").click(function(){
		if(targetItem == null){
			alert("변경 대상이 없습니다");
		}else{
			if( $("#requestHealthInsuranceApplType").val()=="0001" ) { // 취득
				$("#requestHealthInsuranceAccqLossDate").val($("#requestHealthInsuranceAccqDate").val());
				$("#requestHealthInsuranceAccqLossType").val($("#requestHealthInsuranceAccqType").val());
				$("#requestHealthInsuranceAccqLossText").val($("#requestHealthInsuranceAccqType option:selected").text());
			} else if( $("#requestHealthInsuranceApplType").val()=="0002" ) { // 상실
				$("#requestHealthInsuranceAccqLossDate").val($("#requestHealthInsuranceLossDate").val());
				$("#requestHealthInsuranceAccqLossType").val($("#requestHealthInsuranceLossType").val());
				$("#requestHealthInsuranceAccqLossText").val($("#requestHealthInsuranceLossType option:selected").text());
			}
			
			//장애인 종별 부호에 따른 값 설정
			if( $("#requestHealthInsuranceHitchType").val() != "" ) {
				$("#requestHealthInsuranceHitchText").val( $("#requestHealthInsuranceHitchType option:selected").text() );
				$("#requestHealthInsuranceHitchDate").val( $("#requestHealthInsuranceHitchDate").val() );
			}
			
			//원격지발급여부 값 설정
			if($("#requestHealthInsuranceAprtCode").is(":checked")){
				$("#requestHealthInsuranceAprtCode").val("X");
			}else{
				$("#requestHealthInsuranceAprtCode").val("");
			}
			$("#addGuaranteeGrid").jsGrid(
					"updateItem" 
					, targetItem
					, {
						"APPL_TEXT" : $("#requestHealthInsuranceApplType option:selected").text(),
						"ENAME" : $("#requestHealthInsuranceEname option:selected").val(),
						"ACCQ_LOSS_DATE" : $("#requestHealthInsuranceAccqLossDate").val(),
						"ACCQ_LOSS_TYPE" : $("#requestHealthInsuranceAccqLossType").val(),
						"ACCQ_LOSS_TEXT" : $("#requestHealthInsuranceAccqLossText").val(),
						"APRT_CODE" : $("#requestHealthInsuranceAprtCode").val(),
						"HITCH_TYPE" : $("#requestHealthInsuranceHitchType").val(), 
						"HITCH_TEXT" : $("#requestHealthInsuranceHitchText").val(),
						"HITCH_GRADE" : $("#requestHealthInsuranceHitchGrade").val(),
						"HITCH_DATE" : $("#requestHealthInsuranceHitchDate").val(),
						"APPL_TYPE" : $("#requestHealthInsuranceApplType").val(),
						"SUBTY" : $("#requestHealthInsuranceEname option:selected").attr("SUBTY"),
						"OBJPS" : $("#requestHealthInsuranceEname option:selected").attr("OBJPS")
					}
			).done(function(){
				$("#requestHealthInsuranceForm").each(function(){
					this.reset();
				});
				targetItem = null;
			});
		}
	});
	
	$("#requestListDeletelistBtn").click(function(){
		if(targetItem == null){
			alert("삭제 대상이 없습니다");
		}else{
			$("#addGuaranteeGrid").jsGrid(
					"deleteItem"
					,targetItem
			).done(function(){
				$("#requestHealthInsuranceForm").each(function(){
					this.reset();
				});
				targetItem = null;
			});
		}
		
	});

	
	// 건강보험 자격변경자 추가시 체크 사항
	var requestHealthInsuranceCheck = function(){
		if(!checkNullField("requestHealthInsuranceForm")){
			return false;
		}
		
		if( $("#requestHealthInsuranceHitchType").val() != "" ) {
			if( $("#requestHealthInsuranceHitchGrade").val() == "") {
				alert("장애 등급을 입력하세요");
				return false;
			}
			
			if( $("#requestHealthInsuranceHitchDate").val() == "") {
				alert("장애 등록일을 입력하세요");
				return false;
			}
			
		}
		
		return true;
	};
	
	// 건강보험 피부양자 자격 신청 버튼 클릭
	$("#requestHealthInsuranceBtn").click(function(){
		if( $("#addGuaranteeGrid").jsGrid("dataCount") < 1 ) {
			alert("신청할 데이터가 저장되지 않았습니다.");
			return;
		}
		
// 		if( $("#tab1ApplGrid").jsGrid("dataCount") < 1 ) {
// 			alert("결재자 정보가 없습니다.");
// 			return;
// 		}
		if(confirm("신청 하시겠습니까?")){
			$("#requestHealthInsuranceBtn").prop("disabled", true);
			
// 			var param = [];
			var param = $("#requestHealthInsuranceForm").serializeArray();
			$("#addGuaranteeGrid").jsGrid("serialize", param);
			$("#tab1ApplGrid").jsGrid("serialize", param);
			
			jQuery.ajax({
				type : 'POST',
				url : '/supp/requestHealthInsuranceChange.json',
				cache : false,
				dataType : 'json',
				data : param,
				async :false,
				success : function(response) {
					if(response.success){
						alert("신청 되었습니다.");
					}else{
						alert("신청시 오류가 발생하였습니다. " + response.message);
					}
					$("#requestHealthInsuranceBtn").prop("disabled", false);
				}
			});
		}
	});
	
	
	// 건강보험 정보변경 신청 버튼 클릭
	$("#updateHealthInsuranceBtn").click(function(){
		if(updateHealthInsuranceCheck()){
			if(confirm("신청 하시겠습니까?")){
				$("#updateHealthInsuranceBtn").prop("disabled", true);
				
				$("#tab2RowCount").val($("#tab2ApplGrid").jsGrid("dataCount"));
				var param = $("#updateHealthInsuranceForm").serializeArray();
				$("#tab2ApplGrid").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestHealthInsuranceInfoChange.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							$("#updateHealthInsuranceForm").each(function(){
								this.reset();
							});
							$("#updateHealthInsuranceEtcText3").hide();
							$("#updateHealthInsuranceEtcText4").hide();
							$("#updateHealthInsuranceEtcText5").hide();
							$("#healthModifyLayer1").hide();
							$("#healthModifyLayer2").hide();
							$("#healthModifyLayer3").hide();
							
							$('#decisionerTab2').load('/common/getDecisionerGrid?upmuType=21&gridDivId=tab2ApplGrid');
							$("#tab2RowCount").val($("#tab2ApplGrid").jsGrid("dataCount"));
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#updateHealthInsuranceBtn").prop("disabled", false);
					}
				});
			}
		}
	});
	
	// 건강보험 정보변경 신청시 체크 사항
	var updateHealthInsuranceCheck = function(){
		if(!checkNullField("updateHealthInsuranceForm")){
			return false;
		}
		
		//주민등록번호일때 유효성 체크
		if($("#updateHealthInsuranceApplType3 option:selected").val() == "02" ){//주민등록번호
			if( ! resno_chk('updateHealthInsuranceChngAfter')){
				return false;
			}
		}
		
		
		if( $("#updateHealthInsuranceApplType3 option:selected").val() == "04" ){
			if( $("#updateHealthInsuranceEtcText3").val() == "" ){
				alert("변경항목이 기타입니다. 내용을 입력하세요 ");
				$("#updateHealthInsuranceEtcText3").focus();
				return false;
			}
		}
		
		if( $("#updateHealthInsuranceApplType4 option:selected").val() == "05" ){
			if( $("#updateHealthInsuranceEtcText4").val() == "" ){
				alert("발급사유가 기타입니다. 내용을 입력하세요 ");
				$("#updateHealthInsuranceEtcText4").focus();
				return false;
			}
		}
		
		if( $("#updateHealthInsuranceApplType5 option:selected").val() == "04" ){
			if( $("#updateHealthInsuranceEtcText5").val() == "" ){
				alert("신청사유가 기타입니다. 내용을 입력하세요 ");
				$("#updateHealthInsuranceEtcText5").focus();
				return false;
			}
		}
		
		//결재자 정보 유무 체크 
		if($("#tab2ApplGrid").jsGrid("dataCount") == 0){
			alert("결재자 정보가 없습니다.");
			return false;
		}
		return true;
	};
	
	//건강보험 정보변경 신청 > 신청구분 selcet > 기재사항변경(healthModifyLayer1)/추가발급(healthModifyLayer2)/기타(healthModifyLayer3)
	var healthModifySelectChange = function() { 
		if($("#updateHealthInsuranceApplType2").val() == "01") {
			$("#healthModifyLayer1").show();
			
			$("#updateHealthInsuranceApplType3").attr("required","required");
			$("#updateHealthInsuranceChngBefore").attr("required","required");
			$("#updateHealthInsuranceChngAfter").attr("required","required");
			
		} else {
			$("#healthModifyLayer1").hide();
			//초기화
			$("#updateHealthInsuranceApplType3").val("").attr("required",null);
			$("#updateHealthInsuranceEtcText3").val("").hide();
			$("#updateHealthInsuranceChngBefore").val("").attr("required",null);
			$("#updateHealthInsuranceChngAfter").val("").attr("required",null);
		}
		
		if($("#updateHealthInsuranceApplType2").val() == "02") {
			$("#healthModifyLayer2").show();
			
			$("#updateHealthInsuranceApplType4").attr("required","required");
			$("#updateHealthInsuranceAddNum").attr("required","required");
		} else {
			$("#healthModifyLayer2").hide();
			//초기화
			$("#updateHealthInsuranceApplType4").val("").attr("required",null);
			$("#updateHealthInsuranceEtcText4").val("").hide();
			$("#updateHealthInsuranceAddNum").val("").attr("required",null);
		}
		
		if($("#updateHealthInsuranceApplType2").val() == "03") {
			$("#healthModifyLayer3").show();
			
			$("#updateHealthInsuranceApplType5").attr("required","required");
		} else {
			$("#healthModifyLayer3").hide();
			//초기화
			$("#updateHealthInsuranceApplType5").val("").attr("required",null);
			$("#updateHealthInsuranceEtcText5").val("").hide();
			$("#updateHealthInsuranceAddNum1").val("");
		}
	}
	
	// 변경항목 변경시
	$("#updateHealthInsuranceApplType3").change(function(){
		if( $("#updateHealthInsuranceApplType3 option:selected").val() == "04" ){
			$("#updateHealthInsuranceEtcText3").show();
		} else {
			$("#updateHealthInsuranceEtcText3").hide();
			$("#updateHealthInsuranceEtcText3").val("");
		}
	});
	
	// 발급사유 변경시
	$("#updateHealthInsuranceApplType4").change(function(){
		if( $("#updateHealthInsuranceApplType4 option:selected").val() == "05" ){
			$("#updateHealthInsuranceEtcText4").show();
		} else {
			$("#updateHealthInsuranceEtcText4").hide();
			$("#updateHealthInsuranceEtcText4").val("");
		}
	});
	
	// 신청사유 변경시
	$("#updateHealthInsuranceApplType5").change(function(){
		if( $("#updateHealthInsuranceApplType5 option:selected").val() == "04" ){
			$("#updateHealthInsuranceEtcText5").show();
		} else {
			$("#updateHealthInsuranceEtcText5").hide();
			$("#updateHealthInsuranceEtcText5").val("");
		}
	});
	
	// 대상자 성명 변경시
	$("#updateHealthInsuranceEname").change(function(){
		$("#updateHealthInsuranceSubty").val($("#updateHealthInsuranceEname option:selected").attr("SUBTY"));
		$("#updateHealthInsuranceObjps").val($("#updateHealthInsuranceEname option:selected").attr("OBJPS"));
	});
	
	// 건강보험내역
	$(function() {
		$("#healthInsuranceGrid1").jsGrid({
			height: "auto",
			width: "100%",
			autoload : true,
			paging: false,
			sorting: true,
			fields: [
				{ title: "성명", name: "LNMHG", type: "text", align: "center", width: 25 
					,itemTemplate: function(value,item){
						return value + item.FNMHG;
					}
				},
				{ title: "주민번호", name: "REGNO", type: "text", align: "center", width: 25 
					,itemTemplate: function(value, item) { 
						return addResBar(value);
					}
				},
				{ title: "현재등급", name: "GRADE", type: "text", align: "center", width: 25},
				{ title: "가입일자", name: "BEGDA", type: "text", align: "center", width: 25 }
			]
		});
	});
	
	// 대상정보
	$(function() {
		$("#healthInsuranceGrid2").jsGrid({
			height: "auto",
			width: "100%",
			autoload : true,
			paging: false,
			sorting: true,
			fields: [
				{ title: "사업장 기호", name: "E_MINUM", type: "text", align: "center", width: 50 
					,itemTemplate: function(value,item){
						return value.substring(0,1) + "-" + value.substring(1,8);
					}
				},
				{ title: "건강보험 카드번호", name: "E_MICNR", type: "text", align: "center", width: 50 }
			]
		});
	});
	
	// 피보험 대상자
	$(function() {
		$("#healthInsuranceGrid3").jsGrid({
			height: "auto",
			width: "100%",
			autoload : true,
			paging: false,
			sorting: true,
			fields: [
				{ title: "가족유형", name: "STEXT", type: "text", align: "center", width: 30 },
				{ title: "성명", name: "LNMHG", type: "text", align: "center", width: 30 
					,itemTemplate: function(value, item){
						return value + item.FNMHG;
					}
				},
				{ title: "주민번호", name: "REGNO", type: "text", align: "center", width: 40 
					,itemTemplate: function(value, item) { 
						return addResBar(value);
					}
				}
			]
		});
	});
</script>
