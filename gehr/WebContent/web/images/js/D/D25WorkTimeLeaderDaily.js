/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderDaily.js
/*   Description  : 일별 근무 입력 현황 목록 조회 화면
/*   Note         : 
/*   Creation     : 2018-05-16 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/

function getTdHTML(days, rowData) {

    return $.map(days, function(o, i) {
        return '<td class="#">#</td>'
            .replace(/#/, i === days.length - 1 ? 'lastCol #' : '#')
            .replace(/#/, o.HOLID === 'X' ? 'holiday' : (moment(o.WKDAT.deformat(), 'YYYYMMDD').isoWeekday() >= 6 ? 'weekend' : ''))
            .replace(/#/, rowData['CDWS' + o.WDAYS] || '')
            .replace(/class=""/, '');
    }).join('');
}

function renderList(TABLES) {

    TABLES = TABLES || {};

    var list = TABLES.T_ORGDAYS || [], days = TABLES.T_TLDAYS || [], cols = [],
    ths = $.map(days, function(o, i) {
        cols.push('<col />');
        return '<th class="#">#<br />(#)</th>'
            .replace(/#/, i === days.length - 1 ? 'lastCol #' : '#')
            .replace(/#/, o.HOLID === 'X' ? 'holiday' : (moment(o.WKDAT.deformat(), 'YYYYMMDD').isoWeekday() >= 6 ? 'weekend' : ''))
            .replace(/#/, Number(o.WDAYS))
            .replace(/#/, o.WOTAG)
            .replace(/class=""/, '');
    }),
    trFrozen = [
        '<tr#>',
        '<td class="ellipsis emp-name" title="%2%"><a href="javascript:void(0)" data-pernr="%1%" data-orgeh="#" style="color:blue">%2%</a></td>',
        '<td class="ellipsis org-name" title="%3%">%3%</td>',
        '<td class="ellipsis duty-name" title="%4%">%4%</td>',
        '<td class="worktime-sum lastCol">#</td>',
        '</tr>'
    ].join(''),
    trScroll = '<tr#>%</tr>';

    $('span[data-name="empCount"]').text(list.length);

    if (!list.length) {
        $('div.frozen tbody').empty();
        $('div.scroll table').width($('div.date-spread.scroll').data('init-width'));
        $('div.scroll colgroup').html('<col />');
        $('div.scroll thead tr').html('<th class="lastCol">&nbsp;<br />&nbsp;</th>');
        $('div.scroll tbody').empty();
        $('div.date-spread.not-found-data').show();

    } else {
        $('div.scroll table').width(cols.length * 50 + 'px');
        $('div.scroll colgroup').html(cols.join(''));
        $('div.scroll thead tr').html(ths.join(''));

        // tbody rendering
        var tbodyFrozen = [],
        tbodyScroll = $.map(list, function(rowData, i) {
            var c = i === list.length - 1 ? '' : ' class="borderRow"';
            tbodyFrozen.push(trFrozen
                .replace(/#/,    c)
                .replace(/%1%/g, rowData.PERNR)
                .replace(/%2%/g, rowData.ENAME)
                .replace(/%3%/g, rowData.ORGTX)
                .replace(/%4%/g, rowData.JIKKT)
                .replace(/#/,    rowData.ORGEH)
                .replace(/#/,    rowData.CTOTDW));
            return trScroll
                .replace(/#/, c)
                .replace(/%/, getTdHTML(days, rowData));
        });

        $('div.date-spread.not-found-data').hide();
        $('div.frozen tbody').html(tbodyFrozen.join(''))
        $('div.scroll tbody').html(tbodyScroll.join(''));

    }

    $('div.frozen').parent().height(function() {
        return $(this).find('div.frozen').height() + 26;
    });
    parent.autoResize();
}

function retrieveData(o) {

    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeLeaderDataAjax'),
        $.extend(o, {I_ACTGB: 'D'}),
        function(data) {
            $.LOGGER.debug('일별 근무 입력 현황 목록 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            // 목록 rendering
            renderList(data.TABLES);

            setTimeout(parent.$.unblockUI, 500);
        },
        function(data) {
            $.LOGGER.debug('일별 근무 입력 현황 목록 조회 AJAX 호출 오류', data);

            alert(data.message || 'connection error.');

            setTimeout(parent.$.unblockUI, 500);
        },
        $.blockUI.SUPPRESS
    );
}

$(function() {
    if (!parent) {
        alert(i18n.MSG.D.D25.N0012); // 부모 프레임이 없습니다!\n\n이 화면은 부모 프레임에 저장된 정보를 참조해야합니다.
        top.window.close();
        return;
    }

//    $.LOGGER.setup({
//        enable: {
//             debug: false
//            ,info: true
//            ,error: true
//        }
//    });

    $('div.date-spread.scroll').data('init-width', function() {
        return $(this).width();
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
    $(window).resize(function() {
        $('div.date-spread.scroll').width(function() {
            var w = $(this).parent().width() - $('div.date-spread.frozen').width();
            return w < 765 ? '765px' : w + 'px';
        });
    });
    $('a[data-name="excelDownload"]').click(function(e) {
        e.preventDefault();

        $('form[name="excelDownload"]')
            .html($.map($.extend(parent.getData(), {jobid: 'excel-download'}), function(v, k) {
                return '<input type="hidden" name="' + k + '" value="' + v + '" />';
            }))
            .submit();
    });
    $(document).on('click', 'a[data-pernr]', function() {
        parent.popupDialog($(this));
        return false;
    });
    $(document).on('mouseover', 'tbody tr', function() {
        var tr = $(this), tbody = tr.parent(), div = tr.parents('div.date-spread');
        if (div.is('.frozen')) {
            $('div.date-spread.scroll tbody tr').eq(tr.index()).addClass('hover');
        } else {
            $('div.date-spread.frozen tbody tr').eq(tr.index()).addClass('hover');
        }
    });
    $(document).on('mouseout', 'tbody tr', function() {
        var tr = $(this), tbody = tr.parent(), div = tr.parents('div.date-spread');
        if (div.is('.frozen')) {
            $('div.date-spread.scroll tbody tr').eq(tr.index()).removeClass('hover');
        } else {
            $('div.date-spread.frozen tbody tr').eq(tr.index()).removeClass('hover');
        }
    });

    retrieveData(parent.getData());
});