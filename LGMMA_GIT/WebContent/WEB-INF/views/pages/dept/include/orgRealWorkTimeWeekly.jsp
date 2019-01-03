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
        <table class="listTable table-layout-fixed worktime">
            <colgroup>
                <col style="width: 90px" />
                <col style="width:185px" />
                <col style="width: 90px" />
                <col style="width: 90px" />
            </colgroup>
            <thead>
                <tr class="multi-line">
                    <th>이름</th>
                    <th>소속</th>
                    <th>직책</th>
                    <th class="worktime-sum">계</th>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow">
                    <td colspan="4">해당하는 데이타가 존재하지 않습니다.</td><%--  --%>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 근무 입력 현황 테이블 끝 -->

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody data-template>
        <tr>
            <%-- 이름 --%><td class="ellipsis emp-name" title="%2%"><a href="#" data-pernr="%1%" data-ename="%2%" data-orgeh="@" style="color:blue">%2%</a></td>
            <%-- 소속 --%><td class="ellipsis org-name" title="%3%">%3%</td>
            <%-- 직책 --%><td class="ellipsis duty-name" title="%4%">%4%</td>
            <%-- 계   --%><td class="worktime-sum">@</td>
            <%--      --%><td>@</td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->