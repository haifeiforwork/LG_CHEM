<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.Logger" %>
<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="com.sns.jdf.util.PageUtil" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>
<%@ page import="org.springframework.web.servlet.DispatcherServlet" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/include/includeCommon.jsp"%>
<%
	String code = request.getParameter("code");

    if ( !"ghreva".equals(code)) {	// @v1.0
        Logger.debug.println(this, "start login check");
        if(session==null) {
            Logger.debug.println(this, "session is null");
            String msg = g.getMessage("MSG.COMMON.0063"); //session 이 끊어졌습니다. 다시 로그인 해주세요.
            String url = "top.window.close();opener.top.window.close();";
            request.setAttribute("msg", msg);
            request.setAttribute("url", url);
%>
<jsp:forward page = "/web/common/msg.jsp" />
<%
        return;
    }

    WebUserData commonProcessWebUserData  = (WebUserData)session.getAttribute("user");
    if ( commonProcessWebUserData == null || commonProcessWebUserData.login_stat == null ||
            !commonProcessWebUserData.login_stat.equals("Y") ) {
        //로그인이 안된 상태
        Logger.debug.println(this, "not Login");
        String msg = g.getMessage("MSG.COMMON.0064"); //로그인 상태가 아닙니다. 다시 로그인 해주세요.
        String url = "top.window.close();opener.top.window.close();";
        request.setAttribute("msg", msg);
        request.setAttribute("url", url);
%>
<jsp:forward page = "/web/common/msg.jsp" />
<%
            Logger.debug.println(this, "end login check");
            return;
        }

    }

    SessionLocaleResolver localeResolver = Utils.getBean("localeResolver");
    localeResolver.setLocale(request, response, g.getLocale());
    request.setAttribute(DispatcherServlet.LOCALE_RESOLVER_ATTRIBUTE, localeResolver);
%>
