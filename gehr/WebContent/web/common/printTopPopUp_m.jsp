<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="commonProcess_m.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<script language="javascript">
    // [CSR ID:2763588] 급여명세표 수정 2015-04-30  [CSR ID:2763588] E-HR 급여명세표 출력관련 변경 요청의 건
    function f_print(){
         if( confirm("<spring:message code='MSG.COMMON.0059' />") ) {  //① [파일]->[페이지 설정]에서 다음과 같이 설정하시기 바랍니다.  \n\n용지크기\t\t: A4\n머리글/바닥글\t: 내용 삭제\n방향\t\t: 세로\n여백(밀리미터)\t: 왼쪽 19.05 위쪽 19.05\n용지옵션\t\t: 배경색 및 이미지 인쇄  체크

              parent.beprintedpage.focus();
              parent.beprintedpage.print();
        }

    }
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<div style="margin:0 20px; padding:7px 0; border-top:1px solid #ddd;">
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" href="javascript:f_print();"><span><spring:message code='LABEL.COMMON.0001' /><!-- 인쇄하기 --></span></a></li>
			<li><a href="javascript:top.close();"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
		</ul>
	</div>
</div>
<%@ include file="commonEnd.jsp" %>
