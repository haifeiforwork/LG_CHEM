<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 교육, 출장 신청                                             */
/*   Program ID   : D19EduTripBuild.jsp                                         */
/*   Description  : 교육, 출장 신청                                             */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-03-08  lsa                                             */
/*   Update       : [CSR ID:2803878] 초과근무 신청 Process 변경 요청                                                            */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D19EduTrip.*" %>
<%@ page import="hris.D.D19EduTrip.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.sap.*" %>
<%@ page import="com.sap.mw.jco.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>


<%
  WebUserData user    = (WebUserData)session.getAttribute("user");
  String      jobid   = (String)request.getAttribute("jobid");
  String      message = (String)request.getAttribute("message");
  String PERNR = WebUtil.nvl((String)request.getAttribute("PERNR"),user.empNo);
  String today = WebUtil.printDate(DataUtil.getCurrentDate(),"");

  /* 교육, 출장신청 */
  Vector          D19EduTripData_vt = null;
  D19EduTripData data               = null;

  if( jobid.equals("first") ||message != null ){
    data               = new D19EduTripData();
    DataUtil.fixNull(data);
    data.AWART         = "0010";      // default 교육
    data.PERNR         = PERNR;
  } else {
    D19EduTripData_vt = (Vector)request.getAttribute("D19EduTripData_vt");
    data               = (D19EduTripData)D19EduTripData_vt.get(0);
    PERNR = data.PERNR ;
  }
  if (PERNR.equals("")||PERNR==null){
      PERNR = user.empNo;
  }
  if( message == null ){
    message = "";
  }

  //  2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
  GetTimmoRFC rfc = new GetTimmoRFC();

  String      E_RRDAT = rfc.GetTimmo( user.companyCode );
  long        D_RRDAT =  Long.parseLong(DataUtil.removeStructur(E_RRDAT,"-"));

  Vector D03VocationAReason0010_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, PERNR, "0010",DataUtil.getCurrentDate());
  Vector D03VocationAReason0020_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, PERNR, "0020",DataUtil.getCurrentDate());

  Vector D03OvertimeCodeData0010_vt  = new Vector();
  for( int i = 0 ; i < D03VocationAReason0010_vt.size() ; i++ ){
      D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0010_vt.get(i);
      CodeEntity code_data = new CodeEntity();
      code_data.code = old_data.SCODE ;
      code_data.value = old_data.STEXT ;
      D03OvertimeCodeData0010_vt.addElement(code_data);
  }

  Vector D03OvertimeCodeData0020_vt  = new Vector();
  for( int i = 0 ; i < D03VocationAReason0020_vt.size() ; i++ ){
      D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0020_vt.get(i);
      CodeEntity code_data = new CodeEntity();
      code_data.code = old_data.SCODE ;
      code_data.value = old_data.STEXT ;
      D03OvertimeCodeData0020_vt.addElement(code_data);
  }
%>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="jobid" value="<%=jobid%>" />
<c:set var="message" value="<%= message%>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="E_RRDAT" value="<%=E_RRDAT %>" />
<c:set var="D_RRDAT" value="<%=D_RRDAT %>" />
<c:set var="today" value="<%=today %>" />
<c:set var="D03OvertimeCodeData0010_vt" value="<%=D03OvertimeCodeData0010_vt %>" />
<c:set var="D03OvertimeCodeData0020_vt" value="<%=D03OvertimeCodeData0020_vt %>" />
<c:set var="D03VocationAReason0010_vt" value="<%=D03VocationAReason0010_vt %>" />
<c:set var="D03VocationAReason0020_vt" value="<%=D03VocationAReason0020_vt %>" />

<tags:layout css="ui_library_approval.css"  >

	<tags-approval:request-layout  titlePrefix="TAB.COMMON.0036">
		<tags:script>
			<script>
			function msg(){
				   //select box에 data Set

				     document.form1.AWART.value = "0010";
				   <c:if test="${!empty message}">
          				  alert("${message}");
  				 </c:if>
			}
				function OVTM_change() {
				    var inx=0;
				    if (document.form1.AWART.value  == "0010" ) {
					   <c:forEach var="row" items="${D03VocationAReason0010_vt}" varStatus="status">

				    	if ( inx == 0 ) {
				                  inx = inx +1;
				                  document.form1.OVTM_CODE.length = inx;
				                  document.form1.OVTM_CODE[inx-1].value = "";
				                  document.form1.OVTM_CODE[inx-1].text  = "-------------";
				              }
				              inx = inx +1;
				              document.form1.OVTM_CODE.length = inx;
				              document.form1.OVTM_CODE[inx-1].value = "${row.SCODE}";
				              document.form1.OVTM_CODE[inx-1].text  =  "${row.STEXT}";
				       </c:forEach>

				     }else if (document.form1.AWART.value  == "0020") {
						   <c:forEach var="row" items="${D03VocationAReason0020_vt}" varStatus="status">
				           if ( inx == 0 ) {
				                  inx = inx +1;
				                  document.form1.OVTM_CODE.length = inx;
				                  document.form1.OVTM_CODE[inx-1].value = "";
				                  document.form1.OVTM_CODE[inx-1].text  = "-------------";
				              }
				              inx = inx +1;
				              document.form1.OVTM_CODE.length = inx;
				              document.form1.OVTM_CODE[inx-1].value = "${row.SCODE}";
				              document.form1.OVTM_CODE[inx-1].text  =   "${row.STEXT}";
				           </c:forEach>
				     }
				}


				// 교육, 출장구분 체크 변경에 따른 작업 변경
				function click_radio(obj) {
				    document.form1.AWART.value = obj.value;
				    OVTM_change() ;
				}


				function beforeSubmit() {
					if (check_data()) 	return true;
                }

				// data check..
				function check_data(){
				  // 교육, 출장구분
				  // awart_temp  = document.form1.AWART.value;
				  after_remainSetting();
				  // 신청사유-80 입력시 길이 제한
				  x_obj = document.form1.REASON;
				  xx_value = x_obj.value;
				  if( xx_value != "" && checkLength(xx_value) > 80 ){
				    x_obj.value = limitKoText(xx_value, 80);
				    //alert("신청사유는 한글 40자, 영문 80자 이내여야 합니다.");
				    alert("<spring:message code="MSG.D.D19.0003"/>");
				    x_obj.focus();
				    x_obj.select();
				    return false;
				  }

				  date_from  = removePoint(document.form1.APPL_FROM.value);
				  date_to    = removePoint(document.form1.APPL_TO.value);

				  if( date_from > date_to ) {
				    //alert("신청시작일이 신청종료일보다 큽니다.");
				    alert("<spring:message code="MSG.D.D19.0005"/>");
				    return false;
				  }
				  beguz  = removeColon(document.form1.BEGUZ.value);
				  enduz  = removeColon(document.form1.ENDUZ.value);

				  if( (date_from != date_to )&& (beguz != "" ||enduz!= "" )) {
				   //alert("시간은 당일만 입력 가능합니다.");
				   alert("<spring:message code="MSG.D.D19.0006"/>");
				    document.form1.BEGUZ.value = "";
				    document.form1.ENDUZ.value = "";

				    return false;
				  }
				  else {

				      if( beguz > enduz ) {
				        //alert("신청시작시간이 신청종료시간보다 큽니다.");
				        alert("<spring:message code="MSG.D.D19.0007"/>");
				        return false;
				      }
				  }

				  //[CSR ID:2803878] 근태 3개월 이상 벌어지면 Alert
				    var today = "${today}";
				         today = today+"";
				    var today_3month = getAfterMonth(addSlash(today),3);
				    var from_num = Number(removePoint(document.form1.APPL_FROM.value));
				    if ( from_num>today_3month ){
				        //alert("교육/출장일을 다시 확인하시기 바랍니다.");
				        alert("<spring:message code="MSG.D.D19.0008"/>");
				        document.form1.APPL_FROM.focus();
				        document.form1.APPL_FROM.select();
				        return false;
				    }

				  // default값 setting..
				  document.form1.BEGDA.value       = removePoint(document.form1.BEGDA.value);
				  document.form1.APPL_FROM.value   = date_from;
				  document.form1.APPL_TO.value     = date_to;
				  if (beguz =="") {
				      document.form1.BEGUZ.value       = "";
				      document.form1.ENDUZ.value       = "";
				  }
				  else {
				      document.form1.BEGUZ.value       = beguz+"00";
				      document.form1.ENDUZ.value       = enduz+"00";
				  }
				  return true;
				}

				//시간입력시 호출하는 펑션 - 꼭 필요함.
				function check_Time(){

				}

				//2002.12.20. - 잔여교육, 출장일수 다시 계산에서 보여주기
				function after_remainSetting(){
				  remainSetting("APPL_FROM");
				}

				function remainSetting(_id) {
					var _date = $("#" + _id).stripVal();
				  if(checkDate(_date, false)) {
//				    var applFrom = removePoint(obj.value);
				    if( _date < "${D_RRDAT}" ) {
				    alert("<spring:message code='MSG.D.D19.0007' arguments='${f:printDate(E_RRDAT)}' />");
				     $("#" + _id).focus();
				      return false;
				    }
				  }

				}
/*
				$("#APPL_FROM").datepicker({ onSelect: function(dateText,inst) {
							after_remainSetting();
					  }
				});
*/


				$(function() {
					msg();
				      if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);

				});
			</script>
	  </tags:script>
		<!-- 상단 입력 테이블 시작-->
		<%--@elvariable id="resultData" type="hris.D.D19EduTrip.D19EduTripData"--%>
   <!-- 상단 입력 테이블 시작-->
   <c:choose>
   <c:when  test="${empty D03VocationAReason0010_vt && empty message}">
    <div class="align_center">
        <spring:message code="MSG.D.D19.0010"/> <!-- 여수 사업장만 신청 가능합니다. -->
    </div>
   </c:when>
   <c:otherwise>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            <colgroup>
                <col width="15%">
                <col width="85%">
            </colgroup>
                <tr>
                  <th><span class="textPink">*</span><spring:message code="LABEL.D.D19.0003"/> <!-- 신청구분 --></th>
                  <td>
                  <input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" readonly>
                    <input type="radio" name="awart" value="0010" onClick="javascript:click_radio(this);"
                   	   <c:choose>
					   <c:when  test="${ empty resultData.AWART }" >
					     checked
					    </c:when>
					    <c:when  test="${resultData.AWART eq '0010' }">
					     checked
					     </c:when>
					     </c:choose>
					   >

                   <spring:message code="LABEL.D.D19.0022"/> <!-- 교육 -->
                    <input type="radio" name="awart" value="0020" onClick="javascript:click_radio(this);"
					   <c:if  test="${ resultData.AWART eq '0020' }" >
					     checked
					    </c:if>
					   >
                    <spring:message code="LABEL.D.D19.0023"/> <!-- 출장 -->
                  </td>
                </tr>

                <!--@v1.2-->
                <tr id="gntaegubun">
                  <th><span class="textPink">*</span><spring:message code="LABEL.D.D19.0004"/> <!-- 구분 --></th>
                  <td>
                        <select  name="OVTM_CODE" class="required" placeholder="<spring:message code="LABEL.D.D19.0004"/>">
                          <option value="">-------------</option>
                              	   <c:choose>
    	   						   <c:when  test="${ empty resultData.AWART }" >
    	   						      ${ f:printCodeOption(D03OvertimeCodeData0010_vt, "")}
    	   						    </c:when>
    	   						    <c:when  test="${resultData.AWART eq '0010' }">
    	   						     ${f:printCodeOption(D03OvertimeCodeData0010_vt, resultData.OVTM_CODE)}
    	   						     </c:when>
    	   						     <c:otherwise>
    	   						     ${f:printCodeOption(D03OvertimeCodeData0020_vt, resultData.OVTM_CODE) }
    	   						     </c:otherwise>
    	   						     </c:choose>
                        </select>
                  </td>
                </tr>
                <tr>
                  <th><span class="textPink">*</span><spring:message code="LABEL.D.D19.0005"/> <!-- 신청사유 --></th>
                  <td>
                    <input type="text" name="REASON" class="required"   placeholder="<spring:message code="LABEL.D.D19.0005"/>" value="${resultData.REASON}"  size="65" maxlength="80" style="ime-mode:active">
                  </td>
                </tr>
                <tr>
                  <th><spring:message code="LABEL.D.D19.0006"/> <!-- 대근자 --></th>
                  <td>
                    <input type="text" name="OVTM_NAME" value="${resultData.OVTM_NAME}"  size="10" maxlength="10" style="ime-mode:active">
                  </td>
                </tr>
                <tr>
                  <th><span class="textPink">*</span><spring:message code="LABEL.D.D19.0007"/> <!-- 신청기간 --></th>
                  <td>
                    <input type="text" id ="APPL_FROM"  class="required  date"   placeholder="<spring:message code="LABEL.D.D19.0007"/>"  name="APPL_FROM" value="${f:printDate(resultData.APPL_FROM)}" size="20" onChange="javascript:after_remainSetting();"  >
                    <spring:message code="LABEL.D.D19.0024"/> <!-- 부터 -->
                    <input type="text" name="APPL_TO"    class="required  date"   placeholder="<spring:message code="LABEL.D.D19.0007"/>" value="${f:printDate(resultData.APPL_TO)}"  size="20"  >
                    <spring:message code="LABEL.D.D19.0025"/> <!-- 까지 -->
                  </td>
                </tr>
                <input type="hidden" name="BEGUZ" value="${resultData.BEGUZ}" >
                <input type="hidden" name="ENDUZ" value="${resultData.ENDUZ}"  >

            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->
    <!-- HIDDEN  처리해야할 부분 시작 (default = 전일교육, 출장), frdate, todate는 선택된 기간에 개인의 근무일정을 가져오기 위해서.. -->
      <input type="hidden" name="timeopen"    value="T">
      <input type="hidden" name="AWART"       value="${resultData.AWART}" >
      <input type="hidden" name="REMAIN_DATE" value="">
      <input type="hidden" name="DEDUCT_DATE" value="">
   </c:otherwise>
  </c:choose>
	<%-- 하단 추가 부분 --%>
	<div class="commentImportant">
            <p><spring:message code="LABEL.D.D19.0008"/> <!-- ※ *는 필수 입력사항입니다. --></p>
            <p><spring:message code="LABEL.D.D19.0009"/> <!-- ※ OFF시 교육의 경우도 교육으로 신청하시기 바랍니다. (O/T 자동 발생 안됨) --></p>
            <p><spring:message code="LABEL.D.D19.0010"/> <!-- ※ 교대근무자의 경우 심야수당은 자동으로 발생되지 않습니다. --></p>
            <p><spring:message code="LABEL.D.D19.0011"/> <!-- ※ 전일 교육 및 출장의 경우 근태 신청 바랍니다. --></p>
	</div>
<!-- HIDDEN  처리해야할 부분 끝   -->
    	</tags-approval:request-layout>
</tags:layout>