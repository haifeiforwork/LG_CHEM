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
/*   Update       : 2005-11-02 lsa : EP대자인반영                               */
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

  
<%@ include file="ep.jspf" %>
<%
	String ep_server = "";
	if(_debug)
		//ep_server = "epsvr1.lgchem.com:8101";
		ep_server = "epdev.lgchem.com:8101";
	else
		ep_server = "gportal.lgchem.com";

    WebUserData user = null;
    user = (WebUserData)session.getAttribute("epuser");
    if(user == null)
        user = (WebUserData)session.getAttribute("user");

//    session.removeAttribute("user");
//    WebUserData user_m = WebUtil.getSessionMSSUser(request);

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

%>
<html>
<head>
<title>MSS</title>

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/lgchem_ep.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/layout_ep.css" type="text/css">
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
//        document.form2.submit();
//        parent.location.href = "http://<%=ep_server%>/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url=<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV&portlet_EHRApprovalMenu_1isEditAble=false&portlet_EHRApprovalMenu_1AINF_SEQN="+AINF_SEQN;
        parent.location.href = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApproval&url=<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV&isEditAble=false&AINF_SEQN="+AINF_SEQN;
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
//        document.form2.submit();
//        parent.location.href = "http://<%=ep_server%>/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url=<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV&portlet_eHRApplyMenu_1isEditAble=true&portlet_eHRApplyMenu_1AINF_SEQN="+AINF_SEQN;
        parent.location.href = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url=<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV&sEditAble=true&AINF_SEQN="+AINF_SEQN;
    }

    function chngTable(sw)
    {
       if (sw == 2) {
           //Image2.src = "<%= WebUtil.ImageURL %>mtop05_on.gif";
           //Image1.src = "<%= WebUtil.ImageURL %>mtop06_off.gif";
           tab2.style.display ="block";
           tab1.style.display ="none";
           approval.style.display ="block";
           request.style.display ="none";
       } else if (sw ==1) {
           //Image2.src = "<%= WebUtil.ImageURL %>mtop05_off.gif";
           //Image1.src = "<%= WebUtil.ImageURL %>mtop06_on.gif";
           tab1.style.display ="block";
           tab2.style.display ="none";
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
function js_EPInfoMenu(url,menu){
  var link = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrInfo&url="+url+"&portlet_EHRInfo_2menu="+ menu;
  parent.left.location = link;
}
//ep menu Link 추가05.10.25
function js_EPApplyMenu(url,menu){
  var link = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url="+url+"&portlet_eHRApplyMenu_1menu="+menu;
  parent.left.location = link;
}

//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%
    //결재권한이 있는 경우.(20050303:유용원)
    if( appFlag > 0 ){
%>

<table width="476" border="0" cellspacing="0" cellpadding="0">
     <!------- 메인이미지 상단여백 10픽셀----->
     <!------- 메인이미지  ----->
     <tr>
          <td class="title-text">

            <!------- 통합게시판 텝 메뉴영역  ----->
            <table id = "tab1" style="display : none" width="100%" border="0" cellspacing="0" cellpadding="0">
                 <tr>
                      <td width="30%" class="tab-Stitle"><a href="#" onMouseOver= "chngTable(1)" style="cursor:'hand'">신청진행현황</a></td>
                      <td width="30%" class="tab-Dtitle"><a href="#" onMouseOver= "chngTable(2)" style="cursor:'hand'">결재해야할문서</a></td>
                      <td width="40%">&nbsp;</td>
                 </tr>
            </table>
            <table id = "tab2" style="display : block" width="100%" border="0" cellspacing="0" cellpadding="0">
                 <tr>
                      <td width="30%" class="tab-Dtitle"><a href="#" onMouseOver= "chngTable(1)" style="cursor:'hand'">신청진행현황</a></td>
                      <td width="30%" class="tab-Stitle"><a href="#" onMouseOver= "chngTable(2)" style="cursor:'hand'">결재해야할문서</a></td>
                      <td width="40%">&nbsp;</td>
                 </tr>
            </table>

            <!-- 신청진행현황 테이블 시작 -->
            <%  Vector A16ApplListData_vt = (Vector)vcInit.get(1); %>
            <table id = "request" style="display : none" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr class="tablehead-text">
                   <td width="15%" height="26" class="tablehead-text">날짜</td>
                   <td width="55%" height="26" class="tablehead-text">업무구분</td>
                   <td width="30%" height="26" class="tablehead-text">상태</td>
              </tr>
            <% for( int i = 0 ; i < A16ApplListData_vt.size() && i < 4; i++ ) { %>
                <%  A16ApplListData data = (A16ApplListData)A16ApplListData_vt.get(i);
                    String statText = "";
                    //01 신청 ,02 결재진행중 ,03 결재완료 ,04 반려
                    if ("01".equals(data.STAT_TYPE)) {
                        statText = "신청";
                    } else if ("02".equals(data.STAT_TYPE)) {
                        statText = "결재진행중";
                    } else if ("03".equals(data.STAT_TYPE)) {
                        statText = "결재완료";
                    } else if ("04".equals(data.STAT_TYPE)) {
                        statText = "반려";
                    } // end if
                %>
              <tr class="table-text">
                   <td height="1" colspan="3" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
              </tr>
              <tr class="table-text">
                <td><%= WebUtil.printDate(data.BEGDA,"-")%></td>
                <td><a href="javascript:viewDetail2('<%= data.UPMU_TYPE %>', '<%= data.AINF_SEQN %>');">
                    <%= data.UPMU_NAME.trim() %></a></td>
                <td><%=statText%></td>
              </tr>
            <% } // end for%>   
            <!-- 결재해야할문서 테이블 끝 -->
            <!------- 하단 Grey bar  ----->
            <% if (A16ApplListData_vt.size() == 0 ) { %>
              <tr class="table-text">
                   <td height="1" colspan="3" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
              </tr>
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td colspan="3" align=center>&nbsp;해당 데이터가 없습니다.</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr>
                      <td  colspan="3"  class="temp-tebleunder-greybar"></td>
                 </tr>              
            
            <% } else { %>
                 <tr>
                      <td  colspan="3"  class="temp-tebleunder-greybar"></td>
                 </tr> 
            <% } %>             
            </table>
            <!-- 신청진행현황 테이블 끝-->
            <!-- 결재해야할문서 테이블 시작-->
            <%
                Vector vcApprovalDocList = (Vector)vcInit.get(0);
            %>
            <table id = "approval" style="display : block" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr class="tablehead-text">
                   <td width="15%" height="26" class="tablehead-text">날짜</td>
                   <td width="35%" height="26" class="tablehead-text">업무구분</td>
                   <td width="35%" height="26" class="tablehead-text">부서</td>
                   <td width="15%" height="26" class="tablehead-text">신청자</td>
              </tr>
            <% for (int i = 0; i < vcApprovalDocList.size() && i < 4; i++) { %>
                <%
                    ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i);
                    String bgColor = (i % 2) == 0 ? "bgcolor=\"F4F4F4\"" : "";
                %>
              <tr class="table-text">
                   <td height="1" colspan="4" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
              </tr>
              <tr class="table-text">
                <td><%=apl.BEGDA%></td>
                <td><a href="javascript:viewDetail1('<%=apl.UPMU_TYPE%>','<%=apl.AINF_SEQN%>')"><%=apl.UPMU_NAME%></a></td>
                <td><font color="585858"><%=apl.STEXT%></font></td>
                <td><font color="585858"><%=apl.ENAME%></font></td>
              </tr>
            <% } // end for%>
            <!-- 결재해야할문서 테이블 끝 -->
            <!------- 하단 Grey bar  ----->
            <% if (vcApprovalDocList.size() == 0 ) { %>
              <tr class="table-text">
                   <td height="1" colspan="4" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
              </tr>
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td colspan="4" align=center>&nbsp;해당 데이터가 없습니다.</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr>
                      <td  colspan="4"  class="temp-tebleunder-greybar"></td>
                 </tr>              
            
            <% } else { %>
                 <tr>
                      <td  colspan="4"  class="temp-tebleunder-greybar"></td>
                 </tr> 
            <% } %>             
          
            </table>
            <!-- 결재해야할문서 테이블 끝 -->
            <!------- 하단 Grey bar  ----->
<!--            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                 <tr>
                      <td  class="temp-tebleunder-greybar"></td>
                 </tr>
            </table>-->
            <!------- 끝 ----->
          </td>
     </tr>
</table>
<%
    //결재권한이 없는 경우..
    }else{
%>
<table width="476" border="0" cellspacing="0" cellpadding="0">
     <!------- 메인이미지 상단여백 10픽셀----->
     <!------- 메인이미지  ----->
     <tr>
          <td class="title-text">

            <!------- 통합게시판 텝 메뉴영역  ----->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                 <tr>
                      <td width="30%" class="tab-Stitle"><a href="#">신청진행현황</a></td>
                      <td width="70%">&nbsp;</td>
                 </tr>
            </table>

            <!-- 신청진행현황 테이블 시작 -->
            <%  Vector A16ApplListData_vt = (Vector)vcInit.get(1);

            %>
            <table id = "request" style="display : block" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr class="tablehead-text">
                   <td width="25%" height="26" class="tablehead-text">날짜</td>
                   <td width="50%" height="26" class="tablehead-text">업무구분</td>
                   <td width="25%" height="26" class="tablehead-text">상태</td>
              </tr>
            <% for( int i = 0 ; i < A16ApplListData_vt.size() && i < 4; i++ ) { %>
                <%  A16ApplListData data = (A16ApplListData)A16ApplListData_vt.get(i);
                    String statText = "";
                    //01 신청 ,02 결재진행중 ,03 결재완료 ,04 반려
                    if ("01".equals(data.STAT_TYPE)) {
                        statText = "신청";
                    } else if ("02".equals(data.STAT_TYPE)) {
                        statText = "결재진행중";
                    } else if ("03".equals(data.STAT_TYPE)) {
                        statText = "결재완료";
                    } else if ("04".equals(data.STAT_TYPE)) {
                        statText = "반려";
                    } // end if
                %>
              <tr class="table-text">
                   <td height="1" colspan="3" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
              </tr>
              <tr class="table-text">
                <td align=center><%= WebUtil.printDate(data.BEGDA,"-")%></td>
                <td><a href="javascript:viewDetail2('<%= data.UPMU_TYPE %>', '<%= data.AINF_SEQN %>');">
                    <%= data.UPMU_NAME.trim() %></a></td>
                <td><%=statText%></td>
              </tr>
            <% } // end for%>
            <!-- 결재해야할문서 테이블 끝 -->
            <!------- 하단 Grey bar  ----->
            <% if (A16ApplListData_vt.size() == 0 ) { %>
              <tr class="table-text">
                   <td height="1" colspan="3" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
              </tr>
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td colspan="3" align=center>&nbsp;해당 데이터가 없습니다.</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr><td >&nbsp;</td></tr>              
                 <tr>
                      <td  colspan="3"  class="temp-tebleunder-greybar"></td>
                 </tr>              
            
            <% } else { %>
                 <tr>
                      <td  colspan="3"  class="temp-tebleunder-greybar"></td>
                 </tr> 
            <% } %>    
                        
            </table>
            <!-- 신청진행현황 테이블 끝-->
            <!------- 하단 Grey bar  ----->
           <!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
                 <tr>
                      <td  class="temp-tebleunder-greybar"></td>
                 </tr>
            </table>-->
            <!------- 끝 ----->
          </td>
     </tr>
</table>
<%
    } //end if
%>
<form name="form2" method="post">
  <input type="hidden" name="AINF_SEQN">
  <input type="hidden" name="isEditAble">
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
%>