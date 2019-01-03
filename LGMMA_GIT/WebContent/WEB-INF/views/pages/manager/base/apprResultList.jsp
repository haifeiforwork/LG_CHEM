<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>

<form name="form1" method="post" action="">

	<!--// Page Title start -->
	<div class="title">
		<h1>평가결과</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">My Info</a></span></li>
				<li><span><a href="#">개인인적사항</a></span></li>
				<li class="lastLocation"><span><a href="#">평가결과</a></span></li>
			</ul>						
		</div>
	</div>
	<!--// Page Title end -->
	<div class="tableComment">
	<p><span class="bold">개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며, <br/>이를 위반시에는
    	취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려드립니다.</span></p>
	</div>
	<br>
	<!--------------- layout body start --------------->	
	<!--// list start -->
	<div class="listArea">	
		<h2 class="subtitle">나의 평가 결과</h2>
		<div id="addListGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
		<script type="text/javascript">
			$(function() {
				$("#addListGrid").jsGrid({
					height: "auto",
	                width: "100%",
	                sorting: true,
	                paging: true,
	                autoload: true,
	
					controller : {
						loadData : function() {
							var d = $.Deferred();
	
							$.ajax({
								type : "GET",
								url : "/manager/base/getApprResultList.json",
								dataType : "json"
							}).done(function(response) {
								d.resolve(response.storeData);
								if(response.success)
									d.resolve(response.storeData);
				    			else
				    				alert("조회시 오류가 발생하였습니다. " + response.message);
							});
							return d.promise();
						}
					},
	
					fields : [ { name : "YEAR1", title : "년도",     align : "center", type : "text", width: "10%"}, 
					           { name : "ORGTX", title : "근무부서",  align : "left",   type : "text", width: "35%"},
					           { name : "PTEXT", title : "사원구분",  align : "center", type : "text", width: "15%"},
					           { name : "TITEL", title : "직위",     align : "center", type : "text", width: "15%"},
					           { name : "TRFGR", title : "직급",     align : "center", type : "text", width: "15%"},
					           { name : "RTEXT1", title : "평가결과", align : "center", type : "text", width: "10%"} 
					         ]
				});
			});
		</script>
	</div>
	<!--// list end -->	
	<!--------------- layout body start --------------->

</form>

