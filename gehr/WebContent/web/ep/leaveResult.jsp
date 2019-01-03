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
 
<%@ include file="ep.jspf" %>
<%
	String ep_server = "";
	if(_debug)
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

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
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
function js_EPInfoMenu(url,menu){
//  var link = "http://<%=ep_server%>/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url="+url+"&portlet_EHRInfo_2menu="+ menu;
  var link = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrInfo&url="+url+"&portlet_EHRInfo_2menu="+ menu;
  parent.left.location = link;
}
//ep menu Link 추가05.10.25
function js_EPApplyMenu(url,menu){
//  var link = "http://<%=ep_server%>/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url="+url+"&portlet_eHRApplyMenu_1menu="+menu;
  var link = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url="+url+"&portlet_eHRApplyMenu_1menu="+menu;
  parent.left.location = link;
}
<%
    ViewEmpVacationData empVacationData = (ViewEmpVacationData)((Vector)vcInit.get(2)).get(0);
%>

	function tabChgEHR(nu) {



            <%
                //관리자 일경우 사전부여휴가 대신 휴가사용율을 보여줌.
                if(orgFlag>0 || !empVacationData.OCCUR1.equals("") && !empVacationData.OCCUR1.equals("0")){
            %>

        if(nu == '0'){
            firstTD.background = '<%= WebUtil.ImageURL %>ep/r_temp_schedule_stitleback.gif';
            secondTD.background = '<%= WebUtil.ImageURL %>ep/r_temp_schedule_dtitleback02.gif';
            t7Menu00_OFF.style.display='block';
            t7Menu01_OFF.style.display='none';
         }else if(nu == '1'){

            firstTD.background = '<%= WebUtil.ImageURL %>ep/r_temp_schedule_dtitleback.gif';
            secondTD.background = '<%= WebUtil.ImageURL %>ep/r_temp_schedule_stitleback02.gif';
            t7Menu00_OFF.style.display='none';
            t7Menu01_OFF.style.display='block';
         }
        <%
        }
        %>
	}

//-->
</script>
</head>
<%
String laf = request.getParameter("laf");
%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="bea-portal-body" >
<table widht=100%  border="0" cellspacing="0" cellpadding="0" background="http://<%=ep_server%><%=laf%>">
    <tr>
        <td  >
<table width="228" border="0" cellspacing="0" cellpadding="0">
     <tr>
          <td><table width="228" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr>

                         <td id="firstTD" width="81" height="23" align="center" background="<%= WebUtil.ImageURL %>ep/r_temp_schedule_stitleback.gif" class="title-black" onmousemove="tabChgEHR(0)">개인 휴가</td>
                         </td>
                            <%
                                //관리자 일경우 사전부여휴가 대신 휴가사용율을 보여줌.
                                if(orgFlag>0){
                                    ViewDeptVacationData deptVacationData = (ViewDeptVacationData)((Vector)vcInit.get(3)).get(0);
                            %>
<!--                        <td id="secondTD" width="135" height="23" align="center" background="<%= WebUtil.ImageURL %>ep/r_temp_schedule_dtitleback02.gif" class="title-black" onmousemove="tabChgEHR(1)"><a href="#" onClick="parent.location.href='http://<%=ep_server%>/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHROrgStatMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHROrgStatMenu%2Fbegin&_windowLabel=portlet_EHROrgStatMenu_1&_pageLabel=Menu03_Book04_Page01&portlet_EHROrgStatMenu_1url=<%=WebUtil.ServletURL%>hris.F.F41DeptVacationSV'">부서 휴가(<%= deptVacationData.CONSUMRATE %>%)</a></td>-->
                        <td id="secondTD" width="135" height="23" align="center" background="<%= WebUtil.ImageURL %>ep/r_temp_schedule_dtitleback02.gif" class="title-black" onmousemove="tabChgEHR(1)"><a href="#" onClick="parent.location.href='http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrOrgStat&url=<%=WebUtil.ServletURL%>hris.F.F41DeptVacationSV'">부서 휴가(<%= deptVacationData.CONSUMRATE %>%)</a></td>
                            <%
                                }else{
                                    //사전부여휴가
                                    if (!empVacationData.OCCUR1.equals("") && !empVacationData.OCCUR1.equals("0")) {
                            %>
                         사전 휴가

                            <%
                                    }
                            %>
                         <td id="secondTD" width="135" height="1" align="center" valign="bottom" class="title-white" onmousemove="tabChgEHR(1)"><img src="<%= WebUtil.ImageURL %>ep/r_temp_schedule_upline.gif" width="135" height="1"></td>

                            <%
                                }
                            %>

                         <td align="left" valign="bottom"><img src="<%= WebUtil.ImageURL %>ep/r_temp_schedule_upline.gif" width="6" height="1"></td>
                    </tr>
               </table></td>
     </tr>
     <tr>
          <td>

            <div id=t7Menu00_OFF style='display:block' >
            <table width="228" height="90" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                         <td height="90" align="center" valign="top" background="<%= WebUtil.ImageURL %>ep/r_temp_schedule_back02.gif"><table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                   <tr>
                                        <td height="10"></td>
                                   </tr>
                                   <tr>
                                        <td valign="middle"><table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                  <tr class="table-text">
                                                       <td width="13%" align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n1.gif" width="12" height="12"></td>
                                                       <td width="87%">발생일수 :
                                                            <%= WebUtil.printNumFormat(empVacationData.OCCUR,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                                  <tr class="table-text">
                                                       <td align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n2.gif" width="12" height="12"></td>
                                                       <td>사용일수 : <%= WebUtil.printNumFormat(empVacationData.ABWTG,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                                  <tr class="table-text">
                                                       <td align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n3.gif" width="12" height="12"></td>
                                                       <td>잔여일수 : <%= WebUtil.printNumFormat(empVacationData.ZKVRB,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                             </table></td>
                                   </tr>
                                   <tr>
                                        <td height="7" ></td>
                                   </tr>
                              </table></td>
                    </tr>
               </table>
            </div>

            <div id=t7Menu01_OFF style='display:none' >
                            <%
                                //관리자 일경우 사전부여휴가 대신 휴가사용율을 보여줌.
                                if(orgFlag>0){

                                    ViewDeptVacationData deptVacationData = (ViewDeptVacationData)((Vector)vcInit.get(3)).get(0);
                            %>

            <table width="228" height="90" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                         <td height="90" align="center" valign="top" background="<%= WebUtil.ImageURL %>ep/r_temp_schedule_back02.gif"><table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                   <tr>
                                        <td height="10"></td>
                                   </tr>
                                   <tr>
                                        <td valign="middle"><table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                  <tr class="table-text">
                                                       <td width="13%" align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n1.gif" width="12" height="12"></td>
                                                       <td width="87%">발생일수 :
                                                            <%= WebUtil.printNumFormat(deptVacationData.OCCUR,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                                  <tr class="table-text">
                                                       <td align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n2.gif" width="12" height="12"></td>
                                                       <td>사용일수 : <%= WebUtil.printNumFormat(deptVacationData.ABWTG,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                                  <tr class="table-text">
                                                       <td align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n3.gif" width="12" height="12"></td>
                                                       <td>잔여일수 : <%= WebUtil.printNumFormat(deptVacationData.ZKVRB,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                             </table></td>
                                   </tr>
                                   <tr>
                                        <td height="7" ></td>
                                   </tr>
                              </table></td>
                    </tr>
               </table>

                            <%
                                }else{
                                    //사전부여휴가
                                    if (!empVacationData.OCCUR1.equals("") && !empVacationData.OCCUR1.equals("0")) {
                            %>

            <table width="228" height="90" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                         <td height="90" align="center" valign="top" background="<%= WebUtil.ImageURL %>ep/r_temp_schedule_back02.gif"><table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                   <tr>
                                        <td height="10"></td>
                                   </tr>
                                   <tr>
                                        <td valign="middle"><table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                  <tr class="table-text">
                                                       <td width="13%" align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n1.gif" width="12" height="12"></td>
                                                       <td width="87%">발생일수 :
                                                            <%= WebUtil.printNumFormat(empVacationData.OCCUR,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                                  <tr class="table-text">
                                                       <td align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n2.gif" width="12" height="12"></td>
                                                       <td>사용일수 : <%= WebUtil.printNumFormat(empVacationData.ABWTG,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                                  <tr class="table-text">
                                                       <td align="center"><img src="<%= WebUtil.ImageURL %>ep/r_icon_n3.gif" width="12" height="12"></td>
                                                       <td>잔여일수 : <%= WebUtil.printNumFormat(empVacationData.ZKVRB,1) %> 일</td>
                                                  </tr>
                                                  <tr>
                                                       <td height="1" colspan="2" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                                                  </tr>
                                             </table></td>
                                   </tr>
                                   <tr>
                                        <td height="7" ></td>
                                   </tr>
                              </table></td>
                    </tr>
               </table>
                            <%
                                    }
                                }
                            %>
            </div>
</td>
     </tr>
</table>
</td>
</tr>
</table>
<input type=hidden name="7">
<%
String mainlogin = (String)   session.getAttribute("mainlogin");

//if(mainlogin == null)
if(false)
{
%>
<iframe src="/ep/sessionremove.jsp" width="0" height="0">
<%
}
%>
