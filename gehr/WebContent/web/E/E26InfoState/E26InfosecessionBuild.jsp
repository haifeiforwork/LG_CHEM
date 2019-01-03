<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회가입현황                                              */
/*   Program Name : 동호회 탈퇴신청                                             */
/*   Program ID   : E26InfosecessionBuild.jsp                                   */
/*   Description  : 동호회 탈퇴신청                                             */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E26InfoState.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
%>
<tags:layout css="ui_library_approval.css">

    <tags-approval:request-layout titlePrefix="LABEL.E.E26.0010"  disableApprovalLine="true">
                    <tags:script>

                    <script>

$(function() {
    parent.resizeIframe(document.body.scrollHeight);
});

</script>
</tags:script>

    <!--동호회 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            	<colgroup>
            		<col width="15%" />
            		<col width="35%" />
            		<col width="15%" />
            		<col width="35%" />
            	</colgroup>
                <tr>
                  <th ><%--가입일 --%><spring:message code="LABEL.E.E26.0001"/></th>
                  <td colspan="3">${f:printDate(E26InfoStateData.BEGDA) }</td>
                </tr>
                <tr>
                  <th><%--동호회 --%><spring:message code="LABEL.E.E26.0002"/></th>
                  <td>${E26InfoStateData.STEXT}</td>
                  <th ><%--회비 --%><spring:message code="LABEL.E.E26.0007"/></th>
                  <td>${f:printNumFormat(E26InfoStateData.BETRG,0)}</td>
                </tr>
                <tr>
                  <th><%--간사 --%><spring:message code="LABEL.E.E26.0004"/></th>
                  <td>${ E26InfoStateData.ENAME}&nbsp&nbsp${ E26InfoStateData.TITEL}</td>
                  <th ><%--연락처 --%><spring:message code="LABEL.E.E26.0005"/></th>
                  <td>${ E26InfoStateData.USRID }</td>
                </tr>
            </table>
            <div class="commentsMoreThan2">
                <div><%--신청 시 신청내용이 간사에게 전송됩니다 --%><spring:message code="MSG.E.E26.0001"/></div>
                <div><%--회비는 탈퇴월까지 급여공제 됩니다. --%><spring:message code="MSG.E.E26.0009"/></div>
            </div>
        </div>
    </div>
    <!--동호회 테이블 끝-->

    <input type="hidden" name="APPL_DATE" value="${ E26InfoStateData.BEGDA}">
  <input type="hidden" name="BEGDA"     value="${f:currentDate()}">
  <input type="hidden" name="STEXT"     value="${ E26InfoStateData.STEXT }">
  <input type="hidden" name="BETRG"     value="${ E26InfoStateData.BETRG }">
  <input type="hidden" name="TITEL"     value="${ E26InfoStateData.TITEL }">
  <input type="hidden" name="ENAME"     value="${ E26InfoStateData.ENAME}">
  <input type="hidden" name="USRID"     value="${ E26InfoStateData.USRID }">
  <input type="hidden" name="MGART"     value="${ E26InfoStateData.MGART}">
  <input type="hidden" name="LGART"     value="${ E26InfoStateData.LGART}">
  <input type="hidden" name="PERN_NUMB" value="${ E26InfoStateData.PERN_NUMB}">
    <input type="hidden" name="APPLINE_APPU_ENC_NUMB"  value="${ E26InfoStateData.PERN_NUMB}">

   </tags-approval:request-layout>
   </tags:layout>
