<%@ page import="com.common.constant.Area" %>
<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 자격면허등록 신청                                           */
/*   Program ID   : D15EmpPayBuild.jsp                                         */
/*   Description  : 자격증면허를 신청할 수 있는 화면                            */
/*   Note         :                                                             */
/*   Creation     : 2016-10-06  정진만                                          */
/*   Update       :                                                    */
/*                                                                              */
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-emp-pay" tagdir="/WEB-INF/tags/D/D15" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--@elvariable id="g" type="com.common.Global"--%>
<tags-emp-pay:emp-build-layout pageGubun="empPay" titlePrefix="LABEL.D.D15.0201"
                               payTypeURL="${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayTypeListAjax"
                               templateURL="${g.jsp}template/pay_template_${g.locale}.xls"
                               uploadURL="${g.jsp}D/D15EmpPayInfo/D15EmpPayFileUpload.jsp"
                                validateURL="${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayValidateList"
                                validateAjaxURL="${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayValidateAjax">
                               <%--uploadURL="${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayExcelUploadAjax"--%>


    <div class="listArea">
        <div class="listTop">
            <span  class="listCnt"><spring:message code="LABEL.D.D15.0147"/> : <span id="-list-total">${fn:length(resultList)}</span> <spring:message code="LABEL.D.D15.0148"/> / <span id="sumAmt"></span> RMB</span>
            <div class="buttonArea">
                <ul class="btn_mdl displayInline" style="margin-left: 10px;">
                    <li><a class="search" onclick="addRow()"><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><%-- 행추가 --%></span></a></li>
                    <li><a class="search" onclick="deleteRow()"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><%-- 행삭제 --%></span></a></li>
                </ul>
            </div>
        </div>
        <tags-emp-pay:emp-build-list />
        <div class="buttonArea">
            <ul class="btn_mdl displayInline" style="margin-left: 10px; margin-bottom: 2px;">
                <li><a class="search" onclick="addRow()"><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><%-- 행추가 --%></span></a></li>
                <li><a class="search" onclick="deleteRow()"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><%-- 행삭제 --%></span></a></li>
            </ul>
        </div>
        <div class="commentsMoreThan2">
            <div><spring:message code="LABEL.D.D15.0204" /><%-- 결재완료시 반영년월 정기급여로 처리 됩니다. --%></div>
        </div>
    </div>


</tags-emp-pay:emp-build-layout>






