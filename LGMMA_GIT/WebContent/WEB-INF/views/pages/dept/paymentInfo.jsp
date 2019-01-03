<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="hris.D.D15EmpPayInfo.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.F.*" %>

<%
    String jobid      = WebUtil.nvl(request.getParameter("jobid"));
    String I_ORGEH  = WebUtil.nvl(request.getParameter("I_ORGEH"));          //기간
	Vector empPayInfoData_vt       = (Vector)request.getAttribute("empPayInfoData_vt"); //사원임금정보
	Vector searchData_vt       = (Vector)request.getAttribute("searchData_vt"); //사원임금정보
	Map empPayType_map       = (Map)request.getAttribute("empPayType_map"); //사원임금유형
    String I_DATE  = WebUtil.nvl(request.getParameter("I_DATE"));          //기간
    String I_GBN  = WebUtil.nvl(request.getParameter("I_GBN"));
    String I_SEARCHDATA  = WebUtil.nvl(request.getParameter("I_SEARCHDATA"));          
    String deptNm = (String)request.getAttribute("deptNm"); 
    
    if( I_DATE == null|| I_DATE.equals("")) {
        I_DATE = DataUtil.getCurrentDate();
    }
	WebUserData user = (WebUserData)session.getValue("user");

    int empPayInfoData_vt_size = empPayInfoData_vt.size();  
    
%>  

	<!--// Page Title start -->
	<div class="title">
	<form id="pamentInfoForm" name="pamentInfoForm" >	
		<h1>사원지급정보 등록</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">조직관리</a></span></li>
				<li class="lastLocation"><span><a href="#">부서근태</a></span></li>
			</ul>						
		</div>
	</div>
	<!--// Page Title end -->	
	
	<!--------------- layout body start --------------->
	<div class="tableArea pb10">
		<div class="table">
			<table class="tableGeneral">
			<caption>사원지급정보 등록 조회</caption>
			<colgroup>
			<!-- 양기상D요청 본인만 사원검색기능쓸수있게-->
			<%if("07193".equals(user.empNo)){ %>
				<col class="col_15p" />
				<col class="col_30p" />
				<col class="col_10p" />
				<col class="col_45p" />				
			<%}else{ %>
				<col class="col_15p" />
				<col class="col_80p" />			
			<%} %>
			</colgroup>
			<tbody>
				<tr>
					<th><label for="input_select01">조회일자</label></th>
					<td class="tdDate">
                                <input class="datepicker" type="text" id="inputDate" name="I_DATE" value="<%= WebUtil.printDate(I_DATE) %>" />
                                <a id="searchBtn" class="icoSearch pl10" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
                    </td>
                    <%if("07193".equals(user.empNo)){ %><!-- test 는 05115 로 할것 -->
                    <th>
						<!--<select name="I_GBN" id="I_GBN" class="input03"> 
	                    <option value="ORGEH" <%=I_GBN.equals("ORGEH")? "selected" : "" %>>부서명</option>
	                        <option value="PERNR" <%=I_GBN.equals("PERNR")? "selected" : "" %>>사원명</option>
	                    <option value="RECENT" <%=I_GBN.equals("RECENT")? "selected" : "" %>>최근검색</option>
                        </select>-->
                        사원명
                       
                        
                    </th>
					<td>
                        <input type="text" name="txt_searchNm" id="txt_searchNm" size="25" maxlength="30" class="input03" value="" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" >
                        <a id="searchBtn_2" class="icoSearch pl10" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
                    </td>
                    <%} %>
                    
				</tr>
			</tbody>
			</table>
			<input type="hidden" name="row_count" id="row_count" >
			<input type="hidden" name="del_count" id="del_count" >
			<input type="hidden" name="txt_deptNm" id="txt_deptNm" value="<%=deptNm%>">
			<input type="hidden" name="I_ORGEH"  id="I_ORGEH" value="<%=I_ORGEH%>">
			<input type="hidden" name="I_SEARCHDATA" id="I_SEARCHDATA"  value="<%=I_SEARCHDATA%>">

		</div>
	</div>
	<!--// list start -->
	<div class="listArea">
		<div id="paymentInfoGrid"></div>		
 
	</div>
	<!--// list end -->	
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle">저장된 지급정보</h2>
		<div id="savedPaymentInfoGrid"></div>							
    
	</div>	
	<!--// list end -->	
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="saveBtn" ><span>저장</span></a></li>
			<li><a class="" href="#" id="deleteBtn"><span>삭제</span></a></li>
		</ul>
	</div>					
	</form>
	<!--------------- layout body end --------------->						

		
		
		
		
		
		
		
<script>

$(document).ready(function(){
	settingValue();
});

$("#searchBtn").click(function(){
	settingValue();
});

$("#searchBtn_2").click(function(){
	pop_search();
	//settingValue_search();
});


$("#saveBtn").click(function(){
	savePayMentInfo();
});

$("#deleteBtn").click(function(){
	deletePayMentInfo();
});




var empPayType_map_copy = function(){
	
	var gridArray = $("#paymentInfoGrid").jsGrid("option", "data");
	
	
	$.each(gridArray, function(i, data){
		
		jQuery.ajax({
			type : 'POST',
			url : '/dept/getLGARTCode.json',
			cache : false,
			dataType : 'json',
			data : {"PERNR" : data.PERNR},
			async :false,
			success : function(response) {
				if(response.success){
					//console.log(response.LGARTCode);
					//console.log($("[name='LGART']").length);
					var slt = $("[name='LGART']")[i];

					$.each(response.LGARTCode, function(key,value) {
						//console.log(value);
						$('<option>').val(value.LGART).text(value.LGTXT).appendTo(slt);
					});
				}else{
					alert("실패");
				}
			}
		});
	 });
	
	
	
}

var empPayInfoData_vt;
var empPayType_map;
var searchData_vt;

var settingValue = function(){

	
	$.ajax({
		type : "POST",
		url : "/dept/getPaymentInfo.json",
		dataType : "json",
		data : {
			"I_DATE" : $('input[name="I_DATE"]').val(),
			"E_OTEXT" : $("#E_OTEXT").val()
		},
	}).done(function(response) {
		if(response.success){

			empPayInfoData_vt = response.empPayInfoData_vt;
			empPayType_map = response.empPayType_map;
			searchData_vt = response.searchData_vt;
			
			setPaymentInfoGrid();
		
		}else{
			alert("조회시 오류가 발생하였습니다. " + response.message);
		}
	});
}



var setPaymentInfoGrid = function() {

	var MintgCode;
	var OvtmCode;

	$("#paymentInfoGrid").jsGrid({
		height: "auto",
		sorting: false,
		paging: false,
		autoload: true,
		
		controller : {
			loadData : function() {
			var d = $.Deferred();
			d.resolve(empPayInfoData_vt);
			//console.log(empPayInfoData_vt);
			
			return d.promise();
		}
	},
	fields : [
          	{ title: "사원번호", name: "PERNR", type: "text", align: "center", width: "15%" },
        	{ title: "성명", name: "ENAME", type: "text", align: "center", width: "15%" },
        	{ title: "일자", name: "BEGDA", type: "text", align: "center", width: "15%" },
        	{
            	title: "임금유형", name: "LGART1",align: "center", width: "20%",
            	itemTemplate: function(value, item) {
			   		var $select = $("<select name='LGART' >").width("100%");
					return $select;
				}
        	},
            {title: "시간", name: "ANZHL", type:"text",
                itemTemplate: function(_, item) {
                    return $("<input class='wPer' name='ANZHL'>").attr("type", "text");
                },
                align: "center",
                width: "15%"
            },
            {
            	title: "금액",
            	name: "BETRG",
            	type: "text",
                itemTemplate: function(_, item) {
                    return $("<input class='wPer readOnly' name='BETRG' readonly>").attr("type", "text");
                },
                align: "right",
                width: "20%"
            }
			]
	,
	onDataLoaded	: empPayType_map_copy
	
	});
	
	//저장된 지급정보
	$("#savedPaymentInfoGrid").jsGrid({
        height: "auto",
        width: "100%",
        sorting: true,
        paging: false,
        autoload: true,
		controller : {
			loadData : function() {
			var d = $.Deferred();
			//console.log(searchData_vt);
			d.resolve(searchData_vt);
			
			return d.promise();
		}
	},
	fields : [
          	{
            	title: "선택",
            	name: "delChk1",
                itemTemplate: function(_, item) {
                    return $("<input name='delChk' value='X'>").attr("type", "checkbox");
                },
                align: "center",
                width: "6%"
            },
        	{ title: "사원번호", name: "PERNR", type: "text", align: "center", width: "15%" },
        	{ title: "성명", name: "ENAME", type: "text", align: "center", width: "15%" },
        	{ title: "일자", name: "BEGDA", type: "text", align: "center", width: "15%" },
        	{ title: "임금유형", name: "LGTXT", type: "text", align: "center", width: "19%" },
        	{ title: "시간", name: "ANZHL", type: "text", align: "center", width: "14%" },
        	{ title: "금액", name: "BETRG", type: "text", align: "right", width: "16%" }			
	          
			]
	
	});	
	
};


var savePayMentInfo = function(){
	
	var gridArray = $("#paymentInfoGrid").jsGrid("option", "data");
	
	$('#row_count').val(gridArray.length);
	
	if(confirm("저장하시겠습니까?")) {
		
		var param = $("#pamentInfoForm").serializeArray();
		//$("#paymentInfoGrid").jsGrid("serialize", param);
		
		var gridArray = $("#paymentInfoGrid").jsGrid("option", "data");
		$.each(gridArray, function(i, data){
			for (var key in data) {
				 if (data.hasOwnProperty(key)) {
					if(key=="ANZHL"){
						param.push({name:key, value:$("[name='ANZHL']")[i].value});
					}else if(key=="BETRG"){
						param.push({name:key, value:$("[name='BETRG']")[i].value});
					}else if(key=="LGART"){
						param.push({name:key, value:$("[name='LGART']")[i].value});
					}else {
						param.push({name:key, value:data[key]});
					}
				}
			}
		 });
		
		jQuery.ajax({
			type : 'post',
			url : '/dept/savePaymentInfo',
			cache : false,
			dataType : 'json',
			data : param,
			async : false,
			success : function(response) {
				if(response.success) {
					alert("저장되었습니다.");
					settingValue();
					return true;
				} else {
					alert("저장시 오류가 발생하였습니다. " + response.message);
					return false
				}
				$("#saveBtn").prop("disabled", false);
			}
		
		});
	}
}



var deletePayMentInfo = function(){
	
	var gridArray = $("#savedPaymentInfoGrid").jsGrid("option", "data");
	
	$('#del_count').val(gridArray.length);
	
	if(confirm("삭제하시겠습니까?")) {
		
		var param = $("#pamentInfoForm").serializeArray();
		//$("#savedPaymentInfoGrid").jsGrid("serialize", param);
		//console.log($($("[name='delChk']")[0]).is(":checked"));
		$.each(gridArray, function(i, data){
			if ($($("[name='delChk']")[i]).is(":checked")){	
				param.push({name:"delChk", value:"X"});
			}else{
				param.push({name:"delChk", value:""});
			}
			for (var key in data) {
				 if (data.hasOwnProperty(key)) {
					//console.log(key);
						param.push({name:key, value:data[key]});
				}
			}
		 });
		
		
		
		jQuery.ajax({
			type : 'post',
			url : '/dept/deletePaymentInfo',
			cache : false,
			dataType : 'json',
			data : param,
			async : false,
			success : function(response) {
				if(response.success) {
					alert("저장되었습니다.");
					settingValue();
					return true;
				} else {
					alert("저장시 오류가 발생하였습니다. " + response.message);
					return false
				}
				$("#deleteBtn").prop("disabled", false);
			}
		
		});
	}
}


var EnterCheck = function(){
    if (event.keyCode == 13)  {
        pop_search();
    }
}


var pop_search = function(){
	
	//if($('#I_GBN').val() == "ORGEH"||$('#I_GBN').val()=="RECENT"){
	//	dept_search();
	//}else if($('#I_GBN').val() == "PERNR"){
	//	pers_search();
	//}
	
	pers_search();
	
}

var dept_search = function(){

	//alert("부서검색");
	//사원명 검색이 해당기능 포괄하여 닫음.
	//사원명으로 해당팀장이름 검색하면 해당 팀원들이 다 들어옴
}

var pers_search = function(){
	
	$.ajax({
		type : "get",
		url : "/dept/getDeptName.json",
		dataType : "json",
		data : {"txt_searchNm" : $('#txt_searchNm').val()}
	}).done(function(response) {
		if(response.success) {
			$.each(response.searchResult, function(i, data){
				
				$('#I_SEARCHDATA').val(data.EPERNR);
				$('#txt_searchNm').val(response.searchResult[0].ENAME);
				$('#I_ORGEH').val(response.searchResult[0].OBJID);
				$('#txt_deptNm').val(response.searchResult[0].STEXT);
				
				settingValue_search();
			});
		}
		else
			alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
	});
}

var settingValue_search = function(){
	
	
	$.ajax({
		type : "POST",
		url : "/dept/getPaymentInfo.json",
		dataType : "json",
		data : {
			"I_DATE" : $('input[name="I_DATE"]').val(),
			"E_OTEXT" : $("#E_OTEXT").val(),
			"I_SEARCHDATA" : $("#I_SEARCHDATA").val(),
			"txt_searchNm" : $("#txt_searchNm").val(),
			"I_ORGEH" : $("#I_ORGEH").val(),
			"txt_deptNm" : $("#txt_deptNm").val(),
			"I_GBN" : "PERNR"
		},
	}).done(function(response) {
		if(response.success){

			empPayInfoData_vt = response.empPayInfoData_vt;
			empPayType_map = response.empPayType_map;
			searchData_vt = response.searchData_vt;
			
			setPaymentInfoGrid();
		
		}else{
			alert("조회시 오류가 발생하였습니다. " + response.message);
		}
	});
}



</script>