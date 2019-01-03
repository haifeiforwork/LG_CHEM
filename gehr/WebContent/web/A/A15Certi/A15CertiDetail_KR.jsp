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
/*					 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<c:set var="buttonBody" value="${g.bodyContainer}" />
<%--@elvariable id="resultData" type="hris.A.A15Certi.A15CertiData"--%>
<%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>

<%  // [CSR ID:1263333]
	/*
	if( ( a15CertiData.PRINT_CHK.equals("1") && user.empNo.equals(a15CertiData.PERNR) ) ||
			( a15CertiData.PRINT_CHK.equals("2") && (approvalStep == DocumentInfo.DUTY_CHARGER|| approvalStep == DocumentInfo.DUTY_MANGER )  ) ) {
*/

%>
<c:if test="${approvalHeader.finish }">
	<c:if test="${(resultData.PRINT_CHK == '1' and user.empNo == resultData.PERNR and resultData.PRINT_END != 'X') or
					(resultData.PRINT_CHK == '2' and approvalHeader.DMANFL == '01' or  approvalHeader.DMANFL == '02')}">
		<tags:script>
			<script>
				// [CSR ID:1263333]
				function go_print() {

					if( "${resultData.PRINT_CHK}" == "1" && document.form1.PRINT_END.value == "X" ) {
						alert('<spring:message code="MSG.A.A15.009" />'); //발행은 1회만 인쇄 가능합니다.
						return;
					}
					if( "${resultData.PRINT_CHK}" == "1" ){//본인
						msg ="<spring:message code='MSG.A.A15.009' /> <spring:message code='MSG.A.A15.010' />"; //발행은 1회만 인쇄 가능합니다. 인쇄 하시겠습니까?
					}else { //담당자
						msg ="<spring:message code='MSG.A.A15.010' />"; //인쇄 하시겠습니까?
					}

					if( confirm(msg) ) {
						window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=1,resizable=0,width=700,height=650,left=100,top=60");
						document.form1.jobid.value = "print_certi";
						document.form1.target      = "essPrintWindow";
						document.form1.action      = '${g.servlet}hris.A.A15Certi.A15CertiDetailSV';
						document.form1.method      = "post";
						document.form1.submit();

						document.form2.target = "ifHidden";
						document.form2.action = "${g.jsp}common/PrintCntUpdate.jsp";
						document.form2.submit();
					}
				}

				$(function() {
					init_alert();
				});

				//[CSR ID:3051222] 재직증명서 출력 관련
				function init_alert(){
					if( "${resultData.PRINT_CHK}" == "1" ){
						// alert("※ 인감날인 출력※\n\n파일→페이지 설정→배경색 및 이미지인쇄 체크 후 출력바랍니다.");
						//[CSR ID:3081498] 재직증명서 출력 관련
						alert("<spring:message code='MSG.A.A15.011' />"); //※ 인감날인 출력※\n\n[페이지 설정]→[배경색 및 이미지인쇄] 체크 후 출력바랍니다.\n아래 두 가지 방법 중 하나로 설정할 수 있습니다.\n\n① 도구(Alt+x)→인쇄→페이지 설정\n② 화면 상단 마우스 우클릭→메뉴 모음 활성화→파일→페이지 설정
					}
				}
			</script>
		</tags:script>
		<tags:body-container bodyContainer="${buttonBody}">
			<li><a href="javascript:go_print();"><span><spring:message code="LABEL.COMMON.0001" /><!-- 인쇄하기 --></span></a></li>
		</tags:body-container>
	</c:if>
</c:if>

<tags:layout css="ui_library_approval.css" script="dialog.js" >

	<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
	<tags-approval:detail-layout titlePrefix="MSG.A.A15.TITLE" button="${buttonBody}"
								 updateUrl="${g.servlet}hris.A.A15Certi.A15CertiChangeSV">

		<div class="tableArea">
			<div class="table">
				<table class="tableGeneral tableApproval">
					<colgroup>
						<col width="15%">
						<col width="35%">
						<col width="15%">
						<col width="35%">
					</colgroup>
					<tr>
						<th><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></th>
						<td colspan="3">
							<c:choose>
								<c:when test="${resultData.LANG_TYPE == '1'}">
									<spring:message code="LABEL.A.A15.0027"/>
								</c:when>
								<c:otherwise>
									<spring:message code="LABEL.A.A15.0028"/>
								</c:otherwise>
							</c:choose>
							<input type="hidden" name="PRINT_END"   value="${resultData.PRINT_END}">
						</td>
					</tr>
					<tr>
						<th><spring:message code="LABEL.A.A15.0012" /><!-- 발행부수 --></th>
						<td colspan="3">${f:parseLong(resultData.PRINT_NUM)}</td>
					</tr>
					<tr>
						<th><spring:message code="LABEL.A.A15.0014" /><!-- 발행방법 --></th>
						<td colspan="3">
							<input type="radio" name="PRINT_CHK" value="1" ${resultData.PRINT_CHK == "1" ? "checked" : "" } disabled>본인발행
							<input type="radio" name="PRINT_CHK" value="2" ${resultData.PRINT_CHK == "2" ? "checked" : "" } disabled>담당부서 요청발행
						</td>
					</tr>
					<c:if test="${approvalHeader.MODFL != 'X'}">
					<tr>
						<th><spring:message code="LABEL.A.A12.0003" /><!-- 주민등록번호 --></th>
						<td>${f:printRegNo(resultData.REGNO, "LAST")}</td>
						<th class="th02"><spring:message code="LABEL.A.A15.0023" /><!-- 입사일자 --></th>
						<td>${f:printDate(resultData.ENTR_DATE)}</td>
					</tr>

					<tr>

						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
						<%--<th><spring:message code="LABEL.COMMON.0008" /><!-- 직위 --></th> --%>
						<th><spring:message code="MSG.APPROVAL.0024" /><!-- 직책/직급호칭 --></th>
						<td>${resultData.TITEL eq '책임' and  resultData.TITL2 ne '' ? resultData.TITL2 : resultData.TITEL}</td>
						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
						<th class="th02"><spring:message code="LABEL.A.A15.0024" /><!-- 직책출력 --></th>
						<td><input type="checkbox" ${resultData.TITEL_FLAG == 'X' ? 'checked' : ''} disabled></td>
					</tr>

					<tr>
						<th><spring:message code="MSG.A.A01.0013" /><!-- 직무 --></th>
						<td> ${resultData.STELLTX} </td>
						<th class="th02"><spring:message code="LABEL.A.A15.0025" /><!-- 소속부서 --></th>
						<td>${resultData.ORGTX_E} ${resultData.LANG_TYPE == "1" ? "" : resultData.ORGTX_E2}</td>
					</tr>
					<%--<c:choose>
						<c:when test="${resultData.LANG_TYPE == '1'}">
							<tr>
								<th>직무<font color="#006699">&nbsp;</font></th>
								<td> ${resultData.STELLTX} </td>
								<th class="th02">소속부서</th>
								<td> ${resultData.ORGTX_E}</td>
							</tr>
						</c:when>
						<c:otherwise>
							<tr>
								<th>직무</th>
								<td colspan="3"> ${resultData.STELLTX} </td>
							</tr>
							<tr>
								<th>소속부서</th>
								<td colspan=3> ${resultData.ORGTX_E} ${resultData.ORGTX_E2}</td>
							</tr>
						</c:otherwise>
					</c:choose>--%>
					</c:if>

					<tr>
						<th><spring:message code="MSG.A.A01.0043" /><!-- 현주소 --></th>
						<td colspan="3">
							${resultData.ADDRESS1}<br>
							${resultData.ADDRESS2}
						</td>
					</tr>

					<c:if test="${approvalHeader.MODFL != 'X'}">
					<tr>
						<th><spring:message code="MSG.A.A13.014" /><!-- 전화번호 --></th>
						<td colspan="3">${resultData.PHONE_NUM}</td>
					</tr>
					</c:if>

					<tr>
						<th><spring:message code="LABEL.A.A15.0018" /><!-- 제출처 --></th>
						<td colspan="3"> ${resultData.SUBMIT_PLACE}</td>
					</tr>
					<tr>
						<th><spring:message code="LABEL.A.A15.0019" /><!-- 용도 --></th>
						<td colspan="3"> ${resultData.USE_PLACE}</td>
					</tr>
					<tr>
						<th><spring:message code="LABEL.A.A15.0020" /><!-- 특기사항 --></th>
						<td colspan="3">
							${resultData.SPEC_ENTRY1} <br>
							${resultData.SPEC_ENTRY2} <br>
							${resultData.SPEC_ENTRY3} <br>
							${resultData.SPEC_ENTRY4} <br>
							${resultData.SPEC_ENTRY5}
						</td>
					</tr>

					<c:if test="${approvalHeader.MODFL != 'X'}">
					<tr>
						<th><spring:message code="LABEL.A.A15.0026" /><!-- 사업장주소 --></th>
						<td colspan="3">${f:printOptionValueText(vcBizPlaceCodeEntity, resultData.JUSO_CODE)}</td>
					</tr>
					</c:if>

				</table>
			</div>
		</div>
	</tags-approval:detail-layout>

	<iframe id="ifHidden" name="ifHidden" width="0" height="0" style="top:-99999px;" frameborder="0"></iframe>
	<form id="form2" name="form2" method="post" action="">
		<input type="hidden" name="PERNR"     value="${resultData.PERNR}">
		<input type="hidden" name="AINF_SEQN" value="${resultData.AINF_SEQN}">
		<input type="hidden" name="MENU" value="CERTI">
	</form>

</tags:layout>
