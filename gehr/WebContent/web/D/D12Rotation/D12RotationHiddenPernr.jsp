<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사번,성명찾기                                               */
/*   Program Name : 부서일일근태 신청                                           */
/*   Program ID   : D12RotationHiddenPernr.jsp                                  */
/*   Description  : 부서일일근태 신청                                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2008-11-11                                                  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Map" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D12Rotation.*" %>
<%@ page import="hris.D.D12Rotation.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
	String hdn_deptId     = request.getParameter("hdn_deptId");
	String i_datum     = request.getParameter("i_datum");
    String i_ename     = request.getParameter("i_ename");
    String i_pernr    = request.getParameter("i_pernr");
    String i_index   = request.getParameter("i_index");
    
    Map D12EmpInfo_mp  = (new D12EmpInfoRFC()).getEmpInfo(i_pernr, i_ename, hdn_deptId, i_datum);
%>

<form name="form1">
</form>
<script>      
if("<%=D12EmpInfo_mp.get("E_RETURN") %>"=="E"){
	alert("<%=D12EmpInfo_mp.get("E_MESSAGE") %>");
	parent.document.form1.ENAME<%= i_index %>.value = "";
	parent.document.form1.PERNR<%= i_index %>.value = "";
}else{
        parent.document.form1.ENAME<%= i_index %>.value = "<%=D12EmpInfo_mp.get("E_ENAME") %>";

        parent.document.form1.PERNR<%= i_index %>.value = "<%=D12EmpInfo_mp.get("E_PERNR") %>";
}
 

</script>