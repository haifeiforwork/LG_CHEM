<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Objects"%>
<%@ page import="java.util.Vector"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D01OT.*"%>
<%@ page import="hris.D.D01OT.rfc.*"%>
<%@ page import="hris.D.D03Vocation.*"%>
<%@ page import="hris.D.D03Vocation.rfc.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    WebUserData user = (WebUserData) session.getAttribute("user");

    String PERNR = Objects.toString(request.getAttribute("PERNR"), user.empNo);
    String currentDate = DateTime.getShortDateString();

    D01OTData data = (D01OTData) request.getAttribute("D01OTData"); // 초과근무신청

    // 2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
    String E_RRDAT = new GetTimmoRFC().GetTimmo(user.companyCode);
    request.setAttribute("E_RRDAT", StringUtils.isNotBlank(E_RRDAT) ? WebUtil.printDate(E_RRDAT) : "");
    request.setAttribute("D_RRDAT", Long.parseLong(DataUtil.removeStructur(E_RRDAT, ".")));

    int year = DateTime.getYear(); // 년
    int month = DateTime.getMonth(); // 월

    int startYear = Integer.parseInt((user.e_dat03).substring(0, 4));
    int endYear = year;

    //  2003.01.02. - 12월일때만 endYear에 + 1년을 해준다.
    if (month == 12) {
        endYear = year + 1;
    }
    if (startYear < 2004) {
        startYear = 2004;
    }
    if (endYear - startYear > 10) {
        startYear = endYear - 10;
    }

    Vector years = new Vector();
    for (int i = startYear; i <= endYear; i++) {
        String value = "" + i;
        years.addElement(new CodeEntity(value, value));
    }

    D03VocationAReasonRFC rfc = new D03VocationAReasonRFC();

    Map<String, Object> basicData = rfc.getOTBasicData(PERNR, "2005", currentDate); // 초과근무 신청사유, 초과근무 신청가능 여부

    Vector otReasons = (Vector) basicData.get("OVTM_CODE_LIST"); // 초과근무 신청사유
    Vector otOptions = new Vector();
    for (int j = 0; j < otReasons.size(); j++) {
        D03VocationReasonData codeData = (D03VocationReasonData) otReasons.get(j);
        otOptions.addElement(new CodeEntity(codeData.SCODE, codeData.STEXT));
    }

    Vector eduReasons = rfc.getSubtyCode(PERNR, "0010", currentDate); // 교육 신청사유
    Vector eduOptions = new Vector();
    for (int i = 0; i < eduReasons.size(); i++) {
        D03VocationReasonData codeData = (D03VocationReasonData) eduReasons.get(i);
        if (!"1".equals(codeData.SCODE) && !"2".equals(codeData.SCODE)) {
            eduOptions.addElement(new CodeEntity(codeData.SCODE, codeData.STEXT));
        }
    }

    String message = Objects.toString(request.getAttribute("message"), "");
    boolean isForbiddenEduOrBizTrip = eduReasons.size() < 1 && StringUtils.isBlank(message);  // 교육/출장 대상이 아닌 경우 - (이세희 대리)

    request.setAttribute("today", DateTime.getDateString());
    request.setAttribute("month", month);
    request.setAttribute("OTbuildYn", basicData.get("OTbuildYn"));
%>
<c:if test="${param.FROM_ESS_OFW_WORK_TIME ne 'Y'}"><%-- 근무시간입력 메뉴에서 popup으로 호출된 경우 Page title 영역은 숨김 --%>
<!-- Page title start -->
<div class="title">
    <h1>근무</h1>
    <div class="titleRight">
        <ul class="pageLocation">
            <li><span><a href="#">Home</a></span></li>
            <li><span><a href="#">My Info</a></span></li>
            <li><span><a href="#">근태</a></span></li>
            <li class="lastLocation"><span><a href="#">근무</a></span></li>
        </ul>
    </div>
</div>
<!--// Page title end -->
</c:if>

<!-- layout body start -->
<!-- Tab start -->
<div class="tabArea">
    <ul class="tab"><%-- 21:간부사원 -> 팀장미만으로 대상자 변경됨 <c:if test="${user.e_persk ne '21'}"> --%>
        <c:if test="${OTbuildYn eq 'Y'}">
            <c:if test="${TAB.T01 eq 'Y'}">
        <li><a href="#" id="tab1" onclick="switchTabs(this)"${param.TABID eq 'OTBF' or empty param.TABID ? ' class="selected"' : ''}>초과근무(OT/특근) 신청</a></li>
            </c:if>
            <c:if test="${TAB.T02 eq 'Y'}">
        <li><a href="#" id="tab2" onclick="switchTabs(this)"${param.TABID eq 'OTAF' ? ' class="selected"' : ''}>초과근무(OT/특근) 사후신청</a></li>
            </c:if>
        </c:if>
        <c:if test="${TAB.T04 eq 'Y'}">
        <li><a href="#" id="tab3" onclick="switchTabs(this)"${param.TABID eq 'EDTR' or OTbuildYn ne 'Y'  ? ' class="selected"' : ''}>교육/출장 신청</a></li>
        </c:if>
        <li><a href="#" id="tab4" onclick="switchTabs(this)"${param.TABID eq 'CANC' ? ' class="selected"' : ''}>근무취소신청</a></li>
        <li><a href="#" id="tab5" onclick="switchTabs(this)"${param.TABID eq 'RSLT' ? ' class="selected"' : ''}>근태실적조회</a></li>
        <c:if test="${TAB.T03 eq 'Y'}">
        <li><a href="#" id="tab6"${param.TABID eq 'RPRT' ? ' class="selected"' : ''}>근무실적현황</a></li>
        </c:if>
    </ul>
</div>
<!--// Tab end -->

<c:if test="${OTbuildYn eq 'Y' and TAB.T01 eq 'Y'}">
<!-- Tab1 start -->
<div class="tabUnder tab1">
<%@ include file="include/attendanceInfoTab1.jsp" %>
</div>
<!--// Tab1 end -->
</c:if>

<c:if test="${OTbuildYn eq 'Y' and TAB.T02 eq 'Y'}">
<!-- Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
<%@ include file="include/attendanceInfoTab2.jsp" %>
</div>
<!--// Tab2 end -->
</c:if>

<!-- Tab3 start -->
<div class="tabUnder tab3${OTbuildYn eq 'Y' ? ' Lnodisplay' : ''}">
<%@ include file="include/attendanceInfoTab3.jsp" %>
</div>
<!--// Tab3 end -->

<!-- Tab4 start -->
<div class="tabUnder tab4 Lnodisplay">
<%@ include file="include/attendanceInfoTab4.jsp" %>
</div>
<!--// Tab4 end -->

<!-- Tab5 start -->
<div class="tabUnder tab5 Lnodisplay">
<%@ include file="include/attendanceInfoTab5.jsp" %>
</div>
<!--// Tab5 end -->

<!-- Tab6 start -->
<div class="tabUnder tab6 Lnodisplay">
    <iframe id="listFrame" name="listFrame" src="/work/workTimeReport" style="margin:0;width:100%;height:100vh" scrolling="auto" frameborder="0"></iframe>
</div>
<!--// Tab6 end -->

<!-- popup : 월별 계획근무일정 start -->
<div class="layerWrapper layerSizeP" id="popLayerSchedule" style="display:none;">
    <div class="layerHeader">
        <strong>월별 계획근무일정</strong>
        <a href="#" class="btnClose popLayerSchedule_close">창닫기</a>
    </div>
    <iframe name="schedulePopup" id="schedulePopup" src="" frameborder="0" scrolling="no" style="width:100%;height:500px;"></iframe>
</div>
<!--// popup : 월별 계획근무일정 end -->

<!-- script start -->
<%@include file="/WEB-INF/views/tiles/template/javascriptOverTime.jsp"%>
<script type="text/javascript">
function $schedulePopup() {

    $('body').loader('show', '<img style="width:50px;height:50px" src="/web-resource/images/img_loading.gif">');
    $('#schedulePopup')
        .attr('src', '/work/personWorkSchedule')
        .load(function() {
            $('body').loader('hide');
            $('#popLayerSchedule').popup('show');
        });
}

function $changeUPMU_TYPE() {

    $('#attCancelDiv').html($attCancelHtml);
    $('#cancelDiv').hide();
    $('#cancelDecisioner').hide();
    $('#cancelBtnDiv').hide();
}

function $attCancelGrid() {

    $('#attCancelGrid').jsGrid({
        height : 'auto',
        width : '100%',
        sorting : true,
        paging : true,
        autoload : false,
        controller : {
            loadData : function() {
                var d = $.Deferred();

                $.ajax({
                    url: '/work/getAttCancelList.json',
                    data: {
                        I_UPMU_TYPE: $('#I_UPMU_TYPE option:selected').val(),
                        I_TBEGDA: $('#I_TBEGDA').val(),
                        I_TENDDA: $('#I_TENDDA').val()
                    },
                    dataType: 'json',
                    type: 'POST'
                }).done(function(response) {
                    $.LOGGER.debug('#attCancelGrid controller loadData', response);

                    if (!response.success) {
                        alert('조회시 오류가 발생하였습니다.\n\n' + response.message);
                        return;
                    }

                    d.resolve(response.storeData);
                });

                return d.promise();
            }
        },
        fields: [
            {   title: '선택', name: 'th1', align: 'center', width: '6%',
                itemTemplate: function(_, item) {
                    return $('<input name="cnRa">')
                        .attr('type', 'radio')
                        .on('click', function(e) {
                            $searchCancelDetail(item.CANC_STAT,item.AINF_SEQN, item.UPMU_TYPE, item.CAIN_SEQN);
                        });
                },
            },
            {   title: 'No.', name: 'ROWNUMBER', type: 'text', align: 'center', width: '10%', sorting: false,
                itemTemplate: function(value, item) {
                    return $('#attCancelGrid').jsGrid('option', 'data').indexOf(item) + 1;
                }
            },
            {   title: '신청일', name: 'BEGDA', type: 'text', align: 'center', width: '20%' },
            {   title: '업무구분', name: 'UPMU_NAME', type: 'text', align: 'center', width: '20%' },
            {   title: '근태일', name: 'TBEGDA', type: 'text', align: 'center', width: '24%',
                itemTemplate: function(value, item) {
                    if (item.UPMU_TYPE == '40') {
                        return item.TBEGDA + ' ~ ' + item.TENDDA;
                    } else {
                        return item.TBEGDA;
                    }
                }
            },
            {   title: '취소신청여부', name: 'CANC_NAME', type: 'text', align: 'center', width: '20%' }
        ]
    });
}

function clearZeroData(data, index) {

    var PBEG = Number(data['PBEG' + index] || 0),
    PEND = Number(data['PEND' + index] || 0),
    PUNB = Number(data['PUNB' + index] || 0),
    PBEZ = Number(data['PBEZ' + index] || 0);
    if (PBEG + PEND + PUNB + PBEZ === 0) {
        $.each(['PBEG', 'PEND', 'PUNB', 'PBEZ'], function(i, v) {
            $('#overTimeDiv [name="' + v + index + '"]').text('');
        });
    }
}

$ainf_seqn = '';
$upmu_type = '';
function $searchCancelDetail(CANC_STAT, AINF_SEQN, UPMU_TYPE, CAIN_SEQN) {

    $('#attCancelDiv .tableComment')[$('#attCancelGrid').jsGrid('dataCount') ? 'show' : 'hide']();

    $.each($('.popup_wrapper'), function(i, popup) { // 기존 팝업레이어를 지운다. 이렇게 안하면 .popup_wrapper div 가 계속 생성된다.
        if (popup.id != 'popLayerHrStaff_wrapper') $('#' + popup.id).detach();
    });

    $ainf_seqn = AINF_SEQN;
    $upmu_type = UPMU_TYPE;

    // 초과근무
    if (UPMU_TYPE == '17') {
        $.ajax({
            url: '/appl/getWorkDetail.json',
            data: {
                AINF_SEQN: AINF_SEQN
            },
            dataType: 'json',
            type: 'POST',
            async: false
        }).done(function(response) {
            $.LOGGER.debug('$searchCancelDetail UPMU_TYPE 17', response);

            if (!response.success) {
                alert('상세정보 조회시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            var storeData = response.storeData || {};
            setTableText(storeData, 'overTimeDiv');
            clearZeroData(storeData, 1);
            clearZeroData(storeData, 2);

            // 신청사유
            var code = storeData.OVTM_CODE;
            if (code) {
                var map = {};
                $.each(response.reasonCodeList || [], function(i, o) {
                    map[o.SCODE] = o.STEXT;
                });
                $("#overTimeDiv #OVTM_TEXT").text(map[code] || '');
            }

            // TPGUB-C 또는 TPGUB-D 실근무시간 현황 표시 제어
            var table = $('#overTimeDiv #otFormTable'), colgroup = table.find('> colgroup'), cols = colgroup.find('col'),
            reportData = response.reportData || {},
            isTypeC = reportData.TPGUB === 'C', isTypeD = reportData.TPGUB === 'D';

            // 현황 표시
            if (isTypeC || isTypeD) {
                if (cols.length === 2) {
                    colgroup.append('<col>');
                    table.find('td.worktime-report')
                         .toggleClass(isTypeC ? 'type-c' : 'type-d', true)
                         .toggleClass(isTypeC ? 'type-d' : 'type-c', false)
                         .toggleClass('display-none', false);
                } else {
                    table.find('td.worktime-report')
                         .toggleClass(isTypeC ? 'type-c' : 'type-d', true)
                         .toggleClass(isTypeC ? 'type-d' : 'type-c', false);
                }
                renderRealWorktimeReport(reportData, '#overTimeDiv');
            }
            // 현황 숨김
            else {
                if (cols.length === 3) {
                    cols.last().remove();
                    table.find('td.worktime-report')
                         .toggleClass('type-c', false)
                         .toggleClass('type-d', false)
                         .toggleClass('display-none', true);
                }
            }

            // TPGUB-C 기타 화면 제어
            if (isTypeC) {
                $('#overTimeDiv .ot-reason').toggleClass('type-c', true).toggleClass('type-d', false);
            } else {
                $('#overTimeDiv .ot-reason').toggleClass('type-c', false).toggleClass('type-d', isTypeD);
            }

            // 신청/결재 기한 기준 button
            setRequestOrApprovalDeadlineProperty({
                TPGUB: response.TPGUB,
                DATUM: storeData.WORK_DATE
            });

            $('#SCancelDate').text('초과근무일');
            $('#overTimeDiv').show();
            $('#afterOverTimeDiv').hide();
            $('#eduBizDiv').hide();
            $('#attCancelGrid .jsgrid-header-row th:eq(4)').html('초과근무일');
        });
    }
    // 교육/출장
    else if (UPMU_TYPE == '40') {
        $.ajax({
            url : '/appl/getEduTripDetail.json',
            data : {
                AINF_SEQN: AINF_SEQN
            },
            dataType : 'json',
            type : 'POST',
            async :false
        }).done(function(response) {
            $.LOGGER.debug('$searchCancelDetail UPMU_TYPE 40', response);

            if (!response.success) {
                alert('상세정보 조회시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }
            
            var tabFlag = response.tabFlag;
            var awart = response.storeData[0].AWART;
            var gubunArr = $.makeArray({'code':'0020','value':'출장'});
            if(tabFlag == 'Y' && (awart == '0010' || awart == '0011')) {
            	gubunArr.push({'code':'0010','value':'필수교육'});
            	gubunArr.push({'code':'0011','value':'선택교육'});
            	
            	$('[name=CANCLE_BEGUZ]').text(response.storeData[0].BEGUZ.substring(0, 2) + ":" + response.storeData[0].BEGUZ.substring(2, 4));
            	$('[name=CANCLE_ENDUZ]').text(response.storeData[0].ENDUZ.substring(0, 2) + ":" + response.storeData[0].ENDUZ.substring(2, 4));
            	
				$('#cancleInputTimeArea').show();
			} else {
				gubunArr.push({'code':'0010','value':'교육'});
				
				$('#cancleInputTimeArea').hide();
			}

            var arr;
            $.ajax({
                 type : 'POST',
                 url : '/work/getEduWorkCode.json',
                 cache : false,
                 dataType : 'json',
                 data : {
                     'AWART' : response.storeData[0].AWART,
                     'PERNR' : $('#PERNR').val()
                 },
                 async : false,
                 success : function(response) {
                     arr = $.makeArray({'AWART':gubunArr, 'OVTM_CODE':response.storeData});
                 }
            });
            
            $('#SCancelDate').text('교육/출장일');
            $('#overTimeDiv').hide();
            $('#afterOverTimeDiv').hide();
            $('#eduBizDiv').show();
            $('#attCancelGrid .jsgrid-header-row th:eq(4)').html('교육/출장일');
            
            setTableText(response.storeData[0], 'eduBizDiv', arr);
        });
    }
    // 초과근무 사후신청
    else if (UPMU_TYPE == '47') {
        $.ajax({
            url : '/appl/getAfterOvertimeDetail.json',
            data : {
                AINF_SEQN: AINF_SEQN
            },
            dataType: 'json',
            type: 'POST'
        }).done(function(response) {
            $.LOGGER.debug('$searchCancelDetail UPMU_TYPE 47', response);

            if (!response.success) {
                alert('상세정보 조회시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            // 사무직-선택근무제 실근무시간 현황
            renderRealWorktimeReport(response.reportData || {}, '.tab4');

            // 선택일자 실근무시간
            var worktimeData = response.worktimeData || {};
            renderAfterOvertimeData(worktimeData, '.tab4');

            // 초과근무 사후신청 상세
            var overtimeData = response.overtimeData || {};
            $('.tab4 td[name="PICKED_DATE"]').text(moment(overtimeData.WORK_DATE).subtract(overtimeData.VTKEN == 'X' ? 1 : 0, 'days').format('YYYY.MM.DD'));
            $('.tab4 span[name="NRFLGG"]')[overtimeData.ZOVTYP == 'N0' ? 'show' : 'hide']();
            $('.tab4 span[name="R01FLG"]')[overtimeData.ZOVTYP == 'R1' ? 'show' : 'hide']();
            $('.tab4 span[name="R02FLG"]')[overtimeData.ZOVTYP == 'R2' ? 'show' : 'hide']();

            if (overtimeData.BEGUZ) overtimeData.BEGUZ = OverTimeUtils.transformTime(overtimeData.BEGUZ);
            if (overtimeData.ENDUZ) overtimeData.ENDUZ = OverTimeUtils.transformTime(overtimeData.ENDUZ);
            overtimeData.STDAZ = OverTimeUtils.getNelim(overtimeData.STDAZ, 2);

            setTableText(overtimeData, 'afterOverTimeDiv');

            if (worktimeData.STDAZ == worktimeData.NRQPST && Number(overtimeData.PUNB1 || 0) > 0) {
                $('.tab4 span#CPDABS').text(worktimeData.CPDABS).parent().css('display', 'inline');
            }

            var code = overtimeData.OVTM_CODE;
            if (code) {
                var map = {};
                $.each(response.reasonCodeList || [], function(i, o) {
                    map[o.SCODE] = o.STEXT;
                });
                $(".tab4 #OVTM_TEXT").text(map[code] || '');
            }

            $('#SCancelDate').text('초과근무일');
            $('#overTimeDiv').hide();
            $('#afterOverTimeDiv').show();
            $('#eduBizDiv').hide();
            $('#attCancelGrid .jsgrid-header-row th:eq(4)').html('초과근무일');
        });
    }

    //CANC_STAT 취소신청가능
    if (CANC_STAT == '01') {
        $('#cancelDiv').show();
        $('#cancelDecisioner').load('/common/getDecisionerGrid?upmuType='+UPMU_TYPE+'&gridDivId=cancelDecisionerGrid');
        $('#cancelDecisioner').show();
        $('#cancelBtnDiv').show();

    } else {
        $('#cancelDiv').hide();
        $('#cancelDecisioner').hide();
        $('#cancelBtnDiv').hide();
    }

    $('html,body').animate({
        scrollTop: $('#attCancelDiv').offset().top
    });
}

function attCancelRequest(self) {

    if (!checkNullField('attCancelForm')) return;
    //자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
    var msg = self ? '자가취소의 경우 신청과 동시에 승인이 완료됩니다.\n' : '';
    cancelDecisionerGridChangeAppLine(self);
    if (!confirm(msg + '취소신청 하시겠습니까?')) {
        cancelDecisionerGridChangeAppLine(false);
        return;
    }
    var param = $('#attCancelForm').serializeArray();
    $('#cancelDecisionerGrid').jsGrid('serialize', param);
    param.push({name: 'AINF_SEQN', value: $ainf_seqn});
    param.push({name: 'UPMU_TYPE', value: $upmu_type});
    param.push({name: 'selfAppr', value: self});

    $.ajax({
        url : '/work/requestCancel.json',
        data : param,
        dataType : 'json',
        type : 'POST',
        async :false
    }).done(function(response) {
        $.LOGGER.debug('attCancelRequest()', response);

        if (!response.success) {
            alert('취소신청시 오류가 발생하였습니다. ' + response.message);
            return;
        }

        alert('취소신청 되었습니다.');
        $changeUPMU_TYPE();
        $('#attCancelSearchBtn').click();
    });

}

$(function() {

    //근태 실적조회 그리드
    $('#addListGrid').jsGrid({
        height : 'auto',
        width : '100%',
        sorting : true,
        paging : false,
        autoload : true,
        headerRowRenderer : function() {
            var $result = $('<tr>').height(0)
                .append($('<th>').width('9%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'))
                .append($('<th>').width('7%'));
            $result = $result.add($('<tr>')
                .append($('<th>').attr('rowspan', 2).text('구분'))
                .append($('<th>').attr('colspan', 5).text('추가 근로(시간)'))
                .append($('<th>').attr('colspan', 2).text('사원급료정보'))
                .append($('<th>').attr('colspan', 5).text('휴가(일수)'))
                .append($('<th>').attr('colspan', 1).text('기타(일수)')));

            var $tr = $('<tr>');
            var grid = this;
            grid._eachField(function(field, index) {
                if (index>0 && index<14) {
                    var $th = $('<th>').text(field.title).width(field.width).appendTo($tr);
                    if (grid.sorting && field.sorting) {
                        $th.on('click', function() {
                            grid.sort(index);
                        });
                    }
                }
            });

            return $result.add($tr);
        },
        controller : {
            loadData : function() {
                var d = $.Deferred();
                $.ajax({
                    type : 'GET',
                    url : '/work/getAttendanceList.json',
                    dataType : 'json',
                    data : {
                        'year' : $('#year option:selected').val(),
                        'month' : $('#month option:selected').val()
                    }
                }).done(function(response) {
                    $.LOGGER.debug('#addListGrid controller loadData', response);

                    if (!response.success) {
                        alert('조회시 오류가 발생하였습니다.\n\n' + response.message);
                        return;
                    }

                    d.resolve(response.storeData);
                    $('#yearMonth').html($('#year option:selected').text() + '년'+ ' ' + $('#month option:selected').text()+ '월 ');
                });
                return d.promise();
            }
        },
        fields:  [
            { title: '구분', name: 'DATE', type: 'text', align: 'center'  ,width: '9%'},
            { title: '평일연장', name: 'COL1', type: 'number', align: 'center'  ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '휴일연장', name: 'COL2', type: 'number', align: 'center'  ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '야간근무 ', name: 'COL3', type: 'number', align: 'center' ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '휴일근무', name: 'COL4', type: 'number', align: 'center'  ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '명절특근', name: 'COL0', type: 'number', align: 'center'   ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '교육수당', name: 'COL11', type: 'number', align: 'center' ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '당직', name: 'COL12', type: 'number', align: 'center' ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '사용휴가', name: 'COL5', type: 'number', align: 'center'  ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '보상휴가', name: 'COL14', type: 'number', align: 'center'  ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '보건휴가', name: 'COL6', type: 'number', align: 'center' ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '하계휴가', name: 'C0140', type: 'number', align: 'center'  ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '공가', name: 'COL13', type: 'number', align: 'center'   ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            },
            { title: '결근', name: 'COL7', type: 'number', align: 'center' ,width: '7%',
              itemTemplate : function(value) {
                  return (value == 0) ? '' : value;
              }
            }
        ]
    });

    // 근태 실적조회 합계
    $('#attendanceList').jsGrid({
        height: 'auto',
        width: '100%',
        paging: false,
        autoload : true,
        onDataLoaded : function(args) {
            var rows = args.grid.data;
            var total_price = 0;
            var total_price1 = 0;
            var total_price2 = 0;
            var total_price3 = 0;
            var total_price4 = 0;
            var total_price5 = 0;
            var total_price6 = 0;
            var total_price7 = 0;
            var total_price8 = 0;
            var total_price9 = 0;
            var total_price10 = 0;
            var total_price11 = 0;
            var total_price12 = 0;

            for (row in rows) {
                curRow = rows[row];
                total_price  += parseFloat(curRow.COL1.format());
                total_price1 += parseFloat(curRow.COL2.format());
                total_price2 += parseFloat(curRow.COL3.format());
                total_price3 += parseFloat(curRow.COL4.format());
                total_price4 += parseFloat(curRow.COL0.format());
                total_price5 += parseFloat(curRow.COL11.format());
                total_price6 += parseFloat(curRow.COL12.format());
                total_price7 += parseFloat(curRow.COL5.format());
                total_price8 += parseFloat(curRow.COL6.format());
                total_price9 += parseFloat(curRow.C0140.format());
                total_price10 += parseFloat(curRow.COL13.format());
                total_price11 += parseFloat(curRow.COL7.format());
                total_price12 += parseFloat(curRow.COL14.format());
            };
            $('#TOTAL').html(parseFloat(total_price).toFixed(1));
            $('#TOTAL1').html(parseFloat(total_price1).toFixed(1));
            $('#TOTAL2').html(parseFloat(total_price2).toFixed(1));
            $('#TOTAL3').html(parseFloat(total_price3).toFixed(1));
            $('#TOTAL4').html(parseFloat(total_price4).toFixed(1));
            $('#TOTAL5').html(parseFloat(total_price5).toFixed(1));
            $('#TOTAL6').html(parseFloat(total_price6).toFixed(1));
            $('#TOTAL7').html(parseFloat(total_price7).toFixed(1));
            $('#TOTAL8').html(parseFloat(total_price12).toFixed(1));
            $('#TOTAL9').html(parseFloat(total_price8).toFixed(1));
            $('#TOTAL10').html(parseFloat(total_price9).toFixed(1));
            $('#TOTAL11').html(parseFloat(total_price10).toFixed(1));
            $('#TOTAL12').html(parseFloat(total_price11).toFixed(1));
            $('#TOTAL13').html(parseFloat(total_price11).toFixed(1));
        },
        controller : {
            loadData : function() {
                var d = $.Deferred();
                $.ajax({
                    type : 'GET',
                    url : '/work/getAttendanceList.json',
                    dataType : 'json',
                    data : {
                        'year' : $('#year option:selected').val(),
                        'month' : $('#month option:selected').val()
                    }
                }).done(function(response) {
                    $.LOGGER.debug('#attendanceList controller loadData', response);

                    if (!response.success) {
                        alert('조회시 오류가 발생하였습니다.\n\n' + response.message);
                        return;
                    }

                    d.resolve(response.storeData);
                });
                return d.promise();
            }
        }
    });
});

// 근태실적정보 조회
$('.icoSearch').click(function() {
    if ($('#year').val() == '2004' && ($('#month').val() == '1' || $('#month').val() == '2')) {
        alert('근태 실적정보는 2004년 3월부터 조회 가능합니다.');
        return;
    } else {
        $('#attendanceList').jsGrid('search');
        $('#addListGrid').jsGrid('search');
    }
});

// 초과근무 신청시 초과근무일 체크
function getAttWorkCode() {

    $.ajax({
        url: '/work/getAttWorkCode.json',
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
                $('#attForm select').attr('disabled', true);
                $('#attForm input').attr({disabled: true, readonly: true});
                $('#attForm input[name=WORK_DATE]').attr({disabled: false, readonly: false});//초과근무일
                $('#attForm select[name=OVTM_CODE]').attr('disabled', false);//신청사유코드
                alert('초과근무일에 근무일정이 존재합니다.');
            } else {
                $('#inputFlag').val('Y');
                $('select').attr('disabled',false);
                $('input').attr({disabled: false, readonly: false});
                $('.jsInputSearch').attr({disabled: true, readonly: true});
                $('#BEGDA').attr('readonly' ,true);
                $('#STDAZ').attr('readonly' ,true);
            }
        }
    });
};

// 교육/출장 신청사유코드
$('#eduForm input[name="AWART"]').change(getEduWorkCode);

function getEduWorkCode() {
	
	var checkedAwart = $('#eduForm :radio[name="AWART"]:checked').val();
	var tabF01 = $('#TAB_F01').val();
	
	if(tabF01 == 'Y' && (checkedAwart == '0010' || checkedAwart == '0011')) {
		$('#inputTimeArea').show();
	} else {
		$('#inputTimeArea').hide();
	}

    $.ajax({
        url : '/work/getEduWorkCode.json',
        data : {
            'AWART' : checkedAwart,
            'PERNR' : $('#PERNR').val()
        },
        dataType : 'json',
        type: 'POST',
        cache : false,
        async : false,
        success : function(response) {
            $.LOGGER.debug('getEduWorkCode', response);

            if (!response.success) {
                alert('신청사유코드 조회시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            setEduCodeOption(response.storeData);
        }
    });
};

function setEduCodeOption(jsonData) {

    $('#OVTM_CODES').empty();
    $('#OVTM_CODES').append('<option value="">-------------</option>');
    $.each(jsonData, function (key, value) {
         $('#OVTM_CODES').append('<option value="' + value.SCODE + '">' + value.STEXT + '</option>');
    });
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

function cal_time(time1, time2) {

    var tmp_HH1  = 0;//이것이 문제다....
    var tmp_MM1  = 0;
    var tmp_HH2  = 0;
    var tmp_MM2  = 0;
    if (time1.length == 4) {
        tmp_HH1 = time1.substring(0,2);
        tmp_MM1 = time1.substring(2,4);
    } else if (time1.length == 3) {
        tmp_HH1 = time1.substring(0,1);
        tmp_MM1 = time1.substring(1,3);
    }
    if (time2.length == 4) {
        tmp_HH2 = time2.substring(0,2);
        tmp_MM2 = time2.substring(2,4);
    } else if (time2.length == 3) {
        tmp_HH2 = time2.substring(0,1);
        tmp_MM2 = time2.substring(1,3);
    }

    var tmp_hour = tmp_HH2-tmp_HH1;
    var tmp_min  = tmp_MM2-tmp_MM1;
    var interval_time = 0;

    if (tmp_hour < 0) {
        tmp_hour = 24+tmp_hour;
    }
    if (tmp_min >= 0) {
        tmp_min = banolim((tmp_min/60), 2);
    } else {
        tmp_hour = tmp_hour - 1;
        tmp_min  = banolim((60 + tmp_min)/60, 2);
    }
    interval_time = tmp_hour+tmp_min+'';
    return interval_time;
}

//메인시간 계산용(총 초과 근무시간 계산용)
function cal_time2(time1, time2) {

    if (!time1 || !time2) return 0;

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

/**
 *  1. 前日 근태에 포함 체크  ==> flag
 *  2. 각 필드의 형식 첵크 날짜 타입이 맞는지 시간 타입이 맞는지 첵크
 *  3. 형식 check와 동시에 해당 필드 특성에 맞게 값 변환 ex) 00:00 ==> 24:00
 *  4. 시간필드 colon제거 : 계산하기 위해 ':' 제거와 초 '00'을 같이 제거
 *  5. 필수 입력사항 첵크  초과근무 일자, 초과근무 시작시간, 종료시간
 *  6. 前日 근태에 포함 타입에 맞는 시간 인지를 첵크
 *  7. 휴게시간이 초과 근무 시간 내에 있는지를 첵크
 *  8. 휴게 시작시간 종료시간이 다 있는지를 첵크 단 (00:00 ~ 00:00 은 '' ''로 변환)
 *  9. 휴게시간 무결성 첵크
 * 10. 휴게시간 계산
 * 11. 공란 제거(필드 이동)
 * 12. 다시 화면에 보일수 있는 형식으로 변환 addColon(text) 및 화면에 보임
**/
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

    if ($('#attForm #TPGUB').val() === 'C') return true;

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
            alert('휴게시간 설정이 잘못되었습니다.');
            PEND1STDT.not('[readonly]').focus();
            return false;
        }
    }

    // 휴게시간 2
    if (PBEG2 && PEND2) {
        D_PBEG2 = (BEGUZ <= PBEG2 ? '1' : '2') + PBEG2;
        D_PEND2 = (BEGUZ <= PEND2 ? '1' : '2') + PEND2;

        // 시간여부 첵크
        if (D_PBEG2 > D_PEND2) {
            alert('휴게시간 설정이 잘못되었습니다.');
            PEND2STDT.not('[readonly]').focus();
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
            alert('휴게시간 설정이 잘못되었습니다.');
            PBEG1STDT.not('[readonly]').focus();
            return false;
        }
    }
    // 휴게시간 계산  //잘못된 값 억제..
    var tmpSTDAZ = cal_time2(BEGUZ, ENDUZ) + '';

    if (PBEG1 && PEND1) {
        if (!PUNB1 && !PBEZ1) {
            PUNB1 = cal_time(PBEG1, PEND1);
            PBEZ1 = '';
        }
        if (PUNB1 && !PBEZ1) {
            var MAX = Number(cal_time(PBEG1, PEND1));
            if (PUNB1 > MAX) {
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
            if (PUNB2 > MAX) {
                alert('최대 입력값은 '+ MAX +' 입니다.');
                $('#PUNB2').focus().select();
                return false;
            }
        }
        if (PUNB2 && PBEZ2) {
            var MAX = Number(cal_time(PBEG2, PEND2));
            if (Number(PUNB2)+ Number (PBEZ2) > MAX) {
                alert('최대 입력값은 '+ MAX +' 입니다.');
                $('#PUNB2').focus().select();
                return false;
            }
        }
        if (!PUNB2 && PBEZ2) {
            var MAX = Number(cal_time(PBEG2, PEND2));
            if (Number (PBEZ2) > MAX) {
              alert('최대 입력값은 '+ MAX +' 입니다.');
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
    $('#CHKLMT').val(isLimitCheck ? 'X' : '');
    $('#CHGDAT').val(dateChanged ? 'X' : '');

    $.ajax({
        url: '/work/getCheckOverTime.json',
        data: $('#attForm').serialize(),
        dataType: 'json',
        type: 'POST',
        async: false,
        cache: false,
        success: function(response) {
            $.LOGGER.debug('getCheckOverTime', response);

            $('#attForm #TPGUB').val(response.TPGUB);

            // 신청/결재 기한 기준 button
            setRequestOrApprovalDeadlineProperty({
                TPGUB: response.TPGUB,
                DATUM: $('#WORK_DATE').val()
            });

            checkOverTimeCallback({ // overtime.js
                response: response,
                isLimitCheck: isLimitCheck,
                dateChanged: dateChanged,
                wrapper: '.tab1'
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

    if (!checkNullField('attForm')) return false;

    var REASON = $('#REASON');
    if (!$.trim(REASON.val())) {
        alert('신청사유항목은 필수 입력사항입니다.');
        REASON.focus();
        return false;
    }

    if ($('#attForm #RowCount').val($('#decisionerGrid').jsGrid('dataCount')) < 1) {
        alert('결재자 정보가 없습니다.');
        return false;
    }

    return true;
}

// 초과근무 신청
function submitOverTime() {

    if (!isValidOverTimeForm() || !isValidTime(true) || !confirm('신청 하시겠습니까?')) return;

    $('.salBtn').prop('disabled', true);
    $('#attForm #RowCount').val($('#decisionerGrid').jsGrid('dataCount'));

    var param = $('#attForm').serializeArray();
    $('#decisionerGrid').jsGrid('serialize', param);

    $.ajax({
        type: 'POST',
        url: '/work/requestOverTime.json',
        cache: false,
        dataType: 'json',
        data: param,
        async: false,
        success: function(response) {
            $.LOGGER.debug('submitOverTime', response);

            if (!response.success) {
                alert('신청시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            alert(response.message);

            <%-- 시작 : [WorkTime52] 근무시간입력에서 popup으로 호출된 경우 popup 자동 닫기 --%>
            var calledAsPopup = '${fn:escapeXml( param.FROM_ESS_OFW_WORK_TIME )}';
            if (parent && calledAsPopup === 'Y') {
                parent.closeLayerPopup(true);
                return;
            }
            <%-- 종료 : [WorkTime52] 근무시간입력에서 popup으로 호출된 경우 popup 자동 닫기 --%>

            // 초기화
            $('#attForm')[0].reset();

            // TPGUB-C 또는 TPGUB-D 실근무시간 현황 표시 제어
            var table = $('.tab1 #otFormTable'), colgroup = table.find('> colgroup'), cols = colgroup.find('col'),
            TPGUB = '${fn:escapeXml( GUBUN_TPGUB )}', isTypeC = TPGUB === 'C', isTypeD = TPGUB === 'D';

            // 현황 표시
            if (isTypeC || isTypeD) {
                if (cols.length === 2) {
                    colgroup.append('<col>');
                    table.find('td.worktime-report')
                         .toggleClass(isTypeC ? 'type-c' : 'type-d', true)
                         .toggleClass(isTypeC ? 'type-d' : 'type-c', false)
                         .toggleClass('display-none', false);
                } else {
                    table.find('td.worktime-report')
                         .toggleClass(isTypeC ? 'type-c' : 'type-d', true)
                         .toggleClass(isTypeC ? 'type-d' : 'type-c', false);
                }
                renderRealWorktimeReport({TPGUB: TPGUB}, '.tab1');
            }
            // 현황 숨김
            else {
                if (cols.length === 3) {
                    cols.last().remove();
                    table.find('td.worktime-report')
                         .toggleClass('type-c', false)
                         .toggleClass('type-d', false)
                         .toggleClass('display-none', true);
                }
            }

            // TPGUB-C 기타 화면 제어
            if (isTypeC) {
                $('.tab1 .bottom-filler').toggleClass('type-c', true).toggleClass('type-d', false);
                $('.tab1 .type-c').show();
                $('.tab1 #BEGUZEDDT').attr('data-mimic', '');
                $('.tab1 #ENDUZEDDT').attr('data-mimic', '');
                if ($('.tab1 #PBEG1STDT').is('select')) {
                    $('.tab1 #breaktimeTable tbody').html($('.tab1 #cTypeCloneTemplate').html().replace(/eid/g, 'id'));
                }
            } else {
                $('.tab1 .bottom-filler').toggleClass('type-c', false).toggleClass('type-d', isTypeD);
                $('.tab1 .type-c').hide();
                $('.tab1 .type-d')[isTypeD ? 'show' : 'hide']();
                $('.tab1 #BEGUZEDDT').removeAttr('data-mimic');
                $('.tab1 #ENDUZEDDT').removeAttr('data-mimic');
                if ($('.tab1 #PBEG1STDT').is('input')) {
                    $('.tab1 #breaktimeTable tbody').html($('.tab1 #oTypeCloneTemplate').html().replace(/oid/g, 'id'));
                }
            }
        }
    })
    .always(function() {
        $('.salBtn').prop('disabled', false);
    });
}

// 초과근무 사후신청
function submitAfterOverTime() {

    var PICKED_DATE = $('.tab2 input[name="PICKED_DATE"]');
    if (!$.trim(PICKED_DATE.val())) {
        alert('초과근무일을 선택하세요.');
        PICKED_DATE.focus();
        return;
    }
    if (/^\d{4}\.\d{2}\.\d{2}$/.test(PICKED_DATE)) {
        alert('초과근무일 형식 오류입니다.\n"#" 형식으로 입력하세요.'.replace(/#/, moment().format('YYYY.MM.DD')));
        PICKED_DATE.focus();
        return;
    }

    var radios = $('.tab2 input[type="radio"]:not(:disabled)');
    if (!radios.length) {
        alert('선택하신 초과근무일(#)에 유효한 신청유형이 없습니다.'.replace(/#/, PICKED_DATE.val()));
        return;
    }
    if (!$('.tab2 input[type="radio"]:checked').length) {
        alert('신청유형을 선택하세요.');
        return;
    }

    var OVTM_CODE = $('.tab2 select[name="OVTM_CODE"]');
    if (!OVTM_CODE.val()) {
        alert('신청사유항목은 필수 입력사항입니다.');
        OVTM_CODE.focus();
        return;
    }
    var REASON = $('.tab2 input[name="REASON"]');
    if (!$.trim(REASON.val())) {
        alert('신청사유항목은 필수 입력사항입니다.');
        REASON.focus();
        return;
    }

    if (!confirm('신청 하시겠습니까?')) return;

    $('.tab2 .salBtn').prop('disabled', true);

    var param = $('#afterOT').serializeArray(), VTKEN = $('.tab2 input[name="VTKEN"]');
    if (VTKEN.prop('checked')) {
        param.push({name: 'VTKEN', value: 'X'});
    }
    $('#afterOTDecisionerGrid').jsGrid('serialize', param);

    $.ajax({
        url: '/work/requestAfterOverTime.json',
        data: param,
        dataType: 'json',
        type: 'POST',
        cache: false,
        async: false,
        success: function(response) {
            $.LOGGER.debug('submitAfterOverTime', response);

            if (!response.success) {
                alert('신청시 오류가 발생하였습니다.\n\n' + response.message);
                return;
            }

            alert(response.message);

            <%-- 시작 : [WorkTime52] 근무시간입력에서 popup으로 호출된 경우 popup 자동 닫기 --%>
            var calledAsPopup = '${fn:escapeXml( param.FROM_ESS_OFW_WORK_TIME )}';
            if (parent && calledAsPopup === 'Y') {
                parent.closeLayerPopup(true);
                return;
            }
            <%-- 종료 : [WorkTime52] 근무시간입력에서 popup으로 호출된 경우 popup 자동 닫기 --%>

            // 초기화
            $('.tab2 input[name="BEGDA"]').val(moment().format('YYYY.MM.DD'));
            $('.tab2 input[name="PICKED_DATE"]').val('');
            resetAfterOTData();
        }
    })
    .always(function() {
        $('.salBtn').prop('disabled', false);
    });
}

function resetAfterOTData() {

    $('.tab2 [data-reset]').each(function() {
        var t = $(this);
        $.each(t.data('reset').split(','), function(i, v) {
                 if (v === 'value')    t.val(t.data('resetValue') || '');
            else if (v === 'text')     t.text(t.data('resetText') || '');
            else if (v === 'checked')  t.prop(v, t.data('resetChecked'));
            else if (v === 'disabled') t.prop(v, t.data('resetDisabled'));
            else if (v === 'display')  t.css(v, t.data('resetDisplay'));
        });
    });
}

/**
 * 초과근무 사후신청에서 일자 선택시
 * 해당 일자의 실근무시간 및 OT신청가능 시간과 일자가 속한 월 또는 주의 실근무시간 현황을 조회한다.
 */
function getWorkTimeData() {

    var PICKED_DATE = $('.tab2 input[name="PICKED_DATE"]'), vPICKED_DATE = PICKED_DATE.val();
    if (!vPICKED_DATE) {
        alert('초과근무일을 선택하세요.');
        PICKED_DATE.focus();
        return;
    }
    if (!/^\d{4}\.\d{2}\.\d{2}$/.test(vPICKED_DATE)) {
        alert('초과근무일을 "' + moment().format('YYYY.MM.DD') + '" 형식으로 입력하세요.');
        PICKED_DATE.focus();
        return;
    }

    var dateChk = vPICKED_DATE.replace(/[^\d]/g, '');
    if (dateChk < '20040301') {
        alert('2004년 03월 01일부터 초과근무 신청이 가능합니다.');
        PICKED_DATE.focus();
        return;
    }
    if (dateChk < '${D_RRDAT}') {
        alert('초과근무는 ${E_RRDAT}일 이후에만 신청이 가능합니다.');
        PICKED_DATE.select();
        return;
    }
    var selectedDate = moment(dateChk, 'YYYYMMDD');
    if (selectedDate.isSameOrAfter(moment().startOf('date'))) {
        alert(vPICKED_DATE + ' 일자의 초과근무 사후신청은 익일(' + selectedDate.add(1, 'days').format('YYYY.MM.DD') + ')부터 가능합니다.');
        PICKED_DATE.val('').focus();
        return;
    }

    $.ajax({
        url: '/work/getWorkTimeData.json',
        data: {
            WORK_DATE: vPICKED_DATE
        },
        dataType: 'json',
        type: 'POST',
        success: function(response) {
            $.LOGGER.debug('getWorkTimeData', response);

            if (!response.success) {
                if (response.code === 'SHIFT') {
                    PICKED_DATE.val('');
                    alert('교대조 직원은 공휴일에 초과근무를 신청하실 수 없습니다.\n담당부서에 문의하시기 바랍니다.');
                } else {
                    alert('초과근무일 근무시간 현황 조회중 오류가 발생하였습니다.\n\n' + response.message);
                }
                return;
            }

            resetAfterOTData();

            // 실근무시간 현황
            renderRealWorktimeReport(response.reportData || {}, '.tab2');

            // 선택일자 실근무시간
            renderAfterOvertimeData($.extend(response.worktimeData || {}, {RQDAT: vPICKED_DATE}), '.tab2');
        }
    });
}

//교육/출장 신청 관련 validation
function EduClientCheck() {

    if (!checkNullField('eduForm')) return false;

    if (!checkdate($('#inputDateFrom'))) {
        $('#inputDateFrom').focus();
        return false;
    }
    if (!checkdate($('#inputDateTo'))) {
        $('#inputDateTo').focus();
        return false;
    }

    var date_from = $('#inputDateFrom').val().replace(/\./g,'');
    var date_to = $('#inputDateTo').val().replace(/\./g,'');
    var reason = $('#REASONS').val();

    if (date_from > date_to) {
        alert('신청시작일이 신청종료일보다 큽니다.');
        return false;
    }

    if ($('#REASONS').val()=='') {
        alert('신청사유항목은 필수 입력사항입니다.');
        $('#REASONS').focus();
        return false;
    }

    if (checkLength(reason) > 80) {
        alert('신청사유는 한글 40자, 영문 80자 이내여야 합니다.');
        return false;
    }
    if ($('#eduForm #RowCount').val($('#edudecisionerGrid').jsGrid('dataCount')) < 1) {
        alert('결재자 정보가 없습니다.');
        return false;
    }

     return true;
}

// 교육/출장 신청
function EduClient(self) {

    if (!EduClientCheck()) return;

    // 자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
    edudecisionerGridChangeAppLine(self);

    var msg = self ? '자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n' : '';
    if (confirm(msg + '신청 하시겠습니까?')) {
        $('#eduBtn').prop('disabled', true);
        $('#requestNapprovalBtn').prop('disabled', true);
        $('#eduForm #RowCount').val($('#edudecisionerGrid').jsGrid('dataCount'));
        var param = $('#eduForm').serializeArray();
        $('#edudecisionerGrid').jsGrid('serialize', param);
        param.push({'name':'selfAppr', 'value' : self});
        $.ajax({
            type : 'POST',
            url : '/work/requestOfficialWork.json',
            cache : false,
            dataType : 'json',
            data : param,
            async :false,
            success : function(response) {
                $.LOGGER.debug('EduClient', response);

                if (response.success) {
                    alert('신청 되었습니다.');

                    // 초기화
                    $('#eduForm')[0].reset();
                    $('#eduGridList').jsGrid('search');
                } else {
                    alert('신청시 오류가 발생하였습니다. ' + response.message);
                }
                $('#eduBtn').prop('disabled', false);
                $('#requestNapprovalBtn').prop('disabled', false);
            }
        });
    } else {
        edudecisionerGridChangeAppLine(false);
    }
}

$(document).ready(function() {

    $attCancelHtml = $('#attCancelDiv').html();

    $('#decisioner').load('/common/getDecisionerGrid?upmuType=17&gridDivId=decisionerGrid');
    $('#afterOTDecisioner').load('/common/getDecisionerGrid?upmuType=47&gridDivId=afterOTDecisionerGrid');
    $('#edudecisioner').load('/common/getDecisionerGrid?upmuType=40&gridDivId=edudecisionerGrid');
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
    $('#WORK_DATE').change(function() { // 초과근무 신청 관련 초과근무일 변경시 체크

        var WORK_DATE = $('#WORK_DATE'), vWORK_DATE = WORK_DATE.val();
        if (!vWORK_DATE) return false;

        var dateChk = vWORK_DATE.replace(/\./g, '');

        if (dateChk < '20040301') {
            alert('2004년 03월 01일부터 초과근무 신청이 가능합니다.');
            WORK_DATE.focus();
            return false;
        }

        if (dateChk < '${D_RRDAT}') {
            alert('초과근무는 ${E_RRDAT}일 이후에만 신청이 가능합니다.');
            WORK_DATE.select();
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

    $('#requestNapprovalBtn').click(function() { EduClient(true); }); // 자가승인 클릭시(팀장 이상만)
    $('#inputDateFrom').change(function() { // 교육/출장 신청 관련 신청기간 변경시 체크

        if ($('#inputDateFrom').val() != '') {
            var dateChk = $('#inputDateFrom').val().replace(/\./g,'');
            if (dateChk < '${D_RRDAT}') {
                 alert('교육/출장은 ${E_RRDAT}일 이후에만 신청이 가능합니다.');
                 $('#inputDateFrom').focus();
                 return false;
            }
        }
    });

    $('#I_UPMU_TYPE').change($changeUPMU_TYPE); // 취소신청 업무구분
    $('#attCancelSearchBtn').click(function() {
        $('#attCancelGrid').jsGrid('search');  // 취소신청 조회
    });

    $('#tab3').click(function() { // 교육/출장 신청
    	getEduWorkCode();
    });
    $('#tab4').click(function() { // 근무취소신청
        $attCancelGrid();
        $('#attCancelSearchBtn').click();
    });
    $('#tab6').click(function() { // 레포트
    	document.getElementById("listFrame").contentWindow.refreshReport();
    	switchTabs(this);
    });

    setZOVTYPClickEvent('.tab2');<%-- /worktime52/overtime.js --%>

    $('.tab2 input[name="PICKED_DATE"]').change(getWorkTimeData);

    $('.span-look').focus(function() {
        this.blur();
    });

    switchTabs($('.tabArea ul.tab li a.selected')[0]);
});
</script>
<!--// script end -->