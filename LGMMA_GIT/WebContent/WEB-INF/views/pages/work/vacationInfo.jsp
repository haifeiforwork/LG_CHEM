<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.DateTime"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="hris.D.D03Vocation.D03RemainVocationData"%>
<%@ page import="hris.D.D03Vocation.D03VocationReasonData"%>
<%@ page import="hris.D.D03Vocation.rfc.D03VocationAReasonRFC"%>
<%@ page import="hris.E.E19Congra.rfc.E19CongCodeRFC"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    WebUserData userData = (WebUserData) session.getAttribute("user");
    D03RemainVocationData dataRemain = (D03RemainVocationData) request.getAttribute("d03RemainVocationData");

    Vector CodeEntity_vt = new Vector();
    int endYear = DateTime.getYear();
    for (int i = endYear - 9; i <= endYear + 1; i++) {
        CodeEntity_vt.addElement(new CodeEntity(Integer.toString(i), Integer.toString(i)));
    }
%>
<c:if test="${param.FROM_ESS_OFW_WORK_TIME ne 'Y'}">
<!--// Page Title start -->
<div class="title">
    <h1>휴가</h1>
    <div class="titleRight">
        <ul class="pageLocation">
            <li><span><a href="#">Home</a></span></li>
            <li><span><a href="#">My Info</a></span></li>
            <li><span><a href="#">근태</a></span></li>
            <li class="lastLocation"><span><a href="#">휴가</a></span></li>
        </ul>
    </div>
</div>
<!--// Page Title end -->
</c:if>

<!--// Tab start -->
<div class="tabArea">
    <ul class="tab">
        <li><a href="#" id="tab1" onclick="switchTabs(this)" class="selected">휴가신청</a></li>
        <li><a href="#" id="tab2" onclick="switchTabs(this)">휴가취소신청</a></li>
        <li><a href="#" id="tab3" onclick="switchTabs(this)">휴가실적조회</a></li>
        <c:if test="${E_AUTH eq 'Y'}">
        <li><a href="#" id="tab4" onclick="switchTabs(this)">보상휴가 발생내역</a></li>
        </c:if>
    </ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
<%@ include file="include/vacationInfoTab1.jsp" %>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
<%@ include file="include/vacationInfoTab2.jsp" %>
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 Lnodisplay">
<%@ include file="include/vacationInfoTab3.jsp" %>
</div>
<!-- Tab3 end -->

<c:if test="${E_AUTH eq 'Y'}">
<!--// Tab4 start -->
<div class="tabUnder tab4 Lnodisplay">
<%@ include file="include/vacationInfoTab4.jsp" %>
</div>
<!-- Tab4 end -->
</c:if>

<!-- popup : 월별 계획근무일정 start -->
<div class="layerWrapper layerSizeP" id="popLayerSchedule" style="display:none;">
    <div class="layerHeader">
        <strong>월별 계획근무일정</strong>
        <a href="#" class="btnClose popLayerSchedule_close">창닫기</a>
    </div>
    <iframe name="schedulePopup" id="schedulePopup" src="" frameborder="0" scrolling="no" style="width:100%;height:500px;"></iframe>
</div>
<!-- popup : 월별 계획근무일정 end -->

<!-- popup 경조금 조회 start -->
<!-- // 대상자선택 popup -->
<div class="layerWrapper layerSizeP" id="popLayerEventMoneyList">
    <div class="layerHeader">
        <strong>대상자 선택</strong>
        <a href="#" class="btnClose popLayerEventMoneyList_close">창닫기</a>
    </div>
    <div class="layerContainer">
        <div class="layerContent">
            <form id="contactForm">
                <div class="tableArea tablePopup">
                    <!-- // 가족사항 grid -->
                    <div id="eventMoneyGrid" ></div>
                </div>
                <div class="buttonArea buttonCenter">
                    <ul class="btn_crud">
                        <li><a class="darken" href="#" id="popLayerEventMoneyListSave"><span>확인</span></a></li>
                        <li><a href="#" id="popLayerEventMoneyListCansel"><span>취소</span></a></li>
                    </ul>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- popup 경조금 조회 end -->

<!-- popup 업무재개시간 목록 테이블 start -->
<div class="layerWrapper layerSizeML" id="extratimeList" style="display:none">
    <div class="layerHeader">
        <strong>업무재개시간 조회</strong>
        <a href="#" class="btnClose" data-name="extratimeClose">창닫기</a>
    </div>
    <div class="layerContainer">
        <div class="layerContent">
            <div class="listArea" style="padding-bottom:0">
                <div class="table">
                    <table class="listTable worktime breaktime-table">
                        <colgroup>
                            <col style="width:25%" />
                            <col style="width:25%" />
                            <col style="width:50%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>업무 시작</th>
                                <th>업무 종료</th>
                                <th>사유</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td data-name="ABEGUZ">-</td>
                                <td data-name="AENDUZ">-</td>
                                <td data-name="DESCR" class="align-left" style="padding:0 8px">-</td>
                            </tr>
                            <tr>
                                <td data-name="ABEGUZ">-</td>
                                <td data-name="AENDUZ">-</td>
                                <td data-name="DESCR" class="align-left" style="padding:0 8px">-</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- popup 업무재개시간 목록 테이블 end -->

<%@include file="/WEB-INF/views/tiles/template/javascriptWorkTime.jsp"%>
<script type="text/javascript" src="/web-resource/js/worktime52/common.js?v=${CACHE_VERSION}"></script>
<script type="text/javascript" src="/web-resource/js/worktime52/comptime.js?v=${CACHE_VERSION}"></script>
<script type="text/javascript">
$cancelSearch = function() {
    $("#attCancelGrid").jsGrid("search");
    $("#attCancelDiv").html($attCancelHtml);
    $("#cancelDiv, #cancelDecisioner, #cancelBtnDiv").hide();
}

$attCancelGrid = function() {
    $("#attCancelGrid").jsGrid({
        height : "auto",
         width : "100%",
         sorting : true,
         paging : true,
         autoload : false,
         controller : {
             loadData : function() {
                 var d = $.Deferred();
                 $.ajax({
                     type : "GET",
                     url : "/work/getAttCancelList.json",
                     dataType : "json",
                     data : {
                         "I_UPMU_TYPE" : "18",
                         "I_TBEGDA" : $("#I_TBEGDA").val(),
                         "I_TENDDA" : $("#I_TENDDA").val()
                     }
                 }).done(function(response) {
                     if (response.success) {
                         d.resolve(response.storeData);
                     } else {
                         alert("조회시 오류가 발생하였습니다.\n\n" + response.message);
                     }
                 });
                 return d.promise();
             }
         },
         fields: [
             {title: "선택", name: "th1", align: "center", width: "6%",
                 itemTemplate: function(_, item) {
                     return $("<input type='radio' name='cnRa'>")
                         .on("click", function(e) {$searchCancelDetail(item.CANC_STAT,item.AINF_SEQN, item.UPMU_TYPE, item.CAIN_SEQN);});
                 }
             },
             { title: "No.", name: "ROWNUMBER", type: "text", align: "center", width: "10%", sorting: false,
                 itemTemplate: function(value, item) {
                     return $("#attCancelGrid").jsGrid("option", "data").indexOf(item) + 1;
                 }
             },
             { title: "신청일", name: "BEGDA", type: "text", align: "center", width: "20%" },
             { title: "업무구분", name: "UPMU_NAME", type: "text", align: "center", width: "20%" },
             { title: "휴가일", name: "TBEGDA", type: "text", align: "center", width: "24%",
                 itemTemplate: function(value, item) { return item.TBEGDA + " ~ " + item.TENDDA; }
             },
             { title: "취소신청여부", name: "CANC_NAME", type: "text", align: "center", width: "20%" }
         ]
    });
}

$ainf_seqn = "";
$upmu_type = "";
$searchCancelDetail = function(CANC_STAT, AINF_SEQN, UPMU_TYPE, CAIN_SEQN) {
    $.each($(".popup_wrapper"), function(i, popup) { // 기존 팝업레이어를 지운다. 이렇게 안하면 .popup_wrapper div 가 계속 생성된다.
        if (popup.id != "popLayerHrStaff_wrapper")
            $("#" + popup.id).detach();
    });

    $ainf_seqn = AINF_SEQN;
    $upmu_type = UPMU_TYPE;

    //상세조회
    $.ajax({
        type : "get",
        url : "/appl/getVacationDetail.json",
        dataType : "json",
        data : {AINF_SEQN: AINF_SEQN},
        async :false
    }).done(function(response) {
        if (response.success) {
            var eAuth = response.eAuth,
            iMode = response.iMode,
            vacationData = response.storeData,
            remainData = response.d03RemainVocationData,
            vacationType;

            if (eAuth == 'Y') {
                var vocaTypeTxt = (vacationData.AWART == '0111' || vacationData.AWART == '0112' || vacationData.AWART == '0113') ? '보상휴가' : '휴가(연차,경조,공가 등)';
                $('[name=cancelVocaTypeTxt]').text(vocaTypeTxt);
                $('#cancelVocaType').show();

                var E_REMAIN = remainData.E_REMAIN == 0 ? 0 : parseFloat(remainData.E_REMAIN).toFixed(2);
                var VACATION = remainData.VACATION == 0 ? 0 : parseFloat(remainData.VACATION).toFixed(1);
                if (iMode == 'A') {
                    $('#cancelRemainTxt').text(E_REMAIN + "/" + VACATION + " 일");
                } else {
                    $('#cancelRemainTxt').text(E_REMAIN + "일" + remainData.ZKVRBTX);
                }
            } else {
                var P_REMAIN = remainData.P_REMAIN == 0 ? 0 : parseFloat(remainData.P_REMAIN).toFixed(2);
                var P_VACATION = remainData.P_VACATION == 0 ? 0 : parseFloat(remainData.P_VACATION).toFixed(1);
                $('#cancelRemainTxt').text(P_REMAIN + "/" + P_VACATION + " 일");
            }

            $.ajax({
                type : "get",
                url : "/work/getVacationTypeList.json",
                dataType : "json",
                async :false
            }).done(function(response) {
                if (response.success) vacationType = response.storeData;
            });
            var arr = $.makeArray({"AWART":vacationType});
            setTableText(vacationData, "attCancelDiv", arr);

            if (vacationData.AWART == "0130") {// 경조공가
                if (vacationData.CONG_CODE!="") {
                    var codeList = getCongCode();
                    $.each(codeList, function(i, codes) {
                        if (codes.code == vacationData.OVTM_CODE) {
                            $("#c_ovtm_code").html(codes.value);
                            return false;
                        }
                    });
                }
            } else if (vacationData.AWART == "0170" || vacationData.AWART == "0180") {// 전일공가 시간공가
                if (vacationData.OVTM_CODE!="") {
                    var codeList = getEduWorkCode(vacationData.AWART);
                    $.each(codeList, function(i, codes) {
                        if (codes.SCODE == vacationData.OVTM_CODE) {
                            $("#c_ovtm_code").html(codes.value);
                            return false;
                        }
                    });
                }
            }
        } else {
            alert("상세정보 조회시 오류가 발생하였습니다.\n\n" + response.message);
        }
    });

    //CANC_STAT 취소신청가능
    if (CANC_STAT == "01") {
        $('#cancelDecisioner').load('/common/getDecisionerGrid?upmuType=' + UPMU_TYPE + '&gridDivId=cancelDecisionerGrid');
        $("#cancelDiv, #cancelDecisioner, #cancelBtnDiv").show();
    } else {
        $("#cancelDiv, #cancelDecisioner, #cancelBtnDiv").hide();
    }

    $("html,body").animate({
        scrollTop: $("#attCancelDiv").offset().top
    });
}

var getEduWorkCode = function(AWART) {
    var result = null;
     $.ajax({
         type : 'POST',
         url : '/work/getEduWorkCode.json',
         cache : false,
         dataType : 'json',
         data : {
             AWART : AWART,
             PERNR : $("#PERNR").val()
         },
         async :false,
         success : function(response) {
             if (response.success) {
                 result = response.storeData;
             } else {
                 alert("신청사유코드 조회시 오류가 발생하였습니다.\n\n" + response.message);
             }
         }
     });
     return result;
 };

 var getCongCode = function(AWART) {
    var result = null;
     $.ajax({
         type : 'POST',
         url : '/work/getCongCode.json',
         cache : false,
         dataType : 'json',
         async :false,
         success : function(response) {
             if (response.success) {
                 result = response.storeData;
             } else {
                 alert("신청사유코드 조회시 오류가 발생하였습니다.\n\n" + response.message);
             }
         }
     });
     return result;
 };

$attCancelRequest = function(self) {
    if (!checkNullField("attCancelForm"))return;
    //자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
    var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
    cancelDecisionerGridChangeAppLine(self);
    if (!confirm(msg + "신청 하시겠습니까?")) {
        cancelDecisionerGridChangeAppLine(false);
        return;
    }
    var param = $("#attCancelForm").serializeArray();
    $("#cancelDecisionerGrid").jsGrid("serialize", param);
    param.push({name:"AINF_SEQN", value:$ainf_seqn});
    param.push({name:"UPMU_TYPE", value:$upmu_type});
    param.push({"name":"selfAppr", "value" : self});

    $.ajax({
        type : "get",
        url : "/work/requestCancel.json",
        dataType : "json",
        data : param,
        async : false
    }).done(function(response) {
        if (response.success) {
            alert("취소신청 되었습니다.");
            $cancelSearch();
        } else {
            alert("취소신청시 오류가 발생하였습니다.\n\n" + response.message);
        }
    });
}

var searchTab3 = function() {
    $.ajax({
        type : 'POST',
        url : '/work/getVacationList.json',
        cache : false,
        dataType : 'json',
        data : {
            year : $("#year option:selected").val()
        },
        async :false,
        success : function(response) {
            if (!response.success) {
                alert("휴가실적 조회시 오류가 발생하였습니다.\n\n" + response.message);
                return;
            }

            var eAuth = $('input[name=E_AUTH]').val();
            var nonAbsence = response.NON_ABSENCE;
            var longService = response.LONG_SERVICE;
            var flexible = response.FLEXIBLE;
            var comptime = response.COMPTIME;
            var compenCnt = response.COMPEN_CNT;
            var occurResult = response.OCCUR_RESULT;   // 발생내역
            var occurResult1 = response.OCCUR_RESULT1; // 사전부여 발생내역
            var occurResult2 = response.OCCUR_RESULT2; // 선택적보상 발생내역
            var occurResult3 = response.OCCUR_RESULT3; // 보상 발생내역
            var usedResult = response.USED_RESULT ;    // 사용내역
            var usedResult1 = response.USED_RESULT1;   // 사전부여 사용내역
            var usedResult2 = response.USED_RESULT2;   // 선택적보상 사용내역
            var usedResult3 = response.USED_RESULT3;   // 보상 사용내역()
            var usedResult4 = response.USED_RESULT4;   // 보상 사용내역(보상)
            var sWork = response.S_WORK;

            // 발생일수
            $("#BALSENG_ILSU").val(parseFloat(sWork.OCCUR).toFixed(2) + "  ");
            // 사용일수
            $("#ABRTG_SUM").val(parseFloat(sWork.ABWTG).toFixed(2) + "  ");
            // 잔여일수
            $("#JAN_ILSU").val(parseFloat(sWork.ZKVRB).toFixed(2) + "  ");

            $("#balSengListGrid").jsGrid( "insertItem", { th00 : "개근연차", th01 : "", th02 : "", th03 : "", th04 : "", th05 : "", th06 : "", th07 : "", th08 : "", th09 : "", th10 : "", th11 : "", th12 : "", th13 : nonAbsence.format() } );
            $("#balSengListGrid").jsGrid( "insertItem", { th00 : "근속연차", th01 : "", th02 : "", th03 : "", th04 : "", th05 : "", th06 : "", th07 : "", th08 : "", th09 : "", th10 : "", th11 : "", th12 : "", th13 : longService.format() } );
            // 보상휴가
            if (eAuth == 'Y') {
                $("#balSengListGrid").jsGrid("insertItem", {
                    th00 : "보상휴가",
                    th01 : (occurResult3.ANZHL01 == "" || occurResult3.ANZHL01 == "0") ? "" : parseFloat(occurResult3.ANZHL01).toFixed(2),
                    th02 : (occurResult3.ANZHL02 == "" || occurResult3.ANZHL02 == "0") ? "" : parseFloat(occurResult3.ANZHL02).toFixed(2),
                    th03 : (occurResult3.ANZHL03 == "" || occurResult3.ANZHL03 == "0") ? "" : parseFloat(occurResult3.ANZHL03).toFixed(2),
                    th04 : (occurResult3.ANZHL04 == "" || occurResult3.ANZHL04 == "0") ? "" : parseFloat(occurResult3.ANZHL04).toFixed(2),
                    th05 : (occurResult3.ANZHL05 == "" || occurResult3.ANZHL05 == "0") ? "" : parseFloat(occurResult3.ANZHL05).toFixed(2),
                    th06 : (occurResult3.ANZHL06 == "" || occurResult3.ANZHL06 == "0") ? "" : parseFloat(occurResult3.ANZHL06).toFixed(2),
                    th07 : (occurResult3.ANZHL07 == "" || occurResult3.ANZHL07 == "0") ? "" : parseFloat(occurResult3.ANZHL07).toFixed(2),
                    th08 : (occurResult3.ANZHL08 == "" || occurResult3.ANZHL08 == "0") ? "" : parseFloat(occurResult3.ANZHL08).toFixed(2),
                    th09 : (occurResult3.ANZHL09 == "" || occurResult3.ANZHL09 == "0") ? "" : parseFloat(occurResult3.ANZHL09).toFixed(2),
                    th10 : (occurResult3.ANZHL10 == "" || occurResult3.ANZHL10 == "0") ? "" : parseFloat(occurResult3.ANZHL10).toFixed(2),
                    th11 : (occurResult3.ANZHL11 == "" || occurResult3.ANZHL11 == "0") ? "" : parseFloat(occurResult3.ANZHL11).toFixed(2),
                    th12 : (occurResult3.ANZHL12 == "" || occurResult3.ANZHL12 == "0") ? "" : parseFloat(occurResult3.ANZHL12).toFixed(2),
                    th13 : (comptime == "" || comptime == "0") ? "0" : parseFloat(comptime).toFixed(2)
                });
            }
            $("#balSengListGrid").jsGrid( "insertItem", { th00 : "유연휴가", th01 : "", th02 : "", th03 : "", th04 : "", th05 : "", th06 : "", th07 : "", th08 : "", th09 : "", th10 : "", th11 : "", th12 : "", th13 : flexible.format() } );

            //휴가사용내역
            if (usedResult.ABRTG_SUM != null && usedResult.ABRTG_SUM != '') {
                $("#saYongListGrid").jsGrid("insertItem", {
                    th00 : (eAuth == 'Y') ? "연차휴가(사용)" : "연차",
                    th01 : usedResult.ABRTG01 == "0" ? "" : parseFloat(usedResult.ABRTG01).toFixed(2),
                    th02 : usedResult.ABRTG02 == "0" ? "" : parseFloat(usedResult.ABRTG02).toFixed(2),
                    th03 : usedResult.ABRTG03 == "0" ? "" : parseFloat(usedResult.ABRTG03).toFixed(2),
                    th04 : usedResult.ABRTG04 == "0" ? "" : parseFloat(usedResult.ABRTG04).toFixed(2),
                    th05 : usedResult.ABRTG05 == "0" ? "" : parseFloat(usedResult.ABRTG05).toFixed(2),
                    th06 : usedResult.ABRTG06 == "0" ? "" : parseFloat(usedResult.ABRTG06).toFixed(2),
                    th07 : usedResult.ABRTG07 == "0" ? "" : parseFloat(usedResult.ABRTG07).toFixed(2),
                    th08 : usedResult.ABRTG08 == "0" ? "" : parseFloat(usedResult.ABRTG08).toFixed(2),
                    th09 : usedResult.ABRTG09 == "0" ? "" : parseFloat(usedResult.ABRTG09).toFixed(2),
                    th10 : usedResult.ABRTG10 == "0" ? "" : parseFloat(usedResult.ABRTG10).toFixed(2),
                    th11 : usedResult.ABRTG11 == "0" ? "" : parseFloat(usedResult.ABRTG11).toFixed(2),
                    th12 : usedResult.ABRTG12 == "0" ? "" : parseFloat(usedResult.ABRTG12).toFixed(2),
                    th13 : parseFloat(usedResult.ABRTG_SUM).toFixed(2)
                });
            } else {
                $("#saYongListGrid").jsGrid("insertItem", {
                    th00 : (eAuth == 'Y') ? "연차휴가(사용)" : "연차", th01 : "", th02 : "", th03 : "", th04 : "", th05 : "", th06 : "", th07 : "", th08 : "", th09 : "", th10 : "", th11 : "", th12 : "", th13 : "0"
                });
            }

            var month ="00";
            var sum =0;
            var vacationTh01 = "";
            var vacationTh02 = "";
            var vacationTh03 = "";
            var vacationTh04 = "";
            var vacationTh05 = "";
            var vacationTh06 = "";
            var vacationTh07 = "";
            var vacationTh08 = "";
            var vacationTh09 = "";
            var vacationTh10 = "";
            var vacationTh11 = "";
            var vacationTh12 = "";

            for (var i = 0; i < response.d03Vacation_vt.length; i++) {
                var item9 = response.d03Vacation_vt[i];
                var years = (item9.DATUM+'').substring(5,7);

                if (month == years) {
                    sum += parseFloat(item9.ABRTG);
                } else {
                    if (month != 00) {
                        if (month == 01) vacationTh01 = parseFloat(sum).toFixed(2);
                        if (month == 02) vacationTh02 = parseFloat(sum).toFixed(2);
                        if (month == 03) vacationTh03 = parseFloat(sum).toFixed(2);
                        if (month == 04) vacationTh04 = parseFloat(sum).toFixed(2);
                        if (month == 05) vacationTh05 = parseFloat(sum).toFixed(2);
                        if (month == 06) vacationTh06 = parseFloat(sum).toFixed(2);
                        if (month == 07) vacationTh07 = parseFloat(sum).toFixed(2);
                        if (month == 08) vacationTh08 = parseFloat(sum).toFixed(2);
                        if (month == 09) vacationTh09 = parseFloat(sum).toFixed(2);
                        if (month == 10) vacationTh10 = parseFloat(sum).toFixed(2);
                        if (month == 11) vacationTh11 = parseFloat(sum).toFixed(2);
                        if (month == 12) vacationTh12 = parseFloat(sum).toFixed(2);
                    }
                    sum = parseFloat(item9.ABRTG);
                    month = years;
                }
                if (i == response.d03Vacation_vt.length-1) {
                    if (month == 01) vacationTh01 = parseFloat(sum).toFixed(2);
                    if (month == 02) vacationTh02 = parseFloat(sum).toFixed(2);
                    if (month == 03) vacationTh03 = parseFloat(sum).toFixed(2);
                    if (month == 04) vacationTh04 = parseFloat(sum).toFixed(2);
                    if (month == 05) vacationTh05 = parseFloat(sum).toFixed(2);
                    if (month == 06) vacationTh06 = parseFloat(sum).toFixed(2);
                    if (month == 07) vacationTh07 = parseFloat(sum).toFixed(2);
                    if (month == 08) vacationTh08 = parseFloat(sum).toFixed(2);
                    if (month == 09) vacationTh09 = parseFloat(sum).toFixed(2);
                    if (month == 10) vacationTh10 = parseFloat(sum).toFixed(2);
                    if (month == 11) vacationTh11 = parseFloat(sum).toFixed(2);
                    if (month == 12) vacationTh12 = parseFloat(sum).toFixed(2);
                }
            }

            // 보상휴가 사용내역
            if (eAuth == 'Y') {
                $("#saYongListGrid").jsGrid("insertItem", {
                    th00 : "보상휴가(사용)",
                    th01 : (usedResult3.ABRTG01 == "" || usedResult3.ABRTG01 == "0") ? "" : parseFloat(usedResult3.ABRTG01).toFixed(2),
                    th02 : (usedResult3.ABRTG02 == "" || usedResult3.ABRTG02 == "0") ? "" : parseFloat(usedResult3.ABRTG02).toFixed(2),
                    th03 : (usedResult3.ABRTG03 == "" || usedResult3.ABRTG03 == "0") ? "" : parseFloat(usedResult3.ABRTG03).toFixed(2),
                    th04 : (usedResult3.ABRTG04 == "" || usedResult3.ABRTG04 == "0") ? "" : parseFloat(usedResult3.ABRTG04).toFixed(2),
                    th05 : (usedResult3.ABRTG05 == "" || usedResult3.ABRTG05 == "0") ? "" : parseFloat(usedResult3.ABRTG05).toFixed(2),
                    th06 : (usedResult3.ABRTG06 == "" || usedResult3.ABRTG06 == "0") ? "" : parseFloat(usedResult3.ABRTG06).toFixed(2),
                    th07 : (usedResult3.ABRTG07 == "" || usedResult3.ABRTG07 == "0") ? "" : parseFloat(usedResult3.ABRTG07).toFixed(2),
                    th08 : (usedResult3.ABRTG08 == "" || usedResult3.ABRTG08 == "0") ? "" : parseFloat(usedResult3.ABRTG08).toFixed(2),
                    th09 : (usedResult3.ABRTG09 == "" || usedResult3.ABRTG09 == "0") ? "" : parseFloat(usedResult3.ABRTG09).toFixed(2),
                    th10 : (usedResult3.ABRTG10 == "" || usedResult3.ABRTG10 == "0") ? "" : parseFloat(usedResult3.ABRTG10).toFixed(2),
                    th11 : (usedResult3.ABRTG11 == "" || usedResult3.ABRTG11 == "0") ? "" : parseFloat(usedResult3.ABRTG11).toFixed(2),
                    th12 : (usedResult3.ABRTG12 == "" || usedResult3.ABRTG12 == "0") ? "" : parseFloat(usedResult3.ABRTG12).toFixed(2),
                    th13 : (usedResult3.ABRTG_SUM == "" || usedResult3.ABRTG_SUM == "0") ? "0" : parseFloat(usedResult3.ABRTG_SUM).toFixed(2)
                });

                $("#saYongListGrid").jsGrid("insertItem", {
                    th00 : "보상휴가(보상)",
                    th01 : (usedResult4.ABRTG01 == "" || usedResult4.ABRTG01 == "0") ? "" : parseFloat(usedResult4.ABRTG01).toFixed(2),
                    th02 : (usedResult4.ABRTG02 == "" || usedResult4.ABRTG02 == "0") ? "" : parseFloat(usedResult4.ABRTG02).toFixed(2),
                    th03 : (usedResult4.ABRTG03 == "" || usedResult4.ABRTG03 == "0") ? "" : parseFloat(usedResult4.ABRTG03).toFixed(2),
                    th04 : (usedResult4.ABRTG04 == "" || usedResult4.ABRTG04 == "0") ? "" : parseFloat(usedResult4.ABRTG04).toFixed(2),
                    th05 : (usedResult4.ABRTG05 == "" || usedResult4.ABRTG05 == "0") ? "" : parseFloat(usedResult4.ABRTG05).toFixed(2),
                    th06 : (usedResult4.ABRTG06 == "" || usedResult4.ABRTG06 == "0") ? "" : parseFloat(usedResult4.ABRTG06).toFixed(2),
                    th07 : (usedResult4.ABRTG07 == "" || usedResult4.ABRTG07 == "0") ? "" : parseFloat(usedResult4.ABRTG07).toFixed(2),
                    th08 : (usedResult4.ABRTG08 == "" || usedResult4.ABRTG08 == "0") ? "" : parseFloat(usedResult4.ABRTG08).toFixed(2),
                    th09 : (usedResult4.ABRTG09 == "" || usedResult4.ABRTG09 == "0") ? "" : parseFloat(usedResult4.ABRTG09).toFixed(2),
                    th10 : (usedResult4.ABRTG10 == "" || usedResult4.ABRTG10 == "0") ? "" : parseFloat(usedResult4.ABRTG10).toFixed(2),
                    th11 : (usedResult4.ABRTG11 == "" || usedResult4.ABRTG11 == "0") ? "" : parseFloat(usedResult4.ABRTG11).toFixed(2),
                    th12 : (usedResult4.ABRTG12 == "" || usedResult4.ABRTG12 == "0") ? "" : parseFloat(usedResult4.ABRTG12).toFixed(2),
                    th13 : (usedResult4.ABRTG_SUM == "" || usedResult4.ABRTG_SUM == "0") ? "0" : parseFloat(usedResult4.ABRTG_SUM).toFixed(2)
                });
            }
            
         	// 하계 휴가
            if ($("#year option:selected").val() == <%=DateTime.getYear()%>) {
                $("#saYongListGrid").jsGrid("insertItem", {
                    th00 : "하계휴가",
                    th01 : vacationTh01,
                    th02 : vacationTh02,
                    th03 : vacationTh03,
                    th04 : vacationTh04,
                    th05 : vacationTh05,
                    th06 : vacationTh06,
                    th07 : vacationTh07,
                    th08 : vacationTh08,
                    th09 : vacationTh09,
                    th10 : vacationTh10,
                    th11 : vacationTh11,
                    th12 : vacationTh12,
                    th13 : parseFloat(response.E_ABRTG).toFixed(2)
                });
            }

            // 사전부여휴가 발생 내역
            if (occurResult1.ANZHL_SUM) {
                $("#saJunListGrid").jsGrid("insertItem", {
                    th00 : "발생일수",
                    th01 : occurResult1.ANZHL01 == "0" ? "" : parseFloat(occurResult1.ANZHL01).toFixed(2),
                    th02 : occurResult1.ANZHL02 == "0" ? "" : parseFloat(occurResult1.ANZHL02).toFixed(2),
                    th03 : occurResult1.ANZHL03 == "0" ? "" : parseFloat(occurResult1.ANZHL03).toFixed(2),
                    th04 : occurResult1.ANZHL04 == "0" ? "" : parseFloat(occurResult1.ANZHL04).toFixed(2),
                    th05 : occurResult1.ANZHL05 == "0" ? "" : parseFloat(occurResult1.ANZHL05).toFixed(2),
                    th06 : occurResult1.ANZHL06 == "0" ? "" : parseFloat(occurResult1.ANZHL06).toFixed(2),
                    th07 : occurResult1.ANZHL07 == "0" ? "" : parseFloat(occurResult1.ANZHL07).toFixed(2),
                    th08 : occurResult1.ANZHL08 == "0" ? "" : parseFloat(occurResult1.ANZHL08).toFixed(2),
                    th09 : occurResult1.ANZHL09 == "0" ? "" : parseFloat(occurResult1.ANZHL09).toFixed(2),
                    th10 : occurResult1.ANZHL10 == "0" ? "" : parseFloat(occurResult1.ANZHL10).toFixed(2),
                    th11 : occurResult1.ANZHL11 == "0" ? "" : parseFloat(occurResult1.ANZHL11).toFixed(2),
                    th12 : occurResult1.ANZHL12 == "0" ? "" : parseFloat(occurResult1.ANZHL12).toFixed(2),
                    th13 : parseFloat(occurResult1.ANZHL_SUM).toFixed(2)
                });
            }

            //사전부여휴가 사용 내역
            if (usedResult1.ABRTG_SUM) {
                $("#saJunListGrid").jsGrid("insertItem", {
                    th00 : "사용일수",
                    th01 : usedResult1.ABRTG01 == "0" ? "" : parseFloat(usedResult1.ABRTG01).toFixed(2),
                    th02 : usedResult1.ABRTG02 == "0" ? "" : parseFloat(usedResult1.ABRTG02).toFixed(2),
                    th03 : usedResult1.ABRTG03 == "0" ? "" : parseFloat(usedResult1.ABRTG03).toFixed(2),
                    th04 : usedResult1.ABRTG04 == "0" ? "" : parseFloat(usedResult1.ABRTG04).toFixed(2),
                    th05 : usedResult1.ABRTG05 == "0" ? "" : parseFloat(usedResult1.ABRTG05).toFixed(2),
                    th06 : usedResult1.ABRTG06 == "0" ? "" : parseFloat(usedResult1.ABRTG06).toFixed(2),
                    th07 : usedResult1.ABRTG07 == "0" ? "" : parseFloat(usedResult1.ABRTG07).toFixed(2),
                    th08 : usedResult1.ABRTG08 == "0" ? "" : parseFloat(usedResult1.ABRTG08).toFixed(2),
                    th09 : usedResult1.ABRTG09 == "0" ? "" : parseFloat(usedResult1.ABRTG09).toFixed(2),
                    th10 : usedResult1.ABRTG10 == "0" ? "" : parseFloat(usedResult1.ABRTG10).toFixed(2),
                    th11 : usedResult1.ABRTG11 == "0" ? "" : parseFloat(usedResult1.ABRTG11).toFixed(2),
                    th12 : usedResult1.ABRTG12 == "0" ? "" : parseFloat(usedResult1.ABRTG12).toFixed(2),
                    th13 : parseFloat(usedResult1.ABRTG_SUM).toFixed(2)
                });
            }

            //사전부여휴가내역
            var ABRTG_SUM3_CNT = 0;
            if (occurResult1.ANZHL_SUM && usedResult1.ABRTG_SUM) {
                ABRTG_SUM3_CNT = parseFloat(!occurResult1.ANZHL_SUM ? "0.00" : occurResult1.ANZHL_SUM) - parseFloat(!usedResult1.ABRTG_SUM ? "0.00" : usedResult1.ABRTG_SUM);
                $("#ABRTG_SUM3").val(ABRTG_SUM3_CNT.toFixed(2) + "  ");
            } else if (occurResult1.ANZHL_SUM) {
                $("#ABRTG_SUM3").val(parseFloat(occurResult1.ANZHL_SUM).toFixed(2) + "  ");
            } else {
                $("#ABRTG_SUM3").val(parseFloat("0.00").toFixed(2) + "  ");
            }

            //선택적 보상휴가 발생 내역
            if (occurResult2.ANZHL_SUM) {
                $("#selectListGrid").jsGrid("insertItem", {
                    th00 : "발생일수",
                    th01 : occurResult2.ANZHL01 == "0" ? "" : parseFloat(occurResult2.ANZHL01).toFixed(2),
                    th02 : occurResult2.ANZHL02 == "0" ? "" : parseFloat(occurResult2.ANZHL02).toFixed(2),
                    th03 : occurResult2.ANZHL03 == "0" ? "" : parseFloat(occurResult2.ANZHL03).toFixed(2),
                    th04 : occurResult2.ANZHL04 == "0" ? "" : parseFloat(occurResult2.ANZHL04).toFixed(2),
                    th05 : occurResult2.ANZHL05 == "0" ? "" : parseFloat(occurResult2.ANZHL05).toFixed(2),
                    th06 : occurResult2.ANZHL06 == "0" ? "" : parseFloat(occurResult2.ANZHL06).toFixed(2),
                    th07 : occurResult2.ANZHL07 == "0" ? "" : parseFloat(occurResult2.ANZHL07).toFixed(2),
                    th08 : occurResult2.ANZHL08 == "0" ? "" : parseFloat(occurResult2.ANZHL08).toFixed(2),
                    th09 : occurResult2.ANZHL09 == "0" ? "" : parseFloat(occurResult2.ANZHL09).toFixed(2),
                    th10 : occurResult2.ANZHL10 == "0" ? "" : parseFloat(occurResult2.ANZHL10).toFixed(2),
                    th11 : occurResult2.ANZHL11 == "0" ? "" : parseFloat(occurResult2.ANZHL11).toFixed(2),
                    th12 : occurResult2.ANZHL12 == "0" ? "" : parseFloat(occurResult2.ANZHL12).toFixed(2),
                    th13 : parseFloat(occurResult2.ANZHL_SUM).toFixed(2)
                });
            }

            // 선택적 보상 휴가 사용 내역
            if (usedResult2.ABRTG_SUM) {
                $("#selectListGrid").jsGrid("insertItem", {
                    th00 : "사용일수",
                    th01 : usedResult2.ABRTG01 == "0" ? "" : parseFloat(usedResult2.ABRTG01).toFixed(2),
                    th02 : usedResult2.ABRTG02 == "0" ? "" : parseFloat(usedResult2.ABRTG02).toFixed(2),
                    th03 : usedResult2.ABRTG03 == "0" ? "" : parseFloat(usedResult2.ABRTG03).toFixed(2),
                    th04 : usedResult2.ABRTG04 == "0" ? "" : parseFloat(usedResult2.ABRTG04).toFixed(2),
                    th05 : usedResult2.ABRTG05 == "0" ? "" : parseFloat(usedResult2.ABRTG05).toFixed(2),
                    th06 : usedResult2.ABRTG06 == "0" ? "" : parseFloat(usedResult2.ABRTG06).toFixed(2),
                    th07 : usedResult2.ABRTG07 == "0" ? "" : parseFloat(usedResult2.ABRTG07).toFixed(2),
                    th08 : usedResult2.ABRTG08 == "0" ? "" : parseFloat(usedResult2.ABRTG08).toFixed(2),
                    th09 : usedResult2.ABRTG09 == "0" ? "" : parseFloat(usedResult2.ABRTG09).toFixed(2),
                    th10 : usedResult2.ABRTG10 == "0" ? "" : parseFloat(usedResult2.ABRTG10).toFixed(2),
                    th11 : usedResult2.ABRTG11 == "0" ? "" : parseFloat(usedResult2.ABRTG11).toFixed(2),
                    th12 : usedResult2.ABRTG12 == "0" ? "" : parseFloat(usedResult2.ABRTG12).toFixed(2),
                    th13 : parseFloat(usedResult2.ABRTG_SUM).toFixed(2)
                });
            } else {
                if (occurResult2.ANZHL_SUM) {
                    $("#selectListGrid").jsGrid("insertItem", {
                        th00 : "사용일수", th01 : "" , th02 : "" , th03 : "" , th04 : "" , th05 : "" , th06 : "" , th07 : "" , th08 : "" , th09 : "" , th10 : "" , th11 : "" , th12 : "" , th13 : "0"
                    });
                }
            }

            //선택적 보상휴가 보상일수
            var ABRTG_SUM_CNT = 0;
            if (compenCnt.length > 0) {
                ABRTG_SUM_CNT = parseFloat(!compenCnt ? "0.00" : compenCnt);
                $("#ABRTG_SUM1").val(ABRTG_SUM_CNT.toFixed(2) + "  ");
            } else {
                $("#ABRTG_SUM1").val(parseFloat("0.00").toFixed(2) + "  ");
            }

            var ABRTG_SUM2_CNT = 0;
            if (occurResult2.ANZHL_SUM && usedResult2.ABRTG_SUM) {
                ABRTG_SUM2_CNT  = parseFloat(!occurResult2.ANZHL_SUM ? "0.00" : occurResult2.ANZHL_SUM) - parseFloat(!usedResult2.ABRTG_SUM ? "0.00" : usedResult2.ABRTG_SUM) - parseFloat(compenCnt);
                $("#ABRTG_SUM2").val(ABRTG_SUM2_CNT.toFixed(2) + "  ");
            } else if (occurResult2.ANZHL_SUM != "") {
                ABRTG_SUM2_CNT =  parseFloat(!occurResult2.ANZHL_SUM ? "0.00" : occurResult2.ANZHL_SUM) - parseFloat(compenCnt);
                $("#ABRTG_SUM2").val(ABRTG_SUM2_CNT.toFixed(2) + "  ");
            } else {
                ABRTG_SUM2_CNT =  parseFloat("0.00") - parseFloat(compenCnt);
                $("#ABRTG_SUM2").val(ABRTG_SUM2_CNT.toFixed(2) + "  ");
            }

            // 없으면 Hide
            var isSajunCommentHide = false;
            if (!$("#saJunListGrid").jsGrid("dataCount")) {
                $("#sajunListArea, .saJunComment").hide();
                isSajunCommentHide = true;
            }

            if (!$("#selectListGrid").jsGrid("dataCount")) {
                $("#selectListArea, .selectComment").hide();
                
                if(isSajunCommentHide) $('#saJuntableComment').hide();
            }
            if (!$("#saJunListGrid").jsGrid("dataCount") && !$("#selectListGrid").jsGrid("dataCount")) {
                $(".janyeoComment").hide();
            }
        }
    });
}

$("#year").change(function() {
    $("#sajunListArea, .saJunComment, #selectListArea, .selectComment, .janyeoComment").show();
    $("#balSengListGrid").jsGrid({data: []});
    $("#saYongListGrid").jsGrid({data: []});
    $("#saJunListGrid").jsGrid({data: []});
    $("#selectListGrid").jsGrid({data: []});

    searchTab3();
});

// 휴가유형 변경시
$('input:radio[name="vocaType"]').change(function() {
    $("input:radio[name='awartRadio']").filter(":checked").prop('checked', false);
    $("#REASON, #inputDateFrom").val("");
    $('#inputDateTo').val("").removeClass('readOnly').prop('disabled', false);
    $("#BEGUZ_MM, #BEGUZ_HH, #ENDUZ_MM, #ENDUZ_HH").val("00").prop("disabled", true).addClass('readOnly');

    var chkVocaType = $("input:radio[name='vocaType']").filter(":checked").val();
    if (chkVocaType == 'B') {
        $('#vocaType0Panel').show();
        $('#vocaType1Panel').hide();
    } else {
        $('#vocaType0Panel').hide();
        $('#vocaType1Panel').show();
    }

    $.ajax({
        type : 'POST',
        url : '/work/getRemainVacation.json',
        cache : false,
        dataType : 'json',
        data : {"I_MODE":chkVocaType},
        async :false,
        success : function(response) {
            if (response.success) {
                var E_REMAIN = response.storeData.E_REMAIN == 0 ? 0 : parseFloat(response.storeData.E_REMAIN).toFixed(2);
                var ZKVRB2 = response.storeData.ZKVRB2 == 0 ? 0 : parseFloat(response.storeData.ZKVRB2).toFixed(1);
                var VACATION = response.storeData.VACATION == 0 ? 0 : parseFloat(response.storeData.VACATION).toFixed(1);
                var ZKVRBTX = response.storeData.ZKVRBTX;

                if (chkVocaType == 'A') {
                    $('#P_REMAIN').val(E_REMAIN + '/' + ZKVRB2 + '/' + VACATION).next().text('(연월차/선택적보상/하계)');
                } else {
                    $('#P_REMAIN').val(E_REMAIN).next().text(ZKVRBTX);
                }
            } else {
                alert("잔여휴가 조회 오류가 발생하였습니다.\n\n" + response.message);
            }
        }
    });
});

// 휴가구분 변경시
$("input:radio[name='awartRadio']").change(function() {
    var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
    $("#REASON").val("").prop('readonly', false).removeClass("readOnly");

    $('#inputDateTo').datepicker('option', 'disabled', false);

    // 경조공가
    if (radioCheck == '0130') {
        $("#CONG_CODE, #Message_1, #Message_2, #EventMoneyListBtn").show();
        $("#REASON").prop("readonly", true).addClass("readOnly");
    } else {
        // 지각,조퇴,난임휴가(유급)
        if (radioCheck == '0220' || radioCheck == '0230' || radioCheck == '0133') {
            $('#inputDateTo')
                .val($('#inputDateFrom').val())
                .datepicker('option', 'disabled', true);
        }
        $("#CONG_CODE").hide().val("");
        $("#Message_1, #Message_2, #EventMoneyListBtn").hide();
        initDeatilInfo();
    }

    // 전일공가
    if (radioCheck == '0170') {
        $("#OVTM_CODE1").show();
    } else {
        $("#OVTM_CODE1").hide().val("");
    }

    // 시간공가
    if (radioCheck == '0180') {
        $("#OVTM_CODE2").show();
    } else {
        $("#OVTM_CODE2").hide().val("");
    }

    // 신청시간 체크
    var eAuth = $('input[name=E_AUTH]').val();
    // 사무직 - 시간공가
    if (eAuth == 'Y' && radioCheck == '0180') {
        $("#BEGUZ_MM, #BEGUZ_HH, #ENDUZ_MM, #ENDUZ_HH").prop("disabled", false).removeClass('readOnly');
    }
    // 현장직 - 반일휴가(전반, 후반), 시간공가, 지각, 조퇴
    else if (eAuth != 'Y' && (radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' || radioCheck == '0220' || radioCheck == '0230')) {
        $("#BEGUZ_MM, #BEGUZ_HH, #ENDUZ_MM, #ENDUZ_HH").prop("disabled", false).removeClass('readOnly');
    }
    // 나머지 휴가구분의 경우
    else {
        $("#BEGUZ_MM, #BEGUZ_HH, #ENDUZ_MM, #ENDUZ_HH").val("00").prop("disabled", true).addClass('readOnly');
    }

    $("#AWART").val(radioCheck);

    // 공제일수
    if (radioCheck == '0110' || radioCheck == '0111') { // 전일휴가
        $("#DEDUCT_DATE").val('1');
    } else if (radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0112' || radioCheck == '0113') {   // 반일휴가(전반, 후반)
        $("#DEDUCT_DATE").val('0.5');
    } else if (radioCheck == '0180') {   // 시간공가
        $("#DEDUCT_DATE").val('0');
    } else {
        $("#DEDUCT_DATE").val('0');
    }

});

// 날짜변경시
$('#inputDateFrom').change(function() {
    var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();

    if (radioCheck == '0220' || radioCheck == '0230' || radioCheck == '0133') { // 지각,조퇴,난임휴가(유급)
        $('#inputDateTo').val($('#inputDateFrom').val());
    }
});

//경조공가 팝업창에서 셋팅된 값 초기화
var initDeatilInfo = function() {
    $('#DETAIL_PERNR, #DETAIL_AINF_SEQN, #DETAIL_BEGDA, #DETAIL_CONG_CODE, #DETAIL_CONG_NAME, #DETAIL_RELA_CODE, #DETAIL_RELA_NAME, #DETAIL_CONG_DATE, #DETAIL_HOLI_CONT').val("");
}

// 결조공가 사유 선택시
$("#CONG_CODE").change(function() {
    var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val(), CONG_CODE = $("#CONG_CODE option:selected").val();
    if (radioCheck == '0130' && CONG_CODE == "9001") {//자녀출산(유급)
        $("#AWART").val("0131");
        $("#EventMoneyListBtn").hide();
        $("#REASON").val("").prop('readonly', false).removeClass("readOnly");
    } else if (radioCheck == '0130' && CONG_CODE == "9002") {//자녀출산(무급)
        $("#AWART").val("0132");
        $("#EventMoneyListBtn").hide();
        $("#REASON").val("").prop('readonly', false).removeClass("readOnly");
    } else if (radioCheck == '0130'&& (CONG_CODE != "9001" && CONG_CODE != "9002")) {//나머지경조공가
        $("#AWART").val("0130");
        $("#EventMoneyListBtn").show();
        $("#REASON").val("").prop("readonly", true).addClass("readOnly");
    }
});

$("#BEGUZ_HH, #BEGUZ_MM").change(function() {
    $("#BEGUZ").val($("#BEGUZ_HH").val() + $("#BEGUZ_MM").val());
});

$("#ENDUZ_HH, #ENDUZ_MM").change(function() {
    $("#ENDUZ").val($("#ENDUZ_HH").val() + $("#ENDUZ_MM").val());
});

var requestVacation = function(self) {
    if (requestVacationChk()) {
        //자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
        var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
        tab1ApplGridChangeAppLine(self);
        if (confirm(msg + "신청 하시겠습니까?")) {
            $("#requestVacationBtn, #requestNapprovalBtn").prop("disabled", true);

            if ($('#inputDateTo').is(':disabled')) {
                $('#inputDateTo').datepicker('option', 'disabled', false);
            }

            var param = $("#vacationForm").serializeArray();
            $("#tab1ApplGrid").jsGrid("serialize", param);
            param.push({name: "selfAppr", value: self});
            $.ajax({
                type : 'POST',
                url : '/work/requestVacation.json',
                cache : false,
                dataType : 'json',
                data : param,
                async : false,
                success : function(response) {
                    if (response.success) {
                        alert("신청 되었습니다.");
                        $("#vacationForm").each(function() {
                            this.reset();
                        });
                        if ($('input[name=E_AUTH]').val() == 'Y') {
                            $('#vocaType0Panel, #vocaType1Panel').hide();
                        }
                        $("#BEGUZ_MM, #BEGUZ_HH, #ENDUZ_MM, #ENDUZ_HH").val("00").prop("disabled", true).addClass('readOnly');

                        $('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=18&gridDivId=tab1ApplGrid');
                        
                        $('input:radio[name="vocaType"]').eq(0).click();

                    } else {
                        alert("신청시 오류가 발생하였습니다.\n\n" + response.message);
                    }
                    $("#requestVacationBtn, #requestNapprovalBtn").prop("disabled", false);
                }
            });
        } else {
            tab1ApplGridChangeAppLine(false);
        }
    }
}

var requestVacationChk = function() {

    var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
    if (radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' || radioCheck == '0220' || radioCheck == '0230') {
        $("#timeopen").val("T");
    } else {
        $("#timeopen").val("F");
    }
    if (!$("input:radio[name='awartRadio']").is(":checked")) {
        alert("휴가구분을 선택하세요.");
        return false;
    }
    if (!checkNullField("vacationForm")) {
        return false;
    }
    //하계휴가 신청시 잔여 하계휴가일수를 check한다. (2004.03.08)
    if (radioCheck == '0140') {
        if ($("#VACATI_DATE").val() == "0") {
            alert("하계휴가 잔여일수가 존재하지 않습니다.");
            return false;
        }
    }
    if (radioCheck == '0130') {
        var vCONG_DATE_CHECK = $("#CONG_DATE_CHECK").val();
        var chYYYY = vCONG_DATE_CHECK.substring(0,4);
        var chMM = vCONG_DATE_CHECK.substring(5,7);
        var chDD = vCONG_DATE_CHECK.substring(8,10);
        var chDate = new Date(chYYYY, chMM, chDD);  // 경조일

        var vinputDateFrom = $("#inputDateFrom").val();
        var tarYYYY = vinputDateFrom.substring(0,4);
        var tarMM = vinputDateFrom.substring(5,7);
        var tarDD = vinputDateFrom.substring(8,10);
        var tarDate = new Date(tarYYYY, tarMM, tarDD); //휴가기간 시작일

        var vBEGDA = $("#BEGDA").val();
        var reqYYYY =  vBEGDA.substring(0,4);
        var reqMM =  vBEGDA.substring(5,7);
        var reqDD =  vBEGDA.substring(8,10);
        var reqDate =  new Date(reqYYYY, reqMM, reqDD);  //휴가신청일

        // 경조일과 휴가사용일간의 차이 : 경조 발생일 기준  경조공가 사용 가능일  경조발생일 ~ 30일 이내
        var gapDD = (tarDate - chDate)/(24*3600*1000);
        // 경조일과 휴가신청일간의 차이 : 경조발생일 기준 7일전 ~ 30일 이내
        var gapDD2 = (reqDate - chDate)/(24*3600*1000);

        var CONG_CODE = $("#CONG_CODE option:selected").val();
        if (!CONG_CODE) {
            alert("경조공가 신청사유를 선택해주세요.");
            return false;
        }
        if (gapDD2 < -7 && (CONG_CODE != "9001" && CONG_CODE != "9002")) {
            alert("경조공가 신청 가능일은 경조발생일 기준 7일전 ~ 30일 이내입니다. 현재 신청일자는 " + gapDD2 +"일 전 날짜입니다.");
            return false;
        }
        if (gapDD2 > 30 && (CONG_CODE != "9001" && CONG_CODE != "9002")) {
            alert("경조공가 신청 가능일은 경조발생일 기준 7일전 ~ 30일 이내입니다. 현재 신청일자는 " + gapDD2 +"일 이 지난 날짜입니다.");
             return false;
        }

        if (gapDD < 0 && (CONG_CODE != "9001" && CONG_CODE != "9002")) {
            alert("경조공가 사용 가능일은 경조발생일 ~ 30일 이내입니다. 현재 휴가사용일자는 " + gapDD +"일 전 날짜입니다.");
            return false;
        }
        if (gapDD > 30 && (CONG_CODE != "9001" && CONG_CODE != "9002")) {
            alert("경조공가 사용 가능일은 경조발생일 ~ 30일 이내입니다. 현재 휴가사용일자는 " + gapDD +"일 이 지난 날짜입니다.");
             return false;
        }
    } else if (radioCheck == '0170') {
        if ($("#OVTM_CODE1 option:selected").val() == "") {
            alert("전일공가 신청사유를 선택해주세요.");
            return false;
        }
    } else if (radioCheck == '0180') {
        if ($("#OVTM_CODE2 option:selected").val() == "") {
            alert("시간공가 신청사유를 선택해주세요.");
            return false;
        }
    }

    // 전일 공가와 시간 공가  선택한 경우  ( 이동엽D)
    if (radioCheck == '0170') {
        $("#OVTM_CODE").val($("#OVTM_CODE1 option:selected").val());
    }
    if (radioCheck == '0180') {
        $("#OVTM_CODE").val($("#OVTM_CODE2 option:selected").val());
    }

    // 신청사유-80 입력시 길이 제한
    var REASON = $("#REASON"), vREASON = REASON.val();
    if (vREASON != "" && checkLength(vREASON) > 80) {
        REASON.val(limitKoText(vREASON, 80)).focus().select();
        alert("신청사유는 한글 40자, 영문 80자 이내여야 합니다.");
        return false;
    }

    date_from = removePoint($("#inputDateFrom").val());
    date_to   = removePoint($("#inputDateTo").val());

    var eAuth = $('input[name=E_AUTH]').val();
    if (radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' || radioCheck == '0112' || radioCheck == '0113') { // 반일휴가(전반, 후반), 시간공가
        if (date_from != date_to) {
            alert("반일휴가는 신청기간이 하루입니다.");
            return false;
        }

        // 현장직만 체크 - 반일휴가일경우 신청시간 체크..??
        if (eAuth != 'Y' && $("#BEGUZ").val() > $("#ENDUZ").val()) {
            alert("신청시작 시간이 신청종료 시간보다 큽니다.");
            return false;
        }

        if (eAuth != 'Y' && ($("#BEGUZ").val() == "" || $("#ENDUZ").val() == "")) {
            alert("반일휴가의 경우 신청기간을 입력해주십시요.");
            return false;
        }
<%
// 2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다.
if (!userData.e_regno.equals("") && userData.e_regno.substring(6,7).equals("2")) {
%>
    } else if (radioCheck == '0150') {
        if (date_from != date_to) {
            alert("잔여(보건) 휴가는 신청기간이 하루입니다.");
            return false;
        }
<%
}
%>
    } else {
        if (date_from > date_to) {
            alert("신청시작일이 신청종료일보다 큽니다.");
            return false;
        }
    }

    return true;
}

$(function() {
	$('input:radio[name="vocaType"]').eq(0).click();
	
    // 휴가 신청 처리
    $("#requestVacationBtn").click(function() {
        requestVacation(false);
    });
    $("#requestNapprovalBtn").click(function() {
        requestVacation(true);
    });
    $('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=18&gridDivId=tab1ApplGrid');
    $("#OVTM_CODE1, #OVTM_CODE2, #CONG_CODE, #EventMoneyListBtn, #Message_1, #Message_2").hide();
    $("#BEGUZ_MM, #BEGUZ_HH, #ENDUZ_MM, #ENDUZ_HH").val("00").prop("disabled",true).addClass('readOnly');

    $schedulePopup = function() {
        $('body').loader('show', '<img style="width:50px;height:50px" src="/web-resource/images/img_loading.gif">');
        $("#schedulePopup")
            .attr("src", "/work/personWorkSchedule")
            .load(function() {
                $('body').loader('hide');
                $('#popLayerSchedule').popup("show");
            });
    }

    //대상자선택 popup  경조금조회
    $("#EventMoneyListBtn").click(function() {
        $("#eventMoneyGrid").jsGrid("search");
        $("#popLayerEventMoneyList").popup('show');  //popLayerFamilyList 참조
    });
    //대상자선택 popup 저장
    $("#popLayerEventMoneyListSave").click(function() {
        var DETAIL_AINF_SEQN = $('#DETAIL_AINF_SEQN').val();    //결제일련번호
        var DETAIL_CONG_NAME = $('#DETAIL_CONG_NAME').val();    //경조내역
        var DETAIL_RELA_NAME = $('#DETAIL_RELA_NAME').val();    //관계
        var DETAIL_CONG_DATE = $('#DETAIL_CONG_DATE').val();    //경조발생일
        if (DETAIL_AINF_SEQN.length > 0) {
            var str = DETAIL_CONG_NAME + "/" + DETAIL_RELA_NAME + "/" + DETAIL_CONG_DATE
            $('#REASON').val(str);
            $('#CONG_DATE_CHECK').val($('#DETAIL_CONG_DATE').val());
        }
        $("#popLayerEventMoneyList").popup('hide');
    });
    //대상자선택 popup 취소
    $("#popLayerEventMoneyListCansel").click(function() {
        $("#popLayerEventMoneyList").popup('hide');
    });

    $("#tab1").click(function() {
        $("#OVTM_CODE1, #OVTM_CODE2, #CONG_CODE, #EventMoneyListBtn, #Message_1, #Message_2").hide();
        $("#BEGUZ_MM, #BEGUZ_HH, #ENDUZ_MM, #ENDUZ_HH").val("00").prop("disabled", true).addClass('readOnly');
        $('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=18&gridDivId=tab1ApplGrid');
    });
    $("#tab2").click(function() {
        $attCancelGrid();
        $cancelSearch();
    });
    $("#tab3").click(function() {
        $("#sajunListArea, .saJunComment, #selectListArea, .selectComment, .janyeoComment").show();
        $("#balSengListGrid").jsGrid({data: []});
        $("#saYongListGrid").jsGrid({data: []});
        $("#saJunListGrid").jsGrid({data: []});
        $("#selectListGrid").jsGrid({data: []});
        searchTab3();
    });
    $("#tab4").click(function() {
        $('.tab4 select#month').change();
    });

    $attCancelHtml = $("#attCancelDiv").html();

    // 취소신청상세조회
    $("#attCancelSearchBtn").click($cancelSearch);

    // 경조금 지원내역 그리드
    $("#eventMoneyGrid").jsGrid({
        height: "auto",
        width: "100%",
        sorting: true,
        paging: true,
        autoload: false,
        controller: {
            loadData: function() {
                var d = $.Deferred();
                $.ajax({
                    type : "GET",
                    url : "/supp/getEventMoneyListForVacation.json",
                    dataType : "json"
                }).done(function(response) {
                    if (response.success)
                        d.resolve(response.storeData);
                    else
                        alert("조회시 오류가 발생하였습니다.\n\n" + response.message);
                });
                return d.promise();
            }
        },
        fields: [
            { title: "선택", name: "th1", align: "center", width: "12%",
                itemTemplate: function(_, item) {
                    return $("<input type='radio' name='chk'>")
                        .on("click", function(e) {
                            $('#DETAIL_PERNR').val(item.PERNR);
                            $('#DETAIL_AINF_SEQN').val(item.AINF_SEQN);
                            $('#DETAIL_BEGDA').val(item.BEGDA);
                            $('#DETAIL_CONG_CODE').val(item.CONG_CODE);

                            $('#DETAIL_CONG_NAME').val(item.CONG_NAME);
                            $('#DETAIL_RELA_CODE').val(item.RELA_CODE);
                            $('#DETAIL_RELA_NAME').val(item.RELA_NAME);
                            $('#DETAIL_CONG_DATE').val(item.CONG_DATE);
                            $('#DETAIL_HOLI_CONT').val(item.HOLI_CONT);
                       });
                }
            },
            { title: "경조구분", name: "CONG_NAME", type: "text", align: "center", width: "22%" },
            { title: "관 계", name: "RELA_NAME", type: "text", align: "center", width: "22%" },
            { title: "경조발생일", name: "CONG_DATE", type: "text", align: "center", width: "22%" },
            { title: "경조휴가일수", name: "HOLI_CONT", type: "text", align: "center", width: "22%" }
        ]
    });
    // 휴가 발생 내역 그리드
    $("#balSengListGrid").jsGrid({
        height: "auto",
        width: "100%",
        autoload : false,
        paging: false,
        fields: [
            { title: "구분", name: "th00", type: "text", align: "center", width:   "9%" },
            { title: "1월", name: "th01", type: "number", align: "center", width: "7%" },
            { title: "2월", name: "th02", type: "number", align: "center", width: "7%" },
            { title: "3월", name: "th03", type: "number", align: "center", width: "7%" },
            { title: "4월", name: "th04", type: "number", align: "center", width: "7%" },
            { title: "5월", name: "th05", type: "number", align: "center", width: "7%" },
            { title: "6월", name: "th06", type: "number", align: "center", width: "7%" },
            { title: "7월", name: "th07", type: "number", align: "center", width: "7%" },
            { title: "8월", name: "th08", type: "number", align: "center", width: "7%" },
            { title: "9월", name: "th09", type: "number", align: "center", width:  "7%" },
            { title: "10월", name: "th10", type: "number", align: "center", width: "7%" },
            { title: "11월", name: "th11", type: "number", align: "center", width: "7%" },
            { title: "12월", name: "th12", type: "number", align: "center", width: "7%" },
            { title: "계", name: "th13", type: "number", align: "center", width:   "7%" }
        ]
    });
    // 휴가 사용 내역 그리드
    $("#saYongListGrid").jsGrid({
        height: "auto",
        width: "100%",
        autoload : false,
        paging: false,
        fields: [
            { title: "구분", name: "th00", type: "text", align: "center", width:   "9%" },
            { title: "1월", name: "th01", type: "number", align: "center", width: "7%" },
            { title: "2월", name: "th02", type: "number", align: "center", width: "7%" },
            { title: "3월", name: "th03", type: "number", align: "center", width: "7%" },
            { title: "4월", name: "th04", type: "number", align: "center", width: "7%" },
            { title: "5월", name: "th05", type: "number", align: "center", width: "7%" },
            { title: "6월", name: "th06", type: "number", align: "center", width: "7%" },
            { title: "7월", name: "th07", type: "number", align: "center", width: "7%" },
            { title: "8월", name: "th08", type: "number", align: "center", width: "7%" },
            { title: "9월", name: "th09", type: "number", align: "center", width:  "7%" },
            { title: "10월", name: "th10", type: "number", align: "center", width: "7%" },
            { title: "11월", name: "th11", type: "number", align: "center", width: "7%" },
            { title: "12월", name: "th12", type: "number", align: "center", width: "7%" },
            { title: "계", name: "th13", type: "number", align: "center", width:   "7%" }
        ]
    });
    // 사전부여 휴가내역 그리드
    $("#saJunListGrid").jsGrid({
        height: "auto",
        width: "100%",
        autoload : false,
        paging: false,
        fields: [
            { title: "구분", name: "th00", type: "text", align: "center", width:   "9%" },
            { title: "1월", name: "th01", type: "number", align: "center", width: "7%" },
            { title: "2월", name: "th02", type: "number", align: "center", width: "7%" },
            { title: "3월", name: "th03", type: "number", align: "center", width: "7%" },
            { title: "4월", name: "th04", type: "number", align: "center", width: "7%" },
            { title: "5월", name: "th05", type: "number", align: "center", width: "7%" },
            { title: "6월", name: "th06", type: "number", align: "center", width: "7%" },
            { title: "7월", name: "th07", type: "number", align: "center", width: "7%" },
            { title: "8월", name: "th08", type: "number", align: "center", width: "7%" },
            { title: "9월", name: "th09", type: "number", align: "center", width:  "7%" },
            { title: "10월", name: "th10", type: "number", align: "center", width: "7%" },
            { title: "11월", name: "th11", type: "number", align: "center", width: "7%" },
            { title: "12월", name: "th12", type: "number", align: "center", width: "7%" },
            { title: "계", name: "th13", type: "number", align: "center", width:   "7%" }
        ]
    });
    // 선택적 보상 휴가 내역 그리드
    $("#selectListGrid").jsGrid({
        height: "auto",
        width: "100%",
        autoload : false,
        paging: false,
        fields: [
            { title: "구분", name: "th00", type: "text", align: "center", width:   "9%" },
            { title: "1월", name: "th01", type: "number", align: "center", width: "7%" },
            { title: "2월", name: "th02", type: "number", align: "center", width: "7%" },
            { title: "3월", name: "th03", type: "number", align: "center", width: "7%" },
            { title: "4월", name: "th04", type: "number", align: "center", width: "7%" },
            { title: "5월", name: "th05", type: "number", align: "center", width: "7%" },
            { title: "6월", name: "th06", type: "number", align: "center", width: "7%" },
            { title: "7월", name: "th07", type: "number", align: "center", width: "7%" },
            { title: "8월", name: "th08", type: "number", align: "center", width: "7%" },
            { title: "9월", name: "th09", type: "number", align: "center", width:  "7%" },
            { title: "10월", name: "th10", type: "number", align: "center", width: "7%" },
            { title: "11월", name: "th11", type: "number", align: "center", width: "7%" },
            { title: "12월", name: "th12", type: "number", align: "center", width: "7%" },
            { title: "계", name: "th13", type: "number", align: "center", width:   "7%" }
        ]
    });

    <c:if test="${E_AUTH eq 'Y'}"><%-- /web-resource/js/worktime52/comptime.js --%>
    initComptime();
    </c:if>

    var tabId = '${fn:escapeXml( TAB_ID )}';
    if (tabId == '1' || tabId == '2' || tabId == '3' || tabId == '4') {
        $('#tab' + tabId).click();
    }
});
</script>