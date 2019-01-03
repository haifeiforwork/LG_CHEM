/**
 * Created by manyjung on 2016-07-13.
 */

/**
 * 메뉴 이동
 * @param menuCode 연결될 메뉴코드
 * @param url url
 * @param p parnet객체
 * @param count 반복 횟수 기본 5
 */
function moveMenu(menuCode, url, p, count) {
    if(count == 0) return;

    p = p || window.parent;

    count = count || 5;

    if(p && p["moveMenuURL"]) p["moveMenuURL"](menuCode, url);
    else if(p && p.parent && p !== p.parent) moveMenu(menuCode, url, p.parent, --count);
    else return ;
};

/**
 * ajax 처리를 위한 util
 * @param _url url
 * @param _form 전송할 form id 또는 json객체
 * @param _success 성공시 실행할 callback
 * @param _fail 실패시 callback
 * @param _nonBlock ajax연동중 block 처리 여부
 */
function ajaxPost(_url, _form, _success, _fail, _nonBlock) {

    var _param = null;

    if (_form && typeof _form == "string") {
        _param = $("#" + _form).serialize();
    } else {
        _param = _form;
    }

    if (!_nonBlock) $.blockUI({message : '<img src="/web/images/viewLoading.gif" style="width: 50px;"/>'});

    $.post(_url, _param, function(data) {
        if (typeof console !== 'undefined' && typeof console.log === 'function') console.log(data);

        try {
            if (data.code == "error") {
                if (_fail) _fail(data);
                else {
                    alert(data.msg || "connection error.");
                }
            } else {
                if (_success) {
                    _success(data);
                }
            }
        } catch(e) {
            if (typeof console !== 'undefined' && typeof console.log === 'function') console.log(e);
        }
    }).error(function(e) {
        var _errorMessage = e.responseText;

        if (_.isEmpty(_errorMessage))
            alert("connection error");
        else
            alert(_errorMessage);
    }).always(function() {
        if (!_nonBlock) $.unblockUI();
    });
}

/**
 * 지정된 메소드 실행을 위한 tuil
 * @param method 메소드 명 또는 메소드 객체
 * @param defaultValue 결과 default값
 * @returns {*}
 */
function doMethod(method, defaultValue) {
    var args = doMethod.arguments;

    if(typeof(method) == "string") method = window[method];
    if(method && typeof(method) == "function") return method.apply(this, _.rest(args, 2));

    if(defaultValue != undefined) return defaultValue;
    else return true;
}

/**
 * 날짜값 여부 검증
 * @param src
 * @param isAllowEmpty
 * @returns {boolean}
 */
function checkDate(src, isAllowEmpty) {
    var dateString = src.replace(/[^\d]/g, "");

    if(isAllowEmpty && _.isEmpty(dateString)) return true;

    if(dateString.length == 8) {
        var year = dateString.substr(0,4);
        var month = dateString.substr(4,2) - 1;
        var day = dateString.substr(6,2);
        var date = new Date(year, month, day);

        return !/Invalid|NaN/.test(date) && (date.getFullYear() == year && date.getMonth() == month && date.getDate() == day);
    }

    return false;
}


/**
 * jquery 메소드 확장
 * stripVal() : 날짜, money, time 형식에서 특수문자(. , / -)등을 제거하여 가져옴
 * formatVal(value) : 해당 input 형식에 맞게 값을 변경하여 등록
 */
(function($) {
    $.fn.stripVal = function() {
        var $this = $(this);
        var rtnVal = $this.val();

        try{
            if(!_.isEmpty($this.val())) {
                if($this.hasClass("money")) {
                    rtnVal = $this.autoNumeric('get');
                } else if($this.hasClass("date") || $this.hasClass("time")) {
                    rtnVal = rtnVal.replace(/[^\d]/g, "");
                }
            }
        } catch(e) {alert(e);}

        return rtnVal;
    };

    $.fn.formatVal = function(paramVal) {
        var $this = $(this);
        if($this.hasClass("money")) {
            $this.autoNumeric('init').autoNumeric('set', paramVal);
        } else {
            $this.val(paramVal);
        }
    };

    $.fn.unloadingSubmit = function() {
        window.onbeforeunload = null;
        $(this).submit();
        setBeforeUnload();
    };

})(jQuery);


/**
 * validation reset
 * @param formID
 */
function resetValidate(formID) {
    _validator[formID].resetForm();
}

/**
 * input box masking 처리
 * @param $obj
 */
function addMaskFilter($obj, opt) {
    return new Promise(function() {
        opt = {} || opt;
        var _$moneys = $obj.find('input.money');

        _$moneys.keyfilter($.fn.keyfilter.defaults.masks['money']);
        $obj.find('input.email').keyfilter($.fn.keyfilter.defaults.masks['email']);
        $obj.find('input.number').keyfilter($.fn.keyfilter.defaults.masks['num']);

        $obj.find("input.csn").mask("999-99-99999");
        $obj.find("input.psn").mask("999999-9999999");
        $obj.find("input.date").mask("9999.99.99");
        $obj.find("input.time").mask("99:99");

        var _currency = opt.currency || window.currency;
        if(_currency == "KRW")
            _$moneys.autoNumeric({vMin: '-9999999999999999999', vMax: '9999999999999999999'}).css('textAlign', 'right');	//최대 자리수 20자리 소수점이하 0
        else
            _$moneys.autoNumeric({vMin: '-9999999999999999999.99', vMax: '9999999999999999999.99'}).css('textAlign', 'right');	//최대 자리수 20자리 소수점이하 0
    });
}

/**
 * form안에 입력값들에 validation 및 mask filter등을 추가
 * @param formID
 * @author jungjinman
 */
function setValidate(_$form) {
    addMaskFilter(_$form, {currency : window.currency});

    //form들에 validation추가
    _$form.each(function() {
        var $this = $(this);
        return new Promise(function() {

            $this.keypress(function(){
                return event.keyCode;
            });

            var _id = $this.attr('id') || _.uniqueId($this.attr('name'));
            if(_id != $this.attr('id') ) $this.attr('id', _id);

            _validator[_id]  = $this.validate({
                onsubmit: false,
                errorPlacement: function(error, element) {
                    if (typeof console !== 'undefined' && typeof console.log === 'function') console.log(error);
                },
                invalidHandler: function(form, validator) {
                    var errors = validator.numberOfInvalids();
                    if (typeof console !== 'undefined' && typeof console.log === 'function') console.log(errors);
                    if (errors) {
                        var _error = validator.errorList[0];
                        alert(_error.message.replace(/#e#/g, $(_error.element).attr("placeholder") || $.validator.messages.blankItem));
                        _error.element.focus();
                    }
                }
            });
        });

    });
}

/**
 * 달력
 * @param _$date    달력 객체
 * @param opt   달력에 추가 옵션
 * @returns {*}
 */
function addDatePicker(_$date, opt) {
    var _defaultOpt = {dateFormat : 'yy.mm.dd'};   //필요시 추가
    if(opt) _.extend(_defaultOpt, opt);
    return new Promise(function() {

        _$date.each(function() {
            var _$target = $(this);
            var _toDateId = _$target.data("toDate");
            var _fromDateId = _$target.data("fromDate");

            if (!_.isEmpty(_toDateId)) {
                $("#" + _toDateId).on("change", function () {
                    _$target.datepicker("option", "maxDate", $.datepicker.parseDate(_defaultOpt.dateFormat, $(this).val()));
                });
                _defaultOpt.maxDate = $.datepicker.parseDate("yymmdd", $("#" + _toDateId).stripVal());
            }
            if (!_.isEmpty(_fromDateId)) {
                $("#" + _fromDateId).on("change", function () {
                    _$target.datepicker("option", "minDate", $.datepicker.parseDate(_defaultOpt.dateFormat, $(this).val()));
                });
                _defaultOpt.minDate = $.datepicker.parseDate("yymmdd", $("#" + _fromDateId).stripVal());
            }

            //_$date.width(70);
            _$target.datepicker(_defaultOpt);
        });

        $('.ui-datepicker-trigger').css('margin-left', '4px');
        $('.ui-datepicker-trigger').css('vertical-align', 'middle');

    });

}

/**
 * rowspan
 * @param tbodyID
 * @param n rowspan 컬럼 위치 - 1부터 시작
 */
function rowspan(tbodyID, n, maxRow) {
    var $before = null;
    var count = 1;

    var $cols = $('#' + tbodyID + ' tr td:nth-child(' + n + ')');

    if(!maxRow) maxRow = $cols.length;

    /*var applyRowspanStyle = function($obj) {
        if(count > 1 && $obj) {
            $obj.css("background-color", "#fff");
        }
    };*/

    $cols.each(function(i) {
        if(i >= maxRow ) return false;

        var $this = $(this);
        if(i < $cols.length - 1) {
            //$this.css({"border-bottom" : "1px solid #f5f5f5", "background-color" : "#fff"});
        }

        if(i == 0) {
            $before = $this;
            count = 1;
        } else {
            if($before.text() == $this.text()) {
                $this.hide();
                count++;
                $before.attr("rowSpan", count);
            } else {
                /*applyRowspanStyle($before);*/
                $before = $this;
                count = 1;
            }
        }
    });

    //applyRowspanStyle($before);
}

/**
 * rowspan 처리 적용된 table을 원래대로 변환시 사용
 * @param tbodyID
 * @param n
 * @param maxRow
 */
function rowspanClear(tbodyID, n, maxRow) {
    var $cols = $('#' + tbodyID + ' tr td:nth-child(' + n + ')');

    if(!maxRow) maxRow = $cols.length;

    $cols.each(function(i) {
        if(i >= maxRow ) return false;

        var $this = $(this);

        $this.attr("rowSpan", 1);
        $this.show();
    });
}

/**
 * java의 sleep 동일 기능
 * @param delay
 * @returns {*}
 */
function sleep(delay) {
    return new Promise(function(resolve) {
        var start = (new Date()).getTime();
        while((new Date()).getTime() < start + delay);
        resolve();
    });
}

