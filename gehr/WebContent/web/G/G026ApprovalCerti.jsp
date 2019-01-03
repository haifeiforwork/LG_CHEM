<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 제증명 결재                                                 */
/*   Program ID   : G026ApprovalCerti.jsp                                       */
/*   Description  : 제증명 결재                                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*   Update       : 2013-05-15  lsa   C20130513_30354   영문소속명길이추가,필드추가 */
/*                   :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<tags:layout css="ui_library_approval.css" script="dialog.js" >

	<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
	<tags-approval:detail-layout titlePrefix="TAB.COMMON.0013"
								 updateUrl="${g.servlet}hris.A.A15Certi.A15CertiChangeSV">
		<tags:script>
			<script language="JavaScript">
				<!--

				// 부서 검색
				function dept_search()
				{
					var frm = document.form1;
					alert(frm.txt_deptNm.value);
					if ( frm.txt_deptNm.value == "" ) {
						alert('<spring:message code="MSG.COMMON.SEARCH.DEPT.REQUIR" />'); //검색할 부서명을 입력하세요!
						frm.txt_deptNm.focus();
						return;
					}
					small_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=420,left=100,top=100");
					small_window.focus();

					var oldTarget = frm.target;
					var oldAction = frm.action;

					frm.target = "DeptNm";
					frm.action = "/web/common/SearchDeptNamePop.jsp";
					frm.submit();
					frm.target = oldTarget;
					frm.action = oldAction;

				}

				// 부서 검색후 선택
				function setDeptID(deptId, deptNm)
				{
					var frm = document.form1;
					frm.txt_deptNm.value = deptNm;
					frm.ORGEH.value = deptId;
					frm.ORGTX_E.value = deptNm
				};



				function beforeApproval() {
					var frm = document.form1;

					<c:if test="${resultData.LANG_TYPE == '1'}">
					frm.STELLTX.value = frm.STELL.options[frm.STELL.selectedIndex].text;
					</c:if>

					return true;
				}


				function setPRINT_NUM(gubun){
					if( gubun == "1" ) {
						document.form1.PRINT_NUM.disabled=1;
						document.form1.PRINT_NUM.value=1;

						//document.form1.USE_PLACE.value="";
						//document.form1.USE_PLACE.disabled=0;
					} else {
						document.form1.PRINT_NUM.disabled=0;

						//document.form1.USE_PLACE.value="보증용";
						//document.form1.USE_PLACE.disabled=1;
					}
				}

				//-->
			</script>
		</tags:script>

		<!-- 상단 입력 테이블 시작-->
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
						<th><span class="textPink">*</span><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 -->&nbsp;</th>
						<td>
							<c:choose>
								<c:when test="${resultData.LANG_TYPE == '1'}">
									<spring:message code="LABEL.A.A15.0027"/>
								</c:when>
								<c:otherwise>
									<spring:message code="LABEL.A.A15.0028"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th class="th02"><span class="textPink">*</span><spring:message code="LABEL.G.G26.0001" /><!-- 발행부수 --></th>
						<td>
							<select name="PRINT_NUM" ${resultData.PRINT_CHK == "1" ? "disabled" : "" }>
								<c:forEach begin="1" end="10" varStatus="status">
									<option value="${status.count}" ${f:parseLong(resultData.PRINT_NUM) == status.count ? 'selected' : ''}>${status.count}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0002" /><!-- 발행방법 --></th>
						<td colspan="3">
							<input type="radio" name="PRINT_CHK" value="1" ${resultData.PRINT_CHK != '2' ? 'checked' : ''}
								   onClick="javascript:setPRINT_NUM('1');f_LangChang();" ><spring:message code="LABEL.G.G26.0003" /><!-- 본인발행 -->
							<input type="radio" name="PRINT_CHK" value="2" ${resultData.PRINT_CHK == '2' ? 'checked' : ''}
								   onClick="javascript:setPRINT_NUM('2');"><spring:message code="LABEL.G.G26.0004" /><!-- 담당부서 요청발행 -->
						</td>
					</tr>
					<tr>
						<th><spring:message code="LABEL.G.G26.0005" /><!-- 주민등록번호 -->&nbsp;</th>
						<td>${f:printRegNo(resultData.REGNO, "LAST")}</td>
						<th class="th02"><span class="textPink">*</span><spring:message code="LABEL.G.G26.0006" /><!-- 입사일자 --></th>
						<td>
							<input type="text" name="ENTR_DATE" class="date required" size="10" maxlength="10" value="${f:printDate(resultData.ENTR_DATE)}"
								placeholder="<spring:message code="LABEL.G.G26.0006" />">
						</td>
					</tr>
					<tr>
              			<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              			<%--<th><spring:message code="LABEL.COMMON.0008" /><!-- 직위 --></th>--%>
              			<th><spring:message code='MSG.APPROVAL.0024'/><!-- 직책/직급호칭 --></th>
						<td>${resultData.TITEL eq '책임' and  resultData.TITL2 ne '' ? resultData.TITL2 : resultData.TITEL}</td>
						<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
						<th class="th02"><spring:message code="LABEL.G.G26.0007" /><!-- 직책출력 --></th>
						<td><input name="chTITEL_FLAG" type="checkbox" value="X"></td>
					</tr>
				<c:choose>
					<c:when test="${resultData.LANG_TYPE == '1'}">
						<tr>
							<th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0008" /><!-- 직무 --></th>
							<td>
								<select name="STELL" class="required" placeholder="<spring:message code="LABEL.G.G26.0008" />">
									<option value="">---------------------</option>
									${f:printCodeOption(vcStellCodeEntity, resultData.STELL)}
								</select>
								<input type="hidden" name="STELLTX" value="${resultData.STELLTX}">
							</td>
							<th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0009" /><!-- 소속부서 --></th>
							<td>

								<input name="txt_deptNm" type="text" size="20" class="required" placeholder="<spring:message code="LABEL.G.G26.0009" />"
									   value ="${resultData.ORGTX_E}" onChange="document.form1.ORGEH.value= '';document.form1.ORGTX_E.value= ''";>
								<a href="javascript:dept_search();">
									<img src="${g.image}sshr/ico_magnify.png" align="absmiddle" border="0">
								</a>
								<input type="hidden" name="authClsf" value="H">
								<input type="hidden" name="ORGEH" value="${resultData.ORGEH}" >
								<input type="hidden" name="ORGTX_E" value="${resultData.ORGTX_E}" >

							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0008" /><!-- 직무 --></th>
							<td>
								<input type="text" name="STELLTX" size="40" maxlength = "40" value = "${resultData.STELLTX}" class="required" placeholder="<spring:message code="LABEL.G.G26.0008" />">
								<input type="hidden" name="STELL"        value="${resultData.STELL}">
							</td>
							<th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0009" /><!-- 소속부서 --></th>
							<td>
								<input type="text" name="ORGTX_E" size="50" maxlength = "50" value = "${resultData.ORGTX_E}" class="required" placeholder="<spring:message code="LABEL.G.G26.0009" />">
								<input type="text" name="ORGTX_E2" size="50" maxlength = "50" value = "${resultData.ORGTX_E2}"><!--C20130513_30354-->
								<input type="hidden" name="authClsf" value="H">
								<input type="hidden" name="ORGEH" value="${resultData.ORGEH}">
							</td>
						</tr>
					</c:otherwise>
				</c:choose>

					<tr>
						<th><span class="textPink">*</span><spring:message code="TAB.COMMON.0091" /><!-- 현주소 --></th>
						<td colspan="3">
							<input type="text" name="ADDRESS1"  size="60" maxlength="60" value="${resultData.ADDRESS1}" class="vertical required" placeholder="<spring:message code="TAB.COMMON.0091" />"><br>
							<input type="text" name="ADDRESS2"  size="60" maxlength="60" value="${resultData.ADDRESS2}"><br>
							<span class="commentOne"><spring:message code="LABEL.G.G26.0010" /><!-- ※ 영문증명서를 신청하실 경우 현주소에 영문으로 입력해주세요. --></span>
						</td>
					</tr>
					<tr>
						<th><spring:message code="LABEL.G.G06.0013" /><!-- 전화번호 --></th>
						<td colspan="3">
							<input type="text" name="PHONE_NUM" size="20"   value="${resultData.PHONE_NUM}">
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0011" /><!-- 제출처 --> </th>
						<td colspan="3">
							<input type="text" name="SUBMIT_PLACE" size="60" value="${resultData.SUBMIT_PLACE}" class="required" placeholder="<spring:message code="LABEL.G.G26.0011" />">
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0012" /><!-- 용도 -->&nbsp;</th>
						<td colspan="3">
							<input type="text" name="USE_PLACE" size="60" value="${resultData.USE_PLACE}" class="required" placeholder="<spring:message code="LABEL.G.G26.0012" />">
						</td>
					</tr>
					<tr>
						<th><spring:message code="LABEL.G.G26.0013" /><!-- 특기사항 --></th>
						<td colspan="3">
							<textarea name="SPEC_ENTRY" wrap="VIRTUAL" cols="60" rows="3" readonly>${resultData.SPEC_ENTRY1}${resultData.SPEC_ENTRY2}${resultData.SPEC_ENTRY3}${resultData.SPEC_ENTRY4}${resultData.SPEC_ENTRY5}</textarea>
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><spring:message code="LABEL.G.G26.0014" /><!-- 사업장주소 -->&nbsp;</th>
						<td colspan="3">
							<select name="JUSO_CODE" class="required" placeholder="<spring:message code="LABEL.G.G26.0014" />">
								<option value="">---------------------</option>
								${f:printCodeOption(vcBizPlaceCodeEntity, resultData.JUSO_CODE)}
							</select>
						</td>
					</tr>

				</table>
			</div>
			<div class="commentsMoreThan2">
				<div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%><spring:message code="LABEL.G.G26.0015" /><!-- resultData --></div>
			</div>
		</div>
		<!-- 상단 입력 테이블 끝-->


	</tags-approval:detail-layout>

</tags:layout>

