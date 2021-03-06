<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String targetPage = null;
    String isPopUp    = null;

    String gubun = WebUtil.nvl(request.getParameter("gubun"));
	String orgOrTm = WebUtil.nvl(request.getParameter("orgOrTm"));
	String searchDeptNo = WebUtil.nvl(request.getParameter("searchDeptNo"));
	String searchDeptNm = WebUtil.nvl(request.getParameter("searchDeptNm"));
	String iSeqno = WebUtil.nvl(request.getParameter("iSeqno"));
	String ISEQNO = WebUtil.nvl(request.getParameter("ISEQNO"));
	String I_SELTAB = WebUtil.nvl(request.getParameter("I_SELTAB"));

	String I_DATUM = "";
	if(request.getParameter("I_DATUM") == null){
		I_DATUM = DataUtil.getCurrentDate();
	}else{
		I_DATUM = WebUtil.nvl(request.getParameter("I_DATUM")).replace(".","");
	}


//     targetPage = WebUtil.ServletURL+"hris.F.F42DeptMonthWorkConditionSV?hdn_deptId="+hdn_deptId+",hdn_excel="+hdn_excel+",year1="+year1+",month1="+month1+",chck_yeno="+checkYn;
    targetPage = WebUtil.ServletURL+"hris.D.D40TmGroup.D40TmSchkzPlanningChartGroupSV?gubun="+gubun+",orgOrTm="+orgOrTm+",searchDeptNo="+searchDeptNo+",searchDeptNm="+searchDeptNm+
    		",iSeqno="+iSeqno+",I_SELTAB="+I_SELTAB+",I_DATUM="+I_DATUM+",ISEQNO="+ISEQNO;
    if( isPopUp == null ) {
        isPopUp = "";
    }

    if( targetPage == null || targetPage.equals("") ){
%>
        <SCRIPT LANGUAGE="JavaScript">
        <!--
          alert("<spring:message code='MSG.COMMON.0058' />"); //프린트 페이지를 오픈하던 중 오류가 발생했습니다.
          //history.back();
          self.close();
        //-->
        </SCRIPT>
<%
    }
%>
<jsp:include page="/include/header.jsp" />
<frameset rows="*,50" frameborder="NO" border="0" framespacing="0">
  <frame name="beprintedpage" src="<%=WebUtil.JspURL %>F/F42DeptMonthWorkCondition_wait.jsp?targetPage=<%= targetPage %>" marginwidth="0" marginheight="0" scrolling="AUTO" frameborder="NO">
  <frame name="prt" scrolling="NO" noresize src="<%= WebUtil.JspURL %>D/D40TmGroup/common/printTopPopUp_rotation.jsp" frameborder="NO" marginwidth="0" marginheight="0" >
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
<% response.flushBuffer();%>
