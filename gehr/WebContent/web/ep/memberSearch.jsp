<%/*****************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 초기화면                                                    */
/*   Program ID   : view.jsp                                                    */
/*   Description  : 초기화면을 위한 jsp 파일                                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-15 유용원                                           */
/*   Update       : 2005-10-19 lsa : 시스템점검팝업추가                         */
/*                  2005-10-25 lsa : EP연동링크관련하여 ELOFFICE에서 사원접속시 좌측의 메뉴를 EP메뉴를 CALL하도록 변경*/
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %> 
<%-- @ include file="/web/common/commonProcess.jsp" --%>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.G.G001Approval.*" %>
<%@ page import="hris.A.A16Appl.rfc.*" %>
<%@ page import="hris.A.A16Appl.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>

<%
    WebUserData user = null;
    user = (WebUserData)session.getAttribute("epuser");
    if(user == null)
        user = (WebUserData)session.getAttribute("user");
    //session.removeAttribute("user");
    WebUserData user_m = WebUtil.getSessionMSSUser(request);

    int appFlag = user.e_authorization.indexOf("W");    //결재권한여부.
    int orgFlag = user.e_authorization.indexOf("M");    //조직도권한여부.
    int insaFlag = user.e_authorization.indexOf("H");    //인사담당
    Vector vcInit = (new InitViewRFC()).getInitViewData(user.empNo ,user.e_objid ,user.e_authorization);
    //Logger.debug.println(this ,user.empNo + "\t" + user.e_objid + "\t" + user.e_authorization);

    String webUserID = "";

    if (user.webUserId == null ||user.webUserId.equals("") )
        webUserID = "";
    else
        webUserID = user.webUserId.substring(0,6).toUpperCase();

       //             if ( upperID.equals("EADMIN") ) {  // 관리자 메뉴 접근 권한
       //                 user.user_group = "01";
       //             } else if ( upperID.substring(0,6).equals("EMANAG") ) {

    Config conf = new Configuration();
    
    StringBuffer portalServer = new StringBuffer(conf.get("portal.serverUrl"));

%>
<html>
<head>
<title>MSS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/lgchem_ep.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
    function MM_preloadImages() { //v3.0
      var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
        if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
    }

    function MM_findObj(n, d) { //v4.01
      var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
      if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
      for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
      if(!x && d.getElementById) x=d.getElementById(n); return x;
    }

    // 결재 해야 할 문서
    function viewDetail1(UPMU_TYPE, AINF_SEQN)
    {
        document.form2.isEditAble.value = "false";
        document.form2.AINF_SEQN.value = AINF_SEQN;
        document.form2.action = "<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV";
        document.form2.RequestPageName.value = "";
        // document.form2.RequestPageName.value = "<%= WebUtil.ServletURL %>hris.G.G001ApprovalDocListSV";
        document.form2.jobid.value = "";
        document.form2.submit();
    }

    // 신청 진행현황
    function viewDetail2(UPMU_TYPE, AINF_SEQN)
    {
        document.form2.isEditAble.value = "true";
        document.form2.AINF_SEQN.value = AINF_SEQN;
        document.form2.action = "<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV";
        document.form2.RequestPageName.value = "";
        // document.form2.RequestPageName.value = "<%= WebUtil.ServletURL %>hris.G.G002ApprovalIngDocListSV";
        document.form2.jobid.value = "";
        document.form2.submit();
    }

    function chngTable(sw)
    {
       if (sw == 2) {
           Image2.src = "<%= WebUtil.ImageURL %>mtop05_on.gif";
           Image1.src = "<%= WebUtil.ImageURL %>mtop06_off.gif";
           approval.style.display ="block";
           request.style.display ="none";
       } else if (sw ==1) {
           Image2.src = "<%= WebUtil.ImageURL %>mtop05_off.gif";
           Image1.src = "<%= WebUtil.ImageURL %>mtop06_on.gif";
           approval.style.display ="none";
           request.style.display ="block";
       } // end if
    }

function  doSearchDetail() {
    parent.left.openDoc('1034');
    parent.left.hideIMG('1034');
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
//알림추가05.10.19
function winNoticOpen(){
  var url="<%=WebUtil.JspURL%>"+"notice.jsp";
  var win = window.open(url,"notice","width=440,height=300,left=365,top=70,scrollbars=no");
	win.focus();

}
//ep menu Link 추가05.10.25
//function js_EPInfoMenu(url,menu){
//  var link = "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url="+url+"&portlet_EHRInfo_2menu="+ menu;
//  parent.left.location = link;
//}
////ep menu Link 추가05.10.25
//function js_EPApplyMenu(url,menu){
//  var link = "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url="+url+"&portlet_eHRApplyMenu_1menu="+menu;
//  parent.left.location = link;
//}
//
function js_EPInfoMenu(url,menu){
  var link = "http://<%=portalServer%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrInfo&url="+url+"&portlet_EHRInfo_2menu="+ menu;
  parent.left.location = link;
}
//ep menu Link 추가05.10.25
function js_EPApplyMenu(url,menu){
  var link = "http://<%=portalServer%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url="+url+"&portlet_eHRApplyMenu_1menu="+menu;
  parent.left.location = link;
}


//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="16">&nbsp;</td>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <%--  if( insaFlag > 0 || orgFlag > 0 ) { --%>
  		<%  if( true ) { %>
        <%@ include file="/web/ep/SearchDepPersons_ep.jsp" %>
      <% } %>
</form>
<% //out.println("user:"+user.toString()); %>
</body>
</html>