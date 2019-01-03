<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실근무시간 관리
/*   Program ID   : D03CompTimeList-var.jsp
/*   Description  : D03CompTimeList.js에서 사용되는 message 변수 선언
/*                  javascript는 browser에서 실행되는 client side 언어이므로 js 파일내에서
/*                  server side 언어인 JSP Scriptlet, JSTL 또는 EL을 사용할 수 없다.
/*                  하지만 contentType을 text/javascript로 지정한 JSP에 javascript를 코딩하여
/*                  response를 보내면 browser가 js 파일로 인식하므로 이 JSP에서는 server side 언어를 코딩할 수 있다.
/*                  이를 이용하여 message만 별도의 js 파일로 분리하였다.
/*   Note         : 
/*   Creation     : 2018-07-30 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/
--%><%@ page contentType="text/javascript; charset=utf-8" %><%
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %><%
%>(function() {
with (i18n) {

MSG.D.D03 = {};

MSG.D.D03['0081'] = '<spring:message code="MSG.D.D03.0081" />';<%-- 조회년월이 정상적으로 선택되지 않았습니다. --%>
MSG.D.D03['0082'] = '<spring:message code="MSG.D.D03.0082" />';<%-- 2018년 7월부터 조회 가능합니다. --%>

}
})()