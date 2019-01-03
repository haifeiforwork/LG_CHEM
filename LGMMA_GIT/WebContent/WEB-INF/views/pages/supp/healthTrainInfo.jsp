<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E34Body.rfc.E34BodyTrainEntRFC" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.AppLineData"%>

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">체력단련비 신청</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">체력단련비 지원내역</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
	<!--// Table start -->
	<form id="requestHealthForm">
	<div class="tableArea">
		<h2 class="subtitle">체력단련비 신청</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>체력단련비 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="requestBegda">신청일</label></th>
				<td colspan="3" class="tdDate">
					<input type="text" id="requestBegda" name="BEGDA" class="readOnly" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" readonly />
				
					<span class="buttonArea">
						<ul class="btn_crud">
							<li><a class="darken" href="#" id="healthTrainListPerYearBtn" ><span>연간 이용내역 조회</span></a></li>
						</ul>
					</span>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputDateFrom">이용일</label></th>
				<td colspan="3" class="tdDate">
					<input type="text" id="inputDateFrom" name="DAY_IN" placeholder="시작일" vname="이용 시작일" required />
					~
					<input type="text" id="inputDateTo" name="DAY_OUT" placeholder="종료일" vname="이용 종료일" required />
					<input type="text" id="requestTrvlGign" name="TRVL_GIGN" size="10" maxlength="15" onFocus="this.select();" disabled>
					<input type="hidden" id="requestDayUse" name="DAY_USE" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestNameGym">이용업체</label></th>
				<td>
					<input type="text" id="requestNameGym" name="NAME_GYM" class="w250" vname="이용업체" required />
					<input type="hidden" id="requestBusiNumb" name="BUSI_NUMB" />
				</td>
				<th><span class="textPink">*</span><label for="requestJomokCd">종목</label></th>
				<td>
					<select id="requestJomokCd" name="JOMOK_CD" OnChange="checkEtc()" vname="종목" required >
						<option value="">--------</option>
						<%= WebUtil.printOption((new E34BodyTrainEntRFC()).getCodeType()) %>
					</select>
					<input type="text" id="requestJomokTx" name="JOMOK_TX" style="display:none" >
					<input type="hidden" id="requestJomokName" name="JOMOK_NAME" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestMoney">결제금액</label></th>
				<td>
					<input type="text" id="requestMoney" name="MONEY" class="inputMoney w100" onkeyup="cmaComma(this);" onchange="cmaComma(this);"  vname="결제금액" required /> 원
					<input type="hidden" id="requestRequMony1" name="REQU_MONY" />
					<input type="hidden" id="requestRequMony2" name="REQUMONY" />
				</td>
				<th><span class="textPink">*</span><label for="requestDateCard">결제일</label></th>
				<td class="tdDate">
					<input type="text" id="requestDateCard" name="DATE_CARD" class="datepicker" vname="결제일" required />
				</td>
			</tr>
			<tr>
				<th><label for="input-radio01-1">결제구분</label></th>
				<td colspan="3">
					<input type="radio" name="METHOD" value="1" id="input-radio01-1" checked="checked" /><label for="input-radio01-1">개인카드</label>
					<input type="radio" name="METHOD" value="2" id="input-radio01-2" /><label for="input-radio01-2">기타</label>
					<input type="text" id="requestMethodBigo" name="METHOD_BIGO" class="w150" />
				</td>
<!-- 
	2017.05.17 카드번호 제거 (김재만부장 요청)
				<th><label for="requestNumberCard">카드번호</label></th>
				<td>
					<input type="text" id="requestNumberCard" name="NUMBER_CARD" class="w180" maxlength="16"/>
					<span class="noteItem">('-' 표시 없이)</span>
				</td>
 -->
			</tr>
			</tbody>
			</table>
		</div>
	</div>
	<input type="hidden" id="RowCount" name="RowCount" >
	</form>
	<!--// Table end -->
	<!--// list start -->
	<div class="listArea" id="decisionerTab1">
	</div>
	<!--// list end -->
	<div class="buttonArea">
		<ul class="btn_crud">
		<c:if test="${selfApprovalEnable == 'Y'}">
			<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
		</c:if>
			<li><a href="#" id="requestHealthBtn" class="darken" ><span>신청</span></a></li>
		</ul>
	</div>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">체력단련비 지원내역</h2>
		<div class="clear"></div>
		<div id="healthTrainListGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
	</div>
	<!--// list end -->
	
	<div class="tableArea">
		<h2 class="subtitle">체력단련비 상세내역</h2>
		<div class="table">
			<table class="tableGeneral">
				<caption>체력단련비 상세내역</caption>
				<colgroup>
					<col class="col_15p"/>
					<col class="col_35p"/>
					<col class="col_15p"/>
					<col class="col_35p"/>
				</colgroup>
				<tbody>
				<tr>
					<th><label for="detailBegda">신청일</label></th>
					<td colspan="3" class="tdDate">
						<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="detailDayIn">이용일</label></th>
					<td colspan="3" class="tdDate">
						<input class="readOnly" type="text" id="detailDayIn" name="DAY_IN" readonly />
						~
						<input class="readOnly" type="text" id="detailDayOut" name="DAY_OUT" readonly />
						<input class="readOnly w80" type="text" id="detailTrvlGign" name="TRVL_GIGN" readonly />
						<input type="hidden" id="detailDayUse" name="DAY_USE" />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="detailNameGym">이용업체</label></th>
					<td>
						<input class="readOnly w150" type="text" id="detailNameGym" name="NAME_GYM" readonly />
					</td>
					<th><span class="textPink">*</span><label for="detailJomokName">종목</label></th>
					<td colspan="3">
						<input class="readOnly w100" type="text" id="detailJomokName" name="JOMOK_NAME" readonly />
						<input type="hidden" id="detailJomokCd" name="JOMOK_CD" />
						<input class="readOnly w100" type="text" id="detailJomokTx" name="JOMOK_TX" />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="detailMoney">신청금액</label></th>
					<td>
						<input class="inputMoney readOnly w150" type="text" id="detailMoney" name="MONEY" readonly onkeyup="cmaComma(this);" onchange="cmaComma(this);" />
					</td>
					<th><span class="textPink">*</span><label for="detailDateCard">결제일</label></th>
					<td>
						<input class="readOnly w150" type="text" id="detailDateCard" name="DATE_CARD" readonly />
					</td>
				</tr>
				<tr>
					<th><label for="detailMethod1">결제구분</label></th>
					<td colspan="3">
						<input type="radio" id="detailMethod1" name="METHOD" value="1" disabled /><label for="detailMethod1">개인카드</label>
						<input type="radio" id="detailMethod2" name="METHOD" value="2" disabled /><label for="detailMethod2">기타</label>
						<input class="readOnly w80" type="text" id="detailMethodBigo" name="METHOD_BIGO" >
					</td>
<!-- 					<th><label for="inputText02-6">카드번호</label></th>
					<td>
						<input class="readOnly w150" type="text" name="NUMBER_CARD" id="detailNumberCard" readonly />
					</td>
 -->				</tr>
				</tbody>
				</table>
				
			</table>
		</div>
	</div>
</div>
<!--// Tab2 end -->

<!-- // 연간 이용내역 조회 popup -->
<div class="layerWrapper layerSizeP" id="popLayerHealthTrainList">
	<div class="layerHeader">
		<strong>체력단련비 지원내역</strong>
		<a href="#" class="btnClose popLayerHealthTrainList_close">창닫기</a>
		<br/>
		<br/>


	- 연간 이용기간은 
	<input class="w60" type="text" style='text-align:center;'name="EX_BEGDA" id="EX_BEGDA" value=""  vname="시작" readonly /> ~
	<input class="w60" type="text" style='text-align:center;'name="EX_ENDDA" id="EX_ENDDA" value=""  vname="끝" readonly/>
	 이며,	현재까지 이용금액은 총
	 <input class="w60" type="text" style='text-align:right;' name="EX_SUM" id="EX_SUM" value=""  vname="금액" readonly/>원 입니다.
	
	</div>



	<div class="layerContainer">
		<div class="layerContent">
			<form id="contactForm">
			
				
				<div class="tableArea tablePopup">
					<!-- //  grid -->
					<div id="healthTrainListPerYearGrid" ></div>
				</div>
				<div class="buttonArea buttonCenter">
					<ul class="btn_crud">
						<li><a href="#" id="popLayerpopLayerHealthTrainListCansel"><span>확인</span></a></li>
					</ul>
				</div>
			</form>
		</div>
	</div>
</div>


<!--------------- layout body end --------------->

<script type="text/javascript">
	$(document).ready(function(){
		$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=33&gridDivId=healthAppGrid');
		$("#RowCount").val($("#healthAppGrid").jsGrid("dataCount"));
		// 체력단련비 신청 버튼
		$("#requestHealthBtn").click(function(){
			requestHealth(false);
		});
		$("#requestNapprovalBtn").click(function(){
			requestHealth(true);
		});
		
		
		$("#tab1").click(function(){
			$("#requestHealthForm").each(function() {
				this.reset();
			});
			$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=33&gridDivId=healthAppGrid');
			$("#RowCount").val($("#healthAppGrid").jsGrid("dataCount"));
			
		});
		
		$("#tab2").click(function(){
			$("#healthTrainListGrid").jsGrid({"data":$.noop});
			$("#healthTrainListGrid").jsGrid("search");
		});
		
		
		//  연간 이용내역 조회
		$("#healthTrainListPerYearBtn").click(function(){
			$("#healthTrainListPerYearGrid").jsGrid("search");
			$("#popLayerHealthTrainList").popup('show');  //popLayerFamilyList 참조
		});
		
		//대상자선택 popup 취소
		$("#popLayerpopLayerHealthTrainListCansel").click(function(){
			$("#popLayerHealthTrainList").popup('hide');
		});
		
	});
	
	//경조금 지원내역 그리드
	$(function() {

		$("#healthTrainListPerYearGrid").jsGrid({
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
   						url : "/supp/getHealthTrainListPerYear.json",
   						dataType : "json"
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.storeData);
   							
   							var EX_BEGDA = response.EX_BEGDA;
   							var EX_ENDDA = response.EX_ENDDA;
   							var EX_SUM = response.EX_SUM;
   							$("#EX_BEGDA").val(EX_BEGDA);
   							$("#EX_ENDDA").val(EX_ENDDA);
   							$("#EX_SUM").val(EX_SUM);
   							
   							
   							
   						}else{
   		    				alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   					});
   					return d.promise();
   				}
   			},
			fields: [

				{ title: "신청일", name: "BEGDA", type: "text", align: "center", width: "15%" },
				{ title: "이용기관", name: "NAME_GYM", type: "text", align: "center", width: "40%" },
				{ title: "시작일", name: "DAY_IN", type: "text", align: "center", width: "15%" },
				{ title: "종료일", name: "DAY_OUT", type: "text", align: "center", width: "15%" },
				{ title: "신청금액", name: "MONEY", type: "text", align: "right", width: "10%"  },
				{ title: "지원금액", name: "MONEY2", type: "text", align: "right", width: "10%" },
				{ title: "최종결제일", name: "POST_DATE", type: "text", align: "center", width: "15%" }
           	
           		]
		});
	});
	
	
	var requestHealth = function(self) {
		// 사전체크 로직
		if(requestHealthCheck()){
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			healthAppGridChangeAppLine(self);
			if(confirm(msg + "신청 하시겠습니까?")){
				
				$("#requestHealthBtn").prop("disabled", true);
				$("#requestNapprovalBtn").prop("disabled", true);
				$("#requestMoney").val( parseInt($("#requestMoney").val() == "" ? "0" : removeComma($("#requestMoney").val() ) ) );
				
				var param = $("#requestHealthForm").serializeArray();
				$("#healthAppGrid").jsGrid("serialize", param);
				param.push({"name":"selfAppr", "value" : self});
				
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestHealthTrain.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							$("#requestHealthForm").each(function() {
								this.reset();
							});
							$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=33&gridDivId=healthAppGrid');
							$("#RowCount").val($("#healthAppGrid").jsGrid("dataCount"));
							
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#requestHealthBtn").prop("disabled", false);
						$("#requestNapprovalBtn").prop("disabled", false);
					}
				});
			} else {
				healthAppGridChangeAppLine(false);
			}
		}
	}
	var requestHealthCheck = function(){
		if(!checkNullField("requestHealthForm")){
			return false;
		}
/* 		
		if( $("input:radio[name='METHOD']").filter(":checked").val() == "1" ){
			if( !isCardNumber($("#requestNumberCard").val()) ) {
				alert("카드번호를 정확히 입력하세요.");
				$("#requestNumberCard").focus();
				return false;
			}
		}
 */		
		if( "12" == $("#requestJomokCd").val() ){
			if("" == $("#requestJomokTx").val()){
				alert("종목값을 직접 입력하세요");
				$("#requestJomokTx").focus();
				return false;
			}
		}
		
		if( ($("#inputDateFrom").val() != "") && ($("#inputDateTo").val() != "") ){
			var begd  = removePoint($("#inputDateFrom").val());
			var endd  = removePoint($("#inputDateTo").val());
			var cardd = removePoint($("#requestDateCard").val());
			var diff  = parseInt(endd) - parseInt(begd);
			//var difc  = parseInt(cardd) - parseInt(begd);
			$("#requestTrvlGign").val("");
			$("#requestDayUse").val("");
			
			if (diff >0) {
				bday = new Date(begd.substring(0,4),begd.substring(4,6)-1,begd.substring(6,8));
				eday = new Date(endd.substring(0,4),endd.substring(4,6)-1,endd.substring(6,8));
				cday = new Date(cardd.substring(0,4),cardd.substring(4,6)-1,cardd.substring(6,8));
				var betday     = getDayInterval(bday,eday);
				var betcardday = getDayInterval(bday,cday);
				$("#requestTrvlGign").val(betday);
				$("#requestDayUse").val(betday);
				// 1년 넘게 신청 할 경우 alert
				if($("#requestTrvlGign").val() > 365){
					alert("신청기간은 1년을 넘을 수 없습니다.");
					return false;
				}
				
				if (  betcardday > 8 || betcardday < -8  ){
					alert("이용 시작일은 결제일의 7일 전후까지만 가능합니다.\n다시 한번 확인하세요.");//현재는 결제일의 " + (betcardday+1) + "일 전후입니다.
					$("#inputDateFrom").focus();
					return false;  
				}
			}
		}
		
		return true;
	};
	
	var getDayInterval = function(date1,date2){
		var day = 1000 * 3600 *24 
		return parseInt((date2-date1)/day,10)+1;
	}
	
	var checkEtc = function(){
		$("#requestJomokName").val($("#requestJomokCd option:selected").text());
		
		if( "12" == $("#requestJomokCd").val() ){
			$("#requestJomokTx").val("");
			$("#requestJomokTx").show();
		}else{
			
			$("#requestJomokTx").hide();
		}
	}
	
	$(function() {
		$("#healthTrainListGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: true,
			autoload: false,
			pageSize: 10,
			pageButtonCount: 10,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "get",
						url : "/supp/getHealthTrainList.json",
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
				{ title: "선택", name: "AINF_SEQN", align: "center", width: "8%"
					,itemTemplate: function(value, item) {
						return $("<input name='AINF_SEQN'>")
								.attr("type", "radio")
								.val(value)
								.on("click",function(e){
									detailHealthTrainView(item);
								});
					}
				},
				{ title: "신청일", name: "BEGDA", type: "text", align: "center", width: "10%" },
				{ title: "이용기관", name: "NAME_GYM", type: "text", align: "center", width: "24%" },
				{ title: "시작일", name: "DAY_IN", type: "text", align: "center", width: "10%" },
				{ title: "종료일", name: "DAY_OUT", type: "text", align: "center", width: "10%" },
				{ title: "신청금액", name: "MONEY", type: "text", align: "right", width: "14%"  },
				{ title: "지원금액", name: "MONEY2", type: "text", align: "right", width: "14%" },
				{ title: "최종결제일", name: "POST_DATE", type: "text", align: "center", width: "10%" }
			]
		});
	});
	
	// 상세 조회
	var detailHealthTrainView = function(client){
		$("#detailBegda").val(client.BEGDA);
		$("#detailDayIn").val(client.DAY_IN);
		$("#detailDayOut").val(client.DAY_OUT);
		$("#detailTrvlGign").val(parseInt(client.DAY_USE));
		$("#detailDayUse").val(client.DAY_USE);
		$("#detailNameGym").val(client.NAME_GYM);
		$("#detailJomokName").val(client.JOMOK_NAME);
		$("#detailJomokCd").val(client.JOMOK_CD);
		if(client.JOMOK_TX != ""){
			$("#detailJomokTx").show();
			$("#detailJomokTx").val(client.JOMOK_TX);
		}else{
			$("#detailJomokTx").hide();
		}
		$("#detailMoney").val(client.MONEY);
		$("#detailDateCard").val(client.DATE_CARD);
		$("#detailMethod" + client.METHOD).prop("checked", true);
		$("#detailMethodBigo").val(client.METHOD_BIGO);
		//$("#detailNumberCard").val(client.NUMBER_CARD);
		
	};

</script>