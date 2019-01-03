<%
	/******************************************************************************/
	/*   System Name  : ESS                                                         													*/
	/*   1Depth Name  : MY HR 정보                                                  															*/
	/*   2Depth Name  : 휴가/근태                                                        														*/
	/*   Program Name : Flextime(완전선택근무제) 상세                                                  														*/
	/*   Program ID   : D20FlextimeSelectBuild.jsp                                        													*/
	/*   Description  : Flextime(완전선택근무제) 상세 화면                                        																*/
	/*   Note         :                                                             															*/
	/*   Creation     : 2018-05-09  성환희     [WorkTime52] 부분/완전선택 근무제 변경                                       */
	/*   Update       : 								*/
	/******************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>


<tags:layout css="ui_library_approval.css"  script="dialog.js" >

    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_FLEXTIME"
    	updateUrl="${g.servlet}hris.D.D20Flextime.D20FlextimeChangeSV"    	>

<script>

$(function() {
	
	if(!$('#SCHKZ').val() && $('#FLEX_BEGTM').val()) {
		$('input:radio[name="schkz"][value="chkTime"]').prop('checked', true);
		
		$('#date_line')
				.find('span').hide().end()
				.find('#FLEX_ENDDA').hide();
	} else {
		$('#begin_time').prop('disabled', true)
				.find('option').eq(0).prop('selected', true);
		$('#end_time').find('option').eq(9).prop('selected', true);
		$('#begin_minute').prop('disabled', true)
				.find('option').eq(0).prop('selected', true);
		$('#end_minute').find('option').eq(0).prop('selected', true);
	}
	
});

</script>

		<!-- 상단 입력 테이블 시작-->
		<div class="tableArea">
			<div class="table">
				<table class="tableGeneral">
					<colgroup>
						<col width=15% />
						<col />
					</colgroup>

					<tr>
						<th rowspan="2"><span class="textPink">*</span><spring:message code="LABEL.D.D20.0001"/><!-- 근로시간 선택 --></th>
						<td ><input type="radio" name="schkz" value="F070A220"
							${ resultData.SCHKZ==("F070A220") ? "checked" : "" } disabled> 07:00~16:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F080A220"
							${ resultData.SCHKZ==("F080A220") ? "checked" : "" } disabled> 08:00~17:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F090A220"
							${ resultData.SCHKZ==("F090A220") ? "checked" : "" } disabled> 09:00~18:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F100A220"
							${ resultData.SCHKZ==("F100A220") ? "checked" : "" } disabled> 10:00~19:00
						</td>
					</tr>
					<tr>
						<td ><input type="radio" name="schkz" value="F073A220"
							${ resultData.SCHKZ==("F073A220") ? "checked" : "" } disabled> 07:30~16:30
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F083A220"
							${ resultData.SCHKZ==("F083A220") ? "checked" : "" } disabled> 08:30~17:30
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F093A220"
							${ resultData.SCHKZ==("F093A220") ? "checked" : "" } disabled> 09:30~18:30
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="chkTime" disabled>
							<select id="begin_time" disabled>
								<c:set var="n" value="0" />
								<c:forEach begin="0" end="23">
									<fmt:formatNumber value="${n}" pattern="00" var="nConvert" />
									<option value="${nConvert}"  <c:if test="${fn:substring(resultData.FLEX_BEGTM, 0, 2) eq nConvert}">selected</c:if>>${nConvert}</option>
									<c:set var="n" value="${n+1}" />
								</c:forEach>
							</select>
							<select id="begin_minute" disabled>
								<option value="00"  <c:if test="${fn:substring(resultData.FLEX_BEGTM, 3, 5) eq '00'}">selected</c:if>>00</option>
								<option value="30"  <c:if test="${fn:substring(resultData.FLEX_BEGTM, 3, 5) eq '30'}">selected</c:if>>30</option>
							</select>
							~
							<select id="end_time" disabled>
								<c:set var="n" value="0" />
								<c:forEach begin="0" end="23">
									<fmt:formatNumber value="${n}" pattern="00" var="nConvert" />
									<option value="${nConvert}"  <c:if test="${fn:substring(resultData.FLEX_ENDTM, 0, 2) eq nConvert}">selected</c:if>>${nConvert}</option>
									<c:set var="n" value="${n+1}" />
								</c:forEach>
							</select>
							<select id="end_minute" disabled>
								<option value="00"  <c:if test="${fn:substring(resultData.FLEX_ENDTM, 3, 5) eq '00'}">selected</c:if>>00</option>
								<option value="30"  <c:if test="${fn:substring(resultData.FLEX_ENDTM, 3, 5) eq '30'}">selected</c:if>>30</option>
							</select>
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><spring:message	code='LABEL.D.D20.0002' /><!--적용기간--></th>
						<td id="date_line">
							<%--[CSR ID:3525213] Flextime 시스템 변경 요청  FLEX_BEG,FLEX_END 를 FLEX_BEGDA,FLEX_ENDDA로 변경 start--%>
							<input type="text" id="FLEX_BEGDA"  name = "FLEX_BEGDA"  size="10" value="${f:printDate(resultData.FLEX_BEGDA)}"	readonly/>
							<span><spring:message	code='LABEL.D.D19.0024' /></span>
							<!--부터-->&nbsp;
    						<input type="text" id="FLEX_ENDDA"  name = "FLEX_ENDDA" size="10"	 value="${f:printDate(resultData.FLEX_ENDDA)}"  readonly />
							<span><spring:message code='LABEL.D.D19.0025' /></span>
							<!--까지-->
							<%--[CSR ID:3525213] Flextime 시스템 변경 요청  FLEX_BEG,FLEX_END 를 FLEX_BEGDA,FLEX_ENDDA로 변경 end--%>
						</td>
					</tr>
				</table>
			</div>
		</div>
        <div class="commentImportant" style="width:640px;">
            <p><strong><spring:message	code='LABEL.D.D20.0005'/><!--※ 신청시 주의사항--></strong></p>
            <p><spring:message	code='LABEL.D.D20.0015'/><!-- 1) 직속상위자 결재를 득해야 함 --></p>
            <p><spring:message	code='LABEL.D.D20.0016'/><!-- 2) 신청예외자 : 육아기 및 임신기단축근로를 사용중인 경우 Flextime제 미적용 --></p>
        </div>
        
        <input type="hidden" id="SCHKZ" name="SCHKZ"  value="${resultData.SCHKZ}">
        <input type="hidden" id="FLEX_BEGTM" name="FLEX_BEGTM"  value="${resultData.FLEX_BEGTM}">
		<input type="hidden" id="FLEX_ENDTM" name="FLEX_ENDTM"  value="${resultData.FLEX_ENDTM}">
    </tags-approval:detail-layout>
</tags:layout>



