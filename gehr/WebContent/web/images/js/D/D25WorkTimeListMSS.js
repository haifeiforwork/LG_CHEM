/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeListMSS.js
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-06-04 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/

/**
 * 비근무시간 입력 popup layer open
 */
function showBreaktimeList() {

    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date');

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

            var isTodayOrYesterday = moment().subtract(1, 'days').format('YYYYMMDD') == WKDAT || moment().format('YYYYMMDD') == WKDAT,
            isEditable = anchor.data('pdunb-editable') && isTodayOrYesterday;

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
 * 업무재개시간 입력 popup layer open
 */
function showExtratimeList() {

    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date');

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

function popupOvertimeResultSave(e) {

    var refMonth = moment(parent.getData().refMonth.data('year-month'), 'YYYYMM');/*
    openPopup({
        url: getServletURL('hris.D.D01OT.D01OTOvertimeInputSV'),
        data: {
            isPop: 'Y',
            viewMode: 'Y',
            EdgeMode: 'Y',
            FROM_ESS_OFW_WORK_TIME: 'Y',
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

    var tr = $(e.currentTarget).parents('tr'),
    params = {
        isPop: 'Y',
        viewMode: 'Y',
        EdgeMode: 'Y',
        PERNR: tr.data('pernr'),
        FROM_ESS_OFW_WORK_TIME: 'Y',
        PARAM_YYYY: refMonth.year(),
        PARAM_MM: refMonth.format('MM'),
        PARAM_DATE: tr.data('date')
    };
    showModalDialog(getServletURL('hris.D.D01OT.D01OTOvertimeInputSV?') + $.param(params), this, 'location:0;scroll:1;menubar:0;status:0;help:0;resizable:1;dialogWidth:1200px;dialogHeight:450px');
    parent.retrieveData();

    return false;
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
        otLinkIcon: '<img src="' + getImageURL('ehr_common/login_ico_edit.gif') + '" />',
        otLink: '<a href="javascript:void(0)" class="non-background" title="#" data-name="overtimeResultSave">#</a>',
        tr: $('tbody#worktimeMSSTemplate').html()
    };
    $('div.scroll-body > table tbody').html($.map(data.T_WLIST || {}, function(rowData, k) {
        var YYYYMMDD = k.deformat(), thisDate = moment(YYYYMMDD, 'YYYYMMDD'), thisMonth = thisDate.month();

        if (selectedMonth !== thisMonth) return null;

        var T_WKTYP = data.T_WKTYP[YYYYMMDD],
        isSaved = rowData.SAVED === 'X',
        isExceeded = rowData.WRNTM === 'W',     // 기본근무시간 도달 또는 초과시 해당 시점 이후 배경색 처리
        isHoliday = rowData.HOLID === 'X',      // 법정 공휴일 여부
        isWeekend = thisDate.isoWeekday() >= 6, // 주말 여부
        BEGUZ = rowData.BEGUZ ? moment(rowData.BEGUZ.deformat(), 'HHmmss') : null, // 업무 시작
        ENDUZ = rowData.ENDUZ ? moment(rowData.ENDUZ.deformat(), 'HHmmss') : null; // 업무 종료

        return template.tr
            .replace(/data\-date/,      'data-date="' + YYYYMMDD + '"')
            .replace(/data\-tr\-class/, isExceeded ? 'class="borderRow exceed"' : (isHoliday ? 'class="borderRow holiday"' : (isWeekend ? 'class="borderRow weekend"' : 'class="borderRow"')))
            .replace(/icon\-class/,     rowData.SKIP === 'X' ? 'non-this-month' : '')
            .replace(/\sclass=""/,      '')
            .replace(/#text#/,          [rowData.WKDAT, '(', rowData.WOTAG, ')', (isHoliday ? '<br />' + rowData.HDTXT : '')].join(''))
            .replace(/#text#/,          rowData.WKTXT)
            .replace(/#text#/,          isSaved && BEGUZ ? BEGUZ.format('HH : mm') : '')
            .replace(/#text#/,          isSaved && ENDUZ ? ENDUZ.format('HH : mm') : '')

            .replace(/#text#/,          isSaved ? humanize(rowData.CPDUNB).replace(/-/, '') : '')

            .replace(/#text#/,          Number(rowData.ABSTD || '0') > 0 ? Number(rowData.ABSTD) + i18n.LABEL.COMMON['0039'] : '')
            .replace(/\sdata\-class/,   Number(rowData.ABSTD || '0') > 0 ? '' : ' invisible')
            .replace(/data\-pdunb\-editable/,  'data-pdunb-editable="false"')

            .replace(/#text#/,          Number(rowData.AREWK || '0') > 0 && rowData.CAREWK ? humanize(rowData.CAREWK).replace(/-/, '') : '')
            .replace(/\sdata\-class/,   Number(rowData.AREWK || '0') > 0 ? '' : ' invisible')
            .replace(/data\-arewk\-editable/,  'data-arewk-editable="false"')

            .replace(/#text#/,          rowData.OVRTX || '')
            .replace(/#anchor#/,        rowData.RWINP === 'X' ? template.otLink.replace(/#/, i18n.BUTTON.D.D25.N0006).replace(/#/, template.otLinkIcon) // 초과근무 실적입력
                                      : rowData.RWINP === 'T' ? template.otLink.replace(/#/g, i18n.LABEL.D.D25.N2163) // 완료
                                      : rowData.RWINP === 'A' ? i18n.LABEL.D.D25.N2163 : '') // 완료

            .replace(/#text#/,          isSaved && rowData.CSTDAZ ? humanize(rowData.CSTDAZ).replace(/-/, '') : '');
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
    $(document)
        .on('click', 'div.scroll-body a.data-pdunb:not(.invisible)', showBreaktimeList)
        .on('click', 'div.scroll-body a.data-arewk:not(.invisible)', showExtratimeList)
        .on('click', 'div.scroll-body a[data-name="overtimeResultSave"]', popupOvertimeResultSave)
        .on('mouseover', 'div.icon.done, div.icon.required', function() {
            var t = $(this);
            t.attr('title', t.hasClass('done') ? i18n.LABEL.D.D25.N2150 : t.hasClass('required') ? i18n.LABEL.D.D25.N2151 : ''); // 저장됨 : 미저장
        });

    parent.setHeaderData(window); // 근무시간 사용현황 data 표시

    renderList(parent.getData()); // parent frame onload event에서 조회년월 정보로 해당 년월에 입력된 근무시간 정보를 조회하고 조회된 정보를 여기에서 참조한다.

    setTimeout(parent.$.unblockUI, 500);
});