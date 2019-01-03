<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
// 처음 jsp 에서 받는 부분
    String jobid      = request.getParameter("jobid");
    String imgidx     = request.getParameter("IMGIDX");       //IMGIDX == 3이면 KSEA, IMGIDX == 4이면 Process
    String i_sobid    = request.getParameter("SOBID");
    String i_begda    = request.getParameter("BEGDA");        //Job 시작일
    String e_match    = request.getParameter("e_match");      //upload 파일 존재여부

//  생성, 수정 구분
    String jobidPop   = request.getParameter("jobidPop");
%>
<script>
</script>
<html>
<head>
<title>ESS</title>
</head>

<frameset rows="*,0"> 
  <frame name="UpPopMain"   src="<%= WebUtil.JspURL %>J/J03JobCreate/J03FileUpLoadPopup.jsp?jobid=<%= jobid %>&IMGIDX=<%= imgidx %>&SOBID=<%= i_sobid %>&BEGDA=<%= i_begda %>&jobidPop=<%= jobidPop %>&e_match=<%= e_match %>" frameborder="NO" marginwidth="0" marginheight="0" noresize>
  <frame name="UpPopBottom" src="" frameborder="NO" marginwidth="0" marginheight="0" noresize>
</frameset>

<noframes> 
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes> 
</html>  