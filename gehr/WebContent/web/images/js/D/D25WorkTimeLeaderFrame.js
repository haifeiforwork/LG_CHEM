/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황(사무직)
/*   Program ID   : D25WorkTimeLeaderFrame.js
/*   Description  : 실근무시간 월/주/일별 조회 화면
/*   Note         : 
/*   Creation     : 2018-05-09 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/

var TAB_URL = [
    'hris.D.D25WorkTime.D25WorkTimeLeaderMonthlySV',
    'hris.D.D25WorkTime.D25WorkTimeLeaderWeeklySV',
    'hris.D.D25WorkTime.D25WorkTimeLeaderDailySV'
];

function popupDialog($anchor) {

    var o = { P_PERNR: $anchor.data('pernr'), P_ORGEH: $anchor.data('orgeh'), MSSYN: 'Y' };

    if ($('input[type="radio"][name="searchOption"]:checked').val() === 'Emp') {
        o.P_RETIR = $('form[name="searchOrg"] input[type="checkbox"][name="retir_chk"]').prop('checked') ? 'X' : '';
    }

    showModalDialog(getServletURL('hris.D.D25WorkTime.D25WorkTimeFrameSV?' + $.param(o)), this, 'location:0;scroll:1;menubar:0;status:0;help:0;dialogWidth:1100px;dialogHeight:700px');
}

/**
 * 기준년월, 부서 또는 사원 정보 반환
 * 
 * @returns
 */
function getData() {

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
 * @param deptId
 * @param deptNm
 */
function setDeptID(deptId, deptNm) {

    var form = $('form[name="searchOrg"]');
    form.find('input[type="hidden"][name="DEPTID"]').val(function() {
        return deptId ? deptId : $(this).data('init');
    });
    form.find('input[type="text"][name="txt_deptNm"]').val(function() {
        return deptNm ? deptNm : $(this).data('init');
    });
    form.find('input[type="text"][name="I_VALUE1"]').val('');

    var t = $('.tab a.selected');
    tabMove(t[0], t.index('.tab a'));
}

/**
 * @param o 
 *     부서검색 = {
 *         SPERNR: 로그인 사번
 *         EPERNR: 대상자 사번
 *         ENAME : 대상자 성명
 *         STEXT : 부서명
 *         OBJID : 부서 ID
 *         OBJTXT: 
 *     }
 *     사원검색 = {
 *         PERNR: 사번
 *         ENAME: 성명
 *         ORGTX: 부서
 *         JIKWT: 직위/직급 호칭
 *         JIKKT: 직책
 *         STLTX: 직무
 *         BTEXT: 근무지
 *         STAT2: 구분
 *     }
 */
function setPersInfo(o) {

    if ($('input[type="radio"][name="searchOption"]:checked').val() === 'Org') {
        var form = $('form[name="searchOrg"]');
        form.find('input[type="hidden"][name="DEPTID"]').val(o.OBJID);
        if (form.find('select[name="I_GBN"] option:selected').val() === 'ORGEH') {
            form.find('input[type="text"][name="txt_deptNm"]').val(o.STEXT);
        } else {
            form.find('input[type="text"][name="I_VALUE1"]').val(o.ENAME);
        }

    } else {
        var form = $('form[name="searchEmp"]');
        form.find('input[type="hidden"][name="PERNR"]').val(o.PERNR);
        form.find('input[type="text"][name="I_VALUE1"]').val(o.ENAME);

    }

    var t = $('.tab a.selected');
    tabMove(t[0], t.index('.tab a'));
}

function retrieveData() {

    var type = $('input[type="radio"][name="searchOption"]:checked').val(),
    form = $('form[name="search#"]'.replace(/#/, type));

    if (type === 'Org') {
        if (!form.find('input[type="hidden"][name="DEPTID"]').val().trim()) return;
    } else {
        if (!form.find('input[type="hidden"][name="PERNR"]').val().trim()) return;
    }

    var t = $('.tab a.selected');
    tabMove(t[0], t.index('.tab a'));
}

$(function() {
//    $.LOGGER.setup({
//        enable: {
//             debug: false
//            ,info: true
//            ,error: true
//        }
//    });

    // Landing tab 설정
    $('.tab').find('a:first').addClass('selected');

    // 연, 월 combo option 생성
    var thisYear = moment().year(), thisMonth = moment().month();
    $('select[name="year"]').html($.map(new Array(thisYear - 2018 + 1), function(v, i) {
        return '<option value="#"%>#</option>'.replace(/#/g, i + 2018).replace(/%/, thisYear === (i + 2018) ? ' selected="selected"' : '');
    })).change(retrieveData);
    $('select[name="month"]').html($.map(new Array(12), function(v, i) {
        return '<option value="#"%>#</option>'.replace(/#/g, String.lpad(i + 1, 2, '0')).replace(/%/, thisMonth === i ? ' selected="selected"' : '');
    })).change(retrieveData);

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
    // 검색 옵션 radio click event handler
    $('input[type="radio"][name="searchOption"]').click(function() {

        var v = $(this).val();
        $('div[data-name="search#Wrapper"]'.replace(/#/, v)).show().siblings().hide();
        $('div.searchOrg_ment').css('visibility', v === 'Org' ? 'visible' : 'hidden');
    });

    // 하위조직포함 click event handler
    $('form[name="searchOrg"] input[type="checkbox"][name="includeSubOrg"]').click(function() {

        var form = $('form[name="searchOrg"]');
        if (!form.find('input[type="hidden"][name="DEPTID"]').val()) return false;

        // 체크박스 선택시 자동검색
        setDeptID(form.find('input[type="hidden"][name="DEPTID"]').val(), form.find('input[type="text"][name="txt_deptNm"]').val());
    });

    // 부서명 keydown event handler
    $('form[name="searchOrg"] input[type="text"][name="txt_deptNm"],form[name="searchOrg"] input[type="text"][name="I_VALUE1"]').keydown(function(e) {

        if (e.keyCode !== 13) return;

        $('a[data-name="searchOrg"]').click();

        return false;
    });

    // 사원명 keydown event handler
    $('form[name="searchEmp"] input[type="text"][name="I_VALUE1"]').keydown(function(e) {

        if (e.keyCode !== 13) return;

        $('a[data-name="searchEmp"]').click();

        return false;
    });

    // I_GBN combo change event handler
    $('form[name="searchOrg"] select[name="I_GBN"]').change(function() {

        $('form[name="searchOrg"] input[type="text"][data-follow="' + $(this).val() + '"]').show().focus().siblings('[data-follow]').hide();
    });

    // jobid combo change event handler
    $('form[name="searchEmp"] select[name="jobid"]').change(function() {

        $('form[name="searchEmp"] input[type="text"][name="I_VALUE1"]').focus();
    });

    // 부서검색 button click event handler
    $('a[data-name="searchOrg"]').click(function() {

        var form = $('form[name="searchOrg"]'),
        I_GBN = form.find('select[name="I_GBN"] option:selected').val();
        if (I_GBN === 'ORGEH') {
            var t = form.find('input[type="text"][name="txt_deptNm"]');
            if (!t.val().trim()) {
                alert(i18n.MSG.COMMON.SEARCH.DEPT.REQUIR); // 검색할 부서명을 입력하세요.
                t.focus();
                return false;
            }

            openPopup({
                url: getJspURL('common/SearchDeptNamePop.jsp'),
                data: form.jsonize(),
                width: 500,
                height: 500
            });

        } else if (I_GBN === 'PERNR') {
            var t = form.find('input[type="text"][name="I_VALUE1"]'), v = t.val().trim();
            if (!v) {
                alert(i18n.MSG.APPROVAL.SEARCH.NAME.REQUIRED); // 검색할 부서원 성명을 입력하세요.
                t.focus();
                return false;
            }
            if (v.length < 2) {
                alert(i18n.MSG.APPROVAL.SEARCH.NAME.MIN); // 검색할 성명을 한 글자 이상 입력하세요.
                t.focus();
                return false;
            }

            openPopup({
                url: getJspURL('D/D12Rotation/SearchDeptPersonsWait_Rot.jsp'),
                data: form.jsonize(),
                width: 550,
                height: 550
            });

        }

        return false;
    });

    // 조직도로 부서찾기 button click event handler
    $('a[data-name="searchOrgInTree"]').click(function() {

        openPopup({
            url: getServletURL('hris.common.OrganListPopSV'),
            data: $('form[name="searchOrg"]').jsonize(),
            width: 400,
            height: 550
        });

        return false;
    });

    // 사원검색 button click event handler
    $('a[data-name="searchEmp"]').click(function() {

        var form = $('form[name="searchEmp"]'),
        t = form.find('input[type="text"][name="I_VALUE1"]'), v = t.val().trim();

        if ($('select[name="jobid"] option:selected').val() === 'ename') {
            if (!v) {
                alert(i18n.MSG.APPROVAL.SEARCH.NAME.REQUIRED); // 검색할 부서원 성명을 입력하세요.
                t.focus();
                return false;
            }
            if (v.length < 2) {
                alert(i18n.MSG.APPROVAL.SEARCH.NAME.MIN); // 검색할 성명을 한 글자 이상 입력하세요.
                t.focus();
                return false;
            }
        } else {
            if (!v) {
                alert(i18n.MSG.APPROVAL.SEARCH.PERNR.REQUIRED); // 검색할 부서원 사번을 입력하세요.
                t.focus();
                return false;
            }
        }

        openPopup({
            url: getJspURL('common/SearchDeptPersonsWait_T.jsp'),
            data: form.jsonize(),
            width: 800,
            height: 530
        });

        return false;
    });

    $('button#guideDownload').click(openGuide); // 제도 운영 기준 가이드, D-common.js

    $('button#faqDownload').click(openFAQ); // FAQ, D-common.js

    setDeptID();
});