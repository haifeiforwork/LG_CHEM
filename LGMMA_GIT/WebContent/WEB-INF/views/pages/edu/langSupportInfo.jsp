<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.C.C07Language.rfc.C07StudTypeRFC"%>
<%@ page import="hris.C.C04Ftest.rfc.PlanguageRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.AppLineData"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<!--// Page Title start -->
<div class="title">
	<h1>어학지원</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">교육</a></span></li>
			<li class="lastLocation"><span><a href="#">어학지원</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">어학지원비신청</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');" >어학지원내역</a></li>
		<li><a href="#" id="tab3" onclick="switchTabs(this, 'tab3');" >사내어학검정 신청</a></li>	
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">	
	<form id="requestLangForm">
	<!--// Table start -->	
	<div class="tableArea">
		<h2 class="subtitle">어학지원비신청</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>신청서 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="requestLangBegda">신청일</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" id="requestLangBegda" name="BEGDA" value='<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>' readonly="readonly" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputDateFrom">학습시작일</label></th>
				<td class="tdDate">
					<input type="text" size="5" id="inputDateFrom" name="SBEG_DATE" vname="학습시작일" required />
				</td>
				<th><span class="textPink">*</span><label for="inputDateTo">학습종료일</label></th>
				<td class="tdDate">
					<input type="text" size="5" id="inputDateTo" name="SEND_DATE" vname="학습종료일" required />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestLangStudType">학습형태</label></th>
				<td>
					<select class="w150" id="requestLangStudType" name="STUD_TYPE" vname="학습형태" required>
						<option value="">-----------------</option>
						<%= WebUtil.printOption((new C07StudTypeRFC()).getDetail()) %>
					</select>
				</td>
				<th><label for="requestLangLectTime">수강시간</label></th>
				<td><input class="w100" type="text" id="requestLangLectTime" name="LECT_TIME" /></td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestLangStudInst">학습기관</label></th>
				<td colspan="3">
					<input class="wPer" type="text" id="requestLangStudInst" name="STUD_INST" vname="학습기관" required />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestLangLectSbjt">수강과목</label></th>
				<td colspan="3">
					<input class="wPer" type="text" id="requestLangLectSbjt" name="LECT_SBJT" vname="수강과목" required />
				</td>
			</tr>	
			<tr>
				<th><span class="textPink">*</span><label for="SELT_GUBN">결제구분</label></th>
				<td>
					<input type="radio" name="SELT_GUBN" value="P" checked="checked" /><label for="SELT_GUBN">개인카드</label>
					<input type="radio" name="SELT_GUBN" value="X" /><label for="SELT_GUBN">기타</label>
					<input class="w150" type="text" id="METHOD_BIGO" name="METHOD_BIGO" />
				</td>
 				<th><span class="textPink">*</span><label for="requestLangSeltDate">결제일</label></th>
				<td class="tdDate">
					<input class="datepicker" type="text" id="requestLangSeltDate" name="SELT_DATE" vname="결제일" required />
				</td>
			</tr>
<!-- 			<tr>
 				<th><label for="requestLangCardNumb">카드번호</label></th>
				<td>
					<input class="w180" type="text" id="requestLangCardNumb" maxlength="16" name="CARD_NUMB" />
					<span class="noteItem">('-' 표시 없이)</span> 
				</td>
			</tr>
 -->			<tr>
				<th><span class="textPink">*</span><label for="requestLangSetlWonx">결제금액</label></th>
				<td>
					<input class="inputMoney w100" type="text" id="requestLangSetlWonx" name="SETL_WONX" onkeyup="cmaComma(this);" onchange="cmaComma(this);" vname="결제금액" required > 원																
				</td>
				<th><span class="textPink">*</span><label for="requestLangCardCmpy">학습기관<br/>사업자등록번호</label></th>
				<td>
					<input class="w180" type="text" id="requestLangCardCmpy" name="CARD_CMPY" maxlength="12" vname="학습기관 사업자등록번호" required />
				</td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>
	<input type="hidden" id="RowCount" name="RowCount" >
	<input type="hidden" id="requestLangCmpyWonx" name="CMPY_WONX" value="0" >
	</form>
	<!--// Table end -->
	<!--// list start -->
	<div class="listArea" id="decisionerTab1">
	</div>
	<!--// list end -->
	
	<div class="buttonArea">
		<ul class="btn_crud">
		<c:if test="${selfApprovalEnable == 'Y'}">
			<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
		</c:if>
			<li><a href="#" id="requestLangBtn" class="darken" ><span>신청</span></a></li>
		</ul>
	</div>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">어학지원내역</h2>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a href="#popLayerAddress" class="popLayerAddress_open"><span>조회</span></a></li>
			</ul>
		</div>
		<div class="clear"></div>
		<div id="langSupportGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
	</div>
	<!--// list end -->
	<form id="detailLangForm">
	<div class="tableArea">
		<h2 class="subtitle">어학지원내역 상세</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>신청서 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="detailLangBegda">신청일</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" id="detailLangBegda" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailLangSbegDate">학습시작일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" size="5" id="detailLangSbegDate" name="SBEG_DATE" readonly />
				</td>
				<th><span class="textPink">*</span><label for="detailLangSendDate">학습종료일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" size="5" id="detailLangSendDate" name="SEND_DATE" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailLangStudText">학습형태</label></th>
				<td>
					<input class="readOnly w150" type="text" id="detailLangStudText" readonly >
				</td>
				<th><label for="detailLangLectTime">수강시간</label></th>
				<td><input class="readOnly w100" type="text" id="detailLangLectTime" readonly /></td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailLangStudInst">학습기관</label></th>
				<td colspan="3">
					<input class="readOnly wPer" type="text" id="detailLangStudInst" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="detailLangLectSbjt">수강과목</label></th>
				<td colspan="3">
					<input class="readOnly wPer" type="text" id="detailLangLectSbjt" readonly />
				</td>
			</tr>	
			<tr>
				<th><span class="textPink">*</span><label for="SELT_GUBN">결제구분</label></th>
				<td>
					<input type="radio" id="detailSeltGubn1" name="detailSeltGubn" value="P" disabled /><label for="detailSeltGubn1">개인카드</label>
					<input type="radio" id="detailSeltGubn2" name="detailSeltGubn" value="X" disabled /><label for="detailSeltGubn2">기타</label>
					<input class="readOnly w150" type="text" id="METHOD_BIGO" name="METHOD_BIGO" readonly />
				</td>
				<th><span class="textPink">*</span><label for="detailLangSeltDate">결제일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" id="detailLangSeltDate" readonly />
				</td>
			</tr>
<!--
			<tr>
	2017.05.17 카드번호 제거 (김재만부장 요청) 
				<th><label for="detailLangCardNumb">카드번호</label></th>
				<td>
					<input class="readOnly w180" type="text" id="detailLangCardNumb" readonly />
				</td>
			</tr>
 -->
			<tr>
				<th><span class="textPink">*</span><label for="detailLangSetlWonx">결제금액</label></th>
				<td>
					<input class="readOnly inputMoney w100" type="text" id="detailLangSetlWonx" readonly > 원	
				</td>
				<th><span class="textPink">*</span><label for="detailLangCardCmpy">학습기관<br/>사업자등록번호</label></th>
				<td>
					<input class="readOnly w180" type="text" id="detailLangCardCmpy" readonly />
				</td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>
	</form>
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle">사내어학검정 신청</h2>
		<div id="langTestGrid" class="jsGridPaging"></div>
	</div>
	<!--// list end -->
</div>
<!--// Tab3 end -->
<!--------------- layout body end --------------->
<!-- popup : 사내어학검정 상세 start -->
<div class="layerWrapper layerSizeM" id="popLayerlangTest" style="display:inherit !important">
	<div class="layerHeader">
		<strong>사내어학검정 상세</strong>
		<a href="#" class="btnClose popLayerlangTest_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<form id="langTestPopupForm">
			<!--// Content start  -->
			<div class="tableArea">
				<div class="table">
					<table class="tableGeneral">
					<caption>사내어학검정 신청정보</caption>
					<colgroup>
						<col class="col_25p" />
						<col class="col_75p" />
					</colgroup>
					<tbody>
						<tr>
							<th>신청일</th>
							<td><div id="langTestReqsDate" ></div></td>
						</tr>
						<tr>
							<th>구분</th>
							<td><div id="langTestLangName" ></div></td>
						</tr>
						<tr>
							<th>신청검정지역</th>
							<td><select id="langTestAreaCode" name="AREA_CODE" class="w150" /></td>
						</tr>
						<tr>
							<th>검정일</th>
							<td><div id="langTestExamDate"></div></td>
						</tr>
						<tr>
							<th>신청기간</th>
							<td><div id="langTestDate"></div></td>
						</tr>
						<tr>
							<th>비고</th>
							<td><div id="langTestBigo"></div></td>
						</tr>
						<tr>
							<th>상태</th>
							<td><div id="langTestConfFlag"></div></td>
						</tr>
					</tbody>
					</table>
				</div>
			</div>
			<!--// Content end  -->
			<div class="buttonArea">
				<ul class="btn_crud">
					<li><a href="#" id="langTestListBtn" class="darken" ><span>목록</span></a></li>
					<li><a href="#" id="langTestRequestBtn" ><span>신청</span></a></li>
					<li><a href="#" id="langTestChangeBtn" ><span>수정</span></a></li>
					<li><a href="#" id="langTestDeleteBtn" ><span>삭제</span></a></li>
				</ul>
			</div>
			<input type="hidden" id="targetLangCode" name="LANG_CODE" />
			<input type="hidden" id="targetExamDate" name="EXAM_DATE" />

	        <input type="hidden" id="targetBukrs" name="BUKRS" />
	        <input type="hidden" id="targetReqsDate" name="REQS_DATE" />
	        <input type="hidden" id="targetEximDtim" name="EXIM_DTIM" />
	        <input type="hidden" id="targetFromDate" name="FROM_DATE" />
	        <input type="hidden" id="targetFromTime" name="FROM_TIME" />
	        <input type="hidden" id="targetToxxDate" name="TOXX_DATE" />
	        <input type="hidden" id="targetToxxTime" name="TOXX_TIME" />
	        <input type="hidden" id="targetLangName" name="LANG_NAME" />
	        <input type="hidden" id="targetAreaDesc" name="AREA_DESC" /> 
			</form>
		</div>
	</div>
</div>
<!-- //팝업: 결재자 선택 end -->

<script type="text/javascript">
	$(document).ready(function(){
		// 신청 버튼
		$("#requestLangBtn").click(function(){
			requestLang(false);
		});
		
		// 신청 버튼
		$("#requestNapprovalBtn").click(function(){
			requestLang(true);
		});
		$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=31&gridDivId=decisionerGrid');
		
		if($(".layerWrapper").length){
			// 결재자 팝업
			$('#popLayerlangTest').popup();
		};
		
		$("#tab1").click(function(){
			$("#requestLangForm").each(function() {
				this.reset();
			});
			$("#decisionerTab1").load("/common/getDecisionerGrid?upmuType=31&gridDivId=decisionerGrid");
		});
		$("#tab2").click(function(){
			$("#langSupportGrid").jsGrid("search");
		});
		$("#tab3").click(function(){
			$("#langTestGrid").jsGrid("search");
		});
		
		$("#METHOD_BIGO").addClass("readOnly").prop("readOnly",true).val("");
		
	});
	
	$('input:radio[name="SELT_GUBN"]').click(function(){
		if($(this).val() == 'P'){
			//$("#requestLangCardNumb").removeClass("readOnly").prop("readOnly",false);
			$("#METHOD_BIGO").addClass("readOnly").prop("readOnly",true).val("");
		}else{
			//$("#requestLangCardNumb").addClass("readOnly").prop("readOnly",true).val("");
			$("#METHOD_BIGO").removeClass("readOnly").prop("readOnly",false);
		}
	});
	
	//
	var requestLang = function(self) {
		if(requestLangCheck()){
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			decisionerGridChangeAppLine(self);
			if(confirm(msg + "신청 하시겠습니까?")){
				$("#requestLangCmpyWonx").val($("#requestLangSetlWonx").val());
				$('#RowCount').val($("#decisionerGrid").jsGrid("dataCount"));
				var param = $("#requestLangForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				param.push({"name":"selfAppr", "value" : self});
				
				jQuery.ajax({
					type : 'POST',
					url : '/edu/requestLangSupport.json',
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
						// 초기화
						$("#requestLangForm").each(function() {
							this.reset();
						});
						
						$("#decisionerTab1").load("/common/getDecisionerGrid?upmuType=31&gridDivId=decisionerGrid");
					}
				});
			}
		}
	}
	
	var requestLangCheck = function(){
		if(!checkNullField("requestLangForm")){
			return false;
		}
		
		var fr_date = $("#inputDateFrom").val();
		var to_date = $("#inputDateTo").val();
		
		if( fr_date > to_date ) {
			alert("학습시작일이 학습종료일보다 큽니다.");
			return false;
		}
		
		//학습기관-40 입력시 길이 제한 
		if( $("#requestLangStudInst").val().length > 40 ){
			alert("학습기관은 한글 20자, 영문 40자 이내여야 합니다.");
			$("#requestLangStudInst").focus();
			$("#requestLangStudInst").select();
			return false;
		}
		
		//수강과목-50 입력시 길이 제한 
		if( $("#requestLangLectSbjt").val().length > 50 ){
			alert("수강과목은 한글 25자, 영문 50자 이내여야 합니다.");
			$("#requestLangLectSbjt").focus();
			$("#requestLangLectSbjt").select();
			return false;
		}
		
		//결재구분이 카드일경우
		if( $('input:radio[name="SELT_GUBN"]').filter(':checked').val() == "P" ) {
			//  카드번호, 사업자등록번호 중 한 항목만 입력시 error처리함
			if( $("#requestLangCardCmpy").val() == "") {
				alert("사업자등록번호를 입력하세요.");
				$("#requestLangCardCmpy").focus();
				return false;
			}
			//  카드번호 입력시 16자리를 check한다.
/* 			if( $("#requestLangCardNumb").val().length < 16 ){
				alert("카드번호 16자리를 입력하세요.");
				$("#requestLangCardNumb").focus();
				$("#requestLangCardNumb").select();
				return false;
			}
 */		}
		
		//사업자등록번호-30 입력시 길이 제한 
		if($("#requestLangCardCmpy").val().length > 30){
			alert("사업자등록번호은 한글 15자, 영문 30자 이내여야 합니다.");
			$("#requestLangCardCmpy").focus();
			$("#requestLangCardCmpy").select();
			return false;
		}
		
		return true;
	};
	
	// 어학지원내역 grid
	$(function() {
		$("#langSupportGrid").jsGrid({
			height: "auto",
			width: "100%",
			paging: true,
			sorting: true,
			pageSize: 10,
			pageButtonCount: 10,
			autoload: false,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/edu/getLangSupportList.json",
						dataType : "json",
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
					title: "선택", name: "th1", align: "center", width: "8%"
					,itemTemplate: function(_, item) {
						return $("<input name='Radio'>")
							.attr("type", "radio")
							.on("click", function(e) {
								
								$("#detailLangForm").each(function(){
									this.reset();
								})
								
								$("#detailLangBegda").val(item.BEGDA);
								$("#detailLangSbegDate").val(item.SBEG_DATE);
								$("#detailLangSendDate").val(item.SEND_DATE);
								
								var STUD_TEXT = "";
<% 
							Vector StudType_vt = (Vector)(new C07StudTypeRFC()).getDetail();
							for ( int i=0 ; i < StudType_vt.size() ; i++ ){
								CodeEntity ce = (CodeEntity)StudType_vt.get(i);
%>
								if(item.STUD_TYPE == "<%=ce.code%>")
									STUD_TEXT = "<%=ce.value%>";
<%
							}
%>
								$("#detailLangStudText").val(STUD_TEXT);
								
								$("#detailLangLectTime").val(item.LECT_TIME);
								$("#detailLangStudInst").val(item.STUD_INST);
								$("#detailLangLectSbjt").val(item.LECT_SBJT);
								$("#detailLangSetlWonx").val(parseInt(item.SETL_WONX));
								$("#detailLangSeltDate").val(item.SELT_DATE);
								$('input:radio[name="detailSeltGubn"]:input[value='+item.SELT_GUBN+']').prop("checked", true);
								//$("#detailLangCardNumb").val(item.CARD_NUMB);
								$("#detailLangCardCmpy").val(item.CARD_CMPY);
							});
					}
				},
				{ title: "신청일", name: "BEGDA", type: "text", align: "center", width: "10%" },
				{ title: "학습기관", name: "STUD_INST", type: "text", align: "center", width: "22%" },
				{ title: "수강과목", name: "LECT_SBJT", type: "text", align: "center", width: "22%"},
				{ title: "결제금액", name: "SETL_WONX", type: "number", align: "right", width: "14%"
					,itemTemplate: function(value, item) {
						return parseInt(value).format();
					}
				},
				{ title: "회사지원금액", name: "CMPY_WONX", type: "number", align: "right", width: "14%"
					,itemTemplate: function(value, item) {
						return parseInt(value).format();
					}
				},
				{ title: "최종결제일", name: "POST_DATE", type: "text", align: "center", width: "10%" }
			]
		});
	});
	
	// 사내어학검정 신청 grid
	$(function() {
		$("#langTestGrid").jsGrid({
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
						url : "/edu/getLangTestList.json",
						dataType : "json",
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
				{ title: "구분", name: "LANG_NAME", type: "text", align: "center", width: 15
					,itemTemplate : function(value, storeData){
						return $("<a>")
								.attr({
									"href":"#",
									"class":"textLink"
								})
								.text(value)
								.on("click", function(e) {
									$('#langTestAreaCode').empty();
									getPlanguageCode(storeData.BUKRS, storeData.LANG_CODE);
									
									$("#langTestReqsDate").text((storeData.REQS_DATE == "0000.00.00") ? "<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" : storeData.REQS_DATE );
									$("#langTestLangName").text(storeData.LANG_NAME);
									$("#langTestExamDate").text(storeData.EXAM_DATE);  
									$("#langTestAreaCode").val(storeData.AREA_CODE);
									$("#langTestDate").text(storeData.FROM_DATE + " ~ " + storeData.TOXX_DATE);
									$("#langTestBigo").text("시험 시간 : " + storeData.EXIM_DTIM + storeData.FROM_TIME + " ~ " + storeData.TOXX_TIME);
									
									$("#targetLangCode").val(storeData.LANG_CODE);
									$("#targetExamDate").val(storeData.EXAM_DATE);
									
									$("#targetBukrs").val(storeData.BUKRS);
									$("#targetReqsDate").val((storeData.REQS_DATE == "0000.00.00") ? "<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" : storeData.REQS_DATE);
									$("#targetEximDtim").val(storeData.EXIM_DTIM);
									$("#targetFromDate").val(storeData.FROM_DATE);
									$("#targetFromTime").val(storeData.FROM_TIME);
									$("#targetToxxDate").val(storeData.TOXX_DATE);
									$("#targetToxxTime").val(storeData.TOXX_TIME);
									$("#targetLangName").val(storeData.LANG_NAME);
									$("#targetAreaDesc").val(storeData.AREA_DESC);

									var confFlagText = "";
									switch(storeData.CONF_FLAG) {
										case "X" :
											confFlagText = "현재 신청중입니다.";
											break;
										case "Y" :
											confFlagText = "사내어학검정이 확정되었습니다. (확정검정지역 : " + storeData.AREA_DESC2 + " )";
											break;
										case "N" :
											confFlagText = "사내어학검정이 취소되었습니다. <br> (신청기간 이후에 취소하였으므로 검정비는 급여공제함.)";
											break;
										default:
											confFlagText = "";
										break;
									}
									$("#langTestConfFlag").text(confFlagText);
									$('#popLayerlangTest').popup("show");

									var showFlag = (storeData.REQS_FLAG == "X" || (storeData.REQS_DATE == "0000.00.00" && storeData.REQS_FLAG == "Y") || (storeData.REQS_FLAG =="N" && storeData.CONF_FLAG ==""))  ? "Y" : "N" ;
									
									if( showFlag == "Y"){
										$("#langTestRequestBtn").show();
										$("#langTestChangeBtn").hide();
										$("#langTestDeleteBtn").hide();
									}else{
										$("#langTestRequestBtn").hide();
										$("#langTestChangeBtn").show();
										$("#langTestDeleteBtn").show();
									}
								});
					}
				},
				{ title: "검정일", name: "EXAM_DATE", type: "text", align: "center", width: 15 },
				{ title: "신청기간", name: "FROM_DATE", type: "text", align: "center", width: 30 },
				{ title: "신청/확정", name: "REQS_CONT", type: "text", align: "center", width: 25
					,itemTemplate : function(value,item){
						return value + " / " + item.CONF_CONT;
					}
				},
				{ title: "상태", name: "CONF_FLAG", type: "text", align: "center", width: 15
					,itemTemplate : function(value, item){
						var detailBtn = "";
						switch(value) {
							case "X" :
								detailBtn = "신청완료";
								break;
							case "Y" :
								detailBtn = "확정";
								break;
							case "N" :
								detailBtn = "취소";
								break;
							default:
								detailBtn = "";
								break;
						}
						return $("<a>")
								.attr({
									"href":"#",
									"class":"inlineBtn"
								})
								.on("click", function(e) {
									$('#langTestAreaCode').empty();
									
									getPlanguageCode(storeData.BUKRS, storeData.LANG_CODE);
									
									$("#langTestReqsDate").text((storeData.REQS_DATE == "0000.00.00") ? "<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" : storeData.REQS_DATE );
									$("#langTestLangName").text(storeData.LANG_NAME);
									$("#langTestExamDate").text(storeData.EXAM_DATE);
									$("#langTestAreaCode").val(storeData.AREA_CODE);
									$("#langTestDate").text(storeData.FROM_DATE + " ~ " + storeData.TOXX_DATE);
									$("#langTestBigo").text("시험 시간 : " + storeData.EXIM_DTIM + storeData.FROM_TIME + " ~ " + storeData.TOXX_TIME);
									
									$("#targetLangCode").val(storeData.LANG_CODE);
									$("#targetExamDate").val(storeData.EXAM_DATE);
									
									$("#targetBukrs").val(storeData.BUKRS);
									$("#targetReqsDate").val((storeData.REQS_DATE == "0000.00.00") ? "<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" : storeData.REQS_DATE);
									$("#targetEximDtim").val(storeData.EXIM_DTIM);
									$("#targetFromDate").val(storeData.FROM_DATE);
									$("#targetFromTime").val(storeData.FROM_TIME);
									$("#targetToxxDate").val(storeData.TOXX_DATE);
									$("#targetToxxTime").val(storeData.TOXX_TIME);
									$("#targetLangName").val(storeData.LANG_NAME);
									$("#targetAreaDesc").val(storeData.AREA_DESC); 
									
									var confFlagText = "";
									switch(storeData.CONF_FLAG) {
										case "X" :
											confFlagText = "현재 신청중입니다.";
											break;
										case "Y" :
											confFlagText = "사내어학검정이 확정되었습니다. (확정검정지역 : " + storeData.AREA_DESC2 + " )";
											break;
										case "N" :
											confFlagText = "사내어학검정이 취소되었습니다. <br> (신청기간 이후에 취소하였으므로 검정비는 급여공제함.)";
											break;
										default:
											confFlagText = "";
											break;
									}
									$("#langTestConfFlag").text(confFlagText);
									$('#popLayerlangTest').popup("show");
									
									var showFlag = (storeData.REQS_FLAG == "X" || (storeData.REQS_DATE == "0000.00.00" && storeData.REQS_FLAG == "Y") || (storeData.REQS_FLAG =="N" && storeData.CONF_FLAG ==""))  ? "Y" : "N" ;
									
									if( showFlag == "Y"){
										$("#langTestRequestBtn").show();
										$("#langTestChangeBtn").hide();
										$("#langTestDeleteBtn").hide();
									}else{
										$("#langTestRequestBtn").hide();
										$("#langTestChangeBtn").show();
										$("#langTestDeleteBtn").show();
									}
								})
								.add($("<span>").text(detailBtn));
					}
				}
			]
		});
	});
	
	// 신청 검정 지역 option 셋팅 
	var getPlanguageCode = function(BUKRS, LANG_CODE) {
		jQuery.ajax({
			type : "POST",
			url : "/edu/getPlanguageList.json",
			cache : false,
			dataType : "json",
			data : {
				 "BUKRS" : BUKRS
				,"LANG_CODE" : LANG_CODE
			},
			async :false,
			success : function(response) {
				if(response.success){
					setPlanguageOption(response.storeData)
				}
				else{
					alert("조회시 오류가 발생하였습니다. " + response.message);
				}
		}
		});
	};
	
	var setPlanguageOption = function(jsonData) {
		$.each(jsonData, function (key, value) {
			$('#langTestAreaCode').append('<option value=' + value.code + '>' + value.value + '</option>');
		});
	}
	
	// 사내어학검점 목록 버튼
	$("#langTestListBtn").click(function(){
		$("#langTestGrid").jsGrid("search");
		$('#popLayerlangTest').popup("hide");
	});
	
	// 사내어학검점 신청 버튼
	$("#langTestRequestBtn").click(function(){
		if(confirm("신청 하시겠습니까?")){
			$("#targetAreaDesc").val($("#langTestAreaCode option:selected").text());
			
			jQuery.ajax({
				type : 'POST',
				url : '/edu/requestLangTest.json',
				cache : false,
				dataType : 'json',
				data : $('#langTestPopupForm').serialize(), //결재자 정보 필요함
				async :false,
				success : function(response) {
					if(response.success){
						alert("신청 되었습니다.");
						
					}else{
						alert("신청시 오류가 발생하였습니다. " + response.message);
					}
					$("#langTestGrid").jsGrid("search");
					$('#popLayerlangTest').popup("hide");
				}
			});
		}
	});
	
	// 사내어학검점 수정 버튼
	$("#langTestChangeBtn").click(function(){
		if(confirm("정말 수정 하시겠습니까?") ) {
			
			$("#targetAreaDesc").val($("#langTestAreaCode option:selected").text());
			
			jQuery.ajax({
				type : 'POST',
				url : '/edu/updateLangTest.json',
				cache : false,
				dataType : 'json',
				data : $('#langTestPopupForm').serialize(), //결재자 정보 필요함
				async :false,
				success : function(response) {
					if(response.success){
						alert("수정 되었습니다.");
						
					}else{
						alert("수정시 오류가 발생하였습니다. " + response.message);
					}
					$("#langTestGrid").jsGrid("search");
					$('#popLayerlangTest').popup("hide");
				}
			});
		}
	});
	
	// 사내어학검점 삭제 버튼
	$("#langTestDeleteBtn").click(function(){
		if(confirm("정말 삭제 하시겠습니까?") ) {
			jQuery.ajax({
				type : 'POST',
				url : '/edu/deleteLangTest.json',
				cache : false,
				dataType : 'json',
				data : $('#langTestPopupForm').serialize(), //결재자 정보 필요함
				async :false,
				success : function(response) {
					if(response.success){
						alert("삭제 되었습니다.");
						
					}else{
						alert("삭제시 오류가 발생하였습니다. " + response.message);
					}
					$("#langTestGrid").jsGrid("search");
					$('#popLayerlangTest').popup("hide");
				}
			});
		}
	});
</script>