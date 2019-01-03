<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
    // javascript 또는 CSS 파일 같은 static resource가 변경되면 사용자의 browser에 caching된 기존 resource를 무시하도록 version을 지정
    // 지정된 version이 하드코딩이므로 version이 바뀌기 전까지 browser에서 caching이 가능하다.
    request.setAttribute("CACHE_VERSION", "20181207");
%>