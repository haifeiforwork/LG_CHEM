<%@ page import="com.common.constant.Area" %>
<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 주소 신청                                           */
/*   Program ID   : A13AddressApprovalBuilder_DE.jsp                                         */
/*   Description  : 주소를 신청할 수 있는 화면                            */
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

    <tags-approval:request-layout titlePrefix="TTTLE.A.A13" representative="false">
        <%--@elvariable id="resultData" type="hris.A.A13Address.A13AddressApprovalData"--%>
        <!-- 상단 입력 테이블 시작-->
        <div class="tableArea">
            <div class="table">

                <tags:script>
                    <SCRIPT LANGUAGE="JavaScript">
                        function beforeSubmit() {
                            if (document.form1.PSTLZ.value.length != 5) {
                                alert('<spring:message code="MSG.A.A13.040"/>'); //Please input Postal Code 5 length
                                document.form1.PSTLZ.focus();
                                return false;
                            }
                            return true;
                        }

                        function js_change() {
//                            document.form1.NAME2.value = document.form1.ANSSA.options[document.form1.ANSSA.selectedIndex].text;
                        }

                    </SCRIPT>
                </tags:script>
                    <%-- 국내 --%>
                <table class="tableGeneral tableApproval">
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A13.035"/><%--Address Type--%>&nbsp;</th>
                        <td colspan="3">
                            <select name="ANSSA" class="required" onchange="javascript:js_change()" placeholder="<spring:message code="MSG.A.A13.035"/><%--Address Type--%>">
                                ${f:printCodeOption(subTypeList, resultData.ANSSA)}
                            </select>
                            <%--<input type="hidden" name="NAME2"     value="${resultData.NAME2}">--%>
                            <input type="hidden" name="LAND1" value="DE" >
                            <input type="hidden" name="LANDX" value="Germany" >
                            <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
                        </td>
                    </tr>

                    <tr>
                        <th><spring:message code="MSG.A.A13.016"/><!-- Street and House No. --></th>
                        <td colspan="3">
                            <input type="text" name="STRAS" size="50" value="${resultData.STRAS}" >
                        </td>
                    </tr>

                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A13.0001"/><!-- Postal Code/City --></th>
                        <td>
                            <input type="text" name="PSTLZ" size="5" maxlength="5" class="required" value="${resultData.PSTLZ}" placeholder="<spring:message code="LABEL.A.A13.0001"/>">
                        </td>
                        <td colspan="2">
                            <input type="text" name="ORT01" size="50" value="${resultData.ORT01}" class="required" placeholder="Post">
                        </td>
                    </tr>

                    <tr>
                        <th><spring:message code="MSG.A.A13.020"/><!-- District --></th>
                        <td colspan="3"><input type="text" name="ORT02" size="50" value="${resultData.ORT02}"></td>
                    </tr>

                    <tr>
                        <th><spring:message code="MSG.A.A13.021"/><!-- Telephone Number --></th>
                        <td colspan="3"><input type="text" name="TELNR" size="11" value="${resultData.TELNR}"></td>
                    </tr>

                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A13.022"/><!-- District in km. --></th>
                        <td colspan="3">
                            <input type="text" name="ENTKM" class="required" size="5" maxlength="3" value="${resultData.ENTKM}" placeholder="<spring:message code="MSG.A.A13.022"/>">
                        </td>
                    </tr>
                </table>
            </div>
            <span class="inlineComment"><spring:message code="MSG.COMMON.0061"/><%--*는 필수 입력사항입니다.--%></span>
            <!-- 상단 입력 테이블 끝-->
        </div>

    </tags-approval:request-layout>


</tags:layout>
