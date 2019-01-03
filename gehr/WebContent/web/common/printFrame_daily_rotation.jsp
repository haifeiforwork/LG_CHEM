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
    String hdn_deptId  = (String)request.getParameter("hdn_deptId");
    String hdn_excel  = (String)request.getParameter("hdn_excel");
    String year1  = (String)request.getParameter("year1");
    String month1  = (String)request.getParameter("month1");
    String checkYn  = (String)request.getParameter("checkYn");

    if(Integer.parseInt(month1)<10){
    	month1 = "0"+month1;
    }


    targetPage = WebUtil.ServletURL+"hris.F.F43DeptDayWorkConditionSV?hdn_deptId="+hdn_deptId+",hdn_excel="+hdn_excel+",year1="+year1+",month1="+month1+",chck_yeno="+checkYn;

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
  <frame name="beprintedpage" src="<%=WebUtil.JspURL %>F/F43DeptDayWorkCondition_wait.jsp?targetPage=<%= targetPage %>" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO">
  <frame name="prt" scrolling="NO" noresize src="<%= WebUtil.JspURL %>common/printTopPopUp_rotation.jsp" frameborder="NO" marginwidth="0" marginheight="0" >
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
<% response.flushBuffer();%>
