<%@ page contentType="text/html; charset=utf-8" %>

<%
    String msg = (String)request.getAttribute("msg");
    String msg2 = (String)request.getAttribute("msg2");
    String url = (String)request.getAttribute("url");
    String message = "";
    if (msg != null && !msg.equals("")) {
	    if ( msg.toLowerCase().substring(0,3).equals("msg") ) {
	        if( msg.equals("msg001") ) {
	            message = "Applied.";
	        } else if( msg.equals("msg002") ) {
	            message = "Corrected.";
	        } else if( msg.equals("msg003") ) {
	            message = "Deleted.";
	        } else if( msg.equals("msg004") ) {
	            message = "Applicant data is not existed.";
	        } else if( msg.equals("msg005") ) {
	            message = "Approving.";
	        } else if( msg.equals("msg006") ) {
	            message = "Account number is not registered.";
	        } else if( msg.equals("msg007") ) {
	            message = "Inputted.";
	        } else if( msg.equals("msg008") ) {
	            message = "Saved.";
	        } else if( msg.equals("msg009") ) {
	            message = "Approved.";
	        } else if( msg.equals("msg010") ) {
	            message = "Returned.";
	        } else if( msg.equals("msg011") ) {
                message = "Approval is canceled.";
            } // end if
	    } else {
	      message = msg;
	    } // end if
    } // end if
    
    if (msg2 != null && !msg2.equals("")) {
         message = message + "\\n" +msg2;
    } // end if
    
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
    <% if (message != null && !message.equals("")) {%>
        alert('<%= message %>');
    <% } // end if %>
    
    <%= url %>
//-->
</SCRIPT>
