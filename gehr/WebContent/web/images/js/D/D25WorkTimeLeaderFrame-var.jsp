<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황(사무직)
/*   Program ID   : D25WorkTimeLeaderFrame-var.jsp
/*   Description  : D25WorkTimeLeaderFrame.js에서 사용되는 message 변수 선언
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

MSG.COMMON.SEARCH = {DEPT: {}};
MSG.COMMON.SEARCH.DEPT.REQUIR = '<spring:message code="MSG.COMMON.SEARCH.DEPT.REQUIR" />';<%-- 검색할 부서명을 입력하세요! --%>

MSG.APPROVAL = {SEARCH: {PERNR: {}, NAME: {}}};
MSG.APPROVAL.SEARCH.PERNR.REQUIRED = '<spring:message code="MSG.APPROVAL.SEARCH.PERNR.REQUIRED" />';<%-- 검색할 부서원 사번을 입력하세요. --%>
MSG.APPROVAL.SEARCH.NAME.REQUIRED  = '<spring:message code="MSG.APPROVAL.SEARCH.NAME.REQUIRED" />';<%-- 검색할 부서원 성명을 입력하세요. --%>
MSG.APPROVAL.SEARCH.NAME.MIN       = '<spring:message code="MSG.APPROVAL.SEARCH.NAME.MIN" />';<%-- 검색할 성명을 한 글자 이상 입력하세요. --%>

MSG.D.D25.N0021 = '<spring:message code="MSG.D.D25.N0021" />';<%-- 선택하신 조직은 데이터가 너무 많습니다.\n\n하위조직을 선택하여 조회하시기 바랍니다. --%>

}
})()