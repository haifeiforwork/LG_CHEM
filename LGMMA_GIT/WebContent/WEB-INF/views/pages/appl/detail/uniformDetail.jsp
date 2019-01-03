<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<form id="detailForm" name="detailForm">
<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
<div class="tableArea">
	<h2 class="subtitle">근무복 신청 조회</h2>
	<div class="table">
			<table class="tableGeneral">
				<caption>근무복 신청</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_85p" />
				</colgroup>
				<tbody>
					<tr>
						<th><label for="inputText01-1">신청일</label></th>
						<td class="tdDate">
							<input class="readOnly" type="text" name="BEGDA" id="BEGDA" value="" readonly="readonly" />
						</td>
					</tr>
				</tbody>
			</table>
	</div>
	<div class="listArea">
		<div class="tableArea" id="upperStockArea">
			<h2 class="subtitle">근무복 상의 재고현황</h2>
			<div id="upperStockGrid" class="thSpan">
			</div>
		</div>
		<div class="tableArea" id="lowerStockArea">
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
		<!--// list end -->
		<!--// list start -->
	</div>
</div>
</form>
<!--// Table end -->
<script>
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

	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getUniformDetail.json",
			dataType : "json",
			data : {
				"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'
			}
		}).done(function(response) {
			if (response.success) {
				setDetail(response.storeData);
			} else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		var setDetail = function(data) {
			setTableText(data, "detailForm");
			$("#reqUniformGrid").jsGrid({data: []});
			$.each(data, function(i, item) {
				setSizeListAndTypeCode(item);
			});
			$.each(data, function(i, item) {
				$("#reqUniformGrid").jsGrid("insertItem", item);
			});
			fncSetFormReadOnly($("#detailForm"), true);
			setReadOnlyText($("input[name='delItem']"), true);
		}
	};
	var initReqUniformGrid = function() {
		$("#reqUniformGrid").jsGrid({
	        height: "auto",
	        width: "100%",
	        paging: false,
	        confirmDeleting: false,
	
			//autoload: true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/appl/getUniformDetail.json",
						data : {
							"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'
						},
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
	            {
	            	title: "취소",
	            	name: "cencelItem",
	                itemTemplate: function(value, item) {
	                    return $("<input name='delItem'>").attr("type", "checkbox").on("click", function(e) {
	                    	$("#reqUniformGrid").jsGrid("deleteItem", item);
	                    });
	                },
	                align: "center",
	                width: "8%"
	            },
	            { title: "상/하의", name: "TYPE_CODE", type: "text", align: "center", width: "18%", visible: false },
	            { title: "구분", name: "CODE_ITEM", type: "text", align: "center", width: "18%", visible: false },
	            { title: "구분", name: "TYPE_NAME", type: "text", align: "center", width: "10%",
	            	itemTemplate: function(value, item) {
	                	return item.TYPE_CODE == "2" ? "하의" : "상의";
		            }
	           	},
	            { title: "품목", name: "CODE_NAME", type: "text", align: "center", width: "31%",
	            	itemTemplate: function(value, item) {
	                	return getItemName(item);
		            }
	           	},
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
						$('<option selected>').val(parseInt(item.COUNT_ITEM)).text(parseInt(item.COUNT_ITEM)).appendTo($select);
	               		
	        			return $select.on("change", function(e) {
	               			item.COUNT_ITEM = $(this).find("option:selected").val();
	               		});
	                }
	            }
	        ]
	    });					
	}
	$(document).ready(function() {
		$("#upperStockArea").hide();
		$("#lowerStockArea").hide();
		initReqUniformGrid();
		detailSearch();
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
	        		async : false,
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
	        		async : false,
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

	function setSizeListAndTypeCode(oriItem) {
		oriItem.TYPE_CODE = oriItem.CODE_ITEM == "00" ? "2" : "1";
		oriItem.CODE_ITEM = oriItem.TYPE_CODE == "2" ? oriItem.CODE_ITEM2 : oriItem.CODE_ITEM;
		oriItem.SIZE_ITEM = oriItem.TYPE_CODE == "2" ?  oriItem.SIZE_ITEM2 : oriItem.SIZE_ITEM;
		oriItem.COUNT_ITEM = oriItem.TYPE_CODE == "2" ?  oriItem.COUNT_ITEM2 : oriItem.COUNT_ITEM;

		var sizeList = [];
		var data = $("#upperStockGrid").jsGrid("option", "data");
		var list = upperSizeList;

		if(oriItem.TYPE_CODE == "2") {
			data = $("#lowerStockGrid").jsGrid("option", "data");
			list = lowerSizeList;
		}

		for(var i = 0 ; i < data.length ; i ++) {
    		if(data[i].CODE_ITEM == oriItem.CODE_ITEM) {
    			var item = data[i]; 
       	    	$.each(list, function(i, row) {
       	    		//if(parseInt(item["STOCK_COUNT"+row.SIZE_CODE]) > 0)
       	    			sizeList.push(row);
       	    	});
       		}
		}
		oriItem.sizeList = sizeList;
		//gatAvailStockAndSetCountItem(oriItem);
	}

	function addUpperToRequest(item) {
		var sizeList = [];
    	$.each(upperSizeList, function(i, row) {
    		//if(parseInt(item["STOCK_COUNT"+row.SIZE_CODE]) > 0)
    			sizeList.push(row);
    	});
		//과거 데이터 때문에 신청때와는 달리 아이템 선택할때 중복체크적용 
/* 		$("#reqUniformGrid").jsGrid({
	        onItemInserting: function(args) {
				$.each(args.grid.data, function(i, row) {
					if(row.TYPE_CODE == args.item.TYPE_CODE && row.CODE_ITEM == args.item.CODE_ITEM) {
						args.cancel = true;
						alert("이미 해당 아이템을 선택하셨습니다!");
					}
				});
			}
		});
 */
		var newItem = {"TYPE_CODE" : "1", "TYPE_NAME" : "상의", "CODE_ITEM" : item.CODE_ITEM, "CODE_NAME" : item.CODE_NAME, "COUNT_ITEM": 1, "sizeList": sizeList};
		$("#reqUniformGrid").jsGrid("insertItem", newItem);
		$("#reqUniformGrid").focus();
	}
	function addLowerToRequest(item) {
		var sizeList = [];
		$.each(lowerSizeList, function(i, row) {
    		//if(parseInt(item["STOCK_COUNT"+row.SIZE_CODE]) > 0)
    			sizeList.push(row);
    	});
		//과거 데이터 때문에 신청때와는 달리 아이템 선택할때 중복체크적용 
/* 		$("#reqUniformGrid").jsGrid({
	        onItemInserting: function(args) {
				$.each(args.grid.data, function(i, row) {
					if(row.TYPE_CODE == args.item.TYPE_CODE && row.CODE_ITEM == args.item.CODE_ITEM) {
						args.cancel = true;
						alert("이미 해당 아이템을 선택하셨습니다!");
					}
				});
			}
		});
 */		
 		var newItem = {"TYPE_CODE" : "2", "TYPE_NAME" : "하의", "CODE_ITEM" : item.CODE_ITEM, "CODE_NAME" : item.CODE_NAME, "COUNT_ITEM": 1, "sizeList": sizeList};
		$("#reqUniformGrid").jsGrid("insertItem", newItem);
		$("#reqUniformGrid").focus();
	}

	var getItemName = function(item) {
		var data = $("#upperStockGrid").jsGrid("option", "data");
		var itemCode = item.CODE_ITEM;
		if(item.TYPE_CODE == "2") {
			data = $("#lowerStockGrid").jsGrid("option", "data");
			itemCode = item.CODE_ITEM;
		}

		for(var i = 0 ; i < data.length ; i ++) {
    		if(data[i].CODE_ITEM == itemCode) {
    			return data[i].CODE_NAME;
    		}
		}
	}

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
	var reqModifyActionCallBack = function() {
		$("#upperStockArea").show();
		$("#lowerStockArea").show();
		fncSetFormReadOnly($("#detailForm"), false, new Array("BEGDA"));
		setReadOnlyText($("input[name='delItem']"), false);
		var data = $("#reqUniformGrid").jsGrid("option", "data").slice(); //참조없는 복사
		$("#reqUniformGrid").jsGrid({data: []});
		for(var i = 0 ; i < data.length ; i ++) {
			data[i].SIZE_ITEM = "";
			$("#reqUniformGrid").jsGrid("insertItem", data[i]);
			resetCountItem(data[i]);
		}
	}

	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteUniform',
				cache : false,
				dataType : 'json',
				data : param,
				async : false,
				success : function(response) {
					if (response.success) {
						alert("삭제 되었습니다.");
						$('#applDetailArea').html('');
						$("#reqApplGrid").jsGrid("search");
					} else {
						alert("삭제시 오류가 발생하였습니다. " + response.message);
					}
					$("#reqDeleteBtn").prop("disabled", false);
				}
			});
		}
	}

	var reqCancelActionCallBack = function() {
		$("#detailForm").each(function() {
			this.reset();
		});
		$("#upperStockArea").hide();
		$("#lowerStockArea").hide();
		initReqUniformGrid();
		detailSearch();
	}

	var reqSaveActionCallBack = function() {
		if (checkDetailFormValid()) {
			if (confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				var param = $("#detailForm").serializeArray();
				$("#reqUniformGrid").jsGrid("serialize", param);
				$("#detailDecisioner").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateUniform',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
					success : function(response) {
						if (response.success) {
							alert("저장되었습니다.");
							$('#applDetailArea').html('');
							$("#reqApplGrid").jsGrid("search");
							return true;
						} else {
							alert("저장시 오류가 발생하였습니다. " + response.message);
							return false;
						}
						$("#reqSaveBtn").prop("disabled", false);
					}
				});
			}
		} else {
			return false;
		}

	};
	var checkDetailFormValid = function() {
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
</script>
