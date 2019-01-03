<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 주 52시간 근무제 공통 i18n message 변수 선언 js
/*   Program ID   : D-common-var.jsp
/*   Description  : D-common.js에서 사용되는 message 변수 선언
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
%>var i18n = {
    LABEL:  {D: { D25: {} }, COMMON: {} },
    MSG:    {D: { D25: {} }, COMMON: { SAVE: {} } },
    BUTTON: {D: { D25: {} } },
    getMessage: function() {
        var args = Array.prototype.slice.call(arguments), code = args.shift(), msg;
        if (code) {
            msg = eval(/^i18n\./.test(code) ? code : 'i18n.' + code);
        }
        $.each(args, function(i, v) {
            msg = msg.replace(new RegExp('\\{' + i + '\\}', 'g'), v);
        });
        return msg;
    }
};

(function() {
with (i18n) {

LABEL.D.D25.N2141       = '<spring:message code="LABEL.D.D25.N2141" />';<%--       년 --%>
LABEL.D.D25.N2143       = '<spring:message code="LABEL.D.D25.N2143" />';<%--       월 --%>
LABEL.D.D25.N7001       = '<spring:message code="LABEL.D.D25.N7001" />';<%--       시간 --%>
LABEL.COMMON['0039']    = '<spring:message code="LABEL.COMMON.0039" />';<%--       분 --%>
MSG.D.D25.N0009         = '<spring:message code="MSG.D.D25.N0009" />';<%--         저장할 데이터가 없습니다. --%>
MSG.D.D25.N0012         = '<spring:message code="MSG.D.D25.N0012" />';<%--         부모 프레임이 없습니다!\n\n이 화면은 부모 프레임에 저장된 정보를 참조해야합니다. --%>
MSG.COMMON['0004']      = '<spring:message code="MSG.COMMON.0004" />';<%--         해당하는 데이타가 존재하지 않습니다. --%>
MSG.COMMON.SAVE.SUCCESS = '<spring:message code="MSG.COMMON.SAVE.SUCCESS" />';<%-- 저장되었습니다. --%>
MSG.COMMON.SAVE.CONFIRM = '<spring:message code="MSG.COMMON.SAVE.CONFIRM" />';<%-- 저장하시겠습니까? --%>

}
})()