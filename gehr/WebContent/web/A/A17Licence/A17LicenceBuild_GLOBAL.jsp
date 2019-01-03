<%@ page import="com.common.constant.Area" %>
<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 자격면허등록 신청                                           */
/*   Program ID   : A17LicenceBuild_GLOBAL.jsp                                         */
/*   Description  : 자격증면허를 신청할 수 있는 화면                            */
/*   Note         :                                                             */
/*   Creation     : 2002-01-11  최영호                                          */
/*   Update       : 2005-02-15                                                  */
/*                                                                              */
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css">

    <tags-approval:request-layout titlePrefix="MSG.A.A17.001" subtitleCode="MSG.A.A17.001">
        <tags:script>
            <script>

                function beforeSubmit() {
                    $("#RequestPageName").val("");
                    return true;
                }
            </script>
        </tags:script>

        <!-- 상단 입력 테이블 시작-->
        <%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>
        <div class="tableArea">
            <div class="table">

                <%-- 해외 --%>
                <table class="tableGeneral tableApproval">
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.017"/><%--Name & Grade--%></th>
                        <td colspan="3">
                            <input type="text" name="GRADE" class="required" size="30" value="${resultData.GRADE}" maxlength="60" placeholder="<spring:message code="MSG.A.A17.017"/>">
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.018"/><%--Issue Number--%></th>
                        <td><input type="text" name="LNUMBER" class="required" size="30" maxlength="20" value="${resultData.LNUMBER}" placeholder="<spring:message code="MSG.A.A17.018"/>">
                        </td>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.019"/><%--Acquisition Date--%></th>
                        <td>
                            <input type="text" name="ACDATE" class="date required" value="${f:printDate(resultData.ACDATE)}" placeholder="<spring:message code="MSG.A.A17.019"/>">
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.020"/><%--Authority--%></th>
                        <td>
                            <input type="text" name="AUTHORITY" class="required" size="30" maxlength="60" value="${resultData.AUTHORITY}" placeholder="<spring:message code="MSG.A.A17.020"/>">
                        </td>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.021"/><%--Expiry Date--%></th>
                        <td>
                            <input type="text" name="EXDATE" class="date required" value="${f:printDate(resultData.EXDATE)}" placeholder="<spring:message code="MSG.A.A17.021"/>">
                        </td>
                    </tr>
                </table>
                <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
            </div>
            <span class="inlineComment"><spring:message code="MSG.COMMON.0061" /><%--*는 필수 입력사항입니다.--%></span>
            <!-- 상단 입력 테이블 끝-->
        </div>

    </tags-approval:request-layout>

</tags:layout>
