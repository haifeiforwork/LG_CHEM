<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트
/*   Program ID   : D25WorkTimeReport.jsp
/*   Description  : 실근무시간 레포트 화면
/*   Note         : 
/*   Creation     : 2018-05-24 성환희 [WorkTime52]
/*   Update       : 
/******************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- html 시작 선언 및 head 선언 --%>
<%-- * 참고 *
     아래 noCache 변수는 css와 js 파일이 browser에서 caching 되는 것을 방지하기위한 변수이다.
     운영모드에서 css와 js 파일이 안정화되어 수정될 일이 없다고 판단되는 경우 browser에서 caching 되도록 하여 server 부하를 줄이고자한다면 noCache 변수를 삭제한다.

     noCache 변수 삭제 후 운영중에 css나 js 파일이 변경되면 browser의 cache를 사용자가 직접 삭제해줘야하는데 이런 번거로움을 없애려면 noCache 변수를 다시 넣으면된다.

     주의할 점은 jsp:include tag 내부에서는 주석이 오류를 발생시키므로
     주석으로 남기고 싶은 경우 noCache 변수 line을 jsp:include tag 외부로 빼서 주석처리하거나
     변수명을 noCache에서 noCacheX 등으로 변경한다. --%>
<jsp:include page="/include/header.jsp">
    <jsp:param name="noCache" value="?${timestamp}" />
    <jsp:param name="css" value="bootstrap-3.3.2.min.css" />
    <jsp:param name="css" value="D/D25WorkTime.css" />
    <jsp:param name="script" value="moment-with-locales.min.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
</jsp:include>

<%-- body 시작 선언 및 body title --%>
<c:choose>
	<c:when test="${isPop eq 'Y'}">
		<jsp:include page="/include/pop-body-header.jsp">
			<jsp:param name="title" value="${SEARCH_GUBUN eq 'W' ? 'LABEL.D.D25.0043' : 'LABEL.D.D25.0044'}" />
		    <jsp:param name="subView" value="Y" />
		</jsp:include>
	</c:when>
	<c:otherwise>
		<jsp:include page="/include/body-header.jsp">
		    <jsp:param name="subView" value="Y" />
		</jsp:include>
	</c:otherwise>
</c:choose>

<script type="text/javascript">

(function($) {

	$(function() {
		
		$.toggleSearchConditionLayer();
		
		$.buttonSearchHandler();
		$.buttonPrintHandler();
		$.buttonExcelHandler();
		$.changeGubunRadioHandler();
		
	});
	
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
			
			setTimeout(blockFrame);
			
			$('[name=form1]')
				.attr('action', '<%= WebUtil.ServletURL %>hris.D.D25WorkTime.D25WorkTimeReportSV')
				.attr('target', '_self')
				.submit();
		});
	}
	
	$.buttonPrintHandler = function() {
		$('#printButton').click(function(e) {
			e.preventDefault();
			
			window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1300,height=662,left=0,top=2");
			
			$('[name=form1]')
				.attr('action', '<%= WebUtil.JspURL %>common/printFrame_workTimeReport.jsp?viewMode=print')
				.attr('target', 'essPrintWindow')
				.submit();
		});
	}

	$.buttonExcelHandler = function() {
		$('#excelButton').click(function(e) {
			e.preventDefault();
			
			$('[name=form1]')
				.attr('action', '<%= WebUtil.ServletURL %>hris.D.D25WorkTime.D25WorkTimeReportSV?viewMode=excel')
				.attr('target', 'hidden')
				.submit();
		});
	}
	
	$.changeGubunRadioHandler = function() {
		$('[name=SEARCH_GUBUN]').click(function(e) {
			$.toggleSearchConditionLayer();
		});
	}
	
})(jQuery);

</script>

<form name="form1" method="post">
	
	<c:if test="${isPop eq 'Y'}">
		<input type="hidden" name="PARAM_PERNR" value="${PERNR}" />
		<input type="hidden" name="PARAM_ORGTX" value="<c:out value='${PARAM_ORGTX}' />" />
		<input type="hidden" name="isPop" value="Y" />
		
		<div>
			<h2 class="subtitle"><c:out value="${E_NAME}" />(<c:out value="${PERNR}" />) <c:out value="${PARAM_ORGTX}" /></h2>
		</div>
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
                    <img class="searchTitle" src="<%=WebUtil.ImageURL %>sshr/top_box_search.gif" />
                </th>
                <td>
                	<input type="radio" name="SEARCH_GUBUN" value="W" <c:if test="${SEARCH_GUBUN eq 'W'}">checked</c:if> /> 주간
                	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	<input type="radio" name="SEARCH_GUBUN" value="M" <c:if test="${SEARCH_GUBUN eq 'M'}">checked</c:if> <c:if test="${EMPGUB eq 'H'}">disabled</c:if> /> 월간
                </td>
                <td>
                	<div class="tableBtnSearch tableBtnSearch2">
                        <a href="#" class="search" id="searchButton">
                        	<span>조회</span>
                        </a>
                    </div>
                </td>
            </tr>
            <tr id="week_search_div" <c:if test="${SEARCH_GUBUN eq 'M'}">style="display:none;"</c:if>>
            	<td>
                	조회기준일 
                	&nbsp;&nbsp;&nbsp;&nbsp;
                	<input type="text" name="SEARCH_DATE" class="date required" size="10" value="<c:out value='${SEARCH_DATE}' />" style="line-height:normal;" />
                </td>
                <td>
                	<c:if test="${EMPGUB eq 'S'}">
                		&nbsp;&nbsp; * 조회기준일의 1일~말일 데이터를 조회합니다.
                	</c:if>
                	<c:if test="${EMPGUB eq 'H'}">
                		&nbsp;&nbsp; * 조회기준일 전/후 5주간 데이터를 조회합니다.
                	</c:if>
                </td>
            </tr>
            <tr id="month_search_div" <c:if test="${SEARCH_GUBUN eq 'W'}">style="display:none;"</c:if>>
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
                	<c:if test="${EMPGUB eq 'S'}">
                		&nbsp;&nbsp; * 조회년월 1일 ~ 말일 데이터를 조회합니다.
                	</c:if>
                	<c:if test="${EMPGUB eq 'H'}">
                		&nbsp;&nbsp; * 전월 21일 ~ 당월 20일 데이터를 조회합니다.
                	</c:if>
                </td>
            </tr>
        </table>
    </div>
    
    <div class="buttonArea">
		<ul class="btn_mdl displayInline">
			<%-- <li>
				<a href="#" id="printButton">
					<span>인쇄하기</span>
				</a>
			</li> --%>
			<li>
				<a href="#" id="excelButton">
					<span>엑셀다운로드</span>
				</a>
			</li>
		</ul>
	</div>
	
	<c:if test="${SEARCH_GUBUN eq 'W'}">
	<h2 class="subtitle">
		<c:choose>
			<c:when test="${EMPGUB eq 'S'}">1.주당 근무시간 현황</c:when>
			<c:otherwise>1.주당 실 근무시간 현황</c:otherwise>
		</c:choose>
	</h2>
	<div class="listArea">
        <div class="table">
            <table class="listTable" style="margin-bottom:3px;">
	            <thead>
	            	<tr>
	            	<c:if test="${not empty T_HEADER}">
	            		<th class="th02">구분</th>
	            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
	            			<th class="th02 <c:if test="${fn:length(T_HEADER) eq status.count}">lastCol</c:if>">
	            			<c:choose>
	            				<c:when test="${EMPGUB eq 'H'}">
	            					${head.GUBUN}(${fn:replace(fn:substring(head.BEGDA, 5, 10), '-', '.')}~${fn:replace(fn:substring(head.ENDDA, 5, 10), '-', '.')})
	            				</c:when>
	            				<c:otherwise>
	            					${head.GUBUN}
	            				</c:otherwise>
	            			</c:choose>
	            			</th>
	            		</c:forEach>
	            	</c:if>
	            	</tr>
	            </thead>
	            <tbody>
	            	<tr>
	            	<c:if test="${not empty T_HEADER}">
	            		<th style="width:100px;" class="th02">
	            			<c:choose>
								<c:when test="${EMPGUB eq 'S'}">근무시간</c:when>
								<c:otherwise>실 근무시간</c:otherwise>
							</c:choose>
	            		</th>
	            		<fmt:parseNumber var="limitNumber" value="64" />
	            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
	            			<fmt:parseNumber var="convertRWKTM" value="${head.RWKTM}" />
	            			<c:choose>
	            				<c:when test="${convertRWKTM ge limitNumber}"><c:set var="tdClass" value="td11" /></c:when>
	            				<c:otherwise><c:set var="tdClass" value="" /></c:otherwise>
	            			</c:choose>
	            			<c:choose>
	            				<c:when test="${fn:length(T_HEADER) eq status.count && EMPSUB eq 'S'}">
	            					<td class="lastCol" style="width:70px;background-color:#F6EDB8;">${head.RWKTM}</td>
	            				</c:when>
	            				<c:otherwise>
	            					<td class="${tdClass}" style="width:70px;">${head.RWKTM}</td>
	            				</c:otherwise>
	            			</c:choose>
	            		</c:forEach>
	            	</c:if>
	            	</tr>
	            </tbody>
            </table>
		</div>
	</div>
	</c:if>
	
	<c:if test="${SEARCH_GUBUN eq 'M'}">
	<c:choose>
		<c:when test="${EMPGUB eq 'S'}">
		<h2 class="subtitle">1.주당 평균 근무시간 현황</h2>
		<div class="listArea" style="margin-bottom:0px;">
	        <div class="table">
	            <table class="listTable" style="margin-bottom:3px;">
		            <thead>
		            	<tr>
		            		<th class="th02">구분</th>
		            		<th class="th02">월 근무시간 (유급휴가 포함)</th>
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
			            		<td class="lastCol <c:if test="${convertWEKAVR ge limitNumber}">td11</c:if>">${ES_HEADER.WEKAVR}</td>
			            	</tr>
		            	</c:if>
		            </tbody>
	            </table>
			</div>
		</div>
		</c:when>
		<c:otherwise>
			<h2 class="subtitle">1.주당 평균 실 근무시간 현황</h2>
			<c:set var="displayYear" value="${fn:substring(T_HEADER[0].YYYYMM, 0, 4)}" />
			<c:set var="displayMonth" value="${fn:substring(T_HEADER[0].YYYYMM, 4, 6)}" />
			<c:choose>
				<c:when test="${displayMonth eq '01' || displayMonth eq '02' || displayMonth eq '03'}">
					<c:set var="headerMonth1" value="LABEL.D.D04.0022" /><!-- 1월 -->
					<c:set var="headerMonth1Range" value="(${displayYear - 1}.12.21~${displayYear}.01.20)" />
					<c:set var="headerMonth2" value="LABEL.D.D04.0023" /><!-- 2월 -->
					<c:set var="headerMonth2Range" value="(${displayYear}.01.21~${displayYear}.02.20)" />
					<c:set var="headerMonth3" value="LABEL.D.D04.0024" /><!-- 3월 -->
					<c:set var="headerMonth3Range" value="(${displayYear}.02.21~${displayYear}.03.20)" />
				</c:when>
				<c:when test="${displayMonth eq '04' || displayMonth eq '05' || displayMonth eq '06'}">
					<c:set var="headerMonth1" value="LABEL.D.D04.0025" /><!-- 4월 -->
					<c:set var="headerMonth1Range" value="(${displayYear}.03.21~${displayYear}.04.20)" />
					<c:set var="headerMonth2" value="LABEL.D.D04.0026" /><!-- 5월 -->
					<c:set var="headerMonth2Range" value="(${displayYear}.04.21~${displayYear}.05.20)" />
					<c:set var="headerMonth3" value="LABEL.D.D04.0027" /><!-- 6월 -->
					<c:set var="headerMonth3Range" value="(${displayYear}.05.21~${displayYear}.06.20)" />
				</c:when>
				<c:when test="${displayMonth eq '07' || displayMonth eq '08' || displayMonth eq '09'}">
					<c:set var="headerMonth1" value="LABEL.D.D04.0028" /><!-- 7월 -->
					<c:set var="headerMonth1Range" value="(${displayYear}.06.21~${displayYear}.07.20)" />
					<c:set var="headerMonth2" value="LABEL.D.D04.0029" /><!-- 8월 -->
					<c:set var="headerMonth2Range" value="(${displayYear}.07.21~${displayYear}.08.20)" />
					<c:set var="headerMonth3" value="LABEL.D.D04.0030" /><!-- 9월 -->
					<c:set var="headerMonth3Range" value="(${displayYear}.08.21~${displayYear}.09.20)" />
				</c:when>
				<c:when test="${displayMonth eq '10' || displayMonth eq '11' || displayMonth eq '12'}">
					<c:set var="headerMonth1" value="LABEL.D.D04.0031" /><!-- 10월 -->
					<c:set var="headerMonth1Range" value="(${displayYear}.09.21~${displayYear}.10.20)" />
					<c:set var="headerMonth2" value="LABEL.D.D04.0032" /><!-- 11월 -->
					<c:set var="headerMonth2Range" value="(${displayYear}.10.21~${displayYear}.11.20)" />
					<c:set var="headerMonth3" value="LABEL.D.D04.0033" /><!-- 12월 -->
					<c:set var="headerMonth3Range" value="(${displayYear}.11.21~${displayYear}.12.20)" />
				</c:when>
			</c:choose>
			<div class="listArea" style="margin-bottom:0px;">
		        <div class="table">
		            <table class="listTable" style="margin-bottom:3px;">
			            <thead>
			            	<tr>
			            		<th class="th02" style="width:20%;">구분</th>
			            		<th class="th02" style="width:20%;"><spring:message code='<c:out value="${headerMonth1}" />' /><!-- 월 --> <c:out value="${headerMonth1Range}" /></th>
			            		<th class="th02" style="width:20%;"><spring:message code='<c:out value="${headerMonth2}" />' /><!-- 월 --> <c:out value="${headerMonth2Range}" /></th>
			            		<th class="th02" style="width:20%;"><spring:message code='<c:out value="${headerMonth3}" />' /><!-- 월 --> <c:out value="${headerMonth3Range}" /></th>
			            		<th class="th02 lastCol"><spring:message code='LABEL.D.D25.0046' /><!-- 계 --></th>
			            	</tr>
			            </thead>
			            <tbody>
			            	<c:if test="${not empty T_HEADER}">
			            		<fmt:parseNumber var="limitNumber" value="52" />
				            	<c:set var="totalSum" value="${T_HEADER[0].MONSUM + T_HEADER[1].MONSUM + T_HEADER[2].MONSUM}" />
				            	<c:set var="totalWorkDay" value="${T_HEADER[0].WKDAY + T_HEADER[1].WKDAY + T_HEADER[2].WKDAY}" />
				            	<tr class="borderRow">
				            		<td><spring:message code='LABEL.D.D25.0022' /><!-- 실 근무시간 --></td>
				            		<td>${T_HEADER[0].MONSUM eq null ? 0 : T_HEADER[0].MONSUM}</td>
				            		<td>${T_HEADER[1].MONSUM eq null ? 0 : T_HEADER[1].MONSUM}</td>
				            		<td>${T_HEADER[2].MONSUM eq null ? 0 : T_HEADER[2].MONSUM}</td>
				            		<td class="lastCol"><fmt:formatNumber value="${totalSum}" pattern=".00" /></td>
				            	</tr>
				            	<tr class="borderRow">
				            		<td><spring:message code='LABEL.D.D25.0021' /><!-- 주당 평균 실 근무시간 --></td>
				            		<fmt:parseNumber var="convertWEKAVR0" value="${T_HEADER[0].WEKAVR}" />
				            		<fmt:parseNumber var="convertWEKAVR1" value="${T_HEADER[1].WEKAVR}" />
				            		<fmt:parseNumber var="convertWEKAVR2" value="${T_HEADER[2].WEKAVR}" />
				            		<fmt:parseNumber var="totalWEKAVR" value="${totalSum / totalWorkDay * 7}" />
				            		<td <c:if test="${convertWEKAVR0 ge limitNumber}">class="td11"</c:if>>${T_HEADER[0].WEKAVR eq null ? 0 : T_HEADER[0].WEKAVR}</td>
				            		<td <c:if test="${convertWEKAVR1 ge limitNumber}">class="td11"</c:if>>${T_HEADER[1].WEKAVR eq null ? 0 : T_HEADER[1].WEKAVR}</td>
				            		<td <c:if test="${convertWEKAVR2 ge limitNumber}">class="td11"</c:if>>${T_HEADER[2].WEKAVR eq null ? 0 : T_HEADER[2].WEKAVR}</td>
				            		<td class="lastCol <c:if test="${totalWEKAVR ge limitNumber}">td11</c:if>"><fmt:formatNumber value="${totalWEKAVR}" pattern=".00" /></td>
				            	</tr>
			            	</c:if>
			            </tbody>
		            </table>
				</div>
			</div>
		</c:otherwise>
	</c:choose>
	<div class="commentOne"  style="margin-bottom:10px;">
		<c:choose>
			<c:when test="${EMPGUB eq 'S'}">
				<span><spring:message code='LABEL.D.D25.0068' /><!-- 주당 평균 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일)--></span>
			</c:when>
			<c:otherwise>
				<span><spring:message code='LABEL.D.D25.0017' /><!-- 주당 평균 실 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일)--></span>
			</c:otherwise>
		</c:choose>
	</div>
	</c:if>

	<br/>
	<h2 class="subtitle"><spring:message code='LABEL.D.D25.0008' /><!-- 2.세부 현황 --></h2>
	<br/>
	<c:choose>
		<c:when test="${EMPGUB eq 'S'}">
			<h2 class="subtitle"><spring:message code='LABEL.D.D25.0069' /><!-- 근무시간 = 정상근무 + 초과근무 - 휴게 - 비근무 --></h2>
		</c:when>
		<c:otherwise>
			<h2 class="subtitle"><spring:message code='LABEL.D.D25.0059' /><!-- 실근무시간 = 정상근무 + 초과근무 + 교육 - 휴게 - 비근무 --></h2>
		</c:otherwise>
	</c:choose>
	<div class="listArea" style="margin-bottom:0px;">
		<div class="table scroll-table scroll-head">
			<c:choose>
				<c:when test="${SEARCH_GUBUN eq 'W' && EMPGUB eq 'S'}"><fmt:parseNumber var="colWidth" value="${92 / (fn:length(T_NWKTYP) + 5)}" /></c:when>
				<c:otherwise><fmt:parseNumber var="colWidth" value="${92 / (fn:length(T_NWKTYP) + 6)}" /></c:otherwise>
			</c:choose>
	        <table class="listTable">
	        	<colgroup>
	        		<col width="8%" />
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
	        		<c:if test="${EMPGUB eq 'H'}">
	        			<col width="${colWidth}%" />
	        		</c:if>
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
					<c:if test="${not empty T_NWKTYP}">
						<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
							<col width="${colWidth}%" />
						</c:forEach>
					</c:if>
	        		<col width="${colWidth}%" />
	        		<c:if test="${SEARCH_GUBUN eq 'M' && EMPGUB eq 'S'}">
	        			<col width="${colWidth}%" />
	        		</c:if>
	        	</colgroup>
	            <thead>
	                <tr>
	            		<th rowspan="2"><spring:message code='LABEL.D.D25.0023' /><!-- 일자 --></th>
	            		<th rowspan="2"><spring:message code='LABEL.D.D25.0024' /><!-- 정상근무시간 --></th>
	            		<th rowspan="2"><spring:message code='LABEL.D.D25.0025' /><!-- 초과근무 --></th>
	            		<c:if test="${EMPGUB eq 'H'}">
	            			<th rowspan="2"><spring:message code='LABEL.D.D25.0060' /><!-- 교육 --></th>
	            		</c:if>
	            		<th rowspan="2"><spring:message code='LABEL.D.D25.0026' /><!-- 휴게시간 --></th>
	            		<th rowspan="2">
	            			<c:choose>
	            				<c:when test="${EMPGUB eq 'S'}"><spring:message code='LABEL.D.D25.0070' /><!-- 비근무차감 --></c:when>
	            				<c:otherwise><spring:message code='LABEL.D.D25.0027' /><!-- 비근무 --></c:otherwise>
	            			</c:choose>
	            		</th>
	            		<c:if test="${not empty T_NWKTYP}">
	            			<th colspan="${fn:length(T_NWKTYP)}" style="border-bottom:solid 1px #cdcdcd;">
	            				<c:choose>
	            					<c:when test="${EMPGUB eq 'S'}"><spring:message code='LABEL.D.D25.0071' /><!-- 유급휴가 --></c:when>
	            					<c:otherwise><spring:message code='LABEL.D.D25.0028' /><!-- 비근무 --></c:otherwise>
	            				</c:choose>
	            			</th>
	            		</c:if>
		            	<th rowspan="2" <c:if test="${EMPGUB eq 'H' || (EMPGUB eq 'S' && SEARCH_GUBUN eq 'W')}">class="lastCol"</c:if>>
		            	<c:choose>
		            		<c:when test="${EMPGUB eq 'S'}">
		            			<spring:message code='LABEL.D.D25.0062' /><!-- 근무시간 -->
		            		</c:when>
		            		<c:otherwise>
		            			<spring:message code='LABEL.D.D25.0029' /><!-- 실 근무시간 -->
		            		</c:otherwise>
		            	</c:choose>
		            	</th>
		            	<c:if test="${SEARCH_GUBUN eq 'M' && EMPGUB eq 'S'}">
	            			<th rowspan="2" class="lastCol"><spring:message code='LABEL.D.D25.0076' /><!-- 평일 누적근무시간 --></th>
	            		</c:if>
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
        	<table class="worktime listTable">
        		<colgroup>
	        		<col style="width:8%" />
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
	        		<c:if test="${EMPGUB eq 'H'}">
	        			<col width="${colWidth}%" />
	        		</c:if>
	        		<col width="${colWidth}%" />
	        		<col width="${colWidth}%" />
					<c:if test="${not empty T_NWKTYP}">
						<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
							<col width="${colWidth}%" />
						</c:forEach>
					</c:if>
	        		<col width="${colWidth}%" />
	        		<c:if test="${SEARCH_GUBUN eq 'M' && EMPGUB eq 'S'}">
	        			<col width="${colWidth}%" />
	        		</c:if>
	        	</colgroup>
        		<c:if test="${not empty T_BODY}">
	            <tbody>
	            	<c:set var="SUM_NORTM" value="0" scope="request" />
	            	<c:set var="SUM_OVRTM" value="0" scope="request" />
	            	<c:set var="SUM_EDUTM" value="0" scope="request" />
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
	            	
	            	<c:choose>
	            		<c:when test="${SEARCH_GUBUN eq 'W'}"><fmt:parseNumber var="limitNumber" value="64" /></c:when>
	            		<c:otherwise><fmt:parseNumber var="limitNumber" value="52" /></c:otherwise>
	            	</c:choose>
	            	
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
	            			<c:if test="${EMPGUB eq 'H'}">
	            				<td style="padding-top:0px;${tdStyle}">${body.EDUTM}</td>
	            			</c:if>
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
	            			<td class="<c:if test="${EMPGUB eq 'H' || (EMPGUB eq 'S' && SEARCH_GUBUN eq 'W')}">lastCol</c:if> <c:if test="${convertRWKTM ge limitNumber}">td11</c:if>" style="padding-top:0px;font-weight:bold;<c:if test="${convertRWKTM lt limitNumber}">background-color:#F6EDB8;</c:if>">${body.RWKTM}</td>
	            			<c:if test="${SEARCH_GUBUN eq 'M' && EMPGUB eq 'S'}">
	            				<td class="lastCol" style="padding-top:0px;${tdStyle2}">${body.RWSUMA ne '0' ? body.RWSUMA : ''}</td>
	            			</c:if>
		            	</tr>
		            	<c:set var="SUM_NORTM" value="${SUM_NORTM +body.NORTM}" />
		            	<c:set var="SUM_OVRTM" value="${SUM_OVRTM +body.OVRTM}" />
		            	<c:set var="SUM_EDUTM" value="${SUM_EDUTM +body.EDUTM}" />
		            	<c:set var="SUM_BRKTM" value="${SUM_BRKTM +body.BRKTM}" />
		            	<c:set var="SUM_NWKTM" value="${SUM_NWKTM +body.NWKTM}" />
		            	<c:set var="SUM_RWKTM" value="${SUM_RWKTM +body.RWKTM}" />
            		</c:forEach>
            		<c:if test="${SEARCH_GUBUN eq 'M'}">
	            		<tr id="total_calc_row" class="sumRow">
	            			<td class="td11" style="padding-top:0px;">합계</td>
	            			<td class="td11" style="padding-top:0px;">
	            				<c:choose>
			            			<c:when test="${SUM_NORTM eq 0}">0</c:when>
			            			<c:otherwise><fmt:formatNumber value="${SUM_NORTM}" pattern=".00" /></c:otherwise>
		            			</c:choose>
	            			</td>
	            			<td class="td11" style="padding-top:0px;">
	            				<c:choose>
			            			<c:when test="${SUM_OVRTM eq 0}">0</c:when>
			            			<c:otherwise><fmt:formatNumber value="${SUM_OVRTM}" pattern=".00" /></c:otherwise>
		            			</c:choose>
		            		</td>
		            		<c:if test="${EMPGUB eq 'H'}">
		            			<td class="td11" style="padding-top:0px;">
		            				<c:choose>
				            			<c:when test="${SUM_EDUTM eq 0}">0</c:when>
				            			<c:otherwise><fmt:formatNumber value="${SUM_EDUTM}" pattern=".00" /></c:otherwise>
			            			</c:choose>
			            		</td>
		            		</c:if>
	            			<td class="td11" style="padding-top:0px;">
	            				<c:choose>
			            			<c:when test="${SUM_BRKTM eq 0}">0</c:when>
			            			<c:otherwise><fmt:formatNumber value="${SUM_BRKTM}" pattern=".00" /></c:otherwise>
		            			</c:choose>
		            		</td>
	            			<td class="td11" style="padding-top:0px;">
	            				<c:choose>
			            			<c:when test="${SUM_NWKTM eq 0}">0</c:when>
			            			<c:otherwise><fmt:formatNumber value="${SUM_NWKTM}" pattern=".00" /></c:otherwise>
		            			</c:choose>
		            		</td>
	            			<c:if test="${not empty T_NWKTYP}">
		            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
			            			<td style="padding-top:0px;" class="td11">
				            			<c:set var="fName" value="SUM_NWKTYP${status.count}" scope="request" />
				            			<c:choose>
					            			<c:when test="${requestScope[fName] eq 0}">0</c:when>
					            			<c:otherwise><fmt:formatNumber value="${requestScope[fName]}" pattern=".00" /></c:otherwise>
				            			</c:choose>
			            			</td>
			            		</c:forEach>
		            		</c:if>
	            			<td class="<c:if test="${EMPGUB eq 'H'}">lastCol</c:if> td11" style="font-weight:bold;">
	            				<c:choose>
			            			<c:when test="${SUM_RWKTM eq 0}">0</c:when>
			            			<c:otherwise><fmt:formatNumber value="${SUM_RWKTM}" pattern=".00" /></c:otherwise>
		            			</c:choose>
		            		</td>
		            		<c:if test="${EMPGUB eq 'S'}">
		            			<td class="lastCol td11" style="padding-top:0px;"></td>
		            		</c:if>
	            		</tr>
	            	</c:if>
	            </tbody>
            	</c:if>
        	</table>
        </div>
	</div>
	<div class="commentOne">
	<c:choose>
		<c:when test="${EMPGUB eq 'S'}">
			<span><spring:message code='LABEL.D.D25.0073' /><!--근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.--></span>
		</c:when>
		<c:otherwise>
			<span><spring:message code='LABEL.D.D25.0009' /><!--실 근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.--></span>
		</c:otherwise>
	</c:choose>
	</div>
	
	<c:if test="${EMPGUB eq 'H'}">
	<br/>
	<div class="commentOne">
		<span><spring:message code='LABEL.D.D25.0055' /><!--현재일 기준으로 계획근무일정을 반영한 예상 근무시간입니다.--></span>
	</div>
	</c:if>

</form>

<c:if test="${isPop eq 'Y'}" >
<div class="buttonArea underList">
    <ul class="btn_crud">
        <li><a href="javascript:window.close();"><span><spring:message code="BUTTON.COMMON.CLOSE"/></span></a></li>
    </ul>
</div>
<iframe name="hidden" id="hidden" frameborder="0" width="0" height="0" style="top: -9999px; display:none;"></iframe>
</c:if>

<jsp:include page="/include/${bodyFooter}" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/><!-- html footer 부분 -->