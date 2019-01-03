<%
    /********************************************************************************/
    /*                                                                              */
    /*   System Name  : e-HR                                                        */
    /*   1Depth Name  : HR 결재                                                     */
    /*   2Depth Name  : 결재 해야 할 문서                                           */
    /*   Program Name : 초과근무 결재 완료 취소 신청                                */
    /*   Program ID   : D01OTCancelBuild.jsp                                        */
    /*   Description  : 초과근무 결재 완료                                          */
    /*   Note         : 없음                                                        */
    /*   Creation     : 2003-03-28 이승희                                           */
    /*   Update       : 2003-03-28 이승희                                           */
    /*                  2015-06-18 [CSR ID:2803878] 초과근무 신청 Process 변경 요청 */
    /*                  2016-12-12 gehr 김승철                                      */
    /*                                                                              */
    /********************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" errorPage="/web/err/error.jsp" %>
<%@ page import="java.util.Vector"%>
<%@ page import="org.apache.commons.lang.ObjectUtils"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>

<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.D.D01OT.*"%>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="hris.common.util.*"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.D.D03Vocation.*"%>
<%@ page import="hris.D.D03Vocation.rfc.*"%>
<%@ page import="hris.D.rfc.*"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval"%>

<%@ include file="/web/common/commonProcess.jsp" %>
<%
    // browser에서 CSS를 caching하지 못하도록 처리하기 위한 변수
    request.setAttribute("noCache", "?" + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(java.util.Calendar.getInstance().getTime()));

    WebUserData user = WebUtil.getSessionUser(request);
    D01OTData d01OTData = (D01OTData) request.getAttribute("d01OTData");
    String jobid = ObjectUtils.toString(request.getAttribute("jobid"));

    // Vector vcAppLineData = (Vector)request.getAttribute("vcAppLineData");

    boolean isCanGoList = StringUtils.isNotBlank(ObjectUtils.toString(request.getAttribute("RequestPageName")));

    // CSR ID:1546748
    String OVTM_CDNM = "";
    if (!StringUtils.isNotBlank(d01OTData.OVTM_CODE)) {
        Vector D03VocationAReason_vt = new D03VocationAReasonRFC().getSubtyCode(user.companyCode, d01OTData.PERNR, "2005", d01OTData.BEGDA);
        for (int i = 0; i < D03VocationAReason_vt.size(); i++) {
            D03VocationReasonData old_data = (D03VocationReasonData) D03VocationAReason_vt.get(i);
            if (d01OTData.OVTM_CODE.equals(old_data.SCODE)) {
                OVTM_CDNM = old_data.STEXT;
            }
        }
    }

    /* 결제정보를 vector로 받는다 */
    // Vector AppLineData_vt = (Vector) request.getAttribute("AppLineData_vt");

    if (!"C".equals(ObjectUtils.toString(request.getAttribute("TPGUB")))
     && !("D".equals(ObjectUtils.toString(request.getAttribute("TPGUB"))) && !user.empNo.equals(d01OTData.PERNR))) {
        // [CSR ID:2803878] 초과근무 관련 현황 조회
        D02KongsuHourRFC rfcH = new D02KongsuHourRFC();
        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
        Vector ovtmKongsuHour = rfcH.getOvtmHour(user.empNo, yymm, "C"); //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재

        String  YUNJANG = (String) Utils.indexOf(ovtmKongsuHour, 1);
        String   HTKGUN = (String) Utils.indexOf(ovtmKongsuHour, 2);
        String HYUNJANG = (String) Utils.indexOf(ovtmKongsuHour, 3);
        String    YAGAN = (String) Utils.indexOf(ovtmKongsuHour, 4);
        String    NOAPP = (String) Utils.indexOf(ovtmKongsuHour, 5);
        String    MONTH = (String) Utils.indexOf(ovtmKongsuHour, 6);

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
    }

    //[CSR ID:2803878] 사무직의 경우 원근무자(대근시) 의 입력 field 가 조회되지 않도록 하기위한 조건
    String officerYN = "";
    if (user.e_persk.equals("31") || user.e_persk.equals("32") || user.e_persk.equals("33")
     || user.e_persk.equals("34") || user.e_persk.equals("35") || user.e_persk.equals("38")) {
        officerYN = "N";
    } else {
        officerYN = "Y";
    }
%>
<c:set var="user" value="<%=user%>" />
<c:set var="d01OTData" value="<%=d01OTData%>" />
<c:set var="OVTM_CDNM" value="<%=OVTM_CDNM%>" />
<c:set var="officerYN" value="<%=officerYN%>" />

<c:set var="isUpdate" value="<%=request.getAttribute("isUpdate")%>" />
<c:set var="isDeputy" value="${ (d01OTData.OVTM_CODE eq '01' and officerYN eq 'N') or !empty d01OTData.OVTM_NAME }" />

<tags:layout css="ui_library_approval.css, D/D01OverTime.css" script="moment-with-locales.min.js, D/D-common.js">

<script language="javascript">
$(function() {
    $(".-request-button").html('<span><spring:message code="BUTTON.COMMON.APPRCANCELREQ"/></span>');<%-- 결재취소요청 --%>
    $(".btn_crud").append("&nbsp;<li><a href='javascript:history.back();'><span><spring:message code='BUTTON.COMMON.CANCEL'/></span></a></li>");
});

function aftersave() {
    if (document.form1.jobid.value == "create") {
        opener.goToList();
        window.close();
    }
}

// 취소사유입력
function bfCheck() {
    if (document.form1.CANC_REASON.value == "") {
        alert("<spring:message code='MSG.D.D01.0056' />"); // 취소사유를 입력하세요.
        return false;
    }
    return true;
}

// 결재취소로직
function beforeSubmit() {
    if (!bfCheck()) return false;

    // if (!confirm("<spring:message code='MSG.D.D01.0057'/>")) return; // 결재취소 신청하시겠습니까?

    var form = $('#form1');

    form.attr({
        action: '${ g.servlet }hris.D.D01OT.D01OTCancelBuildSV',
        target: '_self',
        method: 'POST'
    })
    .find('input[type="hidden"][name="jobid"]').val('create');

    return true;
}

function popupWorkTime() {

   	var workDate = moment('${d01OTData.WORK_DATE}'.replace(/[^\d]/g, ''), 'YYYYMMDD');

   	openPopup({
        url: '${g.servlet}hris.D.D25WorkTime.D25WorkTimeReportSV',
        data: {
            isPop: 'Y',
            PARAM_PERNR: '${d01OTData.PERNR}',
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

<tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_STAT_APPL" representative="false" disable="false">
<!-- 상단 입력 테이블 시작-->

<input type="hidden" name="BUKRS" value="${user.companyCode}">
<input type="hidden" name="BEGDA" value="${d01OTData.BEGDA}">

<!-- <input type="hidden" name="APPR_STAT"> -->

<!-- 전체테이블 시작 -->
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral" style="table-layout:fixed">
            <colGroup>
                <col style="width:15%" />
                <col />
                <col />
            </colGroup>
            <tbody>
                <tr>
                    <th><spring:message code="LABEL.D.D01.0001" /><%-- 초과근무일 --%></th>
                    <td>${ f:printDate(d01OTData.WORK_DATE) }
                        <input type="checkbox" ${ d01OTData.VTKEN eq "X" ? "checked" : "" } disabled="disabled" />
                        <spring:message code="MSG.D.D01.0051" /><%-- 前日 근태에 포함 --%>
                    </td>
                    <!-- [CSR ID:2803878] 초과근무 신청 화면 수정 -->
<%-- 시작 : 2018.05.17 [WorkTime52] 유정우 - 사무직/현장직 실근로시간 현황표 변경 --%>
<c:choose><c:when test='${TPGUB eq "C"}'><%--  or TPGUB eq "D" --%>
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
</c:when><c:otherwise>
                    <td rowspan="${isDeputy ? 5 : 4}" style="box-sizing:border-box; width:280px; padding:15px">
                        <div class="commentImportant real-worktime-list">
                            <table class="infoTable" style="width:100%">
                                <colGroup>
                                    <col style="width:50%" />
                                    <col />
                                </colGroup>
                                <tbody>
                                    <tr>
                                        <td colspan="2" class="lastCol align_center">
                                            ${MONTH}<spring:message code="LABEL.D.D01.0009" /><%-- 월 초과근무 현황 --%>
                                            <!-- [CSR ID:2803878] 초과근무 문구수정 --><br />
                                            <spring:message code="LABEL.D.D01.0010" /><%-- (전월 21일 ~ 당월 20일 기준) --%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td ><spring:message code="LABEL.D.D01.0011" /><%-- 평일연장 --%></td>
                                        <td width="50%" class="lastCol">${YUNJANG}<spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0012" /><%-- 휴일근로 --%></td>
                                        <td class="lastCol">${HTKGUN}<spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0013" /><%-- 휴일연장 --%></td>
                                        <td class="lastCol">${HYUNJANG}<spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0014" /><%-- 야간근로 --%></td>
                                        <td class="lastCol">${YAGAN}<spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0015" /><%-- 결재 진행 중<br />초과근로 --%></td>
                                        <td class="lastCol">${NOAPP}<spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
</c:otherwise></c:choose>
<%-- 종료 : 2018.05.17 [WorkTime52] 유정우 - 사무직/현장직 실근로시간 현황표 변경 --%>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%></th>
                    <td>${ f:printTime(d01OTData.BEGUZ)} ~ ${ f:printTime(d01OTData.ENDUZ) }
                        ${ f:printNum(d01OTData.STDAZ) } <spring:message code="LABEL.D.D01.0008" /><%-- 시간 --%>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D15.0157" /><%-- 신청사유 --%></th>
                    <td>${ OVTM_CDNM } ${ d01OTData.REASON }</td>
                </tr>

<c:if test="${isDeputy}">
                <tr>
                    <th><spring:message code="LABEL.D.D01.0002" /><%-- 원근무자(대근시) --%></th>
                    <td>${ d01OTData.OVTM_NAME }</td>
                </tr>
</c:if>

                <!-- [CSR ID:2803878] 초과근무 수정 -->
                <tr>
                    <th><spring:message code="LABEL.D.D01.0003" /><%-- 상세업무일정 --%></th>
                    <td class="work-detail-box">
                        <textarea name="OVTM_DESC" readonly="readonly" wrap="hard">${d01OTData.OVTM_DESC1}${d01OTData.OVTM_DESC2}${d01OTData.OVTM_DESC3}${d01OTData.OVTM_DESC4}</textarea>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D03.0039" /><%-- 취소신청일 --%></th>
                    <td colspan="2">${f:printDate(f:currentDate())}</td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D03.0007" /><%-- 취소사유 --%></th>
                    <td colspan="2" style="box-sizing:border-box"><input type="text" id="CANC_REASON" name="CANC_REASON" style="width:100%; max-width:none; box-sizing:border-box" maxlength="80" /></td>
                </tr>
            </tbody>
        </table>
        <div class="commentOne"><spring:message code="MSG.COMMON.0061" /></div><%-- <span class="textPink">*</span> 는 필수 입력사항입니다. --%>
    </div>
</div>

<div class="listArea" style="margin-bottom:30px">
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
                    <th><spring:message code="LABEL.D.D15.0162" /><%-- 시작시간 --%></th>
                    <th><spring:message code="LABEL.D.D15.0163" /><%-- 종료시간 --%></th>
                    <th><spring:message code="LABEL.D.D01.0004" /><%-- 무급     --%></th>
                    <th class="lastCol"><spring:message code="LABEL.D.D01.0005" /><%-- 유급 --%></th>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow">
                    <td><spring:message code="LABEL.D.D01.0006" /><%-- 휴게시간1 --%></td>
                    <td>${ f:printTime(d01OTData.PBEG1) }</td>
                    <td>${ f:printTime(d01OTData.PEND1) }</td>
                    <td>${ d01OTData.PUNB1 eq '0' ? '' : f:printNumFormat(d01OTData.PUNB1, 2) }</td>
                    <td>${ d01OTData.PBEZ1 eq '0' ? '' : f:printNumFormat(d01OTData.PBEZ1, 2) }</td>
                </tr>
                <tr>
                    <td><spring:message code="LABEL.D.D01.0007" /><%-- 휴게시간2 --%></td>
                    <td>${ f:printTime(d01OTData.PBEG2) }</td>
                    <td>${ f:printTime(d01OTData.PEND2) }</td>
                    <td>${ d01OTData.PUNB2 eq '0' ? '' : f:printNumFormat(d01OTData.PUNB2, 2) }</td>
                    <td>${ d01OTData.PBEZ2 eq '0' ? '' : f:printNumFormat(d01OTData.PBEZ2, 2) }</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<%--
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
            <colGroup>
                <col style="width:15%" />
                <col />
            </colGroup>
            <tbody>
                <tr>
                    <th><spring:message code="LABEL.D.D03.0039" /><%-- 취소신청일 -- %></th>
                    <td>${f:printDate(f:currentDate())}</td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span> <spring:message code="LABEL.D.D03.0007" /><%-- 취소사유 -- %></th>
                    <td style="box-sizing:border-box"><input type="text" id="CANC_REASON" name="CANC_REASON" style="width:100%; max-width:none; box-sizing:border-box" maxlength="80" /></td>
                </tr>
            </tbody>
        </table>
    </div>
    <span class="commentOne"><spring:message code="MSG.COMMON.0061" /></span>
</div>
--%>
</tags-approval:request-layout>

</tags:layout>