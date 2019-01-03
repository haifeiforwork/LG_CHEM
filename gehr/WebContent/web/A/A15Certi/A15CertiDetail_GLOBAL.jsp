<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청 조회                                        */
/*   Program ID   : A15CertiDetail_KR.jsp                                          */
/*   Description  : 재직증명서 신청을 조회할 수 있도록 하는 화면                */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                  2008-05-08  lsa  [CSR ID:1263333] 제증명서 발급 Process 개선*/
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >

	<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
	<tags-approval:detail-layout titlePrefix="MSG.A.A15.TITLE"
								 updateUrl="${g.servlet}hris.A.A15Certi.A15CertiChangeSV">
		<div class="tableArea">
			<div class="table">
				<table class="tableGeneral tableApproval">
					<colgroup>
						<col width="15%">
						<col width="85%">
					</colgroup>
					<tr>
						<th><spring:message code="LABEL.A.A15.0001" /><!-- Internal Certificate Type --><!-- 구분 -->&nbsp;</th>
						<td>
							${f:printOptionValueText(certCode_vt, resultData.CERT_CODE)}
						</td>
					</tr>
					<tr>
						<th><spring:message code="LABEL.A.A15.0002" /><!-- Issue Count --><!-- 발행부수 = 发行分数-->&nbsp;</th>
						<td>${f:parseLong(resultData.ISSUE_CNT)}</td>

					</tr>
			<c:choose>
				<%-- 남경법인 --%>
				<c:when test="${isNanjing}">
					<tr>
						<th><spring:message code="LABEL.A.A15.0003" /><!-- Use -->&nbsp;</th>
						<td>
							${f:printOptionValueText(useCodeList, resultData.USECD)}${not empty resultData.USECD ? "&nbsp;" : "" }${resultData.USEFL}
						</td>
					</tr>
					<c:if test="${resultData.CERT_CODE == '05'}">
					<tr id="taxRow">
						<th><spring:message code="LABEL.A.A15.0004" /><!-- 월수입유형 --></th>
						<td>
							<input type="radio" name="INCTYP" value="1" ${resultData.INCTYP != '2' ? 'checked' : ''} disabled> <spring:message code="LABEL.A.A15.0005" /><!-- 税前月收入 -->
							<input type="radio" name="INCTYP" value="2" ${resultData.INCTYP == '2' ? 'checked' : ''} disabled> <spring:message code="LABEL.A.A15.0006" /><!-- 税后月收入 -->
						</td>
					</tr>
					</c:if>
				</c:when>
				<c:otherwise>
					<!-- 용도 -->
					<tr>
						<th><spring:message code="LABEL.A.A15.0019" /><!-- Use --><!-- 용도 -->&nbsp;</th>
						<td>${resultData.USEFL}</td>
					</tr>
				</c:otherwise>
			</c:choose>
				</table>
			</div>
		</div>
	</tags-approval:detail-layout>

</tags:layout>
