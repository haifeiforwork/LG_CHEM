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
    SessionLocaleResolver localeResolver = Utils.getBean("localeResolver");
    localeResolver.setLocale(request, response, g.getLocale());
    request.setAttribute(DispatcherServlet.LOCALE_RESOLVER_ATTRIBUTE, localeResolver);
%>
