<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!doctype html>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page errorPage="/web/err/error.jsp"%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title>header</title>
<link rel="stylesheet" type="text/css" href="${g.image}css/header.css">
<script language="javascript" src="${g.image}js/jquery-1.12.4.min.js"></script>
<script language="javascript">
    $(window).resize(function() {
        $('#ghr-content-iframe').css('height', 0);
        $('#ghr-content-iframe').css('height', ($(window).height() - $('div.header').height()) + 'px');
    });

    $(function() {
        $(".menu li").hover(
            function() { $('ul:first', this).show(); },
            function() { $('ul:first', this).hide(); }
        );
        $(".menu >li:has(ul)>a").each(function() {
            $(this).html( $(this).html() );
        });
        $(".menu ul li:has(ul)")
            .find("a:first")
            .append("<p style='float:right;margin:-3px'>&#9656;</p>");

        $('.btn_allMenu').click(function(e) {
            e.preventDefault();

            var menu = $('.all_menu');
            if (menu.is(":visible")) {
                menu.slideUp(400);
            } else {
                menu.slideDown(400);
            }
        });

        $(window).resize();
    });

    function clickTopMenu(menu1, menu2) {
        $("#menu1").val(menu1 || "");
        $("#menu2").val(menu2 || "");
        $("#menuForm").submit();
    }

    function autoResize(target) {
        target.height = 0;
        target.height = target.contentWindow.document.body.scrollHeight;
    }
</script>
</head>
<body>
<div class="wrapper">
    <form id="menuForm" name="menuForm" method="post" action="/web/main.jsp" target="ghr-content-iframe">
        <input type="hidden" id="menu1" name="menu1"/>
        <input type="hidden" id="menu2" name="menu2"/>
        <input type="hidden" id="menu3" name="menu3"/>
    </form>

    <div class="header">
<!--     <div class="header" style="position:fixed; top:0px; left:0px; height:80px; width:100%; border:0px; z-index:1 "> -->
        <a class="logo" href=""><img src="${g.image}sshr/img_logo.png" alt="HR Portal"/></a>

        <ul class="menu">
        <c:forEach var="menu" items="${menuMap['ROOT']}">
            <li>
                <%--
                FTEXT		CHAR	40	기능코드 Text
                ORDSQ		NUMC	2	정렬 순서
                HLFCD		CHAR	20	상위레벨 기능코드
                EMGUB		CHAR	1	ESS/MSS 구분자
                LEVEL		NUMC	2	노드레벨
                FTYPE		CHAR	4	기능유형
                RPATH		CHAR	255	Web 주소(URL)
                --%>
                <a href="javascript:;" onclick="clickTopMenu('${menu.FCODE}');"><spring:message code="COMMON.MENU.${menu.FCODE}" /><%--${menu.FTEXT}--%></a>

            <c:if test="${not empty menuMap[menu.FCODE]}" >
                <ul class="subMenu" style="display:none">
                <c:forEach var="subMenu" items="${menuMap[menu.FCODE]}">
                    <li><a href="javascript:;" onclick="clickTopMenu('${menu.FCODE}', '${subMenu.FCODE}');"><spring:message code="COMMON.MENU.${subMenu.FCODE}" /><%--${subMenu.FTEXT}--%></a></li>
                </c:forEach>
                </ul>
            </c:if>
            </li>
        </c:forEach>
        </ul>

        <div class="userInfo">
            <ul>
                <%
                    String  SID = g.getSapType().toString();
                    try{
                        Config conf = new Configuration();
                        SID          = conf.get(g.getSapType().getPropertyPerfx() + "SID");

                    } catch (Exception ex) {
                        Logger.error(ex);
                    }

                %>
                <li class="user" style="font-weight: bold; font-size: 20px;"><span class="userTeam" ><%=SID %></span><span class="userName" href="">(${user.empNo})${user.ename} (${user.e_authorization})</span></li>
                <!--  [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건-->
                <li class="userRank">${ user.e_titel eq "책임" and user.e_titl2 ne "" ? user.e_titl2 : user.e_titel }</li>


            </ul>
        </div>

        <div class="subInfo">
            <ul>
                <li><a href="">HR공지</a></li>
                <li><a href="">FAQ</a></li>

                <li><a href="${g.servlet}hris.LogoutSV">로그아웃</a></li>
            </ul>
        </div>

        <a class="btn_allMenu" href=""><img src="${g.image}sshr/btn_allMenu.png" /></a>

    </div>
	<div id="root">
<!-- 	<div id="root" style="position:absolute; top:80px; left:0px; height:90%; border:0; z-index:0; "> -->
    	<iframe id="ghr-content-iframe" name="ghr-content-iframe" src="" width="100%" scrolling="no" onload="autoResize(this);" />
	</div>

</div>
</body>
</html>