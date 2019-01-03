<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 월급여                                                      */
/*   Program Name : 월급여                                                      */
/*   Program ID   : D05MpayDetail_mf.jsp                                         */
/*   Description  : 개인의 월급여내역 조회                                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  chldudgh                                        */
/*   Update       : 2005-01-18  윤정현                                          */
/*   Update       : : 2016-09-20 통합구축 - 김승철                     */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.rfc.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);
    if(user_m.area.getMolga().equals("")){
	    user_m.e_mss="";
	    session.setAttribute("user_m", user_m);
    }
%>

<jsp:include page="/include/header.jsp" />

<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="${title }"/>
    <jsp:param name="help" value="D05Mpay.html"/>
</jsp:include>



<script>

function  doSearchDetail() {

    document.form1.action = "${g.servlet}${servlet}";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
</script>

<form name="form1" method="post" action="">

    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
</form>
	

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
