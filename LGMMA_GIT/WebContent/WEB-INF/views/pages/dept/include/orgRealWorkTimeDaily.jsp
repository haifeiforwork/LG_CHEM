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
    <div class="table" style="position:relative">
        <div class="date-spread frozen" style="left:0; width:415px">
            <table class="listTable table-layout-fixed worktime">
                <colgroup>
                    <col style="width: 90px" />
                    <col style="width:185px" />
                    <col style="width: 90px" />
                    <col style="width: 50px" />
                </colgroup>
                <thead>
                    <tr class="multi-line">
                        <th>이름</th>
                        <th>소속</th>
                        <th>직책</th>
                        <th class="worktime-sum">계</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        <div class="date-spread scroll" style="left:415px; width:620px">
            <table class="listTable table-layout-fixed worktime">
                <colgroup>
                    <col />
                </colgroup>
                <thead>
                    <tr class="multi-line">
                        <th class="border-left">일자<br />요일</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        <div class="date-spread not-found-data">해당하는 데이타가 존재하지 않습니다.</div>
    </div>
</div>
<!-- 근무 입력 현황 테이블 끝 -->