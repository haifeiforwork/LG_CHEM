<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String targetPage = null;
    String hdn_deptId  = (String)request.getParameter("hdn_deptId");
    String hdn_deptNm  = (String)request.getParameter("hdn_deptNm");
    String jobid  = (String)request.getParameter("jobid");
    String t_year  = (String)request.getParameter("t_year");
    String t_month  = (String)request.getParameter("t_month");
    String I_GBN  = (String)request.getParameter("I_GBN");
    String I_SEARCHDATA  = (String)request.getParameter("I_SEARCHDATA");



    targetPage = WebUtil.ServletURL+"hris.D.D12Rotation.D12RotationBuildSV?jobid="+jobid+",hdn_deptId="+hdn_deptId+",hdn_deptNm="+hdn_deptNm+",t_year="+t_year+",t_month="+t_month+",I_GBN="+I_GBN+",I_SEARCHDATA="+I_SEARCHDATA;



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
<html>
<head>
<title>e-HR</title>
</head>
<frameset rows="*,50" frameborder="NO" border="0" framespacing="0">
<frame name="beprintedpage" src="<%=WebUtil.JspURL %>D/D12Rotation/D12RotationDetail_wait.jsp?targetPage=<%= targetPage %>" marginwidth="0" marginheight="0" scrolling="AUTO" frameborder="NO">
  <frame name="prt" scrolling="NO" noresize src="<%= WebUtil.JspURL %>common/printTopPopUp_rotation_build.jsp" frameborder="NO" marginwidth="0" marginheight="0" >
</frameset>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
</html>
<% response.flushBuffer();%>

