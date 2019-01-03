<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Personal HR Info                                                  															*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Time Sheet                                               																	*/
/*   Program ID   		: printFrame_TimeSheetUsa.jsp                                             												*/
/*   Description  		: Time Sheet 상세조회 출력 화면 (USA - LGCPI(G400))                       										*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-10-11 jungin @v1.0 LGCPI 법인 Time Sheet 신규 개발														*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String targetPage = null;
	String isPopUp = null;

    String jobid2 = (String)request.getParameter("jobid2");
    String pernr = (String)request.getParameter("PERNR");

    String i_paydr = (String)request.getParameter("I_PAYDR");
    String i_lcldt = (String)request.getParameter("I_LCLDT");
    String ainf_seqn = (String)request.getParameter("AINF_SEQN");
    String appr_stat = (String)request.getParameter("APPR_STAT");

    if (!jobid2.equals("printGlobal")) {
    	jobid2 = "printFirst";
    } else {
    	jobid2 = "printGlobal";
    }

    targetPage = WebUtil.ServletURL+"hris.D.D07TimeSheet.D07TimeSheetDetailPrintUsaSV?jobid2="+jobid2+"&pernr="+pernr+"&I_PAYDR="+i_paydr+"&I_LCLDT="+i_lcldt+"&AINF_SEQN="+ainf_seqn+"&APPR_STAT="+appr_stat;

    if (isPopUp == null) {
        isPopUp = "";
    }

    Logger.debug.println(this, "#####	[USA]		targetPage	:	[" + targetPage + "]	/	isPopUp	:	[" + isPopUp + "]");

    if (targetPage == null || targetPage.equals("")) {
%>
        <SCRIPT LANGUAGE="JavaScript">
        <!--
          alert("Print Error!");
          //history.back();
          self.close();
        //-->
        </SCRIPT>
<%
    }
%>

<jsp:include page="/include/header.jsp"/>


<frameset rows="*,25,35" frameborder="no" border="0" framespacing="0">

  <frame name="beprintedpage" src="<%= targetPage %>" marginwidth="0" marginheight="0" scrolling="auto" frameborder="no" align="center">
  <frame name="changepage" scrolling="no" noresize src="<%= WebUtil.JspURL %>common/printBottom_insa.jsp" frameborder="no" marginwidth="0" marginheight="0">
  <frame name="prt" scrolling="no" noresize src="<%= WebUtil.JspURL %>common/printTopPopUp.jsp?jobid2=<%= jobid2 %>" frameborder="no" marginwidth="0" marginheight="0">
</frameset>
<noframes>
 <jsp:include page="/include/body-header.jsp">
         <jsp:param name="title" value="COMMON.MENU.ESS_PT_TIME_SHEET"/>
    </jsp:include>

</noframes>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

