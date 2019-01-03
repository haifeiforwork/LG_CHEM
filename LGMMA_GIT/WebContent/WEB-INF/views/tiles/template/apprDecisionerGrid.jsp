<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<script>
		$(function() {
			$("#detailDecisioner").jsGrid({
				height: "auto",
				width: "100%",
				paging: false,
				autoload: true,
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
								alert("조회시 오류가 발생하였습니다. " + response.message);
						});
						return d.promise();
					}
				},
				fields: [
					{ title: "결재자 구분", name: "APPL_APPU_NAME", type: "text", align: "center", width: "15%" },
					{ title: "성명", name: "APPL_ENAME", type: "text", align: "center", width: "12%" },
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
					{ name: "APPL_EMAILADDR", type: "text", visible: false },
					{ name: "APPL_TITEL", type: "text", visible: false }
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
</div>
