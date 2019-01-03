<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 장학자금 조회                                               */
/*   Program ID   : E21ExpenseDetail.jsp                                        */
/*   Description  : 학자금/장학금 조회할 수 있도록 하는 화면                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-01  윤정현                                          */
/*						  2014-10-24  @v.1.5 SJY 신청유형:장학금인 경우에만 시스템 수정 [CSR ID:2634836] 학자금 신청 시스템 개발 요청		*/
/*                      2018-01-11  cykim  [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건        */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="hris.common.PersonData" %>
<%@ page import="hris.E.E21Expense.E21ExpenseData" %>

<%
	WebUserData user = WebUtil.getSessionUser(request);
    E21ExpenseData e21ExpenseData = (E21ExpenseData)request.getAttribute("e21ExpenseData");

    Vector currency_vt = (Vector)request.getAttribute("currency_vt");
    // E21ExpenseChkData e21ExpenseChkData = (E21ExpenseChkData)request.getAttribute("e21ExpenseChkData");

    //  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize  = 2;
    double currencyDecimalSize1 = 2;
    int    currencyValue  = 0;
    int    currencyValue1 = 0;
    //Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();

    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e21ExpenseData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }

        if( e21ExpenseData.WAERS1.equals(codeEnt.code) ){
            currencyDecimalSize1 = Double.parseDouble(codeEnt.value);
        }
    }

    currencyValue  = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
    currencyValue1 = (int)currencyDecimalSize1; //???  KRW -> 0, USDN -> 5
    //  통화키에 따른 소수자리수를 가져온다

    String RequestPageName2 = (String)request.getAttribute("RequestPageName2");

%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="currencyValue" value="<%=currencyValue%>" />
<c:set var="currencyValue1" value="<%=currencyValue1%>" />
<c:set var="print_count" value="<%=e21ExpenseData.P_COUNT%>" />
<c:set var="RequestPageName2" value="<%=RequestPageName2%>" />

<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
    <li><a onclick="go_print();" ><span><spring:message code="LABEL.E.E22.0046" /><!-- 학자금.장학금 신청서 --></span></a></li>
</tags:body-container>

<tags:layout css="ui_library_approval.css" script="dialog.js" >
	<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_TUTI_FEE" updateUrl="${g.servlet}hris.E.E21Expense.E21ExpenseChangeSV"  button="${buttonBody}">
    	<tags:script>
			<script>
			//alert('333='+'${msgFLAG}' );
			//alert('msgTEXT='+'${resultData.SUBF_TYPE}' );
			jQuery(function(){
				on_Load();
			});

			function on_Load() {

			    if( document.form1.RequestPageName2.value == "" ) {
			        //  신청 후 조회된 경우 - 학자금ㆍ장학금 신청서를 먼저 띄워준다.
			        go_print();
			    }

			<c:if test="${resultData.SUBF_TYPE eq '3' }">
				document.getElementById("TYPE_3").style.display="";
		        document.getElementById("TYPE_3_1").style.display="";
		        /* [CSR ID:3569058] 신청유형이 장학금인 경우 학과필드 display  start*/
		        $("#FRTXT").show();
		        /* [CSR ID:3569058] 신청유형이 장학금인 경우 학과필드 display end*/

				<c:if test="${resultData.ABRSCHOOL ne 'X' }">
					        document.getElementsByName("SCHCODE")[0].style.display="inline-block";
				</c:if>

			</c:if>
			}

			function go_print(){

				var target_name="essPrintWindow";
				var _open_popup = window.open("", target_name, "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=740,height=650,left=100,top=60");

				document.form1.jobid.value = "search";
			    document.form1.target = target_name;//"essPrintWindow";
			    document.form1.action = '${g.servlet}hris.E.E21Expense.E21ExpenseDetailSV';
			    document.form1.method = "post";
			    document.form1.submit();
			    document.form1.target = "";
			}

			</script>
		</tags:script>
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

	            	<c:choose>
                	<c:when test="${msgFLAG ne '' }">
					<tr>
		                <td align="center" colspan="4">
		                   <br/>${msgTEXT}<br/><br/>
		                </td>
	                </tr>
                	</c:when>
                	<c:otherwise>
                	<tr>
                		<th><!-- 가족선택 --><spring:message code="LABEL.E.E22.0038" /></th>
                		<td colspan="3">
                			<input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}"  />
                          	<input type="text" name="FAMSA" value="${resultData.FAMSA}" size="5" class="noBorder" readonly/>
                          	<input type="text" name="ATEXT" value="${resultData.ATEXT}" size="10" class="noBorder" readonly/>
                		</td>
                	</tr>

                	<tr>
                		<th><!-- 신청유형 --><spring:message code="LABEL.E.E22.0039" /></th>
                		<td>
               			<c:choose>
                			<c:when test="${ resultData.SUBF_TYPE eq '2'  }">
                				<input type="text" name="SUBF_TYPE" value="<spring:message code="LABEL.E.E22.0040" />" size="7" class="noBorder" readonly /><!--학자금 -->
                			</c:when>
                			<c:otherwise>
                				<input type="text" name="SUBF_TYPE" value="<spring:message code="LABEL.E.E22.0041" />" size="7" class="noBorder" readonly /><!--장학금 -->
                			</c:otherwise>
               			</c:choose>
                		</td>
                		<th class="th02"><!-- 신청년도 --><spring:message code="LABEL.E.E22.0024" /></th>
                		<td>
                			<input type="text" name="PROP_YEAR" value="${resultData.PROP_YEAR}" style="text-align:center" size="10" class="noBorder" readonly/>
                		</td>
                	</tr>

                	<tr>
                        <th><!-- 신청구분 --><spring:message code="LABEL.E.E22.0042" /></th>
                        <td>
                          <input type="radio" name="radiobutton" value="신규분" <c:if test = "${resultData.PAY1_TYPE eq 'X' }" >checked</c:if> disabled />
                          	<!-- 신규분 --><spring:message code="LABEL.E.E22.0022" />
                          <input type="radio" name="radiobutton" value="추가분" <c:if test = "${resultData.PAY2_TYPE eq 'X' }" >checked</c:if> disabled />
                          	<!-- 추가분 --><spring:message code="LABEL.E.E22.0023" />
                        </td>
                        <th class="th02"><!-- 신청분기ㆍ학기 --><spring:message code="LABEL.E.E22.0025" /></th>
                        <td>
                        <c:choose>
                			<c:when test="${ resultData.SUBF_TYPE eq '2'  }">

                				<c:if test = "${resultData.PERD_TYPE ne '0' }" >
                					<input type="text" name="TYPE" value="${resultData.PERD_TYPE} 분기" style="text-align:center" size="10" class="noBorder" readonly/>
                				</c:if>

                			</c:when>
                			<c:otherwise>
                				<c:if test = "${resultData.HALF_TYPE ne '0' }" >
                					<input type="text" name="TYPE" value="${resultData.HALF_TYPE} 학기" style="text-align:center" size="10" class="noBorder" readonly/>
                				</c:if>

                			</c:otherwise>
               			 </c:choose>
                         </td>
                     </tr>

                     <tr>
                         <th><!-- 이름 --><spring:message code="LABEL.E.E22.0017" /></th>
                         <td colspan="3">
                         	  <input type="text" name="full_name" value="<c:out value='${fn:trim(resultData.LNMHG)}'/> <c:out value='${fn:trim(resultData.FNMHG)}'/>" size="14" class="noBorder" readonly/>
                         </td>
                      </tr>
                      <tr>
                		  <th><!-- 학력 --><spring:message code="LABEL.E.E22.0026" /></th>
                		  <td colspan="3">
                          	  <input type="text" name="ACAD_CARE" value="${resultData.ACAD_CARE}" size="5" class="noBorder" readonly />
                          	  <input type="text" name="STEXT" value="${resultData.STEXT}" size="20" class="noBorder" readonly />
                		  </td>
               		  </tr>

               		  <tr>
                		  <th><!-- 교육기관 --><spring:message code="LABEL.E.E22.0027" /></th>
                		  <td>
                		  	   <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                        	   <input type="text" name="SCHCODE" value="${resultData.SCHCODE}"  class="noBorder" size="9" readonly style="display:none">
                        	   <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                          	   <input type="text" name="FASIN" value="${resultData.FASIN}" class="noBorder" size="30" readonly />
                		  </td>
                		  <th class="th02"><!-- 학년 --><spring:message code="LABEL.E.E22.0029" /></th>
                		  <td>
                		  	  <input type="text" name="ACAD_YEAR" value="${resultData.ACAD_YEAR eq '0' ? '' : resultData.ACAD_YEAR}" style="text-align:center" size="10" class="noBorder" readonly />
                		  	  <!-- 학년 --><spring:message code="LABEL.E.E22.0029" />
                		  </td>
               		  </tr>

					  <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 start -->
					  <tr id="FRTXT" style="display:none;">
	                      <th><!-- 학과 --><spring:message code="LABEL.E.E22.0047" /></th>
	                      <td colspan="3">
		               	  		<input type="text" name="FRTXT" value="${resultData.FRTXT}" class="noBorder" style="text-align:left" size="31" readonly/>
	                      </td>
	                  </tr>
					  <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 end -->

               		  <tr>
                          <th><!-- 신청액 --><spring:message code="LABEL.E.E22.0018" /></th>
                          <td>
	                          <input type="text" name="PROP_AMNT" value="${f:printNumFormat(resultData.PROP_AMNT, currencyValue) }" style="text-align:right" size="12" class="noBorder" readonly/>
	                          ${resultData.WAERS}
                          </td>
                          <th class="th02"><!-- 수혜횟수 --><spring:message code="LABEL.E.E22.0030" /></th>
                          <td>
                          	  <input type="text" name="P_COUNT" value="${f:printNum(print_count)}" style="text-align:center" size="10" class="noBorder" readonly/> <!-- 회 --><spring:message code="LABEL.E.E22.0037" />
                          </td>
                      </tr>

                      <tr>
                          <th><!-- 입학금 --><spring:message code="LABEL.E.E22.0028" /></th>
                          <td>
                          	  <input type="checkbox" name="ENTR_FIAG" value="X" size="20" class="noBorder" <c:if test = "${resultData.ENTR_FIAG eq 'X' }" >checked</c:if> disabled />
                          </td>

                          <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                          <th class="th02" ><div  id="TYPE_3" style="display:none;"><!-- 유학 학자금 --><spring:message code="LABEL.E.E22.0031" /></div> </th>
                          <td>
                          	  <div id="TYPE_3_1" style="display:none;" >
                          	  <input type="checkbox" name="ABRSCHOOL" value="X" size="20" class="noBorder" <c:if test = "${resultData.ABRSCHOOL eq 'X' }" >checked</c:if> disabled />
                          	  </div>
                          </td>
                          <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->

                      </tr>

                      <c:if test="${approvalHeader.AFSTAT eq '03' && ! ( approvalHeader.DMANFL eq '01' || approvalHeader.DMANFL eq '02' )  }">
                      <tr>
                          <th><!-- 회사지급액 --><spring:message code="LABEL.E.E22.0019" /></th>
                          <td colspan ="3">
	                          <input type="text" name="PAID_AMNT" value="${f:printNumFormat(resultData.PAID_AMNT, currencyValue1) }" style="text-align:right" size="12" class="noBorder" readonly/>
	                          ${resultData.WAERS1}
                        </td>
                      </tr>
                      <tr>
                          <th><!-- 연말정산반영액 --><spring:message code="LABEL.E.E22.0032" /></th>
                          <td colspan ="3">
                              <input type="text" name="YTAX_WONX" value="${f:printNumFormat(resultData.YTAX_WONX, currencyValue1) }" style="text-align:right" size="12" class="noBorder" readonly/>&nbsp;KRW
                          </td>
                      </tr>
                      </c:if>

					   <c:choose>
	           		   <c:when test="${approvalHeader.DMANFL eq '01' || approvalHeader.DMANFL eq '02'}">
	          		  	<tr>
                  	    	<td colspan="4"><h2 class="subtitle">담당자 정보</h2></td>
                     	</tr>
	          		  	<tr>
		                    <th><!-- 회사지급액 --><spring:message code="LABEL.E.E22.0019" /></th>
		                    <td> ${f:printNumFormat(resultData.PAID_AMNT, currencyValue1) } ${resultData.WAERS1}</td>
		                    <th class="th02"><!-- 연말정산반영액 --><spring:message code="LABEL.E.E22.0032" /></th>
		                    <td>${f:printNumFormat(resultData.YTAX_WONX, currencyValue1) }</td>
	                 	</tr>
	                 	<tr>
		                    <th><!-- 증빙제출일 --><spring:message code="LABEL.E.COMMON.0003" /></th>
		                    <td colspan="3">
		                    	${f:printDate(resultData.PAID_DATE) }
		                    	<input type="hidden" name="PAID_AMNT"    value="${resultData.PAID_AMNT}">
		                        <input type="hidden" name="WAERS1"       value="${resultData.WAERS1}">
		                        <input type="hidden" name="YTAX_WONX"    value="${resultData.YTAX_WONX}">
		                        <input type="hidden" name="PAID_DATE"    value="${resultData.PAID_DATE}">
		                    </td>
	                 	</tr>
	                 	</c:when>
	                 	<c:otherwise>

	                 		<tr>
	                          <th><!-- 비고 --><spring:message code="LABEL.E.E22.0036" /></th>
	                          <td colspan="3">
	                              <input type="text" name="BIGO_TEXT1" value="${resultData.BIGO_TEXT1}" style="text-align:left" size="70" class="noBorder" readonly />
	                      	  </td>
	                      </tr>
	                      <tr>
	                          <th>&nbsp;</th>
	                          <td colspan="3">
	                          	  <input type="text" name="BIGO_TEXT2" value="${resultData.BIGO_TEXT2}" style="text-align:left" size="70" class="noBorder" readonly />
	                          </td>
	                      </tr>
	                 	</c:otherwise>

	                 	</c:choose>

				      <input type="hidden" name="subty"       value="${resultData.FAMSA}">
			    	  <input type="hidden" name="objps"       value="${resultData.OBJC_CODE}">
				      <input type="hidden" name="subf_type"   value="${resultData.SUBF_TYPE}">
				      <input type="hidden" name="RequestPageName2" value="${RequestPageName2}">

                	</c:otherwise>
                	</c:choose>

            	</table>
            </div><!--  end table -->

            <div class="commentsMoreThan2">
        	<div> ※ <spring:message code="LABEL.E.E22.0045" /><!--학자금ㆍ장학금 신청서를 출력한 후 증빙서류를 첨부하여 각 지역별 주관부서로 제출해 주시기 바랍니다.--></div>

        	</div>

            <!-- 상단 입력 테이블 끝-->
        </div> <!--  end tableArea -->

	</tags-approval:detail-layout>
</tags:layout>
