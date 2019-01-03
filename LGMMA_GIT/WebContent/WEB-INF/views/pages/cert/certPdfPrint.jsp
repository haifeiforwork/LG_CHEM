<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>LG MMA</title>
<!-- basic -->
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_jquery.css" />
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-1.9.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-ui-1.10.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/common.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/pdfobject.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var AINF_SEQN = '<c:out value="${AINF_SEQN}"/>';
	var options = {
	    id: "embedPrint",
		fallbackLink: false,
	    pdfOpenParams: { view: 'FitH',  toolbar:1 }
	};
	var pdf = PDFObject.embed("/cert/requestCertificatePrint?AINF_SEQN="+AINF_SEQN,"#pdfRenderer", options);
	
	
});

</script>
</head>
<body>
<div id="pdfRenderer"></div>
</body>
</html>