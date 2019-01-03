<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
%><div class="header">
	<div class="headerFixed">
		<a class="hLogo" href="/home"><img src="/web-resource/images/logo_header.png" alt="LG MMA"/></a>
		<ul class="hMenu">
			<c:if test="${not empty rootMenuItem}">
			<c:forEach var="topMenuItem" items="${rootMenuItem.menuItems}" varStatus="loop">
			<c:if test="${topMenuItem.depth == 1 && topMenuItem.visible}">
			<li class="h<c:out value="${topMenuItem.id}"/>"><a title="<c:out value="${topMenuItem.name}"/>" onclick="globalNavigate('h<c:out value="${topMenuItem.id}"/>');"><c:out value="${topMenuItem.name}"/></a>
				<ul class="megaDrop Lnodisplay">
				<c:forEach var="middleMenuItem" items="${topMenuItem.menuItems}" varStatus="loop">
					<c:if test="${middleMenuItem.depth == 2 && middleMenuItem.visible}">
						<li><a href="javascript:movePage('<c:out value='${middleMenuItem.url}'/>', '<c:out value='${middleMenuItem.id}'/>');"><c:out value="${middleMenuItem.name}"/></a></li>
					</c:if>
				</c:forEach>
				</ul>
			</li>
			</c:if>
			</c:forEach>
			</c:if>
			<% if(!(userData.e_persk.equals("25") || userData.e_persk.equals("31") || userData.e_persk.equals("32") || userData.e_persk.equals("33"))) { %>
			<li class="evaluation"><a href="<%=request.getServerName().equals("ghr.lgmma.com") ? "http://evaluation.lgmma.com/SSOLogin" : "http://evaluation.lgmmadev.com/SSOLogin"%>" target="_blank">평가시스템</a>
			</li>
			<% } %>
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
					<li><a href="/logout">Logout</a></li>
				</ul>
			</div>
			<div class="csInfo">
				<ul>
					<li class="bgnone"><a href="#" id="showPopHrStafffBtn">인사담당자 연락처</a></li>
					<!-- <li><a href="#">사용방법안내</a></li> -->
				</ul>
			</div>
		</div>
		<!--
		<a class="hMap"><img src="/web-resource/images/btn_systemmap.gif" alt="System Map"/></a>
		  -->
	</div>
</div>
<!-- 인사담당자 연락처 팝업 -->
<div class="layerWrapper layerSizeL" id="popLayerHrStaff" style="display:none !important">
	<div class="layerHeader">
		<strong>인사담당자 연락처</strong>
		<a href="#" class="btnClose popLayerHrStaff_close">창닫기</a>
	</div>
		<div class="layerContainer">
			<div class="layerContent">
				<!--// Content start  -->
				<div class="listArea pd0">
					<div id="hrStaffPopupGrid"></div>
				</div>
				<!--// Content end  -->
			</div>
		</div>
	<div class="clear"></div>
</div>

<script type="text/javascript">
	$(function(){
		if($(".layerWrapper").length){
			$('#popLayerHrStaff').popup();
		};
		$("#showPopHrStafffBtn").click(function() {
			$("#popLayerHrStaff").popup("show");
	   		$("#hrStaffPopupGrid").jsGrid("search");
		});
   		$("#hrStaffPopupGrid").jsGrid({
   			height: "auto",
   			width: "100%",
   			paging: false,
   			autoload: false,
   			sorting: false,
   			controller : {
   				loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/getHRStaffList.json",
   						dataType : "json"
   					}).done(function(response) {
   						if(response.success)	
   							d.resolve(response.storeData);
   		    			else
   		    				alert("조회시 오류가 발생하였습니다. " + response.message);
   					});
   					return d.promise();
   				}
   			},
   			fields: [
				{ title: "사업장", name: "GRUP_NAME", type: "text", align: "center", width: "10%" },
				{ title: "업무분야", name: "UPMU_NAME", type: "text", align: "center", width: "13%" },
				{ title: "담당자", name: "ENAME", type: "text", align: "center", width: "17%",
					itemTemplate: function(value, item) {
						return value + " " + item.TITEL;
					}
				},
				{ title: "연락처", name: "TELNUMBER", type: "number", align: "center", width: "20%" },
				{ title: "담당업무", name: "UPMU_DESC", type: "number", align: "left", width: "39%" }
   			]
   		});
	});
</script>