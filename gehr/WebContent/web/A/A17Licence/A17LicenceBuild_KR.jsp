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

    <tags-approval:request-layout titlePrefix="MSG.A.A17.001" subtitleCode="MSG.A.A17.001" >
        <!-- 상단 입력 테이블 시작-->
        <%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>

        <div class="tableArea">
            <div class="table">

                <tags:script>
                    <script>

                        function beforeSubmit() {
                            $("#RequestPageName").val("");
                            return true;
                        }

                        // 자격면허 검색버튼 클릭시 자격면허를 찾는 창이 뜬다.
                        function fn_openLicnCode() {
                            var win = window.open("${g.jsp}A/A17Licence/A17LicenceSearch.jsp", "essPost", "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=yes,width=400,height=500");
                            win.focus();
                        }

                        function licenceSearchData(LICN_CODE, LICN_NAME) {
                            document.form1.LICN_NAME.value = LICN_NAME;
                            document.form1.LICN_CODE.value = LICN_CODE;
                        }


                    </script>
                </tags:script>
                    <%-- 국내 --%>
                <table class="tableGeneral tableApproval">
                    <tr>
                        <th class="th02"><span class="textPink">*</span><spring:message code="MSG.A.A17.003"/><%--자격증--%></th>
                        <td>
                            <input type="text" id="LICN_NAME" name="LICN_NAME" value="${resultData.LICN_NAME}" size="20"
                                   class="required" placeholder="<spring:message code="MSG.A.A17.003"/>" readonly>
                            <a href="javascript:fn_openLicnCode()"><img src="${g.image}/sshr/ico_magnify.png" alt="<spring:message code="BUTTON.COMMON.SEARCH"/>"></a>
                            <input type="hidden" id="LICN_CODE" name="LICN_CODE" value="${resultData.LICN_CODE}">
                        </td>
                        <th class="th02"><span class="textPink">*</span><spring:message code="MSG.A.A17.004"/><%--취득일--%></th>
                        <td>
                            <input type="text" class="date required" id="OBN_DATE" name="OBN_DATE" size="20"
                                   placeholder="<spring:message code="MSG.A.A17.004"/>"
                                   value="${f:printDate(resultData.OBN_DATE)}">
                                <%--<a href="javascript:fn_openCal('OBN_DATE')"><img src="${g.image}/sshr/ico_magnify.png" alt="검색"></a>--%>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.005"/><%--발행처--%></th>
                        <td>
                            <input type="text" name="PUBL_ORGH" size="30" class="required"
                                   value="${resultData.PUBL_ORGH}" placeholder="<spring:message code="MSG.A.A17.005"/>">
                        </td>
                        <th class="th02"><span class="textPink">*</span><spring:message code="MSG.A.A17.006"/><%--자격등급--%></th>
                        <td>
                            <select name="LICN_GRAD" class="required" placeholder="<spring:message code="MSG.A.A17.006"/>">
                                <option value="">------------</option>
                                    ${f:printCodeOption(gradeList, resultData.LICN_GRAD)}
                                    <%--<%= WebUtil.printOption((new A17LicenceGradeRFC()).getLicenceGrade()) %>--%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.007"/><%--자격증번호--%></th>
                        <td colspan="3">
                            <input type="text" name="LICN_NUMB" size="30" class="required" maxlength="20"
                                   value="${resultData.LICN_NUMB}" placeholder="<spring:message code="MSG.A.A17.007"/>">
                        </td>

                    </tr>
                </table>

                <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
            </div>
            <span class="inlineComment"><spring:message code="MSG.COMMON.0061" /><%--*는 필수 입력사항입니다.--%></span>
            <!-- 상단 입력 테이블 끝-->
                <%-- 하단 추가 부분 --%>
            <div class="commentsMoreThan2">
                <spring:message code="MSG.A.A17.008"/>
                    <%--        <div>자격증 종류가 미등록된 경우는 인사부</div>
                            <div>자격증 사본은 해당 주관부서로 제출하시기 바랍니다.</div>--%>
            </div>
        </div>

    </tags-approval:request-layout>


</tags:layout>
