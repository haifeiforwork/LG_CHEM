/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderWeekly.js
/*   Description  : 주별 근무 입력 현황 목록 조회 화면
/*   Note         : 
/*   Creation     : 2018-05-16 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/

function getTdHTML(length, rowData) {

    return $.map(new Array(length), function(o, i) {
        return '<td#>#</td>'.replace(/#/, i === length - 1 ? ' class="lastCol"' : '').replace(/#/, humanize(rowData['CWKS' + String.lpad(i + 1, 2, '0')]));
    }).join('');
}

function renderList(TABLES, o) {

    TABLES = TABLES || {};

    var list = TABLES.T_ORGWEEK || [], weeks = TABLES.T_TLWEEKS || [];

    $('span[data-name="empCount"]').text(list.length);

    if (!list.length) {
        $('table.listTable colgroup').html([
            '<col style="width: 90px" />',
            '<col style="width:185px" />',
            '<col style="width: 90px" />',
            '<col />'
        ].join(''));
        $('table.listTable thead').html([
            '<tr class="multi-line">',
            '<th>', i18n.LABEL.D.D25.N2172, '</th>', // 이름
            '<th>', i18n.LABEL.D.D25.N2173, '</th>', // 소속
            '<th>', i18n.LABEL.D.D25.N2174, '</th>', // 직책
            '<th class="lastCol">', i18n.LABEL.D.D25.N2116, '</th>', // 계
            '</tr>',
        ].join(''));
        $('table.listTable tbody').html('<tr class="oddRow"><td class="lastCol" colspan="4">' + i18n.MSG.COMMON['0004'] + '</td></tr>'); // 해당하는 데이타가 존재하지 않습니다.

    } else {
        var tr = $('tbody#trTemplate').html(), cols = [],
        ths = $.map(weeks, function(o, i) {
            cols.push('<col />');
            return '<th#>#<br />#</th>'.replace(/#/, i === weeks.length - 1 ? ' class="lastCol"' : '').replace(/#/, o.TWEEKS).replace(/#/, o.TPERIOD);
        });

        $('table.listTable colgroup').append(cols.join(''));
        $('table.listTable thead tr').append(ths.join(''));

        // tbody rendering
        $('table.listTable tbody')
        .html($.map(list, function(rowData, i) {
            return tr
            .replace(/%1%/g, rowData.PERNR)
            .replace(/%2%/g, rowData.ENAME)
            .replace(/%3%/g, rowData.ORGTX)
            .replace(/%4%/g, rowData.JIKKT)
            .replace(/#/,    rowData.ORGEH)
            .replace(/#/,    humanize(rowData.CTOTWKS))
            .replace(/<td>#<\/td>/i, getTdHTML(weeks.length, rowData));
        }))
        .find('tr:nth-child(odd)').addClass('oddRow').end()
        .find('tr:last-child').addClass('lastRow');

    }

    parent.autoResize();
}

function retrieveData(o) {

    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeLeaderDataAjax'),
        $.extend(o, {I_ACTGB: 'W'}),
        function(data) {
            $.LOGGER.debug('주별 근무 입력 현황 목록 조회 AJAX 호출', data);

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
            $.LOGGER.debug('주별 근무 입력 현황 목록 조회 AJAX 호출 오류', data);

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

    retrieveData(parent.getData());
});