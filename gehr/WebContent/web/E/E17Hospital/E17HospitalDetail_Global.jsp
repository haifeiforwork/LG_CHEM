<%/***************************************************************************************/
/*	  System Name  	: g-HR																															*/
/*   1Depth Name		: Application                                                 																	*/
/*   2Depth Name		: Benefit Management                                                														*/
/*   Program Name	: Medical Fee                                             																		*/
/*   Program ID   		: E17HospitalDetail.jsp                                         																*/
/*   Description  		: 의료비 신청 상세 화면                                            																		*/
/*   Note         		:                                                            	 																	*/
/*   Creation     		: 2002-01-08 김성일                                          																		*/
/*   Update       		: 2005-02-16 윤정현                                          																		*/
/*                  		: 2005-12-26 @v1.1 [C2005121301000001097] 신용카드/현금구분추가											*/
/*                  		: 2006-01-19 @v1.2 연말정산제외 제거 연말정산반영액추가      														*/
/*   Update       		: 2009-05-13 jungin @v1.3 [C20090513_54934] 대만법인 소수점 입력 방지.									*/
/*							: 2009-05-21 jungin @v1.4 [C20090514_56175] 보험가입 여부 'ZINSU' 필드 추가.							*/
/*	  Update             : 2013-12-19 lixinxin @v1.5 [C20131211_51591] 医疗申请画面增加字段*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="hris.common.PersonData" %>
<%
WebUserData user = WebUtil.getSessionUser(request);

	PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
	String PERNR = (String)request.getAttribute("PERNR");

    String E_BUKRS = PERNR_Data.E_BUKRS;

    // 반올림 변수.		2009-05-13		jungin		@v1.3 [C20090513_54934]
    int decimalNum = 2;
    if(E_BUKRS != null && (E_BUKRS == "G220" || E_BUKRS.equals("G220"))){
    	decimalNum = 0;
    }
%>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="decimalNum" value="<%=decimalNum %>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >

	<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_MEDI_EXPA" updateUrl="${g.servlet}hris.E.Global.E17Hospital.E17HospitalChangeSV">
    <%-- 결재 승인 및 반려시 의견 입력시 화면에 정보성으로 보여줄 내용
        <tags:script>
            <script>
                $(function() {
                    /* 승인 부 */
                    $("#-accept-dialog").dialog({
                        open : function() {
                            $("#-accept-info").text("결재 승인 창 상단에 보여줄 텍스트 입력하세요.");
                        }
                    });
                    /* 반려 부 */
                    $("#-reject-dialog").dialog({
                        open : function() {
                            $("#-reject-info").text("결재 승인 창 상단에 보여줄 텍스트 입력하세요.");
                        }
                    });
                });
            </script>
        </tags:script>
        --%>
        <%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>

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
                        <th><span class="textPink">*</span><!--Name--><spring:message code="LABEL.E.E18.0004" /></th>
                        <td colspan="3">${resultData.ENAME}</td>
                    </tr>
                    <tr>
                        <th><!--Examination Date--><spring:message code="LABEL.E.E18.0005" /></th>
                        <td><c:out value='${f:printDate(resultData.EXDATE)}'/></td>
                        <th class="th02"><!--Medical Type--><spring:message code="LABEL.E.E18.0012" /></th>
                        <td>${f:printOptionValueText(mediCodeList, resultData.MTYPE  )}</td>
                    </tr>

                    <tr>
						<th><span class="textPink">*</span><!--Treatment Location--><spring:message code="LABEL.E.E18.0046" /></th>
                       	<td colspan="3">${resultData.MED_LOCATION}</td>
                     </tr>

                    <c:if test="${resultData.MED_LOCATION eq 'Korea' }">
                    <tr id="reason">
                        <th><span class="textPink">*</span><!--Reason--><spring:message code="LABEL.E.E18.0061" /></th>
                        <td>${resultData.MED_REASON}</td>
                        <th class="th02"><!--Elian Approval--><spring:message code="LABEL.E.E18.0049" /></th>
                        <td>${resultData.MED_ELIANAPR}</td>
                    </tr>
                    </c:if>

                    <tr>
						<th><span class="textPink">*</span><!--Medical Type--><spring:message code="LABEL.E.E18.0012" /></th>
						<td colspan="3">${resultData.MED_TYPE}</td>
					</tr>
                     <tr>
                   		<th><span class="textPink">*</span><!--Prescription--><spring:message code="LABEL.E.E18.0053" /></th>
                   		<td>${resultData.MED_PRESCRIPTION}</td>
                   	 	<th class="th02"><span class="textPink">*</span><!--Diagnosis Certificate--><spring:message code="LABEL.E.E18.0054" /></th>
                   		<td>${resultData.MED_DIAGNOSIS}</td>
                   	</tr>
					<!--2013-12-19 lixinxin @v1.5 [C20131211_51591] 医疗申请画面增加字段 end -->
                     <tr>
                       	<th><span class="textPink">*</span><!--Disease Name--><spring:message code="LABEL.E.E18.0006" /></th>
                       	<td colspan="3">${resultData.DISEASE}</td>
                     </tr>
                     <tr>
                       <th><!--Conditions of Illness--><spring:message code="LABEL.E.E18.0055" /></th>
                       <td colspan="3"><textarea cols="110" rows="4" name="LLINESS" style="border:none;padding-top:2px;overflow:hidden" value="" size="100" readonly>${resultData.LLINESS1}${resultData.LLINESS2}${resultData.LLINESS3}</textarea></td>
                     </tr>
                     <tr>
                         <th><!--Balance Amount--><spring:message code="LABEL.E.E18.0056" /></th>
                         <td><span id="PAMT" name="PAMT">${f:printNumFormat(resultData.PAMT_BALANCE, 2)}</span> ${resultData.WAERS1}</td>
                         <th class="th02"><!--Insurance--><spring:message code="LABEL.E.E18.0062" /></th>
                         <td>
                       		  <c:choose>
	                        	  <c:when test="${resultData.ZINSU eq 'In' }">In</c:when>
	                        	  <c:otherwise>Out</c:otherwise>
                        	  </c:choose>
                         </td>
                     </tr>
                     <tr>
                          <th><!--Total Paid Amount--><spring:message code="LABEL.E.E18.0057" /></th>
                          <td colspan="3">
                          	<span id="PAAMT_BALANCE" name="PAAMT_BALANCE">

                          	<c:choose>
	                        	  <c:when test="${approvalHeader.finish}">${f:printNumFormat(resultData.CERT_BETG_C, 2)}</c:when>
	                        	  <c:otherwise>${f:printNumFormat(resultData.PAAMT_BALANCE, 2)}</c:otherwise>
                        	</c:choose>
                          	</span>
                          ${resultData.WAERS1}
                          </td>
                      </tr>
                      <tr>
                          <th><!--Medical Expense--><spring:message code="LABEL.E.E18.0007" /></th>
                          <td colspan="3"> ${f:printNumFormat(resultData.EXPENSE, decimalNum)} ${resultData.WAERS}</td>
                      </tr>

                      <c:if test="${!approvalHeader.finish}">
                      <tr>
                          <th><!--Converted Amount--><spring:message code="LABEL.E.E18.0058" /></th>
                          <td colspan="3">${f:printNumFormat(resultData.PAAMT, 2)}  ${resultData.WAERS1} </td>
                      </tr>
                      </c:if>

                      <c:if test="${approvalHeader.finish}">
					  <tr>
                   		  <th><!--Payment Amount--><spring:message code="LABEL.E.E21.0030" /></th>
                      	  <td colspan="3">${f:printNumFormat(resultData.CERT_BETG, decimalNum) }  ${resultData.WAERS}</td>
                      </tr>
					  <tr>
                   		  <th><!--Account Document--><spring:message code="LABEL.E.E18.0063" /></th>
                      	  <td colspan="3">${resultData.BELNR}</td>
                      </tr>
                      </c:if>

                      <c:forEach var="row" items="${E17HdataFile_vt}" varStatus="status">
					  <tr>
		              		<th><!--Attachment File --><spring:message code="LABEL.E.E21.0022" /></th>
		              		<td colspan="3">
		              		<a href="<c:out value='${g.servlet}'/>hris.common.DownloadedFile?fileName=<c:out value='${row.FILE_NM}'/><c:out value='${row.FILE_TYPE}'/>&filePath=<c:out value='${row.FILE_PATH}'/>"><c:out value='${row.FILE_NM}'/></a>
		              		</td>
		              </tr>
					  </c:forEach>

                </table>

            </div><!--  end table -->

            <!-- 상단 입력 테이블 끝-->
        </div> <!--  end tableArea -->

        <%-- 결재자이거나 결재가 진행된 상태 일 경우 보여준다  --%>
        <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
        <!--   c:if test="${approvalHeader.showManagerArea}"  첫번째 결재자 경우 -->
        <c:if test="${approvalHeader.ACCPFL eq 'X'}">
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                <tags:script>
	                <script>

                        function beforeAccept() {
	                       	var frm = document.form1;
	                       	if(frm.CERT_DATE.value == "") {
	                       		alert("<spring:message code='MSG.E.E19.0039' />"); // alert("Please input submit date.");
	                       	    frm.CERT_DATE.focus();
	                       	    return;
	                       	} // end if
	                       	var radios = document.getElementsByName('CERT_FLAG');
	                        for(var i =0; i<radios.length; i++){
	                        	if(radios[i].checked && radios[i].value=="N"){
	                        		alert("<spring:message code='MSG.E.E19.0041' />"); //alert("Please check document evidence.");
	                                 return;
	                           	}
	                         }// end if
	                       	if(frm.CERT_BETG.value == "") {
	                       		alert("<spring:message code='MSG.E.E19.0040' />"); //alert("please input Reimburse Amount");
	                       	    frm.CERT_BETG.focus();
	                       	    return;
	                       	} // end if

	                        frm.CERT_DATE.value		= removePoint(frm.CERT_DATE.value);
	                        frm.PDATE.value 				= removePoint(frm.CERT_DATE.value);
	                       	frm.CERT_BETG.value 		=  removeComma(frm.CERT_BETG.value);

	                        return true;
                       }

                       function beforeReject() {
	                       var frm = document.form1;
	                       frm.CERT_DATE.value		= removePoint(frm.CERT_DATE.value);
	                       frm.PDATE.value 				= removePoint(frm.CERT_DATE.value);
	                       frm.CERT_BETG.value 		=  removeComma(frm.CERT_BETG.value);

                           return true;
                       }
	                   </script>
	                </tags:script>
	                <colgroup>
	            		<col width="15%" />
	            		<col width="30%" />
	            		<col width="15%" />
	            		<col width="" />
	            	</colgroup>

                    <tr>
	              	    <th><!--Document Evidence--><spring:message code="LABEL.E.E18.0064" /></th>
	              		<td>
	              			<input type="radio" name="CERT_FLAG" value="Y" >Yes
	                        &nbsp;&nbsp;
	                        <input type="radio" name="CERT_FLAG" value="N"  checked >No
	              		</td>
	              		<th class="th02"><!--Submit Date--><spring:message code="LABEL.E.E18.0065" /></th>
	              		<td>
		                     <input type="text" class="date" id="CERT_DATE" name="CERT_DATE" size="10" value="">
		                     <input type="hidden" name="PDATE" value=""/>
	                    </td>
	                </tr>

	                <tr>
	              		<th><!--Payment Amount--><spring:message code="LABEL.E.E21.0030" /></th>
	              		<td colspan="3">
                            <c:choose>
                                <c:when test="${approvalHeader.chargeManager}">
                                    <input type="text" name="CERT_BETG" size="10" readonly style="text-align:right;"
                                           value="${f:printNumFormat(resultData.CERT_BETG, decimalNum)}" />&nbsp;
                                </c:when>
                                <c:otherwise>
                                    <input type="text" name="CERT_BETG" size="10"  style="text-align:right;"
                                           onkeyup="moneyChkEventForWorld(this);" value="${f:printNumFormat(resultData.EXPENSE, decimalNum)}" />&nbsp;
                                </c:otherwise>
                            </c:choose>
	              		<input type="text" value="${resultData.WAERS}" class="noBorder" size="4" readonly />
	              		</td>
	                </tr>

                  </table> <!--  end tableGeneral -->
             </div>  <!--  end table -->
        </div>   <!--  end tableArea -->

        </c:if>

    </tags-approval:detail-layout>
</tags:layout>

