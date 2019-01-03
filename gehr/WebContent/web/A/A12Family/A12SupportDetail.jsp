<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 부양가족여부 신청                                           */
/*   Program ID   : A12SupportDetail.jsp                                        */
/*   Description  : 부양가족여부 신청                                           */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-03-03  윤정현                                          */
/*                  2008-04-21  lsa @v1.0 [CSR ID:1254077]대리신청시 정보조회안되게수정*/
/*                  2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
    <c:if test="${resultData.DPTID == 'X' and approvalHeader.MODFL == 'X'}">
        <li><a href="javascript:;" onclick="go_print();" ><span><spring:message code="LABEL.A.A12.0047" /><!-- 부양가족 신청서 --></span></a></li>
    </c:if>
</tags:body-container>
<%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
<%--@elvariable id="familyData" type="hris.A.A12Family.A12FamilyListData"--%>
<%--@elvariable id="resultData" type="hris.A.A12Family.A12FamilyBuyangData"--%>

<tags:layout css="ui_library_approval.css" script="dialog.js" >
    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="LABEL.A.A12.0027" updateUrl="${g.servlet}hris.A.A12Family.A12SupportChangeSV" button="${buttonBody}">
        <tags:script>
            <script>
                $(function() {
                    <c:if test="${param.afterRequest == 'true'}">
                    go_print();
                    </c:if>
                });

                function go_print(){
                    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=740,height=450,left=100,top=60");
                    document.form1.jobid.value = "print_hospital";
                    document.form1.target = "essPrintWindow";
                    document.form1.action = "${g.servlet}hris.A.A12Family.A12SupportDetailSV";
                    document.form1.method = "post";
                    document.form1.submit();
                }
            </script>
        </tags:script>
        <h2 class="subtitle"><spring:message code="LABEL.A.A12.0012" /><%--대상자--%></h2>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral tableApproval">
                    <tr>
                        <th><spring:message code="LABEL.A.A12.0001" /><%--성명(한글)--%></th>
                        <td>
                            <input type="text" name="name" value="${familyData.LNMHG } ${familyData.FNMHG }" readonly>
                        </td>
                        <th><spring:message code="LABEL.A.A12.0002" /><%--가족유형--%></th>
                        <td>
                            <input type="text" name="STEXT"  value="${familyData.STEXT }" size="20" readonly>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.A.A12.0003" /><%--주민등록번호--%></th>
                        <td>
                            <input type="text" name="regno"  value="${f:printRegNo(familyData.REGNO, user.empNo != approvalHeader.PERNR and approvalHeader.DMANFL == ''? "FULL" : "")}" size="20" readonly>
                        </td>
                        <th><spring:message code="LABEL.A.A12.0004" /><%--관계--%></th>
                        <td> <input type="text" name="atext"  value="${familyData.ATEXT }" size="20" readonly>
                        </td>
                    </tr>
                    <%-- 기존 로직 본인이거나 결재자이거나 결재가 완료되면 모두 조회 가능 --%>
                    <c:if test="${user.empNo == approvalHeader.PERNR or approvalHeader.ACCPFL == 'X' or approvalHeader.AFSTAT == '03' or approvalHeader.AFSTAT == '04'}" >
                        <tr>
                            <th><spring:message code="LABEL.A.A12.0005" /><%--생년월일--%></th>
                            <td>
                                <input type="text" name="year"  value="${fn:substring(familyData.FGBDT, 0, 4)}" size="4" readonly>
                                년
                                <input type="text" name="month" value="${fn:substring(familyData.FGBDT, 5, 7)}" size="2" readonly>
                                월
                                <input type="text" name="day"   value="${fn:substring(familyData.FGBDT, 8, 10)}" size="2" readonly>
                                일 </td>
                            <th><spring:message code="LABEL.A.A12.0006" /><%--성별--%></th>
                            <td>
                                <input type="radio" name="fasex" value="1" ${familyData.FASEX == "1" ? "checked" : "" } disabled> <spring:message code="LABEL.A.A12.0019" /><%--남--%>
                                <input type="radio" name="fasex" value="2" ${familyData.FASEX == "2" ? "checked" : "" } disabled> <spring:message code="LABEL.A.A12.0020" /><%--여--%>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="LABEL.A.A12.0007" /><%--출생지--%></th>
                            <td> <input type="text" name="fgbot" value="${familyData.FGBOT }" size="20" readonly>
                            </td>
                            <th><spring:message code="LABEL.A.A12.0013" /><%--학력--%></th>
                            <td> <input type="text" name="stext1"  value="${familyData.STEXT1 }" size="20" readonly>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="LABEL.A.A12.0008" /><%--출생국--%></th>
                            <td> <input type="text" name="landx"  value="${familyData.LANDX }" size="20" readonly>
                            </td>
                            <th><spring:message code="LABEL.A.A12.0014" /><%--교육기관--%></th>
                            <td> <input type="text" name="fasin"  value="${familyData.FASIN }" size="20" readonly>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="LABEL.A.A12.0009" /><%--국적--%></th>
                            <td> <input type="text" name="natio"  value="${familyData.NATIO }" size="20" readonly>
                            </td>
                            <th><spring:message code="LABEL.A.A12.0010" /><%--직업--%></th>
                            <td> <input type="text" name="FAJOB"  value="${familyData.FAJOB }" size="20" readonly>
                            </td>
                        </tr>
                    </c:if>
                </table>
            </div>
        </div>

        <h2 class="subtitle"><spring:message code="LABEL.A.A12.0040" /><%--종속성--%></h2>
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                    <tr>
                        <th width="100"><spring:message code="LABEL.A.A12.0026" /><%--세금--%></th>
                        <td width="280">
                            <input type="checkbox" id="DPTID" name="DPTID" value="X" ${resultData.DPTID == "X" ? "checked" : ""} disabled> <spring:message code="LABEL.A.A12.0027" /><%--부양가족--%>
                            <input type="checkbox" id="BALID" name="BALID" value="X" ${resultData.BALID == "X" ? "checked" : ""} disabled> <spring:message code="LABEL.A.A12.0028" /><%--수급자--%>
                            <input type="checkbox" id="HNDID" name="HNDID" value="X" ${resultData.HNDID == "X" ? "checked" : ""} disabled> <spring:message code="LABEL.A.A12.0029" /><%--장애인--%>
                        </td>
                        <th class="th02" width="100"><spring:message code="LABEL.A.A12.0030" /><%--기타--%></th>
                        <td width="280">
                            <input type="checkbox" id="LIVID" name="LIVID" value="X" ${resultData.LIVID == "X" ? "checked" : ""} disabled> <spring:message code="LABEL.A.A12.0031" /><%--동거여부--%>
                            <input type="checkbox" id="HELID" name="HELID" value="X" ${resultData.HELID == "X" ? "checked" : ""} disabled> <spring:message code="LABEL.A.A12.0032" /><%--건강보험--%>
                            <input type="hidden" name="GUBUN" value="X">    <!-- 구분 'X':부양가족, ' ':가족수당 -->
                            <input type="hidden" name="SUBTY" value="${resultData.SUBTY }">
                            <input type="hidden" name="OBJPS" value="${resultData.OBJPS }">
                            <input type="hidden" name="LNMHG" value="${resultData.LNMHG }">
                            <input type="hidden" name="FNMHG" value="${resultData.FNMHG }">
                            <input type="hidden" name="REGNO" value="${resultData.REGNO }">
                            <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </tags-approval:detail-layout>
</tags:layout>
