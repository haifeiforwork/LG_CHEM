<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 안내/신청                                          */
/*   Program ID   : C02CurriSearch.jsp                                          */
/*   Description  : 교육과정 정보를 가져오는 화면                               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  박영락                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    String           gubun = (String)request.getAttribute("gubun");
    C02CurriInfoData key   = (C02CurriInfoData)request.getAttribute("C02CurriInfoData");
    String PERNR = (String)request.getAttribute("PERNR");
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>
<html>
<head>
</head>
<%
    if ("Y".equals(user.e_representative) ) {
%>
<frameset rows="218,*" frameborder="NO" border="0" framespacing="0">
<%
    } else {
%>   
<frameset rows="148,*" frameborder="NO" border="0" framespacing="0">
<%
    }
%> 

<%
    if( gubun.equals("1") ) {
%>
  <frame name="topPage" scrolling="NO" noresize src="<%= WebUtil.JspURL %>C/C02Curri/C02CurriSearchTop.jsp?gubun=<%= gubun %>&I_FDATE=<%= key.I_FDATE %>&I_TDATE=<%= key.I_TDATE %>&I_BUSEO=<%= key.I_BUSEO %>&I_GROUP=<%= key.I_GROUP %>&I_LOCATE=<%= key.I_LOCATE %>&I_DESCRIPTION=<%= key.I_DESCRIPTION %>&PERNR=<%= PERNR %>&RequestPageName=<%= RequestPageName %>" frameborder="NO" marginwidth="0" marginheight="0" >
<%
    } else {
%>
  <frame name="topPage" scrolling="NO" noresize src="<%= WebUtil.JspURL %>C/C02Curri/C02CurriSearchTop.jsp?gubun=''&PERNR=<%= PERNR %>&RequestPageName=<%= RequestPageName %>" frameborder="NO" marginwidth="0" marginheight="0" >
<%
    }
%>
  <frame name="endPage" src="" marginwidth="0" marginheight="0" frameborder="NO" scrolling="AUTO">
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
</html>
<%@ include file="/web/common/commonEnd.jsp" %>
