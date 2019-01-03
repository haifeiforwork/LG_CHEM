<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
<!--
.tableInquiry input, select {width:auto !important;}
.tableBtnSearch button {position:static;}
.tableInquiry table th {text-align:center;}
.tableInquiry table .divider {border-left:1px solid #ddd;}

div.tableInquiry table th div.vertical-radio {display:block}
div.tableInquiry table th div.vertical-radio label {margin-bottom:0}

.scroll-body {max-height: 410px !important;}
.tableInquiry {margin: 0 0 0 0;}

.listTable td {border-bottom:0;}

.tableBtnSearch a.search {
	display: inline-block;
	position: relative ;
	margin-right: 4px;
	background: url(/web-resource/images/bg_btn_search.gif) no-repeat left top;
	cursor:pointer;
}
-->
</style>

<script type="text/javascript">

$(function() {
	
	$.setSearchDatepicker();
	
	$.bindSearchButtonHandler();
	$.buttonExcelHandler();
	
	$.bindNameClickPopup();
	
	$('.headerTable > thead').find('th').each(function() {
		$(this).css('border-bottom', '0');
	});
	
});

$.setSearchDatepicker = function() {
	var param_search_date = $('#SEARCH_DATE').val();
	var obj_search_date;
	
	if(param_search_date.length == 8) {
		obj_search_date = new Date(param_search_date.substr(0, 4) + '-' + param_search_date.substr(4, 2) + '-' + param_search_date.substr(6, 2));
	} else if(param_search_date.indexOf('.') > -1) {
		obj_search_date = new Date(param_search_date.split('.').join('-'));
	} else {
		obj_search_date = new Date();
	}
	
	$('#SEARCH_DATE').datepicker().datepicker("setDate", obj_search_date);
}

$.bindSearchButtonHandler = function() {
	$('#searchButton').click(function(e) {
		e.preventDefault();
		
		$("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
		
		$('[name=form1]')
			.attr('action', '/dept/workTimeHDeptReport')
			.attr('target', '_self')
			.submit();
	});
}

$.buttonExcelHandler = function() {
	$('#excelButton').click(function(e) {
		e.preventDefault();
		
		$('[name=form1]')
			.attr('action', '/excel/workTimeHDeptReportExcel')
			.attr('target', '_self')
			.submit();
	});
}

$.bindNameClickPopup = function() {
	$('#reportContents').find('a').each(function() {
		$(this).click(function(e) {
			e.preventDefault();
			
			var empGubun = 'H';
			var datum = $('[name=SEARCH_DATE]').val();
			if(datum.indexOf('.') > -1) {
				datum = datum.split('.').join('');
			}
			var year = datum.substring(0, 4);
			var month = datum.substring(4, 6);
			var day = datum.substring(6, 8);

			var paramObj = {};
		    paramObj.isPop = 'Y';
		    paramObj.PARAM_ENAME = $(this).data('ename');
		    paramObj.PARAM_PERNR = $(this).data('pernr');
		    paramObj.PARAM_ORGTX = $(this).data('orgtx');
		   	paramObj.SEARCH_DATE = datum;
	    	paramObj.SEARCH_YEAR = year;
	    	paramObj.SEARCH_MONTH = month;
		   	
		   	$.callReportPopup(paramObj);
		});
	});
}

$.callReportPopup = function(paramsObj){
	$("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
	
   	// 타이틀 셋팅
    $('#reportPopupTitle').text(paramsObj.PARAM_ENAME + '(' + paramsObj.PARAM_PERNR + ') ' + paramsObj.PARAM_ORGTX);
   	
   	// parameter string
   	var paramString = $.param(paramsObj);
   	
   	// 레포트 호출
    $("#reportPopup").attr("src","/work/workTimeReport?" + paramString);
    $("#reportPopup").load(function(){
        $('#popLayerWorkReport').popup("show");
        $("body").loader('hide');
    });
}

</script>

<div class="contentBody" style="min-width:1000px">

	<div class="tableInquiry" style="margin-bottom:0px;">
    	<form name="form1" method="post">
		<table>
			<colgroup>
				<col width="13%" />
				<col width="21%" /><!-- 조회 기준일 -->
				<col />
			</colgroup>
			<tr>
				<th rowspan="2">
                    <img class="searchTitle" src="/web-resource/images/top_box_search.gif" />
                </th>
				<td>
					<label class="bold">조회기준일</label>
					&nbsp;
                	<input type="text" id="SEARCH_DATE" name="SEARCH_DATE" class="date required" size="10" value="${SEARCH_DATE}" style="line-height:normal;" />
				</td>
				<td>
					<div class="tableBtnSearch tableBtnSearch2">
                        <button id="searchButton">
                        	<span>조회</span>
                        </button>
                    </div>
				</td>
			</tr>
		</table>
    	</form>
	</div>
    <div class="tableComment" style="margin:-5px 0 30px 0">
        <p id="searchOrg_ment"><span class="bold">조회기준일이 속한 탄력근무 기간 데이터를 조회합니다.</span></p>
    </div>

	<br/>
	
	<div class="frameWrapper">
		<div class="buttonArea" style="float:right;">
			<ul class="btn_mdl displayInline">
				<li>
				<a href="#" id="excelButton">
					<span>엑셀다운로드</span>
					</a>
				</li>
			</ul>
		</div>
		
		<h2 class="subtitle">해당 사번을 클릭하면, 세부 현황이 조회됩니다.</h2>
		<br/>
		
		<div class="listArea" style="margin-bottom:0px;">
			<div class="table scroll-table scroll-head">
				<table class="listTable worktime headerTable">
					<colgroup>
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="25%" />
		        		<col width="16%" />
						<col width="10%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        	</colgroup>
					<thead>
						<tr>
							<th class="th02" rowspan="2">사번</th>
							<th class="th02" rowspan="2">이름</th>
							<th class="th02" rowspan="2">소속</th>
							<th class="th02" rowspan="2">주당 실근무시간<br/>${not empty T_RESULT ? T_RESULT[0].WTEXT : ""}</th>
							<th class="th02" colspan="4">기간별 주 평균시간</th>
						</tr>
						<tr>
							<th class="th02 border-left" rowspan="2">기간</th>
							<th class="th02">기준시간<br/>(52*주)</th>
							<th class="th02">실 근무시간</th>
							<th class="th02">주 평균시간</th>
						</tr>
					</thead>
				</table>
			</div>
			<div class="scroll-table scroll-body">
				<table class="listTable worktime">
					<colgroup>
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="25%" />
		        		<col width="16%" />
						<col width="10%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        		<col width="10%" />
		        	</colgroup>
					<tbody id="reportContents">
						<c:choose>
							<c:when test="${empty T_RESULT}">
								<tr class="oddRow">
									<td class="lastCol align_center" colspan="11">해당하는 데이터가 존재하지 않습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<fmt:parseNumber var="limitNumber" value="52" />
								<c:forEach var="result" items="${T_RESULT}" varStatus="status">
									<c:set var="convertPernr" value="${fn:length(result.PERNR) == 8 ? fn:substring(result.PERNR,3,8) : result.PERNR}" />
									<tr class="borderRow">
										<td><a href="#" style="color:blue;" data-ename="${result.ENAME}" data-pernr="${convertPernr}" data-orgtx="${result.ORGEHTX}">${convertPernr}</a></td>
										<td>${result.ENAME}</td>
										<td>${result.ORGEHTX}</td>
										<td>
											<fmt:formatNumber var="decimalPoint" value="${(result.WRWKTM % 1) % 0.1}" />
		         							<fmt:formatNumber value="${result.WRWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
										</td>
										<td>${result.ADJUNTTX}</td>
										<td>
											<c:choose>
				            					<c:when test="${result.RMAXTM eq '0'}">${result.RMAXTM}</c:when>
				            					<c:otherwise><fmt:formatNumber value="${result.RMAXTM}" pattern="#,##0.00" /></c:otherwise>
				            				</c:choose>
										</td>
										<td>
											<fmt:formatNumber var="decimalPoint" value="${(result.RRWKTM % 1) % 0.1}" />
		         							<fmt:formatNumber value="${result.RRWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="#,##0.0" />
										</td>
										<fmt:parseNumber var="convertRAVRTM" value="${result.RAVRTM}" />
										<td <c:if test="${convertRAVRTM ge limitNumber}">style="background-color:#FFB6C1;"</c:if>>
											<fmt:formatNumber var="decimalPoint" value="${(result.RAVRTM % 1) % 0.1}" />
		            						<fmt:formatNumber value="${result.RAVRTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
										</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>
	</div>

</div>

<!-- 개인Report 영역 팝업 -->
<div class="layerWrapper layerSizeP" id="popLayerWorkReport" style="display:none;width:1060px;">
	<div class="layerHeader">
		<strong id="reportPopupTitle"></strong>
		<a href="#" class="btnClose popLayerWorkReport_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<iframe name="reportPopup" id="reportPopup" src="" frameborder="0" scrolling="auto" style="width:100%;height:800px;"></iframe>
	</div>
</div>
<!-- END 개인Report 영역 팝업 -->