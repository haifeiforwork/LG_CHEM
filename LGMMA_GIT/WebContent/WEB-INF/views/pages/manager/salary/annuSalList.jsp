<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<!-- contents start -->
	<!--// Page Title start -->
	<div class="title">
		<h1>연봉</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">My Info</a></span></li>
				<li><span><a href="#">급여</a></span></li>
				<li class="lastLocation"><span><a href="#">연봉</a></span></li>
			</ul>						
		</div>
	</div>
<!--// Page Title end -->
	<div class="tableComment">
	<p><span class="bold">개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며, <br/>이를 위반시에는
    	취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려드립니다.</span></p>
	</div>
	<br>			
				<!--// Tab1 start -->
				<div class="tabUnder tab1">									
					<div class="listArea">	
						<h3 class="subsubtitle withButtons">나의 연봉 조회</h3>
						<div class="clear"> </div>
						<div id="addListGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>	
					</div>	
					<!--// list end -->	
					<div class="infoTxt">
						<ul>
							<li>
								<strong>기본연봉</strong> : 금년 3월부터 내년 2월까지 실수령하는 금액으로 [기본연봉 월할분 X 20] 한 금액임. 
								<p>(중도 입사자는 입사일로 부터 1년이 되는 날까지의 수령액 기준이며 내년도 
								급여조정시 회사가 정하는 바에 따라 연봉조정할 수 있다.)</p> 
							</li>
							<li>
								<strong>수당계(월)</strong> : 역할급/직책/자격/직무/기타수당 등
							</li>
							<li> 
								<strong>연봉총액</strong> : 기본연봉 + 수당계(월) X 12 (성과급은 제외)
							</li>
							<li> 
								<strong>지급방법</strong>
								<ul> 
									<li>
										<strong>2012년 1월 이전</strong>
										- 매월 :기본연봉의 20분의 1 + 수당계(월)<br/> 
										- 짝수월, 추석, 설 : 기본연봉의 20분의 1
									</li>
									<li> 
										<strong>2012년 1월 이후</strong>
										<dl>
										<dt>전문기술직<dt>
										<dd>- 매월 : 기본연봉의 20분의 1 + 수당계(월)</dd>
										<dd>- 짝수월, 추석, 설 : 기본연봉의 20분의 1</dd>
										</dl>
										<dl>
										<dt>사무기술직<dt>
										<dd>- 매월  :기본연봉의 20분의 1 +수당계(월) +기본연봉의 20분의 1* 50%</dd>
										<dd>- 추석, 설 : 기본연봉의 20분의 1</dd>
										</dl>
									</li>
								</ul> 
							</li>
						</ul>
					</div>				
				</div>	
				<!--// Tab1 end -->	
	<script>
        $(function() {
        	$("#printAgreementBtn").click(function() {
        		var printBody = $("#salAgreement").contents().find("body").html();
        		$("#printBodyCurr").html(printBody);
        		$("#printContentsAreaCurr").print();
        	});
        	
        	$("#printPopAgreementBtn").click(function() {
        		$("#printContentsArea").print();
        	});
        	
        	$("#viewAgreementBtn").click(function() {
        		var year = "";
        		var begda = "";
            	$.each($("#addListGrid").jsGrid("option", "data"), function(i, $item){
            		var $row = $("#addListGrid").jsGrid("rowByItem", $item);
            		if($row.find('input[name="courRadio"]').is(":checked")) {
            			year = $item.ZYEAR;
            			begda = $item.BEGDA;
            			return false;
            		}
            	});
            	if(year == "")
    				alert("조회 연도를 선택하시기 바랍니다.");
            	else {
            		$("#salAgreementPopup").attr("src","/manager/salary/agreement/" + year + "?BEGDA=" + begda);
            		$("#salAgreementPopup").load(function(){
            			$('#popLayerPrint').popup("show");
            		});
            	}
        	});
        	
			$("#addListGrid").jsGrid({
                height: "auto",
                width: "100%",
				sorting : true,
		        paging: true,
		        autoload: true,
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "GET",
							url : "/manager/salary/getAnnuSalList.json",
							dataType : "json"
						}).done(function(response) {
							if(response.success) {
								//연봉계약서 iframe 세팅
								$("#salAgreement").attr("src","/manager/salary/agreement/" + response.storeData[0].ZYEAR + "?BEGDA=" + response.storeData[0].BEGDA);
								$("#salYearStr").html(response.storeData[0].ZYEAR + " 연봉계약서");
								d.resolve(response.storeData);
							}
			    			else
			    				alert("조회시 오류가 발생하였습니다. " + response.message);
						});
						return d.promise();
					}
				},

				fields : [ 
				           { name : "ZYEAR", title : "년도",     align : "center", type : "text" , width: "10%"}, 
				           { name : "ORGTX", title : "소속",  align : "center", type : "text", width: "35%"},
				           { name : "TRFGR", title : "직급/년차", align : "center",  type: "text", width: "15%",
				                itemTemplate: function(value,storeData) {
				                	if(value == 'L3'){
				                		return value
				                	}else{
				                    	return value + " / " + storeData.VGLST
				                	};}
				            }, 
				           { name : "EVLVL", title : "전년평가등급",     align : "center", type : "text" , width: "10%"},
				           { name : "BETRG", title : "기본연봉", align : "right",  type: "number",  width: "10%",
				                itemTemplate: function(value) {
				                    return value.format();}
				            },
				           { name : "BET01", title : "수당계(월)", align : "right",  type: "number",  width: "10%",
				                itemTemplate: function(value) {
				                    return value.format();}
				            },
				           { name : "ANSAL", title : "연봉총액", align : "right",  type: "number",  width: "10%",
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
			               { name : "ZINCR", title : "인상율(%)", align : "center",  type: "number",  width: "10%",
				                itemTemplate: function(value) {
				                    return value + "(%)"; }
				            } 
				         ]
			});
		});
    </script>
</form>