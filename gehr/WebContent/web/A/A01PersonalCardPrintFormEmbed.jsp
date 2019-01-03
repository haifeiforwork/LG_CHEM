<%@ page contentType="text/html; charset=utf-8" %> 
<%@ page import="com.sns.jdf.util.WebUtil" %>
 
<!-- ************************** 인사기록부 PDF. jsp        ************************-->
<!------------------------------------------------------------------------------>
<!-- Program ID   : A01PersonalCardPrintFormEmbed.jsp                        -->
<!-- Description  : 인사기록부  출력화면 jsp                                       -->
<!-- Note         : 없음                                                      -->
<!-- Creation     :   2013/05/30                                                        -->
<!-- --------------------------------------------------------------------------->
<!-- DATE      AUTHOR                 DESCRIPTION                             -->
<!-- ------------------------------------------------------------------------ -->   
<!-- 2014/06/09 이지은D    [CSR ID:2553584] 인사기록부 출력 포맷 변경   ESS 인사기록부 출력 PDF 변환                                              -->      
<!------------------------------------------------------------------------------>

<%
      // Get Request Attribute
      String pernr      = (String) request.getAttribute("pernr");
      String Screen = (String) request.getAttribute("Screen");
      String LeaderPernr   = (String) request.getAttribute("LeaderPernr");

%>
<html>
<head>
<title>E-HR</title>
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
<embed type="application/pdf" src="<%= WebUtil.JspPath %>A/A01PersonalCardPrintForm.jsp?pernr=<%=pernr%>&Screen=<%=Screen%>&LeaderPernr=<%=LeaderPernr%>#toolbar=0&navpanes=0&scrollbar=0" id="pdfDocument" width="100%" height="5550"></embed>

</body>
</html> 