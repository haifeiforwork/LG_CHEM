<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<div class="tableInquiry">
    <table class="worktime">
        <colgroup>
            <col style="width:100px" />
            <col style="width:350px" />
            <col />
        </colgroup>
        <tbody>
            <tr>
                <th><img class="searchTitle" src="/web-resource/images/top_box_search.gif" /></th>
                <th class="align-left pl10"><label class="bold">조회년월</label>
                    <select id="year" style="width:55px"><option>----</option></select><label>년</label>
                    <select id="month" style="width:40px"><option>--</option></select><label>월</label>
                    <label id="period"></label>
                </th>
                <th class="align-left pl30"><label class="bold">월 전체조회</label>
                    <input type="checkbox" id="I_TOTAL" />
                    <div class="tableBtnSearch"><a class="search" href="#"><span>조회</span></a></div>
                </th>
            </tr>
        </tbody>
    </table>
</div>
<div class="tableComment" style="margin:-35px 0 30px 0">
    <p><span class="prefix">보상휴가 발생내역은 해당 월의 익월부터 조회됩니다. 월 전체조회는 초과근로(시간)이 발생하지 않은 일자를 포함하여 조회합니다.</span></p>
    <p><span class="prefix">평일 연장에 대한 보상휴가는 고정OT 20시간을 제외한 시간기준으로 발생합니다.</span></p>
</div>

<!-- 상단 보상휴가 발생현황 테이블 시작 -->
<div class="tableArea">
    <div class="table">
        <table class="worktime summary">
            <colgroup>
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
            </colgroup>
            <thead>
                <tr class="multi-line">
                    <th>구분</th>
                    <th>휴일근무</th>
                    <th>휴일연장<br />(명절특근 포함)</th>
                    <th>평일연장</th>
                    <th>야간근무</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>초과근무시간</th>
                    <td data-name="T_WHEAD-ZFIELD04">-</td>
                    <td data-name="T_WHEAD-ZFIELD02">-</td>
                    <td data-name="T_WHEAD-ZFIELD01">-</td>
                    <td data-name="T_WHEAD-ZFIELD03">-</td>
                </tr>
                <tr>
                    <th>보상휴가 가산율</th>
                    <td data-name="T_WHEAD-ZFIELD08">-</td>
                    <td data-name="T_WHEAD-ZFIELD06">-</td>
                    <td data-name="T_WHEAD-ZFIELD05">-</td>
                    <td data-name="T_WHEAD-ZFIELD07">-</td>
                </tr>
                <tr>
                    <th>보상휴가 발생시간</th>
                    <td data-name="T_WHEAD-ZFIELD09" colspan="4" class="worktime-sum">-</td>
                </tr>
            </tbody>
        </table>
        <div id="messages" class="tableComment rfc-comment"></div>
    </div>
</div>
<!-- 상단 보상휴가 발생현황 테이블 끝 -->

<!-- 보상휴가 발생내역 테이블 시작 -->
<div class="listArea">
    <div class="table scroll-table scroll-head">
        <table class="listTable worktime">
            <colgroup>
                <col class="col_12p" />
                <col class="col_10p" />
                <col class="col_10p" />
                <col class="col_10p" />
                <col class="col_14p" />
                <col class="col_10p" />
                <col class="col_10p" />
                <col class="col_10p" />
                <col class="col_10p" />
            </colgroup>
            <thead>
                <tr>
                    <th rowspan="2">구분</th>
                    <th rowspan="3">업무구분</th>
                    <th rowspan="3">계획근무시간</th>
                    <th rowspan="3">실근무시간</th>
                    <th rowspan="3">업무재개</th>
                    <th colspan="4">초과근무시간</th>
                </tr>
                <tr class="multi-line">
                    <th>휴일근무</th>
                    <th>휴일연장<br />(명절특근 포함)</th>
                    <th>평일연장</th>
                    <th>야간근무</th>
                </tr>
                <tr>
                    <th>합계</th>
                    <th data-name="T_WORKS-CZHOWK" class="worktime-sum">-</th>
                    <th data-name="T_WORKS-CZHOOT" class="worktime-sum">-</th>
                    <th data-name="T_WORKS-CZNOOT" class="worktime-sum">-</th>
                    <th data-name="T_WORKS-CZNIGT" class="worktime-sum">-</th>
                </tr>
            </thead>
        </table>
    </div>
    <div class="scroll-table scroll-body">
        <table class="listTable worktime">
            <colgroup>
                <col class="col_12p" />
                <col class="col_10p" />
                <col class="col_10p" />
                <col class="col_10p" />
                <col class="col_14p" />
                <col class="col_10p" />
                <col class="col_10p" />
                <col class="col_10p" />
                <col class="col_10p" />
            </colgroup>
            <tbody>
                <tr class="oddRow" data-not-found>
                    <td colspan="9">해당하는 데이타가 존재하지 않습니다.</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 보상휴가 발생내역 테이블 끝 -->

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="comptimeTemplate">
        <tr data-date data-tr-class>
            <td>#text#<%-- 구분 --%></td>
            <td>@비대상기간@<%-- 비대상기간 --%><%-- 업무구분 --%></td>
            <td>#text#<%-- 계획근무시간 --%></td>
            <td>#text#<%-- 실근무시간 --%></td>
            <td><%-- 업무재개시간 --%>
                <div class="align-center align-middle readonly-look">#text#</div>
                <a href="#" class="icon-popup data-class"><img src="/web-resource/images/ico/ico_magnify.png" title="조회" /></a>
            </td>
            <td>#text#<%-- 평일연장 --%></td>
            <td>#text#<%-- 휴일연장 --%></td>
            <td>#text#<%-- 야간근무 --%></td>
            <td>#text#<%-- 휴일근무 --%></td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->