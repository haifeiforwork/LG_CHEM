<%/******************************************************************************/
/*  CSR ID : 2511881 재해신청 시스템 수정요청 20140327 이지은D  재해신청일자 입력화면 변경  */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E19Disaster.*" %>
<%@ page import="hris.E.E19Disaster.rfc.*" %>

<%
    String CONG_DATE = request.getParameter("CONG_DATE");
Logger.debug.println(this, "cong_date-------------"+CONG_DATE);
    String PERNR     = request.getParameter("PERNR");
    Vector E19CongcondData_vt = (new E19CongMoreRelaRFC()).getCongMoreRela(PERNR, CONG_DATE);
    if( E19CongcondData_vt.size() > 0 ){
        E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(0);
%>

<SCRIPT>
    parent.document.form1.WORK_YEAR.value = '<%= (e19CongcondData.WORK_YEAR.equals("") || e19CongcondData.WORK_YEAR.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>';
    parent.document.form1.WORK_MNTH.value = '<%= (e19CongcondData.WORK_MNTH.equals("") || e19CongcondData.WORK_MNTH.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>';

    if( parent.document.form1.fromJsp.value == "E19CongraChange.jsp" && parent.document.form1.fromJsp2.value == "E19CongraChange.jsp" &&
        parent.document.form1.checkSubmit.value == "Y" ) {
        parent.do_change_submit();
    } else if( parent.document.form1.fromJsp.value == "E19CongraBuild.jsp" && parent.document.form1.fromJsp2.value == "E19CongraBuild.jsp" &&
        parent.document.form1.checkSubmit.value == "Y" ) {
        parent.doSubmit_save();
    } else if(  parent.document.form1.fromJsp.value == "E19CongraBuild.jsp" && parent.document.form1.fromJsp2.value == "E19ReportBuild.jsp" ) {
    	//변경된 WAGE_WONX(통상임금)이 parent 화면에 세팅될 수 있도록 추가
    	parent.document.form1.WAGE_WONX.value = '<%=e19CongcondData.WAGE_WONX %>';
    } else if(  parent.document.form1.fromJsp.value == "E19CongraChange.jsp" && parent.document.form1.fromJsp2.value == "E19ReportBuild.jsp" ) {
    	//변경된 WAGE_WONX(통상임금)이 parent 화면에 세팅될 수 있도록 추가
    	parent.document.form1.WAGE_WONX.value = '<%=e19CongcondData.WAGE_WONX %>';
    }
</SCRIPT>

<%
    }
%>
