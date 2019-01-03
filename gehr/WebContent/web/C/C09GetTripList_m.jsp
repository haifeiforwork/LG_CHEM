<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 해외경험                                                    */
/*   Program Name : 해외경험                                                    */
/*   Program ID   : C09GetTripList_m.jsp                                       */
/*   Description  : 교육 이력 조회                                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2016-09-26  정진만                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags-trainig" tagdir="/WEB-INF/tags/C/C03" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="user_m" value="<%=WebUtil.getSessionMSSUser(request) %>" />

<tags:layout >
    <tags:script>
        <script>
            function doSearch() {
                if(isValid("form1")) {
                    $("#form1").attr("target", "").attr("action", "").submit();
                }
            }
        </script>
    </tags:script>
    <form id="form1" name="form1" method="post" >
        <!--교육이수현황 리스트 테이블 시작-->
        <div class="listArea">
            <div class="table">
                <table id="-training-table" class="listTable tablesorter" >
                    <colgroup>
                        <col width="20%"/>
                        <col width="15%;"/>
                        <col />
                        <col />
                        <col />
                        <col />
                        <col />
                        <col />
                    </colgroup>
                    <thead>
                    <tr>
                        <th><spring:message code="LABEL.C.C09.0001" /><!-- 기간 --></th>
                        <th><spring:message code="LABEL.C.C09.0002" /><!-- 활동분야 --></th>
                        <th><spring:message code="LABEL.C.C09.0003" /><!-- 지역 --></th>
                        <th><spring:message code="LABEL.C.C09.0004" /><!-- 단체 --></th>
                        <th><spring:message code="LABEL.C.C09.0005" /><!-- 경유지 1 --></th>
                        <th><spring:message code="LABEL.C.C09.0006" /><!-- 경유지 2 --></th>
                        <th><spring:message code="LABEL.C.C09.0007" /><!-- 소요비용 --></th>
                        <th class="lastCol"><spring:message code="LABEL.C.C09.0008" /><!-- 특기사항 --></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="row" items="${resultList}" varStatus="status">
                        <tr class="${f:printOddRow(status.index)}">
                            <td>${row.PERIOD}</td>
                            <td>${row.RESN_TEXT}</td>
                            <td>${row.DEST_ZONE}</td>
                            <td>${row.CRCL_UNIT}</td>
                            <td>${row.WAY1_ZONE}</td>
                            <td>${row.WAY2_ZONE}</td>
                            <td>${f:convertCurrency(f:changeLocalAmount(row.EDUC_WONX, 'KRW'), '')}</td>
                            <td class="lastCol">${row.RESN_DESC}</td>
                        </tr>
                    </c:forEach>
                    <tags:table-row-nodata list="${resultList}" col="8" />
                    </tbody>
                </table>
            </div>
        </div>
        <!--교육이수현황 리스트 테이블 끝-->
    </form>
</tags:layout>


