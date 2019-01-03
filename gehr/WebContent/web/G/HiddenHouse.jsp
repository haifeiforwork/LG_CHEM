<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 신규신청 부서장 결재                               */
/*   Program Name : 주택자금 신규신청 부서장 결재                               */
/*   Program ID   : HiddenHouse.jsp                                             */
/*   Description  : 주택자금 신규신청 부서장 결재 Hidden                        */
/*   Note         :                                                             */
/*   Creation     : 2005-03-10  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.G.*" %>
<%@ page import="hris.G.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    String PERNR = request.getParameter("PERNR");
    String DLART = request.getParameter("DLART");
    String DARBT = request.getParameter("DARBT");
    String ZAHLD = request.getParameter("ZAHLD");

    LoanData data = new LoanData(); 
    LoanRFC  rfc = new LoanRFC(); 
    data = (LoanData)rfc.getLoanDetail(PERNR, DLART, DARBT, ZAHLD);

    if ( data.ZZRPAY_MNTH != "") {
        data.MNTH_INTEREST = WebUtil.printNumFormat(Double.parseDouble(data.MNTH_INTEREST) *100);
        data.TILBT         = WebUtil.printNumFormat(Double.parseDouble(data.TILBT)*100);
%>
  
<SCRIPT>
    parent.setLoanDetail("<%=data.ZZRPAY_MNTH%>", "<%=data.TILBT%>", "<%=data.REFN_BEGDA%>", "<%=data.REFN_ENDDA%>", "<%=data.MNTH_INTEREST%>" );
</SCRIPT>
<%
    }
%>
