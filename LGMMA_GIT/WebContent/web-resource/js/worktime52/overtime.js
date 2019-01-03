var OverTimeUtils = {
    /**
     * YYYY.MM.DD 형식으로 반환
     * 
     * @param date YYYY?MM?DD - 연월일 구분자 상관없음
     * @returns
     */
    getFormattedDate: function(date) {

        return !$.trim(date) ? '' : moment(date.replace(/[^\d]/g, ''), 'YYYYMMDD').format('YYYY.MM.DD');
    },
    /**
     * 날짜 문자열과 시간 문자열을 입력받아 moment 객체로 반환
     * 
     * @param date YYYY?MM?DD - 연월일 구분자 상관없음
     * @param time HH?mm?[ss] - 시분초 구분자 상관없음
     * @returns
     */
    getMoment: function(date, time) {

        return moment(date.replace(/[^\d]/g, '') + time.replace(/[^\d]/g, ''), 'YYYYMMDDHHmm');
    },
    /**
     * 시간 문자열을 입력받아 moment 객체로 반환
     * 
     * @param time HH?mm?[ss] - 시분초 구분자 상관없음
     * @returns
     */
    getMomentTime: function(time) {

        return moment(time.replace(/[^\d]/g, ''), 'HHmmss');
    },
    /**
     * 시분초 문자열을 입력받아 구분자를 삭제하고 반환
     */
    transformTime: function(time) {

        return time ? moment(time.replace(/[^\d]/g, ''), 'HHmmss').format('HHmmss') : time;
    },
    /**
     * 숫자 n을 소수점 p자리까지 내림, 소수점이 없는 경우 소수점 p자리만큼 0을 붙여서 반환
     */
    getNelim: function(n, p) {

        return nelim(n || 0, p).toFixed(p);
    },
    /**
     * arguments의 parameter들이 모두 숫자가 아니면 true 반환
     */
    areNNs: function() {

        var areNNs = true;
        $.each(Array.prototype.slice.call(arguments), function() {
            areNNs = areNNs && isNaN(this);
        });
        return areNNs;
    },
    /**
     * 숫자가 아니면 hyphen 반환
     */
    defaultNumber: function(n) {

        return isNaN(n) ? '-' : Number(n);
    }
};

function joinValues(selectors) {

    return $.map(selectors.split(','), function(v) { return $(v).val(); }).join('');
}

function isAllSelected(selectors) {

    // 시, 분 <select>가 제대로 선택되었다면 각각 2자리 숫자 값을 가지므로 4개의 <select> 값을 join 했을때 8자리 숫자가 된다.
    return /^\d{8}$/.test(joinValues(selectors));
}

function isAllSelectedOrNot(selectors) {

    var values = joinValues(selectors);

    // 시, 분 <select>가 모두 초기화 상태라면 4개의 <select> 값을 join 했을때 빈 문자가 된다.
    return /^\d{8}$/.test(values) || values === '';
}

function checkLimit() {

    return isAllSelected('#BEGUZSTDT,#BEGUZEDDT,#ENDUZSTDT,#ENDUZEDDT')       // 신청시간이 모두 선택되었고
        && isAllSelectedOrNot('#PBEG1STDT,#PBEG1EDDT,#PEND1STDT,#PEND1EDDT')  // 휴게시간1이 모두 선택되었거나 하나도 선택되지 않았거나
        && isAllSelectedOrNot('#PBEG2STDT,#PBEG2EDDT,#PEND2STDT,#PEND2EDDT'); // 휴게시간2가 모두 선택되었거나 하나도 선택되지 않았거나
}

/**
 * 실근무시간 현황표 rendering
 */
function renderRealWorktimeReport(o, wrapper) {

    wrapper = wrapper ?  (wrapper + ' ') : '';

    if (o.TPGUB === 'C') {
        var dn = OverTimeUtils.defaultNumber;

        $(wrapper + '#CBASTM').html(dn(o.BASTM));
        $(wrapper + '#CMAXTM').html(dn(o.MAXTM));
        $(wrapper + '#CPWDWK').html(OverTimeUtils.areNNs(o.CWDWK, o.PWDWK) ? '- / -' : (dn(o.CWDWK) + ' / ' + dn(o.PWDWK)));
        $(wrapper + '#CPWEWK').html(OverTimeUtils.areNNs(o.CWEWK, o.PWEWK) ? '- / -' : (dn(o.CWEWK) + ' / ' + dn(o.PWEWK)));
        $(wrapper + '#CSUMPW').html(OverTimeUtils.areNNs(o.CWTOT, o.PWTOT) ? '- / -' : (dn(o.CWTOT) + ' / ' + dn(o.PWTOT)));

    } else if (o.TPGUB === 'D') {
        $(wrapper + '[name="AVRWK"]')[o.AVRWK === 'Y' ? 'show' : 'hide']();
        $(wrapper + '[name="WAVTM"]').text(o.WAVTM || '-');
        $(wrapper + '#DPERIOD').html(o.ADJUNTTX + o.WTCATTX + o.BEGDA + o.ENDDA ? [
            '(' + (o.ADJUNTTX || ''),
            o.WTCATTX || '',
            (OverTimeUtils.getFormattedDate(o.BEGDA) || '-'),
            '~',
            (OverTimeUtils.getFormattedDate(o.ENDDA) || '-') + ')'
        ].join(' ') : '');
        $(wrapper + '#DBASTM').html(isNaN(o.BASTM) ? '-' : String.comma(Number(o.BASTM || 0)));
        $(wrapper + '#DWKCNT').html(o.WKCNTTX || '(-)');
        $(wrapper + '#DRWSUM').html(isNaN(o.RWSUM) ? '- / -' : (String.comma(nelim(o.RWSUM || 0, 1)) + ' / ' + String.comma(nelim(o.RWTOT || 0, 1))));
        $(wrapper + '#DRWWEK').html(isNaN(o.RWWEK) ? '-' : nelim(o.RWWEK || 0, 1));

    }
}

function renderAfterOvertimeData(o, wrapper) {

    wrapper = wrapper ?  (wrapper + ' ') : '';

    var vPICKED_DATE = o.RQDAT || '',
    ABEGUZ1 = $.trim(o.ABEGUZ01).replace(/:00$/, ''),
    AENDUZ1 = $.trim(o.AENDUZ01).replace(/:00$/, ''),
    ABEGUZ2 = $.trim(o.ABEGUZ02).replace(/:00$/, ''),
    AENDUZ2 = $.trim(o.AENDUZ02).replace(/:00$/, ''),
    isShown1 = (ABEGUZ1 && ABEGUZ1 != '00:00') || (AENDUZ1 && AENDUZ1 != '00:00'),
    isShown2 = (ABEGUZ2 && ABEGUZ2 != '00:00') || (AENDUZ2 && AENDUZ2 != '00:00'),
    CRQPST = o.CRQPST ? o.CRQPST.replace(/\s*\(\s*/, ',').replace(/\s*\)\s*/, '').replace(/\s*,\s*/, ',').replace(/,,/g, ',').split(',') : '-';

    //    8시간 10분 (정상초과 : 2시간 20분,업무재개1 : 2시간 10분,업무재개2 : 3시간 40분)
    // => ['8시간 10분', '정상초과 : 2시간 20분', '업무재개1 : 2시간 10분', '업무재개2 : 3시간 40분']
    // => ['정상초과 : 2시간 20분', '업무재개1 : 2시간 10분', '업무재개2 : 3시간 40분', '(8시간 10분)']
    // => '정상초과 : 2시간 20분<br />업무재개1 : 2시간 10분<br />업무재개2 : 3시간 40분<br />(8시간 10분)'
    if ($.isArray(CRQPST) && CRQPST.length) {
        CRQPST.push('(' + CRQPST.shift() + ')');
        CRQPST = CRQPST.join('<br />');
    }

    $(wrapper + '#CSTDAZ').html(o.CSTDAZ ? o.CSTDAZ.replace(/\s*\(/, '<br />(') : '-'); // 실근무시간 - 업무
    $(wrapper + '#ABEGUZ01')[isShown1 ? 'show' : 'hide']().text(isShown1 ? ABEGUZ1 + ' ~ ' + AENDUZ1 : '-'); // 실근무시간 - 업무재개1
    $(wrapper + '#ABEGUZ02')[isShown2 ? 'show' : 'hide']().text(isShown2 ? ABEGUZ2 + ' ~ ' + AENDUZ2 : '-'); // 실근무시간 - 업무재개2
    $(wrapper + '#CAREWK').text(o.CAREWK ? (isShown1 || isShown2 ? '(' + o.CAREWK + ')' : o.CAREWK) : '-'); // 실근무시간 - 업무재개
    $(wrapper + '#CTOTAL').text(o.CTOTAL || '-'); // 실근무시간 - 합계
    $(wrapper + '#CRQPST').html(CRQPST); // 사후신청 가능시간

    var oBEGUZ = OverTimeUtils.getMoment(vPICKED_DATE, o.BEGUZ);

    // 신청유형 radio 설정
    if (o.NRFLGG == 'X') { // 정상초과 신청가능 flag
        var BEGUZ = OverTimeUtils.getMoment(vPICKED_DATE, o.CNBEGUZ), VTKEN = BEGUZ.isBefore(oBEGUZ);

        $(wrapper + 'input#NRFLGG')
            .prop('disabled', false)
            .data('values', {
                wkdat: VTKEN ? moment(vPICKED_DATE, 'YYYY.MM.DD').add(1, 'days').format('YYYY.MM.DD') : vPICKED_DATE,
                vtken: VTKEN,
                beguz: BEGUZ.format('HH:mm'),
                enduz: o.CNENDUZ.replace(/:00$/, ''),
                stdaz: o.CNSTDAZ,
                equal: o.STDAZ == o.NRQPST, // 근무시간 eq 신청가능시간
                pdabs: o.STDAZ == o.NRQPST ? Number(o.PDABS || 0) : null,
                cpdabs: o.STDAZ == o.NRQPST ? o.CPDABS : null
            });
    } else {
        $(wrapper + 'input#NRFLGG').removeData('values');
    }

    if (o.R01FLG == 'X') { // 업무재개1 신청가능 flag
        var BEGUZ = OverTimeUtils.getMoment(vPICKED_DATE, o.CRBEGUZ1), VTKEN = BEGUZ.isBefore(oBEGUZ);

        $(wrapper + 'input#R01FLG')
            .prop('disabled', false)
            .data('values', {
                wkdat: VTKEN ? moment(vPICKED_DATE, 'YYYY.MM.DD').add(1, 'days').format('YYYY.MM.DD') : vPICKED_DATE,
                vtken: VTKEN,
                beguz: BEGUZ.format('HH:mm'),
                enduz: o.CRENDUZ1.replace(/:00$/, ''),
                stdaz: o.CRSTDAZ1
            });
    } else {
        $(wrapper + 'input#R01FLG').removeData('values');
    }

    if (o.R02FLG == 'X') { // 업무재개2 신청가능 flag
        var BEGUZ = OverTimeUtils.getMoment(vPICKED_DATE, o.CRBEGUZ2), VTKEN = BEGUZ.isBefore(oBEGUZ);

        $(wrapper + 'input#R02FLG')
            .prop('disabled', false)
            .data('values', {
                wkdat: VTKEN ? moment(vPICKED_DATE, 'YYYY.MM.DD').add(1, 'days').format('YYYY.MM.DD') : vPICKED_DATE,
                vtken: VTKEN,
                beguz: BEGUZ.format('HH:mm'),
                enduz: o.CRENDUZ2.replace(/:00$/, ''),
                stdaz: o.CRSTDAZ2
            });
    } else {
        $(wrapper + 'input#R02FLG').removeData('values');
    }
}

function setZOVTYPClickEvent(wrapper) {

    wrapper = wrapper ?  (wrapper + ' ') : '';

    $(document).on('click', wrapper + 'input[type="radio"][name="ZOVTYP"]:not(:disabled)', function() {
        var data = $(this).data('values');
        $(wrapper + 'input[name="WORK_DATE"]').val(data.wkdat);
        $(wrapper + 'input[name="VTKEN"]').prop('checked', data.vtken);
        $(wrapper + 'input[name="BEGUZ"]').val(data.beguz);
        $(wrapper + 'input[name="ENDUZ"]').val(data.enduz);
        $(wrapper + 'input[name="STDAZ"]').val(OverTimeUtils.getNelim(data.stdaz, 2));
        if (data.equal) {
            $(wrapper + 'span#CPDABS').text(data.cpdabs).parent().css('display', 'inline');
        } else {
            $(wrapper + 'span#CPDABS').text('').parent().hide();
        }
        if (data.equal && data.pdabs > 0) {
            $(wrapper + 'input[name="PBEG1"]').val($.trim(data.beguz).replace(/[^\d]/g, '') + '00');
            $(wrapper + 'input[name="PEND1"]').val($.trim(data.enduz).replace(/[^\d]/g, '') + '00');
            $(wrapper + 'input[name="PUNB1"]').val(data.pdabs);
        } else {
            $(wrapper + 'input[name="PBEG1"]').val('');
            $(wrapper + 'input[name="PEND1"]').val('');
            $(wrapper + 'input[name="PUNB1"]').val('');
        }
    });
}

function rerenderEndHour(target) {

    var value = target.val();
    if (!value) return false;

    var limit = target.data('limit'), ENDUZSTDT = $('#ENDUZSTDT'), eHour = ENDUZSTDT.val();
    if (limit) {
        value = Number(value) + 1;

        ENDUZSTDT.html('<option value="">--</option>')
            .append($.map(new Array(limit + 1), function(v, i) {
                // 앞에 0을 먼저 붙이고 뒤의 숫자 2자리만 남긴다.
                // ex) 1 -> 01 -> 01, 12 -> 012 - > 12
                var hour = (('0' + ((value + i) % 24)).replace(/.*(\d{2})$/, '$1'));
                return '<option value="@">@</option>'.replace(/@/g, hour);
            }))
            .val(eHour);

        if (!ENDUZSTDT.find('option[value="' + eHour + '"]').length) {
            return true;
        }
    } else {
        if (ENDUZSTDT.children().length > 10) return;

        ENDUZSTDT.html('<option value="">--</option>')
            .append($.map(new Array(24), function(v, i) {
                var hour = ('0' + i).replace(/.*(\d{2})$/, '$1');
                return '<option value="@">@</option>'.replace(/@/g, hour);
            }))
            .val(eHour);
    }
    return false;
}

function checkOverTimeCallback(o) {

    var response = o.response, wrapper = o.wrapper ? (o.wrapper + ' ') : '';

    if (!response.success) {
        alert('조회시 오류가 발생하였습니다.\n\n' + response.message);
        return;
    }

    var isTypeC = response.TPGUB === 'C', isTypeD = response.TPGUB === 'D';

    /* 
     * 초과근무일이 변경된 경우 사원구분(TPGUB)에 따라 화면제어와 체크로직이 달라짐
     * TPGUB-C : 사무직-선택근무제
     * TPGUB-D : 현장직-탄력근무제
     * 
     * 1. TPGUB-C 교대조 OT 신청가능일 체크
     * 3. TPGUB-C 휴일 신청시간 8시간 제한 제어
     * 2. TPGUB-C 또는 TPGUB-D 실근무시간 현황 표시 제어
     * 4. TPGUB-C 기타 화면 제어
     */ 
    if (o.dateChanged) {
        // TPGUB-C 교대조 OT 신청가능일 체크
        if ((response.shiftData || {}).FLAG === '1') {
            $(wrapper + '#WORK_DATE').val('');
            alert('교대조 직원은 공휴일에 초과근무를 신청하실 수 없습니다.\n담당부서에 문의하시기 바랍니다.');
            return;
        }

        // TPGUB-C 휴일 신청시간 8시간 제한 제어
        var BEGUZSTDT = $(wrapper + '#BEGUZSTDT'), limit = isTypeC && !response.WKDAY;
        if (limit) {
            BEGUZSTDT.data('limit', 8); // 제한
        } else {
            BEGUZSTDT.removeData('limit'); // 해제
        }
        if (rerenderEndHour(BEGUZSTDT, limit)) {
            if (response.limitData) response.limitData.STDAZ = 0;
            if (response.breaktimeData) response.breaktimeData.E_STDAZ = 0;
        }

        // TPGUB-C 또는 TPGUB-D 실근무시간 현황 표시 제어
        var table = $(wrapper + '#otFormTable'), colgroup = table.find('> colgroup'), cols = colgroup.find('col');
        // 현황 표시
        if (isTypeC || isTypeD) {
            if (cols.length === 2) {
                colgroup.append('<col>');
                table.find('td.worktime-report')
                     .toggleClass(isTypeC ? 'type-c' : 'type-d', true)
                     .toggleClass(isTypeC ? 'type-d' : 'type-c', false)
                     .toggleClass('display-none', false);
            } else {
                table.find('td.worktime-report')
                     .toggleClass(isTypeC ? 'type-c' : 'type-d', true)
                     .toggleClass(isTypeC ? 'type-d' : 'type-c', false);
            }
            renderRealWorktimeReport(response.reportData || {}, o.wrapper);
        }
        // 현황 숨김
        else {
            if (cols.length === 3) {
                cols.last().remove();
                table.find('td.worktime-report')
                     .toggleClass('type-c', false)
                     .toggleClass('type-d', false)
                     .toggleClass('display-none', true);
            }
        }

        // TPGUB-C 기타 화면 제어
        if (isTypeC) {
            $(wrapper + '.bottom-filler').toggleClass('type-c', true).toggleClass('type-d', false);
            $(wrapper + '.type-c').show();
            $(wrapper + '#BEGUZEDDT').attr('data-mimic', '');
            $(wrapper + '#ENDUZEDDT').attr('data-mimic', '');
            if ($(wrapper + '#PBEG1STDT').is('select')) {
                $(wrapper + '#breaktimeTable tbody').html($(wrapper + '#cTypeCloneTemplate').html().replace(/eid/g, 'id'));
            }
        } else {
            $(wrapper + '.bottom-filler').toggleClass('type-c', false).toggleClass('type-d', isTypeD);
            $(wrapper + '.type-c').hide();
            $(wrapper + '.type-d')[isTypeD ? 'show' : 'hide']();
            $(wrapper + '#BEGUZEDDT').removeAttr('data-mimic');
            $(wrapper + '#ENDUZEDDT').removeAttr('data-mimic');
            if ($(wrapper + '#PBEG1STDT').is('input')) {
                $(wrapper + '#breaktimeTable tbody').html($(wrapper + '#oTypeCloneTemplate').html().replace(/oid/g, 'id'));
            }
        }
    }

    // 신청시간과 휴게시간이 정상적으로 입력되어 근무일정 중복 체크 및 한계결정한 경우
    if (o.isLimitCheck) {
        var limitData = response.limitData || {};
        if (limitData.FLAG === '1') {
            alert('근무일정과 중복되었습니다. 다시 신청해주십시오.');
        } else if (limitData.FLAG === '2') {
            var sHour = limitData.BEGUZ.substring(0, 2), eHour = limitData.ENDUZ.substring(0, 2);

            $(wrapper + '#BEGUZSTDT').val(Number(sHour) > 23 ? '00' : sHour);
            $(wrapper + '#BEGUZEDDT').val(limitData.BEGUZ.substring(2, 4));
            $(wrapper + '#ENDUZSTDT').val(Number(eHour) > 23 ? '00' : eHour);
            $(wrapper + '#ENDUZEDDT').val(limitData.ENDUZ.substring(2, 4));
            $(wrapper + '#STDAZ').val(Number(limitData.STDAZ || '0').toFixed(2));

            alert('근무일정과 중복되어 신청시간을 정정하였습니다.');
        }
    }

    // 사무직-선택근무제인 경우 휴게시간은 신청일자 또는 신청시간 변경시 자동 재계산
    if (isTypeC) {
        var breaktimeData = response.breaktimeData || {},
        PUNB = Number(breaktimeData.E_PUNB || '0');
        if (PUNB !== 0) {
            BEG = $.trim(breaktimeData.E_PBEG).replace(/[^\d]/g, ''),
            END = $.trim(breaktimeData.E_PEND).replace(/[^\d]/g, '');
            $(wrapper + '#PBEG1STDT').val(BEG.substring(0, 2));
            $(wrapper + '#PBEG1EDDT').val(BEG.substring(2, 4));
            $(wrapper + '#PEND1STDT').val(END.substring(0, 2));
            $(wrapper + '#PEND1EDDT').val(END.substring(2, 4));
            $(wrapper + '#PUNB1').val(PUNB);
        } else {
            $(wrapper + '#PBEG1STDT').val('');
            $(wrapper + '#PBEG1EDDT').val('');
            $(wrapper + '#PEND1STDT').val('');
            $(wrapper + '#PEND1EDDT').val('');
            $(wrapper + '#PUNB1').val('');
        }
        $(wrapper + '#STDAZ').val(Number(breaktimeData.E_STDAZ || '0').toFixed(2));
    }
}