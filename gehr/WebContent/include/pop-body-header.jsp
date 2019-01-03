<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=utf-8" %>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<div class="winPop dvMinheight">
    <div class="header">
        <span><c:if test="${not empty param.title}"><spring:message code="${param.title}" /></c:if></span>
        <a href="javascript:void(0);" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" alt="팝업닫기" /></a>
    </div>
    <div class="body">
