<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 추가암검진(7대암검진)                                                    */
/*   Program Name : 추가암검진(7대암검진)                                                    */
/*   Program ID   : E38CancerDetail.jsp                                        */
/*   Description  : 추가암검진(7대암검진) 신청내역을 조회                                    */
/*   Note         :                                                             */
/*   Creation     : 2013-06-21  lsa    C20130620_53407                                          */
/*   Update       :   2014-10-22 SJY 추가 암검진 화면오류                                                           */
/*                        2014-10-30 SJY  CSR ID:2634070 임직원 건강검진 시스템 오류 수정 요청                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String PERNR = (String)request.getAttribute("PERNR");
%>

<tags:layout css="ui_library_approval.css" script="dialog.js" >
<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
<tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_ADDI_CHECK" updateUrl="${g.servlet}hris.E.E38Cancer.E38CancerChangeSV" disable="${reqDisable}">

	<div class="tableArea">
          <div class="table">
              <table class="tableGeneral">
	               <colgroup>
		           		<col width="15%" />
		           		<col width="30%" />
		           		<col width="15%" />
		           		<col width="" />
		           	</colgroup>

		           	<tr>
		                <th><!--검진년도--><spring:message code="LABEL.E.E28.0001" /></th>
		                <td>
		                	<input type="hidden" name="BEGDA" value="<c:out value='${f:printDate(approvalHeader.RQDAT)}'/>"  />
		                	<input type="text" name="EXAM_YEAR" size="25" class="noBorder" value="<c:out value='${resultData.EXAM_YEAR }'/>" readonly />
		                </td>
		                <th class="th02"><!--구분--><spring:message code="LABEL.E.E28.0002" /></th>
		                <td>
		                	<input type="text" name="GUEN_NAME" size="25" class="noBorder" value="<c:out value='${resultData.GUEN_NAME}'/>" readonly />
	                    </td>
	               </tr>
	               <tr>
	                   <th><!--검진희망병원--><spring:message code="LABEL.E.E28.0009" /></th>
	                   <td colspan="3">
	                       <input type="text" name="HOSP_NAME" size="25" class="noBorder" value="<c:out value='${resultData.HOSP_NAME}'/>" readonly />
	                   </td>
	               </tr>
	               <tr>
	                   <th><!--검진지역--><spring:message code="LABEL.E.E28.0006" /></th>
	                   <td>
	                       <input type="text" name="AREA_NAME" size="25" class="noBorder" value="<c:out value='${resultData.AREA_NAME}'/>" readonly />
	                   </td>
	                   <th class="th02"><!--소화기검사선택--><spring:message code="LABEL.E.E28.0010" /></th>
	                   <td>
	                       <input type="text" name="STMC_TEXT" size="25" class="noBorder" value="<c:out value='${resultData.STMC_TEXT}'/>" readonly />
	                    </td>
	                </tr>

	                <tr>
	                    <th><!--전화(회사)--><spring:message code="LABEL.E.E28.0011" /></th>
	                    <td>
	                    	<input type="text" name="COMP_NUMB" size="25" class="noBorder" value="<c:out value='${resultData.COMP_NUMB}'/>" readonly />
	                    </td>

	                    <th class="th02"><!--선택검사--><spring:message code="LABEL.E.E28.0012" /></th>
	                    <td>
	                    	<input type="text" name="SELT_TEXT" size="25" class="noBorder" value="<c:out value='${resultData.SELT_TEXT}'/>" readonly />
	                    </td>
	                </tr>
	                <tr>
		                <th><!--휴대전화--><spring:message code="LABEL.E.E28.0014" /></th>
		                <td>
		                	<input type="text" name="ZHOM_NUMB" size="25" class="noBorder" value="<c:out value='${resultData.ZHOM_NUMB}'/>" readonly />
		                </td>

		                <th class="th02"><!--검진희망일--><spring:message code="LABEL.E.E28.0003" /></th>
		                <td>
		                	<input type="text" name="EZAM_DATE" size="25" class="noBorder" value="<c:out value='${f:printDate(resultData.EZAM_DATE)}'/>" readonly />
		                </td>
	                </tr>
	                <tr>
		                <th><!--문진표받으실 주소지--><spring:message code="LABEL.E.E28.0015" /></th>
		                <td colspan="3">
		                	<input type="text" name="STRAS" size="105" class="noBorder" value="<c:out value='${resultData.STRAS}'/>" readonly />
		                </td>
	              	</tr>

	              	<!-- 여수,나주  -->
	              	<c:if test="${resultData.AREA_CODE eq '02' || resultData.AREA_CODE eq '07' }" >
	                 <tr>
		                 <th><!--기타요구사항--><spring:message code="LABEL.E.E28.0016" /></th>
		                 <td colspan="3">
		                 	  <input type="text" name="BIGO" size="105" class="noBorder" value="<c:out value='${resultData.BIGO}'/>" readonly />
		                 </td>
	                 </tr>
	                 </c:if>

					 <!-- 대산  -->
	              	 <c:if test="${resultData.AREA_CODE eq '09'}" >
	                 <tr>
	                     <th><!--추가 검사 항목 (개인비용부담)--><spring:message code="LABEL.E.E28.0017" /></th>
	                     <td colspan="3">
	                     	  <input type="text" name="BIGO" size="105" class="noBorder" value="<c:out value='${resultData.BIGO}'/>" readonly />
	                     </td>
	                 </tr>
	                 </c:if>

	                 <tr>
		                 <th><!--상태--><spring:message code="LABEL.E.E28.0019" /></th>
		                 <td colspan="3">

		                 <!--  //결재완료 -->
		                 <c:choose>
		                 	<c:when test="${approvalHeader.AFSTAT eq '03'}" >

		                 		<c:choose>
				                 	<c:when test="${resultData.CONF_DATE eq '' || resultData.CONF_DATE eq '0000-00-00' }" >
				                 		<spring:message code="MSG.E.E15.0028" /> <!-- 미확정되었으니 재신청하십시오.  -->
				                 	</c:when>
				                 	<c:otherwise>
				                 		<spring:message code="MSG.E.E15.0029" /> <!-- 확정되었습니다.  -->   ( <spring:message code="MSG.E.E15.0030" /> <!-- 확정검진일자  --> : <font color="0000ff"> <c:out value='${f:printDate(resultData.CONF_DATE)}'/> </font> )
				                 	</c:otherwise>
				                 </c:choose>

		                 	</c:when>
		                 	<c:otherwise>
		                 		  <spring:message code="MSG.E.E15.0031" /> <!-- 현재 예약중입니다.  -->   <!--  //결재미완료 -->
		                 	</c:otherwise>

		                 </c:choose>

						 </td>
	                 </tr>

			  </table>
          </div><!--  end table -->

		<!-----   hidden field ---------->
		<input type="hidden" name="CONF_DATE"   value="<c:out value='${resultData.CONF_DATE}'/>" />

		<!-----   hidden field ---------->
        <!-- 상단 입력 테이블 끝-->
      </div> <!--  end tableArea -->

</tags-approval:detail-layout>
</tags:layout>