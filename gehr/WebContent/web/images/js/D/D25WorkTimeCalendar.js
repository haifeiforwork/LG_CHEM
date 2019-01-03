/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeCalendar.js
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/

function getDateContent(rowData, isToday, iconURL) {

    var BEGUZ = rowData.BEGUZ ? moment(rowData.BEGUZ, 'HHmm').format('HH:mm') : null, CSTDAZ = humanize(rowData.CSTDAZ).replace(/-/, '');
 
    return [
        rowData.HOLID === 'X' ? ['<div class="holiday">', rowData.HDTXT, '</div>'].join('') : '',
//        rowData.SAVED === 'X' && isToday && !rowData.ENDUZ.replace(/0/g, '') && CSTDAZ ? ['<div><img src="', iconURL, '" /> ', BEGUZ, '</div>'].join('') : '',
        CSTDAZ ? '<div>#<br />#</div>'.replace(/#/, CSTDAZ).replace(/#/, rowData.WKTXT) : (rowData.SAVED === 'X' ? '<div>#</div>'.replace(/#/, rowData.WKTXT) : '')
    ].join('');
}

function getTr(rowData, template) {

    var CSTDAZ = humanize(rowData.CSTDAZ).replace(/-/, '');
    return template.replace(/%/g, rowData.WEEKS).replace(/#/, CSTDAZ ? ['<div>', CSTDAZ, '</div>'].join('') : '');
}

function renderCalendar(data) {

    if ($.isEmptyObject(data.T_WLIST)) {
        $('table.calendar tbody').html('<tr class="oddRow" data-not-found><td class="lastCol" colspan="8">' + i18n.MSG.COMMON['0004'] + '</td></tr>'); // 해당하는 데이타가 존재하지 않습니다.
        return;
    }

    var refMonth = data.refMonth,
    template = $('tbody#calendarTemplate').html(),
    iconURL = getImageURL('enter.png'),
    T_WEEKS = data.T_WEEKS || [],
    trList = [];

    $.each(data.T_WLIST || {}, function(k, rowData) {
        var YYYYMMDD = k.deformat(), thisDate = moment(YYYYMMDD, 'YYYYMMDD');
        if (thisDate.isoWeekday() === 1) { // 월요일
            trList.push(getTr(T_WEEKS[String.lpad(thisDate.isoWeek(), 2, 0)] || {}, template));
        }
        trList.push(trList.pop()
            .replace(/\sdata\-color/, rowData.SKIP === 'X' ? ' non-this-month' : '')
            .replace(/#/, YYYYMMDD)
            .replace(/#/, thisDate.date())
            .replace(/#/, getDateContent(rowData, thisDate.isSame(moment().startOf('date')), iconURL))
        );
    });

    $('table.calendar tbody')
        .html(trList.join(''))
        .find('td[data-date="#"]'.replace(/#/, moment().format('YYYYMMDD'))).addClass('today');

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
    $(document).on('click', 'td[data-date]', function() {
        var calendarHeader = parent.$('div.year-month'),
        selectedDate = String.deformat($(this).data('date')),
        selectedMonth = moment(selectedDate, 'YYYYMM'),
        calendarMonth = moment(String.deformat(calendarHeader.data('year-month')), 'YYYYMM'),
        tab = parent.$('.tab a').removeClass('selected').first().addClass('selected');

        calendarHeader.data('selected', selectedDate);
        if (selectedMonth.isSame(calendarMonth, 'month')) {
            tab.click();
        } else {
            parent.$('button#@Month'.replace(/@/, selectedMonth.isBefore(calendarMonth) ? 'prev' : 'next')).click();
        }
    });

    parent.setHeaderData(); // 근무시간 사용현황 data 표시

    renderCalendar(parent.getData()); // parent frame onload event에서 조회년월 정보로 해당 년월에 입력된 근무시간 정보를 조회하고 조회된 정보를 여기에서 참조한다.

    setTimeout(parent.$.unblockUI, 500);
});