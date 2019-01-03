<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재해야할 문서                                             		*/
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가취소 결재                                                   	*/
/*   Program ID   : G056ApprovalFinishVacation.jsp                              */
/*   Description  : 휴가취소 결재를 위한 jsp 파일                          			*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2013-09-23 손혜영                                           		*/
/*                : 2016-10-10 FD-038 GEHR통합작업-KSC 							*/
/*			      : 2017-07-20 eunha [CSR ID:3438118] flexible time 시스템 요청	*/
/*			      : 2018-05-17 성환희 [WorkTime52] 보상휴가 추가 건       			*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils"%>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    String jobid = (String)request.getAttribute("jobid")==null?"":(String)request.getAttribute("jobid");
     /* 휴가신청 */
    Vector  d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    D03VocationData       data = (D03VocationData)d03VocationData_vt.get(0);
    
    String E_AUTH = (String) request.getAttribute("E_AUTH")==null?"":(String) request.getAttribute("E_AUTH");

    D03GetWorkdayRFC func = new D03GetWorkdayRFC();
//     Object D03GetWorkdayData_vt = func.getWorkday( user.empNo, data.BEGDA );
    Object D03GetWorkdayData_vt = func.getWorkday( data.PERNR, DataUtil.removeSeparate(data.BEGDA) );
    // 사전부여휴가 잔여일수
    String ZKVRB1 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB1");
    // 선택적보상휴가 잔여일수
    String ZKVRB2 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB2");

//     Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");

    E19CongCodeNewRFC e19rfc = new E19CongCodeNewRFC();
    Vector congVT = e19rfc.getCongCode(user.companyCode,"X");

    // 현재 결재자 구분
//     DocumentInfo docinfo = new DocumentInfo(data.AINF_SEQN ,user.empNo);
//     int approvalStep = docinfo.getApprovalStep();
    //CSR ID:1546748
    String OVTM_CDNM = "";
    if (!data.OVTM_CODE.equals("")){

         Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR,  data.AWART,data.BEGDA);
         for( int i = 0 ; i < D03VocationAReason_vt.size() ; i++ ){
             D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(i);
             if (data.OVTM_CODE.equals(old_data.SCODE)) {
                 OVTM_CDNM = old_data.STEXT ;
             }
         }
    }
    //CSR ID:1546748
    String E_BTRTL  = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode, data.PERNR, data.AWART,data.BEGDA);
    String YaesuYn = "";
    if ( E_BTRTL.equals("BAAA")||E_BTRTL.equals("BAAB")||E_BTRTL.equals("BAAC")||
         E_BTRTL.equals("BAAD")||E_BTRTL.equals("BAAE")||E_BTRTL.equals("BAAF")||
         E_BTRTL.equals("BAEA")||E_BTRTL.equals("BAEB")||E_BTRTL.equals("BAEC")||E_BTRTL.equals("CABA")||
         E_BTRTL.equals("BBIA")){
         YaesuYn ="Y";
    }

      String strAwrt = "";
      if(data != null){
          strAwrt = g.getMessage("LABEL.D.D03."+data.AWART);
      }
	boolean visible = false;

// 	if (vcAppLineData != null){
// 		for (int i = 0; i < vcAppLineData.size(); i++) {
// 		    AppLineData ald = (AppLineData) vcAppLineData.get(i);
// 		    if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) {
// 		        visible = true;
// 		        break;
// 		    } // end if
// 		} // end for
// 	}
    D03RemainVocationData dataRemain = (D03RemainVocationData)request.getAttribute("d03RemainVocationData");
	String remainDays = dataRemain.ANZHL_GEN.equals("0")?"0":Float.toString(NumberUtils.toFloat(dataRemain.ANZHL_USE)  / NumberUtils.toFloat(dataRemain.ANZHL_GEN) * 100);
%>

<c:set var="user" value="<%=user%>"/>
<c:set var="data" value="<%=data%>"/>
<c:set var="E_BTRTL" value="<%=E_BTRTL%>"/>
<c:set var="ZKVRB1" value="<%=ZKVRB1%>"/>
<c:set var="ZKVRB2" value="<%=ZKVRB2%>"/>
<c:set var="YaesuYn" value="<%=YaesuYn%>"/>
<c:set var="OVTM_CDNM" value="<%=OVTM_CDNM%>"/>
<c:set var="congVT" value="<%=congVT%>"/>

<c:set var="isUpdate" value="<%=request.getAttribute("isUpdate")%>"/>
<c:set var="dataRemain" value="<%=dataRemain%>"/>
<c:set var="remainDays" value="<%=remainDays%>"/>

<c:set var="E_AUTH" value="<%=E_AUTH%>"/>
<c:set var="strAwrt" value="<%=strAwrt%>"/>

<tags:layout css="ui_library_approval.css"  >

    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO" representative="false" disable="false" >
        <!-- 상단 입력 테이블 시작-->

        <tags:script>

<script language="JavaScript">
$(".btn_crud").html($(".btn_crud").html()+" <li><a href='javascript:history.back();'><span><spring:message code='BUTTON.COMMON.CANCEL'/></span></a></li> ");
$(".-request-button").html('<span><spring:message code="BUTTON.COMMON.APPRCANCELREQ"/></span>');//결재취소요청

<!--

//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha start
$(function(){

if (${user.e_persk==("21")||user.e_persk==("22") }){

	    	if ( "${data.AWART}"=="0120"  || "${data.AWART}"=="0121" ){
	    		$('#requestTime').attr('style','display:none');

	    	}else{
	    		$('#requestTime').attr('style','display:inline-blobk');
	    	}
	 }
});
//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha end

    function aftersave(){
    	if(document.form1.jobid.value == "create"){
    		opener.goToList();
    		window.close();
    	}
    }
	//취소사유입력
    function bfCheck(){
    	if(document.form1.CANC_REASON.value==""){
    		alert("<spring:message code='MSG.D.D01.0056'/>");  //취소사유를 입력하세요.
    		document.form1.CANC_REASON.focus();
    		return false;
    	}
    	return true;
    }

    //결재취소로직
    function beforeSubmit(){
    	if(!bfCheck()) return false;
// 		if(!confirm("<spring:message code='MSG.D.D01.0057'/>")) return false;		 //결재취소 신청하시겠습니까?

    	document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
		document.form1.jobid.value = "create";
        document.form1.target = "_self";
        document.form1.action = "${ g.servlet }hris.D.D03Vocation.D03VocationCancelBuildSV";
        document.form1.method = "post";
//         document.form1.submit();
		return true;
    }

    aftersave();

//-->
</script>
</tags:script>

<input type="hidden" name="BUKRS" value="${user.companyCode}">
<input type="hidden" name="BEGDA"        value="${data.BEGDA}">
<!-- <input type="hidden" name="APPR_STAT"> -->
<%-- <input type="hidden" name="approvalStep" value="${approvalStep}"> --%>
<!-- 전체테이블 시작 -->

<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
            	<colgroup>
            	<col width=15%/>
            	<col />
            	</colgroup>
            <c:if test="${E_AUTH eq 'Y'}">
            <tr>
	             <th width="95"><spring:message code='LABEL.D.D03.0043'/><!-- 휴가유형 --></th>
	             <td>
	             	<c:choose>
	             		<c:when test="${data.AWART eq '0111' || data.AWART eq '0112' || data.AWART eq '0113'}">
	             			<spring:message code='LABEL.D.D03.0045'/><!-- 보상휴가 -->
	             		</c:when>
	             		<c:otherwise>
	             			<spring:message code='LABEL.D.D03.0046'/><!-- 휴가(연차,경조,공가 등) -->
	             		</c:otherwise>
	             	</c:choose>
	             </td>
			</tr>
			</c:if>
            <tr>
	             <th  width="95"><spring:message code='LABEL.D.D19.0016'/><!-- 휴가구분 --></th>
	             <td  >
	               <input type="text" name="AWART" value="${ data.AWART }" class="input04" size="10" readonly>
	               ${ strAwrt }
	             </td>
			</tr>
			<tr>
	             <th  width="95"><spring:message code='LABEL.D.D19.0005'/><!--신청사유--></th>
	             <td >
					<c:if test=' (data.AWART==("0130")||data.AWART==("0370")) && !data.CONG_CODE==("") '>
			              <!--CSR ID:1225704-->
			              <select name="CONG_CODE" class="input04" disabled>
			                <option value="">-------------</option>
			                ${ f:printCodeOption(congVT, data.CONG_CODE) }
			              </select>
					</c:if>
							<input type="text" name="REASON" value="${ OVTM_CDNM } ${ data.REASON }"
							class="input04" size="80" readonly>
					</td>
				</tr>

	           <c:if test=' YaesuYn==("Y") ' > //CSR ID:1546748 %>
		           <tr id="OvtmName" >
		             <th  width="105"><spring:message code='LABEL.D.D15.0161'/><!--대근자--></th>
		             <td  >
			             <input type="text" name="OVTM_NAME" value="${ data.OVTM_NAME }"
			             	class="input04" size="20" readonly>
		             </td>
		           </tr>
	           </c:if>
	           <tr>
		             <th  width="95"><spring:message code='LABEL.D.D05.0085'/><!--잔여휴가일수--></th>
		             <td  style="padding:0px">

		               <table  border="0" cellpadding="0" cellspacing="0">
		                 <tr style="padding:0px">
		                   <td class="noBtBorder" >
	                   		<c:choose>
		                     <c:when test='${data.REMAIN_DATE} < 0 '>
			                     <input type="text" name="P_REMAIN" size="5" class="input04" value="0.0" style="text-align:right" readonly>
			                     <spring:message code='LABEL.D.D03.0022'/><!--일-->
		                     </c:when>
		                     <c:otherwise>
<%-- 			                     <input type="text" name="P_REMAIN" size="10" class="input04" value="${ data.REMAIN_DATE==("0") ? "0" : f:printNumFormat(data.REMAIN_DATE, 1) }" style="text-align:right" readonly>  --%>
			                     <input type="text" name="P_REMAIN" size="5" class="input04" value="${ dataRemain.ZKVRB==("0") ? "0" : f:printNumFormat(dataRemain.ZKVRB, 1) }" style="text-align:right" readonly>
			                     <spring:message code='LABEL.D.D03.0022'/><!--일-->
			                     <span>${dataRemain.ZKVRBTX}</span>
		                     </c:otherwise>
		                     </c:choose>
		                    </td>

								<%--
										               <c:if test='${ user.companyCode==("N100") }'>
										                       <c:if test='${ !ZKVRB2==("0") }'>

												                   <td width="30"> </td>
												                   <td  width="125"><spring:message code='LABEL.D.D03.0018'/><!--교대휴가 잔여일수--></td>
												                   <td >
												                     <input type="text" name="P_REMAIN3" size="10" class="input04" value="${ ZKVRB2==("0") ? "0" : f:printNumFormat(ZKVRB2, 1) }" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
												                   </td>
												               </c:if>

									               		</c:if>
						                       <c:choose>
						                       <c:when test='${ !ZKVRB1==("0") }'>

										                   <td width="30"> </td>
										                   <td  width="125"><spring:message code='LABEL.D.D03.0019'/><!--사전부여휴가 잔여일수--></td>
										                   <td >
										                     <input type="text" name="P_REMAIN2" size="10" class="input04" value="${ ZKVRB1==("0") ? "0" : f:printNumFormat(ZKVRB1, 1) }" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
										                   </td>

						                       </c:when>
												</c:choose>
								 --%>
                       <c:if test='${ ZKVRB1 !=("0") }'>

						                   <td > </td>
						                   <td  ><spring:message code='LABEL.D.D03.0020'/><!--사전부여휴가--></td>
						                   <td >
						                     <input type="text" name="P_REMAIN2" size="5" class="input04" value="${ ZKVRB1==("0") ? "0" : f:printNumFormat(ZKVRB1, 1) }" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
						                   </td>
			               </c:if>
	                       <c:if test='${ ZKVRB2 !=("0") }'>

						                   <td > </td>
						                   <td ><spring:message code='LABEL.D.D03.0021'/><!--선택적보상휴가--></td>
						                   <td >
						                     <input type="text" name="P_REMAIN3" size="5" class="input04" value="${ ZKVRB2==("0") ? "0" : f:printNumFormat(ZKVRB2, 1) }" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
						                   </td>

		               		</c:if>


		                  <th class="th02" width=20%>
		                  		<spring:message code='LABEL.D.D03.0200'/><!-- Use rate(%) -->
		                	</th>
		                	<td >
		                		 <input class="noBorder" type="text" name="REMAINDAYS" size="4" value="${f:printNumFormat(dataRemain.ABWTG /  dataRemain.OCCUR * 100, 2 )}" />(
		                		 <input class="noBorder" type="text" name="ABWTG" size="4" value="${dataRemain.ABWTG}" />/
		                		 <input class="noBorder" type="text" name="OCCUR" size="4" value="${dataRemain.OCCUR}" />)
		                  </td>

		                 </tr>
		               </table>
		             </td>
		           </tr>

		           <tr>
		             <th  width="95"><spring:message code='LABEL.D.D12.0003'/><!--신청기간--></th>
		             <td >
		               <input type="text" name="APPL_FROM"
		               	value="${ f:printDate(data.APPL_FROM) }" size="20" class="input04" readonly>
		               <spring:message code='LABEL.D.D19.0024'/><!--부터-->

		               <!--// 경조금의 경우, 일시적으로 막음. 2004.7.14. mkbae.-->
		               <c:choose>
		               <c:when test='${ data.AWART==("0130")||data.AWART==("0370") }'>
		               		<input type="text" name="APPL_TO"
	               			value="${  f:printDate(data.APPL_TO)   }" size="20" class="input04" readonly>
		              <spring:message code='LABEL.D.D19.0025'/><!--까지-->
		               </c:when>
		               <c:otherwise>

				               <input type="text" name="APPL_TO"
				               value="${  f:printDate(data.APPL_TO)   }" size="20" class="input04" readonly>
				               <spring:message code='LABEL.D.D19.0025'/><!--까지-->
				                ${ data.PBEZ4==("0") || data.PBEZ4==("") ? "" : f:printNumFormat(data.PBEZ4, 0)  }<spring:message code='LABEL.D.D03.0036'/><!-- 일간 -->

		               </c:otherwise>
		               </c:choose>

		             </td>
		           </tr>

		           <tr id="requestTime"><!--//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha-->
		             <th  width="95"><spring:message code='LABEL.D.D03.0023'/><!--신청시간--></th>
			             <td  >
			               <input type="text" name="BEGUZ" value="${ data.BEGUZ==("") ? "" : f:printTime(data.BEGUZ) }" size="20" class="input04" readonly>
			               <spring:message code='LABEL.D.D19.0024'/><!--부터-->
			               <input type="text" name="ENDUZ" value="${ data.ENDUZ==("") ? "" : f:printTime(data.ENDUZ) }" size="20" class="input04" readonly>
			               <spring:message code='LABEL.D.D19.0025'/><!--까지-->
			                ${ data.BEGUZ==("") && data.ENDUZ==("") ? "" : f:printNumFormat(f:getBetweenTime(data.BEGUZ, data.ENDUZ), 2)  }<spring:message code='LABEL.D.D07.0005'/><!-- 시간 -->
			             </td>
		           	</tr>

		           <tr>
			             <th width="95"><spring:message code='LABEL.D.D03.0035'/><!--휴가공제일수--></th>
			             <td  >
			               	<input type="text" name="DEDUCT_DATE" value="${ data.DEDUCT_DATE==("0") ? "" : f:printNumFormat(data.DEDUCT_DATE, 1) }" size="20" class="input04" style="text-align:right" readonly>
			               	<spring:message code='LABEL.D.D03.0022'/><!--일-->
		             	</td>
		           </tr>
			</table>
       <!-- 컨텐츠 전체 테이블 끝-->
		</div>

        <div class="table">
			  	<table width="780" border="0" cellpadding="0" cellspacing="1" class="tableGeneral">
			  		<tr>
			  			<th width="95" ><spring:message code='LABEL.D.D03.0039'/><!-- 취소신청일--></th>
			              <td >${f:printDate(f:currentDate())}</td>
			  		</tr>
			  		<tr>
			  			<th width="95" ><span class="textPink">*</span>
			  					<spring:message code='LABEL.D.D03.0007'/><!-- 취소사유--></th>
			              <td >
			              	<input type="text" id="CANC_REASON" name="CANC_REASON" value="" class="input03" size="100" maxlength="80">
			              </td>
			  		</tr>
			  	</table>
		</div>
	</div>
	<!-- 전체테이블 끝 -->


	</tags-approval:request-layout>

</tags:layout>
