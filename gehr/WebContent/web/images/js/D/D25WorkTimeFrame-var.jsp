<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeFrame-var.jsp
/*   Description  : D25WorkTimeFrame.js에서 사용되는 message 변수 선언
/*                  javascript는 browser에서 실행되는 client side 언어이므로 js 파일내에서
/*                  server side 언어인 JSP Scriptlet, JSTL 또는 EL을 사용할 수 없다.
/*                  하지만 contentType을 text/javascript로 지정한 JSP에 javascript를 코딩하여
/*                  response를 보내면 browser가 js 파일로 인식하므로 이 JSP에서는 server side 언어를 코딩할 수 있다.
/*                  이를 이용하여 message만 별도의 js 파일로 분리하였다.
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/
--%><%@ page contentType="text/javascript; charset=utf-8" %><%
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %><%
%>(function() {
with (i18n) {

LABEL.D.D25.N1004 = '<spring:message code="LABEL.D.D25.N1004" />';<%-- 비근무 시간 등록/수정 --%>
LABEL.D.D25.N1005 = '<spring:message code="LABEL.D.D25.N1005" />';<%-- 비근무 시간 조회 --%>
LABEL.D.D25.N1007 = '<spring:message code="LABEL.D.D25.N1007" />';<%-- 업무재개시간 등록/수정 --%>
LABEL.D.D25.N1008 = '<spring:message code="LABEL.D.D25.N1008" />';<%-- 업무재개시간 조회 --%>
LABEL.D.D25.N2202 = '<spring:message code="LABEL.D.D25.N2202" />';<%-- 시작일 --%>
LABEL.D.D25.N2203 = '<spring:message code="LABEL.D.D25.N2203" />';<%-- 종료일 --%>
LABEL.D.D25.N7011 = '<spring:message code="LABEL.D.D25.N7011" />';<%-- 행 --%>
MSG.D.D25.N0006   = '<spring:message code="MSG.D.D25.N0006" />';<%-- 비근무 시간 입력 팝업을 닫으시겠습니까? --%>
MSG.D.D25.N0007   = '<spring:message code="MSG.D.D25.N0007" />';<%-- 삭제할 비근무 시간 항목을 선택하세요. --%>
MSG.D.D25.N0008   = '<spring:message code="MSG.D.D25.N0008" />';<%-- 선택하신 비근무시간을 삭제하시겠습니까?\\n\\n삭제를 되돌리시려면 닫기 후 다시 팝업을 열어주세요. --%>
MSG.D.D25.N0009   = '<spring:message code="MSG.D.D25.N0009" />';<%-- 저장할 데이터가 없습니다. --%>
MSG.D.D25.N0013   = '<spring:message code="MSG.D.D25.N0013" />';<%-- 비근무 시간은 총 120분을 초과할 수 없습니다. --%>
MSG.D.D25.N0024   = '<spring:message code="MSG.D.D25.N0024" />';<%-- 업무재개시간 입력 팝업을 닫으시겠습니까? --%>
MSG.D.D25.N0025   = '<spring:message code="MSG.D.D25.N0025" />';<%-- 업무 시작 시간과 업무 종료 시간이 같습니다. --%>
MSG.D.D25.N0029   = '<spring:message code="MSG.D.D25.N0029" />';<%-- 2글자 이상 입력하세요. --%>
MSG.D.D25.N0030   = '<spring:message code="MSG.D.D25.N0030" />';<%-- 1행의 업무재개 시간대와 2행의 업무재개 시간대가 겹칩니다. --%>
MSG.D.D25.N0032   = '<spring:message code="MSG.D.D25.N0032" />';<%-- 기본 업무 시간 이후에만 업무재개 시간 입력이 가능합니다. --%>
MSG.D.D25.N0033   = '<spring:message code="MSG.D.D25.N0033" />';<%-- 휴가 시간 이후에만 업무재개 시간 입력이 가능합니다. --%>
MSG.D.D25.N0034   = '<spring:message code="MSG.D.D25.N0034" />';<%-- 계획 근무 시간 이후에만 업무재개 시간 입력이 가능합니다. --%>
MSG.D.D25.N0035   = '<spring:message code="MSG.D.D25.N0035" />';<%-- 업무재개 종료시각이 익일 업무시간과 중복됩니다. --%>
MSG.D.D25.N0037   = '<spring:message code="MSG.D.D25.N0037" />';<%-- 선택하신 업무재개시간을 초기화하시겠습니까?\\n\\n초기화 후 되돌리시려면 닫기 후 다시 팝업을 열어주세요. --%>
MSG.D.D25.N0038   = '<spring:message code="MSG.D.D25.N0038" />';<%-- 기입력된 기본 근무 시간대와 업무재개 시간대는 연속될 수 없습니다. --%>
MSG.D.D25.N0041   = '<spring:message code="MSG.D.D25.N0041" />';<%-- 업무재개 시작 시간이 업무재개 종료 시간 이후입니다. --%>
MSG.D.D25.N0048   = '<spring:message code="MSG.D.D25.N0048" />';<%-- 교육/출장 계획 입력 팝업을 닫으시겠습니까? --%>
MSG.D.D25.N0049   = '<spring:message code="MSG.D.D25.N0049" />';<%-- {0}을 입력하세요. --%>
MSG.D.D25.N0050   = '<spring:message code="MSG.D.D25.N0050" />';<%-- {0}을 {1} 형식으로 입력하세요. --%>
MSG.D.D25.N0051   = '<spring:message code="MSG.D.D25.N0051" />';<%-- 시작일은 내일 일자부터 입력 가능합니다. --%>
MSG.D.D25.N0052   = '<spring:message code="MSG.D.D25.N0052" />';<%-- 종료일은 입력된 시작일로부터 최대 한 달 후 일자까지 입력 가능합니다. --%>
MSG.D.D25.N0053   = '<spring:message code="MSG.D.D25.N0053" />';<%-- 시작일이 종료일 이후입니다. --%>

}
})()

function initMenuLinkButton() {

    BUTTON_LINK_URL = {};<c:if test='${param.JKBGB eq "T" or param.JKBGB eq "P"}'>
    BUTTON_LINK_URL.MSS_OFW_WORK_TIME = {remark: '근무 입력 현황',    url: getServletURL('hris.D.D25WorkTime.D25WorkTimeLeaderFrameSV')};
    BUTTON_LINK_URL.MSS_PT_RWORK_STAT = {remark: '근무 실적 현황',    url: getServletURL('hris.D.D25WorkTime.D25WorkTimeLeaderReportFrameSV')};</c:if><c:if test='${param.JKBGB eq "T" or param.JKBGB eq "P" or param.JKBGB eq "O"}'>
    BUTTON_LINK_URL.ESS_PT_FLEXTIME   = {remark: 'Flextime',          url: getServletURL('hris.D.D20Flextime.D20FlextimeFrameSV')};
    BUTTON_LINK_URL.ESS_PT_LEAV_INFO  = {remark: '휴가 신청',         url: getServletURL('hris.D.D04Vocation.D04VocationFrameSV')};</c:if><c:if test='${param.JKBGB eq "P" or param.JKBGB eq "O"}'>
    BUTTON_LINK_URL.ESS_OPT_OVER_TIME = {remark: '초과근무 신청',     url: getServletURL('hris.D.D00ConductFrameSV'), data: {TABID: 'OTBF'}};
    BUTTON_LINK_URL.ESS_OPT_OVTM_AFTR = {remark: '초과근무 사후신청', url: getServletURL('hris.D.D00ConductFrameSV'), data: {TABID: 'OTAF'}};</c:if>

    $.each(BUTTON_LINK_URL, function(k, p) {
        $('a[data-name="#"]'.replace(/#/, k)).click(function() {<%--
            var o = {width: 1250, height: 600, data: {FROM_ESS_OFW_WORK_TIME: 'Y', EdgeMode: 'Y'}};
            openPopup($.extend(true, {}, o, p, {name: k, specs: {resizable: 'yes'}}));--%><%-- FROM_ESS_OFW_WORK_TIME : 근무 시간 입력 화면에서 popup으로 들어온 경우 결재신청 후 popup을 닫기 위한 flag --%>
            showModalDialog(p.url + '?' + $.param($.extend({FROM_ESS_OFW_WORK_TIME: 'Y', EdgeMode: 'Y'}, p.data)), this, 'location:0;scroll:1;menubar:0;status:0;help:0;resizable:1;dialogWidth:1250px;dialogHeight:600px');
            retrieveData();
            return false;
        });
    });
}