<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="commonProcess.jsp" %>
<%@ page import="hris.common.DraftDocForEloffice" %>
<%@ page import="hris.common.ElofficInterfaceData" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="com.lgchem.esb.adapter.ESBAdapter" %>
<%@ page import="com.lgchem.esb.adapter.LGChemESBService" %>
<%@ page import="com.lgchem.esb.exception.ESBTransferException" %>
<%@ page import="com.lgchem.esb.exception.ESBValidationException" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
  String msg = (String)request.getAttribute("msg");
  String msg2 = (String)request.getAttribute("msg2");
  String url = (String)request.getAttribute("url");
  String message = (String)request.getAttribute("message");
  if (message ==null){
     message = "";
  }
    if (message == null || message.equals("")) {
    	if ( msg != null ) {
    	    msg = msg.toLowerCase();
    	    if ( msg.substring(0,3).equals("msg") ) {
    	        if( msg.equals("msg001") ) {
    	            message = g.getMessage("MSG.COMMON.0001"); //신청 되었습니다.
    	        } else if( msg.equals("msg002") ) {
    	            message = g.getMessage("MSG.COMMON.0002"); //수정 되었습니다.
    	        } else if( msg.equals("msg003") ) {
    	            message = g.getMessage("MSG.COMMON.0003"); //삭제 되었습니다.
    	        } else if( msg.equals("msg004") ) {
    	            message = g.getMessage("MSG.COMMON.0004"); //해당하는 데이타가 존재하지 않습니다.
    	        } else if( msg.equals("msg005") ) {
    	            message = g.getMessage("MSG.COMMON.0005"); //결재가 진행중 입니다.
    	        } else if( msg.equals("msg006") ) {
    	            message = g.getMessage("MSG.COMMON.0006"); //계좌번호가 등록되지 있지 않습니다.
    	        } else if( msg.equals("msg007") ) {
    	            message = g.getMessage("MSG.COMMON.0007"); //입력 되었습니다.
    	        } else if( msg.equals("msg008") ) {
    	            message = g.getMessage("MSG.COMMON.0008"); //저장 되었습니다.
    	        } else if( msg.equals("msg009") ) {
    	            message = g.getMessage("MSG.COMMON.0009"); //결재 되었습니다.
    	        } else if( msg.equals("msg010") ) {
    	            message = g.getMessage("MSG.COMMON.0010"); //반려 되었습니다.
    	        } else if( msg.equals("msg011") ) {
    	            message = g.getMessage("MSG.COMMON.0011"); //결재 취소 되었습니다.
    	        } // end if
    	    } else {
    	      message = msg;
    	    } // end if
    	} // end if
    }
    if (msg2 != null && !msg2.equals("")) {
         message = message + "\\n" +msg2;
    } // end if

    Configuration conf = new Configuration();
    boolean isDev = conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP");


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE> New Document </TITLE>
<script language='javascript'>


    // 메시지
    function show_waiting_smessage(div_id ,message ,isVisible)
    {
        // alert(document.body.scrollLeft + "\t ," + document.body.scrollTop);
        var _x = document.body.clientWidth/2 + document.body.scrollLeft-120;
        var _y = document.body.clientHeight/2 + document.body.scrollTop+50;
        job_message.innerHTML = message;
        document.all[div_id].style.posLeft=_x;
        document.all[div_id].style.posTop=_y;
        document.all[div_id].style.visibility= isVisible ;
    } // end function

	function chkDone()
	{
	   show_waiting_smessage("waiting" ,"" ,'hidden')
		alert('<%= message %>');
	   <%= url %>;
	}

	function init()
	{
	//@v1.1 : 06.05.11 전자결재삭제하기로 함
	chkDone();

    	/*setTimeout("chkDone()" ,1500);*/
    }

</script>
</HEAD>
<BODY  <%= isDev ? "" : "onload='init();'" %>>
<DIV id="waiting" style="Z-INDEX: 1; LEFT: 250px; VISIBILITY: visible; WIDTH: 250px; POSITION: absolute; TOP: 200px; HEIGHT: 45px">
<TABLE cellSpacing=1 cellPadding=0 width="98%" bgColor=black border=0>
  <TBODY>
  <TR bgColor=white>
    <TD>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD class=icms align=middle height=70 id = "job_message"><spring:message code='MSG.COMMON.0069' /><!-- 통합결재 연동중 ... <br>잠시만 기다려주십시요 --> </TD>
        </TR>
        </TBODY>
      </TABLE>
    </TD>
  </TR>
  </TBODY>
</TABLE>
</DIV>
    <% if (isDev) {%>
        <a href="javascript:init()"> <spring:message code='MSG.COMMON.0068' /><!-- Eloffic 연동 --> </a>
    <% } // end if %>

</body>
</html>
</BODY>
</HTML>
