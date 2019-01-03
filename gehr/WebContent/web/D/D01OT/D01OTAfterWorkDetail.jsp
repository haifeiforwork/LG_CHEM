<%--
/******************************************************************************/
/*
/*   System Name  : MSS
/*   1Depth Name  : MY HR 정보
/*   2Depth Name  : 초과근무 사후신청
/*   Program Name : 초과근무 사후신청 조회
/*   Program ID   : D01OTAfterWorkDetail.jsp
/*   Description  : 초과근무 사후신청 조회 및 삭제를 할 수 있도록 하는 화면
/*   Note         :
/*   Creation     : 2018-06-12  강동민/유정우
/*   Update       :
/*
/********************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="org.apache.commons.lang.ObjectUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.G.rfc.ApprovalCancelCheckRFC" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%
    // browser에서 CSS를 caching하지 못하도록 처리하기 위한 변수
    request.setAttribute("noCache", "?" + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(java.util.Calendar.getInstance().getTime()));

    WebUserData user = WebUtil.getSessionUser(request);

    String company      = user.companyCode;
    Vector D01OTData_vt = (Vector) request.getAttribute("D01OTData_vt");
    D01OTData data      = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

    // 현재 결재자 구분
    String OVTM_CDNM = "";
    if (StringUtils.isNotBlank(data.OVTM_CODE)) {
        Vector D03VocationAReason_vt = new D03VocationAReasonRFC().getSubtyCode(user.companyCode, data.PERNR, "2005", DataUtil.getCurrentDate());
        for (int i = 0; i < D03VocationAReason_vt.size(); i++) {
            D03VocationReasonData old_data = (D03VocationReasonData) D03VocationAReason_vt.get(i);
            if (data.OVTM_CODE.equals(old_data.SCODE)) {
                OVTM_CDNM = old_data.STEXT ;
            }
        }
    }

    //--start  승인시 초과근무현황 추가표기 2017/1/10 ksc
    D02KongsuHourRFC rfcH = new D02KongsuHourRFC();
    String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();

    //[CSR ID:2803878] 최종 승인 난 건들 + 현재 승인 요청 한 건의 1주 당 12시간 초과 여부 N은 넘은거, Y 는 안넘은거.
    Vector approvalData_vt = rfcH.getOvtmHour(data.PERNR, yymm, "G", data);
    // [WorkTime52]
    //Vector ovtmKongsuHour = rfcH.getOvtmHour(user.empNo,yymm,"C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재

    String sum = null;
    String OTDTMonth = null;
    String person_flag = null;
    if (approvalData_vt != null) {
        sum = approvalData_vt.get(1).toString();
        int temp_int = sum.indexOf(".");
        if (temp_int != -1) {//[CSR ID:3680148] 초과근무 삭제 요청의 건
            sum = sum.substring(0,temp_int);
        }
        person_flag = approvalData_vt.get(2).toString();
        OTDTMonth = approvalData_vt.get(4).toString();
    }

/* [WorkTime52]
// [CSR ID:2803878] 초과근무 관련 현황 조회
    Vector ovtmKongsuHour = rfcH.getOvtmHour(data.PERNR,yymm,"C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재

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
    //[CSR ID:2803878] 사무직의 경우 원근무자(대근시) 의 입력 field 가 조회되지 않도록 하기위한 조건
    String officerYN = "";
    if (user.e_persk.equals("31")||user.e_persk.equals("32")||user.e_persk.equals("33")||user.e_persk.equals("34")||user.e_persk.equals("35")||user.e_persk.equals("38")) {
        officerYN = "N";
    } else {
        officerYN = "Y";
    }

    //결재취소가능여부
    ApprovalCancelCheckRFC chkRfc = new ApprovalCancelCheckRFC();
    chkRfc.get(data.PERNR, data.AINF_SEQN);
    String chkApp = chkRfc.getReturn().MSGTY;
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

<c:set var="display" value="${AfterData.NRFLGG eq 'X' and AfterData.STDAZ eq AfterData.NRQPST ? 'inline' : 'none'}" />

<tags:layout css="ui_library_approval.css, D/D01OverTime.css" script="dialog.js, moment-with-locales.min.js, D/D-common.js">

<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
<tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_STAT_APPL" updateUrl="${g.servlet}hris.D.D01OT.D01OTAfterWorkChangeSV">

<script language="javascript">
function beforeReject() {

    $("#-accept-info").text("");
    return true;
}

/**
 * 결재승인 전 초과근무 시간 체크 [2018-07-03] ZGHR_RFC_NTM_AFTOT_AVAIL_CHECK
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
        url: getServletURL('hris.D.D01OT.D01OTAfterWorkDetailDataAjax'),
        data: {
            IMPORT: JSON.stringify({
            	I_APPR  : 'X',
                I_GTYPE : " " ,
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
        if (typeof console !== 'undefined' && typeof console.log === 'function') console.log('초과근무 사후신청 시간 한도 체크 AJAX 호출', data);

        data = getRfcResult(data);<%-- D-common.js --%>

        isOK = data.isSuccess();
        if (!isOK) alert(data.MSG);
    })
    .fail(function(data) {
        if (typeof console !== 'undefined' && typeof console.log === 'function') console.log('초과근무 사후신청 시간 한도 체크 AJAX 호출 오류', data);

        alert(data.message || 'connection error.');
    })
    .always(function() {
        $.unblockUI();
    });

    return isOK;
}

/**[worktime52] 승인전 로직 체크추가 2018-07-03
 *  관련RFC : ZGHR_RFC_NTM_AFTOT_AVAIL_CHECK
 */
function beforeAccept() {

    //[CSR ID:3608185]
    var dayCount = dayDiff(document.form1.BEGDA.value, document.form1.WORK_DATE.value);

    //[worktime52] 메세지 수정 2018-07-03
    var OT_late_text = [];
    //if (dayCount < 0) {
    //    OT_late_text.push('<spring:message code="MSG.D.D01.0061" />'); // 초과근무(휴일근무) 사후 신청 건 입니다.<br>해당자와 면담을 통해 실제 근로일 및 근무시간을 확인하시기 바라며, 향후에는  반드시 사전 신청을 통해 업무 진행될 수 있도록 안내 바랍니다.<br><br>
    //}

    var person_flag = '${person_flag}', TPGUB = '${TPGUB}';
    if (person_flag == 'O') { // 사무직
    	var THISWK = Number(${WorkData.CWTOT}) + Number(${data.STDAZ});
        OT_late_text.push(TPGUB == 'C' ?
        	'<spring:message code="MSG.D.D01.0068" arguments="${PersonData.e_ENAME},${MM}" />'.replace(/\{2\}/, THISWK): // {0}님은 금번 초과근무 신청 건을 포함하여 {1}월 총 근무시간이 {2}시간입니다.
            '<spring:message code="MSG.D.D01.0002" arguments="${PersonData.e_ENAME},${OTDTMonth},${sum}" />'); // {0}님은 금번 초과근무 신청 건을 포함하여 {1}월 휴일근로를 {2}시간 실시하였습니다.
    }

    if (${data.PERNR eq user.empNo}) {
    	OT_late_text.push('<spring:message code="MSG.D.D01.0103" />');	//신청하시겠습니까?
    }else{
    	OT_late_text.push('<spring:message code="MSG.D.D01.0059" />');	// 승인하시겠습니까?
    }
  	//[worktime52] 메세지 수정 2018-07-03

    $('#-accept-info').text(OT_late_text.join(' '));

    //return true;
    return checkOTLimit();
}


function popupWorkTime() {

       var workDate = moment('${data.WORK_DATE}'.replace(/[^\d]/g, ''), 'YYYYMMDD');

       openPopup({
        url: '${g.servlet}hris.D.D25WorkTime.D25WorkTimeReportSV',
        data: {
            isPop: 'Y',
            PARAM_PERNR: '${data.PERNR}',
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

<c:if test='${user.e_representative eq "Y"}'>

          <!--   사원검색 보여주는 부분 시작   -->
          <jsp:include page="/web/common/PersonInfo.jsp" />
          <!--   사원검색 보여주는 부분  끝    -->

</c:if>

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
                    <th><spring:message code="LABEL.D.D01.0121" /><!-- 근무일 --></th>
                    <td colspan="2">
                        <input type="text" class="datetime-yyyymmdd" readonly="readonly"
                            value="${f:printDate(data.VTKEN eq 'X' ? f:addDays(fn:replace(fn:replace(data.WORK_DATE, '-', ''), '.', ''), -1) : data.WORK_DATE)}" />
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D25.0039"/><!-- 실근무시간 --></th>
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
                                    <td>${AfterData.CSTDAZ}</td>
                                    <th>업무재개</th>
                                    <td><c:set var="isNotShown1" value="${empty fn:replace(AfterData.ABEGUZ01, '00:00:00', '') and empty fn:replace(AfterData.AENDUZ01, '00:00:00', '')}" />
                                        <c:set var="isNotShown2" value="${empty fn:replace(AfterData.ABEGUZ02, '00:00:00', '') and empty fn:replace(AfterData.AENDUZ02, '00:00:00', '')}" />
                                        <div${isNotShown1 ? ' style="display:none"' : ''}>${f:printTime(AfterData.ABEGUZ01)} ~ ${f:printTime(AfterData.AENDUZ01)}</div>
                                        <div${isNotShown2 ? ' style="display:none"' : ''}>${f:printTime(AfterData.ABEGUZ02)} ~ ${f:printTime(AfterData.AENDUZ02)}</div>
                                        <div>${!isNotShown1 or !isNotShown2 ? '(' : ''}${AfterData.CAREWK}${!isNotShown1 or !isNotShown2 ? ')' : ''}</div>
                                    </td>
                                    <th>합계</th>
                                    <td>${AfterData.CTOTAL}</td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D01.0113"/><!-- 사후신청가능시간 --></th>
                    <td>
                        <span id="E_CRQPST" style="font-weight:bold">${AfterData.CRQPST}</span>
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
                    <th><spring:message code="LABEL.D.D01.0122" /><!-- 신청유형 --></th>
                    <td>
                        <label class="for-radio"><input type="radio" value="N0" data-reset disabled="disabled"${data.ZOVTYP eq 'N0' ? ' checked="checked"' : ''} /> <spring:message code="LABEL.D.D01.0123" /><%-- 정상초과 --%></label>
                        <label class="for-radio"><input type="radio" value="R1" data-reset disabled="disabled"${data.ZOVTYP eq 'R1' ? ' checked="checked"' : ''} /> <spring:message code="LABEL.D.D01.0124" /><%-- 업무재개1 --%></label>
                        <label class="for-radio"><input type="radio" value="R2" data-reset disabled="disabled"${data.ZOVTYP eq 'R2' ? ' checked="checked"' : ''} /> <spring:message code="LABEL.D.D01.0125" /><%-- 업무재개2 --%></label>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D01.0001"/><!-- 초과근무일 --></th>
                    <td>
                        <input type="hidden" name="BEGDA" value="${fn:replace(fn:replace(data.BEGDA, '-', ''), '.', '')}" />
                        <input type="hidden" name="WORK_DATE" value="${fn:replace(fn:replace(data.WORK_DATE, '-', ''), '.', '')}" style="width:80px; text-align:center" readonly="readonly" />
                        <input type="text" value="${f:printDate(data.WORK_DATE)}" class="datetime-yyyymmdd" readonly="readonly" />

                        <c:if test='${user.companyCode eq "C100"}'><!-- LG화학 -->
                        <input type="checkbox" name="VTKEN" style="margin-left:8px" disabled="disabled"${data.VTKEN eq 'X' ? ' checked="checked"' : ''} /> <spring:message code="MSG.D.D01.0051"/><!--前日 근태에 포함-->
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D12.0043"/><!-- 시간 --></th>
                    <td>
                        <input type="hidden" name="BEGUZ" value="${data.BEGUZ}" />
                        <input type="hidden" name="ENDUZ" value="${data.ENDUZ}" />
                        <input type="hidden" name="PBEG1" />
                        <input type="hidden" name="PEND1" />
                        <input type="hidden" name="PBEG2" />
                        <input type="hidden" name="PEND2" />
                        <input type="text" value="${f:printTime(data.BEGUZ)}" class="datetime-hhmm" readonly="readonly" /> ~
                        <input type="text" value="${f:printTime(data.ENDUZ)}" class="datetime-hhmm" readonly="readonly" />
                        <input type="text" name="STDAZ" value="${f:printNum(data.STDAZ)}" class="datetime-hours" readonly="readonly" /><spring:message code="LABEL.D.D12.0043" /><!-- 시간 -->
                        <div data-name="CPDABS" style="margin-left:10px; display:${display}">
                            (<spring:message code="LABEL.D.D01.0126" /><!-- 휴게/비근무 --> <span id="CPDABS">${AfterData.CPDABS}</span>)
<%--                         <div class="commentOne"><spring:message code="MSG.D.D01.0067" /><!-- 실근무시간내에 초과근무신청 가능합니다. --></div> --%>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D15.0157"/><!-- 신청사유 --></th>
                    <td class="reason-box">
                        <table>
                            <colgroup>
                                <col style="width:auto" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td style="padding-right:8px${empty data.OVTM_CODE ? '; display:none' : ''}">${OVTM_CDNM}</td>
                                    <td><input type="text" name="REASON" value="${data.REASON}" readonly="readonly" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <!-- [CSR ID:2803878] 초과근무 수정 -->
                <tr>
                    <th><spring:message code="LABEL.D.D01.0003"/><!-- 상세업무일정 --></th>
                    <td class="work-detail-box">
                        <textarea name="OVTM_DESC" readonly="readonly" wrap="hard">${data.OVTM_DESC1}${data.OVTM_DESC2}${data.OVTM_DESC3}${data.OVTM_DESC4}</textarea>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 상단 입력 테이블 끝-->

</tags-approval:detail-layout>

<form name="form2" method="post" action="/servlet/servlet.hris.D.D01OT.D01OTCancelBuildSV">
    <input type="hidden" name="AINF_SEQN" value="${data.AINF_SEQN}" />
</form>

</tags:layout>