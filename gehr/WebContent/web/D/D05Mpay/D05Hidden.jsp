<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>

<%
    Vector d05ZocrsnTextData_vt = (Vector)request.getAttribute("d05ZocrsnTextData_vt");
    Logger.debug.println(this,d05ZocrsnTextData_vt.toString());
%>

<SCRIPT>
<%
    for ( int i = 0 ; i < d05ZocrsnTextData_vt.size() ; i++ ) {
//   CodeEntity data4 = (CodeEntity)d05ZocrsnTextData_vt.get(i);
     D05ZocrsnTextData data4 = (D05ZocrsnTextData)d05ZocrsnTextData_vt.get(i);

%>  
        //alert("parent:"+parent.name);
        //+"parent.frame[1].name:"+parent.forms[0].name);
        //@v1.1 EP메뉴로 인하여 수정   
        parent.document.form1.ZOCRSN.length = <%= i+1 %>;
        parent.document.form1.ZOCRSN[<%= i %>].value = "<%= data4.ZOCRSN + data4.SEQNR %>";
        parent.document.form1.ZOCRSN[<%= i %>].text  = "<%= data4.ZOCRTX %>";

        //parent.main_ess.document.form1.ZOCRSN.length = <%= i+1 %>;
        //parent.main_ess.document.form1.ZOCRSN[<%= i %>].value = "<%= data4.ZOCRSN + data4.SEQNR %>";
        //parent.main_ess.document.form1.ZOCRSN[<%= i %>].text  = "<%= data4.ZOCRTX %>";
        
<%  
    }  
%>   
</SCRIPT>
