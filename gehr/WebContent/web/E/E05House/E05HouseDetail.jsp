<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 신규신청                                           */
/*   Program Name : 주택자금 신규신청 조회                                      */
/*   Program ID   : E05HouseDetail.jsp                                          */
/*   Description  : 주택자금 신청을 조회할 수 있도록 하는 화면                  */
/*   Note         :                                                             */
/*   Creation     : 2001-12-13  김성일                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                  2005-11-04  @v1.2lsa :C2005102701000000578 :신청서출력추가  */
/*                  2012-04-26  lsa [CSR ID:2097388] 주택자금 신규신청 화면 은행코드 추가 요청 */
/*                  2014-01-20  lsa [CSR ID:C20140115_69945] 알림문구추가 */
/*                  2015-01-21  이지은  [CSR ID:2685890] 대출신청 시 popup 창 문구 수정요청(오창) */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="hris.E.E05House.E05HouseData" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    E05HouseData e05HouseData  = (E05HouseData)request.getAttribute("e05HouseData");

    String E_BTRTL = (String)request.getAttribute("E_BTRTL");  //인사하위영역 String E_BTRTL = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode,user.empNo, "2005",DATUM);

    String approvalClass = (String)request.getAttribute("approvalClass");

	// [CSR ID:2685890] 대출신청 시 popup 창 문구 수정요청(오창)
    String alertmsg = "";
    if(E_BTRTL.equals("BBHA")||E_BTRTL.equals("BBHB")){
        alertmsg = g.getMessage("MSG.E.E05.0001");//"사업장 별 담당부서로 주택자금 신청서 및 주택 계약서 사본을 제출해 주십시오. (매월 6일 마감)";
    }else{
        alertmsg = g.getMessage("MSG.E.E05.0002");//"사업장 별 담당부서로 주택자금 신청서 및 주택 계약서 사본을 제출해 주십시오. (매월 10일 마감)";
    }

	String requ_mony = ""+ ( Double.parseDouble(e05HouseData.REQU_MONY)*100 ) ;
	String darbt = ""+( Double.parseDouble(e05HouseData.DARBT)*100 );
	String tilbt = ""+( Double.parseDouble(e05HouseData.TILBT)*100 );
	String mnth_interst = ""+(Double.parseDouble(e05HouseData.MNTH_INTEREST)*100);

	String RequestPageName2 = (String)request.getAttribute("RequestPageName2");

	//Logger.debug.println( "============== requ_mony : "+ requ_mony);
%>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="requ_mony" value="<%=requ_mony%>" />
<c:set var="darbt" value="<%=darbt%>" />
<c:set var="alertmsg" value="<%=alertmsg%>" />
<c:set var="tilbt" value="<%=tilbt%>" />
<c:set var="mnth_interst" value="<%=mnth_interst%>" />
<c:set var="approvalClass" value="<%=approvalClass%>" />
<c:set var="e_persk" value="<%=user.e_persk%>" />
<c:set var="RequestPageName2" value="<%=RequestPageName2%>" />

<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
	<c:if test="${approvalHeader.ACCPFL ne 'X' }">
    <li><a onclick="go_print();" ><span><spring:message code="LABEL.E.E05.0022" /><!-- 주택자금 지원신청서 --></span></a></li>
    </c:if>
</tags:body-container>

<tags:layout css="ui_library_approval.css" script="dialog.js" >
<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
<tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_HOUS_FUND" updateUrl="${g.servlet}hris.E.E05House.E05HouseChangeSV" button="${buttonBody}">
<tags:script>
	<script>

	<!--
	jQuery(function(){
		on_Load();
	});

	// @v1.2
	function go_print(){
	    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=740,height=650,left=100,top=60");
	    document.form1.jobid.value = "print_house";
	    document.form1.AINF_SEQN.value = "${resultData.AINF_SEQN}";
	    document.form1.target = "essPrintWindow";
	    document.form1.action = '${g.servlet}hris.E.E05House.E05HouseDetailSV';
	    document.form1.method = "post";
	    document.form1.submit();
	    document.form1.target = "";
	}

	// @v1.2
	function on_Load() {
		if( document.form1.RequestPageName2.value == "" ) { //if( document.form1.RequestPageName.value == "" ) {
	        //  신청 후 조회된 경우 - 주택자금 신청서를 먼저 띄워준다.
	        //C20140115_69945
	        alert("${alertmsg}");
	        go_print();
	    }
	}
	//-->

	</script>
</tags:script>

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
	           		<th><!--주택융자유형--><spring:message code="LABEL.E.E05.0001" /></th>
	               	<td colspan="3">
	           			<input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}"  />

	           			<select name="DLART" style="width:135px;" disabled>
	                       <option value="" selected>------------</option>
	                       		${f:printCodeOption(getLoanTypeList, resultData.DLART)}
	                       </select>
	           		</td>
	                <!-- td class="align_right">
	                    <c:if test="${approvalHeader.ACCPFL ne 'X' }">
	                    <a class="inlineBtn" href="javascript:go_print();"><span><spring:message code="LABEL.E.E05.0022" /><!-- 주택자금 지원신청서 -- ></span></a>
	                    </c:if>
	                </td  -->
	           	</tr>
	           	<tr>
	                <th><!--현주소--><spring:message code="LABEL.E.E05.0002" /></th>
	                <td colspan="3">
	                	<input type="text" name="E_STRAS" size="105" value="<c:out value='${E05PersInfoData.e_STRAS}'/>" readonly />
	                </td>
	            </tr>

	            <tr>
                    <th><!--근속년수--><spring:message code="LABEL.E.E05.0003" /></th>
                    <td><input type="text" name="E_YEARS" size="15" value="<c:out value='${E05PersInfoData.e_YEARS}'/>" style="text-align:right" readonly /></td>
                    <th class="th02"><!--신청은행--><spring:message code="LABEL.E.E05.0004" /></th>
                    <td>
                        <select name="BANK_CODE" style="width:135px;" disabled>
                            <option value="">-------------</option>

                            <c:forEach var="row" items="${e05BankCodeData_vt}" varStatus="inx">
                         	<c:set var="index" value="${inx.index}"/>
                         	<option value="<c:out value='${row.BANK_CODE}'/>"  <c:if test = "${row.BANK_CODE eq resultData.BANK_CODE }" >selected</c:if>><c:out value='${row.BANK_NAME}'/></option>
							</c:forEach>
                        </select>
                    </td>
                </tr>

                <tr>
                    <th><!--신청금액 --><spring:message code="LABEL.E.E05.0005" /></th>
                    <td>
                        <input type="text" name="REQU_MONY_NAME" size="15" value="${f:printNumFormat( requ_mony, 0)}" style="text-align:right" readonly />
                    </td>

                    <th class="th02"><!--자금용도--><spring:message code="LABEL.E.E05.0006" /></th>
                    <td>
                        <select name="ZZFUND_CODE" style="width:135px;" disabled>
                            <option value="">------------</option>

                            <c:forEach var="row" items="${E05FundCode_vt}" varStatus="inx">
							<c:set var="index" value="${inx.index}"/>
								<c:if test = "${resultData.DLART eq row.DLART }" >
									<option value="<c:out value='${row.FUND_CODE}'/>" <c:if test = "${resultData.ZZFUND_CODE eq row.FUND_CODE }" >selected</c:if> ><c:out value='${row.FUND_TEXT}'/></option>
								</c:if>
							</c:forEach>
                        </select>
                    </td>
                </tr>

                <tr>
                    <th><!--보증여부--><spring:message code="LABEL.E.E05.0007" /></th>
                    <td colspan="3">
                    <c:choose>
                    <c:when test="${resultData.ZZSECU_FLAG eq 'N' }">
                    	<!--보증보험가입희망--><spring:message code="LABEL.E.E05.0009" />
                    </c:when>
                    <c:when test="${resultData.ZZSECU_FLAG eq 'C' }">
                    	<!--신용보증--><spring:message code="LABEL.E.E05.0008" />
                    </c:when>

                    <c:otherwise>
                    </c:otherwise>
                	</c:choose>

                    </td>
                </tr>

                <!--[CSR ID:1411665] 주택자금 신청화면 변경 요청건-->
                <tr>
                    <th><!--본인확인사항--><spring:message code="LABEL.E.E05.0014" /></th>
                    <td colspan="3">
                        <table>
                            <tr>
                                <td>
                                <!--본인은 신청일 현재 무주택자 임을 확인합니다.--><spring:message code="LABEL.E.E05.0011" /><br>
                                <!--상기 사항이 사실이 아닌 경우 규정에 따른 조치(대출액 환수 등)에 이의가 없음을 확인합니다.--><spring:message code="LABEL.E.E05.0012" />
                                </td>
                            </tr>

                            <tr>
                                <td><!--본인동의--><spring:message code="LABEL.E.E05.0013" /> :
                                <c:if test = "${resultData.ZCONF eq 'Y' }" ><!--예--><spring:message code="LABEL.E.E05.0015" /></c:if>
                                <c:if test = "${resultData.ZCONF eq 'N' }" ><!--아니오--><spring:message code="LABEL.E.E05.0016" /></c:if>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

           	</table>
          </div><!--  end table -->

		<!-----   hidden field ---------->

		<!-----   hidden field ---------->

          <!-- 상단 입력 테이블 끝-->
      </div> <!--  end tableArea -->


      <!--  ***** 부서장 결재자  ***********************  -->

	  <!-- c:if test="${approvalHeader.ACCPFL eq 'X' ||approvalHeader.finish }"  -->
	  <!-- c:if test="${I_APGUB ne '2' }" -->

	   <!--  ***** 업무담당자와 업무담당 부서장만 보여준다. ***********************  -->
      <!-- c:if test="${approvalHeader.DMANFL eq '01' ||approvalHeader.DMANFL eq '02' }"  -->
      <c:if test="${approvalHeader.charger || approvalHeader.chargeManager }">

      <h2 class="subtitle">담당자입력</h2>
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                <tags:script>
	                <script>
		                jQuery(function(){
		                	firstHideshow();
		            	});

	                  function firstHideshow() {
	                	  var guaStyle = "none";
	                	  <c:if test="${!(approvalHeader.departManager) && resultData.ZZSECU_FLAG eq 'Y' }" >
	                	  		guaStyle = "";
             	   		  </c:if>
             	   			guarantee.style.display = guaStyle;
                   	   }

                   	   function hideshow(obj) {

                   	       if (obj.value == "Y" ) {
                   	           guarantee.style.display = "";
                   	       } else {
                   	           guarantee.style.display = "none";
                   	       } // end if
                   	   }

                       function beforeAccept() {
                    	   var validText = "";
                    	   var frm = document.form1;

                   	       if ( frm.ZZSECU_FLAG.disabled == true ) {
                   	           frm.ZZSECU_FLAG.disabled = false;
                   	       }
                   	       if ( frm.PROOF.disabled == true ) {
                   	           frm.PROOF.disabled = false;
                   	       }
                   	       if ( frm.ZZRELA_CODE.disabled == true ) {
                   	           frm.ZZRELA_CODE.disabled = false;
                   	       }

                   	    <c:if test="${requ_mony > 20000000.0 }" >
	                   	 	if ( frm.ZZRELA_CODE2.disabled == true ) {
	          	           		frm.ZZRELA_CODE2.disabled = false;
	          	       		}
                   	    </c:if>

                   	       //※ 한도금액체크 로직 추가[C20110808_41085]
                   	       loantype = frm.DLART.value;
                   	       max_money = max_amount(loantype);
                   	       requ_money = removeComma(document.form1.DARBT.value);
                   	       if( requ_money > max_money ) {
                   	           comma_money = insertComma(max_money+"");
                   	           if (document.form1.ingcount.value > 0){
                   	               alert("<spring:message code='MSG.E.E05.0009' arguments='"+ comma_money +"' />");
                	        	  //alert("신청진행중 금액도 기대출금액으로 환산하여 \n신청 가능금액은 " + comma_money + "원이하 입니다."); //  MSG.E.E05.0009
                   	           }else{
                   	        	alert("<spring:message code='MSG.E.E05.0010' arguments='"+ comma_money +"' />");
                	        	//alert("신청금액이 너무 많습니다.\n신청 가능금액은 " + comma_money + "원이하 입니다."); // MSG.E.E05.0010
                   	           }
                   	           return;
                   	       }

                   	       if ( frm.DARBT.value == "" || parseInt(removeComma(frm.DARBT.value), 10) == 0 ) {
                   	           validText = "<spring:message code='LABEL.E.E05.0025' />";
                		       alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("대출승인금액을 입력해 주시기 바랍니다.");
                   	           return;
                   	       }

                   	       if ( frm.MONY_RATE.value == "" || parseInt(removeComma(frm.MONY_RATE.value), 10) == 0 ) {
                   	    		validText = "<spring:message code='LABEL.E.E05.0026' />";
             		       		alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("개별금리를 입력해 주시기 바랍니다.");
                   	            return;
                   	       }

                   	       if ( frm.ZAHLD.value == ""  ) {
                   	    	   validText = "<spring:message code='LABEL.E.E05.0027' />";
         		       		   alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("지급일을 입력해 주시기 바랍니다.");
                   	           frm.ZAHLD.select();
                   	           return;
                   	       }

                   	       //[CSR ID:2564967]
                   	       if ( frm.ZZRPAY_MNTH.value == ""||frm.ZZRPAY_CONT.value == "" ||frm.REFN_BEGDA.value == "" ){
                   	    	   validText = "<spring:message code='LABEL.E.E05.0027' />";
      		       		   	   alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("지급일을 입력해 주시기 바랍니다.");
                   	           frm.ZAHLD.select();
                   	           return;
                   	       }

                   	       if ( frm.PROOF.checked == true ) {
                   	           frm.PROOF.value = "X";
                   	       } else {
                   	    	   alert("<spring:message code='MSG.E.E19.0011' />");  //alert("증빙확인에 체크해주시기 바랍니다.");
                   	           return;
                   	       }
                   	       //[CSR ID:1411665]지급일 체크로직 삭제요청
                   	       //if ( removePoint(frm.ZAHLD.value) < "< %= DataUtil.getCurrentDate()%>" ) {
                   	       //    alert("지급일이 결재일 보다 커야 합니다.");
                   	       //    return;
                   	       //}

                   	       if ( frm.ZZSECU_FLAG.value == "Y" ) {

                   	           if ( frm.ZZSECU_NAME.value == "" ) {
                   	        	   validText = "<spring:message code='LABEL.E.E05.0034' />";
                   			       alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("보증인 성명을 입력하세요.");
                   	               frm.ZZSECU_NAME.select();
                   	               return;
                   	           }
                   	           if ( frm.ZZRELA_CODE.options[frm.ZZRELA_CODE.selectedIndex].value == "" ) {
                   	        	   validText = "<spring:message code='LABEL.E.E05.0035' />";
                			       alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("보증인 관계를 입력하세요.");
                   	               frm.ZZRELA_CODE.focus();
                   	               return;
                   	           }
                   	           if ( frm.ZZSECU_REGNO.value == "" ) {
                   	        		validText = "<spring:message code='LABEL.E.E05.0036' />";
     			           			alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("보증인 주민등록번호를 입력하세요.");
                   	                frm.ZZSECU_REGNO.select();
                   	                return;
                   	           }
                   	           if ( frm.ZZSECU_TELX.value == "" ) {
                   	        		validText = "<spring:message code='LABEL.E.E05.0037' />";
			           				alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("보증인 연락처를 입력하세요.");
                   	                frm.ZZSECU_TELX.select();
                   	                return;
                   	           }

                   	     	<c:if test="${requ_mony > 20000000.0 }" >
                   	           if ( frm.ZZSECU_NAME2.value == "" ) {
                   	        	   validText = "<spring:message code='LABEL.E.E05.0034' />";
                			       alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("보증인 성명을 입력하세요.");
                   	               frm.ZZSECU_NAME2.select();
                   	               return;
                   	           }
                   	           if ( frm.ZZRELA_CODE2.options[frm.ZZRELA_CODE2.selectedIndex].value == "" ) {
                   	        	   validText = "<spring:message code='LABEL.E.E05.0035' />";
             			           alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("보증인 관계를 입력하세요.");
                   	               frm.ZZRELA_CODE2.focus();
                   	               return;
                   	           }
                   	           if ( frm.ZZSECU_REGNO2.value == "" ) {
                   	        		validText = "<spring:message code='LABEL.E.E05.0036' />";
         			           		alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("보증인 주민등록번호를 입력하세요.");
                   	                frm.ZZSECU_REGNO2.select();
                   	                return;
                   	           }
                   	           if ( frm.ZZSECU_TELX2.value == "" ) {
                   	        		validText = "<spring:message code='LABEL.E.E05.0037' />";
		           					alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("보증인 연락처를 입력하세요.");
                   	                frm.ZZSECU_TELX2.select();
                   	                return;
                   	           }
                   	        </c:if>

                   	       }

	                   	    <c:if test="${E_COUPLEYN eq 'Y'}">
		       	             if (!confirm("${E_MESSAGE}")) { // 시간제의 경우 메세지 처리
		       	                 return;
		       	             }
		       		        </c:if>

	                  	   	// [[CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정] 결재시 사원서브그룹체크(주택신규,장학자금)
	                  	   	// 사원서브그룹 : 14-계약직(자문고문), 24-계약직, 34-계약직(생산기술직), 35-계약직(전문기술직), 36-계약직(4H), 37-계약직(6H)
	                  	    <c:if test="${(e_persk eq '14') || (e_persk eq '24') || (e_persk eq '34')  || (e_persk eq '35') || (e_persk eq '36')  || (e_persk eq '37')}">

	      	                 if (!confirm("<spring:message code='MSG.E.E05.0013' />")) {  // MSG.E.E05.0013 계약직이므로 계약처우 내용을 확인후 결재를 진행해주시기 바랍니다.\n계속진행하시겠습니까?
	      	                    return;
	      	                 }
	                  	     </c:if>

                   	       /* afterAccept 로 이동
                   	       frm.DARBT.value = removeComma(frm.DARBT.value)/100;
                   	       frm.TILBT.value = removeComma(frm.TILBT.value)/100;
                   	       frm.MNTH_INTEREST.value = removeComma(frm.MNTH_INTEREST.value)/100;
                   	       frm.ZAHLD.value = changeChar( frm.ZAHLD.value, ".", "-" );
                   	       frm.REFN_BEGDA.value = changeChar( frm.REFN_BEGDA.value, ".", "-" );
                   	       frm.REFN_ENDDA.value = changeChar( frm.REFN_ENDDA.value, ".", "-" );
                   	       frm.ZZSECU_REGNO.value = changeChar( frm.ZZSECU_REGNO.value, "-", "" );

	                   	   <c:if test="${requ_mony > 20000000.0 }" >
	                   	   frm.ZZSECU_REGNO2.value = changeChar( frm.ZZSECU_REGNO2.value, "-", "" );
	                   	   </c:if>*/

	                        return true;
                       }

                       function afterAccept() {
                    	   var frm = document.form1;

                    	   frm.DARBT.value = removeComma(frm.DARBT.value)/100;
                   	       frm.TILBT.value = removeComma(frm.TILBT.value)/100;
                   	       frm.MNTH_INTEREST.value = removeComma(frm.MNTH_INTEREST.value)/100;
                   	       frm.ZAHLD.value = changeChar( frm.ZAHLD.value, ".", "-" );
                   	       frm.REFN_BEGDA.value = changeChar( frm.REFN_BEGDA.value, ".", "-" );
                   	       frm.REFN_ENDDA.value = changeChar( frm.REFN_ENDDA.value, ".", "-" );
                   	       frm.ZZSECU_REGNO.value = changeChar( frm.ZZSECU_REGNO.value, "-", "" );

                   	    	<c:if test="${requ_mony > 20000000.0 }" >
	                   	   frm.ZZSECU_REGNO2.value = changeChar( frm.ZZSECU_REGNO2.value, "-", "" );
	                   	   </c:if>
                       }

                       function beforeReject() {
	                       var frm = document.form1;
							/*
	                       frm.DARBT.value = removeComma(frm.DARBT.value)/100;
	                       frm.TILBT.value = removeComma(frm.TILBT.value)/100;
	                       frm.MNTH_INTEREST.value = removeComma(frm.MNTH_INTEREST.value)/100;
	                       frm.ZAHLD.value = changeChar( frm.ZAHLD.value, ".", "-" );
	                       frm.REFN_BEGDA.value = changeChar( frm.REFN_BEGDA.value, ".", "-" );
	                       frm.REFN_ENDDA.value = changeChar( frm.REFN_ENDDA.value, ".", "-" );
	                       frm.ZZSECU_REGNO.value = changeChar( frm.ZZSECU_REGNO.value, "-", "" );
	                    <c:if test="${requ_mony > 20000000.0 }" >
	                       frm.ZZSECU_REGNO2.value = changeChar( frm.ZZSECU_REGNO2.value, "-", "" );
	                     </c:if>
	                       */

	                        return true;
                       }

                       function max_amount(loantype) {
                    	    count = document.form1.loantypecount.value;
                    	    oldcount = document.form1.oldcount.value;
                    	    max_money = 0;
                    	    old_money = 0;

                    	    for( i = 0; i < count; i++) {
                    	        loancode = eval("document.form1.LOAN_CODE" + i + ".value");

                    	        if( (loancode == loantype) ){
                    	            max_money = parseFloat(eval("document.form1.LOAN_MONY" + i + ".value"));
                    	        }
                    	    }

                    	    if( loantype == "0020" ) {
                    	        for( i = 0; i < oldcount; i++) {
                    	            loancode = eval("document.form1.OLD_DLART" + i + ".value");
                    	            old_money = old_money + parseFloat(eval("document.form1.OLD_DARBT" + i + ".value"));
                    	        }
                    	        max_money = max_money - old_money;
                    	    } else if( loantype == "0010" ) {
                    	        for( i = 0; i < oldcount; i++) {
                    	            loancode = eval("document.form1.OLD_DLART" + i + ".value");
                    	            old_money = old_money + parseFloat(eval("document.form1.OLD_DARBT" + i + ".value"));
                    	        }
                    	        max_money = max_money - old_money;
                    	    }

                    	    //※ 진행중인건 대출금액목록[C20110808_41085]
                    	    ING_money = 0; //신청진행중인 금액
                    	    if( loantype == "0010" || loantype == "0020" ) {
                    	        for( i = 0; i < document.form1.ingcount.value; i++) {
                    	            loancode = eval("document.form1.ING_DLART" + i + ".value");
                    	            ING_money = ING_money + parseFloat(eval("document.form1.ING_DARBT" + i + ".value"));
                    	        }
                    	        max_money = max_money - ING_money;
                    	    }

                    	    //수정화면에서의 한도체크시 현재 대출승인 금액을 포함해준다.
                    	    curr_money = "${resultData.DARBT eq '0'? requ_mony : darbt}" ;
                    	    //curr_money = < %= e05HouseData.DARBT.equals("0") ? Double.parseDouble(e05HouseData.REQU_MONY)*100  :  Double.parseDouble(e05HouseData.DARBT)*100  %>;
                    	    max_money = max_money + parseFloat(curr_money );

                    	    if(max_money < 0) {
                    	        max_money = 0;
                    	    }
                    	    return max_money;
                   	}

               	   function resno_chk(obj){
               	       if( chkResnoObj_1(obj) == false ) {
               	           return false;
               	       }
               	   }

                   	function after_event_ZAHLD(){
                   	    event_ZAHLD(document.form1.ZAHLD);
                   	}

                   	function event_ZAHLD(obj){
                   	    if( (obj.value != "") && dateFormat(obj) ){

                   	        document.form3.PERNR.value = document.form1.PERNR.value;
                   	        document.form3.DARBT.value = removeComma(document.form1.DARBT.value)/100;
                   	        document.form3.ZAHLD.value = removePoint(obj.value);

                   	        document.form3.action="${g.jsp}G/HiddenHouse.jsp";
                   	        document.form3.target="ifHidden";
                   	        document.form3.submit();
                   	    }
                   	}

                   	function setLoanDetail(ZZRPAY_MNTH, TILBT, REFN_BEGDA, REFN_ENDDA, MNTH_INTEREST ) {
                   	    document.form1.ZZRPAY_MNTH.value = ZZRPAY_MNTH;
                   	    document.form1.TILBT.value       = TILBT;
                   	    document.form1.REFN_BEGDA.value  = changeChar( REFN_BEGDA, "-", "." );
                   	    document.form1.REFN_ENDDA.value  = changeChar( REFN_ENDDA, "-", "." );
                   	    document.form1.MNTH_INTEREST.value = MNTH_INTEREST;
                   	    document.form1.ZZRPAY_CONT.value = "10";
                   	}

	                   </script>
	                </tags:script>

                	<colgroup>
	            		<col width="15%" />
	            		<col width="20%" />
	            		<col width="15%" />
	            		<col width="20%" />
	            		<col width="15%" />
	            		<col width="" />
	            	</colgroup>

                    <tr>
	                    <th><!--대출승인금액--><spring:message code="LABEL.E.E05.0025" /></th>
	                    <td>
							<c:choose>
		                    <c:when test="${approvalHeader.charger}">
		                    	<input name="DARBT" type="text" value="${resultData.DARBT eq '0'? f:printNumFormat(requ_mony, 0) : f:printNumFormat(darbt, 0)}" size="20" style="text-align:right" onKeyUp="javascript:moneyChkEventForWon(this);" />
		                    </c:when>
		                    <c:otherwise>
		                    	<input name="DARBT" type="text" value="${resultData.DARBT eq '0'? f:printNumFormat(requ_mony, 0) : f:printNumFormat(darbt, 0)}" size="20" style="text-align:right" class="noBorder" readonly />
		                    </c:otherwise>
		                	</c:choose>
	                    </td>
	                    <th class="th02"><!--개별금리--><spring:message code="LABEL.E.E05.0026" /></th>
	                    <td>
	                    	<c:choose>
		                    <c:when test="${approvalHeader.charger}">
		                    	<input name="MONY_RATE" type="text" value="${resultData.MONY_RATE eq '000'? '1' : f:printNumFormat(resultData.MONY_RATE, 0)}" size="3" style="text-align:right" onBlur="javascript:usableChar(this, '0123456789');" /> %
		                    </c:when>
		                    <c:otherwise>
		                    	<input name="MONY_RATE" type="text" value="${resultData.MONY_RATE eq '000'? '1' : f:printNumFormat(resultData.MONY_RATE, 0)}" size="3" style="text-align:right" class="noBorder" readonly /> %
		                    </c:otherwise>
		                	</c:choose>
	                    </td>
	                    <th class="th02"><!--지급일--><spring:message code="LABEL.E.E05.0027" /></th>
	                    <td>
	                        <c:choose>
		                    <c:when test="${approvalHeader.charger}">
		                    	<input name="ZAHLD" type="text" value="${f:printDate(resultData.ZAHLD ) }" size="12" onBlur="event_ZAHLD(this);"  class="date"  onchange="after_event_ZAHLD();" />
		                    </c:when>
		                    <c:otherwise>
		                    	<input name="ZAHLD" type="text" value="${f:printDate(resultData.ZAHLD ) }" size="12" onBlur="event_ZAHLD(this);"  class="noBorder" readonly />
		                    </c:otherwise>
		                	</c:choose>

                        </td>
                    </tr>
                    <tr>
                        <th><!--상환기간--><spring:message code="LABEL.E.E05.0028" /></th>
                        <td colspan="5">
                            <input name="ZZRPAY_MNTH" type="text" value="${resultData.ZZRPAY_MNTH eq '000000'? '' : resultData.ZZRPAY_MNTH }"  size="6" class="noBorder" style="text-align:right" readonly> 부터
                            <input name="ZZRPAY_CONT" type="text" value="${resultData.ZZRPAY_CONT eq '00'? '' : resultData.ZZRPAY_CONT}" size="2"  class="noBorder" style="text-align:right" readonly> 년
                        </td>
                     </tr>

                     <tr>
                          <c:if test="${approvalHeader.finish}">
                          <th><!--월상환원금--><spring:message code="LABEL.E.E05.0029" /></th>
                          <td>
                          	${resultData.TILBT eq '0'? '' : f:printNumFormat(tilbt, 0)} 원
                          </td>
                          </c:if>
                          <th class="th02"><!--원상환시작--><spring:message code="LABEL.E.E05.0030" /></th>
                          <td>
                          		<input name="REFN_BEGDA" type="text" value="${f:printDate(resultData.REFN_BEGDA ) }" size="10" class="noBorder" readonly />
                          </td>
                          <th class="th02"><!--월상환종료--><spring:message code="LABEL.E.E05.0031" /></th>
                          <td <c:if test="${!approvalHeader.finish}">colspan="3"</c:if>>
                          		<input name="REFN_ENDDA" type="text" value="${f:printDate(resultData.REFN_ENDDA ) }" size="12"  class="noBorder" readonly />
                          </td>
                      </tr>

                      <tr>
                          <th><!--신청자연락처--><spring:message code="LABEL.E.E05.0032" /></th>
                          <td colspan="5">
                           		<input name="ZZHIRE_TELX" type="text" value="${resultData.ZZHIRE_TELX}" size="20" class="noBorder"  readonly />
                                <input name="ZZHIRE_MOBILE" type="text" value="${resultData.ZZHIRE_MOBILE}" size="20" class="noBorder"  readonly />
                          </td>
                       </tr>

                       <tr>
                            <th><!--보증여부--><spring:message code="LABEL.E.E05.0007" /></th>
                       	    <td>
                       	    	<c:choose>
			                    <c:when test="${approvalHeader.charger}">
			                    	<select name="ZZSECU_FLAG" style="width:135px;" onChange="javascript:hideshow(this);" >
	                                <option value ='Y' <c:if test="${resultData.ZZSECU_FLAG eq 'Y' }">selected</c:if>><!--보증인--><spring:message code="LABEL.E.E05.0023" /></option>
	                                <option value ='N' <c:if test="${resultData.ZZSECU_FLAG eq 'N' }">selected</c:if>><!--보증보험--><spring:message code="LABEL.E.E05.0021" /></option>
	                                <option value ='C' <c:if test="${resultData.ZZSECU_FLAG eq 'C' }">selected</c:if>><!--신용보증--><spring:message code="LABEL.E.E05.0008" /></option>
	                                </select>
			                    </c:when>
			                    <c:otherwise>

			                    	<input type="hidden" name = "ZZSECU_FLAG" value="${resultData.ZZSECU_FLAG}">
			                    	<c:choose>
				                    <c:when test="${resultData.ZZSECU_FLAG eq 'N' }">
				                    	<!--보증보험--><spring:message code="LABEL.E.E05.0021" />
				                    </c:when>
				                    <c:when test="${resultData.ZZSECU_FLAG eq 'C' }">
				                    	<!--신용보증--><spring:message code="LABEL.E.E05.0008" />
				                    </c:when>
				                    <c:when test="${resultData.ZZSECU_FLAG eq 'Y' }">
				                    	<!--보증인-->     <spring:message code="LABEL.E.E05.0023" />
				                    </c:when>
				                	</c:choose>

			                    </c:otherwise>
			                	</c:choose>

                       	    </td>
                       	    <th class="th02"><!--증빙확인--><spring:message code="LABEL.E.E05.0024" /></th>
                       	    <td colspan="3">
                            	<c:choose>
			                    <c:when test="${approvalHeader.charger}">
			                    	<input name="PROOF" type="checkbox" value="X" <c:if test = "${resultData.PROOF eq 'X' }" >checked</c:if> >
			                    </c:when>
			                    <c:otherwise>
			                    	<input name="PROOF" type="checkbox" value="X" <c:if test = "${resultData.PROOF eq 'X' }" >checked</c:if> disabled>
			                    </c:otherwise>
			                	</c:choose>
                            </td>
                     	</tr>

                     	<!--  % // if ( approvalStep != DocumentInfo.POST_MANGER ) { // 업무담당자, 업무담당부서장이고 % -->
	                    <!--  %  //    if ( e05HouseData.ZZSECU_FLAG.equals("Y") ) { // 보증인 일때만 보여줌 %  -->
						<!-- c:if test="${!(approvalHeader.departManager) && resultData.ZZSECU_FLAG eq 'Y' }"  -->

                     	<tr id="guarantee">
                     		<td colspan="6">
                     			<!--보증인 인적사항 테이블 시작-->
                     			<table class="tableGeneral"  >
                     				<colgroup>
					            		<col width="15%" />
					            		<col width="30%" />
					            		<col width="15%" />
					            		<col width="" />
					            	</colgroup>

					                <tr>
									  <td colspan="4"><h2 class="subtitle"><!--보증인 인적사항--><spring:message code="LABEL.E.E05.0033" /></h2></td>
									</tr>

									<tr>
	                                      <th><!--이름--><spring:message code="LABEL.E.E05.0034" /></th>
	                                      <td>
	                                      	 <c:choose>
						                     <c:when test="${approvalHeader.charger}">
						                    	<input name="ZZSECU_NAME" type="text" value="${resultData.ZZSECU_NAME}" size="20" />
						                     </c:when>
						                     <c:otherwise>
						                     	<input name="ZZSECU_NAME" type="text" value="${resultData.ZZSECU_NAME}" size="20" class="noBorder" readonly />
						                     </c:otherwise>
						                	 </c:choose>
	                                      </td>
	                                      <th class="th02"><!--관계--><spring:message code="LABEL.E.E05.0035" /></th>
	                                      <td>

											  <c:choose>
						                      <c:when test="${approvalHeader.charger}">
							                      <select name="ZZRELA_CODE" style="width:135px;" >
				                                  <option value="">---------------</option>
		                                          ${f:printCodeOption(A12Family_vt, resultData.ZZRELA_CODE)}
				                                  </select>
						                      </c:when>
						                      <c:otherwise>
					                     		  <select name="ZZRELA_CODE" style="width:135px;" disabled>
				                                  <option value="">---------------</option>
		                                          ${f:printCodeOption(A12Family_vt, resultData.ZZRELA_CODE)}
				                                  </select>
						                      </c:otherwise>
						                	  </c:choose>
	                                      </td>
                                    </tr>
                                    <tr>
                                        <th><!--주민등록번호--><spring:message code="LABEL.E.E05.0036" /></th>
                                        <td>

                                        	<c:choose>
					                        <c:when test="${approvalHeader.finish}">
					                       		${f:printRegNo(resultData.ZZSECU_REGNO, 'LAST')}
					                        </c:when>
					                        <c:otherwise>

					                        	<c:choose>
						                        <c:when test="${approvalHeader.charger}">
							                      <input name="ZZSECU_REGNO" type="text" value="${f:printRegNo(resultData.ZZSECU_REGNO, '')}" size="20" maxlength="14" onBlur="javascript:resno_chk(this);" />
						                        </c:when>
						                        <c:otherwise>
					                     		  <input name="ZZSECU_REGNO" type="text" value="${f:printRegNo(resultData.ZZSECU_REGNO, '')}" size="20" maxlength="14" class="noBorder" readonly />
						                        </c:otherwise>
						                	    </c:choose>

					                        </c:otherwise>
					                	    </c:choose>

                                      	</td>
                                      	<th class="th02"><!--연락처--><spring:message code="LABEL.E.E05.0037" /></th>
                                      	<td>
                                           <c:choose>
					                       <c:when test="${approvalHeader.charger}">
						                      <input name="ZZSECU_TELX" type="text" value="${resultData.ZZSECU_TELX}" size="20" />
					                       </c:when>
					                       <c:otherwise>
				                     		  <input name="ZZSECU_TELX" type="text" value="${resultData.ZZSECU_TELX}" size="20" class="noBorder" readonly />
					                       </c:otherwise>
					                	   </c:choose>
                                      	</td>
                                    </tr>

                                    <c:if test="${requ_mony >20000000.0 }">
		                            <!--보증인(2) 인적사항 테이블 시작-->
                                    <tr>
	                                    <th><!--이름--><spring:message code="LABEL.E.E05.0034" /></th>
	                                    <td>
	                                    	<c:choose>
					                        <c:when test="${approvalHeader.charger}">
						                      <input name="ZZSECU_NAME2" type="text" value="${resultData.ZZSECU_NAME2}" size="10" />
					                        </c:when>
					                        <c:otherwise>
				                     		  <input name="ZZSECU_NAME2" type="text" value="${resultData.ZZSECU_NAME2}" size="10" class="noBorder" readonly />
					                        </c:otherwise>
					                	    </c:choose>

	                                    </td>
	                                    <th class="th02"><!--관계--><spring:message code="LABEL.E.E05.0035" /></th>
	                                    <td>

	                                        <c:choose>
						                      <c:when test="${approvalHeader.charger}">
							                      <select name="ZZRELA_CODE2" style="width:135px;" >
				                                  <option value="">---------------</option>
		                                          ${f:printCodeOption(A12Family_vt, resultData.ZZRELA_CODE2)}
				                                  </select>
						                      </c:when>
						                      <c:otherwise>
					                     		  <select name="ZZRELA_CODE2" style="width:135px;" disabled>
				                                  <option value="">---------------</option>
		                                          ${f:printCodeOption(A12Family_vt, resultData.ZZRELA_CODE2)}
				                                  </select>
						                      </c:otherwise>
						                	  </c:choose>
	                                    </td>
                                    </tr>
                                    <tr>
	                                    <th><!--주민등록번호--><spring:message code="LABEL.E.E05.0036" /></th>
	                                    <td>
	                                        <c:choose>
						                        <c:when test="${approvalHeader.charger}">
							                      <input name="ZZSECU_REGNO2" type="text" value="${f:printRegNo(resultData.ZZSECU_REGNO2, '')}" size="20" maxlength="14" onBlur="javascript:resno_chk(this);" />
						                        </c:when>
						                        <c:otherwise>
					                     		  <input name="ZZSECU_REGNO2" type="text" value="${f:printRegNo(resultData.ZZSECU_REGNO2, '')}" size="20" maxlength="14" class="noBorder" readonly />
						                        </c:otherwise>
						                    </c:choose>

	                                    </td>
	                                    <th><!--연락처--><spring:message code="LABEL.E.E05.0037" /></th>
	                                    <td>
	                                    	<c:choose>
						                        <c:when test="${approvalHeader.charger}">
							                        <input name="ZZSECU_TELX2" type="text" value="${resultData.ZZSECU_TELX2}" size="20" />
						                        </c:when>
						                        <c:otherwise>
					                     		    <input name="ZZSECU_TELX2" type="text" value="${resultData.ZZSECU_TELX2}" size="20"  class="noBorder" readonly />
						                        </c:otherwise>
						                    </c:choose>
	                                    </td>
	                                </tr>
	                                </c:if>
	                                <!--보증인(2) 인적사항 테이블 끝-->
				                </table>
				                <input name="TILBT" type="hidden" value="${resultData.TILBT eq '0'? '' : f:printNumFormat(tilbt, 0)}" />
                        		<input name="MNTH_INTEREST" type="hidden" value="${resultData.MNTH_INTEREST eq '0'? '' : f:printNumFormat(mnth_interst, 0)}" />
                     		</td>
                     	</tr>
                     	<!-- /c:if  -->

                </table> <!--  end tableGeneral -->

             </div>  <!--  end table -->

        </div>   <!--  end tableArea -->
        </c:if>

		<!-- Hidden Field -->
		<input type="hidden" name="PERNR"     value="${resultData.PERNR}">
		<input type="hidden" name="RequestPageName2" value="${RequestPageName2}">

        <!-- ※한도금액체크로직추가[C20110808_41085] -->
        <input type="hidden" name="loantypecount" value="${fn:length(E05MaxMoneyData_vt) }">

        <c:forEach var="row" items="${E05MaxMoneyData_vt}" varStatus="inx">
		<c:set var="index" value="${inx.index}"/>
	        <input type="hidden" name="LOAN_CODE${index}" value='${row.LOAN_CODE}'>
	        <input type="hidden" name="LOAN_MONY${index}" value='${row.LOAN_MONY}' >
		</c:forEach>

		<input type="hidden" name="oldcount" value="${fn:length(PersLoanData_vt) }">

		<c:forEach var="row" items="${PersLoanData_vt}" varStatus="inx">
		<c:set var="index" value="${inx.index}"/>
	    <input type="hidden" name="OLD_DLART${index}" value='${row.DLART}'>
	    <input type="hidden" name="OLD_DARBT${index}" value='${f:printNum(row.DARBT) }' >
	    <input type="hidden" name="OLD_ENDDA${index}" value='${row.ENDDA}'>
	    </c:forEach>


<!-- //※ 진행중인건 대출금액목록[C20110808_41085]-->
        <input type="hidden" name="ingcount" value="${fn:length(IngPersLoanData_vt) }">

        <c:forEach var="row" items="${IngPersLoanData_vt}" varStatus="inx">
		<c:set var="index" value="${inx.index}"/>
	    <input type="hidden" name="ING_DLART${index}" value='${row.DLART}'>
	    <input type="hidden" name="ING_DARBT${index}" value='${f:printNum(row.DARBT) }>' >
	    </c:forEach>
	    <!-- Hidden Field -->

</tags-approval:detail-layout>

</tags:layout>

<form name="form3" method="post">
    <input type="hidden" name = "PERNR" value="">
    <input type="hidden" name = "DLART" value="">
    <input type="hidden" name = "DARBT" value="">
    <input type="hidden" name = "ZAHLD" value="">
  </form>

<iframe name="ifHidden" width="0" height="0"  style="visibility:hidden;" />
