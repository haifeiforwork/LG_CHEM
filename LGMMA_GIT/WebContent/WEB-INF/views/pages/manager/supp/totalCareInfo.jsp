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
	WebUserData user = (WebUserData)session.getValue("managedUser");
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

<!--// Tab3 start -->
<div class="tabUnder tab3">
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
		if($(".layerWrapper").length){
		};
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
						url : "/manager/supp/getTotalCareList.json",
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
	var TotalCareClient = function() {
		if(TotalCareClientCheck()){
			if(confirm("신청 하시겠습니까?")){
				$("#totalCareBtn").prop("disabled", true);
				$("#totalCareForm #RowCount").val($("#decisionerGrid").jsGrid("dataCount"));
				if( TotalCareClientCheck() ) { 
					var param = $("#totalCareForm").serializeArray();
					$("#decisionerGrid").jsGrid("serialize", param);
					jQuery.ajax({
						type : 'POST',
						url : '/manager/supp/requestTotalCare.json',
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
								$("#totalCare").jsGrid("search");
							}else{
								alert("신청시 오류가 발생하였습니다. " + response.message);
							}
							$("#totalCareBtn").prop("disabled", false);
						}
					});
				}
			}
		}
	}
	</script>
