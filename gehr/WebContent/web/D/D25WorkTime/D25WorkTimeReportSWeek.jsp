<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트 - 사무직 주간
/*   Program ID   : D25WorkTimeReportSWeek.jsp
/*   Description  : 실근무시간 사무직 주간 레포트 화면
/*   Note         : 
/*   Creation     : 2018-06-25 성환희 [WorkTime52]
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
			<jsp:param name="title" value="LABEL.D.D25.0043" />
		    <jsp:param name="subView" value="Y" />
		</jsp:include>
	</c:when>
	<c:otherwise>
		<jsp:include page="/include/body-header.jsp">
		    <jsp:param name="subView" value="Y" />
		</jsp:include>
	</c:otherwise>
</c:choose>

<style>
<!--
.scroll-body {
	max-height: 320px !important;
}
-->
</style>

<script type="text/javascript">

(function($) {

	$(function() {
		
		$.toggleSearchConditionLayer();		// 주간,월간 조회조건 toggle
		
		$.buttonSearchHandler();
		$.buttonExcelHandler();
		$.changeGubunRadioHandler();		// 주간,월간 라디오버튼 이벤트 핸들러
		
	});
	
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
			
			setTimeout(blockFrame);
			
			$('[name=form1]')
				.attr('action', '<%= WebUtil.ServletURL %>hris.D.D25WorkTime.D25WorkTimeReportSV')
				.attr('target', '_self')
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
	
	// 주간,월간 라디오버튼 이벤트 핸들러
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
                	<input type="radio" name="SEARCH_GUBUN" value="M" <c:if test="${SEARCH_GUBUN eq 'M'}">checked</c:if> /> 월간
                </td>
                <td>
                	<div class="tableBtnSearch tableBtnSearch2">
                        <a href="#" class="search" id="searchButton">
                        	<span>조회</span>
                        </a>
                    </div>
                </td>
            </tr>
            <tr id="week_search_div">
            	<td>
                	조회기준일 
                	&nbsp;&nbsp;&nbsp;&nbsp;
                	<input type="text" name="SEARCH_DATE" class="date required" size="10" value="<c:out value='${SEARCH_DATE}' />" style="line-height:normal;" />
                </td>
                <td>&nbsp;&nbsp; * 조회기준일의 1일~말일 데이터를 조회합니다.</td>
            </tr>
            <tr id="month_search_div" style="display:none;">
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
	
	<h2 class="subtitle">1.주당 근무시간 현황</h2>
	<div class="listArea">
        <div class="table">
            <table class="listTable" style="margin-bottom:3px;">
	            <thead>
	            	<tr>
	            	<c:if test="${not empty T_HEADER}">
	            		<th class="th02">구분</th>
	            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
	            			<th class="th02 <c:if test="${fn:length(T_HEADER) eq status.count}">lastCol</c:if>">${head.GUBUN}</th>
	            		</c:forEach>
	            	</c:if>
	            	</tr>
	            </thead>
	            <tbody>
	            	<tr>
	            	<c:if test="${not empty T_HEADER}">
	            		<th style="width:100px;" class="th02">근무시간</th>
	            		<fmt:parseNumber var="limitNumber" value="64" />
	            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
	            			<fmt:parseNumber var="convertRWKTM" value="${head.RWKTM}" />
	            			<c:choose>
	            				<c:when test="${convertRWKTM ge limitNumber}"><c:set var="tdClass" value="td11" /></c:when>
	            				<c:otherwise><c:set var="tdClass" value="" /></c:otherwise>
	            			</c:choose>
	            			<c:choose>
	            				<c:when test="${fn:length(T_HEADER) eq status.count}">
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
	
	<br/>
	<h2 class="subtitle">2.세부 현황</h2>
	<br/>
	<h2 class="subtitle">근무시간 = 정상근무 + 초과근무 - 휴게 - 비근무</h2>
	<div class="listArea" style="margin-bottom:0px;">
		<div class="table scroll-table scroll-head">
			<fmt:parseNumber var="colWidth" value="${92 / (fn:length(T_NWKTYP) + 5)}" />
	        <table class="listTable">
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
	        	</colgroup>
	            <thead>
	                <tr>
	            		<th rowspan="2">일자</th>
	            		<th rowspan="2">정상근무시간</th>
	            		<th rowspan="2">초과근무</th>
	            		<th rowspan="2">휴게시간</th>
	            		<th rowspan="2">비근무차감</th>
	            		<c:if test="${not empty T_NWKTYP}">
            				<th colspan="${fn:length(T_NWKTYP)}" style="border-bottom:solid 1px #cdcdcd;">유급휴가</th>
	            		</c:if>
		            	<th rowspan="2" class="lastCol">근무시간</th>
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
								<td class="lastCol align_center" colspan="${fn:length(T_NWKTYP) + 6}">해당하는 데이터가 존재하지 않습니다.</td>
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
			            			<td style="padding-top:0px;${tdStyle}">${body.BRKTM}</td>
			            			<td style="padding-top:0px;${tdStyle}">${body.NWKTM}</td>
			            			<c:if test="${not empty T_NWKTYP}">
				            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
					            			<td style="width:50px;padding-top:0px;${tdStyle}">${body[nwktyp.FLDNM]}</td>
					            		</c:forEach>
				            		</c:if>
				            		<fmt:parseNumber var="convertRWKTM" value="${body.RWKTM}" />
			            			<td class="lastCol <c:if test="${convertRWKTM ge limitNumber}">td11</c:if>" style="padding-top:0px;font-weight:bold;<c:if test="${convertRWKTM lt limitNumber}">background-color:#F6EDB8;</c:if>">${body.RWKTM}</td>
				            	</tr>
		            		</c:forEach>
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

<c:if test="${isPop eq 'Y'}" >
<div class="buttonArea underList">
    <ul class="btn_crud">
        <li><a href="javascript:window.close();"><span>닫기</span></a></li>
    </ul>
</div>
<iframe name="hidden" id="hidden" frameborder="0" width="0" height="0" style="top: -9999px; display:none;"></iframe>
</c:if>

<jsp:include page="/include/${bodyFooter}" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/><!-- html footer 부분 -->