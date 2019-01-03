/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 보상휴가 발생내역
/*   Program ID   : D03CompTimeList.js
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-07-25 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/

var isTestMode = false; // 운영 반영시 false로 둘 것, 운영 반영 전 4 ~ 6월(사번 : 205958)에 data를 생성하여 test를 위해 사용함, 이 변수에 의해 function 선언이 달라짐

/**
 * combo option 생성 util function 추가
 */
$.fn.extend({
    options: function(values) {
        return this.html($.map(values || [], function(v, i) {
            return '<option value="@">@</option>'.replace(/@/g, v);
        }));
    }
});

/**
 * 조회년월의 연도 combo option rendering, 2018년부터 생성
 * 
 * @return combo
 */
function renderYearCombo() {

    var today = moment(), thisYear = today.year() - (today.month() === 0 ? 1 : 0); // 이번 달이 1월이면 작년까지 연도를 생성한다.
    return $('select#year')
        .options($.map(new Array(thisYear - 2018 + 1), function(v, i) {
            return i + 2018;
        }))
        .val(thisYear); // 현재 연도(또는 직전 연도) 기본 선택
}

function getMonthCombo(prevMonth, begMonth, endMonth) {

    return $('select#month')
        .options($.map(new Array(endMonth - begMonth + 1), function(v, i) {
            return String.lpad(i + begMonth, 2, '0');
        }))
        .val(String.lpad(prevMonth === 0 ? 12 : prevMonth, 2, '0')); // 전월 기본 선택
}

/**
 * 조회년월의 월 combo option rendering, 2018년은 7월 option부터 생성, 이번달 이후 월 option은 생성하지 않음
 * 
 * 참고 : isTestMode 변수에 의해 function 선언을 다르게 한 이유
 *   - logic이 운영 반영 이후 날짜에 영향을 받으므로 test용 function과 운영용 function으로 나누어 내부 logic이 꼬이는 것을 방지함
 *   - 운영 시점에 function 내부에 biz logic과 무관한 분기 처리가 있으면 크지는 않으나 성능에 영향이 있고 유지보수 방해요인울 최소화하는데 도움이 됨
 * 
 * @param year
 * @return combo
 */
var renderMonthCombo = isTestMode ?
function(year) {

    // 선택된 연도가 2018년 이전 연도이거나 당월이 2018년 7월 이전인 경우에는 월을 생성하지 않는다.
    if (isNaN(year) || year < 2018) {
        return $('select#month').options(['--']);
    }

    var today = moment(), thisYear = today.year(),
    prevMonth = today.month(),           // 당월은 근태통계가 없으므로 생성하지 않음 (JS Date의 월은 0월부터 시작되므로 당월 숫자를 구하면 실제로는 전월 숫자를 얻을 수 있다.) 
    begMonth = year > 2018     ?  1 : 4, // 근태통계 가능한 실근무시간 정보는 2018년 4월부터 있음
    endMonth = year < thisYear ? 12 : 7; // 과거 연도를 선택시 12월까지 생성, 현재 연도 선택시 6월까지 생성

    return getMonthCombo(prevMonth, begMonth, endMonth);
} :
function(year) {

    // 선택된 연도가 2018년 이전 연도이거나 당월이 2018년 7월 이전인 경우에는 월을 생성하지 않는다.
    if (isNaN(year) || year < 2018 || moment().startOf('month').isSame('20180701')) {
        return $('select#month').options(['--']);
    }

    var today = moment(), thisYear = today.year(),
    prevMonth = today.month(), // 당월은 근태통계가 없으므로 생성하지 않음 (JS Date의 월은 0월부터 시작되므로 당월 숫자를 구하면 실제로는 전월 숫자를 얻을 수 있다.) 
    begMonth = year > 2018     ?  1 : 7,         // 근태통계 가능한 실근무시간 정보 입력은 2018년 7월부터 운영 open 되었음
    endMonth = year < thisYear ? 12 : prevMonth; // 과거 연도를 선택시 12월까지 생성, 현재 연도 선택시 전월까지 생성

    return getMonthCombo(prevMonth, begMonth, endMonth);
};

/**
 * 업무재개시간 목록 popup layer open
 * 
 * @param list
 */
function popupLayer(list) {

    // 업무재개시간 입력 popup
    var layer = $('div#extratimeList'), trs = layer.find('tbody tr');

    trs.find('td').text('-');

    $.each(list || [], function(i, rowData) {
        var ABEGUZ = rowData.ABEGUZ ? moment(rowData.ABEGUZ.deformat(), 'HHmmss') : null,
            AENDUZ = rowData.AENDUZ ? moment(rowData.AENDUZ.deformat(), 'HHmmss') : null;
        trs.eq(i)
           .find('td[data-name="ABEGUZ"]').text(ABEGUZ ? ABEGUZ.format('HH:mm') : '').end()
           .find('td[data-name="AENDUZ"]').text(AENDUZ ? AENDUZ.format('HH:mm') : '').end()
           .find('td[data-name="DESCR"]' ).text(rowData.DESCR || '');
    });

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
                setTimeout(function() {
                    $('div#extratimeList').hide();
                }, 100);
            }
        });
        $('div.blockUI.blockMsg').draggable();
    }, 500);
}

/**
 * 업무재개시간 입력 popup layer open
 */
function showExtratimeList(e) {

    e.preventDefault();

    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date');

    // 업무재개시간 목록 조회 AJAX 호출
    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeDataAjax'),
        {
            NAME: 'EXTRA_LIST',
            I_WKDAT: WKDAT,
            I_TOMRR: moment(WKDAT, 'YYYYMMDD').add(1, 'days').format('YYYYMMDD')
        },
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            // 업무재개시간 입력 popup layer 호출
            popupLayer((data.TABLES || {}).T_ELIST || []);
        },
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 조회 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

function getTD(name) {

    return $('td[data-name="T_WHEAD-@"]'.replace(/@/, name));
}

function getTH(name) {

    return $('th[data-name="T_WORKS-@"]'.replace(/@/, name));
}

/**
 * 보상휴가 발생내역 현황 rendering
 * 
 * @param T_WHEAD
 */
function renderHeader(T_WHEAD) {

    T_WHEAD = T_WHEAD[0] || {};

    $.each(new Array(9), function(i, v) {
        var name = 'ZFIELD' + String.lpad(i + 1, 2, 0);
        getTD(name).html(T_WHEAD[name] || '-');
    });
}

/**
 * 보상휴가 발생내역 현황 하단 messages rendering
 * 
 * @param T_WMSG
 */
function renderHeaderMessage(T_WMSG) {

    if ($.isArray(T_WMSG)) {
        $('div#messages').html($.map(T_WMSG, function(o, i) {
            return '<div>@</div>'.replace(/@/, o.ZMSG || '');
        }));
    } else {
        $('div#messages').html(T_WMSG);
    }
}

function renderListHeader(T_WORKS) {

    var data0 = T_WORKS.length > 0 ? (T_WORKS[0].GUBUN === 'A' ? T_WORKS[0] : null) : null,
        data1 = T_WORKS.length > 1 ? (T_WORKS[1].GUBUN === 'A' ? T_WORKS[1] : null) : null,
        data = data0 || data1 || {};
    
    getTH('CZNOOT').html(data.CZNOOT || '-');
    getTH('CZHOOT').html(data.CZHOOT || '-');
    getTH('CZNIGT').html(data.CZNIGT || '-');
    getTH('CZHOWK').html(data.CZHOWK || '-');
}

function renderList(T_WLIST) {

    if ($.isEmptyObject(T_WLIST)) {
        $('div.scroll-body > table tbody').html('<tr class="oddRow lastRow" data-not-found><td class="lastCol" colspan="9">' + i18n.MSG.COMMON['0004'] + '</td></tr>'); // 해당하는 데이타가 존재하지 않습니다.
        return;
    }

    var template = $('tbody#comptimeTemplate').html();

    $('div.scroll-body > table tbody').html($.map(T_WLIST, function(rowData, k) {

        return template
            .replace(/data\-date/, 'data-date="' + k + '"')
            .replace(/data\-tr\-class/, rowData.WKTXT ? 'class="borderRow"' : 'class="borderRow weekend"')
            .replace(/#text#/, [rowData.WKDAT, '(', rowData.WOTAG, ')'].join(''))
            .replace(/@(.*)@/, rowData.WKTXT ? rowData.WKTXT : '$1')
            .replace(/#text#/, rowData.SOTIME)
            .replace(/#text#/, rowData.RETIME)
            .replace(/#text#/, Number(rowData.AREWK || '0') > 0 && rowData.CAREWK ? humanize(rowData.CAREWK).replace(/-/, '') : '')
            .replace(/\sdata\-class/, Number(rowData.AREWK || '0') > 0 ? '' : ' invisible')
            .replace(/#text#/, rowData.CZNOOT)
            .replace(/#text#/, rowData.CZHOOT)
            .replace(/#text#/, rowData.CZNIGT)
            .replace(/#text#/, rowData.CZHOWK);
    })).find('tr:last-child').addClass('lastRow');
}

var isAfterOpen = isTestMode ?
function() {

    return true;
} :
function(selectedYearMonth) {

    return moment(selectedYearMonth + '01', 'YYYYMMDD').isSameOrAfter('20180701');
};

/**
 * 보상휴가 발생내역 data 조회
 */
function retrieveData() {

    var year = $('select#year option:selected').val(), month = $('select#month option:selected').val();
    if (!year || !month || isNaN(year) || isNaN(month)) {
        alert(i18n.MSG.D.D03['0081']); // 조회년월이 정상적으로 선택되지 않았습니다.
        return;
    }
    var selectedYearMonth = [year, month].join('');
    if (!isAfterOpen(selectedYearMonth)) {
        alert(i18n.MSG.D.D03['0082']); // 2018년 7월부터 조회 가능합니다.
        return;
    }

    ajaxPost(
        getServletURL('hris.D.D03Vocation.D03CompTimeDataAjax'),
        {
            I_YYMON: selectedYearMonth,
            I_TOTAL: $('input#I_TOTAL').prop('checked') ? 'X' : ''
        },
        function(data) {
            $.LOGGER.debug('보상휴가 발생내역 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            var EXPORT = data.EXPORT, TABLES = data.TABLES, T_WLIST = {};

            $.each(TABLES.T_WLIST || [], function(i, o) {
                T_WLIST[o.WKDAT.deformat()] = o;
            });

            // 보상휴가 발생내역 현황 rendering
            renderHeader(TABLES.T_WHEAD || [{}]);

            // 보상휴가 발생내역 현황 하단 messages rendering
            renderHeaderMessage(TABLES.T_WMSG || []);
//            renderHeaderMessage(EXPORT.E_MSG || '');

            // 보상휴가 발생내역 목록 rendering
            renderListHeader(TABLES.T_WORKS || [{}, {}]);
            renderList(T_WLIST);

            parent.resizeIframe(document.body.scrollHeight);
        },
        function(data) {
            $.LOGGER.debug('보상휴가 발생내역 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
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

    // 연, 월 combo option 생성 및 change event handler 등록
    renderYearCombo()
        .change(function() {
            var selectedYear = Number($(this).val());
            renderMonthCombo(selectedYear).change();
        });
    renderMonthCombo(2018) // 2018년부터 생성
        .change(function() {
            var thisMonth = $(this).val(), yearMonth = moment([$('select#year option:selected').val(), thisMonth].join(''), 'YYYYMM');
            $('label#period').text(isNaN(thisMonth) ? '(0000.00.00 ~ 0000.00.00)' :
                ['(', yearMonth.startOf('month').format('YYYY.MM.DD'), ' ~ ', yearMonth.endOf('month').format('YYYY.MM.DD'), ')'].join(''));
            retrieveData();
        });

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
    $(document).on('click', 'div.scroll-body a:not(.invisible)', showExtratimeList);
    $('a[data-name="extratimeClose"]').click(function() {
        $.unblockUI();
        return false;
    });
    $('a.search').click(retrieveData);
    $('input#I_TOTAL').change(retrieveData);

    // 보상휴가 발생내역 data 조회 및 rendering
    $('select#month').change();
});