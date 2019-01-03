<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--// Page Title start -->
<div class="title">
	<h1>부서 휴가현황</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">조직관리</a></span></li>
			<li class="lastLocation"><span><a href="#">부서 휴가현황</a></span></li>
		</ul>						
	</div>
</div>
<!--// Page Title end -->		
<!--------------- layout body start --------------->							
<div class="tableArea">
	<h2 class="subsubtitle withButtons">부서 휴가현황 조회</h2>
	<div class="clear"> </div>	
	<div class="table">
		<form id="form1" name="form1">
		<table class="tableGeneral">
		<caption>부서 휴가현황 조회</caption>
		<colgroup>
			<col class="col_7p" />
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><label for="input_select01">조회년도</label></th>
				<td>
					<select id="I_YEAR" name="I_YEAR" class="w80">
                	<%
						int curYear = Integer.parseInt(DataUtil.getCurrentYear());
						for(int i=curYear;i>curYear-11;i--){
					%>
						<option value="<%=String.valueOf(i) %>"><%=String.valueOf(i) %></option>
					<% } %>
					</select>
					<a class="icoSearch" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
				</td>
			</tr>
		</tbody>
		</table>
		</form>
	</div>
</div>
<div id="detailAreaDiv">
</div>
</div>
</div>			
<script>
$(document).ready(function(){
	var htm = "";
	//search
	$(".icoSearch").on( "click", function() {
		search();
	});
	
	$("#I_YEAR").on("change", function() {
		$("#detailAreaDiv").html("");
		search();
	});
	
	var search = function(){
		
		$("#detailAreaDiv").html("");
		$(".icoSearch").off("click");
		var paramArr = $("#form1").serializeArray();
		jQuery.ajax({
			type : 'POST',
			url : '/dept/getOrgVacation.json',
			cache : false,
			dataType : 'json',
			data : paramArr,
			async :false,
			success : function(response) {
    			if(response.success){
    				setDetail(response.header, response.detail)
    			}else{
    				alert("조회오류");
    			}
    			
    			$(".icoSearch").on("click", function(){search();});
    		}
		});
	}
	
	var setDetail = function(header, detail){
		var cc=0;
		htm = "";
		for(var ii=0;ii<header.length;ii++){
			var hData = header[ii];
			htm = htm 
				+ "<div class=\"listArea\">"
				+ "&nbsp;<img src=\"/web-resource/images/ico/ico_or_close.gif\" id=\""+hData.ORGEH+"\" style=\"cursor:pointer;\" title=\"접기\" onclick=\"showHide(this)\">" 
				+ "&nbsp;&nbsp;<h2 class=\"subtitle\">" + hData.STEXT + " < 총 " + hData.COUNT + "명&nbsp;&nbsp;실적&nbsp;&nbsp;"+ Number(hData.USE_REAL) + " %(연차)&nbsp;&nbsp;" + Number(hData.CMP_REAL) + " %(보상) ></h2>";
				//+ "&nbsp;&nbsp;<h2 class=\"subtitle\">" + hData.STEXT + " < 총 " + hData.COUNT + "명&nbsp;&nbsp;사용률&nbsp;&nbsp;"+ Number(hData.USE_REAL) + " % (실적)&nbsp;&nbsp;"+ Number(hData.USE_GOAL) +" % (목표) ></h2>";
			 cc = setTable(cc, hData.ORGEH, detail);
		}
		$("#detailAreaDiv").html(htm);
		
	}
	
	var setTable = function(cc, ORGEH, detail){
		var rtn=0; 
		htm = htm 
			+ "<div class=\"table\" style=\"width:1200px;\">"
			+ "<table class=\"listTable\" id=\""+ORGEH+"TB\">"
			+ "<colgroup>"
			+ "<col class=\"col_5p\"/><col class=\"col_5p\"/><col class=\"col_5p\"/><col class=\"col_5p\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/>"
			+ "<col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/>"
			+ "<col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/>"
			+ "<col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/><col width=\"2.5%\"/>"
			+ "</colgroup>"
			+ "<thead><tr><th rowspan=3>사번</th><th rowspan=3>성명</th><th rowspan=3>직책</th><th rowspan=3>직위</th><th colspan=16>연차휴가</th><th colspan=16 class=\"tdBorder\">보상휴가</th></tr>"
			+ "<tr><th rowspan=2>발생<br>일수</th><th colspan=13>사용일수</th><th rowspan=2>잔여<br>일수</th><th rowspan=2>사용률(%)</th>"
			+ "<th rowspan=2>발생<br>일수</th><th colspan=13>사용/보상일수</th><th rowspan=2>잔여<br>일수</th><th rowspan=2 class=\"tdBorder\">사용률(%)</th></tr>"
			+ "<tr><th>1월</th><th>2월</th><th>3월</th><th>4월</th><th>5월</th><th>6월</th><th>7월</th><th>8월</th><th>9월</th><th>10월</th><th>11월</th><th>12월</th><th>계</th>"
			+ "<th>1월</th><th>2월</th><th>3월</th><th>4월</th><th>5월</th><th>6월</th><th>7월</th><th>8월</th><th>9월</th><th>10월</th><th>11월</th><th>12월</th><th>계</th></tr></thead><tbody>";
		
		 for(var j=cc;j<detail.length;j++){
			var dData = detail[j];
			if(ORGEH == dData.ORGEH) {
				htm = htm+"<tr><td>"+dData.PERNR+"</td><td>"+dData.ENAME+"</td><td>"+dData.TITL2+"</td><td>"+dData.TITEL+"</td><td>"+Number(dData.QUARTER)+"</td>"
				+"<td>"+Number(dData.USE_JAN)+"</td><td>"+Number(dData.USE_FEB)+"</td><td>"+Number(dData.USE_MAR)+"</td>"
				+"<td>"+Number(dData.USE_APR)+"</td><td>"+Number(dData.USE_MAY)+"</td><td>"+Number(dData.USE_JUN)+"</td>"
				+"<td>"+Number(dData.USE_JUL)+"</td><td>"+Number(dData.USE_AUG)+"</td><td>"+Number(dData.USE_SEP)+"</td>"
				+"<td>"+Number(dData.USE_OCT)+"</td><td>"+Number(dData.USE_NOV)+"</td><td>"+Number(dData.USE_DEC)+"</td>"
				+"<td>"+Number(dData.USE_TOT)+"</td><td>"+Number(dData.REMAIN)+"</td><td>"+Number(dData.USE_RATE)+"</td>"
				+"<td>"+Number(dData.CMPOCCR)+"</td><td>"+Number(dData.CMP_JAN)+"</td><td>"+Number(dData.CMP_FEB)+"</td>"
				+"<td>"+Number(dData.CMP_MAR)+"</td><td>"+Number(dData.CMP_APR)+"</td><td>"+Number(dData.CMP_MAY)+"</td>"
				+"<td>"+Number(dData.CMP_JUN)+"</td><td>"+Number(dData.CMP_JUL)+"</td><td>"+Number(dData.CMP_AUG)+"</td>"
				+"<td>"+Number(dData.CMP_SEP)+"</td><td>"+Number(dData.CMP_OCT)+"</td><td>"+Number(dData.CMP_NOV)+"</td>"
				+"<td>"+Number(dData.CMP_DEC)+"</td><td>"+Number(dData.CMP_TOT)+"</td><td>"+Number(dData.CMP_REM)+"</td>"
				+"<td>"+Number(dData.CMP_USER)+"</td></tr>";
			} else {
				rtn = j;
				break;
			}

		}
		 
		htm = htm+"</tbody></table></div></div>";

		return rtn;
		
	};
	
	$(".icoSearch").trigger('click');
});

var showHide = function(obj){
	var tableid = $(obj).attr("id") + "TB";
	if($(obj).attr("title")=="접기"){
		$("#"+tableid).hide();
		$(obj).attr("title","펼치기");
		$(obj).attr("src","/web-resource/images/ico/ico_or_open.gif");
	} else {
		$("#"+tableid).show();
		$(obj).attr("title","접기");
		$(obj).attr("src","/web-resource/images/ico/ico_or_close.gif");
	}
}
</script>
