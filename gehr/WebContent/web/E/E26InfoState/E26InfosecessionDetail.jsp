<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회가입현황                                              */
/*   Program Name : 동호회 탈퇴신청                                             */
/*   Program ID   : E26InfosecessionDetail.jsp                                  */
/*   Description  : 동호회 탈퇴신청 조회                                        */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E25Infojoin.*" %>
<%@ page import="hris.E.E26InfoState.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


 <c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="LABEL.E.E26.0010" updateUrl="">
                        <tags:script>
                            <script>
                            $(function() {
                            	$(".-update-button").hide();

                            });

</script>
</tags:script>
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
    				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
              <!--동호회 테이블 시작-->
                <tr>
                  <th ><%--동호회 --%><spring:message code="LABEL.E.E26.0002"/></th>
                  <td  colspan="3">
                    <input type="text" name="STEXT" size="50"  value="${e26InfoStateData.STEXT }" readonly>
                  </td>
                 </tr>
                 <tr>
                  <th><%--가입일 --%><spring:message code="LABEL.E.E26.0001"/></th>
                  <td  width="290">
                    <input type="text" name="ENTR_DATE" size="20"   value="${f:printDate(e26InfoStateData.ENTR_DATE) }"  readonly>
                  </td>
                  <th ><%--회비 --%><spring:message code="LABEL.E.E26.0007"/></th>
                  <td >
                    <input type="text" name="BETRG" size="20"  value="${f:printNumFormat(e26InfoStateData.BETRG,0) }" readonly>
                  </td>
                </tr>
                <tr>
                  <th ><%--간사 --%><spring:message code="LABEL.E.E26.0004"/></th>
                  <td >
                    <input type="text" name="ENAME" size="20"  value="${e26InfoStateData.ENAME} ${e26InfoStateData.TITEL}" readonly>
                  </td>
                  <th><%--연락처 --%><spring:message code="LABEL.E.E26.0005"/></th>
                  <td >
                    <input type="text" name="USRID" size="20"  value="${e26InfoStateData.USRID }" readonly>
                  </td>
                </tr>
              </table>
              </div>
           </div>


  <input type="hidden" name="PERN_NUMB"   value="${e25InfoSettData.PERN_NUMB }">
     </tags-approval:detail-layout>
</tags:layout>