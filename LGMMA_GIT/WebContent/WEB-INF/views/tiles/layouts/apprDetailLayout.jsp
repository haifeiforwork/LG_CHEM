<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@include file="/WEB-INF/views/tiles/template/cacheVersion.jsp"%>
	<!-- empInfo start -->
	<tiles:insertAttribute name="empInfo" />
	<!--// empInfo end -->
	<!-- body start -->
	<tiles:insertAttribute name="body" />
	<!--// body end -->
	<!-- decisioner start -->
	<tiles:insertAttribute name="decisioner" />
	<!--// decisioner end -->
	<!-- action start -->
	<tiles:insertAttribute name="action" />
	<!--// action end -->
