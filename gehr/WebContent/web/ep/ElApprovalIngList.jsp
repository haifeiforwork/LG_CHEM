<%/*****************************************************************************/
/*                                                                              */
/*   System Name  : EHR                                                         */
/*   1Depth Name  : WORK CENETER                                                */
/*   2Depth Name  : 전자결재                                                    */ 
/*   Program Name : 결재진행중문서                                              */
/*   Program ID   : ElApprovalIngList.jsp                                       */
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

        String EMPNO          = request.getParameter("EMPNO");
        String Language       = WebUtil.nvl(request.getParameter("Language"),"en");
        String portalurl      = request.getParameter("portalurl");
        String listurl        = request.getParameter("listurl");
        if (portalurl.indexOf("?eHR=") > 0)
            portalurl      = portalurl.substring(0,portalurl.indexOf("?eHR="));
 
	String ep_server = "";
	if(_debug)
		ep_server = "epdev.lgchem.com:8101";		
	else
		ep_server = "portal.lgchem.com";

        WebUserData user = null;
        user = (WebUserData)session.getAttribute("epuser");
        if(user == null)
            user = (WebUserData)session.getAttribute("user");
       
        String webUserID = "";
        
        if (user.webUserId == null ||user.webUserId.equals("") )
            webUserID = "";
        else
            webUserID = user.webUserId.substring(0,6).toUpperCase();

%>
<html>
<head>
<title>E-HR 결재진행중문서</title>

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/eloffice_approval.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
    // 결재진행중문서 
    function viewDetail2(UPMU_TYPE, AINF_SEQN)
    {
    
       // document.form2.isEditAble.value = "true";
       // document.form2.AINF_SEQN.value = AINF_SEQN;
       // document.form2.action = "<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV";
       // document.form2.RequestPageName.value = "";
       //// document.form2.RequestPageName.value = "<%= WebUtil.ServletURL %>hris.G.G002ApprovalIngDocListSV";
       // document.form2.jobid.value = "";
       
        //ep url
        var epUrl = "http://<%=portalurl%>/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url=";
        var returnUrl = "<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV&portlet_EHRApprovalMenu_1isEditAble=true&portlet_EHRApprovalMenu_1AINF_SEQN="+AINF_SEQN;
        //parent.location.href = epUrl+returnUrl;
        parent.location.href = "http://ehr.lgchem.com<%= WebUtil.ServletURL %>hris.ElApprovalAutoLoginSV?AINF_SEQN="+AINF_SEQN+"&selUserName="+"<%=user.empNo%>"+"&SSERVER="+"<%=portalurl%>"+"&isNotApp=true"+"&listurl="+"<%=listurl%>";
        
    }

//-->
</script>
</head>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
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
<table width="780" border="0"  cellspacing="0" cellpadding="0">
<tr><td>
<table width=100% cellspacing=1 cellpadding=0 border=0  align=center class=trskin>

     <% if (Language.equals("en"))  { %>
     <tr height=22 valign=middle align=center>
        <td width=130>Date</td>
        <td >Subject</td>
        <td width=100>Department</td>
        <td width=100>Writer</td>
        <td width=100>CurApproval</td>
    </tr>        
     <% } else { %>
     <tr height=22 valign=middle align=center>
        <td width=130>기안일</td>
        <td >제목</td>
        <td width=100>부서</td>
        <td width=100>작성자</td>
        <td width=100>현재결재자</td>
    </tr>
     <% } %>
</table>
<div id=viewlist style="position:relative;left:0;top:0;width:100%; overflow-x:none; overflow-y:auto;">
<table width=100% cellspacing=0 cellpadding=0 border=0>

     <% for( int i = 0 ; i < vcApprovalDocList.size(); i++ ) { %>
       <% ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i);%>
		
            <tr height=23 valign=middle class="trout" onmouseover="javascript:this.className='tron'" onmouseout="javascript:this.className='trout'">
                <td width=130 class="viewContent"><%= WebUtil.printDate(apl.BEGDA,"-")%></td>
                <td class="viewContentL"><a href="javascript:viewDetail2('<%= apl.UPMU_TYPE %>', '<%= apl.AINF_SEQN %>');"><%= apl.UPMU_NAME.trim() %></a></td>
                <td  width=100 class="viewContent"><%=apl.STEXT %></td>
                <td  width=100 class="viewContent"><%=apl.ENAME %></td>
                <td  width=100 class="viewContent"><%= apl.DETERMINANT %></td>
            </tr>
     <% } // end for%>   
</Table>
</td></tr></table>
</div>

<%    if( vcApprovalDocList.size() <1 ){%>
<table width=780 cellspacing=0 cellpadding=0 border=0  align=center>
     <tr valign=middle class="trout">
          <td width=100% align=center>저장된 문서가 없습니다.</td>
     </tr>
</table>
<% } // end if%>   


<form name="form2" method="post">
  <input type="hidden" name="AINF_SEQN">
  <input type="hidden" name="isEditAble" value="true">
  <input type="hidden" name="RequestPageName" >
  <input type="hidden" name="jobid">
</form>

</body>
</html>
<%
String mainlogin = (String)session.getAttribute("mainlogin");

//if(mainlogin == null)
if(false)
{
%>
<iframe src="/ep/sessionremove.jsp" width="0" height="0">
<%
} 
// out.println(" listurl     :"+listurl     );
//out.println(" EMPNO     :"+EMPNO     );
//out.println(" Language  :"+Language  );
//out.println(" portalurl :"+portalurl );
%>