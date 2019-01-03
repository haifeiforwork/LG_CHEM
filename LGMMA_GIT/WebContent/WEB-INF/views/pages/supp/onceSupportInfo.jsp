<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E09House.*" %>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.E.E06Rehouse.*" %>
<%@ page import="hris.E.E06Rehouse.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E36OnceSupport.*" %>
<%@ page import="hris.E.E36OnceSupport.rfc.*" %> 

<%
	WebUserData user = (WebUserData)session.getValue("user");
	Vector      PersLoanData_vt    = (Vector)request.getAttribute("PersLoanData_vt");
	String  flag = (String)request.getAttribute("flag");
	String      e_requestFlag  = (String)request.getAttribute("e_requestFlag");
%>
<!--// Page Title start -->
<div class="title">
	<h1>구입전환일시지원금</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">구입전환일시지원금</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<!-- <li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');" class="selected">구입전환일시지원금 신청</a></li> -->
		<li><a href="#" id="tab3" onclick="switchTabs(this, 'tab3');"  class="selected">구입전환일시지원금 상환 신청</a></li>
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" >구입전환일시지원금 조회</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">구입전환일시지원금 조회</h2>
		<div class="clear"></div>
			<form id = "onceListForm">
			<div id="onceHouse" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
				<input type="hidden" id="SUBTY" name="SUBTY" value="">
				<input type="hidden" id="BEGDA" name="BEGDA" value="">
				<input type="hidden" id="ENDDA" name="ENDDA" value="">
				<input type="hidden" id="BETRG" name="BETRG" value="">
				<input type="hidden" id="ONCE_FLAG" name="ONCE_FLAG" value="">
			</form>
	</div>
	<!--// list end -->
	<!--// Table start -->
	<div class="tableArea">
		<h2 class="subtitle">구입전환일시지원금 상세내역</h2>
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
				<td class="alignRight" id="ONCE_E_DARBT"></td>
				<th>월 상환원금</th>
				<td id="ONCE_E_TILBT"></td>
			</tr>
			<tr>
				<th>융자일자</th>
				<td id="ONCE_E_DATBW"></td>
				<th>월 상환이자</th>
				<td id="ONCE_E_BETRG"></td>
			</tr>	
			<tr>
				<th>총상환기간</th>
				<td id="ONCE_E_FROM"></td>
				<th>월 상환금</th>
				<td id="ONCE_E_TILBT_BETRG"></td>
			</tr>
			<tr>
				<th>총상환횟수</th>
				<td id="ONCE_E_ZZRPAY_CONT"></td>
				<th>보증구분</th>
				<td id="ONCE_E_ZZSECU_FLAG"></td>
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
				<td class="alignRight" id="ONCE_E_TOTAL_DARBT"></td>
				<th>상환일자</th>
				<td id="ONCE_E_DARBT_BEGDA"></td>
			</tr>
			<tr>
				<th>상환이자누계</th>
				<td id="ONCE_E_TOTAL_INTEREST"></td>
				<th>상 환 횟 수</th>
				<td id="ONCE_E_TOTAL_CONT"></td>
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
				<td class="alignRight" id="ONCE_E_REMAIN_BETRG"></td>
				<th>잔여횟수</th>
				<td id="ONCE_E_REMAIN_CONT"></td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>
	<!--// Table end -->
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay" id="onceSupportTab">
<form id = "dataCountRequest" name="dataCountRequest">
	<div class="errorArea">
		<div class="errorMsg">
			<div class="errorImg"><!-- 에러이미지 --></div>
			<div class="alertContent">
				<p>이미 구입전환 일시지원금을 받으셨습니다.</p>
			</div>
		</div>
	</div>
</form>
	<!--// Table start -->
	<form action="" id="onceSupportForm" name="onceSupportForm" method="post">
	<input type="hidden" name="DLART" value="0030">
	<input type="hidden" name="REQU_MONY" id="REQU_MONY" value="">
	<div class="tableArea">
		<h2 class="subtitle">구입전환일시지원금 신청</h2>
		<div class="table" >
			<table class="tableGeneral">
			<caption>구입전환일시지원금 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_85p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="inputText02-1">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="inputText02-2">현주소</label></th>
				<td>
					<input class="readOnly wPer" type="text" name="E_STRAS" id="E_STRAS" value="" id="inputText02-2" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="inputText02-3">근속년수</label></th>
				<td>
					<input class="alignRight w120 readOnly" type="text" name="E_YEARS" id="E_YEARS" value="" readonly /> 년
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="input-radio02-1">신청금액</label></th>
				<td>
					<input type="radio" name="MONEY_GUBUN" value="A" id="MONEY_GUBUN1" checked="checked" /><label for="input-radio02-1">3,000만원</label>
					<input type="radio" name="MONEY_GUBUN" value="G" id="MONEY_GUBUN2" /><label for="input-radio02-2">2,000만원</label>
					<input type="radio" name="MONEY_GUBUN" value="B" id="MONEY_GUBUN3" /><label for="input-radio02-3">1,700만원</label>
					<input type="radio" name="MONEY_GUBUN" value="C" id="MONEY_GUBUN4" /><label for="input-radio02-4">1,500만원</label>
					<input type="radio" name="MONEY_GUBUN" value="D" id="MONEY_GUBUN5" /><label for="input-radio02-5">800만원</label>
					<input type="radio" name="MONEY_GUBUN" value="E" id="MONEY_GUBUN6" /><label for="input-radio02-6">600만원</label>
					<input type="radio" name="MONEY_GUBUN" value="F" id="MONEY_GUBUN7" /><label for="input-radio02-7">300만원</label>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="input-radio01-1">상환방법</label></th>
				<td>
					<input type="radio" name="REFND_GUBUN" value="P" id="REFND_GUBUN" checked="checked" /><label for="input-radio01-1">정기급여 상환</label>
					<% if ( user.e_persk.equals("31")){  %> 
						<input type="radio" name="REFND_GUBUN" id="REFND_GUBUN" value="E" /><label for="input-radio01-2"> 정기급여 + 정기상여 상환</label> 
						<input type="radio" name="REFND_GUBUN" id="REFND_GUBUN" value="F" /><label for="input-radio01-3">정기상여 상환</label>
						<input type="radio" name="REFND_GUBUN" id="REFND_GUBUN" value="G" /><label for="input-radio01-4">년말년초 상환(12, 2월)</label>
					<% } %>
					<input type="hidden" name="GUBN_FLAG" id="GUBN_FLAG" value="P">
				</td>
			</tr>
			<tr>
				<th><label for="inputSelect01-7">상환원금</label></th>
				<td>
					<input class="inputMoney w120 readOnly" type="text" id="REFND_MONEY" name="REFND_MONEY" value="" readonly /> 원
				</td>
			</tr>
			<tr>
				<th><label for="inputSelect01-7">상환횟수</label></th>
				<td>
					<input class="inputMoney w120 readOnly" type="text" id="REFND_COUNT" name="REFND_COUNT" value="" readonly / >
				</td>
			</tr>
			<tr>
				<th><label for="input-radio03-1">보증여부</label></th>
				<td>
					<input type="radio" value="N" id="ZZSECU_FLAG" name="ZZSECU_FLAG" checked="checked" /><label for="input-radio03-1">보증보험 가입</label>
					<!-- <input type="radio" value="R" id="ZZSECU_FLAG" name="ZZSECU_FLAG"/><label for="input-radio03-2">퇴직금 담보</label> -->
				</td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>
	<!--// Table end -->
	<!--// list start -->
	<!--// list end -->
	</form>
	<form id="decisionerForm">
		<div class="listArea" id="decisioner"></div>
		<div class="buttonArea">
			<ul class="btn_crud">
			<c:if test="${selfApprovalEnable == 'Y'}">
				<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
			</c:if>
				<li><a class="darken" id="onceSupportBtn" href="javascript:OnceClient(false);"><span>신청</span></a></li>
			</ul>
		</div>
	</form>
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 " id="onceSupportRefundTab">
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
	<!--// Table start -->	
<form action="" id="onceSupportRefundForm" name="onceSupportRefundForm" method="post">
	<div class="tableArea">
		<h2 class="subtitle">구입전환일시지원금 상환신청</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>구입전환일시지원금 상환신청</caption>
			<colgroup>
				<col class="col_20p"/>
				<col class="col_80p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="inputText01-1">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" name="BEGDA" id="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="inputText01-1" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputSelect01-2">주택융자유형</label></th>
				<td>
					<select class="w150" id="I_LOAN_CODE" name="I_LOAN_CODE" disabled>
						<option value="0030" selected>구입전환일시지원금</option> 
					</select>
				</td>
			</tr>
			<tr>
				<th><label for="inputText01-3">상환원금</label></th>
				<td>
					<input class="inputMoney w120 readOnly" type="text" id="E_RPAY_AMNT" name="E_RPAY_AMNT" value="" readonly> 원
				</td>
			</tr>
			<tr>
				<th><label for="inputText01-4">구입전환일시지원금 이자</label></th>
				<td>
					<input class="inputMoney w120 readOnly" type="text" id="E_INTR_AMNT" name="E_INTR_AMNT" value="" readonly> 원
				</td>
			</tr>
			<tr>
				<th><label for="inputText01-5"><strong class="colorBlue">총상환금액</strong></label></th>
				<td>
					<input class="inputMoney w120 readOnly colorBlue" type="text" id="E_TOTAL_AMNT" name="E_TOTAL_AMNT" value="" readonly> 원
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputDateDay">상환액 입금일자</label></th>
				<td colspan="3" class="tdDate">
					<input type="text" size="5" id="I_DATE" name="I_DATE" class="datepicker" value=""  vname="상환액 입금일자" required/>
				</td>
			</tr>
			<tr>
				<th><label for="inputSelect01-7">대출금액</label></th>
				<td>
					<input class="inputMoney w120 readOnly" type="text" id="E_DARBT" name="E_DARBT" value="" readonly> 원
				</td>
			</tr>
			<tr>
				<th><label for="inputSelect01-7">대출일자</label></th>
				<td>
					<input class="w120 readOnly" type="text" id="E_DATBW" name="E_DATBW" value="" readonly>
				</td>
			</tr>
			<tr>
				<th><label for="input-radio02-1">기상환액</label></th>
				<td>
					<input class="inputMoney w120 readOnly" type="text" id="E_ALREADY_AMNT" name="E_ALREADY_AMNT" value="" readonly> 원
				</td>
			</tr>	
			<tr>
				<th><label for="inputSelect01-7">대출잔액</label></th>
				<td>
					<input class="inputMoney w120 readOnly" type="text" id="E_REMAIN_AMNT" name="E_REMAIN_AMNT" value="" readonly> 원
				</td>
			</tr>	
			<tr>
				<th><label for="input-radio02-1">보증여부</label></th>
				<td>
					<input class="w120 readOnly" type="text" id="E_ZZSECU_FLAG" name="E_ZZSECU_FLAG" value="" readonly>	
					<input type="hidden" id="I_BETRG"  name="I_BETRG" value=""/>
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
<% if ( user.e_grup_numb.equals("02")) {  %>
			<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA </span></p>

<% } else { %>
			<p><span class="bold">상환은행계좌 : 신한은행) 140-000-321571 LG MMA </span></p>
<% } %>
			<ul>
				<li>구입전환일시지원금을 입금할 경우 본인임을 확인할 수 있도록 무통장 입금증에 본인의 실명을 입력하여 주십시오.</li>
				<li>매월 21일부터 말일까지는 구입전환일시지원금을 상환할 수 없습니다. </li>
			</ul>
		</div>
	</div>	
	<!--// Table end -->
	<!--// list start -->
	<!--// list end -->
	</form>
	<form id ="refunddecisionerForm">
		<div class="listArea" id="refunddecisioner"></div>
		<div class="buttonArea">
			<ul class="btn_crud">
			<c:if test="${selfApprovalEnable == 'Y'}">
				<li><a href="#" id="refundRequestNapprovalBtn"><span>자가승인</span></a></li>
			</c:if>
				<li><a class="darken" id="onceSupportRefundBtn" href="javascript:OnceSupportRefundClient(false);"><span>신청</span></a></li>
			</ul>
		</div>
	</form>
</div>
<!--------------- layout body end --------------->
<script type="text/javascript">

	$(document).ready(function(){
		//자가승인 클릭시(팀장 이상만)
		//$("#requestNapprovalBtn").click(function(){OnceClient(true);});
		//$("#refundRequestNapprovalBtn").click(function(){OnceSupportRefundClient(true);});
		//getRequMonyGubunCode();
		//getMoneyGubunCode();
		//getOnceRequestList();
		getResotreOnceSupportDetail(); //시작할때 상환신청화면으로 시작
		//$('#decisioner').load('/common/getDecisionerGrid?upmuType=35&gridDivId=decisionerGrid');
		$('#refunddecisioner').load('/common/getDecisionerGrid?upmuType=36&gridDivId=refunddecisionerGrid');
		
		// 구입전환일시지원금 조회
		$("#tab1").click(function(){
			$("#onceHouse").jsGrid("search");
		});
		
		// 구입전환일시지원금 신청 금액 조회
		$("#tab2").click(function(){
			getRequMonyGubunCode();
			getMoneyGubunCode();
			getOnceRequestList();
		});
		
		// 구입전환일시지원금 상환 신청 금액 조회
		$("#tab3").click(function(){
			getResotreOnceSupportDetail();
			$('#refunddecisioner').load('/common/getDecisionerGrid?upmuType=36&gridDivId=refunddecisionerGrid');
			
		});
	});
	
	//신청금액에 대한 금액 변경 코드
	var getRequMonyGubunCode = function() {
		
		var money = $(':radio[name="MONEY_GUBUN"]:checked').val();
		
		if (money == "B") {
			$("#REQU_MONY").val("17000000");
		}else if (money == "C") {
			$("#REQU_MONY").val("15000000");
		}else if (money == "D") {
			$("#REQU_MONY").val("8000000");
		}else if (money =="E") {
			$("#REQU_MONY").val("6000000");
		}else if (money =="F") {
			$("#REQU_MONY").val("3000000");
		}else if (money =="G") {
			$("#REQU_MONY").val("20000000");
		}else if(money =="A") {
			$("#REQU_MONY").val("30000000");
		}
	};
	
	// 구입전환일시지원금 신청 금액 조회
	$('input[name="MONEY_GUBUN"]').change(function(){
		getRequMonyGubunCode();
		getMoneyGubunCode();
	}); 
	
	
	$('input[name="REFND_GUBUN"]').click(function(){
		getRequMonyGubunCode();
		getMoneyGubunCode();
	}); 
	
	// 구입전환일시지원금 상환 신청 조회
	var getResotreOnceSupportDetail = function() {
		jQuery.ajax({
			type : 'POST',
			url : '/supp/resotreOnceSupportDetail.json',
			cache : false,
			dataType : 'json',
			async :false,
			success : function(response) {
				if(response.success){
						var item = response.storeData[0];
						var itemKey = response.keyData[0];
						var dateKeyFrom = itemKey.I_DATE.substring(0,4) +"."+itemKey.I_DATE.substring(4,6)+"."+itemKey.I_DATE.substring(6,8);
						$("#E_RPAY_AMNT").val(item.E_RPAY_AMNT.format());
						$("#E_INTR_AMNT").val(parseFloat(item.E_INTR_AMNT).toFixed(0).format());
						$("#TOTAL_AMNT").val(item.E_TOTAL_AMNT.format());
						$("#I_DATE").val(dateKeyFrom);
						$("#E_TOTAL_AMNT").val(parseFloat(item.E_TOTAL_AMNT).toFixed(0).format());
						$("#E_DARBT").val(item.E_DARBT.format());
						$("#E_DATBW").val(item.E_DATBW);
						$("#E_ALREADY_AMNT").val(item.E_ALREADY_AMNT.format());
						$("#E_REMAIN_AMNT").val(item.E_REMAIN_AMNT.format());
						$("#E_ZZSECU_FLAG").val(item.E_ZZSECU_TXT);
						$("#I_BETRG").val(itemKey.I_BETRG);
						$("#dataCountRefund").hide();
						$("#onceSupportRefundForm").show();
						$("#decisionerForm").show();
						$("#refunddecisionerForm").show();
					}else{
						$("#dataCountRefund").show();
						$("#onceSupportRefundForm").hide();
						$("#decisionerForm").hide();
						$("#refunddecisionerForm").hide();
					}
			}
		});
	};
	
	// 구입전환일시지원금 신청조회
	var getOnceRequestList = function() {
		jQuery.ajax({
			type : 'POST',
			url : '/supp/getOnceRequestList.json',
			cache : false,
			dataType : 'json',
			async :false,
			success : function(response) {
				if(response.success){
					var item = response.storeData[0];
					$("#E_STRAS").val(item.E_STRAS);
					$("#E_YEARS").val(item.E_YEARS);
					if( "<%=flag%>" == "true" ){
						$("#onceSupportForm").hide();
						$("#decisionerForm").hide();
						$("#dataCountRequest").show();
						$("#refunddecisionerForm").show();
					}else{
						$("#onceSupportForm").show();
						$("#decisionerForm").show();
						$("#dataCountRequest").hide();
						$("#refunddecisionerForm").hide();
					} 
				}else{
					alert("구입전환일시 지원금 신청조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	//구입전환일시지원금 신청 금액 조회
	var getMoneyGubunCode = function() {
		jQuery.ajax({
			type : 'POST',
			url : '/supp/getOnceSupportCode.json',
			cache : false,
			dataType : 'json',
			data : {
				"MONEY_GUBUN" : $(':radio[name="MONEY_GUBUN"]:checked').val(),
				"REFND_GUBUN" : $(':radio[name="REFND_GUBUN"]:checked').val()
			},
			async :false,
			success : function(response) {
				if(response.success){
					var item = response.storeData[0];
					$("#REFND_MONEY").val(item.REFND_MONEY.format());
					$("#REFND_COUNT").val(parseInt(item.REFND_COUNT));
				}else{
					alert("구입전환일시금 신청금액 조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	// 구입전환일시 지원금 조회 그리드
	$(function() {
		$("#onceHouse").jsGrid({
			height: "auto",
			width: "100%",
			paging: true,
			autoload: true,
			pageSize: 10,
			pageButtonCount: 10,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/supp/getOnceSupportList.json",
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
				{ title: "선택", name: "th1", align: "center", width: "8%"
					,itemTemplate: function(value, storeData) {
						if(storeData.FLAG == "Y")
							return $("<input name='courRadio' id='courRadio' disabled>").attr("type", "radio")
						else
							return $("<input name='courRadio' id='courRadio' checked>")
									.attr("type", "radio")
									.on("click", function(e) {
										$("#SUBTY").val(storeData.SUBTY);
										$("#BEGDA").val(storeData.BEGDA);
										$("#ENDDA").val(storeData.ENDDA);
										$("#BETRG").val(storeData.BETRG);
										$("#ONCE_FLAG").val(storeData.FLAG);
										
										if( storeData.FLAG == "Y" ){
											alert("대출 진행중인 건에 대해서만 상세조회가 가능합니다.");
											return false;
										}else{
											selectEduChageValue();
										}
									});
					},
				},
				{ title: "융자일자", name: "DATBW", type: "text", align: "center", width: "10%" },
				{ title: "융자형태", name: "STEXT", type: "text", align: "center", width: "16%" },
				{ title: "융자원금", name: "DARBT", type: "text", align: "right", width: "14%"
					,itemTemplate: function(value) {
						return value.format();
					}
				},
				{ title: "상환원금", name: "REDEMPTION", type: "text", align: "right", width: "14%"
					,itemTemplate: function(value) {
						return value.format();
					}
				},
				{ title: "잔여원금", name: "BETRG", type: "text", align: "right", width: "14%"
					,itemTemplate: function(value) {
						return value.format();
					}
				},
				{ title: "상환완료일자", name: "ZAHLD", type: "text", align: "center", width: "10%"
					,itemTemplate: function(value,storeData) {
						return (storeData.FLAG == "Y") ? (value == "0000-00-00" ? "" : value) : ""
					}
				},
				{ title: "일시상환금액", name: "REDARBT", type: "text", align: "right", width: "14%"
					,itemTemplate: function(value,storeData) {
						return (storeData.FLAG == "Y") ? value.format() : ""
					}
				}
			]
		});
	});
	
	// 구입전환일시지원금 상세 조회
	var selectEduChageValue = function(){
		jQuery.ajax({
			type : 'GET',
			url : '/supp/getOnceSupportDetail.json',
			cache : false,
			dataType : 'json',
			data : $('#onceListForm').serialize(),
			async :false,
			success : function(response) {
				if(response.success){
					var item = response.storeData;
					var E_ZZRPAY_MNTH = item.E_ZZRPAY_MNTH.substring(0,4) + "." + item.E_ZZRPAY_MNTH.substring(4,6);
					var E_ENDDA       = item.E_ENDDA.substring(0,4)       + "." + item.E_ENDDA.substring(4,6)      ;
					var E_DARBT_BEGDA = item.E_DARBT_BEGDA.substring(0,4) + "." + item.E_DARBT_BEGDA.substring(4,6);
					var E_DARBT_ENDDA = item.E_DARBT_ENDDA.substring(0,4) + "." + item.E_DARBT_ENDDA.substring(4,6);
					
					//융자현황
					$("#ONCE_E_DARBT").html(item.E_DARBT.format() == "0" ? "" :item.E_DARBT.format());
					$("#ONCE_E_TILBT").html(item.E_TILBT.format() == "0" ? "" :item.E_TILBT.format());
					$("#ONCE_E_DATBW").html(item.E_DATBW);
					$("#ONCE_E_BETRG").html(item.E_BETRG.format() == "0" ? "" :item.E_BETRG.format());
					$("#ONCE_E_FROM").html(E_ZZRPAY_MNTH+ " ~ "+E_ENDDA);
					
					$("#ONCE_E_TILBT_BETRG").html(item.E_TILBT_BETRG.format() == "0" ? "" :item.E_TILBT_BETRG.format());
					$("#ONCE_E_ZZRPAY_CONT").html(parseFloat(item.E_ZZRPAY_CONT));
					$("#ONCE_E_ZZSECU_FLAG").html(item.E_ZZSECU_FLAG == "Y" ? "보증인" :"보험보증가입");
					
					//상환내역
					$("#ONCE_E_TOTAL_DARBT").html(item.E_TOTAL_DARBT.format() == "0" ? "" :item.E_TOTAL_DARBT.format());
					if(item.E_TOTAL_CONT == "0000"){
						
					}else{
						$("#ONCE_E_DARBT_BEGDA").html(E_DARBT_BEGDA+ " ~ "+E_DARBT_ENDDA);
					}
					
					$("#ONCE_E_TOTAL_INTEREST").html(item.E_TOTAL_INTEREST.format() == "0" ? "" :item.E_TOTAL_INTEREST.format());
					$("#ONCE_E_TOTAL_CONT").html(parseFloat(item.E_TOTAL_CONT));
					
					//잔여금
					$("#ONCE_E_REMAIN_BETRG").html(item.E_REMAIN_BETRG.format() == "0" ? "" :item.E_REMAIN_BETRG.format());
					$("#ONCE_E_REMAIN_CONT").html(parseFloat(item.E_REMAIN_CONT) == "0" ? "" :parseFloat(item.E_REMAIN_CONT));
					
				}else{
					alert("조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	
	// 구입전환일시 지원금 신청 validation
	var OnceClientCheck = function() {
		
		if(!checkNullField("onceSupportForm")){
			return false;
		}
		
		if($("#REFND_MONEY").val() == "0" ) {
			alert("신청금액과 상환방법을 입력하세요");
			return false;
		}
		
		//결재자 체크
		if( $("#RowCount").val() < 1 ){
			alert("결재자 정보가 없습니다.");
			return false;
		}
		
		if("N" == '<%= e_requestFlag %>'){
			alert("이미 신청 건이 있습니다.");
		return false;
		}
		
		return true;
	} 
	// 구입전환일시 지원금 신청
	var OnceClient = function(self) {
		if( OnceClientCheck() ) {
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			decisionerGridChangeAppLine(self);

			if(confirm(msg + "신청 하시겠습니까?")){
				$("#onceSupportBtn").prop("disabled", true);
				$("#requestNapprovalBtn").prop("disabled", true);
				$("#onceSupportForm #RowCount").val($("#decisionerGrid").jsGrid("dataCount"));
				$("#GUBN_FLAG").val($(':radio[name="REFND_GUBUN"]:checked').val())
				var param = $("#onceSupportForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				param.push({"name":"selfAppr", "value" : self});
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestOnceSupport.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							// 초기화
							$("#onceSupportForm")[0].reset();
							$("#onceSupport").jsGrid("search");
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#onceSupportBtn").prop("disabled", false);
						$("#requestNapprovalBtn").prop("disabled", false);
					}
				}); 
			} else {
				decisionerGridChangeAppLine(false);
			}
		}
	}
	
	// 구입전환일시지원금 상환신청 validation
	var OnceSupportRefundClientCheck = function() {
		
		if(!checkNullField("onceSupportRefundForm")){
			return false;
		}
		
		var now = new Date();
		var sysDate = now.getDate();
		
		if ( sysDate >= 21 && sysDate <=31 ) {
			//alert("매월 21일부터 말일까지는 상환 신청을 할 수 없습니다.");
			//return false;
		}
		
		
		if(!checkdate($("#I_DATE"))){
			return false;
		}
		
		var date_from  = $("#onceSupportRefundForm #BEGDA").val().replace(/\./g,'');
		var date_to    = $("#onceSupportRefundForm #I_DATE").val().replace(/\./g,'');
		
		dif = dayDiff(addSlash(date_from), addSlash(date_to));
		
		if( dif > 7) {
			alert("입금일자는 신청일 1주일 이내만 가능합니다.");
			return false;
		}
		
		if($("#E_REMAIN_AMNT").val() == "0"){
			alert("대출잔액이 없습니다.");
			return false;
		}
		
		//결재자 체크
		if( $("#onceSupportRefundForm #RowCount").val() < 1 ){
			alert("결재자 정보가 없습니다.");
			return false;
		}
		return true;
	} 
	// 구입전환일시지원금 상환신청
	var OnceSupportRefundClient = function(self) {
		if( OnceSupportRefundClientCheck() ) {
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			refunddecisionerGridChangeAppLine(self);

			if(confirm(msg + "신청 하시겠습니까?")) {
				$("#onceSupportRefundBtn").prop("disabled", true);
				$("#refundRequestNapprovalBtn").prop("disabled", true);
				$("#onceSupportRefundForm #RowCount").val($("#refunddecisionerGrid").jsGrid("dataCount"));
				var param = $("#onceSupportRefundForm").serializeArray();
				$("#refunddecisionerGrid").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestOnceSupportRefund.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							// 초기화
							$("#onceSupportRefundForm")[0].reset();
							$("#onceSupportRefund").jsGrid("search");
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#onceSupportRefundBtn").prop("disabled", false);
						$("#refundRequestNapprovalBtn").prop("disabled", false);
					}
				}); 
			} else {
				refunddecisionerGridChangeAppLine(false);
			}
		}
	}
</script>