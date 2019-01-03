<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%
WebUserData user = (WebUserData)session.getValue("user");
String deptId    = (String)request.getAttribute("deptId");
String deptNm    = WebUtil.nvl(request.getParameter("hdn_deptNm"));
String searchDay = (String)request.getAttribute("E_YYYYMON");
String year      = (String)request.getAttribute("year");
String month     = (String)request.getAttribute("month");
String STEXT    = (String)request.getAttribute("STEXT");

%>
	<!--// Page Title start -->
	<div class="title">
		<h1>월간근태현황</h1>
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
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
			<caption>월간근태현황 조회</caption>
			<colgroup>
				<col class="col_15p" />
				<col class="col_35p" />
				<col class="col_15p" />
				<col class="col_35p" />
			</colgroup>
			<tbody>
				<tr>
					<th><label for="input_select01">조회년월</label></th>
					<td>
						<select class="w70" id="year" name="year"> 
<%
    					for( int i = 2016 ; i <= Integer.parseInt( DataUtil.getCurrentYear() ) ; i++ ) {
						int year1 = Integer.parseInt(searchDay.substring(0, 4));
%>
						<option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>
						</select>
						<select class="w50" id="month" name="month">
<%
						for( int i = 1 ; i <= 12 ; i++ ) {
							String temp = Integer.toString(i);
							int mon = Integer.parseInt(searchDay.substring(4, 6));
%>
						<option value="<%= i %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
						</select>
						<input type="hidden" id="deptId" name="deptId"  value="<%=deptId%>">
						<input type="hidden" id="deptNm" name="deptNm"  value="<%=deptNm%>">
						<input type="hidden" id="year1" name="year1" value="">
						<input type="hidden" id="month1" name="month1" value="">
						<input type="hidden" id="searchDay_bf" name="searchDay_bf" value="">
						<input type="hidden" id="BEGDA" name="BEGDA" value="">
						<input type="hidden" id="ENDDA" name="ENDDA" value="">
						<input type="hidden" id="kyejang" name="kyejang"  value="<%=user.e_kyejang%>">
						
<!-- 						<a class="icoSearch" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a> -->
					</td>
					<th>부서명</th>
					<td><%=STEXT%></td>
				</tr>
			</tbody>
			</table>
		</div>
	</div>				
	<!--// list start -->
	<div class="listArea pb0">			
		<h2 class="subtitle">월간근태현황</h2>
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a href="#" id="excelDownloadBtn"><span>Excel Download</span></a></li>
				</ul>
			</div>
		<div class="clear"></div>	
		<!-- slide content -->
		<div id="empMonthlyWorkGrid" class="thSpan">
		</div>
	</div>
	<!-- //slide content -->
	<!--// list end -->
	<!--// table start -->
	<div class="tableArea">
<%
	if(!user.e_kyejang.equals("Y")){
%>
<div class="tableComment">
	<p><span class="bold">안내사항</span></p>
	<ul>
		<li>공수 = 실출근일수 + 유급휴일수 + (초과근로 + 기타) * 가중시수 반영</li>
		<li>초과근로 + 기타 = (연장 + 야간 + 특근 + 근무시간외 교육, 향군)/ 8h</li>
	</ul>
</div>
<%
	}
%>
		<h2 class="subtitle pt30">근태유형 및 단위</h2>
		<div class="table">
			<table class="tableGeneral">
				<caption>근태유형 및 단위</caption>
				<colgroup>
					<col class="col_8p" />
					<col class="col_8p" />
					<col class="col_36p" />
					<col class="col_8p" />
					<col class="col_28p" />
					<col class="col_12p" />
				</colgroup>
				<thead>
				<tr>
					<th colspan="2" class="alignCenter">근태유형</th>
					<th class="alignCenter">비근무</th>
					<th class="alignCenter">근무</th>
					<th class="alignCenter">초과근무</th>
					<th class="alignCenter thNoLine">기타</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<th rowspan="3">단위</th>
					<th>시간</th>
					<td class="tdLine">
						시간공가, 휴일비근무, 비근무<br>모성보호휴가
					</td>
					<td rowspan="3" class="tdLine alignCenter">
						교육, 출장
					</td>
					<td class="tdLine">휴일특근, 명절특근, 휴일연장, 연장근로, 야간근로</td>
					<td>교육(근무 외), 당직</td>
				</tr>
				<tr>
					<th>일수</th>
					<td class="tdLine">
						반일휴가(이전/전반/후반), 보상휴가(전일/반일(전/후반)), <br>
						전일휴가, 경조휴가, 하계휴가, 난임휴가, <br>
						보건휴가, 산전산후휴가, 전일공가, 유급결근, 무급결근, 전일공가 
					</td>
					<td class="tdLine"></td>
					<td></td>
				</tr>
				<tr>
					<th>횟수</th>
					<td class="tdLine">
						지각, 조퇴,조기조퇴(무단)
					</td>
					<td class="tdLine"></td>
					<td></td>
				</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!--// table end -->
	<!--------------- layout body end --------------->
	<script>
	$(document).ready(function(){
		$empMonthlyWorkList();
		kyejang();

	});

	$("#excelDownloadBtn").click(function(){
		var $form = $('<form></form>');
		$form.attr('action', '/excel/genEmpMonthlyWorkDataExcel');
		$form.attr('method', 'post');
		$form.appendTo('body');

		var year = $('<input name="year" type="hidden" value="'+$("#year option:selected").val()+'">');
		var month = $('<input name="month" type="hidden" value="'+$("#month option:selected").text()+'">');

		$form.append(year).append(month);
		$form.submit();
	});

	$("#year").change(function(){
		$empMonthlylyWorkList();
		kyejang();
	});
	$("#month").change(function(){
		$empMonthlyWorkList();
		kyejang();
	});
	
	var kyejang = function(){
		if($("#kyejang").val() != "Y"){
			$("#empMonthlyWorkGrid").jsGrid("fieldOption","KONGSU", "visible", true);
			$("#empMonthlyWorkGrid").jsGrid("fieldOption","KONGSU_HOUR", "visible", true);
		}else{
			$("#empMonthlyWorkGrid").jsGrid("fieldOption","KONGSU", "visible", false);
			$("#empMonthlyWorkGrid").jsGrid("fieldOption","KONGSU_HOUR", "visible", false);
		}
	};
	var checkData = function(){
		if($("#year option:selected").val() == "2016" && $("#month option:selected").val() <8){
	    	alert( "2016년 8월 이후부터 조회가능합니다.");
			return false;
	    }
		return true;
	}
	$empMonthlyWorkList = function(){
		$("#empMonthlyWorkGrid").jsGrid({
			height: "auto",
   			sorting: false,
   			paging: false,
            autoload: true,
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/dept/getEmpMonthlyWorkDataList.json",
   						dataType : "json",
   						data :{
   							"deptId"  : $("#deptId").val(),
   							"year"    : $("#year option:selected").val(),
   							"month"   : $("#month option:selected").text()
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
   			//new Array(2, 25,"근태집계") ,
   			headerRowRenderer: function() {
   				var arr = new Array(new Array(3,16,"비근무 (일,횟수)"), new Array(15,18,"근무 (시간)"), new Array(17,24,"초과근무 (시간)"), new Array(23,26,"기타 (시간)"), new Array(25,28,"공수"));
   				return setGridHeader(this, arr);
   			},
   			fields : [
					{ title: "성명", name: "ENAME", type: "text", align: "center", width: "80" },
					{ title: "사번", name: "PERNR", type: "text", align: "center", width: "80",
						itemTemplate: function(value,item){ 
							if(item.ENAME == "TOTAL")
								return "( "+value.format()+" ) 명";
							else
								return item.PERNR.length == 8 ? item.PERNR.substring(3, 8) : item.PERNR;
						}
					},
					{ title: "잔여</br>휴가", name: "REMA_HUGA", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "잔여</br>보상</br>휴가", name: "REMA_RWHUGA", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,2);}else{return "0"+value }}
					},
					{ title: "휴가", name: "HUGA", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "보상</br>휴가", name: "RWHUGA", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,2);}else{return "0"+value }}
					},
					{ title: "경조<br/>휴가", name: "KHUGA", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "하계<br/>휴가", name: "HHUGA", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "보건<br/>휴가", name: "BHUG", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "모성<br/>보호<br/>휴가", name: "MHUG", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "공가", name: "GONGA", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "결근", name: "KYULKN", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "지각", name: "JIGAK", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "조퇴", name: "JOTAE", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "외출", name: "WECHUL", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "조기조퇴<br>(무단조퇴)", name: "MUNO", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "교육", name: "GOYUK", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "출장", name: "CHULJANG", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "휴일<br>특근", name: "HTKGUN", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "명절<br>특근", name: "MTKGUN", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "휴일<br>연장", name: "HYUNJANG", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "연장<br>근로", name: "YUNJANG", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "야간<br>근로", name: "YAGAN", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "당직", name: "DANGJIC", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "항군<br>(근무외)", name: "HYANGUN", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "교육<br>(근무외)", name: "KOYUK", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "금액", name: "KONGSU", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					},
					{ title: "시간", name: "KONGSU_HOUR", type: "text", align: "center", width: "50" ,
						itemTemplate: function(value){ 
							if(parseInt(value) > 0 || value == "0"){return pointFormat(value,1);}else{return "0"+value }}
					}
				]
			});
		};
    </script>
				