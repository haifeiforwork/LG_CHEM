<%@ page import="hris.common.rfc.CurrencyCodeRFC" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 상세                                                */
/*   Program ID   : D30MembershipFeeDetail.jsp                                        */
/*   Description  : 상세내용 화면                                    */
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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="LABEL.D.D30.0001" updateUrl="${g.servlet}hris.D.D15EmpPay.D15EmpPayChangeSV" disableUpdate="true">

        <%--@elvariable id="resultList" type="java.util.Vector<hris.D.D15EmpPayInfo.D15EmpPayData>"--%>
        <div class="tableArea">
            <div class="table">
                <table id="-search-table" class="tableGeneral tableApproval">
                    <colgroup>
                        <col width="15%">
                        <col width="85%">

                    </colgroup>
                    <tr>
                        <th class="th02"><spring:message code="LABEL.D.D15.0202" /><!-- 반영년월 --></th>
                        <td>
                            ${fn:substring(resultList[0].YYYYMM, 0, 4)}.${fn:substring(resultList[0].YYYYMM, 4, 6)}
                        </td>
                    </tr>
                </table>
            </div>
            <!-- 상단 입력 테이블 끝-->
        </div>

        <div class="listArea">
            <div class="listTop">
                <span  class="listCnt"><spring:message code="LABEL.D.D15.0147"/> : <span id="-list-total">${f:getSize(resultList)}</span> <spring:message code="LABEL.D.D15.0148"/>  / <span id="sumAmt"></span> RMB</span>
            </div>
            <div class="table">
                <table class="listTable">
                  <%--  <colgroup>
                        <col width="140">
                        <col width="100">
                        <col width="100">
                        <col width="100">
                        <col width="50">
                    </colgroup>--%>
                    <thead>
                    <tr>
                        <th><spring:message code="LABEL.D.D12.0017" /><!-- 사원번호 --></th>
                    	<th><spring:message code="MSG.APPROVAL.0013" /><!-- 성명 --></th>
                        <th><spring:message code="LABEL.D.D30.0002" /><!-- 회비유형 --></th>
                    	<th><spring:message code="LABEL.D.D05.0015" /><!-- 금액 --></th>
                    	<th><spring:message code="LABEL.D.D15.0203" /><!-- 통화 --></th>
                        <th class="lastCol" ><spring:message code="LABEL.D.D30.0003" /><!-- 탈퇴 --></th>
                    </tr>
                    </thead>
                    <tbody id="-listTable-body">
                        <%--@elvariable id="resultList" type="java.util.Vector<hris.D.D15EmpPayInfo.D15EmpPayData>"--%>
                    <c:set var="sumAmt" value="0"/>
                    <c:forEach  var="row" items="${resultList}" varStatus="status">
                        <c:set var="sumAmt" value="${sumAmt + row.BETRG}"/>
                        <tr id="-pay-row-${status.index}" >
                            <td>${row.PERNR}</td>
                            <td>${row.ENAME}</td>
                            <td class="align_left" style="padding-left: 10px;">[${row.MGART}] ${row.MGTXT}</td>
                            <td class="align_right" >${f:convertCurrencyDecimal(row.BETRG, '') }</td>
                            <td>${row.WAERS}</td>
                            <td class="lastCol">${row.ZQUIT}</td>
                        </tr>
                    </c:forEach>
                    <tags:table-row-nodata list="${resultList}" col="6"/>
                        <script>
                            $("#sumAmt").text('${f:convertCurrencyDecimal(sumAmt, '0') }');
                        </script>
                    </tbody>
                </table>
            </div>
        </div>

    </tags-approval:detail-layout>
</tags:layout>