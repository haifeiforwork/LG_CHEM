<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 어학능력                                                    */
/*   Program Name : 어학능력 조회                                               */
/*   Program ID   : C05FtestResult.jsp                                          */
/*   Description  : 어학능력 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-07  윤정현                                          */
/*                  2006-01-06  lsa @v1.1  teps추가                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<tags:layout>

    <h2 class="subtitle"><spring:message code="MSG.C.C05.0001" /><%--Foreign Language Ability--%></h2>

    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <colgroup>
                    <col>
                    <col width="120">
                    <col width="100">
                    <col width="100">
                </colgroup>
                <thead>
                <tr>
                    <th ><spring:message code="MSG.C.C05.0002" /><%--Language Certificate Name--%></th>
                    <th ><spring:message code="MSG.C.C05.0003" /><%--Date of&nbsp;&nbsp;Acquisition--%></th>
                    <th ><spring:message code="MSG.C.C05.0004" /><%--Scale--%></th>
                    <th class="lastCol"><spring:message code="MSG.C.C05.0005" /><%--Language--%></th>
                </tr>
                </thead>
                <tbody>
                    <%--@elvariable id="langList" type="java.util.Vector<hris.C.C05FtestResult1Data>"--%>
                <c:forEach var="row" items="${langList}" varStatus="status">
                    <tr class="${f:printOddRow(status.index)}">
                        <td>${row.TENAM}</td>
                        <td>${f:printDate(row.BEGDA)}</td>
                        <td>${row.PTEXT2}</td>
                        <td class="lastCol">${row.LANTX}</td>
                    </tr>
                </c:forEach>
                <tags:table-row-nodata list="${langList}" col="4" />
                </tbody>
            </table>
        </div>
    </div>

</tags:layout>
