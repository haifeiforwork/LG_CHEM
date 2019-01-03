<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<jsp:include page="/include/header.jsp" />
<%
    String targetPage = null;
    String isPopUp    = null;
    isPopUp       = (String)request.getAttribute("isPopUp");
    String viewMode  = (String)request.getParameter("viewMode");
    String SEARCH_EMPGUBUN  = (String)request.getParameter("SEARCH_EMPGUBUN");
    String SEARCH_GUBUN  = (String)request.getParameter("SEARCH_GUBUN");
    String SEARCH_DATE  = (String)request.getParameter("SEARCH_DATE");
    String SEARCH_DEPTID  = (String)request.getParameter("SEARCH_DEPTID");
    String SEARCH_INCLUDE_SUBDEPT  = (String)request.getParameter("SEARCH_INCLUDE_SUBDEPT");
    String SEARCH_PERNR  = (String)request.getParameter("SEARCH_PERNR");

    targetPage = WebUtil.ServletURL+"hris.D.D25WorkTime.D25WorkTimeLeaderReportSV?viewMode="+viewMode+",SEARCH_GUBUN="+SEARCH_GUBUN+",SEARCH_DATE="+SEARCH_DATE+",SEARCH_EMPGUBUN="+SEARCH_EMPGUBUN+",SEARCH_DEPTID="+SEARCH_DEPTID+",SEARCH_INCLUDE_SUBDEPT="+SEARCH_INCLUDE_SUBDEPT+",SEARCH_PERNR="+SEARCH_PERNR;

    Logger.debug.println(this, "targetPage["+targetPage+"], isPopUp["+isPopUp+"]");

    if( isPopUp == null ) {
        isPopUp = "";
    }

    if( targetPage == null || targetPage.equals("") ){
%>
        <SCRIPT LANGUAGE="JavaScript">
        <!--
          alert("<spring:message code='MSG.COMMON.0058' />"); //프린트 페이지를 오픈하던 중 오류가 발생했습니다.
          //history.back();
          self.close();
        //-->
        </SCRIPT>
<%
    }
%>

<frameset rows="*,50" frameborder="NO" border="0" framespacing="0">
  <frame name="beprintedpage" src="<%=WebUtil.JspURL %>D/D25WorkTime/D25WorkTime52Report_wait.jsp?targetPage=<%= targetPage %>" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO">
  <frame name="prt" scrolling="NO" noresize src="<%= WebUtil.JspURL %>common/printTopPopUp_rotation.jsp" frameborder="NO" marginwidth="0" marginheight="0" >
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
<% response.flushBuffer();%>
