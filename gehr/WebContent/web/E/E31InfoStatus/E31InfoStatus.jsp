<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회 가입현황(간사용)                                      */
/*   Program Name : 동호회 가입현황(간사용)                                      */
/*   Program ID   : E31InfoStatus.jsp                                           */
/*   Description  : 동호회가입현황(간사용)                                      */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<jsp:include page="/include/header.jsp" />


<frameset rows="130,*" frameborder="NO" border="0" framespacing="0">
  <frame name="topPage" scrolling="NO" noresize src="<%= WebUtil.JspPath %>E/E31InfoStatus/E31InfoStatusTop.jsp" frameborder="NO" marginwidth="0" marginheight="0" >
  <frame name="endPage" src=""  marginwidth="0" marginheight="0" frameborder="NO" scrolling="AUTO" >
</frameset>
<noframes>
<jsp:include page="/include/body-header.jsp"/>
</noframes>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
