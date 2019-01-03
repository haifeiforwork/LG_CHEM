<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 전근무지                                                    */
/*   Program Name : 전근무지사업자번호 명칭 조회                                */
/*   Program ID   : D11TaxAdjustPreWorkHiddenName.jsp                           */
/*   Description  : 전근무지사업자번호 명칭 조회                                */
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
    String BUS01 = request.getParameter("BUS01").replace("-","");
    String INX = request.getParameter("INX");
//out.println("BUS01-:"+BUS01);
//out.println("INX:"+INX);
     Vector   code_vt = null;
    if( !BUS01.equals("") ) {
        try {
            D11TaxAdjustPreWorkSearchRFC func = new D11TaxAdjustPreWorkSearchRFC();
            code_vt = func.getSearch("%");
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>
<form name="form1">
<%
    boolean Find = false;
    for( int i = 0 ; i < code_vt.size() ; i++ ) {
        D11TaxAdjustPreWorkSearchData data = (D11TaxAdjustPreWorkSearchData)code_vt.get(i);
        if ( BUS01.equals(data.BIZNO.replace("-","")) ) {
           Find = true;
%>
<script>
    //parent.document.form1.COM01<%=INX%>.value = "<%= data.COMNM %>";
    parent.document.form1.COMNM<%=INX%>.value = "<%= data.COMNM %>";
</script>
<%
        }
%>
        <input type="hidden" name="BUS01<%= i %>" value="<%= data.BIZNO %>">[<%=BUS01%>]
        <input type="hidden" name="COM01<%= i %>" value="<%= data.COMNM %>">
<%
    }  // end for
%>
<script>
    if ( <%=Find%> ==false){
        //parent.document.form1.COM01<%=INX%>.value = "";
        parent.document.form1.COMNM<%=INX%>.value = "";

    }
</script>
</form>
