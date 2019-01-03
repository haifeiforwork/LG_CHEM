<%/******************************************************************************/
/*   System Name  : Global e-hr                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주소                                                        */
/*   Program Name : 주소                                                        */
/*   Program ID   : A13AddressDetail_PL.jsp                                        */
/*   Description  : 주소 상세조회                                                */
/*   Note         :                                                             */
/*   Creation     : 2010 06 25 yji                                                           */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-address" tagdir="/WEB-INF/tags/A/A13Address" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<jsp:useBean id="resultData" class="hris.A.A13Address.A13AddressListData" scope="request" />
<%@ include file="/web/common/commonProcess.jsp" %>
<%-- 내용 부 --%>
<tags-address:address-detail-layout data="${resultData}" >
        <div class="table">
            <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                <colgroup>
                    <col width="160" >
                    <col width="100" >
                    <col>
                </colgroup>
                <tr>
                    <th><spring:message code="MSG.A.A13.010"/><%--Address Type--%></th>
                    <td colspan="2">${resultData.ANSTX }</td>
                </tr>

                <tr>
                    <th><spring:message code="MSG.A.A13.016"/> <%--Street and House No.--%></td>
                    <td colspan="2">${resultData.STRAS }</td>
                </tr>

                <tr>
                    <th><spring:message code="MSG.A.A13.012"/> <%--Postal Code/Post--%></td>
                    <td>${resultData.PSTLZ }</td>
                    <td>${resultData.OR2KK }</td>
                </tr>

                <tr>
                    <th><spring:message code="MSG.A.A13.017"/> <%--Region--%></td>
                    <td colspan="2">${resultData.BEZEI }</td>
                </tr>

                <tr>
                    <th><spring:message code="MSG.A.A13.018"/> <%--County Code--%></td>
                    <td colspan="2"><%--${resultData.COUNC } --%>${resultData.BEZEI1 }</td>
                </tr>

                <tr>
                    <th><spring:message code="MSG.A.A13.019"/> <%--District Key--%></td>
                    <td colspan="2">
                          <%--  ${resultData.TERY0 }&nbsp;
                            ${resultData.TERY1 }&nbsp;
                            ${resultData.RCTVC }&nbsp;--%>
                            ${resultData.TTEXT }
                    </td>
                </tr>

                <tr>
                    <th><spring:message code="MSG.A.A13.020"/> <%--District--%></td>
                    <td colspan="2">${resultData.ORT02 }</td>
                </tr>

                <tr>
                    <th><spring:message code="MSG.A.A13.021"/> <%--Telephone Number--%></td>
                    <td colspan="2">${resultData.TELNR }</td>
                </tr>

                <tr>
                    <th><spring:message code="MSG.A.A13.022"/> <%--District in km.--%></td>
                    <td colspan="2">${resultData.ENTKM }</td>
                </tr>
            </table>
        </div>
</tags-address:address-detail-layout>




