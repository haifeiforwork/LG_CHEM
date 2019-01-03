<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 부서근태
/*   Program Name : 실근무 실적현황
/*   Program ID   : D40WorkTimeReport.jsp
/*   Description  : 실근무 실적현황 레포트 화면
/*   Note         : 
/*   Creation     : 2018-06-04 성환희 [WorkTime52]
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
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
</jsp:include>

<script type="text/javascript">

$(function() {
	
	//$.buttonPrintHandler();
	$.buttonExcelHandler();
	
	$.bindNameClickPopup();
	
});

$.buttonPrintHandler = function() {
	$('#printButton').click(function(e) {
		e.preventDefault();
		
		window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1300,height=662,left=0,top=2");
		
		$('[name=form1]')
			.attr('action', '<%= WebUtil.JspURL %>D/D40TmGroup/common/printFrame_workTimeReport.jsp?viewMode=print')
			.attr('target', 'essPrintWindow')
			.submit();
	});
}

$.buttonExcelHandler = function() {
	$('#excelButton').click(function(e) {
		e.preventDefault();
		
		$('[name=form1]')
			.attr('action', '<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40WorkTimeReportSV?viewMode=excel')
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
	var empGubun = 'H';
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
   	paramObj.SEARCH_DATE = datum;
    
	openPopup({
        url: "<%= WebUtil.ServletURL %>hris.D.D25WorkTime.D25WorkTimeReportSV",
        data: paramObj,
        width: width,
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
	<input type="hidden" name="orgOrTm" value="${orgOrTm}" />
	<input type="hidden" name="searchDeptNo" value="${searchDeptNo}" />
	<input type="hidden" name="searchDeptNm" value="${searchDeptNm}" />
	<input type="hidden" name="iSeqno" value="${iSeqno}" />
	<input type="hidden" name="ISEQNO" value="${ISEQNO}" />
	<input type="hidden" name="I_SELTAB" value="${I_SELTAB}" />
	<input type="hidden" name="SEARCH_DATE" value="${SEARCH_DATE}" />
</form>

<div class="buttonArea" style="float:right;">
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

<h2 class="subtitle">해당 사번을 클릭하면, 세부 현황이 조회됩니다.</h2>
<br/>

<div class="listArea" style="margin-bottom:0px;">
	<div class="table scroll-table scroll-head">
		<table class="listTable">
			<colgroup>
				<col width="8%" />
        		<col width="10%" />
        		<col width="10%" />
        		<col width="27%" />
        		<col width="16%" />
        		<col width="10%" />
        		<col width="10%" />
        		<col width="10%" />
        		<%-- <col width="8%" />
        		<col width="5%" />
        		<col width="7%" />
        		<col width="6%" />
        		<col width="14%" />
        		<col width="14%" />
        		<col width="14%" />
        		<col width="11%" />
        		<col width="7%" />
        		<col width="7%" />
        		<col width="7%" /> --%>
        	</colgroup>
			<thead>
				<tr>
					<%-- <th class="th02" rowspan="2">근무제유형</th> --%>
					<th class="th02" rowspan="2">구분</th>
					<th class="th02" rowspan="2">사번</th>
					<th class="th02" rowspan="2">이름</th>
					<th class="th02" rowspan="2">소속</th>
					<%-- <th class="th02" rowspan="2">사업장 탄력/정상 근무기간</th>
					<th class="th02" rowspan="2">개인 탄력/정상 근무기간</th> --%>
					<th class="th02" rowspan="2">주당 실근무시간<br/>${not empty T_RESULT ? T_RESULT[0].WTEXT : ""}</th>
					<th class="th02" colspan="3">기간별 주 평균시간</th>
				</tr>
				<tr>
					<th class="th02" style="border-top:1px solid #cdcdcd;">기준</th>
					<th class="th02" style="border-top:1px solid #cdcdcd;">실 근무시간</th>
					<th class="th02" style="border-top:1px solid #cdcdcd;">주평균시간</th>
				</tr>
			</thead>
		</table>
	</div>
	<div class="scroll-table scroll-body">
		<table class="worktime listTable">
			<colgroup>
				<col width="8%" />
        		<col width="10%" />
        		<col width="10%" />
        		<col width="27%" />
        		<col width="16%" />
        		<col width="10%" />
        		<col width="10%" />
        		<col width="10%" />
        		<%-- <col width="8%" />
        		<col width="5%" />
        		<col width="7%" />
        		<col width="6%" />
        		<col width="14%" />
        		<col width="14%" />
        		<col width="14%" />
        		<col width="11%" />
        		<col width="7%" />
        		<col width="7%" />
        		<col width="7%" /> --%>
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
							<tr class="borderRow">
								<%-- <td>${result.WTCATTX}</td> --%>
								<td>${result.ADJUNTTX}</td>
								<td><a href="#" style="color:blue;" data-pernr="${result.PERNR}" data-orgtx="${result.ORGEHTX}">${result.PERNR}</a></td>
								<td>${result.ENAME}</td>
								<td>${result.ORGEHTX}</td>
								<%-- <td>${result.OTEXT}</td>
								<td>${result.RTEXT}</td> --%>
								<td>
									<fmt:formatNumber var="decimalPoint" value="${(result.WRWKTM % 1) % 0.1}" />
         							<fmt:formatNumber value="${result.WRWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
								</td>
								<td>${result.RMAXTM}</td>
								<td>
									<fmt:formatNumber var="decimalPoint" value="${(result.RRWKTM % 1) % 0.1}" />
         							<fmt:formatNumber value="${result.RRWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
								</td>
								<fmt:parseNumber var="convertRAVRTM" value="${result.RAVRTM}" />
								<td <c:if test="${convertRAVRTM ge limitNumber}">class="td11"</c:if>>
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
	
<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/><!-- html footer 부분 -->