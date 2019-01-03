<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진 소화기,위검사 선택                                 */
/*   Program ID   : E15HiddenSelect.jsp                                         */
/*   Description  : 종합검진 소화기,위검사 선택                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2008-01-31                                                  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.A.A19Career.rfc.*" %>
<%@ page import="hris.A.A18Deduct.rfc.*" %> 
<%@ page import="hris.A.A15Certi.rfc.*" %> 

<%
    String PERNR = request.getParameter("PERNR");
    String AINF_SEQN = request.getParameter("AINF_SEQN");
    String MENU = request.getParameter("MENU");
    
    if (MENU.equals("CAREER")) {  //경력증명서
       A19CareerRFC func = new A19CareerRFC();           
       func.updateFlag(PERNR,AINF_SEQN);                    
    }else if (MENU.equals("DEDUCT") ) { //원천징수,갑근세
    //프린트는 1회로 출력을 제한한다.
       A18DeductRFC   func = new A18DeductRFC();
       func.updateFlag(PERNR,AINF_SEQN);                 
    }else if (MENU.equals("CERTI") ) { //재증명
    //프린트는 1회로 출력을 제한한다.
       A15CertiRFC func = new A15CertiRFC();
       func.updateFlag(PERNR,AINF_SEQN);                 
    }          
     
%>
<html>  
<input type="hidden" name="PERNR"     value="<%=PERNR%>">
<input type="hidden" name="AINF_SEQN" value="<%=AINF_SEQN%>">
<input type="hidden" name="MENU"     value="<%=MENU%>"> 

</html>
