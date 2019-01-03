<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 부양가족여부 신청                                           */
/*   Program ID   : A12SupportBuild.jsp                                         */
/*   Description  : 부양가족여부 신청                                           */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-02  윤정현                                          */
/*                  2008-04-21  lsa @v1.0 [CSR ID:1254077]대리신청시 정보조회안되게수정*/
/*                  2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청                                                             */

/*                  2015-11-02 [CSR ID:2908196] 부양가족 신청 안내화면 수정    */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>

<tags:layout css="ui_library_approval.css" help="A12Family.html">
    <tags-approval:request-layout titlePrefix="LABEL.A.A12.0027" subtitleCode="LABEL.A.A12.0027" representative="false">
    <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
    <%--@elvariable id="familyData" type="hris.A.A12Family.A12FamilyListData"--%>

        <h2 class="subtitle"><spring:message code="LABEL.A.A12.0012" /><!-- 대상자 --></h2>

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
                            <input type="text" name="regno"  value="${f:printRegNo(familyData.REGNO, user.empNo != approvalHeader.PERNR ? "FULL" : "")}" size="20" readonly>
                        </td>
                        <th><spring:message code="LABEL.A.A12.0004" /><%--관계--%></th>
                        <td> <input type="text" name="atext"  value="${familyData.ATEXT }" size="20" readonly>
                        </td>
                    </tr>
                    <c:if test="${user.empNo == approvalHeader.PERNR}" >
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

        <div class="inlineComment"><spring:message code="MSG.A.A12.0026" /><%--해당사항에 체크하여 주시기 바랍니다.--%></div>
        <h2 class="subtitle"><spring:message code="LABEL.A.A12.0040" /><%--종속성--%></h2>
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                    <tr>
                        <th width="100"><spring:message code="LABEL.A.A12.0026" /><%--세금--%></th>
                        <td width="280">
                            <input type="checkbox" id="DPTID" name="DPTID" value="X" ${resultData.DPTID == "X" ? "checked" : ""}> <spring:message code="LABEL.A.A12.0027" /><%--부양가족--%>
                            <input type="checkbox" id="BALID" name="BALID" value="X" ${resultData.BALID == "X" ? "checked" : ""} > <spring:message code="LABEL.A.A12.0028" /><%--수급자--%>
                            <input type="checkbox" id="HNDID" name="HNDID" value="X" ${resultData.HNDID == "X" ? "checked" : ""} > <spring:message code="LABEL.A.A12.0029" /><%--장애인--%>
                        </td>
                        <th class="th02" width="100"><spring:message code="LABEL.A.A12.0030" /><%--기타--%></th>
                        <td width="280">
                            <input type="checkbox" id="LIVID" name="LIVID" value="X" ${resultData.LIVID == "X" ? "checked" : ""}> <spring:message code="LABEL.A.A12.0031" /><%--동거여부--%>
                            <input type="checkbox" id="HELID" name="HELID" value="X" ${resultData.HELID == "X" ? "checked" : ""}> <spring:message code="LABEL.A.A12.0032" /><%--건강보험--%>
                            <input type="hidden" name="GUBUN" value="X">    <!-- 구분 'X':부양가족, ' ':가족수당 -->
                            <input type="hidden" name="SUBTY" value="${familyData.SUBTY }">
                            <input type="hidden" name="OBJPS" value="${familyData.OBJPS }">
                            <input type="hidden" name="LNMHG" value="${familyData.LNMHG }">
                            <input type="hidden" name="FNMHG" value="${familyData.FNMHG }">
                            <input type="hidden" name="REGNO" value="${familyData.REGNO }">
                            <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">

                        </td>
                    </tr>
                </table>
            </div>
            <span class="inlineComment"><spring:message code="MSG.A.A12.0027" /><%--&nbsp;&nbsp;※ 부양가족여부는 연말정산자료로서
                자격요건에 해당하는 경우에만 신청하시기 바랍니다.<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신청하시기전에 사용방법안내에서 자격요건과 제출서류를 반드시
                확인해 주시기 바랍니다.--%>
            </span>
        </div>

    </tags-approval:request-layout>
</tags:layout>





