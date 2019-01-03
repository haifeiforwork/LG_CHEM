<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ attribute name="pageType" type="java.lang.String"%>
<%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
            <colgroup>
                <col width="15%">
                <col width="35%">
                <col width="15%">
                <col width="35%">
            </colgroup>
            <tr>
                <th><spring:message code="MSG.APPROVAL.0007" /><%--작성자--%></th>
                <td colspan="3">
               <%--  ${approvalHeader.ORGTX} ${approvalHeader.ENAME} ${approvalHeader.JIKWT} (${approvalHeader.PHONE_NUM}) (${approvalHeader.PERNR}) --%>
                <%-- [CSR ID:3456352] --%>
                <c:choose>
	                <c:when test="${approvalHeader.BUKRS=='C100' && approvalHeader.JIKWT=='책임' && approvalHeader.JIKKT!=''}">
		            	${approvalHeader.ORGTX} ${approvalHeader.ENAME} ${approvalHeader.JIKKT} (${approvalHeader.PHONE_NUM}) (${approvalHeader.PERNR})
	                </c:when>
	                <%-- [CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 start --%>
	                <c:when test="${f:isChangeGlobalJIKKT(approvalHeader.BUKRS,approvalHeader.PERSG,approvalHeader.PERSK,approvalHeader.JIKWE,approvalHeader.JIKKT, approvalHeader.JIKCH)}">
		            	${approvalHeader.ORGTX} ${approvalHeader.ENAME} ${approvalHeader.JIKKT} (${approvalHeader.PHONE_NUM}) (${approvalHeader.PERNR})
	                </c:when>
	                <%-- [CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 end --%>
	                <c:otherwise>
	               		${approvalHeader.ORGTX} ${approvalHeader.ENAME} ${approvalHeader.JIKWT} (${approvalHeader.PHONE_NUM}) (${approvalHeader.PERNR})
	                </c:otherwise>
                </c:choose>
                <%-- [CSR ID:3456352] --%>
                </td>
            </tr>
            <tr>
                <th><spring:message code="MSG.APPROVAL.0008" /><%--작성일--%></th>
                <td>
                    ${f:printDate(approvalHeader.RQDAT)}
                    <c:if test="${pageType != 'request'}">
                        ${f:printTime(approvalHeader.RQTIM)}
                    </c:if>
                </td>
                <th class="th02"><spring:message code="MSG.APPROVAL.0009" /><%--보존년한--%></th>
                <td>
                    <spring:message code="MSG.APPROVAL.0010" /><%--영구--%>
                </td>
            </tr>
        </table>
        <%--<table width="780" height="4" border="0" cellpadding="0" cellspacing="0">--%>
            <%--<tr>--%>
                <%--<td width="3"></td>--%>
                <%--<td><img src="${g.image}ehr/space.gif" height="4"></td>--%>
                <%--<td width="3"></td>--%>
            <%--</tr>--%>
        <%--</table>--%>
    </div>
</div>
