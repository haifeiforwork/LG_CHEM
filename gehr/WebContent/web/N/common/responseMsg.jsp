<%@ page contentType="text/html; charset=utf-8" %>

<%
    String msg = (String)request.getAttribute("msg");
    String msg2 = (String)request.getAttribute("msg2");
    String url = (String)request.getAttribute("url");
    String message = "";
    
    
    if (msg != null) {
	    msg = msg.toLowerCase();
	    if ( msg.substring(0,3).equals("msg") ) {
	        if( msg.equals("msg001") ) { // 심리,건강상담 이메일 전송시 메세지 처리 
	            message = "담당자에게 메일이 발송되었습니다.";
	        } else if( msg.equals("msg002") ) {
	            //message = "수정 되었습니다.";
	        } else if( msg.equals("msg003") ) {
	            message = "삭제 되었습니다.";
	        } else if( msg.equals("msg004") ) {
	            message = "해당하는 데이타가 존재하지 않습니다.";
	        } else if( msg.equals("msg005") ) {
	            message = "결재가 진행중 입니다.";
	        } else if( msg.equals("msg006") ) {
	            message = "계좌번호가 등록되지 있지 않습니다.";
	        } else if( msg.equals("msg007") ) {
	            message = "입력 되었습니다.";
	        } else if( msg.equals("msg008") ) {
	            message = "저장 되었습니다.";
	        } else if( msg.equals("msg009") ) {
	            message = "결재 되었습니다.";
	        } else if( msg.equals("msg010") ) {
	            message = "반려 되었습니다.";
	        } else if( msg.equals("msg011") ) {
                message = "결재 취소 되었습니다.";
	        } else if( msg.equals("msg012") ) {
                message = "확정 처리되었습니다.";
	        } else if( msg.equals("msg013") ) {
                message = "확정 실패입니다.";
            } else if( msg.equals("msg014") ) {
                message = "확정 실패입니다.";//"부서구분 번호가 없습니다. 인사담당자에게 문의하시기 바랍니다.";//@2014 연말정산 추가(송현우K 요청)
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
