<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무시간 입력
/*   Program ID   : D25WorkTimeSummary.jsp
/*   Description  : 근무시간 입력 상단 공통 근무시간 사용 현황 테이블
/*   Note         : 
/*   Creation     : 2018-05-21 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/
--%><%@ page contentType="text/html; charset=utf-8" %><%
%><div class="buttonArea" style="margin-bottom:5px; height:25px; text-align:left">
    <h2 class="subtitle" style="margin:9px 0 0 0; vertical-align:bottom"><spring:message code="LABEL.D.D25.N1003" /></h2><c:if test="${param.MSSYN ne 'Y'}">
    <ul class="btn_crud" style="position:absolute; top:0; right:0"><c:if test='${E_JKBGB eq "T" or E_JKBGB eq "P"}'>
        <li><a href="javascript:void(0)" class="align-middle" data-name="MSS_OFW_WORK_TIME"><span><spring:message code="BUTTON.D.D25.N0007" /><%-- 근무 입력 현황    --%></span></a></li>
        <li><a href="javascript:void(0)" class="align-middle" data-name="MSS_PT_RWORK_STAT"><span><spring:message code="BUTTON.D.D25.N0008" /><%-- 근무 실적 현황    --%></span></a></li></c:if><c:if test='${E_JKBGB eq "T" or E_JKBGB eq "P" or E_JKBGB eq "O"}'>
        <li><a href="javascript:void(0)" class="align-middle" data-name="ESS_PT_FLEXTIME"  ><span><spring:message code="BUTTON.D.D25.N0009" /><%-- Flextime          --%></span></a></li>
        <li><a href="javascript:void(0)" class="align-middle" data-name="ESS_PT_LEAV_INFO" ><span><spring:message code="BUTTON.D.D25.N0010" /><%-- 휴가 신청         --%></span></a></li></c:if><c:if test='${E_JKBGB eq "P" or E_JKBGB eq "O"}'>
        <li><a href="javascript:void(0)" class="align-middle" data-name="ESS_OPT_OVER_TIME"><span><spring:message code="BUTTON.D.D25.N0011" /><%-- 초과근무 신청     --%></span></a></li>
        <li><a href="javascript:void(0)" class="align-middle" data-name="ESS_OPT_OVTM_AFTR"><span><spring:message code="BUTTON.D.D25.N0012" /><%-- 초과근무 사후신청 --%></span></a></li></c:if>
    </ul></c:if>
</div>

<!-- 근무시간 사용 현황 테이블 시작 -->
<div class="tableArea"${E_TPGUB ne "C" ? "" : " style=\"padding-bottom:20px\""}>
    <div class="table"><c:choose><c:when test='${E_TPGUB ne "C"}'>
        <table class="summary"><!-- 정시/시차 근무제 -->
            <colgroup>
                <col style="width:15%" />
                <col style="width:15%" />
                <col style="width:15%" />
                <col style="width:15%" />
                <col style="width:15%" />
                <col />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2101" /></th><%-- 구분    --%>
                    <th><spring:message code="LABEL.D.D25.N2102" /></th><%-- 오늘    --%>
                    <th><spring:message code="LABEL.D.D25.N2103" /></th><%-- 이번 주 --%>
                    <th><spring:message code="LABEL.D.D25.N2104" /></th><%-- 이번 달 --%>
                    <th><spring:message code="LABEL.D.D25.N2105" /></th><%-- 주 평균 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D25.N2106" /></th><%-- 상태 --%>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2107" /></th><%-- 근무시간 --%>
                    <td data-name="T_WHEAD[0]-CH01">-</td>
                    <td data-name="T_WHEAD[0]-CH02">-</td>
                    <td data-name="T_WHEAD[0]-CH03">-</td>
                    <td data-name="T_WHEAD[0]-CH04">-</td>
                    <td data-name="T_WHEAD[0]-WSTATS" class="lastCol">-</td>
                </tr>
            </tbody>
        </table></c:when><c:otherwise>
        <table class="summary"><!-- 선택 근무제 -->
            <colgroup>
                <col style="width:10%" />
                <col style="width:13%" />
                <col style="width:13%" />
                <col style="width:13%" />
                <col style="width:13%" />
                <col style="width:13%" />
                <col />
            </colgroup>
            <thead>
                <tr class="multi-line">
                    <th><spring:message code="LABEL.D.D25.N2101" /></th><%-- 구분              --%>
                    <th><spring:message code="LABEL.D.D25.N2108" /></th><%-- 누적 실근무시간   --%>
                    <th><spring:message code="LABEL.D.D25.N2109" /></th><%-- 유급휴가 시간     --%>
                    <th class="worktime-sum"><spring:message code="LABEL.D.D25.N2116" /></th><%-- 계                --%>
                    <th><spring:message code="LABEL.D.D25.N2110" /></th><%-- 월 기본 근무시간  --%>
                    <th><spring:message code="LABEL.D.D25.N2111" /></th><%-- 법정 최대한도시간 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D25.N2106" /></th><%-- 상태 --%>
                </tr>
            </thead>
            <tbody>
                <tr class="multi-line">
                    <th><spring:message code="LABEL.D.D25.N2114" /></th><%-- 주중(평일) --%>
                    <td data-name="T_WHEAD[0]-CH01">-</td>
                    <td data-name="T_WHEAD[1]-CH01">-</td>
                    <td data-name="T_WHEAD[1]-CH03" class="worktime-sum">-</td>
                    <td data-name="T_WHEAD[0]-CH02">-</td>
                    <td data-name="T_WHEAD[0]-CH03" rowspan="3">-</td>
                    <td data-name="T_WHEAD[0]-WSTATS" rowspan="3" class="lastCol">-</td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2115" /></th><%-- 주말/휴일 --%>
                    <td data-name="T_WHEAD[0]-CH04">-</td>
                    <td>-</td>
                    <td data-name="T_WHEAD[1]-CH04" class="worktime-sum">-</td>
                    <td>-</td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2116" /></th><%-- 계 --%>
                    <td data-name="T_WHEAD[0]-CH05">-</td>
                    <td data-name="T_WHEAD[1]-CH02">-</td>
                    <td data-name="T_WHEAD[1]-CH05" class="worktime-sum">-</td>
                    <td>-</td>
                </tr>
            </tbody>
        </table>
        <div class="commentOne"><spring:message code="MSG.D.D25.N0042" /></div><%-- 누적실근무시간과 유급휴가시간을 합쳐 기본근무시간을 초과하는 경우, 평일연장근로를 신청하셔야 합니다. --%></c:otherwise></c:choose>
    </div>
</div>
<!-- 근무시간 사용 현황 테이블 끝 -->