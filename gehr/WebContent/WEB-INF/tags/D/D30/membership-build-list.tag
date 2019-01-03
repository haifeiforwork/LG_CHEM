<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<div class="table">
    <div class="table">
        <table class="listTable">
            <colgroup>
                <col width="10">
                <col width="200">
                <col width="200">
                <col width="150">
                <col width="80">
                <col width="50">
                <col width="50">
                <col width="">
            </colgroup>
            <thead>
            <tr>
                <th><input type="checkbox" id="checkAll" name="checkAll" onclick="checkAllChange()"/></th>
                <th><spring:message code="LABEL.COMMON.0006" /><%-- 사원찾기 --%></th>
                <th><spring:message code="MSG.A.A12.0021" /><%-- 대상자 --%></th>
                <th><spring:message code="LABEL.D.D30.0002" /><!-- 회비유형 --></th>
                <th><spring:message code="LABEL.D.D05.0015" /><!-- 금액 --></th>
                <th><spring:message code="LABEL.D.D15.0203" /><!-- 통화 --></th>
                <th><spring:message code="LABEL.D.D30.0003" /><!-- 탈퇴 --></th>
                <th class="lastCol" ><spring:message code="LABEL.D.D13.0021" /><!-- 메세지 --></th>
            </tr>
            </thead>
            <tbody id="-listTable-body">
            <%--@elvariable id="resultList" type="java.util.Vector<hris.D.D15EmpPayInfo.D15EmpPayData>"--%>
            <%--@elvariable id="payTypeMap" type="Map<String, Vector<hris.D.D30MembershipFee.D30MembershipFeeTypeData>>"--%>

            <c:forEach  var="row" items="${resultList}" varStatus="status"><%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
                <tr id="-pay-row-${status.index}" >
                    <td>
                        <input type="checkbox" id="checkRow${status.index}" name="checkRow" class="-row-check" value="X"/>
                    </td>
                    <td>
                        <select id="APPR_SEARCH_GUBUN${status.index}"  name="LIST_SEARCH_GUBUN" onChange="removeSearchPerson(${status.index})">
                            <option value="2"><!--성명별--><spring:message code="LABEL.COMMON.0004" /></option>
                            <option value="1"><!--사번별--><spring:message code="LABEL.COMMON.0005" /></option>
                        </select>
                        <input type="text"  id="APPR_SEARCH_VALUE${status.index}" name="I_VALUE1" size="10"  maxlength="10"  onkeydown="searchPerson(${status.index});" style="ime-mode:active" >
                        <a onclick="searchPerson(${status.index});" ><img src="${g.image}sshr/ico_magnify.png" /></a>
                    </td>
                    <td>
                        <input type="text" id="PERNR${status.index}" name="LIST_PERNR" class="-search-person required" placeholder="<spring:message code="MSG.A.A12.0021" /><%-- 대상자 --%>"  readonly value="${row.PERNR}" style="width: 80px;" />
                        <input type="text" id="ENAME${status.index}" name="LIST_ENAME" readonly value="${row.ENAME}" style="width: 60px;"/>
                    </td>
                    <td>
                        <select id="MGART${status.index}" name="LIST_MGART" class="required -pay-type" onchange="selectPayType('MGART${status.index}');" placeholder="<spring:message code="LABEL.D.D30.0002" />">
                            <option value="">-----------------</option>
                            <c:forEach var="payType" items="${payTypeList}">
                                <option value="${payType.MGART}" data-lgart="${payType.LGART}" data-betrg="${payType.BETRG}"
                                    ${row.MGART == payType.MGART ? "selected" : ""}>[${payType.MGART}]${payType.MGTXT}</option>
                            </c:forEach>
                        </select>
                        <input type="hidden" id="YYYYMM${status.index}" name="LIST_YYYYMM" value="${row.YYYYMM}"/>
                        <input type="hidden" id="PDATE${status.index}" name="LIST_PDATE" value="${row.PDATE}"/>
                        <input type="hidden" id="LGART${status.index}" name="LIST_LGART" value="${row.LGART}"/>
                        <input type="hidden" id="AINF_SEQN${status.index}" name="LIST_AINF_SEQN" value="${row.AINF_SEQN}"/>
                        <input type="hidden" id="BEGDA${status.index}" name="LIST_BEGDA" value="${approvalHeader.RQDAT}"/>
                    </td>
                    <td>
                        <input type="text" id="BETRG${status.index}" name="LIST_BETRG" value="${f:convertCurrency(row.BETRG, '') }" size="10"  class="money" placeholder="<spring:message code="LABEL.D.D05.0015" /><!-- 금액 -->" readonly>
                    </td>
                    <td>
                        <input type="text" id="WAERS${status.index}" name="LIST_WAERS" value="${row.WAERS}" size="5" placeholder="<spring:message code="LABEL.D.D15.0203" /><!-- 통화 -->" readonly>
                    </td>
                    <td>
                        <input type="checkbox" id="checkRetire${status.index}" name="LIST_CHECK_RETIRE" value="X" ${row.ZQUIT == 'X' ? 'checked' : ''} onclick="checkRetire(${status.index})">
                        <input type="hidden" id="ZQUIT${status.index}" name="LIST_ZQUIT" value="${row.ZQUIT}" >
                    </td>
                    <td class="lastCol">
                        <input type="text" id="ZMSG${status.index}" name="LIST_ZMSG" style="width: 90%" value="${row.ZMSG}" class="result-msg" readonly/>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <textarea id="template" style="display: none; top: -99999px; height: 0px; ">
        <tr id="-pay-row-#idx#" >
            <td>
                <input type="checkbox" id="checkRow#idx#" name="checkRow" class="-row-check" value="X"/>
            </td>
            <td>
                 <select id="APPR_SEARCH_GUBUN#idx#" name="LIST_SEARCH_GUBUN" onChange="removeSearchPerson(#idx#)">
                    <option value="2"><!--성명별--><spring:message code="LABEL.COMMON.0004" /></option>
                    <option value="1"><!--사번별--><spring:message code="LABEL.COMMON.0005" /></option>
                </select>
                <input type="text"  id="APPR_SEARCH_VALUE#idx#" name="I_VALUE1" size="10"  maxlength="10"  onkeydown="searchPerson(#idx#);" style="ime-mode:active" >
                <a onclick="searchPerson(#idx#);" ><img src="${g.image}sshr/ico_magnify.png" /></a>
            </td>
            <td>
                <input type="text" id="PERNR#idx#" name="LIST_PERNR" class="-search-person required" readonly value="" style="width: 80px;" />
                <input type="text" id="ENAME#idx#" name="LIST_ENAME" readonly value="" style="width: 60px;"/>
            </td>
            <td>
                <select id="MGART#idx#" name="LIST_MGART" class="required -pay-type" onchange="selectPayType('MGART#idx#');" placeholder="<spring:message code="LABEL.D.D30.0002" />">
                    <option value="">-----------------</option>
                <c:forEach var="payType" items="${payTypeList}">
                    <option value="${payType.MGART}" data-lgart="${payType.LGART}" data-betrg="${payType.BETRG}"
                        ${row.MGART == payType.MGART ? "selected" : ""}>[${payType.MGART}]${payType.MGTXT}</option>
                </c:forEach>
                </select>
                <input type="hidden" id="YYYYMM#idx#" name="LIST_YYYYMM" value=""/>
                <input type="hidden" id="PDATE#idx#" name="LIST_PDATE" value=""/>
                <input type="hidden" id="LGART#idx#" name="LIST_LGART" value=""/>
                <input type="hidden" id="AINF_SEQN#idx#" name="LIST_AINF_SEQN" value=""/>
                <input type="hidden" id="BEGDA#idx#" name="LIST_BEGDA" value="${approvalHeader.RQDAT}"/>
            </td>
            <td>
                <input type="text" id="BETRG#idx#" name="LIST_BETRG" value="" size="10"  class="money" placeholder="<spring:message code="LABEL.D.D05.0015" />" maxlength="9" readonly/>
            </td>
            <td>
                <input type="text" id="WAERS#idx#" name="LIST_WAERS" value="" size="5" placeholder="<spring:message code="LABEL.D.D15.0203" />" readonly>
            </td>
            <td>
                <input type="checkbox" id="checkRetire#idx#" name="LIST_CHECK_RETIRE" value="X" onclick="checkRetire(#idx#)" >
                <input type="hidden" id="ZQUIT#idx#" name="LIST_ZQUIT" value="" >
            </td>
            <td class="lastCol">
                <input type="text" id="ZMSG#idx#" name="LIST_ZMSG" style="width: 90%" value="" class="result-msg" readonly/>
            </td>
        </tr>
    </textarea>


</div>
