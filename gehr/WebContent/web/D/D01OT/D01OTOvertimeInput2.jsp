<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 초과근무 실적입력
/*   Program ID   : D01OTOvertimeInput.jsp
/*   Description  : 초과근무 실적입력 화면
/*   Note         : 
/*   Creation     : 2018-08-14 성환희 [WorkTime52]
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
	
	$.fn.Rowspan = function(colIdx, isStats) {
		return this.each(function(){
			var that;
			$('tr', this).each(function(row) {
				$('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
					
					if ($(this).html() == $(that).html()
						&& (!isStats
								|| isStats && $(this).prev().html() == $(that).prev().html()
								)
						) {
						rowspan = $(that).attr("rowspan") || 1;
						rowspan = Number(rowspan)+1;

						$(that).attr("rowspan",rowspan);

						$(this).remove();

					} else {
						that = this;
					}

					that = (that == null) ? this : that;
				});
			});
		});
	};
	
	// Page onload
	$(function() {
		
		$.buttonSearchClickHandler();	// 검색버튼 이벤트 핸들러
		$.buttonSaveClickHandler();		// 실적확정 이벤트 핸들러
		
		$.decorateDataTable();			// 리스트 테이블 build
		
		<c:if test="${isPop eq 'Y'}">
			$.setTitleSearchDate();		// 팝업창 title build
			
			<c:if test="${viewMode eq 'Y'}">
			$.disabledAllCheckbox();	// 조회모드용 체크박스 비활성
			</c:if>
		</c:if>
		
	});
	// End - Page onload
	
	// 조회모드용 체크박스 비활성
	$.disabledAllCheckbox = function() {
		$('[name=selecCheck]').each(function(index) {
			$(this).prop('disabled', true);
		});
	}
	
	// 리스트 테이블 build
	$.decorateDataTable = function() {
		var $table = $('#dataTable');
		
		// [SELEC] 'X' 선택값 초기화 - 확정 실패시 history.back 대응
		$('[name=SELEC]').each(function() { $(this).val(''); });
		
		// 체크박스 선택값 초기화 - 확정 실패시 history.back 대응
		$('[name=selecCheck]').each(function() { $(this).prop('checked', false); });
		
		// table rowspan 적용
		$table.Rowspan(7)
			.Rowspan(6)
			.Rowspan(5)
			.Rowspan(4)
			.Rowspan(1)
			.Rowspan(0);
		
		// 1. 체크박스 비활성화
		// 2. 짝수row "oddRow" 추가
		// 3. 마지막 row border 제거
		var checkTotalCount = $('[name=selecCheck]').length;
		$('[name=selecCheck]').each(function(index) {
			var $this = $(this);
			
			// 1. 체크박스 비활성화
			$this.prop('disabled', $this.data("disbled"));
			
			// 2. 짝수row "oddRow" 추가
			var $pTR = $this.closest('tr');
			var rowspanCount = $this.closest('td').attr('rowspan');
			var checkTRIndex = $pTR.index();
			if(index % 2 == 0) {
				$pTR.addClass("oddRow");
				
				var $tempTR;
				for(var i = 1; i < rowspanCount; i++) {
					if($tempTR == null) $tempTR = $pTR.next();
					
					$tempTR.addClass("oddRow");
					
					$tempTR = $tempTR.next();
				}
			} else {
				$pTR.addClass("notOddRow");
				
				var $tempTR;
				for(var i = 1; i < rowspanCount; i++) {
					if($tempTR == null) $tempTR = $pTR.next();
					
					$tempTR.addClass("notOddRow");
					
					$tempTR = $tempTR.next();
				}
			}
			
			// 3. 일별 마지막 row border 제거
			if(checkTRIndex > 0) {
				$table.find('tr').eq(checkTRIndex - 1).find('td').each(function() {
					$(this).css('border-bottom', '');
				});
				
				if(index == checkTotalCount - 1) {
					$table.find('tr').last().find('td').each(function() {
						$(this).css('border-bottom', '');
					});
				}
			} else {
				$table.find('tr').last().find('td').each(function() {
					$(this).css('border-bottom', '');
				});
			}
		});
	}
	
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

<style>
table#dataTable tr.oddRow:hover {
	background: #f5f5f5 !important;
}
table#dataTable tr.notOddRow:hover {
	background: #ffffff !important;
}
</style>

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
	                <col width="25%" />
	                <col width="10%" />
	                <col width="10%" />
	                <col />
	            </colgroup>
	            <thead>
		            <tr>
		                <th>선택</th>
		                <th>초과근무일</th>
		                <th>초과근무 신청시간</th>
		                <th>상태</th>
		                <th>실 근무시간</th>
		                <th>기본근무시간</th>
		                <th>초과근무 실적시간</th>
		                <th class="lastCol" >사후신청가능시간</th>
		            </tr>
	            </thead>
			</table>
		</div>
		<div class="scroll-table scroll-body">
			<table id="dataTable" class="worktime listTable">
				<colgroup>
	                <col width="4%" />
	                <col width="7%" />
	                <col width="15%" />
	                <col width="7%" />
	                <col width="25%" />
	                <col width="10%" />
	                <col width="10%" />
	                <col />
	            </colgroup>
	            <tbody>
	            	<c:choose>
	            		<c:when test="${empty T_REQTM}">
							<tr class="oddRow">
								<td class="lastCol align_center" colspan="8">해당하는 데이터가 존재하지 않습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
				            <c:forEach var="list" varStatus="status" items="${T_REQTM}" >
				                <tr align="center">
				                    <td><input type="checkbox" name="selecCheck" data-date="${list.DATUM}" data-disbled="${list.ISDISABLED}" /></td>
				                    <td>${list.DATUM}</td>
				                    <td style="border-bottom:1px solid #dddddd;text-align:left;padding-left:4px;">
				                    	${list.TIMETX}
				                    	<!-- 
				                    	실적확정시 사용되는 Data - [T_REQTM] table
				                    	 -->
				                    	<input type="hidden" name="REQTM_PERNR" value="<c:out value='${list.PERNR}' />" />
				                    	<input type="hidden" name="REQTM_AINF_SEQN" value="<c:out value='${list.AINF_SEQN}' />" />
				                    	<input type="hidden" name="REQTM_DATUM" value="<c:out value='${list.DATUM}' />" />
				                    	<input type="hidden" name="REQTM_BEGUZ" value="<c:out value='${list.BEGUZ}' />" />
				                    	<input type="hidden" name="REQTM_ENDUZ" value="<c:out value='${list.ENDUZ}' />" />
				                    	<input type="hidden" name="REQTM_STDAZ" value="<c:out value='${list.STDAZ}' />" />
				                    	<input type="hidden" name="REQTM_TIMETX" value="<c:out value='${list.TIMETX}' />" />
				                    	<input type="hidden" name="REQTM_APPR_STAT" value="<c:out value='${list.APPR_STAT}' />" />
				                    	<input type="hidden" name="REQTM_STATX" value="<c:out value='${list.STATX}' />" />
				                    </td>
				                    <td style="border-bottom:1px solid #dddddd;">${list.STATX}</td>
				                    <td style="text-align:left;padding-left:4px;">
				                    	<input type="hidden" name="temp1" value="${list.DATUM}" />
				                    	<c:if test="${list.TRESULT.TIMETX1 ne null && list.TRESULT.TIMETX1 ne ''}">${list.TRESULT.TIMETX1}</c:if>
				                    	<c:if test="${list.TRESULT.TIMETX2 ne null && list.TRESULT.TIMETX2 ne ''}"><BR/>${list.TRESULT.TIMETX2}</c:if>
				                    	<c:if test="${list.TRESULT.TIMETX3 ne null && list.TRESULT.TIMETX3 ne ''}"><BR/>${list.TRESULT.TIMETX3}</c:if>
				                    </td>
				                    <td>
				                    	<input type="hidden" name="temp2" value="${list.DATUM}" />
				                    	${list.TRESULT.BASTX}
				                    </td>
				                    <td>
				                    	<input type="hidden" name="temp3" value="${list.DATUM}" />
				                    	${list.TRESULT.OVRTX}
				                    </td>
				                    <td class="lastCol" style="text-align:left;padding-left:4px;">
				                    	${list.TRESULT.NEXTX}
				                    	<!-- 
				                    	실적확정시 사용되는 Data - [T_RESULT] table
				                    	 -->
				                    	<input type="hidden" name="SELEC" />
				                    	<input type="hidden" name="PERNR" value="<c:out value='${list.TRESULT.PERNR}' />" />
				                    	<input type="hidden" name="DATUM" value="<c:out value='${list.TRESULT.DATUM}' />" />
				                    	<input type="hidden" name="BEGUZ1" value="<c:out value='${list.TRESULT.BEGUZ1}' />" />
				                    	<input type="hidden" name="ENDUZ1" value="<c:out value='${list.TRESULT.ENDUZ1}' />" />
				                    	<input type="hidden" name="ANZHL1" value="<c:out value='${list.TRESULT.ANZHL1}' />" />
				                    	<input type="hidden" name="ABSTD1" value="<c:out value='${list.TRESULT.ABSTD1}' />" />
				                    	<input type="hidden" name="TIMETX1" value="<c:out value='${list.TRESULT.TIMETX1}' />" />
				                    	<input type="hidden" name="BEGUZ2" value="<c:out value='${list.TRESULT.BEGUZ2}' />" />
				                    	<input type="hidden" name="ENDUZ2" value="<c:out value='${list.TRESULT.ENDUZ2}' />" />
				                    	<input type="hidden" name="ANZHL2" value="<c:out value='${list.TRESULT.ANZHL2}' />" />
				                    	<input type="hidden" name="TIMETX2" value="<c:out value='${list.TRESULT.TIMETX2}' />" />
				                    	<input type="hidden" name="BEGUZ3" value="<c:out value='${list.TRESULT.BEGUZ3}' />" />
				                    	<input type="hidden" name="ENDUZ3" value="<c:out value='${list.TRESULT.ENDUZ3}' />" />
				                    	<input type="hidden" name="ANZHL3" value="<c:out value='${list.TRESULT.ANZHL3}' />" />
				                    	<input type="hidden" name="TIMETX3" value="<c:out value='${list.TRESULT.TIMETX3}' />" />
				                    	<input type="hidden" name="BASTM" value="<c:out value='${list.TRESULT.BASTM}' />" />
				                    	<input type="hidden" name="BASTX" value="<c:out value='${list.TRESULT.BASTX}' />" />
				                    	<input type="hidden" name="OVRTM" value="<c:out value='${list.TRESULT.OVRTM}' />" />
				                    	<input type="hidden" name="OVRTX" value="<c:out value='${list.TRESULT.OVRTX}' />" />
				                    	<input type="hidden" name="NEXTM" value="<c:out value='${list.TRESULT.NEXTM}' />" />
				                    	<input type="hidden" name="NEXTX" value="<c:out value='${list.TRESULT.NEXTX}' />" />
				                    </td>
				                </tr>
				                
				                <c:if test="${list.APPR_STAT ne '3'}">
				                	<!-- 팝업으로 진입시 사용되는 변수. 승인되지 않은 실적건이 있을경우 실적확정 버튼 비노출 처리 -->
				                	<c:set var="isSave" value="N" />
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
	    <p><span class="comment-title">초과근무 일자별로 실적입력 가능합니다. (동일일자 여러건 신청시 모두 결재완료되어야 실적입력 가능)</span></p>
	    <p><span class="comment-title">초과근무 실적입력 후 해당일자의 추가 초과근무는 사후신청(3 근무일 이내)을 이용하세요.</span></p>
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
       			<c:if test="${viewMode ne 'Y' && isSave ne 'N'}">
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
