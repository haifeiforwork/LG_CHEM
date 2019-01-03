<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--// Page Title start -->
<div class="title">
	<h1>나의 신청진행현황</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">HR 결재함</a></span></li>
			<li class="lastLocation"><span><a href="#">나의 신청진행현황</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--// Inquiry Table start -->
<div class="tableInquiry">
	<table>
		<caption>결재진행현황 조회</caption>
		<colgroup>
			<col class="col_9p" />
			<col class="col_26p" />
			<col class="col_10p" />
			<col class="col_16p" />
			<col class="col_10p" />
			<col class="col_29p" />
		</colgroup>
		<tbody>
			<tr>
				<th>업무구분</th>
				<td><select name="UPMU_TYPE" class="wPer" id="UPMU_TYPE"></select></td>
				<th>상태</th>
				<td><select name="STAT_TYPE" class="wPer" id="STAT_TYPE">
						<option value=""   selected>전체</option>
						<option value="01">미결재</option>
						<option value="02">진행중</option>
						<option value="03">결재완료</option>
						<option value="04">반려</option>
						<option value="05">교육과정취소</option>
					</select>
				</td>
				<th>신청일</th>
				<td class="tdDate">
					<input id="inputDateFrom" name="BEGDA" type="text" value="${fn:escapeXml( BEGDA )}" />
					~
					<input id="inputDateTo" name="ENDDA" type="text" value="${fn:escapeXml( ENDDA )}" />
				</td>
			</tr>
		</tbody>
	</table>

	<div class="tableBtnSearch"><button type="submit" id="applSearchBtn"><span>조회</span></button></div>
	<div class="clear"> </div>
</div>
<!--// Inquiry Table end -->

<c:if test="${TPGUB_CD}">
<div class="buttonArea" style="margin-bottom:5px">
    <ul class="btn_mdl">
        <li><a href="#" name="RADL-button"><span>신청/결재 기한</span></a></li>
    </ul>
</div>
</c:if>
<div id="reqApplGrid" class="jsGridPaging" style="margin-bottom:30px"><%-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --%></div>
<script>
$(function() {
	$('#reqApplGrid').jsGrid({
		height: 'auto',
		width: '100%',
		sorting: true,
		paging: true,
		autoload: true,
		controller : {
			loadData : function() {
				var d = $.Deferred();
				$.ajax({
					type : 'get',
					url : '/appl/getMyApplList.json'<%-- ZHRA_RFC_GET_APPL_LIST --%>,
					dataType : 'json',
					data : {
						BEGDA : $('input[name="BEGDA"]').val(),
						ENDDA : $('input[name="ENDDA"]').val(),
						UPMU_TYPE : $('#UPMU_TYPE option:selected').val(),
						STAT_TYPE : $('#STAT_TYPE option:selected').val()
					}
				}).done(function(response) {
				    console.log(response);
					$('#applDetailArea').html('');
					if (response.success)
						d.resolve(response.storeData);
					else
						alert('조회시 오류가 발생하였습니다.\n\n' + response.message);
				});
				return d.promise();
			}
		},
		fields: [
			{ title: '선택', name: 'AINF_SEQN', sorting: false, align: 'center', width: '8%',
				itemTemplate: function(value, item) {
					return $('<input type="radio" name="AINF_SEQN" />')
						.on('click', function(e) {
							showApplDetailView(item);
						});
				}
			},
			{ title: 'No.', name: 'ROWNUMBER', type: 'text', align: 'center', width: '10%', sorting: false,
				itemTemplate: function(value, item) {
					return $('#reqApplGrid').jsGrid('option', 'data').indexOf(item) + 1;
				}
			},
			{ title: '신청일', name: 'BEGDA', type: 'text', align: 'center', width: '16%'},
// 				itemTemplate: function(value, item) {
// 					return $('<a href="#">')
// 							.append(value)
// 							.on('click',function(e){
// 								showApplDetailViewNewWindow(item);
// 							});
// 				}
// 			},
			{ title: '업무구분', name: 'UPMU_NAME', type: 'text', align: 'center', width: '38%' },
			{ title: '상태', name: 'STAT_TYPE', type: 'text', align: 'center', width: '28%',
				itemTemplate: function(value, item) {
					switch (value) {
						case '01' :
							return '<img src="/web-resource/images/ico/ico_condition1.png" alt="결재전" />';
							break;
						case '02' :
							return '<img src="/web-resource/images/ico/ico_condition2.png" alt="결재중" />';
							break;
						case '03' :
							return '<img src="/web-resource/images/ico/ico_condition3.png" alt="결재완료" />';
							break;
						case '04' :
							return '<img src="/web-resource/images/ico/ico_condition4.png" alt="반려" />';
							break;
						case '05' :
							return '<img src="/web-resource/images/ico/ico_condition4.png" alt="교육과정취소" />';
							break;
						default :
							return '<img src="/web-resource/images/ico/ico_condition1.png" alt="결재전" />';
					}
				}
			}
		]
	});

});

function viewNameUpmuCase(upmuType) {
	switch (upmuType) {
		case '20' :
			return 'healthInsuDetail?BTN_MODE='; // 건강보험 자격변경신청
		case '21' :
			return 'healthInsuInfoDetail?BTN_MODE='; // 건강보험 정보변경신청
		case '80' :
			return 'accountDetail?BNKSA=9&BTN_MODE='; // 경비계좌 신청
		case '01' :
			return 'eventMoneyDetail?BTN_MODE='; // 경조금신청
		case '84' :
			return 'changeOnLineDetail?BTN_MODE=Search'; // 교육 차수변경
		case '40' :
			return 'eduTripDetail?BTN_MODE='; // 교육/출장 신청
		case '83' :
			return 'eduDetail?BTN_MODE=Delete'; // 교육신청
		case '36' :
			return 'onceRefundDetail?BTN_MODE=Delete'; // 구입전환일시지원금 상환
		case '35' :
			return 'onceSupportDetail?BTN_MODE='; // 구입전환일시지원금 신청
		case '22' :
			return 'pensionDetail?BTN_MODE='; // 국민연금 자격변경신청
		case '28' :
			return 'incomeTaxDetail?BTN_MODE='; // 근로소득,갑근세원천징수 신청
		case '34' :
			return 'uniformDetail?BTN_MODE='; // 근무복 신청
		case '10' :
			return 'accountDetail?BNKSA=0&BTN_MODE='; // 급여계좌신청
		case '07' :
			return 'supportFamilyDetail?BTN_MODE='; // 부양가족여부신청
		case '38' :
			return 'dormitoryDetail?BTN_MODE='; // 사택/기숙사 관리
		case '82' :
			return 'reSmlendingDetail?BTN_MODE=Delete'; // 소액대출 상환신청
		case '81' :
			return 'smlendingDetail?BTN_MODE='; // 소액대출 신규신청
		case '31' :
			return 'langSupportDetail?BTN_MODE='; // 어학지원비 신청
		case '85' :
			return 'kindergartenDetail?BTN_MODE='; // 유치원비 신청
		case '03' :
			return 'medicalDetail?BTN_MODE='; // 의료비신청
		case '19' :
			return 'informalDetail?BTN_MODE=Delete'; // 인포멀가입신청
		case '27' :
			return 'informalDropDetail?BTN_MODE=Delete'; // 인포멀탈퇴신청
		case '14' :
			return 'licenseDetail?BTN_MODE='; // 자격면허등록신청
		case '06' :
			return 'scholarshipDetail?BTN_MODE='; // 장학금/학자금 신청
		case '09' :
			return 'disasterDetail?BTN_MODE='; // 재해신청
		case '16' :
			return 'issueDetail?BTN_MODE='; // 제증명신청
		case '04' :
			return 'totalCareDetail?BTN_MODE=Delete'; // 종합검진신청
		case '13' :
			return 'houseRefundDetail?BTN_MODE=Delete'; // 주택자금 상환신청
		case '12' :
			return 'houseFundDetail?BTN_MODE='; // 주택자금 신규신청
		case '33' :
			return 'healthTrainDetail?BTN_MODE='; // 체력단련비
		case '17' :
			return 'workDetail?BTN_MODE='; // 초과근무(OT/특근) 신청
		case '32' :
			return 'condoFeeDetail?BTN_MODE='; // 콘도시스템(지원비)
		case '43' :
			return 'condoDetail?BTN_MODE='; // 콘도이용
		case '37' :
			return 'summerDetail?BTN_MODE='; // 하계휴향소비 신청
		case '18' :
			return 'vacationDetail?BTN_MODE='; // 휴가신청
		case 'C17' :
			return 'workCancelDetail?BTN_MODE=Delete'; // 초과근무(OT/특근) 취소신청
		case 'C40' :
			return 'eduTripCancelDetail?BTN_MODE=Delete'; // 교육/출장 취소신청
		case 'C18' :
			return 'vacationCancelDetail?BTN_MODE=Delete'; // 휴가 취소신청
		case '44' :
			return 'flexTimeDetail?BTN_MODE='; // Flextime 신청
		case '45' :
			return 'informalAccountInfoDetail?BTN_MODE='; // 간사계좌신청 신청
		case '46' :
			return 'informalAccountInfoChangeDetail?BTN_MODE='; // 간사계좌변경 신청
		case '47' :
			return 'afterOvertimeDetail?BTN_MODE='; // 초과근무(OT/특근) 사후신청
	}
};

// 결재진행현황 상세  //UPMU_TYPE 추가 필요한지 고려중
function showApplDetailView(item) {
	$.each($('.popup_wrapper'), function(i, popup) {	//기존 팝업레이어를 지운다. 이렇게 안하면 .popup_wrapper div 가 계속 생성된다.
		if (popup.id != 'popLayerHrStaff_wrapper') $('#' + popup.id).detach();
	});
	$('#applDetailArea').empty();

	var url = viewNameUpmuCase(item.UPMU_TYPE);
	if (url == null) {
		alert('선택 페이지가 존재하지 않습니다.');
		return false;
	}

	$('#applDetailArea').loader('show', '<img style="width:50px;height:50px" src="/web-resource/images/img_loading.gif" />');
	$('#applDetailArea').load('/appl/detail/' + url + '&AINF_SEQN=' + item.AINF_SEQN + '&UPMU_TYPE=' + item.UPMU_TYPE + '&STAT_TYPE=' + item.STAT_TYPE, function(response, status, xhr) {
		if (xhr.status == 401) {
			alert('세션이 종료 되었습니다.\n\n재접속 하시기 바랍니다.');
		} else if (xhr.status == 500) {
			alert('선택 페이지가 존재하지 않습니다.');
		}
		$('#applDetailArea').loader('hide');
		if (item.STAT_TYPE == '04') {
			$('#rejectName').show();
			$('#rejectNameTD').text(item.REJECT_NAME);
		}
	    $('html,body').animate({
	        scrollTop: $('#applDetailArea').offset().top
	    });
	});
};

// 결재진행현황 상세 test용
function showApplDetailViewNewWindow(item) {
	window.open('/appl/test/detail/' + viewNameUpmuCase(item.UPMU_TYPE) + '&AINF_SEQN=' + item.AINF_SEQN + '&STAT_TYPE=' + item.STAT_TYPE, 'newWindow', 'toolbar=1,directories=1,menubar=1,status=1,resizable=1,location=1,scrollbars=1,width=800,height=500');
};

$('#applSearchBtn').click(function() {
	$('#reqApplGrid').jsGrid('search');
});

// 업무코드
$.ajax({
	type : 'POST',
	url : '/common/getUpmuCodeList.json'<%-- ZHRA_RFC_GET_UPMU_TYPE --%>,
	dataType : 'json'
}).done(function(response) {
	if (!response.success) {
		alert('업무코드 조회시 오류가 발생하였습니다. ' + response.message);
		return;
	}
	$('#UPMU_TYPE')
	    .html('<option value="">전체</option>')
	    .append($.map(response.storeData, function (value, key) {
	        return '<option value="' + value.code + '">' + value.value + '</option>';
	    }));
});
</script>
<div class="listArea" id="applDetailArea"></div>