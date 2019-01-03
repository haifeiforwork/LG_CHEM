<%/******************************************************************************/
/*                                                                              */
/*   System Name  	: MSS                                                         */
/*   1Depth Name  	: 신청                                                        */
/*   2Depth Name  	: 근태                                                        */
/*   Program Name 	: 휴가 상세                                                   */
/*   Program ID   		: D03VacationDetail.jsp                                       */
/*   Description  		: 휴가 상세내용 화면                                          */
/*   Note         		:                                                             */
/*   Creation     		:                                                             */
/*   Update       		: 2005-03-04  유용원                                          */
/*   Update       		: 2007-09-19  li hui                                          */
/*   Update       		: 2008-02-20  김정인                                          							*/
/*                      	   휴가유형에 따른 selectbox 업무코드를 가져온다.                        */
/*							: 2017-04-19 eunha [CSR ID:3359686] 审批日期限制   남경 결재 5일제어                           */
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
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>

<%
    WebUserData user = (WebUserData)session.getAttribute("user");

    String P_STDAZ2="";

    /* 휴가신청 */
    Vector  d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    D03VocationData       data = (D03VocationData) Utils.indexOf(d03VocationData_vt, 0);

    Vector  HolidayAbsenceData_vt = new Vector();

    HolidayAbsenceData_vt = ( new D03HolidayAbsenceRFC() ).getHolidayAbsence(user.empNo,data.AWART);
    for(int i=0; i<HolidayAbsenceData_vt.size(); i++){
     D03HolidayAbsenceData data2 = (D03HolidayAbsenceData)HolidayAbsenceData_vt.get(i);
    	if(data.AINF_SEQN2.equals(data2.AINF_SEQN)){
    	   P_STDAZ2 = data2.ABSN_DATE;
    	}
    }

    //D03GetWorkdayRFC func = new D03GetWorkdayRFC();
    //Object D03GetWorkdayData_vt = func.getWorkday( user.empNo, data.BEGDA );
    // 사전부여휴가 잔여일수
    //String ZKVRB1 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB1");
    // 선택적보상휴가 잔여일수
    //String ZKVRB2 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB2");

    //**********수정부분 시작 (20050304:유용원)**********
    //**********수정 부분 끝.****************************

    Vector  Code_vt = ( new D17HolidayTypeRFC() ).getHolidayType1(data.PERNR);

    D03RemainVocationData dataRemain = (D03RemainVocationData)request.getAttribute("d03RemainVocationData");
	String remainDays = dataRemain.ANZHL_GEN.equals("0")?"0":Float.toString(NumberUtils.toFloat(dataRemain.ANZHL_USE)  / NumberUtils.toFloat(dataRemain.ANZHL_GEN) * 100);
%>

<c:set var="user" value="<%=user%>"/>
<c:set var="data" value="<%=data%>"/>

<c:set var="isUpdate" value="<%=request.getAttribute("isUpdate")%>"/>
<c:set var="Code_vt" value="<%=Code_vt%>"/>
<c:set var="dataRemain" value="<%=dataRemain%>"/>
<c:set var="remainDays" value="<%=remainDays%>"/>
<c:set var="E_BUKRS" value="<%= user.companyCode%>"/>


<tags:layout css="ui_library_approval.css"  script="dialog.js" >

    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO"
    	updateUrl="${g.servlet}hris.D.D03Vocation.D03VocationChangeGlobalSV">

        <!-- 상단 입력 테이블 시작-->

        <tags:script>

			<script language="JavaScript">
			function beforeAccept(){

			<%--[CSR ID:3359686] 审批日期限制   남경 결재 5일제어 START--%>
				<c:if test="${E_7OVER_NOT_APPROVAL =='E'}">
				 alert("<spring:message code="MSG.D.D01.0108"/>");//The request date has passed 5 working days. You could not approve it.
		        return;
			</c:if>
			<%--[CSR ID:3359686] 审批日期限制   남경 결재 5일제어 END--%>

			var flag= '${flag}';
		    	if(flag == "N"){
		    		alert("<spring:message code='MSG.D.D03.0047'/>");//You can't apply this data in payroll period");
		    		return false;
		    	}
		    	return true;
			}


			function day(){
				 if((document.form1.BEGUZ.value == "") ||(document.form1.ENDUZ.value == "") ){
				 	document.form1.I_STDAZ.value ="";
				 }else{
					 if(document.form1.ENDUZ.value == "00:00"){
					 	document.form1.ENDUZ.value = "24:00";
					 }
				     var num = Number(document.form1.ENDUZ.value.substring(0,2)) -
				     		Number(document.form1.BEGUZ.value.substring(0,2)) ;
				     if(num<0){
				    	num +=24;
				    }
					//  document.form1.I_STDAZ.value = num ;


				 }
			       if(document.form1.AWART.value=='0120'||document.form1.AWART.value=='0121'){
				   		sp2.style.visibility='';
				   }else{
				   		sp2.style.visibility='hidden';
				   }

					if(document.form1.ABRTG.value.substring(0,1) == "."){
						document.form1.ABRTG.value = "0"+document.form1.ABRTG.value;
					}
			}

			$( function(){
				day();
			})
			//-->
			</script>
			</tags:script>


<div class="tableArea">
    <div class="table">
        <table class="tableGeneral tableApproval">

            	<colgroup>
	            	<col width=15%/>
	            	<col width=35%/>
	            	<col width=15%/>
	            	<col width=35%/>
            	</colgroup>


                    <input type="hidden" name="BEGDA"
                    	value="${ data.BEGDA==('0000-00-00') ? "" : data.BEGDA }" size="20" class="noBorder" readonly>


                <tr>
                  <th ><spring:message code='LABEL.D.D19.0016'/><!--  Absence Type&nbsp;--></th>
                  <td  colspan=${ empty data.FAMY_TEXT? 3:1 } >
                  		<input class="noBorder divide" type="text" name="ATEXT" value="${f:printOptionValueText(Code_vt, data.AWART) }" size="25"  readonly >
                   <input type="hidden" name="AWART" value="${ data.AWART } "  >
	                   <c:if test='${ !empty data.FAMY_TEXT }'>
	                   		<th class="th02" ><spring:message code='LABEL.D.D03.0041'/><!--  LABEL.D.D03.0041 = Family Type--></th>
	                   		<td>
	    	                  	<input type="text" name="FAMY_TEXT" value="${ data.FAMY_TEXT } "  size="30" class="noBorder divider" readOnly>
   	                  		</td>
                      	</c:if>
                   </td>
                </tr>
                <tr>
                  <th ><spring:message code='LABEL.D.D19.0005'/><!--Application Reason&nbsp;--></th>
                  <td colspan=3>
                    <input type="text" name="APPL_REAS" value="${ data.APPL_REAS }" class="noBorder" size="80" readonly>
                  </td>
                </tr>

                <tr>
	                  <th><spring:message code='LABEL.D.D03.0025'/><!--Quota Balance--></th>
	                  <td > <input type="text" name="ANZHL_BAL" value="${ f:printNumFormat(data.ANZHL_BAL,2) }"
	                  	class="noBorder" size="4" maxlength="15" style="ime-mode:active;text-align:right;" readonly>
                        <c:choose>
	                     <c:when test="${E_BUKRS eq 'G170'}" >
    	                  	<spring:message code="LABEL.D.D01.0008"/>
        	              </c:when>
            	        <c:otherwise>
                       		<spring:message code="LABEL.D.D03.0031"/>       <!-- hours:days -->
                      	</c:otherwise>
                      	</c:choose>

	                  </td>
	                  <th class="th02">
	                  		<spring:message code='LABEL.D.D03.0200'/><!-- Use rate(%) -->
	                	</th>
	                	<td >
	                		 <input class="noBorder" type="text" name="REMAINDAYS" size="4" value="${f:printNumFormat(remainDays,2)}" />(
	                		 <input class="noBorder" type="text" name="ANZHL_USE" size="4" value="${dataRemain.ANZHL_USE}" />/
	                		 <input class="noBorder" type="text" name="ANZHL_GEN" size="4" value="${dataRemain.ANZHL_GEN}" />)
	                  </td>
                </tr>

                <tr>
                   <th ><spring:message code='LABEL.D.D12.0003'/><!--Application Period&nbsp;--></th>
                   <td colspan=3>
                   <input type="text" name="APPL_FROM" value="${  f:printDate(data.APPL_FROM) }" size="9" class="noBorder" readonly>
                     ~
                   <input type="text" name="APPL_TO"   value="${  f:printDate(data.APPL_TO)   }" size="9" class="noBorder" readonly >
              		(
                    <input type="text" name="ABRTG" value="${ f:printNumFormat(data.ABRTG,2) } "  size="4" class="noBorder"
                    	style="text-align:right;" readonly>
                    	<!-- //[CSR ID:3544114] 휴가 구분이 Compensatory Leave 이면, 신청기간 우측이 "시간" 으로 보여짐 -->
                                <c:choose>
	                            <c:when test="${E_BUKRS eq 'G170' ||( E_BUKRS eq 'G220' and data.AWART eq '0160' )}" >
	                             	<spring:message code="LABEL.D.D01.0008"/>
	                             </c:when>
	                             <c:otherwise>
	                              	<spring:message code="LABEL.D.D03.0036"/>      <!-- hours:days -->
                              	</c:otherwise>
                              	</c:choose>
                       &nbsp;) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <span id="sp2"><spring:message code='LABEL.D.D03.0026'/><!--Maximum Available&nbsp;-->
                      		<input type="text" name="P_STDAZ2" value="${data.ABSN_DATE}" class="noBorder" size="3"
                      			maxlength="7" style="ime-mode:active;text-align:right;" readonly>
                                <c:choose>
	                            <c:when test="${E_BUKRS eq 'G170'}" >
	                             	<spring:message code="LABEL.D.D01.0008"/>
	                             </c:when>
	                             <c:otherwise>
	                              	<spring:message code="LABEL.D.D03.0031"/>       <!-- hours:days -->
                              	</c:otherwise>
                              	</c:choose>
                      </span>
                   <input type="hidden" name="AINF_SEQN2" value=""  size="3" class="noBorder" readonly></td>
                   </td>
                </tr>

                <tr>
                   <th><spring:message code="LABEL.D.D03.0023"/><!-- Application Time --></th>
                   <td colspan=3>
                   		<input type="text" name="BEGUZ"
                   value="${  data.BEGUZ==("00:00:00") ? "" : f:printTime(data.BEGUZ) }" size="5"
                   class="noBorder" readonly ${ data.AWART==("0111")   ? "" : "readonly" }>
                    ~
                     <input type="text" name="ENDUZ"
                     value="${  data.ENDUZ==("00:00:00") ? "" : f:printTime(data.ENDUZ) }"
                      size="5" class="noBorder" readonly ${ data.AWART==("0111") ? "" : "readonly" }>

                     <input type="text" name="I_STDAZ" value=" ${data.STDAZ } "  size="3"
                      class="noBorder" style="text-align:right;" readonly>
	                             	<spring:message code="LABEL.D.D01.0008"/>

                  </td>
                </tr>

              </table>

			<!--  HIDDEN  처리해야할 부분 시작-->
			      <input type="hidden" name="PERNR"       value="${data.PERNR}">

			      <!-- **********수정 시작 (20050304:유용원)********** -->
			      <!-- **********수정 끝********** -->
			<!--  HIDDEN  처리해야할 부분 끝-->
		</div></div>
    </tags-approval:detail-layout>

</tags:layout>

<%--
<script>


function do_change(){
	var comp = '<%=user.companyCode%>';
	var  datetm =  <%=DataUtil.getCurrentDate()%><%= DataUtil.getCurrentTime() %>;
	if (datetm >= 20071215210000 && datetm<20071216150000 && comp=='G130' ){
		alert('数据修改中...请于2007年12月16日15时后再使用此功能!');
		return;
	}
 	if( chk_APPR_STAT(0) ){
    	document.form1.jobid.value = "first";
    	document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

    	document.form1.action = "<%= f:ServletURL %>hris.D.D03Vocation.D03VocationChangeSV?AINF_SEQN2="+document.form1.AINF_SEQN2.value+"&UPMU_CODE="+document.form1.UPMU_CODE;
    	document.form1.method = "post";
    	document.form1.submit();
  	}
}

function do_delete(){
	var comp = '<%=user.companyCode%>';
	var  datetm =  <%=DataUtil.getCurrentDate()%><%= DataUtil.getCurrentTime() %>;
	if (datetm >= 20071215210000 && datetm<20071216150000 && comp=='G130' ){
		alert('数据修改中...请于2007年12月16日15时后再使用此功能!');
		return;
	}
	if( chk_APPR_STAT(1) && confirm("Are you sure to delete?") ) {
		document.form1.jobid.value = "delete";
		document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

		document.form1.action = "<%= f:ServletURL %>hris.D.D03Vocation.D03VocationDetailSV";
		document.form1.method = "post";
		document.form1.submit();
	}
}


</script>
 --%>