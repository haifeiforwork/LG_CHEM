<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="detailForm">
<div class="tableArea">
    <h2 class="subtitle">초과근무(OT/특근) 사후신청 상세내역</h2>
    <div class="table">
        <table class="tableGeneral table-layout-fixed">
            <caption>초과근무(OT/특근) 사후신청</caption>
            <colgroup>
                <col class="col_15p" />
                <col class="col_35p" />
                <col class="col_15p" />
                <col class="col_35p" />
            </colgroup>
            <tbody>
                <tr>
                    <th>신청일</th>
                    <td name="BEGDA" format="dateB"></td>
                    <th>결재일</th>
                    <td>${fn:escapeXml( APPR_DATE )}</td>
                </tr>
                <tr>
                    <th>선택일</th>
                    <td name="PICKED_DATE" colspan="3"></td>
                </tr>
            </tbody>
        </table>
        <table class="tableGeneral table-layout-fixed">
            <colgroup>
                <col class="col_15p" />
                <col />
                <col class="worktime-report type-c" />
            </colgroup>
            <tbody>
                <tr>
                    <th>선택일 실근무시간</th>
                    <td colspan="2" class="selected-date-worktime">
                        <table>
                            <colgroup>
                                <col style="width: 80px" />
                                <col style="width:130px" />
                                <col style="width: 80px" />
                                <col style="width:130px" />
                                <col style="width: 80px" />
                                <col style="width:110px" />
                                <col style="width: 80px" />
                                <col style="width:173px" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>정상업무</th>
                                    <td id="CSTDAZ"></td>
                                    <th>업무재개</th>
                                    <td>
                                        <div id="ABEGUZ01" style="display:none"></div>
                                        <div id="ABEGUZ02" style="display:none"></div>
                                        <div id="CAREWK"></div>
                                    </td>
                                    <th>합계</th>
                                    <td id="CTOTAL"></td>
                                    <th>사후신청<br />가능시간</th>
                                    <td id="CRQPST"></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th>시간대 선택</th>
                    <td>
                        <span name="NRFLGG" style="display:none">정상초과</span>
                        <span name="R01FLG" style="display:none">업무재개1</span>
                        <span name="R02FLG" style="display:none">업무재개2</span>
                    </td>
                    <%-- [WorkTime52] 시작 : 지정일자 근무시간현황 --%>
                    <jsp:include page="/WEB-INF/views/pages/work/include/realWorkTimeReportTable.jsp">
                        <jsp:param name="rowspan" value="4" />
                    </jsp:include>
                    <%-- [WorkTime52] 종료 : 지정일자 근무시간현황 --%>
                </tr>
                <tr>
                    <th>신청 초과근무일</th>
                    <td class="tdDate">
                        <span name="WORK_DATE" format="dateB"></span>
                        <input type="checkbox" name="VTKEN" class="checkbox-large" disabled="disabled" /> 前日 근태에 포함
                    </td>
                </tr>
                <tr>
                    <th>신청시간</th>
                    <td>
                        <span name="BEGUZ" format="time"></span> ~ <span name="ENDUZ" format="time"></span> / <span name="STDAZ"></span> 시간
                        <div style="display:none">(휴게/비근무 <span id="CPDABS"></span>)</div>
                    </td>
                </tr>
                <tr>
                    <th class="aot-reason type-c">신청사유</th>
                    <td class="align-top"><span id="OVTM_TEXT"></span> <span name="REASON"></span></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="tableComment display-none consultant-request">
        <p><span class="bold">초과근무 사후신청은 발생 이후 3근무일 이내에 신청 및 결재를 완료하여 주시기 바랍니다.</span></p>
    </div>
</div>
</form>

<%@include file="/WEB-INF/views/tiles/template/javascriptOverTime.jsp"%>
<script type="text/javascript">
$(document).ready(function() {

    $.ajax({
        url : '/appr/getAfterOvertimeDetail.json',
        data : {
            AINF_SEQN: '${fn:escapeXml( AINF_SEQN )}',
            PERNR: '${fn:escapeXml( PERNR )}'
        },
        dataType: 'json',
        type: 'POST'
    }).done(function(response) {
        $.LOGGER.debug('DOM ready', response);

        if (!response.success) {
            alert('상세정보 조회시 오류가 발생하였습니다.\n\n' + response.message);
            return;
        }

        // 사무직-선택근무제 실근무시간 현황
        renderRealWorktimeReport(response.reportData || {});

        // 선택일자 실근무시간
        var worktimeData = response.worktimeData || {};
        renderAfterOvertimeData(worktimeData);

        // 초과근무 사후신청 상세
        var overtimeData = response.overtimeData || {};
        $('td[name="PICKED_DATE"]').text(moment(overtimeData.WORK_DATE).subtract(overtimeData.VTKEN == 'X' ? 1 : 0, 'days').format('YYYY.MM.DD'));
        $('span[name="NRFLGG"]')[overtimeData.ZOVTYP == 'N0' ? 'show' : 'hide']();
        $('span[name="R01FLG"]')[overtimeData.ZOVTYP == 'R1' ? 'show' : 'hide']();
        $('span[name="R02FLG"]')[overtimeData.ZOVTYP == 'R2' ? 'show' : 'hide']();

        if (overtimeData.BEGUZ) overtimeData.BEGUZ = OverTimeUtils.transformTime(overtimeData.BEGUZ);
        if (overtimeData.ENDUZ) overtimeData.ENDUZ = OverTimeUtils.transformTime(overtimeData.ENDUZ);
        overtimeData.STDAZ = OverTimeUtils.getNelim(overtimeData.STDAZ, 2);

        setTableText(overtimeData, 'detailForm');

        if (worktimeData.STDAZ == worktimeData.NRQPST && Number(overtimeData.PUNB1 || 0) > 0) {
            $('span#CPDABS').text(worktimeData.CPDABS).parent().css('display', 'inline');
        }

        var code = overtimeData.OVTM_CODE;
        if (code) {
            var map = {};
            $.each(response.reasonCodeList || [], function(i, o) {
                map[o.SCODE] = o.STEXT;
            });
            $("#OVTM_TEXT").text(map[code] || '');
        }

        // 승인시 결재가능일 및 한도 체크를 위해 상세 data를 화면에 저장, updateAppr function에서 사용
        window.overtimeData = $.map(overtimeData, function(v, k) { return {name: k, value: v}; });
    });
});
</script>