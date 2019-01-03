<!-- update:	2018-03-14 cykim [CSR ID:3627348] 인사데이터 관련  -->
<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="personalData" required="true" type="hris.A.A01SelfDetailPersonalData" %>

<h2 class="subtitle"><spring:message code="MSG.A.A01.0042" /><%--주소 및 신상--%></h2>
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral" cellspacing="0">
            <tr>
                <th><spring:message code="MSG.A.A01.0043" /><%--현주소--%></th>
                <td colspan="5">${personalData.STRAS1} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0044" /><%--우편번호--%></th>
                <td>${personalData.PSTLZ1}</td>
            </tr>
            <tr>
                <th><spring:message code="MSG.A.A01.0045" /><%--본적--%></th>
                <td colspan="5">${personalData.STRAS} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0046" /><%--우편번호--%></th>
                <td>${personalData.PSTLZ}</td>
            </tr>
            <tr>
                <th><spring:message code="MSG.A.A01.0047" /><%--신장--%></th>
                <td>${f:appendSuffix(f:printNum(personalData.ZHEIGHT), " cm") } </td>
                <th class="th02"><spring:message code="MSG.A.A01.0048" /><%--체중--%></th>
                <td>${f:appendSuffix(f:printNum(personalData.ZWEIGHT), " kg") }</td>
                <th class="th02"><spring:message code="MSG.A.A01.0049" /><%--시력(좌)--%></th>
                <td>${f:printNumFormat(personalData.LSIGHT, 1)}</td>
                <th class="th02"><spring:message code="MSG.A.A01.0050" /><%--시력(우)--%></th>
                <td>${f:printNumFormat(personalData.RSIGHT, 1)}</td>
            </tr>
            <tr>
                <th><spring:message code="MSG.A.A01.0051" /><%--색맹--%></th>
                <td>
                    <c:choose>
                        <c:when test="${personalData.CBLIND == 'N'}">
                            <spring:message code="MSG.A.A01.0076"/><%--정상--%>
                        </c:when>
                        <%--[CSR ID:3627348] 인사데이터 관련  start --%>
						<c:when test="${personalData.CBLIND == 'Y'}">
							<spring:message code="MSG.A.A01.0077"/><%--비정상--%>
                        </c:when>
                        <c:otherwise>
                            <%--CBLIND: "" 일 경우 공란으로 처리.--%>
                        </c:otherwise>
                        <%--[CSR ID:3627348] 인사데이터 관련  end --%>
                    </c:choose>
                </td><%--a01SelfDetailData.FLAG.equals("N") ? "정상" : "비정상"--%>
                <th class="th02"><spring:message code="MSG.A.A01.0052" /><%--혈액형--%></th>
                <td>${personalData.BLDTYP}</td>
                <th class="th02"><spring:message code="MSG.A.A01.0053" /><%--장애--%></th>
                <td>${personalData.HNDCD}</td><%--a01SelfDetailData.FLAG1.equals("N") ? "" : a01SelfDetailData.FLAG1--%>
                <th class="th02"><spring:message code="MSG.A.A01.0054" /><%--특기--%></th>
                <td>${personalData.ZTALEN}</td>
            </tr>
            <tr>
                <th><spring:message code="MSG.A.A01.0055" /><%--결혼여부--%></th>
                <td>${personalData.FATXT} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0056" /><%--주거형태--%></th>
                <td>${personalData.LIVETP}</td>
        <c:choose>
            <c:when test="${pageType == 'M'}">
                <th class="th02"><spring:message code="MSG.A.A01.0031" /><%--종교--%></th>
                <td>${personalData.KTEXT}</td>
            </c:when>
            <c:otherwise>
                <th class="th02"><spring:message code="MSG.A.A01.0057" /><%--보훈대상--%></th>
                <td>${personalData.CONTX}</td>
            </c:otherwise>
        </c:choose>
                <th class="th02"><spring:message code="MSG.A.A01.0058" /><%--취미--%></th>
                <td>${personalData.ZHOBBY}</td>
            </tr>
        <c:if test="${pageType == 'M'}">
            <tr>
                <th><spring:message code="MSG.A.A01.0057" /><%--보훈대상--%></th>
                <td colspan="7" class="td04" style="text-align:left">${personalData.CONTX}</td>
            </tr>
        </c:if>
        </table>
    </div>
</div>