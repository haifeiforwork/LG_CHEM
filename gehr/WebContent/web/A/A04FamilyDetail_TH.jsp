<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 가족사항 조회                                               */
/*   Program ID   : A04FamilyDetail.jsp                                         */
/*   Description  : 가족사항 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건*/
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="isOwner" value="${PERNR == user.empNo}"/>


<jsp:useBean id="detailBody" class="com.common.vo.BodyContainer" scope="page" />



<tags-family:family-layout-global detailBody="${detailBody}"/>



