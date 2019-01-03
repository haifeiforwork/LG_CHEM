<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.C.rfc.*"%>
<%@ page import="hris.C.C09Educ.rfc.C09EducRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<!--// Page Title start -->
<div class="title">
	<h1>교육</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">교육</a></span></li>
			<li class="lastLocation"><span><a href="#">교육</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">사이버아카데미 교육신청</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">OffLine 교육신청</a></li>
		<li><a href="#" id="tab3" onclick="switchTabs(this, 'tab3');" >교육변경신청(사이버아카데미)</a></li>
		<li><a href="#" id="tab4" onclick="switchTabs(this, 'tab4');" >교육변경신청(OffLine)</a></li>
		<li><a href="#" id="Tab5" onclick="switchTabs(this, 'Tab5');" >교육이수현황</a></li>	
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
	<form id="eduForm">
	<div class="tableArea">
		<h2 class="subtitle">교육과정 선택</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>교육신청</caption>
			<colgroup>
				<col class="col_10p" />
				<col class="col_14p" />
				<col class="col_10p" />
				<col class="col_16p" />
				<col class="col_10p" />
				<col class="col_40p" />
			</colgroup>
			<tbody>
				<tr>
					<th><span class="textPink">*</span><label for="EDUC_YEAR">교육년도</label></th>
					<td>
						<select class="w90" id="EDUC_YEAR" name="EDUC_YEAR" vname="교육년도" required>
							<option value="">----</option>
							<%= WebUtil.printOption((new C09EducRFC()).getCodeType("","","","","3")) %>
						</select>
					</td>
					<th><span class="textPink">*</span><label for="CATA_CODE">교육분야 </label></th>
					<td>
						<select class="wPer" id="CATA_CODE" name="CATA_CODE" vname="교육분야" required>
							<option value="">--------</option>
							<%= WebUtil.printOption((new C09EducRFC()).getCodeType("","","","","2")) %>
						</select>
					</td>
					<th><span class="textPink">*</span><label for="COUR_CODE">교육과정</label></th>
					<td>
						<select class="wPer" id="COUR_CODE" name="COUR_CODE" vname="교육과정" required> 
							<option value="">------------------------</option>
						</select>
					</td>
					<input type="hidden" id="ORGA_CODE" name="ORGA_CODE" value="2000">
				</tr>
			</tbody>
			</table>
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
	<!--// list start -->
	<div class="listArea" id="decisioner"></div>
	<!--// list end -->
	<div class="buttonArea">
		<ul class="btn_crud">
		<c:if test="${selfApprovalEnable == 'Y'}">
			<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
		</c:if>
			<li><a id="requestOnLineBtn" class="darken" href="#"><span>신청</span></a></li>
			<li><a id="changeOnLineBtn" class="darken" href="#"><span>수정</span></a></li>
		</ul>
	</div>
	<input type="hidden" id="GUBUN"     name="GUBUN" />
	<input type="hidden" id="BEGDA"     name="BEGDA" value="<%= DataUtil.getCurrentDate() %>" />
	<input type="hidden" id="SUBTY"     name="SUBTY" />
	<input type="hidden" id="OBJPS"     name="OBJPS" />
	<input type="hidden" id="UPMUTYPE"  name="UPMUTYPE" />
	<input type="hidden" id="FAMID"     name="FAMID" />
	<input type="hidden" id="ainfSeqn"  name="AINF_SEQN" />

	<input type="hidden" id="ORGA_NAME" name="ORGA_NAME" />
	<input type="hidden" id="CATA_NAME" name="CATA_NAME" />
	<input type="hidden" id="COUR_NAME" name="COUR_NAME" />
	<input type="hidden" id="COUR_SCHE" name="COUR_SCHE" />
	<input type="hidden" id="EDUC_BEGD" name="EDUC_BEGD" />
	<input type="hidden" id="EDUC_ENDD" name="EDUC_ENDD" />
	<input type="hidden" id="EDUC_COST" name="EDUC_COST" />
	<input type="hidden" id="EDUC_TIME" name="EDUC_TIME" />
	<input type="hidden" id="PASS_FLAG" name="PASS_FLAG" />
	<input type="hidden" id="ESSE_FLAG" name="ESSE_FLAG" />
	<input type="hidden" id="APPR_MARK" name="APPR_MARK" />
	<input type="hidden" id="EMPL_FLAG" name="EMPL_FLAG" />
	<input type="hidden" id="SEMI_FLAG" name="SEMI_FLAG" />

	<input type="hidden" id="ORGA_CODE_1" name="ORGA_CODE_1" value="2000" />
	<input type="hidden" id="CATA_CODE_1" name="CATA_CODE_1" />
	<input type="hidden" id="EDUC_YEAR_1" name="EDUC_YEAR_1" />
	<input type="hidden" id="COUR_CODE_1" name="COUR_CODE_1" />
	<input type="hidden" id="CHECK"       name="CHECK" />
	
	</form>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<form id="eduRequestOffLineForm">
	<div class="tableArea">
		<h2 class="subtitle">교육신청</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>교육신청</caption>
			<colgroup>
				<col class="col_15p" />
				<col class="col_85p" />
			</colgroup>
			<tbody>
				<tr>
					<th><span class="textPink">*</span><label for="requestOffLineEducYear">교육년도</label></th>
					<td>
						<select class="w90" id="requestOffLineEducYear" name="EDUC_YEAR" vname="교육년도" required >
							<option value="">----</option>
							<%= WebUtil.printOption((new C09EducRFC()).getCodeType("","","","","3")) %>
						</select>
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="requestOffLineCataCode">교육분야 </label></th>
					<td>
						<select class="w90" id="requestOffLineCataCode" name="CATA_CODE" vname="교육분야" required >
							<option value="">--------</option>
							<%= WebUtil.printOption((new C09EducRFC()).getCodeType("","","","","2")) %>
						</select>
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="requestOffLineCourName">교육과정명</label></th>
					<td>
						<input class="wPer" type="text" id="requestOffLineCourName" name="COUR_NAME" vname="교육과정" required />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="requestOffLineOrgaName">교육기관명</label></th>
					<td>
						<input class="wPer" type="text" id="requestOffLineOrgaName" name="ORGA_NAME" vname="교육기관" required />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="inputDateFrom">교육기간</label></th>
					<td class="tdDate">
						<input id="inputDateFrom" name="EDUC_BEGD" type="text" size="5" vname="교육시작기간" required />
						~
						<input id="inputDateTo" name="EDUC_ENDD" type="text" size="5" vname="교육종료기간" required />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="requestOffLineEducCost">교육비</label></th>
					<td>
						<input class="inputMoney w100" type="text" id="requestOffLineEducCost" name="EDUC_COST" vname="교육비" required /> 원
					</td>
				</tr>
				<tr>
					<th>교육시간</label></th>
					<td>
						<input class="alignRight w100" type="text" id="requestOffLineEducTime" name="EDUC_TIME" /> 시간
					</td>
				</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">안내사항</span></p>
			<ul>
				<li>교육비 및 출장비 품의는 UAS에서 별도 품의서 작성하셔야 합니다. </li>
				<li>UAS에서 교육비 정산 전 교육 신청을 완료하시기 바랍니다.</li>
				<li>교육수강후 이수확인서, 수료증, 교육비영수증 등 증빙사본을 교육담당자에게 제출 바랍니다.</li>
			</ul>
		</div>
		<div class="buttonArea">
			<ul class="btn_crud">
				<li><a class="darken" id="requestOffLineBtn" href="#"><span>신청</span></a></li>
				<li><a class="darken" id="changeOffLineBtn" href="#"><span>수정</span></a></li>
			</ul>
		</div>
	</div>
	<input type="hidden" id="requestOffLineCataName" name="CATA_NAME" />
	<input type="hidden" id="requestOffLineCourSche" name="COUR_SCHE" value="1">
	<input type="hidden" id="requestOffLineOrgaCode" name="ORGA_CODE" value="9999">
	<input type="hidden" id="requestOffLineAinfSeqn" name="AINF_SEQN" />
	<input type="hidden" id="requestOffLineCourCode" name="COUR_CODE" />
	</form>
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 Lnodisplay">
	<form id="changeOnLineForm">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle">교육변경신청</h2>
		<div id="changeOnLineGrid" class="jsGridPaging"></div>
	</div>
	<!--// list end -->
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" id="changeOnLineFormBtn" href="#"><span>변경신청</span></a></li>
		</ul>
	</div>
	<input type="hidden" id="changeOnLineRadioChk"    name="radio_chk" />
	<input type="hidden" id="changeOnLinePernr"       name="PERNR"     />
	<input type="hidden" id="changeOnLineBegda"       name="BEGDA"     />
	<input type="hidden" id="changeOnLineAinfSeqn"    name="AINF_SEQN" />
	<input type="hidden" id="changeOnLineOldAinfSeqn" name="OLD_AINF_SEQN" />
	<input type="hidden" id="changeOnLineOrgaCode"    name="ORGA_CODE" />
	<input type="hidden" id="changeOnLineOrgaName"    name="ORGA_NAME" />
	<input type="hidden" id="changeOnLineCataCode"    name="CATA_CODE" />
	<input type="hidden" id="changeOnLineCataName"    name="CATA_NAME" />
	<input type="hidden" id="changeOnLineEducYear"    name="EDUC_YEAR" />
	<input type="hidden" id="changeOnLineCourCode"    name="COUR_CODE" />
	<input type="hidden" id="changeOnLineCourName"    name="COUR_NAME" />
	<input type="hidden" id="changeOnLineCourSche"    name="COUR_SCHE" />
	<input type="hidden" id="changeOnLineEducBegd"    name="EDUC_BEGD" />
	<input type="hidden" id="changeOnLineEducEndd"    name="EDUC_ENDD" />
	<input type="hidden" id="changeOnLineEducCost"    name="EDUC_COST" />
	<input type="hidden" id="changeOnLineEducTime"    name="EDUC_TIME" />
	<input type="hidden" id="changeOnLineApprMark"    name="APPR_MARK" />
	<input type="hidden" id="changeOnLinePassFlag"    name="PASS_FLAG" />
	<input type="hidden" id="changeOnLineEsseFlag"    name="ESSE_FLAG" />
	<input type="hidden" id="changeOnLineEmplFlag"    name="EMPL_FLAG" />
	</form>
</div>
<!--// Tab3 end -->

<!--// Tab4 start -->
<div class="tabUnder tab4 Lnodisplay">
	<form id="changeOffLineForm">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle">교육변경신청(OffLine)</h2>
		<div id="changeOffLineGrid" class="jsGridPaging"></div>
	</div>
	<!--// list end -->
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" id="changeOffLineFormBtn" href="#"><span>변경신청</span></a></li>
		</ul>
	</div>
	</form>
</div>
<!--// Tab4 end -->

<!--// Tab5 start -->
<div class="tabUnder Tab5 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">교육이수현황</h2>
		<div class="floatRight colorBlue">※ Y : 이수, M : 미이수, N : 불참</div>
		<div class="clear"> </div>
		<div id="finishedGrid" class="jsGridPaging"></div>
	</div>
	<!--// list end -->
</div>
<!--// Tab5 end -->

<script type="text/javascript">

	$(document).ready(function(){
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=83&gridDivId=decisionerGrid');
		$("#tab1").click(function(){
			$('#decisioner').load('/common/getDecisionerGrid?upmuType=83&gridDivId=decisionerGrid');
			$("#EDUC_YEAR").val("").prop("disabled", false);
			$("#CATA_CODE").val("").prop("disabled", false);
			$("#COUR_CODE").val("").prop("disabled", false);

			// 초기화
			CHANGE_CODE();

			$("#ORGA_NAME").val("");
			$("#CATA_NAME").val("");
			
			$("#decisionerGrid").jsGrid("search");
			$("#curriculumGrid").jsGrid({"data":$.noop});
			
			$("#requestOnLineBtn").show();
			$("#changeOnLineBtn").hide();
			
		});
		$("#tab2").click(function(){
			// 초기화
			$("#eduRequestOffLineForm").each(function() {
				this.reset();
			});
			
			$("#requestOffLineEducYear").prop("disabled", false);
			$("#requestOffLineCataCode").prop("disabled", false);
			
			$("#requestOffLineBtn").show();
			$("#changeOffLineBtn").hide();
		});
		$("#tab3").click(function(){
			$("#changeOnLineGrid").jsGrid("search");
		});
		$("#tab4").click(function(){
			$("#changeOffLineGrid").jsGrid("search");
		});
		$("#Tab5").click(function(){
			$("#finishedGrid").jsGrid("search");
		});
		
		$("#changeOnLineBtn").hide();
		
		if($(".layerWrapper").length){
			// 결재자 팝업
			$('#popLayerAppl').popup();
		};
		//  년도 select box 변경
		$("#EDUC_YEAR").change(function(){
			CHANGE_CODE();
			$("#curriculumGrid").jsGrid("search");
		});
		
		// 교육뷴야 select box 변경
		$("#CATA_CODE").change(function(){
			CHANGE_CODE();
			$("#applPopupGrid").jsGrid("search");
		});
		
		// 교육과정 select box 변경
		$("#COUR_CODE").change(function(){
			$("#curriculumGrid").jsGrid("search");
		});
		
		// 결재자 조회 popup 검색
		$("#applPopupSearchbtn").click(function(){
			$("#applPopupGrid").jsGrid("search");
		});
		
		// OnLine 교육신청 버튼
		$("#requestOnLineBtn").click(function(){
			requestOnLine(false);
		});
		
		// OnLine 교육 자가승인 버튼
		$("#requestNapprovalBtn").click(function(){
			requestOnLine(true);
		});
		
		// OnLine 교육 변경 신청 버튼
		$("#changeOnLineBtn").click(function(){
			changeOnLine();
		});
		
		// OffLine 교육신청 버튼
		$("#requestOffLineBtn").click(function(){
			requestOffLine();
		});
		
		// OffLine 교육신청 변경 버튼
		$("#changeOffLineBtn").click(function(){
			changeOffLine();
		});
		
		// OnLine 교육신청 수정
		$("#changeOnLineFormBtn").click(function(){
			if( !$("input:radio[name='onLineRadio']").is(":checked")) {
				alert("교육변경 신청 대상을 선택하세요.");
				return false;
			}
			
			$("#requestOnLineBtn").hide();
			$("#changeOnLineBtn").show();
			// 탭전환
			selectEduChageValue();
		});
		
		// OffLine 교육신청 수정
		$("#changeOffLineFormBtn").click(function(){
			if( !$("input:radio[name='offLineRadio']").is(":checked")) {
				alert("교육변경 신청 대상을 선택하세요.");
				return false;
			}
			
			$("#requestOffLineBtn").hide();
			$("#changeOffLineBtn").show();
			// 탭전환
			switchTabs($("#tab2"), 'tab2');
		});
		
	});
	
	// onChange CategoryCode
	var CHANGE_CODE = function() {
		$("#COUR_CODE").lenth = 1;
		$("#COUR_CODE").val("");
		
		$("#GUBUN").val("4");
		$("#ORGA_CODE_1").val($("#ORGA_CODE").val());
		$("#CATA_CODE_1").val($("#CATA_CODE").val());
		$("#EDUC_YEAR_1").val($("#EDUC_YEAR").val());
		$("#COUR_CODE_1").val($("#COUR_CODE").val());
		
		getCategoryCode();
		
		if( $('#EDUC_YEAR').val() != "" && $('#ORGA_CODE').val() != "" && $('#CATA_CODE').val() != "" ) {
			$("#TDLINE_TEXT").text("");
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
				,"CATA_CODE" : $("#CATA_CODE_1").val()
				,"EDUC_YEAR" : $("#EDUC_YEAR_1").val()
				,"COUR_CODE" : $("#COUR_CODE_1").val()
				,"GUBUN" : "4"
			},
			async :false,
			success : function(response) {
				if(response.success){
					setCategoryOption(response.storeData)
				}
				else{
					alert("급여사유 조회시 오류가 발생하였습니다. " + response.message);
				}
		}
		});
	};
	
	// 교육과정 옵션 설정
	var setCategoryOption = function(jsonData) {
		$('#COUR_CODE').empty();
		$.each(jsonData, function (key, value) {
			$('#COUR_CODE').append('<option value=' + value.code + '>' + value.value + '</option>');
		});
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
							   "ORGA_CODE" : $("#ORGA_CODE").val()
							  ,"CATA_CODE" : $("#CATA_CODE").val()
							  ,"EDUC_YEAR" : $("#EDUC_YEAR").val()
							  ,"COUR_CODE" : $("#COUR_CODE").val()
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
                { title: "선택", name: "th1", align: "center", width: "5%",
                	itemTemplate: function(_, item) {
                        return $("<input name='courRadio'>")
                        	   .attr("type", "radio")
                        	   .on("click", function(e) {
                        		   $("#COUR_SCHE").val(item.COUR_SCHE);
                        		   $("#EDUC_BEGD").val(item.EDUC_BEGD);
                        		   $("#EDUC_ENDD").val(item.EDUC_ENDD);
                        		   $("#EDUC_COST").val(item.EDUC_COST);
                        		   $("#EDUC_TIME").val(item.EDUC_TIME);
                        		   $("#APPR_MARK").val(item.APPR_MARK);
                        		   $("#PASS_FLAG").val(item.PASS_FLAG);
                        		   $("#ESSE_FLAG").val(item.ESSE_FLAG);
                        		   $("#EMPL_FLAG").val(item.EMPL_FLAG);
                        		   $("#SEMI_FLAG").val(item.SEMI_FLAG);
                        	   });
                    }
                },
                { title: "차수", name: "COUR_SCHE", type: "text", align: "center", width: "15%" },
                { title: "교육기간", name: "EDUC_BEGD", type: "text", align: "center", width: "21%",
                	itemTemplate: function(value, storeData) {
                        return storeData.EDUC_BEGD + " ~ " + storeData.EDUC_ENDD;
                    }
                },
                { title: "교육비", name: "EDUC_COST", type: "number", align: "center", width: "16%",
                	itemTemplate: function(value, storeData) {
                        return value.format();
                    }
                },
                { title: "교육시간", name: "EDUC_TIME", type: "number", align: "center", width: "16%",
                	itemTemplate: function(value, storeData) {
                        return value.format();
                    }
                },
                { title: "필수여부",name: "ESSE_FLAG", align: "center", width: "8%",
                	itemTemplate: function(value, item) {
                        if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
                    }
                },
                { title: "고용보험", name: "EMPL_FLAG", align: "center", width: "8%",
                    itemTemplate: function(value, item) {
                    	if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
                    }
                },
                { title: "세미나과정", name: "SEMI_FLAG", align: "center", width: "8%",
                    itemTemplate: function(value, item) {
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
	
	var requestOnLine = function(self) {
		if( requestOnLineCheck() ) {
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			decisionerGridChangeAppLine(self);
			if(confirm(msg + "신청 하시겠습니까?")){
				$("#ORGA_NAME").val("LG사이버아카데미");
				$("#CATA_NAME").val($("#CATA_CODE option:selected").text());
				$("#COUR_NAME").val($("#COUR_CODE option:selected").text());
				
				var param = $("#eduForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				param.push({"name":"selfAppr", "value" : self});
				jQuery.ajax({
					type : 'POST',
					url : '/edu/requestOnLine.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
		    			if(response.success){
		    				alert("신청 되었습니다.");
		    				
		    				$("#EDUC_YEAR").val("").prop("disabled", false);
		    				$("#CATA_CODE").val("").prop("disabled", false);
		    				$("#COUR_CODE").val("").prop("disabled", false);

		    				// 초기화
		    				CHANGE_CODE();

		    				$("#ORGA_NAME").val("");
		    				$("#CATA_NAME").val("");
		    				
		    				$("#decisionerGrid").jsGrid("search");
		    				$("#curriculumGrid").jsGrid({"data":$.noop});
		    				
		    				$("#requestOnLineBtn").show();
		    				$("#changeOnLineBtn").hide();
		    			}else{
		    				alert("신청시 오류가 발생하였습니다. " + response.message);
		    			}
		    		}
				});
			} else {
				decisionerGridChangeAppLine(false);
			}
		};
	};
	
	var changeOnLine = function(){
		if( requestOnLineCheck() ) {
			if(confirm("정말 변경 하시겠습니까?")){
				$("#EDUC_YEAR").prop("disabled", false);
				$("#CATA_CODE").prop("disabled", false);
				$("#COUR_CODE").prop("disabled", false);
				$("#ORGA_NAME").val("LG사이버아카데미");
				$("#COUR_NAME").val($("#COUR_CODE option:selected").text());
				$("#CATA_NAME").val($("#CATA_CODE option:selected").text());
				
				var param = $("#eduForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'POST',
					url : '/edu/requestChangeOnLine.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
		    			if(response.success){
		    				$("#EDUC_YEAR").prop("disabled", true);
		    				$("#CATA_CODE").prop("disabled", true);
		    				$("#COUR_CODE").prop("disabled", true);
		    				alert("변경 신청 되었습니다.");
		    			}else{
		    				alert("변경 신청시 오류가 발생하였습니다. " + response.message);
		    			}
		    			$("#changeOnLineGrid").jsGrid("search");
		    			switchTabs($("#tab3"), 'tab3');
		    		}
				});
			}
		}
	};
	
	var requestOnLineCheck = function(){
		if(!checkNullField("eduForm")){
			return false;
		}
		if( !$("input:radio[name='courRadio']").is(":checked")) {
			alert("교육차수를 선택하세요.");
			return false;
		}
		
		//결재자 체크
		if( $("#RowCount").val() < 1 ){
            alert("결재자 정보가 없습니다.");
            return false;
        }
//         for ( i = 0 ; i<$("#RowCount").val()-1 ; i++ ){
//             val = $("#APPL_APPU_NUMB"+i).val();
//             if( val == "" || val == null || val == "00000000" ){ 
//                 alert("결재자 이름을 입력하세요.");
//                 return false;
//             }
//         }
//         for( i = 0; i < $("#RowCount").val()-1; i++ ){
//             for( j = 0; j < $("#RowCount").val()-1; j++){
//                 if( i != j ){
//                     if( eval($("#APPL_APPU_TYPE"+i).val() != '02' && $("#APPL_APPU_TYPE"+j).val() != '02' ) ){
//                         if( eval($("#APPL_PERNR"+i).val() == $("#APPL_PERNR"+j).val() ) ){
//                             alert("결재자가 중복 입력되었습니다.");
//                             return false;
//                         }
//                     }
//                 }
//             }
//         }

		return true;
	};
	
	// OffLine 교육신청 
	var requestOffLine = function(){
		if(confirm("신청 하시겠습니까?")){
			$("#requestOffLineCataName").val($("#requestOffLineCataCode option:selected").text());
			
			if( requestOffLineCheck() ) {
				jQuery.ajax({
					type : 'POST',
					url : '/edu/requestOffLine.json',
					cache : false,
					dataType : 'json',
					data : $('#eduRequestOffLineForm').serialize(),
					async :false,
					success : function(response) {
		    			if(response.success){
		    				alert("신청 되었습니다.");
		    				// 초기화
		    				$("#eduRequestOffLineForm").each(function() {
		    					this.reset();
		    				});
		    				
		    				$("#requestOffLineEducYear").prop("disabled", false);
		    				$("#requestOffLineCataCode").prop("disabled", false);
		    				
		    				$("#requestOffLineBtn").show();
		    				$("#changeOffLineBtn").hide();
		    				
		    			}else{
		    				alert("신청시 오류가 발생하였습니다. " + response.message);
		    			}
		    		}
				});
			};
		}
	};
	
	// OffLine 교육신청 변경
	var changeOffLine = function(){
		if( requestOffLineCheck() ){
			if(confirm("정말 수정 하시겠습니까?")){
				$("#requestOffLineEducYear").prop("disabled", false);
				$("#requestOffLineCataCode").prop("disabled", false);
				jQuery.ajax({
					type : 'POST',
					url : '/edu/requestChangeOffLine.json',
					cache : false,
					dataType : 'json',
					data : $('#eduRequestOffLineForm').serialize(),
					async :false,
					success : function(response) {
		    			if(response.success){
		    				$("#requestOffLineEducYear").prop("disabled", true);
		    				$("#requestOffLineCataCode").prop("disabled", true);
		    				alert("신청 되었습니다.");
		    			}else{
		    				alert("신청시 오류가 발생하였습니다. " + response.message);
		    			}
		    			$("#changeOffLineGrid").jsGrid("search");
		    			switchTabs($("#tab4"), 'tab4');
		    		}
				});
			}
		};
	};
	
	var requestOffLineCheck = function(){
		
		if(!checkNullField("eduRequestOffLineForm")){
			return false;
		}
		
		if(!checkNum($("#requestOffLineEducCost").val())){
			alert("교육비는 숫자만 입력하세요");
			return false;
		}
		if( !$("#requestOffLineEducTime").val() == "" ) {
			if(!checkNum($("#requestOffLineEducTime").val())){
				alert("교육시간은 숫자만 입력하세요");
				return false;
			}
		}
		
		if(!checkdate($("#inputDateFrom"))){
			return false;
		}
		if(!checkdate($("#inputDateTo"))){
			return false;
		}

		return true;
	}
	
	// OnLIne 교육변경 신청 grid
	$(function() {
		$("#changeOnLineGrid").jsGrid({
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
   						url : "/edu/getForChangeOnLineList.json",
   						dataType : "json"
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
           			title: "선택", name: "th1", align: "center", width: "4%",
           			itemTemplate: function(_, item) {
           				return $("<input name='onLineRadio' >")
           					   .attr("type", "radio")
           					   .on("click", function(e) {
           						   $("#changeOnLineRadioChk").val("Y");
           						   $("#ainfSeqn").val(item.AINF_SEQN);
           					       $("#changeOnLineAinfSeqn").val(item.AINF_SEQN);
           					   });
           			}
           		},
           		{ title: "년도", name: "EDUC_YEAR", type: "text", align: "center", width: "7%" },
           		{ title: "교육기관", name: "ORGA_NAME", type: "text", align: "center", width: "14%" },
           		{ title: "교육분야", name: "CATA_NAME", type: "text", align: "center", width: "14%" },
           		{ title: "교육과정", name: "COUR_NAME", type: "text", align: "center", width: "13%" },
           		{ title: "확정차수", name: "COUR_SCHE_C", type: "text", align: "center", width: "7%" },
           		{ title: "확정차수<br/>교육기간", name: "PERIOD_C", type: "text", align: "center", width: "14%" },
           		{ title: "변경차수", name: "COUR_SCHE", type: "text", align: "center", width: "7%" },
           		{ title: "변경신청중인<br/>차수교육기간", name: "EDUC_BEGD", type: "text", align: "center", width: "14%" 
           			,itemTemplate : function(_,item){
           				return item.EDUC_BEGD + "~" + item.EDUC_ENDD;
           			}
           		},
           		{ title: "필수여부", name: "ESSE_FLAG", type: "text", align: "center", width: "6%" 
           			,itemTemplate: function(value,item){
           				if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
           			}
           		}
       		]
		});
	});
	
	// OffLIne 교육변경 신청 grid
	$(function() {
		$("#changeOffLineGrid").jsGrid({
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
   						url : "/edu/getForChangeOffLineList.json",
   						dataType : "json"
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
           			title: "선택", name: "th1", align: "center", width: "6%",
           			itemTemplate: function(_, item) {
           				return $("<input name='offLineRadio'>")
           					   .attr("type", "radio")
           					   .on("click", function(e) {
           						   $("#requestOffLineEducYear").val(item.EDUC_YEAR).prop("disabled", true);
           						   $("#requestOffLineCataCode").val(item.CATA_CODE).prop("disabled", true);
           						   $("#requestOffLineCourName").val(item.COUR_NAME);
           						   $("#requestOffLineOrgaName").val(item.ORGA_NAME);
           						   $("#inputDateFrom").val(item.EDUC_BEGD);
           						   $("#inputDateTo").val(item.EDUC_ENDD);
           						   $("#requestOffLineEducCost").val(parseInt(item.EDUC_COST * 100));
           						   $("#requestOffLineEducTime").val(parseInt(item.EDUC_TIME));
           						   $("#requestOffLineCataName").val(item.CATA_NAME);
           						   $("#requestOffLineCourSche").val(item.COUR_SCHE);
           						   $("#requestOffLineOrgaCode").val(item.ORGA_CODE);
           					       $("#requestOffLineAinfSeqn").val(item.AINF_SEQN);
           					       $("#requestOffLineCourCode").val(item.COUR_CODE);
           					   });
           			}
           		},
           		{ title: "년도", name: "EDUC_YEAR", type: "text", align: "center", width: "10%" },
           		{ title: "교육과정", name: "COUR_NAME", type: "text", align: "center", width: "19%" },
           		{ title: "차수교육기간", name: "EDUC_BEGD", type: "text", align: "center", width: "20%", 
           			itemTemplate: function(value,item){
           				return value + "~" + item.EDUC_ENDD;
           			}
           		},
           		{ title: "교육비", name: "EDUC_COST", type: "number", align: "center", width: "15%",
           			itemTemplate: function(value,item){
           				return parseInt(value*100).format();
           			}
           		},
           		{ title: "교육기관", name: "ORGA_NAME", type: "text", align: "center", width: "20%" },
           		{ title: "필수여부", name: "ESSE_FLAG", type: "text", align: "center", width: "8%",
           			itemTemplate: function(value,item){
           				if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
           			}
           		}
       		]
		});
	});
	
	var selectEduChageValue = function(){
		jQuery.ajax({
			type : 'GET',
			url : '/edu/getDetailForChangeOnLine.json',
			cache : false,
			dataType : 'json',
			data : $('#changeOnLineForm').serialize(),
			async :false,
			success : function(response) {
    			if(response.success){
    				$("#EDUC_YEAR").val(response.storeData.EDUC_YEAR).prop("disabled", true);
    				$("#ORGA_NAME").val(response.storeData.ORGA_NAME);
    				$("#CATA_CODE").val(response.storeData.CATA_CODE).prop("disabled", true);
    				CHANGE_CODE();
    				$("#CATA_NAME").val(response.storeData.CATA_NAME);
    				$("#COUR_CODE").val(response.storeData.COUR_CODE).prop("disabled", true);
    				$("#curriculumGrid").jsGrid("search");
    				
    			    $("#COUR_SCHE_CHECK").val(response.storeData.COUR_SCHE);
    			    $("#ORGA_CODE").val(response.storeData.ORGA_CODE);
    				
    				switchTabs($("#tab1"), 'tab1');
    			}else{
    				alert("조회시 오류가 발생하였습니다. " + response.message);
    			}
    		}
		});
	};
	
	// 교육이수 현황 그리드
	$(function() {
	    $("#finishedGrid").jsGrid({
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
   						url : "/edu/getFinishedList.json",
   						dataType : "json"
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
	        	{ title: "교육분야", name: "MC_STEXT", type: "text", align: "left", width: "10%" },
	        	{ title: "과정명", name: "TTEXT", type: "text", align: "left", width: "24%" },
	            { title: "교육기관", name: "MC_STEXT1", type: "text", align: "left", width: "24%" },
	            { title: "교육기간", name: "PERIOD", type: "text", align: "center", width: "18%" },
	            { title: "시간", name: "ILSU", type: "number", align: "center", width: "6%" 
	            	,itemTemplate: function(value, item) {
	            		if(value.format() > 0 )
	            			return value.format();
	            		else
	            			return "";
                    },
	            },
	            { title: "이수", name: "FLAG1", type: "number", align: "center", width: "6%" },
	            { title: "평가", name: "PYONGGA", type: "number", align: "center", width: "6%" },
	            { title: "진급필수", name: "FLAG2", type: "number", align: "center", width: "6%"  
	            	,itemTemplate: function(value, item) {
	            		if(value == "N" )
	            			return "";
	            		else
	            			return value;
                    },
	            }
	        ]
	    });
	});
	
</script>
