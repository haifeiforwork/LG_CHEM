<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!--// Page Title start -->
<div class="title">
    <h1>휴가사용현황</h1>
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
<!--// list start -->
<div class="listArea">    
    <h2 class="subtitle">부서명 : ${fn:escapeXml( user.e_orgtx )} &lt;총 <span id="total">0</span> 건&gt;</h2>        
    <div class="clear"></div>    
    <div id="empVacationGrid"></div>
</div>
<!--// list end -->
<!-- layout body end -->
<script>
function getEmpNo(value) {

    return value.replace(/.*(.{5})$/, '$1'); // 우측 5자만 남김
}

function toFixed2(value) {

    return nelim(value || 0, 2).toFixed(2);
}

$(function() {

var colgroup = [
    '<colgroup>',
    '<col style="width: 5.0em" />',
    '<col style="width: 8.0em" />',
    '<col style="width:15.0em" />',
    '<col style="width: 7.0em" />',
    '<col style="width: 6.0em" />',
    '<col style="width: 6.0em" />',
    '<col style="width: 4.0em" />',
    '<col style="width: 4.0em" />',
    '<col style="width: 7.0em" />',
    '<col style="width: 4.5em" />',
    '<col style="width: 4.5em" />',
    '<col style="width: 4.5em" />',
    '<col style="width: 4.5em" />',
    '<col style="width: 4.5em" />',
    '<col style="width: 4.5em" />',
    '<col style="width: 4.5em" />',
    '<col style="width: 4.5em" />',
    '<col style="width: 4.5em" />',
    '</colgroup>'
].join('');

$("#empVacationGrid").jsGrid({
    height: "auto",
    sorting: false,
    paging: false,
    autoload: true,
    controller : {
        loadData : function() {
            var d = $.Deferred();
            $.ajax({
                url : "/dept/getEmpVacationDataList.json",
                type : "GET",
                dataType : "json"
            }).done(function(response) {
                if (response.success) {
                    $('#total').text(response.storeData.length);

                    var thead = $("#empVacationGrid .jsgrid-grid-header table");
                    if (!thead.find('colgroup').length) {
                        thead.prepend(colgroup);
                    }
                    var tbody = $("#empVacationGrid .jsgrid-grid-body table");
                    if (!tbody.find('colgroup').length) {
                        tbody.prepend(colgroup);
                    }

                    d.resolve(response.storeData);
                } else {
                    alert("조회시 오류가 발생하였습니다.\n\n" + response.message);
                }
            });
            return d.promise();
        }
    },
    headerRowRenderer: function() {

        return [
        '<tr>',
            '<th rowspan="2">사번</th>',
            '<th rowspan="2">이름</th>',
            '<th rowspan="2">소속</th>',
            '<th rowspan="2">직책</th>',
            '<th rowspan="2">직위</th>',
            '<th rowspan="2">직급</th>',
            '<th rowspan="2">호봉</th>',
            '<th rowspan="2">연차</th>',
            '<th rowspan="2">입사일자</th>',
            '<th colspan="4">연차 휴가</th>',
            '<th colspan="5">보상 휴가</th>',
        '</tr><tr>',
            '<th>발생<br />일수</th>',
            '<th>사용<br />일수</th>',
            '<th>잔여<br />일수</th>',
            '<th>사용률<br />(%)</th>',
            '<th>발생<br />일수</th>',
            '<th>보상<br />일수</th>',
            '<th>사용<br />일수</th>',
            '<th>잔여<br />일수</th>',
            '<th>사용률<br />(%)</th>',
        '</tr>'
        ].join('');
    },
    fields : [
        { title: "사번", name: "PERNR", type: "text", align: "center", itemTemplate: getEmpNo },
        { title: "이름", name: "KNAME", type: "text", align: "center" },
        { title: "소속", name: "ORGTX", type: "text", align: "center" },
        { title: "직책", name: "TITL2", type: "text", align: "center" },
        { title: "직위", name: "TITEL", type: "text", align: "center" },
        { title: "직급", name: "TRFGR", type: "text", align: "center" },
        { title: "호봉", name: "TRFST", type: "number", align: "center" },
        { title: "연차", name: "VGLST", type: "number", align: "center" },
        { title: "입사일자", name: "DAT01", type: "number", align: "center" },<%-- 64% --%>

        { title: "발생", name: "OCCUR1", type: "number", align: "right", itemTemplate: toFixed2 },
        { title: "사용", name: "ABWTG1", type: "number", align: "right", itemTemplate: toFixed2 },
        { title: "잔여", name: "ZKVRB1", type: "number", align: "right", itemTemplate: toFixed2 },
        { title: "사용률<br />(%)", name: "CONSUMRATE1", type: "number", align: "right", itemTemplate: toFixed2 },

        { title: "발생", name: "OCCUR2", type: "number", align: "right", itemTemplate: toFixed2 },
        { title: "보상", name: "CMPTG2", type: "number", align: "right", itemTemplate: toFixed2 },
        { title: "사용", name: "ABWTG2", type: "number", align: "right", itemTemplate: toFixed2 },
        { title: "잔여", name: "ZKVRB2", type: "number", align: "right", itemTemplate: toFixed2 },
        { title: "사용률<br />(%)", name: "CONSUMRATE2", type: "number", align: "right", itemTemplate: toFixed2 }
    ]
});

});
</script>