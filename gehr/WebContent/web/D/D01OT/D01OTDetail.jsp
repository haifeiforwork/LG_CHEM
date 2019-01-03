<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : MY HR 정보
/*   2Depth Name  : 초과근무
/*   Program Name : 초과근무 조회
/*   Program ID   : D01OTDetail.jsp
/*   Description  : 초과근무 조회 및 삭제를 할 수 있도록 하는 화면
/*   Note         :
/*   Creation     : 2002-01-15  박영락
/*   Update       : 2005-03-03  윤정현
/*                  [CSR ID:2803878] 초과근무 신청 Process 변경 요청
/*                  2016-09-20 통합구축 - 김승철
/*                  2018-01-29 cykim [CSR ID:3562427] G-HR 초과근로 승인자 팝업 내용 문구 수정 요청
/*                  2018-02-12 rdcamel [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청
/*                  2018-05-11 rdcamel [CSR ID:3680148] 초과근무 삭제 요청의 건
/*                  2018-05-18 [WorkTime52] 유정우 실근로시간 현황표 변경
/********************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="org.apache.commons.lang.ObjectUtils" %>

<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.G.rfc.ApprovalCancelCheckRFC" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ include file="/web/common/commonProcess.jsp" %>

<%
    // browser에서 CSS를 caching하지 못하도록 처리하기 위한 변수
    request.setAttribute("noCache", "?" + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(java.util.Calendar.getInstance().getTime()));

    WebUserData user = WebUtil.getSessionUser(request);

    String company      = user.companyCode;
    Vector D01OTData_vt = (Vector)request.getAttribute("D01OTData_vt");
    D01OTData data      = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

    // 현재 결재자 구분
    // DocumentInfo docinfo = new DocumentInfo(data.AINF_SEQN ,user.empNo);
    //int approvalStep = docinfo.getApprovalStep();

    //CSR ID:1546748
    String OVTM_CDNM = "";
    if (!data.OVTM_CODE.equals("")) {
        String DATUM = DataUtil.getCurrentDate();
        Vector D03VocationAReason_vt = new D03VocationAReasonRFC().getSubtyCode(user.companyCode, data.PERNR, "2005", DATUM);
        for (int i = 0 ; i < D03VocationAReason_vt.size(); i++) {
            D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(i);
            if (data.OVTM_CODE.equals(old_data.SCODE)) {
                OVTM_CDNM = old_data.STEXT;
            }
        }
    }

//--start  승인시 초과근무현황 추가표기 2017/1/10 ksc
    D02KongsuHourRFC rfcH = new D02KongsuHourRFC();
    String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();

    //[CSR ID:2803878] 최종 승인 난 건들 + 현재 승인 요청 한 건의 1주 당 12시간 초과 여부 N은 넘은거, Y 는 안넘은거.
    Vector approvalData_vt = rfcH.getOvtmHour(data.PERNR, yymm, "G", data);
    //Vector ovtmKongsuHour = rfcH.getOvtmHour(user.empNo,yymm,"C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재

    String sum = null;
    String OTDTMonth = null;
    String person_flag = null;
    if (approvalData_vt != null) {
        sum = approvalData_vt.get(1).toString();
        int temp_int = sum.indexOf(".");
        if (temp_int != -1) { // [CSR ID:3680148] 초과근무 삭제 요청의 건
            sum = sum.substring(0,temp_int);
        }
        person_flag = approvalData_vt.get(2).toString();
        OTDTMonth = approvalData_vt.get(4).toString();
    }
//---end  승인시 초과근무현황 추가표기 2017/1/10 ksc

    // [CSR ID:2803878] 초과근무 관련 현황 조회
    if (!"C".equals(ObjectUtils.toString(request.getAttribute("TPGUB")))
     && !("D".equals(ObjectUtils.toString(request.getAttribute("TPGUB"))) && !user.empNo.equals(data.PERNR))) {
        Vector ovtmKongsuHour = rfcH.getOvtmHour(data.PERNR, yymm, "C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재

        String  YUNJANG = (String) Utils.indexOf(ovtmKongsuHour, 1);
        String   HTKGUN = (String) Utils.indexOf(ovtmKongsuHour, 2);
        String HYUNJANG = (String) Utils.indexOf(ovtmKongsuHour, 3);
        String    YAGAN = (String) Utils.indexOf(ovtmKongsuHour, 4);
        String    NOAPP = (String) Utils.indexOf(ovtmKongsuHour, 5);
        String    MONTH = (String) Utils.indexOf(ovtmKongsuHour, 6);

        //  [CSR ID:2803878] 초과근문 수정 (월 받아오기/소수점 처리)
        if ( YUNJANG != null &&  YUNJANG.indexOf(".") > -1 )  YUNJANG = DataUtil.banolim( YUNJANG, 1);
        if (  HTKGUN != null &&   HTKGUN.indexOf(".") > -1 )   HTKGUN = DataUtil.banolim(  HTKGUN, 1);
        if (HYUNJANG != null && HYUNJANG.indexOf(".") > -1 ) HYUNJANG = DataUtil.banolim(HYUNJANG, 1);
        if (   YAGAN != null &&    YAGAN.indexOf(".") > -1 )    YAGAN = DataUtil.banolim(   YAGAN, 1);
        if (   NOAPP != null &&    NOAPP.indexOf(".") > -1 )    NOAPP = DataUtil.banolim(   NOAPP, 1);

        request.setAttribute( "YUNJANG",  YUNJANG);
        request.setAttribute(  "HTKGUN",   HTKGUN);
        request.setAttribute("HYUNJANG", HYUNJANG);
        request.setAttribute(   "YAGAN",    YAGAN);
        request.setAttribute(   "NOAPP",    NOAPP);
        request.setAttribute(   "MONTH", Integer.parseInt(MONTH));
    }

    //[CSR ID:2803878] 사무직의 경우 원근무자(대근시) 의 입력 field 가 조회되지 않도록 하기위한 조건
    String officerYN = "";
    if (user.e_persk.equals("31") || user.e_persk.equals("32") || user.e_persk.equals("33")
     || user.e_persk.equals("34") || user.e_persk.equals("35") || user.e_persk.equals("38")) {
        officerYN = "N";
    } else {
        officerYN = "Y";
    }

    //결재취소가능여부
    ApprovalCancelCheckRFC chkRfc = new ApprovalCancelCheckRFC();
    chkRfc.get2(data.PERNR, data.AINF_SEQN);
    String chkApp = chkRfc.getReturn().MSGTY;
    Vector vt = new Vector();
%>

<c:set var="user" value="<%=user%>" />
<c:set var="data" value="<%=data%>" />
<c:set var="officerYN" value="<%=officerYN%>" />

<c:set var="OVTM_CDNM" value="<%=OVTM_CDNM%>" />
<c:set var="chkApp" value="<%=chkApp%>" />
<c:set var="I_APGUB" value="<%=request.getAttribute("I_APGUB")%>" /><%-- '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서 --%>

<c:set var="sum" value="<%=sum%>" />
<c:set var="OTDTMonth" value="<%=OTDTMonth%>" />
<c:set var="person_flag" value="<%=person_flag%>" />
<c:set var="isDeputy" value="${ (data.OVTM_CODE eq '01' and officerYN eq 'N') or !empty data.OVTM_NAME }" />

<c:set var="curdate" value="<%=DataUtil.getCurrentDate()%>" />

<tags:layout css="ui_library_approval.css, D/D01OverTime.css" script="dialog.js, moment-with-locales.min.js, D/D-common.js">

<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
<tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_STAT_APPL" updateUrl="${g.servlet}hris.D.D01OT.D01OTChangeSV">

<script language="javascript">
$(function() {
    if (${data.PERNR eq user.empNo and chkApp eq "Y" and I_APGUB eq "3" and approvalHeader.AFSTAT eq "03"}) {
        $('.btn_crud').prepend([
            '<li><a class="darken" href="javascript:appCancel()">',
            '<span><spring:message code="BUTTON.COMMON.APPRCANCELREQ" /></span>',<%-- 결재취소요청 --%>
            '</a></li>&nbsp;'
        ].join(''));
    }
<%--
    //WorkTime52 : 신청자가 초과근무 신청문서 수정시, 초과근무일이 오늘일자보다 이전이면 수정할수없게 수정버튼 숨김.
    if (${data.PERNR eq user.empNo and I_APGUB eq "2" and fn:join(fn:split(data.WORK_DATE,'-'), '') < curdate }) {
        $('.btn_crud').each(function() {
            $(this).find('li').eq(0).hide();
        });
    }
--%>
});

/**
 * 결재승인 전 초과근무 시간 체크 : ZGHR_RFC_NTM_OT_AVAL_CHK_ADD
 */
function checkOTLimit() {

    $.blockUI({message : '<img src="/web/images/viewLoading.gif" style="width:50px" />'});

    var isOK = false, form = $('#form1'),
    PERNR = form.find('input[type="hidden"][name="PERNR"]');

    if (!PERNR.length) form.append('<input type="hidden" name="PERNR" value="${data.PERNR}" />');

    form.find('input[name="WORK_DATE"]').val(function() {
        return $.trim(this.value).replace(/[^\d]/g, '');
    });

    $.post({
        url: getServletURL('hris.D.D01OT.D01OTDetailDataAjax'),
        data: {
            IMPORT: JSON.stringify({
                I_APPR: 'X',
                I_APERNR: '${user.empNo}'
            }),
            TABLES: JSON.stringify({
                T_RESULT: [form.jsonize()]
            })
        },
        dataType: 'json',
        async: false
    })
    .done(function(data) {
        if (typeof console !== 'undefined' && typeof console.log === 'function') console.log('초과근무 시간 한도 체크 AJAX 호출', data);

        data = getRfcResult(data);<%-- D-common.js --%>

        isOK = data.isSuccess();
        if (data.MSG) alert(data.MSG);
    })
    .fail(function(data) {
        if (typeof console !== 'undefined' && typeof console.log === 'function') console.log('초과근무 시간 한도 체크 AJAX 호출 오류', data);

        alert(data.message || 'connection error.');
    })
    .always(function() {
        $.unblockUI();
    });

    return isOK;
}

// 결재취소로직
function appCancel() {

    blockFrame();
    document.form2.submit();
}

function beforeReject() {

    $('#-accept-info').text('');
    return true;
}

function beforeAccept() {

    var OT_late_text = [], TPGUB = '${TPGUB}', person_flag = '${person_flag}';
    if (person_flag == 'O') { // 사무직
        var THISWK = Number(${CWTOT}) + Number(${data.STDAZ}), WORK_DATE_MONTH = moment($('input[name="WORK_DATE"]').val(), 'YYYY.MM.DD').month() + 1;
        THISWK = THISWK.toFixed(2);	// 소수점 길이만큼만 반올림하여서 반환
        // [CSR ID:3562427] 승인결재시 문구 수정
        OT_late_text.push(TPGUB == 'C' ?
            '<spring:message code="MSG.D.D01.0068" arguments="${PersonData.e_ENAME}" />'.replace(/\{1\}/, WORK_DATE_MONTH).replace(/\{2\}/, THISWK): // {0}님은 금번 초과근무 신청 건을 포함하여 {1}월 총 근무시간이 {2}시간입니다.
            '<spring:message code="MSG.D.D01.0002" arguments="${PersonData.e_ENAME},${OTDTMonth},${sum}" />'); // {0}님은 금번 초과근무 신청 건을 포함하여 {1}월 휴일근로를 {2}시간 실시하였습니다.

    } else if (person_flag == 'P') { // 생산직
        OT_late_text.push('<spring:message code="MSG.D.D01.0003" arguments="${PersonData.e_ENAME},${sum}" />'); // {0}님은 금번 초과근무 신청 건을 포함하여 1주간 초과근로를 {1}시간 실시하였습니다.

    }

<c:choose><c:when test="${data.PERNR eq user.empNo}">
    OT_late_text.push('<spring:message code="MSG.D.D01.0103" />'); // 신청하시겠습니까?
</c:when><c:otherwise>
    OT_late_text.push('<spring:message code="MSG.D.D01.0059" />'); // 승인하시겠습니까?
</c:otherwise></c:choose>

    $('#-accept-info').text(OT_late_text.join(' '));

    return checkOTLimit();
}

function popupWorkTime() {

       var workDate = moment('${data.WORK_DATE}'.replace(/[^\d]/g, ''), 'YYYYMMDD');

       openPopup({
        url: '${g.servlet}hris.D.D25WorkTime.D25WorkTimeReportSV',
        data: {
            isPop: 'Y',
            PARAM_PERNR: '${data.PERNR}',
            PARAM_ORGTX: '${approvalHeader.ORGTX}',
            SEARCH_GUBUN: 'M',
            SEARCH_YEAR: workDate.year(),
            SEARCH_MONTH: workDate.month() + (workDate.date() > 20 ? 2 : 1)
        },
        width: 1200,
        height: 745,
        specs: {resizable: 'yes'}
    });
}
</script>

<c:if test="${user.e_representative eq 'Y'}">

<!-- 사원검색 보여주는 부분 시작 -->
<jsp:include page="/web/common/PersonInfo.jsp" />
<!-- 사원검색 보여주는 부분  끝  -->

</c:if>

<!-- 상단 입력 테이블 시작-->
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral" style="table-layout:fixed">
            <colgroup>
                <col style="width:15%" />
                <col />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th><spring:message code="LABEL.D.D01.0001" /><!-- 초과근무일--></th>
                    <td>
                        <input type="hidden" name="BEGDA" value="${ data.BEGDA }" />
                        <input type="text" name="WORK_DATE" value="${ f:printDate(data.WORK_DATE) }" class="datetime-yyyymmdd" readonly="readonly" />

                        <c:if test='${ user.companyCode eq "C100" }'><!-- LG화학 -->
                        <input type="checkbox" disabled="disabled"${ data.VTKEN eq 'X' ? ' checked="checked"' : '' } />
                        <input type="hidden" name="VTKEN" value="${ data.VTKEN }" />
                        <spring:message code="MSG.D.D01.0051" /><!--前日 근태에 포함-->
                        </c:if>

                        <!-- [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청 -->
                        <c:if test='${approvalHeader.ACCPFL eq "X" and (f:getBetween(f:removeStructur(data.BEGDA,"-"), f:removeStructur(data.WORK_DATE,"-")) < 0)}'>
                        <span class="textPink"> &nbsp; <u>사후신청 件</u></span>
                        </c:if>
                        <!-- [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청 -->
                    </td>
                    <!-- [CSR ID:2803878] 초과근무 신청 화면 수정 -->
<%-- 시작 : 2018.05.17 [WorkTime52] 유정우 - 사무직/현장직 실근로시간 현황표 변경 --%>
<c:choose><c:when test='${TPGUB eq "C"}'>
                    <td rowspan="${isDeputy ? 5 : 4}" style="box-sizing:border-box; width:525px; padding:15px">
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
                                        <th colspan="4" class="lastCol"><spring:message code="LABEL.D.D01.0031" /></th><%-- 초과근무 신청 가능여부(시간) --%>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th rowspan="2"><spring:message code="LABEL.D.D01.0032" /></th><%-- 기준 --%>
                                        <td><spring:message code="LABEL.D.D01.0033" /></td><%-- 기본근무 --%>
                                        <td>${f:printNum(BASTM)}</td>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0034" /></td><%-- 주중 평일 x 8시간 --%>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0035" /></td><%-- 법정최대한도 --%>
                                        <td>${f:printNum(MAXTM)}</td>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0036" /></td><%-- 달력 일수 / 7 x 52시간 --%>
                                    </tr>
                                    <tr>
                                        <th rowspan="3"><spring:message code="LABEL.D.D01.0037" /></th><%-- 실적 --%>
                                        <td><spring:message code="LABEL.D.D01.0038" /></td><%-- 주중근로 --%>
                                        <td>${f:printNum(PWDWK)} (${f:printNum(CWDWK)})<spring:message code="LABEL.D.D01.0044" /></td><%-- <sup>주)</sup> --%>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0043" /></td><%-- 유급휴가 포함 기준 --%>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0039" /></td><%-- 주말/휴일 --%>
                                        <td>${f:printNum(PWEWK)} (${f:printNum(CWEWK)})<spring:message code="LABEL.D.D01.0044" /></td><%-- <sup>주)</sup> --%>
                                        <td class="lastCol"></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0040" /></td><%-- 계 --%>
                                        <td>${f:printNum(PWTOT)} (${f:printNum(CWTOT)})<spring:message code="LABEL.D.D01.0044" /></td><%-- <sup>주)</sup> --%>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0041" /></td><%-- 법정최대한도시간 초과 불가 --%>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="commentOne"><spring:message code="LABEL.D.D01.0042" /></div><%-- 주) 실적의 ( )안의 시간은 품의/승인을 받은 실근로시간입니다. --%>
                        </div>
                    </td>
</c:when><c:when test='${TPGUB eq "D" and user.empNo ne data.PERNR}'>
                    <td rowspan="${isDeputy ? 5 : 4}" style="box-sizing:border-box; width:560px; padding:15px; display:none">
                        <div class="commentImportant real-worktime-list">
                            <table class="infoTable">
                                <colgroup>
                                    <col style="width: 50px" />
                                    <col style="width:140px" />
                                    <col style="width: 90px" />
                                    <col style="width:220px" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th colspan="4" class="lastCol"><spring:message code="LABEL.D.D01.0060" arguments="${ADJUNTTX},${WTCATTX},${f:printDate(BEGDA)},${f:printDate(ENDDA)}" /></th><%-- 실근로시간 현황 ({0} {1} {2} ~ {3}) --%>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th><spring:message code="LABEL.D.D01.0032" /></th><%-- 기준 --%>
                                        <td><spring:message code="LABEL.D.D01.0061" /></td><%-- 법정최대한도<br />(주 평균 52시간) --%>
                                        <td>
                                            <fmt:formatNumber var="remainder" value="${BASTM % 0.1}" />
                                            <fmt:formatNumber value="${BASTM - (remainder eq 0.1 ? 0 : remainder)}" pattern="0.0" />
                                        </td>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0062" /></td><%-- 매주 52시간 근로 가정시<br />(총 일수 ÷ 7일 × 52시간) --%>
                                    </tr>
                                    <tr>
                                        <th rowspan="2"><spring:message code="LABEL.D.D01.0063" /></th><%-- 실적 --%>
                                        <td><spring:message code="LABEL.D.D01.0064" /></td><%-- 총 근로시간 --%>
                                        <td>
                                            <fmt:formatNumber var="remainder" value="${RWSUM % 0.1}" />
                                            <fmt:formatNumber value="${RWSUM - (remainder eq 0.1 ? 0 : remainder)}" pattern="0.0" />
                                            /
                                            <fmt:formatNumber var="remainder" value="${RWTOT % 0.1}" />
                                            <fmt:formatNumber value="${RWTOT - (remainder eq 0.1 ? 0 : remainder)}" pattern="0.0" />
                                        </td>
                                        <td class="lastCol" style="word-break:keep-all"><spring:message code="LABEL.D.D01.0065" /></td><%-- 신청일 기준 누적근로시간 / 계획근로시간 --%>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0066" /></td><%-- 1주 근로시간 --%>
                                        <td>
                                            <fmt:formatNumber var="remainder" value="${RWWEK % 0.1}" />
                                            <fmt:formatNumber value="${RWWEK - (remainder eq 0.1 ? 0 : remainder)}" pattern="0.0" />
                                        </td>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0067" /></td><%-- 초과근로일이 속한 1주(월 ~ 일)의 근로시간 --%>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="commentOne"><spring:message code="LABEL.D.D01.0068" /></div><%-- 실근로시간 산정을 위해 휴게시간 및 비근무를 제외한 기준입니다. --%>
                        </div>
                    </td>
</c:when><c:otherwise>
                    <td rowspan="${isDeputy ? 5 : 4}" style="box-sizing:border-box; width:280px; padding:15px">
                        <div class="commentImportant real-worktime-list">
                            <table class="infoTable" style="width:100%">
                                <colgroup>
                                    <col style="width:50%" />
                                    <col />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <td colspan="2" class="lastCol align_center">
                                            ${MONTH}<spring:message code="LABEL.D.D01.0009" /><%-- 월 초과근무 현황 --%>
                                            <!-- [CSR ID:2803878] 초과근무 문구수정 -->
                                            <br /><spring:message code="LABEL.D.D01.0010" /><%-- (전월 21일 ~ 당월 20일 기준) --%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0011" /><%-- 평일연장 --%></td>
                                        <td class="lastCol">${YUNJANG} <spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0012" /><%-- 휴일근로 --%></td>
                                        <td class="lastCol">${HTKGUN} <spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0013" /><%-- 휴일연장 --%></td>
                                        <td class="lastCol">${HYUNJANG} <spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0014" /><%-- 야간근로 --%></td>
                                        <td class="lastCol">${YAGAN} <spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0015" /><%-- 결재 진행 중<br />초과근로 --%></td>
                                        <td class="lastCol">${NOAPP} <spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
</c:otherwise></c:choose>
<%-- 종료 : 2018.05.17 [WorkTime52] 유정우 - 사무직/현장직 실근로시간 현황표 변경 --%>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D12.0043" /><!-- 시간 --></th>
                    <td>
                        <input type="text" name="BEGUZ" value="${ f:printTime(data.BEGUZ) }" class="datetime-hhmm" readonly="readonly" />
                        ~
                        <input type="text" name="ENDUZ" value="${ f:printTime(data.ENDUZ) }" class="datetime-hhmm" readonly="readonly" />
                        <input type="text" name="STDAZ" value="${ f:printNum(data.STDAZ)  }" class="datetime-hours" readonly="readonly" />
                        <spring:message code="LABEL.D.D12.0043" /><!-- 시간 -->
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D15.0157" /><!-- 신청사유 --></th>
                    <td class="reason-box">
                        <table>
                            <colgroup><c:if test="${!empty data.OVTM_CODE}">
                                <col style="width:170px" /></c:if>
                                <col />
                            </colgroup>
                            <tbody>
                                <tr><c:if test="${!empty data.OVTM_CODE}">
                                    <td style="padding-right:8px">${empty data.OVTM_CODE ? '' :  OVTM_CDNM}</td></c:if>
                                    <td><input type="text" name="REASON" value="${data.REASON}" readonly="readonly" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>

<c:if test="${isDeputy}">
                <tr>
                    <th><spring:message code="LABEL.D.D01.0002" /><!-- 원근무자(대근시) --></th>
                    <td style="box-sizing:border-box">
                        <input type="text" name="OVTM_NAME" value="${ data.OVTM_NAME }" style="box-sizing:border-box; width:100%; max-width:none" readonly="readonly" />
                    </td>
                </tr>
</c:if>

                <!-- [CSR ID:2803878] 초과근무 수정 -->
                <tr>
                    <th><spring:message code="LABEL.D.D01.0003" /><!-- 상세업무일정 --></th>
                    <td class="work-detail-box">
                        <textarea name="OVTM_DESC" readonly="readonly" wrap="hard">${data.OVTM_DESC1}${data.OVTM_DESC2}${data.OVTM_DESC3}${data.OVTM_DESC4}</textarea>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 상단 입력 테이블 끝-->

<div class="listArea">
    <div class="table">
        <table class="listTable">
            <colGroup>
                <col style="width:15%" />
                <col style="width:21.25%" />
                <col style="width:21.25%" />
                <col style="width:21.25%" />
                <col style="width:21.25%" />
            </colGroup>
            <thead>
                <tr>
                    <th>&nbsp;</th>
                    <th><spring:message code="LABEL.D.D15.0162" /><%-- 시작시간 --%></td>
                    <th><spring:message code="LABEL.D.D15.0163" /><%-- 종료시간 --%></td>
                    <th><spring:message code="LABEL.D.D01.0004" /><%-- 무급 --%></td>
                    <th class="lastCol"><spring:message code="LABEL.D.D01.0005" /><%-- 유급 --%></td>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow">
                    <td><spring:message code="LABEL.D.D01.0006" /><%-- 휴게시간1 --%></td>
                    <td><input type="text" name="PBEG1" class="datetime-hhmm" value="${ f:printTime(data.PBEG1) }" readonly="readonly" /></td>
                    <td><input type="text" name="PEND1" class="datetime-hhmm" value="${ f:printTime(data.PEND1) }" readonly="readonly" /></td>
                    <td><input type="text" name="PUNB1" class="datetime-hours" value="${ data.PUNB1 eq '0' ? '' : f:printNum(data.PUNB1) }" readonly="readonly" /></td>
                    <td><input type="text" name="PBEZ1" class="datetime-hours" value="${ data.PBEZ1 eq '0' ? '' : f:printNum(data.PBEZ1) }" readonly="readonly" /></td>
                </tr>
                <tr>
                    <td><spring:message code="LABEL.D.D01.0007" /><%-- 휴게시간2 --%></td>
                    <td><input type="text" name="PBEG2" class="datetime-hhmm" value="${ f:printTime(data.PBEG2) }" readonly="readonly" /></td>
                    <td><input type="text" name="PEND2" class="datetime-hhmm" value="${ f:printTime(data.PEND2) }" readonly="readonly" /></td>
                    <td><input type="text" name="PUNB2" class="datetime-hours" value="${ data.PUNB2 eq '0' ? '' : f:printNum(data.PUNB2) }" readonly="readonly" /></td>
                    <td><input type="text" name="PBEZ2" class="datetime-hours" value="${ data.PBEZ2 eq '0' ? '' : f:printNum(data.PBEZ2) }" readonly="readonly" /></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

</tags-approval:detail-layout>

<form name="form2" method="post" action="/servlet/servlet.hris.D.D01OT.D01OTCancelBuildSV">
    <input type="hidden" name="AINF_SEQN" value="${data.AINF_SEQN}" />
</form>

</tags:layout>