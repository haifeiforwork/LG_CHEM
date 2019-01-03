<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<!-- 근무 입력 현황 테이블 시작 -->
<div class="listArea">
    <div class="listTop">
        <span class="subtitle">월별 근무 입력현황</span>
        <div class="buttonArea float-right" style="margin-top:2px">
            <ul class="btn_mdl">
                <li><a href="#" data-name="excelDownload"><span>엑셀 다운로드</span></a></li>
            </ul>
        </div>
    </div>
    <div class="table">
        <table class="listTable table-layout-fixed worktime traffic-light">
            <colgroup>
                <col style="width: 90px" />
                <col style="width:185px" />
                <col style="width: 90px" />
                <col style="width: 70px" />
                <col />
                <col style="width:110px" />
                <col style="width: 60px" />
                <col style="width: 70px" />
                <col style="width: 70px" />
                <col style="width: 70px" />
                <col style="width: 35px" />
            </colgroup>
            <thead>
                <tr>
                    <th rowspan="3">이름</th>
                    <th rowspan="3">소속</th>
                    <th rowspan="3">직책</th>
                    <th colspan="5">개인입력</th>
                    <th rowspan="3">인정<br />근무시간</th>
                    <th rowspan="3">GAP<br />(개인-인정)</th>
                    <th rowspan="3">상태</th>
                </tr>
                <tr class="multi-line">
                    <th rowspan="2" class="worktime-sum">당월<br />근무시간<br />(연차/보상<br />휴가 포함)</th>
                    <th>월 기본 근무시간</th>
                    <th>법정 최대 한도<br />근무시간</th>
                    <th colspan="2">기타 시간</th>
                </tr>
                <tr>
                    <th>기본 / 잔여</th>
                    <th>기본 / 잔여</th>
                    <th>비근무</th>
                    <th>업무재개</th>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow">
                    <td colspan="11">해당하는 데이타가 존재하지 않습니다.</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 근무 입력 현황 테이블 끝 -->

<!-- 상태 설명 테이블 끝 -->
<div class="tableComment traffic-light">
    <p><span class="bold">상태 설명</span></p>
    <p><span>- 월 기본 근무시간 잔여 평균</span></p>
    <p><span class="icon-green" title="7시간 이상"></span> 7시간 이상</p>
    <p><span class="icon-yellow" title="6시간 이상 7시간 미만"></span> 6시간 이상 7시간 미만</p>
    <p><span class="icon-red" title="6시간 미만"></span> 6시간 미만</p>
</div>
<!-- 상태 설명 테이블 끝 -->

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody data-template>
        <tr class="multi-line">
            <%-- 이름                         --%><td class="ellipsis emp-name" title="%2%"><a href="#" data-pernr="%1%" data-ename="%2%" data-orgeh="@" style="color:blue">%2%</a></td>
            <%-- 소속                         --%><td class="ellipsis org-name" title="%3%">%3%</td>
            <%-- 직책                         --%><td class="ellipsis duty-name" title="%4%">%4%</td>
            <%-- 누적<br />실근무시간         --%><td class="worktime-sum">@</td>
            <%-- 월 기본<br />근무시간        --%><td>@ /<br />@</td>
            <%-- 법정 최대 한도<br />근무시간 --%><td>@ /<br />@</td>
            <%-- 기타 시간                    --%><td>@</td>
            <%-- 기타 시간                    --%><td>@</td>
            <%-- 근무시간                     --%><td>@</td>
            <%-- GAP<br />(개인 - 회사)       --%><td>@</td>
            <%-- 상태                         --%><td>@</td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->