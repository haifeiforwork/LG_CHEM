<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%
	E19CongcondData  e19CongcondData      = (E19CongcondData)request.getAttribute("e19CongcondData");
	Vector e19CongCode = (Vector)request.getAttribute("e19CongCode");
	Vector E19CongcondData_opt = (Vector)request.getAttribute("e19CongcondData_opt");
	Vector E19CongcondData_rate = (Vector)request.getAttribute("e19CongcondData_rate");
%>
<!-- contents start -->
	<!--// Page Title start -->
	<div class="title">
		<h1>경조금</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">My Info</a></span></li>
				<li><span><a href="#">복리후생</a></span></li>
				<li class="lastLocation"><span><a href="#">경조금</a></span></li>
			</ul>						
		</div>
	</div>
<!--// Page Title end -->			
<!--// Tab start -->
	<div class="tabArea">
		<ul class="tab">
			<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">경조금신청</a></li>
			<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">경조금 지원내역</a></li>
		</ul>
	</div>
<!--// Tab end -->
				<!--// Tab1 start -->
				<div class="tabUnder tab1">									
					<!--// Table start -->	
					<form name="form1" id="form1">
					<div class="tableArea">
						<h2 class="subtitle">신청서 작성</h2>
						<div class="table pb10">
							<table class="tableGeneral">
							<caption>신청서 신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" id="BEGDA" readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="CONG_CODE">경조내역</label></th>
								<td colspan="3">
									<select class="w150" id="CONG_CODE" name="CONG_CODE" required vname="경조내역">
										<option value="">-------------</option>
										<!-- 경조내역 option -->
										<%=  e19CongcondData.CONG_CODE.equals("") ? WebUtil.printOption(e19CongCode) : WebUtil.printOption(e19CongCode, e19CongcondData.CONG_CODE )%>
										<!-- 경조내역 option -->
									</select>
                                </td>
                            </tr>
                            <tr>
								<th><span class="textPink">*</span><label for="RELA_CODE">경조대상자 관계</label></th>
								<td>
									<select class="w150" id="RELA_CODE" name="RELA_CODE" required vname="경조대상자 관계"> 
										<option value="">-------------</option>
									</select>
								</td>
								<th><span class="textPink">*</span><label for="EREL_NAME">경조대상자 성명</label></th>
								<td><input class="w150" type="text" name="EREL_NAME" value="<%= e19CongcondData.EREL_NAME %>" id="EREL_NAME" required vname="경조대상자 성명" /></td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="CONG_DATE">경조발생일자</label></th>
								<td colspan="3">
                                   <input id="CONG_DATE" class="datepicker" name="CONG_DATE"  type="text" size="5"  value="<%= e19CongcondData.CONG_DATE.equals("0000.00.00") ? "" : WebUtil.printDate(e19CongcondData.CONG_DATE) %>" required vname="경조발생일자"/>
                                </td>
							</tr>						
							</tbody>
							</table>
						</div>
						<div class="table">
							<table class="tableGeneral">
							<caption>신청서 자동출력</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText02-1">月 기준급</label></th>
								<td colspan="3">
									<input class="inputMoney w120 readOnly" type="text" id="WAGE_WONX" name="WAGE_WONX" value="<%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%>" readonly /> 원
								</td>
							</tr>
							<tr>
								<th><label for="inputText02-2">지급율</label></th>
								<td colspan="3">
									<input class="alignRight w120 readOnly" type="text" id="CONG_RATE" name="CONG_RATE" value="<%= e19CongcondData.CONG_RATE %>" readonly /> %
                                </td>
                            </tr>
                            <tr>
								<th><label for="inputText02-3">경조금액</label></th>
								<td colspan="3">
									<input class="inputMoney w120 readOnly" type="text" id="CONG_WONX" name="CONG_WONX" value="<%=e19CongcondData.CONG_WONX.equals("") ? "" : WebUtil.printNumFormat(e19CongcondData.CONG_WONX)%>" readonly /> 원
								</td>
							</tr>
							<tr>
								<th><label for="inputText02-4">이체은행명</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="BANK_NAME" name="BANK_NAME" value="<%= e19CongcondData.BANK_NAME %>" readonly />
								</td>
								<th><label for="inputText02-5">은행계좌번호</label></th>
								<td>
									<input class="w120 readOnly" type="text" name="BANKN" value="<%= e19CongcondData.BANKN %>" id="BANKN" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="HOLI_CONT">경조휴가일수</label></th>
								<td colspan="3">
									<div id="HOLI_CONT1" style="display:block;">
									<input class="alignRight w120 readOnly" type="text" name="HOLI_CONT" value="<%= e19CongcondData.HOLI_CONT.equals("") ? "" : WebUtil.printNum(e19CongcondData.HOLI_CONT) %>" id="HOLI_CONT" readonly /> 일
									</div>
									<div id="HOLI_CONT2" style="display:none;">
										Help 참조
									</div>
								</td>
							</tr>
							<tr>
								<th><label for="inputText02-7">근속년수</label></th>
								<td colspan="3">
                                   <input class="alignRight w50 readOnly" type="text" name="WORK_YEAR" id="WORK_YEAR" readonly value="<%= ( e19CongcondData.WORK_YEAR.equals("") || e19CongcondData.WORK_YEAR.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>" /> 년
                                   <input class="alignRight w50 readOnly" type="text" name="WORK_MNTH" id="WORK_MNTH" readonly value="<%= ( e19CongcondData.WORK_MNTH.equals("") || e19CongcondData.WORK_MNTH.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>"/> 개월
                                </td>
							</tr>						
							</tbody>
							</table>
						</div>
					</div>	
					</form>
					<!--// Table end -->
					<!--// 결재그리드 start -->
					<div class="listArea" id="decisioner"></div>	
					<!--// 결재그리드 end -->	
					<div class="buttonArea">
						<ul class="btn_crud">
						<c:if test="${selfApprovalEnable == 'Y'}">
							<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
						</c:if>
							<li><a class="darken" href="#" id="requestBtn"><span>신청</span></a></li>
						</ul>
					</div>				
				</div>	
				<!--// Tab1 end -->	
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">
					<!--// list start -->
					<div class="listArea">
						<h2 class="subtitle">경조금 지원내역</h2>
						<div id="eventMoneyGrid"  class="jsGridPaging"></div>
					</div>
					<!--// list end -->
					
					<!--// Table start -->	
					<form id="detailForm">
					<div class="tableArea">	
						<h2 class="subtitle">경조금 상세내역</h2>		
						<div class="table">
							<table class="tableGeneral">
							<caption>경조금 상세내역</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="DETAIL_CONG_DATE">경조발생일자</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_CONG_DATE" readonly />
								</td>
								<th><label for="DETAIL_CONG_NAME">경조내역</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_CONG_NAME" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="DETAIL_RELA_NAME">경조대상자 관계</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_RELA_NAME" readonly />
								</td>
								<th><label for="DETAIL_EREL_NAME">경조대상자 성명</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_EREL_NAME" readonly />
								</td>
                            </tr>
							<tr>
								<th><label for="DETAIL_WAGE_WONX">月 기준급</label></th>
								<td colspan="3">
									<input class="inputMoney w120 readOnly" type="text" id="DETAIL_WAGE_WONX" readonly /> 원
								</td>
							</tr>
							<tr>
								<th><label for="DETAIL_CONG_RATE">지급율</label></th>
								<td colspan="3">
									<input class="alignRight w120 readOnly" type="text" id="DETAIL_CONG_RATE" readonly /> %
                                </td>
                            </tr>
                            <tr>
								<th><label for="DETAIL_CONG_WONX">경조금액</label></th>
								<td colspan="3">
									<input class="inputMoney w120 readOnly" type="text" id="DETAIL_CONG_WONX" readonly /> 원
								</td>
							</tr>
							<tr>
								<th><label for="DETAIL_BANK_NAME">이체은행명</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_BANK_NAME" readonly />
								</td>
								<th><label for="DETAIL_BANKN">은행계좌번호</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_BANKN" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="DETAIL_HOLI_CONT">경조휴가일수</label></th>
								<td colspan="3">
									<input class="alignRight w120 readOnly" type="text" id="DETAIL_HOLI_CONT" readonly /> 일
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-11">근속년수</label></th>
								<td colspan="3">
                                   <input class="alignRight w50 readOnly" type="text" id="DETAIL_WORK_YEAR" readonly /> 년
                                   <input class="alignRight w50 readOnly" type="text" id="DETAIL_WORK_MNTH" readonly /> 개월
                                </td>
							</tr>						
							</tbody>
							</table>
						</div>
					</div>
					</form>
					<!--// Table end -->
				</div>
				<!--// Tab2 end -->
<!-- 프린트 영역 팝업-->		
<div id="hiddenPrint" style="width:700px;"></div>
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>경조금 신청서</strong>
		<a href="#" class="btnClose popLayerPrint_close" onClick="setHidden(true);">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer">
			<div id="printBody">
				<iframe name="eventMoneyPrintPopup" id="eventMoneyPrintPopup" src="" frameborder="0" scrolling="no" style="float:left; height:1000px; width:700px;"></iframe>
			</div>
		</div>
	</div>
	<div class="buttonArea buttonPrint">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="printPopBtn"><span>프린트</span></a></li>								
		</ul>
	</div>	
	<div class="clear"> </div>	
</div>
<!-- 프린트 영역 -->
<script type="text/javascript">

	$(document).ready(function(){
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=01&gridDivId=decisionerGrid');
		$("#CONG_CODE").change(function(){CONG_CODE();});		
		$("#RELA_CODE").change(function(){RELA_CODE();});
		$("#CONG_DATE").change(function(){event_CONG_DATE();});
		$("#requestBtn").click(function(){requestEvent(false);});
		//자가승인 클릭시(팀장 이상만)
		$("#requestNapprovalBtn").click(function(){requestEvent(true);});
		$("#tab2").click(function(){getEventMoney();});
		$("#printPopBtn").click(function(){
			setHidden(false);
			$("#hiddenPrint").print();
		});
	});
	
	var CONG_CODE = function() {
		//계산부분 reset
		$("#CONG_RATE").val("");
		$("#CONG_WONX").val("");
		$("#HOLI_CONT").val("");
		
		//RELA_CODE 조회
		var val = $("#CONG_CODE").val();
		
		$('#RELA_CODE').empty();
		$('#RELA_CODE').append('<option value=\"\">-------------</option>');
	<%
	    int inx = 0;
	    String before = "";
	    for( int i = 0 ; i < E19CongcondData_opt.size() ; i++ ) {
	        E19CongcondData data = (E19CongcondData)E19CongcondData_opt.get(i);
	        if( before.equals(data.CONG_CODE) ) {
	        	
	        }
	%>
    		if(val == '<%=data.CONG_CODE%>'){
				$('#RELA_CODE').append('<option value=' + '<%=data.RELA_CODE%>' + '>' + '<%=data.RELA_NAME%>' + '</option>');
			}
	<%
	    }     //for문
	%>
 	
		$('#RELA_CODE').val("");
	
	};
	
	//경조대상자 관계코드
	var RELA_CODE = function() {
		var val = $("#RELA_CODE").val();
		var disa = $("#CONG_CODE").val();
	//  C2004042001000000069 - 돌반지 신청 시 금액을 입력하지 못하게 하고, 결재 시 담당자가 금액 입력 하도록 함. 이 때 자동전표는 생성되지 않고 이력만 관리하도록 함
	//  돌반지일경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
	    if( disa == "0006" ){ 
	    	<%
	        for( int i = 0 ; i < E19CongcondData_rate.size() ; i++ ) {
	            E19CongcondData data_rate = (E19CongcondData)E19CongcondData_rate.get(i);
	    %>    
	        } else if( val == "<%=data_rate.RELA_CODE%>" && disa == "<%=data_rate.CONG_CODE%>" ){
	        	$("#CONG_RATE").val("<%=data_rate.CCON_RATE%>"); //지급율 % 
	            
//	          2002.07.03. 조위이면서 부모, 배우자부모일경우에는 일수가 아닌 text를 보여준다. 요청자 : 성경호, 수정자 : 김도신
				//2017.01.06 불필요한 로직이라 삭제요청. 요청자 : LGMMA 홍성민
				/*
	            if( disa == "0003" && (val == "0002" || val == "0003") ) {
	            	$("#HOLI_CONT1").hide();
	            	$("#HOLI_CONT2").show();
	            } else {
	            	$("#HOLI_CONT1").show();
	            	$("#HOLI_CONT2").hide();
	            }
	        	*/
	            $("#HOLI_CONT").val('<%=data_rate.HOLI_CONT.equals("") ? "" : WebUtil.printNum(data_rate.HOLI_CONT)%>');//경조휴가일수
	            $("#CONG_WONX").val(cal_money());//계산된 경조금

	    <%
	        } 
	    %>	    		
	    }
	};
	
	var setHoli = function(CONG_CODE, RELA_CODE) {
//      2002.07.03. 조위이면서 부모, 배우자부모일경우에는 일수가 아닌 text를 보여준다. 요청자 : 성경호, 수정자 : 김도신
		if( CONG_CODE == "0003" && (RELA_CODE == "0002" || RELA_CODE == "0003") ) {
        	$("#printForm [name='HOLI_CONT']").text("Help 참조");
		}
	};
	//경조금 계산(근속년수가 LG MMA-1년미만시 지급율의 50%를 지급)
	var cal_money = function() {
	    var money = 0 ;
	    var rate = 0;
	    var wage = 0;
	    var compCode = 0;

	    rate = Number($("#CONG_RATE").val());
	    wage = Number(numberOnly($("#WAGE_WONX").val()));           // @v1.1

	    money = ( rate * wage )/100;

	    
	    WORK_YEAR = Number($("#WORK_YEAR").val());
	    WORK_MNTH = Number($("#WORK_MNTH").val());
		
	    if( WORK_YEAR < 1 ){//LG MMA-1년미만
	      money = money * 0.5 ;
	      $("#CONG_RATE").val(Number($("#CONG_RATE").val()) * 0.5) ; //지급율 % 도 50%로
	    }
	    
	    money = money_olim(money);
	    money = money.format();
	    return money;
	};
	
	var event_CONG_DATE = function() {
		var rtn = true;
		jQuery.ajax({
    		type : "POST",
    		url : "/supp/getServiceYearMonth.json",
    		cache : false,
    		dataType : "json",
    		data : {				
				 "CONG_DATE" : numberOnly($("#CONG_DATE").val())
			},
    		async :false,
    		success : function(response) {
    			if(response.success){
    				var item = response.storeData[0];
    				$('#WORK_YEAR').val(item.WORK_YEAR);
    				$('#WORK_MNTH').val(item.WORK_MNTH);
    				$('#WAGE_WONX').val(item.WAGE_WONX.format());
    				rela_action();
    			}
    			else{
    				alert(response.message);
    				rtn = false;
    			}
    		}
		});
		
		return rtn;
		
    };
    
    //경조금 신청시 중복신청을 체크
	var congraDupCheck = function() {
		var rtn = true;
		jQuery.ajax({
    		type : "POST",
    		url : "/supp/getCongraDupCheckList.json",
    		cache : false,
    		dataType : "json",
    		async :false,
    		success : function(response) {
    			if(response.success){
    				var items = response.storeData;
    				var WORK_YEAR = $('#WORK_YEAR').val();
    				var RELA_CODE = $('#RELA_CODE').val();
    				var disa = $("#CONG_CODE").val();
    				var EREL_NAME = $.trim($('#EREL_NAME').val());	//공백제거
    				for(var i=0;i<items.length;i++){
    					var item = items[0];
    					//  2003.02.20 - 경조금 신청시 중복신청을 체크하는 로직 추가
						//             - 신청사번에 대하여 동일 경조내역 & 동일 경조대상자 성명이 있는경우 신청하지 못한다
    					if(item.CONG_CODE == disa && item.RELA_CODE == RELA_CODE && item.EREL_NAME == EREL_NAME){
							//lg MMA : 본인 재혼은 제외 - Temp Table만 체크한다.
    						if( disa != "0009" || RELA_CODE != "0001"){
    							if(item.INFO_FLAG == "I"){
    								alert("해당 경조내역에 이미 동명의 경조대상자가 있습니다.");
    								rtn = false;
    								break;
    							}	
    						}
    						
    						if(item.INFO_FLAG == "T"){
    							alert("현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
    							rtn = false;
								break;
    						}
    					}
    				}

    			}
    			else{
    				alert(response.message);
    				rtn = false;
    			}
    		}
		});
		
		return rtn;
		
    };
    
 	// 경조발생일자 변경에 따른 Action - 돌반지는 재계산하지 않는다.
    var rela_action = function(obj) {
     	  var val = $('#RELA_CODE').val();
          var disa = $('#CONG_CODE').val();
        
    //  C2004042001000000069 - 돌반지 신청 시 금액을 입력하지 못하게 하고, 결재 시 담당자가 금액 입력 하도록 함. 이 때 자동전표는 생성되지 않고 이력만 관리하도록 함
    //  돌반지일경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
        if( disa == "0006" ){ 
        	$('#CONG_WONX').val(0);
    <%
                for( int i = 0 ; i < E19CongcondData_rate.size() ; i++ ) {
                    E19CongcondData data_rate = (E19CongcondData)E19CongcondData_rate.get(i);
    %>    
        } else if( val == "<%=data_rate.RELA_CODE%>" && disa == "<%=data_rate.CONG_CODE%>" ){
        	$('#CONG_RATE').val("<%=data_rate.CCON_RATE%>");//지급율 % 
        	$('#HOLI_CONT').val("<%=data_rate.HOLI_CONT.equals("") ? "" : WebUtil.printNum(data_rate.HOLI_CONT)%>");//경조휴가일수
        	$('#CONG_WONX').val(cal_money());//계산된 경조금
    <%
                } 
    %>
        }
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
			$("#decisionerGrid").jsGrid("serialize", paramArr);
			paramArr.push({"name":"selfAppr", "value" : self});
			jQuery.ajax({
				type : 'POST',
				url : '/supp/requestEventMoney.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("신청 되었습니다.");
	    				//신청서 프린트 팝업
	    				openPrintPop(response);
	    				//reset
	    				$("#form1").each(function() {this.reset();});
	    				$("#decisionerGrid").jsGrid("search");
	    				
	    			}else{
	    				alert("신청시 오류가 발생하였습니다. " + response.message);
	    			}
	    			
	    			$("#requestBtn").on("click", function(){requestEvent();});
	    			$("#requestNapprovalBtn").click(function(){requestEvent(true);});
	    		}
			});
		} else {
			decisionerGridChangeAppLine(false);
		}
	};
	
	var openPrintPop = function(response){
		$("#eventMoneyPrintPopup").attr("src","/supp/eventMoneyPrint?AINF_SEQN=" + response.storeData.AINF_SEQN);
		$("#eventMoneyPrintPopup").load(function(){
			$('#popLayerPrint').popup("show");
		});
		
	}
	
	//경조금 신청 체크
	var requestCheck = function(){
		//필수값 체크
		if(!checkNullField("form1")) return false;		
		if(!congraDupCheck()) return false;		
		if($("#BANK_NAME").val() == "" || $("#BANKN").val() == "") {
			alert("입금될 계좌정보가 명확하지 않습니다.\n\n  인사담당자에게 문의해 주세요");
		    return false;
		}
		//  C2004042001000000069 - 돌반지 신청 시 금액을 입력하지 못하게 하고, 결재 시 담당자가 금액 입력 하도록 함. 이 때 자동전표는 생성되지 않고 이력만 관리하도록 함
		var CONG_WONX = Number(numberOnly($("#CONG_WONX").val()));
		var disa = $("#CONG_CODE").val();		
		if(disa != "0006" && CONG_WONX == 0){
			alert(" 입력값이 적합하지 않습니다. ");
			$("#CONG_WONX").focus();
			return false;
		}
		
		//경조사 발생 3개월초과시 에러처리
		var begin_date = numberOnly($("#BEGDA").val());
	    var congra_date = numberOnly($("#CONG_DATE").val());		
	    betw = getAfterMonth(addSlash(congra_date), 3);
	    dif = dayDiff(addSlash(begin_date), addSlash(betw));
	    betw2 = getAfterMonth(addSlash(begin_date), 3);
	    dif2 = dayDiff(addSlash(congra_date), addSlash(betw2));
	    if(dif < 0){
	        alert('경조를 신청할수 없습니다.\n\n경조발생일로부터 3개월 이전부터 신청할수 있습니다.');
	        return false;
	    }
	    if(dif2 < 0) {
	        alert('경조를 신청할수 없습니다.\n\n경조발생일로부터 3개월 이후에는 신청할수 없습니다.');
	        return false;
	    }
		// 경조발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다. -->필요한가...
		return true;
	};
	
	//경조금 지원내역 탭 클릭
	var getEventMoney = function(){
		$("#eventMoneyGrid").jsGrid("search");
		//reset
		$("#detailForm").each(function() {this.reset();});
	}
	
	//경조금 지원내역 그리드
	$(function() {
		$("#eventMoneyGrid").jsGrid({
			height: "auto",
	        width: "100%",
	        sorting: true,
	        paging: true,
	        autoload: false,
			controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/supp/getEventMoneyList.json",
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
           						    $('#DETAIL_CONG_DATE').val(item.CONG_DATE);
	           						$('#DETAIL_CONG_NAME').val(item.CONG_NAME);
	           						$('#DETAIL_RELA_NAME').val(item.RELA_NAME);
	           						$('#DETAIL_EREL_NAME').val(item.EREL_NAME);
	           						$('#DETAIL_WAGE_WONX').val(item.WAGE_WONX.format());
	           						$('#DETAIL_CONG_RATE').val(item.CONG_RATE);
	           						$('#DETAIL_CONG_WONX').val(item.CONG_WONX.format());
	           						$('#DETAIL_BANK_NAME').val(item.BANK_NAME);
	           						$('#DETAIL_BANKN').val(item.BANKN);
	           						$('#DETAIL_HOLI_CONT').val(item.HOLI_CONT);
	           						$('#DETAIL_WORK_YEAR').val(item.WORK_YEAR);
	           						$('#DETAIL_WORK_MNTH').val(item.WORK_MNTH);
           						  
           					   });
           			},
           			align: "center",
           			width: "8%"
           		},
           		{ title: "신청일", name: "BEGDA", type: "text", align: "center", width: "10%" },
           		{ title: "경조내역", name: "CONG_NAME", type: "text", align: "left", width: "13%" },
           		{ title: "경조대상자 관계", name: "RELA_NAME", type: "text", align: "left", width: "16%" },
           		{ title: "대상자", name: "EREL_NAME", type: "text", align: "left", width: "13%" },
           		{ title: "경조발생일", name: "CONG_DATE", type: "text", align: "center", width: "13%" 
           			,itemTemplate: function(value, storeData) {
						return value == "0000.00.00" ? "" : value;
					}
           		},
           		{ title: "경조금액", name: "CONG_WONX", type: "text", align: "right", width: "13%" ,
           		 	itemTemplate: function(value) {
	                    return value.format();}
           		},
           		{ title: "최종결재일", name: "POST_DATE", type: "text", align: "center", width: "14%" 
           			,itemTemplate: function(value, storeData) {
						return value == "0000.00.00" ? "" : value;
					}
           		}
       		]
		});
	});
</script>