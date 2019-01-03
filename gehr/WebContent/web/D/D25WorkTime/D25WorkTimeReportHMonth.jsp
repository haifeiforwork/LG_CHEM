<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트 - 현장직 월간
/*   Program ID   : D25WorkTimeReportHMonth.jsp
/*   Description  : 실근무시간 현장직 월간 레포트 화면
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
			<jsp:param name="title" value="LABEL.D.D25.0044" />
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
		
		$.buttonSearchHandler();
		$.buttonExcelHandler();
		$.changeSearchDateHandler();	// 검색일자 change 이벤트 핸들러
		
		// 1주 근무유형인지 판단하는 RFC를 호출한다.
		// WTCAT 값이 '0030'일 경우 월간 라디오버튼을 숨긴다.
		$.callNTMP9810($('[name=SEARCH_DATE]').val());
		
	});
	
	$.buttonSearchHandler = function() {
		$('#searchButton').click(function(e) {
			e.preventDefault();
			
			$.callSearch();
		});
	}
	
	$.callSearch = function() {
		<c:if test="${isPop eq 'Y'}">
		setTimeout(blockFrame);
		</c:if>
		
		$('[name=form1]')
			.attr('action', '<%= WebUtil.ServletURL %>hris.D.D25WorkTime.D25WorkTimeReportSV')
			.attr('target', '_self')
			.submit();
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
	
	// 검색일자 change 이벤트 핸들러
	$.changeSearchDateHandler = function() {
		$('[name=SEARCH_DATE]').change(function() {
			$.callNTMP9810($(this).val());
		});
	}
	
	// 1주 근무유형인지 판단하는 RFC를 호출한다.
	// WTCAT 값이 '0030'일 경우 주간 검색으로 강제 이동
	$.callNTMP9810 = function(searchDate) {
		var url = '/servlet/servlet.hris.D.D25WorkTime.D25WorkTimeReportSV';
		var pars = 'PERNR=${PERNR}&jobid=p9810&DATUM=' + searchDate;

		blockFrame();
	    $.ajax({
	    	type:'GET', 
	    	cache: false, 
	    	dataType: 'html', 
	    	url: url, 
	    	data: pars, 
	    	success: function(data){
	    				$.callBackRadioHandler(data);
	    	}
	   	});
	}
	
	// arr[0] = WTCAT
	// WTCAT 값이 '0030'일 경우 주간 검색으로 강제 이동
	$.callBackRadioHandler = function(data) {
		$.unblockUI();
		
		if(data != '') {
			var arr = data.split(',');
			if(arr[0]=="N" || arr[0]=="E") {
				alert(arr[1]);
				return;
			} else if(arr[0] == '0030') {
				$('[name=SEARCH_GUBUN]').eq(0).prop('checked', true);
				$.callSearch();
			} else {
				return;
			}
		}
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
	
	<h2 class="subtitle">1.주당 평균 실 근무시간 현황</h2>
	<br/>
	<%-- 
	<h2 class="subtitle">근무제 유형 : ${E_WTCATTX} (${fn:join(fn:split(E_BEGDA, '-'), '.')} ~ ${fn:join(fn:split(E_ENDDA, '-'), '.')})</h2>
	 --%>
	<div class="listArea" style="margin-bottom:0px;">
        <div class="table">
            <table class="listTable" style="margin-bottom:3px;">
            	<colgroup>
            		<col width="25%" />
            		<col width="25%" />
            		<col width="25%" />
            		<col width="25%" />
            	</colgroup>
            	<thead>
            		<tr>
            			<th>정산기간</th>
            			<th>법정기준</th>
            			<th>실 근무시간</th>
            			<th class="lastCol">주당 평균 실 근무시간</th>
            		</tr>
            	</thead>
            	<tbody>
            	<fmt:parseNumber var="limitNumber" value="52" />
            	<c:forEach var="tHeader" items="${T_HEADER}" varStatus="status">
            		<tr class="borderRow" <c:if test="${status.index eq 0}">style="background-color:#F6EDB8;"</c:if>>
            			<td>${tHeader.PERIOD}</td>
            			<c:choose>
            				<c:when test="${status.index eq 0}"><td>${tHeader.MAXTM}</td></c:when>
            				<c:otherwise><td style="background-color:#e1e1e1;">&nbsp;</td></c:otherwise>
            			</c:choose>
            			<td>
            				<fmt:formatNumber var="decimalPoint" value="${(tHeader.RWKTM % 1) % 0.1}" />
            				<fmt:formatNumber value="${tHeader.RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
            			</td>
            			<fmt:parseNumber var="convertAVRTM" value="${tHeader.AVRTM}" />
            			<td class="lastCol <c:if test="${convertAVRTM ge limitNumber}">td11</c:if>">
            				<fmt:formatNumber var="decimalPoint" value="${(tHeader.AVRTM % 1) % 0.1}" />
            				<fmt:formatNumber value="${tHeader.AVRTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
            			</td>
            		</tr>
            	</c:forEach>
            	</tbody>
            </table>
        </div>
    </div>

	<div class="commentOne"  style="margin-bottom:10px;">
		<span>주당 평균 실 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일)</span>
	</div>

	<br/>
	<h2 class="subtitle">2.세부 현황</h2>
	<br/>
	<h2 class="subtitle">실근무시간 = 정상근무 + 초과근무 + 교육 - 휴게 - 비근무</h2>
	<div class="listArea" style="margin-bottom:0px;">
		<div class="table scroll-table scroll-head">
			<fmt:parseNumber var="colWidth" value="${92 / (fn:length(T_NWKTYP) + 6)}" />
	        <table class="listTable">
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
	            		<th rowspan="2">정상근무시간</th>
	            		<th rowspan="2">초과근무</th>
            			<th rowspan="2">교육</th>
	            		<th rowspan="2">휴게시간</th>
	            		<th rowspan="2">비근무</th>
	            		<c:if test="${not empty T_NWKTYP}">
	            			<th colspan="${fn:length(T_NWKTYP)}" style="border-bottom:solid 1px #cdcdcd;">
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
        	<table class="worktime listTable">
        		<colgroup>
	        		<col style="width:8%" />
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
        		<c:if test="${not empty T_BODY}">
	            <tbody>
	            	<c:choose>
	            		<c:when test="${empty T_BODY}">
	            			<tr class="oddRow">
								<td class="lastCol align_center" colspan="${fn:length(T_NWKTYP) + 7}">해당하는 데이터가 존재하지 않습니다.</td>
							</tr>
	            		</c:when>
	            		<c:otherwise>
	            			<fmt:parseNumber var="limitNumber" value="52" />
		            		<c:forEach var="body" items="${T_BODY}" varStatus="status">
			           			<c:choose>
			           				<c:when test="${body.DATUM eq '0000-00-00'}">
			           					<c:set var="tdClass" value="td11" />
			           				</c:when>
			           				<c:otherwise>
			           					<c:set var="tdClass" value="" />
			           				</c:otherwise>
			           			</c:choose>
				            	<tr class="${body.DATUM eq '0000-00-00' ? 'sumRow' : 'borderRow'}">
			            			<td class="${tdClass}" style="padding-top:0px;">${body.DAYTX}</td>
			            			<td class="${tdClass}" style="padding-top:0px;">${body.NORTM}</td>
			            			<td class="${tdClass}" style="padding-top:0px;">${body.OVRTM}</td>
		            				<td class="${tdClass}" style="padding-top:0px;">${body.EDUTM}</td>
			            			<td class="${tdClass}" style="padding-top:0px;">${body.BRKTM}</td>
			            			<td class="${tdClass}" style="padding-top:0px;">${body.NWKTM}</td>
			            			<c:if test="${not empty T_NWKTYP}">
				            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
					            			<td class="${tdClass}" style="width:50px;padding-top:0px;">${body[nwktyp.FLDNM]}</td>
					            		</c:forEach>
				            		</c:if>
				            		<fmt:parseNumber var="convertRWKTM" value="${body.RWKTM}" />
			            			<td class="lastCol ${tdClass} <c:if test="${convertRWKTM ge limitNumber}">td11</c:if>" style="padding-top:0px;font-weight:bold;<c:if test="${convertRWKTM lt limitNumber}">background-color:#F6EDB8;</c:if>">
			            				<fmt:formatNumber var="decimalPoint" value="${(body.RWKTM % 1) % 0.1}" />
            							<fmt:formatNumber value="${body.RWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" /><!-- 소숫점 두자리를 한자리로 표현(버림 표현식) -->
			            			</td>
				            	</tr>
		            		</c:forEach>
	            		</c:otherwise>
	            	</c:choose>
	            </tbody>
            	</c:if>
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