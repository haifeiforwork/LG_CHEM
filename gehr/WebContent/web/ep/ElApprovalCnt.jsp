<%/*****************************************************************************/
/*                                                                              */
/*   System Name  : EHR                                                         */
/*   1Depth Name  : WORK CENETER                                                */
/*   2Depth Name  : 전자결재                                                    */ 
/*   Program Name : 결재할문서건수                                              */
/*   Program ID   : ElApprovalCnt.jsp                                           */
/*   Description  : 전자결재의 결재할문서                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-05-11 lsa                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%-- @ include file="/web/common/commonProcess.jsp" --%>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="hris.common.*" %>
<%--@ page import="hris.A.A16Appl.rfc.*" --%>
<%--@ page import="hris.A.A16Appl.*" --%>
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
	String ep_server = "";
	if(_debug)
		ep_server = "epapp.lgchem.com:8101";		
	else
		ep_server = "portal.lgchem.com";

        WebUserData user = null;
        user = (WebUserData)session.getAttribute("epuser");
        if(user == null)
            user = (WebUserData)session.getAttribute("user");

//    session.removeAttribute("user");
//    WebUserData user_m = WebUtil.getSessionMSSUser(request);

//        int appFlag = user.e_authorization.indexOf("W");    //결재권한여부.
//        int orgFlag = user.e_authorization.indexOf("M");    //조직도권한여부.
//        int insaFlag = user.e_authorization.indexOf("H");    //인사담당
//        Vector vcInit = (new InitViewRFC()).getInitViewData(user.empNo ,user.e_objid ,user.e_authorization);
        //Logger.debug.println(this ,user.empNo + "\t" + user.e_objid + "\t" + user.e_authorization);
        
        String webUserID = "";
        
        if (user.webUserId == null ||user.webUserId.equals("") )
            webUserID = "";
        else
            webUserID = user.webUserId.substring(0,6).toUpperCase();

       //             if ( upperID.equals("EADMIN") ) {  // 관리자 메뉴 접근 권한
       //                 user.user_group = "01";
       //             } else if ( upperID.substring(0,6).equals("EMANAG") ) {

%>
<html>
<head>
<title>E-HR 결재할문서건수</title>

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/eloffice_approval.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>
    <BODY leftmargin=0 topmargin=0 STYLE="background-color:transparent">
<%         
           ApprovalListKey aplk     = new ApprovalListKey();
           Vector vcApprovalDocList = null;
           
           aplk.I_BEGDA  =   DataUtil.getAfterDate( DataUtil.getCurrentDate() , -60);
           aplk.I_ENDDA  =   DataUtil.getCurrentDate();
            
           aplk.I_STAT_TYPE  =   "1";
           aplk.I_PERNR  =   user.empNo;

           G001ApprovalDocListRFC aplRFC = new G001ApprovalDocListRFC();
           vcApprovalDocList = aplRFC.getApprovalDocList(aplk);
           int ApprovalCnt =0;
           //23:식권영업사원식대SAP신청WEB결재,04:종합검진신청:웹신청SAP결재,08:교육신청:교육지원신청EHR결재

           for( int i = 0 ; i < vcApprovalDocList.size(); i++ ) { 
               ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i); 
               if (apl.UPMU_TYPE.equals("08")||apl.UPMU_TYPE.equals("23")||apl.UPMU_TYPE.equals("04") ) {
                  ApprovalCnt++;
               }
           }
           
%>
    <table width=30 cellspacing=0 cellpadding=0 border=0>

         <tr valign=middle align="center">

          <td width="100%" class="tdcnt"><%=ApprovalCnt%></td>

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