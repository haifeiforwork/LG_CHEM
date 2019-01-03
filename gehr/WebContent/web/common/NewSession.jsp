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
<%@ include file="commonProcess.jsp" %>
<%@ page import="hris.N.EHRComCRUDInterfaceRFC" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import= "com.sns.jdf.sap.SAPType" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.sys.SysAuthInput" %>
<%@ page import="hris.sys.rfc.SysAuthRFC" %>

<%
	String hdn_deptId	 = WebUtil.nvl(request.getParameter("hdn_deptId"));
	String empNo                = request.getParameter("empNo");
	String reCode = "S";
	WebUserData user = WebUtil.getSessionUser(request);
	 Box mssBox = new Box("mssCkBox");
	//보안 진단 취약점 개선  marco257 2015-08-19
	if (user.sapType.isLocal()){

        SysAuthInput inputData = new SysAuthInput();
        inputData.I_CHKGB = "2";
        inputData.I_DEPT = WebUtil.getSessionUser(request).empNo;
        inputData.I_PERNR = empNo;

        SysAuthRFC sysAuthRFC = new SysAuthRFC();

        if(!sysAuthRFC.isAuth(inputData)){
            reCode = "E";
        }
	}

    mssBox.put("I_ORGEH", hdn_deptId);
    mssBox.put("I_PERNR", empNo);
    mssBox.put("I_DATUM", DataUtil.getCurrentDate());

	String viewFlag             = WebUtil.nvl(request.getParameter("hdn_viewFlag"));

    //초기화면에서 사원인사정보의 인사정보 조회로 이동을 위한 값.( 2005.2.17:추가 유용원 )


    WebUserData user_m          = new WebUserData();

    PersonInfoRFC numfunc        = new PersonInfoRFC();
    PersonData phonenumdata   = new PersonData();

    phonenumdata = (PersonData)numfunc.getPersonInfo(empNo);

    user_m.login_stat   = "Y";
    user_m.companyCode  = phonenumdata.E_BUKRS ;

    Config conf         = new Configuration();
    user_m.clientNo     = conf.get("com.sns.jdf.sap.SAP_CLIENT");



    session = request.getSession(true);

    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
    session.setMaxInactiveInterval(maxSessionTime);


%>
<html>
<head>
<title>사원 검색</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

</head>

<SCRIPT LANGUAGE="JavaScript">
<!--

newSession();  // Session 값 넣어줌

function newSession(){
    //초기 화면의 사원리스트에서 선택된 사원의 인사정보 조회로 이동.( 2005.2.17:추가 유용원 )
    if( "<%=viewFlag%>" == "Y" ){
        //parent.left.openDoc('1034');
        //parent.left.hideIMG('1034');
        parent.left.openDoc('M100');
        parent.left.hideIMG('M100');

    }else if ( "<%=viewFlag%>" == "CLOSE" ){
        //팝업 사원리스트에서 선택된 값으로 이전창으로 이동.
        //parent.opener.doSearchDetail();
        top.opener.doSearchDetail();
        top.close();
    }else{
    	//alert("lost");
        //보안 진단 2015-08-19
        //팝업 사원리스트에서 선택된 값으로 이전창으로 이동.
        //if('<%=reCode%>' == "S"){
            //alert(parent.parent.opener.value);



        	//window.parent.parent.opener.document.form1.target="Organ";

        top.opener.doSearchDetail();



        //}else{

        //alert("인사정보 조회대상이 아니거나 사원마스터가 없습니다");
        //}
    }
}
//-->
</SCRIPT>
