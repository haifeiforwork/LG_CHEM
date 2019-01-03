<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황(사무직)
/*   Program ID   : D25WorkTimeLeaderWeekly-var.jsp
/*   Description  : D25WorkTimeLeaderWeekly.js에서 사용되는 message 변수 선언
/*                  javascript는 browser에서 실행되는 client side 언어이므로 js 파일내에서
/*                  server side 언어인 JSP Scriptlet, JSTL 또는 EL을 사용할 수 없다.
/*                  하지만 contentType을 text/javascript로 지정한 JSP에 javascript를 코딩하여
/*                  response를 보내면 browser가 js 파일로 인식하므로 이 JSP에서는 server side 언어를 코딩할 수 있다.
/*                  이를 이용하여 message만 별도의 js 파일로 분리하였다.
/*   Note         : 
/*   Creation     : 2018-05-09 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/
--%><%@ page contentType="text/javascript; charset=utf-8" %><%
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %><%
%>(function() {
with (i18n) {

LABEL.D.D25.N2171 = '<spring:message code="LABEL.D.D25.N2171" />';<%-- 사번 --%>
LABEL.D.D25.N2172 = '<spring:message code="LABEL.D.D25.N2172" />';<%-- 이름 --%>
LABEL.D.D25.N2173 = '<spring:message code="LABEL.D.D25.N2173" />';<%-- 소속 --%>
LABEL.D.D25.N2174 = '<spring:message code="LABEL.D.D25.N2174" />';<%-- 직책 --%>
LABEL.D.D25.N2116 = '<spring:message code="LABEL.D.D25.N2116" />';<%-- 계 --%>

}
})()