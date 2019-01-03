<%/*****************************************************************************/
/*                                                                              */
/*   System Name  : EHR                                                         */
/*   1Depth Name  : WORK CENETER                                                */
/*   2Depth Name  : 전자결재                                                    */ 
/*   Program Name : 결재진행중문서건수                                          */
/*   Program ID   : ElApprovalIngCnt.jsp                                        */
/*   Description  : 전자결재의 결재진행중문서                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-05-11 lsa                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%-- @ include file="/web/common/commonProcess.jsp" --%>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>

<%@ page import="hris.G.G001Approval.*" %>
<%@ page import="hris.G.G001Approval.rfc.*" %>


<%@ include file="ep.jspf" %>
<% 

        String gubun  = (String)request.getAttribute("gubun");

	String ep_server = "";
	if(_debug)
		ep_server = "epapp.lgchem.com:8101";		
	else
		ep_server = "portal.lgchem.com";

        WebUserData user = null;
        user = (WebUserData)session.getAttribute("epuser");
        if(user == null)
            user = (WebUserData)session.getAttribute("user");

%>
<html>
<head>
<title>E-HR 결재진행중문서건수</title>

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/eloffice_approval.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" type="text/JavaScript">
</script>
</head>
    <BODY leftmargin=0 topmargin=0 STYLE="background-color:transparent">
<%         
           ApprovalListKey aplk     = new ApprovalListKey();
           Vector vcApprovalDocList = null;
           
           aplk.I_BEGDA  =   DataUtil.getAfterDate( DataUtil.getCurrentDate() , -60);
           aplk.I_ENDDA  =   DataUtil.getCurrentDate();
            
           aplk.I_STAT_TYPE  =   "2"; //진행중
           aplk.I_PERNR  =   user.empNo;

           G001ApprovalDocListRFC aplRFC = new G001ApprovalDocListRFC();
           vcApprovalDocList = aplRFC.getApprovalDocList(aplk);
           
%>
    <table width=30 cellspacing=0 cellpadding=0 border=0>

         <tr valign=middle align="center">

          <td width="100%"  class="tdcnt"><%=vcApprovalDocList.size()%></td>

         </tr>

    </table>

</body>
</html>
<%
String mainlogin = (String)session.getAttribute("mainlogin");

//if(mainlogin == null)
if(false)
{
%>
<iframe src="/web/ep/sessionremove.jsp" width="0" height="0">
<%
}
%>