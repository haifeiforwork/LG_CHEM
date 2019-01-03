<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>

<%@ attribute name="approvalLine" type="java.util.Vector" required="true" %>

<div class="listArea" id="-approvalLine-layout">
    <div class="table">
        <table class="listTable" id="-approvalLine-table">
            <colgroup>
                <col width="15%" />
                <col width="20%" />
                <col width="10%" />
                <col width="55%" />
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code='MSG.APPROVAL.0012' /><%--구분--%></th>
                <th><spring:message code='MSG.APPROVAL.0013' /><%--성명--%></th>
                <%-- //[CSR ID:3456352]<th><spring:message code='MSG.APPROVAL.0014' />직위</th> --%>
                <th><spring:message code='MSG.APPROVAL.0024' /><%--직책/직급호칭--%></th>
                <th class='lastCol'><spring:message code='MSG.APPROVAL.0015' /><%--부서--%></th>
            </tr>
            </thead>
            <%--@elvariable id="approvalLine" type="java.util.Vector<hris.common.approval.ApprovalLineData>"--%>
            <c:forEach var="row" items="${approvalLine}" varStatus="status">
                <tr class="${f:printOddRow(status.index)}" >
                    <td><spring:message code="COMMON.APPROVAL.${row.APPU_TYPE}.STAT"/><%--${row.APPU_NAME}--%></td>
                    <td class="align_left">
                        <input id="APPLINE_ENAME_${status.index}" data-idx="${status.index}"  name="APPLINE_ENAME" type="text" size="23" value="${row.ENAME}" placeholder="${row.ENAME}" readonly/>

                        <c:if test="${row.APPU_TYPE == '01'}">
                            <%--[CSR ID:3438118] flexible time 시스템 요청  eunha 20170905 Flextime에서 담당결재가 2차까지 있어 로직이 제대로 수행되지 않아 수정 start --%>
                            <a href="javascript:changePop('${status.index}');" id = "-search-decision_${status.index}"  class="-search-decision unloading"  data-idx="${status.index}" data-objid="${row.OBJID}"><img src="${g.image}sshr/ico_magnify.png" /></a>
                            <%--<a href="javascript:;" class="-search-decision unloading"  data-idx="${status.index}"><img src="${g.image}sshr/ico_magnify.png" /></a> --%>
                            <%--[CSR ID:3438118] flexible time 시스템 요청  eunha 20170905 Flextime에서 담당결재가 2차까지 있어 로직이 제대로 수행되지 않아 수정 end --%>
                        </c:if>
                        <input type="hidden" id="APPLINE_APPR_TYPE_${status.index}" name="APPLINE_APPR_TYPE" value="${row.APPR_TYPE}" />
                        <input type="hidden" id="APPLINE_APPU_TYPE_${status.index}" name="APPLINE_APPU_TYPE" value="${row.APPU_TYPE}" />
                        <input type="hidden" id="APPLINE_APPR_SEQN_${status.index}" name="APPLINE_APPR_SEQN" value="${row.APPR_SEQN}" />
                        <%--<input type="hidden" id="APPLINE_APPU_NUMB_${status.index}" name="APPLINE_APPU_NUMB" value="${row.APPU_NUMB}" />--%>
                        <input type="hidden" id="APPLINE_APPU_ENC_NUMB_${status.index}" name="APPLINE_APPU_ENC_NUMB" value="${row.APPU_NUMB == '00000000' ? '' : f:encrypt(row.APPU_NUMB)}" />
                        <input type="hidden" id="APPLINE_OTYPE_${status.index}" name="APPLINE_OTYPE" value="${row.OTYPE}" />
                        <input type="hidden" id="APPLINE_OBJID_${status.index}" name="APPLINE_OBJID" value="${row.OBJID}" />

                        <input type="hidden" id="APPLINE_APPU_NAME_${status.index}" name="APPLINE_APPU_NAME" value="${row.APPU_NAME}" />
                        <input type="hidden" id="APPLINE_JIKWT_${status.index}" name="APPLINE_JIKWT" value="${row.JIKWT}" />
                        <input type="hidden" id="APPLINE_ORGTX_${status.index}" name="APPLINE_ORGTX" value="${row.ORGTX}" />

                    </td>
                    <td id="-APPLINE-JIKWT-${status.index}" >
                    <%--//[CSR ID:3456352] ${row.JIKWT}--%>
                    <c:choose>
		                <c:when test="${row.BUKRS=='C100' && row.JIKWE=='EBA' && row.JIKKT!=''}">
			                ${row.JIKKT}
		                </c:when>
						 <%-- [CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 start --%>
						 <c:when test="${f:isChangeGlobalJIKKT(row.BUKRS,row.PERSG,row.PERSK,row.JIKWE,row.JIKKT, row.JIKCH)}">
			               ${row.JIKKT}
		                </c:when>
		                <%-- [CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 end --%>
		                <c:otherwise>
		               		${row.JIKWT}
		                </c:otherwise>
	                </c:choose>
	                <%--//[CSR ID:3456352]--%>
                    </td>
                    <td id="-APPLINE-ORGTX-${status.index}" class="lastCol align_left">${row.ORGTX}</td>
                </tr>
            </c:forEach>
            <tags:table-row-nodata list="${approvalLine}" col="4" />
        </table>
    </div>
</div>