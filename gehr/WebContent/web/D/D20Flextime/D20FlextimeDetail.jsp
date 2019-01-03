<%
	/******************************************************************************/
	/*   System Name  : ESS                                                         													*/
	/*   1Depth Name  : MY HR 정보                                                  															*/
	/*   2Depth Name  : 휴가/근태                                                        														*/
	/*   Program Name : Flextime(부분선택근무제) 상세                                                  														*/
	/*   Program ID   :	D20FlextimeBuild.jsp                                        													*/
	/*   Description  : Flextime(부분선택근무제) 상세 화면                                        																*/
	/*   Note         :                                                             															*/
	/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청                                       */
	/*   Update       : 2017-11-08  eunha    [CSR ID:3525213] Flextime 시스템 변경 요청								*/
	/*   Update       : 2018-05-09  성환희     [WorkTime52] 부분/완전선택 근무제 변경								*/
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
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>


<tags:layout css="ui_library_approval.css"  script="dialog.js" >

    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_FLEXTIME"
    	updateUrl="${g.servlet}hris.D.D20Flextime.D20FlextimeChangeSV"    	>

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
							<td ><input type="radio" name="SCHKZ" value="F070A220"
							${ resultData.SCHKZ==("F070A220") ? "checked" : "" } disabled> 07:00~16:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="SCHKZ" value="F080A220"
							${ resultData.SCHKZ==("F080A220") ? "checked" : "" } disabled> 08:00~17:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="SCHKZ" value="F090A220"
							${ resultData.SCHKZ==("F090A220") ? "checked" : "" } disabled> 09:00~18:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="SCHKZ" value="F100A220"
							${ resultData.SCHKZ==("F100A220") ? "checked" : "" } disabled> 10:00~19:00
						</td>
					</tr>

					<tr>
						<td ><input type="radio" name="SCHKZ" value="F073A220"
							${ resultData.SCHKZ==("F073A220") ? "checked" : "" } disabled> 07:30~16:30
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="SCHKZ" value="F083A220"
							${ resultData.SCHKZ==("F083A220") ? "checked" : "" } disabled> 08:30~17:30
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="SCHKZ" value="F093A220"
							${ resultData.SCHKZ==("F093A220") ? "checked" : "" } disabled> 09:30~18:30
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><spring:message	code='LABEL.D.D20.0002' /><!--적용기간--></th>
						<td >
							<%--[CSR ID:3525213] Flextime 시스템 변경 요청  FLEX_BEG,FLEX_END 를 FLEX_BEGDA,FLEX_ENDDA로 변경 start--%>
							<input type="text" id="FLEX_BEGDA"  name = "FLEX_BEGDA"  size="10" value="${f:printDate(resultData.FLEX_BEGDA)}"	readonly/>
							<spring:message	code='LABEL.D.D19.0024' />
							<!--부터-->&nbsp;
    						<input type="text" id="FLEX_ENDDA"  name = "FLEX_ENDDA" size="10"	 value="${f:printDate(resultData.FLEX_ENDDA)}"  readonly />
							<spring:message code='LABEL.D.D19.0025' />
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
    </tags-approval:detail-layout>
</tags:layout>



