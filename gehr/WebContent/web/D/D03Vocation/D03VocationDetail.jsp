<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        		*/
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 휴가 상세                                                   		*/
/*   Program ID   : D03VacationDetail.jsp                                       */
/*   Description  : 휴가 상세내용 화면                                          		*/
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-03-04  유용원                                          		*/
/*                : 2008-03-14  CSR ID:1225704 경조선택시 경조내역조회팝업추가  		*/
/*                : 2011-09-16  CSR ID:C20110915_62868   인사하위영역이 파주공장(BBIA) 이고 기능직인 경우 휴일비근무 신청가능하게  */
/*                : 2011-10-25  ※CSR ID:C20111025_86242   모성보호휴가 유형추가 :0190 */
/*                : 2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청 */
/*                : 2016-09-20 통합구축 - 김승철                     				*/
/*				  : 2017-07-20 eunha [CSR ID:3438118] flexible time 시스템 요청	*/
/*				  : 2017-10-12 eunha [CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 */
/*				  : 2018-05-17 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils"%>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.G.rfc.ApprovalCancelCheckRFC" %>

<%
    WebUserData user =(WebUserData)session.getAttribute("user");

    /* 장치교대근무자 체크
    */
    D03RemainVocationData dataRemain = (D03RemainVocationData)request.getAttribute("d03RemainVocationData");

    /* 휴가신청 */
    Vector  d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    D03VocationData       data = (D03VocationData)d03VocationData_vt.get(0);
    
    String E_AUTH = (String) request.getAttribute("E_AUTH")==null?"":(String) request.getAttribute("E_AUTH");

    D03GetWorkdayRFC func = new D03GetWorkdayRFC();
    Object D03GetWorkdayData_vt = func.getWorkday( data.PERNR, DataUtil.removeSeparate(data.BEGDA) );
    // 사전부여휴가 잔여일수
    String ZKVRB1 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB1");
    // 선택적보상휴가 잔여일수
    String ZKVRB2 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB2");

    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");

    //CSR ID:1546748
    String OVTM_CDNM = "";
    if (!data.OVTM_CODE.equals("")){

         String DATUM     = DataUtil.getCurrentDate();
         Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(PERNR_Data.E_BUKRS, data.PERNR, data.AWART,data.BEGDA);
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

    // 2007.12.20. 전LG석유화학 휴일비근무 전문기술직만 신청 추가
    // C20110915_62868 인사하위영역이 파주공장(BBIA) 이고 기능직인 경우 휴일비근무 신청가능하게
    // [CSR ID:2583929] 생산기술직 38 추가
    String H0340_Yes = "";
    if( PERNR_Data.E_PERSK.equals("31") || ( E_BTRTL.equals("BBIA") && ( PERNR_Data.E_PERSK.equals("33") || PERNR_Data.E_PERSK.equals("38") ) ) ) {
 		H0340_Yes = "Y";
    }
    String WOMAN_YN = "";

    if( !PERNR_Data.E_REGNO.equals("") && (PERNR_Data.E_REGNO.substring(6,7).equals("2")||PERNR_Data.E_REGNO.substring(6,7).equals("4")||PERNR_Data.E_REGNO.substring(6,7).equals("6")||PERNR_Data.E_REGNO.substring(6,7).equals("8")||PERNR_Data.E_REGNO.substring(6,7).equals("0")) ) {
       WOMAN_YN ="Y";
    }

    E19CongCodeNewRFC e19rfc = new E19CongCodeNewRFC();
    Vector congVT = e19rfc.getCongCode(user.companyCode,"X");

    String chkApp = "N";
    //결재취소가능여부
    ApprovalCancelCheckRFC chkRfc = new ApprovalCancelCheckRFC();
    chkRfc.get(data.PERNR, data.AINF_SEQN);
    chkApp = chkRfc.getReturn().MSGTY;

	String remainDays = dataRemain.OCCUR.equals("0")?"0":Float.toString(NumberUtils.toFloat(dataRemain.ABWTG)  / NumberUtils.toFloat(dataRemain.OCCUR) * 100);

%>


<c:set var="user" value="<%=user%>"/>
<c:set var="data" value="<%=data%>"/>
<c:set var="ename" value="<%=PERNR_Data.E_ENAME%>"/>
<c:set var="PERNR_Data" value="<%=PERNR_Data%>"/>
<c:set var="E_BTRTL" value="<%=E_BTRTL%>"/>
<c:set var="ZKVRB1" value="<%=ZKVRB1%>"/>
<c:set var="ZKVRB2" value="<%=ZKVRB2%>"/>
<c:set var="YaesuYn" value="<%=YaesuYn%>"/>
<c:set var="H0340_Yes" value="<%=H0340_Yes%>"/>
<c:set var="WOMAN_YN" value="<%=WOMAN_YN%>"/>
<c:set var="congVT" value="<%=congVT%>"/>
<c:set var="OVTM_CDNM" value="<%=OVTM_CDNM%>"/>
<c:set var="dataRemain" value="<%=dataRemain%>"/>
<c:set var="remainDays" value="<%=remainDays%>"/>
<c:set var="I_APGUB" value="<%=request.getAttribute("I_APGUB")%>"/><!-- //'1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서 -->

<c:set var="isUpdate" value="<%=request.getAttribute("isUpdate")%>"/>
<c:set var="chkApp" value="<%=chkApp%>"/>

<c:set var="E_AUTH" value="<%=E_AUTH%>"/>


<tags:layout css="ui_library_approval.css"  script="dialog.js" >


<script language="JavaScript">
<!--
//**********수정 부분 끝.****************************

    //승인완료된건 결재취소로직
    function appCancelPop(){
    	//팝업띄우기
    	window.open("/servlet/servlet.hris.D.D03Vocation.D03VocationCancelBuildSV?AINF_SEQN=${data.AINF_SEQN}","결재취소요청",
    			"toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=1030,height=675,left=100,top=10");
    }
    //승인완료된건 결재취소로직
    function appCancel(){
		 blockFrame();
   	  document.form2.submit();
    }
	$(function(){
		if (${data.PERNR eq user.empNo and chkApp=="Y" and I_APGUB=="3" and approvalHeader.AFSTAT =='03' }){
	       	   $(".btn_crud").html(" <li><a class='darken' href='javascript:appCancel();'> "+
	       	   "<span><spring:message code='BUTTON.COMMON.APPRCANCELREQ'/><!--승인취소요청-->"+
	       	   "</span></a></li> " + $(".btn_crud").html());
		}

		//[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 start
		if (! ("${data.AWART}"=="0120"  || "${data.AWART}"=="0121" || "${data.AWART}"=="0190" || "${data.AWART}"=="0180" )){// 반일휴가(전반), 반일휴가(후반), 시간공가,모성보호휴가
	    	$('#requestTime').attr('style','display:none');
		}
		//[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 end
		//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha start
		 if (${ PERNR_Data.e_PERSK==("21")||PERNR_Data.e_PERSK==("22") }){
		    	if ( "${data.AWART}"=="0120"  || "${data.AWART}"=="0121" ){
		    		$('#requestTime').attr('style','display:none');

		    	}
		 }
		 //[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha end
	});
 //-->
</script>
 <!-- 휴가 -->
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO"
    	updateUrl="${g.servlet}hris.D.D03Vocation.D03VocationChangeSV"    	>

        <!-- 상단 입력 테이블 시작-->

    <tags:script>
	</tags:script>

<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
          	<colgroup>
          	<col width=15%/>
          	<col width=50%/>
          	<col width=15%/>
          	<col width=20%/>
          	</colgroup>

				<input type="hidden" name="BEGDA" value="${ data.BEGDA }" size="20"  readonly>    <!-- 상단 입력 테이블 시작-->


			  <c:if test="${E_AUTH eq 'Y'}">
              <tr>
	               <th rowspan=1><spring:message code='LABEL.D.D03.0043'/><!-- 휴가유형 --></th>
	               <td colspan=3>
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
                  <th rowspan=1><spring:message code='LABEL.D.D19.0016'/><!-- 휴가구분 --></th>
                  <td colspan=3>
	                   <strong>
                   <input type="text" name="AWART" value="${ data.AWART } <spring:message code='LABEL.D.D03.${ data.AWART }'/>"   readonly>

	             <%--Start: Radio를 Text로 변경
	                    <c:if test=' ${ data.AWART==("0110") }'>         <spring:message code='LABEL.D.D03.0110'/></c:if> <!--전일휴가-->
	                    <c:if test=' ${ data.AWART==("0120") }' >                    <spring:message code='LABEL.D.D03.0120'/></c:if><!--반일휴가(전반)-->
	                    <c:if test=' ${ data.AWART==("0121") }' >                    <spring:message code='LABEL.D.D03.0121'/></c:if><!--반일휴가(후반)-->
						<c:if test='${ user.companyCode==("N100") }'>
						        <c:if test='${data.AWART==("0122") }'>					                    <spring:message code='LABEL.D.D03.0122'/><!--토요휴가-->						</c:if>
						</c:if>
						<c:if test='${ H0340_Yes==("Y") }' >					                    <spring:message code='LABEL.D.D03.0340'/><!--휴일비근무-->					</c:if>
						<c:if test='${ WOMAN_YN==("Y") }'>
		                       <c:if test='${ data.AWART==("0190") }'>					                          <spring:message code='LABEL.D.D03.0190'/></c:if><!--모성보호휴가-->
						</c:if>


	                    <c:if test='${ data.AWART==("0140")}'>                      <spring:message code='LABEL.D.D03.0140'/></c:if><!--하계휴가-->
	                    <c:if test='${ data.AWART==("0130")||data.AWART==("0370")}'>                    <spring:message code='LABEL.D.D03.0130'/></c:if><!--경조휴가-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                    <c:if test='"${ data.AWART}" ${ data.AWART==("0170")}'>                   <spring:message code='LABEL.D.D03.0170'/></c:if><!--전일공가-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                    <c:if test='${ data.AWART==("0180")}'>                   <spring:message code='LABEL.D.D03.0180'/></c:if><!--시간공가-->&nbsp;&nbsp;&nbsp;

						<!-- //  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다. -->
						<c:if test='${  WOMAN_YN==("Y")}'>
			                    <c:if test='${ data.AWART==("0150")}'>		                    <spring:message code='LABEL.D.D03.0150'/></c:if><!--보건휴가-->
						</c:if>
					</strong>
             <%--End: Radio를 Text로 변경  --%>

<%--
                    <input type="radio" name="awart" value="0110" ${ data.AWART==("0110") ? "checked" : "" } disabled>
                    <spring:message code='LABEL.D.D03.0110'/><!--전일휴가-->
                    <input type="radio" name="awart" value="0120" ${ data.AWART==("0120") ? "checked" : "" } disabled>
                    <spring:message code='LABEL.D.D03.0120'/><!--반일휴가(전반)-->
                    <input type="radio" name="awart" value="0121" ${ data.AWART==("0121") ? "checked" : "" } disabled>
                    <spring:message code='LABEL.D.D03.0121'/><!--반일휴가(후반)-->

					<!-- //  2002.08.16. LG석유화학 휴일비근무 신청 추가 -->
					<c:if test='${ user.companyCode==("N100") }'>
					        <c:if test='${data.AWART==("0122") }'>
					<!--          // 2004.07.01 이전 토요휴가 신청건을 조회할때는 토요휴가 래디오 버튼을 보여준다. (2004.09.15) KDS -->

					                    <input type="radio" name="awart" value="0122" ${ data.AWART==("0122") ? "checked" : "" } disabled>
					                    <spring:message code='LABEL.D.D03.0122'/><!--토요휴가-->&nbsp;&nbsp;&nbsp;
							</c:if>
					</c:if>



					<!-- //  2007.12.20. 전LG석유화학 휴일비근무 전문기술직만 신청 추가 , 또는 파주공장BBIA 이고 기능직33 인경우 가능 -->
					<c:if test='${ H0340_Yes==("Y") }' >


					                    <input type="radio" name="h0340" value="0340" ${ data.AWART==("0340") ? "checked" : "" } disabled>
					                    <spring:message code='LABEL.D.D03.0340'/><!--휴일비근무-->
					</c:if>



					<!-- //  ※CSR ID:C20111025_86242 2011.10.25. 여사원일경우 모성보호휴가  신청  -->
					<c:if test='${ WOMAN_YN==("Y") }'>
					                       <input type="radio" name="awart" value="0190" onClick="javascript:chk_del(1);javascript:click_radio(this);" ${ data.AWART==("0190") ? "checked" : "" }>
					                          <spring:message code='LABEL.D.D03.0190'/><!--모성보호휴가-->
					</c:if>

                  </td>
                </tr>

                <tr>

                  <td colspan=3>
                    <input type="radio" name="awart" value="0140" ${ data.AWART==("0140") ? "checked" : "" } disabled>
                      <spring:message code='LABEL.D.D03.0140'/><!--하계휴가-->
                    <input type="radio" name="awart" value="0130" ${ data.AWART==("0130")||data.AWART==("0370")  ? "checked" : "" } disabled>
                    <spring:message code='LABEL.D.D03.0130'/><!--경조휴가-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="awart" value="${ data.AWART}" ${ data.AWART==("0170")? "checked" : "" } disabled>
                   <spring:message code='LABEL.D.D03.0170'/><!--전일공가-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="awart" value="0180" ${ data.AWART==("0180") ? "checked" : "" } disabled>
                   <spring:message code='LABEL.D.D03.0180'/><!--시간공가-->&nbsp;&nbsp;&nbsp;

					<!-- //  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다. -->
					<c:if test='${  WOMAN_YN==("Y")}'>

		                    <input type="radio" name="awart" value="0150" ${ data.AWART==("0150") ? "checked" : "" } disabled>
		                    <spring:message code='LABEL.D.D03.0150'/><!--보건휴가-->
					</c:if>
		                  </td>
		                </tr>

 --%>

		                <tr>
		                  <th ><spring:message code='LABEL.D.D19.0005'/><!--신청사유--></th>
		                  <td colspan=3>

							<c:if test='${ data.AWART==("0130") ||data.AWART==("0370") }'>
			                    <!--CSR ID:1225704-->
			                    <select name="CONG_CODE"  disabled readonly>
			                      <option value="">-------------</option>
			                      ${ f:printCodeOption(congVT, data.CONG_CODE) }
			                    </select>
							</c:if>
							${ OVTM_CDNM }
                    <input type="text" name="REASON" value=" ${ data.REASON }" size="80" readonly>
                  </td>
                </tr>
                <%-- //if( YaesuYn==("Y") ) { //CSR ID:1546748 --%>

                <c:if test='${   data.OVTM_NAME !=("")  }'>
<!--                  //여수 외에 대산도 추가되어 변경함 13.11.22 %> -->

                <tr id="OvtmName" >
	                  <th  width="105"><spring:message code='LABEL.D.D15.0161'/><!--대근자-->&nbsp;</th>
	                  <td colspan=3>
	                  		<input type="text" name="OVTM_NAME" value="${ data.OVTM_NAME }"  size="20" readonly>
	                  </td>
                </tr>

                </c:if>

                <tr>
                  <th  ><spring:message code='LABEL.D.D05.0085'/><!--잔여휴가일수--></th>
                  <td style="padding:0px">
                    <table border="0" cellpadding="0" cellspacing="0">
                      <tr style="padding:0px">
                        <td class="noBtBorder"  >

                        <c:choose>
                          <c:when test='${ data.REMAIN_DATE=="0"  }'><!--  Double.parseDouble( x)  < 0.0 -->
    	                      <input type="text" name="P_REMAIN" size="5"
    	                      value="0.0" style="text-align:right" readonly> 일
                          </c:when>
                          <c:otherwise>
	                          <input type="text" name="P_REMAIN" size="5"
	                          value="${ data.REMAIN_DATE==("0") ? "0" : f:printNumFormat(data.REMAIN_DATE, 1) }"
	                           style="text-align:right" readonly> 일
	                           <span>${dataRemain.ZKVRBTX}</span>
                          </c:otherwise>
                          </c:choose>


                          </td>
				<c:choose>
											<c:when test=' user.companyCode==("N100") }'>
											        <c:if test='${ ZKVRB2!=("0") }'>

							                        <td class="noBtBorder"  > </td>
							                        <td class="noBtBorder"  ><spring:message code='LABEL.D.D03.0018'/><!--교대휴가 잔여일수--></td>
							                        <td class="noBtBorder"   >
							                          <input type="text" name="P_REMAIN3" size="5"
							                          value="${ ZKVRB2==("0") ? "0" : f:printNumFormat(ZKVRB2, 1) }" style="text-align:right" readonly>
							                          <spring:message code='LABEL.D.D03.0022'/><!--일-->
							                        </td>

										        </c:if>

										        <c:if test='${ ZKVRB1!=("0") }'>

							                        <td class="noBtBorder" > </td>
							                        <td class="noBtBorder"   ><spring:message code='LABEL.D.D03.0019'/><!--사전부여휴가 잔여일수--></td>
							                        <td class="noBtBorder"  >
							                          <input type="text" name="P_REMAIN2" size="5"
							                           value="${ ZKVRB1==("0") ? "0" : f:printNumFormat(ZKVRB1, 1) }" style="text-align:right" readonly>
							                           <spring:message code='LABEL.D.D03.0022'/><!--일-->
							                        </td>

										        </c:if>
										</c:when>
			<c:otherwise>


			<c:if test='${ ZKVRB1 !=("0") }'>
                        <td class="noBtBorder"  > </td>
                        <td class="noBtBorder"   ><spring:message code='LABEL.D.D03.0020'/><!--사전부여휴가--></td>
                        <td class="noBtBorder"  >
                          <input type="text" name="P_REMAIN2" size="5"
                          value="${ ZKVRB1==("0") ? "0" : f:printNumFormat(ZKVRB1, 1) }" style="text-align:right" readonly>
                          <spring:message code='LABEL.D.D03.0022'/><!--일-->
                        </td>
			</c:if>

			<c:if test='${ ZKVRB2!=("0") }'>
                        <td class="noBtBorder"  > </td>
                        <td class="noBtBorder"   ><spring:message code='LABEL.D.D03.0021'/><!--선택적보상휴가--></td>
                        <td class="noBtBorder"  >
                          <input type="text" name="P_REMAIN3" size="5"
                          value="${ ZKVRB2==("0") ? "0" : f:printNumFormat(ZKVRB2, 1) }" style="text-align:right" readonly>
                          <spring:message code='LABEL.D.D03.0022'/><!--일-->
                        </td>
			</c:if>

		</c:otherwise>
		</c:choose>

                      </tr>
                    </table>
                  </td>

                  <th class="th02">
                  		<spring:message code='LABEL.D.D03.0200'/><!-- 휴가사용율 Use rate(%) -->
                	</th>
	                <td colspan=3>
	                	 <input class="noBorder" type="text" name="REMAINDAYS" size="4" value="${f:printNumFormat(remainDays,2)}" />(
	                	 <input class="noBorder" type="text" name="ABWTG" size="4" value="${dataRemain.ABWTG}" />/
	                	 <input class="noBorder" type="text" name="OCCUR" size="4" value="${dataRemain.OCCUR}" />)
	                </td>
                </tr>

                <tr>
                  <th  ><spring:message code='LABEL.D.D12.0003'/><!--신청기간--></th>

                  	<!-- @rdcamel colspan 제어 -->
                  	<!--  <td colspan=3> -->
                	<td colspan="${dataRemain.OCCUR3 !='0' ? '1':'3' }">
					<!-- @rdcamel colspan 제어  end -->

                    <input type="text" name="APPL_FROM" value="${  f:printDate(data.APPL_FROM) }" size="10"  readonly>
                   <spring:message code='LABEL.D.D19.0024'/><!--부터-->
                    <!--// 경조금의 경우, 일시적으로 막음. 2004.7.14. mkbae.-->
                    <c:choose>
                    <c:when test='${ data.AWART==("0130") }'>
		                    <input type="text" name="APPL_TO"   value="${  f:printDate(data.APPL_TO)   }" size="10"  readonly>
		                   <spring:message code='LABEL.D.D19.0025'/><!--까지-->
                    </c:when>
                    <c:otherwise>
		                    <input type="text" name="APPL_TO"   value="${  f:printDate(data.APPL_TO)   }" size="10"  readonly>
		                   <spring:message code='LABEL.D.D19.0025'/><!--까지-->
		                   	 <c:if test='${ data.PBEZ4 *100 > 0 }'>
			                   	  	${f:printNumFormat(data.PBEZ4, 0)}
	  		                      <spring:message code='LABEL.D.D03.0036'/><!-- 일간 -->
  		                      </c:if>
                    </c:otherwise>
                    </c:choose>

                  </td>

                 <!-- @rdcamel 추가 -->
				 <c:if test='${ dataRemain.OCCUR3 !="0" }'>
						<th class="th02">
	                  		유연 휴가
	                	</th>
						<td >
	                		 <input class="noBorder" type="text" name="ABWTG3" size="3" value="${f:printNumFormat(dataRemain.ABWTG3,1)}" />/
	                		 <input class="noBorder" type="text" name="OCCUR3" size="3" value="${f:printNumFormat(dataRemain.OCCUR3,1)}" />일
	                  	</td>
				 </c:if>
				 <!-- @rdcamel 추가 end-->
                </tr>


                <tr id="requestTime"><!--//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha-->
                  <th  ><spring:message code='LABEL.D.D03.0023'/><!--신청시간--></th>
                  <td colspan=3>
                    <input type="text" name="BEGUZ" value="${ data.BEGUZ==("") ? "" : f:printTime(data.BEGUZ) }" size="10"  readonly>
                    <spring:message code='LABEL.D.D19.0024'/><!--부터-->
                    <input type="text" name="ENDUZ" value="${ data.ENDUZ==("") ? "" : f:printTime(data.ENDUZ) }" size="10"  readonly>
                   <spring:message code='LABEL.D.D19.0025'/><!--까지-->
                   	 ${ data.BEGUZ==("") && data.ENDUZ==("") ? "" : f:printNumFormat(f:getBetweenTime(data.BEGUZ, data.ENDUZ), 2) }
                      ${ data.BEGUZ==("") && data.ENDUZ==("") ? "" :" 시간"}
                  </td>
                </tr>

                <tr>
                  <th  ><spring:message code='LABEL.D.D03.0035'/><!--휴가공제일수--></th>
                  <td colspan=3>
                    <input type="text" name="DEDUCT_DATE" value="${ data.DEDUCT_DATE==("0") ? "" : f:printNumFormat(data.DEDUCT_DATE, 1) }" size="10"  style="text-align:right" readonly>
                    <spring:message code='LABEL.D.D03.0022'/><!--일-->
                  </td>
                </tr>
              </table>
     	</div></div>


    </tags-approval:detail-layout>

	<form name="form2" method="post" action="/servlet/servlet.hris.D.D03Vocation.D03VocationCancelBuildSV">

	  <input type="hidden" name="AINF_SEQN" value="${data.AINF_SEQN}">
	</form>


</tags:layout>



