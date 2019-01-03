<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 
/*   Program ID   : D25WorkTimeCommonPreprocess.jsp
/*   Description  : 주 52시간 근무제 프로그램 공통 include jsp
/*   Note         : 
/*   Creation     : 2018-05-09 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/
--%><%@ page contentType="text/html; charset=utf-8" %><%
%><%@ include file="/web/common/commonProcess.jsp" %><%
%><%@ include file="/web/common/commonResponseHeader.jsp" %><%

request.setAttribute("timestamp", new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(java.util.Calendar.getInstance().getTime()));
request.setAttribute("Draggable", "Y");

%>