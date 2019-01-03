<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<!-- 근무시간 달력 테이블 시작 -->
<div class="tableArea">
    <div class="table">
        <table class="worktime worktime-calendar">
            <colgroup>
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
            </colgroup>
            <thead>
                <tr>
                    <th class="isoweek">주</th>
                    <th class="weekday">월</th>
                    <th class="weekday">화</th>
                    <th class="weekday">수</th>
                    <th class="weekday">목</th>
                    <th class="weekday">금</th>
                    <th class="weekend">토</th>
                    <th class="weekend">일</th>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow" data-not-found>
                    <td colspan="8">해당하는 데이타가 존재하지 않습니다.</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 근무시간 달력 테이블 종료 -->

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="calendarTemplate">
        <tr>
            <td class="isoweek" data-week="%"><div class="positioning"><div class="week-number">W%</div>#</div></td>
            <td class="weekday data-color" data-date="#"><div class="positioning"><div class="date-number">#</div>#</div></td>
            <td class="weekday data-color" data-date="#"><div class="positioning"><div class="date-number">#</div>#</div></td>
            <td class="weekday data-color" data-date="#"><div class="positioning"><div class="date-number">#</div>#</div></td>
            <td class="weekday data-color" data-date="#"><div class="positioning"><div class="date-number">#</div>#</div></td>
            <td class="weekday data-color" data-date="#"><div class="positioning"><div class="date-number">#</div>#</div></td>
            <td class="weekend data-color" data-date="#"><div class="positioning"><div class="date-number">#</div>#</div></td>
            <td class="weekend data-color" data-date="#"><div class="positioning"><div class="date-number">#</div>#</div></td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->