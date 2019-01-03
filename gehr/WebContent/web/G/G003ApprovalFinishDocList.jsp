<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서 리스트                                       */
/*   Program Name : 결재 완료 문서                                              */
/*   Program ID   : G003ApprovalFinishDocList.jsp                               */
/*   Description  : 문서 목록보기                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/G" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page errorPage="/web/err/error.jsp"%>

<%@ include file="/web/common/commonProcess.jsp" %>

<tags:layout title="COMMON.MENU.ESS_APP_VED_DOC">
    <%--@elvariable id="g" type="com.common.Global"--%>
    <%--@elvariable id="pu" type="com.sns.jdf.util.PageUtil"--%>
    <tags:script>
        <script language="JavaScript" type="text/JavaScript">
            <!--
            function viewDetail(idx) {
                var $row = $("#row_" + idx);

                $("#AINF_SEQN").val($row.data("seq"));
                $("#UPMU_TYPE").val($row.data("type"));
                $("#PERNR").val($row.data("pernr"));

                document.detailForm.submit();
            }

            //-->
        </script>
    </tags:script>
    <!--  검색테이블 시작 -->
    <div class="tableInquiry">
        <form id="detailForm" name="detailForm" action="${g.servlet}hris.G.G003ApprovalFinishDetailSV">
            <input type="hidden" id="AINF_SEQN" name="AINF_SEQN" />
            <input type="hidden" id="UPMU_TYPE" name="UPMU_TYPE" />
            <input type="hidden" id="PERNR" name="PERNR" />
            <input type="hidden" id="RequestPageName" name="RequestPageName" value="${currentURL}"/>
        </form>
        <form id="searchForm" name="searchForm" action="${g.servlet}hris.G.G003ApprovalFinishDocListSV">
            <%-- 검색 공통 --%>
            <tags-approval:approval-search-layout />
        </form>
    </div>
    <!--  검색테이블 끝-->

    <!-- 리스트테이블 시작 -->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt">${pu.pageInfo}</span>
        </div>
        <div class="table">
            <table class="listTable">
                <thead>
                <tr>
                    <th><spring:message code="LABEL.G.G01.0001" /><!-- 순번 --></th>
                    <th><spring:message code="LABEL.G.G02.0008" /><!-- 제목 --></th>
                    <th><spring:message code="MSG.APPROVAL.0015" /><!-- 부서 --></th>
                    <th><spring:message code="LABEL.G.G01.0003" /><!-- 신청자 --></th>
                    <th><spring:message code="LABEL.G.G01.0004" /><!-- 신청일 --></th>
                    <c:if test="${!g.sapType.local}">
                        <th><spring:message code="LABEL.G.G01.0005" /><!-- Appl.Date --></th>
                    </c:if>
                    <th class="lastCol"><spring:message code="MSG.APPROVAL.0017" /><!-- 상태 --></th>
                </tr>
                </thead>
                    <%--@elvariable id="resultList" type="java.util.Vector<hris.G.G001Approval.ApprovalDocList>"--%>
                <c:forEach var="row" items="${resultList}" varStatus="status" begin="${pu.from}" end="${pu.to > 0 ? pu.to - 1 : pu.to}">
                    <tr id="row_${status.index}" class="${f:printOddRow(status.index)}" data-type="${row.UPMU_TYPE}" data-seq="${row.AINF_SEQN}"  data-pernr="${row.PERNR}" >
                        <td>${pu.from + status.count}</td>
                        <td style="cursor: pointer;" <c:if test="${isLocal != true}"> onClick="viewDetail(${status.index});" </c:if> >
                            ${row.UPMU_NAME}
                            <c:if test="${isLocal == true}">
                                <br>
                                ${row.AINF_SEQN}
                            </c:if>
                        </td>
                        <td class="align_left" style="cursor: pointer;" onClick="viewDetail(${status.index});">${row.STEXT}</td>
                        <td>${row.ENAME}</td>
                        <td>${f:printDate(row.BEGDA)}</td>
                        <c:if test="${!g.sapType.local}">
                            <td>${f:printDate(row.APPL_DATE)}</td>
                        </c:if>
                        <td class="lastCol">
                            <c:choose>
                                <c:when test="${row.APPR_STAT == 'A'}"><spring:message code="COMMON.APPROVAL.LIST.FINISH.A"/></c:when>
                                <c:when test="${row.APPR_STAT == 'R'}"><spring:message code="COMMON.APPROVAL.LIST.FINISH.R"/></c:when>
                                <c:when test="${row.APPR_STAT == ' '}"><spring:message code="COMMON.APPROVAL.LIST.FINISH.NONE"/></c:when>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${f:getSize(resultList) <= pu.from}">
                    <tags:table-row-nodata list="${emptyList}" col="${g.sapType.local ? '7' : '8'}" />
                </c:if>
                    <%--<input type="hidden" name="rowCount" value = "<%=pu.toRow() - pu.formRow()%>">--%>
            </table>
            <div class="align_center">
                    ${pu.pageControl}
            </div>
        </div>
    </div>
    <!-- 리스트테이블 끝-->
</tags:layout>


