<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.*" %>

 

<%
    Vector cntycd = (Vector)request.getAttribute("cntycd");
  //  Logger.debug.println(this,cntycd.toString()); 
%>
<SCRIPT> 
    	parent.document.form1.CNTYCD.length = 1;
        parent.document.form1.CNTYCD[0].value = "";
        parent.document.form1.CNTYCD[0].text  = "Select";
 
<%
if(cntycd!=null){
    for ( int i = 1 ; i < cntycd.size()+1 ; i++ ) { 
      
      SearchAddrDataCn data = (SearchAddrDataCn)cntycd.get(i-1);

%>  
 
        parent.document.form1.CNTYCD.length = <%= i+1 %>;
        parent.document.form1.CNTYCD[<%= i %>].value = "<%= data.CNTYCD%>";
        parent.document.form1.CNTYCD[<%= i %>].text  = "<%= data.CNTYTX %>";
 
        
<%  
    }
    }
    if(cntycd==null || cntycd.size()==0){
    %>
    	//parent.document.form1.CNTYCD.length = 0;
    	parent.document.form1.CNTYCD.length = 1;
        parent.document.form1.CNTYCD[0].value = "";
        parent.document.form1.CNTYCD[0].text  = "Select";
    <%	
    }
%>   
</SCRIPT>
