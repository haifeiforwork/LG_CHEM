<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 발령사항                                                    */
/*   Program Name : 발령사항                                                    */
/*   Program ID   : A05AppointDetail.jsp                                        */
/*   Description  : 발령사항 조회                                               */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-28  윤정현                                          */
/*                  2006-05-17  @v1.1 lsa 5월급여작업으로 막음  전문기술직만    */
/*                  2006-06-16 @v1.1 kdy 임금인상관련 급여화면 제어              */
/*                  2015.03.11 이지은D [CSR ID:2724630] 인사정보 화면 일부 수정 건   */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<tags:layout >

    <%-- 발령 --%>
    <self:self-appoint />

    <%-- 승급 --%>
    <self:self-promotion />

</tags:layout>
