<%--/******************************************************************************/
/*                                                                                */
/*   System Name  : MSS                                                           */
/*   1Depth Name  : MY HR 정보                                                    */
/*   2Depth Name  : 초과근무  사후신청                                            */
/*   Program Name : 초과근무  사후신청                                            */
/*   Program ID   : D01OTAfterWorkBuild_KR.jsp                                    */
/*   Description  : 초과근무(OT/특근) 사후근로를 신청을 하는 화면                 */
/*   Note         :                                                               */
/*   Creation     : 2018-05-15    Kang     [WorkTime52]    주52시간 근로시간 단축 대응 PJT */
/*   Update       :                                                               */
/*                                                                                */
/**********************************************************************************/--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="org.apache.commons.lang.ObjectUtils" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%
    // browser에서 CSS를 caching하지 못하도록 처리하기 위한 변수
    request.setAttribute("noCache", "?" + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(java.util.Calendar.getInstance().getTime()));

    WebUserData user = (WebUserData) session.getAttribute("user");
    String jobid = (String) request.getAttribute("jobid");
    String PERNR = (String) request.getAttribute("PERNR");
    String PRECHECK = (String) request.getAttribute("PRECHECK");    //초과근무 전일근태 체크 가능 여부
    Vector D01OTData_vt = (Vector) request.getAttribute("D01OTData_vt");
    D01OTData data = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

    //[CSR ID:2803878] 초과근무
    String sum = null;
    String OTDTMonth = null;
    String person_flag = null;

    Vector SubmitData_vt = (Vector) request.getAttribute("submitData_vt");
    if (SubmitData_vt != null) {
        sum = SubmitData_vt.get(1).toString();
        // 소수점 둘째자리에서 반올림
        sum = DataUtil.banolim(sum, 1);
        person_flag = SubmitData_vt.get(2).toString();
        OTDTMonth = SubmitData_vt.get(4).toString();
    }

    // 결재의뢰 점검메시지처리를 위해 Servlet에서 넘어온 메세지
    String message = ObjectUtils.toString(request.getAttribute("message"), "");

    // 2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
    String E_RRDAT = new GetTimmoRFC().GetTimmo(user.companyCode);
    long D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT, "-"));

    PersonData PERNR_Data = (PersonData) request.getAttribute("PersonData");

    //[WorkTime52] --------------------------------------------------------------------------
    String TPGUB = (String) request.getAttribute("TPGUB");
    String EMPGUB = (String) request.getAttribute("EMPGUB");
    String R_DATUM = (String) request.getAttribute("DATUM");
    //[WorkTime52] --------------------------------------------------------------------------

    //CSR ID:1546748
    String DATUM = DataUtil.getCurrentDate();

    Vector D03VocationAReason_vt = new D03VocationAReasonRFC().getSubtyCode(user.companyCode, data.PERNR, "2005", DATUM);
    Vector newOpt = new Vector();
    for (int i = 0; i < D03VocationAReason_vt.size(); i++) {
        D03VocationReasonData old_data = (D03VocationReasonData) D03VocationAReason_vt.get(i);
        CodeEntity code_data = new CodeEntity();
        code_data.code = old_data.SCODE;
        code_data.value = old_data.STEXT;
        newOpt.addElement(code_data);
    }

    String Display_yn = "Y";
    // CSR ID:1279434 @v1.0 간부사원은 신청하지못한다
    if (PERNR_Data.E_PERSK.equals("11") || PERNR_Data.E_PERSK.equals("12") || PERNR_Data.E_PERSK.equals("13") || PERNR_Data.E_PERSK.equals("14") || PERNR_Data.E_PERSK.equals("21")) {
        Display_yn = "N";
    }

    //C20100812_18478 휴일근무 신청 대상자 조정 :팀장미만 신청가능
    String OTbuildYn = new D03VocationAReasonRFC().getE_OVTYN(PERNR_Data.E_BUKRS, PERNR_Data.E_PERNR, "2005", DATUM);
    String E_BTRTL = new D03VocationAReasonRFC().getE_BTRTL(PERNR_Data.E_BUKRS, PERNR_Data.E_PERNR, "2005", DATUM);
    //C20120113_33260 휴일근무,반일특근 및 체크로직 대상자GET 사무지도직(S):휴일특근,반일특근신청가능 ,전문기능(T) : 사전신청가능
    String E_PERSKG = new D03VocationAReasonRFC().getE_PERSKG(PERNR_Data.E_BUKRS, PERNR_Data.E_PERNR, "2005", DATUM);
    //C20140203_79594 일근직체크
    String shiftCheck = new D03ShiftCheckRFC().check(PERNR_Data.E_PERNR, DATUM);    //D:일근직,1:장치교대조

    //사무직의 경우 원근무자(대근시) 의 입력 field 가 조회되지 않도록 하기위한 조건
    String officerYN = "";
    if (EMPGUB.equals("S")) {
        officerYN = "N";
    } else {
        officerYN = "Y";
    }
/* [WorkTime52]
    //CSR ID:2803878 초과근무 관련 현황 조회
    String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
    Vector ovtmKongsuHour = new D02KongsuHourRFC().getOvtmHour(PERNR_Data.E_PERNR, yymm, "C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재

    String  YUNJANG = (String) Utils.indexOf(ovtmKongsuHour, 1);
    String   HTKGUN = (String) Utils.indexOf(ovtmKongsuHour, 2);
    String HYUNJANG = (String) Utils.indexOf(ovtmKongsuHour, 3);
    String    YAGAN = (String) Utils.indexOf(ovtmKongsuHour, 4);
    String    NOAPP = (String) Utils.indexOf(ovtmKongsuHour, 5);
    String    MONTH = (String) Utils.indexOf(ovtmKongsuHour, 6);

    // 소수점 둘째자리에서 반올림 banolim
    if ( YUNJANG != null &&  YUNJANG.indexOf(".") > -1)  YUNJANG = DataUtil.banolim( YUNJANG, 1);
    if (  HTKGUN != null &&   HTKGUN.indexOf(".") > -1)   HTKGUN = DataUtil.banolim(  HTKGUN, 1);
    if (HYUNJANG != null && HYUNJANG.indexOf(".") > -1) HYUNJANG = DataUtil.banolim(HYUNJANG, 1);
    if (   YAGAN != null &&    YAGAN.indexOf(".") > -1)    YAGAN = DataUtil.banolim(   YAGAN, 1);
    if (   NOAPP != null &&    NOAPP.indexOf(".") > -1)    NOAPP = DataUtil.banolim(   NOAPP, 1);

    request.setAttribute( "YUNJANG",  YUNJANG);
    request.setAttribute(  "HTKGUN",   HTKGUN);
    request.setAttribute("HYUNJANG", HYUNJANG);
    request.setAttribute(   "YAGAN",    YAGAN);
    request.setAttribute(   "NOAPP",    NOAPP);
    request.setAttribute(   "MONTH", Integer.parseInt(MONTH));
*/
    Boolean isUpdate = (Boolean) request.getAttribute("isUpdate");
    if (isUpdate == null) isUpdate = false;
%>
<c:set var="user" value="<%=user%>" />
<c:set var="data" value="<%=data%>" />
<c:set var="ename" value="<%=PERNR_Data.E_ENAME%>" />
<c:set var="PERNR" value="<%=PERNR%>" />
<c:set var="OTbuildYn" value="<%=OTbuildYn%>" />
<c:set var="shiftCheck" value="<%=shiftCheck%>" />
<c:set var="E_RRDAT" value="<%=E_RRDAT%>" />
<c:set var="D_RRDAT" value="<%=D_RRDAT%>" />
<c:set var="PERNR_Data" value="<%=PERNR_Data%>" />
<c:set var="Display_yn" value="<%=Display_yn%>" />
<c:set var="E_BTRTL" value="<%=E_BTRTL%>" />
<c:set var="E_PERSKG" value="<%=E_PERSKG%>" />
<c:set var="officerYN" value="<%=officerYN%>" />

<c:set var="D03VocationAReason_vt_size" value="<%=D03VocationAReason_vt.size()%>" />

<c:set var="PRECHECK" value="<%=PRECHECK%>" />
<c:set var="sum" value="<%=sum%>" />
<c:set var="OTDTMonth" value="<%=OTDTMonth%>" />
<c:set var="person_flag" value="<%=person_flag%>" />
<c:set var="SubmitData_vt" value="<%=SubmitData_vt%>" />
<c:set var="newOpt" value="<%=newOpt%>" />

<c:set var="isUpdate" value="<%=isUpdate%>" />

<!-- [WorkTime52] Begin -->
<c:set var="TPGUB" value="<%=TPGUB%>" />
<c:set var="EMPGUB" value="<%=EMPGUB%>" />
<!-- [WorkTime52] End -->

<tags:layout css="ui_library_approval.css, D/D01OverTime.css" script="dialog.js, moment-with-locales.min.js, moment-round.min.js,D/D-common.js">

<script language="javascript">
function msg() {

    $('input[type="text"][name="BEGUZ"]').val(function() { return addColon(this.value); });
    $('input[type="text"][name="ENDUZ"]').val(function() { return addColon(this.value); });
    $('input[type="text"][name="PBEG1"]').val(function() { return addColon(this.value); });
    $('input[type="text"][name="PEND1"]').val(function() { return addColon(this.value); });

<c:choose><c:when test='${!empty message}'>
    alert('${ message }');
</c:when><c:otherwise>
    if ('${PRECHECK}' == 'N' && '${data.VTKEN}' == 'X') {
        alert('<spring:message code="MSG.D.D01.0001" />'); // 前日 근태에 포함 체크를 해제 하시기 바랍니다.(대상아님)
    } else {
        if ('${person_flag}' == 'O' && '${EMPGUB}' == 'S') { //사무직
            if ('${TPGUB}' == 'C' || '${shiftCheck}' == '1') {
                var THISWK = Number(${WorkData.CWTOT}) + Number(${data.STDAZ}),
                WORK_DATE_MONTH = moment($('input#WORK_DATE').val(), 'YYYY.MM.DD').month() + 1;
                THISWK = THISWK.toFixed(2);	// 소수점 길이만큼만 반올림하여서 반환
                // {0}님은 금번 초과근무 신청 건을 포함하여 {1}월 총 근무시간이 {2}시간입니다.
                if (confirm('<spring:message code="MSG.D.D01.0068" arguments="${ename}" />\n<spring:message code="MSG.D.D01.0103" />'.replace(/\{1\}/, WORK_DATE_MONTH).replace(/\{2\}/, THISWK))) {
                    document.form1.OVTM12YN.value = 'N';
                    setTimeout(triggerSubmit, 500);
                }
            } else {
                // {0}님은 금번 초과근무 신청 건을 포함하여 {1}월 초과근로를 {2}시간 실시하였습니다.\n신청하시겠습니까?
                if (confirm('<spring:message code="MSG.D.D01.0066" arguments="${ename},${OTDTMonth},${sum}" />\n<spring:message code="MSG.D.D01.0103" />')) {
                    document.form1.OVTM12YN.value = 'N';
                    setTimeout(triggerSubmit, 500);
                }

            }
        }
    }
</c:otherwise></c:choose>
}

function triggerSubmit() {
    $('.-request-button').triggerHandler('click');
}

function beforeSubmit() {
    var PICKED_DATE = $('input[type="text"][name="PICKED_DATE"]');
    if (!$.trim(PICKED_DATE.val())) {
        alert('근무일을 선택하세요.');
        PICKED_DATE.focus();
        return;
    }
    if (/^\d{4}\.\d{2}\.\d{2}$/.test(PICKED_DATE)) {
        alert('근무일 형식 오류입니다.\n"#" 형식으로 입력하세요.'.replace(/#/, moment().format('YYYY.MM.DD')));
        PICKED_DATE.focus();
        return;
    }

    var radios = $('input[type="radio"]:not(:disabled)');
    if (!radios.length) {
        alert('선택하신 근무일(#)에 유효한 신청유형이 없습니다.'.replace(/#/, PICKED_DATE.val()));
        return;
    }
    if (!$('input[type="radio"]:checked').length) {
        alert('신청유형을 선택하세요.');
        return;
    }
    return copy_Entity();
}

function doCheck() {
    if (copy_Entity()) {
        document.form1.jobid.value = 'check';
        document.form1.action = '${g.servlet}hris.D.D01OT.${isUpdate ? "D01OTChangeSV" : "D01OTAfterWorkBuildSV"}?isUpdate=${isUpdate}&DATUM=' + document.form1.WORK_DATE.value;
        document.form1.method = 'post';
        document.form1.submit();
    }
}

function copy_Entity() {
    textArea_to_TextFild( document.form1.OVTM_DESC.value );
    document.form1.BEGDA.value = document.form1.BEGDA.value.replace(/[^\d]/g, '');
    return true;
}

function addSec( text ) {
    if ( text != '') {
        time = removeColon(text);
        return time + '00';
    } else {
        return '';
    }
}

function removeSec( text ) {
    if (text != '') {
        if (text.length == 6) {
            text = text.substring(0,4);
        }
    }
    return text;
}

function addColon(text) {//형식 체크후 문자형태의 시간 0000을 00:00으로 바꾼다 값이 없을시는 0을 리턴
    if ( text!= '' ) {
        if (text.length == 6) {
            text = text.substring(0, 4);
        }
        if (text.length == 4) {
            return text.substring(0, 2) + ':' + text.substring(2, 4);
        }
    } else {
        return '';
    }
}

function EnterCheck2() {
    if (event.keyCode == 13) {
//         doCheck();
    }
}

//[WorkTime52] --------------------------------------------------------------------------
function on_Change(obj, GTYPE) {

    if ('${EMPGUB}' == 'S') {        //사무직
        if( obj.value != '' && dateFormat(obj) ) {
            ajaxPost(
                getServletURL('hris.D.D01OT.D01OTAfterWorkBuildSV'),
                {
                    jobid: 'ajax',
                    I_EMPGUB: 'S',
                    GTYPE: GTYPE,
                    DATUM: removePoint(obj.value),
                    AINF_SEQN : document.form1.AINF_SEQN.value
                },
                showResponse_S,
                function(data) {
                    if (typeof console !== 'undefined' && typeof console.log === 'function') console.log('초과근무 근무일 체크 AJAX 호출', data);
                    alert(data.message || 'connection error.');
                }
            );
        }
    }
}

// 사무직
function showResponse_S(o) {

    if (o.MSGTY == 'E') {
        alert(o.MSGTX);
        $('input[type="text"][name="PICKED_DATE"]').val('');
    }

    // 근무시간 현황표
    $('#E_BASTM').text(isNaN(o.E_BASTM) ? '-' : Number(o.E_BASTM));
    $('#E_MAXTM').text(isNaN(o.E_MAXTM) ? '-' : Number(o.E_MAXTM));
    $('#E_PWDWK').text(isNaN(o.E_PWDWK) ? '-' : Number(o.E_PWDWK) + ' (' + Number(o.E_CWDWK) + ')');
    $('#E_PWEWK').text(isNaN(o.E_PWEWK) ? '-' : Number(o.E_PWEWK) + ' (' + Number(o.E_CWEWK) + ')');
    $('#E_SUMPW').text(isNaN(o.E_PWTOT) ? '-' : Number(o.E_PWTOT) + ' (' + Number(o.E_CWTOT) + ')');

    var isShown1 = o.E_ABEGUZ01 && o.E_ABEGUZ01 != '00:00:00' && o.E_AENDUZ01 && o.E_AENDUZ01 != '00:00:00',
    isShown2 = o.E_ABEGUZ02 && o.E_ABEGUZ02 != '00:00:00' && o.E_AENDUZ02 && o.E_AENDUZ02 != '00:00:00';

    $('#E_CSTDAZ').html(o.E_CSTDAZ ? o.E_CSTDAZ.replace(/\s*\(/, '<br />(') : '-'); // 실근무시간 - 업무
    $('#E_ABEGUZ01')[isShown1 ? 'show' : 'hide']().text(o.E_ABEGUZ01 ? $.trim(o.E_ABEGUZ01).replace(/:00$/, '') + ' ~ ' + $.trim(o.E_AENDUZ01).replace(/:00$/, '') : '-'); // 실근무시간 - 업무재개1
    $('#E_ABEGUZ02')[isShown2 ? 'show' : 'hide']().text(o.E_ABEGUZ02 ? $.trim(o.E_ABEGUZ02).replace(/:00$/, '') + ' ~ ' + $.trim(o.E_AENDUZ02).replace(/:00$/, '') : '-'); // 실근무시간 - 업무재개2
    $('#E_CAREWK').text(o.E_CAREWK ? (isShown1 && isShown2 ? '(' + o.E_CAREWK + ')' : o.E_CAREWK) : '-'); // 실근무시간 - 업무재개
    $('#E_CTOTAL').text(o.E_CTOTAL || '-'); // 실근무시간 - 합계
    $('#E_CRQPST').text(o.E_CRQPST || '-'); // 사후신청가능시간

    var PICKED_DATE = $('input[type="text"][name="PICKED_DATE"]').val();

    $('[type="text"][data-reset],[type="hidden"][data-reset]').val('');
    $('[type="radio"][data-reset],[type="checkbox"][data-reset]').prop('checked', false);

    // 신청유형
    // 정상초과 신청가능 flag
    if (o.E_NRFLGG == 'X') {
        $('#E_NRFLGG')
            .prop('disabled', false)
            .data((function() {
                var BEGUZ = getMoment(PICKED_DATE, o.E_BEGUZ), ENDUZ = getMoment(PICKED_DATE, o.E_ENDUZ);

                if (ENDUZ.isAfter(BEGUZ)) ENDUZ.add(1, 'days');

                if (o.E_STDAZ != o.E_NRQPST) {
                    BEGUZ = moment(ENDUZ).subtract(Number(o.E_NRQPST || 0), 'hours').round(10,'minutes');
                }

                var VTKEN = BEGUZ.isBefore(getMoment(PICKED_DATE, o.E_BEGUZ));
                return {
                    wkdat: VTKEN ? moment(PICKED_DATE, 'YYYY.MM.DD').add(1, 'days').format('YYYY.MM.DD') : PICKED_DATE,
                    vtken: VTKEN,
                    beguz: BEGUZ.format('HH:mm'),
                    enduz: ENDUZ.format('HH:mm'),
                    stdaz: o.E_NRQPST,
                    equal: o.E_STDAZ == o.E_NRQPST,
                    pdabs: o.E_STDAZ == o.E_NRQPST ? o.E_PDABS : null,
                    cpdabs: o.E_STDAZ == o.E_NRQPST ? o.E_CPDABS : null
                };
            })());
    } else {
        $('#E_NRFLGG').prop('disabled', true).removeData();
    }

    // 업무재개1 신청가능 flag
    if (o.E_R01FLG == 'X') {
        $('#E_R01FLG')
            .prop('disabled', false)
            .data((function() {
                var BEGUZ = getMoment(PICKED_DATE, o.E_ABEGUZ01), ENDUZ = getMoment(PICKED_DATE, o.E_AENDUZ01);

                if (o.E_AREWK01 != o.E_RRQPST) {
                    BEGUZ = moment(ENDUZ).subtract(Number(o.E_RRQPST || 0), 'hours').round(10,'minutes');
                }

                var VTKEN = BEGUZ.isBefore(getMoment(PICKED_DATE, o.E_BEGUZ));
                return {
                    wkdat: VTKEN ? moment(PICKED_DATE, 'YYYY.MM.DD').add(1, 'days').format('YYYY.MM.DD') : PICKED_DATE,
                    vtken: VTKEN,
                    beguz: BEGUZ.format('HH:mm'),
                    enduz: ENDUZ.format('HH:mm'),
                    stdaz: o.E_RRQPST
                };
            })());
    } else {
        $('#E_R01FLG').prop('disabled', true).removeData();
    }

    // 업무재개2 신청가능 flag
    if (o.E_R02FLG == 'X') {
        $('#E_R02FLG')
            .prop('disabled', false)
            .data((function() {
                var BEGUZ = getMoment(PICKED_DATE, o.E_ABEGUZ02), ENDUZ = getMoment(PICKED_DATE, o.E_AENDUZ02);

                if (o.E_AREWK02 != o.E_RRQPST) {
                    BEGUZ = moment(ENDUZ).subtract(Number(o.E_RRQPST || 0), 'hours').round(10,'minutes');
                }

                var VTKEN = BEGUZ.isBefore(getMoment(PICKED_DATE, o.E_BEGUZ));
                return {
                    wkdat: VTKEN ? moment(PICKED_DATE, 'YYYY.MM.DD').add(1, 'days').format('YYYY.MM.DD') : PICKED_DATE,
                    vtken: VTKEN,
                    beguz: BEGUZ.format('HH:mm'),
                    enduz: ENDUZ.format('HH:mm'),
                    stdaz: o.E_RRQPST
                };
            })());
    } else {
        $('#E_R02FLG').prop('disabled', true).removeData();
    }

    $('input[type="radio"][name="ZOVTYP"][value="${data.ZOVTYP}"]:not(:disabled)').click();

    document.form1.HOLID.value = o.E_HOLID;
    document.form1.SOLLZ.value = o.E_SOLLZ;
    document.form1.SHIFT.value = o.E_SHIFT;
}
//[WorkTime52] --------------------------------------------------------------------------

function ovtmDescClear(textarea) {
    if (!textarea.value.replace(/\s/g, '').length) {
        textarea.value = $(textarea).attr('placeholder');
    }
}

function textArea_to_TextFild(text) {
    var tmpText='';
    var tmplength = 0;
    var count = 1;
    var flag = true;

//[CSR ID:2589455] *(42) 제거 로직 추가----------------------------
    for ( var i = 0; i < text.length; i++ ){
        if(text.charCodeAt(i) != 42){
          tmpText = tmpText+text.charAt(i);
      }
    }
    text = tmpText;
    tmpText = '';
//-----------------------------------------------------------------

    for ( var i = 0; i < text.length; i++ ){
      tmplength = checkLength(tmpText);

/*    enter 키 입력시 값에 엔터키 코드(13)을 제거하기 위한 부분 추가.. 김성일 */
//    2003.04.16 << text.charCodeAt(i) != 10 >> 추가함 13과 10을 동시에 check해야함 - 김도신

      if(  Number( tmplength ) < 70 ){

          tmpText = tmpText+text.charAt(i);
          flag = true
      } else {
          flag = false;
          tmpText.trim;

            if (Number( tmplength ) >= 70) { // @v1.4
              eval('document.form1.OVTM_DESC'+count+'.value=tmpText');
              count++;
              i=i-1;
          }
          tmpText='';   //text.charAt(i);

          if( count > 4 ){
            break;
          }
      }
/*    enter 키 입력시 값에 엔터키 코드(13)을 제거하기 위한 부분 추가.. 김성일 */
   }

   if ( flag ) {
      eval('document.form1.OVTM_DESC' + count + '.value=tmpText');
   }

}

//[CSR ID:2803878] textarea 4줄 이상 입력 못하게 막음.
function areaMax(area) {

    var value = $.trim(area.value);

    if (!value) return;

//     var str = value;
//     var enter_num = 0;

//     for (var i = 0; i < str.length; i++) {
//         var ascii = str.charCodeAt(i);

//        if (ascii == 13) { // 아스키값이 13번 엔터값일때
//             enter_num++;                                       // 엔터값 count 증가
//        }
//     }

    var lines = value.split('\n');
    if (3 < lines.length) {
        alert('<spring:message code="MSG.D.D01.0006" />'); // 한 줄당 35자 총 4줄까지 작성할 수 있습니다.\n(글자 잘림이 발생할 수 있습니다.
        area.value = lines.splice(0, 4).join('\n');
        area.focus();
    }
}

//20150318 [CSR ID:2803878] 초과근무 신청화면 수정
function ovtmDescFill(obj) {
    if (obj.value.trim() == "※ 초과근무일에 수행할 업무에 대하여 상세히 기재하여 주시기 바랍니다.") {
        obj.value = "";
    }
}

// [WorkTime52]
function popupWorkTime(EmpGubun, Pernr) {
    var WorkDate = removePoint(document.form1.WORK_DATE.value);
    if (!WorkDate) {
        WorkDate = '${f:currentDate()}';//현재일자
    }

    popupView(EmpGubun, Pernr, WorkDate);
}

function popupView(EmpGubun, Pernr, WorkDate) {

    var year  = WorkDate.substring(0, 4);
    var month = WorkDate.substring(4, 6);
    var day   = WorkDate.substring(7, 10);

    if (EmpGubun == 'H' && day > 20) {
        month = Number(month) + 1;
    }
    var paramString = '?isPop=Y&PARAM_PERNR=' + Pernr + '&SEARCH_GUBUN=M&SEARCH_YEAR=' + year + '&SEARCH_MONTH=' + month;
    var theURL = '${ g.servlet}hris.D.D25WorkTime.D25WorkTimeReportSV' + paramString;
    var retData = showModalDialog(theURL, window, 'location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:1200px;dialogHeight:700px');
}

// 처음 load
$(function() {

    <c:if test="${!isUpdate}">parent.resizeIframe(document.body.scrollHeight);</c:if>

    $(document).on('click', 'input[type="radio"][name="ZOVTYP"]:not(:disabled)', function() {
        var data = $(this).data();
        $('input#WORK_DATE').val(data.wkdat);
        $('input#VTKEN').prop('checked', data.vtken);
        $('input#BEGUZ').val(data.beguz);
        $('input#ENDUZ').val(data.enduz);
        $('input#STDAZ').val(Number(data.stdaz));
        $('input[type="hidden"][name="WORK_DATE"]').val(data.wkdat.replace(/[^\d]/g, ''));
        $('input[type="hidden"][name="VTKEN"]').val(data.vtken ? 'X' : '');
        $('input[type="hidden"][name="BEGUZ"]').val(data.beguz.replace(/[^\d]/g, '') + '00');
        $('input[type="hidden"][name="ENDUZ"]').val(data.enduz.replace(/[^\d]/g, '') + '00');
        $('input[type="hidden"][name="STDAZ"]').val(Number(data.stdaz));
        if (data.equal) {
            $('div[data-name="CPDABS"]').css('display', 'inline').find('#CPDABS').text(data.cpdabs);
            $('input[type="hidden"][name="PBEG1"]').val(data.beguz.replace(/[^\d]/g, '') + '00');
            $('input[type="hidden"][name="PEND1"]').val(data.enduz.replace(/[^\d]/g, '') + '00');
            $('input[type="hidden"][name="PUNB1"]').val(Number(data.pdabs));
        } else {
            $('div[data-name="CPDABS"]').hide().find('#CPDABS').text('');
            $('input[type="hidden"][name="PBEG1"]').val('');
            $('input[type="hidden"][name="PEND1"]').val('');
            $('input[type="hidden"][name="PUNB1"]').val('');
        }
    });

    $('input[type="text"][name="PICKED_DATE"]').datepicker('option', 'numberOfMonths', 1);

    on_Change($('input[type="text"][name="PICKED_DATE"]')[0], 1);

    msg();
});
</script>

<tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_STAT_APPL" representative="true" disable="${OTbuildYn ne 'Y'}" disableApprovalLine="${OTbuildYn ne 'Y'}">

<!-- 상단 입력 테이블 시작-->
<input type="hidden" name="BEGDA" value="${isUpdate ? data.BEGDA : f:printDate(f:currentDate())}">
<input type="hidden" name="PBEG1" />
<input type="hidden" name="PEND1" />
<input type="hidden" name="PUNB1" />
<input type="hidden" name="OVTM12YN" /><!-- [CSR ID:2803878] 초과근무 신청 화면 수정 confirm 값을 yes로 하면 Y로... -->

<c:choose><c:when test="${OTbuildYn ne 'Y'}">

<div class="align_center">
    <p><spring:message code="MSG.D.D15.0211" /></p><!-- 대상자가 아닙니다. -->
</div>

</c:when><c:otherwise>

<!-- 상단 입력 테이블 시작-->
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral" style="table-layout:fixed">
            <colgroup>
                <col style="width:15%" />
                <col />
                <col style="width:525px" />
            </colgroup>
            <tbody>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D01.0121" /><!-- 근무일 --></th>
                    <td colspan="2">
                        <input type="text" name="PICKED_DATE" class="date datetime-yyyymmdd" style="margin-right:5px"
                            placeholder="<spring:message code='LABEL.D.D01.0001' />" onchange="on_Change(this, 2)"
                            value="${isUpdate ? (f:printDate(data.VTKEN eq 'X' ? f:addDays(fn:replace(fn:replace(data.WORK_DATE, '-', ''), '.', ''), -1) : data.WORK_DATE)) : f:printDate(param.PICKED_DATE)}" />
                        <c:if test='${ user.companyCode eq "C100" }'><!--  LG화학 -->
                        <span class="commentOne" style="margin-top:3px; margin-left:6px; display:block">초과근무 사후신청은 발생 이후 3근무일 이내에 신청 및 결재를 완료하여 주시기 바랍니다.</span>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D25.0039" /><!-- 실근무시간 --></th>
                    <td colspan="2">
                        <table class="infoTable real-worktime-info">
                            <colgroup>
                                <col style="width:50px" />
                                <col style="width:110px" />
                                <col style="width:80px" />
                                <col style="width:110px" />
                                <col style="width:50px" />
                                <col style="width:110px" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>업무</th>
                                    <td><span id="E_CSTDAZ"></span></td>
                                    <th>업무재개</th>
                                    <td>
                                        <div id="E_ABEGUZ01"></div>
                                        <div id="E_ABEGUZ02" style="display:none"></div>
                                        <div id="E_CAREWK"></div>
                                    </td>
                                    <th>합계</th>
                                    <td><span id="E_CTOTAL"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D01.0113" /><!-- 사후신청가능시간 --></th>
                    <td>
                        <span id="E_CRQPST" style="font-weight:bold"></span>
                    </td>
                    <td rowspan="6" style="box-sizing:border-box; padding:15px">
                        <div class="commentImportant real-worktime-list">
                            <table class="infoTable">
                                <colgroup>
                                    <col style="width: 60px" />
                                    <col style="width:100px" />
                                    <col style="width:125px" />
                                    <col style="width:180px" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th colspan="4" class="lastCol"><spring:message code="LABEL.D.D01.0022" /><!-- 초과근무 신청 가능여부(시간)--></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th rowspan="2"><spring:message code="LABEL.D.D01.0023" /><!-- 기준 --></th>
                                        <td><spring:message code="LABEL.D.D01.0024" /><!-- 기본근무 --></td>
                                        <td><span id="E_BASTM">${f:printNum(WorkData.BASTM)}</span></td>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0034" /></td><!-- 주중 평일 x 8시간 -->
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0025" /><!-- 법정최대한도 --></td>
                                        <td><span id="E_MAXTM">${f:printNum(WorkData.MAXTM)}</span></td>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0036" /></td><!-- 달력 일수 / 7 x 52시간 -->
                                    </tr>
                                    <tr>
                                        <th rowspan="3"><spring:message code="LABEL.D.D01.0037" /><!-- 실적 --></th>
                                        <td><spring:message code="LABEL.D.D01.0038" /></td><!-- 주중근로 -->
                                        <td><span id="E_PWDWK">${f:printNum(WorkData.PWDWK)} (${f:printNum(WorkData.CWDWK)})</span><spring:message code="LABEL.D.D01.0044" /></td><!-- <sup>주)</sup> -->
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0043" /></td><!-- 유급휴가 포함 기준 -->
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0039" /></td><!-- 주말/휴일 -->
                                        <td><span id="E_PWEWK">${f:printNum(WorkData.PWEWK)} (${f:printNum(WorkData.CWEWK)})</span><spring:message code="LABEL.D.D01.0044" /></td><!-- <sup>주)</sup> -->
                                        <td class="lastCol"></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0040" /></td><!-- 계 -->
                                        <td><span id="E_SUMPW">${f:printNum(WorkData.PWTOT)} (${f:printNum(WorkData.CWTOT)})</span><spring:message code="LABEL.D.D01.0044" /></td><!-- <sup>주)</sup> -->
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0041" /></td><!-- 법정최대한도시간 초과 불가 -->
                                    </tr>
                                </tbody>
                            </table>
                            <div class="commentOne"><spring:message code="LABEL.D.D01.0042" /></div><!-- 주) 실적의 ( )안의 시간은 품의/승인을 받은 실근로시간입니다. -->
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D01.0122" /><!-- 신청유형 --></th>
                    <td>
                        <label class="for-radio"><input type="radio" name="ZOVTYP" id="E_NRFLGG" value="N0" data-reset disabled="disabled"${data.ZOVTYP eq 'N0' ? ' checked="checked"' : ''} /> <spring:message code="LABEL.D.D01.0123" /><%-- 정상초과 --%></label>
                        <label class="for-radio"><input type="radio" name="ZOVTYP" id="E_R01FLG" value="R1" data-reset disabled="disabled"${data.ZOVTYP eq 'R1' ? ' checked="checked"' : ''} /> <spring:message code="LABEL.D.D01.0124" /><%-- 업무재개1 --%></label>
                        <label class="for-radio"><input type="radio" name="ZOVTYP" id="E_R02FLG" value="R2" data-reset disabled="disabled"${data.ZOVTYP eq 'R2' ? ' checked="checked"' : ''} /> <spring:message code="LABEL.D.D01.0125" /><%-- 업무재개2 --%></label>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D01.0001" /><!-- 초과근무일 --></th>
                    <td>
                        <input type="hidden" name="WORK_DATE" value="${data.WORK_DATE}" data-reset />
                        <input type="hidden" name="VTKEN" value="${data.VTKEN}" data-reset />

                        <input type="text" id="WORK_DATE" value="${f:printDate(data.WORK_DATE)}" data-reset class="datetime-yyyymmdd" readonly="readonly" />
                        <c:if test='${ user.companyCode eq "C100" }'><!--  LG화학 -->
                        <input type="checkbox" id="VTKEN" data-reset style="margin-left:8px" disabled="disabled"${data.VTKEN eq 'X' ? ' checked="checked"' : ''} /> <spring:message code="MSG.D.D01.0051" /><!-- 前日 근태에 포함-->
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D12.0043" /><!-- 시간 --></th>
                    <td>
                        <input type="hidden" name="BEGUZ" value="${data.BEGUZ}" data-reset />
                        <input type="hidden" name="ENDUZ" value="${data.ENDUZ}" data-reset />
                        <input type="hidden" name="STDAZ" value="${data.STDAZ}" data-reset />

                        <input type="text" id="BEGUZ" value="${f:printTime(data.BEGUZ)}" data-reset class="datetime-hhmm" readonly="readonly" /> ~
                        <input type="text" id="ENDUZ" value="${f:printTime(data.ENDUZ)}" data-reset class="datetime-hhmm" readonly="readonly" />
                        <input type="text" id="STDAZ" value="${data.STDAZ}" data-reset class="datetime-hours" readonly="readonly" /><spring:message code="LABEL.D.D01.0008" /><!-- 시간 -->
                        <div data-name="CPDABS" style="margin-left:10px; display:none">
                            (<spring:message code="LABEL.D.D01.0126" /><!-- 휴게/비근무 --> <span id="CPDABS"></span>)
<%--                         <div class="commentOne"><spring:message code="MSG.D.D01.0067" /><!-- 실근무시간내에 초과근무신청 가능합니다. --></div> --%>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D15.0157" /><!-- 신청사유 --></th>
                    <td class="reason-box">
                        <table>
                            <colgroup>
                                <col style="width:170px" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td style="padding-right:8px${OTbuildYn eq 'Y' and D03VocationAReason_vt_size > 0 ? '' : '; display:none'}">
                                        <!-- CSR ID:1546748 -->
                                        <select name="OVTM_CODE" class="required">
                                           <option value="">-------------</option>
                                           ${ f:printOption(newOpt, 'code', 'value', data.OVTM_CODE) }
                                        </select>
                                    </td>
                                    <td>
                                        <input type="text" name="REASON" class="required" value="${data.REASON}"
                                            placeholder="<spring:message code='LABEL.D.D15.0157' />" onkeypress="EnterCheck2();">
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D01.0003" /><!-- 상세업무일정 --></th>
                    <td class="work-detail-box">
                        <input type="hidden" name="OVTM_DESC1" />
                        <input type="hidden" name="OVTM_DESC2" />
                        <input type="hidden" name="OVTM_DESC3" />
                        <input type="hidden" name="OVTM_DESC4" />
<c:choose><c:when test='${empty data.OVTM_DESC1 and empty data.OVTM_DESC2 and empty data.OVTM_DESC3 and empty data.OVTM_DESC4}'>
                        <textarea name="OVTM_DESC" class="required" wrap="hard" placeholder="<spring:message code='LABEL.D.D01.0127' />"
                            onblur="ovtmDescClear(this)" onfocus="ovtmDescFill(this)" onchange="areaMax(this)">
1. 업무 수행 장소 :
2. 업무 수행 내역(상세히 기재)
    </textarea></c:when><c:otherwise>
                        <textarea name="OVTM_DESC" class="required" wrap="hard" placeholder="<spring:message code='LABEL.D.D01.0003' />"
                            onblur="ovtmDescClear(this)" onfocus="ovtmDescFill(this)" onchange="areaMax(this)">${data.OVTM_DESC1}${data.OVTM_DESC2}${data.OVTM_DESC3}${data.OVTM_DESC4}</textarea>
</c:otherwise></c:choose>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 상단 입력 테이블 끝-->

</c:otherwise></c:choose>

<input type="hidden" name="HOLID" /><!-- [WorkTime52 : 평일/공휴일 외-->
<input type="hidden" name="SOLLZ" />
<input type="hidden" name="AREWK" />
<input type="hidden" name="SHIFT" />

</tags-approval:request-layout>

</tags:layout>