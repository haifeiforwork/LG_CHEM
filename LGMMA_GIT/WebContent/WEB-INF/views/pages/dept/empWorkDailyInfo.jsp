<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="com.sns.jdf.util.DataUtil"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
String searchDay = (String) request.getAttribute("E_YYYYMON");
String year      = (String) request.getAttribute("year");
String month     = (String) request.getAttribute("month");
String dayCnt    = (String) request.getAttribute("E_DAY_CNT");
String STEXT     = (String) request.getAttribute("STEXT");
%>
<!--// Page Title start -->
<div class="title">
    <h1>일간근태현황</h1>
    <div class="titleRight">
        <ul class="pageLocation">
            <li><span><a href="#">Home</a></span></li>
            <li><span><a href="#">조직관리</a></span></li>
            <li class="lastLocation"><span><a href="#">부서근태</a></span></li>
        </ul>
    </div>
</div>
<!--// Page Title end -->

<!-- layout body start -->
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
        <caption>일간근태현황 조회</caption>
        <colgroup>
            <col class="col_15p" />
            <col class="col_35p" />
            <col class="col_15p" />
            <col class="col_35p" />
        </colgroup>
        <tbody>
            <tr>
                <th><label for="input_select01">조회년월</label></th>
                <td>
                    <select class="w70" id="year" name="year">
<%
                        for (int i = 2016; i <= Integer.parseInt( DataUtil.getCurrentYear() ); i++) {
                        int year1 = Integer.parseInt(searchDay.substring(0, 4));
%>
                        <option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>
                    </select>
                    <select class="w50" id="month" name="month">
<%
                        for (int i = 1; i <= 12; i++) {
                            String temp = Integer.toString(i);
                            int mon = Integer.parseInt(searchDay.substring(4, 6));
%>
                        <option value="<%= i %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
                    </select>
                    <input type="hidden" id="deptId" name="deptId" value="${fn:escapeXml( deptId )}">
                    <input type="hidden" id="deptNm" name="deptNm" value="${fn:escapeXml( param.hdn_deptNm )}">
                    <input type="hidden" id="year1" name="year1" value="">
                    <input type="hidden" id="month1" name="month1" value="">
                    <input type="hidden" id="searchDay_bf" name="searchDay_bf" value="">
                    <input type="hidden" id="D29" name="D29" value="">
                    <input type="hidden" id="D30" name="D30" value="">
                    <input type="hidden" id="D31" name="D31" value="">
                    <input type="hidden" id="BEGDA" name="BEGDA" value="">
                    <input type="hidden" id="ENDDA" name="ENDDA" value="">
<%--                <a class="icoSearch" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a> --%>
                </td>
                <th>부서명</th>
                <td><%=STEXT%></td>
            </tr>
        </tbody>
        </table>
    </div>
</div>
<!--// list start -->
<div class="listArea">
    <h2 class="subtitle">일간근태현황</h2>
    <div class="buttonArea">
            <ul class="btn_mdl">
                <li><a href="#" id="excelDownloadBtn"><span>Excel Download</span></a></li>
            </ul>
        </div>
    <div class="clear"></div>
    <!-- slide content -->
    <div id="empDailyWorkGrid" class="thSpan">
    </div>
</div>
<!-- //slide content -->
<!--// list end -->
<!--// table start -->
<div class="tableArea">
    <h2 class="subtitle">근태유형 및 단위</h2>
    <div class="table">
        <table class="tableGeneral">
            <caption>근태유형 및 단위</caption>
            <colgroup>
                <col class="col_10p" />
                <col class="col_30p" />
                <col class="col_40p" />
                <col class="col_20p" />
            </colgroup>
            <thead>
            <tr>
                <th class="alignCenter"></th>
                <th class="alignCenter">시간</th>
                <th class="alignCenter">일수</th>
                <th class="alignCenter thNoLine">횟수</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <th>비근무</th>
                <td class="tdLine lh2">
                    L:시간공가<br/>U:휴일근무<br/>V:비근무<br/>W:모성보호휴가
                </td>
                <td class="tdLine lh2">
                    D:반일휴가(이전) E:반일휴가(전반) F:반일휴가(후반)<br/>
                    BC:전일휴가(보상) BE:반일휴가(보상,전반) BF:반일휴가(보상,후반)<br/>
                    P1:난임휴가(유급) P2:난임휴가(무급)<br/>
                    C:전일휴가 G:경조공가 H:하계휴가 I:보건휴가<br/>
                    I:보건휴가 J:산전산후휴가 K:전일공가 <br/>
                    M:유급결근 N:무급결근 X:배우자출산휴가(유급)<br/>
                    Y:배우자출산휴가(무급) Z:무급휴일<br/>
                    1:무급휴일, 3:무급자녀출산휴가, K:전일공가
                </td>
                <td class="lh2">O:지각 <br/>P:조퇴<br/> Q:조기조퇴(무단)</td>
            </tr>
            <tr>
                <th>근무</th>
                <td class="tdLine lh2"></td>
                <td class="tdLine lh2">
                    AA:교육(근무시간내)${F01 eq "Y" ? ' AB:선택교육(근무시간내)' : ''}<br/>B:출장
                </td>
                <td></td>
            </tr>
            <tr>
                <th>초과근무</th>
                <td class="tdLine lh2">
                    OA:휴일특근 OC:명절특근 OE:휴일연장<br/>OF:연장근로 OG:야간근로
                </td>
                <td class="tdLine lh2"></td>
                <td></td>
            </tr>
            <tr>
                <th>기타</th>
                <td class="tdLine lh2">EA:교육(분임조) EB:교육(근무시간외) EC:당직${F01 eq "Y" ? '<br/>ED:선택교육(근무시간외)' : ''}</td>
                <td class="tdLine lh2"></td>
                <td></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
<!--// table end -->
<!-- layout body end -->
<script>
$(document).ready(function() {
    if (setBaseInfo())
        $("#empDailyWorkGrid").jsGrid("search");

    fieldCount();
});

$("#excelDownloadBtn").click(function() {
    if (checkData()) {
        var $form = $('<form></form>');
        $form.attr('action', '/excel/genEmpDailyWorkDataExcel');
        $form.attr('method', 'post');
        $form.appendTo('body');

        var deptId = $('<input name="deptId" type="hidden" value="' + $("#deptId").val() + '">');
        var year = $('<input name="year" type="hidden" value="' + $("#year option:selected").val() + '">');
        var month = $('<input name="month" type="hidden" value="' + $("#month option:selected").text() + '">');

        $form.append(deptId).append(year).append(month);
        $form.submit();
    }
});

$("#year").change(function() {
    if (setBaseInfo())
        $("#empDailyWorkGrid").jsGrid("search");

    fieldCount();
});

$("#month").change(function() {
    if (setBaseInfo())
        $("#empDailyWorkGrid").jsGrid("search");

    fieldCount();
});

var checkData = function() {
    if ($("#year option:selected").val() == "2016" && $("#month option:selected").val() < 8) {
        alert( "2016년 8월 이후부터 조회가능합니다.");
        return false;
    }
    return true;
}

$("#empDailyWorkGrid").jsGrid({
    height: "auto",
    sorting: false,
    paging: false,
    autoload: false,
    controller: {
        loadData: function() {
            var d = $.Deferred();
            $.ajax({
                type: "GET",
                url: "/dept/getEmpDailyWorkDataList.json",
                dataType: "json",
                data: {
                    deptId: $("#deptId").val(),
                    year: $("#year option:selected").val(),
                    month: $("#month option:selected").text()
                }
            }).done(function(response) {
                if(response.success)
                    d.resolve(response.storeData);
                else
                    alert("조회시 오류가 발생하였습니다. " + response.message);
            });
            return d.promise();
        }
    },
    headerRowRenderer: function() {
        var arr = new Array(new Array(4, 6 + <%=dayCnt%>, "일일근태내용 " + $("#BEGDA").val() + " ~ " + $("#ENDDA").val()));
        return setGridHeader(this, arr);
    },
    fields : fields28
});

var setBaseInfo = function(){
    if(checkData()){
        jQuery.ajax({
            type: 'get',
            url: '/dept/getEmpDailyWorkTitleList.json',
            cache: false,
            dataType: 'json',
            data: {
                deptId: $("#deptId").val(),
                year: $("#year option:selected").val(),
                month: $("#month option:selected").text()
            },
            async: false,
            success: function(response) {
                if (response.success) {
                    var storeData = response.storeData[0];
                    $("#D29").val(storeData.D29);
                    $("#D30").val(storeData.D30);
                    $("#D31").val(storeData.D31);
                    $("#BEGDA").val(storeData.BEGDA);
                    $("#ENDDA").val(storeData.ENDDA);
                    $("#STEXT").val(storeData.STEXT);
                } else {
                    alert("조회시 오류가 발생하였습니다. " + response.message);
                }
            }
        });
        return true;
    } else {
        return false;
    }
};

var fieldCount = function() {
    if ($("#D29").val() == "00") {
        $("#empDailyWorkGrid").jsGrid("option", "fields", fields28);
    } else if ($("#D30").val() == "00") {
        $("#empDailyWorkGrid").jsGrid("option", "fields", fields29);
    } else if ($("#D31").val() == "00") {
        $("#empDailyWorkGrid").jsGrid("option", "fields", fields30);
    } else {
        $("#empDailyWorkGrid").jsGrid("option", "fields", fields31);
    }
    $("#empDailyWorkGrid").jsGrid("reset");
};

var fields28 = [
    { title: "No.", name: "ROWNUMBER", type: "text", align: "center", width: "30", sorting: false,
        itemTemplate: function(value, item) {
            return $("#empDailyWorkGrid").jsGrid("option", "data").indexOf(item) + 1;
        }
    },
    { title: "성명", name: "ENAME", type: "text", align: "center", width: "80" },
    { title: "사번", name: "PERNR", type: "text", align: "center", width: "80",
        itemTemplate: function(value, item) {
            return item.PERNR.length == 8 ? item.PERNR.substring(3, 8) : item.PERNR;
        }
    },
    { title: "잔여</br>휴가", name: "REMA_HUGA", type: "text", align: "center", width: "50" ,
        itemTemplate: function(value) {
            if (parseInt(value) > 0 || value == "0") {
                return pointFormat(value, 1);
            } else {
                return "0" + value;
            }
        }
    },
    { title: "잔여</br>보상</br>휴가", name: "REMA_RWHUGA", type: "text", align: "center", width: "50" ,
        itemTemplate: function(value) {
            if (parseInt(value) > 0 || value == "0") {
                return pointFormat(value, 2);
            } else {
                return "0" + value;
            }
        }
    },
    { title: "21", name: "D1", type: "text", align: "center", width:  "50" },
    { title: "22", name: "D2", type: "text", align: "center", width:  "50" },
    { title: "23", name: "D3", type: "text", align: "center", width:  "50" },
    { title: "24", name: "D4", type: "text", align: "center", width:  "50" },
    { title: "25", name: "D5", type: "text", align: "center", width:  "50" },
    { title: "26", name: "D6", type: "text", align: "center", width:  "50" },
    { title: "27", name: "D7", type: "text", align: "center", width:  "50" },
    { title: "28", name: "D8", type: "text", align: "center", width:  "50" },
    { title: "01", name: "D9", type: "text", align: "center", width:  "50" },
    { title: "02", name: "D10", type: "text", align: "center", width: "50" },
    { title: "03", name: "D11", type: "text", align: "center", width: "50" },
    { title: "04", name: "D12", type: "text", align: "center", width: "50" },
    { title: "05", name: "D13", type: "text", align: "center", width: "50" },
    { title: "06", name: "D14", type: "text", align: "center", width: "50" },
    { title: "07", name: "D15", type: "text", align: "center", width: "50" },
    { title: "08", name: "D16", type: "text", align: "center", width: "50" },
    { title: "09", name: "D17", type: "text", align: "center", width: "50" },
    { title: "10", name: "D18", type: "text", align: "center", width: "50" },
    { title: "11", name: "D19", type: "text", align: "center", width: "50" },
    { title: "12", name: "D20", type: "text", align: "center", width: "50" },
    { title: "13", name: "D21", type: "text", align: "center", width: "50" },
    { title: "14", name: "D22", type: "text", align: "center", width: "50" },
    { title: "15", name: "D23", type: "text", align: "center", width: "50" },
    { title: "16", name: "D24", type: "text", align: "center", width: "50" },
    { title: "17", name: "D25", type: "text", align: "center", width: "50" },
    { title: "18", name: "D26", type: "text", align: "center", width: "50" },
    { title: "19", name: "D27", type: "text", align: "center", width: "50" },
    { title: "20", name: "D28", type: "text", align: "center", width: "50" }
];

var fields29 = [
    { title: "No.", name: "ROWNUMBER", type: "text", align: "center", width: "30", sorting: false,
        itemTemplate: function(value, item) {
            return $("#empDailyWorkGrid").jsGrid("option", "data").indexOf(item) + 1;
        }
    },
    { title: "성명", name: "ENAME", type: "text", align: "center", width: "80" },
    { title: "사번", name: "PERNR", type: "text", align: "center", width: "80",
        itemTemplate: function(value, item) {
            return item.PERNR.length == 8 ? item.PERNR.substring(3, 8) : item.PERNR;
        }
    },
    { title: "잔여</br>휴가", name: "REMA_HUGA", type: "text", align: "center", width: "50",
        itemTemplate: function(value) {
            if (parseInt(value) > 0 || value == "0") {
                return pointFormat(value, 1);
            } else {
                return "0" + value;
            }
        }
    },
    { title: "잔여</br>보상</br>휴가", name: "REMA_RWHUGA", type: "text", align: "center", width: "50",
        itemTemplate: function(value) {
            if (parseInt(value) > 0 || value == "0") {
                return pointFormat(value, 2);
            } else {
                return "0" + value;
            }
        }
    },
    { title: "21", name: "D1", type: "text", align: "center", width:  "50" },
    { title: "22", name: "D2", type: "text", align: "center", width:  "50" },
    { title: "23", name: "D3", type: "text", align: "center", width:  "50" },
    { title: "24", name: "D4", type: "text", align: "center", width:  "50" },
    { title: "25", name: "D5", type: "text", align: "center", width:  "50" },
    { title: "26", name: "D6", type: "text", align: "center", width:  "50" },
    { title: "27", name: "D7", type: "text", align: "center", width:  "50" },
    { title: "28", name: "D8", type: "text", align: "center", width:  "50" },
    { title: "29", name: "D9", type: "text", align: "center", width:  "50" },
    { title: "01", name: "D10", type: "text", align: "center", width: "50" },
    { title: "02", name: "D11", type: "text", align: "center", width: "50" },
    { title: "03", name: "D12", type: "text", align: "center", width: "50" },
    { title: "04", name: "D13", type: "text", align: "center", width: "50" },
    { title: "05", name: "D14", type: "text", align: "center", width: "50" },
    { title: "06", name: "D15", type: "text", align: "center", width: "50" },
    { title: "07", name: "D16", type: "text", align: "center", width: "50" },
    { title: "08", name: "D17", type: "text", align: "center", width: "50" },
    { title: "09", name: "D18", type: "text", align: "center", width: "50" },
    { title: "10", name: "D19", type: "text", align: "center", width: "50" },
    { title: "11", name: "D20", type: "text", align: "center", width: "50" },
    { title: "12", name: "D21", type: "text", align: "center", width: "50" },
    { title: "13", name: "D22", type: "text", align: "center", width: "50" },
    { title: "14", name: "D23", type: "text", align: "center", width: "50" },
    { title: "15", name: "D24", type: "text", align: "center", width: "50" },
    { title: "16", name: "D25", type: "text", align: "center", width: "50" },
    { title: "17", name: "D26", type: "text", align: "center", width: "50" },
    { title: "18", name: "D27", type: "text", align: "center", width: "50" },
    { title: "19", name: "D28", type: "text", align: "center", width: "50" },
    { title: "20", name: "D29", type: "text", align: "center", width: "50" }
];

var fields30 = [
    { title: "No.", name: "ROWNUMBER", type: "text", align: "center", width: "30", sorting: false,
        itemTemplate: function(value, item) {
            return $("#empDailyWorkGrid").jsGrid("option", "data").indexOf(item) + 1;
        }
    },
    { title: "성명", name: "ENAME", type: "text", align: "center", width: "80" },
    { title: "사번", name: "PERNR", type: "text", align: "center", width: "80",
        itemTemplate: function(value, item) {
            return item.PERNR.length == 8 ? item.PERNR.substring(3, 8) : item.PERNR;
        }
    },
    { title: "잔여</br>휴가", name: "REMA_HUGA", type: "text", align: "center", width: "50",
        itemTemplate: function(value) {
            if (parseInt(value) > 0 || value == "0") {
                return pointFormat(value, 1);
            } else {
                return "0" + value;
            }
        }
    },
    { title: "잔여</br>보상</br>휴가", name: "REMA_RWHUGA", type: "text", align: "center", width: "50",
        itemTemplate: function(value) {
            if (parseInt(value) > 0 || value == "0") {
                return pointFormat(value, 2);
            } else {
                return "0" + value;
            }
        }
    },
    { title: "21", name: "D1", type: "text", align: "center", width:  "50" },
    { title: "22", name: "D2", type: "text", align: "center", width:  "50" },
    { title: "23", name: "D3", type: "text", align: "center", width:  "50" },
    { title: "24", name: "D4", type: "text", align: "center", width:  "50" },
    { title: "25", name: "D5", type: "text", align: "center", width:  "50" },
    { title: "26", name: "D6", type: "text", align: "center", width:  "50" },
    { title: "27", name: "D7", type: "text", align: "center", width:  "50" },
    { title: "28", name: "D8", type: "text", align: "center", width:  "50" },
    { title: "29", name: "D9", type: "text", align: "center", width:  "50" },
    { title: "30", name: "D10", type: "text", align: "center", width: "50" },
    { title: "01", name: "D11", type: "text", align: "center", width: "50" },
    { title: "02", name: "D12", type: "text", align: "center", width: "50" },
    { title: "03", name: "D13", type: "text", align: "center", width: "50" },
    { title: "04", name: "D14", type: "text", align: "center", width: "50" },
    { title: "05", name: "D15", type: "text", align: "center", width: "50" },
    { title: "06", name: "D16", type: "text", align: "center", width: "50" },
    { title: "07", name: "D17", type: "text", align: "center", width: "50" },
    { title: "08", name: "D18", type: "text", align: "center", width: "50" },
    { title: "09", name: "D19", type: "text", align: "center", width: "50" },
    { title: "10", name: "D20", type: "text", align: "center", width: "50" },
    { title: "11", name: "D21", type: "text", align: "center", width: "50" },
    { title: "12", name: "D22", type: "text", align: "center", width: "50" },
    { title: "13", name: "D23", type: "text", align: "center", width: "50" },
    { title: "14", name: "D24", type: "text", align: "center", width: "50" },
    { title: "15", name: "D25", type: "text", align: "center", width: "50" },
    { title: "16", name: "D26", type: "text", align: "center", width: "50" },
    { title: "17", name: "D27", type: "text", align: "center", width: "50" },
    { title: "18", name: "D28", type: "text", align: "center", width: "50" },
    { title: "19", name: "D29", type: "text", align: "center", width: "50" },
    { title: "20", name: "D30", type: "text", align: "center", width: "50" }
];

var fields31 = [
    { title: "No.", name: "ROWNUMBER", type: "text", align: "center", width: "30", sorting: false,
        itemTemplate: function(value, item) {
            return $("#empDailyWorkGrid").jsGrid("option", "data").indexOf(item) + 1;
        }
    },
    { title: "성명", name: "ENAME", type: "text", align: "center", width: "80" },
    { title: "사번", name: "PERNR", type: "text", align: "center", width: "80",
        itemTemplate: function(value, item) {
            return item.PERNR.length == 8 ? item.PERNR.substring(3, 8) : item.PERNR;
        }
    },
    { title: "잔여</br>휴가", name: "REMA_HUGA", type: "text", align: "center", width: "50",
        itemTemplate: function(value) {
            if (parseInt(value) > 0 || value == "0") {
                return pointFormat(value, 1);
            } else {
                return "0" + value;
            }
        }
    },
    { title: "잔여</br>보상</br>휴가", name: "REMA_RWHUGA", type: "text", align: "center", width: "50",
        itemTemplate: function(value) {
            if (parseInt(value) > 0 || value == "0") {
                return pointFormat(value, 2);
            } else {
                return "0" + value;
            }
        }
    },
    { title: "21", name: "D1", type: "text", align: "center", width:  "50" },
    { title: "22", name: "D2", type: "text", align: "center", width:  "50" },
    { title: "23", name: "D3", type: "text", align: "center", width:  "50" },
    { title: "24", name: "D4", type: "text", align: "center", width:  "50" },
    { title: "25", name: "D5", type: "text", align: "center", width:  "50" },
    { title: "26", name: "D6", type: "text", align: "center", width:  "50" },
    { title: "27", name: "D7", type: "text", align: "center", width:  "50" },
    { title: "28", name: "D8", type: "text", align: "center", width:  "50" },
    { title: "29", name: "D9", type: "text", align: "center", width:  "50" },
    { title: "30", name: "D10", type: "text", align: "center", width: "50" },
    { title: "31", name: "D11", type: "text", align: "center", width: "50" },
    { title: "01", name: "D12", type: "text", align: "center", width: "50" },
    { title: "02", name: "D13", type: "text", align: "center", width: "50" },
    { title: "03", name: "D14", type: "text", align: "center", width: "50" },
    { title: "04", name: "D15", type: "text", align: "center", width: "50" },
    { title: "05", name: "D16", type: "text", align: "center", width: "50" },
    { title: "06", name: "D17", type: "text", align: "center", width: "50" },
    { title: "07", name: "D18", type: "text", align: "center", width: "50" },
    { title: "08", name: "D19", type: "text", align: "center", width: "50" },
    { title: "09", name: "D20", type: "text", align: "center", width: "50" },
    { title: "10", name: "D21", type: "text", align: "center", width: "50" },
    { title: "11", name: "D22", type: "text", align: "center", width: "50" },
    { title: "12", name: "D23", type: "text", align: "center", width: "50" },
    { title: "13", name: "D24", type: "text", align: "center", width: "50" },
    { title: "14", name: "D25", type: "text", align: "center", width: "50" },
    { title: "15", name: "D26", type: "text", align: "center", width: "50" },
    { title: "16", name: "D27", type: "text", align: "center", width: "50" },
    { title: "17", name: "D28", type: "text", align: "center", width: "50" },
    { title: "18", name: "D29", type: "text", align: "center", width: "50" },
    { title: "19", name: "D30", type: "text", align: "center", width: "50" },
    { title: "20", name: "D31", type: "text", align: "center", width: "50" }
];
</script>