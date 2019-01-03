<%/******************************************************************************/
/*                                                                              */
/*   System Name  : tag                                                         */
/*   1Depth Name  : tag                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 헤더 용 tag                                    */
/*   Program ID   : self-header.tag                                       */
/*   Description  : 인사기록부 헤더 조회                                             */
/*   Note         : 없음                                                        */
/*   Creation     :                                           */
/*   Update       : 2017-07-10 [CSR ID:3428773] 인사기록부 수정 요청                               */
/*   Update       :  2017/07/13 eunha   [CSR ID:3475164] 인사기록부 수정 요청                          */
/*                      */
/*                      */
/*                              */
/********************************************************************************/%>
<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="personData" required="true" type="hris.A.A01SelfDetailData" %>
<%@ attribute name="pageType" type="java.lang.String" %>

<%--<c:set var="isMasking" value="${pageType == 'M'}" />--%>

<div class="tableArea">
    <!-- 개인 인적사항 조회 -->
    <div class="table">
        <table border="0" cellspacing="0" cellpadding="0" class="tableGeneral">
            <colgroup>
                <col width="140" />
                <col width="18%" />
                <col width="25%" />
                <col width="18%" />
                <col width="25%" />
            </colgroup>
            <tr>
                <c:set var="rowspan" value="11" />
                <c:choose>
                    <c:when test="${user.area == 'US'}">
                        <c:set var="rowspan" value="9" />
                    </c:when>
                    <c:when test="${user.area == 'CN'}">
                        <c:set var="rowspan" value="12" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="rowspan" value="10" />
                    </c:otherwise>
                </c:choose>

                <td width="140" rowspan="${rowspan}" align="center">
                    <img class="idPic" name="photo1" border="0" src="${personData.PHOTO }" width="120" height="140">
                </td>
                <th class="th02"><spring:message code="MSG.A.A01.0079" /><%--회사--%>&nbsp;/&nbsp;<spring:message code="MSG.A.A01.0006" /><%--소속--%></th>
                <td colspan="3">
                    <c:choose>
                        <c:when test="${user.area == 'KR'}">
                            ${personData.BUTXT}
                        </c:when>
                        <c:otherwise>
                            ${personData.NAME1}
                        </c:otherwise>
                    </c:choose>
                    &nbsp;/&nbsp;
                    ${personData.ORGTX }
                </td>
            </tr>
            <tr>
                <th class="th02"><spring:message code="MSG.A.A01.0002" /><%--성명--%></th>
                <td>${personData.CNAME1 }</td>
                <th class="th02"><spring:message code="MSG.A.A01.0005" /><%--사번--%></th>
                <td>${personData.PERNR }</td>

            </tr>
            <tr>
                <th class="th02"><spring:message code="MSG.A.A01.0004" /><%--성명(영어)--%></th>
                <td>${personData.CNAME2 }</td>
                <th class="th02"><spring:message code="MSG.A.A01.0018" /><%--근무지--%></th>
                <td>${personData.BTEXT }</td>
            </tr>
            <tr>
                <!-- [CSR ID:3428773][CSR ID:3456352]
				<th class="th02"><spring:message code="MSG.A.A01.0007" /><%--직위--%></th>  -->
				   <th class="th02"><spring:message code="MSG.A.A01.0083" /><%--직위/직급호칭--%></th>
                  <!-- [CSR ID:3428773] end-->
                <td>${personData.JIKWT }</td>
                <th class="th02"><spring:message code="MSG.A.A01.0011" /><%--그룹입사일--%></th>
                <td>${f:printDate(personData.DAT01)}</td>
            </tr>
            <tr>
                <th class="th02">
                    <c:choose>
                        <c:when test="${user.e_persk == '11' or user.e_persk == '12' or user.e_persk == '13'}">
                            <spring:message code="MSG.A.A01.0020" /><%--직급--%>
                        </c:when>
                        <c:when test="${user.e_persk == '21' or user.e_persk == '22' }">
                            <spring:message code="MSG.A.A01.0021" /><%--직급/년차--%>
                        </c:when>
                        <c:otherwise>
                            <spring:message code="MSG.A.A01.0019" /><%--급호--%>
                        </c:otherwise>
                    </c:choose>
                </th>

                <%-- 2017/07/13 eunha   [CSR ID:3475164] 인사기록부 수정 요청  start
                   <td>${personData.VGLST}</td>--%>

                   <td  id = "VGLST" >
                   <c:choose>
                   <c:when test="${user.e_persk == '11' or user.e_persk == '12' or user.e_persk == '13' or  user.e_persk == '21' or user.e_persk == '22'}">
                   ${personData.VGLST}
                   </c:when>
                   <c:otherwise>
                   <c:if test="${O_CHECK_FLAG != 'N'}">${personData.VGLST}</c:if>
                   </c:otherwise>
                   </c:choose>
                   </td>

                <%-- 2017/07/13 eunha   [CSR ID:3475164] 인사기록부 수정 요청  end   --%>
                <th class="th02"><spring:message code="MSG.A.A01.0014" /><%--자사입사일--%></th>
                <td>${f:printDate(personData.DAT02)}</td>
            </tr>
            <tr>
                <th class="th02"><spring:message code="MSG.A.A01.0016" /><%--직책--%></th>
                <td>${personData.JIKKT }</td>
                <th class="th02"><spring:message code="MSG.A.A01.0017" /><%--현직위승진--%></th>
                <td>${f:printDate(personData.DAT03)}</td>
            </tr>
            <tr>
                <th class="th02"><spring:message code="MSG.A.A01.0013" /><%--직무--%></th>
                <td>${personData.STLTX }</td>
                <th class="th02"><spring:message code="MSG.A.A01.0022" /><%--근속기준일--%></th>
                <td>${f:printDate(personData.DAT04)}</td>
            </tr>

            <c:choose>
                <c:when test="${user.area == 'KR'}">
                    <tr>
                        <th class="th02"><spring:message code="MSG.A.A01.0010" /><%--신분--%></th>
                        <td>${personData.PKTXT }</td>
                        <th class="th02"><spring:message code="MSG.A.A01.0012" /><%--입사구분--%></th>
                        <td>${personData.MGTXT }</td>
                    </tr>
                    <tr>
                        <th class="th02"><spring:message code="MSG.A.A01.0078" /><%--신분구분--%></th>
                        <td>${personData.PGTXT}</td>
                        <th class="th02"><spring:message code="MSG.A.A01.0015" /><%--입사시학력--%></th>
                        <td>${personData.SLABS }</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <tr>
                        <th class="th02"><spring:message code="MSG.A.A01.0010" /><%--신분--%></th>
                        <td>${personData.PKTXT }</td>
                        <th class="th02"><spring:message code="MSG.A.A01.0078" /><%--신분구분--%></th>
                        <td>${personData.PGTXT}</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            <c:if test="${user.area != 'US'}">
                <tr>
                    <th class="th02"><spring:message code="MSG.A.A01.0026" /><%--생년월일--%></th>
                    <td>${f:printDate(personData.GBDAT)} (<spring:message code="MSG.A.A01.0080" arguments="${personData.AGECN}"/>) </td>
                    <th class="th02"><spring:message code="LABEL.A.A12.0009" /><%--국적--%></th>
                    <td>${personData.LANDX }</td>
                </tr>
            </c:if>

            <c:if test="${user.area == 'CN'}">
                <%--<tr>
                    <th class="th02"><spring:message code="MSG.A.A01.0032" />&lt;%&ndash;민족&ndash;%&gt;</th>
                    <td>${personData.LTEXT}</td>
                    <th class="th02"><spring:message code="MSG.A.A01.0033" />&lt;%&ndash;정치성향&ndash;%&gt;</th>
                    <td>${personData.PTEXT }</td>
                </tr>--%>
                <tr>
                    <th class="th02"><spring:message code="MSG.A.A01.0034" /><%--계약만료일--%></th>
                    <td>${personData.CTEDTX}</td>
                    <th class="th02"><spring:message code="MSG.A.A01.0025" /><%--출생지--%> / <spring:message code="MSG.A.A01.0032" /><%--민족--%></th>
                    <td>${personData.GBORT } / ${personData.LTEXT}</td>
                </tr>
            </c:if>
        </table>
    </div>
</div>
