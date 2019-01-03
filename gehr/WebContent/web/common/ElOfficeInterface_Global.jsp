<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="hris.common.ElofficInterfaceData_Global" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
    String msg = (String)request.getAttribute("msg");
    String msg2 = (String)request.getAttribute("msg2");
    String url = (String)request.getAttribute("url");
    String message = "";
    if (msg != null && !msg.equals("")) {
        msg = msg.toLowerCase();
        if ( msg.substring(0,3).equals("msg") ) {
            if( msg.equals("msg001") ) {
                message = g.getMessage("MSG.COMMON.0001");  //신청 되었습니다. //Applied.
            } else if( msg.equals("msg002") ) {
                message = g.getMessage("MSG.COMMON.0002");  //수정 되었습니다. //Corrected.
            } else if( msg.equals("msg003") ) {
                message = g.getMessage("MSG.COMMON.0003"); //삭제 되었습니다. //Deleted.
            } else if( msg.equals("msg004") ) {
                message = g.getMessage("MSG.COMMON.0004"); //Applicant data is not existed.
            } else if( msg.equals("msg005") ) {
                message = g.getMessage("MSG.COMMON.0005"); //Approving.
            } else if( msg.equals("msg006") ) {
                message = g.getMessage("MSG.COMMON.0006"); //Account number is not registered.
            } else if( msg.equals("msg007") ) {
                message = g.getMessage("MSG.COMMON.0007"); //Inputted
            } else if( msg.equals("msg008") ) {
                message = g.getMessage("MSG.COMMON.0008");  //Saved.
            } else if( msg.equals("msg009") ) {
                message = g.getMessage("MSG.COMMON.0009");  //Approved.
            } else if( msg.equals("msg010") ) {
                message = g.getMessage("MSG.COMMON.0010"); //Rejected.
            } else if( msg.equals("msg011") ) {
                message = g.getMessage("MSG.COMMON.0011"); //Approval is canceled.
            } // end if
        } else {
          message = msg;
        } // end if
    } // end if

    if (msg2 != null && !msg2.equals("")) {
         message = message + "\\n" +msg2;
    } // end if

    WebUserData user = (WebUserData)session.getAttribute("user");
    Vector vcEof = (Vector) request.getAttribute("vcElofficInterfaceData_Global");
    Configuration conf = new Configuration();
    boolean isDev = conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP");  //false 200708
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
	return;
	<%  for (int i = 0; i < vcEof.size(); i++) { %>
		document.form<%=i%>.submit();
    <% } // end for %>
    	/*setTimeout("chkDone()" ,1500);*/
    }

</script>
</HEAD>
<BODY  <%= isDev ? "" : "onload='init();'" %>>
<DIV id="waiting" style="Z-INDEX: 1; LEFT: 250px; VISIBILITY: visible; WIDTH: 250px; POSITION: absolute; TOP: 200px; HEIGHT: 45px">
<TABLE cellSpacing=1 cellPadding=0 width="98%" bgColor=black border=0>
  <TBODY>
  <TR bgColor=blue>
    <TD>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
<!--          <TD class=icms align=middle height=70 id = "job_message">ElOffice 연동중 ... <br>잠시만 기다려주십시요 </TD>-->
          <TD class=icms align=middle height=70 id = "job_message"><spring:message code='MSG.COMMON.0067' /><!-- 연동중 ... <br>잠시만 기다려주십시요 --> </TD>  <!-- 处理中...请稍等 -->
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
<%  for (int i = 0; i < vcEof.size(); i++) { %>
    <%  ElofficInterfaceData_Global  eof = (ElofficInterfaceData_Global)vcEof.get(i);%>
<form name="form<%=i%>" method="post" target = "ifmifmCtl<%=i%>"  action="http://<%=eof.SServer%>/App/Approval.nsf/CreateApprovalLinkEHR?CreateDocument">
    <input type="hidden" name="SaveOptions" value="1">
    <input type="hidden" name="Server_Name"   value="">
    <input type="hidden" name="WebDbName"   value="">
    <input type="hidden" name="Subject" value="<%=eof.Subject%>">
    <input type="hidden" name="DocID"   value="<%=eof.DocID%>">
    <input type="hidden" name="LinkURL"                value="http://<%=eof.LinkURL%>/servlet/hris.ElApprovalAutoLoginSV?AINF_SEQN=<%=eof.DocID%>">
	<input type="hidden" name="HDocStatus"             value="<%=eof.HDocStatus%>">
	<input type="hidden" name="WriterSabun"            value="<%=eof.WriterSabun%>">
	<input type="hidden" name="HCurApproverSabun"      value="<%=eof.HCurApproverSabun%>">
	<input type="hidden" name="HDoneApproverSabun"     value="<%=eof.HDoneApproverSabun%>">
	<input type="hidden" name="HrealApproverListSabun" value="<%=eof.HrealApproverListSabun%>">
	<input type="hidden" name="HMApproverSabun"        value="<%=eof.HMApproverSabun%>">
	<input type="hidden" name="HinvApprover"           value="<%=eof.HinvApprover%>">
	<input type="hidden" name="HinvApproverList"       value="<%=eof.HinvApproverList%>">
<!--
	<input type="hidden" name="FeedBackScript"         value="parent.Feedback('<%=i%>');">
	<input type="hidden" name="FeedBackScript"         value="location.href='http://<%=eof.LinkURL%>/FeedBack.jsp;'">
-->
</form>
<iframe name='ifmifmCtl<%=i%>' <%= isDev ? "width='200' height='50' frameborder='1'" : "width='0' height='0' frameborder='0' " %>  ></iframe>
<% } // end for %>
</body>
</html>
</BODY>
</HTML>
