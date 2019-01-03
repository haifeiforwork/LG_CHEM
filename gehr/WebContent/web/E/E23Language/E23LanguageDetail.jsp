<%/***************************************************************************************/
/*	  System Name  	: g-HR																															*/
/*   1Depth Name		: Application                                                 																	*/
/*   2Depth Name		: Benefit Management                                                														*/
/*   Program Name	: Language Fee                                             																	*/
/*   Program ID   		: E23LanguageDetail.jsp                                         															*/
/*   Description  		: 어학비 신청 상세 화면                                            																		*/
/*   Note         		: 없음                                                        																				*/
/*   Creation     		: heli                                                            																	*/
/*   Update       		: 2007-09-13 heli	   @v1.0 global hr update                          													*/
/*                         : 2009-05-13 jungin @v1.1 [C20090513_54934] 대만법인 소수점 입력 방지.                                    */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="hris.common.PersonData" %>
<%@ page import="hris.common.approval.ApprovalLineData" %>

<%
	WebUserData user = WebUtil.getSessionUser(request);

	PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
    String PERNR = (String)request.getAttribute("PERNR");

    int iFlag = 0;
    Vector vcAppLineData   = (Vector)request.getAttribute("approvalLine");

    for (int i = 0; i < vcAppLineData.size(); i++) {
    	ApprovalLineData appLineData = (ApprovalLineData) vcAppLineData.get(i);
		if(user.empNo.equals(appLineData.APPU_NUMB) && appLineData.APPR_SEQN.equals("01")){
			iFlag = 1;
			break;
		}
	}
    String E_BUKRS = PERNR_Data.E_BUKRS;

    // 반올림 변수.		2009-05-13		jungin		@v1.1 [C20090513_54934]
    int decimalNum = 2;
    if(E_BUKRS != null && (E_BUKRS == "G220" || E_BUKRS.equals("G220"))){
    	decimalNum = 0;
    }
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="decimalNum" value="<%=decimalNum %>" />
<c:set var="iFlag" value="<%=iFlag %>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >
	<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_LANG_EXPA" updateUrl="${g.servlet}hris.E.Global.E23Language.E23LanguageChangeSV">
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
                   		<th><!--Pers. Type--><spring:message code="LABEL.E.E23.0001" /></th>
                        <td>
                        <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
	                        <span id="gubn" name="gubn">
							 ${f:printOptionValueText(perType, resultData.PERS_GUBN  )}
							</span>
						</td>
                        <th class="th02"><!--Family Type--><spring:message code="LABEL.E.E23.0002" /></th>
                        <td>
<c:if test = "${resultData.FAMI_CODE ne '' }" >
						 <span id="fcode" name="fcode">
						 ${f:printOptionValueText(famiCode, resultData.FAMI_CODE )}
                 		 </span>
</c:if>
                        </td>
                 	</tr>
                 	<tr>
	                    <th><!--Name--><spring:message code="LABEL.E.E23.0003" /></th>
	                    <td colspan="3">
	                    <span id="ename" name="ename">${resultData.ENAME}</span>
	                    </td>
                    </tr>

                    <c:choose>
                    	<c:when test="${approvalHeader.finish}">
                    	<tr>
                            <th><!--Monthly Payment Limit--><spring:message code="LABEL.E.E23.0004" /></th>
                            <td>
                            	${f:printNumFormat(resultData.REIM_AMT, decimalNum) } &nbsp;${resultData.WAERS1}

                            </td>
                            <th class="th02"><!--Rest Period--><spring:message code="LABEL.E.E23.0005" /></th>
                            <td>
                            	${resultData.ZMONTH_REST} <!--Months--><spring:message code="LABEL.E.E23.0006" />
                            </td>
                        </tr>
                        <tr>
	                        <th><!--Converted Payment--><spring:message code="LABEL.E.E23.0007" /></th>
	                        <td>
	                        	${f:printNumFormat(resultData.REIM_AMTH, 2) } &nbsp;${resultData.WAERS1}
	                        	<input type="hidden" name="REIM_WAR2" value="${resultData.WAERS1}" readonly />
	                        </td>
	                        <th class="th02"><!--Payment Rate--><spring:message code="LABEL.E.E23.0008" /></th>
                            <td>
                            	${f:printNum(resultData.REIM_RAT) } &nbsp;%
                            </td>
	                       </tr>
                    	</c:when>

                    	<c:otherwise>
                    	<tr>
		                    <th>
		                    <c:choose>
	                        	<c:when test="${resultData.PERS_GUBN eq '02' }"><!--Payment Rate--><spring:message code="LABEL.E.E23.0008" /></c:when>
	                        	<c:otherwise><!--Monthly Payment Limit--><spring:message code="LABEL.E.E23.0004" /></c:otherwise>
	                       	</c:choose>
		                    </th>
		                    <td>
		                    <span id="rarest" name="rarest">
			                    <c:choose>
		                        	<c:when test="${resultData.PERS_GUBN eq '02' }">${f:printNum(resultData.REIM_RAT) } &nbsp;%</c:when>
		                        	<c:otherwise>${f:printNumFormat(resultData.REIM_AMT, decimalNum) } &nbsp;${resultData.WAERS1}	</c:otherwise>
		                       	</c:choose>
		                     </span>
		                     </td>
		                     <th class="th02"><!--Rest Period--><spring:message code="LABEL.E.E23.0005" /></th>
		                     <td>
		                     	<span id="zrest" name="zrest">
		                    	${resultData.ZMONTH_REST}
		                    	</span>
		 						<!--Months--><spring:message code="LABEL.E.E23.0006" />
		                    </td>
		                </tr>
		                <tr id="cptr" name="cptr" style="display:<c:choose><c:when test="${resultData.PERS_GUBN eq '02' }">none</c:when><c:otherwise></c:otherwise></c:choose>;" >

		                    <th><!--Converted Payment--> <spring:message code="LABEL.E.E23.0007" /></th>
		                    <td colspan="3"><span id="rcrest" name="rcrest">
	<c:if test = "${resultData.PERS_GUBN ne '02' }" >
		                    ${f:printNumFormat(resultData.REIM_AMTH, 2) } &nbsp;${resultData.WAERS1}
	</c:if>
		                    </span>
		                    </td>
	                    </tr>
                    	</c:otherwise>

                    </c:choose>

                     <tr>
                         <th><!--Education Institute--><spring:message code="LABEL.E.E23.0009" /></th>
                         <td colspan="3"><span id="sname" name="sname">${resultData.SCHL_NAME } </span></td>
                      </tr>

                      <tr>
                          <th><!--Lesson Fee--><spring:message code="LABEL.E.E23.0010" /></th>
                          <td class="td09">
                          ${f:printNumFormat(resultData.REIM_BET, decimalNum) }
                          <input type="hidden" name="REIM_BET" value="${resultData.REIM_BET}" />
                          <span id="sname" name="rwar1">${resultData.REIM_WAR }</span>
                          </td>
						  <th class="th02"><!--Payment Period--><spring:message code="LABEL.E.E23.0011" /></th>
                          <td>
							 ${resultData.COUR_PRID } <!--Months--><spring:message code="LABEL.E.E23.0006" />
                          </td>
                      </tr>
                      <tr>
                      	   <th><!--Payment Amount--><spring:message code="LABEL.E.E23.0012" /></th>
                           <td colspan="3">
                           ${f:printNumFormat(resultData.REIM_CAL, decimalNum) }   <!--  ${f:printNumFormat(resultData.CERT_BETG, decimalNum) }  -->

                           <input type="hidden" name="REIM_CAL" value="${resultData.REIM_CAL}" />

                           <span id="sname" name="rwar2">${resultData.REIM_WAR }</span>
                           </td>
                      </tr>

                      <c:if test="${approvalHeader.finish}">
                      <tr>
                      	   <th><!--회사 지급--><spring:message code="LABEL.E.E21.0030" /></th>
                           <td colspan="3">
                            ${f:printNumFormat(resultData.CERT_BETG, decimalNum) }
                           <span id="sname2" name="rwar3">${resultData.REIM_WAR }</span>
                           </td>
                      </tr>
					  <tr>
                   		  <th><!--Account Document--><spring:message code="LABEL.E.E18.0063" /></th>
                      	  <td colspan="3">${resultData.BELNR}</td>
                      </tr>
                      </c:if>

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
	                       		alert("<spring:message code='MSG.E.E19.0039' />");  //alert("Please input submit date.");
	                       	    frm.CERT_DATE.focus();
	                       	    return;
	                       	} // end if

	                       	var radios = document.getElementsByName('CERT_FLAG');
	                        for(var i =0; i<radios.length; i++){
	                        	if(radios[i].checked && radios[i].value=="N"){
	                        		alert("<spring:message code='MSG.E.E19.0041' />"); //alert("Please check document evidence");
	                              return;
	                        	}
	                        }

	                       	if(frm.CERT_BETG.value == "") {
	                       		alert("<spring:message code='MSG.E.E19.0040' />"); //alert("please input Payment Amount");
	                       	    frm.CERT_BETG.focus();
	                       	    return;
	                       	} // end if

	                        frm.CERT_DATE.value 	= removePoint(frm.CERT_DATE.value);
	                        frm.PDATE.value 			= removePoint(frm.CERT_DATE.value);
	                   	 	//frm.BEGDA.value 			= removePoint(frm.BEGDA.value);
	                        frm.CERT_BETG.value 	= frm.REIM_CAL2.value;
	                        frm.CERT_BETG.value 	= removeComma(frm.CERT_BETG.value);
	                        frm.REIM_BET.value 	    = removeComma(frm.REIM_BET.value);
	                        frm.REIM_CAL.value 	    = removeComma(frm.REIM_CAL.value);

	                        return true;
                       }

                       function beforeReject() {
	                       var frm = document.form1;

	                       frm.CERT_DATE.value	    = removePoint(frm.CERT_DATE.value);
	                  	   //frm.BEGDA.value 			= removePoint(frm.BEGDA.value);
	                       frm.PDATE.value 			= removePoint(frm.CERT_DATE.value);
	                       frm.CERT_BETG.value 	=  frm.REIM_CAL2.value;
	                       frm.CERT_BETG.value 	=  removeComma(frm.CERT_BETG.value);
	                       frm.REIM_BET.value 	    =  removeComma(frm.REIM_BET.value);
	                       frm.REIM_CAL.value 	    =  removeComma(frm.REIM_CAL.value);

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
	              		<th><!--Submit Date--><spring:message code="LABEL.E.E18.0065" /></th>
	              		<td>
		                     <input type="text" class="date" id="CERT_DATE" name="CERT_DATE" size="10" value="">
		                     <input type="hidden" name="PDATE" value=""/>
	                    </td>
	                </tr>

	                <tr>
	              		<th><!--Payment Amount--><spring:message code="LABEL.E.E21.0030" /></th>
	              		<td colspan="3">
	              		<c:choose>
	              			<c:when test="${iFlag eq '1'}">
	              				<input type="text" name="REIM_CAL2"  style="text-align:right;" size="10" onkeyup="moneyChkEventForWorld(this);" value="${f:printNumFormat(resultData.REIM_CAL, decimalNum)}" />
	              			</c:when>
	              			<c:otherwise>
	              				<input type="text" name="REIM_CAL2"  style="text-align:right;" size="10" onkeyup="moneyChkEventForWorld(this);" value="${f:printNumFormat(resultData.CERT_BETG, decimalNum)}" class="noBorder" readonly />
	              			</c:otherwise>
              			</c:choose>&nbsp;

	              		<input type="text" name="REIM_WAR" size="4"  value="${resultData.REIM_WAR}" class="noBorder" readonly>
	              		<input type="hidden" name="CERT_BETG" value="${resultData.CERT_BETG}"  />
	              		</td>
	                </tr>

                </table> <!--  end tableGeneral -->
             </div>  <!--  end table -->
        </div>   <!--  end tableArea -->

        </c:if>

    </tags-approval:detail-layout>
</tags:layout>