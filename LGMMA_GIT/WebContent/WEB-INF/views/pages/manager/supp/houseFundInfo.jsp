<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%
	WebUserData user = (WebUserData)session.getValue("managedUser");
	E05PersInfoData E05PersInfoData    = (E05PersInfoData)request.getAttribute("E05PersInfoData");
	Vector          E05MaxMoneyData_vt = (Vector)request.getAttribute("E05MaxMoneyData_vt");
	String          E_WERKS            = (String)request.getAttribute("E_WERKS");
	
%>

<!-- contents start -->
	<!--// Page Title start -->
	<div class="title">
		<h1>주택자금</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">My Info</a></span></li>
				<li><span><a href="#">복리후생</a></span></li>
				<li class="lastLocation"><span><a href="#">주택자금</a></span></li>
			</ul>
		</div>
	</div>
<!--// Page Title end -->
				<!--// Tab3 start -->
				<div class="tabUnder tab3">
					<!--// list start -->
					<div class="listArea">		
						<h2 class="subtitle withButtons">주택지원내역</h2>
						<div class="clear"></div>
	    				<div id="houseFundList" class="jsGridPaging"></div>
					</div>
						
					<!--// list end -->
					<!--// Table start -->
					<div class="tableArea">	
						<h2 class="subtitle">주택지원 상세내역</h2>
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
								<td class="alignRight" id="E_DARBT_tab3"></td>
								<th>월 상환원금</th>
								<td class="alignRight" id="E_TILBT"></td>
							</tr>
							<tr>
								<th>융자일자</th>
								<td id="E_DATBW_tab3"></td>
								<th>월 상환이자</th>
								<td class="alignRight" id="E_BETRG"></td>
							</tr>
							<tr>
								<th>총상환기간</th>
								<td id="E_ZZRPAY_MNTH_TO_E_ENDDA"></td>
								<th>월 상환금</th>
								<td class="alignRight" id="E_TILBT_BETRG"></td>
							</tr>	
							<tr>
								<th>총상환횟수</th>
								<td id="E_ZZRPAY_CONT"></td>
								<th>보증구분</th>
								<td id="E_ZZSECU_FLAG_tab3"></td>
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
								<td class="alignRight" id="E_TOTAL_DARBT"></td>
								<th >상환일자</th>
								<td id="E_DARBT_BEGDA_TO_E_DARBT_ENDDA"></td>
							</tr>
							<tr>
								<th>상환이자누계</th>
								<td class="alignRight" id="E_TOTAL_INTEREST"></td>
								<th>상환횟수</th>
								<td id="E_TOTAL_CONT"></td>
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
								<td class="alignRight" id="E_REMAIN_BETRG"></td>
								<th>잔여횟수</th>
								<td id="E_REMAIN_CONT"></td>
							</tr>
							</tbody>
							</table>
						</div>
					</div>
					<!-- <div class="buttonArea">
						<ul class="btn_crud">
							<li><a class="darken" href="#"><span>목록</span></a></li>
						</ul>
					</div> -->
					<!--// Table end -->
				</div>
				<!--// Tab3 end -->


<script type="text/javascript">
	$('#decisioner').load('/common/getDecisionerGrid?upmuType=12&gridDivId=decisionerGrid');
	
	$(document).ready(function(){
		
		$("#tab1").click(function(){
			$("#form1").each(function(e){
				this.reset();
			});
			$('#decisioner').load('/common/getDecisionerGrid?upmuType=12&gridDivId=decisionerGrid');
		});
		$("#tab2").click(function(){
			getPersonLoanForRepay();
			$('#decisioner2').load('/common/getDecisionerGrid?upmuType=13&gridDivId=decisionerGrid2');
		});
		$("#tab3").click(function(){
			$("#houseFundList").jsGrid("search");
		});
	});
	
	$("#DLART").change(function(){
		DLART();
	});
	
	$("#applPopupSearchbtn").click(function(){
		$("#applPopupGrid").jsGrid("search");
	});
	
	$("#I_LOAN_CODE").change(function(){
		getPersonLoanForRepaySecond();
	});
	
	$("#requestBtn2").click(function(){
		requestRepay();
	});
	
	$("#requestBtn").click(function(){
		requestEvent();
	});
	
	var requestCheck = function(){
		//필수값 체크
		if(!checkNullField("form1")) return false;

		var requ_mony = Number(numberOnly($("#REQU_MONY").val()));
		if( requ_mony <= 0 ) {
			alert("신청금액은 0 원보다 커야합니다.");
			return false;
		}
		
		return true;
		
		
	};
	

	var requestCheck2 = function(){
		//필수값 체크
		if(!checkNullField("form2")) return false;

		
		return true;
		
		
	};	

	var DLART = function() {
		$("#REQU_MONY").val(max_amount($("#DLART").val()).format());
		
		//자금용도 코드
		jQuery.ajax({
    		type : "POST",
    		url : "/manager/supp/getFundCode.json",
    		cache : false,
    		dataType : "json",
    		data : {
				 "DLART" : $("#DLART").val()
			},
    		async :false,
    		success : function(response) {
    			if(response.success){
    				
    				var items = response.storeData;
    				$("#ZZFUND_CODE").empty();
    				$("#ZZFUND_CODE").append('<option value=\"\">-------------</option>');
    				
    				for(var i=0;i<items.length;i++){
    					var item = items[i];
    					$('#ZZFUND_CODE').append('<option value=' + item.code + '>' + item.value + '</option>');
    				}
    			}
    			else{
    				alert(response.message);
    			}
    		}
		});
	};
	
	var max_amount = function(loantype) {
		var max_money = 0;
		<%
	    for ( int i = 0 ; i < E05MaxMoneyData_vt.size() ; i++ ) {
	        E05MaxMoneyData E05MaxMoneyData = (E05MaxMoneyData)E05MaxMoneyData_vt.get(i);
		%>
		if(loantype == '<%= E05MaxMoneyData.LOAN_CODE %>'){
			max_money = Number('<%= WebUtil.printNum( E05MaxMoneyData.LOAN_MONY ) %>');
		}
		<%
	    }
		%>
		
		if(max_money < 0) {
			max_money = 0;
		}
		
		return max_money;
	};
	


	var requestEvent = function() {
		if( !requestCheck() ) return; 
		
		if(confirm("신청 하시겠습니까?")){
			$("#requestBtn").off("click");
			
			var paramArr = $("#form1").serializeArray();
			var gridArray = $("#decisionerGrid").jsGrid("option", "data");
			$.each(gridArray, function(i, data){
				for (var key in data) {
					if (data.hasOwnProperty(key)) {
						paramArr.push({name:key, value:data[key]});
					}
				}
			});
			
			jQuery.ajax({
				type : 'POST',
				url : '/manager/supp/requestHouseFund.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("신청 되었습니다.");
	    				//reset
	    				$("#form1").each(function() {
	    					this.reset();  
	    				});
	    				$("#decisionerGrid").jsGrid("search");
	    				
	    			}else{
	    				alert("신청시 오류가 발생하였습니다. " + response.message);
	    			}
	    			
	    			$("#requestBtn").on("click", function(){
	    				requestEvent();
	    			});
	    		}
			});
		}
	};
	
	$(function() {
		$("#houseFundList").jsGrid({
			height: "auto",
	        width: "100%",
	        sorting: true,
            paging: true,
            pageSize: 10,
            pageButtonCount: 10,
	        autoload: true,
			controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/manager/supp/getHouseFundList.json",
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
           			itemTemplate: function(_, item) {
           				return $("<input name='chk'>")
           					   .attr("type", "radio")
           					   .on("click", function(e) {
           						getHouseFundDetail(item);
           					   });
           			},
           			align: "center",
           			width: "6%"
           		},
                { title: "융자일자", name: "DATBW", type: "text", align: "center", width: "10%" },
                { title: "융자형태", name: "STEXT", type: "text", align: "center", width: "18%" },

                
                
                { title: "융자원금", name: "DARBT", type: "text", align: "right", width: "14%" ,
           		 	itemTemplate: function(value) {
	                    return value.format();}
           		},
                { title: "상환원금", name: "REDEMPTION", type: "text", align: "right", width: "14%" ,
           		 	itemTemplate: function(value) {
	                    return value.format();}
           		},
                { title: "잔여원금", name: "BETRG", type: "text", align: "right", width: "14%", 
           		 	itemTemplate: function(value) {
	                    return value.format();}
           		},
                { title: "상환완료일자", name: "ZAHLD", type: "text", align: "center", width: "10%" },
                { title: "일시상환금액", name: "REDARBT", type: "text", align: "right", width: "14%",
           		 	itemTemplate: function(value) {
	                    return value.format();}
           		}
                
       		]
		});
	});	
	
	var changeYYYYMMDD = function(nonDate) {
		var nonDate = nonDate;
		var date = nonDate.substr(0,4)+"."+nonDate.substr(4,2)+"."+nonDate.substr(6,2);
		return date;
	}
	
	var changeYYYYMM = function(nonDate) {
		var nonDate = nonDate;
		var date = nonDate.substr(0,4)+"."+nonDate.substr(4,2);
		return date;
	}
	
	
	var getHouseFundDetail = function(item) {
			jQuery.ajax({
				type : 'POST',
				url : '/manager/supp/getHouseFundDetail.json',
				cache : false,
				dataType : 'json',
				data : {
					 "SUBTY" : item.SUBTY,
					 "BEGDA" : item.BEGDA,
					 "ENDDA" : item.ENDDA,
					 "BETRG" : item.BETRG
				},
				async :false,
				success : function(response) {
	    			if(response.success){
	    				var json_Data = response.storeData;
						    $('#E_DARBT_tab3').text(json_Data.E_DARBT.format());
       						$('#E_TILBT').text(json_Data.E_TILBT.format());
       						$('#E_DATBW_tab3').text(json_Data.E_DATBW);
       						$('#E_BETRG').text(json_Data.E_BETRG.format());
       						$('#E_ZZRPAY_MNTH_TO_E_ENDDA').text(changeYYYYMM(json_Data.E_ZZRPAY_MNTH) +'~'+ changeYYYYMM(json_Data.E_ENDDA));
       						$('#E_TILBT_BETRG').text(json_Data.E_TILBT_BETRG.format());
       						$('#E_ZZRPAY_CONT').text(json_Data.E_ZZRPAY_CONT.format());
       						$('#E_ZZSECU_FLAG_tab3').text((json_Data.E_ZZSECU_FLAG=="Y")?"보증인":"보험가입");
       						
       						$('#E_TOTAL_DARBT').text(json_Data.E_TOTAL_DARBT.format());
       						$('#E_DARBT_BEGDA_TO_E_DARBT_ENDDA').text(changeYYYYMM(json_Data.E_DARBT_BEGDA) +'~'+changeYYYYMM(json_Data.E_DARBT_ENDDA));
       						$('#E_TOTAL_INTEREST').text(json_Data.E_TOTAL_INTEREST.format());
       						$('#E_TOTAL_CONT').text(json_Data.E_TOTAL_CONT.format());
       						$('#E_REMAIN_BETRG').text(json_Data.E_REMAIN_BETRG.format());
       						$('#E_REMAIN_CONT').text(json_Data.E_REMAIN_CONT.format());
	    			}else{
	    				alert("신청시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
	};

	var getPersonLoanForRepay = function() {
		jQuery.ajax({
			type : 'POST',
			url : '/manager/supp/getPersonLoanForRepay.json',
			cache : false,
			dataType : 'json',
			data : { "UPMUTYPE" : "13" },
			async :false,
			success : function(response) {
    			if(response.success){

    				var json_Data = response.storeData;
    				    $('#E_RPAY_AMNT').val(json_Data.E_RPAY_AMNT.format());
					    $('#E_INTR_AMNT').val(parseInt(json_Data.E_INTR_AMNT).format());
					    $('#E_TOTAL_AMNT').val(json_Data.E_TOTAL_AMNT.format());
					    $('#E_DARBT').val(json_Data.E_DARBT.format());
					    $('#E_DATBW').val(json_Data.E_DATBW);
					    $('#E_ALREADY_AMNT').val(json_Data.E_ALREADY_AMNT.format());
					    $('#E_REMAIN_AMNT').val(json_Data.E_REMAIN_AMNT.format());
					    $('#E_ZZSECU_FLAG_TEXT').val(json_Data.E_ZZSECU_FLAG_TEXT);
					
					var personLoanData = response.personLoanData[0];
					
					var key = response.key;
					$('#I_LOAN_CODE').val(key.I_LOAN_CODE);
					$('#I_BETRG').val(key.I_BETRG);
					$('#idate').val(key.I_DATE);
					$('#I_DATE').val(changeYYYYMMDD(key.I_DATE));
					
    			}else{
    				alert(response.message + "  신규신청 화면으로 돌아갑니다.");
    				location.reload();
    			}
    		}
		});
};	


var getPersonLoanForRepaySecond = function() {
	
	var tmpLoanCode = $('#I_LOAN_CODE').val();
	
	jQuery.ajax({
		type : 'POST',
		url : '/manager/supp/getPersonLoanForRepaySecond.json',
		cache : false,
		dataType : 'json',
		data : { "UPMUTYPE"    : "13" ,
				 "I_LOAN_CODE" : $('#I_LOAN_CODE').val() ,
				 "I_BETRG"     : $('#I_BETRG').val() ,
				 "I_DATE"      : $('#idate').val() ,
			   },
		
		async :false,
		success : function(response) {
			if(response.success){

				var json_Data = response.storeData;
				var personLoanData = response.personLoanData[0];
				var key = response.key;

				//alert("!" + personLoanData.DLART + " :" + tmpLoanCode);
				if(personLoanData.DLART != tmpLoanCode){
					alert("해당 유형은 상환 신청을 할 수 없습니다.")
					$('#requestBtn2').hide();
				}else{
					$('#requestBtn2').show();
				}
				//json_Data
				$('#E_RPAY_AMNT').val(json_Data.E_RPAY_AMNT.format());
			    $('#E_INTR_AMNT').val(parseInt(json_Data.E_INTR_AMNT).format());
			    $('#E_TOTAL_AMNT').val(json_Data.E_TOTAL_AMNT.format());
			    $('#E_DARBT').val(json_Data.E_DARBT.format());
			    $('#E_DATBW').val(json_Data.E_DATBW);
			    $('#E_ALREADY_AMNT').val(json_Data.E_ALREADY_AMNT.format());
			    $('#E_REMAIN_AMNT').val(json_Data.E_REMAIN_AMNT.format());
			    $('#E_ZZSECU_FLAG_TEXT').val(json_Data.E_ZZSECU_FLAG_TEXT);
			    //personLoanData				
				$('#I_LOAN_CODE').val(personLoanData.DLART);
				//key				
				$('#I_LOAN_CODE').val(key.I_LOAN_CODE);
				$('#I_BETRG').val(key.I_BETRG);
				$('#idate').val(key.I_DATE);
				$('#I_DATE').val(changeYYYYMMDD(key.I_DATE));

			}else{
				alert("신청시 오류가 발생하였습니다. " + response.message);
			}
		}
	});
};	



var requestRepay = function() {
	if( !requestCheck2() ) return; 
	
	if(confirm("신청 하시겠습니까?")){
		$("#requestBtn2").off("click");
		
		var paramArr = $("#form2").serializeArray();
		var gridArray = $("#decisionerGrid2").jsGrid("option", "data");
		$.each(gridArray, function(i, data){
			for (var key in data) {
				if (data.hasOwnProperty(key)) {
					paramArr.push({name:key, value:data[key]});
				}
			}
		});
		
		jQuery.ajax({
			type : 'POST',
			url : '/manager/supp/requestHouseRefund.json',
			cache : false,
			dataType : 'json',
			data : paramArr,
			async :false,
			success : function(response) {
    			if(response.success){
    				alert("신청 되었습니다.");
    				//reset
    				$("#form2").each(function() {  
    					this.reset();  
    				});
    				$("#decisionerGrid2").jsGrid("search");
    				
    			}else{
    				alert("신청시 오류가 발생하였습니다. " + response.message);
    			}
    			
    			$("#requestBtn2").on("click", function(){
    				requestRepay();
    			});
    		}
		});
	}
};

	
</script>

