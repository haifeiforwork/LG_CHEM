<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : E19HiddenLifnrByEname.jsp                                   */
/*   Description  : 경조금 신청                                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-12-07  @v1.1 lsa C2005112301000000543 경조화환 신청시 부서계좌 정보 조회기능 추가 */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String DEPT_NAME = request.getParameter("DEPT_NAME");
    String BANKN     = request.getParameter("p_BANKN");
    String SWITCH    = request.getParameter("p_SWITCH");
    String PERNR    = request.getParameter("P_PERNR");
    
    Vector E19CongLifnrByEname_vt  = (new E19CongLifnrByEnameRFC()).getLifnr(user.companyCode,DEPT_NAME,BANKN ,SWITCH,PERNR);
%>

<form name="form1">
<%
    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    for( int i = 0 ; i < E19CongLifnrByEname_vt.size() ; i++ ) {
        E19CongLifnrByEnameData data = (E19CongLifnrByEnameData)E19CongLifnrByEname_vt.get(i);
%>
            <input type="hidden" name="P_LIFNR<%= i %>" value="<%= data.LIFNR %>">
            <input type="hidden" name="P_BANKN<%= i %>" value="<%= data.BANKN %>">
            <input type="hidden" name="P_BANKA<%= i %>" value="<%= data.BANKA %>">
            <input type="hidden" name="P_BANKL<%= i %>" value="<%= data.BANKL %>">
<%
    }  // end for
%>
</form>
<script>      
    parent.document.form1.LIFNR.length = <%= E19CongLifnrByEname_vt.size()+1 %>;
<%        
    int inx = 0;
    for( int i = 0 ; i < E19CongLifnrByEname_vt.size() ; i++ ) {
        E19CongLifnrByEnameData data = (E19CongLifnrByEnameData)E19CongLifnrByEname_vt.get(i);
        inx++;
        if ( i ==0) {
%>
        parent.document.form1.LIFNR[<%= inx-1 %>].value = "";
        parent.document.form1.LIFNR[<%= inx-1 %>].text  = "-------------------";
<%      
        inx = inx +1;
  
        }
%>        
        parent.document.form1.LIFNR[<%= inx-1 %>].value = "<%=data.LIFNR%>";
        parent.document.form1.LIFNR[<%= inx-1 %>].text  = "<%=data.LIFNR%> <%=data.NAME1%>(<%=data.BVTXT %>)";
<%

    }
    
    if ( E19CongLifnrByEname_vt.size() == 0 ) {
%>
        alert("등록된 부서계좌가 존재하지 않습니다");
<%  } 
%>  
    parent.document.form1.LIFNR[0].selected = true;
    parent.document.form1.BANK_NAME.value = "";
    parent.document.form1.BANKN.value = "";
    parent.document.form1.p_BANKN_SEARCHGUBN.value = "SEARCH";

<%    
%>
function view_LifnrDept(obj,Index) {
  var Lifnr_V = obj;
  var sIndex = Index-1;
  
  var doc = "document.form1";      
  if (sIndex ==-1 ) {
    parent.document.form1.BANK_NAME.value = "";
    parent.document.form1.BANKN.value = "";
  }
  else if( Lifnr_V == eval(doc+".P_LIFNR"+sIndex+".value") ) {
    parent.document.form1.BANK_NAME.value = eval(doc+".P_BANKA"+sIndex+".value");
    parent.document.form1.BANKN.value = eval(doc+".P_BANKN"+sIndex+".value");
  }
  else {
    parent.document.form1.BANK_NAME.value = "";
    parent.document.form1.BANKN.value = "";
  }
}

</script>