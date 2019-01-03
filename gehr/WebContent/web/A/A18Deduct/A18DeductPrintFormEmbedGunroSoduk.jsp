<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>


<!-- ************************** 원천징수영수증PDF. jsp  ************************-->
<!------------------------------------------------------------------------------>
<!-- System Name  : ESS                                                       -->
<!-- 1Depth Name  : 제증명서                                                                                                       -->
<!-- 2Depth Name  : 제증명서 신청                                                                                                -->
<!-- Program Name : 제증명서 신청                                                                                                -->
<!-- Program ID   : A18DeductPrintFormEmbedGunrosoduk.jsp                     -->
<!-- Description  : 원천징수 영수증 출력화면 jsp                                    -->
<!-- Note         : 없음                                                                                                             -->
<!-- Creation     :                                                           -->
<!-- Update       : 2010-04-09  지민재                                                                                  -->
<!-- --------------------------------------------------------------------------->
<!-- DATE      AUTHOR                 DESCRIPTION                             -->
<!-- ------------------------------------------------------------------------ -->
<!-- 2010.04.09 지민재  [CSR ID:1639484] ESS 원천징수 영수증 출력 PDF 변환                        -->
<!------------------------------------------------------------------------------>

<%
// Get Request Attribute
String sPerNR      = (String) request.getAttribute("sPerNR");
String sTargetYear = (String) request.getAttribute("sTargetYear");
String sAinfSeqn   = (String) request.getAttribute("sAinfSeqn");


%>
<html>
<head>
<title>ESS</title>
<script language="JavaScript">
<!--
function printDocument(documentId) {
    //Wait until PDF is ready to print
    if (typeof document.getElementById(documentId).print == 'undefined') {
        setTimeout(function(){printDocument(documentId);}, 1000);
    } else {
        var x = document.getElementById(documentId);
        x.print();
    }
}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" leftmargin="5" topmargin="5" marginwidth="5" marginheight="5">
<embed type="application/pdf" src="<%= WebUtil.JspPath %>A/A18Deduct/A18DeductPrintFormGunroSoduk.jsp?sPerNR=<%=sPerNR%>&sTargetYear=<%=sTargetYear%>&sAinfSeqn=<%=sAinfSeqn%>#toolbar=0&navpanes=0&scrollbar=0" id="pdfDocument" width="100%" height="675"></embed>

</body>
</html>