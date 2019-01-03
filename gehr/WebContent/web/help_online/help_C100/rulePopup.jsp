
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS ?                                                         */
/*   1Depth Name  : 공통  ?                                                    */
/*   2Depth Name  :                                                             */
/*   Program Name : 주택자금신청 담당자 조회                                                 */
/*   Program ID   : ContactListPop.jsp                                            */
/*   Description  : 주택자금신청 담당자 조회 PopUp                                           */
/*   Note         : 담당자 버튼 클릭 시 나오는 화면                                        */
/*   Creation     : 2016-05-27 김불휘S [CSR ID:C20160526_74869]                                         */
/*   Update       : 2017-05-12  eunha  [CSR ID:3377485] 담당자 변경 수정 건                                                          */
/*   Update       : 2017-07-12  eunha  [CSR ID:3430087] 담당자 변경 수정 건                                                          */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
 <%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/web/common/popupPorcess.jsp" %>



<html>
<head>
<title></title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
</head>
<body>
<div class="winPop">
	<div class="header">
    	<span>안내</span>
		<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
    </div>
    <div class="body">
    	<div class="listArea">
인사체계 개편 관련 HR 제도 업데이트 중입니다.
      	</div>
    	<ul class="btn_crud close">
    		<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a>
    	</ul>
    </div>




</div>

</body>
</html>

