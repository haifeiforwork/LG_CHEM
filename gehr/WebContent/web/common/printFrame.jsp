<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String targetPage = null;
    String isPopUp    = null;
    isPopUp    = (String)request.getAttribute("isPopUp");
    targetPage = (String)request.getAttribute("print_page_name");
    Logger.debug.println(this, targetPage+"   "+isPopUp);
    if( isPopUp == null ) {
        isPopUp = "";
    }

    if( targetPage == null || targetPage.equals("") ){
%>
        <SCRIPT LANGUAGE="JavaScript">
        <!--
         // alert("프린트 페이지를 오픈하던 중 오류가 발생했습니다.");
        alert("<%=g.getMessage("MSG.COMMON.0058")%>");
          //history.back();
          self.close();
        //-->

        </SCRIPT>
<%
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<jsp:include page="/include/header.jsp" />
<frameset id="printFrame" name="printFrame" rows="*,50" frameborder="NO" border="0" framespacing="0">
    <frame id="beprintedpage" name="beprintedpage"  src="<%= targetPage %>" marginwidth="0" marginheight="0"  scrolling="AUTO" frameborder="NO">
    <frame name="prt" scrolling="NO" noresize src="<%= WebUtil.JspURL %>common/<%= isPopUp.equals("false") ? "printTop.jsp" : "printTopPopUp.jsp" %>" frameborder="NO" marginwidth="0" marginheight="0" >

</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
<% response.flushBuffer();%>
