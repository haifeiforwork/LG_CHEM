<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="language" tagdir="/WEB-INF/tags/C/C05" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>

<%--@elvariable id="g" type="com.common.Global"--%>
<div class="title"><h1><spring:message code="MSG.C.C05.0001" /><%--외국어능력 조회--%></h1><!-- C20140204_80557 어학 을  외국어로 변경--></div>

<c:if test="${empty langList}">

    <h2 class="subtitle"><spring:message code="TITLE.C.C05.0001" /><%--TOEIC--%></h2> <!-- 0001 -->

    <!--TOEIC 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <thead>
                <tr>
                    <th><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                    <th><spring:message code="MSG.C.C05.0007" /><%--L/C--%></th>
                    <th><spring:message code="MSG.C.C05.0008" /><%--R/C--%></th>
                    <th class="lastCol"><spring:message code="MSG.C.C05.0009" /><%--TOTAL--%></th>
                </tr>
                </thead>
                <tr>
                    <td class="lastCol align_center" colspan="4"><spring:message code="MSG.COMMON.0004"/><%--해당하는 데이터가 존재하지 않습니다.--%></td>
                </tr>
            </table>
        </div>
    </div>

</c:if>


<%--@elvariable id="langMap" type="java.util.Map<String, java.util.List<hris.C.C05FtestResult1Data>>"--%>
<c:forEach var="lang" items="${langMap}">
    <c:choose>
        <c:when test="${lang.key == '0001'}">
            <!--------------------------------------- TOEIC 시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0001" /><%--TOEIC--%></h2> <!-- 0001 -->
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th><spring:message code="MSG.C.C05.0007" /><%--L/C--%></th>
                            <th><spring:message code="MSG.C.C05.0008" /><%--R/C--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0009" /><%--TOTAL--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                        <tr class="${f:printOddRow(status.index)}">
                            <td>${f:printDate(row.BEGDA)}</td>
                            <td>${row.LISN_SCOR}</td>
                            <td>${row.READ_SCOR}</td>
                            <td class="lastCol">
                                <font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.TOTL_SCOR}</font>
                            </td>
                        </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--TOEIC 리스트 테이블 끝-->
        </c:when>

        <c:when test="${lang.key == '0002'}">
            <!--------------------------------------- JPT 시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0002" /><%--JPT--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th><spring:message code="MSG.C.C05.0007" /><%--L/C--%></th>
                            <th><spring:message code="MSG.C.C05.0008" /><%--R/C--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0009" /><%--TOTAL--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td>${row.LISN_SCOR}</td>
                                <td>${row.READ_SCOR}</td>
                                <td class="lastCol">
                                    <font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.TOTL_SCOR}</font>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--JPT 리스트 테이블 끝-->
        </c:when>


        <c:when test="${lang.key == '0003'}">
            <!--------------------------------------- TOEFL 시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0003" /><%--TOEFL--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th><spring:message code="MSG.C.C05.0007" /><%--L/C--%></th>
                            <th><spring:message code="MSG.C.C05.0010" /><%--Structure--%></th>
                            <th><spring:message code="MSG.C.C05.0008" /><%--R/C--%></th>
                            <th><spring:message code="MSG.C.C05.0011" /><%--Writing--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0009" /><%--TOTAL--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td>${row.LISN_SCOR}</td>
                                <td>${row.STRU_SCOR}</td>
                                <td>${row.READ_SCOR}</td>
                                <td>${row.WRIT_SCOR}</td>
                                <td class="lastCol">
                                    <font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.TOTL_SCOR}</font>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--TOEFL 리스트 테이블 끝-->
        </c:when>

        <c:when test="${lang.key == '0004'}">
            <!--------------------------------------- 한어수평고시 시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0004" /><%--한어수평고시--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th><spring:message code="MSG.C.C05.0012" /><%--청력--%></th>
                            <th><spring:message code="MSG.C.C05.0013" /><%--어법--%></th>
                            <th><spring:message code="MSG.C.C05.0014" /><%--독해--%></th>
                            <th><spring:message code="MSG.C.C05.0015" /><%--종합--%></th>
                            <th><spring:message code="MSG.C.C05.0016" /><%--작문--%></th>
                            <th><spring:message code="MSG.C.C05.0017" /><%--구술--%></th>
                            <th><spring:message code="MSG.C.C05.0009" /><%--TOTAL--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0018" /><%--등급--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td>${row.HEAR_SCOR}</td>
                                <td>${row.EXPR_SCOR}</td>
                                <td>${row.UNDR_SCOR}</td>
                                <td>${row.SUMM_SCOR}</td>

                                <td>${row.COMP_SCOR}</td>
                                <td>${row.ORAL_SCOR}</td>
                                <td>${row.TOTL_SCOR}</td>
                                <td class="lastCol">
                                    <font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.LANG_LEVL}</font>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--한어수평고시 리스트 테이블 끝-->
        </c:when>

        <c:when test="${lang.key == '0005'}">
            <!--------------------------------------- LGA-LAP Oral Test 시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0005" /><%--LGA-LAP Oral Test--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th width="150"><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0019" /><%--Oral Score--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td class="lastCol">
                                    ${row.STEXT}
                                    (<font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.LGAX_SCOR}</font>)
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--LGA-LAP Oral Test 리스트 테이블 끝-->
        </c:when>

        <c:when test="${lang.key == '0006'}">
            <!--------------------------------------- LGA-LAP Written  시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0006" /><%--LGA-LAP Written--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th width="150"><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0020" /><%--Written Score--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td class="lastCol">${row.STEXT}
                                    (<font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.LAPX_SCOR}</font>)
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--LGA-LAP Written 테이블 끝-->
        </c:when>

        <c:when test="${lang.key == '0007'}">
            <!--------------------------------------- SEPT 시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0007" /><%--SEPT--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th width="150"><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th><spring:message code="MSG.C.C05.0021" /><%--Weighted Score--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0022" /><%--레벨--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td>${row.SEPT_SCOR}</td>
                                <td class="lastCol">${row.STEXT}
                                    (<font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.SEPT_LEVL}</font>)
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--SEPT 테이블 끝-->
        </c:when>

        <c:when test="${lang.key == '0008'}">
            <!--------------------------------------- @v1.1 TEPS 시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0008" /><%--TEPS--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th width="150" rowspan="2"><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th colspan="2"><spring:message code="MSG.C.C05.0023" /><%--청해--%></th>
                            <th colspan="2"><spring:message code="MSG.C.C05.0024" /><%--문법--%></th>
                            <th colspan="2"><spring:message code="MSG.C.C05.0025" /><%--어휘--%></th>
                            <th colspan="2"><spring:message code="MSG.C.C05.0014" /><%--독해--%></th>
                            <th class="lastCol" colspan="2"><spring:message code="MSG.C.C05.0026" /><%--총점--%></th>
                        </tr>
                        </thead>
                        <tr>
                            <th><spring:message code="MSG.C.C05.0027" /><%--점수--%></th>
                            <th><spring:message code="MSG.C.C05.0018" /><%--등급--%></th>
                            <th><spring:message code="MSG.C.C05.0027" /><%--점수--%></th>
                            <th><spring:message code="MSG.C.C05.0018" /><%--등급--%></th>
                            <th><spring:message code="MSG.C.C05.0027" /><%--점수--%></th>
                            <th><spring:message code="MSG.C.C05.0018" /><%--등급--%></th>
                            <th><spring:message code="MSG.C.C05.0027" /><%--점수--%></th>
                            <th><spring:message code="MSG.C.C05.0018" /><%--등급--%></th>
                            <th><spring:message code="MSG.C.C05.0027" /><%--점수--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0018" /><%--등급--%></th>
                        </tr>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td>${f:parseLong(row.TEPS_SCOR1)}</td>
                                <td>${row.TEPS_LEVL1}</td>
                                <td>${f:parseLong(row.TEPS_SCOR2)}</td>
                                <td>${row.TEPS_LEVL2}</td>
                                <td>${f:parseLong(row.TEPS_SCOR3)}</td>
                                <td>${row.TEPS_LEVL3}</td>
                                <td>${f:parseLong(row.TEPS_SCOR4)}</td>
                                <td>${row.TEPS_LEVL4}</td>
                                <td><font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.TEPS_AMNT}</font></td>
                                <td class="lastCol">${row.TEPS_LEVL}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--@v1.1 TEPS 테이블 끝-->
        </c:when>

        <c:when test="${lang.key == '0009'}">
            <!--------------------------------------- 신 HSK -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0009" /><%--신HSK--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th width="150"><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th><spring:message code="MSG.C.C05.0028" /><%--듣기--%></th>
                            <th><spring:message code="MSG.C.C05.0014" /><%--독해--%></th>
                            <th><spring:message code="MSG.C.C05.0029" /><%--쓰기--%></th>
                            <th><spring:message code="MSG.C.C05.0026" /><%--총점--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0018" /><%--등급--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td>${f:parseLong(row.HEAR_SCOR)}</td>
                                <td>${f:parseLong(row.UNDR_SCOR)}</td>
                                <td>${f:parseLong(row.COMP_SCOR)}</td>
                                <td><font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.TOTL_SCOR}</font></td>
                                <td class="lastCol">${f:parseLong(row.LANG_LEVL)}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--신 HSK 끝-->
        </c:when>

        <c:when test="${lang.key == '0010'}">
        <!--------------------------------------- TOEIC Speaking -------------------------------------->
        <h2 class="subtitle"><spring:message code="TITLE.C.C05.0010" /><%--TOEIC Speaking--%></h2>
        <div class="listArea">
            <div class="table">
                <table class="listTable">
                    <thead>
                    <tr>
                        <th width="150"><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                        <th><spring:message code="MSG.C.C05.0031" /><%--SPEAKING--%></th>
                        <th><spring:message code="MSG.C.C05.0032" /><%--SPEAKING LEVEL--%></th>
                        <th><spring:message code="MSG.C.C05.0033" /><%--WRITING--%></th>
                        <th class="lastCol">W<spring:message code="MSG.C.C05.0034" /><%--RITING LEVEL--%></th>
                    </tr>
                    </thead>
                    <c:forEach var="row" items="${lang.value}" varStatus="status">
                        <tr class="${f:printOddRow(status.index)}">
                            <td>${f:printDate(row.BEGDA)}</td>
                            <td><font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.SPEA_SCOR}</font></td>
                            <td><font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.SPEA_LEVL}</font></td>
                            <td><font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.WRIT_SCOR1}</font></td>
                            <td class="lastCol"><font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.WRIT_LEVL}</font></td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
        <!--TOEIC Speaking 끝-->
        </c:when>

        <c:when test="${lang.key == '0011'}">
            <!--------------------------------------- C20131202_46202 OPIc  시작 -------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0011" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="OPIC_TEXT"/>
            <!--OPIc 끝-->
        </c:when>

        <c:when test="${lang.key == '0012'}">
            <!--------------------------------------- JLPT  시작 -------------------------------------->
            <h2 class="subtitle"><spring:message code="TITLE.C.C05.0012" /><%--JLPT--%></h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <thead>
                        <tr>
                            <th width="150"><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
                            <th><spring:message code="MSG.C.C05.0035" /><%--Level--%></th>
                            <th><spring:message code="MSG.C.C05.0036" /><%--언어지식--%></th>
                            <th><spring:message code="MSG.C.C05.0014" /><%--독해--%></th>
                            <th><spring:message code="MSG.C.C05.0023" /><%--청해--%></th>
                            <th class="lastCol"><spring:message code="MSG.C.C05.0009" /><%--TOTAL--%></th>
                        </tr>
                        </thead>
                        <c:forEach var="row" items="${lang.value}" varStatus="status">
                            <tr class="${f:printOddRow(status.index)}">
                                <td>${f:printDate(row.BEGDA)}</td>
                                <td>${row.JLPT_LEVL}</td>
                                <td>${row.LANG_SCOR}</td>
                                <td>${row.READ_SCOR1}</td>
                                <td>${row.LISN_SCOR1}</td>
                                <td class="lastCol">
                                    <font color="${row.LAST_FLAG == 'Y' ? '#CC3300': '#000000'}">${row.TOTL_SCOR}</font>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!--JLPT 끝-->
        </c:when>

        <c:when test="${lang.key == '0013'}">
            <!--------------------------------------- [CSR ID:2981372] TSC  시작 -------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0013" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="TSC_TEXT"/>
            <!--[CSR ID:2981372] TSC 끝-->
        </c:when>

        <c:when test="${lang.key == '0014'}">
            <!---------------------------------------[CSR ID:2981372] SJPT(일본어) 0014--------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0014" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="SJPT_TEXT"/>
            <!--SJPT 끝-->
        </c:when>

        <c:when test="${lang.key == '0015'}">
            <!---------------------------------------ZD(독어) --------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0015" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="ZD_TEXT"/>
            <!--ZD(독어) 끝-->
        </c:when>


        <c:when test="${lang.key == '0016'}">
            <!---------------------------------------DALF(프랑스어) --------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0016" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="DALF_TEXT"/>
            <!--DALF(프랑스어) 끝-->
        </c:when>


        <c:when test="${lang.key == '0017'}">
            <!---------------------------------------DELF(프랑스어) --------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0017" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="DELF_TEXT"/>
            <!--DELF(프랑스어) 끝-->
        </c:when>

        <c:when test="${lang.key == '0018'}">
            <!---------------------------------------DELE(스페인어) --------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0018" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="DELE_TEXT"/>
            <!--DELF(프랑스어) 끝-->
        </c:when>

        <c:when test="${lang.key == '0019'}">
            <!---------------------------------------CELPE-BRAS(포르투칼어) --------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0019" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="CELPE_TEXT"/>
            <!--CELPE-BRAS(포르투칼어) 끝-->
        </c:when>

        <c:when test="${lang.key == '0020'}">
            <!---------------------------------------TORFL(러시아어) --------------------------------------->
            <language:language-layout-others title="TITLE.C.C05.0020" rows="${lang.value}" colTitle="MSG.C.C05.0018" colName="TORFL_TEXT"/>
        </c:when>

    </c:choose>
</c:forEach>

