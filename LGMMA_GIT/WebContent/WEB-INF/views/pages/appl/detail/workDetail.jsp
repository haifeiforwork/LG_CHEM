<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D01OT.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="com.sns.jdf.util.DateTime" %>
<%@ page import="com.sns.jdf.util.CodeEntity" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    WebUserData user = (WebUserData) session.getValue("user");
    Vector D03VocationAReason_vt = new D03VocationAReasonRFC().getSubtyCode(user.empNo, "2005" , DateTime.getShortDateString());
    Vector options = new Vector();
    for (int j = 0; j < D03VocationAReason_vt.size(); j++) {
        D03VocationReasonData option = (D03VocationReasonData) D03VocationAReason_vt.get(j);
        options.addElement(new CodeEntity(option.SCODE, option.STEXT));
    }
    String E_RRDAT = new GetTimmoRFC().GetTimmo(user.companyCode);
    long   D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT,"."));
%>
<form id="detailForm">
<input type="hidden" name="AINF_SEQN" id="AINF_SEQN" />
<input type="hidden" name="inputFlag" id="inputFlag" />
<input type="hidden" name="work_time" id="work_time" />

<div class="tableArea">
    <h2 class="subtitle">초과근무(OT/특근) 신청 상세내역</h2>
    <div class="table">
        <table class="tableGeneral table-layout-fixed" id="otFormTable">
        <caption>초과근무(OT/특근) 신청</caption>
        <colgroup>
            <col class="col_15p" />
            <col />
            <c:if test="${TPGUB_CD}"><col /></c:if>
        </colgroup>
        <tbody>
        <tr>
            <th><label>신청일</label></th>
            <td class="tdDate">
                <input type="text" name="BEGDA" id="BEGDA" class="align-center" readonly />
            </td>
            <%-- [WorkTime52] 시작 : 지정일자 근무시간현황 --%>
            <jsp:include page="/WEB-INF/views/pages/work/include/realWorkTimeReportTable.jsp" />
            <%-- [WorkTime52] 종료 : 지정일자 근무시간현황 --%>
        </tr>
        <tr>
            <th><span class="textPink">*</span><label>초과근무일</label></th>
            <td class="tdDate">
                <input type="text" name="WORK_DATE" id="WORK_DATE" class="datepicker align-center" readonly />
                <label><input type="checkbox" name="VTKEN" class="checkbox-large" id="VTKEN" disabled="disabled" /> 前日 근태에 포함</label>
                <div style="margin-top:4px; color:blue; display:none" id="VTKENComment">
                    * '前日 근태에 포함' 체크는 새벽에 비상 호출 등의 근무가 발생하여 전날 근무와 연속적인 근무가 발생할 경우만 체크해야 함
                </div>
            </td>
        </tr>
        <tr>
            <th><span class="textPink">*</span><label>신청시간</label></th>
            <td>
                <select class="w50" name="BEGUZSTDT" id="BEGUZSTDT" vname="신청시간" required="required"${GUBUN_TPGUB eq 'C' and empty GUBUN_WORK ? ' data-limit="9" data-limit-target="ENDUZSTDT"' : ''}>
                    <option value="">--</option>
                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                    <option value="${hour}">${hour}</option>
                    </c:forEach>
                </select>
                :
                <select class="w50" name="BEGUZEDDT" id="BEGUZEDDT" vname="신청시간" required="required"${GUBUN_TPGUB eq 'C' ? ' data-mimic' : ''}>
                    <option value="">--</option>
                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                    <option value="${minute}">${minute}</option>
                    </c:forEach>
                </select>
                    ~
                <select class="w50" name="ENDUZSTDT" id="ENDUZSTDT" vname="신청시간" required="required">
                    <option value="">--</option>
                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                    <option value="${hour}">${hour}</option>
                    </c:forEach>
                </select>
                :
                <select class="w50" name="ENDUZEDDT" id="ENDUZEDDT" vname="신청시간" required="required"${GUBUN_TPGUB eq 'C' ? ' data-mimic' : ''}>
                    <option value="">--</option>
                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                    <option value="${minute}">${minute}</option>
                    </c:forEach>
                </select>
                <span class="pl10"><input class="w60 align-right" type="text" name="STDAZ" id="STDAZ" readonly /> 시간</span>
            </td>
        </tr>
        <tr>
            <th><span class="textPink">*</span><label>신청사유</label></th>
            <td class="align-top">
                <select id="OVTM_CODE" name="OVTM_CODE" vname="신청사유" required="required" readonly>
                <option value="">-------------</option>
                <%= WebUtil.printOption(options) %>
                </select>
                <input type="text" name="REASON" id="REASON" placeholder="신청사유 입력" class="ot-reason" />
                <div class="bottom-filler ${TPGUB_CD ? fn:escapeXml( STYLE_TPGUB ) : ''} tall"></div>
            </td>
        </tr>
        </tbody>
        </table>
    </div>
</div>
<!--// Table end -->

<!-- Table start -->
<div class="listArea">
    <h2 class="subtitle">선택사항</h2>
    <div class="table">
        <table class="listTable borderBottom">
        <caption>휴게시간 작성</caption>
        <colgroup>
            <col class="col_16p"/>
            <col class="col_24p"/>
            <col class="col_24p"/>
            <col class="col_18p"/>
            <col class="col_18p"/>
        </colgroup>
        <thead>
        <tr>
            <th></th>
            <th class="thAlignCenter">시작시간</th>
            <th class="thAlignCenter">종료시간</th>
            <th class="thAlignCenter">무급</th>
            <th class="thAlignCenter tdBorder">유급</th>
        </tr>
        </thead>
        <tbody>
        <c:choose><c:when test="${GUBUN_TPGUB eq 'C'}">
        <tr>
            <th>휴게시간 1</th>
            <td>
                <input type="text" name="PBEG1STDT" id="PBEG1STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
                <input type="text" name="PBEG1EDDT" id="PBEG1EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
            </td>
            <td>
                <input type="text" name="PEND1STDT" id="PEND1STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
                <input type="text" name="PEND1EDDT" id="PEND1EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
            </td>
            <td><input type="text" name="PUNB1" id="PUNB1" class="span-look align-center" readonly="readonly" /></td>
            <td class="tdBorder"><input type="text" name="PBEZ1" id="PBEZ1" class="span-look align-center" readonly="readonly" /></td>
        </tr>
        <tr>
            <th>휴게시간 2</th>
            <td>
                <input type="text" name="PBEG2STDT" id="PBEG2STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
                <input type="text" name="PBEG2EDDT" id="PBEG2EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
            </td>
            <td>
                <input type="text" name="PEND2STDT" id="PEND2STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
                <input type="text" name="PEND2EDDT" id="PEND2EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
            </td>
            <td><input type="text" name="PUNB2" id="PUNB2" class="span-look align-center" readonly="readonly" /></td>
            <td class="tdBorder"><input type="text" name="PBEZ2" id="PBEZ2" class="span-look align-center" readonly="readonly" /></td>
        </tr>
        </c:when><c:otherwise>
        <tr>
            <th>휴게시간 1</th>
            <td>
                 <select class="w50" name="PBEG1STDT" id="PBEG1STDT">
                    <option value="">--</option>
                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                    <option value="${hour}">${hour}</option>
                    </c:forEach>
                </select>
                :
                <select class="w50" name="PBEG1EDDT" id="PBEG1EDDT">
                    <option value="">--</option>
                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                    <option value="${minute}">${minute}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <select class="w50" name="PEND1STDT" id="PEND1STDT">
                    <option value="">--</option>
                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                    <option value="${hour}">${hour}</option>
                    </c:forEach>
                </select>
                :
                <select class="w50" name="PEND1EDDT" id="PEND1EDDT">
                    <option value="">--</option>
                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                    <option value="${minute}">${minute}</option>
                    </c:forEach>
                </select>
            </td>
            <td><input type="text" name="PUNB1" id="PUNB1" class="align-center" readonly /></td>
            <td class="tdBorder"><input type="text" name="PBEZ1" id="PBEZ1" class="align-center" readonly /></td>
        </tr>
        <tr>
            <th>휴게시간 2</th>
            <td>
                <select class="w50" name="PBEG2STDT" id="PBEG2STDT">
                    <option value="">--</option>
                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                    <option value="${hour}">${hour}</option>
                    </c:forEach>
                </select>
                :
                <select class="w50" name="PBEG2EDDT" id="PBEG2EDDT">
                    <option value="">--</option>
                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                    <option value="${minute}">${minute}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <select class="w50" name="PEND2STDT" id="PEND2STDT">
                    <option value="">--</option>
                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                    <option value="${hour}">${hour}</option>
                    </c:forEach>
                </select>
                :
                <select class="w50" name="PEND2EDDT" id="PEND2EDDT">
                    <option value="">--</option>
                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                    <option value="${minute}">${minute}</option>
                    </c:forEach>
                </select>
            </td>
            <td><input type="text" name="PUNB2" id="PUNB2" class="align-center" readonly /></td>
            <td class="tdBorder"><input type="text" name="PBEZ2" id="PBEZ2" class="align-center" readonly /></td>
        </tr>
        </c:otherwise></c:choose>
        </tbody>
        </table>
        <div class="tableComment">
            <p><span class="bold type-c${GUBUN_TPGUB eq 'C' ? '' : ' display-none'}">사무직 초과근무는 시간 단위로만 신청이 가능합니다.</span></p>
            <p><span class="bold">심야 초과근무 입력 시, 아래 예시 참조하여 주시기 바랍니다.</span></p>
            <p>ex) N(night) 대근시 : 23:00 ~ 07:00</p>
        </div>
    </div>
</div>
</form>

<%@include file="/WEB-INF/views/pages/work/include/breaktimeTableTemplate.jsp"%>

<%@include file="/WEB-INF/views/tiles/template/javascriptOverTime.jsp"%>
<script type="text/javascript">
function setBreaktimeData(data, index) {

    var PBEG = data['PBEG' + index] || '000000',
    PEND = data['PEND' + index] || '000000',
    PUNB = data['PUNB' + index] || '0',
    PBEZ = data['PBEZ' + index] || '0',
    nPBEG = Number(PBEG),
    nPEND = Number(PEND),
    nPUNB = Number(PUNB),
    nPBEZ = Number(PBEZ);
    if (nPBEG + nPEND + nPUNB + nPBEZ === 0) {
        $.each(['PBEG', 'PEND'], function(i, v) {
            $('#' + v + index + 'STDT').val('');
            $('#' + v + index + 'EDDT').val('');
        });
        $('#PUNB' + index).val('');
        $('#PBEZ' + index).val('');
    } else {
        var mPBEG = OverTimeUtils.getMomentTime(PBEG), mPEND = OverTimeUtils.getMomentTime(PEND);<%-- 24시 -> 00시 --%>
        $('#PBEG' + index + 'STDT').val(mPBEG.format('HH'));
        $('#PBEG' + index + 'EDDT').val(mPBEG.format('mm'));
        $('#PEND' + index + 'STDT').val(mPEND.format('HH'));
        $('#PEND' + index + 'EDDT').val(mPEND.format('mm'));
        $('#PUNB' + index).val(nPUNB);
        $('#PBEZ' + index).val(nPBEZ);
    }
}

function detailSearch() {

    $.ajax({
        url: '/appl/getWorkDetail.json',
        data: {
            AINF_SEQN: '${fn:escapeXml( AINF_SEQN )}'
        },
        dataType: 'json',
        type: 'POST',
        async: false
    }).done(function(response) {
        $.LOGGER.debug('detailSearch', response);

        if (!response.success) {
            alert('상세정보 조회시 오류가 발생하였습니다.\n\n' + response.message);
            return;
        }

        var storeData = response.storeData || {};
        if (storeData.STDAZ) storeData.STDAZ = OverTimeUtils.getNelim(storeData.STDAZ, 2);

        setDetail(storeData);
        setBreaktimeData(storeData, 1);
        setBreaktimeData(storeData, 2);

        var BEGUZ = OverTimeUtils.getMomentTime(storeData.BEGUZ);<%-- 24시 -> 00시 --%>
        var ENDUZ = OverTimeUtils.getMomentTime(storeData.ENDUZ);<%-- 24시 -> 00시 --%>
        $('#BEGUZSTDT').val(BEGUZ.format('HH'));
        $('#BEGUZEDDT').val(BEGUZ.format('mm'));
        $('#ENDUZSTDT').val(ENDUZ.format('HH'));
        $('#ENDUZEDDT').val(ENDUZ.format('mm'));

        // 사무직-선택근무제 or 현장직-탄력근무제 실근무시간 현황
        renderRealWorktimeReport(response.reportData || {});
    });
}

function setDetail(item) {

    setTableText(item, 'detailForm');
    fncSetFormReadOnly($('#detailForm'), true);
}

// 수정
function reqModifyActionCallBack() {

    var isExistComment = $('#VTKENComment').show().length > 0;
    $('.bottom-filler').toggleClass('short', isExistComment).toggleClass('tall', !isExistComment);
    $('#WORK_DATE').datepicker();
    fncSetFormReadOnly($('#detailForm'), false, ['BEGDA', 'STDAZ']);
}

// 수정취소
function reqCancelActionCallBack() {

    $('#VTKENComment').hide();
    $('.bottom-filler').toggleClass('short', false).toggleClass('tall', true);
    $('#detailForm')[0].reset();
    destroydatepicker('detailForm');

    detailSearch();
};

// 저장
function reqSaveActionCallBack() {

    if (!isValidOverTimeForm() || !isValidTime(true) || !confirm('저장하시겠습니까?')) {
        return false;
    }

    $('#reqSaveBtn').prop('disabled', true);
    $('#AINF_SEQN').val('${fn:escapeXml( AINF_SEQN )}');

    var param = $('#detailForm').serializeArray();
    $('#detailDecisioner').jsGrid('serialize', param);

    var isCallbackSuccess = false;
    $.ajax({
        url: '/appl/updateWork',
        data: param,
        dataType: 'json',
        type: 'POST',
        cache: false,
        async: false,
        success: function(response) {
            $.LOGGER.debug('reqSaveActionCallBack', response);

            if (!response.success) {
                $('#reqSaveBtn').prop('disabled', false);
                alert('저장시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            alert(response.message);

            $('#applDetailArea').html('');
            $('#reqApplGrid').jsGrid('search');

            isCallbackSuccess = true;
        }
    });

    return isCallbackSuccess;
};

$('#BEGUZSTDT, #BEGUZEDDT, #ENDUZSTDT, #ENDUZEDDT').change(changeTimeSelect);
$('#PBEG1STDT, #PBEG1EDDT, #PEND1STDT, #PEND1EDDT').change(function(e) {
    $('#PUNB1').val('');
    $('#PBEZ1').val('');
    changeTimeSelect(e);
});

$('#PBEG2STDT, #PBEG2EDDT, #PEND2STDT, #PEND2EDDT').change(function(e) {
    $('#PUNB2').val('');
    $('#PBEZ2').val('');
    changeTimeSelect(e);
});

function getAttWorkCode() {

    $.ajax({
        url: '/appl/getAttWorkCode.json',
        data: {
            WORK_DATE: $('#WORK_DATE').val().replace(/[^\d]/g, '')
        },
        dataType: 'json',
        type: 'POST',
        cache: false,
        async: false,
        success: function(response) {
            $.LOGGER.debug('getAttWorkCode', response);

            if (!response.success) {
                alert('초과근무일 조회시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            var item = response.storeData[0];
            var work_time = Number(item.ENDUZ) -Number(item.BEGUZ);
            $('#work_time').val(work_time);

            if (work_time > 0) {
                $('#inputFlag').val('N');
                $('#select').attr('disabled', true);
                $('#input').attr({disabled: true, readonly: true});
                $('#input[name=WORK_DATE]').attr({disabled: false, readonly: false}); // 초과근무일
                $('#select[name=OVTM_CODE]').attr('disabled', false); // 신청사유코드
                alert('초과근무일에 근무일정이 존재합니다.');
            } else {
                $('#inputFlag').val('Y');
                $('select').attr('disabled', false);
                $('input').attr({disabled: false, readonly: false});
                $('.jsInputSearch').attr({disabled: true, readonly: true});
                $('#BEGDA').attr('readonly', true);
                $('#STDAZ').attr('readonly', true);
            }
        }
    });
};

// 삭제
function reqDeleteActionCallBack() {

    if (!confirm('삭제하시겠습니까?'))  return;

    $('#reqDeleteBtn').prop('disabled', true);
    $('#AINF_SEQN').val('${fn:escapeXml( AINF_SEQN )}');

    var param = $('#detailForm').serializeArray();
    $('#detailDecisioner').jsGrid('serialize', param);

    $.ajax({
        url: '/appl/deleteWork',
        data: param,
        dataType: 'json',
        type: 'POST',
        cache: false,
        async: false,
        success: function(response) {
            $.LOGGER.debug('reqDeleteActionCallBack', response);

            if (!response.success) {
                $('#reqDeleteBtn').prop('disabled', false);
                alert('삭제시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            alert('삭제 되었습니다.');
            $('#applDetailArea').html('');
            $('#reqApplGrid').jsGrid('search');
        }
    });
}

function f_timeFormat(obj) {

    t = obj.val();

    if (!t) return true;

    if (isNaN(t)) {
        alert('입력 형식이 틀립니다.\n"##.##" 형식으로 입력하세요.');
        obj.focus().select();
        return false;
    }
    if (99.99 > t && t > 0) {
        t = t + '';
        d_index = t.indexOf('.');
        if (d_index != -1) {
            tmpstr = t.substring(d_index + 1, t.length);
            if (tmpstr.length > 2) { // 소수점 2자리가 넘는 경우
                alert('입력 형식이 틀립니다.\n"##.##" 형식으로 입력하세요.');
                obj.focus().select();
                return false;
            }
        }
        return true;
    }
    return true;
}

// 휴게시간 체크 로직
function isInvalidBreaktime(BEGUZ, ENDUZ, BREAKTIME) {

    if (!BREAKTIME) return false;

    if (BEGUZ > ENDUZ) {
        if (Number(BREAKTIME) < Number(BEGUZ)) { // 경우 잘못된값 true 리턴
            if (Number(BREAKTIME) > Number(ENDUZ)) return true;
        }
        return false;
    } else if (BEGUZ < ENDUZ) { // 주의 flag에 따라 체크 방법이 틀림
        if (Number(BEGUZ) <= Number(BREAKTIME)) {
            if (Number(BREAKTIME) <= Number(ENDUZ)) return false;

        } else if (BREAKTIME == 0 && ENDUZ == 2400) {
            return false;

        }
        return true;
    }

    return false;
}

function cal_time(time1, time2) {

    var tmp_HH1 = 0; // 이것이 문제다....
    var tmp_MM1 = 0;
    var tmp_HH2 = 0;
    var tmp_MM2 = 0;
    if (time1.length == 4) {
        tmp_HH1 = time1.substring(0, 2);
        tmp_MM1 = time1.substring(2, 4);
    } else if (time1.length == 3) {
        tmp_HH1 = time1.substring(0, 1);
        tmp_MM1 = time1.substring(1, 3);
    }
    if (time2.length == 4) {
        tmp_HH2 = time2.substring(0, 2);
        tmp_MM2 = time2.substring(2, 4);
    } else if (time2.length == 3) {
        tmp_HH2 = time2.substring(0, 1);
        tmp_MM2 = time2.substring(1, 3);
    }

    var tmp_hour = tmp_HH2 - tmp_HH1;
    var tmp_min  = tmp_MM2 - tmp_MM1;
    var interval_time = 0;

    if (tmp_hour < 0) {
        tmp_hour = 24 + tmp_hour;
    }
    if (tmp_min >= 0) {
        tmp_min = banolim(tmp_min / 60, 2);
    } else {
        tmp_hour = tmp_hour - 1;
        tmp_min  = banolim((60 + tmp_min) / 60, 2);
    }
    interval_time = tmp_hour + tmp_min + '';
    return interval_time;
}

//메인시간 계산용(총 초과 근무시간 계산용)
function cal_time2(time1, time2) {

    var tmp_HH1 = 0; // 이것이 문제다....
    var tmp_MM1 = 0;
    var tmp_HH2 = 0;
    var tmp_MM2 = 0;
    if (time1.length == 4) {
        tmp_HH1 = time1.substring(0, 2);
        tmp_MM1 = time1.substring(2, 4);
    } else if (time1.length == 3) {
        tmp_HH1 = time1.substring(0, 1);
        tmp_MM1 = time1.substring(1, 3);
    }
    if (time2.length == 4) {
        tmp_HH2 = time2.substring(0, 2);
        tmp_MM2 = time2.substring(2, 4);
    } else if (time2.length == 3) {
        tmp_HH2 = time2.substring(0, 1);
        tmp_MM2 = time2.substring(1, 3);
    }

    var tmp_hour = tmp_HH2 - tmp_HH1;
    var tmp_min  = tmp_MM2 - tmp_MM1;
    var interval_time = 0;

    if (tmp_hour < 0) {
        tmp_hour = 24 + tmp_hour;
    }
    if (tmp_min >= 0) {
        tmp_min = banolim(tmp_min / 60, 2);
    } else {
        tmp_hour = tmp_hour - 1;
        tmp_min  = banolim((60 + tmp_min) / 60, 2);
    }
    interval_time = tmp_hour + tmp_min + '';
    if (interval_time == 0) {
        interval_time = 24;
    }

    return interval_time;
}

function isValidTime(isSave) {

    // 필수 필드의 형식 체크
    // 무급 및 유급 시간형식 첵크
    if (!f_timeFormat($('#PUNB1')) || !f_timeFormat($('#PBEZ1')) || !f_timeFormat($('#PUNB2')) || !f_timeFormat($('#PBEZ2'))) return false;

    var WORK_DATE = $('#WORK_DATE'),

    BEGUZ = $('#BEGUZSTDT').val() + $('#BEGUZEDDT').val(), // 초과근무 시작시각
    ENDUZ = $('#ENDUZSTDT').val() + $('#ENDUZEDDT').val(), // 초과근무 종료시각
    STDAZ = $('#STDAZ').val() || '',                       // 초과근무 시간

    PBEG1STDT = $('#PBEG1STDT'),
    PBEG1EDDT = $('#PBEG1EDDT'),
    PEND1STDT = $('#PEND1STDT'),
    PEND1EDDT = $('#PEND1EDDT'),
    PBEG2STDT = $('#PBEG2STDT'),
    PBEG2EDDT = $('#PBEG2EDDT'),
    PEND2STDT = $('#PEND2STDT'),
    PEND2EDDT = $('#PEND2EDDT'),

    PBEG1 = (PBEG1STDT.val() || '') + (PBEG1EDDT.val() || ''), // 휴게 시작시각 1
    PEND1 = (PEND1STDT.val() || '') + (PEND1EDDT.val() || ''), // 휴게 종료시각 1
    PBEG2 = (PBEG2STDT.val() || '') + (PBEG2EDDT.val() || ''), // 휴게 시작시각 2
    PEND2 = (PEND2STDT.val() || '') + (PEND2EDDT.val() || ''), // 휴게 종료시각 2

    PUNB1  = $('#PUNB1').val() || '', // 무급 휴게시간 1
    PBEZ1  = $('#PBEZ1').val() || '', // 유급 휴게시간 1
    PUNB2  = $('#PUNB2').val() || '', // 무급 휴게시간 2
    PBEZ2  = $('#PBEZ2').val() || ''; // 유급 휴게시간 2

    if (!WORK_DATE.val()) {
        if (isSave) {
            alert('초과근무일은 필수 입력사항입니다.');
            WORK_DATE.focus();
        }
        return false;
    }
    if (!/^\d{4}\.\d{2}\.\d{2}$/.test(WORK_DATE.val())) {
        alert('초과근무일을 "' + moment().format('YYYY.MM.DD') + '" 형식으로 입력하세요.');
        WORK_DATE.focus();
        return false;
    }

    var TPGUB = '${fn:escapeXml( GUBUN_TPGUB )}';
    if (TPGUB === 'C') return true;

    // 초과근무에서 휴게시간의 유효범위 체크
    if (isInvalidBreaktime(BEGUZ, ENDUZ, PBEG1)) {
        alert('휴게시간이 초과근무시간에 해당하지 않습니다.');
        PBEG1STDT.not('[readonly]').focus().select();
        return false;
    }

    if (isInvalidBreaktime(BEGUZ, ENDUZ, PEND1)) {
        alert('휴게시간이 초과근무시간에 해당하지 않습니다.');
        PEND1STDT.not('[readonly]').focus().select();
        return false;
    }
    if (isInvalidBreaktime(BEGUZ, ENDUZ, PBEG2)) {
        alert('휴게시간이 초과근무시간에 해당하지 않습니다.');
        PBEG2STDT.not('[readonly]').focus().select();
        return false;
    }
    if (isInvalidBreaktime(BEGUZ, ENDUZ, PEND2)) {
        alert('휴게시간이 초과근무시간에 해당하지 않습니다.');
        PEND2STDT.not('[readonly]').focus().select();
        return false;
    }

    // 휴게시간이 정확한지 여부 체크
    // 시간+날짜
    var D_PBEG1, D_PEND1, D_PBEG2, D_PEND2;

    // 휴게시간 1
    if (PBEG1 && PEND1) {
        D_PBEG1 = (BEGUZ <= PBEG1 ? '1' : '2') + PBEG1;
        D_PEND1 = (BEGUZ <= PEND1 ? '1' : '2') + PEND1;

        // 시간여부 첵크
        if (D_PBEG1 > D_PEND1) {
            alert('휴게시간이 설정이 잘못되었습니다.');
            $('#PEND1').focus();
            return false;
        }
    }

    // 휴게시간 2
    if (PBEG2 && PEND2) {
        if (BEGUZ <= PBEG2) {
            D_PBEG2 = '1'+PBEG2;
        } else {
            D_PBEG2 = '2'+PBEG2;
        }
        if (BEGUZ <= PEND2) {
            D_PEND2 = '1'+PEND2;
        } else {
            D_PEND2 = '2'+PEND2;
        }
        //
        if (D_PBEG2 > D_PEND2) {
            alert('휴게시간이 설정이 잘못되었습니다.');
            $('#PEND2').focus();
            return false;
        }
    }

    // 휴게시간 값이 모두 있는경우  //좀더 생각
    if (PBEG1 && PEND1 && PBEG2 && PEND2) {
        if (D_PEND1 <= D_PBEG2 && D_PEND1 <= D_PEND2) {
            //정상적인경우
        } else if (D_PEND2 <= D_PBEG1 && D_PBEG2 <= D_PBEG1) {
            //정상적인경우
        } else {
            alert('휴게시간이 설정이 잘못되었습니다.');
            $('#PBEG1').focus();
            return false;
        }
    }
    // 휴게시간 계산  //잘못된 값 억제..
    tmpSTDAZ = cal_time2(BEGUZ, ENDUZ) + '';

    if (PBEG1 && PEND1) {
        if (!PUNB1 && !PBEZ1) {
            PUNB1 = cal_time(PBEG1, PEND1);
            PBEZ1 = '';
        }
        if (PUNB1 && !PBEZ1) {
            var MAX = Number(cal_time(PBEG1, PEND1));
            if (Number(PUNB1) > MAX) {
                alert('최대 입력값은 ' + MAX + ' 입니다.');
                $('#PUNB1').focus().select();
                return false;
            }
        }
        if (PUNB1 && PBEZ1) {
            var MAX = Number(cal_time(PBEG1, PEND1));
            if (Number(PUNB1) + Number(PBEZ1) > MAX) {
                alert('최대 입력값은 ' + MAX + ' 입니다.');
                $('#PUNB1').focus().select();
                return false;
            }
        }
        if (!PUNB1 && PBEZ1) {
            var MAX = Number(cal_time(PBEG1, PEND1));
            if (Number(PBEZ1) > MAX) {
              alert('최대 입력값은 ' + MAX + ' 입니다.');
              $('#PUNB1').focus().select();
              return false;

            }
        }
        tmpSTDAZ = tmpSTDAZ - PUNB1;
    } else {
        if (PUNB1) PUNB1 = '';
        if (PBEZ1) PBEZ1 = '';
    }

    if (PBEG2 && PEND2) {
        if (!PUNB2 && !PBEZ2) {
            PUNB2 = cal_time(PBEG2, PEND2);
            PBEZ2 = '';
        }
        if (PUNB2 && !PBEZ2) {
            var MAX = Number(cal_time(PBEG2, PEND2));
            if (Number(PUNB2) > MAX) {
                alert('최대 입력값은 ' + MAX + ' 입니다.');
                $('#PUNB2').focus().select();
                return false;
            }
        }
        if (PUNB2 && PBEZ2) {
            var MAX = Number(cal_time(PBEG2, PEND2));
            if (Number(PUNB2) + Number(PBEZ2) > MAX) {
                alert('최대 입력값은 ' + MAX + ' 입니다.');
                $('#PUNB2').focus().select();
                return false;
            }
        }
        if (!PUNB2 && PBEZ2) {
            var MAX = NUmber(cal_time(PBEG2, PEND2));
            if (Number(PBEZ2) > MAX) {
                alert('최대 입력값은 ' + MAX + ' 입니다.');
                $('#PUNB2').focus().select();
                return false;
            }
        }
        tmpSTDAZ = tmpSTDAZ - PUNB2;
    } else {
        if (PUNB2) PUNB2 = '';
        if (PBEZ2) PBEZ2 = '';
    }

    // 이동로직
    if (!PBEG1 && PBEG2) {
        PBEG1 = PBEG2;
        PEND1 = PEND2;
        PUNB1 = PUNB2;
        PBEZ1 = PBEZ2;
        PBEG2 = '';
        PEND2 = '';
        PUNB2 = '';
        PBEZ2 = '';
    }

    $('#STDAZ').val(Number(tmpSTDAZ || '0').toFixed(2));
    $('#PUNB1').val(PUNB1 == 0 ? '' : PUNB1);
    $('#PBEZ1').val(PBEZ1 == 0 ? '' : PBEZ1);
    $('#PUNB2').val(PUNB2 == 0 ? '' : PUNB2);
    $('#PBEZ2').val(PBEZ2 == 0 ? '' : PBEZ2);

    return true;
}

/**
 * 신청일자(D) 또는 신청시간(H)이 변경된 경우
 *   D   실근무시간 현황 조회
 *   D   교대조 신청가능일 체크
 *   D/H 근무일정 중복 체크 및 한계결정
 *   D/H 휴게시간 계산
 */
function getCheckOverTime(dateChanged) {

    if (!isValidTime()) return;

    var isLimitCheck = checkLimit();

    $.ajax({
        url: '/work/getCheckOverTime.json',
        data: {
            AINF_SEQN: '${fn:escapeXml( AINF_SEQN )}',
            WORK_DATE: $('#WORK_DATE').val(),
            BEGUZSTDT: $('#BEGUZSTDT').val(),
            BEGUZEDDT: $('#BEGUZEDDT').val(),
            ENDUZSTDT: $('#ENDUZSTDT').val(),
            ENDUZEDDT: $('#ENDUZEDDT').val(),
            VTKEN: $('#VTKEN').prop('checked') ? 'X' : '',
            CHKLMT: isLimitCheck ? 'X' : '',
            CHGDAT: dateChanged ? 'X' : ''
        },
        dataType: 'json',
        type: 'POST',
        async: false,
        cache: false,
        success: function(response) {
            $.LOGGER.debug('getCheckOverTime', response);

            checkOverTimeCallback({ // overtime.js
                response: response,
                isLimitCheck: isLimitCheck,
                dateChanged: dateChanged
            });
        }
    });
}

function changeTimeSelect(e) {

    <%-- 시작 : [WorkTime52] 사무직-선택근무제 휴일근무 시간 한도적용 --%>
    // 초과근무 입력가능 시간제한이 있는 경우 시작시각이 변경되면 종료시각 <option>을 제한된 시간만큼만 보여준다.
    var target = $(e.currentTarget);
    if (target.is('#BEGUZSTDT')) { // 시작시각 변경이고 숫자가 선택된 경우
        rerenderEndHour(target); // overtime.js
    }
    <%-- 종료 : [WorkTime52] 사무직-선택근무제 휴일근무 시간 한도적용 --%>
    <%-- 시작 : [WorkTime52] 사무직-선택근무제 한시간 단위 입력 제어(시작시각, 종료시각 분이 같은 값으로 움직이도록 제어) --%>
    if (target.is('[data-mimic]')) {
        target.siblings('[data-mimic]').val(target.val());
    }
    <%-- 종료 : [WorkTime52] 사무직-선택근무제 한시간 단위 입력 제어(시작시각, 종료시각 분이 같은 값으로 움직이도록 제어) --%>

    $('#STDAZ').val(function() {
        var v = $(this).val();
        return v ? v : '0.00';
    });

    getCheckOverTime(false);
}

// 초과근무 신청 관련 validation
function isValidOverTimeForm() {

    if (Number($('#STDAZ').val() || 0) === 0) {
        alert('신청시간이 0시간입니다. 시간을 다시 입력해주세요.');
        return;
    }

    if ($('#work_time').val() > 0) {
        alert('초과근무일에 근무일정이 존재합니다.');
        return false;
    }

    if (!checkNullField('detailForm')) return false;

    var REASON = $('#REASON');
    if (!$.trim(REASON.val())) {
        alert('신청사유항목은 필수 입력사항입니다.');
        REASON.focus();
        return false;
    }

    return true;
}

$('#WORK_DATE').change(function() {

    var WORK_DATE = $('#WORK_DATE'), vWORK_DATE = WORK_DATE.val();
    if (!vWORK_DATE) return false;

    var dateChk = vWORK_DATE.replace(/\./g, '');

    if (dateChk < '20040301') {
         alert('2004년 03월 01일부터 초과근무 입력이 가능합니다.');
         $('#WORK_DATE').focus();
         return false;
    }

    if (dateChk < '<%= D_RRDAT %>') {
         alert('초과근무는 <%= E_RRDAT.equals("") ? "" : WebUtil.printDate(E_RRDAT) %>일 이후에만 신청 가능합니다.');
         $('#WORK_DATE').select();
         return false;
    }

    getCheckOverTime(true);
<% // 사무직(연봉제), 운전직(호봉제)인 경우만 check하도록한다.
    if (("02".equals(user.e_trfar) && ("L2급".equals(user.e_trfgr) ||
         "L1A급".equals(user.e_trfgr) || "L1B급".equals(user.e_trfgr) ||
         "L1B급".equals(user.e_trfgr))) || "11".equals(user.e_trfar)) {
%>
        getAttWorkCode();
<%
    }
%>
});

$('.span-look').focus(function() {
    this.blur();
});

detailSearch();
</script>