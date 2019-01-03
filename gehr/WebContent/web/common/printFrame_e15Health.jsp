<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String targetPage = null;
    String isPopUp    = null;
    isPopUp       = (String)request.getAttribute("isPopUp");
    String pernr  = (String)request.getParameter("PERNR");
    String year  = (String)request.getParameter("YEAR");
    String jobid_m  = (String)request.getParameter("jobid_m");

    targetPage = WebUtil.ServletURL+"hris.E.E16Health.E16HealthCardSV?PERNR="+pernr+"&YEAR="+year+"&jobid_m="+jobid_m;
   // out.println("tt:"+targetPage);
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
<jsp:include page="/include/header.jsp" />
<frameset rows="*,50"  frameborder="NO" border="0" framespacing="0">

  <frame name="beprintedpage" src="<%= targetPage %>" marginwidth="0" marginheight="0" scrolling="AUTO" frameborder="NO">
  <frame name="prt" scrolling="NO" noresize src="<%= WebUtil.JspURL %>common/printTopPopUp_e15health.jsp?jobid_m=<%=jobid_m%>" frameborder="NO" marginwidth="0" marginheight="0" >
</frameset>

<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
<jsp:include page="/include/footer.jsp" />
<% response.flushBuffer();%>


