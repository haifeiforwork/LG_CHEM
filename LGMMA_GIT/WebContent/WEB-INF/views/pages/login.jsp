<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xml:lang="ko" xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<title>LG MMA GHR <%=request.getLocalAddr().equals("165.244.241.154") ? "" : "TEST"%>시스템 로그인</title>
<!-- basic -->
<link rel="shortcut icon" href="/web-resource/images/g_favicon.ico" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_jquery.css" />
<%
String clientIP = request.getRemoteAddr();
if (!(
           "10.45.1.26".equals(clientIP) // 이동엽 (CNS)
   ||  "165.243.184.34".equals(clientIP) // 이동엽 (CNS)
   ||     "10.64.67.10".equals(clientIP) // 송현우 (CNS)
   ||    "10.64.64.106".equals(clientIP) // 한영주 (CNS)
   ||     "10.64.74.35".equals(clientIP) // 박형순 (CNS)

   // 서울
   ||      "10.45.1.90".equals(clientIP) // 김재만
   ||      "10.45.1.37".equals(clientIP) // 홍성민
   ||  "165.243.184.42".equals(clientIP) // 홍성민
   ||     "10.45.1.123".equals(clientIP) // 김남주
   ||  "165.243.184.73".equals(clientIP) // 김남주
   ||     "10.45.1.120".equals(clientIP) // 박진희
   ||      "10.45.1.72".equals(clientIP) // 문영웅

   // 여수
   ||      "10.45.8.17".equals(clientIP) // 차효윤
   ||      "10.45.8.16".equals(clientIP) // 이혜정
   ||      "10.45.8.14".equals(clientIP) // 양기상
   ||      "10.45.8.13".equals(clientIP) // 이병위

   // 배수연 선임(sharedservice 모의해킹)
   ||      "10.45.1.51".equals(clientIP)   // 배수연
)) {
    // response.sendRedirect("http://sso.lgmma.com:8080/lgmma-portal/login.do");
}
System.out.println("########### login user IP : " + clientIP);
%>
<!--
이동엽 : 10.45.1.26, 165.243.184.34
김재만 : 10.45.1.90
홍성민 : 10.45.1.37, 165.243.184.42
김남주 : 165.243.184.73, 10.45.1.123
송현우 : 10.64.67.10
-->
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-1.9.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-ui-1.10.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/common.js"></script>
<script type="text/javascript">
$(function() {
    $('.btn_login').click(function() {
        if (validateForm()) {
            document.forms['f'].submit();
        }
    });
});

function validateForm() {
    if (document.forms['f'].adminPwd.value.length == "") {
        alert("PASSWORD를 입력하시기 바랍니다.");
        document.forms['f'].adminPwd.focus();
        return false;
    }
    return true;
}
</script>
</head>
<body style="overflow:auto;" onload="document.forms['f'].adminPwd.focus();">
<c:url var="loginUrl" value="/user/doLogin" />
<c:if test="${not empty error}">
<script type="text/javascript">
    alert('${msg}');
</script>
</c:if>
<!--// Login start -->
<div class="loginBox">
    <!--// Login Header start -->
    <div class="loginHeader">
        <img src="/web-resource/images/logo_login_header.gif" alt="LG MMA GHR" />
    </div>
    <!--// Login Header end -->
    <!--// Login Content start -->
    <form:form name="f" action="${loginUrl}" method="post" onsubmit="return validateForm();">
    <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> --%>
    <div class="loginContent">
        <img class="mainImage" src="/web-resource/images/img_main.png" alt="메인이미지" />
        <span style="position:absolute;left:359px;top:45px;color:red"><%=request.getLocalAddr().equals("165.244.241.154") ? "" : "※ 테스트서버입니다."%></span>
        <ul class="inputGr">
            <li class="input_id"><input type="text" id="empNo" name="empNo" value=""
                onkeyup="javascript:if (event.keyCode == 13) { $('.btn_login').click(); }" /></li>
            <li class="input_pw"><input type="password" name="adminPwd" id="adminPwd" value="<%=request.getLocalAddr().equals("165.244.241.154") ? "" : "mmaadmin"%>"
                onkeyup="javascript:if (event.keyCode == 13) { $('.btn_login').click(); }" /></li>
            <!-- <li class="input_id"><input type="text" name="empNo" id="empNo" value="4209" /></li> -->
        </ul>
        <a class="btn_login" href="#"><img src="/web-resource/images/btn_login.gif" alt="로그인" /></a>
    </form:form>
    </div>
    <!--// Login Content end -->
    <!--// Login Footer start -->
    <div class="loginFooter">
        <h1>문의전화 : <span>02-6930-3891</span></h1>
        <img src="/web-resource/images/logo_footer.gif" alt="logo" />
    </div>
    <!--// Login Footer end -->
</div>
<!--// Login end -->
</html>