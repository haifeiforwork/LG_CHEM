<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>

<!-- ************************** 갑근세PDF. jsp        ************************-->
<!------------------------------------------------------------------------------>
<!-- System Name  : ESS                                                       -->
<!-- 1Depth Name  : 원천징수영수증                                            -->
<!-- 2Depth Name  : 원천징수영수증 신청                                       -->
<!-- Program Name : 원천징수영수증 신청                                       -->
<!-- Program ID   : A18DeductPrintFormEmbedGabgnse.jsp                        -->
<!-- Description  : 갑근세 출력화면 jsp                                       -->
<!-- Note         : 없음                                                      -->
<!-- Creation     :                                                           -->
<!-- Update       : 2012-07-23  lsa                                           -->
<!-- --------------------------------------------------------------------------->
<!-- DATE      AUTHOR                 DESCRIPTION                             -->
<!-- ------------------------------------------------------------------------ -->
<!--   ESS 갑근세 출력 PDF 변환                        -->
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
<embed type="application/pdf" src="<%= WebUtil.JspPath %>A/A18Deduct/A18DeductPrintFormGabgnse.jsp?sPerNR=<%=sPerNR%>&sTargetYear=<%=sTargetYear%>&sAinfSeqn=<%=sAinfSeqn%>#toolbar=0&navpanes=0&scrollbar=0" id="pdfDocument" width="100%" height="675"></embed>

</body>
</html>