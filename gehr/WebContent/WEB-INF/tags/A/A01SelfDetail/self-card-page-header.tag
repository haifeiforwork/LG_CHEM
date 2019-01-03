<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="resultData" required="true" type="hris.A.A01SelfDetailData" %>
<%@ attribute name="hideHeader" type="java.lang.Boolean" %>

<div class="printPageHeader">
    <div>
        <div class="-small-font" style="float:left; color: grey;">NO : ${resultData.CFNUM}</div>
        <div class="-small-font" style="float:right; color: grey;">DATE : ${f:printDate(printDate)}</div>
    </div>

    <div style="clear: both"></div>

    <c:if test="${hideHeader != true}">
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral" style="table-layout: fixed;">
                <tr>
                    <th width="8%"><spring:message code="LABEL.COMMON.0007" /></th>
                    <td style="white-space: nowrap">${resultData.ORGTX} ( ${resultData.JIKWT}${not empty resultData.JIKKT ? "/" : ""}${resultData.JIKKT} )<td>
                    <%--<th width="8%" class="th02"><!--직위--><spring:message code="LABEL.COMMON.0008" /></th>
                    <td style="white-space:nowrap;">${resultData.JIKWT}<td>
                    <th width="8%" class="th02"><!--직책--><spring:message code="LABEL.COMMON.0009" /></th>
                    <td style="white-space:nowrap;">${resultData.JIKKT}<td>--%>
                    <th width="8%" class="th02"><!--성명--><spring:message code="LABEL.COMMON.0010" /></th>
                    <td width="25%">
                        <c:out value='${resultData.ENAME} '/>(<c:out value='${resultData.PERNR}'/>)
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div>&nbsp;</div>
    <div>&nbsp;</div>
    </c:if>
</div>