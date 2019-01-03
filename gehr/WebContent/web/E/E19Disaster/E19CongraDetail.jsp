<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해신청 조회                                               */
/*   Program ID   : E19CongraDetail.jsp                                         */
/*   Description  : 재해 신청을 조회하는 화면                                   */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-25  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E19Disaster.*" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<%
    WebUserData user = WebUtil.getSessionUser(request);

    E19CongcondData e19CongcondData = (E19CongcondData)request.getAttribute("e19CongcondData");

    Vector E19DisasterData_vt = (Vector)request.getAttribute("E19DisasterData_vt");
    int rowCount_report =E19DisasterData_vt.size();
    long dateLong=Long.parseLong(DataUtil.removeStructur(e19CongcondData.CONG_DATE, "-"));
    String dateCheck = "Y";
    if( dateLong < 20020101 )     dateCheck = "N";


%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="E19DisasterData_vt" value="<%=E19DisasterData_vt %>"/>
<c:set var="rowCount_report" value="<%=rowCount_report %>"/>
<c:set var="dateCheck" value="<%=dateCheck %>"/>


<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_ADDI_FEE" updateUrl="${g.servlet}hris.E.E19Disaster.E19CongraChangeSV">
                        <tags:script>
                            <script>
                            function open_report(){
                                document.form1.action = "${g.servlet}hris.E.E19Disaster.E19ReportDetailSV";
                                document.form1.method = "post";
                                document.form1.submit();
                            }
                         </script>
                        </tags:script>



    <!-- 상단 입력 테이블 시작-->
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
                    <th><!-- 재해발생일자 --><spring:message code="LABEL.E.E19.0003"/></th>
                    <td colspan="3">
                      <input type="text" name="CONG_DATE" value="${f:printDate(resultData.CONG_DATE)}" size="20" readonly>
                      <input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" size="20" readonly>
                      <a class="inlineBtn" href="javascript:open_report();"><span><!-- 재해 피해 신고서 조회 --><spring:message code="LABEL.E.E19.0010"/></span></a>
                      <span>&nbsp;${rowCount_report}&nbsp;건</span>
                      <input type="hidden" name="disa_name" value="재해" size="20" readonly>
                    </td>
                  </tr>
            </table>
        </div>
    </div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
             	<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
<%--
<!--
                      <tr>
                        <th>통상임금</th>
                        <td colspan="3">
<%
//  2002.07.09. 경조발생일자가 2002.01.01. 이전이면 통상임금, 경조금액을 보여주지 않는다.
    String dateCheck = "Y";
        long dateLong = Long.parseLong(DataUtil.removeStructur(e19CongcondData.CONG_DATE, "-"));
    if( user.companyCode.equals("C100") ) {         // LG화학

        if( dateLong < 20100430 ) {
            dateCheck = "N";
        }
        if( dateCheck.equals("Y") ) {
%>
                          <input type="text" name="WAGE_WONX" value="<%= WebUtil.printNumFormat(e19CongcondData.WAGE_WONX) %>" style="text-align:right" size="20" readonly> 원
<%
        } else {
%>
                          <input type="text" name="WAGE_WONX" value="" style="text-align:right" size="20" readonly>
<%
        }
//  2002.07.09. 0보다 큰 경우에만 값을 보여준다.
    } else if( user.companyCode.equals("N100") ) {         // LG석유화학
        if( !WebUtil.printNumFormat(e19CongcondData.WAGE_WONX).equals("0") ) {
%>
                          <input type="text" name="WAGE_WONX" value="<%= WebUtil.printNumFormat(e19CongcondData.WAGE_WONX) %>" style="text-align:right" size="20" readonly> 원
<%
        } else {
%>
                          <input type="text" name="WAGE_WONX" value="" style="text-align:right" size="20" readonly>
<%
        }
    }
%>
                        </td>
                      </tr>
-->
<!--
                      <tr>
                        <th>지급율</th>
                        <td colspan="3">
                          <input type="text" name="CONG_RATE" value="<%= e19CongcondData.CONG_RATE %> " style="text-align:right" size="20" readonly> %
                        </td>
                      </tr>
-->
--%>
                      <tr>
                        <th><!-- 재해위로금액 --><spring:message code="LABEL.E.E19.0011"/></th>
                        <td colspan="3">
                          <input type="text" name="CONG_WONX" value="${dateCheck eq 'Y' ?  f:printNumFormat(resultData.CONG_WONX, 0) : ''}" style="text-align:right" size="48" readonly>
                    </td>
                  </tr>
                  <tr>
                    <th><!-- 이체은행명 --><spring:message code="LABEL.E.E20.0012"/></th>
                    <td>
                      <input type="text" name="BANK_NAME" value="${resultData.BANK_NAME}" size="48" readonly>
                    </td>
                    <th class="th02"><!-- 은행계좌번호 --><spring:message code="LABEL.E.E20.0013"/></th>
                    <td>
                      <input type="text" name="BANKN" value="${resultData.BANKN }" size="48" readonly>
                    </td>
                  </tr>
                  <tr>
                <c:choose>
                    <%-- 최초 결재자 여부 - 모든 결재자가 수정 가능 할 경우 --%>
                    <c:when test="${approvalHeader.ACCPFL eq 'X'}">
                        <tags:script>
                            <script>
                            function beforeAccept() {
                                var frm = document.form1;
                                if(!frm.chPROOF.checked) {
                                    //alert("증빙확인유무 확인 하세요");
                                    alert("<spring:message code="MSG.E.E19.0011"/>");
                                    return;
                                } else {
                                    frm.PROOF.value = frm.chPROOF.value;
                                } // end if
                                return true;
                            }
                            </script>
                            </tags:script>
                    <th><!-- 근속년수 --><spring:message code="LABEL.E.E20.0015"/></th>
                    <td  >
                      <input type="text" name="WORK_YEAR"  value="${empty resultData.WORK_YEAR || resultData.WORK_YEAR eq '00'  ? '' : f:printNum(resultData.WORK_YEAR)}" size="21" style="text-align:right" readonly> <!-- 년 --><spring:message code="LABEL.E.E20.0017"/>
                      <input type="text" name="WORK_MNTH" value="${empty resultData.WORK_MNTH || resultData.WORK_MNTH eq '00'  ? '' : f:printNum(resultData.WORK_MNTH)}"  size="21" style="text-align:right" readonly> <!-- 개월 --><spring:message code="LABEL.E.E20.0018"/>
                    </td>
                            <input type="hidden" name="PROOF"        value="${resultData.PROOF}" "${resultDate.PROOF eq 'X' ? 'checked' : '' }" value="X" >
                  <th class="th02"><!-- 증빙확인유무 --><spring:message code="LABEL.E.E19.0012"/>&nbsp;<font color="#006699"><b>*</b></font></th>
                  <td><input name="chPROOF" type="checkbox" value="X" size="30"></td>
                  </c:when>
                  <c:otherwise>
                    <th><!-- 근속년수 --><spring:message code="LABEL.E.E20.0015"/></th>
                    <td  colspan="3">
                      <input type="text" name="WORK_YEAR"  value="${empty resultData.WORK_YEAR || resultData.WORK_YEAR eq '00'  ? '' : f:printNum(resultData.WORK_YEAR)}" size="21" style="text-align:right" readonly> <!-- 년 --><spring:message code="LABEL.E.E20.0017"/>
                      <input type="text" name="WORK_MNTH" value="${empty resultData.WORK_MNTH || resultData.WORK_MNTH eq '00'  ? '' : f:printNum(resultData.WORK_MNTH)}"  size="21" style="text-align:right" readonly> <!-- 개월 --><spring:message code="LABEL.E.E20.0018"/>
                    </td>
                  </c:otherwise>
                   </c:choose>
                  </tr>
                  <c:if test="${approvalHeader.finish}">
                              <tr>
                              <th ><!-- 증빙확인유무 --><spring:message code="LABEL.E.E19.0012"/></td>
                              <td class="td09"><input name="chPROOF" type="checkbox" <c:if  test="${ resultData.PROOF eq  'X' }" >
					     			checked
					   		 </c:if>
					   disabled></td>
                              <th class="th02"><spring:message code='LABEL.E.E19.0049' /><!-- 회계전표번호 --></th>
                              <td class="td09" colaspan ="3">${resultData.BELNR }</td>
                            </tr>
                  </c:if>
            </table>
        </div>
    </div>

<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="CONG_CODE"       value="0005">
    <input type="hidden" name="RELA_CODE"       value="">
    <input type="hidden" name="EREL_NAME"       value="">
    <input type="hidden" name="RowCount_report" value="${rowCount_report }">
    <input type="hidden" name="retPage" value="${currentURL}">
    <input type="hidden" name="PERNR" value="${approvalHeader.PERNR}"/>

   <c:forEach var="row" items="${E19DisasterData_vt}" varStatus="status">
      <input type="hidden" name="DISA_RESN${status.index}" value="${row.DISA_RESN}">
      <input type="hidden" name="DISA_CODE${status.index}" value="${row.DISA_CODE}">
      <input type="hidden" name="DREL_CODE${status.index}" value="${row.DREL_CODE}">
      <input type="hidden" name="DISA_RATE${status.index}" value="${row.DISA_RATE}">
      <input type="hidden" name="CONG_DATE${status.index}" value="${f:deleteStr(row.CONG_DATE,'-')}">
      <input type="hidden" name="DISA_DESC1${status.index}" value="${row.DISA_DESC1}">
      <input type="hidden" name="DISA_DESC2${status.index}" value="${row.DISA_DESC2}">
      <input type="hidden" name="DISA_DESC3${status.index}" value="${row.DISA_DESC3}">
      <input type="hidden" name="DISA_DESC4${status.index}" value="${row.DISA_DESC4 }">
      <input type="hidden" name="DISA_DESC5${status.index}" value="${row.DISA_DESC5}">
      <input type="hidden" name="EREL_NAME${status.index}" value="${row.EREL_NAME}">
      <input type="hidden" name="INDX_NUMB${status.index}" value="${row.INDX_NUMB}">
      <input type="hidden" name="PERNR${status.index}" value="${row.PERNR}">
      <input type="hidden" name="REGNO${status.index}" value="${row.REGNO}">
      <input type="hidden" name="STRAS${status.index}" value="${row.STRAS }">
      <input type="hidden" name="AINF_SEQN${status.index}" value="${row.AINF_SEQN}">
  </c:forEach>
<!--  HIDDEN  처리해야할 부분 끝-->
    </tags-approval:detail-layout>
</tags:layout>
