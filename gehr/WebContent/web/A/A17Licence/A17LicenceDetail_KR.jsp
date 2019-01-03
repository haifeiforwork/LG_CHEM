<%@ page import="hris.common.rfc.CurrencyCodeRFC" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 자격면허상세                                                */
/*   Program ID   : A17LicenceDetail_GLOBAL.jsp                                        */
/*   Description  : 자격증면허 상세내용 화면                                    */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-02-23  유용원                                          */
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
    <tags-approval:detail-layout titlePrefix="MSG.A.A17.001" updateUrl="${g.servlet}hris.A.A17Licence.A17LicenceChangeSV">
        <%-- 결재 승인 및 반려시 의견 입력시 화면에 정보성으로 보여줄 내용
        <tags:script>
            <script>
                $(function() {
                    /* 승인 부 */
                    $("#-accept-dialog").dialog({
                        open : function() {
                            $("#-accept-info").text("결재 승인 창 상단에 보여줄 텍스트 입력하세요.");
                        }
                    });
                    /* 반려 부 */
                    $("#-reject-dialog").dialog({
                        open : function() {
                            $("#-reject-info").text("결재 승인 창 상단에 보여줄 텍스트 입력하세요.");
                        }
                    });
                });
            </script>
        </tags:script>
        --%>
        <%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral tableApproval">
                <colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
                    <tr>
                        <th ><span class="textPink">*</span><spring:message code="MSG.A.A17.003"/><%--자격증--%></th>
                        <td>${resultData.LICN_NAME}</td>
                        <th ><span class="textPink">*</span><spring:message code="MSG.A.A17.004"/><%--취득일--%></th>
                        <td>${f:printDate(resultData.OBN_DATE)}</td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.005"/><%--발행처--%></th>
                        <td>${resultData.PUBL_ORGH}</td>
                        <th ><span class="textPink">*</span><spring:message code="MSG.A.A17.006"/><%--자격등급--%></th>
                        <td>${resultData.GRAD_NAME}</td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A17.007"/><%--자격증번호--%></th>
                        <td colspan="3">${resultData.LICN_NUMB}</td>

                    </tr>
                </table>
            </div>
            <!-- 상단 입력 테이블 끝-->
        </div>

        <%-- 결재자이거나 결재가 진행된 상태 일 경우 보여준다  --%>
        <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
        <c:if test="${approvalHeader.showManagerArea}">
        <h2 class="subtitle"><spring:message code="MSG.APPROVAL.0021"/><%--담당자입력정보--%></h2>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral tableApproval">
                <colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>

                <c:choose>
                    <%-- 최초 결재자 여부 --%>
                    <c:when test="${approvalHeader.editManagerArea}">
                        <tags:script>
                            <script>
                                // 부서 검색
                                function dept_search() {
                                    var frm = document.form1;
                                    if ( frm.txt_deptNm.value == "" ) {
                                        alert("<spring:message code="MSG.COMMON.SEARCH.DEPT.REQUIR"/>");/*검색할 부서명을 입력하세요!*/
                                        frm.txt_deptNm.focus();
                                        return;
                                    }

                                   /* var small_window=window.open("/web/common/SearchDeptNamePop.jsp?authClsf=S&txt_deptNm=" + $("#txt_deptNm").val(), "DeptNm",
                                            "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=420,left=100,top=100");
                                    small_window.focus();*/
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
                                function setDeptID(deptId, deptNm) {
                                    var frm = document.form1;
                                    frm.txt_deptNm.value = deptNm;
                                    frm.ORGEH.value = deptId;
                                }

                                function beforeAccept() {
                                    var frm = document.form1;

                                    if(frm.ORGEH.value == "") {
                                    	 alert("<spring:message code="MSG.A.A17.025"/>");  /*관리 부서를 입력하세요*/
                                        frm.txt_deptNm.value = "";
                                        frm.txt_deptNm.focus();
                                        return;
                                    }

                                    if(frm.GIVE_RATE1.value == "d") {
                                        alert("<spring:message code="MSG.A.A17.009"/>");    /*지급율을  선택하세요*/
                                        frm.GIVE_RATE1.focus();
                                        return false;
                                    } // end if

                                    if(frm.LICN_AMNT.value == "" && frm.GIVE_RATE1.value != "") {
                                        alert("<spring:message code="MSG.A.A17.010"/>");/*자격수당을 입력하세요*/
                                        frm.LICN_AMNT.focus();
                                        return false
                                    } // end if

                                    return true;
                                }

                                <%-- 반려시 이전 행위 필요시 작성
                                function beforeReject() {
                                    return true;
                                }
                                --%>

                                function changeToZero(obj) {
                                    var val = obj[obj.selectedIndex].value;
                                    var frm = document.form1;
                                    if(val==""){
                                        frm.LICN_AMNT.value = "0";
                                        frm.LICN_AMNT.disabled = true;
                                    } else {
                                        frm.LICN_AMNT.value = "";
                                        frm.LICN_AMNT.disabled = false;
                                    }
                                }
                            </script>
                        </tags:script>
                    <tr>
                        <th><spring:message code="MSG.A.A17.011"/><%--자격관리부서--%></th>
                        <td>
                            <input id="txt_deptNm" name="txt_deptNm" type="text" size="20" onChange="document.form1.ORGEH.value= '';">
                            <input type="hidden" name="authClsf" value="S">
                            <input type="hidden" name="ORGEH" class="required" placeholder="<spring:message code="MSG.A.A17.011"/>">
                            <a href="javascript:dept_search();"><img src="${g.image}sshr/ico_magnify.png" align="absmiddle" border="0" alt="부서찾기"></a>
                        </td>
                        <th ><spring:message code="MSG.A.A17.012"/><%--증빙접수일--%></th>
                        <td>
                            <input type="text" name="CERT_DATE" class="date required" size="10" maxlength="10" placeholder="<spring:message code="MSG.A.A17.012"/>">
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="MSG.A.A17.013"/><%--지급율--%></th>
                        <td>
                            <select id="GIVE_RATE1" name="GIVE_RATE1" onChange="javascript:changeToZero(this);">
                                <option value = "d">------</option>
                                <option value = "50">50</option>
                                <option value = "100">100</option>
                                <option value = ""><spring:message code="MSG.A.A17.014"/><%--이력입력용--%></option>
                            </select>
                        </td>
                        <th ><spring:message code="MSG.A.A17.015"/><%--적용일자--%></th>
                        <td>
                            <input type="text" name="PAY_DATE" class="date required" size="10" maxlength="10" placeholder="<spring:message code="MSG.A.A17.015"/>">
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="MSG.A.A17.016"/><%--자격수당--%></th>
                        <td>
                            <%-- 확인 후 변경 --%>
                            <input name="LICN_AMNT" type="text" <%--class="money" placeholder="자격수당"--%> onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS');" style="text-align:right" size="20" >
                            <select name="WAERS">
                                <c:set var="currencyList" value="<%=(new CurrencyCodeRFC()).getCurrencyCode() %>" />
                                <option>------</option>
                                ${f:printCodeOption(currencyList, "KRW")}
                            </select>
                        </td>
                        <td colspan="2">&nbsp;</td>
                            </tr>
                    </c:when>
                    <c:otherwise>
                            <tr>
                                <th><spring:message code="MSG.A.A17.011"/><%--자격관리부서--%></th>
                                <td>${resultData.ORGTX}</td>
                                <th><spring:message code="MSG.A.A17.012"/><%--증빙접수일--%></th>
                                <td>${f:printDate(resultData.CERT_DATE)}</td>
                            </tr>
                            <tr>
                                <th><spring:message code="MSG.A.A17.013"/><%--지급율--%></th>
                                <td> ${empty resultData.GIVE_RATE1 ? "이력입력용": resultData.GIVE_RATE1}</td>
                                <th><spring:message code="MSG.A.A17.015"/><%--적용일자--%></th>
                                <td>${f:printDate(resultData.PAY_DATE)}</td>
                            </tr>
                            <tr>
                                <th><spring:message code="MSG.A.A17.016"/><%--자격수당--%></th>
                                <td colspan="3">
                                        ${f:convertCurrency(f:changeLocalAmount(resultData.LICN_AMNT, resultData.WAERS), 0)} ${resultData.WAERS}
                                </td>
                            </tr>
                    </c:otherwise>

                </c:choose>

                </table>
            </div>
        </div>
        </c:if>


    </tags-approval:detail-layout>
</tags:layout>