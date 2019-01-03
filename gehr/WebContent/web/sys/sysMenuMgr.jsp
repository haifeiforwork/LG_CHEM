<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%
    String initMenuCode = request.getParameter("MenuCode");
%>
<html>
<head>
<title>메뉴관리</title>
<script language="JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

// 상태바 보여주게 - 류동원씨가 요청  2004.11.03 YJH  -------------------------------------
var st = new Array(" ♠개인목표 수정은 개인평가시스템 접속을 통해 연중 가능하오니 평가자와의 협의를 통해 " ," 목표수정을 하시기 바랍니다.(문의사항은 인사팀 3-7838,3771로 하여 주시기 바랍니다.) ");
var x = 0; pos = 0;
var l = st[0].length;

// -->
</script>
</head>
<frameset rows="*" cols="300,*" frameborder="NO" border="0" framespacing="0">
    <frame name="MenuTree"   src="<%= WebUtil.ServletURL%>hris.sys.SysMenuTreeSV?MenuCode=<%=initMenuCode%>" frameborder="NO" noresize marginwidth="0" marginheight="0">
    <frame name="MenuDetail" src="" frameborder="NO" marginwidth="0" marginheight="0" >
</frameset>
<noframes>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
</html>
