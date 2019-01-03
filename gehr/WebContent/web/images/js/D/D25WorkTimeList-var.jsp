<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeList-var.jsp
/*   Description  : D25WorkTimeList.js에서 사용되는 message 변수 선언
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
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %><%
%>(function() {
with (i18n) {

LABEL.D.D25.N2150  = '<spring:message code="LABEL.D.D25.N2150" />';<%-- 저장됨 --%>
LABEL.D.D25.N2151  = '<spring:message code="LABEL.D.D25.N2151" />';<%-- 미저장 --%>
LABEL.D.D25.N2163  = '<spring:message code="LABEL.D.D25.N2163" />';<%-- 완료 --%>
MSG.D.D25.N0014    = '<spring:message code="MSG.D.D25.N0014" />';<%-- 업무 시작/종료 시간이 변경되었습니다. --%>
MSG.D.D25.N0015    = '<spring:message code="MSG.D.D25.N0015" />';<%-- 업무 시작/종료 시간을 저장한 후, 비근무를 입력할 수 있습니다. --%>
MSG.D.D25.N0016    = '<spring:message code="MSG.D.D25.N0016" />';<%-- 업무 시작/종료 시간을 저장한 후, 업무재개를 입력할 수 있습니다. --%>
MSG.D.D25.N0039    = '<spring:message code="MSG.D.D25.N0039" />';<%-- 전반 휴가의 경우 휴가 시간 이후에만 업무 시간 입력이 가능합니다. --%>
MSG.D.D25.N0040    = '<spring:message code="MSG.D.D25.N0040" />';<%-- 후반 휴가의 경우 휴가 시간 이전에만 업무 시간 입력이 가능합니다. --%>
MSG.D.D25.N0055    = '<spring:message code="MSG.D.D25.N0055" />';<%-- 업무 시간이 다음날 업무 시간과 중복됩니다. --%>
BUTTON.D.D25.N0006 = '<spring:message code="BUTTON.D.D25.N0006" />';<%-- 초과근무 실적입력 --%>

}
})()