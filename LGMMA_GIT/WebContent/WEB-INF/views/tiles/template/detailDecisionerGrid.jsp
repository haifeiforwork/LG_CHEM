<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<script>
		$(function() {
			if($(".layerWrapper").length){
				// 결재자 팝업
				$("#PopLayerAppl").popup();
			};
			
			// 결재자 조회 popup 검색
			$("#ApplPopupSearchbtn").click(function(){
				$("#ApplPopupGrid").jsGrid("search");
			});
    		// 엔터 입력시 조회
    		$("#I_ENAME, #I_ENAME1").keyup(function(event){
	    		if (event.keyCode ==13 ){
	    			$("#ApplPopupGrid").jsGrid("search");
	    		}
    		});
    			
			$("#detailDecisioner").jsGrid({
				height: "auto",
				width: "100%",
				paging: false,
				autoload: false,
				rowClick: function(args){
					$("#ClickRow").val(args.itemIndex);
				},
				controller : {
					loadData : function() {
						var d = $.Deferred();
						var AINF_SEQN = '<c:out value="${AINF_SEQN}"/>';
						$.ajax({
							type : "GET",
							url : "/common/getAppDetailVt.json",
							dataType : "json",
							data: {AINF_SEQN:AINF_SEQN}
						}).done(function(response) {
							if(response.success)	
								d.resolve(response.storeData);
							else
								alert("조회시 오류가 발생하였습니다.\n\n" + response.message);
						});
						return d.promise();
					}
				},
				fields: [
					{ title: "결재자 구분", name: "APPL_APPU_NAME", type: "text", align: "center", width: "15%" },
					{ title: "<span class='textPink'>*</span>성명", name: "APPL_ENAME", type: "text", align: "center", width: "12%"
						
					},
					{ title: "부서명", name: "APPL_ORGTX", type: "text", align: "center", width: "20%" },
					{ title: "직책", name: "APPL_TITL2", type: "text", align: "center", width: "13%" },
					{ title: "승인일", name: "APPL_APPR_DATE", type: "text", align: "center", width: "15%",
						itemTemplate: function(value) {
							return (value == "0000.00.00") ? "" : value;
						}
					},
					{ title: "상태", name: "APPL_APPR_STAT", type: "text", align: "center", width: "12%",
						itemTemplate: function(value, storeData) {
							return value == "A" ? "승인" : value == "X" ? "반려" : value == "Z" ? "교육과정취소" : "미결" ;
						}
					},
					{ title: "연락처", name: "APPL_TELNUMBER", type: "number", align: "center", width: "13%" },
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
					{ name: "APPL_TITEL", type: "text", visible: false }
				]
			});
		});
		// 결재자 변경
		var PopAppl = function(item) {
			//필요한가?
			$("#PopLayerForm").each(function() {
				this.reset();
			});
			$("#ApplPopupGrid").jsGrid({"data":[]}); //초기화 방안 재확인 필요
			
			$("#PopLayerAppl").popup('show');
			$("#ApplPopupGrid").jsGrid({
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "get",
							url : "/common/searchDecisionerList.json",
							dataType : "json",
							data : { 
								"I_ENAME" : $("#I_ENAME").val(),
								"I_ENAME1" : $("#I_ENAME1").val(),
								"objid" : item.APPL_OBJID
							}
						}).done(function(response) {
							if(response.success)
								d.resolve(response.storeData);
							else
								alert("조회시 오류가 발생하였습니다.\n\n" + response.message);
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
					$("#detailDecisioner").jsGrid("updateItem", item, newItem).done(function() {
						$("#PopLayerAppl").popup('hide');
					});
				}
			});
		};
		
		// 결재자 검색 grid
		$(function() {
			$("#ApplPopupGrid").jsGrid({
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
	</script>
	<!-- //common : 반려사유 start -->
	<div class="tableArea" id="rejectName" style="display:none;">
	<div class="table">
			<table class="tableGeneral">
				<caption>반려사유</caption>
				<colgroup>
					<col width="15%" />
					<col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<th>반려사유</th>
						<td id="rejectNameTD" style="word-wrap:break-word;"></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!-- //common : 반려사유 end -->
	
<div id="Area" class="listArea">
	<!-- //common : 결재자 공통 start -->
	<h2 class="subtitle">결재정보</h2>	
	<div id="detailDecisioner">
	</div>
	<!-- //common : 결재자 end -->
	
	<!-- popup : 결재자 선택 start -->
	<div class="layerWrapper layerSizeM" id="PopLayerAppl" style="display:inherit !important">
		<div class="layerHeader">
			<strong>결재자 조회</strong>
			<a href="#" class="btnClose PopLayerAppl_close">창닫기</a>
		</div>
		<div class="layerContainer">
			<div class="layerContent">
				<!--// Content start  -->
				<div class="tableInquiry item1">
				<form id="PopLayerForm">
					<span class="pr5">결재자</span>
					<input type="text" id="I_ENAME" name="I_ENAME" class="w50" placeholder="성" />
					<input type="text" id="I_ENAME1" name="I_ENAME1" class="w80" placeholder="이름" />
					<a href="#" id="ApplPopupSearchbtn"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
					<input type="hidden" id="Objid" name="objid" />
					<input type="hidden" id="ClickRow" name="clickRow" />
				</form>
				</div>
				<div class="listArea pd0">
					<div id="ApplPopupGrid" class="jsGridPaging"></div>
				</div>
				<!--// Content end  -->
			</div>
		</div>
	</div>
</div>
<!-- //팝업: 결재자 선택 end -->
