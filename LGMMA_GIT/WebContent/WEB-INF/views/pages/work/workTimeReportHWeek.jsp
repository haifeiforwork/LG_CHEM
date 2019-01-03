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
		
		$.buttonSearchHandler();
		$.buttonExcelHandler();
		$.changeSearchDateHandler();	// 검색일자 change 이벤트 핸들러
		
		// 공통 css에서 바인딩 되어있는 hover이벤트 제거용
		$(".headerTitleRow")
			.removeClass("listTableHover")
			.each(function(index) {
				if(index > 0) {
					$(this).find('th').each(function() {
						$(this).css('border-top', '1px solid #dddddd');
					});
				}
			});
		
		// 주당 실근무시간 현황 Boder 추가
		$('.header_info_table').find('td').not('.lastCol').each(function() {
			$(this).css('border-right', '1px solid #dddddd');
		});
		
		$('.headerTable > thead').find('th').each(function() {
			$(this).css('border-bottom', '0');
		});
		
		// 1주 근무유형일 경우 월간 라디오버튼 숨김
		<c:if test="${S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W'}">
		$('[name=SEARCH_GUBUN]').eq(1).hide().next().hide();
		</c:if>
		
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
	
	// 검색일자 change 이벤트 핸들러
	$.changeSearchDateHandler = function() {
		$('[name=SEARCH_DATE]').change(function() {
			$.callNTMP9810($(this).val());
		});
	}
	
	// 1주 근무유형인지 판단하는 RFC를 호출한다.
	// E_2190T-RADJPRD = '01' AND E_2190T-RADJUNT = 'W'일 경우 월간 라디오버튼 숨김
	$.callNTMP9810 = function(searchDate) {
	    $("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
	    
	    $.ajax({
	 		type : 'POST',
	 		url : '/work/getNTM9810.json',
	 		cache : false,
	 		dataType : 'json',
	 		data : {
	 			PERNR: '${PERNR}',
	 			DATUM: searchDate
	 		},
	 		async :false,
	 		success : function(response) {
	 			$.callBackRadioHandler(response.storeData);
	 		},
	 		error : function(jqXHR, textStatus, errorThrown ) {
	 			alert("Error\n" + textStatus);
	 			$("body").loader('hide');
	 		}
	 	});
	}
	
	// E_2190T-RADJPRD = '01' AND E_2190T-RADJUNT = 'W'일 경우 월간 라디오버튼 숨김
	$.callBackRadioHandler = function(data) {
		$("body").loader('hide');
		
		if(data != '') {
			if(data.flag=="N" || data.flag=="E") {
				alert(data.msg);
				return ;
			} else if(data.S_2190T.RADJPRD == '01' && data.S_2190T.RADJUNT == 'W') {
				$('[name=SEARCH_GUBUN]').eq(1).hide().next().hide();
			} else {
				$('[name=SEARCH_GUBUN]').eq(1).show().next().show();
			}
		}
	}
	
})(jQuery);

</script>

<div class="contentBody" style="min-width:1000px">

<form name="form1" method="post">
	
	<c:if test="${isPop eq 'Y'}">
		<input type="hidden" name="PARAM_PERNR" value="${PERNR}" />
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
                	<input type="radio" name="SEARCH_GUBUN" value="W" <c:if test="${SEARCH_GUBUN eq 'W'}">checked</c:if> /> <span>주간</span>
                	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	<input type="radio" name="SEARCH_GUBUN" value="M" <c:if test="${SEARCH_GUBUN eq 'M'}">checked</c:if> /> <span>월간</span>
                </td>
                <td>
                	<div class="tableBtnSearch tableBtnSearch2">
                        <button id="searchButton">
                        	<span>조회</span>
                        </button>
                    </div>
                </td>
            </tr>
            <tr>
            	<td>
                	조회기준일 
                	&nbsp;&nbsp;&nbsp;&nbsp;
                	<input type="text" name="SEARCH_DATE" id="SEARCH_DATE" class="date required" size="10" value="<c:out value='${SEARCH_DATE}' />" style="line-height:normal;" />
                </td>
                <td>
               		&nbsp;&nbsp; <%-- * 조회기준일이 속한 탄력근무 기간 데이터를 조회합니다. --%>
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
	
	<h2 class="subtitle">1.주당 실 근무시간 현황</h2>
	<br/>
	<div class="listArea">
        <div class="table">
        	<c:set var="headerCount" value="${fn:length(T_HEADER)}" />
        	<fmt:parseNumber var="rowCount" value="${((headerCount - 1) / 6) + 1}" integerOnly="true" />
            <fmt:parseDate value="${fn:join(fn:split(SEARCH_DATE, '.'), '')}" pattern="yyyyMMdd" var="convertSearchDate" />
            <table class="listTable header_info_table" style="margin-bottom:3px;">
            <c:forEach begin="1" end="${rowCount}" varStatus="rowStatus">
            	<c:set var="beginNum" value="${(rowStatus.count - 1) * 6}" />
            	<c:set var="endNum" value="${(rowStatus.count * 6) - 1}" />
            	<tr class="headerTitleRow" style="background-color:#f5f5f5;">
            		<th class="th02">구분</th>
            		<c:choose>
            			<c:when test="${headerCount < 6}">
            				<c:forEach var="result" items="${T_HEADER}" varStatus="headerStatus">
            					<fmt:parseDate value="${fn:join(fn:split(result.BEGDA, '-'), '')}" pattern="yyyyMMdd" var="convertBegda" />
		            			<fmt:parseDate value="${fn:join(fn:split(result.ENDDA, '-'), '')}" pattern="yyyyMMdd" var="convertEndda" />
            					<th class="th02 <c:if test="${rowCount ne 1 && headerStatus.last && S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W'}">lastCol</c:if>" <c:if test="${convertSearchDate ge convertBegda && convertSearchDate le convertEndda}">style="background-color:#E9FFD2;"</c:if>>
            						${result.GUBUN}
            					</th>
            				</c:forEach>
            			</c:when>
            			<c:otherwise>
            				<c:forEach var="header" begin="${beginNum}" end="${endNum}" varStatus="headerStatus">
            					<fmt:parseDate value="${fn:join(fn:split(T_HEADER[headerStatus.index].BEGDA, '-'), '')}" pattern="yyyyMMdd" var="convertBegda" />
		            			<fmt:parseDate value="${fn:join(fn:split(T_HEADER[headerStatus.index].ENDDA, '-'), '')}" pattern="yyyyMMdd" var="convertEndda" />
								<th class="th02 <c:if test="${rowCount ne 1 && headerStatus.last && S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W'}">lastCol</c:if>" <c:if test="${convertSearchDate ge convertBegda && convertSearchDate le convertEndda}">style="background-color:#E9FFD2;"</c:if>>
									${T_HEADER[headerStatus.index].GUBUN eq null ? '' : T_HEADER[headerStatus.index].GUBUN}
								</th>
							</c:forEach>
            			</c:otherwise>
            		</c:choose>
					<c:if test="${rowStatus.count eq 1 && !(S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W')}">
            			<th class="lastCol">주당 평균 실 근무시간</th>
            		</c:if>
            	</tr>
            	<tr>
            		<th style="border-right:1px solid #dddddd !important;">실 근무시간</th>
            		<c:choose>
            			<c:when test="${headerCount < 6}">
            				<c:forEach var="result" items="${T_HEADER}" varStatus="headerStatus">
		            			<fmt:parseDate value="${fn:join(fn:split(result.BEGDA, '-'), '')}" pattern="yyyyMMdd" var="convertBegda" />
		            			<fmt:parseDate value="${fn:join(fn:split(result.ENDDA, '-'), '')}" pattern="yyyyMMdd" var="convertEndda" />
		            			<c:choose>
		            				<c:when test="${result.ZOVER eq 'X'}"><c:set var="bgColor" value="#FFB6C1;" /></c:when>
		            				<c:when test="${result.ZOVER ne 'X' && convertSearchDate ge convertBegda && convertSearchDate le convertEndda}"><c:set var="bgColor" value="#E9FFD2;" /></c:when>
		            				<c:otherwise><c:set var="bgColor" value="" /></c:otherwise>
		            			</c:choose>
            					<td <c:if test="${rowCount ne 1 && headerStatus.last && S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W'}">class="lastCol"</c:if> style="background-color:${bgColor}">
            						<fmt:formatNumber var="decimalPoint" value="${(result.RWKTM % 1) % 0.1}" />
		            				<fmt:formatNumber value="${result.RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" /><!-- 소숫점 두자리를 한자리로 표현(버림 표현식) -->
            					</td>
            				</c:forEach>
            			</c:when>
            			<c:otherwise>
            				<c:forEach var="header" begin="${beginNum}" end="${endNum}" varStatus="headerStatus">
		            			<fmt:parseDate value="${fn:join(fn:split(T_HEADER[headerStatus.index].BEGDA, '-'), '')}" pattern="yyyyMMdd" var="convertBegda" />
		            			<fmt:parseDate value="${fn:join(fn:split(T_HEADER[headerStatus.index].ENDDA, '-'), '')}" pattern="yyyyMMdd" var="convertEndda" />
		            			<c:choose>
		            				<c:when test="${T_HEADER[headerStatus.index].ZOVER eq 'X'}"><c:set var="bgColor" value="#FFB6C1;" /></c:when>
		            				<c:when test="${T_HEADER[headerStatus.index].ZOVER ne 'X' && convertSearchDate ge convertBegda && convertSearchDate le convertEndda}"><c:set var="bgColor" value="#E9FFD2;" /></c:when>
		            				<c:otherwise><c:set var="bgColor" value="" /></c:otherwise>
		            			</c:choose>
								<td <c:if test="${rowCount ne 1 && headerStatus.last && S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W'}">class="lastCol"</c:if> style="background-color:${bgColor}">
									<fmt:formatNumber var="decimalPoint" value="${(T_HEADER[headerStatus.index].RWKTM % 1) % 0.1}" />
		            				<fmt:formatNumber value="${T_HEADER[headerStatus.index].RWKTM eq null ? '' : T_HEADER[headerStatus.index].RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" /><!-- 소숫점 두자리를 한자리로 표현(버림 표현식) -->
								</td>
							</c:forEach>
            			</c:otherwise>
            		</c:choose>
					<c:if test="${rowStatus.count eq 1 && !(S_2190T.RADJPRD eq '01' && S_2190T.RADJUNT eq 'W')}">
						<fmt:parseNumber var="limitNumber" value="52" />
						<fmt:parseNumber var="convertWKAVR" value="${E_WKAVR}" />
						<td rowspan="${(rowCount * 2) - 1}" class="lastCol" <c:if test="${convertWKAVR ge limitNumber}">style="background-color:#FFB6C1;"</c:if>>
							<fmt:formatNumber var="decimalPoint" value="${(E_WKAVR % 1) % 0.1}" />
            				<fmt:formatNumber value="${E_WKAVR - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" /><!-- 소숫점 두자리를 한자리로 표현(버림 표현식) -->
						</td>
					</c:if>
            	</tr>
            </c:forEach>
            </table>
		</div>
	</div>
	
	<br/>
	<h2 class="subtitle">2.세부 현황</h2>
	<br/>
	<h2 class="subtitle">실근무시간 = 정상근무 + 초과근무 + 교육 - 휴게 - 비근무</h2>
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
	        		<col width="${colWidth}%" />
					<c:if test="${not empty T_NWKTYP}">
						<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
							<col width="${colWidth}%" />
						</c:forEach>
					</c:if>
	        		<col width="${colWidth}%" />
	        	</colgroup>
	            <thead>
	                <tr>
	            		<th rowspan="2">일자</th>
	            		<th rowspan="2">정상근무</th>
	            		<th rowspan="2">초과근무</th>
            			<th rowspan="2">교육</th>
	            		<th rowspan="2">휴게시간</th>
	            		<th rowspan="2">비근무</th>
	            		<c:if test="${not empty T_NWKTYP}">
	            			<th colspan="${fn:length(T_NWKTYP)}">
	            				비근무
	            			</th>
	            		</c:if>
		            	<th rowspan="2" class="lastCol">실 근무시간</th>
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
	        		<col width="8%" />
	        		<col width="${colWidth}%" />
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
	        	</colgroup>
	            <tbody>
	            	<c:choose>
	            		<c:when test="${empty T_BODY}">
	            			<tr class="oddRow">
								<td class="lastCol align_center" colspan="${fn:length(T_NWKTYP) + 7}">해당하는 데이터가 존재하지 않습니다.</td>
							</tr>
	            		</c:when>
	            		<c:otherwise>
	            			<fmt:parseNumber var="limitNumber" value="64" />
		            		<c:forEach var="body" items="${T_BODY}" varStatus="status">
			           			<c:choose>
			           				<c:when test="${body.ZWEEK ne '00'}">
			           					<c:set var="tdStyle" value="background-color:#F6EDB8;" />
			           				</c:when>
			           				<c:otherwise>
			           					<c:set var="tdStyle" value="" />
			           				</c:otherwise>
			           			</c:choose>
				            	<tr class="borderRow">
			            			<td style="padding-top:0px;${tdStyle}">${body.DAYTX}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.NORTM}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.OVRTM}</td>
		            				<td style="padding-top:0px;${tdStyle}">${body.EDUTM}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.BRKTM}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.NWKTM}</td>
			            			<c:if test="${not empty T_NWKTYP}">
				            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
					            			<td style="padding-top:0px;${tdStyle}">${body[nwktyp.FLDNM]}</td>
					            		</c:forEach>
				            		</c:if>
				            		<fmt:parseNumber var="convertRWKTM" value="${body.RWKTM}" />
				            		<c:choose>
				            			<c:when test="${convertRWKTM ge limitNumber}"><c:set var="bgColor" value="background-color:#FFB6C1;" /></c:when>
				            			<c:otherwise><c:set var="bgColor" value="background-color:#F6EDB8;" /></c:otherwise>
				            		</c:choose>
			            			<td class="lastCol" style="padding-top:0px;font-weight:bold;${bgColor}">
			            				<fmt:formatNumber var="decimalPoint" value="${(body.RWKTM % 1) % 0.1}" />
			            				<fmt:formatNumber value="${body.RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" /><!-- 소숫점 두자리를 한자리로 표현(버림 표현식) -->
			            			</td>
				            	</tr>
		            		</c:forEach>
	            		</c:otherwise>
	            	</c:choose>
	            </tbody>
        	</table>
        </div>
	</div>
	<div class="commentOne">
		<span>실 근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.</span>
	</div>
	
	<br/>
	<div class="commentOne">
		<span>현재일 기준으로 계획근무일정을 반영한 예상 근무시간입니다.</span>
	</div>

</form>

</div>