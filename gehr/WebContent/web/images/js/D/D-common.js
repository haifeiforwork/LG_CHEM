/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 주 52시간 근무제 공통 js
/*   Program ID   : D-common.js
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-05-09 [WorkTime52] 유정우
/*   Update       : 2018-06-04 rdcamel [CSR ID:3704184] 유연근로제 동의 관련 기능 추가 건 - Global HR Portal
/******************************************************************************/

moment.locale(LOCALE);

$.blockUI.SUPPRESS = true;

var POPUP;

/**
 * 입력된 문자열에서 숫자를 제외한 모든 문자 제거
 * format이 적용된 날짜나 시간, 숫자 등의 문자열을 RFC에 입력되는 숫자만 남기는 형식으로 변환하는 용도로 사용
 * 
 * @param t YYYY-MM-DD or YYYY.MM.DD or YYYY/MM/DD
 * @returns YYYYMMDD
 */
String.deformat = function(t) {
    return $.trim(t).replace(/[^\d]/g, '');
}

String.prototype.deformat = function() {
    return String.deformat(this);
}

/**
 * iframe onload event handler
 * 
 * @returns
 */
function autoResize() {
    var t = $('iframe[name="listFrame"]')[0];
    t.height = 0;
    t.height = t.contentWindow.document.body.scrollHeight;
}

/**
 * Tab click event handler
 * 
 * @param target
 * @param tabIndex
 * @returns
 */
function tabMove(target, tabIndex) {
    setTimeout(blockFrame);

    $('.tab .selected').removeClass('selected');
    $(target).addClass('selected');

    document.all.urlForm.action = getServletURL(TAB_URL[tabIndex]); // getWaitURL(getServletURL(TAB_URL[tabIndex]))
    document.all.urlForm.submit();
}

/**
 * '##:##' 형식으로 입력된 문자열을 '##시간 ##분'의 형식으로 변환
 * 
 * @param t ##:##
 * @returns ##시간 ##분
 */
function humanize(t) {

    if (t === '-') return t;
    if (!$.trim(t).replace(/[:0]/g, '')) return '-';

    var r = t.split(':');
    return [r.length > 0 && Number(r[0]) === 0 ? '' : r[0] + i18n.LABEL.D.D25.N7001, r.length > 1 && Number(r[1]) === 0 ? '' : r[1] + i18n.LABEL.COMMON['0039']].join(' ').trim();
}

/**
 * 날짜 문자열과 시간 문자열을 입력받아 moment 객체로 반환
 * 
 * @param date YYYY?MM?DD - 연월일 구분자 상관없음
 * @param time HH?mm?[ss] - 시분초 구분자 상관없음
 * @returns
 */
function getMoment(date, time) {

    return moment([String.deformat(date), String.deformat(time)].join(' '), 'YYYYMMDD HHmm');
}

/**
 * AJAX 호출 결과 형태 변환 및 function 추가
 * 
 * @param data
 * @returns
 */
function getRfcResult(data) {

    data = data || {};

    var EXPORT = data.EXPORT || {}, TABLES = data.TABLES || {}, E_RETURN = EXPORT.E_RETURN || {};
    return {
        CODE: E_RETURN.MSGTY,
        MSG: E_RETURN.MSGTX,
        EXPORT: EXPORT,
        TABLES: TABLES,
        isSuccess: function() {
            return this.CODE === 'S' || this.CODE === 'N' || this.CODE === 'W';
        },
        isWarning: function() {
            return this.CODE === 'W';
        }
    };
}

/**
 * window.open wrapper function
 * 
 * @param o = {
 *      url    : 요청 URL
 *     ,data   : 요청 parameter
 *     ,name   : Popup창 이름
 *     ,width  : Popup창 width
 *     ,height : Popup창 height
 *     ,specs  : Popup창 옵션 = {
 *          toolbar: 'no',
 *          location: 'no',
 *          directories: 'no',
 *          status: 'no',
 *          menubar: 'no',
 *          resizable: 'no',
 *          scrollbars: 'yes'
 *      }
 * }
**/
function openPopup(o) {

    if (POPUP) POPUP.close();

    var $o = {
         u: o.url
        ,d: o.data || {}
        ,n: o.name || 'win'
        ,w: o.width || 550
        ,h: o.height || 450
        ,t: o.target || null
    };

    var hiddenHTML = '<input type="hidden" name="#" value="#" />',
    formHTML = [
        '<form',
        ' id="popupPostForm"',
        ' action="#"'.replace(/#/, $o.u),
        ' target="#"'.replace(/#/, $o.n),
        ' method="POST"',
        ' style="margin:0; padding:0">'
    ];

    if (typeof $o.d === 'object') {
        $.each($o.d, function(k, v) {
            formHTML.push(hiddenHTML.replace(/#/, k).replace(/#/, v));
        });
    } else if (typeof $o.d === 'string') {
        $.each($o.d.split('&'), function(i, s) {
            var pair = s.split('=');
            formHTML.push(hiddenHTML.replace(/#/, pair[0]).replace(/#/, pair[1]));
        });
    }
    formHTML.push('</form>');

    $('form#popupPostForm').remove();

    var f = $(formHTML.join('')).appendTo('body'),
    specs = $.extend({
        top: 100, // (screen.height / 2) - ($o.h / 2),
        left: (screen.width / 2) - ($o.w / 2),
        width: $o.w,
        height: $o.h,
        status: 'no',
        menubar: 'no',
        toolbar: 'no',
        location: 'no',
        resizable: 'no',
        scrollbars: 'yes',
        directories: 'no'
    }, o.specs || {}),
    s = $.map(specs, function(v, k) {
        return k +'='+ v;
    }).join();

    POPUP = window.open('', $o.n, s);

    if (POPUP == null) {
        f.remove();
        alert('팝업차단 기능이 실행되고있습니다.\n차단 해제후 다시 실행해 주시기 바랍니다.');
        return false;
    } else {
        f.submit();
        POPUP.focus();
        return false;
    }
}

function openGuide(e) {

    e.preventDefault();

    // 제도 운영 기준 가이드
    openPopup({
        url: 'http://165.244.240.220/ezpdf/customLayout.jsp',
        data: {
            encdata: [
                'A93E52F12A02628A37981FD61D55CEC26A2E11AC5C3D9B73F69691C63254A02FA1A837AAA061CC65D436B0F7A1D5F05F8EF4D8AE',
                '739EF6BC931C9B69F8310A5BDAA793670AD3693D6D123E8CF79D71363C8D0222C6DE3023BD3F095182F210DB5B00F5FD41B0997C'
            ].join('')
        },
        width: 1100,
        height: 760
    });
    return false;
}

function openFAQ(e) {

    e.preventDefault();

    // FAQ
    openPopup({
        url: 'http://165.244.240.220/ezpdf/customLayout.jsp',
        data: {
            encdata: [
                'A93E52F12A02628A37981FD61D55CEC26A2E11AC5C3D9B73F69691C63254A02FA1A837AAA061CC65D436B0F7A1D5F05F13CBB1F8',
                'B16F28C3FDFCB8F0C11B40DEDAA793670AD3693D6D123E8CF79D71360C248FEB6450C609BD3F095182F210DB5B00F5FD41B0997C'
            ].join('')
        },
        width: 1100,
        height: 760
    });
    return false;
}

$.fn.extend({
    /**
     * jQuery.serialize()의 변형, 대상 form의 field를 모두 검색하여 아래와 같은 형태로 반환
     * 
     * @return [
     *     {name: '', value: ''},
     *     {name: '', value: ''},
     *     ...
     * ]
     */
    prejsonize: function() {
        return this.map(function() {
            // Can add propHook for 'elements' to filter or add form elements
            var elements = $.prop(this, 'elements');
            return elements ? $.makeArray(elements) : this;
        })
        .filter(function() {
            var rsubmitterTypes = /^(?:submit|button|image|reset|file)$/i,
                rsubmittable = /^(?:input|select|textarea|keygen)/i,
                manipulation_rcheckableType = /^(?:checkbox|radio)$/i;
            var type = this.type;
            // Use .is(':disabled') so that fieldset[disabled] works
            return this.name && !$(this).is(':disabled') &&
                rsubmittable.test(this.nodeName) && !rsubmitterTypes.test(type) &&
                (this.checked || !manipulation_rcheckableType.test(type));
        })
        .map(function(i, elem) {
            var rCRLF = /\r?\n/g;
            var val = (elem.type === 'select-multiple') ?
                $(this).children('option').map(function(i, o) { return o.value; }).get().join() :
                    (elem.type === 'text' && $(this).hasClass('cal')) ? $(this).val().replace(/-/g, '') : $(this).val();

            return val == null ?
                null :
                $.isArray(val) ?
                    $.map(val, function(val) {
                        return { name: elem.name, value: val.replace(rCRLF, '\r\n') };
                    }) :
                    { name: elem.name, value: val.replace(rCRLF, '\r\n') };
        }).get();
    },
    /**
     * jQuery.serialize()의 변형, 대상 form의 field를 모두 검색하여 아래와 같은 형태로 반환
     * 
     * @return {
     *     name: value,
     *     name: value,
     *     ...
     * }
     */
    jsonize: function() {
        var d = {};
        $.each(this.prejsonize(), function(i, o) {
            d[o.name] = o.value;
        });
        return d;
    },
    /**
     * jQuery.param()의 synonym, 대상 form의 field를 모두 검색하여 URL query string으로 변환하여 반환
     * 
     * @return 'name=value&name=value...'
     */
    parameterize: function() {
        return $.param(this.prejsonize());
    }
});


/**
 * 2018-06-04 rdcamel [CSR ID:3704184] 유연근로제 동의 관련 기능 추가 건 - Global HR Portal
 */
function policyAgree(param) {

	var url = '/web/D/D25WorkTime/D25WorkTimePolicyAgree.jsp' + (param == 'N' ? '?agreeYN=N' : '');
	window.open(url, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,scrollbars=yes,width=1120,height=680,left=100,top=100');
}

function workTimeAgreeSave() {

    ajaxPost(
        getServletURL('hris.D.D25WorkTime.D25WorkTimeFrameSV'),
        {
            jobid: 'save'
        },
        function(data) {
            $.LOGGER.debug('AJAX 호출', data);

            if (data) {
                alert('동의 완료 되었습니다.');
                window.close();
            }
        },
        function(data) {
            $.LOGGER.debug('AJAX 호출 오류', data);

            alert(data.message || 'connection error.');
        }
    );
}