<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E25InfoJoin.*" %>
<%@ page import="hris.E.E25InfoJoin.rfc.* "%>
<%@ page import="hris.E.E25InformalAccountInfo.*" %>
<%@ page import="hris.E.E25InformalAccountInfo.rfc.* "%>

<%
    Vector  InfoListData_vt = (Vector)request.getAttribute("InfoListData_vt");
    Vector  InfoListDataNew_vt = (Vector)request.getAttribute("InfoListDataNew_vt");
    Vector  InfoPayData_vt = (Vector)request.getAttribute("InfoPayData_vt");
%>

<!--// Page Title start -->
<div class="title">
	<h1>간사계좌</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">간사계좌</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">간사계좌신규</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">간사계좌변경</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">	
	<!--// Table start -->	
<form id="regForm" name="regForm" method="post">
<input type="hidden" name="LGTXT" id="LGTXT" />
<input type="hidden" name="MGART_TX" id="MGART_TX" />
<input type="hidden" name="RECI_NAME" id="RECI_NAME" />
<input type="hidden" name="WORK_TYPE" id="WORK_TYPE" value="45"/>
<input type="hidden" name="JOB_TYPE" id="JOB_TYPE" value="2"/>
<input type="hidden" name="TYPE" id="TYPE" value="N"/>

<!-- 
<input type="hidden" name="AEDTM" id="AEDTM" />
<input type="hidden" name="UNAME" id="UNAME" />
<input type="hidden" name="REJECT_CODE" id="REJECT_CODE" />
<input type="hidden" name="REJECT_NAME" id="REJECT_NAME" />
-->

	<div class="tableArea">
		<h2 class="subtitle">간사계좌신규</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>간사계좌신규 신청</caption>
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
					<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-2">인포멀회유형</label></th>
				<td>
					<select id="MGART" name="MGART" vname="인포멀회" style="width:110px" required> 
						<option value="">----선택----</option>
<%
					for( int i = 0; i < InfoListDataNew_vt.size(); i++ ) {
						E25InformalAccountInfoLisNewtData infolistdata = (E25InformalAccountInfoLisNewtData)InfoListDataNew_vt.get(i);
%>
						<option value="<%= infolistdata.MGART %>"  ><%= infolistdata.STEXT %></option>
<%
					}
%>
					</select>
				</td>
				<th><span class="textPink">*</span><label for="inputText01-2">입금유형</label></th>
				<td>
					<select id="LGART" name="LGART" vname="입금유형" style="width:158px" required> 
						<option value="">-------선택-------</option>
<%
					for( int i = 0; i < InfoPayData_vt.size(); i++ ) {
						E25InformalAccountInfoPayData infopaydata = (E25InformalAccountInfoPayData)InfoPayData_vt.get(i);
%>
						<option value="<%= infopaydata.LGART %>"><%= infopaydata.LGTXT %></option>
<%
					}
%>
					</select>
					<input class="w30 readOnly" type="text" name="LGART_CODE"  id="LGART_CODE" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="INFO_BEG">등록기간</label></th>
				<td colspan="3" class="tdDate">
					<input type="text" id="inputDateFromCustom" name="INFO_BEG" placeholder="시작일" vname="시작일" required />
					~
					<input type="text" class="readOnly" id="inputDateTo_" name="INFO_END" placeholder="종료일" vname="종료일" value="9999.12.31" readonly="readonly" required />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-3">간사사번</label></th>
				<td>
					<input class="" style="width:102px" type="text" name="PERN_NUMB" id="PERN_NUMB" vname="간사사번" onkeydown="onlyNumber(this)" required />
				</td>
				<th><span class="textPink">*</span><label for="inputText01-4">연락처</label></th>
				<td>
					<input class="w150" type="text" name="PERN_TELE" id="PERN_TELE" vname="연락처" required/>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span>은행코드</th>
				<td><select class="fixedWidth" name="BANK_CODE" id="BANK_CODE"  vname="은행코드" required>
					<option value="">-------------</option>
					</select>
					<input class="w30 readOnly" type="text" name="BANK_CODE_VALUE"  id="BANK_CODE_VALUE" readonly />
				</td>
				<th><span class="textPink">*</span>계좌번호</th>
				<td>
					<input class="w150" type="text" name="BANKN" id="BANKN" value=""  vname="계좌번호" onkeydown="onlyNumber(this)" required/>
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">신규 인포멀유형 등록후 신청하시기 바랍니다.</span></p>
		</div>
	</div>
	</form>
	<!--// Table end -->
	<div class="listArea" id="decisioner"></div>
	<div class="buttonArea">
		<ul class="btn_crud">
			<c:if test="${selfApprovalEnable == 'Y'}">
				<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
			</c:if>
			<li><a class="darken" href="javascript:InformalAccountJoinClient();" id="regBtn"><span>신청</span></a></li>
		</ul>
	</div>
	
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<!--// list start -->
	<div class="listArea">
		<div class="tableInquiry mb0" style="padding:13px 0px 11px 5px;margin-bottom:30px">
			<table style="width: 100%">
				<form id="searchForm" name="searchForm" method="post">
					<caption>1행조회</caption>
					<colgroup>
						<col class="col_7p">
						<col class="col_26p">
						<col class="col_67p" style="width: 100%">
					</colgroup>
					<tbody>
						<tr>
							<th>인포멀회</th>
							<td>
								
								<select id="SEARCH_MGART" name="SEARCH_MGART" vname="인포멀회" required> 
								<option value="">---------전체---------</option>
		<%
								for( int i = 0; i < InfoListData_vt.size(); i++ ) {
									E25InformalAccountInfoJoinData infolistdata = (E25InformalAccountInfoJoinData)InfoListData_vt.get(i);
		%>
									<option value="<%= infolistdata.MGART %>"  ><%= infolistdata.MGART_TX %></option>
		<%
								}
		%>
								</select>
								
							</td>
							<td class="btn_mdl" style="text-align: right">
								<a class="icoSearch" href="javascript:goSearch();"><span>조회</span></a>
							</td>
						</tr>
					</tbody>
				</form>
			</table>
		 </div>
		 <h2 class="subtitle withButtons" style="padding-top:20px">간사등록 현황</h2>
		<div class="clear"></div>
		<div id="informalAccountList"></div>
	</div>	
	<!--// list end -->
	
	<div class="tableArea" id="detail_div">
		<form id="detailForm" name="detailForm" method="post">
		<input type="hidden" name="LGTXT" id="DETAIL_LGTXT" />
		<input type="hidden" name="MGART_TX" id="DETAIL_MGART_TX" />
		<input type="hidden" name="RECI_NAME" id="DETAIL_RECI_NAME" />
		<input type="hidden" name="WORK_TYPE" id="DETAIL_WORK_TYPE" value="46"/>
		<input type="hidden" name="JOB_TYPE" id="DETAIL_JOB_TYPE" value="3"/>
		<input type="hidden" name="TYPE" id="DETAIL_TYPE" value="U"/>
		
		<!-- 
		<input type="hidden" name="AEDTM" id="AEDTM" />
		<input type="hidden" name="UNAME" id="UNAME" />
		<input type="hidden" name="REJECT_CODE" id="REJECT_CODE" />
		<input type="hidden" name="REJECT_NAME" id="REJECT_NAME" />
		-->
		<h2 class="subtitle">간사계좌 변경신청</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>간사계좌 변경신청</caption>
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
					<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="DETAIL_BEGDA" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-2">인포멀회유형</label></th>
				<td>
					<span id="MGART_TXT"></span>
					<input type="hidden" name="MGART" id="DETAIL_MGART"/>
				</td>
				<th><span class="textPink">*</span><label for="inputText01-2">입금유형</label></th>
				<td>
					<span id="LGTXT_TXT"></span>
					<input type="hidden" name="LGART" id="DETAIL_LGART"/>
					<input class="w30 readOnly" type="text" name="LGART_CODE"  id="DETAIL_LGART_CODE" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputDateFrom_detail">등록기간</label></th>
				<td colspan="3" class="tdDate">
					<input type="text" id="inputDateFrom_detail" name="INFO_BEG" placeholder="시작일" vname="시작일" />
					~
					<input type="text" id="inputDateTo_detail" name="INFO_END" placeholder="종료일" vname="종료일" readonly="readonly" class="readOnly" required />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-3">간사사번</label></th>
				<td>
					<input class="" style="width:102px" type="text" name="PERN_NUMB" id="DETAIL_PERN_NUMB" vname="간사사번" onkeydown="onlyNumber(this)" required />
				</td>
				<th><span class="textPink">*</span><label for="inputText01-4">연락처</label></th>
				<td>
					<input class="w150" type="text" name="PERN_TELE" id="DETAIL_PERN_TELE" vname="연락처" required/>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span>은행코드</th>
				<td><select class="fixedWidth" name="BANK_CODE" id="DETAIL_BANK_CODE"  vname="은행코드" required>
					<option value="">-------------</option>
					</select>
					<input class="w30 readOnly" type="text" name="BANK_CODE_VALUE"  id="DETAIL_BANK_CODE_VALUE" readonly />
				</td>
				<th><span class="textPink">*</span>계좌번호</th>
				<td>
					<input class="w150" type="text" name="BANKN" id="DETAIL_BANKN" value=""  vname="계좌번호" onkeydown="onlyNumber(this)" required/>
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">변경신청 안내</span></p>
			<ul>
				<li>간사 또는 계좌변경시 한계결정 되므로 등록시작은 매월 1일자 입니다.</li>
				<li>인포멀회가 없어지는 경우 담당자에게 연락 바랍니다. </li>
			</ul>
		</div>
		</form>
	</div>
	</form>
	<!--// Table end -->
	<div class="listArea" id="decisioner2"></div>
	<div class="buttonArea" id="detailBtn">
		<ul class="btn_crud">
			<li><a class="darken" href="javascript:InformalAccountChangeClient();" id="modBtn"><span>신청</span></a></li>
		</ul>
	</div>
	
</div>
<!--// Tab2 end -->	
<!--------------- layout body end --------------->


<script type="text/javascript">
	
	$( document ).ready(function() {
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=45&gridDivId=decisionerGrid');
		bankCode("");
		
		$("#tab1").click(function(){
			$('#decisioner2').html("");
			$('#decisioner').load('/common/getDecisionerGrid?upmuType=45&gridDivId=decisionerGrid');
		});
		
		$("#tab2").click(function(){
			$('#decisioner').html("");
			$('#decisioner2').load('/common/getDecisionerGrid?upmuType=45&gridDivId=decisionerGrid');
			$("#informalAccountList").jsGrid("search");
			$("#detail_div").hide();
			$("#detailBtn").hide();
			
		});
		
		//날짜 기간 datepicker
		$( "#inputDateFromCustom" ).datepicker({
			defaultDate: "+1w",
			dateFormat: 'yy.mm.01',
			onClose: function( selectedDate ) {
				$( "#inputDateTo" ).datepicker( "option", "minDate", selectedDate );
			}
		});
		
		//날짜 기간 datepicker
		$( "#inputDateFrom_detail" ).datepicker({
			defaultDate: "+1w",
			dateFormat: 'yy.mm.01',
			onClose: function( selectedDate ) {
				$( "#inputDateTo_detail" ).datepicker( "option", "minDate", selectedDate );
			}
		});
		
	});
	
	function goSearch(){
		$("#informalAccountList").jsGrid("search");
		$("#detail_div").hide();
		$("#detailBtn").hide();
	}

	function onlyNumber(obj) {
	    $(obj).keyup(function(){
	         $(this).val($(this).val().replace(/[^0-9]/g,""));
	    }); 
	}
	
	var bankCode = function(param_div){
		var params = "0";
		jQuery.ajax({
    		type : "POST",
    		url : "/salary/getChangeBankCode.json",
    		cache : false,
    		dataType : "json",
    		data :{
    			"BNKSA" : params
    		},
    		async :false,
    		success : function(response) {
    			if(response.success){
    				var jsonData = response.storeData;
    				var data = response.adata;
    				bankCodeOption(jsonData, data, param_div);
    			}
    			else{
    				alert("은행코드 정보가 존재하지 않습니다." + response.message);
    			}
    		}
		});
    };
    
	var bankCodeOption = function(jsonData, data, param_div) {
		$("#"+param_div+"BANK_CODE").empty();
		$("#"+param_div+"BANK_CODE").append('<option value="">----</option>');
        $.each(jsonData, function (key, value) {
        	$("#"+param_div+"BANK_CODE").append('<option value=' + value.BANK_CODE +'>' + value.BANK_NAME + '</option>');
        });
	}
	
	//은행 변경시
	$("#BANK_CODE").change(function(){
		$("#BANK_CODE_VALUE").val($("#BANK_CODE option:selected").val());
	});
	//은행 변경시
	$("#DETAIL_BANK_CODE").change(function(){
		$("#DETAIL_BANK_CODE_VALUE").val($("#DETAIL_BANK_CODE option:selected").val());
	});
	
	//임금유형 변경시
	$("#LGART").change(function(){
		$("#LGTXT").val($("#LGART option:selected").text());
		$("#LGART_CODE").val($("#LGART option:selected").val());
	});
	
	//인포멀회 변경시
	$("#MGART").change(function(){
		$("#MGART_TX").val($("#MGART option:selected").text());
		
		/*$("#PERN_NUMB").val($("#MGART option:selected").attr("PERN_NUMB"));
		$("#RECI_NAME").val($("#MGART option:selected").attr("ENAME"));
		$("#PERN_TELE").val($("#MGART option:selected").attr("USRID")); */
	});
	
	
	//임금유형 변경시
	$("#DETAIL_LGART").change(function(){
		$("#DETAIL_LGTXT").val($("#LGART option:selected").text());
	});
	
 	//인포멀회 변경시
	$("#DETAIL_MGART").change(function(){
		/* $("#DETAIL_MGART_TX").val($("#DETAIL_MGART option:selected").text());
		$("#DETAIL_PERN_NUMB").val($("#DETAIL_MGART option:selected").attr("PERN_NUMB"));
		$("#DETAIL_RECI_NAME").val($("#DETAIL_MGART option:selected").attr("ENAME"));
		$("#DETAIL_PERN_TELE").val($("#DETAIL_MGART option:selected").attr("USRID")); */
	});
	
	
	//간사계좌신청 validation
	var InformalAccountJoinClientCheck = function() {
		if(!checkNullField("regForm")){
			return false;
		}
		if( $("#MEMBER").val() == "1") {
			alert("이미 회원입니다.");
			return false;
		}
		return true;
	}
	
	//간사계좌변경신청 validation
	var InformalAccountChangeClientCheck = function() {
		if(!checkNullField("detailForm")){
			return false;
		}
		if( $("#MEMBER").val() == "1") {
			alert("이미 회원입니다.");
			return false;
		}
		return true;
	}
	
	//간사계좌신청
	var InformalAccountJoinClient = function() {
		if(confirm("간사계좌를 신규 신청 하시겠습니까?")){
			$("#regBtn").prop("disabled", true);
			if( InformalAccountJoinClientCheck() ) { 
				var param = $("#regForm").serializeArray();

				$("#decisionerGrid").jsGrid("serialize", param);
				param.push({"name":"selfAppr", "value" : self});
				
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestInformalAccountInfo.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							// 초기화
							$("#regForm").each(function() {
								this.reset();
							});
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#regBtn").prop("disabled", false);
					}
				}); 
			}
		}
	}
	
	//간사등록현황
	$(function() {
		$("#informalAccountList").jsGrid({
			height: "auto",
			width: "100%",
			paging: true,
			autoload: false,
			pageSize: 5,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					var param = $("#searchForm").serializeArray();
					$.ajax({
						type : "GET",
						url : "/supp/getInformalAccountList.json",
						data : param,
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
				{
					title: "선택", name: "th1", align: "center", width: "8%",
					itemTemplate: function(_, item) {
						return $("<input name='CHECK_ITEM'>")
								.attr("type", "radio")
								.on("click", function(e) {
									bankCode("DETAIL_");
									//$("#DETAIL_BEGDA").val(item.BEGDA);
									$("#DETAIL_LGART").val(item.LGART);
									$("#DETAIL_LGART_CODE").val(item.LGART);
									$("#LGTXT_TXT").text(item.LGTXT);
									$("#DETAIL_LGTXT").val(item.LGTXT);

									$("#DETAIL_MGART").val(item.MGART);
									$("#DETAIL_MGART_TX").val(item.MGART_TX);
									$("#MGART_TXT").text(item.MGART_TX);
									
									$("#DETAIL_RECI_NAME").val(item.RECI_NAME);
									$("#inputDateFrom_detail").val(item.INFO_BEG);
									$("#inputDateTo_detail").val(item.INFO_END);
									$("#DETAIL_PERN_NUMB").val( item.PERN_NUMB.substring(4,8) );
									$("#DETAIL_PERN_TELE").val(item.PERN_TELE);
									$("#DETAIL_BANK_CODE").val(item.BANK_CODE);
									$("#DETAIL_BANK_CODE_VALUE").val(item.BANK_CODE);
									$("#DETAIL_BANKN").val(item.BANKN);
									
									$("#detail_div").show();
									$("#detailBtn").show();
									
								});
					}
				},
				{ title: "인포멀명", name: "MGART_TX", type: "text", align: "center", width: "19%" },
				{ title: "등록기간", name: "INFO_BEG", type: "text", align: "center", width: "18%" ,
					itemTemplate: function(value,storeData) {
						var INFO_BEG = "";
						var INFO_END = "";
						
						if(value != "0000.00.00"){
							INFO_BEG = value
						}else{
							//시작일자가 없으면 입력할수있게 풀어준다
							$("#inputDateFrom_detail").removeClass("readOnly").removeAttr('readonly');
							$( "#inputDateFrom_detail" ).datepicker({
								defaultDate: "+1w",
								onClose: function( selectedDate ) {
									$( "#inputDateTo_detail" ).datepicker( "option", "minDate", selectedDate );
								}
							});
						}
						
						if(storeData.INFO_END != "0000.00.00") INFO_END = "~" + storeData.INFO_END;
						
						return INFO_BEG + INFO_END;
					}
				},
				{ title: "간사", name: "RECI_NAME", type: "text", align: "center", width: "18%" },
				{ title: "연락처", name: "PERN_TELE", type: "text", align: "center", width: "19%" },
			]
		});
	});
	
	//간사계좌변경신청
	var InformalAccountChangeClient = function() {
		if(confirm("간사계좌 변경 신청 하시겠습니까?")){
			$("#modBtn").prop("disabled", true);
			if( InformalAccountChangeClientCheck() ) { 
				var param = $("#detailForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestInformalAccountInfo.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("변경 신청 되었습니다.");
							// 초기화
							$("#detailForm").each(function() {
								this.reset();
							});
							$('#decisioner').html("");
							$('#decisioner2').load('/common/getDecisionerGrid?upmuType=45&gridDivId=decisionerGrid');
							$("#informalAccountList").jsGrid("search");
							$("#detail_div").hide();
							$("#detailBtn").hide();
						}else{
							alert("변경 신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#modBtn").prop("disabled", false);
					}
				}); 
			}
		}
	}
	
</script>