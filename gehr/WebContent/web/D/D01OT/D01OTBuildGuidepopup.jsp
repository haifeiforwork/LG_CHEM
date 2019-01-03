<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : .                                               */
/*   2Depth Name  : 초과근무 신청 시 여수사업장의 경우 popup 알람 생성                                               */
/*   Program Name : 초과근무 신청/수정 시 popup 알람 생성 (onload 시 생성 팝업)                                               */
/*   Program ID   : D01OTBuildGuidepopup.jsp                                                */
/*   Description  :                                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2015-12-16 [CSR ID:2941146] 여수공장 근무시간 관련                                           */
/*   Update       :   */
/*                     */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*"%>
<%@ page session="false" %>

<jsp:include page="/include/header.jsp" />

<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D01.0016"/>  
    <jsp:param name="help" value="A03Account.html"/>    
    <jsp:param name="css" value="/image/css/ui_library_approval.css"/>    
</jsp:include>


<image src="<%=WebUtil.ImageURL%>/ehr/yeosu_OTGuide.gif" height ="290" width="490">


<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
