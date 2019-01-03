<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<h2 class="subtitle" style="margin-top:5px">근무시간 사용 현황</h2>
<c:if test="${param.MSSYN ne 'Y'}">
<div class="buttonArea float-right" style="margin-top:2px">
    <ul class="btn_mdl">
        <c:if test='${E_JKBGB eq "T"}'>
        <li><a href="#" class="align-middle" data-name="MSS_OFW_WORK_TIME"><span>근무 입력현황</span></a></li>
        <li><a href="#" class="align-middle" data-name="MSS_PT_RWORK_STAT"><span>근무 실적현황</span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_PT_FLEXTIME"  ><span>Flextime     </span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_PT_LEAV_INFO" ><span>휴가 신청    </span></a></li>
        </c:if>
        <c:if test='${E_JKBGB eq "P"}'>
        <li><a href="#" class="align-middle" data-name="MSS_OFW_WORK_TIME"><span>근무 입력현황    </span></a></li>
        <li><a href="#" class="align-middle" data-name="MSS_PT_RWORK_STAT"><span>근무 실적현황    </span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_PT_FLEXTIME"  ><span>Flextime         </span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_PT_LEAV_INFO" ><span>휴가 신청        </span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_OPT_OVER_TIME"><span>초과근무 신청    </span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_OPT_OVTM_AFTR"><span>초과근무 사후신청</span></a></li>
        </c:if>
        <c:if test='${E_JKBGB eq "O"}'>
        <li><a href="#" class="align-middle" data-name="ESS_PT_FLEXTIME"  ><span>Flextime         </span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_PT_LEAV_INFO" ><span>휴가 신청        </span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_OPT_OVER_TIME"><span>초과근무 신청    </span></a></li>
        <li><a href="#" class="align-middle" data-name="ESS_OPT_OVTM_AFTR"><span>초과근무 사후신청</span></a></li>
        </c:if>
    </ul>
</div>
<div class="clear"></div>
</c:if>
<!-- 근무시간 사용 현황 테이블 시작 -->
<div class="tableArea">
    <c:choose><c:when test='${E_TPGUB ne "C"}'>
    <div class="table">
        <table class="worktime summary"><!-- 정시/시차 근무제 -->
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
                    <th>구분</th>
                    <th>오늘</th>
                    <th>이번 주</th>
                    <th>이번 달</th>
                    <th>주 평균</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>근무시간</th>
                    <td data-name="T_WHEAD[0]-CH01">-</td>
                    <td data-name="T_WHEAD[0]-CH02">-</td>
                    <td data-name="T_WHEAD[0]-CH03">-</td>
                    <td data-name="T_WHEAD[0]-CH04">-</td>
                    <td data-name="T_WHEAD[0]-WSTATS">-</td>
                </tr>
            </tbody>
        </table>
    </div>
    </c:when><c:otherwise>
    <div class="table">
        <table class="worktime summary"><!-- 선택 근무제 -->
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
                    <th>구분</th>
                    <th>누적 실근무 시간</th>
                    <th>연차/보상휴가 시간</th>
                    <th class="worktime-sum">계</th>
                    <th>월 기본근무 시간</th>
                    <th>법정 최대한도 시간</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <tr class="multi-line">
                    <th>주중(평일)</th><%--  --%>
                    <td data-name="T_WHEAD[0]-CH01">-</td>
                    <td data-name="T_WHEAD[1]-CH01">-</td>
                    <td data-name="T_WHEAD[1]-CH03" class="worktime-sum">-</td>
                    <td data-name="T_WHEAD[0]-CH02">-</td>
                    <td data-name="T_WHEAD[0]-CH03" rowspan="3">-</td>
                    <td data-name="T_WHEAD[0]-WSTATS" rowspan="3">-</td>
                </tr>
                <tr>
                    <th>주말/휴일</th>
                    <td data-name="T_WHEAD[0]-CH04">-</td>
                    <td>-</td>
                    <td data-name="T_WHEAD[1]-CH04" class="worktime-sum">-</td>
                    <td>-</td>
                </tr>
                <tr>
                    <th>계</th>
                    <td data-name="T_WHEAD[0]-CH05">-</td>
                    <td data-name="T_WHEAD[1]-CH02">-</td>
                    <td data-name="T_WHEAD[1]-CH05" class="worktime-sum">-</td>
                    <td>-</td>
                </tr>
            </tbody>
        </table>
    </div>
    <c:if test="${param.MSSYN ne 'Y'}">
    <div class="tableComment">
        <p><span class="prefix">누적 실근무 시간과 연차/보상휴가 시간을 합쳐 기본근무 시간을 초과하는 경우, 평일연장근로를 신청하셔야 합니다.</span></p>
    </div>
    </c:if>
    </c:otherwise></c:choose>
</div>
<!-- 근무시간 사용 현황 테이블 끝 -->