<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import="hris.N.EHRCommonUtil" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    String detailPage = (String) request.getAttribute("detailPage");
    String gubun = (String) request.getAttribute("gubun"); //@v1.1 ep후 결재함에서 로그인시처리위해 추가

    /*if (detailPage == null || detailPage.equals("")) {
        detailPage = WebUtil.JspURL + "view.jsp";
    } // end if*/

    // 시스템관리자(AdminLogin_TEST.jsp) 를 통해 들어온 URL과  Portal 구분

    String potalYN = WebUtil.nvl(request.getParameter("potalYN"));
    if(potalYN.equals("")){
    	potalYN = "Y";
    }
    /*
    if(potalYN.equals("Y")){
    	 // 2015-05-19 메인 메뉴
        detailPage =   WebUtil.ServletURL+"hris.N.ehrptmain.EHRPortalMainSV";
    }*/

    String menuCode =EHRCommonUtil.nullToEmpty((String) request.getParameter("menuCode"));
    String AINF_SEQN = EHRCommonUtil.nullToEmpty((String) request.getParameter("AINF_SEQN"));
    String year = EHRCommonUtil.nullToEmpty((String) request.getParameter("year"));
    String month = EHRCommonUtil.nullToEmpty((String) request.getParameter("month"));

    if(menuCode == null){
    	menuCode = "";
    }else if(menuCode.equals("9999")){

    	/// servlet/servlet.hris.G.G000ApprovalDocMapSV?isEditAble=false^AINF_SEQN=0003322681"
    	detailPage = "/servlet/servlet.hris.G.G000ApprovalDocMapSV?isEditAble=false&AINF_SEQN="+ AINF_SEQN;
    }

    //detailPage = (String) request.getAttribute("menuCode");
     Logger.debug.println(this,">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>main.jsp menuCode : " + menuCode +" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
     Logger.debug.println(this,">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>main.jsp detailPage : " + detailPage +" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    	//WebUtil.JspURL + "/N/ehrptmain/EHRPortalMain.jsp";
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=8;" />

<title><%=user.companyCode.equals("C100") ? "LG화학/e-HR" : "LG석유화학/ESS" %></title>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery.blockUI.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/underscore.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

    <script language="JavaScript">
<!--

var showLoading = function() {
    /*setTimeout(function() {
        console.log("---- block -------------------");
        $.blockUI({ message : '잠시만 기다려 주세요' });
    }, 1);*/
    if (window.frames["menuContentIframe"]["blockFrame"]) window.frames["menuContentIframe"]["blockFrame"]();
}

function hideLoading() {
    if(window.frames['menuContentIframe'].$ && window.frames['menuContentIframe'].$.unblockUI)
        window.frames['menuContentIframe'].$.unblockUI();
}

function moveMenuURL(menuCode, url) {
    if(window.frames['left'].selectMenu)
        window.frames['left'].selectMenu(menuCode, _.isEmpty(url));

    if(url) {
        $("#menuContentIframe").attr("src", url);
        //console.log("move url : " + url);	// ie7 x 
    }
}

//-->
</script>
</head>
		<frameset id="framesets" cols="225,*,0">
		    <frame id="left" name="left" src="<%= WebUtil.ServletURL%>hris.sys.SysMenuSV?menu1=${param.menu1}&menu2=${param.menu2}&menu3=${param.menu3}&tabid=${param.tabid}&potalYN=<%=potalYN%>&menuCode=<%=menuCode %>&AINF_SEQN=<%= AINF_SEQN%>&year=<%=year %>&month=<%=month %>" frameborder="NO" noresize marginwidth="0" marginheight="0" ></frame>
		    <frame id="menuContentIframe" name="menuContentIframe" src="" frameborder="NO" marginwidth="0" marginheight="0" onload="hideLoading();"></frame>
		    <frame name="hidden" frameborder="NO" noresize marginwidth="0" marginheight="0"></frame>
		</frameset>
<noframes>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear();" >

</body>
</noframes>
</html>
