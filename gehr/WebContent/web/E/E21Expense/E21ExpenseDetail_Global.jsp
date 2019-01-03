<%/***************************************************************************************/
/*	  System Name  	: g-HR																															*/
/*   1Depth Name		: Application                                                 																	*/
/*   2Depth Name		: Benefit Management                                                														*/
/*   Program Name	: Tuition Fee                                             																		*/
/*   Program ID   		: E21ExpenseDetail.jsp                                         																*/
/*   Description  		: 장학금 신청 상세 화면                                            																		*/
/*   Note         		: 없음                                                        																				*/
/*   Creation     		: 2002-01-03 김성일                                          																		*/
/*   Update       		: 2005-03-01 윤정현                                          																		*/
/*   Update				: 2007-10-12 heli @v1.0 global hr update                                                           					*/
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
    WebUserData  user = (WebUserData)session.getAttribute("user");
    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");

    //E21ExpenseData e21ExpenseData = (E21ExpenseData)request.getAttribute("e21ExpenseData");

    String PERNR = (String)request.getAttribute("PERNR");
    String E_BUKRS = PERNR_Data.E_BUKRS;

    // 반올림 변수.		2009-05-13		jungin		@v1.1 [C20090513_54934]
    int decimalNum = 2;
    if(E_BUKRS != null && (E_BUKRS == "G220" || E_BUKRS.equals("G220"))){
    	decimalNum = 0;
    }

    int iFlag = 0;
    Vector vcAppLineData   = (Vector)request.getAttribute("approvalLine");

    for (int i = 0; i < vcAppLineData.size(); i++) {
    	ApprovalLineData appLineData = (ApprovalLineData) vcAppLineData.get(i);
		if(user.empNo.equals(appLineData.APPU_NUMB) && appLineData.APPR_SEQN.equals("01")){
			iFlag = 1;
			break;
		}
	}

%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="decimalNum" value="<%=decimalNum %>" />
<c:set var="iFlag" value="<%=iFlag %>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >
	<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_TUTI_EXPA" updateUrl="${g.servlet}hris.E.Global.E21Expense.E21ExpenseChangeSV">
    	<tags:script>
			<script>

			jQuery(function(){
				loads();
			});

			function loads(){
			 	var tem= '${resultData.SUBTY}';
				if(tem=='0003'){
					document.getElementById("entrancefee").style.display="none";
					document.getElementById("lessionfee").style.display="none";
					document.getElementById("attendingfee").style.display="none";
					document.getElementById("contribution").style.display="none";
				}else if(tem=='0004'){
					document.getElementById("entrancefee").style.display="";
					document.getElementById("tuitionfee").style.display="";
					document.getElementById("lessionfee").style.display="";
					document.getElementById("attendingfee").style.display="none";
					document.getElementById("contribution").style.display="none";
				}else{
					document.getElementById("entrancefee").style.display="";
					document.getElementById("tuitionfee").style.display="";
					document.getElementById("lessionfee").style.display="";
					document.getElementById("attendingfee").style.display="";
					document.getElementById("contribution").style.display="";
				}
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

	            	<tr>
		                <th><!--Name--><spring:message code="LABEL.E.E21.0001" /></th>
		                <td colspan="3">
		                	<input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
		                    <input type="text" name="CHLD_NAME" value="${resultData.CHLD_NAME}" size="40" class="noBorder" readonly>

	                    <span class="commentOne"><spring:message code="LABEL.E.E21.0003" /><!--Please&nbsp; register&nbsp; your&nbsp; families&nbsp;first. &nbsp;(Menu &nbsp;:&nbsp;Personnel &nbsp;HR &nbsp;Info&nbsp; -> &nbsp;Family)--></span>
	               	 	</td>
	               </tr>

	               <tr>
                        <th><!--School--><spring:message code="LABEL.E.E21.0004" /></th>
                        <td>
							${f:printOptionValueText(schoolsKind, resultData.SUBTY)}
                        </td>
                        <th class="th02">
	                        <c:if test = "${resultData.ATTC_NORL ne '' }" >
	                        	<!--Attachment--><spring:message code="LABEL.E.E21.0027" /> &nbsp;
	                        </c:if>
                        </th>
                        <td>
	                        <c:if test = "${resultData.ATTC_NORL ne '' }" >
	                        <input type="radio" name="ATTC_NORL" value="N" <c:if test = "${resultData.ATTC_NORL eq 'N' }" >checked</c:if> disabled><!--Normal--><spring:message code="LABEL.E.E21.0026" />&nbsp;&nbsp;&nbsp;
	                        <input type="radio" name="ATTC_NORL" value="A" <c:if test = "${resultData.ATTC_NORL eq 'A' }" >checked</c:if> disabled><!--Attachment--><spring:message code="LABEL.E.E21.0027" />&nbsp;&nbsp;&nbsp;&nbsp;
							</c:if>
                        </td>
                    </tr>

                    <tr>
                        <th><!--School Type--><spring:message code="LABEL.E.E21.0005" /></th>
                        <td>
							${f:printOptionValueText(schoolsType, resultData.SCHL_TYPE)}
                        </td>
                        <th class="th02"><!--School Name--><spring:message code="LABEL.E.E21.0006" /></th>
                        <td>
							<input type="text" name="SCHL_NAME" value="${resultData.SCHL_NAME}" size="20" class="noBorder" readonly />
                        </td>
                    </tr>

                    <tr>
                        <th><!--Grade--><spring:message code="LABEL.E.E21.0007" /></th>
                        <td>
                        	<input type="text" name="SCHL_GRAD" value="${resultData.SCHL_GRAD}" size="2" maxlength="2" style="text-align:right" class="noBorder" readonly>&nbsp;<!--Grade--><span class="inputText"><spring:message code="LABEL.E.E21.0007" /></span>
                        	<input type="text" name="TERM_TEXT" style="text-align:right" value="${resultData.TERM_TEXT}" size="2" maxlength="2" class="noBorder" readonly>&nbsp;<!--Term--><span class="inputText"><spring:message code="LABEL.E.E21.0009" /></span>
                       	</td>
                        <th class="th02"><!--Period--><spring:message code="LABEL.E.E21.0008" /></th>
                        <td>
							<input type="text" name="TERM_BEGD" value="${f:printDate(resultData.TERM_BEGD)}" size="10" class="noBorder" readonly>~
							<input type="text" name="TERM_ENDD" value="${f:printDate(resultData.TERM_ENDD)}" size="10" class="noBorder" readonly>
                        </td>
                      </tr>

                      <tr>
	                        <th><!--Rest Period--><spring:message code="LABEL.E.E21.0010" /></th>
	                        <td><input type="text" name="REIM_CNTH_REST" style="text-align:right;" value="${resultData.REIM_CNTH_REST}" size="2" class="noBorder" readonly>&nbsp;
	                        <!--Times--><span class="inputText"><spring:message code="LABEL.E.E21.0023" /></span>
	                        </td>
	                        <th class="th02">
	                       		<c:if test = "${ (resultData.REIM_AMTH_REST ne '') && (resultData.REIM_AMTH_REST ne '0') }" >
	                        	<!--Balance--><spring:message code="LABEL.E.E21.0028" />
	                        	</c:if>
	                        </th>
	                        <td>
		                        <input type="text" name="REIM_AMTH_REST" style="text-align:right;" value="${f:printNumFormat(resultData.REIM_AMTH_REST, 2) }" size="20" class="noBorder" readonly/>&nbsp;
		                        <input type="text" name="WAERS" value="${resultData.WAERS}" size="5" class="noBorder" readonly />
	                        </td>
                      </tr>
        		</table>
            </div><!--  end table -->
            <!-- 상단 입력 테이블 끝-->
        </div> <!--  end tableArea -->

        <div class="listArea">
	       	<div class="table">
	        	<table class="listTable">
	          		<tr>
	                	<th class="divide"><!--Application Fee Type--><spring:message code="LABEL.E.E21.0011" /></th>
	                    <th><!--Application Amount--><spring:message code="LABEL.E.E21.0012" /></th>
	                    <th><!--Payment Rate--><spring:message code="LABEL.E.E21.0013" /></th>
	                    <th class="lastCol"><!--Payment Amount--><spring:message code="LABEL.E.E21.0029" /></th>
	            	</tr>

	            	<tr class="oddRow" id="entrancefee" name="entrancefee">
	            		<td class="divide"><!--Entrance Fee--><spring:message code="LABEL.E.E21.0015" /></td>
		                <td>
			                <input type="text" name="REIM_BET1" style="text-align:right;" value="${f:printNumFormat(resultData.REIM_BET1, decimalNum) }" class="noBorder" size="10" readonly />&nbsp;
			                <input type="text" name="REIM_WAR1" value="${resultData.REIM_WAR1}" class="noBorder" size="4" readonly />
		                </td>
		                <td>
		                	<span id="REIM_RATE1" name="REIM_RATE1"><input type="text" style="text-align:right;" class="noBorder" name="REIM_RAT1" value="${f:printNum(resultData.REIM_RAT1) }" size="4" readonly /></span>&nbsp;%
	                	</td>
		                <td class="lastCol">
		                	<input type="text" name="REIM_CAL1" value="${f:printNumFormat(resultData.REIM_CAL1, decimalNum) }" style="text-align:right;" class="noBorder" size="10" readonly />&nbsp;&nbsp;
		                	<input type="text" name="REIM_WAR11" value="${resultData.REIM_WAR1}" class="noBorder" size="4" readonly />
		                </td>
	            	</tr>

	            	<tr id="tuitionfee" name="tuitionfee">
		                <td class="divide" ><!--Tuition Fee--><spring:message code="LABEL.E.E21.0016" /></td>
		                <td>
		                    <input type="text" name="REIM_BET2" value="${f:printNumFormat(resultData.REIM_BET2, decimalNum) }" style="text-align:right;ime-mode:disabled;" class="noBorder" size="10" readonly />&nbsp;
		                    <input type="text" name="REIM_WAR2" value="${resultData.REIM_WAR2}" class="noBorder" size="4" readonly />
		                </td>
		                <td>
		                	<span id="REIM_RATE2" name="REIM_RATE2"><input type="text" style="text-align:right;" name="REIM_RAT2" value="${f:printNum(resultData.REIM_RAT2) }" size="4" class="noBorder" readonly/></span>&nbsp;%
		                </td>
		                <td class="lastCol">
		                    <input type="text" name="REIM_CAL2" value="${f:printNumFormat(resultData.REIM_CAL2, decimalNum) }" style="text-align:right;" class="noBorder" size="10" readonly/>&nbsp;&nbsp;
		                    <input type="text" name="REIM_WAR22" value="${resultData.REIM_WAR2}" size="4" class="noBorder" readonly/>
		                </td>
	                </tr>

	                <tr class="oddRow" id="lessionfee" name="lessionfee">
		                <td class="divide"><!--Lesson Fee--><spring:message code="LABEL.E.E21.0017" /></td>
		                <td>
		                    <input type="text" name="REIM_BET3" value="${f:printNumFormat(resultData.REIM_BET3, decimalNum) }" style="text-align:right;ime-mode:disabled;" class="noBorder" size="10" readonly />&nbsp;
		                    <input type="text" name="REIM_WAR3" value="${resultData.REIM_WAR3}" class="noBorder" size="4" readonly />
		                </td>
		                <td>
		                    <span id="REIM_RATE3" name="REIM_RATE3"><input type="text" style="text-align:right;" name="REIM_RAT3" value="${f:printNum(resultData.REIM_RAT3) }" size="4" class="noBorder" readonly/></span>&nbsp;%
		                </td>
		                <td class="lastCol">
		                	<input type="text" name="REIM_CAL3" value="${f:printNumFormat(resultData.REIM_CAL3, decimalNum) }" size="10" style="text-align:right;" class="noBorder" readonly/>&nbsp;&nbsp;
							<input type="text" name="REIM_WAR33" value="${resultData.REIM_WAR3}" class="noBorder" size="4" readonly/>
		                </td>
	                </tr>

	                <tr id="attendingfee" name="attendingfee">
		                <td class="divide"><!--Attending Fee--><spring:message code="LABEL.E.E21.0018" /></td>
		                <td>
		                	<input type="text" name="REIM_BET4" value="${f:printNumFormat(resultData.REIM_BET4, decimalNum) }" style="text-align:right;ime-mode:disabled;" class="noBorder" size="10" readonly />&nbsp;
		                	<input type="text" name="REIM_WAR4" value="${resultData.REIM_WAR4}" class="noBorder" size="4" readonly>
		                </td>
		                <td>
		                	  <span id="REIM_RATE4" name="REIM_RATE4"><input type="text" style="text-align:right;" name="REIM_RAT4" value="${f:printNum(resultData.REIM_RAT4) }" size="4" class="noBorder" readonly/></span>&nbsp;%
		                </td>
		                <td class="lastCol">
		                    <input type="text" name="REIM_CAL4" value="${f:printNumFormat(resultData.REIM_CAL4, decimalNum) }" style="text-align:right;" size="10" class="noBorder" readonly/>&nbsp;&nbsp;
		                    <input type="text" name="REIM_WAR44" value="${resultData.REIM_WAR4}" size="4" class="noBorder" readonly/>
		                </td>
	                </tr>

	                <tr class="oddRow" id="contribution" name="contribution">
	               	    <td class="divide"><!--Contribution--><spring:message code="LABEL.E.E21.0019" /></td>
	                    <td>
	                  	    <input type="text" name="REIM_BET5" value="${f:printNumFormat(resultData.REIM_BET5, decimalNum) }" style="text-align:right;ime-mode:disabled;" maxlength="10" size="10"  class="noBorder"  readonly />&nbsp;
	                  	     <input type="text" name="REIM_WAR5" value="${resultData.REIM_WAR5}" class="noBorder" size="4" readonly/>
	                    </td>
	                    <td>
	                  	    <span id="REIM_RATE5" name="REIM_RATE5"><input type="text" name="REIM_RAT5" style="text-align:right;" value="${f:printNum(resultData.REIM_RAT5) }" size="4" class="noBorder" readonly/></span>&nbsp;%
	                    </td>
	                    <td class="lastCol">
	                        <input type="text" name="REIM_CAL5" value="${f:printNumFormat(resultData.REIM_CAL5, decimalNum) }" style="text-align:right;" size="10" class="noBorder" readonly>&nbsp;&nbsp;
	                        <input type="text" name="REIM_WAR55" value="${resultData.REIM_WAR5}" size="4" class="noBorder" readonly/>
	                    </td>
	                </tr>

	                <c:if test="${approvalHeader.finish}">
				  	<tr>
                  		  <th><!--Account Document--><spring:message code="LABEL.E.E18.0063" /></th>
                     	  <td colspan="3">${resultData.BELNR}</td>
                    </tr>
                    </c:if>
	            </table>
            </div>


            <div class="buttonArea">
			    <span name="totalReim"><!--Total&nbsp;Payment--> <spring:message code="LABEL.E.E21.0021" /></span> :
			     ${f:printNumFormat(resultData.REIM_TOTL, decimalNum) }  ${resultData.REIM_WAERS}
				<input type="hidden" name="REIM_WAERS" value="${resultData.REIM_WAERS}"  />
				<input type="hidden" name="REIM_TOTL" value="${f:printNumFormat(resultData.REIM_TOTL, decimalNum) }" />
				<c:if test="${approvalHeader.finish}">
			    / <span name="totalReim2"><!--지급 금액--> <spring:message code="LABEL.E.E21.0030" /></span> :
			     ${f:printNumFormat(resultData.CERT_BETG, decimalNum) } ${resultData.REIM_WAERS}
				</c:if>

			    <c:if test = "${resultData.CERT_BETG_C ne '0' }" >
                <input type="text" id="CERT_BETG_C" style="text-align:right;" name="CERT_BETG_C" value="${f:printNumFormat(resultData.CERT_BETG_C, 2) }" class="noBorder" size="10" readonly/>
                <input type="text" name="cmoney" value="${resultData.REIM_WAERS}" size="4" class="noBorder" readonly />
                </c:if>
                 &nbsp;&nbsp;
			    <span id="mtitle" name="mtitle"></span>
			    <span id="CERT_BETG_C2" name="CERT_BETG_C2"></span>
		    </div>

        </div>
        <c:if test="${not empty E17HdataFile_vt}">
        <!-- end class=""listArea"" -->
		<div class="listArea">
            <div class="table">
            	<table class="tableGeneral">
            		<colgroup>
	            		<col width="15%" />
	            		<col width="" />
	            	</colgroup>
        			<c:forEach var="row" items="${E17HdataFile_vt}" varStatus="status">
				  	<tr>
	              		<th><!--Attachment File --><spring:message code="LABEL.E.E21.0022" /></th>
	              		<td colspan="3" style="text-align: left;">
	              		<a href="<c:out value='${g.servlet}'/>hris.common.DownloadedFile?fileName=<c:out value='${row.FILE_NM}'/><c:out value='${row.FILE_TYPE}'/>&filePath=<c:out value='${row.FILE_PATH}'/>"><c:out value='${row.FILE_NM}'/></a>
	              		</td>
	              	</tr>
				  	</c:forEach>
            	</table>
            </div>
		</div>
		</c:if>
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
	                        		alert("<spring:message code='MSG.E.E19.0041' />");  //alert("Please check document evidence");
	                              return;
	                        	}
	                        }

	                       	if(frm.CERT_BETG.value == "") {
	                       		alert("<spring:message code='MSG.E.E19.0040' />"); // // alert("please input Payment Amount");
	                       	    frm.CERT_BETG.focus();
	                       	    return;
	                       	} // end if

	                        frm.BEGDA.value = removePoint(frm.BEGDA.value);
	                        frm.TERM_BEGD.value = removePoint(frm.TERM_BEGD.value);
	                        frm.TERM_ENDD.value = removePoint(frm.TERM_ENDD.value);
	                        frm.CERT_DATE.value = removePoint(frm.CERT_DATE.value);
	                        frm.CERT_BETG.value =  removeComma(frm.CERT_BETG.value);
	                        frm.REQU_DATE.value = removePoint(frm.BEGDA.value);

	                        return true;
                       }

                       function beforeReject() {
	                       var frm = document.form1;

	                       frm.BEGDA.value = removePoint(frm.BEGDA.value);
	                       frm.TERM_BEGD.value = removePoint(frm.TERM_BEGD.value);
	                       frm.TERM_ENDD.value = removePoint(frm.TERM_ENDD.value);
	                       frm.CERT_DATE.value = removePoint(frm.CERT_DATE.value);
	                       frm.CERT_BETG.value = removeComma(frm.CERT_BETG.value);
	                       frm.REQU_DATE.value = removePoint(frm.BEGDA.value);

	                       <c:if test="${iFlag eq '1'}">
	                       //frm.PAID_DATE.value = "";
	           		       //frm.PAID_AMNT.value = "0";
	           		       //frm.YTAX_WONX.value = "0";
	           		    	</c:if>

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
		                     <input type="hidden" name="REQU_DATE"     value="${resultData.REQU_DATE}" />
	                    </td>
	                </tr>

	                <tr>
	              		<th><!--Payment Amount--><spring:message code="LABEL.E.E21.0030" /></th>
	              		<td colspan="3">
	              		<c:choose>
	              			<c:when test="${resultData.CERT_BETG eq '0' || resultData.CERT_BETG eq '' }">
	              				<input type="text" name="CERT_BETG"  style="text-align:right;" size="10" onkeyup="moneyChkEventForWorld(this);" value="${f:printNumFormat(resultData.REIM_TOTL, decimalNum)}" />
	              			</c:when>
	              			<c:otherwise>
	              				<input type="text" name="CERT_BETG"  style="text-align:right;" size="10" onkeyup="moneyChkEventForWorld(this);" value="${f:printNumFormat(resultData.CERT_BETG, decimalNum)}" class="noBorder" readonly />
	              			</c:otherwise>
              			</c:choose>&nbsp; ${resultData.REIM_WAR1}
	              		</td>
	                </tr>

                </table> <!--  end tableGeneral -->
             </div>  <!--  end table -->
        </div>   <!--  end tableArea -->

        </c:if>

        </tags-approval:detail-layout>
</tags:layout>

