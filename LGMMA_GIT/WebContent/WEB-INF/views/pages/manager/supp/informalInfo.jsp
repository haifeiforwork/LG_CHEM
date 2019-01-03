<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E25InfoJoin.*" %>
<%@ page import="hris.E.E25InfoJoin.rfc.* "%>

<%
    Vector  InfoListData_vt = (Vector)request.getAttribute("InfoListData_vt");
%>

<!--// Page Title start -->
<div class="title">
	<h1>인포멀</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">인포멀</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab2 start -->
<div class="tabUnder tab2">
<form id="secessionForm" name="secessionForm" method="post">
<input type="hidden" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" name="BEGDA0" id="BEGDA0" />
<input type="hidden" value="" name="STEXT0" id="STEXT0" />
<input type="hidden" value="" name="BETRG0" id="BETRG0" />
<input type="hidden" value="" name="ENAME0" id="ENAME0" />
<input type="hidden" value="" name="APPL_DATE0" id="APPL_DATE0" />
<input type="hidden" value="" name="MGART0" id="MGART0" />
<input type="hidden" value="" name="LGART0" id="LGART0" />
<input type="hidden" value="" name="PERN_NUMB0" id="PERN_NUMB0" />
<input type="hidden" value="" name="TITEL0" id="TITEL0" />
<input type="hidden" value="" name="USRID0" id="USRID0" />
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">인포멀 가입내역</h2>
		<div class="clear"></div>
		<div id="informalList"></div>
	</div>	
	<!--// list end -->
	</form>
</div>
<!--// Tab2 end -->	
<!--------------- layout body end --------------->

<script type="text/javascript">
	$("#tab2").click(function(){
		$("#informalList").jsGrid("search");
	});
	
	// 인포멀 가입내역 리스트
	$(function() {
		$("#informalList").jsGrid({
			height: "auto",
			width: "100%",
			paging: true,
			autoload: true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/manager/supp/getInformalList.json",
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
				{ title: "가입일", name: "BEGDA", type: "text", align: "center", width: "19%" },
				{ title: "인포멀회", name: "STEXT", type: "text", align: "center", width: "26%" },
				{ title: "회비(원)", name: "BETRG", type: "text", align: "center", width: "18%" ,
					itemTemplate: function(value,storeData) {
						return value.format();
					}
				},
				{ title: "간사", name: "ENAME", type: "text", align: "center", width: "18%" ,
					itemTemplate: function(value,storeData) {
						return value + " " + storeData.TITEL;
					}
				},
				{ title: "연락처", name: "USRID", type: "text", align: "center", width: "19%" },
			]
		});
	});
</script>