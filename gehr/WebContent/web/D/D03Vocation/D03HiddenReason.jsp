<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 근무유형별 휴가 사유코드목록화                              */
/*   Program Name : 사유                                                        */
/*   Program ID   : D03HiddenOVTM_CODE.jsp                                         */
/*   Description  : 사유코드목록화                                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2009-10-26  @v1.0 CSR ID:1546748                            */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String AWART     = request.getParameter("AWART");
    String PERNR     = request.getParameter("PERNR");
    String INDEX     = WebUtil.nvl(request.getParameter("INDEX"),"N");
    String DATUM     = DataUtil.getCurrentDate();
    Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, PERNR, AWART,DATUM);
    out.println("PERNR:"+PERNR);
    out.println("AWART:"+AWART);
    out.println("PERNR:"+PERNR);
%>
 
<script>      

<%  if ( INDEX.equals("N")) {  //초과근무,휴가
%> 
         parent.reason_show(<%= D03VocationAReason_vt.size()%>);

         parent.document.form1.OVTM_CODE.length = <%= D03VocationAReason_vt.size()+1 %>;
<%             
         int inx = 0;
         for( int i = 0 ; i < D03VocationAReason_vt.size() ; i++ ) {
             D03VocationReasonData data = (D03VocationReasonData)D03VocationAReason_vt.get(i);
             inx++;
             if ( i ==0) {
%>       
             parent.document.form1.OVTM_CODE[<%= inx-1 %>].value = "";
             parent.document.form1.OVTM_CODE[<%= inx-1 %>].text  = "-------------------";
<%           
             inx = inx +1;
         
             }
%>             
             parent.document.form1.OVTM_CODE[<%= inx-1 %>].value = "<%=data.SCODE%>";
             parent.document.form1.OVTM_CODE[<%= inx-1 %>].text  = "<%=data.STEXT%>";
<%       
         }
%>       
         parent.document.form1.OVTM_CODE[0].selected = true;
<%       
     }else {  //부서근태
%> 
         parent.reason_show(<%= D03VocationAReason_vt.size()%>,<%= INDEX%>);
         eval("parent.document.form1.OVTM_CODE<%=INDEX%>.length = <%= D03VocationAReason_vt.size()+1 %>");
<%             
         int inx = 0;
         for( int i = 0 ; i < D03VocationAReason_vt.size() ; i++ ) {
             D03VocationReasonData data = (D03VocationReasonData)D03VocationAReason_vt.get(i);
             inx++;
             if ( i ==0) {
%>       
             eval("parent.document.form1.OVTM_CODE<%=INDEX%>[<%= inx-1 %>].value = ''");
             eval("parent.document.form1.OVTM_CODE<%=INDEX%>[<%= inx-1 %>].text  = '------------------'");
<%
             inx = inx +1;
             }
%>             
             eval("parent.document.form1.OVTM_CODE<%=INDEX%>[<%= inx-1 %>].value = '<%=data.SCODE%>'");
             eval("parent.document.form1.OVTM_CODE<%=INDEX%>[<%= inx-1 %>].text  = '<%=data.STEXT%>'");
<%       
         }
%>       
         eval("parent.document.form1.OVTM_CODE<%=INDEX%>[0].selected = true");
<%       
     }
%> 
</script>