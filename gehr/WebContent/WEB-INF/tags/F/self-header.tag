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
                <col width="10%" />
                <col width="20%" />
                <col width="25%" />
                <col width="20%" />
                <col width="25%" />
            </colgroup>
            <tr>
                <td width="140" rowspan="${pageType == 'M' and user.area == 'KR' ? '9' : '8'}" align="center">
                    <img class="idPic" name="photo1" border="0" src="${personData.PHOTO }" width="120" height="140">
                </td>
                <th class="th02"><spring:message code="MSG.A.A01.0005" /><%--사번--%></th>
                <td>${personData.PERNR }</td>

                <th class="th02"><spring:message code="MSG.A.A01.0079" /><%--회사--%></th>
                <td>
                    <c:choose>
                        <c:when test="${user.area == 'KR'}">
                            ${personData.NAME1}
                        </c:when>
                        <c:otherwise>
                            ${personData.BTEXT}
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th class="th02"><spring:message code="MSG.A.A01.0002" /><%--성명--%></th>
                <td>${personData.CNAME1 }</td>
                <th class="th02"><spring:message code="MSG.A.A01.0006" /><%--소속--%></th>
                <td colspan="3">${personData.ORGTX }</td>
            </tr>
            <tr>
                <th class="th02"><spring:message code="MSG.A.A01.0004" /><%--성명(영어)--%></th>
                <td>${personData.CNAME2 }</td>
                <th class="th02"><spring:message code="MSG.A.A01.0018" /><%--근무지--%></th>
                <td>${personData.BTEXT }</td>
            </tr>
            <tr>
                <th class="th02"><spring:message code="MSG.A.A01.0007" /><%--직위--%></th>
                <!-- [CSR ID:3456352]
				<th class="th02"><spring:message code="MSG.A.A01.0007" /><%--직위--%></th>  -->
				<th class="th02"><spring:message code="MSG.A.A01.0083" /><%--직위/직급호칭--%></th>
                  <!-- [CSR ID:3456352] end-->
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
                <td>${personData.VGLST }</td>
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
                    <th class="th02"><spring:message code="MSG.A.A01.0025" /><%--출생지--%></th>
                    <td>${personData.GBORT }</td>
                </tr>
            </c:if>
        </table>
    </div>
</div>
