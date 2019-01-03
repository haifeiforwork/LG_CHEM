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
    Vector citycd = (Vector)request.getAttribute("citycd");
    //Logger.debug.println(this,citycd.toString()); 
%>

<SCRIPT>  
        parent.document.form1.CITYCD.length = 1;
        parent.document.form1.CITYCD[0].value = "";
        parent.document.form1.CITYCD[0].text  = "Select";
<%
   if(citycd!=null){
   

    for ( int i = 1 ; i < citycd.size()+1 ; i++ ) { 
      
      SearchAddrDataCn data = (SearchAddrDataCn)citycd.get(i-1);

%>  

 
        parent.document.form1.CITYCD.length = <%= i+1 %>;
        parent.document.form1.CITYCD[<%= i %>].value = "<%= data.CITYCD%>";
        parent.document.form1.CITYCD[<%= i %>].text  = "<%= data.CITYTX %>";
        parent.get2();
        
<%  
    }
      } 
    
    if(citycd==null || citycd.size()==0){
    %>
    	//parent.document.form1.CITYCD.length = 0;
    	parent.document.form1.CITYCD.length = 1;
        parent.document.form1.CITYCD[0].value = "";
        parent.document.form1.CITYCD[0].text  = "Select";
        parent.get2();
    <%	
    
    }
%>   
</SCRIPT>
