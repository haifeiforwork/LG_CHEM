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

WebUserData user = (WebUserData)session.getValue("user");
 String      FLAG  = (String)request.getAttribute("flag");
 String      requestFlag  = (String)request.getAttribute("requestFlag");
 
 String      e_requestFlag  = (String)request.getAttribute("e_requestFlag");
 
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
				
				<!--------------- layout body start --------------->	
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" id = "tab2" onclick="switchTabs(this, 'tab2');" class="selected">소액대출신청</a></li>
						<li><a href="#" id = "tab3" onclick="switchTabs(this, 'tab3');" >소액대출 상환신청</a></li>
						<li><a href="#" id = "tab1" onclick="switchTabs(this, 'tab1');" >소액대출지원 조회</a></li>
					</ul>
				</div>
				<!--// Tab end -->
				
				<!--// Tab1 start -->
				<div class="tabUnder tab1 Lnodisplay">
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
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 ">
				   <form id="requestPettyLoanForm">
					<!--// Table start -->	
					<div class="tableArea">
						<h2 class="subtitle">소액대출신청</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>소액대출신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText02-1">신청일</label></th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" id="BEGDA"  value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>"  />
								</td>
							</tr>
							<input type="hidden" name="DLART" size="50" class="input03" value='0080'>
							<tr>
								<th><span class="textPink">*</span><label for="input-radio01-1">신청금액</label></th>
								<td>
									<input type="radio" name="REQU_MONY" value=1000000 id="REQU_MONY"  onClick="javascript:click_radio(this);" checked="checked" /><label for="input-radio01-1">100만원</label>
									<input type="radio" name="REQU_MONY" value=2000000 id="REQU_MONY"  onClick="javascript:click_radio(this);"/><label for="input-radio01-2">200만원</label>
									<input type="radio" name="REQU_MONY" value=3000000 id="REQU_MONY"  onClick="javascript:click_radio(this);"/><label for="input-radio01-3">300만원</label>
									<input type="radio" name="REQU_MONY" value=5000000 id="REQU_MONY"  onClick="javascript:click_radio(this);"/><label for="input-radio01-4">500만원</label>
                                </td>
							</tr>	
							<tr>
								<th><span class="textPink">*</span><label for="input-radio02-1">상환방법</label></th>
								<td>
                                	<input type="radio" name="GUBN_FLAG" value="P" id="GUBN_FLAG" onClick="javascript:click_radio(this);" checked="checked" <%= user.e_persk.equals("11") || user.e_persk.equals("12") || user.e_persk.equals("13") || user.e_persk.equals("14") ? "disabled" : "" %>/><label for="input-radio02-1">급여(24회 2년상환)</label>
									<input type="radio" name="GUBN_FLAG" value="O" id="GUBN_FLAG" onClick="javascript:click_radio(this);"  <%= user.e_persk.equals("11") || user.e_persk.equals("12") || user.e_persk.equals("13") || user.e_persk.equals("14") ? "disabled" : "" %>/><label for="input-radio02-2">급여(12회 1년상환)</label>
<%
    if( user.e_persk.equals("31") ) {
%>
				                    <input type="radio" name="GUBN_FLAG" value="B" id="GUBN_FLAG" onClick="javascript:click_radio(this);" <%= user.e_persk.equals("11") || user.e_persk.equals("12") || user.e_persk.equals("13") || user.e_persk.equals("14") ? "disabled" : "" %>/><label for="input-radio02-3">급여+정기상여(40회)</label>
				                    <input type="radio" name="GUBN_FLAG" value="C" id="GUBN_FLAG" onClick="javascript:click_radio(this);" <%= user.e_persk.equals("11") || user.e_persk.equals("12") || user.e_persk.equals("13") || user.e_persk.equals("14") ? "disabled" : "" %>/><label for="input-radio02-4">급여+정기상여(20회)</label>
<%
    } 
%>     
                                </td>
                            </tr>
                            <tr>
								<th><label for="inputText01-3">월 상환금</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="TILBT" name="TILBT" value="" readonly/>원
								</td>
							</tr>
							</tbody>
							</table>
						</div>
						<div class="tableComment">
							<p><span class="bold">매월 21일부터 말일까지는 소액대출 신규 신청을 할 수 없습니다.</span></p>
						</div>
					</div>	
					<!--// Table end -->
					<!--// list start -->
					<!--// list end -->
			      </form>
			      	<div class="listArea" id="decisioner">
					</div>	
					<div class="buttonArea">
						<ul class="btn_crud">
						<c:if test="${selfApprovalEnable == 'Y'}">
							<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
						</c:if>
							<li><a class="darken" id="requestPettyLoanBtn" href="#"><span>신청</span></a></li>
						</ul>
					</div>
				</div>
				<!--// Tab2 end -->		
				
				<!--// Tab3 start -->
				<div class="tabUnder tab3 Lnodisplay">
					<form id = "dataCount" name="dataCount">
						<div class="errorArea">
							<div class="errorMsg">	
								<div class="errorImg"><!-- 에러이미지 --></div>
								<div class="alertContent">
									<p>해당하는 데이터가 존재하지 않습니다.</p>
								</div>
							</div>
						</div>
					</form>
					<!--// Table start -->	
					<form id = "refundPettyLoanForm">
					<div class="tableArea">
						<h2 class="subtitle">소액대출 상환신청</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>소액대출 상환신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText03-1">신청일</label></th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" id="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>"  />
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-2">상환원금</label></th>
								<td>
                                  <input class="inputMoney w120 readOnly" name="E_RPAY_AMNT" type="text" id="E_RPAY_AMNT" value=""  readonly> 원
                                </td>
                            </tr>
							<tr>
                                <th><span class="textPink">*</span><label for="inputDateDay">상환액 입금일자</label></th>
								<td colspan="3" class="tdDate">
                                   <input type="text" size="5" id="inputDateDay" name="I_DATE" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>"/>
                                </td>
							</tr>
							<tr>
								<th><label for="inputText03-3">대출금액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" name="E_DARBT" id="E_DARBT" value="" readonly> 원
                                </td>
							</tr>	
							<tr>
								<th><label for="inputText03-4">대출일자</label></th>
								<td>
									<input class="w80 readOnly" type="text" name="E_DATBW" id="E_DATBW" value="" readonly>
                                </td>
							</tr>	
							<tr>
								<th><label for="inputText03-5">기상환액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" name="E_ALREADY_AMNT" id="E_ALREADY_AMNT" value="" readonly> 원
							    </td>
							</tr>	
							<tr>
								<th><label for="inputText03-6">대출잔액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" name="E_REMAIN_AMNT" id="E_REMAIN_AMNT" value="" readonly> 원
                                </td>
							</tr>
							</tbody>
							</table>
						</div>
						<div class="tableComment">
<% if ( user.e_grup_numb.equals("02")) {  //@v1.1  여수만 사용 %>
<!-- <p><span class="bold">상환은행계좌 : 여수 신한은행) 100-025-254850 LG MMA</span></p> -->
				<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA</span></p>
<% } else { %>
				<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA</span></p>
<% } %>   
							<ul>
								<li>소액대출을 입금할 경우 본인임을 확인할 수 있도록 무통장 입금증에 본인의 실명을 입력하여 주십시오.</li>
								<li>매월 21일부터 말일까지는 소액대출을 상환할 수 없습니다. </li>
								<li>2009. 07. 01일부터 기상환액이 대출원금의 85% 이상일 경우에만 상환신청이 가능합니다. </li>
							</ul>
						</div>
					</div>	
					<!--// Table end -->	
					<!--// list start -->
					    <input type="hidden" id="E_EXP_PERNR" name="E_EXP_PERNR"   value="">
					    <input type="hidden" id="I_LOAN_CODE" name="I_LOAN_CODE"   value="">
					    <input type="hidden" id="I_BETRG" name="I_BETRG"       value="">
					    <input type="hidden" id="E_TOTAL_AMNT" name="E_TOTAL_AMNT"  value="">      <!--  합계  -->
					    <input type="hidden" id="E_REPT_DATE" name="E_REPT_DATE"   value="">       <!--  날짜  -->
					    <input type="hidden" id="P_PERNR" name="P_PERNR"   value="">       <!--  날짜  -->
					</form>
					<form id="refunddecisionerForm">
						<div class="listArea" id="refunddecisioner"></div>
						<!--// list end -->					
						<div class="buttonArea">
							<ul class="btn_crud">
							<c:if test="${selfApprovalEnable == 'Y'}">
								<li><a href="#" id="requestRefundNapprovalBtn"><span>자가승인</span></a></li>
							</c:if>
								<li><a class="darken" id="refundPettyLoanBtn"href="#"><span>신청</span></a></li>
							</ul>
						</div>
					</form>
				</div>
				<!--// Tab3 end -->
				
<script type="text/javascript">

$(document).ready(function(){
	$('#decisioner').load('/common/getDecisionerGrid?upmuType=81&gridDivId=decisionerGrid');
	$('#refunddecisioner').load('/common/getDecisionerGrid?upmuType=82&gridDivId=refunddecisionerGrid');
	click_radio();
	if($(".layerWrapper").length){
		// 결재자 검색
		$("#dataCount").hide();
     };
	
	$("#tab1").click(function(){
		$("#pettyLoanListGrid").jsGrid("search");
	});
	$("#tab2").click(function(){
		click_radio();
	});
	$("#tab3").click(function(){
		refundPettyLoanList();
		if($("#refundPettyLoanForm #E_RPAY_AMNT").val() ==""||$("#refundPettyLoanForm #E_RPAY_AMNT").val() ==null||$("#refundPettyLoanForm #E_RPAY_AMNT").val() =="0"){
			$("#dataCount").show();
			$("#refunddecisionerForm").hide();
			$("#refundPettyLoanForm").hide();
		}else{
			$("#dataCount").hide();
			$("#refunddecisionerForm").show();
			$("#refundPettyLoanForm").show();
			
		}
	});
	
	// 신청 버튼
	$("#requestPettyLoanBtn").click(function(){
		requestPettyLoan(false);
	});
	
	// 신청 버튼
	$("#requestNapprovalBtn").click(function(){
		requestPettyLoan(true);
	});
	
	// 상환 버튼
	$("#refundPettyLoanBtn").click(function(){
		refundPettyLoan(false);
	});
	// 상환 버튼
	$("#requestRefundNapprovalBtn").click(function(){
		refundPettyLoan(true);
	});
});
// tab1 조회
var selectPettyLoanChageValue = function(){
	jQuery.ajax({
		type : 'GET',
		url : '/supp/getPettyLoanDetail.json',
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
             autoload: false,
             sorting: true,
             paging: true,
             pageSize: 10,
             pageButtonCount: 10,
 	        controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/supp/getPettyLoanList.json",
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
	                         return $("<input name='chk' id='chk' checked>")
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

function click_radio(obj) {
	if($(':radio[name="REQU_MONY"]:checked').val()!=null
	&&	$(':radio[name="GUBN_FLAG"]:checked').val()!=null){
		$("#TILBT").val(cal_money());
	}
}

var cal_money = function() {
	var requMony =0;
	var gubnFlag = "";
	var count = 0;
	var money = 0;
	requMony = $(':radio[name="REQU_MONY"]:checked').val();
	gubnFlag = $(':radio[name="GUBN_FLAG"]:checked').val();

    if( gubnFlag == "P" ){
    	count = 24;
    }else if (gubnFlag == "O"){
    	count = 12;
    }else if (gubnFlag == "B"){
    	count = 40;
    }else if (gubnFlag == "C"){
    	count = 20;
    }
    money = requMony / count;
    //money =  nelim(money);
    money =  olim(money);
    
    money = money.format();
    return money;

}

//tab2 신청
var requestPettyLoan = function(self){
	if(requestPettyLoanCheck()){
		decisionerGridChangeAppLine(self);
		$("#requestPettyLoanForm #RowCount").val($("#decisionerGrid").jsGrid("dataCount"));
		var param = $("#requestPettyLoanForm").serializeArray();
		$("#decisionerGrid").jsGrid("serialize", param);
		param.push({"name":"selfAppr", "value" : self});
		
		//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
		var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
		if(confirm(msg + "신청 하시겠습니까?")){
			jQuery.ajax({
				type : 'POST',
				url : '/supp/requestPettyLoan.json',
				cache : false,
				dataType : 'json',
				data : param,
				async :false,
				success : function(response) {
		  			if(response.success){
		  				alert("신청 되었습니다.");
		  				$("#requestPettyLoanForm").each(function() {
	    					this.reset();
	    				});
		  				
		  				$("#REQU_MONY").prop("checked", false);
	    				$("#GUBN_FLAG").prop("checked", false);
		  			}else{
		  				alert("신청시 오류가 발생하였습니다. " + response.message);
		  			}
		  		}
			});
		} else {
			decisionerGridChangeAppLine(false);
		}
	}
};

var requestPettyLoanCheck = function(){
	
	 var now = new Date();
	 var sysDate = now.getDate();
	
	if ( sysDate >= 21 && sysDate <=31 ) {  
		alert("매월 21일부터 말일까지는 소액대출 신규 신청을 할 수 없습니다.");
	return false;
	}
	if("N" == '<%= requestFlag %>'){
		alert("이미 소액대출를 받으셨습니다.");
	return false;
	}
	if("N" == '<%= e_requestFlag %>'){
		alert("이미 신청 건이 있습니다.");
	return false;
	}
	
	return true;
}

// 상환
var refundPettyLoanList = function(){
	jQuery.ajax({
		type : 'GET',
		url : '/supp/getRefundPettyLoanList.json',
		cache : false,
		dataType : 'json',
		async :false,
		success : function(response) {
			if(response.success){
				var storeData = response.storeData;
				var key = response.key;
				var P_PERNR = response.P_PERNR;
				$("#refundPettyLoanForm #E_RPAY_AMNT").val(banolim(storeData.E_RPAY_AMNT,0).format());
				$("#refundPettyLoanForm #I_DATE").val(key.I_DATE);
				$("#refundPettyLoanForm #E_DARBT").val(banolim(storeData.E_DARBT,0).format());
				$("#refundPettyLoanForm #E_DATBW").val(storeData.E_DATBW);
				$("#refundPettyLoanForm #E_ALREADY_AMNT").val(banolim(storeData.E_ALREADY_AMNT,0).format());
			    $("#refundPettyLoanForm #E_REMAIN_AMNT").val(banolim(storeData.E_REMAIN_AMNT,0).format());
			    $("#refundPettyLoanForm #E_EXP_PERNR").val(storeData.E_EXP_PERNR.format());
			    $("#refundPettyLoanForm #I_LOAN_CODE").val(key.I_LOAN_CODE);
			    $("#refundPettyLoanForm #I_BETRG").val(key.I_BETRG);
			    $("#refundPettyLoanForm #E_TOTAL_AMNT").val(storeData.E_TOTAL_AMNT.format());
			    $("#refundPettyLoanForm #E_REPT_DATE").val(storeData.E_REPT_DATE.format());
			    $("#refundPettyLoanForm #P_PERNR").val(P_PERNR);
			    $("#dataCount").hide();
			    $("#refundPettyLoanForm").show();
			    $("#refunddecisionerForm").show();
			}else{
				 $("#dataCount").show();
				 $("#refundPettyLoanForm").hide();
				 $("#refunddecisionerForm").hide();
			}
		}
	});
};	

var refundPettyLoan = function(self){
	if(refundPettyLoanCheck()){
		refunddecisionerGridChangeAppLine(self);
		$("#refundPettyLoanForm #RefundRowCount").val($("#refunddecisionerGrid").jsGrid("dataCount"));
		var param = $("#refundPettyLoanForm").serializeArray();
		$("#refunddecisionerGrid").jsGrid("serialize", param);
		param.push({"name":"selfAppr", "value" : self});
		
		//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
		var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
		if(confirm(msg + "신청 하시겠습니까?")){
			jQuery.ajax({
				type : 'POST',
				url : '/supp/requestPettyLoanRefund.json',
				cache : false,
				dataType : 'json',
				data : param,
				async :false,
				success : function(response) {
		  			if(response.success){
		  				alert("신청 되었습니다.");
		  				$("#refundPettyLoanForm").each(function() {
	    					this.reset();
	    				});
		  				 $("#inputDateDay").val("");
		  				
		  			}else{
		  				alert("신청시 오류가 발생하였습니다. " + response.message);
		  			}
		  		}
			});
		} else {
			refunddecisionerGridChangeAppLine(false);
		}
	}
};

var refundPettyLoanCheck = function(){
    datech = removePoint($("#refundPettyLoanForm #inputDateDay").val());
    erpayamnt = removeComma($("#refundPettyLoanForm #E_RPAY_AMNT").val()); //원금
    ealreadyamnt = removeComma($("#refundPettyLoanForm #E_ALREADY_AMNT").val()); //기상환금액
    edarbt = removeComma($("#refundPettyLoanForm #E_DARBT").val()); //대출원금
    
    expect_amt = edarbt  * 85 /100;
    
    if ( ealreadyamnt < expect_amt) {
        if ($("#refundPettyLoanForm #E_EXP_PERNR").val() != $("#refundPettyLoanForm #P_PERNR").val()){
            alert("대출원금대비 85%이상 상환 시만 중도상환 신청이 가능합니다.");
            return false;   
        }  
     }
	if(datech.length==8){
		var now = new Date();
		var sysDate = now.getDate();
		
		if ( sysDate >= 21 && sysDate <=31 ) {
			alert("매월 21일부터 말일까지는 상환 신청을 할 수 없습니다.");
			return false;
		}
		
		if( $("#refundPettyLoanForm #inputDateDay").val() == "" ) {
			alert("상환액 입금일자를 입력하세요.");
			return false;
		}
		dif = dayDiff($("#refundPettyLoanForm #BEGDA").val(), $("#refundPettyLoanForm #inputDateDay").val());
		
	    if( dif > 7) {
	        alert("입금일자는 신청일 1주일 이내만 가능합니다.");
	    	return false;
	    }
	}
    return true;
}

</script>