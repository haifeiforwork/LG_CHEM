<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E15General.rfc.*" %>
<%@ page import="hris.E.E15General.*" %>

<%
	WebUserData user = (WebUserData)session.getValue("user");
	E15GeneralData     gdata          = (E15GeneralData)request.getAttribute("e15general");
	Vector             Area_vt        = (Vector)request.getAttribute("Area_vt");
	E15GeneralFlagData flagdata       = (E15GeneralFlagData)request.getAttribute("E15GeneralFlagData");
%>

<form name="form1" id="form1" method="post" action="">
<!-- contents start -->
	<!--// Page Title start -->
	<div class="title">
		<h1>종합검진</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">My Info</a></span></li>
				<li><span><a href="#">복리후생</a></span></li>
				<li class="lastLocation"><span><a href="#">종합검진</a></span></li>
			</ul>
		</div>
	</div>
</form>
<!--// Page Title end -->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" name="tab1" onclick="switchTabs(this, 'tab1');" class="selected">종합검진 안내</a></li>
<%
if( user.e_werks.equals("AA00") ) {//서울
	if(Long.parseLong(DataUtil.getCurrentDate())>=Long.parseLong("20180312") && Long.parseLong(DataUtil.getCurrentDate())<=Long.parseLong("20180630")) { //20160429 서울 종합검진 수정요청
%>
		<li><a href="#" id="tab2" name="tab2" onclick="switchTabs(this, 'tab2');">종합검진 신청</a></li>
<%
	} 
%>
<%
} else {  //여수
	if(Long.parseLong(DataUtil.getCurrentDate())>=Long.parseLong("20180402") && Long.parseLong(DataUtil.getCurrentDate())<=Long.parseLong("20181116")) {
%>
		<li><a href="#" id="tab2" name="tab2" onclick="switchTabs(this, 'tab2');">종합검진 신청</a></li>
<%
	}
}
%>
		<li><a href="#" id="tab3" name="tab3" onclick="switchTabs(this, 'tab3');">종합검진 실시내역</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
	<div class="checkupBox">
	<%
if( user.e_werks.equals("AA00") ) {//사무직(서울)
	%>	
		<img src="/web-resource/images/e15Guide_S.gif">
<%
} else {
%>
		<img src="/web-resource/images/e15Guide.gif">
<%
}
%>

	</div>
</div>

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<div id="dataCount">
		<form id="totalCareForm" name="totalCareForm" >
		<input type="hidden" id="EZAM_DATE"  name="EZAM_DATE" value=""/>
		<input type="hidden" id="GUEN_NAME"  name="GUEN_NAME" value=""/>
		<input type="hidden" id="HOSP_NAME"  name="HOSP_NAME" value=""/>
		<input type="hidden" id="SCOPE_APPLY"  name="SCOPE_APPLY"  value="">
		<input type="hidden" name="M_FLAG"  id="M_FLAG"   value="">
		<input type="hidden" name="F_FLAG"  id="F_FLAG"   value="">
		<input type="hidden" name="ME_FLAG" id="ME_FLAG"  value="">
		<input type="hidden" name="WI_FLAG" id="WI_FLAG"  value="">
		<input type="hidden" name="ME_CODE" id="ME_CODE"  value="">
		<input type="hidden" name="WI_CODE" id="WI_CODE"  value="">
	
		<!--// Table start -->
		<div class="tableArea">
			<h2 class="subtitle">종합검진 신청</h2>
			<div class="table">
				<table class="tableGeneral">
				<caption>종합검진 신청</caption>
				<colgroup>
					<col class="col_15p"/>
					<col class="col_35p"/>
					<col class="col_15p"/>
					<col class="col_35p"/>
				</colgroup>
				<tbody>
				<tr>
					<th><label for="inputText01-1">신청일</label></th>
					<td class="tdDate">
						<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
					</td>
					<th><label for="inputText01-2">검진년도</label></th>
					<td class="tdDate">
						<input class="readOnly" type="text" name="EXAM_YEAR" value="<%= DataUtil.getCurrentYear() %>" id="EXAM_YEAR" readonly />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="inputText01-3">구분</label></th>
					<td>
						<select name="GUEN_CODE" id="GUEN_CODE" vname="구분" required>
							<option value="">-------선택-------</option>
						</select>
					</td>
					<th><span class="textPink">*</span><label for="inputDate01">검진희망일자 </label></th>
					<td class="tdDate">
						<input type="text" class="datepicker" vname="검진희망일자" required id="to_date" name="to_date"/>
					</td>
				</tr>
				<tr>
					<th><label for="inputText01-5">검진지역</label></th>
					<td>
	                    <input type="hidden" id="AREA_CODE" name="AREA_CODE" value="">
						<input class="readOnly" type="text" name="AREA_NAME" value="" id="AREA_NAME" readonly />
					</td>
					<th><span class="textPink">*</span><label for="inputText01-6">검진희망병원 </label></th>
					<td>
						<select name="HOSP_CODE" class="input03" id="HOSP_CODE" vname="검진희망병원" required>
							<option value="">-------선택-------</option>
	<%= WebUtil.printOption((new HospCodeRFC()).getHospCode(user.empNo)) %>
						</select>
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="inputText01-7">전화(휴대폰)</label></th>
					<td>
						<input class="" type="text" name="ZHOM_NUMB" value="<%= user.e_cell_phone %>" id="ZHOM_NUMB" vname="전화(휴대폰)" required/>
					</td>
					<th><label for="inputText01-8">전화(회사)</label></th>
					<td>
						<input class="readOnly" type="text" name="COMP_NUMB" value="<%= user.e_phone_num %>" id="COMP_NUMB" readonly />
					</td>
				</tr>
	<%
		if( user.e_werks.equals("AA00") ) {
	%>
				<tr>
					<th><label for="inputText01-9">소화기 검사항목<br>본인 선택사항<font color="#0000FF"><b>*</b></font></td>
					<td class="td02" colspan="3"> 
						<input type="radio" name="EXAM_GUEN" value="1" checked>위내시경&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="EXAM_GUEN" value="2">위 수면내시경 (일정금액 본인부담함)&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="EXAM_GUEN" value="3">위투시X-선검사
					</td>
				</tr>
	<%
		}
	%>
				<tr>
					<th><label for="inputText01-9">대장내시경 여부</label></th>
					<td colspan="3">
						<input type="checkbox" id="SCOPE_APPLY_CHECK" name="SCOPE_APPLY_CHECK" >
					</td>
				</tr>
				<tr>
					<th><label for="inputText01-9">선택검사 및<br>기타요구사항</label></th>
					<td colspan="3">
						<input type="text" class="wPer" name="REQUIRE" id="REQUIRE" maxlength="100" />
					</td>
				</tr>
				</tbody>
				</table>
			</div>
		</div>
		<!--// Table end -->
		<!--// list start -->
		<!--// list end -->
		</form>
		<div class="listArea" id="decisioner"></div>
		<div class="buttonArea">
			<ul class="btn_crud">
			<c:if test="${selfApprovalEnable == 'Y'}">
				<li><a href="javascript:TotalCareClient(true);" id="requestNapprovalBtn"><span>자가승인</span></a></li>
			</c:if>
				<li><a class="darken" id="totalCareBtn" href="javascript:TotalCareClient(false);"><span>신청</span></a></li>
			</ul>
		</div>
	</div>
	<div id="dataCount2">
		<div class="errorArea">
			<div class="errorMsg">	
				<div class="errorImg"><!-- 에러이미지 --></div>
				<div class="alertContent">
					<p>올해 종합검진 대상자가 아닙니다.</p>
				</div>
			</div>
		</div>
	</div>
	<div id="dataCount3">
		<div class="errorArea">
			<div class="errorMsg">	
				<div class="errorImg"><!-- 에러이미지 --></div>
				<div class="alertContent">
					<p>검진지역이 등록되어 있지 않습니다.</p>
				</div>
			</div>
		</div>
	</div>
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 Lnodisplay">
	<!--// list start -->
	<div class="listArea">	
		<h2 class="subtitle">종합검진 실시내역</h2>
		<div id="totalCareDetail" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>	
	</div>
</div>
<!--// Tab3 end -->
<!--------------- layout body end --------------->
<script type="text/javascript">

	$(document).ready(function(){
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=04&gridDivId=decisionerGrid');
		$("#tab2").click(function(){
			totalCareData();
		});
	});
	
	var totalCareData = function(){
		jQuery.ajax({
			type : 'GET',
			url : '/supp/getTotalCareData.json',
			cache : false,
			dataType : 'json',
			async :false,
			success : function(response) {
				if(response.success){
					var gdata =  response.gdata;
					var entity =  response.entity;
					var flagdata =  response.flagdata;
					
					$("#M_FLAG").val(gdata.M_FLAG);
					$("#F_FLAG").val(gdata.F_FLAG);
					$("#ME_FLAG").val(flagdata.ME_FLAG);
					$("#WI_FLAG").val(flagdata.WI_FLAG);
					$("#ME_CODE").val(flagdata.ME_CODE);
					$("#WI_CODE").val(flagdata.WI_CODE);
					$("#AREA_CODE").val(entity.code);
					$("#AREA_NAME").val(entity.value);
					checkGuen();
				}else{
					alert("조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	}
	var checkGuen = function(){
		if($("#M_FLAG").val()=="N" && $("#F_FLAG").val()=="N"){
			$("#dataCount").hide();
			$("#dataCount2").show();
			$("#dataCount3").hide();
		}else{
			$("#dataCount").show();
			$("#dataCount2").hide();
			$("#dataCount3").hide();
		}
		if($("#AREA_CODE").val()=="" && $("#AREA_NAME").val()==""){
			$("#dataCount").hide();
			$("#dataCount2").hide();
			$("#dataCount3").show();
		}else{
			$("#dataCount").show();
			$("#dataCount2").hide();
			$("#dataCount3").hide();
		}
		
		if($("#M_FLAG").val()=="Y"){
			$("#GUEN_CODE").append('<option value= "0001" >'+ "본인" +'</option>');
		}
		
		if($("#F_FLAG").val()=="Y"){
			$("#GUEN_CODE").append('<option value= "0002" >'+ "배우자" +'</option>');
		}
	};
	
	$("#GUEN_CODE").change(function(){
		if( $("#GUEN_CODE").val() == "0002"){
			if($("#F_FLAG").val() == "N"){
				alert("사번 <%= user.empNo %> 의 배우자는 해당년도의 검진대상자가 아닙니다.");
				totalCareForm.GUEN_CODE[0].selected = true;
			}
		}
	});
	
	//종합검진 실시내역
	$(function() {
		$("#totalCareDetail").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/supp/getTotalCareList.json",
						dataType : "json",
					}).done(function(response) {
						if(response.success){
							d.resolve(response.storeData);
						}else{
							alert("조회시 오류가 발생하였습니다. " + response.message);
						}
					});
					return d.promise();
				}
			},
			fields: [
				{ title: "검진년도", name: "EXAM_YEAR", type: "text", align: "center", width: "10%" },	
				{ title: "구분", name: "GUEN_NAME", type: "text", align: "center", width: "20%" },
				{ title: "검진일자", name: "REAL_DATE", type: "text", align: "center", width: "%20" 
					,itemTemplate: function(value, storeData) {
						return value == "0000.00.00" ? (storeData.BEGDA == "0000.00.00" ? "" : storeData.BEGDA ) :  value;
					}
				},
				{ title: "검진지역", name: "AREA_NAME", type: "text", align: "center", width: "20%" },
				{ title: "검진병원", name: "HOSP_NAME", type: "text", align: "center", width: "30%" }
			]
		});
	});
	
	// 종합검진 신청 validation
	var TotalCareClientCheck = function() {
		
		if(!checkNullField("totalCareForm")){
			return false;
		}
		
		if(!checkdate($("#to_date"))){
			return false;
		} 
		
		var guencode =  $("#GUEN_CODE").val();
		var mecode   =  $("#ME_CODE").val();
		var wicode   =  $("#WI_CODE").val();
		
		if(guencode == mecode || guencode == wicode ) {
			alert("이미 신청하셨습니다.")
			return false;
		}
		
		var date_from  = $("#totalCareForm #BEGDA").val().replace(/\./g,'');
		var date_to    = $("#totalCareForm #to_date").val().replace(/\./g,'');
		
		def  = dayDiff(date_from,date_to);
		if( def < 0 ) {
			alert("검진희망일자가 신청일의 이전 일자 입니다.");
			return false;
		}
		
		//RFC에 해당하는 데이터들을 넘겨준다.
		if ($("#SCOPE_APPLY_CHECK").is(':checked')) {
			$("#SCOPE_APPLY").val("X");
		}else{
			$("#SCOPE_APPLY").val("");
		} 
		
		$("#EZAM_DATE").val($("#to_date").val());
		$("#GUEN_NAME").val($("#GUEN_CODE option:selected").text());
		$("#HOSP_NAME").val($("#HOSP_CODE option:selected").text()); 
		
		return true;
	}
	
	// 종합검진 신청
	var TotalCareClient = function(self) {
		if(TotalCareClientCheck()){
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			decisionerGridChangeAppLine(self);
			if(confirm(msg + "신청 하시겠습니까?")){
				$("#totalCareBtn").prop("disabled", true);
				$("#requestNapprovalBtn").prop("disabled", true);
				$("#totalCareForm #RowCount").val($("#decisionerGrid").jsGrid("dataCount"));
				if( TotalCareClientCheck() ) { 
					var param = $("#totalCareForm").serializeArray();
					$("#decisionerGrid").jsGrid("serialize", param);
					param.push({"name":"selfAppr", "value" : self});
					jQuery.ajax({
						type : 'POST',
						url : '/supp/requestTotalCare.json',
						cache : false,
						dataType : 'json',
						data : param,
						async :false,
						success : function(response) {
							if(response.success){
								alert("신청 되었습니다.");
								// 초기화
								$("#GUEN_CODE").val("");
								$("#AREA_NAME").val("");
								$("#HOSP_CODE").val("");
								$("#ZHOM_NUMB").val("");
								$("#COMP_NUMB").val("");
								$("#SCOPE_APPLY_CHECK").val("");
								$("#to_date").val("");
								$("#REQUIRE").val("");
								$("#totalCare").jsGrid("search");
							}else{
								alert("신청시 오류가 발생하였습니다. " + response.message);
							}
							$("#totalCareBtn").prop("disabled", false);
							$("#requestNapprovalBtn").prop("disabled", false);
						}
					});
				}
			} else {
				decisionerGridChangeAppLine(false);
			}
		}
	}
	</script>
