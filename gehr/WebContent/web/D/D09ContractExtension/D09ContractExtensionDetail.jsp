<%/***************************************************************************************/              																				
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Application                                                  																	*/
/*   2Depth Name  	: Time Management                                                    														*/
/*   Program Name 	: Contract Extension                                               															*/
/*   Program ID   		: D09ContractExtensionDetail.jsp                                             										*/
/*   Description  		: Contract Extension 신청을 하는 화면 (USA)                       														*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-10-13 jungin @v1.0																								*/
/*	  Update				: 2011-02-08 jungin @v1.1 [C20110207_19781] 'Pay Type' 추가.												*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
    <li><a href="javascript:;" onclick="f_popQuotaPlan();" ><span>Quota Plan / Result Status</span></a></li>
</tags:body-container>


<tags:layout css="ui_library_approval.css" script="dialog.js" help="D09ContractExtensionUsa.html">

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.MSS_PA_CONT_EXTE" updateUrl="${g.servlet}hris.D.D09ContractExtension.D09ContractExtensionChangeSV" button="${buttonBody}">
        <tags:script>
            <script>
                // Quota Plan/Result Status
                function f_popQuotaPlan() {
                    window.open("${g.servlet}hris.F.F79QuotaPlanResultStatusSV","DeptPers","toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=1024,height=500,left=100,top=100");
                }
            </script>
        </tags:script>
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
                        <td>${T_CURRENT.STLTX}</td>
                        <th>Agency</th>
                        <td>${T_CURRENT.STEXT}</td>
                    </tr>
                    <tr>
                        <th>Application Type</th>
                        <td colspan="3">${f:printOptionValueText(applicationType, T_RESULT.APPL_TYPE)}</td>
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
                        <th>Contract Type</th>
                        <td>${T_CURRENT.CTTXT }</td>
                        <td>${f:printOptionValueText(contractType, T_RESULT.CTTYP)}</td>
                    </tr>
                    <tr>
                        <th>Contract Period</th>
                        <td>${f:printDate(T_CURRENT.CBEGDA)} ~ ${f:printDate(T_CURRENT.CTEDT)}</td>
                        <td>${f:printDate(T_RESULT.CBEGDA)} ~ ${f:printDate(T_RESULT.CTEDT)}</td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span>Bill Rate</th>
                        <td>
                            <input type="text" name="CR_BILRTE" size="15" value="${f:convertCurrency(T_CURRENT.BILRTE, "")}" readonly style="text-align:right;">&nbsp;&nbsp;&nbsp;
                            <input type="text" name="CR_BWAERS" size="3" value="${T_CURRENT.BWAERS}" readonly>
                        </td>
                        <td>
                            <input type="text" name="BILRTE" size="22"  class="align_right" value="${f:convertCurrency(T_RESULT.BILRTE, "")}" maxlength="18" readonly>&nbsp;&nbsp;&nbsp;
                            <input type="text" name="BWAERS" size="3" value="USD" readonly>
                        </td>
                    </tr>
                    <tr>
                        <th>OT Bill Rate</th>
                        <td>
                            <input type="text" name="CR_OTBRTE" size="15" value="${f:convertCurrency(T_CURRENT.OTBRTE, "")}" readonly class="money align_right">&nbsp;&nbsp;&nbsp;
                            <input type="text" name="CR_OWAERS" size="3" value="${T_CURRENT.OWAERS }" readonly>
                        </td>
                        <td><input type="text" id="OTBRTE" name="OTBRTE" size="22"  value="${f:convertCurrency(T_RESULT.OTBRTE, "")}" maxlength="18" class="align_right" readonly>&nbsp;&nbsp;&nbsp;
                            <input type="text" id="OWAERS" name="OWAERS" size="3" value="USD" readonly>
                        </td>
                    </tr>
                    <tr><!-- @v1.1 -->
                        <th>Pay Type</th>
                        <td>${T_CURRENT.PTTXT }</td>
                        <td>${f:printOptionValueText(payType, T_RESULT.PAYTYPE)}</td>
                    </tr>
                    <tr>
                        <th>Reason for Contract<br>Extension</th>
                        <td class="td09" colspan="3"><textarea name="TLINE" cols="99" rows="3" maxlength="200" readonly >${T_RESULT.TLINE}</textarea></td>
                    </tr>

                </table>
            </div>

        </div>
    </tags-approval:detail-layout>
</tags:layout>

