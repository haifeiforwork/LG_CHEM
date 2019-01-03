<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="<c:out value='${gridDivId}'/>Area">
	<!-- //common : 결재자 공통 start -->
	<h2 class="subtitle">결재정보</h2>
<%-- 	<div class='frs'>
		<c:choose>
			<c:when test="${selfApprovalEnable == 'Y'}">
		<input type="checkbox" name="selfApproval" id="selfApproval" value="Y" /><label for="selfPayment" class="bold v-ams colorPoint" >자가결제</label>
			</c:when>
			<c:otherwise>Not
			</c:otherwise>
		</c:choose>
	</div>
	<div class="clear"></div>
 --%>	<div id="<c:out value='${gridDivId}'/>">
	</div>
	<!-- //common : 결재자 end -->
	<!-- popup : 결재자 선택 start -->
	<div class="layerWrapper layerSizeM" id="<c:out value='${gridDivId}'/>PopLayerAppl" style="display:inherit !important">
		<div class="layerHeader">
			<strong>결재자 조회</strong>
			<a href="#" class="btnClose <c:out value='${gridDivId}'/>PopLayerAppl_close">창닫기</a>
		</div>
		<div class="layerContainer">
			<div class="layerContent">
				<!--// Content start  -->
				<div class="tableInquiry item1">
				<form id="<c:out value='${gridDivId}'/>PopLayerForm">
					<span class="pr5">결재자</span>
					<input type="text" id="<c:out value='${gridDivId}'/>I_ENAME" name="I_ENAME" class="w50" placeholder="성" />
					<input type="text" id="<c:out value='${gridDivId}'/>I_ENAME1" name="I_ENAME1" class="w80" placeholder="이름" />
					<a href="#" id="<c:out value='${gridDivId}'/>ApplPopupSearchbtn"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
					<input type="hidden" id="<c:out value='${gridDivId}'/>Objid" name="objid" />
					<input type="hidden" id="<c:out value='${gridDivId}'/>ClickRow" name="clickRow" />
				</form>
				</div>
				<div class="listArea pd0">
					<div id="<c:out value='${gridDivId}'/>ApplPopupGrid" class="jsGridPaging"></div>
				</div>
				<!--// Content end  -->
			</div>
		</div>
	</div>
</div>
<!-- //팝업: 결재자 선택 end -->
	<script>
		var <c:out value='${gridDivId}'/>SelfAppLineData; 
		var <c:out value='${gridDivId}'/>OrgAppLineData; 
        $(function() {
    		if($(".layerWrapper").length){
    			// 결재자 팝업
    			$("#<c:out value='${gridDivId}'/>PopLayerAppl").popup();
    		};
    		
    		// 결재자 조회 popup 검색
    		$("#<c:out value='${gridDivId}'/>ApplPopupSearchbtn").click(function(){
    			$("#<c:out value='${gridDivId}'/>ApplPopupGrid").jsGrid("search");
    		});
    		
    		// 엔터 입력시 조회
    		$("#<c:out value='${gridDivId}'/>I_ENAME, #<c:out value='${gridDivId}'/>I_ENAME1").keyup(function(event){
	    		if (event.keyCode ==13 ){
	    			$("#<c:out value='${gridDivId}'/>ApplPopupGrid").jsGrid("search");
	    		}
    		});
    			
	   		$("#<c:out value='${gridDivId}'/>").jsGrid({
	   			height: "auto",
	   			width: "100%",
	   			paging: false,
	   			autoload: true,
	   			rowClick: function(args){
	   				$("#<c:out value='${gridDivId}'/>ClickRow").val(args.itemIndex);
	   			},
	   			controller : {
	   				loadData : function() {
	   					var d = $.Deferred();
	   					var upmuType = '<c:out value="${upmuType}"/>';
	   					$.ajax({
	   						type : "GET",
	   						url : "/common/getDecisionerList.json",
	   						dataType : "json",
	   					    data: {upmuType:upmuType}
	   					}).done(function(response) {
	   						if(response.success) {
	   							d.resolve(response.storeData);
	   							//clone
	   							<c:out value='${gridDivId}'/>OrgAppLineData = $.extend({}, response.storeData[0]);
	   							<c:out value='${gridDivId}'/>SelfAppLineData = response.userData;
	   						} else {
	   		    				alert("결재선 조회시 오류가 발생하였습니다. " + response.message);
	   						}
	   					});
	   					return d.promise();
	   				}
	   			},
	   			fields: [
	   		         { title: "결재자 구분", name: "APPL_APPU_NAME", type: "text", align: "center", width: "20%" },
	   		         { title: "<span class='textPink'>*</span>성명", name: "APPL_ENAME", type: "text", align: "center", width: "20%",
	   		        	itemTemplate: function(value, storeData) {
	   		        		if(storeData.APPL_APPU_TYPE=="01")
	                        	return $("<input class='jsInputSearch readOnly' readonly disabled>")
	                        	       .attr({
	                        	    	   type:"text"
	                       	    	   })
	                        	       .val(value)
	                        	       .add(
	                        	    		$("<img>")
	                       	    		    .attr({
	                       	    			   src:"/web-resource/images/ico/ico_magnify.png",
	                       	    			   alt:'검색'
	                     	    			})
	                       	    		    .on("click", function(e) {
	                       	    		    	<c:out value='${gridDivId}'/>PopAppl(storeData);
	                       	    		    })
	                      	    	   );
	   		        		else
	   		        			return value;
	                    }
	   		         },
	   		         { title: "부서명", name: "APPL_ORGTX", type: "text", align: "center", width: "20%" },
	   		         { title: "직 책", name: "APPL_TITL2", type: "text", align: "center", width: "20%" },
	   		         { title: "연락처", name: "APPL_TELNUMBER", type: "number", align: "center", width: "20%" },
					 { name: "APPL_UPMU_FLAG", type: "text", visible: false },
					 { name: "APPL_APPU_TYPE", type: "text", visible: false },
					 { name: "APPL_APPR_TYPE", type: "text", visible: false },
					 { name: "APPL_APPR_SEQN", type: "text", visible: false },
					 { name: "APPL_PERNR", type: "text", visible: false },
					 { name: "APPL_OTYPE", type: "text", visible: false },
					 { name: "APPL_OBJID", type: "text", visible: false },
					 { name: "APPL_STEXT", type: "text", visible: false },
					 { name: "APPL_PERNR", type: "text", visible: false },
					 { name: "APPL_APPU_NUMB", type: "text", visible: false },
					 { name: "APPL_EMAILADDR", type: "text", visible: false },
					 { name: "APPL_TITEL", type: "text", visible: false }
	   			]
	   		});
		});
    	// 결재자 변경
    	var <c:out value='${gridDivId}'/>PopAppl = function(item) {
    		//필요한가?
    		$("#<c:out value='${gridDivId}'/>PopLayerForm").each(function() {
    			this.reset();
    		});
    		$("#<c:out value='${gridDivId}'/>ApplPopupGrid").jsGrid({"data":[]}); //초기화 방안 재확인 필요
    		
    		$("#<c:out value='${gridDivId}'/>PopLayerAppl").popup('show');
    		$("#<c:out value='${gridDivId}'/>ApplPopupGrid").jsGrid({
    			controller : {
    				loadData : function() {
       					var d = $.Deferred();
       					$.ajax({
       						type : "get",
       						url : "/common/searchDecisionerList.json",
       						dataType : "json",
       						data : { 
       							 "I_ENAME" : $("#<c:out value='${gridDivId}'/>I_ENAME").val()
       							,"I_ENAME1" : $("#<c:out value='${gridDivId}'/>I_ENAME1").val()
       							,"objid" : item.APPL_OBJID
       						}
      					}).done(function(response) {
       						if(response.success)
       							d.resolve(response.storeData);
       		    			else
       		    				alert("결재자 변경시 오류가 발생하였습니다. " + response.message);
       					});
       					return d.promise();
       				}
       			},
       			rowClick : function(args){
                	var newItem = {
    					"APPL_PERNR": args.item.PERNR,
    					"APPL_APPU_NUMB": args.item.APPU_NUMB,
    					"APPL_APPU_NAME": args.item.APPU_NAME,
    					"APPL_ENAME": args.item.ENAME,
    					"APPL_ORGTX": args.item.ORGTX,
    					"APPL_TITEL": args.item.TITEL,
    					"APPL_TITL2": args.item.TITL2,
    					"APPL_TELNUMBER": args.item.TELNUMBER,
    					"APPL_EMAILADDR": args.item.EMAILADDR
    				};
                	<c:out value='${gridDivId}'/>OrgAppLineData = $.extend({}, newItem);
                	$("#<c:out value='${gridDivId}'/>").jsGrid("updateItem", item, newItem).done(function() {
                        $("#<c:out value='${gridDivId}'/>PopLayerAppl").popup('hide');
    				});
                }
    		});
    	};
    	
    	// 결재자 검색 grid
    	$(function() {
            $("#<c:out value='${gridDivId}'/>ApplPopupGrid").jsGrid({
       			width: "100%",
       			height: "auto",
       			sorting: true,
       			paging: true,
                autoload: false,
                fields: [
                         {
                         	title: "선택", align: "center", width: "7%",
                             itemTemplate: function(_, item) {
                                 return $("<input>").attr("type", "radio");
                             }
                         },
                         { title: "사번",  name: "PERNR", type: "text", align: "center", width: "13%" },
                         { title: "성명",  name: "ENAME", type: "text", align: "center", width: "14%" },
                         { title: "부서명", name: "ORGTX", type: "text", align: "center", width: "32%" },
                         { title: "직위명", name: "TITEL", type: "text", align: "center", width: "17%" },
                         { title: "직책명", name: "TITL2", type: "text", align: "center", width: "17%" }
                ]
            });
        });
    	var <c:out value='${gridDivId}'/>ChangeAppLine = function(self) {
			var item = $("#<c:out value='${gridDivId}'/>").jsGrid("option", "data")[0];
    		if(self) {
            	$("#<c:out value='${gridDivId}'/>").jsGrid("updateItem", item, <c:out value='${gridDivId}'/>SelfAppLineData);
    		} else {
            	$("#<c:out value='${gridDivId}'/>").jsGrid("updateItem", item, <c:out value='${gridDivId}'/>OrgAppLineData);
    		}
    	}
    </script>
