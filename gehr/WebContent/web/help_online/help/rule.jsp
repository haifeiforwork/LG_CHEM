<%@ page contentType="text/html; charset=utf-8" %>
<%--@ include file="/web/common/commonProcess.jsp" --%>

<%
    String      mName = request.getParameter("param");
    if ( mName.equals("contents.html") ) {
        mName="contentsRule.html";
    }
%>

<html>
<head>
<script>
function autoResize(target) {
    var iframeHeight =  target.contentWindow.document.body.scrollHeight;
    target.height = iframeHeight + 50;
}
</script>
</head>
<title>HR 제도안내</title>


<iframe id="listFrame" name="listFrame" src="/web/help_online/help/html/<%= mName %>"  width="100%" height="90%" marginwidth="0" marginheight="0" frameborder="0" scrolling="yes" onload="autoResize(this);"></iframe>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</html>
