<%--
/********************************************************************************/
/*																			  	*/
/*   System Name	:  MSS													  	*/
/*   1Depth Name	:  부서근태												  	*/
/*   2Depth Name	:  실근무 실적현황										  	*/
/*   Program Name	:  실근무 실적현황										  	*/
/*   Program ID		:  D40WorkTimeReportFrame.jsp							  	*/
/*   Description	:  현장직 실근무 실적현황									  	*/
/*   Note			:             											  	*/
/*   Creation		:  2018-06-01  성환희 [WorkTime52]                         	*/
/*   Update			:                                           			  	*/
/*   																		  	*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  				//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
	String E_INFO =  (String)request.getAttribute("E_INFO");

	Vector resultList    = (Vector)request.getAttribute("resultList");

%>

<jsp:include page="/include/header.jsp">
    <jsp:param name="noCache" value="?${timestamp}" />
    <jsp:param name="css" value="bootstrap-3.3.2.min.css" />
    <jsp:param name="css" value="D/D25WorkTime.css" />
    <jsp:param name="script" value="moment-with-locales.min.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
</jsp:include>

<c:set var="listCnt" value="${fn:length(resultList)}" />

<!-- 근무 실적 현황 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D25.0078" />
</jsp:include>

<form name="form1" method="post">
    <input type="hidden" name="urlName" value="">
    <input type="hidden" id="ISEQNO" name="ISEQNO" value="">
    <input type="hidden" name="eInfo"  value="${E_INFO}">
	<%@ include file="/web/D/D40TmGroup/common/SearchD40DeptInfoPernr.jsp" %>
	
	<script type="text/javascript">

		var listCnt = '${listCnt}';
		
		$(function() {
			
			$.bindButtonSearchHandler();
			
			$.initSeachCondition();
			
			setTimeout(blockFrame);
			$('#searchButton').trigger('click');
			
		});
		
		$.initSeachCondition = function() {
			var iSeqno = "";
			if($("#iSeqno").val() == ""){
				$("select option").each(function(){
					iSeqno += $(this).val()+",";
				});
				$("#ISEQNO").val(iSeqno.slice(0, -1));
			}else{
				$("#ISEQNO").val( $("#iSeqno").val());
			}
			if(!$('input:radio[name=orgOrTm]').is(':checked')){	//최초 진입 시 라디오 체크 안되어있을때
				if(listCnt == 0){ //근태 그룹개수가 없을때 조직도 선택
			    	$('input:radio[name=orgOrTm]:input[value=1]').attr("checked", true).trigger("click");
			    }else{	//근태그룹 선택
			    	$('input:radio[name=orgOrTm]:input[value=2]').attr("checked", true).trigger("click");
			    }
			}
			if($(':input:radio[name=orgOrTm]:checked').val() == "2"){
				$("#I_SELTAB").val("C");
			}
		}
		
		$.bindButtonSearchHandler = function() {
			$('#searchButton').click(function(e) {
				e.preventDefault();
				
				$.initSeachCondition();
				
				$('[name=form1]')
					.attr('action', '<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40WorkTimeReportSV')
					.attr('method', 'post')
					.attr('target', 'listFrame')
					.submit();
			});
		}
	
	</script>
	
	<div class="tableInquiry" style="margin-bottom:0px;">
		<table>
			<colgroup>
				<col width="13%" /><!-- radio button -->
				<col width="18%" /><!-- 조회 기준일 -->
				<col />
			</colgroup>
			<tr>
				<td>&nbsp;</td>
				<td>
					<label class="bold">조회기준일</label>
					&nbsp;
                	<input type="text" id="SEARCH_DATE" name="SEARCH_DATE" class="date required" size="10" value="${SEARCH_DATE}" style="line-height:normal;" />
				</td>
				<td>
					<div class="tableBtnSearch tableBtnSearch2">
                        <a href="#" class="search" id="searchButton">
                        	<span>조회</span>
                        </a>
                    </div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="searchOrg_ment" style="margin-top:5px;text-align:left; margin-bottom: 5px;">
		<div class="searchOrg_ment" id="searchOrg_ment" style="padding-left:200px;display:none;">
			* 조회기준일이 속한 탄력근무 기간 데이터를 조회합니다.
		</div>
	</div>
</form>

	<br/>

	<div class="frameWrapper">
		<!-- Tab 프레임 -->
	    <iframe id="listFrame" name="listFrame" onload="autoResize();" frameborder="0" scrolling="no"></iframe>
	</div>

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->