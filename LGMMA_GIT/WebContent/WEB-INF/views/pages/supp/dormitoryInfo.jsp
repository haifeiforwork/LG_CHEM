<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
%>
				<!--// Page Title start -->
				<div class="title">
					<h1>사택(기숙사)</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">복리후생</a></span></li>
							<li class="lastLocation"><span><a href="#">사택(기숙사)</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->	
				
				<!--------------- layout body start --------------->				
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" onclick="switchTabs(this, 'tab1');" class="selected">사택(기숙사) 신청</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab2');">사택(기숙사) 조회</a></li>
					</ul>
				</div>
				<!--// Tab end -->
				
				<!--// Tab1 start -->
				<div class="tabUnder tab1">	
				<form name="reqDomitoryForm" id="reqDomitoryForm" method="post" action="">
					<!--// Table start -->	
					<div class="tableArea">
						<h2 class="subtitle">사택(기숙사) 신청</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>사택(기숙사) 신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td class="tdDate">
									<input name="BEGDA" id="BEGDA" value='<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>' class="readOnly" type="text"readonly />
								</td>
								<th><span class="textPink">*</span><label for="input-radio01-1">입주희망일</label></th>
								<td class="tdDate">
                                   <input class="datepicker" type="text" name="MOVE_DATE" id="MOVE_DATE" />
                                </td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="input-radio01-1">구분 </label></th>
								<td>
									<input type="radio" name="ZCHOUSE_GUBUN" id="ZCHOUSE_GUBUN_R01" checked value="C" /><label for="ZCHOUSE_GUBUN_R01">사택</label>
									<input type="radio" name="ZCHOUSE_GUBUN" id="ZCHOUSE_GUBUN_R02" value="D" /><label for="ZCHOUSE_GUBUN_R02">기숙사</label>
                                </td>
								<th>무주택여부</th>
								<td>
									<input type="checkbox" id="NOHOUSE" name="NOHOUSE" value="X" >	                         
                                </td>
                            </tr>				
							</tbody>
							</table>
						</div>
						<div class="tableComment">
							<p><span class="bold">제출서류 안내</span></p>
							<p>지방세 세목별과세증명서(배우자 포함), 부양가족이 등재된 주민등록등본 </p>
						</div>
					</div>	
					<!--// Table end -->							
					<!--// list start -->
					<div class="listArea">	
						<h2 class="subtitle">동거인 목록</h2>
						<div class="clear"></div>
						<div id="mateGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>							
					</div>	
					<div class="agreeCheckText">
						<ul>
							<strong>준 수 사 항</strong>
							<li>
								<span class="no">1.</span> 
								<p>출퇴근 가능지역내 무주택자로서 사규 및 사택관리규정을 준수하여 사택에 입주한다.  
								   가족 소유주택의 경우에는 사택으로 입주할 수 없으며, <br>사실상 본인 및 가족소유주택의 경우에도 사택으로 입주할 수 없다.</p>
							</li>
							<li>  
								<span class="no">2.</span> 
								<p>사택입주 도중 출퇴근 가능지역내에 주택을 구입하게 될 경우 이 사실을 관리부서에 통보하고 사택을 퇴거해야 한다.</p>
							</li>
							<li>  
								<span class="no">3.</span> 
								<p>임대차계약관련 다음과 같은 중대한 사안이 발행하였을 경우에는 관리부서에 즉시 통보한다.</p>  
								<ul>
									<li>① 임차사택의 소유권이 변경될 경우</li>  
									<li>② 임대차계약 또는 임차보증금 회수에 중대한 영향을 미칠만한 사유가 발생한 경우</li>
								</ul>
							</li>
							<li>  
								<span class="no">4.</span>
								<p>사택의 효율적 관리와 원활한 운영을 위해 협조한다.</p>  								
							</li>							
						</ul> 	
						<input type="checkbox" name="PROMISE" id="PROMISE" value="X">위의 준수사항을 확인합니다.
					</div>		
					</form>
					<!--// list start -->
					<div class="listArea" id="decisioner">	
					</div>	
					<!--// list end -->					
					<div class="buttonArea">
						<ul class="btn_crud">
						<c:if test="${selfApprovalEnable == 'Y'}">
							<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
						</c:if>
							<li><a class="darken" href="#" id="reqDormitoryBtn"><span>신청</span></a></li>
						</ul>
					</div>		
				</div>
				<!--// Tab1 end -->
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">
					<!--// list start -->
					<div class="listArea">
						<h2 class="subtitle">사택(기숙사) 조회</h2>
						<div class="clear"></div>				
						<div id="dormitoryGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
					 </div>				 			

					<!------------------ 상세내역 start ------------------>
					<!--// Table start -->	
					<div class="tableArea">
					<form id="detailForm">
						<h2 class="subtitle">사택(기숙사) 신청 상세내역</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>사택(기숙사) 신청 상세내역</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" value="" id="BEGDA" readonly />
								</td>
								<th><span class="textPink">*</span><label for="inputText01-2">입주희망일</label></th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="MOVE_DATE" id="MOVE_DATE" value="" readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="input-radio01-1">구분 </label></th>
								<td>
									<input type="radio" name="ZCHOUSE_GUBUN" id="ZCHOUSE_GUBUN_R01" value="C" disabled /><label for="ZCHOUSE_GUBUN_R01">사택</label>
									<input type="radio" name="ZCHOUSE_GUBUN" id="ZCHOUSE_GUBUN_R02" value="D" disabled /><label for="ZCHOUSE_GUBUN_R02">기숙사</label>
					            </td>
								<th>무주택여부</th>
								<td>
									<input type="checkbox" id="NOHOUSE" name="NOHOUSE" value="X" disabled >	                         
		                           </td>
		                       </tr>				
							</tbody>
							</table>
						</div>
						<div class="tableComment">
							<p><span class="bold">제출서류 안내</span></p>
							<p>지방세 세목별과세증명서(배우자 포함), 부양가족이 등재된 주민등록등본 </p>
						</div>
					</div>	
					<!--// Table end -->
					<!--// list start -->
					<div class="listArea">	
						<h2 class="subtitle">동거인 목록</h2>
						<div id="mateGridForDetail"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>							
						<script>
					        $(function() {
					            $("#mateGridForDetail").jsGrid({
					                height: "auto",
					                width: "100%",
					                sorting: true,
					                paging: false,
					                autoload: true,
					                fields: [
					                    { title: "관계", name: "MATE_RELA", type: "text", align: "center", width: 33 },
					                    { title: "성명", name: "MATE_NAME", type: "text", align: "center", width: 33 },
					                    { title: "직업", name: "MATE_WORK", type: "text", align: "center", width: 34 },
					                ]
					            });
					        });
					    </script>					    
					</div>
				</form>
				</div>
				<!--// Tab2 end -->	
				<!--------------- layout body end --------------->						
			
			</div>

	<script>
        $(function() {
    		//자가승인 클릭시(팀장 이상만)
    		$("#requestNapprovalBtn").click(function(){reqDormitory(true);});
    		$("#reqDormitoryBtn").click(function(){reqDormitory(false)});
        	$('#decisioner').load('/common/getDecisionerGrid?upmuType=38&gridDivId=decisionerGrid');

        	$("#mateGrid").jsGrid({
                height: "auto",
                width: "100%",
                //sorting: true,
                paging: false,
                confirmDeleting: false,
                //autoload: true,
                //inserting: true,
                editing: true,
                invalidMessage: "",
                onItemInserting: function(args) {
                	if(args.grid.data.length > 4) {
                		args.cancel = true;
                		alert("동거인 5명까지 추가 가능합니다.");
                	} else {
                		args.cancel = !isCanAddMate(args.grid);
                	}
                },
                fields: [
                    { title: "<span class='textPink'>*</span>관계", name: "MATE_RELA", type: "text", align: "center", width: 26 },
                    { title: "<span class='textPink'>*</span>성명", name: "MATE_NAME", type: "text", align: "center", width: 29 },
                    { title: "직업", name: "MATE_WORK", type: "text", align: "center", width: 29 },
                    { type: "control", editButton: true, modeSwitchButton: false, width: 16,
                    	headerTemplate: function() {
                    		return $("<a class='inlineBtn'><span>추가</span></a>")
                    		.on("click", function () {
                    				//기존 편집중 데이터를 비활성화 시킨다.
                        			$("#mateGrid").find(".jsgrid-update-button").click();
	                    			var newItem = {"MATE_RELA" : "", "MATE_NAME" : "", "MATE_WORK" : ""};
	                    			$("#mateGrid").jsGrid("insertItem" , newItem);
	                    			$("#mateGrid").jsGrid("rowByItem", newItem).click();
                    			}
                    		);
                    	}
                    }
                ]
            });
            $("#dormitoryGrid").jsGrid({
                height: "auto",
                width: "100%",
                sorting: true,
                paging: true,
                autoload: true,
	   			controller : {
	   				loadData : function() {
	   					var d = $.Deferred();
	   					$.ajax({
	   						type : "GET",
	   						url : "/supp/getDormitoryList.json",
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
                    	title: "선택",
                    	name: "AINF_SEQN",
    					itemTemplate: function(value, item) {
    						return $("<input name='AINF_SEQN'>")
    								.attr("type", "radio")
    								.on("click",function(e){
    									if(value == "") {
    										alert("결재정보가 존재하지 않습니다.");
    									} else {
        									domitoryDetailView(value);
    									}
    								});
    					},
                        align: "center",
                        width: "8%"
                    },
                	{ title: "신청일", name: "BEGDA", type: "text", align: "center", width: "10%",
		                itemTemplate: function(value) {
		                    return (value == "0000.00.00") ? "" : value;
						}
                	},
                    { title: "주소", name: "STRAS", type: "text", align: "left", width: "40%" },
                    { title: "임차보증금", name: "DEPOSIT", type: "number", align: "right", width: "16%",
		                itemTemplate: function(value) {
		                    return value.format();
						}
					},
                    { title: "임차료/월", name: "RENT_MONTH", type: "text", align: "right", width: "16%",
		                itemTemplate: function(value) {
		                    return value.format();}
					},
                    { title: "입주 희망일", name: "MOVE_DATE", type: "text", align: "center", width: "10%",
		                itemTemplate: function(value) {
		                    return (value == "0000.00.00") ? "" : value;
						}
                    }
                ]
            });
    		//action start
    		var reqDormitory = function(self) {
    			if(checkReqDomitoryFormValid()) {
    				//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
    				var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
    				decisionerGridChangeAppLine(self);
    				if(confirm(msg + "신청 하시겠습니까?")){
    					$("#requestNapprovalBtn").prop("disabled", true);
    					$("#reqDormitoryBtn").prop("disabled", true);
    					var param = $("#reqDomitoryForm").serializeArray();
    					customSerialize($("#mateGrid").jsGrid("option", "data"), param);
    					$("#decisionerGrid").jsGrid("serialize", param);
    					param.push({"name":"selfAppr", "value" : self});
    					jQuery.ajax({
    		        		type : 'POST',
    		        		url : '/supp/requestDormitory',
    		        		cache : false,
    		        		dataType : 'json',
    		        		data : param,
    		        		async : false,
    		        		success : function(response) {
    		        			if(response.success) {
    		        				alert("신청되었습니다.");
    								$("#reqDomitoryForm").each(function() {  
    									this.reset();
    									$("#mateGrid").jsGrid({data: []});
    								});  
    		        			} else {
    		        				alert("신청시 오류가 발생하였습니다. " + response.message);
    		        			}
    	    					$("#requestNapprovalBtn").prop("disabled", false);
    							$("#reqDormitoryBtn").prop("disabled", false);
    		        		}
    		        	});
    				} else {
    					decisionerGridChangeAppLine(false);
    				}
    			}
    		}
    		var checkReqDomitoryFormValid = function() {
				//기존 편집중 데이터를 비활성화 시킨다.
    			$("#mateGrid").find(".jsgrid-update-button").click();
        		if(!isCanAddMate($("#mateGrid").jsGrid())) {
        			return false;
        		}

				if($("#MOVE_DATE").val().trim().length == 0) {
    				alert("입주희망일을 입력하세요.");
    				$("#MOVE_DATE").focus();
    				return false;
    			} 
    			if($("#PROMISE").is(":checked") == false) {
    				alert("준수사항을 확인하세요.");
    				$("#PROMISE").focus();
    				return false;
    			}
    			return true;
    		}
    		var isCanAddMate = function(grid) {
    			var valid = true;
        		$.each(grid.data, function(i, item) {
        			if(item.MATE_RELA == "" || item.MATE_NAME == "") {
                		alert("동거인 관계/성명을 입력후 추가 가능합니다.");
                		valid = false;
                		return false;
        			}
        		});
        		return valid;
    		}
            var customSerialize = function(data, param) {
            	//MATE_RELA, MATE_RELA2 ... 인 모델객체 때문에 별도 구현
            	$.each(data, function(i, row){
            		for (var key in row) {
            			if (row.hasOwnProperty(key)) {
            				if(i > 1)
            					param.push({name:key+(i+1), value:row[key]});
            				else
            					param.push({name:key, value:row[key]});
            			}
            		}
            	});
            }
        	// 상세 조회
        	var domitoryDetailView = function(id){
				var d = $.Deferred();
   				$.ajax({
   					type : "get",
   					url : "/supp/getDormitoryDetail.json",
   					dataType : "json",
   					data : { 
   						 "AINF_SEQN" : id
   					}
  				}).done(function(response) {
   					if(response.success) {
   						d.resolve(response.storeData);
   						setDetailView(response.storeData);
   					}
   		    		else
   		    			alert("조회시 오류가 발생하였습니다. " + response.message);
   				});
        	};
        	var setDetailView = function(data) {
        		$("#detailForm #BEGDA").val(data.BEGDA);
        		$("#detailForm #MOVE_DATE").val(data.MOVE_DATE);
    			$('#detailForm input:radio[name="ZCHOUSE_GUBUN"]:input[value='+data.ZCHOUSE_GUBUN+']').prop("checked", true);
    			$('#detailForm input:checkbox[name="NOHOUSE"]:input[value='+data.NOHOUSE+']').prop("checked", true);

    			var arrayData = [];
    			if(data.MATE_RELA !="" || data.MATE_NAME !="" || data.MATE_WORK !="")
    				arrayData.push({"MATE_RELA" : data.MATE_RELA, "MATE_NAME" : data.MATE_NAME, "MATE_WORK" : data.MATE_WORK});
    			if(data.MATE_RELA2 !="" || data.MATE_NAME2 !="" || data.MATE_WORK2 !="")
    				arrayData.push({"MATE_RELA" : data.MATE_RELA2, "MATE_NAME" : data.MATE_NAME2, "MATE_WORK" : data.MATE_WORK2});
    			if(data.MATE_RELA3 !="" || data.MATE_NAME3 !="" || data.MATE_WORK3 !="")
    				arrayData.push({"MATE_RELA" : data.MATE_RELA3, "MATE_NAME" : data.MATE_NAME3, "MATE_WORK" : data.MATE_WORK3});
    			if(data.MATE_RELA4 !="" || data.MATE_NAME4 !="" || data.MATE_WORK4 !="")
    				arrayData.push({"MATE_RELA" : data.MATE_RELA4, "MATE_NAME" : data.MATE_NAME4, "MATE_WORK" : data.MATE_WORK4});
    			if(data.MATE_RELA5 !="" || data.MATE_NAME5 !="" || data.MATE_WORK5 !="")
    				arrayData.push({"MATE_RELA" : data.MATE_RELA5, "MATE_NAME" : data.MATE_NAME5, "MATE_WORK" : data.MATE_WORK5});

				$("#mateGridForDetail").jsGrid({
					data: arrayData
        		});
        	}
		});
    </script>
