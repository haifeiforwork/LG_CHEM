<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@include file="/WEB-INF/views/tiles/template/javascriptWorkTime.jsp"%>
<script type="text/javascript" src="/web-resource/js/worktime52/common.js?v=${CACHE_VERSION}"></script>
<script type="text/javascript">
var WORKTIME_DATA = {
    E_TPGUB: null, // 근무구분[A:사무직 일반(정시/시차), C:선택근무]
    T_WHEAD: null, // 근무시간 통계
    T_WEEKS: null, // 주별 근무시간 합계
    T_WLIST: null, // 근무시간 정보 목록
    T_WKTYP: null, // 일별 구분 combo
    T_TYPES: null  // 교육/출장 계획 입력 구분 combo
},
POPUP_NAME = {
    BREAK_TIME: 0,
    EXTRA_TIME: 1,
    PLAN_TIME: 2
};

/**
 * 교육/출장 계획 입력 popup datepicker 설정
 */
function initDatePicker() {

    var tomorrow = moment().startOf('date').add(1, 'days'),
    options = {
        dateFormat : 'yy.mm.dd',
        minDate: tomorrow.toDate()
    };

    $('input#BEGDA')
        .val(tomorrow.format(Format.DATE))
        .change(function () {
            var BEGDA = $(this).val().trim(), MINDA = moment(BEGDA, Format.DATE);
            if (!BEGDA || !/^\d{4}.\d{2}.\d{2}$/.test(BEGDA)) {
                return;
            }

            // 시작일이 변경되면 종료일의 선택 가능한 최소 일자를 시작일로, 최대 일자를 시작일 + 한 달로 제한
            $('input#ENDDA').val('')
                .datepicker('option', {
                    minDate: MINDA.toDate(),
                    maxDate: moment(BEGDA, Format.DATE).add(1, 'months').toDate()
                });
        })
        .datepicker(options);

    $('input#ENDDA').val(tomorrow.format(Format.DATE)).datepicker(options);
}

/**
 * 비근무입력, 업무재개시간, 교육/출장 계획 입력 popup 초기 설정
 */
function initPopup() {

    // 비근무입력
    $('div#breaktimeList')
        .popup({
            transition: null,
            onclose: function() {
                $('div#breaktimeList').removeData();
            }
        });

    // 업무재개시간
    $('div#extratimeList')
        .popup({
            transition: null,
            onclose: function() {
                $('div#extratimeList').removeData();
            }
        })
        .find('select[name*="hour"]').html($.map(new Array(24), function(v, i) {
            return '<option value="#">#</option>'.replace(/#/g, String.lpad(i, 2, '0'));
        }).join(''))
        .end()
        .find('select[name*="minute"]').html($.map(new Array(6), function(v, i) {
            return '<option value="#">#</option>'.replace(/#/g, String.lpad((i * 10), 2, '0'));
        }).join(''));

    // 교육/출장 계획 입력
    $('div#plantimeTable')
        .popup({
            transition: null,
            onclose: function() {
                $('input#BEGDA').datepicker('destroy');
                $('input#ENDDA').datepicker('destroy');
            }
        });

    // 업무별 신청 popup
    $('#modalDialog')
        .popup({
            transition: null
        });
}

/**
 * 근무시간 사용 현황 상단 바로가기 button link 설정
 */
function initMenuLinkButton() {

    <c:if test='${E_JKBGB eq "T"}'>
    var BUTTON_LINK_URL = {
        MSS_OFW_WORK_TIME: {title: '근무 입력현황', height: 780, url: '/dept/orgRealWorkTime'},
        MSS_PT_RWORK_STAT: {title: '근무 실적현황', height: 780, url: '/dept/workTimeLeaderReport'},
        ESS_PT_FLEXTIME  : {title: 'Flextime 신청', height: 780, url: '/work/flexTime'},
        ESS_PT_LEAV_INFO : {title: '휴가 신청',     height: 780, url: '/work/vacationInfo'}
    };
    </c:if>
    <c:if test='${E_JKBGB eq "P"}'>
    var BUTTON_LINK_URL = {
        MSS_OFW_WORK_TIME: {title: '근무 입력현황',     height: 780, url: '/dept/orgRealWorkTime'},
        MSS_PT_RWORK_STAT: {title: '근무 실적현황',     height: 780, url: '/dept/workTimeLeaderReport'},
        ESS_PT_FLEXTIME  : {title: 'Flextime 신청',     height: 780, url: '/work/flexTime'},
        ESS_PT_LEAV_INFO : {title: '휴가 신청',         height: 780, url: '/work/vacationInfo'},
        ESS_OPT_OVER_TIME: {title: '초과근무 신청',     height: 780, url: '/work/attendanceInfo', data: {TABID: 'OTBF'}},
        ESS_OPT_OVTM_AFTR: {title: '초과근무 사후신청', height: 780, url: '/work/attendanceInfo', data: {TABID: 'OTAF'}}
    };
    </c:if>
    <c:if test='${E_JKBGB eq "O"}'>
    var BUTTON_LINK_URL = {
        ESS_PT_FLEXTIME  : {title: 'Flextime 신청',     height: 780, url: '/work/flexTime'},
        ESS_PT_LEAV_INFO : {title: '휴가 신청',         height: 780, url: '/work/vacationInfo'},
        ESS_OPT_OVER_TIME: {title: '초과근무 신청',     height: 780, url: '/work/attendanceInfo', data: {TABID: 'OTBF'}},
        ESS_OPT_OVTM_AFTR: {title: '초과근무 사후신청', height: 780, url: '/work/attendanceInfo', data: {TABID: 'OTAF'}}
    };
    </c:if>

    $.each(BUTTON_LINK_URL, function(k, p) {
        $('a[data-name="#"]'.replace(/#/, k)).click(function() {
            LoadingImage.show();

            $('#modalDialog iframe')
                .width(1048)
                .attr('src', p.url + '?' + $.param($.extend({FROM_ESS_OFW_WORK_TIME: 'Y'}, p.data)))
                .load(function() {
                    var iframe = $(this), bh = $('body').height() - 32, ih = iframe.contents().find('body').css('overflow-x', 'hidden').get(0).scrollHeight - 32;
                    iframe.height(ih > bh ? bh : (ih < p.height ? p.height : ih));

                    $('#modalDialog')
                        .width(1080)
                        .find('strong').text(p.title).end()
                        .draggable().popup('show');

                    LoadingImage.hide();
                });
        });
    });
}

/**
 * Layer popup 내에서 신청 작업이 완료되면 근무시간 목록을 갱신하고 popup을 닫음
 */
function closeLayerPopup(refresh) {

    if (refresh) retrieveData();

    $('.layerWrapper:visible').popup('hide');
}

/**
 * 비근무시간 합계 계산
 */
function sumMinutes() {

    var t = $('div#breaktimeList input[name="ABSTD"]').map(function() {
        return String.deformat($(this).val());
    }).get();

    $('td.minutes-sum').text(!t.length ? '' : eval(t.join(' + ')) + '분');
}

/**
 * 비근무시간 입력 행 추가
 */
function addBreaktime() {

    var template = $('tbody#breaktimeTemplate').html(), tbody = $('div#breaktimeList tbody');
    tbody.find('tr[data-not-found]').remove();
    tbody.append(template.replace(/data\-value=""/, 'value="10분"').replace(/data\-value=""/, ''));
    sumMinutes();
}

/**
 * 비근무시간 입력 행 삭제
 */
function removeBreaktime() {

    var tbody = $('div#breaktimeList tbody'), checkboxes = tbody.find('input[type="checkbox"]:checked');
    if (!checkboxes.length) {
        alert('삭제할 비근무시간 항목을 선택하세요.');
        return;
    }

    if (!confirm('선택하신 비근무시간을 삭제하시겠습니까?\n\n삭제 후 되돌리시려면 닫기 후 다시 팝업을 열어주세요.')) return;

    checkboxes.parents('tr').remove();
    if (!tbody.find('tr').length) {
        tbody.append('<tr class="oddRow" data-not-found><td colspan="3">해당하는 데이타가 존재하지 않습니다.</td></tr>');
    }
    sumMinutes();
}

/**
 * 비근무시간 data 저장
 */
function saveBreaktime() {

    var layer = $('div#breaktimeList'), trs = layer.find('tbody tr:not([data-not-found])'), WKDAT = String.deformat(layer.data('date')), timeSum = 0,
    list = trs.map(function() {
        var t = $(this), ABSTD = Number(String.deformat(t.find('input[name="ABSTD"]').val()));
        timeSum += ABSTD;
        return {
            WKDAT: WKDAT,
            ABSTD: ABSTD,
            DESCR: t.find('input[name="DESCR"]').val()
        };
    }).get();

    if (timeSum > 120) {
        alert('비근무시간은 총 120분을 초과할 수 없습니다.');
        return;
    }
    if (!confirm('저장하시겠습니까?')) return;

    var params = $.extend(true, $('form#attForm').jsonize(), {
        NAME: 'BREAK_SAVE',
        I_WKDAT: WKDAT,
        TABLES: JSON.stringify({
            T_ELIST: list
        })
    });

    ajaxPost(
        '/work/getRealWorkTimeData.json',
        params,
        function(data) {
            $.LOGGER.debug('비근무시간 목록 저장 AJAX 호출', data);

            data = getRfcResult(data);

            if (data.success) {
                alert('저장되었습니다.');
            } else {
                alert(data.message);
            }

            closeLayerPopup(true);
        },
        function(data) {
            $.LOGGER.debug('비근무시간 목록 저장 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

/**
 * 두 시간대가 겹치는지 확인
 * 
 * @param beg1 시간대1 시작 시간
 * @param end1 시간대1 종료 시간
 * @param beg2 시간대2 시작 시간
 * @param end2 시간대2 종료 시간
 * @returns 오류 message
 */
function isTimeSlotsOverlapped(beg1, end1, beg2, end2) {

    return beg1.isSame(beg2) || end1.isSame(end2) || (beg1.isBefore(beg2) && beg2.isBefore(end1)) || (beg1.isAfter(beg2) && beg1.isBefore(end2));
}

/**
 * 입력된 업무재개시간이 저장 가능한 시간대인지 확인
 * 
 * 근무유형       : 업무/휴가/휴무/휴일/교육/출장 등 화면에서 combo로 선택하는 구분
 * 기본 업무 시간 : 업무 시간이 입력 가능한 근무유형인 경우 사용자가 입력한 업무 시간
 *                  업무 시간이 입력 불가능한 근무유형인 경우 시스템 내부에서 가지고 있는 계획근무 시간
 * 
 * 확인 로직
 * 1. 업무재개 시간은 근무유형이 가지는 기본 업무 시간 이후로만 저장 가능함.
 *    기본 업무 시간을 가지지 않는 근무유형(ex: 휴일)의 경우 어느 시간대든 저장 가능.
 * 2. 기본 업무 시간 입력 가능한 근무유형인 경우 사용자가 입력한 기본 업무 시간대와 겹치는지 확인
 * 3. 기본 업무 시간 입력 불가능한 근무유형인데 계획근무 시간을 가지는 근무유형의 경우 계획근무 시간대와 겹치는지 확인
 * 4. 익일 계획 근무 시간이 있는 경우 계획 근무 시간대와 겹치는지 확인
 * 
 * @param ABEGUZ
 * @param AENDUZ
 * @param layer
 * @returns
 */
function validateTimeSlot(ABEGUZ, AENDUZ, layer) {

    var KEY_WKDAT = layer.data('date'), WKDAT = String.deformat(KEY_WKDAT), WKTYP = layer.data('wktyp');

    ABEGUZ = getMoment(WKDAT, ABEGUZ); // 업무재개 시작 시간
    AENDUZ = getMoment(WKDAT, AENDUZ); // 업무재개 종료 시간

    // 기본 업무 시간 입력 가능한 근무유형인 경우
    if (WORKTIME_DATA.T_WKTYP[KEY_WKDAT].data[WKTYP].PSTIM === 'X') {
        var BEGUZ = getMoment(WKDAT, layer.data('beguz')), // 기본 업무 시작 시간
            ENDUZ = getMoment(WKDAT, layer.data('enduz')); // 기본 업무 종료 시간

        // 기본 업무 시작 시간이 기본 업무 종료 시간보다 이후라면 24시가 넘어간 것으로 간주하여 기본 업무 종료 시간에 하루를 더함
        // ex) 23:00 ~ 01:00
        if (BEGUZ.isSameOrAfter( ENDUZ))  ENDUZ.add(1, 'days');

        // 기본 업무 시작 시간이 업무재개 시간보다 이후라면 24시가 넘어간 것으로 간주하여 업무재개 시간에 하루를 더함
        if (BEGUZ.isSameOrAfter(ABEGUZ)) ABEGUZ.add(1, 'days');
        if (BEGUZ.isSameOrAfter(AENDUZ) || ABEGUZ.isSameOrAfter(AENDUZ)) AENDUZ.add(1, 'days');

        // 업무재개 시작/종료 시간 순서 확인
        if (ABEGUZ.isAfter(AENDUZ)) {
            return '업무재개 시작 시간이 업무재개 종료 시간 이후입니다.';
        }

        // |<--- 전반 휴가 --->|<--- 후반 기본 업무 --->|<--- 업무재개 --->|<--- 익일 계획 근무 --->
        // 휴가(전반)
        if (WKTYP === '3120') {
            if (ABEGUZ.isBefore(ENDUZ) || AENDUZ.isBefore(ENDUZ)) {
                return '기본 업무 시간 이후에만 업무재개 시간 입력이 가능합니다.';
            }
        }
        // |<--- 전반 기본 업무 --->|<--- 후반 휴가 --->|<--- 업무재개 --->|<--- 익일 계획 근무 --->
        // 휴가(후반) : 반차의 경우 계획 근무 시간은 업무 시간과 반차 시간이 합쳐진 시간
        else if (WKTYP === '3130') {
            var data = WORKTIME_DATA.T_WLIST[KEY_WKDAT],
            SOBEG = getMoment(WKDAT, data.SOBEG), // 계획 근무 시작 시간
            SOEND = getMoment(WKDAT, data.SOEND); // 계획 근무 종료 시간(실제 데이터는 반차 종료 시간)

            if (SOBEG.isAfter(SOEND)) SOEND.add(1, 'days');

            if (ABEGUZ.isBefore(SOEND) || AENDUZ.isBefore(SOEND)) {
                return '휴가 시간 이후에만 업무재개 시간 입력이 가능합니다.';
            }
        }
        // |<--- 기본 업무 --->|<--- 업무재개 --->|<--- 익일 계획 근무 --->
        // 업무
        else {
            if (ABEGUZ.isBefore(ENDUZ) || AENDUZ.isBefore(ENDUZ)) {
                return '기본 업무 시간 이후에만 업무재개 시간 입력이 가능합니다.';
            }
        }
    }
    // 기본 업무 시간 입력 불가능한 근무유형인 경우
    else {
        var data = WORKTIME_DATA.T_WLIST[KEY_WKDAT];

        // 교육(2010) 또는 출장(2020)인 경우
        if (WKTYP === '2010' || WKTYP === '2020') {
            var SOBEG = getMoment(WKDAT, data.SOBEG), // 계획 근무 시작 시간
                SOEND = getMoment(WKDAT, data.SOEND); // 계획 근무 종료 시간

            if (SOBEG.isAfter(SOEND)) SOEND.add(1, 'days');

            var BEGUZ = getMoment(WKDAT, layer.data('beguz')); // 기본 업무 시작 시간

            // 기본 업무 시작 시간이 업무재개 시간보다 이후라면 24시가 넘어간 것으로 간주하여 업무재개 시간에 하루를 더함
            if (BEGUZ.isSameOrAfter(ABEGUZ)) ABEGUZ.add(1, 'days');
            if (BEGUZ.isSameOrAfter(AENDUZ) || ABEGUZ.isSameOrAfter(AENDUZ)) AENDUZ.add(1, 'days');

            if (ABEGUZ.isBefore(SOEND) || AENDUZ.isBefore(SOEND)) {
                return '계획 근무 시간 이후에만 업무재개 시간 입력이 가능합니다.';
            }
        }
    }

    var t6w = layer.data('tomorrow') || {};

    // 익일의 구분값이 휴무(3020)가 아니고 익일 계획 근무 시간이 있는 경우
    if (t6w.WKTYP !== '3020' && t6w.SOBEG) {
        var TSOBEG = getMoment(WKDAT, t6w.SOBEG).add(1, 'days'); // 익일 계획 근무 시작 시간

        if (ABEGUZ.isAfter(TSOBEG) || AENDUZ.isAfter(TSOBEG)) {
            return '업무재개 종료시각이 익일 업무시간과 중복됩니다.';
        }
    }

    return '';
}

/**
 * 업무재개시간 popup 시간 combo 초기화(삭제)
 */
function clearExtratime() {

    var tbody = $('div#extratimeList tbody'), checkboxes = tbody.find('input[type="checkbox"]:checked');
    if (!checkboxes.length) {
        alert('초기화할 업무재개시간 항목을 선택하세요.');
        return;
    }

    if (!confirm('선택하신 업무재개시간을 초기화하시겠습니까?\n\n초기화 후 되돌리시려면 닫기 후 다시 팝업을 열어주세요.')) return;

    checkboxes
        .parents('tr')
        .find('select').val('00').end()
        .find('input' ).val('').end()
        .end().prop('checked', false);
}

/**
 * 업무재개시간 data 저장
 */
function saveExtratime() {

    var layer = $('div#extratimeList'), WKDAT = String.deformat(layer.data('date')), messages = [],
    trs = layer.find('tbody tr:not([data-not-found])'),
    list = trs.map(function(i) {
        var t = $(this),
        ABEGUZ = t.find('select[name*="ABEGUZ"] option:selected').text(),
        AENDUZ = t.find('select[name*="AENDUZ"] option:selected').text(),
        DESCR = t.find('input[name="DESCR"]').val().trim();

        // 시작/종료 시간 모두 0시 0분이면 삭제로 간주
        if (ABEGUZ === '0000' && AENDUZ === '0000') {
            return { ABEGUZ: '', AENDUZ: '' };
        }
        if (ABEGUZ === AENDUZ) {
            messages.push((i + 1) + '행 : 업무 시작 시간과 업무 종료 시간이 같습니다.');
            return null;
        }
        var msg = validateTimeSlot(ABEGUZ, AENDUZ, layer); // 시간대 입력 가능 여부 확인 : 오류가 있는 경우 메세지가 반환됨
        if (msg) {
            messages.push((i + 1) + '행 : ' + msg);
            return null;
        }
        if (DESCR.length < 2) {
            messages.push((i + 1) + '행 : 2글자 이상 입력하세요.');
            return null;
        }

        return {
            WKDAT: WKDAT,
            ABEGUZ: ABEGUZ + '00',
            AENDUZ: AENDUZ + '00',
            DESCR: DESCR
        };
    }).get();

    if (messages.length) {
        alert(messages.join('\n'));
        return;
    }

    var isRemove = [!list[0].ABEGUZ && !list[0].AENDUZ, !list[1].ABEGUZ && !list[1].AENDUZ],
    ABEGUZ1 = isRemove[0] ? null : getMoment(WKDAT, list[0].ABEGUZ),
    AENDUZ1 = isRemove[0] ? null : getMoment(WKDAT, list[0].AENDUZ),
    ABEGUZ2 = isRemove[1] ? null : getMoment(WKDAT, list[1].ABEGUZ),
    AENDUZ2 = isRemove[1] ? null : getMoment(WKDAT, list[1].AENDUZ);

    // 1, 2행 모두 0시 0분을 입력하여 업무재개 시간을 삭제 처리하려고 한다면 시간대 겹침 확인은 건너뜀
    // 입력된 업무재개 시간 1, 2행 간의 겹침 확인
    if (!isRemove[0] && !isRemove[1]) {
        if (ABEGUZ1.isAfter(AENDUZ1)) AENDUZ1 = AENDUZ1.add(1, 'days');
        if (ABEGUZ2.isAfter(AENDUZ2)) AENDUZ2 = AENDUZ2.add(1, 'days');

        if (isTimeSlotsOverlapped(ABEGUZ1, AENDUZ1, ABEGUZ2, AENDUZ2)) {
            alert('1행의 업무재개 시간대와 2행의 업무재개 시간대가 겹칩니다.');
            return;
        }
    }

    // 업무재개 시간 정보 저장시 RFC에서는 기존 정보를 삭제 후 입력된 정보만 새로 저장함
    // 따라서 삭제를 위해 초기화한 행의 정보는 RFC로 넘기지 않음
    if (isRemove[1]) list.pop();   // 배열의 마지막 원소 제거
    if (isRemove[0]) list.shift(); // 배열의 첫번째 원소 제거

    if (!confirm('저장하시겠습니까?')) return;

    var params = $.extend(true, $('form#attForm').jsonize(), {
        NAME: 'EXTRA_SAVE',
        I_WKDAT: WKDAT,
        TABLES: JSON.stringify({
            T_ELIST: list
        })
    });

    ajaxPost(
        '/work/getRealWorkTimeData.json',
        params,
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 저장 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                alert(data.message);
                return;
            }

            // 근무가능시간의 잔여시간이 부족한 경우 warning이 return 됨
            if (data.warning) {
                alert(data.message);
            } else {
                alert('저장되었습니다.');
            }

            closeLayerPopup(true);
        },
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 저장 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

/**
 * isTrue가 true이면 msg를 띄우고 target에 focus를 둔다.
 * 
 * @param msg
 * @param target
 * @param isTrue
 * @returns validation 진행 중단 여부, true면 중단
 */
function isNotValid(msg, target, isTrue) {

    if (!isTrue) return false;

    alert(msg);
    target.focus();
    return true;
}

/**
 * 교육/출장 계획 data 저장
 */
function savePlantime() {

    var BEGDA = $('input#BEGDA'), ENDDA = $('input#ENDDA'), regex = /^\d{4}\.\d{2}\.\d{2}$/, today = moment().startOf('date');

    var vBEGDA = BEGDA.val().trim();

    if (isNotValid('시작일을 입력하세요.', BEGDA, !vBEGDA)) return;
    if (isNotValid('시작일을 ' + today.format(Format.DATE) + ' 형식으로 입력하세요.', BEGDA, !regex.test(vBEGDA))) return;

    var mBEGDA = moment(String.deformat(vBEGDA));

    if (isNotValid('시작일은 내일 일자부터 입력 가능합니다.', BEGDA, mBEGDA.isSameOrBefore(today))) return;

    var vENDDA = ENDDA.val().trim();

    if (isNotValid('종료일을 입력하세요.', ENDDA, !vENDDA)) return;
    if (isNotValid('종료일을 ' + today.format(Format.DATE) + ' 형식으로 입력하세요.', ENDDA, !regex.test(vENDDA))) return;

    var mENDDA = moment(String.deformat(vENDDA));

    if (isNotValid('시작일이 종료일 이후입니다.', ENDDA, mBEGDA.isAfter(mENDDA))) return;
    if (isNotValid('종료일은 입력된 시작일로부터 최대 한 달 후 일자까지 입력 가능합니다.', ENDDA, mENDDA.isAfter(mBEGDA.add(1, 'months')))) return;

    var WKTYP = $('select#WKTYP option:selected'),
    period = vBEGDA === vENDDA ? vBEGDA : (vBEGDA + ' ~ ' + vENDDA);
    if (!confirm(String.concat(WKTYP.text(), ' : ', period, '\n\n저장하시겠습니까?'))) return;

    var params = $.extend(true, $('form#attForm').jsonize(), {
        NAME: 'PLAN_SAVE',
        TABLES: JSON.stringify({
            T_TLIST: [{
                WKTYP: WKTYP.val(),
                BEGDA: String.deformat(vBEGDA),
                ENDDA: String.deformat(vENDDA)
            }]
        })
    });

    ajaxPost(
        '/work/getRealWorkTimeData.json',
        params,
        function(data) {
            $.LOGGER.debug('교육/출장 계획 저장 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                alert(data.message);
                return;
            }

            alert('저장되었습니다.');

            closeLayerPopup(true);
        },
        function(data) {
            $.LOGGER.debug('교육/출장 계획 저장 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

/**
 * Combo option HTML 생성 후 반환
 * 
 * @param o {
 *     WKTYP: vWKTYP,
 *     WKTXT: vWKTXT,
 *     ATTR1: vATTR1,
 *     ATTR2: vATTR2
 * }
 * @returns '<option value="vWKTYP" data-attr1="vATTR1" data-attr2="vATTR2">vWKTXT</option>'
 */
function getOptionHTML(o) {

    var p = $.extend({}, o),
    option = '<option value="#" %>#</option>'.replace(/#/, p.WKTYP).replace(/#/, p.WKTXT);

    delete p.WKDAT;
    delete p.WKTYP;
    delete p.WKTXT;

    return option.replace(/%/, $.map(p, function(v, k) {
        return 'data-#="#"'.replace(/#/, k.toLowerCase()).replace(/#/, v);
    }).join(' '));
}

/**
 * 구분 combo change event handler
 */
function changeWKTYP() {

    var t = $(this), o = t.find('option:selected'), tr = t.parents('tr'), isSaved = tr.find('.icon').hasClass('done');

    // 업무 시간 combo 활성화 toggle
    tr.find('select.time').prop('disabled', o.data('pstim') !== 'X');

    // 비근무 입력 popup icon(돋보기) 보임 toggle
    tr.find('a.data-pdunb').toggleClass('invisible', !isSaved || o.data('psabs') !== 'X');

    // 업무재개 입력 popup icon(돋보기) 보임 toggle
    tr.find('a.data-arewk').toggleClass('invisible', !isSaved || o.data('psrwk') !== 'X');

    // 업무 시작 시간 초기화
    tr.find('select.time[name="BEGUZ-hour"]').val(function() {
        return o.data('psbeg') === 'X' ? ($(this).data('sobeghh') || '00') : '00';
    });
    tr.find('select.time[name="BEGUZ-minute"]').val(function() {
        return o.data('psbeg') === 'X' ? ($(this).data('sobegmm') || '00') : '00';
    });

    // 업무 종료 시간 초기화
    tr.find('select.time[name="ENDUZ-hour"]').val(function() {
        return o.data('psend') === 'X' ? ($(this).data('soendhh') || '00') : '00';
    });
    tr.find('select.time[name="ENDUZ-minute"]').val(function() {
        return o.data('psend') === 'X' ? ($(this).data('soendmm') || '00') : '00';
    });
}

/**
 * 비근무시간 입력 or 업무재개시간 입력 or 교육/출장 계획 입력 popup layer open
 * 
 * @param o = {
 *     which:      POPUP_NAME.BREAK_TIME or POPUP_NAME.EXTRA_TIME or POPUP_NAME.PLAN_TIME
 *     list:       data
 *     date:       WKDAT
 *     isEditable: 저장 가능 여부
 *     
 *     wktyp:      메인 테이블에서 선택된 '구분'값 (POPUP_NAME.EXTRA_TIME인 경우에만)
 *     beguz:      기입력된 기본 근무 시작 시간    (POPUP_NAME.EXTRA_TIME인 경우에만)
 *     enduz:      기입력된 기본 근무 종료 시간    (POPUP_NAME.EXTRA_TIME인 경우에만)
 * }
 */
function popupLayer(o) {

    // 비근무시간 입력 popup
    if (o.which === POPUP_NAME.BREAK_TIME) {
        var layer = $('div#breaktimeList').toggleClass('readonly', !o.isEditable), tbody = layer.find('tbody').empty();

        if (o.list.length) {
            var template = $('tbody#breaktimeTemplate').html(), last = o.list.pop() || {};

            tbody.append($.map(o.list, function(rowData) {
                var ABSTD = Number(rowData.ABSTD || '10');
                return template
                    .replace(/data\-disabled=""/g, o.isEditable ? '' : 'disabled="disabled"')
                    .replace(/data\-value=""/,     'value="' + ABSTD + '분"')
                    .replace(/data\-value=""/,     'value="' + (rowData.DESCR || '') + '"');
            }));
            layer.find('td.minutes-sum').text(Number(last.ABSTD || '0') > 0 ? Number(last.ABSTD) + '분' : '');
        } else {
            tbody.append('<tr class="oddRow" data-not-found><td colspan="3">해당하는 데이타가 존재하지 않습니다.</td></tr>');
            layer.find('td.minutes-sum').text('');
        }

        layer.data('date', o.date)
             .find('strong').text('비근무 시간 ' + (o.isEditable ? '등록/수정' : '조회')).end()
             .draggable().popup('show');
    }
    // 업무재개시간 입력 popup
    else if (o.which === POPUP_NAME.EXTRA_TIME) {
        var layer = $('div#extratimeList').toggleClass('readonly', !o.isEditable), trs = layer.find('tbody tr');

        if (o.isEditable) {
            layer.data(o); // 저장시 업무 시작/종료 시간과 겹치는지 확인하기 위해 data 저장
        }

        trs.find('select').val('00').prop('disabled', !o.isEditable).end()
           .find('input' ).val(''  ).prop({disabled: !o.isEditable, checked: false});

        if (o.list.length) {
            $.each(o.list, function(i, rowData) {
                var ABEGUZ = rowData.ABEGUZ ? moment(String.deformat(rowData.ABEGUZ), 'HHmmss') : null,
                    AENDUZ = rowData.AENDUZ ? moment(String.deformat(rowData.AENDUZ), 'HHmmss') : null,
                    ABEGHH = ABEGUZ ? ABEGUZ.format('HH') : '00',
                    ABEGMM = ABEGUZ ? ABEGUZ.format('mm') : '00',
                    AENDHH = AENDUZ ? AENDUZ.format('HH') : '00',
                    AENDMM = AENDUZ ? AENDUZ.format('mm') : '00';
                trs.eq(i)
                   .find('select[name="ABEGUZ-hour"]'  ).val(ABEGHH).end()
                   .find('select[name="ABEGUZ-minute"]').val(ABEGMM).end()
                   .find('select[name="AENDUZ-hour"]'  ).val(AENDHH).end()
                   .find('select[name="AENDUZ-minute"]').val(AENDMM).end()
                   .find('input[type="text"][name="DESCR"]').val(rowData.DESCR || '');
            });
        }

        layer.find('strong').text('업무재개시간 ' + (o.isEditable ? '등록/수정' : '조회')).end()
             .draggable().popup('show');
    }
    // 교육/출장 계획 입력 popup
    else if (o.which === POPUP_NAME.PLAN_TIME) {
        var layer = $('div#plantimeTable'), tr = layer.find('tbody tr'), tomorrow = moment().startOf('date').add(1, 'days').format(Format.DATE);

        initDatePicker();
        layer.find('select#WKTYP').html($.map(WORKTIME_DATA.T_TYPES, function(o, i) {
                 return '<option value="@">@</option>'.replace(/@/, o.WKTYP).replace(/@/, o.WKTXT);
             })).end()
             .draggable().popup('show');
    }
}

/**
 * 비근무시간 입력 popup open 가능 여부 확인
 * 
 * 목록이 조회된 이후 업무 시작/종료 시간이 수정된 상태가 아닐 것
 * 업무 시작/종료 시간이 한 번 이상 ERP에 저장된 상태일 것
 * 구분 combo 선택 값의 속성이 시간입력 가능 속성일 것 : PSTIM === 'X'
 * 
 * @param tr
 * @returns 오류 message
 */
function checkBreaktimeListPopupAllowed(tr) {

    var message = [],
    WKTYP = tr.find('select[name="WKTYP"] option:selected').val(),
    BEGHH = tr.find('select[name="BEGUZ-hour"]'),
    BEGMM = tr.find('select[name="BEGUZ-minute"]'),
    ENDHH = tr.find('select[name="ENDUZ-hour"]'),
    ENDMM = tr.find('select[name="ENDUZ-minute"]'),

    isSaved = tr.find('.icon').hasClass('done'),
    isEditable = WORKTIME_DATA.T_WKTYP[tr.data('date')].data[WKTYP].PSTIM === 'X',
    isChanged = Number(BEGHH.data('beguzhh') || -1) !== Number(BEGHH.find('option:selected').val())
             || Number(BEGMM.data('beguzmm') || -1) !== Number(BEGMM.find('option:selected').val())
             || Number(ENDHH.data('enduzhh') || -1) !== Number(ENDHH.find('option:selected').val())
             || Number(ENDMM.data('enduzmm') || -1) !== Number(ENDMM.find('option:selected').val());

    message.push(!isChanged ? '' : '업무 시작/종료 시간이 변경되었습니다.\n');
    message.push(!isChanged && isSaved && isEditable ? '' : '업무 시작/종료 시간을 저장한 후 비근무를 입력할 수 있습니다.');

    return message.join('');
}

/**
 * 비근무시간 입력 popup layer open
 */
function popupBreaktimeList() {

<c:choose><c:when test="${param.MSSYN eq 'Y'}">
    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date');
</c:when><c:otherwise>
    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date'),
    message = checkBreaktimeListPopupAllowed(tr);

    if (message) {
        alert(message); // 업무 시작/종료 시간이 변경되었습니다.\n업무 시작/종료 시간을 저장한 후 비근무를 입력할 수 있습니다.
        return;
    }
</c:otherwise></c:choose>

    var params = $.extend($('form#attForm').jsonize(), {
        NAME: 'BREAK_LIST',
        I_WKDAT: String.deformat(WKDAT)
    });

    // 비근무 목록 조회 AJAX 호출
    ajaxPost(
        '/work/getRealWorkTimeData.json',
        params,
        function(data) {
            $.LOGGER.debug('비근무시간 목록 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                alert(data.message);
                return;
            }

            // 비근무 입력 popup layer 호출
            popupLayer({
                which: POPUP_NAME.BREAK_TIME,
                list: (data.TABLES || {}).T_ELIST || [],
                date: WKDAT,
                isEditable: anchor.data('pdunb-editable')
            });
        },
        function(data) {
            $.LOGGER.debug('비근무시간 목록 조회 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

/**
 * 업무재개 시간 입력 popup open 가능 여부 확인
 * 
 * 목록이 조회된 이후 업무 시작/종료 시간이 수정된 상태가 아닐 것
 * 업무 시작/종료 시간이 한 번 이상 ERP에 저장된 상태일 것
 * 
 * @param tr
 * @returns 오류 message
 */
function checkExtratimeListPopupAllowed(tr) {

    var message = [],
    BEGHH = tr.find('select[name="BEGUZ-hour"]'),
    BEGMM = tr.find('select[name="BEGUZ-minute"]'),
    ENDHH = tr.find('select[name="ENDUZ-hour"]'),
    ENDMM = tr.find('select[name="ENDUZ-minute"]'),

    isSaved = tr.find('.icon').hasClass('done'),
    isChanged = Number(BEGHH.data('beguzhh') || -1) !== Number(BEGHH.find('option:selected').val())
             || Number(BEGMM.data('beguzmm') || -1) !== Number(BEGMM.find('option:selected').val())
             || Number(ENDHH.data('enduzhh') || -1) !== Number(ENDHH.find('option:selected').val())
             || Number(ENDMM.data('enduzmm') || -1) !== Number(ENDMM.find('option:selected').val());

    message.push(!isChanged ? '' : '업무 시작/종료 시간이 변경되었습니다.\n');
    message.push(!isChanged && isSaved ? '' : '업무 시작/종료 시간을 저장한 후 업무재개를 입력할 수 있습니다.');

    return message.join('');
}

/**
 * 업무재개시간 입력 popup layer open
 */
function popupExtratimeList() {

<c:choose><c:when test="${param.MSSYN eq 'Y'}">
    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date');
</c:when><c:otherwise>
    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date'),
    message = checkExtratimeListPopupAllowed(tr);

    if (message) {
        alert(message); // 업무 시작/종료 시간이 변경되었습니다.\n업무 시작/종료 시간을 저장한 후 업무재개를 입력할 수 있습니다.
        return;
    }
</c:otherwise></c:choose>

    var params = $.extend($('form#attForm').jsonize(), {
        NAME: 'EXTRA_LIST',
        I_WKDAT: String.deformat(WKDAT),
        I_TOMRR: moment(WKDAT, Format.DATE).add(1, 'days').format('YYYYMMDD')
    });

    // 업무재개시간 목록 조회 AJAX 호출
    ajaxPost(
        '/work/getRealWorkTimeData.json',
        params,
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                alert(data.message);
                return;
            }

            var isEditable = anchor.data('arewk-editable');

            // 업무재개시간 입력 popup layer 호출
            popupLayer($.extend({
                which: POPUP_NAME.EXTRA_TIME,
                list: (data.TABLES || {}).T_ELIST || [],
                date: WKDAT,
                tomorrow: data.EXPORT.TOMORROW || {},
                isEditable: isEditable
            }, isEditable ? {
                wktyp: tr.find('select[name="WKTYP"] option:selected').val(),
                beguz: tr.find('select[name*="BEGUZ"] option:selected').text(),
                enduz: tr.find('select[name*="ENDUZ"] option:selected').text()
            } : null));
        },
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 조회 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

/**
 * 교육/출장 계획 입력 popup layer 호출
 */
function popupPlantimeTable(e) {

    popupLayer({
        which: POPUP_NAME.PLAN_TIME
    });
}

/**
 * 초과근무 실적입력 popup 호출
 */
function popupOvertimeResultSave(e) {

    var refMonth = moment(WORKTIME_DATA.refMonth.data('year-month'), 'YYYYMM'),
    params = {
        isPop: 'Y',<c:if test="${param.MSSYN eq 'Y'}">
        viewMode: 'Y',
        PERNR: $('input[type="hidden"][name="P_PERNR"]').val(),</c:if>
        FROM_ESS_OFW_WORK_TIME: 'Y',
        PARAM_YYYY: refMonth.year(),
        PARAM_MM: refMonth.format('MM'),
        PARAM_DATE: $(e.currentTarget).parents('tr').data('date')
    };

    LoadingImage.show();

    $('#modalDialog iframe')
        .width(1048)
        .attr('src', '/work/overTimeInput?' + $.param(params))
        .load(function() {

            var iframe = $(this), bh = $('body').height() - 32, ih = iframe.contents().find('body').css('overflow-x', 'hidden').get(0).scrollHeight - 32;
            iframe.height(ih > bh ? bh : (ih < 780 ? 780 : ih));

            $('#modalDialog')
                .width(1080)
                .find('strong').text('초과근무 실적확정').end()
                .draggable().popup('show');

            LoadingImage.hide();
        });
}

/**
 * 금일 업무시간과 익일 계획근무시간의 겹침 체크를 위해 익일 data를 조회한다.
 * 
 * @param WKDAT 금일 일자
 * @param TOMRR 익일 일자
 * @returns 익일 계획근무시간 정보
 */
function getTomorrowData(WKDAT, TOMRR) {

    var params = $.extend($('form#attForm').jsonize(), {
        NAME: 'EXTRA_LIST',
        I_WKDAT: WKDAT,
        I_TOMRR: TOMRR
    });

    var TOMRRData;
    ajaxPost(
        '/work/getRealWorkTimeData.json',
        params,
        function(data) {
            $.LOGGER.debug('익일 data 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                alert(data.message);
                return;
            }

            TOMRRData = data.EXPORT.TOMORROW || {};
        },
        function(data) {
            $.LOGGER.debug('익일 data 조회 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        },
        LoadingImage.OFF,
        false
    );

    return TOMRRData;
}

function getMultiLineMessage(message) {

    return $.trim(message).replace(/\\n/g, '\n');
}

/**
 * 근무시간 목록 data 저장
 */
function saveWorktimeList() {

    var T_WLIST = WORKTIME_DATA.T_WLIST, // 시간 겹침 체크를 위한 실근무시간 정보 가져다놓기
    messages = [], // 시간 validation 오류 메세지

    // 입력 또는 수정된 근무시간 정보 변수로 저장
    list = $('div.scroll-body select[name="WKTYP"]:not(:disabled)').map(function() {
        var s = $(this), tr = s.parents('tr'),
        KEY_WKDAT = tr.data('date'),
        WKDAT = String.deformat(KEY_WKDAT),
        WKTYP = s.find('option:selected').val(),
        BEGUZ = getMoment(WKDAT, tr.find('select[name*="BEGUZ"] option:selected').text()),
        ENDUZ = getMoment(WKDAT, tr.find('select[name*="ENDUZ"] option:selected').text());

        if (BEGUZ.isAfter(ENDUZ)) ENDUZ.add(1, 'days');

        // |<--- 전반 휴가 --->|<--- 후반 업무 --->|
        // 전반 휴가 시간대에 업무 시간이 입력되었으면 오류 처리
        if (WKTYP === '3120') {
            var HFBEG = getMoment(WKDAT, T_WLIST[KEY_WKDAT].HFBEG); // 반차인 경우의 계획 근무 시작 시간(=반차 종료 시간)
            if (BEGUZ.isBefore(HFBEG) || ENDUZ.isBefore(HFBEG)) { // 전반 휴가 시간 이후에만 입력 가능
                messages.push(moment(WKDAT, Format.DATE).format(Format.DATE + '(ddd)') + '\n    전반 휴가의 경우 휴가 시간 이후에만 업무 시간 입력이 가능합니다.');
                return null;
            }
        }

        // |<--- 전반 업무 --->|<--- 후반 휴가 --->|
        // 후반 휴가 시간대에 업무 시간이 입력되었으면 오류 처리
        else if (WKTYP === '3130') {
            var HFEND = getMoment(WKDAT, T_WLIST[KEY_WKDAT].HFEND); // 반차인 경우의 계획 근무 종료 시간(=반차 시작 시간)
            if (BEGUZ.isAfter(HFEND) || ENDUZ.isAfter(HFEND)) { // 후반 휴가 시간 이전에만 입력 가능
                messages.push(moment(WKDAT, Format.DATE).format(Format.DATE + '(ddd)') + '\n    후반 휴가의 경우 휴가 시간 이전에만 업무 시간 입력이 가능합니다.');
                return null;
            }
        }

        // |<--- 금일 업무 시간 --->|<--- 익일 계획 근무 시간 --->|
        // 금일과 익일의 업무 시간이 겹치는 경우 오류 처리
        var TOMRR = moment(WKDAT, Format.DATE).add(1, 'days').format(Format.DATE), TOMRRData = T_WLIST[TOMRR];
        if (!$.isPlainObject(TOMRRData)) {
            TOMRRData = getTomorrowData(WKDAT, TOMRR) || {}; // 이번달 data를 모두 받아 오지만 마지막 날짜의 경우 익일 data가 없으므로 AJAX로 받아온다.
        }

        // 익일 계획 근무 시간이 있는 경우에만 업무 시간 겹침 체크
        if (TOMRRData.SOBEG) {
            var SOBEG = getMoment(TOMRR, TOMRRData.SOBEG); // 익일 계획 시업 시간
            if (ENDUZ.isAfter(SOBEG)) {
                messages.push(moment(WKDAT, Format.DATE).format(Format.DATE + '(ddd)') + '\n    업무 시간이 다음날 업무 시간과 중복됩니다.');
                return null;
            }
        } else {
            $.LOGGER.debug('익일 계획근무시간 겹침 체크 제외', {ENDUZ: ENDUZ.format(Format.DATE + ' HH:mm:ss'), SOBEG: moment(TOMRR, Format.DATE).format(Format.DATE) + ' ' + TOMRRData.SOBEG});
        }

        return {
            WKDAT: WKDAT,
            WKTYP: WKTYP,
            BEGUZ: BEGUZ.format('HHmmss'),
            ENDUZ: ENDUZ.format('HHmmss')
        };
    }).get();

    if (messages.length) {
        alert(messages.join('\n'));
        return;
    }

    if (!confirm('저장하시겠습니까?')) return;

    var params = $.extend(true, $('form#attForm').jsonize(), {
        NAME: 'WORK_SAVE',
        I_YYMON: WORKTIME_DATA.refMonth.data('year-month'),
        TABLES: JSON.stringify({
            T_WLIST: list
        })
    });

    // 저장 AJAX 호출
    ajaxPost(
        '/work/getRealWorkTimeData.json',
        params,
        function(data) {
            $.LOGGER.debug('근무시간 저장 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                alert(getMultiLineMessage(data.message));
                return;
            }

            // 근무가능시간의 잔여시간이 부족한 경우 warning이 return 됨
            if (data.warning) {
                alert(getMultiLineMessage((data.EXPORT.E_RETURN || {}).MSGTX));
            }

            // 추가 message가 있는 경우 별도로 보여줌
            var msg2 = (data.EXPORT.E_RETURN2 || {}).MSGTX;
            if (msg2) {
                alert(getMultiLineMessage(msg2));
            }

            // warning message와 추가 message가 없으면 저장 message 보여줌
            if (!data.warning && !msg2) {
                alert('저장되었습니다.');
            }

            retrieveData();
        },
        function(data) {
            $.LOGGER.debug('근무시간 저장 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

/**
 * Header data 표시
 */
function setHeaderData() {

    var T_WHEAD = WORKTIME_DATA.T_WHEAD || [{}, {}, {}],
    T_WHEAD0 = T_WHEAD[0] || {},
    T_WHEAD1 = T_WHEAD[1] || {},
    T_WHEAD2 = T_WHEAD[2] || {};

    if (WORKTIME_DATA.E_TPGUB !== 'C') {
        // 정시/시차 근무제
        $('td[data-name="T_WHEAD[0]-CH01"]').text(String.humanize(T_WHEAD0.CH01));
        $('td[data-name="T_WHEAD[0]-CH02"]').text(String.humanize(T_WHEAD0.CH02));
        $('td[data-name="T_WHEAD[0]-CH03"]').text(String.humanize(T_WHEAD0.CH03));
        $('td[data-name="T_WHEAD[0]-CH04"]').text(String.humanize(T_WHEAD0.CH04));
    } else {
        // 선택 근무제
        /**
         * ---------------------------------------------------------------------------------------------------
         * | T_WHEAD0.CH01 | T_WHEAD1.CH01 | T_WHEAD1.CH03 | T_WHEAD0.CH02 |               |                 |
         * |---------------|---------------|---------------|---------------|               |                 |
         * | T_WHEAD0.CH04 |       -       | T_WHEAD1.CH04 |        -      | T_WHEAD0.CH03 | T_WHEAD0.WSTATS |
         * |---------------|---------------|---------------|---------------|               |                 |
         * | T_WHEAD0.CH05 | T_WHEAD1.CH02 | T_WHEAD1.CH05 |        -      |               |                 |
         * ---------------------------------------------------------------------------------------------------
         */
        var CH02 = $.trim(T_WHEAD0.CH02).replace(/(\d{1,3}:\d{1,2})/g, function($1) { return String.humanize($1); }).replace(/\(/, '<br />(').replace(/\(\-/, '(&Delta; '),
        CH03 = $.trim(T_WHEAD0.CH03).replace(/(\d{1,3}:\d{1,2})/g, function($1) { return String.humanize($1); }).replace(/\(/, '<br />(').replace(/\(\-/, '(&Delta; ');

        $('td[data-name="T_WHEAD[0]-CH01"]').html(String.humanize(T_WHEAD0.CH01));
        $('td[data-name="T_WHEAD[0]-CH02"]').html(CH02);
        $('td[data-name="T_WHEAD[0]-CH03"]').html(CH03);
        $('td[data-name="T_WHEAD[0]-CH04"]').html(String.humanize(T_WHEAD0.CH04));
        $('td[data-name="T_WHEAD[0]-CH05"]').html(String.humanize(T_WHEAD0.CH05));

        $('td[data-name="T_WHEAD[1]-CH01"]').html($.trim(T_WHEAD1.CH01).replace(/(.+)\(/, '$1<br />(') || '-');
        $('td[data-name="T_WHEAD[1]-CH02"]').html(String.humanize(T_WHEAD1.CH02));
        $('td[data-name="T_WHEAD[1]-CH03"]').html(String.humanize(T_WHEAD1.CH03));
        $('td[data-name="T_WHEAD[1]-CH04"]').html(String.humanize(T_WHEAD1.CH04));
        $('td[data-name="T_WHEAD[1]-CH05"]').html(String.humanize(T_WHEAD1.CH05));
    }
    $('td[data-name="T_WHEAD[0]-WSTATS"]').html($.trim(T_WHEAD0.WSTATX).replace(/\(/, '<br />(') || '-');

    $('span[data-name="T_WHEAD[2]-CH01"]').html(T_WHEAD2.CH01 || '휴일').parent()[T_WHEAD2.CH01 === '-' ? 'hide' : 'show']();
    $('span[data-name="T_WHEAD[2]-CH02"]').html(T_WHEAD2.CH02 || 0);
}

/**
 * 목록 그리기
 */
<c:choose><c:when test="${param.MSSYN eq 'Y'}">
function renderList(data) {

    if ($.isEmptyObject(data.T_WLIST)) {
        $('div.scroll-body > table tbody').html('<tr class="oddRow" data-not-found><td colspan="10">해당하는 데이타가 존재하지 않습니다.</td></tr>');
        return;
    }

    var refMonth = data.refMonth,     // 기준년월
    today = moment().startOf('date'), // 오늘 일자
    selectedMonth = moment(refMonth.data('year-month'), 'YYYYMM').month(),
    selected = refMonth.data('selected') ? moment(refMonth.data('selected'), Format.DATE) : today;

    // tbody rendering
    var template = {
        otLinkIcon: '<img src="/web-resource/images/ico/ico_edit.gif" />',
        otLink: '<a href="#" class="non-background data-otrst" title="@">@</a>',
        tr: $('tbody#worktimeMSSTemplate').html()
    };
    $('div.scroll-body > table tbody').html($.map(data.T_WLIST || {}, function(rowData, k) {
        var thisDate = moment(k, Format.DATE), thisMonth = thisDate.month();

        if (selectedMonth !== thisMonth) return null;

        var T_WKTYP = data.T_WKTYP[k],
        isSaved = rowData.SAVED === 'X',
        isExceeded = rowData.WRNTM === 'W',     // 기본근무시간 도달 또는 초과시 해당 시점 이후 배경색 처리
        isHoliday = rowData.HOLID === 'X',      // 법정 공휴일 여부
        isWeekend = thisDate.isoWeekday() >= 6, // 주말 여부
        BEGUZ = rowData.BEGUZ ? moment(String.deformat(rowData.BEGUZ), 'HHmmss') : null, // 업무 시작
        ENDUZ = rowData.ENDUZ ? moment(String.deformat(rowData.ENDUZ), 'HHmmss') : null; // 업무 종료

        return template.tr
            .replace(/data\-date=""/,      'data-date="' + k + '"')
            .replace(/data\-tr\-class=""/, isExceeded ? 'class="borderRow exceed"' : (isHoliday ? 'class="borderRow holiday"' : (isWeekend ? 'class="borderRow weekend"' : 'class="borderRow"')))
            .replace(/(icon\-class)/,      rowData.SKIP === 'X' ? 'non-this-month $1' : '$1')
            .replace(/icon\-class/,        isSaved ? 'done' : (thisDate.isSame(today) ? 'required' : ''))
            .replace(/\sclass=""/,         '')
            .replace(/#text#/,             String.concat(k, '(', rowData.WOTAG, ')', (isHoliday ? '<br />' + rowData.HDTXT : '')).toString())
            .replace(/#text#/,             rowData.WKTXT)
            .replace(/#text#/,             isSaved && BEGUZ ? BEGUZ.format('HH : mm') : '')
            .replace(/#text#/,             isSaved && ENDUZ ? ENDUZ.format('HH : mm') : '')

            .replace(/#text#/,             isSaved ? String.humanize(rowData.CPDUNB).replace(/-/, '') : '')

            .replace(/#text#/,             Number(rowData.ABSTD || '0') > 0 ? Number(rowData.ABSTD) + '분' : '')
            .replace(/\sdata\-class/,      Number(rowData.ABSTD || '0') > 0 ? '' : ' invisible')
            .replace(/data\-pdunb\-editable=""/,  'data-pdunb-editable="false"')

            .replace(/#text#/,             Number(rowData.AREWK || '0') > 0 && rowData.CAREWK ? String.humanize(rowData.CAREWK).replace(/-/, '') : '')
            .replace(/\sdata\-class/,      Number(rowData.AREWK || '0') > 0 ? '' : ' invisible')
            .replace(/data\-arewk\-editable=""/,  'data-arewk-editable="false"')

            .replace(/#text#/,             rowData.OVRTX || '')
            .replace(/#anchor#/,           rowData.RWINP === 'X' ? template.otLink.replace(/@/, '초과근무 실적입력').replace(/@/, template.otLinkIcon)
                                         : rowData.RWINP === 'T' ? template.otLink.replace(/@/g, '완료(사전)')
                                         : rowData.RWINP === 'C' ? template.otLink.replace(/@/g, '완료')
                                         : rowData.RWINP === 'A' ? '완료(사후)' : '')

            .replace(/#text#/,             isSaved && rowData.CSTDAZ ? String.humanize(rowData.CSTDAZ).replace(/-/, '') : '');
    }))
    .find('tr[data-date="#"]'.replace(/#/, selected.format(Format.DATE))).addClass('picked');
}
</c:when><c:otherwise>
function renderList(data) {

    if ($.isEmptyObject(data.T_WLIST)) {
        $('div.scroll-body > table tbody').html('<tr class="oddRow" data-not-found><td colspan="10">해당하는 데이타가 존재하지 않습니다.</td></tr>');
        return;
    }

    var refMonth = data.refMonth,     // 기준년월
    today = moment().startOf('date'), // 오늘 일자
    selectedMonth = moment(refMonth.data('year-month'), 'YYYYMM').month(),
    selected = refMonth.data('selected') ? moment(refMonth.data('selected'), Format.DATE) : today;

    // tbody rendering
    var template = {
        // 시 combo
        hour: $.map(new Array(24), function(v, i) {
            return '<option value="@">@</option>'.replace(/@/g, String.lpad(i, 2, '0'));
        }).join(''),
        // 분 combo
        minute: $.map(new Array(6), function(v, i) {
            return '<option value="@">@</option>'.replace(/@/g, String.lpad((i * 10), 2, '0'));
        }).join(''),
        otLinkIcon: '<img src="/web-resource/images/ico/ico_edit.gif" />',
        otLink: '<a href="#" class="non-background data-otrst" title="@">@</a>',
        tr: $('tbody#worktimeTemplate').html()
    };
    /***
     * rowData.PSTIM = X  : 구분 combo 활성화 O & 시간 combo 활성화 O
     *                 M  : 구분 combo 활성화 O & 시간 combo 활성화 X - 휴일, 휴무
     *                 Z  : 구분 combo 활성화 O & 시간 combo 활성화 O - 반차
     *                 '' : 구분 combo 활성화 X & 시간 combo 활성화 X
     */
    $('div.scroll-body > table tbody').html($.map(data.T_WLIST, function(rowData, k) {
        var thisDate = moment(k, Format.DATE), thisMonth = thisDate.month();

        if (selectedMonth !== thisMonth) return null;

        var PSTIM = rowData.PSTIM,
        WKTYP = rowData.WKTYP || '',
        T_WKTYP = data.T_WKTYP[k],
        isSaved = rowData.SAVED === 'X',        // 실근무시간 저장 여부
        isExceeded = rowData.WRNTM === 'W',     // 기본근무시간 도달 또는 초과시 해당 시점 이후 배경색 처리
        isHoliday = rowData.HOLID === 'X',      // 법정 공휴일 여부
        isWeekend = thisDate.isoWeekday() >= 6, // 주말 여부
        isFuture = thisDate.isAfter(today),     // 오늘 일자 이후 여부
        isWorkTimeEditable = PSTIM === 'X' || PSTIM === 'Z', // 실근무시간 입력 가능 여부

        // 비근무시간 popup 호출 icon 보임 여부
        isIconVisible1 = isFuture ? false : (Number(rowData.ABSTD || '0') > 0 || (isSaved && rowData.PSABS === 'X')),

        // 업무재개시간 popup 호출 icon 보임 여부
        isIconVisible2 = isFuture ? false : (Number(rowData.AREWK || '0') > 0 || (isSaved && rowData.PSRWK === 'X')),

        BEGUZ = rowData.BEGUZ ? moment(String.deformat(rowData.BEGUZ), 'HHmmss') : null, // 업무 시작
        ENDUZ = rowData.ENDUZ ? moment(String.deformat(rowData.ENDUZ), 'HHmmss') : null, // 업무 종료
        BEGHH = rowData.BEGUZ ? BEGUZ.format('HH') : null,
        BEGMM = rowData.BEGUZ ? BEGUZ.format('mm') : null,
        ENDHH = rowData.ENDUZ ? ENDUZ.format('HH') : null,
        ENDMM = rowData.ENDUZ ? ENDUZ.format('mm') : null,
        SOBEG = rowData.SOBEG ? moment(String.deformat(rowData.SOBEG), 'HHmmss') : null, // 업무 시작 초기화 시간(구분 combo 변경시 사용)
        SOEND = rowData.SOEND ? moment(String.deformat(rowData.SOEND), 'HHmmss') : null; // 업무 종료 초기화 시간(구분 combo 변경시 사용)

        return template.tr
            .replace(/data\-date=""/,      'data-date="' + k + '"')
            .replace(/data\-tr\-class=""/, isExceeded ? 'class="exceed"' : (isHoliday ? 'class="holiday"' : (isWeekend ? 'class="weekend"' : '')))
            .replace(/(icon\-class)/,      rowData.SKIP === 'X' ? 'non-this-month $1' : '$1')
            .replace(/icon\-class/,        isSaved ? 'done' : (thisDate.isSame(today) ? 'required' : ''))
            .replace(/\sclass=""/,         '')
            .replace(/#text#/,             String.concat(k, '(', rowData.WOTAG, ')', (isHoliday ? '<br />' + rowData.HDTXT : '')).toString())

            // 구분 combo
            .replace(/#type\-options#/,    PSTIM === 'Z' ? getOptionHTML(T_WKTYP.data[WKTYP]) : T_WKTYP.options.replace(new RegExp('(value="' + WKTYP + '")'), '$1 selected="selected"'))
            .replace(/data\-disabled=""/,  PSTIM ? '' : 'disabled="disabled"')

            // 시작/종료 시간
            .replace(/#hh-options#/,       BEGUZ ? template.hour.replace(  new RegExp('(value="' + BEGHH + '")'), '$1 selected="selected"') : template.hour)
            .replace(/#mm-options#/,       BEGUZ ? template.minute.replace(new RegExp('(value="' + BEGMM + '")'), '$1 selected="selected"') : template.minute)
            .replace(/#hh-options#/,       ENDUZ ? template.hour.replace(  new RegExp('(value="' + ENDHH + '")'), '$1 selected="selected"') : template.hour)
            .replace(/#mm-options#/,       ENDUZ ? template.minute.replace(new RegExp('(value="' + ENDMM + '")'), '$1 selected="selected"') : template.minute)
            .replace(/data\-beguzhh=""/,   BEGUZ ? 'data-beguzhh="' + BEGHH + '"' : '')
            .replace(/data\-beguzmm=""/,   BEGUZ ? 'data-beguzmm="' + BEGMM + '"' : '')
            .replace(/data\-enduzhh=""/,   ENDUZ ? 'data-enduzhh="' + ENDHH + '"' : '')
            .replace(/data\-enduzmm=""/,   ENDUZ ? 'data-enduzmm="' + ENDMM + '"' : '')
            .replace(/data\-sobeghh=""/,   SOBEG ? 'data-sobeghh="' + SOBEG.format('HH') + '"' : '')
            .replace(/data\-sobegmm=""/,   SOBEG ? 'data-sobegmm="' + SOBEG.format('mm') + '"' : '')
            .replace(/data\-soendhh=""/,   SOEND ? 'data-soendhh="' + SOEND.format('HH') + '"' : '')
            .replace(/data\-soendmm=""/,   SOEND ? 'data-soendmm="' + SOEND.format('mm') + '"' : '')
            .replace(/data\-disabled=""/g, isWorkTimeEditable ? '' : 'disabled="disabled"')

            .replace(/#text#/,             String.humanize(rowData.CPDUNB).replace(/-/, ''))

            .replace(/data\-value=""/,     isIconVisible1 && Number(rowData.ABSTD || '0') > 0 ? 'value="' + Number(rowData.ABSTD) + '분"' : '')
            .replace(/\sdata\-class/,      isIconVisible1 ? '' : ' invisible')
            .replace(/data\-pdunb\-editable=""/,  'data-pdunb-editable="' + (isSaved && rowData.PSABS === 'X') + '"') // 비근무 수정 가능 여부

            .replace(/data\-value=""/,     isIconVisible2 && rowData.CAREWK ? 'value="' + String.humanize(rowData.CAREWK).replace(/-/, '') + '"' : '')
            .replace(/\sdata\-class/,      isIconVisible2 ? '' : ' invisible')
            .replace(/data\-arewk\-editable=""/,  'data-arewk-editable="' + (isSaved && rowData.PSRWK === 'X') + '"') // 업무재개 수정 가능 여부

            .replace(/#text#/,             rowData.OVRTX || '')
            .replace(/#anchor#/,           rowData.RWINP === 'X' ? template.otLink.replace(/@/, '초과근무 실적입력').replace(/@/, template.otLinkIcon)
                                         : rowData.RWINP === 'T' ? template.otLink.replace(/@/g, '완료(사전)')
                                         : rowData.RWINP === 'C' ? template.otLink.replace(/@/g, '완료')
                                         : rowData.RWINP === 'A' ? '완료(사후)' : '')

            .replace(/#text#/,             rowData.CSTDAZ ? String.humanize(rowData.CSTDAZ).replace(/-/, '') : '')
    }))
    .find('tr[data-date="#"]'.replace(/#/, selected.format(Format.DATE))).addClass('picked');
}
</c:otherwise></c:choose>

/**
 * 달력 tr html 문자열 생성
 */
function getTr(rowData, template) {

    var CSTDAZ = String.humanize(rowData.CSTDAZ).replace(/-/, '');
    return template.replace(/%/g, rowData.WEEKS).replace(/#/, CSTDAZ ? ('<div>' + CSTDAZ + '</div>') : '');
}

/**
 * 달력 td html 문자열 생성
 */
function getDateContent(rowData) {

    var CSTDAZ = String.humanize(rowData.CSTDAZ).replace(/-/, '');
    return String.concat(
        rowData.HOLID === 'X' ? String.concat('<div class="holiday">', rowData.HDTXT, '</div>') : '<div class="dummy">&nbsp;</div>',
        CSTDAZ ? '<div>#<br />#</div>'.replace(/#/, CSTDAZ).replace(/#/, rowData.WKTXT) : (rowData.SAVED === 'X' ? '<div>#</div>'.replace(/#/, rowData.WKTXT) : '')
    ).toString();
}

/**
 * 달력 그리기
 */
function renderCalendar(data) {

    if ($.isEmptyObject(data.T_WLIST)) {
        $('table.worktime-calendar tbody').html('<tr class="oddRow" data-not-found><td colspan="8">해당하는 데이타가 존재하지 않습니다.</td></tr>');
        return;
    }

    var refMonth = data.refMonth,
    template = $('tbody#calendarTemplate').html(),
    T_WEEKS = data.T_WEEKS || [],
    trList = [];

    $.each(data.T_WLIST || {}, function(k, rowData) {
        var thisDate = moment(k, Format.DATE);
        if (thisDate.isoWeekday() === 1) { // 월요일
            trList.push(getTr(T_WEEKS[String.lpad(thisDate.isoWeek(), 2, 0)] || {}, template));
        }
        trList.push(trList.pop()
            .replace(/\sdata\-color/, rowData.SKIP === 'X' ? ' non-this-month' : '')
            .replace(/#/, k)
            .replace(/#/, thisDate.date())
            .replace(/#/, getDateContent(rowData))
        );
    });

    $('table.worktime-calendar tbody')
        .html(trList.join(''))
        .find('td[data-date="#"]'.replace(/#/, moment().format(Format.DATE))).addClass('today');
}

/**
 * 달력 월 이동시 오류가 발생하면 이동하기 전월로 되돌리기
 */
function failRetrieveData(data) {

    var t = $('div.year-month'), month = moment(t.data('old-month') || t.data('year-month'), 'YYYYMM');

    t.text(String.concat(month.format('YYYY'), '년 ', month.format('MM'), '월').toString())
     .data('year-month', month.format('YYYYMM'))
     .data('old-month', null);

    alert(data.message || 'connection error.');

    if (!t.data('old-month')) {
        $('ul.tab a[id$="Tab"].selected').click();
    }
}

/**
 * 실근무시간 목록 data 조회
 */
function retrieveData() {

    var t = $('div.year-month'),
    params = $.extend($('form#attForm').jsonize(), {
        I_YYMON: t.data('year-month')
    });

    ajaxPost(
        '/work/getRealWorkTimeData.json',
        params,
        function(data) {
            $.LOGGER.debug('근무시간 목록 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                failRetrieveData(data);
                return;
            }

            var EXPORT = data.EXPORT, TABLES = data.TABLES,

            // 달력 정보 및 근무시간 정보 저장
            E_TPGUB = WORKTIME_DATA.E_TPGUB = EXPORT.E_TPGUB,
            T_WHEAD = WORKTIME_DATA.T_WHEAD = TABLES.T_WHEAD || [{}, {}, {}], // 근무시간 통계
            T_TYPES = WORKTIME_DATA.T_TYPES = [], // 교육/출장 계획 입력 구분 combo
            T_WKTYP = WORKTIME_DATA.T_WKTYP = {}, // 일별 구분 combo
            T_WLIST = WORKTIME_DATA.T_WLIST = {}, // 근무시간 정보 목록
            T_WEEKS = WORKTIME_DATA.T_WEEKS = {}; // 주별 근무시간 합계

            // 일별 구분 combo
            $.each(TABLES.T_WKTYP || [], function(i, o) {
                var k = moment(String.deformat(o.WKDAT), 'YYYYMMDD').format(Format.DATE);
                if (T_WKTYP[k]) {
                    T_WKTYP[k].data[o.WKTYP] = o;
                    T_WKTYP[k].options = T_WKTYP[k].options + getOptionHTML(o);
                } else {
                    var d = {};
                    d[o.WKTYP] = o;

                    T_WKTYP[k] = {
                        data: d,
                        options: getOptionHTML(o)
                    };
                }
            });
            // 근무시간 정보 목록
            $.each(TABLES.T_WLIST || [], function(i, o) {
                T_WLIST[moment(String.deformat(o.WKDAT), 'YYYYMMDD').format(Format.DATE)] = o;
            });
            // 주별 근무시간 합계
            $.each(TABLES.T_WEEKS || [], function(i, o) {
                T_WEEKS[o.WEEKS] = o;
            });
            // 교육/출장 계획
            $.each(TABLES.T_TYPES || [], function(i, o) {
                T_TYPES.push(o);
            });

            $.LOGGER.info('근무시간 정보', WORKTIME_DATA);

            setHeaderData(); // 근무시간 사용현황 data 표시
            renderCalendar(WORKTIME_DATA);
            renderList(WORKTIME_DATA);

            $('ul.tab a[id$="Tab"].selected').click();
        },
        function(data) {
            $.LOGGER.debug('근무시간 목록 AJAX 호출 오류', data);

            failRetrieveData(data);
        }
    );
}

$(function() {
//      $.LOGGER.setup({
//          enable: {
//               debug: false
//              ,info: true
//              ,error: true
//          }
//      });

    WORKTIME_DATA.refMonth = $('div.year-month');

    $('ul.tab a[id$="Tab"]').click(function() {
        switchTabs(this, this.id);

        // 목록 tab click시 선택된 일자로 자동 scroll 한다.
        if (!$('.tabUnder.listTab').is(':visible')) {
            return;
        }

        var autoScrollTarget = $('div.scroll-body > table tbody')
            .find('tr.picked').removeClass('picked').end()
            .find('tr[data-date="@"]'.replace(/@/, $('div.year-month').data('selected') || moment().format(Format.DATE))).addClass('picked'); // 선택일자로 자동 scroll
        setTimeout(function() {
            $('div.scroll-body').scrollTop(autoScrollTarget.length ? (autoScrollTarget.index() - 3) * 40 + 1 : 0);
        }, 100);
    });

    $('a#prevMonth').click(function(e) {
        var t = $('div.year-month'), oldMonth = t.data('year-month'), month = moment(oldMonth, 'YYYYMM').subtract(1, 'months');

        t.text(String.concat(month.format('YYYY'), '년 ', month.format('MM'), '월').toString())
         .data('year-month', month.format('YYYYMM'))
         .data('old-month', oldMonth)
         .data('selected', moment().format(Format.DATE));

        retrieveData();
    });
    $('a#nextMonth').click(function(e) {
        var t = $('div.year-month'), oldMonth = t.data('year-month'), month = moment(oldMonth, 'YYYYMM').add(1, 'months');

        t.text(String.concat(month.format('YYYY'), '년 ', month.format('MM'), '월').toString())
         .data('year-month', month.format('YYYYMM'))
         .data('old-month', oldMonth)
         .data('selected', moment().format(Format.DATE));

        retrieveData();
    });

    $('a[data-name="plantimeTablePopup"]').click(popupPlantimeTable);
    $('a[data-name="worktimeSave"]').click(saveWorktimeList);

    $('a[data-name="breaktimeAdd"]').click(addBreaktime);
    $('a[data-name="breaktimeRemove"]').click(removeBreaktime);
    $('a[data-name="breaktimeSave"]').click(saveBreaktime);
    $('a[data-name="breaktimeClose"]').click(function() {
        if (!$('div#breaktimeList').hasClass('readonly') && !confirm('비근무시간 입력 팝업을 닫으시겠습니까?')) {
            return;
        }
        closeLayerPopup();
    });
    $('a[data-name="extratimeClear"]').click(clearExtratime);
    $('a[data-name="extratimeSave"]').click(saveExtratime);
    $('a[data-name="extratimeClose"]').click(function() {
        if (!$('div#extratimeList').hasClass('readonly') && !confirm('업무재개시간 입력 팝업을 닫으시겠습니까?')) {
            return;
        }
        closeLayerPopup();
    });
    $('a[data-name="plantimeSave"]').click(savePlantime);
    $('a[data-name="plantimeClose"]').click(function() {
        if (confirm('교육/출장 계획 입력 팝업을 닫으시겠습니까?')) {
            closeLayerPopup();
        }
    });
    $('a[data-name="modalDialog"]').click(function() {
        if (confirm($('div#modalDialog strong').text() + ' 팝업을 닫으시겠습니까?')) {
            closeLayerPopup();
//             $('div#modalDialog iframe').attr('src', 'about:blank');
        }
    });
    $(document)
        .on('click', 'div.scroll-body a.data-pdunb:not(.invisible)', popupBreaktimeList) // 비근무시간 입력 popup 호출
        .on('click', 'div.scroll-body a.data-arewk:not(.invisible)', popupExtratimeList) // 업무재개시간 입력 popup 호출
        .on('click', 'div.scroll-body a.data-otrst', popupOvertimeResultSave) // 초과근무 실적입력 popup 호출
        .on('click', 'button.icon-button.plus', function() { // 비근무시간 입력 popup '+' click event 처리
            $(this).siblings('input[name="ABSTD"]').val(function() {
                return $(this).val().replace(/\d+/, function(x) {
                    var v = Number(x) + 10;
                    return v < 120 ? v : 120;
                });
            });
            sumMinutes();
        })
        .on('click', 'button.icon-button.minus', function() { // 비근무시간 입력 popup '-' click event 처리
            $(this).siblings('input[name="ABSTD"]').val(function() {
                return $(this).val().replace(/\d+/, function(x) {
                    var v = Number(x) - 10;
                    return v > 10 ? v : 10;
                });
            });
            sumMinutes();
        })
        .on('click', 'td[data-date] > div', function() { // 달력 td click event 처리
            var calendarHeader = $('div.year-month'),
            selectedDate = $(this).parent().data('date'),
            selectedMonth = moment(selectedDate, 'YYYYMM'),
            calendarMonth = moment(calendarHeader.data('year-month'), 'YYYYMM'),
            tab = $('ul.tab a[id$="Tab"]').removeClass('selected').first().addClass('selected');

            calendarHeader.data('selected', selectedDate);
            if (selectedMonth.isSame(calendarMonth, 'month')) {
                tab.click();
            } else {
                $('a#@Month'.replace(/@/, selectedMonth.isBefore(calendarMonth) ? 'prev' : 'next')).click();
            }
        })
        .on('change', 'div.scroll-body select[name="WKTYP"]', changeWKTYP) // 구분 combo change event 처리 
        .on('mouseover', 'td.icon.done, td.icon.required', function() { // 근무시간 목록 일자 앞 icon event 처리
            var t = $(this);
            t.attr('title', t.hasClass('done') ? '저장됨' : t.hasClass('required') ? '저장안된 현재일' : '');
        });

    initPopup();
    initMenuLinkButton();

    retrieveData(); // 실근무시간 목록 data 조회
});
</script>