<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : E19Hidden4WorkYear.jsp                                      */
/*   Description  : 경조금 신청 Hidden                                          */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-14  이승희                                          */
/*   Update       : 2005-02-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>


<%
    String CONG_DATE = request.getParameter("CONG_DATE");
    String PERNR     = request.getParameter("PERNR");

    Vector E19CongcondData_vt = (new E19CongMoreRelaRFC()).getCongMoreRela(PERNR, CONG_DATE,"1");

    String CONG_CODE = request.getParameter("CONG_CODE");
    String RELA_CODE = request.getParameter("RELA_CODE");

    if( E19CongcondData_vt.size() > 0 ){
        E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(0);

    Vector e19CongCodeCheck_vt  = null;  // @v1.1
    E19CongCodeCheckData Check_vt  = (E19CongCodeCheckData)(new E19CongCodeCheckRFC()).getCongCodeCheck( "C100", CONG_DATE,CONG_CODE,RELA_CODE,PERNR );


%>
<SCRIPT>
    parent.document.form1.WORK_YEAR.value = '<%= ( e19CongcondData.WORK_YEAR.equals("") || e19CongcondData.WORK_YEAR.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>';
    parent.document.form1.WORK_MNTH.value = '<%= (e19CongcondData.WORK_MNTH.equals("") || e19CongcondData.WORK_MNTH.equals("00") ) ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>';
    //통상임금은 현재일자기준으로 데이타 가져온다.
    //@v1.4 통상금액(경조일 기준으로변경)
    parent.document.form1.WAGE_WONX.value = '<%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%>';

    //parent.document.form1.CONG_RATE.value = '<%= e19CongcondData.CONG_RATE %>';

    parent.rela_action_1(parent.document.form1.RELA_CODE);

    if( parent.document.form1.fromJsp.value == "E19CongraChange.jsp" &&
        parent.document.form1.checkSubmit.value == "Y" ) {
        //parent.do_change_submit();
    } else if( parent.document.form1.fromJsp.value == "E19CongraBuild.jsp" &&
        parent.document.form1.checkSubmit.value == "Y" ) {
        //parent.doSubmit_save();
    }
    if ( "<%=Check_vt.E_FLAG%>"!="Y") {
        alert("<%=Check_vt.E_MESSAGE%>");
        parent.document.form1.CONG_DATE.value = '';
    }
</SCRIPT>
<%
    }
%>
