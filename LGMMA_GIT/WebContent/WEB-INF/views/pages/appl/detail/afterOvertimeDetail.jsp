<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.DateTime"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="hris.common.rfc.GetTimmoRFC"%>
<%@ page import="hris.D.D03Vocation.D03VocationReasonData"%>
<%@ page import="hris.D.D03Vocation.rfc.D03VocationAReasonRFC"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    WebUserData user = (WebUserData) session.getValue("user");
    Vector D03VocationAReason_vt = new D03VocationAReasonRFC().getSubtyCode(user.empNo, "2005" , DateTime.getShortDateString());
    Vector options = new Vector();
    for (int j = 0; j < D03VocationAReason_vt.size(); j++) {
        D03VocationReasonData option = (D03VocationReasonData) D03VocationAReason_vt.get(j);
        options.addElement(new CodeEntity(option.SCODE, option.STEXT));
    }
    String E_RRDAT = new GetTimmoRFC().GetTimmo(user.companyCode);
    long   D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT,"."));
%>
<form id="detailForm">
<div class="tableArea">
    <h2 class="subtitle">초과근무(OT/특근) 사후신청 상세내역</h2>
    <div class="table">
        <table class="tableGeneral table-layout-fixed">
            <caption>초과근무(OT/특근) 사후신청</caption>
            <colgroup>
                <col class="col_15p" />
                <col />
                <col class="worktime-report type-c" />
            </colgroup>
            <tbody>
                <tr>
                    <th>신청일</th>
                    <td colspan="2" class="tdDate">
                        <input type="text" name="BEGDA" class="readOnly align-center" readonly="readonly" format="dateB" />
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink Lnodisplay">*</span>초과근무일 선택</th>
                    <td colspan="2" class="tdDate">
                        <input type="text" name="PICKED_DATE" class="datepicker readOnly align-center" readonly="readonly" format="dateB" />
                    </td>
                </tr>
                <tr>
                    <th>선택일 실근무시간</th>
                    <td colspan="2" class="selected-date-worktime">
                        <table>
                            <colgroup>
                                <col style="width: 80px" />
                                <col style="width:130px" />
                                <col style="width: 80px" />
                                <col style="width:130px" />
                                <col style="width: 80px" />
                                <col style="width:110px" />
                                <col style="width: 80px" />
                                <col style="width:173px" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>정상업무</th>
                                    <td><span id="CSTDAZ" data-reset="text" data-reset-text="-"></span></td>
                                    <th>업무재개</th>
                                    <td>
                                        <div id="ABEGUZ01" style="display:none" data-reset="text,display" data-reset-text="-" data-reset-display="none"></div>
                                        <div id="ABEGUZ02" style="display:none" data-reset="text,display" data-reset-text="-" data-reset-display="none"></div>
                                        <div id="CAREWK" data-reset="text" data-reset-text="-"></div>
                                    </td>
                                    <th>합계</th>
                                    <td><span id="CTOTAL" data-reset="text" data-reset-text="-"></span></td>
                                    <th>사후신청<br />가능시간</th>
                                    <td><span id="CRQPST" data-reset="text" data-reset-text="-"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink Lnodisplay">*</span>시간대 선택</th>
                    <td>
                        <label class="for-radio"><input type="radio" name="ZOVTYP" id="NRFLGG" value="N0" disabled="disabled" data-reset="checked,disabled" data-reset-checked="false" data-reset-disabled="true" />정상초과</label>
                        <label class="for-radio"><input type="radio" name="ZOVTYP" id="R01FLG" value="R1" disabled="disabled" data-reset="checked,disabled" data-reset-checked="false" data-reset-disabled="true" />업무재개1</label>
                        <label class="for-radio"><input type="radio" name="ZOVTYP" id="R02FLG" value="R2" disabled="disabled" data-reset="checked,disabled" data-reset-checked="false" data-reset-disabled="true" />업무재개2</label>
                    </td>
                    <%-- [WorkTime52] 시작 : 지정일자 근무시간현황 --%>
                    <jsp:include page="/WEB-INF/views/pages/work/include/realWorkTimeReportTable.jsp">
                        <jsp:param name="rowspan" value="4" />
                    </jsp:include>
                    <%-- [WorkTime52] 종료 : 지정일자 근무시간현황 --%>
                </tr>
                <tr>
                    <th><span class="textPink Lnodisplay">*</span>신청 초과근무일</th>
                    <td class="tdDate">
                        <input type="text" name="WORK_DATE" class="datetime-yyyymmdd readOnly" readonly="readonly" data-reset="value" format="dateB" />
                        <input type="checkbox" name="VTKEN" class="checkbox-large" disabled="disabled" data-reset="checked" data-reset-checked="false" /> 前日 근태에 포함
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink Lnodisplay">*</span>신청시간</th>
                    <td>
                        <input type="text" name="BEGUZ" class="datetime-hhmm readOnly" readonly="readonly" data-reset="value" format="time" />
                        ~
                        <input type="text" name="ENDUZ" class="datetime-hhmm readOnly" readonly="readonly" data-reset="value" format="time" />
                        <input type="text" name="STDAZ" class="datetime-hours readOnly align-right" readonly="readonly" data-reset="value" /> 시간
                        <div style="margin-left:10px; display:none" data-reset="display" data-reset-display="none">(휴게/비근무 <span id="CPDABS" data-reset="text"></span>)</div>

                        <input type="hidden" name="PBEG1" data-reset="value" />
                        <input type="hidden" name="PEND1" data-reset="value" />
                        <input type="hidden" name="PUNB1" data-reset="value" />
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink Lnodisplay">*</span>신청사유</th>
                    <td class="align-top">
                        <select name="OVTM_CODE" disabled="disabled" data-reset="disabled" data-reset-disabled="false">
                            <option value="">-------------</option>
                            <%= WebUtil.printOption(options) %>
                        </select>
                        <input type="text" name="REASON" placeholder="신청사유 입력" maxlength="40" readonly="readonly" class="ot-reason readOnly" data-reset="disabled" data-reset-disabled="false" />
                        <div class="bottom-filler type-c short"></div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="tableComment display-none consultant-request">
        <p><span class="bold">초과근무 사후신청은 발생 이후 3근무일 이내에 신청 및 결재를 완료하여 주시기 바랍니다.</span></p>
    </div>
</div>
</form>

<%@include file="/WEB-INF/views/tiles/template/javascriptOverTime.jsp"%>
<script type="text/javascript">
function detailSearch() {

    $.ajax({
        url: '/appl/getAfterOvertimeDetail.json',
        data: {
            AINF_SEQN: '${fn:escapeXml( AINF_SEQN )}'
        },
        dataType: 'json',
        type: 'POST'
    }).done(function(response) {
        $.LOGGER.debug('detailSearch', response);

        if (!response.success) {
            alert('상세정보 조회시 오류가 발생하였습니다.\n\n' + response.message);
            return;
        }

        $('#VTKENComment').hide();
        $('.bottom-filler').toggleClass('short', false).toggleClass('tall', true);
        $('#detailForm')[0].reset();
        destroydatepicker('detailForm');

        // 사무직-선택근무제 실근무시간 현황
        renderRealWorktimeReport(response.reportData || {});

        // 선택일자 실근무시간
        var worktimeData = response.worktimeData || {};
        renderAfterOvertimeData(worktimeData);

        // 초과근무 사후신청 상세
        var overtimeData = response.overtimeData || {};
        $('input[name="PICKED_DATE"]').val(moment(String.deformat(overtimeData.WORK_DATE), 'YYYYMMDD').subtract(overtimeData.VTKEN == 'X' ? 1 : 0, 'days').format('YYYY.MM.DD'));

        if (overtimeData.BEGUZ) overtimeData.BEGUZ = OverTimeUtils.transformTime(overtimeData.BEGUZ);
        if (overtimeData.ENDUZ) overtimeData.ENDUZ = OverTimeUtils.transformTime(overtimeData.ENDUZ);
        overtimeData.STDAZ = OverTimeUtils.getNelim(overtimeData.STDAZ, 2);

        setDetail(overtimeData);

        if (worktimeData.STDAZ == worktimeData.NRQPST && Number(overtimeData.PUNB1 || 0) > 0) {
            $('span#CPDABS').text(worktimeData.CPDABS).parent().css('display', 'inline');
        }
        $('input[name="ZOVTYP"][value="' + overtimeData.ZOVTYP + '"]').prop('checked', true);
    });
}

function setDetail(overtimeData) {

    setTableText(overtimeData, 'detailForm');
    fncSetFormReadOnly($('#detailForm'), true);
}

// 수정
function reqModifyActionCallBack() {

    if (getWorkTimeData()) {
        var isExistComment = $('#VTKENComment').show().length > 0;
        $('.bottom-filler').toggleClass('short', isExistComment).toggleClass('tall', !isExistComment);
        $('select[name="OVTM_CODE"], input[name="REASON"]').prop('readonly', false).toggleClass('readOnly', false);
        $('input[name="PICKED_DATE"]')
            .prop('readonly', false)
            .toggleClass('readOnly', false)
            .datepicker();
    }
}

// 수정취소
function reqCancelActionCallBack() {

    detailSearch();
};

// 초과근무 사후신청 수정
function reqSaveActionCallBack() {

    var PICKED_DATE = $('input[name="PICKED_DATE"]');
    if (!$.trim(PICKED_DATE.val())) {
        alert('초과근무일을 선택하세요.');
        PICKED_DATE.focus();
        return false;
    }
    if (/^\d{4}\.\d{2}\.\d{2}$/.test(PICKED_DATE)) {
        alert('초과근무일 형식 오류입니다.\n"#" 형식으로 입력하세요.'.replace(/#/, moment().format('YYYY.MM.DD')));
        PICKED_DATE.focus();
        return false;
    }

    var radios = $('input:radio:not(:disabled)');
    if (!radios.length) {
        alert('선택하신 초과근무일(#)에 유효한 신청유형이 없습니다.'.replace(/#/, PICKED_DATE.val()));
        return false;
    }
    if (!$('input:radio:checked').length) {
        alert('신청유형을 선택하세요.');
        return false;
    }

    if (!confirm('저장 하시겠습니까?')) return false;

    $('.salBtn').prop('disabled', true);

    var isOK = false,
    param = $('#detailForm').serializeArray();
    if ($('input[name="VTKEN"]').prop('checked')) {
        param.push({name: 'VTKEN', value: 'X'});
    }
    param.push({name: 'AINF_SEQN', value: '${fn:escapeXml( AINF_SEQN )}'});
    $('#detailDecisioner').jsGrid('serialize', param);

    $.ajax({
        url: '/appl/updateAfterOverTime.json',
        data: param,
        dataType: 'json',
        type: 'POST',
        cache: false,
        async: false,
        success: function(response) {
            $.LOGGER.debug('reqSaveActionCallBack', response);

            if (!response.success) {
                $('.salBtn').prop('disabled', false);
                alert('저장시 오류가 발생하였습니다.\n\n' + response.message);
                isOK = false;
                return false;
            }

            alert('저장되었습니다.');
            $('#applDetailArea').html('');
            $('#reqApplGrid').jsGrid('search');
            isOK = true;
        }
    });

    return isOK;
}

// 삭제
function reqDeleteActionCallBack() {

    if (!confirm('삭제하시겠습니까?')) return;

    $('#reqDeleteBtn').prop('disabled', true);

    var param = $('#detailForm').serializeArray();
    param.push({name: 'AINF_SEQN', value: '${fn:escapeXml( AINF_SEQN )}'});
    $('#detailDecisioner').jsGrid('serialize', param);

    $.ajax({
        url: '/appl/deleteAfterOvertime',
        data: param,
        dataType: 'json',
        type: 'POST',
        async: false,
        success: function(response) {
            $.LOGGER.debug('reqDeleteActionCallBack', response);

            if (!response.success) {
                $('#reqDeleteBtn').prop('disabled', false);
                alert('삭제시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            alert('삭제 되었습니다.');
            $('#applDetailArea').html('');
            $('#reqApplGrid').jsGrid('search');
        }
    });
}

function resetAfterOTData() {

    $('[data-reset]').each(function() {
        var t = $(this);
        $.each(t.data('reset').split(','), function(i, v) {
            if (v === 'value') t.val(t.data('resetValue') || '');
            else if (v === 'text') t.text(t.data('resetText') || '');
            else if (v === 'checked') t.prop(v, t.data('resetChecked'));
            else if (v === 'disabled') t.prop(v, t.data('resetDisabled'));
            else if (v === 'display') t.css(v, t.data('resetDisplay'));
        });
    });
}

/**
 * 초과근무 사후신청에서 일자 선택시
 * 해당 일자의 실근무시간 및 OT신청가능 시간과 일자가 속한 월 또는 주의 실근무시간 현황을 조회한다.
 */
function getWorkTimeData() {

    var PICKED_DATE = $('input[name="PICKED_DATE"]'), vPICKED_DATE = PICKED_DATE.val();
    if (!vPICKED_DATE) {
        alert('초과근무일을 선택하세요.');
        PICKED_DATE.focus();
        return false;
    }
    if (!/^\d{4}\.\d{2}\.\d{2}$/.test(vPICKED_DATE)) {
        alert('초과근무일을 "' + moment().format('YYYY.MM.DD') + '" 형식으로 입력하세요.');
        PICKED_DATE.focus();
        return false;
    }

    var dateChk = vPICKED_DATE.replace(/[^\d]/g, '');
    if (dateChk < '20040301') {
        alert('2004년 03월 01일부터 초과근무 신청이 가능합니다.');
        PICKED_DATE.val('').focus();
        return false;
    }
    if (dateChk < '<%= D_RRDAT %>') {
        alert('초과근무는 <%= "".equals(E_RRDAT) ? "" : WebUtil.printDate(E_RRDAT) %>일 이후에만 신청가능합니다.');
        PICKED_DATE.val('').focus();
        return false;
    }
    var selectedDate = moment(dateChk, 'YYYYMMDD');
    if (selectedDate.isSameOrAfter(moment().startOf('date'))) {
        alert(vPICKED_DATE + ' 일자의 초과근무 사후신청은 익일(' + selectedDate.add(1, 'days').format('YYYY.MM.DD') + ')부터 신청 가능합니다.');
        PICKED_DATE.val('').focus();
        return;
    }

    var isOK = false;
    $.ajax({
        url: '/work/getWorkTimeData.json',
        data: {
            WORK_DATE: vPICKED_DATE,
            AINF_SEQN: '${fn:escapeXml( AINF_SEQN )}'
        },
        dataType: 'json',
        type: 'POST',
        async: false,
        success: function(response) {
            $.LOGGER.debug('getWorkTimeData', response);

            if (!response.success) {
                if (response.code === 'SHIFT') {
                    PICKED_DATE.val('');
                    alert('교대조 직원은 공휴일에 초과근무를 신청하실 수 없습니다.\n담당부서에 문의하시기 바랍니다.');
                } else {
                    alert('초과근무일 근무시간 현황 조회중 오류가 발생하였습니다.\n\n' + response.message);
                }
                return;
            }

            resetAfterOTData();

            // 사무직-선택근무제 실근무시간 현황
            renderRealWorktimeReport(response.reportData || {});

            // 선택일자 실근무시간
            renderAfterOvertimeData($.extend(response.worktimeData || {}, {RQDAT: vPICKED_DATE}));

            isOK = true;
        }
    });
    return isOK;
}

$(document).ready(function() {

    $('input[name="PICKED_DATE"]').change(getWorkTimeData);

    setZOVTYPClickEvent();<%-- /worktime52/overtime.js --%>

    detailSearch();
});
</script>