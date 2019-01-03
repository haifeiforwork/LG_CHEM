<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<td rowspan="${empty param.rowspan ? '4' : fn:escapeXml( param.rowspan )}" class="worktime-report ${fn:escapeXml( STYLE_TPGUB )}${TPGUB_CD ? '' : ' display-none'}">
    <%-- 사무직 실근무시간 현황 table 시작 --%>
    <table class="type-c${GUBUN_TPGUB eq 'C' ? '' : ' Lnodisplay'}">
        <colgroup>
                <col style="width: 50px" />
                <col style="width:150px" />
                <col style="width:120px" />
                <col style="width:160px" />
        </colgroup>
        <thead>
            <tr>
                <th colspan="4">초과근무 신청 가능여부(시간)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th rowspan="2">기준</th>
                <td>기본근무</td>
                <td class="bold"><span id="CBASTM" data-reset="text" data-reset-text="-">-</span></td>
                <td>주중 평일 x 8시간</td>
            </tr>
            <tr>
                <td>법정최대한도</td>
                <td class="bold"><span id="CMAXTM" data-reset="text" data-reset-text="-">-</span></td>
                <td>달력 일수 / 7 x 52시간</td>
            </tr>
            <tr class="multi-line">
                <th rowspan="3">실적</th>
                <td>주중근로<br />(인정 / 개인입력 시간)</td>
                <td class="bold"><span id="CPWDWK" data-reset="text" data-reset-text="- / -">- / -</span></td>
                <td>연차/보상휴가<br />포함 기준</td>
            </tr>
            <tr class="multi-line">
                <td>주말 · 휴일<br />(인정 / 개인입력 시간)</td>
                <td class="bold"><span id="CPWEWK" data-reset="text" data-reset-text="- / -">- / -</span></td>
                <td></td>
            </tr>
            <tr class="multi-line">
                <td>계<br />(인정 / 개인입력 시간)</td>
                <td class="bold"><span id="CSUMPW" data-reset="text" data-reset-text="- / -">- / -</span></td>
                <td>법정최대한도시간<br />초과 불가</td>
            </tr>
        </tbody>
    </table>
    <%-- 사무직 실근무시간 현황 table 종료 --%>

    <%-- 현장직 실근무시간 현황 table 시작 --%>
    <table class="type-d${GUBUN_TPGUB eq 'D' ? '' : ' Lnodisplay'}">
        <colgroup>
            <col style="width: 50px" />
            <col style="width:120px" />
            <col style="width:110px" />
            <col style="width:180px" />
        </colgroup>
        <thead>
            <tr>
                <th colspan="4">실근로시간 현황 <span id="DPERIOD" data-reset="text" data-reset-text="-"></span></th>
            </tr>
        </thead>
        <tbody>
            <tr class="multi-line">
                <th>기준</th>
                <td>법정최대한도<br />(주<span name="AVRWK" class="Lnodisplay"> 평균</span> <span name="WAVTM">-</span>시간)</td>
                <td class="bold"><span id="DBASTM" data-reset="text" data-reset-text="-">-</span><br /><span id="DWKCNT" data-reset="text" data-reset-text="(-)">(-)</span></td>
                <td>매주 <span name="WAVTM">-</span>시간 근로 가정시<br />(총 일수 ÷ 7일 × <span name="WAVTM">-</span>시간)</td>
            </tr>
            <tr class="multi-line">
                <th rowspan="2">실적</th>
                <td>총 근로시간<br />(누적 / 계획)</td>
                <td id="DRWSUM" class="bold" data-reset="text" data-reset-text="- / -">- / -</td>
                <td style="word-break:keep-all">초과근무일 기준 누적근로시간 / 계획근로시간</td>
            </tr>
            <tr class="multi-line">
                <td>1주 근로시간</td>
                <td id="DRWWEK" class="bold" data-reset="text" data-reset-text="-">-</td>
                <td>초과근무일이 속한<br />1주(월 ~ 일)의 근로시간</td>
            </tr>
        </tbody>
    </table>
    <div class="tableComment type-d${GUBUN_TPGUB eq 'D' ? '' : ' Lnodisplay'}">
        <p><span class="bold">실근로시간 산정을 위해 휴게시간 및 비근무를 제외한 기준입니다.</span></p>
        <p><span class="bold${empty param.PERNR ? ' display-none' : ''}">실적의 근로시간은 해당 신청시간은 제외한 시간입니다.</span></p><%-- 결재자 화면에만 표시 --%>
    </div>
    <%-- 현장직 실근무시간 현황 table 종료 --%>
</td>