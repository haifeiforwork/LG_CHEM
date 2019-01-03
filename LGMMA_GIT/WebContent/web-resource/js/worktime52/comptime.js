var initComptime = (function() {

var isDevMode = false, // 운영 반영시 false로 둘 것, 운영 반영 전 개발 서버에 10월부터 test data를 생성함, 이 변수에 의해 function 선언도 달라짐
openMonth = isDevMode ? 10 : 11;

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
    return $('.tab4 select#year')
        .options($.map(new Array(thisYear - 2018 + 1), function(v, i) {
            return i + 2018;
        }))
        .val(thisYear); // 현재 연도(또는 직전 연도) 기본 선택
}

function getMonthCombo(prevMonth, begMonth, endMonth) {

    return $('.tab4 select#month')
        .options($.map(new Array(endMonth - begMonth + 1), function(v, i) {
            return String.lpad(i + begMonth, 2, '0');
        }))
        .val(String.lpad(prevMonth === 0 ? 12 : prevMonth, 2, '0')); // 전월 기본 선택
}

/**
 * 조회년월의 월 combo option rendering
 * 
 * 2018년은 openMonth월 option부터 생성하고 올해 당월 이후 월은 data가 없으므로 option을 생성하지 않음
 * 
 * @param year
 * @return combo
 */
var renderMonthCombo = isDevMode ?
function(year) {

    // 선택된 연도가 2018년 이전 연도이거나 당월이 2018년 10월 이전인 경우에는 월을 생성하지 않는다.
    if (isNaN(year) || year < 2018) {
        return $('.tab4 select#month').options(['--']);
    }

    var today = moment(), thisYear = today.year(),
    prevMonth = today.month(),                   // 당월은 근태통계가 없으므로 생성하지 않음 (JS Date의 월은 0월부터 시작되므로 당월 숫자를 구하면 실제로는 전월 숫자를 얻을 수 있다.) 
    begMonth = year > 2018     ?  1 : openMonth, // 근태통계 가능한 실근무시간 정보는 2018년 10월부터 있음
    endMonth = year < thisYear ? 12 : openMonth; // 과거 연도를 선택시 12월까지 생성, 현재 연도 선택시 10월까지 생성

    return getMonthCombo(prevMonth, begMonth, endMonth);
} :
function(year) {

    // 선택된 연도가 2018년 이전 연도이거나 당월이 2018년 openMonth월 이전인 경우에는 월을 생성하지 않는다.
    if (isNaN(year) || year < 2018 || moment().startOf('month').isSame('2018' + openMonth + '01')) {
        return $('.tab4 select#month').options(['--']);
    }

    var today = moment(), thisYear = today.year(),
    prevMonth = today.month(),                   // 당월은 근태통계가 없으므로 생성하지 않음 (JS Date의 월은 0월부터 시작되므로 당월 숫자를 구하면 실제로는 전월 숫자를 얻을 수 있다.) 
    begMonth = year > 2018     ?  1 : openMonth, // 근태통계 가능한 실근무시간 정보 입력은 2018년 openMonth월부터 운영 open 되었음
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

    layer.popup('show');
}

/**
 * 업무재개시간 입력 popup layer open
 */
function showExtratimeList() {

    var anchor = $(this), tr = anchor.parents('tr'), WKDAT = tr.data('date');

    // 업무재개시간 목록 조회 AJAX 호출
    ajaxPost(
        '/work/getRealWorkTimeData.json',
        {
            NAME: 'EXTRA_LIST',
            I_WKDAT: WKDAT,
            I_TOMRR: moment(WKDAT, 'YYYYMMDD').add(1, 'days').format('YYYYMMDD')
        },
        function(data) {
            $.LOGGER.debug('업무재개시간 목록 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                alert(data.message);
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

function setTD(name, text, suffix) {

    return $('.tab4 td[data-name="T_WHEAD-@"]'.replace(/@/, name)).text(text ? (text + (suffix || '')) : '-');
}

function getTH(name) {

    return $('.tab4 th[data-name="T_WORKS-@"]'.replace(/@/, name));
}

/**
 * 보상휴가 발생내역 현황 rendering
 * 
 * @param T_WHEAD
 */
function renderHeader(T_WHEAD) {

    T_WHEAD = T_WHEAD[0] || {};

    // 초과근무시간
    setTD('ZFIELD04', T_WHEAD.ZFIELD04); // 휴일근무
    setTD('ZFIELD02', T_WHEAD.ZFIELD02); // 휴일연장(명절특근 포함)
    setTD('ZFIELD01', T_WHEAD.ZFIELD01); // 평일연장
    setTD('ZFIELD03', T_WHEAD.ZFIELD03); // 야간근무

    // 보상휴가 가산율
    setTD('ZFIELD08', T_WHEAD.ZFIELD08.replace(/\.0+$/g, ''), '%'); // 휴일근무
    setTD('ZFIELD06', T_WHEAD.ZFIELD06.replace(/\.0+$/g, ''), '%'); // 휴일연장(명절특근 포함)
    setTD('ZFIELD05', T_WHEAD.ZFIELD05.replace(/\.0+$/g, ''), '%'); // 평일연장
    setTD('ZFIELD07', T_WHEAD.ZFIELD07.replace(/\.0+$/g, ''), '%'); // 야간근무

    // 보상휴가 발생시간
    setTD('ZFIELD09', T_WHEAD.ZFIELD09);
}

/**
 * 보상휴가 발생내역 현황 하단 messages rendering
 * 
 * @param T_WMSG
 */
function renderHeaderMessage(T_WMSG) {

    if ($.isArray(T_WMSG)) {
        $('.tab4 div#messages').html($.map(T_WMSG, function(o, i) {
            return '<div>@</div>'.replace(/@/, o.ZMSG || '');
        }));
    } else {
        $('.tab4 div#messages').html(T_WMSG);
    }
}

function renderListHeader(T_WORKS) {

    var data0 = T_WORKS.length > 0 ? (T_WORKS[0].GUBUN === 'A' ? T_WORKS[0] : null) : null,
        data1 = T_WORKS.length > 1 ? (T_WORKS[1].GUBUN === 'A' ? T_WORKS[1] : null) : null,
        data = data0 || data1 || {};
    
    getTH('CZHOWK').html(data.CZHOWK || '-');
    getTH('CZHOOT').html(data.CZHOOT || '-');
    getTH('CZNOOT').html(data.CZNOOT || '-');
    getTH('CZNIGT').html(data.CZNIGT || '-');
}

function renderList(T_WLIST) {

    if ($.isEmptyObject(T_WLIST)) {
        $('.tab4 div.scroll-body > table tbody').html('<tr class="oddRow" data-not-found><td colspan="9">해당하는 데이타가 존재하지 않습니다.</td></tr>');
        return;
    }

    var template = $('.tab4 tbody#comptimeTemplate').html();

    $('.tab4 div.scroll-body > table tbody').html($.map(T_WLIST, function(rowData, k) {

        return template
            .replace(/data\-date/, 'data-date="' + k + '"')
            .replace(/data\-tr\-class/, rowData.WKTXT ? '' : 'class="weekend"')
            .replace(/#text#/, [rowData.WKDAT, '(', rowData.WOTAG, ')'].join(''))
            .replace(/@(.*)@/, rowData.WKTXT ? rowData.WKTXT : '$1')
            .replace(/#text#/, rowData.SOTIME)
            .replace(/#text#/, rowData.RETIME)
            .replace(/#text#/, Number(rowData.AREWK || '0') > 0 && rowData.CAREWK ? String.humanize(rowData.CAREWK).replace(/-/, '') : '')
            .replace(/\sdata\-class/, Number(rowData.AREWK || '0') > 0 ? '' : ' invisible')
            .replace(/#text#/, rowData.CZHOWK)
            .replace(/#text#/, rowData.CZHOOT)
            .replace(/#text#/, rowData.CZNOOT)
            .replace(/#text#/, rowData.CZNIGT);
    }));
}

var isAfterOpen = isDevMode ?
function() {

    return true;
} :
function(selectedYearMonth) {

    return moment(selectedYearMonth + '01', 'YYYYMMDD').isSameOrAfter('2018' + openMonth + '01');
};

/**
 * 보상휴가 발생내역 data 조회
 */
function retrieveData() {

    var year = $('.tab4 select#year option:selected').val(), month = $('.tab4 select#month option:selected').val();
    if (month === '--') {
        alert('2018년 ' + (openMonth + 1) + '월 1일부터 조회 가능합니다.');
        return;
    }

    if (!year || !month || isNaN(year) || isNaN(month)) {
        alert('조회년월이 정상적으로 선택되지 않았습니다.');
        return;
    }
    var selectedYearMonth = [year, month].join('');
    if (!isAfterOpen(selectedYearMonth)) {
        alert('2018년 ' + (openMonth + 1) + '월 1일부터 조회 가능합니다.');
        return;
    }

    ajaxPost(
        '/work/getCompTimeData.json',
        {
            I_YYMON: selectedYearMonth,
            I_TOTAL: $('.tab4 input#I_TOTAL').prop('checked') ? 'X' : ''
        },
        function(data) {
            $.LOGGER.debug('보상휴가 발생내역 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.success) {
                alert(data.message);
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

            // 보상휴가 발생내역 목록 rendering
            renderListHeader(TABLES.T_WORKS || [{}, {}]);
            renderList(T_WLIST);
        },
        function(data) {
            $.LOGGER.debug('보상휴가 발생내역 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}

return function() {

    // 연, 월 combo option 생성 및 change event handler 등록
    renderYearCombo()
        .change(function() {
            renderMonthCombo(Number($(this).val())).change();
        });
    renderMonthCombo(2018) // 2018년부터 생성
        .change(function() {
            var thisMonth = $(this).val(), yearMonth = moment([$('.tab4 select#year option:selected').val(), thisMonth].join(''), 'YYYYMM');
            $('.tab4 label#period').text(isNaN(thisMonth) ? '' :
                ['(', yearMonth.startOf('month').format('YYYY.MM.DD'), ' ~ ', yearMonth.endOf('month').format('YYYY.MM.DD'), ')'].join(''));
            retrieveData();
        });

    $(document).on('click', '.tab4 div.scroll-body a:not(.invisible)', showExtratimeList);
    $('.tab4 a.search').click(retrieveData);
    $('.tab4 input#I_TOTAL').change(retrieveData);

    // 업무재개시간 popup
    $('a[data-name="extratimeClose"]').click(function() {
        $('div#extratimeList').popup('hide');
    });
    $('div#extratimeList')
        .draggable()
        .popup({
            transition: null
        });

    // 보상휴가 발생내역 data 조회 및 rendering
//    $('.tab4 select#month').change();
};
})();