<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.C.*" %>
<%@ page import="hris.C.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%
	WebUserData user = (WebUserData)session.getValue("user");
	// 1. 교육년도
	String  year  = DataUtil.getCurrentYear(); // 현재년도
	int startYear = Integer.parseInt( (user.e_dat03).substring(0,4) );
	int endYear = Integer.parseInt( DataUtil.getCurrentYear() );
	if( startYear < 2004 ){
		startYear = 2004;
	}
	if( ( endYear - startYear ) > 10 ){
		startYear = endYear - 10;
	}
	Vector CodeEntity_vt = new Vector();
	for( int i = startYear ; i <= endYear ; i++ ){
		CodeEntity entity = new CodeEntity();
		entity.code  = Integer.toString(i);
		entity.value = Integer.toString(i);
		CodeEntity_vt.addElement(entity);
	}
	String searchYearValue = (String)request.getAttribute("iYear");
	if(searchYearValue == null || "".equals(searchYearValue)){
		searchYearValue = year;
	}
%>
	<!--// Page Title start -->
	<div class="title">
		<h1>교육이력조회</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">기타관리</a></span></li>
				<li class="lastLocation"><span><a href="#">교육이력조회</a></span></li>
			</ul>
		</div>
	</div>
	<!--// Page Title end -->
	<!--------------- layout body start --------------->

	<!--------------- layout body start --------------->	
	<div class="tableArea">
		<h2 class="subsubtitle">교육이력조회</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>교육이력조회</caption>
			<colgroup>
				<col class="col_15p" />
				<col class="col_85p" />
			</colgroup>
			<tbody>
				<tr>
					<th><label for="input_select01">해당년월</label></th>
					<td>
						<select class="w70" id="iYear" name="iYear"> 
							<%= WebUtil.printOption(CodeEntity_vt, searchYearValue )%>
						</select>
						<a class="icoSearch" id="search" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
					</td>
				</tr>
			</tbody>
			</table>
		</div>
	</div>
	
	<div class="tableArea tdLine">
		<h2 class="subsubtitle">조회 년도 교육예산(전문직무_전문기술직)</h2>
		<div class="clear"></div>
			<div id="eduHistorySum"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
	</div>
	
	<div class="listArea" style="width:1350px">	
		<h2 class="subtitle withButtons">교육이력(전체)</h2>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a href="#" id="excelDownloadBtn"><span>Excel Download</span></a></li>
			</ul>
		</div>
		<div class="clear"></div>
		<div id="eduHistoryGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
		
		<div class="totalArea">
			<strong>교육비 총계</strong>
			<input class="inputMoney readOnly w100" type="text" id="returnSUM" name="returnSUM" redonly />
		</div>
	</div>
			<!--------------- layout body start --------------->
<script>
	$(document).ready(function(){
		$("#eduHistoryGrid").jsGrid('search');
		$("#eduHistorySum").jsGrid('search');
	});
	
	$("#excelDownloadBtn").click(function(){
		var $form = $('<form></form>');
		$form.attr('action', '/excel/genEduHistoryDataExcel');
		$form.attr('method', 'post');
		$form.appendTo('body');
		
		var iYear = $('<input name="iYear" type="hidden" value="'+$("#iYear option:selected").val()+'">');
		
		$form.append(iYear);
		$form.submit();
	});
	
	$("#search").click(function(){
		$("#eduHistoryGrid").jsGrid('search');
		$("#eduHistorySum").jsGrid('search');
	});
	
	$("#eduHistorySum").jsGrid({
		height: "auto",
		width: "100%",
		autoload: false,
		controller : {
			loadData : function() {
				var d = $.Deferred();
				$.ajax({
					type : "GET",
					url : '/edu/getEduHistorySum.json',
					dataType : "json",
					data : {
						"iYear" : $("#iYear").val()
					}
				}).done(function(response) {
					if(response.success) 
						d.resolve(response.storeData);
					else
						alert("조회시 오류가 발생하였습니다. " + response.message);
				});
				return d.promise();
			}
		},
		fields : [ 
				 { name : "STEXT", title : "소속", align : "center",  type: "text", width: '30%'},
				 { name : "ZYESA", title : "교육예산", align : "right",  type: "text", width: '30%',
						 itemTemplate: function(value, storeData) {
							 return value.format();
						 }
				},
				 { name : "UYESA", title : "사용금액", align : "right",  type: "number", width: '30%',
						 itemTemplate: function(value, storeData) {
							 return value.format();
						 }
				 }
			 ]
	});
	
	$(function() {
		$("#eduHistoryGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: true,
			pageSize: 20,
			pageButtonCount: 20,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/edu/getEduHistoryList.json",
						dataType : "json",
						data : {
							"iYear" : $("#iYear").val()
						}
					}).done(function(response) {
						if(response.success){
							d.resolve(response.storeData);
							$("#returnSUM").val(response.returnSUM.format());
						}else{
							alert("조회시 오류가 발생하였습니다. " + response.message);
						}
					});
					return d.promise();
				}
			},
			fields: [
						{ title: "사번", name: "PERNR", type: "text", align: "center", width: "4%" },
						{ title: "이름", name: "ENAME", type: "text", align: "center", width: "6%" },
						{ title: "소속", name: "ORGTX", type: "text", align: "center", width: "8%" },
						{ title: "직위", name: "TIT01", type: "text", align: "center", width: "4%" },
						{ title: "직책", name: "TIT02", type: "text", align: "center", width: "4%" },
						{ title: "시작일", name: "BEGDA", type: "text", align: "center", width: "6%" },
						{ title: "종료일", name: "ENDDA", type: "text", align: "center", width: "6%" },
						{ title: "교육기관", name: "ORGA_NAME", type: "text", align: "center", width: "10%" },
						{ title: "교육분야", name: "CATA_NAME", type: "text", align: "center", width: "6%" },
						{ title: "교육년도", name: "EDUC_YEAR", type: "text", align: "center", width: "4%" },
						{ title: "교육과정", name: "COUR_NAME", type: "text", align: "left", width: "25%" },
						{ title: "차수", name: "COUR_SCHE", type: "text", align: "center", width: "3%" ,
							 itemTemplate: function(value, storeData) {
								 return value.format();
							 }
						 },
						{ title: "교육비", name: "EDUC_COST", type: "text", align: "right", width: "7%",
							 itemTemplate: function(value, storeData) {
								 return value.format();
							 }
						 },
						{ title: "교육시간", name: "EDUC_TIME", type: "text", align: "center", width: "4%" ,
							 itemTemplate: function(value, storeData) {
								 return value.format();
							 }
						 },
			]
		});
	});
</script>