<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<c:choose>
    <c:when test="${user.area == 'KR'}">
        <%-- 해당 로직은 A01SelfDetailNeo_m.jsp 에  적용됨 --%>
        <%--<table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="td09" align="left">
                    <font color="red"><spring:message code="MSG.A.A01.0075" />&lt;%&ndash; ※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.&ndash;%&gt;<br><br></font><!--@v1.1-->
                </td>
            </tr>
        </table>--%>
        <%--@elvariable id="user" type="hris.common.WebUserData"--%>
        <%-- 주소 및 신상 --%>
        <self:self-personal-address personalData="${personalData}" />

        <%-- 병역 --%>
        <self:self-army extraData="${armyData}" />

        <%-- 자격 면허 --%>
        <self:self-license licenseList="${licenseList}" />
        <%--<input type="hidden" name="LICN_CODE<%= i %>" value="<%= licndata.LICN_CODE %>">
        <input type="hidden" name="FLAG<%= i %>"      value="<%= licndata.FLAG %>">--%>

        <%-- 학력 --%>
        <self:self-school schoolList="${schoolList}" limit="5"/>

        <%-- 가족사항 --%>
        <self:self-family-mss-kr familyList="${familyList}" />
    </c:when>
    <c:otherwise>
        <%-- 추가 개인데이타
        <self:self-extra-data extraData="${extraData}" />
--%>
        <%-- 자격 면허 --%>
        <self:self-license licenseList="${licenseList}" />

        <%-- 학력 --%>
        <self:self-school schoolList="${schoolList}" limit="5"/>
    </c:otherwise>
</c:choose>