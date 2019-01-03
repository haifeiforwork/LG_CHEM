<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String targetPage = null;
    String hdn_deptId  = (String)request.getParameter("hdn_deptId");
    String I_SEARCHDATA  = (String)request.getParameter("I_SEARCHDATA");
    String jobid  = (String)request.getParameter("jobid");
    String I_DATE  = (String)request.getParameter("I_DATE");
    String I_GBN  = (String)request.getParameter("I_GBN");


    String E_OTEXT  = (String)request.getParameter("E_OTEXT");
    if( hdn_deptId == null|| hdn_deptId.equals("")) {
        hdn_deptId = I_SEARCHDATA;           //1번째 조회시
    }

    targetPage = WebUtil.ServletURL+"hris.D.D12Rotation.D12RotationSV?jobid="+jobid+",hdn_deptId="+hdn_deptId+",I_DATE="+I_DATE+",I_SEARCHDATA="+I_SEARCHDATA+",I_GBN="+I_GBN;

    //out.println("targetPage:"+targetPage);

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
<frameset rows="*,50" frameborder="NO" border="0" framespacing="0">
  <frame name="beprintedpage" src="<%=WebUtil.JspURL %>D/D12Rotation/D12RotationDetail_wait.jsp?targetPage=<%= targetPage %>" marginwidth="0" marginheight="0" scrolling="AUTO" frameborder="NO">
  <frame name="prt" scrolling="NO" noresize src="<%= WebUtil.JspURL %>common/printTopPopUp_Day_rotation.jsp" frameborder="NO" marginwidth="0" marginheight="0" >
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
<jsp:include page="/include/footer.jsp" />
<% response.flushBuffer();%>

