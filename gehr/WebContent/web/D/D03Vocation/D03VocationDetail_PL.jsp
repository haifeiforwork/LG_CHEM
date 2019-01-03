<%/******************************************************************************/
/*   System Name  	: MSS                                                         */
/*   1Depth Name  	: Application                                                 */
/*   2Depth Name  	: Time Management                                       */
/*   Program Name 	: Leave                                               		  */
/*   Program ID   		: D03VocationDetailPl.jsp[폴란드]                   */
/*   Description  		: 휴가 상세내용 화면                                          		  */
/*   Note         		:                                                                 */
/*   Creation     		: 2010-07-26 yji                                            */
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
    
//    String P_STDAZ2="";
    
    /* 휴가신청 */
    Vector  d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    D03VocationData       data = (D03VocationData)d03VocationData_vt.get(0);
    
    String  E_BUKRS = user.companyCode;
    Vector  HolidayAbsenceData_vt = new Vector();
    
    HolidayAbsenceData_vt = ( new D03HolidayAbsenceRFC() ).getHolidayAbsence(user.empNo,data.AWART);
    for(int i=0; i<HolidayAbsenceData_vt.size(); i++){
     D03HolidayAbsenceData data2 = (D03HolidayAbsenceData)HolidayAbsenceData_vt.get(i); 
    	if(data.AINF_SEQN2.equals(data2.AINF_SEQN)){
//    	   P_STDAZ2 = data2.ABSN_DATE;
    	}
    }      
    
    Vector  Code_vt = ( new D17HolidayTypeRFC() ).getHolidayType1(data.PERNR);
    D03RemainVocationData dataRemain = (D03RemainVocationData)request.getAttribute("d03RemainVocationData");
	String remainDays = dataRemain.ANZHL_GEN.equals("0")?"0":Float.toString(NumberUtils.toFloat(dataRemain.ANZHL_USE)  / NumberUtils.toFloat(dataRemain.ANZHL_GEN) * 100);
%>
<c:set var="user" value="<%=user%>"/>
<c:set var="data" value="<%=data%>"/>
<c:set var="Code_vt" value="<%=Code_vt%>"/>

<c:set var="isUpdate" value="<%=request.getAttribute("isUpdate")%>"/>
<c:set var="dataRemain" value="<%=dataRemain%>"/>
<c:set var="remainDays" value="<%=remainDays%>"/>


<tags:layout css="ui_library_approval.css"  script="dialog.js" >

    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO" updateUrl="${g.servlet}hris.D.D03Vocation.D03VocationChangeSV">

        <!-- 상단 입력 테이블 시작-->

        <tags:script>
        
<script language="JavaScript">
<!--

//-->
</script>
</tags:script>



    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            <colgroup>
            <col width=15%/>
            <col width=35%/>
            <col width=15%/>
            <col />
            </colgroup>  

  <input type="hidden" name="timeopen" value="">
  <input type="hidden" name="BEGDA" value="${ data.BEGDA }" size="20"  readonly>    <!-- 상단 입력 테이블 시작-->
  

                <tr>
                  <th class="align_right" ><spring:message code='LABEL.D.D19.0016'/><!--  Absence Type&nbsp;--></th>
                  <td  colspan=3>
                  	<input type="text" name="ATEXT" value="${f:printOptionValueText(Code_vt,data.AWART) }"  readonly>
                   <input type="hidden" name="AWART" value="${ data.AWART }" class="input03"  >
                   </td>
                </tr>
                <tr>
                  <th  class="align_right" ><spring:message code='LABEL.D.D15.0157'/><!--Application Reason--></th>
                  <td  colspan=3>
                    <input type="text" name="APPL_REAS" value="${ data.APPL_REAS }" 
                     size="80" readonly>
                  </td>
                </tr>
                <tr> 
                  <th class="align_right" ><spring:message code='LABEL.D.D03.0025'/><!--Quota Balance--></th>
                  <td  >
                  	<input type="text" name="ANZHL_BAL" value="${ f:printNumFormat(data.ANZHL_BAL,2) }"
                  	 size="3" maxlength="15" style="ime-mode:active;text-align:right;" readonly>
                     	<spring:message code='LABEL.D.D02.0009'/><!--Days-->
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
                   <th class="align_right" ><spring:message code='LABEL.D.D12.0003'/><!--Application Period&nbsp;--></th>
                   <td  colspan=3> <input type="text" name="APPL_FROM" 
                   value="${ f:printDate(data.APPL_FROM) }" size="9"  readonly> 
                     ~ 
                    <input type="text" name="APPL_TO"   
                    	value="${ f:printDate(data.APPL_TO)   }" size="9"   readonly >  
                    <input type="text" name="ABRTG" value="${data.ABRTG } "  	size="3"  style="text-align:right;" readonly>
					<spring:message code='LABEL.D.D02.0009'/><!--Days-->
<!--                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="sp2">Maximum Available&nbsp;
                      <input type="text" name="P_STDAZ2" value="${data.ABSN_DATE}"
                        size="2" maxlength="7" style="ime-mode:active;text-align:right;" readonly> 
                      day  
                      </span>-->
                   <input type="hidden" name="AINF_SEQN2" value=""  size="3"                     readonly></td>
                   </td>
                </tr>
              </table>
                  <!-- 상단 입력 테이블 끝-->

	</div></div>
    </tags-approval:detail-layout>
    
</tags:layout>

