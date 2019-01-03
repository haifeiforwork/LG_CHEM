<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>

<!--// Page Title start -->
<div class="title">
	<h1>하계조직활성화비</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">하계조직활성화비</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">하계조직활성화비 신청</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">하계조직활성화비 지원내역</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
<%
	if(!request.getAttribute("OpenYn").equals("OK")) {
%>
	<div class="errorArea">
		<div class="errorMsg">	
			<div class="errorImg"><!-- 에러이미지 --></div>
			<div class="alertContent">
				<p>신청기간이 아닙니다.</p>
			</div>
		</div>
	</div>
<%
	} else {
%>
	<!--// Table start -->
	<div class="tableArea">
		<h2 class="subtitle">하계조직활성화비 신청</h2>
		<form id="summerResortForm">
		<div class="table">
			<table class="tableGeneral">
			<caption>하계조직활성화비 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="requestSummerResortBegda">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" id="requestSummerResortBegda" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>"  readonly />
				</td>
				<th><label for="requestSummerResortMoney">신청금액</label></th>
				<td class="tdDate">
					<input class="inputMoney w150 readOnly" type="text" id="requestSummerResortMoney" name="MONEY" value="<%= WebUtil.printNumFormat((String)request.getAttribute("MONEY"))%>" readOnly />
				</td>
			</tr>	
			</tbody>
			</table>
		</div>
		<input type="hidden" name="ZYEAR" value="<%=DataUtil.getCurrentDate().substring(0,4)%>">
		</form>
		<div class="tableComment">
			<p><span class="bold">제출증빙 안내</span></p>
			<p>개인카드 또는 현금소득공제용 영수증 (식당, 숙박업소만 가능)</p>
		</div>
	</div>
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
			<li><a href="#" id="requestSummerResortBtn" class="darken"><span>신청</span></a></li>
		</ul>
	</div>
<% } %>
</div>
<!--// Tab1 end -->
<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">하계조직활성화비 지원내역</h2>
		<div class="clear"></div>
		<div id="summerResortGrid" class="jsGridPaging"></div>
	</div>
	<!------------------ 상세내역 start ------------------>
	<!--// Table start -->	
	<div class="tableArea">
		<h2 class="subtitle">하계조직활성화비 상세내역</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>하계조직활성화비 상세내역</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="detailBegda">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" id="detailBegda" readonly />
				</td>
				<th><label for="detailMoney">신청금액</label></th>
				<td class="tdDate">
					<input class="inputMoney w150 readOnly" type="text" id="detailMoney" readonly>
				</td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>
	<!--// Table end -->
	<!------------------ 상세내역 end ------------------>
</div>
<!--// Tab2 end -->
<!--------------- layout body end --------------->

<script type="text/javascript">
	
	$(document).ready(function(){
		$("#requestSummerResortBtn").click(function(){
			requestSummerResort(false);
		});
		$("#requestNapprovalBtn").click(function(){
			requestSummerResort(true);
		});
		
		$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=37&gridDivId=tab1ApplGrid');
		
		$("#tab1").click(function(){
			$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=37&gridDivId=tab1ApplGrid');
		});
		
		$("#tab2").click(function(){
			$("#summerResortGrid").jsGrid("search");
		});
	});
	
	var requestSummerResort = function(self) {
		if(requestSummerResortCheck()){
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			tab1ApplGridChangeAppLine(self);
			if(confirm(msg + "신청 하시겠습니까?")){
				$("#requestSummerResortBtn").prop("disabled", true);
				$("#requestNapprovalBtn").prop("disabled", true);
				
				var param = $("#summerResortForm").serializeArray();
				$("#tab1ApplGrid").jsGrid("serialize", param);
				param.push({"name":"selfAppr", "value" : self});
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestSummerResort.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							$("#summerResortForm").each(function() {
								this.reset();
							});
							$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=37&gridDivId=tab1ApplGrid');
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#requestSummerResortBtn").prop("disabled", false);
						$("#requestNapprovalBtn").prop("disabled", false);
					}
				});
			} else {
				tab1ApplGridChangeAppLine(false);
			}
		}
	}
	
	// 
	var requestSummerResortCheck = function(){
		if(!checkNullField("summerResortForm")){
			return false;
		}
		$("#requestSummerResortMoney").val( removeComma($("#requestSummerResortMoney").val()) );
		$("#requestSummerResortBegda").val( removePoint($("#requestSummerResortBegda").val()) );
		return true;
	}
	
	// 하계휴가비 조회 grid
	$(function() {
		$("#summerResortGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: true,
			autoload: false,
			controller: {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "get",
						url : "/supp/getSummerResortList.json",
						dataType : "json",
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
					title: "선택", name: "th1", align: "center", width: "10%"
					,itemTemplate: function(_, item) {
						return	$("<input name='chk'>")
								.attr("type", "radio")
								.on("click",function(e){
									$("#detailBegda").val(item.BEGDA);
									$("#detailMoney").val(item.MONEY.format());
								});
					}
				},
				{ title: "신청일", name: "BEGDA", type: "text", align: "center", width: "30%" },
				{ title: "신청금액", name: "MONEY", type: "number", align: "right", width: "30%" 
					,itemTemplate: function(value,item){
						return value.format();
					}
				},
				{ title: "최종결제일", name: "POST_DATE", type: "text", align: "center", width: "30%" 
					,itemTemplate: function(value, storeData) {
						return value == "0000.00.00" ? "" : value;
					}
				}
			]
		});
	});
</script>