<%
	/******************************************************************************/
	/*   System Name  : ESS                                                         													*/
	/*   1Depth Name  : MY HR 정보                                                  															*/
	/*   2Depth Name  : 휴가/근태                                                        														*/
	/*   Program Name : Flextime                                                   													*/
	/*   Program ID   :D20FlextimeBuild.jsp                                        													*/
	/*   Description  : Flextime을 신청하는 화면                                        														*/
	/*   Note         :                                                             															*/
	/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청                                       */
	/*   Update       : 2017-11-08  eunha    [CSR ID:3525213] Flextime 시스템 변경 요청								*/
	/*   Update       : 2018-05-09  성환희     [WorkTime52] 부분/완전선택 근무제 변경								*/
	/******************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/web/common/commonProcess.jsp"%>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval"%>
<%@ page import="org.apache.commons.lang.math.NumberUtils"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="hris.D.*"%>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="java.text.*"%>

<%

		int currentMonth = NumberUtils.toInt(DataUtil.getCurrentMonth())+1; //다음달부터 신청가능
		int currentYear = NumberUtils.toInt(DataUtil.getCurrentYear());

 		java.text.SimpleDateFormat formatter  = new java.text.SimpleDateFormat ("dd");
 		int currentDate = NumberUtils.toInt(formatter.format( new java.util.Date()));
 		//if (currentDate >=20) currentMonth = currentMonth+1;//20일부터는 다다음달부터 신청가능

		DecimalFormat df = new DecimalFormat("00");
		int maxValue = currentMonth + 3;
		String fromMonth = "";
		String toMonth = "";

		for(int n = currentMonth; n < maxValue; n++) {
			boolean isNextyear = n > 12;
			String month = df.format(isNextyear ? n - 12 : n);
			String year = String.valueOf(isNextyear ? currentYear + 1 : currentYear);
			if (n==currentMonth) fromMonth = year + "." + month  ;
			if (n== maxValue-1)   toMonth = year + "." + month  ;
}

%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="fromMonth" value="<%=fromMonth %>"/>
<c:set var="toMonth" value="<%=toMonth%>"/>

<tags:layout css="ui_library_approval.css" script="dialog.js">
<link rel="stylesheet" href="${g.image}css/bootstrap-monthpicker.css" type="text/css">
<tags:script>
<script src="<c:url value="${g.image}js/bootstrap-monthpicker.js"/>"></script>
    <script>
    
	    $(function() {
	    	
	    	if(!$('#FLEX_BEGDA').val() && $('#FLEX_ENDDA')) {
	    		var curYear = (new Date()).getFullYear();
    			$('#FLEX_BEGDA')
    					.datepicker("option", "minDate", 0)
    					.datepicker("setDate", new Date());
    			$('#FLEX_ENDDA')
    					.datepicker("option", "minDate", 0)
    					.datepicker("setDate", new Date('12/31/' + (new Date()).getFullYear()));
    		}
	    	
	    });


		function beforeSubmit() {
			if (check_data()) 	return true;
        }

		function click_radio(obj) {
			 document.form1.SCHKZ.value = obj.value;
			 
			 $('#FLEX_BEGTM').val($(obj).data('start'));
			 $('#FLEX_ENDTM').val($(obj).data('end'));
		}

		function check_data(){

			  if(document.form1.SCHKZ.value=="") {
				  alert("<spring:message code='MSG.D.D20.0001'/>"); //alert("근로시간을 선택하세요");
				  return false;
			  }
			  <%--[CSR ID:3525213] Flextime 시스템 변경 요청  FLEX_BEG,FLEX_END 를 FLEX_BEGDA,FLEX_ENDDA로 변경 start--%>
			  if(document.form1.FLEX_BEGDA.value=="") {
				  alert("<spring:message code='MSG.D.D20.0002'/>"); // alert("신청기간 시작일을 선택하세요");
				  return false;
			  }
			  if(document.form1.FLEX_ENDDA.value=="") {
				  alert("<spring:message code='MSG.D.D20.0003'/>"); //alert("신청기간 종료일을 선택하세요");
				  return false;
			  }

			  date_from  = removePoint(document.form1.FLEX_BEGDA.value);
			  date_to    = removePoint(document.form1.FLEX_ENDDA.value);
			  <%--[CSR ID:3525213] Flextime 시스템 변경 요청   FLEX_BEG,FLEX_END 를 FLEX_BEGDA,FLEX_ENDDA로 변경 end--%>
			  if( date_from > date_to ) {
				  alert("<spring:message code='MSG.D.D20.0004'/>"); //alert("신청기간 시작일이 종료일보다 큽니다.");
			    return false;
			  }

			  return true;
			}
		<%--[CSR ID:3525213] Flextime 시스템 변경 요청 start--%>
		function dateCheck(obj) {
		        var url = '${g.servlet}hris.D.D20Flextime.D20FlextimeBuildSV';
		        var i_gtype = "${isUpdate ? '3' : '2'}";
		        var i_begtm = $('[name=schkz]:checked').data('start').substring(0, 4);
		        var pars = 'jobid=check&PERNR=' + $('#PERNR').val()+ '&BEGDA=' + $('#BEGDA').val()+'&FLEX_BEGDA='+ $('#FLEX_BEGDA').val()+'&FLEX_ENDDA='+ $('#FLEX_ENDDA').val()+ '&FLEX_BEGTM='+ i_begtm+'&AINF_SEQN='+ $('#AINF_SEQN').val()+'&I_GTYPE='+i_gtype ;
		        $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
		    }

		function showResponse(originalRequest){

		        var flag = originalRequest.split(",")[0];
		        var msg = originalRequest.split(",")[1];

		        if(flag == "E" ){
		           alert(msg);
		           document.form1.FLEX_BEGDA.value = "" ;
		           document.form1.FLEX_ENDDA.value = "" ;
		           document.form1.FLEX_BEGDA.focus();
		           return;
		        }
		}
		<%--[CSR ID:3525213] Flextime 시스템 변경 요청 end--%>
    </script>
  </tags:script>
	<tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_FLEXTIME" representative="true"  disable="${ E_AVAILABLE !='Y'  and user.empNo != '00202674'}" disableApprovalLine="${ E_AVAILABLE !='Y' and user.empNo != '00202674'}">
<c:choose>
 <c:when test='${ E_AVAILABLE !="Y"  and user.empNo != "00202674" }'>
    <div class="align_center">
        <p>${E_AVAILABLE_MSG }
    </div>
</c:when>
<c:otherwise>
		<!-- 상단 입력 테이블 시작-->
		<div class="tableArea">
			<div class="table">
				<table class="tableGeneral">
					<colgroup>
						<col width=15% />
						<col />
					</colgroup>
					<tr>
						<th rowspan="2"><span class="textPink">*</span><spring:message code="LABEL.D.D20.0001"/><!-- 근로시간 선택 --></th>
						<td ><input type="radio" name="schkz" value="F070A220" data-start="070000" data-end="160000"
							${ resultData.SCHKZ==("F070A220") ? "checked" : "" } onclick="click_radio(this);"> 07:00~16:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F080A220" data-start="080000" data-end="170000"
							${ resultData.SCHKZ==("F080A220") ? "checked" : "" } onClick="click_radio(this);"> 08:00~17:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F090A220" data-start="090000" data-end="180000"
							${ resultData.SCHKZ==("F090A220") ? "checked" : "" } onClick="click_radio(this);"> 09:00~18:00
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F100A220" data-start="100000" data-end="190000"
							${ resultData.SCHKZ==("F100A220") ? "checked" : "" } onClick="click_radio(this);"> 10:00~19:00
						</td>
					</tr>
					<tr>
						<td ><input type="radio" name="schkz" value="F073A220" data-start="073000" data-end="163000"
							${ resultData.SCHKZ==("F073A220") ? "checked" : "" } onClick="click_radio(this);"> 07:30~16:30
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F083A220" data-start="083000" data-end="173000"
							${ resultData.SCHKZ==("F083A220") ? "checked" : "" } onClick="click_radio(this);"> 08:30~17:30
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="schkz" value="F093A220" data-start="093000" data-end="183000"
							${ resultData.SCHKZ==("F093A220") ? "checked" : "" } onClick="click_radio(this);"> 09:30~18:30
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span> <spring:message	code='LABEL.D.D20.0002' /><!--적용기간--></th>
						<td >
							<%--[CSR ID:3525213] Flextime 시스템 변경 요청  FLEX_BEG,FLEX_END 를 FLEX_BEGDA,FLEX_ENDDA로 변경 start--%>
							<input type="text" id="FLEX_BEGDA"  name = "FLEX_BEGDA"  size="10" value="${f:printDate(resultData.FLEX_BEGDA)}"	 class="date"/>
							<spring:message	code='LABEL.D.D20.0003' />
							<!--부터-->&nbsp;
    						<input type="text" id="FLEX_ENDDA"  name = "FLEX_ENDDA" size="10"	 value="${f:printDate(resultData.FLEX_ENDDA)}"  class="date" /> <!-- onchange="javascript:dateCheck(this);" -->
							<spring:message code='LABEL.D.D20.0004' />
							<!--까지-->
							<%--[CSR ID:3525213] Flextime 시스템 변경 요청  FLEX_BEG,FLEX_END 를 FLEX_BEGDA,FLEX_ENDDA로 변경 end--%>
						</td>
					</tr>
				</table>
			</div>
		</div>
        <div class="commentImportant" style="width:640px;">
            <p><strong><spring:message	code='LABEL.D.D20.0005'/><!--※ 신청시 주의사항--></strong></p>
            <p><spring:message	code='LABEL.D.D20.0015'/><!-- 1) 직속상위자 결재를 득해야 함 --></p>
            <p><spring:message	code='LABEL.D.D20.0015'/><!-- 2) 신청예외자 : 육아기 및 임신기단축근로를 사용중인 경우 Flextime제 미적용 --></p>
        </div>
      </c:otherwise>
     </c:choose>
		<!-- HIDDEN  처리해야할 부분 시작. -->
	<input type="hidden" id="SCHKZ" name="SCHKZ"  value="${resultData.SCHKZ}">
	<input type="hidden" id="FLEX_BEGTM" name="FLEX_BEGTM"  value="${resultData.FLEX_BEGTM}">
	<input type="hidden" id="FLEX_ENDTM" name="FLEX_ENDTM"  value="${resultData.FLEX_ENDTM}">
	<input type="hidden" id="CR_UNAME" name="CR_UNAME"  value="${resultData.CR_UNAME}">
	<input type="hidden" id="CR_DATE" name="CR_DATE"  value="${resultData.CR_DATE}">
	<input type="hidden" id="CR_TIME" name="CR_TIME"  value="${resultData.CR_TIME}">
	<input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" >
		<!-- HIDDEN  처리해야할 부분 끝   -->
	</tags-approval:request-layout>
</tags:layout>