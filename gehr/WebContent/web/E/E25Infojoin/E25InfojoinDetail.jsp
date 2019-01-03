<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회 가입                                                 */
/*   Program Name : 동호회 가입 조회                                            */
/*   Program ID   : E25InfojoinDetail.jsp                                       */
/*   Description  : 동호회 가입 조회할 수 있게 하는 화면                        */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-03-02  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E25Infojoin.*" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

 <c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="LABEL.E.E26.0008" updateUrl="">
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
                      <tr>
                        <th><%--동호회 --%><spring:message code="LABEL.E.E26.0002"/>
                        	<input type="hidden" name="BEGDA" size="14"  value="${ f:printDate(e25InfoJoinData.BEGDA)}" readonly>
                        </th>
                        <td colspan="3">
                          	<input type="text" name="STEXT" size="40"  value="${ e25InfoJoinData.STEXT}" readonly>
                        </td>
                      </tr>
                      <tr>
                         <th><%--간사 --%><spring:message code="LABEL.E.E26.0004"/></th>
                         <td>
                         	 <input type="text" name="ENAME" size="40"  value="${e25InfoJoinData.ENAME }&nbsp;${e25InfoSettData.TITEL}" readonly>
                        </td>
                         <th><%--연락처 --%><spring:message code="LABEL.E.E26.0005"/></th>
                  		 <td >
                    			<input type="text" name="USRID" size="20"  value="${e25InfoJoinData.USRID}"  readonly>
                  		</td>
                        </tr>
                    </table>
                </div>
                </div>
<c:if test="${approvalHeader.showManagerArea}">
        <h2 class="subtitle"><%--담당자입력정보 --%><spring:message code="LABEL.E.E26.0006"/></h2>
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                  <colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
                <c:choose>
                    <%-- 최초 결재자 여부 - 모든 결재자가 수정 가능 할 경우 --%>
                    <c:when test="${approvalHeader.editManagerArea}">
                          <tags:script>
                            <script>
                            function beforeAccept()
                            {
                                var frm = document.form1;
                                source = frm.APPL_DATE;
                                if(source.value == "") {
                                    //alert("가입일을 입력하세요");
                                    alert("<spring:message code='MSG.E.E26.0005'/>");
                                    source.focus();
                                    return;
                                } // end if

                                source = frm.BETRG;
                                if(source.value == "") {
                                    //alert("회비를 입력하세요");
                                    alert("<spring:message code='MSG.E.E26.0006'/>");
                                    source.focus();
                                    return;
                                } // end if


                                return true;
                            }
                            </script>
                           </tags:script>
	                            <tr>
	                              <th><%--가입일 --%><spring:message code="LABEL.E.E26.0001"/><span class="textPink">*</span></th>
	                              <td>
	                              	<input type="text"  class="date" name="APPL_DATE" size="10" maxlength="10" >
	                              </td>
	                              <th ><%--회비 --%><spring:message code="LABEL.E.E26.0007"/><span class="textPink">*</span></th>
	                              <td>
	                                <input type="text" NAME="BETRG" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEvent(this,'KRW');" onBlur="if(this.value=='') this.value = 0;" class="input03"> 원
	                              </td>
	                            </tr>
	                      </c:when>
	                      <c:otherwise>
	                      	       <tr>
	                              <th><%--가입일 --%><spring:message code="LABEL.E.E26.0001"/><span class="textPink">*</span></th>
	                              <td>
	                              	${f:printDate(e25InfoJoinData.APPL_DATE)}
	                              </td>
	                              <th ><%--회비 --%><spring:message code="LABEL.E.E26.0007"/><span class="textPink">*</span></th>
	                              <td>
	                                ${f:printNumFormat(e25InfoJoinData.BETRG,'0')} ${e25InfoJoinData.WAERS }
	                              </td>
	                            </tr>
	                      </c:otherwise>
	                      </c:choose>
                    </table>
                    <span class="commentOne"><%-- 회비는 가입월부터 급여공제됩니다.--%><spring:message code="MSG.E.E26.0008"/> </span>
                </div>
                </div>
	</c:if>
    </tags-approval:detail-layout>
</tags:layout>
