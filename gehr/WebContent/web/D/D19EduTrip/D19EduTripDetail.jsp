<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 교육,출장신청조회                                           */
/*   Program ID   : D19EduTripDetail.jsp                                        */
/*   Description  : 교육,출장신청                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-03-08  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.D.D19EduTrip.*" %>

<%
  WebUserData      user            = (WebUserData)session.getAttribute("user");

  /* 교육,출장신청 */
  Vector  D19EduTripData_vt = (Vector)request.getAttribute("D19EduTripData_vt");
  D19EduTripData       data = (D19EduTripData)D19EduTripData_vt.get(0);

  //근태유형추가
  Vector D03VocationAReason0010_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR, "0010",DataUtil.getCurrentDate());
  Vector D03VocationAReason0020_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR, "0020",DataUtil.getCurrentDate());

  Vector D03OvertimeCodeData0010_vt  = new Vector();
  for( int i = 0 ; i < D03VocationAReason0010_vt.size() ; i++ ){
      D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0010_vt.get(i);
      CodeEntity code_data = new CodeEntity();
      code_data.code = old_data.SCODE ;
      code_data.value = old_data.STEXT ;
      D03OvertimeCodeData0010_vt.addElement(code_data);
  }

  Vector D03OvertimeCodeData0020_vt  = new Vector();
  for( int i = 0 ; i < D03VocationAReason0020_vt.size() ; i++ ){
      D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0020_vt.get(i);
      CodeEntity code_data = new CodeEntity();
      code_data.code = old_data.SCODE ;
      code_data.value = old_data.STEXT ;
      D03OvertimeCodeData0020_vt.addElement(code_data);
  }
%>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="D03OvertimeCodeData0010_vt" value="<%=D03OvertimeCodeData0010_vt %>" />
<c:set var="D03OvertimeCodeData0020_vt" value="<%=D03OvertimeCodeData0020_vt %>" />
<tags:layout css="ui_library_approval.css" script="dialog.js" >
 <tags-approval:detail-layout titlePrefix="TAB.COMMON.0036" updateUrl="${g.servlet}hris.D.D19EduTrip.D19EduTripChangeSV">
              <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            <colgroup>
                <col width="15%">
                <col width="85%">
            </colgroup>
                    <tr>
                      <th ><spring:message code="LABEL.D.D19.0003"/> <!-- 신청구분 --></th>
                      <td >
                        <input type="radio" name="awart" value="0010"
                       <c:if  test="${ resultData.AWART eq  '0010' }" >
					     checked
					    </c:if>
					   >
                        <spring:message code="LABEL.D.D19.0022"/> <!-- 교육 -->
                        <input type="radio" name="awart" value="0020"
                        <c:if  test="${ resultData.AWART eq '0020' }" >
					     checked
					    </c:if>
					   >
                        <spring:message code="LABEL.D.D19.0023"/> <!-- 출장 -->
                      </td>
                    </tr>
                    <tr id="gntaegubun">
                      <th><spring:message code="LABEL.D.D19.0004"/> <!-- 구분 --></th>
                      <td >
                        <select  name="OVTM_CODE" class="input04" disabled>
                          <option value="">-------------</option>
                              	   <c:choose>
    	   						   <c:when  test="${ empty resultData.AWART }" >
    	   						      ${ f:printCodeOption(D03OvertimeCodeData0010_vt, "")}
    	   						    </c:when>
    	   						    <c:when  test="${resultData.AWART eq '0010' }">
    	   						     ${f:printCodeOption(D03OvertimeCodeData0010_vt, resultData.OVTM_CODE)}
    	   						     </c:when>
    	   						     <c:otherwise>
    	   						     ${f:printCodeOption(D03OvertimeCodeData0020_vt, resultData.OVTM_CODE) }
    	   						     </c:otherwise>
    	   						     </c:choose>
                        </select>
                      </td>
                    </tr>
                    <tr>
                      <th><spring:message code="LABEL.D.D19.0005"/> <!-- 신청사유 --></th>
                      <td >
                        <input type="text" name="REASON" value="${resultData.REASON}" size="80" readonly>
                      </td>
                    </tr>
                    <!--@v1.2-->
                    <tr>
                      <th><spring:message code="LABEL.D.D19.0006"/> <!-- 대근자 --></th>
                      <td>
                        <input type="text" name="OVTM_NAME" value="${resultData.OVTM_NAME}"  class="input04" size="10" maxlength="10" style="ime-mode:active" readonly>
                      </td>
                      </tr>
                      <tr>
                      <th><spring:message code="LABEL.D.D19.0007"/> <!-- 신청기간 --></th>
                      <td>
                        <input type="text" name="APPL_FROM" value="${f:printDate(resultData.APPL_FROM)}" size="10" readonly>
                        <spring:message code="LABEL.D.D19.0024"/> <!-- 부터 -->
                        <input type="text" name="APPL_TO"   value="${f:printDate(resultData.APPL_TO)}" size="10" readonly>
                        <spring:message code="LABEL.D.D19.0025"/> <!-- 까지 -->
                        <input type="hidden" name="BEGUZ" value="${resultData.BEGUZ}">
                		<input type="hidden" name="ENDUZ" value="${resultData.ENDUZ}">
                      </td>
                    </tr>

            </table>
        </div>
    </div>
                  <div class="commentImportant">
              	<p><spring:message code="LABEL.D.D19.0008"/> <!-- ※ *는 필수 입력사항입니다. --></p>
              	<p><spring:message code="LABEL.D.D19.0009"/> <!-- ※ OFF시 교육의 경우도 교육으로 신청하시기 바랍니다. (O/T 자동 발생 안됨) --></p>
              	<p><spring:message code="LABEL.D.D19.0010"/> <!-- ※ 교대근무자의 경우 심야수당은 자동으로 발생되지 않습니다. --></p>
              	<p><spring:message code="LABEL.D.D19.0011"/> <!-- ※ 전일 교육 및 출장의 경우 근태 신청 바랍니다. --></p>
                  </div>

              <!-- 상단 입력 테이블 끝-->
    </tags-approval:detail-layout>
</tags:layout>