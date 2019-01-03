<%@ page import="hris.common.rfc.CurrencyCodeRFC" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 주소상세                                                */
/*   Program ID   : A13AddressApprovalBuild_DE.jsp                              */
/*   Description  : 주소 상세내용 화면                                    */
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
    <tags-approval:detail-layout titlePrefix="TTTLE.A.A13" updateUrl="${g.servlet}hris.A.A13Address.A13AddressApprovalChangeSV">
        <%--@elvariable id="resultData" type="hris.A.A13Address.A13AddressApprovalData"--%>
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral tableApproval">
                    <tr>
                        <th><spring:message code="MSG.A.A13.035"/><%--Address Type--%>&nbsp;</th>
                        <td  colspan="3">
                            <%--${resultData.NAME2 }--%>
                            ${f:printOptionValueText(subTypeList, resultData.ANSSA)}
                        </td>
                    </tr>

                    <tr>
                        <th><spring:message code="MSG.A.A13.016"/><!-- Street and House No. --></th>
                        <td colspan="3">${resultData.STRAS }</td>
                    </tr>

                    <tr>
                        <th><spring:message code="LABEL.A.A13.0001"/><!-- Postal Code/City --></th>
                        <td >${resultData.PSTLZ }</td>
                        <td colspan="2">${resultData.ORT01 }</td>
                    </tr>

                    <tr>
                        <th><spring:message code="MSG.A.A13.020"/><!-- District --></th>
                        <td  colspan="3">${resultData.ORT02 }</td>
                    </tr>

                    <tr>
                        <th><spring:message code="MSG.A.A13.021"/><!-- Telephone Number --></th>
                        <td  colspan="3">${resultData.TELNR }</td>
                    </tr>

                    <tr>
                        <th><spring:message code="MSG.A.A13.022"/><!-- District in km. -->&nbsp;</th>
                        <td  colspan="3">${resultData.ENTKM }</td>
                    </tr>
                </table>
            </div>
            <!-- 상단 입력 테이블 끝-->
        </div>

    </tags-approval:detail-layout>
</tags:layout>