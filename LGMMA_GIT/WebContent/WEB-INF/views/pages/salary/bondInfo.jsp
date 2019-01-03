<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.D.D09Bond.D09BondListData" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.DateTime"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%
	WebUserData user   = (WebUserData)session.getValue("user");
	Vector D09BondListData_vt = ( Vector ) request.getAttribute( "D09BondListData_vt" ) ;
	
	String CRED_TOTA          = ( String ) request.getAttribute( "CRED_TOTA"    ) ;  // 가압류총액
	String G_SUM              = ( String ) request.getAttribute( "G_SUM"        ) ;  // 공제총액
	String dedu_rest          = ( String ) request.getAttribute( "dedu_rest"    ) ;  // 미공제잔액
	String GIVE_TOTA          = ( String ) request.getAttribute( "GIVE_TOTA"    ) ;  // 지급총액
	String G_DPOT_REST        = ( String ) request.getAttribute( "G_DPOT_REST"  ) ;  // 미배당공탁액
	String coll_rest          = ( String ) request.getAttribute( "coll_rest"    ) ;  // 예수금잔액
	String REST_TOTA          = ( String ) request.getAttribute( "REST_TOTA"    ) ;  // 가압류잔액 합계
%>
				<!--// Page Title start -->
				<div class="title">
					<h1>채권가압류</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">급여</a></span></li>
							<li class="lastLocation"><span><a href="#">채권가압류</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->
				
				<!--------------- layout body start --------------->	
				
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" onclick="switchTabs(this, 'tab1');" class="selected">채권압류현황</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab2');" class="tab2">지급총액</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab3');" class="tab3" >미배당 공탁액</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab4');" class="tab4" >공제현황</a></li>
					</ul>
				</div>
				<!--// Tab end -->
				
				<!--// Tab1 start -->
				<div class="tabUnder tab1">
					<h2 class="subsubtitle">채권압류현황</h2>
					<!-- 채권압류현황 목록-->
					<div class="listArea pb10">							
						<div class="table">
							<table class="listTable" id="bondListTable">
								<caption>채권압류현황</caption>
								<colgroup>
									<col class="col_5p" />
									<col class="col_10p" />
									<col class="col_20p" />
									<col class="col_10p" />
									<col class="col_15p" />
									<col class="col_15p" />
									<col class="col_15p" />
									<col class="col_10p" />
								</colgroup>
								<tbody>
								<tr>
									<th class="thAlignCenter">No</th>
									<th class="thAlignCenter">접수일</th>
									<th class="thAlignCenter">채권자</th>
									<th class="thAlignCenter">관리번호</th>
									<th class="thAlignCenter">가압류액</th>
									<th class="thAlignCenter">지급액</th>
									<th class="thAlignCenter">가압류잔액</th>
									<th class="thAlignCenter">해지일</th>
								</tr>
<%
    if( D09BondListData_vt.size() > 0 ) {
        for ( int i = 0 ; i < D09BondListData_vt.size() ; i++ ) {
            D09BondListData data = ( D09BondListData ) D09BondListData_vt.get( i ) ;
        	long dateLong = Long.parseLong(DataUtil.removeStructur(data.BEGDA, "."));
        
	        if( (user.empNo.equals("04205") || user.empNo.equals("05112") || user.empNo.equals("05124") ||
	             user.empNo.equals("05125") || user.empNo.equals("05134") || user.empNo.equals("06106") ||
	             user.empNo.equals("06109") || user.empNo.equals("06118")) && dateLong < 20040301 ) {
	            continue;
	        }
%>
          <tr class="showDetail">
            <td class="tdAlignCenter"><a href="#"><%= i + 1 %></a></td>
            <td class="tdAlignCenter"><a href="#"><%= WebUtil.printDate( data.BEGDA ) %></a></td>
            <td class="tdAlignLeft"><a href="#"><%= data.CRED_NAME %></a></td>
            <td class="tdAlignCenter"><a href="#"><%= data.SEQN_NUMB %></a></td>
            <td class="tdAlignRight"><a href="#"><%= WebUtil.printNumFormat( data.CRED_AMNT ) %> 원</a></td>
            <td class="tdAlignRight"><a href="#"><%= WebUtil.printNumFormat( data.GIVE_AMNT ) %> 원</a></td>
            <td class="tdAlignRight"><a href="#"><%= WebUtil.printNumFormat( data.REST_AMNT ) %> 원</a></td>
            <td class="tdAlignCenter tdBorder"><a href="#"><%= data.ENDDA.equals( "0000.00.00" ) ? "" : WebUtil.printDate( data.ENDDA ) %></a></td>
              <input type="hidden" name="BEGDA"      value="<%= WebUtil.printDate( data.BEGDA ) %>">
              <input type="hidden" name="CRED_NAME"  value="<%= data.CRED_NAME  %>">
              <input type="hidden" name="MGTT_NUMB"  value="<%= data.MGTT_NUMB  %>">
              <input type="hidden" name="CRED_ADDR"  value="<%= data.CRED_ADDR  %>">
              <input type="hidden" name="CRED_AMNT"  value="<%= WebUtil.printNumFormat( data.CRED_AMNT ) %> 원">
              <input type="hidden" name="CRED_TEXT"  value="<%= data.CRED_TEXT  %>">
              <input type="hidden" name="CRED_NUMB"  value="<%= data.CRED_NUMB  %>">
              <input type="hidden" name="SEQN_NUMB"  value="<%= data.SEQN_NUMB  %>">
          </tr>
<%
        }
%>
          <tr class="total"> 
            <td><strong>TOTAL</strong></td>
            <td></td>
            <td></td>
            <td></td>
            <td class="tdAlignRight"><%= WebUtil.printNumFormat( CRED_TOTA ) %> 원</td>
            <td class="tdAlignRight"><%= WebUtil.printNumFormat( GIVE_TOTA ) %> 원</td>
            <td class="tdAlignRight"><%= WebUtil.printNumFormat( REST_TOTA ) %> 원</td>
            <td></td>
          </tr>
<%
        } else {
%>
          <tr> 
            <td colspan="8">해당 데이터가 없습니다.</td>
          </tr>
<%
	}
%>
								</tbody>
							</table>
						</div>
					</div>	
					<div class="tableArea mb30">
						<div class="table">
							<table class="tableGeneral">
								<caption>총액 테이블</caption>
								<colgroup>
									<col class="col_15p" />
									<col class="col_18p" />
									<col class="col_15p" />
									<col class="col_18p" />
									<col class="col_15p" />
									<col class="col_19p" />
								</colgroup>
								<tbody>
								<tr>
									<th>가압류 총액</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat( CRED_TOTA ) %> 원</td>
									<th>공제액(해지건 제외)</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat( G_SUM ) %> 원</td>
									<th>미공제 잔액</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat( dedu_rest ) %> 원</td>
								</tr>
								<tr>
									<th>지급총액</th>
									<td class="tdAlignRight"><a class="textLink" href="#" onclick="switchTabs('.tabArea ul.tab li a.tab2', 'tab2');" ><%= WebUtil.printNumFormat( GIVE_TOTA ) %> 원</a></td>
									<th>미배당 공탁액</th>
									<td class="tdAlignRight"><a class="textLink" href="#" onclick="switchTabs('.tabArea ul.tab li a.tab3', 'tab3');" ><%= WebUtil.printNumFormat( G_DPOT_REST ) %> 원</a></td>
									<th>예수금 잔액</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat( coll_rest ).equals("-0") ? "" : WebUtil.printNumFormat( coll_rest ) %> 원</td>
								</tr>
								</tbody>
							</table>
						</div>
					</div>	
					<!-- 채권압류현황 상세 -->
					
					<div class="tableArea">
						<h3 class="subsubtitle">채권압류현황 상세내역</h3>
						<div class="table">
							<table class="tableGeneral" id="bondDetail">
								<caption>채권이력 상세내역</caption>
								<colgroup>
									<col class="col_15p" />
									<col class="col_35p" />
									<col class="col_15p" />
									<col class="col_35p" />
								</colgroup>
								<tbody>
								<tr>
									<th>접수일</th>
									<td colspan="3" id="BEGDA"></td>
								</tr>
								<tr>
									<th>채권자 성명</th>
									<td id="CRED_NAME"></td>
									<th>관리번호</th>
									<td id="SEQN_NUMB"></td>
								</tr>
								<tr>
									<th>가압류 금액</th>
									<td class="tdAlignRight" id="CRED_AMNT"></td>
									<th>채권사유</th>
									<td id="CRED_TEXT"></td>
								</tr>
								<tr>
									<th>주소</th>
									<td colspan="3" id="CRED_ADDR"></td>
								</tr>
								</tbody>
							</table>
						</div>
					</div>	
					<div class="listArea">		
						<h3 class="subsubtitle">채권압류 지급현황</h3>					
						<div id="jsGrid1-2"></div>	
   						<script>
					        $(function() {
					            $("#jsGrid1-2").jsGrid({
					                height: "auto",
					                width: "100%",
					                paging: false,
					                noDataContent: "채권압류현황을 선택하세요",
					                fields: [
					                	{ title: "구분", name: "BOND_TYPE", type: "text", align: "center", width: "6%" },
					                	{ title: "채권자", name: "CRED_NAME", type: "text", align: "left", width: "18%" },
					                    { title: "번호", name: "SEQN_NUMB", type: "text", align: "center", width: "6%" },
					                    { title: "지급(공탁)일", name: "BEGDA", type: "text", align: "center", width: "9%" },
					                    { title: "지급(배정)액", name: "GIVE_AMNT", type: "number", align: "right", width: "12%"
											,itemTemplate: function(value) { 
												return value.format() + " 원";
											}
				                    	},
					                    { title: "공탁수수료", name: "DPOT_CHRG", type: "number", align: "right", width: "10%"
											,itemTemplate: function(value) { 
												return value.format() + " 원";
											}
										},
					                    { title: "수령자", name: "RECV_NAME", type: "text", align: "left", width: "14%" },
					                    { title: "수령은행", name: "BANK_TEXT", type: "text", align: "center", width: "11%" },
					                    { title: "지급계좌", name: "BANK_NUMB", type: "text", align: "center", width: "14%" }
					                ]
					            });
					        });
					    </script>
					    <div class="totalArea" >
					    	<strong>지급액계</strong>
					    	<span id="subaTotal"></span>
					    </div>	
					</div>	
				</div>
				<!--// Tab1 end -->
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">				
					<div class="listArea">		
						<h3 class="subsubtitle">지급총액</h3>					
						<div id="jsGrid2"></div>	
   						<script>
					        $(function() {
					            $("#jsGrid2").jsGrid({
					                height: "auto",
					                width: "100%",
					                paging: false,
					                autoload: true,
					                fields: [
							                	{ title: "구분", name: "BOND_TYPE", type: "text", align: "center", width: "8%" },
							                	{ title: "채권자", name: "CRED_NAME", type: "text", align: "left", width: "16%" },
							                    { title: "번호", name: "SEQN_NUMB", type: "text", align: "center", width: "6%" },
							                    { title: "지급(공탁)일", name: "BEGDA", type: "text", align: "center", width: "9%" },
							                    { title: "지급(배정)액", name: "GIVE_AMNT", type: "number", align: "right", width: "12%"
													,itemTemplate: function(value) { 
														return value.format() + " 원";
													}
						                    	},
							                    { title: "공탁수수료", name: "DPOT_CHRG", type: "number", align: "right", width: "10%"
													,itemTemplate: function(value) { 
														return value.format() + " 원";
													}
												},
							                    { title: "수령자", name: "RECV_NAME", type: "text", align: "left", width: "14%" },
							                    { title: "수령은행", name: "BANK_TEXT", type: "text", align: "center", width: "11%" },
							                    { title: "지급계좌", name: "BANK_NUMB", type: "text", align: "center", width: "14%" }
					                ],
									controller : {
										loadData : function() {
											var d = $.Deferred();
											$.ajax({
												type : "GET",
												url : "/salary/getBondProvisionTotalList.json",
												dataType : "json"
											}).done(function(response) {
												if(response.success) {
													d.resolve(response.storeData);
													$("#provisionTotal").html(response.total.format() + " 원");
												}
								    			else
								    				alert("조회시 오류가 발생하였습니다. " + response.message);
											});
											return d.promise();
										}
									}
					            });
					        });
					    </script>
					    <div class="totalArea">
					    	<strong>지급총액</strong>
					    	<span id="provisionTotal"></span>
					    </div>	
					</div>	
				</div>
				<!--// Tab2 end -->
				
				<!--// Tab3 start -->
				<div class="tabUnder tab3 Lnodisplay">
					<div class="listArea">		
						<h3 class="subsubtitle">미배당 공탁액</h3>					
						<div id="jsGrid3"></div>	
   						<script>
					        $(function() {
					            $("#jsGrid3").jsGrid({
					                height: "auto",
					                width: "100%",
					                paging: false,
					                autoload: true,
					                rowClick: function(args) {
					                	if(parseInt(args.item.GIVE_AMNT) > 0)
											showDetails(args.item);
									},
					                fields: [
					                	{ title: "공탁일", name: "BEGDA", type: "text", align: "center", width: "15%" },
					                	{ title: "실공탁액", name: "DPOT_AMNT", type: "number", align: "right", width: "20%"
											,itemTemplate: function(value) { 
												return value.format() + " 원";
											}
				                    	},
					                    { title: "공탁수수료", name: "DPOT_CHRG", type: "number", align: "right", width: "20%"
											,itemTemplate: function(value) { 
												return value.format() + " 원";
											}
				                    	},
					                    { title: "배당정리액(수수료포함)", name: "GIVE_AMNT", type: "number", align: "right", width: "20%"
											,itemTemplate: function(value) { 
												return value.format() + " 원";
											}
				                    	},
					                    { title: "공탁법원", name: "CORT_TITL", type: "text", align: "left", width: "25%" }
					                ],
									controller : {
										loadData : function() {
											var d = $.Deferred();
											$.ajax({
												type : "GET",
												url : "/salary/getBondDepositList.json",
												dataType : "json"
											}).done(function(response) {
												if(response.success) {
													d.resolve(response.storeData);
													$("#depositTotal").html(response.total.format() + " 원");
												}
								    			else
								    				alert("조회시 오류가 발생하였습니다. " + response.message);
											});
											return d.promise();
										}
									}
					            });
					
					            var showDetails = function(item) {
					        		$("#jsGrid3-1").jsGrid({
					        			autoload: true,
					        			controller : {
					        				loadData : function() {
					        					var d = $.Deferred();
					        					$.ajax({
					        						type : "POST",
					        						url : "/salary/getBondDepositDetail.json",
					        						data : {"BEGDA" : item.BEGDA},
					        						dataType : "json"
					        					}).done(function(response) {
					        						d.resolve(response.storeData);
					        					});
					        					return d.promise();
					        				}
					        			}
					        		});
					            };
					        });
					    </script>
					    <div class="totalArea">
					    	<strong>미배당공탁액계</strong>
					    	<span id="depositTotal"></span>
					    </div>	
					</div>
					<div class="listArea">		
						<h3 class="subsubtitle">배당정리액 내역</h3>					
						<div id="jsGrid3-1"></div>	
   						<script>
					        $(function() {
					            $("#jsGrid3-1").jsGrid({
					                height: "auto",
					                width: "100%",
					                paging: false,
					                noDataContent: "배당정리액을 선택하시기 바랍니다.",
					                autoload: false,
					                fields: [
					                	{ title: "구분", name: "BOND_TYPE", type: "text", align: "center", width: "15%" },
					                	{ title: "지급(공탁)일", name: "BEGDA", type: "text", align: "center", width: "10%" },
					                	{ title: "채권자", name: "CRED_NAME", type: "text", align: "left", width: "20%" },
					                	{ title: "번호", name: "SEQN_NUMB", type: "text", align: "center", width: "5%" },
					                	{ title: "지급(배정)액", name: "GIVE_AMNT", type: "number", align: "right", width: "15%"
											,itemTemplate: function(value) { 
												return value.format() + " 원";
											}
				                    	},
					                    { title: "공탁수수료", name: "DPOT_CHRG", type: "number", align: "right", width: "15%"
											,itemTemplate: function(value) { 
												return value.format() + " 원";
											}
				                    	},
					                    { title: "수령자", name: "RECV_NAME", type: "text", align: "left", width: "20%" }
					                ]
					            });
					        });
					    </script>
					</div>		
				</div>
				<!--// Tab3 end -->	
				
				<!--// Tab4 start -->
				<div class="tabUnder tab4 Lnodisplay">					
					<div class="listArea">	
						<h3 class="subsubtitle">공제현황</h3>
						<div id="jsGrid4"></div>	
   						<script>
					        $(function() {
					            $("#jsGrid4").jsGrid({
					                height: "auto",
					                width: "100%",
					                paging: false,
					                autoload: true,
					                fields: [
					                	{ title: "공제월", name: "BEGDA", type: "text", align: "center", width: "10%" },
					                    { title: "정규급여", name: "BETRG01", type: "number", align: "right", width: "18%"
											,itemTemplate: function(value) { 
												return Math.round(value).format() + " 원";
											}
										},
					                    { title: "정상급여", name: "BETRG02", type: "number", align: "right", width: "18%"
											,itemTemplate: function(value) { 
												return Math.round(value).format() + " 원";
											}
										},
					                    { title: "비정규상여", name: "BETRG04", type: "number", align: "right", width: "18%"
											,itemTemplate: function(value) { 
												return Math.round(value).format() + " 원";
											}
										},
					                    { title: "퇴직금", name: "BETRG03", type: "number", align: "right", width: "18%"
											,itemTemplate: function(value) { 
												return Math.round(value).format() + " 원";
											}
										},
					                    { title: "공제액계", name: "G_SUM", type: "number", align: "right", width: "18%"
											,itemTemplate: function(value) { 
												return Math.round(value).format() + " 원";
											}
										}
					                ],
									controller : {
										loadData : function() {
											var d = $.Deferred();
											$.ajax({
												type : "GET",
												url : "/salary/getBondDeductionList.json",
												dataType : "json"
											}).done(function(response) {
												if(response.success) {
													d.resolve(response.storeData);
													$("#jsGrid4-2").jsGrid("insertItem", {"BEGDA": "소계", "total1" : response.total1, "total2" : response.total2, "total3" : response.total3, "total4" : response.total4, "totalSum" : response.totalSum});
												}
								    			else
								    				alert("조회시 오류가 발생하였습니다. " + response.message);
											});
											return d.promise();
										}
									}
					            });
					
					        });
					    </script>	
					    <div id="jsGrid4-2" class="jsTotal"></div>	
   						<script>
					        $(function() {
					            $("#jsGrid4-2").jsGrid({
					                height: "auto",
					                width: "100%",
					                paging: false,
					                fields: [
							                	{ title: "공제월", name: "BEGDA", type: "text", align: "center", width: "10%" },
							                    { title: "정규급여", name: "total1", type: "number", align: "right", width: "18%"
													,itemTemplate: function(value) { 
														return Math.round(value).format() + " 원";
													}
												},
							                    { title: "정규상여", name: "total2", type: "number", align: "right", width: "18%"
													,itemTemplate: function(value) { 
														return Math.round(value).format() + " 원";
													}
												},
							                    { title: "비정규상여", name: "total4", type: "number", align: "right", width: "18%"
													,itemTemplate: function(value) { 
														return Math.round(value).format() + " 원";
													}
												},
							                    { title: "퇴직금", name: "total3", type: "number", align: "right", width: "18%"
													,itemTemplate: function(value) { 
														return Math.round(value).format() + " 원";
													}
												},
							                    { title: "공제액계", name: "totalSum", type: "number", align: "right", width: "18%"
													,itemTemplate: function(value) { 
														return Math.round(value).format() + " 원";
													}
												}
					                ]
					            });
					
					        });
					    </script>	
					</div>	
				</div>
				<!--// Tab4 end -->
				
				
				<!--------------- layout body end --------------->					
<!-- // script -->
<script type="text/javascript">
$(document).ready(function(){
	$(".showDetail").click(function() {
		var begda = $(this).closest("tr").find("input[name='BEGDA']").val();
		var credName = $(this).closest("tr").find("input[name='CRED_NAME']").val();
		var seqnNumb = $(this).closest("tr").find("input[name='SEQN_NUMB']").val();
		var credAddr = $(this).closest("tr").find("input[name='CRED_ADDR']").val();
		var credAmnt = $(this).closest("tr").find("input[name='CRED_AMNT']").val();
		var credText = $(this).closest("tr").find("input[name='CRED_TEXT']").val();
		var mgttNumb = $(this).closest("tr").find("input[name='MGTT_NUMB']").val();

		$("#BEGDA").html(begda);
		$("#CRED_NAME").html(credName);
		$("#SEQN_NUMB").html(seqnNumb);
		$("#CRED_ADDR").html(credAddr);
		$("#CRED_AMNT").html(credAmnt);
		$("#CRED_TEXT").html(credText);
		$("#jsGrid1-2").jsGrid({
			autoload: true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "POST",
						url : "/salary/getBondProvisionList.json",
						data : {"MGTT_NUMB" : mgttNumb},
						dataType : "json"
					}).done(function(response) {
						d.resolve(response.storeData);
						$("#subaTotal").html(response.total.format() + " 원");
					});
					return d.promise();
				}
			}
		});
    });
});
</script>