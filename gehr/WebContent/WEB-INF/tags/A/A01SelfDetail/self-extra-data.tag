<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="extraData" required="true" type="hris.A.A01SelfDetailExtraData" %>

<c:if test="${user.area != 'US'}">
<h2 class="subtitle"><spring:message code="MSG.A.A01.0023" /><%--추가개인데이터--%></h2>
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral" cellspacing="0">
            <tr>
                <th><spring:message code="MSG.A.A01.0024" /><%--국적--%></th>
                <td>${extraData.LANDX} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0025" /><%--출생지--%></th>
                <td colspan="3">${extraData.GBORT}</td>
            </tr>
            <tr>
                <th><spring:message code="MSG.A.A01.0026" /><%--생년월일--%></th>
                <td>${f:printDate(extraData.GBDAT)} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0027" /><%--연령--%></th>
                <td>${extraData.AGECN}</td>
                <th class="th02"><spring:message code="MSG.A.A01.0028" /><%--성별--%></th>
                <td>${extraData.GESCX}</td>
            </tr>
            <tr>
                <th><spring:message code="MSG.A.A01.0029" /><%--결혼상태--%></th>
                <td>${extraData.FATXT} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0030" /><%--결혼기념일--%></th>
                <td>${f:printDate(extraData.FAMDT)}</td>
                <th class="th02"><spring:message code="MSG.A.A01.0031" /><%--종교--%></th>
                <td>${extraData.KTEXT}</td>
            </tr>
            <c:if test="${user.area == 'CN'}">
                <tr>
                    <th><spring:message code="MSG.A.A01.0032" /><%--민족--%></th>
                    <td>${extraData.LTEXT} </td>
                    <th class="th02"><spring:message code="MSG.A.A01.0033" /><%--정치성향--%></th>
                    <td>${extraData.PTEXT}</td>
                    <th class="th02"><spring:message code="MSG.A.A01.0034" /><%--계약만료일--%></th>
                    <td>${extraData.CTEDTX}</td>
                </tr>
            </c:if>
        </table>
    </div>
</div>
</c:if>