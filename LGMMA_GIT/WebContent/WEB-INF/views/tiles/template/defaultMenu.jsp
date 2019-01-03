<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.lgmma.ess.app.model.MenuItem"%>
<%@ page import="com.lgmma.ess.common.props.MenuFile"%>
<%
    //이 방법이 가끔 안될때가 있네... 흠...
    //${sessionScope.SPRING_SECURITY_CONTEXT.authentication.userInfo.allowedMenuMap['01'].menuItems
    WebUserData userData = (WebUserData) session.getAttribute("user");

    if (userData != null) {
        pageContext.setAttribute("rootMenuItem", userData.getAllowedMenuMap().get(MenuFile.GHR_USER_MENU.getCode()));
    }
%>
<div class="leftMenu">
<form name="menuForm" id="menuForm" method="post">
<input type="hidden" name="menuId" id="menuId">
</form>
<script>
function movePage(url, id) {
    $("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
    $("#menuForm #menuId").val(id);
    $("#menuForm").attr('action', url);
    $("#menuForm").submit();
}
</script>
    <a class="leftTop close" href="javascript:clsopnleftMenu();"><span class="Lnodisplay">접고 펼치기 버튼</span></a>
    <div class="leftBg">
        <div class="closeOpen">
            <c:forEach var="topMenuItem" items="${rootMenuItem.menuItems}" varStatus="loop">
            <c:if test="${topMenuItem.selected}">
            <c:if test="${topMenuItem.depth eq 1 && topMenuItem.visible}">
            <div class="leftSystemInfo">
                <div class="leftSysname"><c:out value="${topMenuItem.name}"/></div>
            </div>
            </c:if>
            <c:if test="${not empty topMenuItem.menuItems}">
            <ul id="leftMenuBlock" class="slideMenu">
                <c:forEach var="middleMenuItem" items="${topMenuItem.menuItems}" varStatus="loop">
                <c:if test="${middleMenuItem.depth == 2 && middleMenuItem.visible}">
                <li><a class="leftDepth1"><span${middleMenuItem.selected ? ' class="on"' : ''}><c:out value="${middleMenuItem.name}"/></span></a>
                    <c:if test="${not empty middleMenuItem.menuItems}">
                    <ul class="2depthArea${not middleMenuItem.selected ? ' Lnodisplay' : ''}">
                        <c:forEach var="menuItem" items="${middleMenuItem.menuItems}" varStatus="loop">
                        <c:if test="${menuItem.depth == 3 && menuItem.visible}">
                        <li><a class="leftDepth2" href="javascript:movePage('<c:out value='${menuItem.url}'/>', '<c:out value='${menuItem.id}'/>');"><span><c:out value='${menuItem.name}'/></span></a></li>
                        </c:if>
                        </c:forEach>
                    </ul>
                    </c:if>
                </li>
                </c:if>
                </c:forEach>
            </ul>
            </c:if>
            </c:if>
            </c:forEach>
            <div class="leftBottom"> </div>
        </div>
    </div>
    <div class="leftUnderBanner">
        <ul>
            <!-- <li><a class="leftBanners"><img src="/web-resource/images/img_exchange.gif" alt="환율정보" /></a></li> -->
            <li><a class="leftBanners">시스템 문의 : 02-6930-3891</a></li>
        </ul>
    </div>
</div>