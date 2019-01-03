<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E31InfoStatus.*" %>
<%@ page import="hris.E.E31InfoStatus.rfc.*" %>

<%
    Vector E31InfoNameData_vt = (Vector)request.getAttribute("E31InfoNameData_vt");
    String MGART = (String)request.getAttribute("MGART");
%>
<SCRIPT>
    parent.main_ess.topPage.document.form1.MGART.length = 1; // 초기화
<%
    int ins = 2;
    int cnt = 0;
    for ( int i = 0 ; i < E31InfoNameData_vt.size() ; i++ ) {
        E31InfoNameData data4 = (E31InfoNameData)E31InfoNameData_vt.get(i);
%>
        parent.main_ess.topPage.document.form1.MGART.length = <%= ins %>;
        parent.main_ess.topPage.document.form1.MGART[<%= ins-1 %>].value = "<%= data4.MGART %>";
        parent.main_ess.topPage.document.form1.MGART[<%= ins-1 %>].text  = "<%= data4.STEXT %>";
<%
        if ( MGART.equals(data4.MGART) ) {
%>
        parent.main_ess.topPage.document.form1.MGART[<%= ins-1 %>].selected = true;
<%
            cnt++;
        }
%>
<%
        ins++;
    }
%>

<%
    if ( cnt == 0 ) {
%>
        parent.main_ess.topPage.document.form1.MGART[0].selected = true;
<%
    }
%>
</SCRIPT>

