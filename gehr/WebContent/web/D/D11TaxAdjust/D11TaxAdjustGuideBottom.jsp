<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Random" %>

<%
    String targetYear = request.getParameter("targetYear");

    Random num    = new Random();
    String random = "";
    String url    = "";
    int    R_num  = num.nextInt(5);   // 0부터 4까지의 난수 발생

    R_num  = R_num + 1;               // 1부터 5까지의 난수 발생

    random = Integer.toString(R_num);

    url = "http://eloffice.lgchem.com:800" + random + "/welfare/" + targetYear + "/Tax_Top.htm";
    Logger.debug.println(url);
%>

<jsp:include page="/include/header.jsp" />
<FRAMESET rows="0,*" frameborder="NO" border="0" framespacing="0">
  <FRAME name="title"  marginwidth="0" marginheight="0" src="">
  <FRAME name="inform" marginwidth="0" marginheight="0" src="<%= url %>" scrolling="AUTO" frameborder="NO">
</FRAMESET>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
