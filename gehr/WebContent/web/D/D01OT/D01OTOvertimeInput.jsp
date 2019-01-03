<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 초과근무 실적입력
/*   Program ID   : D01OTOvertimeInput.jsp
/*   Description  : 초과근무 실적입력 화면
/*   Note         : 
/*   Creation     : 2018-06-08 성환희 [WorkTime52]
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
	<jsp:param name="css" value="D/D25WorkTime.css" />
    <jsp:param name="script" value="moment-with-locales.min.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
</jsp:include>

<c:choose>
	<c:when test="${isPop eq 'Y'}">
		<jsp:include page="/include/pop-body-header.jsp">
			<jsp:param name="title" value="LABEL.D.D01.0116" />
		</jsp:include>
	</c:when>
	<c:otherwise>
		<jsp:include page="/include/body-header.jsp">
		    <jsp:param name="title" value="LABEL.D.D01.0100" />
		</jsp:include>
	</c:otherwise>
</c:choose>

<script type="text/javascript">

(function($) {
	
	// Page onload
	$(function() {
		
		$.buttonSearchClickHandler();	// 검색버튼 이벤트 핸들러
		$.buttonSaveClickHandler();		// 실적확정 이벤트 핸들러
		
		<c:if test="${isPop eq 'Y'}">
			$.setTitleSearchDate();		// 팝업창 title build
		</c:if>
		
	});
	// End - Page onload
	
	// 팝업창 title build
	$.setTitleSearchDate = function() {
		var title = $('.header').find('span').eq(0).text();
		title = title + ' (${PARAM_YYYY}년 ${PARAM_MM}월)';
		
		$('.header').find('span').eq(0).text(title);
	}
	
	// 검색버튼 이벤트 핸들러
	$.buttonSearchClickHandler = function() {
		$('#searchButton').click(function(e) {
			e.preventDefault();
			
			$('[name=PARAM_ACTION]').val('SEARCH');
			$('[name=form1]')
					.attr('action', '<%= WebUtil.ServletURL %>hris.D.D01OT.D01OTOvertimeInputSV')
					.attr('target', '_self')
					.submit();
		});
	}

	// 실적확정 이벤트 핸들러
	$.buttonSaveClickHandler = function() {
		$('#btnSave').click(function(e) {
			e.preventDefault();
			
			if($('[name=selecCheck]:checked').length < 1) {
				alert("항목을 선택하세요.");
				return false;
			}
			
			$('[name=PARAM_ACTION]').val('SAVE');
			$('[name=selecCheck]').each(function() {
				if($(this).is(':checked')) {
					$(this).closest('tr').find('[name=SELEC]').val('X');
				} else {
					$(this).closest('tr').find('[name=SELEC]').val('');
				}
			});
			
			$('[name=form1]')
					.attr('action', '<%= WebUtil.ServletURL %>hris.D.D01OT.D01OTOvertimeInputSV')
			<c:choose>
				<c:when test="${isPop eq 'Y'}">
					.attr('target', 'ifHidden')
				</c:when>
				<c:otherwise>
					.attr('target', '_self')
				</c:otherwise>
			</c:choose>
					.submit();
		});
	}

})(jQuery);

</script>

<form name="form1" method="post">
	<input type="hidden" name="PARAM_ACTION" />

	<c:choose>
		<c:when test="${isPop eq 'Y'}">
			<input type="hidden" name="isPop" value="<c:out value='${isPop}' />" />
			<input type="hidden" name="PARAM_YYYY" value="<c:out value='${PARAM_YYYY}' />" />
			<input type="hidden" name="PARAM_MM" value="<c:out value='${PARAM_MM}' />" />
			<input type="hidden" name="PARAM_DATE" value="<c:out value='${PARAM_DATE}' />" />
		</c:when>
		<c:otherwise>
			<div class="tableInquiry">
		        <table>
		            <tr>
		                <td style="text-align:center;">
		                	조회년/월
		                	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                	<c:set var="n" value="2018" />
		                    <select name="PARAM_YYYY">
		                    	<c:forEach begin="${n}" end="${CURRENT_YEAR}">
		                    		<option value="${n}" <c:if test="${n eq PARAM_YYYY}">selected</c:if>>${n}</option>
		                    		<c:set var="n" value="${n+1}" />
		                    	</c:forEach>
		                    </select>
		                    <c:set var="n" value="1" />
		                    <select name="PARAM_MM">
		                    	<c:forEach begin="1" end="12">
		                    		<fmt:formatNumber value="${n}" pattern="00" var="nConvert" />
		                    		<option value="${nConvert}" <c:if test="${nConvert eq PARAM_MM}">selected</c:if>>${nConvert}</option>
		                    		<c:set var="n" value="${n+1}" />
		                    	</c:forEach>
		                    </select>
		                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    <div class="tableBtnSearch tableBtnSearch2">
		                        <a href="#" class="search" id="searchButton">
		                        	<span>조회</span>
		                        </a>
		                    </div>
		                </td>
		            </tr>
		        </table>
		    </div>
		</c:otherwise>
	</c:choose>
    
    <div class="tableArea">
	    <div class="table">
	        <table class="tableGeneral" cellspacing="0">
	        	<colgroup>
	        		<col width="18%" />
	        		<col width="15%" />
	        		<col width="18%" />
	        		<col width="15%" />
	        		<col width="18%" />
	        		<col width="15%" />
	        	</colgroup>
	            <tr>
	                <th>법정한도시간</th>
	                <td>
	                	<fmt:parseNumber var="maxtm" value="${T_HEADER[0].MAXTM}" integerOnly="true" />
	                	${maxtm}
	                </td>
	                <th class="th02">기본근무시간</th>
	                <td>
	                	<fmt:parseNumber var="bastm" value="${T_HEADER[0].BASTM}" integerOnly="true" />
	                	${bastm}
	                </td>
	                <th class="th02">실근무시간</th>
	                <td>${T_HEADER[0].RWKTM}</td>
	            </tr>
	            <tr>
	                <th>초과근무(실적확정)</th>
	                <td>${T_HEADER[0].OTMBA}</td>
	                <th class="th02">초과근무(결재)</th>
	                <td>${T_HEADER[0].OTMAC}</td>
	                <th class="th02">초과근무(결재중)</th>
	                <td>${T_HEADER[0].OTMAP}</td>
	            </tr>
	        </table>
	    </div>
	</div>
	
	<div class="listArea" style="margin-bottom:0px;">
	    <div class="table scroll-table scroll-head">
	        <table class="listTable" cellspacing="0">
	            <colgroup>
	                <col width="4%" />
	                <col width="7%" />
	                <col width="15%" />
	                <col width="7%" />
	                <col width="15%" />
	                <col width="10%" />
	                <col width="13%" />
	                <col />
	            </colgroup>
	            <thead>
		            <tr>
		                <th>선택</th>
		                <th>초과근무일</th>
		                <th>초과근무 신청시간</th>
		                <th>상태</th>
		                <th>실 근무시간</th>
		                <th>정상근무시간</th>
		                <th>초과근무 실적시간</th>
		                <th class="lastCol" >사후신청가능시간</th>
		            </tr>
	            </thead>
			</table>
		</div>
		<div class="scroll-table scroll-body">
			<table class="worktime listTable">
				<colgroup>
	                <col width="4%" />
	                <col width="7%" />
	                <col width="15%" />
	                <col width="7%" />
	                <col width="15%" />
	                <col width="10%" />
	                <col width="13%" />
	                <col />
	            </colgroup>
	            <tbody>
	            	<c:choose>
	            		<c:when test="${empty T_LIST}">
							<tr class="oddRow">
								<td class="lastCol align_center" colspan="8">해당하는 데이터가 존재하지 않습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
				            <c:forEach var="list" varStatus="status" items="${T_LIST}" >
				                <tr class="${status.index % 2 == 0 ? 'oddRow' : ''}" align="center">
				                    <td><input type="checkbox" name="selecCheck" <c:if test="${list.APPR_STAT ne '3' || viewMode eq 'Y'}">disabled</c:if> /></td>
				                    <td>${list.DATUM}</td>
				                    <td>${fn:substring(list.OTBEG, 0, 5)}~${fn:substring(list.OTEND, 0, 5)} ${list.OVTTX}</td>
				                    <td>${list.STATX}</td>
				                    <td>${fn:substring(list.RWBEG, 0, 5)}~${fn:substring(list.RWEND, 0, 5)} ${list.RWKTX}</td>
				                    <td>${list.NORTX}</td>
				                    <td>${list.OVRTX}</td>
				                    <td class="lastCol">
				                    	${list.NEXTX}
				                    	<input type="hidden" name="SELEC" />
				                    	<input type="hidden" name="AINF_SEQN" value="${list.AINF_SEQN}" />
				                    	<input type="hidden" name="PERNR" value="${list.PERNR}" />
				                    	<input type="hidden" name="DATUM" value="${list.DATUM}" />
				                    	<input type="hidden" name="VTKEN" value="${list.VTKEN}" />
				                    	<input type="hidden" name="OTBEG" value="${list.OTBEG}" />
				                    	<input type="hidden" name="OTEND" value="${list.OTEND}" />
				                    	<input type="hidden" name="OVTHR" value="${list.OVTHR}" />
				                    	<input type="hidden" name="OVTTX" value="${list.OVTTX}" />
				                    	<input type="hidden" name="APPR_STAT" value="${list.APPR_STAT}" />
				                    	<input type="hidden" name="STATX" value="${list.STATX}" />
				                    	<input type="hidden" name="RWBEG" value="${list.RWBEG}" />
				                    	<input type="hidden" name="RWEND" value="${list.RWEND}" />
				                    	<input type="hidden" name="RWKHR" value="${list.RWKHR}" />
				                    	<input type="hidden" name="RWKTX" value="${list.RWKTX}" />
				                    	<input type="hidden" name="NORTM" value="${list.NORTM}" />
				                    	<input type="hidden" name="NORTX" value="${list.NORTX}" />
				                    	<input type="hidden" name="OVRTM" value="${list.OVRTM}" />
				                    	<input type="hidden" name="OVRTX" value="${list.OVRTX}" />
				                    	<input type="hidden" name="NEXTM" value="${list.NEXTM}" />
				                    	<input type="hidden" name="NEXTX" value="${list.NEXTX}" />
				                    </td>
				                </tr>
				                
				                <c:if test="${list.APPR_STAT eq '3'}">
				                	<!-- 팝업으로 진입시 사용되는 변수. 승인되지 않은 실적건이 있을경우 실적확정 버튼 비노출 처리 -->
				                	<c:set var="isSave" value="Y" />
				                </c:if>
				            </c:forEach>
		            	</c:otherwise>
		            </c:choose>
	            </tbody>
	        </table>
	    </div>
	</div>
	
	<div class="commentImportant" style="width:97%;">
	    <p><span class="comment-title">초과근무 신청시간, 실근무시간, 초과근무 실적시간은 휴게시간을 제외한 순수 실근무시간입니다.</span></p>
	    <p><span class="comment-title">초과근무 실적시간 안내</span></p>
	    <p>- 초과근무는 신청/결재를 완료한 시간 내에서 실제 근무한 시간만큼 실적으로 인정 됩니다.</p>\
		<p>- 평일연장근무는 월 기본근무시간을 초과한 경우에만 실적으로 인정 됩니다.</p>
	</div>
	
	<div class="buttonArea">
        <ul class="btn_crud">
       	<!-- 팝업으로 진입여부 -->
		<!-- viewMode:조회전용으로 진입시 버튼 비노출 -->
		<!-- isSave:승인되지 않은 실적건이 있을경우 실적확정 버튼 비노출 -->
       	<c:choose>
       		<c:when test="${isPop eq 'Y'}">
       			<c:if test="${viewMode ne 'Y' && isSave eq 'Y'}">
					<li><a href="#" id="btnSave"><span>실적확정</span></a></li>
				</c:if>
				<li><a href="javascript:window.close();"><span>닫기</span></a></li>
       		</c:when>
       		<c:otherwise>
       			<li><a href="#" id="btnSave"><span>실적확정</span></a></li>
       		</c:otherwise>
       	</c:choose>
        </ul>
	</div>

</form>

<iframe name="ifHidden" width="0" height="0" />

<jsp:include page="/include/${bodyFooter}" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/><!-- html footer 부분 -->
