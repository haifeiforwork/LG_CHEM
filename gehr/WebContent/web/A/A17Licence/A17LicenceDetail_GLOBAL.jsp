<%@ page import="hris.common.rfc.CurrencyCodeRFC" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 자격면허상세                                                */
/*   Program ID   : A17LicenceDetail_GLOBAL.jsp                                        */
/*   Description  : 자격증면허 상세내용 화면                                    */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-02-23  유용원                                          */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="MSG.A.A17.001" updateUrl="${g.servlet}hris.A.A17Licence.A17LicenceChangeSV">
        <%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral tableApproval">
                    <tr>
                        <th><spring:message code="MSG.A.A17.017"/><%--Name & Grade--%></th>
                        <td colspan="3">
                            ${resultData.GRADE}
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="MSG.A.A17.018"/><%--Issue Number--%></th>
                        <td>${resultData.LNUMBER}</td>
                        <th><spring:message code="MSG.A.A17.019"/><%--Acquisition Date--%></th>
                        <td>${f:printDate(resultData.ACDATE)}</td>
                    </tr>
                    <tr>
                        <th><spring:message code="MSG.A.A17.020"/><%--Authority--%></th>
                        <td>${resultData.AUTHORITY}</td>
                        <th><spring:message code="MSG.A.A17.021"/><%--Expiry Date--%></th>
                        <td>${f:printDate(resultData.EXDATE)}</td>
                    </tr>
                </table>
            </div>
            <!-- 상단 입력 테이블 끝-->
        </div>

        <%-- 결재자이거나 결재가 진행된 상태 일 경우 보여준다  --%>
        <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
        <c:if test="${approvalHeader.showManagerArea}">
        <h2 class="subtitle"><spring:message code="MSG.APPROVAL.0021"/><%--담당자입력정보--%></h2>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral tableApproval">

                <c:choose>
                    <%-- 최초 결재자 여부 --%>
                    <%--<c:when test="${approvalHeader.editManagerArea}">--%>
                    <%-- 결재 가능자 --%>
                    <c:when test="${approvalHeader.ACCPFL == 'X'}">
                        <tr>
                            <th><spring:message code="MSG.A.A17.022"/><%--Document evidence--%></th>
                            <td>
                                <input type="radio" name="CERT_FLAG" value="Y" ${resultData.CERT_FLAG == 'Y' ? 'checked' : ''}>Yes
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="radio" name="CERT_FLAG" value="N" ${resultData.CERT_FLAG != 'Y' ? 'checked' : ''} >No

                            </td>
                            <th><spring:message code="MSG.A.A17.023"/><%--Submit Date--%></th>
                            <td>
                                <input type="text" id="CERT_DATE" name="CERT_DATE" class="date" value="${resultData.CERT_DATE}" placeholder="<spring:message code="MSG.A.A17.023"/>">
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <th><spring:message code="MSG.A.A17.022"/><%--Document evidence--%></th>
                            <td>
                                ${resultData.CERT_FLAG == "Y" ? "Yes" : "No"}
                            </td>
                            <th><spring:message code="MSG.A.A17.023"/><%--Submit Date--%></th>
                            <td>
                                ${f:printDate(resultData.CERT_DATE)}
                            </td>
                        </tr>
                    </c:otherwise>

                </c:choose>

                </table>
            </div>
        </div>
        </c:if>


    </tags-approval:detail-layout>
</tags:layout>