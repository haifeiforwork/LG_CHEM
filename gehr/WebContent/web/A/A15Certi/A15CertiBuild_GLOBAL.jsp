<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청                                             */
/*   Program ID   : A15CertiBuild_KR.jsp                                           */
/*   Description  : 재직증명서를 신청할 수 있도록 하는 화면                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*                  2008-05-08  lsa  [CSR ID:1263333] 제증명서 발급 Process 개선*/
/*                  2015-08-07  이지은  [CSR ID:2844968] 제증명 부수 선택 오류*/
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>


<tags:layout css="ui_library_approval.css" >

    <tags-approval:request-layout titlePrefix="TAB.COMMON.0016">
        <%--@elvariable id="resultData" type="hris.A.A15Certi.A15CertiData"--%>
        <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>

        <!-- 상단 입력 테이블 시작-->
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral tableApproval">
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <!-- 구분 -->
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0001" /><!-- Internal Certificate Type -->&nbsp;</th>
                        <td>
                            <select id="CERT_CODE" name="CERT_CODE" class="required" placeholder="<spring:message code="LABEL.A.A15.0001" />">
                                <option value=""><spring:message code="MSG.A.A03.0020" /><%--Select--%></option>
                                ${f:printCodeOption(certCode_vt, resultData.CERT_CODE)}
                            </select>
                            <input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" >
                        </td>
                    </tr>

                    <!-- 발행부수-->
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0002" /><%--Issue Count--%>&nbsp;</th>
                        <td>
                            <select name="ISSUE_CNT" class="required" placeholder="<spring:message code="LABEL.A.A15.0002" />" ><%--ISSUE_CNT--%>
                            <c:forEach begin="1" end="5" varStatus="status">
                                <option value="${status.count}" ${f:parseLong(resultData.ISSUE_CNT) == status.count ? 'selected' : ''}>${status.count}</option>
                            </c:forEach>
                            </select>
                        </td>
                    </tr>

                <c:choose>
                    <%-- 남경법인 --%>
                    <c:when test="${isNanjing}">
                        <tags:script>
                            <script>
                                $(function() {
                                    $("#CERT_CODE").change(function() {
                                        var $this = $(this);

                                        if($this.val() == "05") $("#taxRow").show();
                                        else $("#taxRow").hide();

                                        var _$USECD = $("#USECD");
                                        ajaxPost("${g.servlet}hris.A.A15Certi.A15CertiUserCodeAjaxSV", {CERT_CODE : $this.val(), PERNR : $("#PERNR").val()}, function(data) {

                                            if(data.resultList.length > 0) {
                                                _$USECD.show();
                                                _$USECD.empty().append("<option value=''>Select</option>");

                                                _.each(data.resultList, function (row) {
                                                    $("<option/>").val(row.code).text(row.value)
                                                            .appendTo(_$USECD);
                                                });

                                                $("#USEFL").hide().removeClass("required");
                                            } else {
                                                _$USECD.hide();
                                                $("#USEFL").show().addClass("required");
                                            }
                                        });
                                    });

                                    $("#USECD").change(function() {
                                        if($(this).val() == "99") {
                                            $("#USEFL").show().addClass("required");
                                        } else {
                                            $("#USEFL").hide().removeClass("required");
                                        }
                                    });

                                });

                            </script>
                        </tags:script>
                        <tr>
                            <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0003" /><%--Use--%>&nbsp;</th>
                            <td>
                                <select id="USECD" name="USECD"
                                    ${fn:length(useCodeList) > 0 ? "class='required'" : "style='display:none;'"}
                                     placeholder="<spring:message code="LABEL.A.A15.0003" />">
                                    <option value=""><spring:message code="MSG.A.A03.0020" /><%--Select--%></option>
                                    ${f:printCodeOption(useCodeList, resultData.USECD)}
                                </select>
                                <input type="text" id="USEFL" name="USEFL" size="60" maxlength = "100" value="${resultData.USEFL}"
                                    ${resultData.USECD == "99" or fn:length(useCodeList) == 0 ? "class='required'" : "style='display:none;'"}
                                       placeholder="<spring:message code="LABEL.A.A15.0003" />" >
                            </td>
                        </tr>
                        <tr id="taxRow" style="display: ${resultData.CERT_CODE == '05' ? 'block' : 'none'};">
                            <th><spring:message code="LABEL.A.A15.0004" /><!-- 월수입유형 --></th>
                            <td>
                                <input type="radio" name="INCTYP" value="1" ${resultData.INCTYP != '2' ? 'checked' : ''}> <spring:message code="LABEL.A.A15.0005" /><!-- 税前月收入 -->
                                <input type="radio" name="INCTYP" value="2" ${resultData.INCTYP == '2' ? 'checked' : ''}> <spring:message code="LABEL.A.A15.0006" /><!-- 税后月收入 -->
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <%--용도--%>
                        <tr>
                            <th><span class="textPink">*</span><spring:message code="LABEL.A.A15.0003" /><%--Use--%>&nbsp;</th>
                            <td>
                                <input type="text" id="USEFL" name="USEFL" size="60" maxlength = "100" value="${resultData.USEFL}" class="required" placeholder="<spring:message code="LABEL.A.A15.0003" />" >
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>

                </table>
            </div>
            <div class="commentsMoreThan2">
                <div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
            </div>
        </div>
        <!-- 상단 입력 테이블 끝-->

    </tags-approval:request-layout>


</tags:layout>

