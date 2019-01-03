<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비사업자번호 명칭 조회                                  */
/*   Program ID   : D11TaxAdjustMediHiddenbusiName.jsp                           */
/*   Description  : 의료비사업자번호 명칭 조회                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2007.11.19                                                  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
 
<%
    WebUserData user = WebUtil.getSessionUser(request);
    String BUS01 = request.getParameter("BUS01");
    String INX = request.getParameter("INX");
          
    String  name = "";    
    if( !BUS01.equals("") ) {
        try {
            D11TaxAdjustMediBusiNameRFC func = new D11TaxAdjustMediBusiNameRFC();
           
            name = func.getBusiName(BUS01);
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
            
        }
    }
%>
<form name="form1">

<script>    
	parent.document.form1.BIZ_NAME<%=INX%>.value = "<%= name %>";
    
</script>
</form>
