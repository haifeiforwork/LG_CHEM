<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.E.E06Rehouse.*" %>
<%@ page import="hris.E.E06Rehouse.rfc.*" %>
<%@ page import="hris.E.E07Smlending.*" %>
<%@ page import="hris.E.E08ReSmlending.*" %>
<%@ page import="hris.E.E09House.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%

WebUserData user = (WebUserData)session.getValue("managedUser");
 String      FLAG  = (String)request.getAttribute("flag");
 String      requestFlag  = (String)request.getAttribute("requestFlag");
 Vector          PersLoanData_vt = (Vector)request.getAttribute("PersLoanData_vt");
 E05PersLoanData persLoanData = (E05PersLoanData)PersLoanData_vt.get(0);

%>
<form name="form1" id="form1" method="post" action="">
<!-- contents start -->
	<!--// Page Title start -->
	<div class="title">
		<h1>소액대출</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">My Info</a></span></li>
				<li><span><a href="#">복리후생</a></span></li>
				<li class="lastLocation"><span><a href="#">소액대출</a></span></li>
			</ul>
		</div>
	</div>
</form>
<!--// Page Title end -->
				<!--// Tab1 start -->
				<div class="tabUnder tab1">
					<!--// list start -->
					<div class="listArea">
						<h2 class="subtitle withButtons">소액대출지원 조회</h2>
						<div class="clear"></div>
						<form id = "pettyLoanListForm">
						<div id="pettyLoanListGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
						<input type="hidden" id="DATBW" name="DATBW" value="">
						<input type="hidden" id="STEXT" name="STEXT" value="">
						<input type="hidden" id="DARBT" name="DARBT" value="">
						<input type="hidden" id="BETRG" name="BETRG" value="">
						<input type="hidden" id="REDEMPTION" name="REDEMPTION" value="">
						<input type="hidden" id="SUBTY" name="SUBTY" value="">
						<input type="hidden" id="ENDDA" name="ENDDA" value="">
						<input type="hidden" id="BEGDA" name="BEGDA" value="">
						</form>
					</div>	
					<!--// list end -->
					<!--// Table start -->
					<div class="tableArea">	
						<h2 class="subtitle">소액대출 상세내역</h2>	
						<div class="clear"></div>
						<h3 class="subsubtitle">- 융자현황</h3>
						<div class="table pb30">
							<table class="tableGeneral">
							<caption>융자현황</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th>융자금액</th>
								  <td><input class="inputMoney w120 readOnly" id="E_DARBT" name="E_DARBT"readonly /> 원 </td>
								<th>융자일자</th>
								  <td><input class="w120 readOnly" id="E_DATBW" readonly /> </td>
							</tr>
							<tr>
								<th>총상환기간</th>
								  <td><input class="w120 readOnly" type="text" id="E_ZZRPAY_MNTH" readonly /> ~ <input class="w120 readOnly" type="text" id="E_ENDDA" readonly /> </td>
								<th>총상환횟수</th>
								  <td><input class="alignRight w120 readOnly"  id="E_ZZRPAY_CONT" readonly /> </td>
							</tr>	
							<tr>
								<th>월 상환금</th>
								  <td> <input class="inputMoney w120 readOnly" id="E_TILBT_BETRG" readonly />원 </td>
								<th></th>
								<td></td>
							</tr>
							</tbody>
							</table>
						</div>
						<h3 class="subsubtitle">- 상환내역</h3>
						<div class="table pb30">	
							<table class="tableGeneral">
							<caption>상환내역</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th>상환원금누계</th>
								  <td><input class="inputMoney w120 readOnly" id="E_TOTAL_DARBT" readonly />원 </td>
								<th>상환일자</th>
								  <td><input class="w120 readOnly" type="text" id="E_DARBT_BEGDA" readonly /> ~ <input class="w120 readOnly" type="text" id="E_DARBT_ENDDA" readonly /> </td>
							</tr>
							<tr>
								<th>상환횟수</th>
								  <td><input class="alignRight w120 readOnly"  id="E_TOTAL_CONT" readonly /> </td>
								<th></th>
								<td></td>
							</tr>
							</tbody>
							</table>
						</div>
						
						<h3 class="subsubtitle">- 잔여금</h3>
						<div class="table">	
							<table class="tableGeneral">
							<caption>상환내역</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th>잔여원금</th>
								  <td><input class="inputMoney w120 readOnly" id="E_REMAIN_BETRG" readonly />원</td>
								<th>잔여횟수</th>
								  <td><input class="alignRight w120 readOnly"  id="E_REMAIN_CONT" readonly /> </td>
							</tr>
							</tbody>
							</table>
						</div>
					</div>
					<!--// Table end -->
				</div>
				<!--// Tab1 end -->
				
<script type="text/javascript">

$(document).ready(function(){
	$("#tab1").click(function(){
		$("#pettyLoanListGrid").jsGrid("search");
	});
});
// tab1 조회
var selectPettyLoanChageValue = function(){
	jQuery.ajax({
		type : 'GET',
		url : '/manager/supp/getPettyLoanDetail.json',
		cache : false,
		dataType : 'json',
		data : $('#pettyLoanListForm').serialize(),
		async :false,
		success : function(response) {
			if(response.success){
				$("#E_DARBT").val(response.storeData.E_DARBT.format());
				$("#E_DATBW").val(response.storeData.E_DATBW);
				$("#E_ZZRPAY_MNTH").val(response.storeData.E_ZZRPAY_MNTH.substring(0,4)+"."+response.storeData.E_ZZRPAY_MNTH.substring(4,6));
				$("#E_ENDDA").val(response.storeData.E_ENDDA.substring(0,4)+ "." + response.storeData.E_ENDDA.substring(4,6));
				$("#E_ZZRPAY_CONT").val(response.storeData.E_ZZRPAY_CONT);
				$("#E_TILBT_BETRG").val(response.storeData.E_TILBT_BETRG.format());
				$("#E_TOTAL_DARBT").val(response.storeData.E_TOTAL_DARBT.format());
				$("#E_DARBT_BEGDA").val(response.storeData.E_DARBT_BEGDA.substring(0,4)+ "." + response.storeData.E_DARBT_BEGDA.substring(4,6));
				$("#E_DARBT_ENDDA").val(response.storeData.E_DARBT_ENDDA.substring(0,4)+ "." + response.storeData.E_DARBT_ENDDA.substring(4,6));
				$("#E_TOTAL_CONT").val(response.storeData.E_TOTAL_CONT.format());
				$("#E_REMAIN_BETRG").val(response.storeData.E_REMAIN_BETRG.format());
				$("#E_REMAIN_CONT").val(response.storeData.E_REMAIN_CONT.format());
			}else{
				alert("조회시 오류가 발생하였습니다. " + response.message);
			}
		}
	});
};

//소액 대출지원 Grid
    $(function() {
         $("#pettyLoanListGrid").jsGrid({
         	height: "auto",
             width: "100%",
             autoload: true,
             sorting: true,
             paging: true,
             pageSize: 10,
             pageButtonCount: 10,
 	        controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/manager/supp/getPettyLoanList.json",
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
                 	title: "선택",
                 	name: "th1",
                     itemTemplate: function(value, storeData) {
	                         return $("<input name='chk' id='chk' >")
	                           .attr("type", "radio")
	     					  .on("click", function(e) {
	                        		   $("#DATBW").val(storeData.DATBW);
	                        		   $("#STEXT").val(storeData.STEXT);
	                        		   $("#DARBT").val(storeData.DARBT);
	                        		   $("#BETRG").val(storeData.BETRG);
	                        		   $("#REDEMPTION").val(storeData.REDEMPTION);
	                        		   $("#SUBTY").val(storeData.SUBTY);
	                        		   $("#ENDDA").val(storeData.ENDDA);
	                        		   $("#BEGDA").val(storeData.BEGDA);
	                        		   selectPettyLoanChageValue();
                           });
                     },
                     align: "center",
                     width: "8%"
                 },
                 { title: "융자일자", name: "DATBW", type: "text", align: "center", width: "10%" },
                 { title: "융자형태", name: "STEXT", type: "text", align: "center", width: "16%" },
                 { title: "융자원금", name: "DARBT", type: "text", align: "right", width: "14%",
                	 itemTemplate: function(value, storeData) {
                         return value.format();
                     }
                 },
                 { title: "상환원금", name: "REDEMPTION", type: "text", align: "right", width: "14%", 
                	 itemTemplate: function(value, storeData) {
                         return value.format();
                     }
                 },
                 { title: "잔여원금", name: "BETRG", type: "text", align: "right", width: "14%" ,
                	 itemTemplate: function(value, storeData) {
                         return value.format();
                     }
                 },
                 { title: "상환완료일자", name: "ZAHLD", type: "text", align: "center", width: "10%" },
                 { title: "일시상환금액", name: "REDARBT", type: "text", align: "right", width: "14%", 
                	 itemTemplate: function(value, storeData) {
                         return value.format();
                     }
                 }
             ]
         });
     });
</script>