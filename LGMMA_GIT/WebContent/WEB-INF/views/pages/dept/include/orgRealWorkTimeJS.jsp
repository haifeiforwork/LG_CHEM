<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@include file="/WEB-INF/views/tiles/template/javascriptWorkTime.jsp"%>
<script type="text/javascript" src="/web-resource/js/worktime52/common.js?v=${CACHE_VERSION}"></script>
<script type="text/javascript" src="/web-resource/js/worktime52/search-popup.js?v=${CACHE_VERSION}"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/dynatree/jquery.dynatree.min.js"></script>
<script type="text/javascript">
function popupDialog($anchor) {

    var o = { P_PERNR: $anchor.data('pernr'), P_ORGEH: $anchor.data('orgeh'), MSSYN: 'Y' };

    if ($('input[type="radio"][name="searchOption"]:checked').val() === 'Emp') {
        o.P_RETIR = $('form[name="searchOrg"] input[type="checkbox"][name="retir_chk"]').prop('checked') ? 'X' : '';
    }

    $('#modalDialog iframe')
        .attr('src', '/work/realWorkTimePopup?' + $.param(o))
        .load(function() {
            $('#modalDialog')
                .find('strong').text('근무시간입력 [' + $anchor.data('ename') + ']').end()
                .popup('show');
        });
}

function renderMonthlyList(list) {

    list = list || [];

    if (!list.length) {
        $('.monthlyTab table.listTable tbody').html('<tr class="oddRow"><td colspan="11">해당하는 데이타가 존재하지 않습니다.</td></tr>');

    } else {
        var tr = $('.monthlyTab tbody[data-template]').html(),
        stats = {
            '0': {icon: 'icon-glass', title: ''},
            '1': {icon: 'icon-green', title: '월 기본 근무시간 잔여 평균 7시간 이상'},
            '2': {icon: 'icon-yellow', title: '월 기본 근무시간 잔여 평균 6시간 이상 7시간 미만'},
            '3': {icon: 'icon-red', title: '월 기본 근무시간 잔여 평균 6시간 미만'}
        };

        // tbody rendering
        $('.monthlyTab table.listTable tbody')
        .html($.map(list, function(rowData, i) {
            var status = stats[rowData.WSTATS || '0'];
            return tr
                .replace(/%1%/g, rowData.PERNR) // 사번
                .replace(/%2%/g, rowData.ENAME) // 이름
                .replace(/%3%/g, rowData.ORGTX) // 소속
                .replace(/%4%/g, rowData.JIKKT) // 직책
                .replace(/@/,    rowData.ORGEH) // 소속 코드
                .replace(/@/,    String.humanize(rowData.CCOLWT).replace(/\s/, '<br />')) // 당월근무시간(유급휴가포함)
                .replace(/@/,    String.humanize(rowData.CBASWT)) // 월 기본 근무시간
                .replace(/@/,    String.humanize(rowData.CBRMWT, true).replace(/^\-$/, '').replace(/^\-/, '&Delta; ').replace(/\((.*)\)(.+)$/, '$2 ($1)').replace(/\s*00분/, '')) // 월 기본 근무시간 (잔여)
                .replace(/@/,    String.humanize(rowData.CMAXWT)) // 법정 최대 한도 근무시간
                .replace(/@/,    String.humanize(rowData.CMRMWT, true).replace(/^\-$/, '').replace(/^\-/, '&Delta; ')) // 법정 최대 한도 근무시간 (잔여)
                .replace(/@/,    String.humanize(rowData.CABSTD)) // 비근무
                .replace(/@/,    String.humanize(rowData.CAREWK).replace(/\s/, '<br />')) // 업무재개
                .replace(/@/,    String.humanize(rowData.CRWKTM).replace(/\s/, '<br />')) // 회사인정 근무시간
                .replace(/@/,    String.humanize(rowData.CGAPTM).replace(/\s/, '<br />')) // GAP(개인 - 회사)
                .replace(/@/,    '<span class="cursor-default @" title="@"></span>'.replace(/@/, status.icon).replace(/@/, status.title)); // 상태
        }))
        .find('tr:nth-child(odd)').addClass('oddRow');

    }
}

function renderWeeklyList(TABLES) {

    TABLES = TABLES || {};

    var list = TABLES.T_ORGWEEK || [], weeks = TABLES.T_TLWEEKS || [],
    getTdHTML = function(length, rowData) {

        return String.concat($.map(new Array(length), function(o, i) {
            return '<td>@</td>'.replace(/@/, String.humanize(rowData['CWKS' + String.lpad(i + 1, 2, '0')]));
        })).toString();
    }

    if (!list.length) {
        $('.weeklyTab table.listTable colgroup').html(String.concat(
            '<col style="width: 90px" />',
            '<col style="width:185px" />',
            '<col style="width: 90px" />',
            '<col style="width: 90px" />'
        ).toString());
        $('.weeklyTab table.listTable thead').html(String.concat(
            '<tr class="multi-line">',
            '<th>이름</th>',
            '<th>소속</th>',
            '<th>직책</th>',
            '<th class="worktime-sum">계</th>',
            '</tr>'
        ).toString());
        $('.weeklyTab table.listTable tbody').html('<tr class="oddRow"><td colspan="4">해당하는 데이타가 존재하지 않습니다.</td></tr>');

    } else {
        var tr = $('.weeklyTab tbody[data-template]').html(), cols = [],
        ths = $.map(weeks, function(o, i) {
            cols.push('<col />');
            return '<th>@<br />@</th>'.replace(/@/, o.TWEEKS).replace(/@/, o.TPERIOD);
        });

        $('.weeklyTab table.listTable colgroup').html(String.concat(
            '<col style="width: 90px" />',
            '<col style="width:185px" />',
            '<col style="width: 90px" />',
            '<col style="width: 90px" />',
            cols
        ).toString());
        $('.weeklyTab table.listTable thead tr').html(String.concat(
            '<th>이름</th>',
            '<th>소속</th>',
            '<th>직책</th>',
            '<th class="worktime-sum">계</th>',
            ths
        ).toString());

        // tbody rendering
        $('.weeklyTab table.listTable tbody')
        .html($.map(list, function(rowData, i) {
            return tr
            .replace(/%1%/g, rowData.PERNR)
            .replace(/%2%/g, rowData.ENAME)
            .replace(/%3%/g, rowData.ORGTX)
            .replace(/%4%/g, rowData.JIKKT)
            .replace(/@/,    rowData.ORGEH)
            .replace(/@/,    String.humanize(rowData.CTOTWKS))
            .replace(/<td>@<\/td>/i, getTdHTML(weeks.length, rowData));
        }))
        .find('tr:nth-child(odd)').addClass('oddRow');

    }
}

function renderDailyList(TABLES) {

    TABLES = TABLES || {};

    var list = TABLES.T_ORGDAYS || [], days = TABLES.T_TLDAYS || [], cols = [],
    ths = $.map(days, function(o, i) {
        cols.push('<col />');
        return '<th class="@">@<br />(@)</th>'
            .replace(/@/, o.HOLID === 'X' ? 'holiday' : (moment(o.WKDAT.deformat(), 'YYYYMMDD').isoWeekday() >= 6 ? 'weekend' : ''))
            .replace(/@/, Number(o.WDAYS))
            .replace(/@/, o.WOTAG)
            .replace(/class=""/, '');
    }),
    trFrozen = String.concat(
        '<tr>',
        '<td class="ellipsis emp-name" title="%2%"><a href="#" data-pernr="%1%" data-orgeh="@" style="color:blue">%2%</a></td>',
        '<td class="ellipsis org-name" title="%3%">%3%</td>',
        '<td class="ellipsis duty-name" title="%4%">%4%</td>',
        '<td class="worktime-sum">@</td>',
        '</tr>'
    ).toString(),
    trScroll = '<tr>@</tr>',
    getTdHTML = function(days, rowData) {

        return String.concat($.map(days, function(o, i) {
            return '<td class="@">@</td>'
                .replace(/@/, o.HOLID === 'X' ? 'holiday' : (moment(o.WKDAT.deformat(), 'YYYYMMDD').isoWeekday() >= 6 ? 'weekend' : ''))
                .replace(/@/, rowData['CDWS' + o.WDAYS] || '')
                .replace(/class=""/, '');
        })).toString();
    }

    if (!list.length) {
        $('.dailyTab div.frozen tbody').empty();
        $('.dailyTab div.scroll colgroup').html('<col />');
        $('.dailyTab div.scroll thead tr').html('<th class="border-left">일자<br />요일</th>');
        $('.dailyTab div.scroll tbody').empty();
        $('.dailyTab div.scroll').removeClass('border-left');
        $('.dailyTab div.date-spread.not-found-data').show();

    } else {
        $('.dailyTab div.scroll table').width(cols.length * 50 + 'px');
        $('.dailyTab div.scroll colgroup').html(cols.join(''));
        $('.dailyTab div.scroll thead tr').html(ths.join(''));

        // tbody rendering
        var tbodyFrozen = [],
        tbodyScroll = $.map(list, function(rowData, i) {
            tbodyFrozen.push(
                trFrozen
                    .replace(/%1%/g, rowData.PERNR)
                    .replace(/%2%/g, rowData.ENAME)
                    .replace(/%3%/g, rowData.ORGTX)
                    .replace(/%4%/g, rowData.JIKKT)
                    .replace(/@/,    rowData.ORGEH)
                    .replace(/@/,    rowData.CTOTDW)
            );
            return trScroll.replace(/@/, getTdHTML(days, rowData));
        });

        $('.dailyTab div.date-spread.not-found-data').hide();
        $('.dailyTab div.frozen tbody').html(tbodyFrozen.join(''))
        $('.dailyTab div.scroll tbody').html(tbodyScroll.join(''));
        $('.dailyTab div.scroll').addClass('border-left');

    }

    $('.dailyTab div.frozen').parent().height(function() {
        return $(this).find('div.frozen').height() + 26;
    });
}

/**
 * 기준년월, 부서 또는 사원 정보 반환
 * 
 * @returns
 */
function getSearchCondition() {

    var YYMON = $('select[name="year"] option:selected').val() + $('select[name="month"] option:selected').val(),
    method = $('input[type="radio"][name="searchOption"]:checked').val();
    if ($('input[type="radio"][name="searchOption"]:checked').val() === 'Org') {
        var form = $('form[name="searchOrg"]'), DEPTID = form.find('input[type="hidden"][name="DEPTID"]'), ORGEH = DEPTID.val().trim();
        return {
            METHOD: method,
            I_ORGEH: ORGEH ? ORGEH : DEPTID.data('init'),
            I_LOWERYN: form.find('input[type="checkbox"][name="includeSubOrg"]').prop('checked') ? 'Y' : '',
            I_YYMON: YYMON
        };

    } else {
        var form = $('form[name="searchEmp"]');
        return {
            METHOD: method,
            I_PERNR: form.find('input[type="hidden"][name="PERNR"]').val(),
            I_RETIR: form.find('input[type="checkbox"][name="retir_chk"]').prop('checked') ? 'X' : '',
            I_YYMON: YYMON
        };

    }
}

/**
 * Popup에서 선택된 부서 정보 적용 및 해당 data 조회
 * 
 * @param deptId 부서코드
 * @param deptNm 부서명
 */
function setDeptID(deptId, deptNm) {

    var form = $('form[name="searchOrg"]');
    form.find('input[type="hidden"][name="DEPTID"]').val(function() {
        return deptId ? deptId : $(this).data('init');
    });
    form.find('input[type="text"][name="txt_deptNm"]').val(function() {
        return deptNm ? deptNm : $(this).data('init');
    });

    $("#popLayerSearchDept").popup('hide');
    retrieveData();
}

/**
 * 사원 검색 popup callback
 *
 * @param pernr 사번
 * @param ename 성명
 */
function setPersInfo(pernr, ename) {

    var form = $('form[name="searchEmp"]');
    form.find('input[type="hidden"][name="PERNR"]').val(pernr);
    form.find('input[type="text"][name="I_VALUE1"]').val(ename);

    $("#popLayerSearchEmp").popup('hide');
    retrieveData();
}

function retrieveData() {

    var type = $('input[type="radio"][name="searchOption"]:checked').val(),
    form = $('form[name="search@"]'.replace(/@/, type));

    if (type === 'Org') {
        if (!form.find('input[type="hidden"][name="DEPTID"]').val().trim()) return;
    } else {
        if (!form.find('input[type="hidden"][name="PERNR"]').val().trim()) return;
    }

    var excelId = $('.tab a.selected').data('excelId');
    data = $.extend(getSearchCondition(), {I_ACTGB: excelId});

    ajaxPost(
        '/dept/getOrgRealWorkTimeData',
        data,
        function(data) {
            $.LOGGER.debug('근무 입력 현황 목록 조회 AJAX 호출', data);

            if (!data.success) {
                alert(data.message);
                return;
            }

            // 목록 rendering
            if (excelId === 'M') {
                renderMonthlyList((data.TABLES || {}).T_ORGMONT);
            } else if (excelId === 'W') {
                renderWeeklyList(data.TABLES);
            } else if (excelId === 'D') {
                renderDailyList(data.TABLES);
            } else {
                alert('알 수 없는 parameter!');
            }
        },
        function(data) {
            $.LOGGER.debug('근무 입력 현황 목록 조회 AJAX 호출 오류', data);

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

    // 연, 월 combo option 생성
    var thisYear = moment().year(), thisMonth = moment().month();
    $('select[name="year"]').html($.map(new Array(thisYear - 2018 + 1), function(v, i) {
        return '<option value="@"%>@</option>'.replace(/@/g, i + 2018).replace(/%/, thisYear === (i + 2018) ? ' selected="selected"' : '');
    })).change(retrieveData);
    $('select[name="month"]').html($.map(new Array(12), function(v, i) {
        return '<option value="@"%>@</option>'.replace(/@/g, String.lpad(i + 1, 2, '0')).replace(/%/, thisMonth === i ? ' selected="selected"' : '');
    })).change(retrieveData);

    $.fetchOrgehData();
    $.bindSearchEmpHandler();
    $.bindSearchOrgInTreeHandler();
    $.bindButtonSearchDeptHandler();
    $.bindIncludeSubOrgCheckboxHandler();
    $.bindEmpNameKeydownHandler();
    $.bindDeptNameKeydownHandler();

    // 검색 옵션 radio click event handler
    $('input[type="radio"][name="searchOption"]').click(function() {

        var v = $(this).val();
        $('div[data-name="search@Wrapper"]'.replace(/@/, v)).show().siblings().hide();
        $('.tableComment.data-org').css('visibility', v === 'Org' ? 'visible' : 'hidden');
    });

    // jobid combo change event handler
    $('form[name="searchEmp"] select[name="jobid"]').change(function() {

        $('form[name="searchEmp"] input[type="text"][name="I_VALUE1"]').focus();
    });

    $('ul.tab a[id$="Tab"]').click(function() {
        switchTabs(this, this.id);
        retrieveData();
    });

    $('a[data-name="excelDownload"]').click(function(e) {

        $('form[name="excelDownload"]')
            .html($.map($.extend(getSearchCondition(), {I_ACTGB: $('.tab a.selected').data('excelId')}), function(v, k) {
                return String.concat('<input type="hidden" name="', k, '" value="', v, '" />').toString();
            }))
            .submit();
    });

    $('#modalDialog').draggable().popup({
        transition: null
    });

    $(document)
        .on('click', 'a[data-pernr]', function() {
            popupDialog($(this));
        })
        .on('mouseover', 'tbody tr', function() {
            var tr = $(this), tbody = tr.parent(), div = tr.parents('div.date-spread');
            if (div.is('.frozen')) {
                $('div.date-spread.scroll tbody tr').eq(tr.index()).addClass('hover');
            } else {
                $('div.date-spread.frozen tbody tr').eq(tr.index()).addClass('hover');
            }
        })
        .on('mouseout', 'tbody tr', function() {
            var tr = $(this), tbody = tr.parent(), div = tr.parents('div.date-spread');
            if (div.is('.frozen')) {
                $('div.date-spread.scroll tbody tr').eq(tr.index()).removeClass('hover');
            } else {
                $('div.date-spread.frozen tbody tr').eq(tr.index()).removeClass('hover');
            }
        });

    setDeptID();
});
</script>