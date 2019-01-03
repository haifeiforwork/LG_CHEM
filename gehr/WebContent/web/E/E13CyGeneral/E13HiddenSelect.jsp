<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진 소화기,위검사 선택                                 */
/*   Program ID   : E13HiddenSelect.jsp                                         */
/*   Description  : 종합검진 소화기,위검사 선택                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2008-01-31                                                  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E13CyGeneral.*" %>
<%@ page import="hris.E.E13CyGeneral.rfc.*" %>

<%
    String PERNR     = request.getParameter("PERNR");
    String HOSP_CODE = request.getParameter("HOSP_CODE");
    String STMC_CODE = request.getParameter("STMC_CODE");
    String SELT_CODE = request.getParameter("SELT_CODE");    
    String GUBUN     = request.getParameter("GUBUN");    
%>
<html>
<script>    
//@v1.1 병원선택시 소화기검사  setting
function view_Stmc() {
    //check_Option();
    var HOSP_CODE = parent.document.form1.HOSP_CODE[parent.document.form1.HOSP_CODE.selectedIndex].value;
    var val  = "<%=HOSP_CODE%>";
    parent.document.form1.to_date.value = ""; 
    parent.document.form1.STMC_CODE.length = 1; 
    parent.document.form1.STMC_CODE[0].value = ""; 
<% 
    int Stinx = 1;
    String Stbefore = "";
    String SttempCode = "";
 
    Vector E15StmcData_opt  = (new E13CyStmcCodeRFC()).getStmcCode(PERNR,HOSP_CODE);
    if (E15StmcData_opt.size() > 0) {     %>

    parent.document.form1.STMC_CODE[0].text  = "-------------";        
<%  } else { %>
    parent.document.form1.STMC_CODE[0].text  = "해당사항없음";        
<%
    }
    for( int i = 1 ; i < E15StmcData_opt.size()+1 ; i++ ) {
        E13CyStmcCodeData data = (E13CyStmcCodeData)E15StmcData_opt.get(i-1);

        Stinx++;
%>        
        parent.document.form1.STMC_CODE.length = <%= Stinx %>;
        parent.document.form1.STMC_CODE[<%= Stinx-1 %>].value = "<%=data.STMC_CODE%>";
        parent.document.form1.STMC_CODE[<%= Stinx-1 %>].text  = "<%=data.STMC_TEXT%>";
<%
    } //for
%>
    parent.document.form1.STMC_CODE[0].selected = true;
    view_Selt();

}
<%  if (GUBUN.equals("HOSP_CODE")) { %>
   view_Stmc()
<%  } else if (GUBUN.equals("STMC_CODE")) { %>
   view_Selt();
   MessageSTMC();
<%  } else if (GUBUN.equals("SELT_CODE")) { %>
   MessageSELT();
<%  } %>

//@v1.0 병원선택시  선택검사 setting
function view_Selt() {
   // check_Option();
    var HOSP_CODE = parent.document.form1.HOSP_CODE[parent.document.form1.HOSP_CODE.selectedIndex].value;
    parent.document.form1.to_date.value = ""; 

    var val  = "<%=HOSP_CODE%>";
    parent.document.form1.SELT_CODE.length = 1; 
    parent.document.form1.SELT_CODE[0].value = ""; 
<% 
    int inx = 1;

    Vector E13CySeltData_opt  = (new E13CySeltCodeRFC()).getSeltCode(PERNR,HOSP_CODE);
    E13CySeltData_opt  = SortUtil.sort_num(E13CySeltData_opt,"GRUP_NUMB,HOSP_CODE", "asc");  

    if (E13CySeltData_opt.size() > 0) {     
%>
    parent.document.form1.SELT_CODE[0].text  = "-------------";  
<%  } else { %>
    parent.document.form1.SELT_CODE[0].text  = "해당사항없음";        
<%  
    }
    for( int i = 1 ; i < E13CySeltData_opt.size()+1 ; i++ ) {
        E13CyStmcCodeData data = (E13CyStmcCodeData)E13CySeltData_opt.get(i-1);
        inx++;
%>        
        parent.document.form1.SELT_CODE.length = <%= inx %>;
        parent.document.form1.SELT_CODE[<%= inx-1 %>].value = "<%=data.SELT_CODE%>";
        parent.document.form1.SELT_CODE[<%= inx-1 %>].text  = "<%=data.SELT_TEXT%>";
<%
    } //for
%>
    
    parent.document.form1.SELT_CODE[0].selected = true;
    //Message();
}
function MessageSTMC() {
<%    for( int i = 1 ; i < E15StmcData_opt.size()+1 ; i++ ) {
        E13CyStmcCodeData data = (E13CyStmcCodeData)E15StmcData_opt.get(i-1);
        if (!data.INFO_MESS.equals("") && STMC_CODE.equals(data.STMC_CODE)){
%>
        alert("<%=data.INFO_MESS%>");
<%      }
    } //for
%>
}
function MessageSELT() {
<%    for( int i = 1 ; i < E13CySeltData_opt.size()+1 ; i++ ) {
        E13CyStmcCodeData data = (E13CyStmcCodeData)E13CySeltData_opt.get(i-1);
        if (!data.INFO_MESS.equals("") && SELT_CODE.equals(data.SELT_CODE)){
%>
        alert("<%=data.INFO_MESS%>");
<%      } 
    } //for
%>
}
</script>  

</html>
