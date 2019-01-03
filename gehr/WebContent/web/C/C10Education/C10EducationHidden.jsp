<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>

<%
    String i_empNo = request.getParameter("i_empNo");
    String i_begda = request.getParameter("i_begda");
    String i_endda = request.getParameter("i_endda");
    String i_chaid = request.getParameter("i_chaid");

//  신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.
    C02CurriGetFlagRFC func_check = new C02CurriGetFlagRFC();
    String checkFlag  = func_check.check( i_empNo, i_begda, i_endda, i_chaid );
%>

<SCRIPT>
  parent.menuContentIframe.document.form3.checkFlag.value = "<%= checkFlag %>";
</SCRIPT>
