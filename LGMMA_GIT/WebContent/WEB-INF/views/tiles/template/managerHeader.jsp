<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
%><div class="header">
	<div class="headerFixed">
		<a class="hLogo" href="/manager/home"><img src="/web-resource/images/logo_header.png" alt="LG MMA"/></a>
		<ul class="hMenu">
			<c:forEach var="menuItem" items="${menuItem.menuItems}" varStatus="loop">
			<c:if test="${menuItem.depth == 1 && menuItem.visible}">
			<li class="h<c:out value="${menuItem.id}"/>"><a title="<c:out value="${menuItem.name}"/>" onclick="globalNavigate('h<c:out value="${menuItem.id}"/>');"><c:out value="${menuItem.name}"/></a>
				<ul class="megaDrop Lnodisplay">
			</c:if>
				<c:forEach var="menuItem" items="${menuItem.menuItems}" varStatus="loop">
					<c:if test="${menuItem.depth == 2 && menuItem.visible}">
						<li><a href="javascript:movePage('<c:out value='${menuItem.url}'/>', '<c:out value='${menuItem.id}'/>');"><c:out value="${menuItem.name}"/></a></li>
					</c:if>
				</c:forEach>
				</ul>
			</li>
			</c:forEach>
		</ul>
		<script type="text/javascript">
			//헤더영역에서 마우스 벗어나면 헤더 및 메가드롭 사라지기
			$(".hMenu").mouseleave(function(){$(".hMenu a").removeClass('on');$(".megaDrop").addClass('Lnodisplay');});
		</script>
		
		<div class="hInfo">
			<div class="myInfo">
				<h2><a href="#"><strong><%=userData.ename %> </strong></a><%=userData.e_titel%>
				<%if(!"".equals(userData.e_titl2)){ %> /<%=userData.e_titl2%>  <% }%>
				</h2>
				<ul>
					<li><!-- <a href="/logout">Logout</a> --></li>
				</ul>
			</div>
<!-- 			<div class="csInfo">
				<ul>
					<li class="bgnone"><a href="#">인사담당자 연락처</a></li>
					<li><a href="#">사용방법안내</a></li>
				</ul>
 -->		</div>
		<!--
		<a class="hMap"><img src="/web-resource/images/btn_systemmap.gif" alt="System Map"/></a>
		  -->
	</div>
</div>