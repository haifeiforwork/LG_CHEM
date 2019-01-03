<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="extraData" required="true" type="hris.A.A01SelfDetailArmyData" %>

<h2 class="subtitle"><spring:message code="MSG.A.A01.0059" /><%--병역사항--%></h2>
<div class="listArea">
    <div class="table">
        <table class="tableGeneral" cellspacing="0">
            <tr>
                <th><spring:message code="MSG.A.A01.0060" /><%--복무기간--%></th>
                <td colspan="3">${armyData.PERIOD} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0062" /><%--실역구분--%></th>
                <td>${armyData.TRAN_TEXT}</td>
            </tr>
            <tr>
                <th><spring:message code="MSG.A.A01.0063" /><%--군별--%></th>
                <td>${armyData.SERTX} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0064" /><%--계급--%></th>
                <td>${armyData.RKTXT}</td>
                <th class="th02"><spring:message code="MSG.A.A01.0065" /><%--전역사유--%></th>
                <td>${armyData.RTEXT}</td>
            </tr>
            <tr>
                <th><spring:message code="MSG.A.A01.0066" /><%--군번--%></th>
                <td>${armyData.IDNUM} </td>
                <th class="th02"><spring:message code="MSG.A.A01.0067" /><%--주특기--%></th>
                <td>${armyData.JBTXT}</td>
                <th class="th02"><spring:message code="MSG.A.A01.0068" /><%--면제사유--%></th>
                <td>${armyData.RSEXP}</td>
            </tr>
        </table>
    </div>
</div>