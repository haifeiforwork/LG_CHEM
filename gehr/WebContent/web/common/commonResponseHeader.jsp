<%--
/******************************************************************************/
/*   System Name  : 
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : commonResponseHeader.jsp
/*   Description  : 주 52시간 근무제 프로그램 공통 include jsp
/*   Note         : 
/*   Creation     : 2018-06-04 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/
--%><%@ page contentType="text/html; charset=utf-8" %><%

response.setHeader("Cache-Control", "no-store");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
if ("HTTP/1.1".equals(request.getProtocol())) response.setHeader("Cache-Control", "no-cache");

%>