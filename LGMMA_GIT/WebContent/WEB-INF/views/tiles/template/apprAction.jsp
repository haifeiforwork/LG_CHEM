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
//    if (isBlockType(request.getParameter("UPMU_TYPE"))) request.setAttribute("APPR_STAT", "BLOCK");

    // 2018.11.02 적용, SAP CTS 이관 후 테스트를 위해 등록된 IP에서 접속된 사용자만 주52시간 관련 결재 기능 제한을 해제한다.
    if (!"Y".equals(((WebUserData) session.getAttribute("user")).e_ip_match) && isBlockType(request.getParameter("UPMU_TYPE"))) request.setAttribute("APPR_STAT", "BLOCK");
%>
<!--// Table end -->
<div>
	<div class="buttonArea">
		<ul class="btn_crud">
			<c:if test="${empty APPR_STAT}">
				<li><a class="darken" href="javascript:void(0);" id="approvalBtn"><span>승인</span></a></li>
				<li><a class="darken pop_return_open" href="#pop_return" id="rejectBtn"><span>반려</span></a></li>
			</c:if>
            <c:if test="${APPR_STAT eq 'BLOCK'}">
                <span class="textPink bold">※ 시스템 및 데이타 전환 작업( 1월 12일 18시 ~ 1월 14일 09시 )으로 인하여 결재는 한시적으로 중단됩니다.</span>
            </c:if>
		</ul>
	</div>
</div>
<div class="layerWrapper layerSizeM" id="pop_return">
	<div class="layerHeader">
		<strong>반려사유</strong>
		<a href="#" class="btnClose pop_return_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">			
			<div class="tableArea tablePopup">
				<div class="table">
					<table class="tableGeneral">
						<caption>반려사유</caption>
						<colgroup>
							<col class="col_25p">
							<col class="col_75p">
						</colgroup>
						<tbody>
							<tr>
								<th>
									<label for="labelReturn">반려사유</label>
									<p class="colorOrg">(반려시 필수입니다.)</p>
								</th>
								<td colspan="3">
									<select id="returnSelection">
									</select>
									<div class="mt5">
										<input type="text" class="wPer" id="rejectTxt" name="rejectTxt" readonly />								
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="buttonArea buttonCenter">
				<ul class="btn_crud">
					<li><a class="darken" href="javascript:void(0);" id="rejectCompleteBtn"><span>확인</span></a></li>
					<li><a href="#" class="pop_return_close"><span>취소</span></a></li>
				</ul>
			</div>		
			<!--// Content end  -->							
		</div>		
	</div>		
</div>
<script type="text/javascript">
$(document).ready(function() {
	var UPMU_TYPE = '<c:out value="${UPMU_TYPE}"/>';
	$.ajax({
		type : 'get',
		url : '/appr/getReturnTypeList.json',
		data : {UPMU_TYPE : UPMU_TYPE},
		dataType : 'json'
	}).done(function(response) {
		if (response.success) {
			$('#returnSelection')
			    .html('<option value="default">-------------</option>')
			    .append($.map(response.storeData, function (value, key) {
	                $('#returnSelection').append('<option value=' + value.code + '>' + value.value + '</option>');
	            }))
                .append('<option value="txt">직접입력</option>');
		} else {
			alert('반려사유 조회 시 오류가 발생하였습니다. ' + response.message);
		}
	});
});

$('#returnSelection').change(function() {
	var test = $(this).val();
	if (test == 'txt') {
		$('#rejectTxt').removeAttr('readonly');
		$('input[name="rejectTxt"]').val('').focus();
	} else {
		$('#rejectTxt').attr('readonly', true);
		if (test == 'default') {
			$('input[name="rejectTxt"]').val('');
		} else {
			$('#rejectTxt').val($('#returnSelection option:selected').text());
		}
	}
});
$('#approvalBtn').click(function(){
	updateAppr('A');
});
$('#rejectBtn').click(function(){
	$('#pop_return').popup('show');
});
$('#rejectCompleteBtn').click(function(){
	if (checkValid('X')) {
		updateAppr('X');
	}
});

var updateAppr = function(apprStat) {
	if (confirm(apprStat == 'A' ? '승인 하시겠습니까?' : '반려 하시겠습니까?')) {
		$('#approvalBtn').prop('disabled', true);
		$('#rejectBtn').prop('disabled', true);
		
		var upmuType = '<c:out value="${UPMU_TYPE}" />';
		var param = [];
		$('#detailDecisioner').jsGrid('serialize', param);
		param.push({name:'AINF_SEQN', value:'<c:out value="${AINF_SEQN}"/>'});
		param.push({name:'UPMU_TYPE', value:upmuType});
		param.push({name:'REQDATE', value:'<c:out value="${REQDATE}"/>'});
		param.push({name:'PERNR', value:'<c:out value="${PERNR}"/>'});
		param.push({name:'EMAILADDR', value:'<c:out value="${EMAILADDR}"/>'});
		param.push({name:'APPR_STAT', value:apprStat});

		// 휴가
		if (upmuType == '18') {
			var awartCheck = $('input:radio[name="awartRadio"]').filter(':checked').val();
			var timeopen = (awartCheck == '0123' || awartCheck == '0124' || awartCheck == '0180' || awartCheck == '0112' || awartCheck == '0113') ? 'T' : 'F';
			param.push({name:'BEGDA', value:$('#detailBegda').val()});
			param.push({name:'AWART', value:awartCheck});
			param.push({name:'REASON', value:$('#detailReason').val()});
			param.push({name:'APPL_FROM', value:$('#detailApplFrom').val()});
			param.push({name:'APPL_TO', value:$('#detailApplTo').val()});
			param.push({name:'DEDUCT_DATE', value:$('#detailDeductDate').val()});
			param.push({name:'CONG_CODE', value:$('#detailCongCode').val()});
			param.push({name:'OVTM_NAME', value:$('#detailOvtmName').val()});
			param.push({name:'OVTM_CODE', value:$('#detailOvtmCode1').val()});
			param.push({name:'BEGUZ_HH', value:$('#detailBeguzHh').val()});
			param.push({name:'BEGUZ_MM', value:$('#detailBeguzMm').val()});
			param.push({name:'ENDUZ_HH', value:$('#detailEnduzHh').val()});
			param.push({name:'ENDUZ_MM', value:$('#detailEnduzMm').val()});
			param.push({name:'timeopen', value:timeopen});
		}
		// 휴가 취소
		else if (upmuType == 'C18') {
			param.push({name:'OAIN_SEQN', value:$('[name=OAIN_SEQN]').val()});
			param.push({name:'CREASON', value:$('#CREASON').text()});
		}
		// Flextime
		else if (upmuType == '44') {
			param.push({name:'FLEX_BEG', value:$('#FLEX_BEG').val()});
			param.push({name:'FLEX_END', value:$('#FLEX_END').val()});
		}
		// 초과근무 사후신청
		else if (upmuType == '47') {
		    if (window.overtimeData && $.isArray(window.overtimeData)) {
		        param = param.concat(window.overtimeData);
		    }
		}

		if (apprStat == 'X') {
		    param.push({name:'REJECT_TX', value:$('#rejectTxt').val()});
		}

		$.ajax({
			type : 'post',
			url : '/appr/updateAppr.json',
			cache : false,
			dataType : 'json',
			data : param,
			async : false,
			success : function(response) {
				if (response.success) {
				    if (upmuType == '17' && apprStat == 'A' && response.code == 'warning') {
				        alert('승인 되었습니다.\n\n' + response.message);
				    } else {
				        alert(apprStat == 'A' ? '승인 되었습니다.' : '반려 되었습니다');
				    }
				} else {
					alert(response.message);
					return false;
				}
				//$('#applDetailArea').html('');
				$('#pop_return').popup('hide');
				$('#reqApplGrid').jsGrid('search');
				$('#approvalBtn').prop('disabled', false);
				$('#rejectBtn').prop('disabled', false);
				return true;
			}				
		});
	}
}
var checkValid = function(apprStat) {

    if (apprStat != 'X') return true;

	var rejectTX = $('#rejectTxt').val();
	if (rejectTX) return true;

	if ($('#returnSelection option:selected').val() == 'txt') {
		$('#rejectTxt').focus();
	} else {
		$('#returnSelection').focus();
	}
	alert('반려사유를 입력하세요.');

	return false;
}
</script>