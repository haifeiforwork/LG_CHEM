<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% 
	String CurrentYear = DataUtil.getCurrentYear();
	String CurrentMonth = DataUtil.getCurrentMonth();
%>
<html>
<head>
<title>LG MMA</title>
<!-- basic -->
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_jquery.css" />
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-1.9.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-ui-1.10.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/common.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/pdfobject.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
	
	$(".plControl").hide();
	//search
	$(".darken").on( "click", function() {
		search();
	});
	
	$(".prev").on( "click", function() {
		searchMonth('prev');
	});
	
	$(".next").on( "click", function() {
		searchMonth('next');
	});
	
	$(".this").on( "click", function() {
		searchMonth('this');
	});
	
	var searchMonth = function(gb){
		
		var year = 	$("#I_KJAHR").val();
		var month = $("#I_MONAT").val();
		
		var changemonth = Number(month);
		if(gb=="this") {
			year = "<%=CurrentYear%>";
			changemonth = "<%=CurrentMonth%>";
		} else {
			if(gb=="prev") {
				changemonth = changemonth-1;
			} else if(gb=="next") {
				changemonth = changemonth+1;
			}
				
			if(changemonth==0){
				year = Number(year)-1;
				changemonth = 12;
			} else if(changemonth==13) {
				year = Number(year)+1;
				changemonth = 1;
			}
			
			if(changemonth<10) {
				changemonth = "0"+changemonth;
			}
		}
		
		$("#I_KJAHR").val(year);
		$("#I_MONAT").val(changemonth);
		search();
	}
	
	var search = function(){
		$(".calendar tbody").html("");
		$(".darken").off("click");
		var paramArr = $("#form1").serializeArray();
		jQuery.ajax({
			type : 'POST',
			url : '/work/getWorkSchedule.json',
			cache : false,
			dataType : 'json',
			data : paramArr,
			async :false,
			success : function(response) {
    			if(response.success){
    				setDetail(response.storeData)
    			}else{
    				alert("조회오류");
    			}
    			
    			$(".darken").on("click", function(){search();});
    		}
		});
		$(".plControl").show();
	}
	
	var setDetail = function(storeData){
		$(".plThis").html("");
		$(".calendar tbody").html("");
		
		var htm = "";
		var td=0;
		
		for(var i=0;i<storeData.length;i++){
			var data = storeData[i];
			if(data.DAY=="월"){
				htm = htm + "<tr>";
				td = 1;
			} else if(data.DAY=="화") {
				td = 2;
			} else if(data.DAY=="수") {
				td = 3;
			} else if(data.DAY=="목") {
				td = 4;
			} else if(data.DAY=="금") {
				td = 5;
			} else if(data.DAY=="토") {
				td = 6;
			} else if(data.DAY=="일") {
				td = 7;
			}
			//첫번째 td 추가하기
			if(i==0) {
				if(td>1) htm = htm + "<tr>";
				for(var j=1;j<td;j++){
					htm = htm + "<td></td>";
				}
			}
			
			var clsNm = "";
			
			if(data.DAY == "토") clsNm = "cldrSat";
			if(data.DAY == "일") clsNm = "cldrSun";
			//휴일
			if(data.TTPOG == "1") clsNm = "cldrHoliday";
			var curDate = "";
			if(data.DATE == '<%=WebUtil.printDate(DataUtil.getCurrentDate(), ".")%>') curDate = " class=\"clToday\"";
			var dd = data.DATE.substr(8,11);
			
			htm = htm + "<td"+curDate+"><p class=\""+clsNm+"\">"+ Number(dd) +"</p><p class=\"cldr\">"+ data.TPROG + "<br>(" + data.TTEXT+")</p></td>";
			
			if(data.DAY=="일") htm = htm+"</tr>";
			
			//마지막 td 추가하기
			if(i==storeData.length-1) {
				for(var k=7;k>td;k--){
					htm = htm + "<td></td>";
				}
				
				if(td<7) htm = htm+"</tr>";
			}
		}

		$(".calendar tbody").html(htm);
		var year = 	$("#I_KJAHR").val();
		var month = $("#I_MONAT").val();
		$(".plThis").html(year+". "+month);
	}
	
	$(".darken").trigger('click');
});

</script>
</head>
<body>
<div class="layerContainer">
<!--// Planner start -->
<div class="planner">
	<form id="form1" name="form1">
	<div class="plMonth">
		<div class="plSearch">
			<select id="I_KJAHR" name="I_KJAHR" class="w80">
			<%
				int curYear = Integer.parseInt(CurrentYear);
				for(int i=curYear-5;i<curYear+6;i++){
			%>
				<option value="<%=String.valueOf(i) %>" <%if(i==curYear){%>selected<% } %>><%=String.valueOf(i) %> 년</option>
			<% } %>
			</select>
			<select id="I_MONAT" name="I_MONAT" class="w60">
		   <%
				int curMonth = Integer.parseInt(CurrentMonth);
				for(int i=1;i<13;i++){
					String Mnth = String.valueOf(i);
					if(i<10) Mnth =  "0"+Mnth;
			%>
				<option value="<%=Mnth %>" <%if(i==curMonth){%>selected<% } %>><%=String.valueOf(i) %> 월</option>
			<% } %>
			</select>
			<span class="btn_mdl"><a class="darken" href="#"><span>검색</span></a></span>
		</div>
		<div class="plThis"></div>
		<div class="plControl">
			<a href="#" class="prev"><img src="../web-resource/images/ico/ico_prev_page.gif" alt="이전"/><span>이전달</span></a>
			<a href="#" class="this"><span>이번달</span></a>
			<a href="#" class="next"><span>다음달</span><img src="../web-resource/images/ico/ico_next_page.gif" alt="다음" /></a>
		</div>
		<div class="clear"> </div>
	</div>
	</form>
	<div id="detailAreaDiv">
	</div>
	<table class="calendar">
		<thead class="cldrHeader">
			<tr>
				<th><p>월</p></th>
				<th><p>화</p></th>
				<th><p>수</p></th>
				<th><p>목</p></th>
				<th><p>금</p></th>
				<th><p class="cldrSat">토</p></th>
				<th><p class="cldrSun">일</p></th>
			</tr>
		</thead>
		<tbody class="cldrDates oneLine">

		</tbody>
	</table>
</div>
<!--// Planner end -->
</div>
</body>
</html>