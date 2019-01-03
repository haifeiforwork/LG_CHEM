<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%
    request.setAttribute("TODAY_TEXT", new SimpleDateFormat("MM.dd").format(Calendar.getInstance().getTime()));
%>
<!-- 근무시간 목록 테이블 시작 -->
<div class="listArea">
    <div class="tableComment notation" style="width:285px">
        <p><span class="prefix">금일( ${TODAY_TEXT} ) 기본 근무시간 :</span> <span data-name="T_WHEAD[2]-CH01"></span></p>
    </div>
    <div class="worktime-entry-deadline">※ 근무시간 입력은 D+<span data-name="T_WHEAD[2]-CH02">0</span> 근무일까지 가능합니다.(비근무는 D+1 근무일)</div>
    <div class="clear"></div>
    <div class="table scroll-table scroll-head">
        <table class="worktime">
            <colgroup>
                <col style="width:12%" />
                <col style="width:10%" />
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width: 9%" />
                <col style="width: 8%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width: 6%" />
                <col style="width: 8%" />
            </colgroup>
            <thead>
                <tr class="multi-line">
                    <th>일자</th>
                    <th>구분</th>
                    <th>업무 시작</th>
                    <th>업무 종료</th>
                    <th>휴게 시간<br />(법정)</th>
                    <th>비근무</th>
                    <th>업무재개</th>
                    <th>초과근무<br />신청여부</th>
                    <th>초과근무<br />실적입력</th>
                    <th>일 근로시간</th>
                </tr>
            </thead>
        </table>
    </div>
    <div class="scroll-table scroll-body">
        <table class="worktime">
            <colgroup>
                <col style="width:12%" />
                <col style="width:10%" />
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width: 9%" />
                <col style="width: 8%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width: 6%" />
                <col style="width: 8%" />
            </colgroup>
            <tbody>
                <tr class="oddRow" data-not-found>
                    <td colspan="10">해당하는 데이타가 존재하지 않습니다.</td>
                </tr>
            </tbody>
        </table>
    </div><c:if test="${param.MSSYN ne 'Y'}">
    <div class="buttonArea" style="margin-top:20px">
        <ul class="btn_crud">
            <li><a href="#" class="darken" data-name="plantimeTablePopup"><span>교육/출장 계획 입력</span></a></li>
            <li><a href="#" class="darken" data-name="worktimeSave"><span>저장</span></a></li>
        </ul>
    </div></c:if>
</div>
<!-- 근무시간 목록 테이블 끝 -->
<c:if test="${param.MSSYN ne 'Y'}">
<div class="tableComment" style="width:100%">
    <p><span class="bold">참고사항</span></p>
    <table>
        <colgroup>
            <col />
            <col />
        </colgroup>
        <tbody>
            <tr>
                <td colspan="2">- 업무시작/종료 시간을 저장한 후, 비근무시간을 입력할 수 있습니다.</td>
            </tr>
            <tr>
                <td>- <span class="bold">업무시작 시간</span></td>
                <td>
                    업무를 시작할 준비가 된 시간으로서 기본적으로 "시업시간=업무시작 시간"입니다.<br />
                    상사 지시·업무 등의 사유로 조기 출근하는 경우 사전에 업무시작 시간 변경이 가능합니다.<br />
                    (1일 단위 Flextime 시간대 변경 필요)
                </td>
            </tr>
            <tr>
                <td>- <span class="bold">업무종료 시간</span></td>
                <td>
                    업무 마무리를 의미하는 시간으로서 기본적으로 "종업시간=업무종료 시간"입니다.<br />
                    종업시간 이후에 업무를 수행하는 경우 업무 마무리 시점에 업무종료 시간을 입력하시면 됩니다.
                </td>
            </tr>
            <tr>
                <td>- <span class="bold">비근무시간</span></td>
                <td>
                    업무시간 내 업무와 무관하게 개인적으로 이용한 시간을 의미하며, 업무 연관성 여부는 구성원 스스로 판단하시면 됩니다.<br />
                    ex) 사내시설 이용(카페·편의점·헬스장 등), 외출(병원·은행·관공서 등), 조·석식 등<br />
                    단, 화장실 이용 및 심리상담·건강상담 등 시간은 비근무 기준에서 제외합니다.<br />
                    비근무 시간이 1회 10분 이상 발생 시 시스템 입력하시면 됩니다. (일 최대 2시간 제한)
                </td>
            </tr>
            <tr>
                <td>- <span class="bold">업무재개 시간</span></td>
                <td>
                    업무종료 이후, 긴급하게 업무를 수행해야 하는 경우 입력하실 수 있습니다.
                </td>
            </tr>
            <tr>
                <td>- <span class="bold">일 근무시간</span></td>
                <td>
                    휴게 시간/비근무 시간 차감 후 업무재개를 더한 당일의 근무시간을 의미합니다.
                </td>
            </tr>
            <tr>
                <td>- <span class="bold">일자 항목 아이콘</span></td>
                <td>
                    <div class="icon done">저장된 일자</div>
                    <div class="icon required">저장안된 현재일</div>
                </td>
            </tr>
        </tbody>
    </table>
</div></c:if>

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="worktimeMSSTemplate">
        <tr data-date="" data-tr-class="" data-pernr="${fn:escapeXml( param.P_PERNR )}">
            <td class="icon icon-class">#text#<%-- 일자 --%></td>
            <td>#text#<%-- 구분 --%></td>
            <td>#text#<%-- 업무 시작 --%></td>
            <td>#text#<%-- 업무 종료 --%></td>
            <td>#text#<%-- 휴게 시간(법정) --%></td>
            <td><%-- 비근무시간 --%>
                <div class="align-center align-middle readonly-look">#text#</div>
                <a href="#" class="icon-popup data-pdunb data-class"><img src="/web-resource/images/ico/ico_magnify.png" alt="조회" /></a>
            </td>
            <td><%-- 업무재개시간 --%>
                <div class="align-center align-middle readonly-look">#text#</div>
                <a href="#" class="icon-popup data-arewk data-class" data-editable=""><img src="/web-resource/images/ico/ico_magnify.png" alt="조회" /></a>
            </td>
            <td>#text#<%-- 초과근무 신청여부 --%></td>
            <td class="btn_crud">#anchor#<%-- 초과근무 실적입력 --%></td>
            <td>#text#<%-- 일 근로시간 --%></td>
        </tr>
    </tbody>
</table>
<table>
    <tbody id="worktimeTemplate">
        <tr data-date="" data-tr-class="">
            <td class="icon icon-class">#text#<%-- 일자 --%></td>
            <td><%-- 구분 --%>
                <select name="WKTYP" style="width:90px" data-disabled="">#type-options#</select>
            </td>
            <td><%-- 업무 시작 --%>
                <div style="min-width:105px">
                    <select name="BEGUZ-hour" class="time" data-beguzhh="" data-sobeghh="" data-disabled="">#hh-options#</select>
                    <label>:</label>
                    <select name="BEGUZ-minute" class="time" data-beguzmm="" data-sobegmm="" data-disabled="">#mm-options#</select>
                </div>
            </td>
            <td><%-- 업무 종료 --%>
                <div style="min-width:105px">
                    <select name="ENDUZ-hour" class="time" data-enduzhh="" data-soendhh="" data-disabled="">#hh-options#</select>
                    <label>:</label>
                    <select name="ENDUZ-minute" class="time" data-enduzmm="" data-soendmm="" data-disabled="">#mm-options#</select>
                </div>
            </td>
            <td>#text#<%-- 휴게 시간(법정) --%></td>
            <td><%-- 비근무시간 --%>
                <input type="text" name="PDUNB" class="align-center readOnly" readonly="readonly" data-value="" />
                <a href="#" class="icon-popup data-pdunb data-class" data-pdunb-editable><img src="/web-resource/images/ico/ico_magnify.png" title="조회" /></a>
            </td>
            <td><%-- 업무재개시간 --%>
                <input type="text" name="AREWK" class="align-center readOnly" readonly="readonly" data-value="" />
                <a href="#" class="icon-popup data-arewk data-class" data-arewk-editable=""><img src="/web-resource/images/ico/ico_magnify.png" title="조회" /></a>
            </td>
            <td>#text#<%-- 초과근무 신청여부 --%></td>
            <td class="btn_crud">#anchor#<%-- 초과근무 실적입력 --%></td>
            <td>#text#<%-- 일 근로시간 --%></td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->