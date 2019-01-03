<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/include/includeCommon.jsp"%>
<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
%>
<html>
<head>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<title>ESS</title>
<script language="javascript">
    function f_print(){

        if( confirm("<spring:message code='MSG.COMMON.0076' />") ) {  //① [도구]->[인터넷 옵션]->[고급]->[인쇄]의 [배경색 및 이미지 인쇄]를 체크하시기 바랍니다.\n\n② [파일]->[페이지 설정]에서 다음과 같이 설정하시기 바랍니다.  \n\n용지크기\t\t: A4\n머리글/바닥글\t: 내용 삭제\n방향\t\t: 세로\n여백(밀리미터)\t: 왼쪽 6.01 오른쪽 6.01 위쪽 4.23 아래쪽 4.23
            parent.beprintedpage.focus();
            parent.beprintedpage.print();
        }
    }
</script>
</head>


<body bgcolor="#FFFFFF" text="#000000">
	<div class="buttonArea">
		<ul class="btn_crud">
		    <li><a href="javascript:f_print();"><span><%=g.getMessage("LABEL.COMMON.0001")%></span></a></li>
		    <li><a class="darken" href="javascript:top.close();"><span><%=g.getMessage("LABEL.COMMON.0002")%></span></a></li>
		</ul>
	</div>
<%@ include file="commonEnd.jsp" %>

