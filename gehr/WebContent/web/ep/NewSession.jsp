<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 검색한 사원을 Session값에 넣어줌                            */
/*   Program ID   : NewSession.jsp                                              */
/*   Description  : 검색한 사원을 Session값에 넣어줌                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       : 2005-02-17  유용원                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%--@ include file="/web/common/commonProcess.jsp" --%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
 
<%@ include file="ep.jspf" %>
<%
	String ep_server = "";
	if(_debug)
		ep_server = "epdev.lgchem.com:8101";
	else
		ep_server = "gportal.lgchem.com";
    //초기화면에서 사원인사정보의 인사정보 조회로 이동을 위한 값.( 2005.2.17:추가 유용원 )
    String viewFlag             = WebUtil.nvl(request.getParameter("hdn_viewFlag"));

    WebUserData user_m          = new WebUserData();
    String empNo                = request.getParameter("empNo");
    PersonInfoRFC numfunc        = new PersonInfoRFC();
    PersonData phonenumdata   = new PersonData();

    phonenumdata = (PersonData)numfunc.getPersonInfo(empNo);

    user_m.login_stat   = "Y";
    user_m.companyCode  = phonenumdata.E_BUKRS ;

    Config conf         = new Configuration();
    user_m.clientNo     = conf.get("com.sns.jdf.sap.SAP_CLIENT");

    user_m.empNo        = empNo ;
    user_m.ename        = phonenumdata.E_ENAME ;
    user_m.e_titel 				= phonenumdata.E_JIKWT;
    user_m.e_titl2 				= phonenumdata.E_JIKKT;
    user_m.e_orgeh      = phonenumdata.E_ORGEH ;
    user_m.e_orgtx      = phonenumdata.E_ORGTX ;
    user_m.e_is_chief   = phonenumdata.E_IS_CHIEF ;
    user_m.e_stras      = phonenumdata.E_STRAS ;
    user_m.e_locat      = phonenumdata.E_LOCAT ;
    user_m.e_regno      = phonenumdata.E_REGNO ;
    user_m.e_oversea    = phonenumdata.E_OVERSEA ;
    user_m.e_phone_num  = phonenumdata.E_PHONE_NUM ;
//  user_m.e_cell_phone = phonenumdata.E_CELL_PHONE ;
    user_m.e_trfar      = phonenumdata.E_TRFAR ;
    user_m.e_trfgr      = phonenumdata.E_TRFGR ;
    user_m.e_trfst      = phonenumdata.E_TRFST ;
    user_m.e_vglgr      = phonenumdata.E_VGLGR ;
    user_m.e_vglst      = phonenumdata.E_VGLST ;
    user_m.e_dat03      = phonenumdata.E_DAT02 ;
    user_m.e_persk      = phonenumdata.E_PERSK ;
    user_m.e_objid      = phonenumdata.E_OBJID ;
    user_m.e_obtxt      = phonenumdata.E_OBJTX ;
    user_m.e_werks      = phonenumdata.E_WERKS ;
    user_m.e_recon      = phonenumdata.E_RECON ;
    user_m.e_reday      = phonenumdata.E_REDAY ;

    DataUtil.fixNull(user_m);

    session = request.getSession(true);

    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
    session.setMaxInactiveInterval(maxSessionTime);

    session.setAttribute("user_m",user_m);
%>
<html>
<head>
<title>사원 검색</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<form name="form1">
</form>
</head>

<SCRIPT LANGUAGE="JavaScript">
<!--
newSession();  // Session 값 넣어줌

function newSession(){
    //초기 화면의 사원리스트에서 선택된 사원의 인사정보 조회로 이동.( 2005.2.17:추가 유용원 )
    if( "<%=viewFlag%>" == "Y" ){
        javascript:parent.left.openDoc('1010')
/*
        var frm = document.form1;

        frm.action = "<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
        frm.target = "menuContentIframe";
        frm.method = "post";
        frm.submit();
*/
    }else{
        //팝업 사원리스트에서 선택된 값으로 이전창으로 이동.
        //이부분을 portal url로 바꾼다.
//        parent.opener.doSearchDetail();//
        // lsa 막음 opener.parent.parent.location.href="http://<%=ep_server%>/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url=<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
//        opener.parent.parent.location.href="http://<%=ep_server%>/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHREmpInfoMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHREmpInfoMenu%2Fbegin&_windowLabel=portlet_EHREmpInfoMenu_1&_pageLabel=Menu03_Book03_Page01&portlet_EHREmpInfoMenu_1url=<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
        opener.parent.parent.location.href="http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrInfo&url=<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
//							 http://epsvr1.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01" method="post">
        top.close();
    }
}
//-->
</SCRIPT>
