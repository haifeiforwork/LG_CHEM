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
	WebUserData user = (WebUserData)session.getValue("user");
	E05PersInfoData E05PersInfoData    = (E05PersInfoData)request.getAttribute("E05PersInfoData");
	Vector          E05MaxMoneyData_vt = (Vector)request.getAttribute("E05MaxMoneyData_vt");
	String          E_WERKS            = (String)request.getAttribute("E_WERKS");
	String      e_requestFlagBuy  = (String)request.getAttribute("e_requestFlagBuy");
    String      e_requestFlagRent  = (String)request.getAttribute("e_requestFlagRent");
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
<!--// Tab start -->
	<div class="tabArea">
		<ul class="tab">
			<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">주택자금 신규신청</a></li>
			<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">주택자금 상환신청</a></li>
			<li><a href="#" id="tab3" onclick="switchTabs(this, 'tab3');" >주택지원내역</a></li>
		</ul>
	</div>
<!--// Tab end -->
				<!--// Tab1 start -->
				<div class="tabUnder tab1">
					<form id="form1">	
					<!--// Table start -->
					<div class="tableArea">
						<h2 class="subtitle">주택자금 신규신청</h2>
						<div class="table pb10">
							<table class="tableGeneral">
							<caption>신청서 작성</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" id="BEGDA" readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="DLART">주택융자유형</label></th>
								<td>
                                   <select class="w150" id="DLART" name="DLART" required vname="주택융자유형">
                                   		<option value="" selected>------------</option>
										<%= WebUtil.printOption((new E05LoanCodeRFC()).getLoanType()) %>
									</select>
                                </td>
                            </tr>
                            <tr>
								<th><label for="inputText01-3">현주소</label></th>
								<td>
									<input class="readOnly wPer" type="text" name="E_STRAS" id="E_STRAS" value="<%=E05PersInfoData.E_STRAS%>" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="E_YEARS">근속년수</label></th>
								<td>
									<input class="alignRight w120 readOnly" type="text" name="E_YEARS" id="E_YEARS" value="<%=E05PersInfoData.E_YEARS%>" readonly /> 년
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="REQU_MONY">신청금액</label></th>
								<td>
									<input class="inputMoney w120" type="text" id="REQU_MONY" name="REQU_MONY" onkeyup="cmaComma(this);" onchange="cmaComma(this);" value="" required vname="신청금액"/> 원
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="GUBN_FLAG">상환방법</label></th>
								<td>
                                   <input type="radio" name="GUBN_FLAG" id="GUBN_FLAG1" value="P" checked/><label for="GUBN_FLAG1">정기급여</label> 
				                    <% if ( user.e_persk.equals("31")){  %>
				                       <input type="radio" name="GUBN_FLAG" id="GUBN_FLAG2" value="B"/><label for="GUBN_FLAG2">정기급여 + 정기상여 상환</label>
				                    <% } %>
                                </td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="ZZFUND_CODE">자금용도</label></th>
								<td>
                                   <select class="w150" id="ZZFUND_CODE" name="ZZFUND_CODE" required vname="자금용도">
										<option value="">------------</option>
									</select>
                                </td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="input-radio02-1">보증여부</label></th>
								<td>
									<input type="radio" name="ZZSECU_FLAG" value="Y" id="ZZSECU_FLAG1" checked="checked" /><label for="ZZSECU_FLAG1">연대보증인 입보</label>
									<input type="radio" name="ZZSECU_FLAG" value="N" id="ZZSECU_FLAG2" /><label for="ZZSECU_FLAG2">보증보험가입희망</label>
									<!-- <input type="radio" name="ZZSECU_FLAG" value="R" id="ZZSECU_FLAG3" /><label for="ZZSECU_FLAG3">퇴직금예상액 ½ 한도적용</label> -->
                                </td>
							</tr>
							</tbody>
							</table>
						</div>
					</div>	
					<!--// Table end -->
					<!--// list start -->
					<div class="listArea" id="decisioner">
					</div>
					<!--// list end -->
					
										
					<div class="buttonArea">
						<ul class="btn_crud">
						<c:if test="${selfApprovalEnable == 'Y'}">
							<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
						</c:if>
							<li><a class="darken" href="#" id="requestBtn"><span>신청</span></a></li>
						</ul>
					</div>
					
					</form>
				</div>
				<!--// Tab1 end -->
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">
				
				<form id = "dataCountRefund" name="dataCountRefund">
					<div class="errorArea">
						<div class="errorMsg">
							<div class="errorImg"><!-- 에러이미지 --></div>
							<div class="alertContent">
								<p>해당하는 데이터가 존재하지 않습니다.</p>
							</div>
						</div>
					</div>
				</form>
				
				
				
					<form id="form2">
					<!--// Table start -->	
					<div class="tableArea">
						<h2 class="subtitle">주택자금 상환신청</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>신청서 작성</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td class="tdDate">

									<input class="readOnly" type="text"  name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputSelect01-2">주택융자유형</label></th>
								<td>
                                   <select class="w150" id="I_LOAN_CODE" name="I_LOAN_CODE" required vname="주택융자유형"> 
                                   		<option value="">------------</option>
										<%= WebUtil.printOption((new E05LoanCodeRFC()).getLoanType()) %>
									</select>
                                </td>
                            </tr>
                            <tr>
								<th><label for="inputText01-3">상환원금</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="E_RPAY_AMNT" value="" readonly> 원
								</td>
							</tr>
							<tr>
								<th><label for="inputText01-4">주택자금이자</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="E_INTR_AMNT" value="" readonly> 원	
								</td>
							</tr>
							<tr>
								<th><label for="inputText01-5"><strong class="colorBlue">총상환금액</strong></label></th>
								<td>
									<input class="inputMoney w120 readOnly colorBlue" type="text" id="E_TOTAL_AMNT" value="" readonly> 원
								</td>
							</tr>
							<tr>
                                <th><span class="textPink">*</span><label for="inputDateDay">상환액 입금일자</label></th>
								<td colspan="3" class="tdDate">
                                   <input class="datepicker" type="text" size="5" id="I_DATE" required vname="상환액 입금일자"/>
                                </td>
							</tr>
							<tr>
								<th><label for="inputSelect01-7">대출금액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="E_DARBT" value="" readonly> 원
                                </td>
							</tr>	
							<tr>
								<th><label for="inputSelect01-7">대출일자</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="E_DATBW" value="" readonly>
                                </td>
							</tr>	
							<tr>
								<th><label for="input-radio02-1">기상환액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="E_ALREADY_AMNT" value="" readonly> 원
							    </td>
							</tr>	
							<tr>
								<th><label for="inputSelect01-7">대출잔액</label></th>
								<td>
									<input class="inputMoney w120 readOnly" type="text" id="E_REMAIN_AMNT" value="" readonly> 원
                                </td>
							</tr>	
							<tr>
								<th><label for="input-radio02-1">보증여부</label></th>
								<td><input type="hidden" name="E_ZZSECU_FLAG" id="E_ZZSECU_FLAG" value="">
									<input type="hidden" name="I_BETRG" id="I_BETRG" value="">
									<input type="hidden" name="idate" id="idate" value="">
									<input type="hidden" name="fromdate" id="fromdate"  value='<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>'>
								
									<input class="w120 readOnly" type="text" id="E_ZZSECU_TXT" value="연대보증인입보" readonly>
							    </td>
							</tr>
							</tbody>
							</table>
						</div>
						<div class="tableComment">
							<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA </span></p>
							<ul>
								<li>주택자금을 입금할 경우 본인임을 확인할 수 있도록 무통장 입금증에 본인의 실명을 입력하여 주십시오.</li>
								<li>매월 21일부터 말일까지는 주택자금을 상환할 수 없습니다.</li>
							</ul>
						</div>
					</div>
					<!--// Table end -->
					<!--// list start -->
					<div class="listArea" id="decisioner2">	
					</div>
					<!--// list end -->
					<div class="buttonArea">
						<ul class="btn_crud">
						<c:if test="${selfApprovalEnable == 'Y'}">
							<li><a href="#" id="requestNapprovalBtn2"><span>자가승인</span></a></li>
						</c:if>
							<li><a class="darken" href="#" id="requestBtn2"><span>신청</span></a></li>
						</ul>
					</div>
					</form>
				</div>
				<!--// Tab2 end -->
				
				<!--// Tab3 start -->
				<div class="tabUnder tab3 Lnodisplay">
					<!--// list start -->
					<div class="listArea">		
						<h2 class="subtitle withButtons">주택지원내역</h2>
						<div class="clear"></div>
						<div id="jsGrid3-1" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
	    				<div id="houseFundList"></div>
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
		requestRepay(false);
	});
	
	$("#requestNapprovalBtn2").click(function(){
		requestRepay(true);
	});
	
	$("#requestBtn").click(function(){
		requestEvent(false);
	});
	$("#requestNapprovalBtn").click(function(){
		requestEvent(true);
	});
	
	var requestCheck = function(){
		//필수값 체크
		if(!checkNullField("form1")) return false;

		var requ_mony = Number(numberOnly($("#REQU_MONY").val()));
		if( requ_mony <= 0 ) {
			alert("신청금액은 0 원보다 커야합니다.");
			return false;
		}
		
		if("N" == '<%= e_requestFlagBuy %>'){
			alert("이미 신청 건(구입자금)이 있습니다.");
		return false;
		}
		
		if("N" == '<%= e_requestFlagRent %>'){
			alert("이미 신청 건(전세자금)이 있습니다.");
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
    		url : "/supp/getFundCode.json",
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
	


	var requestEvent = function(self) {
		if( !requestCheck() ) return; 
		//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
		var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
		decisionerGridChangeAppLine(self);
		if(confirm(msg + "신청 하시겠습니까?")){
			$("#requestBtn").off("click");
			$("#requestNapprovalBtn").off("click");
			
			var paramArr = $("#form1").serializeArray();
			var gridArray = $("#decisionerGrid").jsGrid("option", "data");
			$.each(gridArray, function(i, data){
				for (var key in data) {
					if (data.hasOwnProperty(key)) {
						paramArr.push({name:key, value:data[key]});
					}
				}
			});
			paramArr.push({"name":"selfAppr", "value" : self});
			
			jQuery.ajax({
				type : 'POST',
				url : '/supp/requestHouseFund.json',
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
	    				requestEvent(false);
	    			});
	    			$("#requestNapprovalBtn").click(function(){requestEvent(true);});
	    		}
			});
		} else {
			decisionerGridChangeAppLine(false);
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
	        autoload: false,
			controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/supp/getHouseFundList.json",
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
				url : '/supp/getHouseFundDetail.json',
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
			url : '/supp/getPersonLoanForRepay.json',
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
					$("#dataCountRefund").hide();
					$("#form2").show();

					if($('#E_REMAIN_AMNT').val()=='0'){
	    				$("#dataCountRefund").show();
	    				$("#form2").hide();
					}
    			}else{
    				$("#dataCountRefund").show();
    				$("#form2").hide();
    			}
    		}
		});
};	


var getPersonLoanForRepaySecond = function() {
	
	var tmpLoanCode = $('#I_LOAN_CODE').val();
	
	jQuery.ajax({
		type : 'POST',
		url : '/supp/getPersonLoanForRepaySecond.json',
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



var requestRepay = function(self) {
	if( !requestCheck2() ) return; 
	
	//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
	var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
	decisionerGrid2ChangeAppLine(self);
	if(confirm(msg + "신청 하시겠습니까?")){
		$("#requestBtn2").off("click");
		$("#requestNapprovalBtn2").off("click");
		
		var paramArr = $("#form2").serializeArray();
		var gridArray = $("#decisionerGrid2").jsGrid("option", "data");
		$.each(gridArray, function(i, data){
			for (var key in data) {
				if (data.hasOwnProperty(key)) {
					paramArr.push({name:key, value:data[key]});
				}
			}
		});
		paramArr.push({"name":"selfAppr", "value" : self});
		
		jQuery.ajax({
			type : 'POST',
			url : '/supp/requestHouseRefund.json',
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
    				requestRepay(false);
    			});
    			$("#requestNapprovalBtn2").on("click", function(){
    				requestRepay(true);
    			});
    		}
		});
	} else {
		decisionerGrid2ChangeAppLine(false);
	}
};

	
</script>

