'use strict';

moment.locale('ko');

var POPUP,
LoadingImage = {
    ON: true,
    OFF: false,
    show: function() {
        $('body').loader('show', '<img style="width:50px;height:50px" src="/web-resource/images/img_loading.gif">');
    },
    hide: function() {
        $('body').loader('hide');
    }
},
Format = {
    DATE: 'YYYY.MM.DD' // Format.DATE
};

/**
 * 날짜 문자열과 시간 문자열을 입력받아 moment 객체로 반환
 * 
 * @param date YYYYMMDD - 연월일
 * @param time HHmm[ss] - 시분초
 * @param deformat boolean - delimiter 제거 여부
 * @returns
 */
function getMoment(date, time, deformat) {

    return moment([deformat ? String.deformat(date) : date, deformat ? String.deformat(time) : time].join(' '), 'YYYYMMDD HHmm');
}

/**
 * jQuery.post 호출 공통 function
 * 
 * @param url 대상 URL
 * @param form JSON or form id
 * @param done callback function
 * @param fail callback function
 * @param loading block layer 출력 여부, default: true
 * @param async 비동기식 동작 여부, default: true
 * @returns jQuery XHR object
 */
function ajaxPost(url, form, done, fail, loading, async) {

    loading = (typeof loading === 'undefined' || loading);

    if (loading) LoadingImage.show();

    var params = (form && typeof form === 'string') ? $('#' + form).serialize() : form;

    return $.ajax({
        url: url,
        type: 'POST',
        data: params,
        dataType: 'json',
        async: (typeof async === 'undefined' || async),
        success: function(data) {
            if (typeof console !== 'undefined' && typeof console.log === 'function') console.log(data);

            try {
                if (data.code === 'error') {
                    if (fail) fail(data);
                    else alert(data.msg || 'Connection error!');
                } else {
                    if (done) done(data);
                }
            } catch(e) {
                if (typeof console !== 'undefined' && typeof console.log === 'function') console.log(e);
            }
        }
    }).fail(function(e) {
        if (typeof console !== 'undefined' && typeof console.log === 'function') console.log(e);

        try {
            if (e.status == 401) { // session timeout
                location.href = '/';
                return;
            }

            var o = JSON.parse(e.responseText);
            alert(o.message || 'Connection error!');
        } catch (ex) {
            var msg = e.responseText;
            alert($.trim(msg) ? msg : 'Connection error!');
        }

    }).always(function() {
        if (loading) LoadingImage.hide();

    });
}

/**
 * AJAX 호출 결과 형태 변환 및 function 추가
 * 
 * @param data
 * @returns
 */
function getRfcResult(data) {

    data = data || {};

    if (data.success) {
        data.warning = ((data.EXPORT || {}).E_RETURN || {}).MSGTY === 'W'
        if (data.warning) {
            data.message = ((data.EXPORT || {}).E_RETURN || {}).MSGTX;
        }
    }

    return data;
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

    var options = {
         u: o.url
        ,d: o.data || {}
        ,n: o.name || 'win'
        ,w: o.width || 550
        ,h: o.height || 450
        ,t: o.target || null
    },
    hiddenHTML = '<input type="hidden" name="#" value="#" />',
    formHTML = [
        '<form',
        ' id="popupPostForm"',
        ' action="#"'.replace(/#/, String.escapeXml(options.u)),
        ' target="#"'.replace(/#/, String.escapeXml(options.n)),
        ' method="POST"',
        ' style="margin:0; padding:0">'
    ];

    if (typeof options.d === 'object') {
        $.each(options.d, function(k, v) {
            formHTML.push(hiddenHTML.replace(/#/, String.escapeXml(k)).replace(/#/, String.escapeXml(v)));
        });
    } else if (typeof options.d === 'string') {
        $.each(options.d.split('&'), function(i, s) {
            var pair = s.split('=');
            formHTML.push(hiddenHTML.replace(/#/, String.escapeXml(pair[0])).replace(/#/, String.escapeXml(pair[1])));
        });
    }
    formHTML.push('</form>');

    $('form#popupPostForm').remove();

    var f = $(formHTML.join('')).appendTo('body'),
    specs = $.extend({
        top: 100, // (screen.height / 2) - (options.h / 2),
        left: (screen.width / 2) - (options.w / 2),
        width: options.w,
        height: options.h,
        status: 'no',
        menubar: 'no',
        toolbar: 'no',
        location: 'no',
        resizable: 'no',
        scrollbars: 'yes',
        directories: 'no'
    }, o.specs || {});

    POPUP = window.open('', options.n, $.param(specs).replace(/&/g, ','));

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