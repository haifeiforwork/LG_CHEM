<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 포상/징계                                                   */
/*   Program Name : 포상 및 징계내역 조회                                       */
/*   Program ID   : A06PrizeNPunish.jsp                                         */
/*   Description  : 포상 및 징계내역 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-26  윤정현                                          */
/*   Update       : RequestPageName 보상명세서에서 이전가기 추가                */
/*                  2013.04.26 [CSR ID:2319361] 징계종료일자   추가              */
/*   Update       : C20130425_19315징계종료일자 추가 요청                       */
/*   Update       : C20130611_47348 징계기간추가                                */
/*                  2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)     */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<tags:layout>

    <self:self-prize-GLOBAL />

    <c:if test="${pageType == 'M'}">
        <self:self-punish-GLOBAL />
    </c:if>

    <c:if test="${not empty RequestPageName}">
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:history.back()"><span><spring:message code="BUTTON.COMMON.BACK" /><%--뒤로가기--%></span></a></li>
            </ul>
        </div>
    </c:if>
</tags:layout>

