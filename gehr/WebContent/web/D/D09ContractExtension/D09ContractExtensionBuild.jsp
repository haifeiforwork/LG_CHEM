<%/***************************************************************************************/                               																				
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Application                                                  																	*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Contract Extension                                               															*/
/*   Program ID   		: D09ContractExtensionBuild.jsp                                             										*/
/*   Description  		: Contract Extension 신청을 하는 화면 (USA)                       														*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-10-13 jungin @v1.0																								*/
/*	  Update				: 2011-02-08 jungin @v1.1 [C20110207_19781] 'Pay Type' 추가.												*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>

<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
    <li><a href="javascript:;" onclick="f_popQuotaPlan();" ><span>Quota Plan / Result Status</span></a></li>
</tags:body-container>

<c:set var="requestDisable" value="${empty T_CURRENT}" />
<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css" help="D09ContractExtensionUsa.html">

    <tags-approval:request-layout titlePrefix="COMMON.MENU.MSS_PA_CONT_EXTE" disable="${requestDisable}" enableChangeApprovalLine="true" button="${buttonBody}">
        <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
        <%--@elvariable id="T_CURRENT" type="hris.D.D09ContractExtension.D09ExtensionData"--%>
        <%--@elvariable id="T_RESULT" type="hris.D.D09ContractExtension.D09ExtensionData"--%>

        <tags:script>
            <script>
                function beforeSubmit() {
                    /*frm.PERNR.value = frm.I_DEPT.value;	// 계약이 연장되는 실제 사번*/

                    return true;
                }

                function typeChange() {	// Contract Extension Check
                    var frm = document.form1;

                    var sDate = $("#CBEGDA").stripVal();
                    var eDate = $("#CTEDT").stripVal();

                    /*if (sDate != "" && eDate != "") {
                        if (sDate > eDate) {
                            alert("End date precedes start date.");
                            frm.CTEDT.focus();
                            return;
                        }
                    }*/

                    if(_.isEmpty(sDate) || _.isEmpty(eDate) || _.isEmpty($("#CTTYP").val())) return;

                    ajaxPost("${g.servlet}hris.D.D09ContractExtension.D09ContractExtensionAjax", "form1", function(data) {
                        if(!data.resultData.success) {
                            alert(data.resultData.message);
                            frm.CBEGDA.value = "";
                            frm.CTEDT.value = "";
                            frm.CBEGDA.focus();
                            return;
                        }
                    });

                }

                // Quota Plan/Result Status
                function f_popQuotaPlan() {
                    window.open("${g.servlet}hris.F.F79QuotaPlanResultStatusSV","DeptPers","toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=1024,height=500,left=100,top=100");
                }

                function changeApproval() {
                    changeApprovalLine({I_AWART : $("#APPL_TYPE").val()});
                }
                //-->
            </script>
        </tags:script>


        <c:choose>
            <c:when test="${requestDisable}">
                <div class="tableArea">
                    <div class="table">
                        <table class="tableGeneral tableApproval">
                            <tr>
                                <td class="td04">
                                <spring:message code="MSG.APPROVAL.REQUESt.NODATA"/>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
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
                                <th>Job Title</th>
                                <td>
                                    ${T_CURRENT.STLTX}
                                    <input type="hidden" name="STELL" value="${T_CURRENT.STELL}">
                                    <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
                                    <input type="hidden" id="UPMU_TYPE" name="UPMU_TYPE" value="${approvalHeader.UPMU_TYPE}"/>
                                </td>

                                <th class="th02">Agency</th>
                                <td>
                                        ${T_CURRENT.STEXT}
                                    <input type="hidden" name="OBJID" value="${T_CURRENT.OBJID}">
                                </td>
                            </tr>
                            <tr>
                                <th><span class="textPink">*</span>Application Type</th>
                                <td colspan="3">
                                    <select id="APPL_TYPE" name="APPL_TYPE" onchange="changeApproval()" class="required" placeholder="Application Type">
                                        <option value="">Select</option>
                                            ${f:printCodeOption(applicationType, T_RESULT.APPL_TYPE)}
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="tableArea">
                    <div class="table">
                        <table class="tableGeneral tableApproval">
                            <colgroup>
                                <col width="15%">
                                <col width="40%">
                                <col width="45%">
                            </colgroup>
                            <tr>
                                <th></th>
                                <th class="align_center">Current</th>
                                <th class="align_center">Extension</th>
                            </tr>
                            <tr>
                                <th><span class="textPink">*</span>Contract Type</th>
                                <td>${T_CURRENT.CTTXT }</td>
                                <td>
                                    <select id="CTTYP" name="CTTYP"  onchange="typeChange();" class="required" placeholder="Contract Type">
                                        <option value="">Select</option>
                                            ${f:printCodeOption(contractType, T_RESULT.CTTYP)}
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th><span class="textPink">*</span>Contract Period</th>
                                <td>${f:printDate(T_CURRENT.CBEGDA)} ~ ${f:printDate(T_CURRENT.CTEDT)}</td>
                                <td>
                                        <%-- 날짜 선택 후 typeChange 호출--%>
                                    <input type="text" id="CBEGDA" name="CBEGDA" value="${f:printDate(T_RESULT.CBEGDA)}" class="date fromDate required" data-to-date="CTEDT"
                                           onchange="typeChange();" placeholder="Contract Period">
                                    ~
                                    <input type="text" id="CTEDT" name="CTEDT" value="${f:printDate(T_RESULT.CBEGDA)}" class="date toDate required" data-from-date="CBEGDA"
                                           onchange="typeChange();" placeholder="Contract Period">
                                </td>
                            </tr>
                            <tr>
                                <th><span class="textPink">*</span>Bill Rate</th>
                                <td>
                                    <input type="text" name="CR_BILRTE" size="15" value="${f:convertCurrency(T_CURRENT.BILRTE, "")}" readonly style="text-align:right;">&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CR_BWAERS" size="3" value="${T_CURRENT.BWAERS}" readonly>
                                </td>
                                <td>
                                    <input type="text" name="BILRTE" size="22"  class="money required align_right" value="${T_RESULT.BILRTE}" maxlength="18" placeholder="Bill Rate">&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="BWAERS" size="3" value="USD" readonly>
                                </td>
                            </tr>
                            <tr>
                                <th>OT Bill Rate</th>
                                <td>
                                    <input type="text" name="CR_OTBRTE" size="15" value="${f:convertCurrency(T_CURRENT.OTBRTE, "")}" readonly class="money align_right">&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CR_OWAERS" size="3" value="${T_CURRENT.OWAERS }" readonly>
                                </td>
                                <td><input type="text" id="OTBRTE" name="OTBRTE" size="22"  value="${T_RESULT.OTBRTE}" maxlength="18" class="money align_right" placeholder="OT Bill Rate">&nbsp;&nbsp;&nbsp;
                                    <input type="text" id="OWAERS" name="OWAERS" size="3" value="USD" readonly>
                                </td>
                            </tr>
                            <tr><!-- @v1.1 -->
                                <th>Pay Type</th>
                                <td>${T_CURRENT.PTTXT }</td>
                                <td>
                                    <select name="PAYTYPE" >
                                        <option value="">Select</option>
                                            ${f:printCodeOption(payType, T_RESULT.PAYTYPE)}
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>Reason for Contract<br>Extension</th>
                                <td class="td09" colspan="3"><textarea name="TLINE" cols="99" rows="3" maxlength="200" >${T_RESULT.TLINE}</textarea></td>
                            </tr>

                        </table>
                    </div>

                </div>
            </c:otherwise>
        </c:choose>


    </tags-approval:request-layout>
</tags:layout>


