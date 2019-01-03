/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderMonthly.js
/*   Description  : 월별 근무 입력 현황 목록 조회 화면
/*   Note         :
/*   Creation     : 2018-05-11 [WorkTime52] 유정우
/*   Update       :
/******************************************************************************/

function renderList(list) {

    list = list || [];

    $('span[data-name="empCount"]').text(list.length);

    if (!list.length) {
        $('table.listTable tbody').html('<tr class="oddRow"><td class="lastCol" colspan="13">' + i18n.MSG.COMMON['0004'] + '</td></tr>'); // 해당하는 데이타가 존재하지 않습니다.

    } else {
        var tr = $('tbody#trTemplate').html(), stats = {'0': 'glass', '1': 'green', '2': 'yellow', '3': 'red'};

        // tbody rendering
        $('table.listTable tbody')
        .html($.map(list, function(rowData, i) {
            return tr
                .replace(/%1%/g, rowData.PERNR) // 사번
                .replace(/%2%/g, rowData.ENAME) // 이름
                .replace(/%3%/g, rowData.ORGTX) // 소속
                .replace(/%4%/g, rowData.JIKKT) // 직책
                .replace(/#/,    rowData.ORGEH) // 소속 코드
                .replace(/#/,    humanize(rowData.CCOLWT)) // 당월근무시간(유급휴가포함)
                .replace(/#/,    humanize(rowData.CBASWT)) // 월 기본 근무시간
                .replace(/#/,    humanize(rowData.CBRMWT).replace(/^\-/, '&Delta; ').replace(/\((.*)\)(.+)$/, '$2 ($1)').replace(/\s00분/, '')) // 월 기본 근무시간 (잔여)
                .replace(/#/,    humanize(rowData.CMAXWT)) // 법정 최대 한도 근무시간
                .replace(/#/,    humanize(rowData.CMRMWT).replace(/^\-/, '&Delta; ')) // 법정 최대 한도 근무시간 (잔여)
                .replace(/#/,    humanize(rowData.CABSTD)) // 비근무
                .replace(/#/,    humanize(rowData.CAREWK)) // 업무재개
                .replace(/#/,    humanize(rowData.CRWKTM)) // 회사인정 근무시간
                .replace(/#/,    humanize(rowData.CGAPTM)) // GAP(개인 - 회사)
                .replace(/#/,    '<span class="traffic-light #">&#9899;</span>'.replace(/#/, stats[rowData.WSTATS || '0'])); // 상태
        }))
        .find('tr:nth-child(odd)').addClass('oddRow').end()
        .find('tr:last-child').addClass('lastRow');

    }

    parent.autoResize();
}

function retrieveData(o) {

    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeLeaderDataAjax'),
        $.extend(o, {I_ACTGB: 'M'}),
        function(data) {
            $.LOGGER.debug('월별 근무 입력 현황 목록 조회 AJAX 호출', data);

            data = getRfcResult(data);

            if (!data.isSuccess()) {
                alert(data.MSG);
                return;
            }

            // 목록 rendering
            renderList((data.TABLES || {}).T_ORGMONT);

            setTimeout(parent.$.unblockUI, 500);
        },
        function(data) {
            $.LOGGER.debug('월별 근무 입력 현황 목록 조회 AJAX 호출 오류', data);

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

        return false;
    });
    $(document).on('click', 'a[data-pernr]', function() {
        parent.popupDialog($(this));
        return false;
    });

    retrieveData(parent.getData());
});