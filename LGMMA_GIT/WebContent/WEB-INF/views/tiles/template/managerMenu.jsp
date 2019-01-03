<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.lgmma.ess.app.model.MenuItem"%>
<%@ page import="com.lgmma.ess.common.props.MenuFile"%>
<%
	//이 방법이 가끔 안될때가 있네... 흠...
	//${sessionScope.SPRING_SECURITY_CONTEXT.authentication.userInfo.allowedMenuMap['01'].menuItems
	WebUserData userData = (WebUserData) (request.getSession().getValue("managedUser"));

	MenuItem menuItem = null;
	if(userData != null) {
		menuItem = userData.getAllowedMenuMap().get(MenuFile.GHR_MANAGER_MENU.getCode());
		pageContext.setAttribute("menuItem", menuItem);
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
			<c:forEach var="menuItem" items="${menuItem.menuItems}" varStatus="loop">
			<c:if test="${menuItem.selected eq true}">
			<c:if test="${menuItem.depth == 1 && menuItem.visible}">
			<div class="leftSystemInfo">
				<div class="leftSysname"><c:out value="${menuItem.name}"/></div>
			</div>
			</c:if>
			<c:if test="${!empty menuItem.menuItems}">
			<ul id="leftMenuBlock" class="slideMenu">
				<c:forEach var="menuItem" items="${menuItem.menuItems}" varStatus="loop">
					<c:if test="${menuItem.depth == 2 && menuItem.visible}">
				<li><a class="leftDepth1"><span <c:if test="${menuItem.selected eq true}">class="on"</c:if>><c:out value="${menuItem.name}"/></span></a>
						<c:if test="${!empty menuItem.menuItems}">
					<ul class="2depthArea<c:if test="${menuItem.selected ne true}"> Lnodisplay</c:if>">
							<c:forEach var="menuItem" items="${menuItem.menuItems}" varStatus="loop">
								<c:if test="${menuItem.depth == 3 && menuItem.visible}">
						<li><a class="leftDepth2" href="javascript:movePage('<c:out value='${menuItem.url}'/>', '<c:out value='${menuItem.id}'/>');"><span><c:out value='${menuItem.name}'/></span></a></li>
								</c:if>
							</c:forEach>
					</ul>
						</c:if>
				</li>
					</c:if>
				</c:forEach>
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