<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 실근무 실적현황 사무직
/*   Program ID   : D25WorkTimeLeaderReport.jsp
/*   Description  : 실근무 실적현황 사무직 레포트 화면
/*   Note         : 
/*   Creation     : 2018-05-28 성환희 [WorkTime52]
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
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
</jsp:include>

<style>
<!--
.scroll-body {
	max-height: 410px !important;
}
-->
</style>

<script type="text/javascript">

$(function() {
	
	$.buttonExcelHandler();
	
	$.bindNameClickPopup();
	
});

$.buttonExcelHandler = function() {
	$('#excelButton').click(function(e) {
		e.preventDefault();
		
		$('[name=form1]')
			.attr('action', '<%= WebUtil.ServletURL %>hris.D.D25WorkTime.D25WorkTimeLeaderReportSV?viewMode=excel')
			.attr('target', 'hidden')
			.submit();
	});
}

$.bindNameClickPopup = function() {
	$('#reportContents').find('a').each(function() {
		$(this).click(function(e) {
			e.preventDefault();
			$.popupView('reportPopView', '1200', '745', $(this).data('pernr'),  $(this).data('orgtx'));
		});
	});
}

$.popupView = function(winName, width, height, pernr, orgtx) {
	var empGubun = $('[name=SEARCH_EMPGUBUN]').val();
	var gubun = $('[name=SEARCH_GUBUN]').val();
	var datum = $('[name=SEARCH_DATE]').val();
	var year = datum.substring(0, 4);
	var month = datum.substring(5, 7);
	var day = datum.substring(8, 10);
	var screenwidth = (screen.width-width)/2;
    var screenheight = (screen.height-height)/2;
    var paramObj = {};
    paramObj.isPop = 'Y';
    paramObj.PARAM_PERNR = pernr;
    paramObj.PARAM_ORGTX = orgtx;
    paramObj.SEARCH_GUBUN = gubun;
    paramObj.SEARCH_DATE = datum;
    
    if(gubun == 'M') {
    	if(empGubun == 'H' && day > 20) {
    		month = Number(month) + 1;
        }
    	
    	paramObj.SEARCH_YEAR = year;
    	paramObj.SEARCH_MONTH = month;
    }
    
	openPopup({
        url: "<%= WebUtil.ServletURL %>hris.D.D25WorkTime.D25WorkTimeReportSV",
        data: paramObj,
        width: width,
        name:'privateReportPop',
        height: height,
        specs: {resizable: 'yes'}
    });
}

</script>

<%-- body 시작 선언 및 body title --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="subView" value="Y" />
</jsp:include>

<form name="form1" method="post">
	<input type="hidden" name="SEARCH_EMPGUBUN" value="<c:out value='${SEARCH_EMPGUBUN}' />" />
	<input type="hidden" name="SEARCH_GUBUN" value="<c:out value='${SEARCH_GUBUN}' />" />
	<input type="hidden" name="SEARCH_DATE" value="<c:out value='${SEARCH_DATE}' />" />
	<input type="hidden" name="SEARCH_DEPTID" value="<c:out value='${SEARCH_DEPTID}' />" />
	<input type="hidden" name="SEARCH_INCLUDE_SUBDEPT" value="<c:out value='${SEARCH_INCLUDE_SUBDEPT}' />" />
	<input type="hidden" name="SEARCH_PERNR" value="<c:out value='${SEARCH_PERNR}' />" />
</form>

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
<c:if test="${SEARCH_GUBUN eq 'W'}">
<h2 class="subtitle">근무시간 = 정상근무 + 초과근무 - 휴게/비근무</h2>
<div class="listArea" style="margin-bottom:0px;">
	<div class="table scroll-table scroll-head">
		<table class="listTable">
			<colgroup>
        		<col width="6%" />
        		<col width="6%" />
				<c:if test="${not empty T_TWEEKS}">
					<fmt:parseNumber var="colWidth" value="${88 / (fn:length(T_TWEEKS) * 4)}" />
					<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
						<col style="width:${colWidth}%" />
						<col style="width:${colWidth}%" />
						<col style="width:${colWidth}%" />
						<col style="width:${colWidth}%" />
					</c:forEach>
				</c:if>
        	</colgroup>
			<thead>
				<tr>
					<th rowspan="2" class="th02">사번</th>
					<th rowspan="2" class="th02">이름</th>
					<c:if test="${not empty T_TWEEKS}">
						<c:forEach var="tweeks" items="${T_TWEEKS}" varStatus="status">
							<th colspan="4" class="th02" style="border-bottom:solid 1px #cdcdcd;">${tweeks.TWEEKS}${tweeks.TPERIOD}</th>
						</c:forEach>
					</c:if>
				</tr>
				<tr>
					<c:if test="${not empty T_TWEEKS}">
						<c:forEach var="tweeks" items="${T_TWEEKS}" varStatus="status">
							<th class="th02">정상근무</th>
							<th class="th02">초과근무</th>
							<th class="th02">휴게/비근무</th>
							<th class="th02">근무시간</th>
						</c:forEach>
					</c:if>
				</tr>
			</thead>
		</table>
	</div>
	<div class="scroll-table scroll-body">
		<table class="worktime listTable">
			<colgroup>
        		<col width="6%" />
        		<col width="6%" />
				<c:if test="${not empty T_TWEEKS}">
					<fmt:parseNumber var="colWidth" value="${88 / (fn:length(T_TWEEKS) * 4)}" />
					<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
						<col style="width:${colWidth}%" />
						<col style="width:${colWidth}%" />
						<col style="width:${colWidth}%" />
						<col style="width:${colWidth}%" />
					</c:forEach>
				</c:if>
        	</colgroup>
			<tbody id="reportContents">
				<c:choose>
					<c:when test="${empty T_LIST}">
						<tr class="oddRow">
							<td class="lastCol align_center" colspan="${(fn:length(T_TWEEKS) * 4) + 2}">해당하는 데이터가 존재하지 않습니다.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<fmt:parseNumber var="limitNumber" value="64" />
						<c:set var="tweeksSize" value="${fn:length(T_TWEEKS)}" />
						<c:forEach var="list" items="${T_LIST}" varStatus="status">
							<tr <c:if test="${status.first}">class="sumRow"</c:if><c:if test="${!status.first}">class="borderRow"</c:if>>
								<c:choose>
									<c:when test="${status.first}">
										<c:set var="tdStyle" value="background-color:#F6EDB8;" />
										<td style="${tdStyle}">${list.ENAME}</td>
										<td style="${tdStyle}">${list.PERNR}</td>
									</c:when>
									<c:otherwise>
										<c:set var="tdStyle" value="" />
										<td><a href="#" style="color:blue;" data-pernr="${list.PERNR}" data-orgtx="${list.ORGTX}">${list.PERNR}</a></td>
										<td>${list.ENAME}</td>
									</c:otherwise>
								</c:choose>
								<c:forEach begin="1" end="${tweeksSize}" step="1" var="x">
								<c:set var="NORTM" value="NORTM${x}" />
								<c:set var="OVRTM" value="OVRTM${x}" />
								<c:set var="EDUTM" value="EDUTM${x}" />
								<c:set var="BRKTM" value="BRKTM${x}" />
								<c:set var="NWKTM" value="NWKTM${x}" />
								<c:set var="RWKTM" value="RWKTM${x}" />
									<td style="${tdStyle}">${list[NORTM]}</td>
									<fmt:formatNumber var="tempSum2" value="${list[OVRTM] + list[EDUTM]}" pattern="0.00" />
									<td style="${tdStyle}">${tempSum2 eq '0.00' ? '0' : tempSum2}</td>
									<fmt:formatNumber var="tempSum" value="${list[BRKTM] + list[NWKTM]}" pattern="0.00" />
									<td style="${tdStyle}">${tempSum eq '0.00' ? '0' : tempSum}</td>
									<fmt:parseNumber var="convertRWKTM" value="${list[RWKTM]}" />
									<td <c:if test="${convertRWKTM ge limitNumber}">class="td11"</c:if> style="font-weight:bold;<c:if test="${convertRWKTM lt limitNumber}">background-color:#F6EDB8;</c:if>">${list[RWKTM]}</td>
								</c:forEach>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>
</c:if>
<c:if test="${SEARCH_GUBUN eq 'M'}">
<h2 class="subtitle">당월 근무시간 = 정상근무 + 초과근무 - 휴게/비근무</h2>
<div class="listArea" style="margin-bottom:0px;">
	<div class="table scroll-table scroll-head">
		<table class="listTable">
			<colgroup>
        		<col style="width:15%" />
        		<col style="width:15%" />
        		<col style="width:14%" />
        		<col style="width:14%" />
        		<col style="width:14%" />
        		<col style="width:14%" />
        		<col style="width:14%" />
        	</colgroup>
			<thead>
				<tr>
					<th class="th02">사번</th>
					<th class="th02">이름</th>
					<th class="th02">정상근무</th>
					<th class="th02">초과근무</th>
					<th class="th02">휴게/비근무</th>
					<th class="th02">당월 근무시간</th>
					<th class="th02 lastCol">주당 평균 실 근무시간</th>
				</tr>
			</thead>
		</table>
	</div>
	<div class="scroll-table scroll-body">
		<table class="worktime listTable">
			<colgroup>
        		<col style="width:15%" />
        		<col style="width:15%" />
        		<col style="width:14%" />
        		<col style="width:14%" />
        		<col style="width:14%" />
        		<col style="width:14%" />
        		<col style="width:14%" />
        	</colgroup>
			<tbody id="reportContents">
				<c:choose>
					<c:when test="${empty T_LIST}">
						<tr class="oddRow">
							<td class="lastCol align_center" colspan="7">해당하는 데이터가 존재하지 않습니다.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<fmt:parseNumber var="limitNumber" value="52" /><!-- 실근무시간 비교에 사용되는 변수 -->
						<c:forEach var="list" items="${T_LIST}" varStatus="status">
							<tr class="borderRow">
								<c:choose>
									<c:when test="${status.first}">
										<c:set var="tdStyle" value="background-color:#F6EDB8;" />
										<td style="${tdStyle}">${list.ENAME}</td>
										<td style="${tdStyle}">${list.PERNR}</td>
									</c:when>
									<c:otherwise>
										<c:set var="tdStyle" value="" />
										<td><a href="#" style="color:blue;" data-pernr="${list.PERNR}" data-orgtx="${list.ORGTX}">${list.PERNR}</a></td>
										<td>${list.ENAME}</td>
									</c:otherwise>
								</c:choose>
								<td style="${tdStyle}">${list.NORTM}</td>
								<td style="${tdStyle}">${list.OVRTM}</td>
								<fmt:formatNumber var="tempSum" value="${list.BRKTM + list.NWKTM}" pattern="0.00" />
								<td style="${tdStyle}">${tempSum eq '0.00' ? '0' : tempSum}</td>
								<td style="font-weight:bold;background-color:#F6EDB8;">${list.MONSUM}</td>
								<fmt:parseNumber var="convertAVRTM" value="${list.AVRTM}" />
								<td <c:if test="${convertAVRTM ge limitNumber}">class="td11"</c:if> style="font-weight:bold;<c:if test="${convertAVRTM lt limitNumber}">background-color:#F6EDB8;</c:if>">${list.AVRTM}</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>
</c:if>
<div class="commentOne">
	<span>실 근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.</span>
</div>

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/><!-- html footer 부분 -->