<%/********************************************************************************/
/*   Update       : 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/**********************************************************************************/%>
<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ attribute name="isLink" type="java.lang.Boolean" required="true" %>

<h2 class="subtitle"><spring:message code="MSG.B.B01.0036" /><%--평가사항 조회--%></h2>

<!--평가사항 리스트 테이블 시작-->
<div class="listArea">

    <div class="table">
            <%--
            아래 로직은 B01ValuateDetailData 안으로 이동
             if (Integer.parseInt(data.YEAR1) > 1998 &&Integer.parseInt(data.YEAR1) < 2006 )
                d_RATING5 = DataUtil.nelim(Double.parseDouble(data.RATING5)/0.8/1.125,1);
            else
                d_RATING5 = Double.parseDouble(data.RATING5);
             --%>



        <c:choose>
            <%--  user_m.e_persk.equals("31") || user_m.e_persk.equals("33")||user_m.e_persk.equals("38") --%>
            <%-- 전문직 + BAFA or BACA --%>
            <c:when test="${pageType == 'E' and (user.e_persk == '31' or user.e_persk == '33' || user.e_persk == '38')}">
                <table class="listTable">
                    <thead>
                    <tr>
                        <th><spring:message code="MSG.B.B01.0037" /><%--년도--%></th>
                        <th><spring:message code="MSG.B.B01.0038" /><%--소속--%></th>
                        <th><spring:message code="MSG.B.B01.0039" /><%--직급--%></th>
						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
						<%--<th><spring:message code="MSG.B.B01.0040" /><!--호칭--></th> --%>
						<th><spring:message code="MSG.APPROVAL.0025" /><%--직책/직급호칭--%></th>
						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                        <th><spring:message code="MSG.B.B01.0048" /><%--상대화--%></th>
                        <th class="lastCol"><spring:message code="MSG.B.B01.0049" /><%--최종평가자--%></th>
                    </tr>
                    </thead>
                    <tbody>

                    <c:forEach var="row" items="${evalList}" varStatus="status">
                        <tr class="${f:printOddRow(status.index)}">
                            <td>${row.YEAR1}</td>
                            <td>${row.ORGTX}</td>
                            <td>${row.TRFGR}</td>
                            <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start
                            <td>${row.TITEL}</td>--%>
                            <td>${row.TITEL eq '책임' and  row.TITL2 ne '' ? row.TITL2 : row.TITEL}</td>
                            <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                            <td>${row.RTEXT1}</td>
                            <td class="lastCol">${row.BOSS_NAME}</td>
                        </tr>
                    </c:forEach>
                    <tags:table-row-nodata list="${evalList}" col="6"/>
                    </tbody>
                </table>
            </c:when>

            <%--@elvariable id="user" type="hris.common.WebUserData"--%>
            <%-- MSS 일 경우 사원 서브그룹별 보여주는 부분 --%>
            <c:when test="${pageType == 'M' and (user.e_persk == '31' or user.e_persk == '33' || user.e_persk == '38')}">
                <table class="listTable">
                    <thead>
                    <tr>
                        <th rowspan=2><spring:message code="MSG.B.B01.0037" /><%--년도--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0038" /><%--소속--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0039" /><%--직급--%></th>
						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
						<%--<th rowspan=2><spring:message code="MSG.B.B01.0040" /><!--호칭--></th> --%>
						<th rowspan=2><spring:message code="MSG.APPROVAL.0025" /><%--직책/직급호칭--%></th>
						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                        <th colspan=3><spring:message code="MSG.B.B01.0062" /><%--업적평가--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0045" /><%--능력--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0046" /><%--태도--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0047" /><%--절대<br>평가--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0048" /><%--상대화--%></th>
                        <th class="lastCol" rowspan=2><spring:message code="MSG.B.B01.0049" /><%--최종<br>평가자--%></th>

                    </tr>
                    <tr>
                        <th width="30"><spring:message code="MSG.B.B01.0050" /><%--본인--%></th>
                        <th width="30"><spring:message code="MSG.B.B01.0051" /><%--상사--%></th>
                        <th width="40"><spring:message code="MSG.B.B01.0052" /><%--계--%></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="row" items="${evalList}" varStatus="status">
                        <tr class="${f:printOddRow(status.index)}">
                            <td>${row.YEAR1}</td>
                            <td>${row.ORGTX}</td>
                            <td>${row.TRFGR}</td>
                            <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start
                            <td>${row.TITEL}</td>--%>
                            <td>${row.TITEL eq '책임' and  row.TITL2 ne '' ? row.TITL2 : row.TITEL}</td>
                            <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                            <td>${f:defaultIfZero(row.RATING4,  "")}</td>
                            <td>${f:defaultIfZero(row.RATING5,  "")}</td>
                            <td>${row.RATING7}</td>
                            <td>${f:defaultIfZero(row.RATING1,  "")}</td>
                            <td>${f:defaultIfZero(row.RATING2,  "")}</td>
                            <td>${row.TOTL}</td>
                            <td>${row.RTEXT1}</td>
                            <td class="lastCol">${row.BOSS_NAME}</td>
                        </tr>
                    </c:forEach>
                    <tags:table-row-nodata list="${evalList}" col="12"/>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <table class="listTable">
                    <thead>
                    <tr>
                        <th rowspan=2><spring:message code="MSG.B.B01.0037" /><%--년도--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0038" /><%--소속--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0039" /><%--직급--%></th>
                        <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
						<%--<th rowspan=2><spring:message code="MSG.B.B01.0040" /><!--호칭--></th> --%>
						<th rowspan=2><spring:message code="MSG.APPROVAL.0025" /><%--직책/직급호칭--%></th>
						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                        <th colspan=3><spring:message code="MSG.B.B01.0041" /><%--업무목표달성도--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0042" /><%--난이도<br>/<br>기여도--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0043" /><%--안전<br>환경--%></th>
                        <th colspan=3><spring:message code="MSG.B.B01.0044" /><%--HR Index--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0045" /><%--능력--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0046" /><%--태도--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0047" /><%--절대<br>평가--%></th>
                        <th rowspan=2><spring:message code="MSG.B.B01.0048" /><%--상대화--%></th>
                        <th class="lastCol" rowspan=2><spring:message code="MSG.B.B01.0049" /><%--최종<br>평가자--%></th>
                    </tr>
                    <tr>
                        <th width="30"><spring:message code="MSG.B.B01.0050" /><%--본인--%></th>
                        <th width="30"><spring:message code="MSG.B.B01.0051" /><%--상사--%></th>
                        <th width="40"><spring:message code="MSG.B.B01.0052" /><%--계--%></th>
                        <th width="40"><spring:message code="MSG.B.B01.0053" /><%--조직<br>활성화--%></th>
                        <th width="62"><spring:message code="MSG.B.B01.0054" /><%--HR<br>KPI--%></th>
                        <th width="40"><spring:message code="MSG.B.B01.0055" /><%--계--%></th>
                    </tr>
                    </thead>
                    <tbody>
                        <%--@elvariable id="evalList" type="java.util.Vector<hris.B.B01ValuateDetailData>"--%>
                    <c:forEach var="row" items="${evalList}" varStatus="status">
                        <%-- DB_YEAR와 YEAR1 같을 경우 이전 일 경우만 화면에 표시--%>
                        <c:if test="${row.YEAR1 != DB_YEAR or (row.YEAR1 == DB_YEAR and isBefore) }">
                            <tr class="${f:printOddRow(status.index)}">
                                <c:choose>
                                    <c:when test="${isLink and row.l_FLAG == 'Y'}">
                                        <td><a href="javascript:goLink('${row.YEAR1 }','${row.RTEXT1 }');"><font color="#006699">${row.YEAR1 }</font></a></td>
                                    </c:when>
                                    <c:otherwise>
                                        <td>${row.YEAR1 }</td>
                                    </c:otherwise>
                                </c:choose>
                                <td>&nbsp;${row.ORGTX }</td>
                                <td>${row.TRFGR }</td>
                            	<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start
                            	<td>${row.TITEL}</td>--%>
                            	<td>${row.TITEL eq '책임' and  row.TITL2 ne '' ? row.TITL2 : row.TITEL}</td>
                            	<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                                <td>${f:defaultIfZero(row.RATING4, "")}</td>
                                <td>${f:defaultIfZero(row.RATING5, "") == "" ? "" : row.rating5Value}</td>
                                <td>${row.RATING7 }</td>
                                <td>${f:defaultIfZero(row.RATING6, "")}</td><!--난이도/기여도-->
                                <td>${f:defaultIfZero(row.RATING9, "")}</td><!--안전환경-->
                                <td>${f:defaultIfZero(row.RATING8, "")}</td><!--조직활성화-->
                                <td>${f:defaultIfZero(row.RATING10, "")}
                                    <c:if test="${f:defaultIfZero(row.RATING3, '') != ''}">
                                        <br>(${row.RATING3})
                                    </c:if>
                                </td><!--hrkpi-->
                                <td>${f:defaultIfZero(row.RATING12, "")}</td><!--HR INDEX 계-->
                                <td>${f:defaultIfZero(row.RATING1, "")}
                                    <c:if test="${f:defaultIfZero(row.RATING11, '') != ''}">
                                        <br>(${row.RATING11})
                                    </c:if>
                                </td>
                                <td>${f:defaultIfZero(row.RATING2, "")}</td>
                                <td>${row.TOTL }</td>
                                <td>${row.RTEXT1 }</td>
                                <td class="lastCol">${row.BOSS_NAME }</td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <tags:table-row-nodata list="${evalList}" col="17"/>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

    </div>
</div>

