<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<link type="text/css" rel="stylesheet" href="/web-resource/js/jQuery/dynatree/ui.fancytree.min.css" />
<style>
<!--
.tableInquiry input, select {width:auto !important;}
.tableBtnSearch button {position:static;}

.scroll-body {max-height: 410px !important;}
.tableInquiry {margin: 0 0 0 0;}

.listTable td {border-bottom:0;}
-->
</style>
<script type="text/javascript" src="/web-resource/js/jQuery/dynatree/jquery.dynatree.min.js"></script>
<script type="text/javascript" src="/web-resource/js/worktime52/search-popup.js?v=${CACHE_VERSION}"></script>
<script type="text/javascript">
var preSearchOption = '';

$(function() {
	
	$.fetchOrgehData('S');
	
	$('#SEARCH_DATE').datepicker().datepicker("setDate", new Date());
	
	$.bindSearchDateChangeHandler();
	$.bindSearchGubunChangeHandler();
	$.bindSearchOptionRadioHandler();
	$.bindDeptNameKeydownHandler();
	$.bindEmpNameKeydownHandler();
	$.bindIncludeSubOrgCheckboxHandler();
	$.bindSearchOrgInTreeHandler();
	$.bindButtonSearchDeptHandler('S');
	$.bindSearchEmpHandler('S');
	
	$.initListGrid();
	
	$("#planListGrid").jsGrid("search");
	
});

$.initListGrid = function() {
	$("#planListGrid").jsGrid({
        height : "560px",
        width : "100%",
        sorting : true,
        paging : false,
        autoload : false,
        controller : {
            loadData : function() {
                var d = $.Deferred();
                $.ajax({
                    type : "GET",
                    url : "/work/getWorktimePlan.json",
                    dataType : "json",
                    data : {
                    	"SEARCH_GUBUN" : $('[name=searchOption]:checked').val(),
                    	"I_ORGEH" : $('[name=DEPTID]').val(),
                    	"I_PERNR" : $('[name=PERNR]').val(),
                   	 	"I_BEGDA" : $("#SEARCH_DATE").val(),
                   	 	"I_ENDDA" : $("#SEARCH_DATE").val(),
                   	 	"I_LOWERYN" : $('[name=includeSubOrg]').is(':checked') ? 'Y' : 'N',
                   	 	"I_EMPGUB" : $('#SEARCH_EMPGUBUN').val()
                    }
                }).done(function(response) {
                    if(response.success){
                    	preSearchOption = $('[name=searchOption]:checked').val();
                    	
                        d.resolve(response.T_EXPORTA);
                        
                        $('.jsgrid-grid-header').css('overflow-y', 'scroll');
                        $('.jsgrid-grid-body').css('overflow-y', 'scroll');
                    }else{
                        alert("조회시 오류가 발생하였습니다. " + response.message);
                    }
                });
                return d.promise();
            }
        },
        fields: [
            { title: "선택", name: "PERNR", sorting: false, align: "center", width: "8%",
                itemTemplate: function(value, item) {
                    return $("<input type='radio' name='FIRSE_PERNR'>")
                        .on("click", function(e) {
                            $.popFlexInfo(item);
                        });
                }
            },
            { title: "사원구분", name: "PKTXT", type: "text", align: "center", width: "12%" },
            { title: "성명", name: "ENAME", type: "text", align: "center", width: "12%" },
            { title: "부서", name: "ORGTX", type: "text", align: "center", width: "26%" },
            { title: "직책", name: "JIKKT", type: "text", align: "center", width: "14%" },
            { title: "근무지", name: "BTEXT", type: "text", align: "center", width: "14%" },
            { title: "근무시간", name: "WORKTIME", type: "text", align: "center", width: "14%" },
            { name: "PERNR", type: "text", visible: false }
        ]
   });
}

$.popFlexInfo = function(item) {
	$("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
	
   	// 타이틀 셋팅
    $('#flextimeInfoPopupTitle').text('계획근무시간[' + item.ENAME + ']');
   	
   	// parameter string
   	var paramString = $.param(item);
   	
   	// 레포트 호출
    $("#flextimeInfoPopup").attr("src","/work/popFlextimeInfo?" + paramString);
    $("#flextimeInfoPopup").load(function(){
        $('#popLayerFlextimeInfo').popup("show");
        $("body").loader('hide');
    });
}

$.bindSearchDateChangeHandler = function() {
	$('#SEARCH_DATE').change(function() {
		var currentSearchOption = $('[name=searchOption]:checked').val();
		if(currentSearchOption == 'Org') {
			$("#planListGrid").jsGrid("search");
		} else {
			var gridArray = $("#planListGrid").jsGrid("option", "data");
			
			$("#planListGrid").jsGrid("option", "data", []);
			
			$.each(gridArray, function(i, data){
				$.ajax({
		            type : "GET",
		            url : "/work/getWorktimePlan.json",
		            dataType : "json",
		            data : {
		            	"SEARCH_GUBUN" : 'Emp',
		            	"I_PERNR" : data.PERNR,
		           	 	"I_BEGDA" : $("#SEARCH_DATE").val(),
		           	 	"I_ENDDA" : $("#SEARCH_DATE").val()
		            }
		        }).done(function(response) {
		            if(response.success){
		            	$("#planListGrid").jsGrid('insertItem', response.T_EXPORTA[0]);
		            }else{
		                alert("조회시 오류가 발생하였습니다. " + response.message);
		            }
		        });
			});
		}
	});
}

$.bindSearchGubunChangeHandler = function() {
	$('#SEARCH_EMPGUBUN').change(function() {
		$("#planListGrid").jsGrid("search");
	});
}

$.bindSearchOptionRadioHandler = function() {
    $('input[type="radio"][name="searchOption"]').click(function() {

        var v = $(this).val();
        $('div[data-name="search#Wrapper"]'.replace(/#/, v)).show().siblings().hide();
        $('div.searchOrg_ment').css('visibility', v === 'Org' ? 'visible' : 'hidden');
        
        if(v == 'Org') {
        	$('#orgComment').show();
        	$('#SEARCH_EMPGUBUN').show();
        	$('#SEARCH_EMPGUBUN_LABEL').show();
        } else {
        	$('#orgComment').hide();
        	$('#SEARCH_EMPGUBUN').hide();
        	$('#SEARCH_EMPGUBUN_LABEL').hide();
        }
    });
}

function setDeptID(deptId, deptNm) {
	
	$("#popLayerSearchDept").popup('hide');

    var form = $('form[name="searchOrg"]');
    form.find('input[type="hidden"][name="DEPTID"]').val(function() {
        return deptId ? deptId : $(this).data('init');
    });
    form.find('input[type="text"][name="txt_deptNm"]').val(function() {
        return deptNm ? deptNm : $(this).data('init');
    });
    
    $("body").loader('hide');

    $("#planListGrid").jsGrid("search");
}

function setPersInfo(pernr, ename) {
	$("#popLayerSearchEmp").popup('hide');
	
    var form = $('form[name="searchEmp"]');
    form.find('input[type="hidden"][name="PERNR"]').val(pernr);
    form.find('input[type="text"][name="I_VALUE1"]').val(ename);

    if(preSearchOption == 'Emp') {
    	$.ajax({
            type : "GET",
            url : "/work/getWorktimePlan.json",
            dataType : "json",
            data : {
            	"SEARCH_GUBUN" : $('[name=searchOption]:checked').val(),
            	"I_ORGEH" : $('[name=DEPTID]').val(),
            	"I_PERNR" : $('[name=PERNR]').val(),
           	 	"I_BEGDA" : $("#SEARCH_DATE").val(),
           	 	"I_ENDDA" : $("#SEARCH_DATE").val(),
           	 	"I_LOWERYN" : $('[name=includeSubOrg]').is(':checked') ? 'Y' : 'N',
           	 	"I_EMPGUB" : $('#SEARCH_EMPGUBUN').val()
            }
        }).done(function(response) {
            if(response.success){
            	$("#planListGrid").jsGrid('insertItem', response.T_EXPORTA[0]);
            }else{
                alert("조회시 오류가 발생하였습니다. " + response.message);
            }
        });
    } else {
	    $("#planListGrid").jsGrid("search");
    }
}

</script>

<!--// Page Title start -->
<div class="title">
	<h1>계획근무시간 조회</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">근태</a></span></li>
			<li class="lastLocation"><span><a href="#">계획근무시간 조회</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<div class="contentBody" style="min-width:1000px">

	<div class="tableInquiry">
        <table class="worktime" style="min-width:1000px;">
            <colgroup>
                <col style="width:8%" />
                <col style="width:8%" />
                <col style="width:12%" />
                <col style="width:10%" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th rowspan="2">
                        <img class="searchTitle" src="/web-resource/images/top_box_search.gif" />
                    </th>
                    <th style="text-align:right;">
                        <label class="bold">기준일</label>
                    </th>
                	<th style="text-align:left;">
                        <input type="text" id="SEARCH_DATE" class="date required" size="10" />
                    </th>
                    <th rowspan="2" class="divider">
                    	<div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Org" checked="checked" /> 부서검색</label></div>
                        <div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Emp" /> 사원검색</label></div>
                    </th>
                    <th rowspan="2" class="align-left" style="padding-left:10px">
                    	<div data-name="searchOrgWrapper">
                            <form name="searchOrg" method="POST">
                                <div style="float:left; margin-right:20px;">
                                    <input type="hidden" name="DEPTID" data-init="" value="<c:out value='${DEPT_ID}' />" />
                                    <input type="text" name="txt_deptNm" maxlength="10" onfocus="this.select()" data-follow="ORGEH" style="width:200px; ime-mode:active" data-init="" value="<c:out value='${DEPT_NM}' />" />
                                    <a class="icoSearch" href="javascript:;" data-name="searchOrg"><img alt="검색" src="/web-resource/images/ico/ico_magnify.png"></a>
                                </div>
                                <div class="divider" style="margin-left:10px; padding-left:10px;">
                                    <img class="searchIcon" src="/web-resource/images/icon_map_g.gif" />
                                    <label>하위조직포함 <input type="checkbox" name="includeSubOrg" value="Y" /></label>
                                    <div class="tableBtnSearch"><a class="search" href="#" data-name="searchOrgInTree"><span class="icon-magnify"></span><span>조직도로 부서찾기</span></a></div>
                                </div>
                            </form>
                        </div>
                        <div data-name="searchEmpWrapper" style="display:none">
                            <form name="searchEmp" method="POST">
                                <div style="float:left;margin-left:15px;">
                                    <select name="jobid">
                                        <option value="ename">성명별</option>
                                    </select>
                                    <input type="hidden" name="PERNR" />
                                    <input type="text" name="I_VALUE1" maxlength="10" onfocus="this.select()" style="width:103px; ime-mode:active" />
                                    <a class="icoSearch" href="javascript:;" data-name="searchEmp"><img alt="검색" src="/web-resource/images/ico/ico_magnify.png"></a>
                                </div>
                                <div class="tableComment" style="margin-left:10px;padding-left:10px;padding-top:4px;">
							    	<p><span class="bold">사원 검색은 누적하여 조회됩니다.</span></p>
							    </div>
                            </form>
                        </div>
                    </th>
                </tr>
                <tr>
                	<th style="text-align:right;">
                        <label class="bold" id="SEARCH_EMPGUBUN_LABEL">사원구분</label>
                    </th>
                    <th style="text-align:left;">
                    	<select id="SEARCH_EMPGUBUN" style="width:90% !important;margin-left:-1px;">
                        	<option value="">전체</option>
                        	<option value="S">사무직</option>
                        	<option value="H">현장직</option>	
                        </select>
                    </th>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="tableComment" style="margin:-5px 0 30px 0">
    	<p class="float-left"><span class="bold">사원 선택시 년간 일정이 조회됩니다.</span></p>
        <p class="float-right" id="orgComment"><span class="bold">하위조직포함을 선택하면 하위조직까지 조회됩니다.</span></p>
    </div>

	<div class="listArea">	
		<div id="planListGrid"></div>
	</div>

</div>

<!-- 부서검색, 사원검색, 조직도검색 영역 팝업 -->
<%@ include file="../dept/include/searchPopupLayers.jsp" %>
<!--// 부서검색, 사원검색, 조직도검색 영역 팝업 -->

<!-- 개인Flextime Info 영역 팝업 -->
<div class="layerWrapper layerSizeP" id="popLayerFlextimeInfo" style="display:none;width:1060px;">
	<div class="layerHeader">
		<strong id="flextimeInfoPopupTitle"></strong>
		<a href="#" class="btnClose popLayerFlextimeInfo_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<iframe name="reportPopup" id="flextimeInfoPopup" src="" frameborder="0" scrolling="auto" style="width:100%;height:660px;"></iframe>
	</div>
</div>
<!-- END 개인Flextime Info 영역 팝업 -->