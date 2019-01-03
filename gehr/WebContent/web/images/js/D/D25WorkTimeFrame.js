/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeFrame.js
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/

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
},
TAB_URL = [
    'hris.D.D25WorkTime.D25WorkTimeListSV',
    'hris.D.D25WorkTime.D25WorkTimeCalendarSV'
];

function setHeaderData(iframe) {

    var T_WHEAD = WORKTIME_DATA.T_WHEAD || [],
    T_WHEAD0 = T_WHEAD[0] || {},
    T_WHEAD1 = T_WHEAD[1] || {},
    T_WHEAD2 = T_WHEAD[2] || {};

    if (WORKTIME_DATA.E_TPGUB !== 'C') {
        // 정시/시차 근무제
        $('td[data-name="T_WHEAD[0]-CH01"]').text(humanize(T_WHEAD0.CH01));
        $('td[data-name="T_WHEAD[0]-CH02"]').text(humanize(T_WHEAD0.CH02));
        $('td[data-name="T_WHEAD[0]-CH03"]').text(humanize(T_WHEAD0.CH03));
        $('td[data-name="T_WHEAD[0]-CH04"]').text(humanize(T_WHEAD0.CH04));
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
        var CH02 = $.trim(T_WHEAD0.CH02).replace(/(\d{1,3}:\d{1,2})/g, function($1) { return humanize($1); }).replace(/\(/, '<br />(').replace(/\(\-/, '(&Delta; '),
        CH03 = $.trim(T_WHEAD0.CH03).replace(/(\d{1,3}:\d{1,2})/g, function($1) { return humanize($1); }).replace(/\(/, '<br />(').replace(/\(\-/, '(&Delta; ');

        $('td[data-name="T_WHEAD[0]-CH01"]').html(humanize(T_WHEAD0.CH01));
        $('td[data-name="T_WHEAD[0]-CH02"]').html(CH02);
        $('td[data-name="T_WHEAD[0]-CH03"]').html(CH03);
        $('td[data-name="T_WHEAD[0]-CH04"]').html(humanize(T_WHEAD0.CH04));
        $('td[data-name="T_WHEAD[0]-CH05"]').html(humanize(T_WHEAD0.CH05));

        $('td[data-name="T_WHEAD[1]-CH01"]').html($.trim(T_WHEAD1.CH01).replace(/(.+)\(/, '$1<br />(') || '-');
        $('td[data-name="T_WHEAD[1]-CH02"]').html(humanize(T_WHEAD1.CH02));
        $('td[data-name="T_WHEAD[1]-CH03"]').html(humanize(T_WHEAD1.CH03));
        $('td[data-name="T_WHEAD[1]-CH04"]').html(humanize(T_WHEAD1.CH04));
        $('td[data-name="T_WHEAD[1]-CH05"]').html(humanize(T_WHEAD1.CH05));
    }
    $('td[data-name="T_WHEAD[0]-WSTATS"]').html($.trim(T_WHEAD0.WSTATX).replace(/\(/, '<br />(') || '-');

    if (iframe) {
        if (T_WHEAD2.CH01) {
            iframe.$('.commentImportant.notation').show()
                .find('span[data-name="T_WHEAD[2]-CH01"]').html(T_WHEAD2.CH01);
        } else {
            iframe.$('.commentImportant.notation').hide();
        }
    }
}

function initExtratimePopup() {

    $('div#extratimeList')
        .find('select[name*="hour"]').html($.map(new Array(24), function(v, i) {
            return '<option value="#">#</option>'.replace(/#/g, String.lpad(i, 2, '0'));
        }).join(''))
        .end()
        .find('select[name*="minute"]').html($.map(new Array(6), function(v, i) {
            return '<option value="#">#</option>'.replace(/#/g, String.lpad((i * 10), 2, '0'));
        }).join(''));
}

/**
 * 비근무시간 합계 계산
 */
function sumMinutes() {

    var t = $('div#breaktimeList input[name="ABSTD"]').map(function() {
        return $(this).val().deformat();
    }).get();

    $('td.minutes-sum').text(!t.length ? '' : eval(t.join(' + ')) + i18n.LABEL.COMMON['0039']);
}

/**
 * 비근무시간 data 저장
 */
function saveBreaktime() {

    var layer = $('div#breaktimeList'), trs = layer.find('tbody tr:not([data-not-found])'), WKDAT = layer.data('date'), timeSum = 0,
    list = trs.map(function() {
        var t = $(this), ABSTD = Number(t.find('input[name="ABSTD"]').val().deformat());
        timeSum += ABSTD;
        return {
            WKDAT: WKDAT,
            ABSTD: ABSTD,
            DESCR: t.find('input[name="DESCR"]').val()
        };
    }).get();

    if (timeSum > 120) {
        alert(i18n.MSG.D.D25.N0013); // 비근무시간은 총 120분을 초과할 수 없습니다.
        return false;
    }
    if (!confirm(i18n.MSG.COMMON.SAVE.CONFIRM)) return false; // 저장하시겠습니까?

    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        {
            NAME: 'BREAK_SAVE',
            I_WKDAT: WKDAT,
            TABLES: JSON.stringify({
                T_ELIST: list
            })
        },
        function(data) {
            $.LOGGER.debug('비근무시간 목록 저장 AJAX 호출', data);

            data = getRfcResult(data);

            if (data.isSuccess()) {
                alert(i18n.MSG.COMMON.SAVE.SUCCESS); // 저장되었습니다.
            } else {
                alert(data.MSG);
            }

            retrieveData();
        },
        function(data) {
            $.LOGGER.debug('비근무시간 목록 저장 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        },
        $.blockUI.SUPPRESS
    );

    return false;
}

/**
 * 비근무시간 입력 행 삭제
 */
function removeBreaktime() {

    var tbody = $('div#breaktimeList tbody'), checkboxes = tbody.find('input[type="checkbox"]:checked');
    if (!checkboxes.length) {
        alert(i18n.MSG.D.D25.N0007); // 삭제할 비근무시간 항목을 선택하세요.
        return false;
    }

    if (!confirm(i18n.MSG.D.D25.N0008)) return false; // 선택하신 비근무시간을 삭제하시겠습니까?\\n\\n삭제 후 되돌리시려면 닫기 후 다시 팝업을 열어주세요.

    checkboxes.parents('tr').remove();
    if (!tbody.find('tr').length) {
        tbody.append(['<tr class="oddRow" data-not-found><td class="lastCol" colspan="3">', i18n.MSG.COMMON['0004'], '</td></tr>'].join(''));
    }
    sumMinutes();

    return false;
}

/**
 * 비근무시간 입력 행 추가
 */
function addBreaktime() {

    var template = $('tbody#breaktimeTemplate').html(), tbody = $('div#breaktimeList tbody');
    tbody.find('tr[data-not-found]').remove();
    tbody.append(template.replace(/data\-value/, 'value="10' + i18n.LABEL.COMMON['0039'] + '"').replace(/data\-value/, ''));
    sumMinutes();

    return false;
}

/**
 * 업무재개 시간 초기화(삭제용)
 * 
 * @returns
 */
function initExtratime() {

    var tbody = $('div#extratimeList tbody'), checkboxes = tbody.find('input[type="checkbox"]:checked');
    if (!checkboxes.length) {
        alert(i18n.MSG.D.D25.N0037); // 초기화할 업무재개시간 항목을 선택하세요.
        return false;
    }

    if (!confirm(i18n.MSG.D.D25.N0038)) return false; // 선택하신 업무재개시간을 초기화하시겠습니까?\\n\\n초기화 후 되돌리시려면 닫기 후 다시 팝업을 열어주세요.

    checkboxes
        .parents('tr')
        .find('select').val('00').end()
        .find('input' ).val('').end()
        .end().prop('checked', false);

    return false;
}

/**
 * 두 시간대가 겹치는지 확인
 * 
 * @param beg1 시간대1 시작 시간
 * @param end1 시간대1 종료 시간
 * @param beg2 시간대2 시작 시간
 * @param end2 시간대2 종료 시간
 * @returns
 */
function isTimeSlotsOverlapped(beg1, end1, beg2, end2) {

    return beg1.isSame(beg2) || end1.isSame(end2) || (beg1.isBefore(beg2) && beg2.isBefore(end1)) || (beg1.isAfter(beg2) && beg1.isBefore(end2));
}

/**
 * 입력된 업무재개 시간이 저장 가능한 시간대인지 확인
 * 
 * 근무유형       : 업무/휴가/휴무/휴일/교육/출장 등 화면에서 combo로 선택하는 구분
 * 기본 업무 시간 : 업무 시간이 입력 가능한 근무유형인 경우 사용자가 입력한 업무 시간
 *                  업무 시간이 입력 불가능한 근무유형인 경우 시스템 내부에서 가지고 있는 계획근무 시간
 * 
 * 확인 로직
 * 1. 업무재개 시간은 근무유형이 가지는 기본 업무 시간 이후로만 저장 가능함. 기본 업무 시간과 연속으로는 저장 불가능.
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

    var WKDAT = layer.data('date'), WKTYP = layer.data('wktyp');

    ABEGUZ = getMoment(WKDAT, ABEGUZ); // 업무재개 시작 시간
    AENDUZ = getMoment(WKDAT, AENDUZ); // 업무재개 종료 시간

    // 기본 업무 시간 입력 가능한 근무유형인 경우
    if (WORKTIME_DATA.T_WKTYP[WKDAT].data[WKTYP].PSTIM === 'X') {
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
            return i18n.MSG.D.D25.N0041; // 업무재개 시작 시간이 업무재개 종료 시간 이후입니다.
        }

        // |<--- 전반 휴가 --->|<--- 후반 기본 업무 --->|<--- 업무재개 --->|<--- 익일 계획 근무 --->
        // 휴가(전반)
        if (WKTYP === '3120') {
            if (ABEGUZ.isBefore(ENDUZ) || AENDUZ.isBefore(ENDUZ)) {
                return i18n.MSG.D.D25.N0032; // 기본 업무 시간 이후에만 업무재개 시간 입력이 가능합니다.
            }
        }
        // |<--- 전반 기본 업무 --->|<--- 후반 휴가 --->|<--- 업무재개 --->|<--- 익일 계획 근무 --->
        // 휴가(후반) : 반차의 경우 계획 근무 시간은 업무 시간과 반차 시간이 합쳐진 시간
        else if (WKTYP === '3130') {
            var data = WORKTIME_DATA.T_WLIST[WKDAT],
            SOBEG = getMoment(WKDAT, data.SOBEG), // 계획 근무 시작 시간
            SOEND = getMoment(WKDAT, data.SOEND); // 계획 근무 종료 시간(실제 데이터는 반차 종료 시간)

            if (SOBEG.isAfter(SOEND)) SOEND.add(1, 'days');

            if (ABEGUZ.isBefore(SOEND) || AENDUZ.isBefore(SOEND)) {
                return i18n.MSG.D.D25.N0033; // 휴가 시간 이후에만 업무재개 시간 입력이 가능합니다.
            }
        }
        // |<--- 기본 업무 --->|<--- 업무재개 --->|<--- 익일 계획 근무 --->
        // 업무
        else {
            if (ABEGUZ.isBefore(ENDUZ) || AENDUZ.isBefore(ENDUZ)) {
                return i18n.MSG.D.D25.N0032; // 기본 업무 시간 이후에만 업무재개 시간 입력이 가능합니다.
            }
        }
    }
    // 기본 업무 시간 입력 불가능한 근무유형인 경우
    else {
        var data = WORKTIME_DATA.T_WLIST[WKDAT];

        // 출장 또는 교육인 경우
        if (WKTYP === '2010' || WKTYP === '2020') {
            var SOBEG = getMoment(WKDAT, data.SOBEG), // 계획 근무 시작 시간
                SOEND = getMoment(WKDAT, data.SOEND); // 계획 근무 종료 시간

            if (SOBEG.isAfter(SOEND)) SOEND.add(1, 'days');

            var BEGUZ = getMoment(WKDAT, layer.data('beguz')); // 기본 업무 시작 시간

            // 기본 업무 시작 시간이 업무재개 시간보다 이후라면 24시가 넘어간 것으로 간주하여 업무재개 시간에 하루를 더함
            if (BEGUZ.isSameOrAfter(ABEGUZ)) ABEGUZ.add(1, 'days');
            if (BEGUZ.isSameOrAfter(AENDUZ) || ABEGUZ.isSameOrAfter(AENDUZ)) AENDUZ.add(1, 'days');

            if (ABEGUZ.isBefore(SOEND) || AENDUZ.isBefore(SOEND)) {
                return i18n.MSG.D.D25.N0034; // 계획 근무 시간 이후에만 업무재개 시간 입력이 가능합니다.
            }
        }
    }

    var t6w = layer.data('tomorrow') || {};

    // 익일의 구분값이 휴무(3020)가 아니고 익일 계획 근무 시간이 있는 경우
    if (t6w.WKTYP !== '3020' && t6w.SOBEG) {
        var TSOBEG = getMoment(WKDAT, t6w.SOBEG).add(1, 'days'); // 익일 계획 근무 시작 시간

        if (ABEGUZ.isAfter(TSOBEG) || AENDUZ.isAfter(TSOBEG)) {
            return i18n.MSG.D.D25.N0035; // 업무재개 종료시각이 익일 업무시간과 중복됩니다.
        }
    }

    return '';
}

/**
 * 업무재개시간 data 저장
 */
function saveExtratime() {

    var layer = $('div#extratimeList'), WKDAT = layer.data('date'), messages = [],
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
            messages.push([i + 1, i18n.LABEL.D.D25.N7011, ' : ', i18n.MSG.D.D25.N0025].join('')); // i행 : 업무 시작 시간과 업무 종료 시간이 같습니다.
            return null;
        }
        var msg = validateTimeSlot(ABEGUZ, AENDUZ, layer); // 시간대 입력 가능 여부 확인 : 오류가 있는 경우 메세지가 반환됨
        if (msg) {
            messages.push([i + 1, i18n.LABEL.D.D25.N7011, ' : ', msg].join(''));
            return null;
        }
        if (DESCR.length < 2) {
            messages.push([i + 1, i18n.LABEL.D.D25.N7011, ' : ', i18n.MSG.D.D25.N0029].join('')); // i행 : 2글자 이상 입력하세요.
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
        return false;
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
            alert(i18n.MSG.D.D25.N0030); // 1행의 업무재개 시간대와 2행의 업무재개 시간대가 겹칩니다.
            return false;
        }
    }

    // 업무재개 시간 정보 저장시 RFC에서는 기존 정보를 삭제 후 입력된 정보만 새로 저장함
    // 따라서 삭제를 위해 초기화한 행의 정보는 RFC로 넘기지 않음
    if (isRemove[1]) list.pop();   // 배열의 마지막 원소 제거
    if (isRemove[0]) list.shift(); // 배열의 첫번째 원소 제거

    if (!confirm(i18n.MSG.COMMON.SAVE.CONFIRM)) return false; // 저장하시겠습니까?

    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        {
            NAME: 'EXTRA_SAVE',
            I_WKDAT: WKDAT,
            TABLES: JSON.stringify({
                T_ELIST: list
            })
        },
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 저장 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            // 근무가능시간의 잔여시간이 부족한 경우 warning이 return 됨
            if (data.isWarning()) {
                alert(data.MSG);
            } else {
                alert(i18n.MSG.COMMON.SAVE.SUCCESS); // 저장되었습니다.
            }

            retrieveData();
        },
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 저장 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        },
        $.blockUI.SUPPRESS
    );

    return false;
}

/**
 * isTrue가 true이면 msg를 띄우고 target에 focus를 둔다.
 * 
 * @param msg
 * @param target
 * @param isTrue
 * @returns
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

    var vBEGDA = BEGDA.val().trim(), tBEGDA = i18n.LABEL.D.D25.N2202;

    // 시작일을 입력하세요.
    if (isNotValid(i18n.getMessage('MSG.D.D25.N0049', tBEGDA), BEGDA, !vBEGDA)) return false;

    // 시작일을 2018.07.01 형식으로 입력하세요.
    if (isNotValid(i18n.getMessage('MSG.D.D25.N0050', tBEGDA, today.format('YYYY.MM.DD')), BEGDA, !regex.test(vBEGDA))) return false;

    var mBEGDA = moment(vBEGDA.deformat());

    // 시작일은 내일 일자부터 입력 가능합니다.
    if (isNotValid(i18n.MSG.D.D25.N0051, BEGDA, mBEGDA.isSameOrBefore(today))) return false;

    var vENDDA = ENDDA.val().trim(), tENDDA = i18n.LABEL.D.D25.N2203;

    // 종료일을 입력하세요.
    if (isNotValid(i18n.getMessage('MSG.D.D25.N0049', tENDDA), ENDDA, !vENDDA)) return false;

    // 종료일을 2018.07.01 형식으로 입력하세요.
    if (isNotValid(i18n.getMessage('MSG.D.D25.N0050', tENDDA, today.format('YYYY.MM.DD')), ENDDA, !regex.test(vENDDA))) return false;

    var mENDDA = moment(vENDDA.deformat());

    // 시작일이 종료일 이후입니다.
    if (isNotValid(i18n.MSG.D.D25.N0053, ENDDA, mBEGDA.isAfter(mENDDA))) return false;
    
    // 종료일은 입력된 시작일로부터 최대 한 달 후 일자까지 입력 가능합니다.
    if (isNotValid(i18n.MSG.D.D25.N0052, ENDDA, mENDDA.isAfter(mBEGDA.add(1, 'months')))) return false;

    var WKTYP = $('select#WKTYP option:selected');
    if (!confirm([WKTYP.text(), ':', vBEGDA, '~', vENDDA].join(' ') + '\n\n' + i18n.MSG.COMMON.SAVE.CONFIRM)) return false; // 저장하시겠습니까?

    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        {
            NAME: 'PLAN_SAVE',
            TABLES: JSON.stringify({
                T_TLIST: [{
                    PERNR: WKTYP.data('pernr'),
                    WKTYP: WKTYP.val(),
                    BEGDA: vBEGDA.deformat(),
                    ENDDA: vENDDA.deformat(),
                }]
            })
        },
        function(data) {
            $.LOGGER.debug('교육/출장 계획 저장 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            alert(i18n.MSG.COMMON.SAVE.SUCCESS); // 저장되었습니다.

            retrieveData();
        },
        function(data) {
            $.LOGGER.debug('교육/출장 계획 저장 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        },
        $.blockUI.SUPPRESS
    );

    return false;
}

function setDraggable() {

    $('div.blockUI.blockMsg').draggable();
}

/**
 * 비근무시간 입력 or 업무재개시간 입력 popup layer open
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
        var tbody = $('div#breaktimeList').toggleClass('readonly', !o.isEditable).find('tbody').empty();

        if (o.list.length) {
            var template = $('tbody#breaktimeTemplate').html(), last = o.list.pop() || {};

            tbody.append($.map(o.list, function(rowData) {
                var ABSTD = Number(rowData.ABSTD || '10');
                return template
                    .replace(/data\-disabled/g, o.isEditable ? '' : 'disabled="disabled"')
                    .replace(/data\-readonly/g, o.isEditable ? '' : 'readonly="readonly"')
                    .replace(/data\-value/,     'value="' + ABSTD + i18n.LABEL.COMMON['0039'] + '"')
                    .replace(/data\-value/,     'value="' + (rowData.DESCR || '') + '"');
            }));
            $('div#breaktimeList td.minutes-sum').text(Number(last.ABSTD || '0') > 0 ? Number(last.ABSTD) + i18n.LABEL.COMMON['0039'] : '');
        } else {
            tbody.append(['<tr class="oddRow" data-not-found><td class="lastCol" colspan="3">', i18n.MSG.COMMON['0004'], '</td></tr>'].join(''));
            $('div#breaktimeList td.minutes-sum').text('');
        }

        $('div#breaktimeList .subtitle').text(o.isEditable ? i18n.LABEL.D.D25.N1004 : i18n.LABEL.D.D25.N1005);

        // AJAX always callback의 $.unblockUI() 후 실행
        setTimeout(function() {
            var left = ($(document).width() / 2 - 233) + 'px';
            $.blockUI({
                message: $('div#breaktimeList').data('date', o.date).show(),
                css: {
                    top: '30%',
                    left: left,
                    width: '466px',
                    cursor: 'default'
                },
                onUnblock: function(e, o) {
                    $('div#breaktimeList').removeData().hide();
                }
            });
            setDraggable();
        }, 500);
    }
    // 업무재개시간 입력 popup
    else if (o.which === POPUP_NAME.EXTRA_TIME) {
        var layer = $('div#extratimeList'), trs = layer.toggleClass('readonly', !o.isEditable).find('tbody tr');

        if (o.isEditable) {
            // 저장시 업무 시작/종료 시간과 겹치는지 확인하기 위해 data 저장
            layer.data(o);
        }

        trs.find('select').val('00').prop('disabled', !o.isEditable).end()
           .find('input' ).val(''  ).prop({disabled: !o.isEditable, checked: false});

        if (o.list.length) {
            $.each(o.list, function(i, rowData) {
                var ABEGUZ = rowData.ABEGUZ ? moment(rowData.ABEGUZ.deformat(), 'HHmmss') : null,
                    AENDUZ = rowData.AENDUZ ? moment(rowData.AENDUZ.deformat(), 'HHmmss') : null,
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

        layer.find('.subtitle').text(o.isEditable ? i18n.LABEL.D.D25.N1007 : i18n.LABEL.D.D25.N1008);

        // AJAX always callback의 $.unblockUI() 후 실행
        setTimeout(function() {
            var left = ($(document).width() / 2 - 303) + 'px';
            $.blockUI({
                message: $('div#extratimeList').show(),
                css: {
                    top: '30%',
                    left: left,
                    width: '606px',
                    cursor: 'default'
                },
                onUnblock: function(e, o) {
                    $('div#extratimeList').removeData().hide();
                }
            });
            setDraggable();
        }, 500);
    }
    // 교육/출장 계획 입력 popup
    else if (o.which === POPUP_NAME.PLAN_TIME) {
        var layer = $('div#plantimeTable'), tr = layer.find('tbody tr'), tomorrow = moment().startOf('date').add(1, 'days').format('YYYY.MM.DD');

        layer.find('select#WKTYP').html($.map(WORKTIME_DATA.T_TYPES, function(o, i) {
                 return '<option value="@" data-pernr="%">@</option>'.replace(/@/, o.WKTYP).replace(/@/, o.WKTXT).replace(/%/, o.PERNR);
             })).end()
             .find('input#BEGDA').val(tomorrow).change().end()
             .find('input#ENDDA').val(tomorrow);

        var left = ($(document).width() / 2 - 233) + 'px';
        $.blockUI({
            message: $('div#plantimeTable').show(),
            css: {
                top: '30%',
                left: left,
                width: '466px',
                cursor: 'default'
            },
            onUnblock: function(e, o) {
                $('div#plantimeTable').hide();
            }
        });
        setDraggable();
    }
}

function getData() {
    return WORKTIME_DATA;
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
 * Datepicker 설정 function overriding
 * 
 * @returns
 */
function addDatePicker() {

    new Promise(function() {
        var options = {
            dateFormat : 'yy.mm.dd',
            minDate: moment().startOf('date').add(1, 'days').toDate()
        };

        $('input#BEGDA')
            .change(function () {
                var BEGDA = $(this).val().trim(), MINDA = moment(BEGDA, 'YYYY.MM.DD');
                if (!BEGDA || !/^\d{4}.\d{2}.\d{2}$/.test(BEGDA)) {
                    return;
                }

                // 시작일이 변경되면 종료일의 선택 가능한 최소 일자를 시작일로, 최대 일자를 시작일 + 한 달로 제한
                $('input#ENDDA').val('')
                    .datepicker('option', {
                        minDate: MINDA.toDate(),
                        maxDate: moment(BEGDA, 'YYYY.MM.DD').add(1, 'months').toDate()
                    });
            })
            .datepicker(options);

        $('input#ENDDA').datepicker(options);
    });
}

/**
 * 실근무시간 목록 data 조회
 * 
 * @returns
 */
function retrieveData() {

    var t = $('div.year-month');
    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        {
            I_YYMON: t.data('year-month'),
            P_PERNR: $('input[type="hidden"][name="P_PERNR"]').val(),
            P_RETIR: $('input[type="hidden"][name="P_RETIR"]').val()
        },
        function(data) {
            $.LOGGER.debug('근무시간 목록 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            var EXPORT = data.EXPORT, TABLES = data.TABLES,

            // 달력 정보 및 근무시간 정보 저장
            E_TPGUB = WORKTIME_DATA.E_TPGUB = EXPORT.E_TPGUB,
            T_WHEAD = WORKTIME_DATA.T_WHEAD = (TABLES.T_WHEAD || [{}, {}]), // 근무시간 통계
            T_TYPES = WORKTIME_DATA.T_TYPES = [], // 교육/출장 계획 입력 구분 combo
            T_WKTYP = WORKTIME_DATA.T_WKTYP = {}, // 일별 구분 combo
            T_WLIST = WORKTIME_DATA.T_WLIST = {}, // 근무시간 정보 목록
            T_WEEKS = WORKTIME_DATA.T_WEEKS = {}; // 주별 근무시간 합계

            // 일별 구분 combo
            $.each(TABLES.T_WKTYP || [], function(i, o) {
                var k = o.WKDAT.deformat();
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
                T_WLIST[o.WKDAT.deformat()] = o;
            });
            // 주별 근무시간 합계
            $.each(TABLES.T_WEEKS || [], function(i, o) {
                T_WEEKS[o.WEEKS] = o;
            });
            // 교육/출장 계획
            $.each(TABLES.T_TYPES || [], function(i, o) {
                T_TYPES.push($.extend(o, {PERNR: EXPORT.PERNR}));
            });

            $.LOGGER.info('근무시간 정보', WORKTIME_DATA);

            $('.tab').find('a.selected').click();
        },
        function(data) {
            $.LOGGER.debug('근무시간 목록 AJAX 호출 오류', data);

            var t = $('div.year-month'), month = moment(t.data('old-month') || t.data('year-month'), 'YYYYMM');

            t.text([month.format('YYYY'), i18n.LABEL.D.D25.N2141, ' ', month.format('MM'), i18n.LABEL.D.D25.N2143].join(''))
             .data('year-month', month.format('YYYYMM'))
             .data('old-month', null);

            alert(data.message || 'connection error.');

            if (!t.data('old-month')) {
                $('.tab').find('a.selected').click();
            }

            setTimeout($.unblockUI, 500);
        },
        $.blockUI.SUPPRESS
    );
}

$(function() {
//    $.LOGGER.setup({
//        enable: {
//             debug: false
//            ,info: true
//            ,error: true
//        }
//    });

    WORKTIME_DATA.refMonth = $('div.year-month');

    $('.tab a[data-name="calendar"]').addClass('selected');

    // iframe load 완료시 실근무시간 목록 data 조회
    retrieveData();

    initExtratimePopup();
    initMenuLinkButton(); // D25WorkTimeFrame-var.jsp

    /**
     * $(document).on(eventName, selector, handler)
     *     document 내에 event 발생시 selector에 해당하는 element를 찾아 handler를 실행
     *     event 발생시 마다 selector에 해당하는 element를 찾기 때문에 동적으로 생성되는 element에 자동으로 event handler를 부여하는 효과가 있어 편리하다.
     *     단, 화면이 복잡하고 $(document).on 으로 처리되는 event가 많을시 화면 동작이 느려지므로 주의해서 사용해야한다.
     * 
     * $(selector).eventName(handler)
     *     selector에 해당하는 element에 event handler를 부여, element에 event 발생시 handler 실행
     *     이 구문이 선언되는 시점에 selector에 해당하는 element가 생성되어 있어야한다.
     *     element가 생성되어 있지 않으면 이 구문이 무시되므로 오류 발생은 없지만
     *     이후에 동적으로 생성된 element의 경우 event를 발생시켜도 동작하지 않으므로 오류라고 착각할 수 있기 때문에 주의한다. 
     */        
    $('button#prevMonth').click(function(e) {
        var t = $('div.year-month'), oldMonth = t.data('year-month'), month = moment(oldMonth, 'YYYYMM').subtract(1, 'months'), s = String.deformat(t.data('selected'));
        
        t.text([month.format('YYYY'), i18n.LABEL.D.D25.N2141, ' ', month.format('MM'), i18n.LABEL.D.D25.N2143].join(''))
         .data('year-month', month.format('YYYYMM'))
         .data('old-month', oldMonth);

        if (s && !month.isSame(moment(s, 'YYYYMM'), 'month')) t.removeData('selected');

        retrieveData();
    });
    $('button#nextMonth').click(function(e) {
        var t = $('div.year-month'), oldMonth = t.data('year-month'), month = moment(oldMonth, 'YYYYMM').add(1, 'months'), s = String.deformat(t.data('selected'));
        
        t.text([month.format('YYYY'), i18n.LABEL.D.D25.N2141, ' ', month.format('MM'), i18n.LABEL.D.D25.N2143].join(''))
         .data('year-month', month.format('YYYYMM'))
         .data('old-month', oldMonth);

        if (s && !month.isSame(moment(s, 'YYYYMM'), 'month')) t.removeData('selected');

        retrieveData();
    });

    $('button#guideDownload').click(openGuide); // 제도 운영 기준 가이드, D-common.js

    $('button#faqDownload').click(openFAQ); // FAQ, D-common.js

    $('a[data-name="breaktimeAdd"]').click(addBreaktime);
    $('a[data-name="breaktimeRemove"]').click(removeBreaktime);
    $('a[data-name="breaktimeSave"]').click(saveBreaktime);
    $('a[data-name="breaktimeClose"]').click(function() {
        if (!$('div#breaktimeList').hasClass('readonly') && !confirm(i18n.MSG.D.D25.N0006)) return false; // 비근무시간 입력 팝업을 닫으시겠습니까?

        $.unblockUI();
        return false;
    });
    $('a[data-name="extratimeInit"]').click(initExtratime);
    $('a[data-name="extratimeSave"]').click(saveExtratime);
    $('a[data-name="extratimeClose"]').click(function() {
        if (!$('div#extratimeList').hasClass('readonly') && !confirm(i18n.MSG.D.D25.N0024)) return false; // 업무재개시간 입력 팝업을 닫으시겠습니까?

        $.unblockUI();
        return false;
    });
    $('a[data-name="plantimeSave"]').click(savePlantime);
    $('a[data-name="plantimeClose"]').click(function() {
        if (!confirm(i18n.MSG.D.D25.N0048)) return false; // 교육/출장 계획 입력 팝업을 닫으시겠습니까?

        $.unblockUI();
        return false;
    });
    $(document).on('click', 'button.icon-button.plus', function() {
        $(this).siblings('input[name="ABSTD"]').val(function() {
            return $(this).val().replace(/\d+/, function(x) {
                var v = Number(x) + 10;
                return v < 120 ? v : 120;
            });
        });
        sumMinutes();
    });
    $(document).on('click', 'button.icon-button.minus', function() {
        $(this).siblings('input[name="ABSTD"]').val(function() {
            return $(this).val().replace(/\d+/, function(x) {
                var v = Number(x) - 10;
                return v > 10 ? v : 10;
            });
        });
        sumMinutes();
    });
});