<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
%>
				<!--// Page Title start -->
				<div class="title">
					<h1>근무복</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">복리후생</a></span></li>
							<li class="lastLocation"><span><a href="#">근무복</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->	
				
				<!--------------- layout body start --------------->				
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" onclick="switchTabs(this, 'tab1');" class="selected">근무복 신청</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab2');">근무복지원내역</a></li>		
						<div class="buttonArea">
							<ul class="btn_mdl">
								<!-- <li><a href="#popLayerUniformStock" class="popLayerUniformStock_open"><span>근무복 재고</span></a></li> -->
								<li><a href="#" id="popLayerUniformImgBtn" class="popLayerUniformImg_open"><span>근무복 이미지</span></a></li>								
							</ul>
						</div>							
						<div class="clear"></div>					
					</ul>										
				</div>
				<!--// Tab end -->
				
				<!--// Tab1 start -->
				<div class="tabUnder tab1">
				<form name="reqUniformForm" id="reqUniformForm" method="post" action="">
					<!--// table start  -->
					<div class="tableArea">
						<h2 class="subtitle">신청서 작성</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>근무복 신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" id="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" readonly="readonly" />
								</td>
							</tr>
							</table>
						</div>						
					</div>						
					<div class="listArea">
						<div class="tableArea">
							<h2 class="subtitle">근무복 상의 재고현황</h2>
							<div id="upperStockGrid" class="thSpan">
							</div>
						</div>
						<div class="tableArea">
							<h2 class="subtitle">근무복 하의 재고현황</h2>
							<div id="lowerStockGrid" class="thSpan">
							</div>
						</div>
						<!--// Content end  -->	
						<!--// list start -->
						<div class="listArea">	
							<h2 class="subtitle">근무복 신청 목록</h2>
							<div id="reqUniformGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>	
						</div>
						</form>
						<!--// list end -->
						<!--// list start -->
						<div class="listArea" id="decisioner">	
						</div>	
						<!--// list end -->	
						<div class="buttonArea">
							<ul class="btn_crud">
								<li><a class="darken" href="#" id="reqUniformBtn"><span>신청</span></a></li>
							</ul>
						</div>		
					</div>
				</div>
				<!--// Tab1 end -->		
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">	
					<!--// list start -->
					<div class="listArea">		
						<h2 class="subtitle">근무복지원내역</h2>
						<div class="clear"></div>
						<div id="uniformDistGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>								
					</div>	
					<!--// list end -->		
				</div>
				<!--// Tab2 end -->
				<!--------------- layout body end --------------->						

<div class="layerWrapper layerSizeL" id="popLayerUniformImg">
	<div class="layerHeader">
		<strong>근무복 이미지</strong>
		<a href="#" class="btnClose popLayerUniformImg_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">			
			<!--// Content start  -->
			<div class="layerScroll">
				 <h2 class="subtitle">하계</h2>
				 <div class="uniformImg">
				 	<ul>
						<li>
							<img src="/web-resource/images/sub/summerStock01.jpg" alt="하계반팔 T-셔츠" >
					 		<p>하계반팔 T-셔츠</p>
					 	</li>
					 	<li>
							<img src="/web-resource/images/sub/summerStock02.jpg" alt="하계긴팔 T-셔츠" >
					 		<p>하계긴팔 T-셔츠</p>
					 	</li>
						<li>
							<img src="/web-resource/images/sub/summerStockb01.jpg" alt="하계 바지" >
					 		<p>하계 바지</p>
					 	</li>
					 	<li>
							<img src="/web-resource/images/sub/summerStockj01.jpg" alt="하계 점퍼" >
					 		<p>하계 점퍼</p>
					 	</li>
					</ul>
				 </div>
				 <h2 class="subtitle">춘추</h2>
				 <div class="uniformImg">
				 	<ul>
						<li>
							<img src="/web-resource/images/sub/fallStock01.jpg" alt="추동 T-셔츠" >
					 		<p>추동 T-셔츠</p>
					 	</li>
					 	<li>
							<img src="/web-resource/images/sub/fallStockj01.jpg" alt="추동 점퍼" >
					 		<p>추동 점퍼</p>
					 	</li>
						<li>
							<img src="/web-resource/images/sub/fallStockb01.jpg" alt="추동 바지" >
					 		<p>추동 바지</p>
					 	</li>
					</ul>
				 </div>
				 <h2 class="subtitle">동계</h2>
				 <div class="uniformImg">
				 	<ul>
						<li>
							<img src="/web-resource/images/sub/winterStockp01.jpg" alt="방한 파카" >
					 		<p>방한 파카</p>
					 	</li>
					 	<li>
							<img src="/web-resource/images/sub/winterStockz01.jpg" alt="방한 자파리 점퍼" >
					 		<p>방한 자파리 점퍼</p>
					 	</li>
					</ul>
				 </div>
			</div>
			<!--// Content end  -->							
		</div>		
	</div>		
</div>
<!-- //popup : 근무복이미지 end -->
	<script>
        $(function() {
        	var upperSizeList = [{"SIZE_CODE": "01", "SIZE_NAME": "90(S)"},
        	                 	{"SIZE_CODE": "02", "SIZE_NAME": "95(M)"},
        	                 	{"SIZE_CODE": "03", "SIZE_NAME": "100(L)"},
        	                 	{"SIZE_CODE": "04", "SIZE_NAME": "105(XL)"},
        	                 	{"SIZE_CODE": "05", "SIZE_NAME": "110(2XL)"},
        	                 	{"SIZE_CODE": "06", "SIZE_NAME": "115(3XL)"},
        	                 	{"SIZE_CODE": "07", "SIZE_NAME": "120(4XL)"}];

        	var lowerSizeList = [{"SIZE_CODE": "01", "SIZE_NAME": "27\""},
         	                 	{"SIZE_CODE": "02", "SIZE_NAME": "28\""},
         	                 	{"SIZE_CODE": "03", "SIZE_NAME": "29\""},
         	                 	{"SIZE_CODE": "04", "SIZE_NAME": "30\""},
         	                 	{"SIZE_CODE": "05", "SIZE_NAME": "31\""},
         	                 	{"SIZE_CODE": "06", "SIZE_NAME": "32\""},
         	                 	{"SIZE_CODE": "07", "SIZE_NAME": "33\""},
         	                 	{"SIZE_CODE": "08", "SIZE_NAME": "34\""},
         	                 	{"SIZE_CODE": "09", "SIZE_NAME": "35\""},
         	                 	{"SIZE_CODE": "10", "SIZE_NAME": "36\""},
         	                 	{"SIZE_CODE": "11", "SIZE_NAME": "38\""},
         	                 	{"SIZE_CODE": "12", "SIZE_NAME": "40\""},
         	                 	{"SIZE_CODE": "13", "SIZE_NAME": "42\""},
         	                 	{"SIZE_CODE": "14", "SIZE_NAME": "44\""}];

        	$('#decisioner').load('/common/getDecisionerGrid?upmuType=34&gridDivId=decisionerGrid');

        	$("#popLayerUniformImgBtn").click(function() {
        		$('#popLayerUniformImg').popup("show");
        	});
        	//상의 재고 Grid
			$("#upperStockGrid").jsGrid({
                width: "100%",
		        autoload: true,
		        headerRowRenderer: function() {
	                var $result = $("<tr>").height(0)
	                	.append($("<th>").width('10%'))
	                	.append($("<th>").width('24%'))
	                	.append($("<th>").width('7%'))
	                	.append($("<th>").width('7%'))
	                	.append($("<th>").width('7%'))
	                	.append($("<th>").width('7%'))
	        	        .append($("<th>").width('7%'))
	                	.append($("<th>").width('7%'))
	                	.append($("<th>").width('7%'))
	                	.append($("<th>").width('7%'))
	        	        .append($("<th>").width('10%'));
	                $result = $result.add($("<tr>")
	                	.append($("<th>").attr("colspan", 2).text("구분"))
	                	.append($("<th>").attr("colspan", 1).text("90"))
	                	.append($("<th>").attr("colspan", 1).text("95"))
	                	.append($("<th>").attr("colspan", 1).text("100"))
	                	.append($("<th>").attr("colspan", 1).text("105"))
	                	.append($("<th>").attr("colspan", 1).text("110"))
	                	.append($("<th>").attr("colspan", 1).text("115"))
	                	.append($("<th>").attr("colspan", 1).text("120"))
	                	.append($("<th>").attr("colspan", 1).text("총수량"))
	                	.append($("<th>").attr("colspan", 1).text("선택"))
	                	);
	                
	                var $tr = $("<tr>");
	                return $result.add($tr);
	            },
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "GET",
							url : "/supp/getUpperUniformStock.json",
							dataType : "json"
						}).done(function(response) {
							if(response.success) {
								d.resolve(response.storeData);
							}
			    			else
			    				alert("조회시 오류가 발생하였습니다. " + response.message);
						});
						return d.promise();
					}
				},
				fields : [ 
				           { name : "GROUP_NAME", title : "구분", align : "center",  type: "text", width: '10%', css: "bgGray"},
				           { name : "CODE_NAME", title : "구분", align : "center",  type: "text", width: '24%'}, 
				           { name : "STOCK_COUNT01", title : "90", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT02", title : "95", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				            },
				           { name : "STOCK_COUNT03", title : "100", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT04", title : "105", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT05", title : "110", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT06", title : "115", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT07", title : "120", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
			               { name : "SUM_COUNT", title : "총수량", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				            }, 
				           { name : "selectItem", title : "선택", align : "center",  type: "text", width: '10%',
		                    	itemTemplate: function(value, item) {
		                            return $("<a class='inlineBtn'><span>선택</span></a>")
		                            	   .on("click", function(e) {
		                            		   addUpperToRequest(item);
		                            	   });
		                        }
				           }
				         ],
				onDataLoaded: mergeUpperStockCells
			});
			function addUpperToRequest(item) {
				var sizeList = [];

	        	$.each(upperSizeList, function(i, row) {
	        		if(parseInt(item["STOCK_COUNT"+row.SIZE_CODE]) > 0)
	        			sizeList.push(row);
	        	});
				var newItem = {"TYPE_CODE" : "1", "TYPE_NAME" : "상의", "CODE_ITEM" : item.CODE_ITEM, "CODE_NAME" : item.CODE_NAME, "sizeList": sizeList};
				$("#reqUniformGrid").jsGrid("insertItem", newItem);
				$("#reqUniformGrid").focus();
			}
			function mergeUpperStockCells() {
				var data = $("#upperStockGrid").jsGrid("option", "data");
				var tdToRemove = [];
            	$.each(data, function(i, $item) {
            		var rowspan = 1;
            		var $row = $("#upperStockGrid").jsGrid("rowByItem", $item);
    				var $td  = $($row.find('td')[0]);
            		for(var j = i ; j < data.length -1 ; j ++) {
            			if(data[j].GROUP_NAME == data[j+1].GROUP_NAME) {
                    		var $nextTd = $($("#upperStockGrid").jsGrid("rowByItem", data[j+1]).find('td')[0]);
                    		tdToRemove.push($nextTd);
            				rowspan += 1;
            				$td.attr('rowspan', rowspan);
            			} else {
                			break;
            			}
            		}
            		//버튼에대해 css 재정의
    				$td  = $($row.find('td')[10]);
    				$td.attr('class', $td.attr('class') + " pd0");
            	});
            	$.each(tdToRemove, function(i, $td) {
            		$td.remove();
            	});
			}
        	//하의 재고 Grid
			$("#lowerStockGrid").jsGrid({
                width: "100%",
		        autoload: true,
		        headerRowRenderer: function() {
	                var $result = $("<tr>").height(0)
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('10%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	        	        .append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('5%'))
	                	.append($("<th>").width('7%'))
	        	        .append($("<th>").width('8%'));
	                $result = $result.add($("<tr>")
	                	.append($("<th>").attr("colspan", 2).text("구분"))
	                	.append($("<th>").attr("colspan", 1).text("27"))
	                	.append($("<th>").attr("colspan", 1).text("28"))
	                	.append($("<th>").attr("colspan", 1).text("29"))
	                	.append($("<th>").attr("colspan", 1).text("30"))
	                	.append($("<th>").attr("colspan", 1).text("31"))
	                	.append($("<th>").attr("colspan", 1).text("32"))
	                	.append($("<th>").attr("colspan", 1).text("33"))
	                	.append($("<th>").attr("colspan", 1).text("34"))
	                	.append($("<th>").attr("colspan", 1).text("35"))
	                	.append($("<th>").attr("colspan", 1).text("36"))
	                	.append($("<th>").attr("colspan", 1).text("38"))
	                	.append($("<th>").attr("colspan", 1).text("40"))
	                	.append($("<th>").attr("colspan", 1).text("42"))
	                	.append($("<th>").attr("colspan", 1).text("44"))
	                	.append($("<th>").attr("colspan", 1).text("총수량"))
	                	.append($("<th>").attr("colspan", 1).text("선택"))
	                	);
	                
	                var $tr = $("<tr>");
	                return $result.add($tr);
	            },
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "GET",
							url : "/supp/getLowerUniformStock.json",
							dataType : "json"
						}).done(function(response) {
							if(response.success) {
								d.resolve(response.storeData);
							}
			    			else
			    				alert("조회시 오류가 발생하였습니다. " + response.message);
						});
						return d.promise();
					}
				},
				fields : [ 
				           { name : "GROUP_NAME", title : "구분", align : "center",  type: "text", width: '5%', css: "bgGray"},
				           { name : "CODE_NAME", title : "구분", align : "center",  type: "text", width: '10%'}, 
				           { name : "STOCK_COUNT01", title : "90", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT02", title : "95", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT03", title : "100", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT04", title : "105", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT05", title : "110", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT06", title : "115", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT07", title : "120", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT08", title : "120", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT09", title : "120", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT10", title : "120", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT11", title : "120", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT12", title : "120", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT13", title : "120", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
				           { name : "STOCK_COUNT14", title : "120", align : "right",  type: "number", width: '5%',
				                itemTemplate: function(value) {
				                    return value.format();}
				           },
			               { name : "SUM_COUNT", title : "총수량", align : "right",  type: "number", width: '7%',
				                itemTemplate: function(value) {
				                    return value.format();}
				            }, 
				           { name : "selectItem", title : "선택", align : "center",  type: "text", width: '8%',
		                    	itemTemplate: function(value, item) {
		                            return $("<a class='inlineBtn'><span>선택</span></a>")
		                            	   .on("click", function(e) {
		                            		   addLowerToRequest(item);
		                            	   });
		                        }
				           }
				         ],
				onDataLoaded: mergeLowerStockCells
			});
			function addLowerToRequest(item) {
				var sizeList = [];
				$.each(lowerSizeList, function(i, row) {
	        		if(parseInt(item["STOCK_COUNT"+row.SIZE_CODE]) > 0)
	        			sizeList.push(row);
	        	});
				var newItem = {"TYPE_CODE" : "2", "TYPE_NAME" : "하의", "CODE_ITEM" : item.CODE_ITEM, "CODE_NAME" : item.CODE_NAME, "sizeList": sizeList};
				$("#reqUniformGrid").jsGrid("insertItem", newItem);
				$("#reqUniformGrid").focus();
			}
			function mergeLowerStockCells() {
				var data = $("#lowerStockGrid").jsGrid("option", "data");
				var tdToRemove = [];
            	$.each(data, function(i, $item) {
            		var rowspan = 1;
            		var $row = $("#lowerStockGrid").jsGrid("rowByItem", $item);
    				var $td  = $($row.find('td')[0]);
            		for(var j = i ; j < data.length -1 ; j ++) {
            			if(data[j].GROUP_NAME == data[j+1].GROUP_NAME) {
                    		var $nextTd = $($("#lowerStockGrid").jsGrid("rowByItem", data[j+1]).find('td')[0]);
                    		tdToRemove.push($nextTd);
            				rowspan += 1;
            				$td.attr('rowspan', rowspan);
            			} else {
                			break;
            			}
            		}
            		//버튼에대해 css 재정의
    				$td  = $($row.find('td')[17]);
    				$td.attr('class', $td.attr('class') + " pd0");
            	});
            	$.each(tdToRemove, function(i, $td) {
            		$td.remove();
            	});
			}
            $("#reqUniformGrid").jsGrid({
                height: "auto",
                width: "100%",
                paging: false,
                confirmDeleting: false,
                //deleteConfirm: "해당 아이템을 취소 하시겠습니까?",
/* 
                onItemInserting: function(args) {
					$.each(args.grid.data, function(i, row) {
						if(row.TYPE_CODE == args.item.TYPE_CODE && row.CODE_ITEM == args.item.CODE_ITEM) {
							args.cancel = true;
							alert("이미 해당 아이템을 선택하셨습니다!");
						}
					});
				},
 */                
				fields: [
                    {
                    	title: "취소",
                    	name: "cencelItem",
                        itemTemplate: function(value, item) {
                            return $("<input>").attr("type", "checkbox").on("click", function(e) {
                            	$("#reqUniformGrid").jsGrid("deleteItem", item);
                            });
                        },
                        align: "center",
                        width: "8%"
                    },
                    { title: "구분", name: "TYPE_CODE", type: "text", align: "center", width: "18%", visible: false },
                    { title: "구분", name: "CODE_ITEM", type: "text", align: "center", width: "18%", visible: false },
                    { title: "구분", name: "TYPE_NAME", type: "text", align: "center", width: "10%"},
                    { title: "품목", name: "CODE_NAME", type: "text", align: "center", width: "31%"},
                    { title: "SIZE", name: "SIZE_ITEM", type: "text", align: "center", width: "26%",
                        itemTemplate: function(value, item) {
                       		var $select = $("<select name='sizeSelect'>").width("100px")
                            .append($("<option>").val("").text("-----------"));
							$.each(item.sizeList, function(key, value) {
								if(item.SIZE_ITEM == value.SIZE_CODE)
							    	$('<option selected>').val(value.SIZE_CODE).text(value.SIZE_NAME).appendTo($select);
								else
							    	$('<option>').val(value.SIZE_CODE).text(value.SIZE_NAME).appendTo($select);
							});
                       		return $select.on("change", function(e) {
                       			item.SIZE_ITEM = $(this).find("option:selected").val();
                       			gatAvailStockAndSetCountItem(item);
                       		});
                        }
					},
                    { title: "수량", name: "COUNT_ITEM", type: "text", align: "center", width: "26%",
                        itemTemplate: function(value, item) {
                       		var $select = $("<select name='countSelect'>").width("100px")
                            .append($("<option>").val("").text("---------"));
                       		for(var i = 1 ; i <= parseInt(item.availStock) ; i ++) {
                       			if(parseInt(item.COUNT_ITEM) == i)
        					   		$('<option selected>').val(i).text(i).appendTo($select);
                       			else
        					   		$('<option>').val(i).text(i).appendTo($select);
                       		}
                       		
        					return $select.on("change", function(e) {
                       			item.COUNT_ITEM = $(this).find("option:selected").val();
                       		});
                        }
                    }
                ]
            });
			var gatAvailStockAndSetCountItem = function(item){
				$.ajax({
					type : "get",
					url : "/common/getAvailUniformInStock.json",
					dataType : "json",
					async : false,
					data : {
						"TYPE_CODE" : item.TYPE_CODE,
						"CODE_ITEM" : item.CODE_ITEM,
						"SIZE_ITEM" : item.SIZE_ITEM
					}
				}).done(function(response) {
					if (response.success) {
						item.availStock = response.storeData.STOCK_COUNT;
						resetCountItem(item);
					} else
						alert("재고 조회시 오류가 발생하였습니다. " + response.message);
				});
			}
			var resetCountItem = function(item){
				$("#reqUniformGrid").jsGrid("fieldOption", "COUNT_ITEM", "itemTemplate", function(value, item) {
               		var $select = $("<select name='countSelect'>").width("100px")
                    .append($("<option>").val("").text("---------"));
               		for(var i = 1 ; i <= parseInt(item.availStock) ; i ++) {
               			if(parseInt(item.COUNT_ITEM) == i)
					   		$('<option selected>').val(i).text(i).appendTo($select);
               			else
					   		$('<option>').val(i).text(i).appendTo($select);
               		}
               		
					return $select.on("change", function(e) {
               			item.COUNT_ITEM = $(this).find("option:selected").val();
               		});
                });
			}			
			
    		//reqUniformForm start
    		$("#reqUniformBtn").click(function(){
    			if(checkReqUniformFormValid()) {
    				if(confirm("신청하시겠습니까?")) {
    					$("#reqUniformBtn").prop("disabled", true);
    					var param = $("#reqUniformForm").serializeArray();
    					$("#reqUniformGrid").jsGrid("serialize", param);
    					$("#decisionerGrid").jsGrid("serialize", param);
    					jQuery.ajax({
    		        		type : 'POST',
    		        		url : '/supp/requestUniform',
    		        		cache : false,
    		        		dataType : 'json',
    		        		data : param,
    		        		async : false,
    		        		success : function(response) {
    		        			if(response.success) {
    		        				alert("신청되었습니다.");
    								$("#reqUniformForm").each(function() {  
    									this.reset();
    									$("#reqUniformGrid").jsGrid({data: []});
    								});  
    		        			} else {
    		        				alert("신청시 오류가 발생하였습니다. " + response.message);
    		        			}
    							$("#reqUniformBtn").prop("disabled", false);
    		        		}
    		        	});
    				}
    			}
    		});
    		var checkReqUniformFormValid = function() {
    			var gridData = $("#reqUniformGrid").jsGrid("option", "data");
    			var stockData;
    			var isValid = true;
    			if(gridData.length == 0) {
    			     alert("품목을 선택하세요!");
    			     return false;
    			}
				$.each(gridData, function(key, item) {
	        		var $row = $("#reqUniformGrid").jsGrid("rowByItem", item);
	        		if($row.find('select[name="sizeSelect"]').prop('selectedIndex') == 0) {
						alert("사이즈를 선택 하시기 바랍니다.");
		        		$row.find('select[name="sizeSelect"]').click();
						isValid = false;
						return false;
					}
				});
				if(isValid) {
					$.each(gridData, function(key, item) {
						if(!checkNum(item.COUNT_ITEM) || parseInt(item.COUNT_ITEM) < 1) {
							alert("수량을 선택 하시기 바랍니다.");
							isValid = false;
							return false;
						}
					});
				}
				if(isValid) {
					$.each(gridData, function(key, item) {
						if(item.TYPE_CODE == "1") {	//상의
							stockData = $("#upperStockGrid").jsGrid("option", "data");
						} else {
							stockData = $("#lowerStockGrid").jsGrid("option", "data");
						}
						$.each(stockData, function(key2, upper) {
							if(item.CODE_ITEM == upper.CODE_ITEM && parseInt(upper["STOCK_COUNT"+item.SIZE_ITEM]) == 0) {
								alert("해당 재고가 없습니다.");
				        		var $row = $("#reqUniformGrid").jsGrid("rowByItem", item);
				        		$row.find('select[name="sizeSelect"] option')[0].selected = true;
				        		$row.find('select[name="sizeSelect"]').click();
								isValid = false;
								return false;
							}
							if(item.CODE_ITEM == upper.CODE_ITEM && parseInt(upper["STOCK_COUNT"+item.SIZE_ITEM]) < parseInt(item.COUNT_ITEM)) {
								alert("재고가 충분하지 않습니다.");
								isValid = false;
								return false;
							}
						});
					});
				}
        		return isValid;
    		}
	        $("#uniformDistGrid").jsGrid({
	        	height: "auto",
	            width: "100%",
	            sorting: false,
	            paging: true,
	            autoload: true,
	            pageSize: 10,
	            pageButtonCount: 10,
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "GET",
							url : "/supp/getUniformDistList.json",
							dataType : "json"
						}).done(function(response) {
							if(response.success) {
								d.resolve(response.storeData);
							}
			    			else
			    				alert("조회시 오류가 발생하였습니다. " + response.message);
						});
						return d.promise();
					}
				},
	            fields: [
	                { title: "신청일", name: "BEGDA", type: "text", align: "center", width: "18%"},
	                { title: "구분", name: "FLAG", type: "text", align: "center", width: "18%",
		            	itemTemplate: function(value, item) {
			                return !item.CODE_NAME == "" ? "상의" : "하의";
		                }
	            	},
	                { title: "지급품목", name: "CODE_NAME", type: "text", align: "center", width: "26%",
		            	itemTemplate: function(value, item) {
			                return !item.CODE_NAME == "" ? item.CODE_NAME : item.CODE_NAME2;
		                }
	            	},
	                { title: "지급사이즈", name: "SIZE_NAME", type: "text", align: "center", width: "22%",
		            	itemTemplate: function(value, item) {
			                return !item.CODE_NAME == "" ? item.SIZE_NAME : item.SIZE_NAME2
		                }
	            	},
	                { title: "지급수량", name: "COUNT_NAME", type: "text", align: "center", width: "18%",
		            	itemTemplate: function(value, item) {
			                return !item.CODE_NAME == "" ? item.COUNT_NAME: item.COUNT_NAME2
		                }
	            	},
	            ],
				onDataLoaded: mergeUniformDistGrid
	        });					
			function mergeUniformDistGrid() {
				var data = $("#uniformDistGrid").jsGrid("option", "data");
				var tdToRemove = [];
            	$.each(data, function(i, $item) {
            		var rowspan = 1;
            		var $row = $("#uniformDistGrid").jsGrid("rowByItem", $item);
    				var $td  = $($row.find('td')[0]);
            		for(var j = i ; j < data.length -1 ; j ++) {
            			if(data[j].BEGDA == data[j+1].BEGDA) {
                    		var $nextTd = $($("#uniformDistGrid").jsGrid("rowByItem", data[j+1]).find('td')[0]);
                    		tdToRemove.push($nextTd);
            				rowspan += 1;
            				$td.attr('rowspan', rowspan);
            				$td.attr('class', $td.attr('class') + " bgGray");
            			} else {
            				$td.attr('class', $td.attr('class') + " bgGray");
                			break;
            			}
            		}
            	});
            	$.each(tdToRemove, function(i, $td) {
            		$td.remove();
            	});
			}
		});
    </script>
