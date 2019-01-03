<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 진급자격요건 시뮬레이션                                     */
/*   Program Name : 진급자격요건 시뮬레이션                                     */
/*   Program ID   : B04PromotionDetail.jsp                                      */
/*   Description  : 진급자격요건 시뮬레이션을 조회                              */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                      [CSR ID:2748124] E-HR 내 진급 시뮬레이션 화면 조정 件                                                         */
/*						 [CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 2017-06-15 eunha  */
/*                      [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件    2017-11-15 eunha               */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%
    String topPage = (String)request.getAttribute("topPage");
    String endPage = (String)request.getAttribute("endPage");
    Logger.debug.println(this, topPage);
    Logger.debug.println(this, endPage);
%>

<jsp:include page="/include/header.jsp"/>
<%-- [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  start --%>
<%--[CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 2017-06-15 eunha   start--%>
 <frameset rows="130,*" frameborder="NO" border="0" framespacing="0">
  <frame id="topPage" name="topPage" scrolling="NO" noresize src="<%= topPage %>" frameborder="NO" marginwidth="0" marginheight="0" >
  <frame id="endPage" name="endPage" src="<%= endPage %>" marginwidth="0" marginheight="0" frameborder="NO" scrolling="AUTO">
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>

<%--<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PA_PROM_SIMU"/>
</jsp:include>
    <div>
        <p>시스템 점검중 입니다.</p>
    </div>
 --%>
<%--[CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 2017-06-15 eunha   end--%>
<%-- [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  end --%>
<jsp:include page="/include/footer.jsp"/>
