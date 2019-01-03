<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<script>
function fullScreen() {

    var targetUrl = "${targetUrl}";
    if (targetUrl.indexOf('realWorkTimePopup') == -1) {
    	//top.moveTo(0,0);
    	//top.resizeTo(screen.availWidth, screen.availHeight);
    }

	top.location = targetUrl;
}
</script>
</head>
<body onload="fullScreen()">
</body>
</html>