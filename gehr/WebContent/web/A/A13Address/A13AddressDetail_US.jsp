<%
/***************************************************************************************/
/*   System Name  	: g-HR              																												*/
/*   1Depth Name		: Personal HR Info                                                  															*/
/*   2Depth Name  	: Personal Info                                                    																*/
/*   Program Name 	: Address                                                    																	*/
/*   Program ID   		: A13AddressDetail_US.jsp                                        															*/
/*   Description  		: 주소 상세조회 (USA)                                              															*/
/*   Note         		:                                                             																		*/
/*   Creation     		: 2010-10-04 jungin @v1.0 																								*/
/***************************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags-address" tagdir="/WEB-INF/tags/A/A13Address" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<jsp:useBean id="resultData" class="hris.A.A13Address.A13AddressListData" scope="request"/>
<%-- 내용 부 --%>
<tags-address:address-detail-layout data="${resultData}">
        <div class="table">
            <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                <colgroup>
                    <col width="160">
                    <col>
                </colgroup>
                <tr>
                    <th><spring:message code="MSG.A.A13.010"/><%--Address Type--%></th>
                    <td>${resultData.ANSTX}</td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.023"/><%--Address Line 1--%></th>
                    <td>${resultData.STRAS}</td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.024"/><%--Address Line 2--%></th>
                    <td>${resultData.LOCAT}</td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.025"/><%--City / Country--%></th>
                    <td>${resultData.ORT01} ${resultData.ORT02}</td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.026"/><%--State / Zip Code--%></th>
                    <td>${resultData.BEZEI} / ${resultData.PSTLZ}</td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A13.021"/><%--Telephone Number--%></th>
                    <td>${resultData.TELNR}</td>
                </tr>
            </table>
        </div>
</tags-address:address-detail-layout>
