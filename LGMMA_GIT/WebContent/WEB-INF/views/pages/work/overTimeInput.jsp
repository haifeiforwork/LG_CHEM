<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
<!--
.table {margin-bottom:0}
.scroll-table {border-bottom:solid 1px #cdcdcd; overflow-x:hidden; overflow-y:scroll}
.scroll-table table {table-layout:fixed; margin-bottom:0; border-bottom:0}
.scroll-table th {border-bottom:0; text-align:center}
.scroll-table th, .scroll-table td {font-size:12px}
.scroll-table td {height:40px; padding:1px 0}
.scroll-table .icon {margin:0 auto; padding-left:25px; width:120px}
.scroll-table .icon.done {background:url(../../icon_saved.png) no-repeat left center}
.scroll-table .icon.required {background:url(../../icon_required.png) no-repeat left center}
.scroll-table select, .scroll-table label {vertical-align:middle}
.scroll-table select, .scroll-table input[type="text"] {min-width:45px; max-width:60%}
.scroll-table select.time {min-width:45px; width:45px}
.scroll-table a.icon-popup {position:relative; top:-1px}
.scroll-table a.icon-popup.invisible {visibility:hidden}
.scroll-table a.non-background {margin:0 0 3px 0; color:#0000ff; background:none; cursor:pointer}
.scroll-table div.readonly-look {margin-right:3px; width:60%; height:22px; line-height:22px; display:inline-block; background-color:#f3f3f3}
.scroll-head {scrollbar-face-color:#ffffff; scrollbar-shadow-color:#ffffff; scrollbar-highlight-color:#ffffff; scrollbar-3dlight-color:#ffffff; scrollbar-darkshadow-color:#ffffff; scrollbar-track-color:#ffffff; scrollbar-arrow-color:#ffffff}
.scroll-body {margin-bottom:5px; min-height:40px; max-height:240px}
.scroll-body tbody tr:hover {background-color:#e1e1e1}

.listTable td {border-bottom:0;}
.borderBottomColumn {border-bottom:1px solid #dddddd !important;}

.searchSelect {width:auto !important; vertical-align:middle;}

.commentImportant {width: 97%;padding: 12px;margin-bottom:10px;}

.oddRow {background-color: #f5f5f5 !important;}
.notOddRow {background-color: #ffffff !important;}
-->
</style>

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
		// 4. TD 우측 border 회색
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
					$(this).removeClass('borderBottomColumn');
				});
				
				if(index == checkTotalCount - 1) {
					$table.find('tr').last().find('td').each(function() {
						$(this).removeClass('borderBottomColumn');
					});
				}
			} else {
				$table.find('tr').last().find('td').each(function() {
					$(this).removeClass('borderBottomColumn');
				});
			}
		});
		
		// 4.TD 우측 border 회색
		$table.find('td').not('.lastCol').each(function() {
			$(this).css('border-right', '1px solid #dddddd');
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
					.attr('action', '/work/overTimeInput')
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
			
			$.ajax({
		 		type : 'POST',
		 		url : '/work/overTimeInputSave.json',
		 		cache : false,
		 		dataType : 'json',
		 		data : $('[name=form1]').serialize(),
		 		async :false,
		 		success : function(response) {
		 			if(response.success) {
		 				alert("저장되었습니다.");
			 			<c:choose>
							<c:when test="${isPop eq 'Y'}">
							    parent.closeLayerPopup(true);
							</c:when>
							<c:otherwise>
								$('#searchButton').trigger('click');
							</c:otherwise>
						</c:choose>
		 			} else {
		 				alert("실적확정 오류가 발생하였습니다."  + response.message);
		 			}
		 		},
		 		error : function(jqXHR, textStatus, errorThrown ) {
		 			
		 		}
		 	});
		});
	}

})(jQuery);

</script>

<c:if test="${isPop ne 'Y'}">
<!--// Page Title start -->
<div class="title">
	<h1>초과근무 실적확정</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">근태</a></span></li>
			<li class="lastLocation"><span><a href="#">초과근무 실적확정</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
</c:if>

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
		                	조회년/월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                	<c:set var="n" value="2018" />
		                    <select name="PARAM_YYYY" class="searchSelect">
		                    	<c:forEach begin="${n}" end="${CURRENT_YEAR}">
		                    		<option value="${n}" <c:if test="${n eq PARAM_YYYY}">selected</c:if>>${n}</option>
		                    		<c:set var="n" value="${n+1}" />
		                    	</c:forEach>
		                    </select>
		                    <c:set var="n" value="1" />
		                    <select name="PARAM_MM" class="searchSelect">
		                    	<c:forEach begin="1" end="12">
		                    		<fmt:formatNumber value="${n}" pattern="00" var="nConvert" />
		                    		<option value="${nConvert}" <c:if test="${nConvert eq PARAM_MM}">selected</c:if>>${nConvert}</option>
		                    		<c:set var="n" value="${n+1}" />
		                    	</c:forEach>
		                    </select>
		                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    <div class="tableBtnSearch">
		                        <button id="searchButton">
		                        	<span>조회</span>
		                        </button>
		                    </div>
		                </td>
		            </tr>
		        </table>
		    </div>
		</c:otherwise>
	</c:choose>
    
    <div class="tableArea" style="padding-top:4px">
        <h2 class="subtitle"></h2>
        <div class="buttonArea${TPGUB_CD ? '' : ' Lnodisplay'}">
            <ul class="btn_mdl">
                <li><a href="#" name="RADL-button"><span>신청/결재 기한</span></a></li>
            </ul>
        </div>
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
	
	<div class="listArea" style="margin-bottom:0px;padding-bottom:10px;">
	    <div class="table scroll-table scroll-head">
	        <table class="listTable worktime">
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
		                <th>사후신청가능시간</th>
		            </tr>
	            </thead>
			</table>
		</div>
		<div class="scroll-table scroll-body">
			<table id="dataTable" class="listTable worktime">
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
				                    <td class="borderBottomColumn" style="text-align:left;padding-left:4px;">
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
				                    <td class="borderBottomColumn">${list.STATX}</td>
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
				                    <td style="text-align:left;padding-left:4px;">
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
				                
				                <c:if test="${list.ISDISABLED eq 'true'}">
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
	
	<div class="buttonArea" style="padding-bottom:10px;">
        <ul class="btn_crud">
       	<!-- 팝업으로 진입여부 -->
		<!-- viewMode:조회전용으로 진입시 버튼 비노출 -->
		<!-- isSave:승인되지 않은 실적건이 있을경우 실적확정 버튼 비노출 -->
        <c:choose>
       		<c:when test="${isPop eq 'Y'}">
       			<c:if test="${viewMode ne 'Y' && isSave ne 'N'}">
					<li><a href="#" id="btnSave"><span>실적확정</span></a></li>
				</c:if>
       		</c:when>
       		<c:otherwise>
       			<li><a href="#" id="btnSave"><span>실적확정</span></a></li>
       		</c:otherwise>
       	</c:choose>
        </ul>
	</div>
	
	<div class="commentImportant">
	    <p><span class="bold">초과근무 신청시간, 실근무시간, 초과근무 실적시간은 휴게시간을 제외한 순수 실근무시간입니다.</span></p>
	    <p><span class="bold">초과근무 일자별로 실적입력 가능합니다. (동일일자 여러건 신청시 모두 결재완료되어야 실적입력 가능)</span></p>
	    <p><span class="bold">초과근무 실적입력 후 해당일자의 추가 초과근무는 사후신청(<c:out value="${E_SUBCD}" />)을 이용하세요.</span></p>
	    <p><span class="bold">기본근무시간 미달로 인해 초과근무 실적시간이 없는 경우에는, 해당일자의 초과근무를 취소신청 하시기 바랍니다.</span></p>
	    <p><span class="bold">초과근무 실적시간 안내</span></p>
	    <p>- 초과근무는 신청/결재를 완료한 시간 내에서 실제 근무한 시간만큼 실적으로 인정 됩니다.</p>
		<p>- 평일연장근무는 월 기본근무시간을 초과한 경우에만 실적으로 인정 됩니다.</p>
	</div>
	
</form>
