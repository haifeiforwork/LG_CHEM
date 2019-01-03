<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@include file="/WEB-INF/views/tiles/template/cacheVersion.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xml:lang="ko" xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<tiles:insertAttribute name="common-meta" />
<tiles:insertAttribute name="common-css" />
<tiles:insertAttribute name="common-javascript" />
</head>
<body>

	<!-- innerContent start -->
	<tiles:insertAttribute name="body" />			
	<!--// innerContent end -->
	
</body>
</html>