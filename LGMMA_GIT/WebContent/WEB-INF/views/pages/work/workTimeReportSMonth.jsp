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

.scroll-body {max-height: 320px !important;}
.tableInquiry {margin: 0 0 10px; 0;}

.listTable td {border-bottom:0;}

.tableBtnSearch a.search {
	display: inline-block;
	position: relative ;
	margin-right: 4px;
	background: url(/web-resource/images/bg_btn_search.gif) no-repeat left top;
	cursor:pointer;
}

.btnClose { display:block; position:absolute; top:14px; right:10px; width:30px; height:30px; background: url('/web-resource/images/btn_popup_close.png') center no-repeat; color:transparent; text-indent:-9999;}
.btnClose>img {margin-top:8px}
-->
</style>

<script type="text/javascript">

function refreshReport() {
	$("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
	
	$('[name=form1]')
		.attr('action', '/work/workTimeReport')
		.attr('target', '_self')
		.submit();
}

(function($) {

	$(function() {
		
		$.setSearchDatepicker();
		
		$.toggleSearchConditionLayer();		// 주간,월간 조회조건 toggle
		
		$.buttonSearchHandler();
		$.buttonExcelHandler();
		$.changeGubunRadioHandler();		// 주간,월간 라디오버튼 이벤트 핸들러
		
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
	
	// 주간,월간 조회조건 toggle
	$.toggleSearchConditionLayer = function() {
		var gubun = $('[name=SEARCH_GUBUN]:checked').val();
		if(gubun == 'W') {
			$('#month_search_div').hide();
			$('#week_search_div').show();
		} else {
			$('#week_search_div').hide();
			$('#month_search_div').show();
		} 
	}
	
	$.buttonSearchHandler = function() {
		$('#searchButton').click(function(e) {
			e.preventDefault();
			
			$("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
			
			$('[name=form1]')
				.attr('action', '/work/workTimeReport')
				.attr('target', '_self')
				.submit();
		});
	}
	
	$.buttonExcelHandler = function() {
		$('#excelButton').click(function(e) {
			e.preventDefault();
			
			$('[name=form1]')
				.attr('action', '/work/workTimeReport?viewMode=excel')
				.attr('target', '_self')
				.submit();
		});
	}
	
	// 주간,월간 라디오버튼 이벤트 핸들러
	$.changeGubunRadioHandler = function() {
		$('[name=SEARCH_GUBUN]').click(function(e) {
			$.toggleSearchConditionLayer();
		});
	}
	
})(jQuery);

</script>

<div class="contentBody" style="min-width:1000px">

<form name="form1" method="post">
	
	<c:if test="${isPop eq 'Y'}">
		<input type="hidden" name="PARAM_PERNR" value="<c:out value='${PERNR}' />" />
		<input type="hidden" name="PARAM_ORGTX" value="<c:out value='${PARAM_ORGTX}' />" />
		<input type="hidden" name="isPop" value="Y" />
	</c:if>
	
	<div class="tableInquiry">
        <table>
            <colgroup>
                <col width="15%" />
                <col width="30%" />
                <col />
            </colgroup>
            <tr>
                <th rowspan="2">
                    <img class="searchTitle" src="/web-resource/images/top_box_search.gif" />
                </th>
                <td>
                	<input type="radio" name="SEARCH_GUBUN" value="W" <c:if test="${SEARCH_GUBUN eq 'W'}">checked</c:if> /> 주간
                	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	<input type="radio" name="SEARCH_GUBUN" value="M" <c:if test="${SEARCH_GUBUN eq 'M'}">checked</c:if> /> 월간
                </td>
                <td>
                	<div class="tableBtnSearch tableBtnSearch2">
                        <button id="searchButton">
                        	<span>조회</span>
                        </button>
                    </div>
                </td>
            </tr>
            <tr id="week_search_div" style="display:none;">
            	<td>
                	조회기준일 
                	&nbsp;&nbsp;&nbsp;&nbsp;
                	<input type="text" name="SEARCH_DATE" id="SEARCH_DATE" class="date required" size="10" value="<c:out value='${SEARCH_DATE}' />" style="line-height:normal;" />
                </td>
                <td>&nbsp;&nbsp; * 조회기준일의 1일~말일 데이터를 조회합니다.</td>
            </tr>
            <tr id="month_search_div">
            	<td>
                	조회년/월
                	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	<c:set var="n" value="2018" />
                    <select name="SEARCH_YEAR">
                    	<c:forEach begin="${n}" end="${CURRENT_YEAR}">
                    		<option value="${n}" <c:if test="${n eq SEARCH_YEAR}">selected</c:if>>${n}</option>
                    		<c:set var="n" value="${n+1}" />
                    	</c:forEach>
                    </select>
                    <c:set var="n" value="1" />
                    <select name="SEARCH_MONTH">
                    	<c:forEach begin="${n}" end="12">
                    		<fmt:formatNumber value="${n}" pattern="00" var="nConvert" />
                    		<option value="${nConvert}" <c:if test="${nConvert eq SEARCH_MONTH}">selected</c:if>>${nConvert}</option>
                    		<c:set var="n" value="${n+1}" />
                    	</c:forEach>
                    </select>
                </td>
                <td>
               		&nbsp;&nbsp; * 조회년월 1일 ~ 말일 데이터를 조회합니다.
                </td>
            </tr>
        </table>
    </div>
    
    <div class="buttonArea">
		<ul class="btn_mdl displayInline">
			<li>
				<a href="#" id="excelButton">
					<span>엑셀다운로드</span>
				</a>
			</li>
		</ul>
	</div>
	
	<h2 class="subtitle">1.주당 평균 근무시간 현황</h2>
	<div class="listArea" style="margin-bottom:0px;padding-bottom:5px;">
        <div class="table">
            <table class="listTable" style="margin-bottom:3px;">
	            <thead>
	            	<tr>
	            		<th class="th02">구분</th>
	            		<th class="th02">월 근무시간 (연차/보상 휴가 포함)</th>
	            		<th class="th02 lastCol">주당 평균 근무시간</th>
	            	</tr>
	            </thead>
	            <tbody>
	            	<c:if test="${not empty ES_HEADER}">
		            	<fmt:parseNumber var="limitNumber" value="52" />
		            	<fmt:parseNumber var="convertWEKAVR" value="${ES_HEADER.WEKAVR}" />
		            	<tr>
		            		<th class="th02">근무시간</th>
		            		<td class="th02">${ES_HEADER.MONSUM}</td>
		            		<td class="lastCol" <c:if test="${convertWEKAVR ge limitNumber}">style="background-color:#FFB6C1;"</c:if>>${ES_HEADER.WEKAVR}</td>
		            	</tr>
	            	</c:if>
	            </tbody>
            </table>
		</div>
	</div>
	
	<div class="commentOne"  style="margin-bottom:10px;">
		<span>주당 평균 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일)</span>
	</div>

	<br/>
	<h2 class="subtitle">2.세부 현황</h2>
	<br/>
	<h2 class="subtitle">근무시간 = 정상근무 + 초과근무 - 휴게 - 비근무</h2>
	<div class="listArea" style="margin-bottom:0px;padding-bottom:5px;">
		<div class="table scroll-table scroll-head">
			<fmt:parseNumber var="colWidth" value="${92 / (fn:length(T_NWKTYP) + 6)}" />
	        <table class="listTable worktime headerTable">
	        	<colgroup>
	        		<col width="8%" />
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
					<c:if test="${not empty T_NWKTYP}">
						<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
							<col width="${colWidth}%" />
						</c:forEach>
					</c:if>
	        		<col width="${colWidth}%" />
        			<col width="${colWidth}%" />
	        	</colgroup>
	            <thead>
	                <tr>
	            		<th rowspan="2">일자</th>
	            		<th rowspan="2">정상근무</th>
	            		<th rowspan="2">초과근무</th>
	            		<th rowspan="2">휴게시간</th>
	            		<th rowspan="2">비근무차감</th>
	            		<c:if test="${not empty T_NWKTYP}">
	            			<th colspan="${fn:length(T_NWKTYP)}">연차/보상 휴가</th>
	            		</c:if>
		            	<th rowspan="2">근무시간</th>
            			<th rowspan="2" class="lastCol">평일 누적근무시간</th>
	            	</tr>
	            	<tr>
            		<c:if test="${not empty T_NWKTYP}">
            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
	            			<th style="width:50px;">${nwktyp.NWKTXT}</th>
	            		</c:forEach>
            		</c:if>
	            	</tr>
	            </thead>
	        </table>
	    </div>
	    <div class="scroll-table scroll-body">
        	<table class="listTable worktime">
        		<colgroup>
	        		<col style="width:8%" />
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
					<c:if test="${not empty T_NWKTYP}">
						<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
							<col width="${colWidth}%" />
						</c:forEach>
					</c:if>
	        		<col width="${colWidth}%" />
        			<col width="${colWidth}%" />
	        	</colgroup>
	            <tbody>
	            	<c:choose>
	            		<c:when test="${empty T_BODY}">
	            			<tr class="oddRow">
								<td class="lastCol align_center" colspan="${fn:length(T_NWKTYP) + 7}">해당하는 데이터가 존재하지 않습니다.</td>
							</tr>
	            		</c:when>
	            		<c:otherwise>
	            			<c:set var="SUM_NORTM" value="0" scope="request" />
			            	<c:set var="SUM_OVRTM" value="0" scope="request" />
			            	<c:set var="SUM_BRKTM" value="0" scope="request" />
			            	<c:set var="SUM_NWKTM" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP1" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP2" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP3" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP4" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP5" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP6" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP7" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP8" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP9" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP10" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP11" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP12" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP13" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP14" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP15" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP16" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP17" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP18" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP19" value="0" scope="request" />
			            	<c:set var="SUM_NWKTYP20" value="0" scope="request" />
			            	<c:set var="SUM_RWKTM" value="0" scope="request" />
			            	
			            	<fmt:parseNumber var="limitNumber" value="52" />
			            	
		            		<c:forEach var="body" items="${T_BODY}" varStatus="status">
			           			<c:choose>
			           				<c:when test="${fn:indexOf(body.DAYTX, '소계') > -1}">
			           					<c:set var="tdStyle" value="background-color:#F6EDB8;" />
			           					<c:set var="tdStyle2" value="" />
			           				</c:when>
			           				<c:when test="${body.BASOVR eq 'X'}">
			           					<c:set var="tdStyle" value="" />
			           					<c:set var="tdStyle2" value="background-color:#e9ffd2;" />
			           				</c:when>
			           				<c:otherwise>
			           					<c:set var="tdStyle" value="" />
			           					<c:set var="tdStyle2" value="" />
			           				</c:otherwise>
			           			</c:choose>
				            	<tr class="borderRow">
			            			<td style="padding-top:0px;${tdStyle}">${body.DAYTX}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.NORTM}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.OVRTM}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.BRKTM}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.NWKTM}</td>
			            			<c:if test="${not empty T_NWKTYP}">
				            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
					            			<td style="width:50px;padding-top:0px;${tdStyle}">${body[nwktyp.FLDNM]}</td>
					            			<c:choose>
					            				<c:when test="${status.count eq 1}"><c:set var="SUM_NWKTYP1" value="${SUM_NWKTYP1 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 2}"><c:set var="SUM_NWKTYP2" value="${SUM_NWKTYP2 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 3}"><c:set var="SUM_NWKTYP3" value="${SUM_NWKTYP3 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 4}"><c:set var="SUM_NWKTYP4" value="${SUM_NWKTYP4 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 5}"><c:set var="SUM_NWKTYP5" value="${SUM_NWKTYP5 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 6}"><c:set var="SUM_NWKTYP6" value="${SUM_NWKTYP6 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 7}"><c:set var="SUM_NWKTYP7" value="${SUM_NWKTYP7 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 8}"><c:set var="SUM_NWKTYP8" value="${SUM_NWKTYP8 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 9}"><c:set var="SUM_NWKTYP9" value="${SUM_NWKTYP9 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 10}"><c:set var="SUM_NWKTYP10" value="${SUM_NWKTYP10 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 11}"><c:set var="SUM_NWKTYP11" value="${SUM_NWKTYP11 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 12}"><c:set var="SUM_NWKTYP12" value="${SUM_NWKTYP12 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 13}"><c:set var="SUM_NWKTYP13" value="${SUM_NWKTYP13 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 14}"><c:set var="SUM_NWKTYP14" value="${SUM_NWKTYP14 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 15}"><c:set var="SUM_NWKTYP15" value="${SUM_NWKTYP15 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 16}"><c:set var="SUM_NWKTYP16" value="${SUM_NWKTYP16 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 17}"><c:set var="SUM_NWKTYP17" value="${SUM_NWKTYP17 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 18}"><c:set var="SUM_NWKTYP18" value="${SUM_NWKTYP18 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 19}"><c:set var="SUM_NWKTYP19" value="${SUM_NWKTYP19 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 20}"><c:set var="SUM_NWKTYP20" value="${SUM_NWKTYP20 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            			</c:choose>
					            		</c:forEach>
				            		</c:if>
				            		<fmt:parseNumber var="convertRWKTM" value="${body.RWKTM}" />
				            		<c:choose>
				            			<c:when test="${convertRWKTM ge limitNumber}"><c:set var="bgColor" value="background-color:#FFB6C1;" /></c:when>
				            			<c:otherwise><c:set var="bgColor" value="background-color:#F6EDB8;" /></c:otherwise>
				            		</c:choose>
			            			<td style="padding-top:0px;font-weight:bold;${bgColor}">${body.RWKTM}</td>
		            				<td class="lastCol" style="padding-top:0px;${tdStyle2}">${body.RWSUMA ne '0' ? body.RWSUMA : ''}</td>
				            	</tr>
				            	<c:set var="SUM_NORTM" value="${SUM_NORTM +body.NORTM}" />
				            	<c:set var="SUM_OVRTM" value="${SUM_OVRTM +body.OVRTM}" />
				            	<c:set var="SUM_BRKTM" value="${SUM_BRKTM +body.BRKTM}" />
				            	<c:set var="SUM_NWKTM" value="${SUM_NWKTM +body.NWKTM}" />
				            	<c:set var="SUM_RWKTM" value="${SUM_RWKTM +body.RWKTM}" />
		            		</c:forEach>
		            		<tr id="total_calc_row" class="sumRow">
		            			<td style="padding-top:0px;background-color:#FFB6C1;">합계</td>
		            			<td style="padding-top:0px;background-color:#FFB6C1;">
		            				<c:choose>
				            			<c:when test="${SUM_NORTM eq 0}">0</c:when>
				            			<c:otherwise><fmt:formatNumber value="${SUM_NORTM}" pattern="0.00" /></c:otherwise>
			            			</c:choose>
		            			</td>
		            			<td style="padding-top:0px;background-color:#FFB6C1;">
		            				<c:choose>
				            			<c:when test="${SUM_OVRTM eq 0}">0</c:when>
				            			<c:otherwise><fmt:formatNumber value="${SUM_OVRTM}" pattern="0.00" /></c:otherwise>
			            			</c:choose>
			            		</td>
		            			<td style="padding-top:0px;background-color:#FFB6C1;">
		            				<c:choose>
				            			<c:when test="${SUM_BRKTM eq 0}">0</c:when>
				            			<c:otherwise><fmt:formatNumber value="${SUM_BRKTM}" pattern="0.00" /></c:otherwise>
			            			</c:choose>
			            		</td>
		            			<td style="padding-top:0px;background-color:#FFB6C1;">
		            				<c:choose>
				            			<c:when test="${SUM_NWKTM eq 0}">0</c:when>
				            			<c:otherwise><fmt:formatNumber value="${SUM_NWKTM}" pattern="0.00" /></c:otherwise>
			            			</c:choose>
			            		</td>
		            			<c:if test="${not empty T_NWKTYP}">
			            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
				            			<td style="padding-top:0px;background-color:#FFB6C1;">
					            			<c:set var="fName" value="SUM_NWKTYP${status.count}" scope="request" />
					            			<c:choose>
						            			<c:when test="${requestScope[fName] eq 0}">0</c:when>
						            			<c:otherwise><fmt:formatNumber value="${requestScope[fName]}" pattern="0.00" /></c:otherwise>
					            			</c:choose>
				            			</td>
				            		</c:forEach>
			            		</c:if>
		            			<td style="font-weight:bold;background-color:#FFB6C1;">
		            				<c:choose>
				            			<c:when test="${SUM_RWKTM eq 0}">0</c:when>
				            			<c:otherwise><fmt:formatNumber value="${SUM_RWKTM}" pattern="0.00" /></c:otherwise>
			            			</c:choose>
			            		</td>
		            			<td class="lastCol" style="padding-top:0px;background-color:#FFB6C1;"></td>
		            		</tr>
	            		</c:otherwise>
	            	</c:choose>
	            </tbody>
        	</table>
        </div>
	</div>
	<div class="commentOne">
		<span>근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.</span>
	</div>
	
</form>

</div>