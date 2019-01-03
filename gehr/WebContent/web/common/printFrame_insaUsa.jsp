<%/***************************************************************************************/      																				
/*   System Name  	: g-HR              																												*/ 
/*   1Depth Name		: Employee Data                                                  																*/
/*   2Depth Name  	: Personal Data                                                    															*/
/*   Program Name 	: Personnel File                                                    															*/
/*   Program ID   		: printFrame_insaUsa.jsp                                        															*/
/*   Description  		: 사원 인사정보 출력 미리보기 화면 (USA)                                              									*/
/*   Note         		:                                                             																		*/
/*   Creation     		: 2010-10-04 jungin @v1.0 																								*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String targetPage = null;
    String isPopUp = null;
    
    isPopUp = (String)request.getAttribute("isPopUp");
    String jobid2 = (String)request.getParameter("jobid2");
    String pernr = (String)request.getParameter("pernr");
 
    if (!jobid2.equals("printGlobal")) {
         jobid2 = "printFirst";
    } else {     
         jobid2 = "printGlobal";
    }
    
    targetPage = WebUtil.ServletURL+"hris.A.A01PersonalCardEurpSV_m?jobid2="+jobid2+"&pernr="+pernr;
    
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
        </SCRIPT>
<%
    }
%>

<html>
<head>
<title>LG CHEM Global e-HR</title>
</head>
<frameset rows="25,*,20" frameborder="no" border="0" framespacing="0">
  <frame name="prt" scrolling="no" noresize src="<%= WebUtil.JspURL %>common/printTopPopUp_insaUsa.jsp?jobid2=<%= jobid2 %>" frameborder="no" marginwidth="0" marginheight="0" >
  <frame name="beprintedpage" src="<%=WebUtil.JspURL %>A/A01PersonalCardWait_m.jsp?targetPage=<%= targetPage %>" marginwidth="0" marginheight="0" scrolling="auto" frameborder="no">
  <frame name="changepage" scrolling="no" noresize src="<%= WebUtil.JspURL %>common/printBottom_insa.jsp" frameborder="no" marginwidth="0" marginheight="0" >
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
</html>
<% response.flushBuffer();%>
