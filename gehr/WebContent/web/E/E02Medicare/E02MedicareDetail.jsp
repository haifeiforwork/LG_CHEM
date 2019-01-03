<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 재발급                                             */
/*   Program Name : 건강보험 재발급/추가발급/기재사항변경 신청 조회             */
/*   Program ID   : E02MedicareDetail.jsp                                       */
/*   Description  : 건강보험증 변경/재발급 조회/삭제 하는 화면                  */
/*   Note         :                                                             */
/*   Creation     : 2002-01-29  박영락                                          */
/*   Update       : 2005-02-28  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E02Medicare.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />


    <tags:layout css="ui_library_approval.css" script="dialog.js" >
    <tags-approval:detail-layout titlePrefix="TAB.COMMON.0052"  updateUrl="${g.servlet}hris.E.E02Medicare.E02MedicareChangeSV">


              <!-- 상단 입력 테이블 시작-->
				<div class="tableArea">
                  <div class="table">
	                  <table class="tableGeneral tableApproval">
	                 <colgroup>
            			<col width="15%" />
            			<col width="35%" />
            			<col width="15%" />
            			<col width="35%" />
            		</colgroup>
                      <tr>
                        <th><spring:message code="LABEL.E.E22.0042" /><!-- 신청구분 --></th>
                        <td>
                          <input type="text" name="APPL_TEXT2"  value='${resultData.APPL_TEXT2}' readonly size="16">
                        </td>
                        <th class="th02"><spring:message code="LABEL.E.E01.0002" /><!-- 대상자 성명 --></th>
                        <td >
                          <input type="text" name="ENAME"  value='${resultData.ENAME }' readonly size="16">
                        </td>
                      </tr>
            		</table>
        		  </div>
    			</div>

    <h2 class="subtitle"><input type="radio" name="medi" value="1" ${resultData.APPL_TEXT3 eq ''  ? ''  :  'checked' } disabled><spring:message code="LABEL.E.E02.0001" /><!-- 기재사항변경 --></h2>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
	                 <colgroup>
            			<col width="15%" />
            			<col width="35%" />
            			<col width="15%" />
            			<col width="35%" />
            		</colgroup>
                <tr>
                  <th><spring:message code="LABEL.E.E02.0002" /><!-- 변경항목 --></th>
                  <td colspan="3">
						<input type="text" name="APPL_TEXT3" size="60" value='${resultData.APPL_TEXT3 eq  '기타'  ? resultData.ETC_TEXT3 : resultData.APPL_TEXT3 }' readonly >
                  </td>
                </tr>
                <tr>
                  <th><spring:message code="LABEL.E.E02.0003" /><!-- 변경전Data --></th>
                  <td>
                    <input type="text" name="CHNG_BEFORE" size="25" value='${resultData.CHNG_BEFORE }' readonly >
                  </td>
                  <th class="th02"><spring:message code="LABEL.E.E02.0004" /><!-- 변경후Data --></th>
                  <td>
                    <input type="text" name="CHNG_AFTER" size="25" value='${resultData.CHNG_AFTER }' readonly >
                  </td>
                </tr>
              </table>
        </div>
    </div>
    <h2 class="subtitle"><input type="radio" name="medi" value="2" ${resultData.APPL_TEXT4  eq '' ? '' : 'checked' } disabled><spring:message code="LABEL.E.E02.0005" /><!-- 추가발급 --></h2>
    <div class="tableArea">
        <div class="table">
              <table class="tableGeneral tableApproval">
	                 <colgroup>
            			<col width="15%" />
            			<col  />
            		</colgroup>
                <tr>
                  <th><spring:message code="LABEL.E.E02.0006" /><!-- 발급사유 --></th>
                  <td>
						<input type="text" name="APPL_TEXT4"  value='${resultData.APPL_TEXT4 eq  '기타' ? resultData.ETC_TEXT4 : resultData.APPL_TEXT4 }' readonly size="60">
                  </td>
                </tr>
                <tr>
                  <th ><spring:message code="LABEL.E.E02.0007" /><!-- 발행부수 --></th>
                  <td><input type="text" name="ADD_NUM"  value="${resultData.ADD_NUM eq '000' ? '' : f:printNum(resultData.ADD_NUM)}" size="2" maxlength="3" style="text-align:right" readonly></td>
                </tr>
              </table>
        </div>
    </div>

    <h2 class="subtitle"><input type="radio" name="medi" value="3" ${resultData.APPL_TEXT5 eq '' ?  ''  : 'checked' } disabled><spring:message code="LABEL.E.E02.0008" /><!-- 재발급 --></h2>
    <div class="tableArea">
        <div class="table">
          <table class="tableGeneral tableApproval">
	                 <colgroup>
            			<col width="15%" />
            			<col  />
            		</colgroup>
            <tr>
              <th><spring:message code="LABEL.E.E02.0009" /><!-- 신청사유 --></th>
              <td>
                <input type="text" name="APPL_TEXT5"  value='${resultData.APPL_TEXT5 eq  '기타'  ? resultData.ETC_TEXT5 : resultData.APPL_TEXT5 }' readonly size="60">
               </td>
            </tr>
            <tr>
              <th><spring:message code="LABEL.E.E02.0007" /><!-- 발행부수 --></th>
              <td><input type="text" name="ADD_NUM1"  value="${resultData.ADD_NUM1 eq '000' ? '' : f:printNum(resultData.ADD_NUM1)}" size="2" maxlength="3" style="text-align:right" readonly>
              </td>
            </tr>
          </table>
        </div>
        <div class="commentImportant" style="width:640px;">
            <p><spring:message code="LABEL.E.E02.0010" /><!-- ※ 제출서류 : 기재사항변경의 경우 주민등록등본, 건강보험증 각 1부 --></p>
        </div>
    </div>
    <!--상단 입력 테이블 끝-->
    </tags-approval:detail-layout>
</tags:layout>