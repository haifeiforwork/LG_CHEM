<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.servlet.*"%>
<%@ page import="hris.N.EHRComCRUDInterfaceRFC" %>
<%@page import="hris.N.EHRCommonUtil"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>


<%
    WebUserData user    = (WebUserData)session.getAttribute("user");                                        //세션.
//  특정사번은 현재 조직이 아닌 ZHRH130T테이블을 읽어 조직을 셋팅함. 2015-11-23
	Box sbox = new Box("orgview");
	sbox.put("I_PERNR", user.empNo);
	sbox.put("I_AUTHOR", "M");
	sbox.put("I_DATUM", DataUtil.getCurrentDate());
	//String sfunctionName = "ZHRC_RFC_CHECK_EXORG";
	String sfunctionName = "ZGHR_RFC_CHECK_EXORG";
	EHRComCRUDInterfaceRFC tcomRFC = new EHRComCRUDInterfaceRFC();
	HashMap orgHM = tcomRFC.getExecutAll(sbox, sfunctionName);
	HashMap<String, String> exportField = new HashMap<String, String>();
	exportField = (HashMap)orgHM.get("EXPORT_FIELD");
	String sRETURN =tcomRFC.getReturn().MSGTY;


    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                //부서코드
    if(deptId.equals("")){
    	if(!sRETURN.equals("S")){
    		deptId = user.e_objid;
    	}else{
    		deptId = exportField.get("E_ORGEH");
    	}
    }
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                              //부서명

    if(deptNm.equals("")){
    	if(!sRETURN.equals("S")){
    		deptNm = user.e_obtxt;
    	}else{
    		deptNm = exportField.get("E_ORGTX");
    	}

    }

    // 웹로그 메뉴 코드명 2015-09-08
    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    // 제목 텍스트 추가  2015-10-26
	String sMenuText =  WebUtil.nvl(request.getParameter("sMenuText"));
    String sCommand = WebUtil.nvl(request.getParameter("command"));
    if(sCommand.equals("")){
    	sCommand ="PIS0040";
    }

    String tabNo =  "0";
    if(sCommand.equals("PIS0041")){
    	tabNo =  "1";
    }else if(sCommand.equals("PIS0042")){
    	tabNo =  "2";
    }

    String chck_yeno = WebUtil.nvl(request.getParameter("chck_yeno"));
    if(chck_yeno.equals("")){
    	chck_yeno = "Y";
    }

    String I_ITEM = WebUtil.nvl(request.getParameter("I_ITEM"));
    String I_ITEMTXT = WebUtil.nvl(request.getParameter("I_ITEMTXT"));


%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--


	//조회에 의한 부서ID와 그에 따른 조회.
	function setDeptID(deptId, deptNm){
		switchScreen();
	    frm = document.form1;
	    frm.hdn_deptId.value = deptId;
	    frm.hdn_deptNm.value = deptNm;
	    frm.command.value= listFrame.document.form1.command.value;
	    frm.I_ITEM.value= listFrame.document.form1.I_ITEM.value;
	    frm.I_ITEMTXT.value=listFrame.document.form1.I_ITEMTXT.value;
	    frm.targetpage.value ="main";
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.languageprsn.LanguagePrsnSV";




        frm.target = "_self";
	    frm.submit();
	}

	//Execl Down 하기.
	function excelDown(gubun) {
		alert("excel");
	    frm = document.form1;
	    frm.command.value = gubun;
	    frm.targetpage.value ="excel";
	    frm.target = "hidden";
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.languageprsn.LanguagePrsnSV";
	    frm.submit();
	}

	function switchScreen() {
	    document.getElementById("divLoading").style.display = "";
	    document.getElementById("divBody").style.display = "none";
	}

	function switchScreen1() {

	    document.getElementById("divLoading").style.display = "none";
	    document.getElementById("divBody").style.display = "";

	}




//-->
</SCRIPT>




<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.MSS_TALE_LANG"/>
    <jsp:param name="click" value="Y"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="I_ORGEH"  value="<%=deptId%>">

<input type="hidden" name="command"   value="">
<input type="hidden" name="targetpage"   value="">
<input type="hidden" name="chck_sub"   value="<%=chck_yeno %>">
<input type="hidden" name="initUrl"   value="N">

<input type="hidden" name="I_ITEM"   value="">
<input type="hidden" name="I_ITEMTXT"   value="">
<input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">
<input type="hidden" name="sMenuText"   value="<%=sMenuText %>">

	<!--   부서검색 보여주는 부분 시작   -->
	<%@ include file="/web/common/SearchDeptInfo.jsp" %>
	<!--   부서검색 보여주는 부분  끝    -->

	<div id="divLoading" style="position:absolute; top:190px; left:0; width:100%; text-align:center; margin:0 auto;">
    	 <script>
            blockFrame();
        </script>
	</div>

	<div id="divBody">
		<!-- TAB 프레임  -->
		<iframe id="listFrame" name="listFrame" src="<%= WebUtil.ServletURL %>hris.N.orgstats.languageprsn.LanguagePrsnSV?command=<%= sCommand%>&I_ITEM=<%=I_ITEM %>&I_ITEMTXT=<%=I_ITEMTXT %>&tabSet=<%= tabNo%>&viewGubun=GD&sMenuCode=<%=sMenuCode %>&sMenuText=<%=sMenuText%>&chck_sub=<%= chck_yeno%>&chck_yeno=<%=chck_yeno %>&hdn_deptId=<%=deptId%>&hdn_deptNm=<%=deptNm %>" width="100%" height="1224" marginwidth="0" marginheight="0" scrolling="auto"  frameborder=0 ></iframe>
	</div>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

