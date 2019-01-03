/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeList.js
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/

/**
 * 구분 combo change event handler
 */
function changeWKTYP() {

    var t = $(this), o = t.find('option:selected'), tr = t.parents('tr'), isSaved = tr.find('div.icon').hasClass('done');

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
 * 비근무시간 입력 popup open 가능 여부 확인
 * 
 * 목록이 조회된 이후 업무 시작/종료 시간이 수정된 상태가 아닐 것
 * 업무 시작/종료 시간이 한 번 이상 ERP에 저장된 상태일 것
 * 구분 combo 선택 값의 속성이 시간입력 가능 속성일 것 : PSTIM === 'X'
 * 
 * @param tr
 * @returns
 */
function checkBreaktimeListPopupAllowed(tr) {

    var message = [],
    WKTYP = tr.find('select[name="WKTYP"] option:selected').val(),
    BEGHH = tr.find('select[name="BEGUZ-hour"]'),
    BEGMM = tr.find('select[name="BEGUZ-minute"]'),
    ENDHH = tr.find('select[name="ENDUZ-hour"]'),
    ENDMM = tr.find('select[name="ENDUZ-minute"]'),

    isSaved = tr.find('div.icon').hasClass('done'),
    isEditable = parent.getData().T_WKTYP[tr.data('date')].data[WKTYP].PSTIM === 'X',
    isChanged = Number(BEGHH.data('beguzhh') || -1) !== Number(BEGHH.find('option:selected').val())
             || Number(BEGMM.data('beguzmm') || -1) !== Number(BEGMM.find('option:selected').val())
             || Number(ENDHH.data('enduzhh') || -1) !== Number(ENDHH.find('option:selected').val())
             || Number(ENDMM.data('enduzmm') || -1) !== Number(ENDMM.find('option:selected').val());

    message.push(!isChanged ? '' : i18n.MSG.D.D25.N0014 + '\n'); // 업무 시작/종료 시간이 변경되었습니다.
    message.push(!isChanged && isSaved && isEditable ? '' : i18n.MSG.D.D25.N0015); // 업무 시작/종료 시간을 저장한 후 비근무를 입력할 수 있습니다.

    return message.join('');
}

/**
 * 비근무시간 입력 popup layer open
 */
function showBreaktimeList() {

    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date'),
    message = checkBreaktimeListPopupAllowed(tr);

    if (message) {
        alert(message); // 업무 시작/종료 시간이 변경되었습니다.\n업무 시작/종료 시간을 저장한 후 비근무를 입력할 수 있습니다.
        return;
    }

    // 비근무 목록 조회 AJAX 호출
    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        {
            NAME: 'BREAK_LIST',
            I_WKDAT: WKDAT,
            P_PERNR: parent.$('input[type="hidden"][name="P_PERNR"]').val()
        },
        function(data) {
            $.LOGGER.debug('비근무시간 목록 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            var isEditable = anchor.data('pdunb-editable');

            // 비근무 입력 popup layer 호출
            parent.popupLayer({
                which: parent.POPUP_NAME.BREAK_TIME,
                list: (data.TABLES || {}).T_ELIST || [],
                date: WKDAT,
                isEditable: isEditable
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
 * @returns
 */
function checkExtratimeListPopupAllowed(tr) {

    var message = [],
    BEGHH = tr.find('select[name="BEGUZ-hour"]'),
    BEGMM = tr.find('select[name="BEGUZ-minute"]'),
    ENDHH = tr.find('select[name="ENDUZ-hour"]'),
    ENDMM = tr.find('select[name="ENDUZ-minute"]'),

    isSaved = tr.find('div.icon').hasClass('done'),
    isChanged = Number(BEGHH.data('beguzhh') || -1) !== Number(BEGHH.find('option:selected').val())
             || Number(BEGMM.data('beguzmm') || -1) !== Number(BEGMM.find('option:selected').val())
             || Number(ENDHH.data('enduzhh') || -1) !== Number(ENDHH.find('option:selected').val())
             || Number(ENDMM.data('enduzmm') || -1) !== Number(ENDMM.find('option:selected').val());

    message.push(!isChanged ? '' : i18n.MSG.D.D25.N0014 + '\n'); // 업무 시작/종료 시간이 변경되었습니다.
    message.push(!isChanged && isSaved ? '' : i18n.MSG.D.D25.N0016); // 업무 시작/종료 시간을 저장한 후 업무재개를 입력할 수 있습니다.

    return message.join('');
}

/**
 * 업무재개시간 입력 popup layer open
 */
function showExtratimeList() {

    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date'),
    message = checkExtratimeListPopupAllowed(tr);

    if (message) {
        alert(message); // 업무 시작/종료 시간이 변경되었습니다.\n업무 시작/종료 시간을 저장한 후 업무재개를 입력할 수 있습니다.
        return;
    }

    // 업무재개시간 목록 조회 AJAX 호출
    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        {
            NAME: 'EXTRA_LIST',
            I_WKDAT: WKDAT,
            P_PERNR: parent.$('input[type="hidden"][name="P_PERNR"]').val(),
            I_TOMRR: moment(WKDAT, 'YYYYMMDD').add(1, 'days').format('YYYYMMDD')
        },
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            var isEditable = anchor.data('arewk-editable');

            // 업무재개시간 입력 popup layer 호출
            parent.popupLayer($.extend({
                which: parent.POPUP_NAME.EXTRA_TIME,
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

function showPlantimeTable(e) {

    // 교육/출장 계획 입력 popup layer 호출
    parent.popupLayer({
        which: parent.POPUP_NAME.PLAN_TIME
    });
    return false;
}

function popupOvertimeResultSave(e) {

    var refMonth = moment(parent.getData().refMonth.data('year-month'), 'YYYYMM');/*
    openPopup({
        url: getServletURL('hris.D.D01OT.D01OTOvertimeInputSV'),
        data: {
            isPop: 'Y',
            PARAM_YYYY: refMonth.year(),
            PARAM_MM: refMonth.format('MM'),
            PARAM_DATE: $(e.currentTarget).parents('tr').data('date')
        },
        width: 1200,
        height: 450,
        specs: {
            resizable: 'yes'
        }
    });*/

    var params = {
        isPop: 'Y',
        EdgeMode: 'Y',
        FROM_ESS_OFW_WORK_TIME: 'Y',
        PARAM_YYYY: refMonth.year(),
        PARAM_MM: refMonth.format('MM'),
        PARAM_DATE: $(e.currentTarget).parents('tr').data('date')
    };
    showModalDialog(getServletURL('hris.D.D01OT.D01OTOvertimeInputSV?') + $.param(params), this, 'location:0;scroll:1;menubar:0;status:0;help:0;resizable:1;dialogWidth:1200px;dialogHeight:450px');
    parent.retrieveData();

    return false;
}

/**
 * 금일 업무시간과 익일 계획근무시간의 겹침 체크를 위해 익일 data를 조회한다.
 * 
 * @param WKDAT 금일 일자
 * @param TOMRR 익일 일자
 * @returns
 */
function getTomorrowData(WKDAT, TOMRR) {

    var TOMRRData;
    $.post({
        url: getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        data: {
            NAME: 'EXTRA_LIST',
            I_WKDAT: WKDAT,
            I_TOMRR: TOMRR
        },
        dataType: 'json',
        async: false
    })
    .done(function(data) {
        $.LOGGER.debug('익일 data 조회 AJAX 호출', data);

        data = getRfcResult(data);

        if (!data.isSuccess()) {
            alert(data.MSG);
            return;
        }

        TOMRRData = data.EXPORT.TOMORROW || {};
    })
    .fail(function(data) {
        $.LOGGER.debug('익일 data 조회 AJAX 호출 오류', data);

        alert(data.message || 'connection error.');
    });

    return TOMRRData;
}

function saveWorktimeList() {

    var T_WLIST = parent.getData().T_WLIST, // 시간 겹침 체크를 위한 실근무시간 정보 가져다놓기
    messages = [], // 시간 validation 오류 메세지

    // 입력 또는 수정된 근무시간 정보 변수로 저장
    list = $('div.scroll-body select[name="WKTYP"]:not(:disabled)').map(function() {
        var s = $(this), tr = s.parents('tr'),
        WKDAT = tr.data('date'),
        WKTYP = s.find('option:selected').val(),
        BEGUZ = getMoment(WKDAT, tr.find('select[name*="BEGUZ"] option:selected').text()),
        ENDUZ = getMoment(WKDAT, tr.find('select[name*="ENDUZ"] option:selected').text());

        if (BEGUZ.isAfter(ENDUZ)) ENDUZ.add(1, 'days');

        // |<--- 전반 휴가 --->|<--- 후반 업무 --->|
        // 전반 휴가 시간대에 업무 시간이 입력되었으면 오류 처리
        if (WKTYP === '3120') {
            var HFBEG = getMoment(WKDAT, T_WLIST[WKDAT].HFBEG); // 반차인 경우의 계획 근무 시작 시간(=반차 종료 시간)
            if (BEGUZ.isBefore(HFBEG) || ENDUZ.isBefore(HFBEG)) { // 전반 휴가 시간 이후에만 입력 가능
                messages.push(moment(WKDAT, 'YYYYMMDD').format('YYYY-MM-DD(ddd)') + '\n    ' + i18n.MSG.D.D25.N0039); // 전반 휴가의 경우 휴가 시간 이후에만 업무 시간 입력이 가능합니다.
                return null;
            }
        }

        // |<--- 전반 업무 --->|<--- 후반 휴가 --->|
        // 후반 휴가 시간대에 업무 시간이 입력되었으면 오류 처리
        else if (WKTYP === '3130') {
            var HFEND = getMoment(WKDAT, T_WLIST[WKDAT].HFEND); // 반차인 경우의 계획 근무 종료 시간(=반차 시작 시간)
            if (BEGUZ.isAfter(HFEND) || ENDUZ.isAfter(HFEND)) { // 후반 휴가 시간 이전에만 입력 가능
                messages.push(moment(WKDAT, 'YYYYMMDD').format('YYYY-MM-DD(ddd)') + '\n    ' + i18n.MSG.D.D25.N0040); // 후반 휴가의 경우 휴가 시간 이전에만 업무 시간 입력이 가능합니다.
                return null;
            }
        }

        // |<--- 금일 업무 시간 --->|<--- 익일 계획 근무 시간 --->|
        // 금일과 익일의 업무 시간이 겹치는 경우 오류 처리
        var TOMRR = moment(WKDAT, 'YYYYMMDD').add(1, 'days').format('YYYYMMDD'), TOMRRData = T_WLIST[TOMRR];
        if (!$.isPlainObject(TOMRRData)) {
            TOMRRData = getTomorrowData(WKDAT, TOMRR) || {}; // 이번달 data를 모두 받아 오지만 마지막 날짜의 경우 익일 data가 없으므로 AJAX로 받아온다.
        }

        // 익일 계획 근무 시간이 있는 경우에만 업무 시간 겹침 체크
        if (TOMRRData.SOBEG) {
            var SOBEG = getMoment(TOMRR, TOMRRData.SOBEG); // 익일 계획 시업 시간
            if (ENDUZ.isAfter(SOBEG)) {
                messages.push(moment(WKDAT, 'YYYYMMDD').format('YYYY-MM-DD(ddd)') + '\n    ' + i18n.MSG.D.D25.N0055); // 업무 시간이 다음날 업무 시간과 중복됩니다.
                return null;
            }
        } else {
            $.LOGGER.debug('익일 계획근무시간 겹침 체크 제외', {ENDUZ: ENDUZ.format('YYYY-MM-DD HH:mm:ss'), SOBEG: moment(TOMRR, 'YYYYMMDD').format('YYYY-MM-DD') + ' ' + TOMRRData.SOBEG});
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
        return false;
    }

    if (!confirm(i18n.MSG.COMMON.SAVE.CONFIRM)) return; // 저장하시겠습니까?

    // 저장 AJAX 호출
    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        {
            NAME: 'WORK_SAVE',
            I_YYMON: parent.getData().refMonth.data('year-month'),
            TABLES: JSON.stringify({
                T_WLIST: list
            })
        },
        function(data) {
            $.LOGGER.debug('근무시간 저장 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            // 근무가능시간의 잔여시간이 부족한 경우 warning이 return 됨
            if (data.isWarning()) {
                alert(data.MSG);
            }

            var msg2 = (data.EXPORT.E_RETURN2 || {}).MSGTX;
            if (msg2) {
                alert(msg2);
            }

            if (!data.isWarning() && !msg2) {
                alert(i18n.MSG.COMMON.SAVE.SUCCESS); // 저장되었습니다.
            }

            parent.retrieveData();
        },
        function(data) {
            $.LOGGER.debug('근무시간 저장 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

function renderList(data) {

    if ($.isEmptyObject(data.T_WLIST)) {
        $('div.scroll-body > table tbody').html('<tr class="oddRow" data-not-found><td class="lastCol" colspan="10">' + i18n.MSG.COMMON['0004'] + '</td></tr>'); // 해당하는 데이타가 존재하지 않습니다.
        return;
    }

    var refMonth = data.refMonth,     // 기준년월
    today = moment().startOf('date'), // 오늘 일자
    selectedMonth = moment(refMonth.data('year-month'), 'YYYYMM').month(),
    selected = refMonth.data('selected') ? moment(String(refMonth.data('selected')).deformat(), 'YYYYMMDD') : today;

    // tbody rendering
    var template = {
        // 시 combo
        hour: $.map(new Array(24), function(v, i) {
            return '<option value="#">#</option>'.replace(/#/g, String.lpad(i, 2, '0'));
        }).join(''),
        // 분 combo
        minute: $.map(new Array(6), function(v, i) {
            return '<option value="#">#</option>'.replace(/#/g, String.lpad((i * 10), 2, '0'));
        }).join(''),
        otLinkIcon: '<img src="' + getImageURL('ehr_common/login_ico_edit.gif') + '" />',
        otLink: '<a href="javascript:void(0)" class="non-background" title="#" data-name="overtimeResultSave">#</a>',
        tr: $('tbody#worktimeTemplate').html()
    };
    /***
     * rowData.PSTIM = X  : 구분 combo 활성화 O & 시간 combo 활성화 O
     *                 M  : 구분 combo 활성화 O & 시간 combo 활성화 X - 휴일, 휴무
     *                 Z  : 구분 combo 활성화 O & 시간 combo 활성화 O - 반차
     *                 '' : 구분 combo 활성화 X & 시간 combo 활성화 X
     */
    $('div.scroll-body > table tbody').html($.map(data.T_WLIST, function(rowData, k) {
        var YYYYMMDD = k.deformat(), thisDate = moment(YYYYMMDD, 'YYYYMMDD'), thisMonth = thisDate.month();

        if (selectedMonth !== thisMonth) return null;

        var PSTIM = rowData.PSTIM,
        WKTYP = rowData.WKTYP || '',
        T_WKTYP = data.T_WKTYP[YYYYMMDD],
        isSaved = rowData.SAVED === 'X',         // 실근로시간 저장 여부
        isExceeded = rowData.WRNTM === 'W',      // 기본근무시간 도달 또는 초과시 해당 시점 이후 배경색 처리
        isHoliday = rowData.HOLID === 'X',       // 법정 공휴일 여부
        isWeekend = thisDate.isoWeekday() >= 6,  // 주말 여부
        isFuture = thisDate.isAfter(today),      // 오늘 일자 이후 여부

        // 비근무시간 popup 호출 icon 보임 여부
        isWorkTimeEditable = PSTIM === 'X' || PSTIM === 'Z',
        isIconVisible1 = isFuture ? false : (Number(rowData.ABSTD || '0') > 0 || (isSaved && rowData.PSABS === 'X')),

        // 업무재개시간 popup 호출 icon 보임 여부
        isIconVisible2 = isFuture ? false : (Number(rowData.AREWK || '0') > 0 || (isSaved && rowData.PSRWK === 'X')),

        BEGUZ = rowData.BEGUZ ? moment(rowData.BEGUZ.deformat(), 'HHmmss') : null, // 업무 시작
        ENDUZ = rowData.ENDUZ ? moment(rowData.ENDUZ.deformat(), 'HHmmss') : null, // 업무 종료
        BEGHH = rowData.BEGUZ ? BEGUZ.format('HH') : null,
        BEGMM = rowData.BEGUZ ? BEGUZ.format('mm') : null,
        ENDHH = rowData.ENDUZ ? ENDUZ.format('HH') : null,
        ENDMM = rowData.ENDUZ ? ENDUZ.format('mm') : null,
        SOBEG = rowData.SOBEG ? moment(rowData.SOBEG.deformat(), 'HHmmss') : null, // 업무 시작 초기화 시간(구분 combo 변경시 사용)
        SOEND = rowData.SOEND ? moment(rowData.SOEND.deformat(), 'HHmmss') : null; // 업무 종료 초기화 시간(구분 combo 변경시 사용)

        return template.tr
            .replace(/data\-date/,      'data-date="' + YYYYMMDD + '"')
            .replace(/data\-tr\-class/, isExceeded ? 'class="borderRow exceed"' : (isHoliday ? 'class="borderRow holiday"' : (isWeekend ? 'class="borderRow weekend"' : 'class="borderRow"')))
            .replace(/(icon\-class)/,   rowData.SKIP === 'X' ? 'non-this-month $1' : '$1')
            .replace(/icon\-class/,     isSaved ? 'done' : (thisDate.isSame(today) ? 'required' : ''))
            .replace(/\sclass=""/,      '')
            .replace(/#text#/,          [rowData.WKDAT, '(', rowData.WOTAG, ')', (isHoliday ? '<br />' + rowData.HDTXT : '')].join(''))

            // 구분 combo
            .replace(/#type\-options#/, PSTIM === 'Z' ? parent.getOptionHTML(T_WKTYP.data[WKTYP]) : T_WKTYP.options.replace(new RegExp('(value="' + WKTYP + '")'), '$1 selected="selected"'))
            .replace(/data\-disabled/,  PSTIM ? '' : 'disabled="disabled"')

            // 시작/종료 시간
            .replace(/#hh-options#/,    BEGUZ ? template.hour.replace(  new RegExp('(value="' + BEGHH + '")'), '$1 selected="selected"') : template.hour)
            .replace(/#mm-options#/,    BEGUZ ? template.minute.replace(new RegExp('(value="' + BEGMM + '")'), '$1 selected="selected"') : template.minute)
            .replace(/#hh-options#/,    ENDUZ ? template.hour.replace(  new RegExp('(value="' + ENDHH + '")'), '$1 selected="selected"') : template.hour)
            .replace(/#mm-options#/,    ENDUZ ? template.minute.replace(new RegExp('(value="' + ENDMM + '")'), '$1 selected="selected"') : template.minute)
            .replace(/data\-beguzhh/,   BEGUZ ? 'data-beguzhh="' + BEGHH + '"' : '')
            .replace(/data\-beguzmm/,   BEGUZ ? 'data-beguzmm="' + BEGMM + '"' : '')
            .replace(/data\-enduzhh/,   ENDUZ ? 'data-enduzhh="' + ENDHH + '"' : '')
            .replace(/data\-enduzmm/,   ENDUZ ? 'data-enduzmm="' + ENDMM + '"' : '')
            .replace(/data\-sobeghh/,   SOBEG ? 'data-sobeghh="' + SOBEG.format('HH') + '"' : '')
            .replace(/data\-sobegmm/,   SOBEG ? 'data-sobegmm="' + SOBEG.format('mm') + '"' : '')
            .replace(/data\-soendhh/,   SOEND ? 'data-soendhh="' + SOEND.format('HH') + '"' : '')
            .replace(/data\-soendmm/,   SOEND ? 'data-soendmm="' + SOEND.format('mm') + '"' : '')
            .replace(/data\-disabled/g, isWorkTimeEditable ? '' : 'disabled="disabled"')

            .replace(/#text#/,          humanize(rowData.CPDUNB).replace(/-/, ''))

            .replace(/data\-value/,     isIconVisible1 && Number(rowData.ABSTD || '0') > 0 ? 'value="' + Number(rowData.ABSTD) + i18n.LABEL.COMMON['0039'] + '"' : '')
            .replace(/\sdata\-class/,   isIconVisible1 ? '' : ' invisible')
            .replace(/data\-pdunb\-editable/,  'data-pdunb-editable="' + (isSaved && rowData.PSABS === 'X') + '"') // 비근무 수정 가능 여부

            .replace(/data\-value/,     isIconVisible2 && rowData.CAREWK ? 'value="' + humanize(rowData.CAREWK).replace(/-/, '') + '"' : '')
            .replace(/\sdata\-class/,   isIconVisible2 ? '' : ' invisible')
            .replace(/data\-arewk\-editable/,  'data-arewk-editable="' + (isSaved && rowData.PSRWK === 'X') + '"') // 업무재개 수정 가능 여부

            .replace(/#text#/,          rowData.OVRTX || '')
            .replace(/#anchor#/,        rowData.RWINP === 'X' ? template.otLink.replace(/#/, i18n.BUTTON.D.D25.N0006).replace(/#/, template.otLinkIcon) // 초과근무 실적입력
                                      : rowData.RWINP === 'T' ? template.otLink.replace(/#/g, i18n.LABEL.D.D25.N2163) // 완료
                                      : rowData.RWINP === 'A' ? i18n.LABEL.D.D25.N2163 : '') // 완료

            .replace(/#text#/,          rowData.CSTDAZ ? humanize(rowData.CSTDAZ).replace(/-/, '') : '')
    }))
    .find('tr[data-date="#"]'.replace(/#/, selected.format('YYYYMMDD'))).addClass('today'); // 오늘 일자 스타일 적용

    var autoScrollTarget = $('tr[data-date="#"]'.replace(/#/, selected.format('YYYYMMDD')));
    if (autoScrollTarget.length) {
        autoScrollTarget.addClass('picked');
        setTimeout(function() {
//            $('div.scroll-body').animate({scrollTop: (autoScrollTarget.index() - 3) * 46}, 300);
            $('div.scroll-body').scrollTop((autoScrollTarget.index() - 3) * 40);
        }, 100);
    }

    parent.autoResize();
}

$(function() {
    if (!parent) {
        alert(i18n.MSG.D.D25.N0012); // 부모 프레임이 없습니다!\n\n이 화면은 부모 프레임에 저장된 정보를 참조해야합니다.
        top.window.close();
        return;
    }

//    $.LOGGER.setup({
//        enable: {
//             debug: true
//            ,info: true
//            ,error: true
//        }
//    });

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
    $('a[data-name="plantimeTablePopup"]').click(showPlantimeTable);
    $('a[data-name="worktimeSave"]').click(saveWorktimeList);

    $(document)
        .on('click', 'div.scroll-body a.data-pdunb:not(.invisible)', showBreaktimeList)
        .on('click', 'div.scroll-body a.data-arewk:not(.invisible)', showExtratimeList)
        .on('click', 'div.scroll-body a[data-name="overtimeResultSave"]', popupOvertimeResultSave)
        .on('change', 'div.scroll-body select[name="WKTYP"]', changeWKTYP)
        .on('mouseover', 'div.icon.done, div.icon.required', function() {
            var t = $(this);
            t.attr('title', t.hasClass('done') ? i18n.LABEL.D.D25.N2150 : t.hasClass('required') ? i18n.LABEL.D.D25.N2151 : ''); // 저장됨 : 미저장
        });

    parent.setHeaderData(window); // 근무시간 사용현황 data 표시

    renderList(parent.getData()); // parent frame onload event에서 조회년월 정보로 해당 년월에 입력된 근무시간 정보를 조회하고 조회된 정보를 여기에서 참조한다.

    setTimeout(parent.$.unblockUI, 500);
});