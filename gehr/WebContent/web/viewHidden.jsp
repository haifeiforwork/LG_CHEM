<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>

<%
    String p_empl_numb = (String)request.getAttribute("p_empl_numb");
    String address = (String)request.getAttribute("address");
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
goHris();

function goHris() {
	var username = "<%=DataUtil.decodeEmpNo(p_empl_numb) %>";
	var eco_url = "<%=address %>";
	eco_url += "?p_empl_numb=" + username;
	eco_url += "&p_pass_word=" + "";
	eco_url += "&p_eval_year=" + "";
	eco_url += "&p_gubun=" + "ESSMENU";

    newWindow = window.open(eco_url, 'HRIS', 'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=yes,resizable=1,left=0,top=0,width=795,height=595');
    newWindow.focus();
}
-->

</SCRIPT>
