<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page import="hris.common.WebUserData"%>
<%!
private boolean isBlockType(String UPMU_TYPE) {
    
    return "17".equals(UPMU_TYPE)   // 초과근무(OT/특근) 신청
        || "18".equals(UPMU_TYPE)   // 휴가신청
        || "40".equals(UPMU_TYPE)   // 교육/출장 신청
        || "44".equals(UPMU_TYPE)   // Flextime 신청
        || "47".equals(UPMU_TYPE)   // 초과근무(OT/특근) 사후신청
        || "C17".equals(UPMU_TYPE)  // 초과근무(OT/특근) 취소신청
        || "C18".equals(UPMU_TYPE)  // 휴가 취소신청
        || "C40".equals(UPMU_TYPE); // 교육/출장 취소신청
}
%>
<%
    // 2018.11.01 적용, SAP CTS 이관 전까지 주52시간 관련 결재 기능은 모두 제한한다.
//    if (isBlockType(request.getParameter("UPMU_TYPE"))) request.setAttribute("STAT_TYPE", "BLOCK");

    // 2018.11.02 적용, SAP CTS 이관 후 테스트를 위해 등록된 IP에서 접속된 사용자만 주52시간 관련 결재 기능 제한을 해제한다.
    if (!"Y".equals(((WebUserData) session.getAttribute("user")).e_ip_match) && isBlockType(request.getParameter("UPMU_TYPE"))) request.setAttribute("STAT_TYPE", "BLOCK");
%>
<!--// Table end -->
<div>
	<div class="buttonArea">
		<ul class="btn_crud">
			<c:if test="${STAT_TYPE == '01'}">
				<li><a class="darken" href="#" id="reqModifyBtn"><span>수정</span></a></li>
				<li><a class="darken" href="#" id="reqDeleteBtn"><span>삭제</span></a></li>
				<li><a class="darken" href="#" id="reqCancelBtn"><span>취소</span></a></li>
				<li><a class="darken" href="#" id="reqSaveBtn"><span>저장</span></a></li>
			</c:if>
			<c:if test="${STAT_TYPE == '02'}">
			</c:if>
			<c:if test="${STAT_TYPE == '03'}">
			</c:if>
			<c:if test="${STAT_TYPE == '04'}">
			</c:if>
			<c:if test="${STAT_TYPE == '05'}">
			</c:if>
            <c:if test="${STAT_TYPE eq 'BLOCK'}">
                <span class="textPink bold">※ 시스템 및 데이타 전환 작업( 1월 12일 18시 ~ 1월 14일 09시 )으로 인하여 수정/삭제가 한시적으로 중단됩니다.</span>
            </c:if>
		</ul>
	</div>
</div>
<script type="text/javascript">

//	switchDecisioner(mode) :
//	mode 정리
//	'Modify' : 수정용 [ 결재자 그리드 수정용 필드 전환, 수정버튼 활성화, 삭제버튼 활성화 ]
//	'Delete' : 삭제용 [ 삭제버튼 활성화 ]
//	'Search' : 조회용 [ 버튼 없음 ]
//	''       : 기본   [ 결재자 그리드 조회용 필드 전환, 수정버튼 활성화, 삭제버튼 활성화 ]

var switchDecisioner = function(mode) {
	if (mode == "Modify") {
		$("#detailDecisioner").jsGrid({
			fields: [
				{ title: "결재자 구분", name: "APPL_APPU_NAME", type: "text", align: "center", width: "20%" },
				{ title: "<span class='textPink'>*</span>성명", name: "APPL_ENAME", type: "text", align: "center", width: "20%",
					itemTemplate: function(value, storeData) {
						if (storeData.APPL_APPU_TYPE=="01")
							return $("<input class=\"jsInputSearch readOnly\" disabled=\"disabled\" />")
									.attr({
										type:"text"
									})
									.val(value)
									.add(
										$("<img src=\"/web-resource/images/ico/ico_magnify.png\" title=\"검색\" />")
										.on("click", function(e) {
											PopAppl(storeData);
										})
									);
						else
							return value;
					}
				},
				{ title: "부서명", name: "APPL_ORGTX", type: "text", align: "center", width: "20%" },
				{ title: "직책", name: "APPL_TITL2", type: "text", align: "center", width: "20%" },
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
				{ name: "APPL_TITEL", type: "text", visible: false }
			]
		});

		$("#reqModifyBtn").hide();
		$("#reqDeleteBtn").hide();
		$("#reqCancelBtn").show();
		$("#reqSaveBtn").show();
	} else if (mode == "Delete") {
		$("#reqModifyBtn").hide();
		$("#reqDeleteBtn").show();
		$("#reqCancelBtn").hide();
		$("#reqSaveBtn").hide();
	} else if (mode == "Search") {
		$("#reqModifyBtn").hide();
		$("#reqDeleteBtn").hide();
		$("#reqCancelBtn").hide();
		$("#reqSaveBtn").hide();
	} else {
		$("#detailDecisioner").jsGrid({
			fields: [
				{ title: "결재자 구분", name: "APPL_APPU_NAME", type: "text", align: "center", width: "15%" },
				{ title: "<span class='textPink'>*</span>성명", name: "APPL_ENAME", type: "text", align: "center", width: "12%" },
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

		$("#reqModifyBtn").show();
		$("#reqDeleteBtn").show();
		$("#reqCancelBtn").hide();
		$("#reqSaveBtn").hide();
	}

	$("#detailDecisioner").jsGrid("search");
}

$(document).ready(function() {
	switchDecisioner('${BTN_MODE}');
});

$("#reqModifyBtn").click(function(e) {
    e.preventDefault();

	if (applStateChk('${STAT_TYPE}')) {
		switchDecisioner('Modify');
		reqModifyActionCallBack(); // detail 화면에서 구현
	}
});

$("#reqDeleteBtn").click(function(e) {
    e.preventDefault();

	if (applStateChk('${STAT_TYPE}')) reqDeleteActionCallBack(); // detail 화면에서 구현
});

$("#reqCancelBtn").click(function(e) {
    e.preventDefault();

	switchDecisioner();
	reqCancelActionCallBack(); // detail 화면에서 구현
});


$("#reqSaveBtn").click(function(e) {
    e.preventDefault();

	if (applStateChk('${STAT_TYPE}') && reqSaveActionCallBack()) {
		switchDecisioner(); // detail 화면에서 구현
	}
});

function applStateChk(type) {

	if (type == '01') return true;

	var alertMsg = "";
	switch (type) {
		case "02" :
			alertMsg = "이미 결재 진행 상태 입니다.";
			break;
		case "03" :
			alertMsg = "결재완료 상태 입니다.";
			break;
		case "04" :
			alertMsg = "반려 상태 입니다.";
			break;
		case "05" :
			alertMsg = "교육과정취소 상태 입니다.";
			break;
		default :
			break;
	}

	alert(alertMsg);
	return false;
}
</script>