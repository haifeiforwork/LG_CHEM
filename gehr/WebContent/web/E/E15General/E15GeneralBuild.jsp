<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진 신청                                               */
/*   Program ID   : E15GeneralBuild.jsp                                         */
/*   Description  : 종합검진을 신청할 수 있는 화면                              */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                      2016-06-07 rdcamel [CSR ID:3000327] 2016년 종합검진 신청 이미지 및 첨부 파일 반영 요청 (매년 수검자로 비이월자)     */
/*   				  : 2017-03-23  eunha [CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String PERNR = (String)request.getAttribute("PERNR");
%>

<c:set var="PERNR" value="<%=PERNR%>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_GENE_CHECK" >
	<tags:script>
	<script>

	<!--
	//alert("sssssssssssss="+ "${PersonData.e_GRUP_NUMB}" );

	function beforeSubmit() { // function doSubmit(){

	    if(check_data()) {
	        if (document.form1.GUEN_CODE.value != "0002" && document.form1.F_FLAG.value == "Y" ) {
	            if (confirm("<spring:message code='MSG.E.E15.0020' />")) { // "배우자도 신청하시겠습니까?"
	            	document.form1.F_FLAG_REQYN.value     = "Y";
	            }
	        }

	        document.form1.BEGDA.value     = removePoint( document.form1.BEGDA.value);
	        document.form1.EZAM_DATE.value = removePoint( document.form1.to_date.value);
	        document.form1.HOSP_CODE.value = document.form1.HOSP_CODE[form1.HOSP_CODE.selectedIndex].value;
	        document.form1.GUEN_CODE.value = document.form1.GUEN_CODE[form1.GUEN_CODE.selectedIndex].value;
	        document.form1.GUEN_NAME.value = document.form1.GUEN_CODE[form1.GUEN_CODE.selectedIndex].text;
	        document.form1.HOSP_NAME.value = document.form1.HOSP_CODE[form1.HOSP_CODE.selectedIndex].text;
	        document.form1.STMC_TEXT.value = document.form1.STMC_CODE[form1.STMC_CODE.selectedIndex].text;
	        document.form1.SELT_TEXT.value = document.form1.SELT_CODE[form1.SELT_CODE.selectedIndex].text;

	        return true;
	    }
	}

	function check_data(){
		var validText = "";
	  	document.form1.GUEN_CODE.value = document.form1.GUEN_CODE[form1.GUEN_CODE.selectedIndex].value;
	  	var guencode =  document.form1.GUEN_CODE.value;
	  	var mecode   =    document.form1.ME_CODE.value;
	  	var wicode   =    document.form1.WI_CODE.value;

	  ////사내부부 신청 시 배우자 신청 불가
	  <c:if test="${CompanyCoupleYN eq 'Y' }">
		  if(guencode == "0002"){
			  alert("<spring:message code='MSG.E.E15.0003' />"); //alert("사내부부의 경우 배우자 종합검진 신청이 불가합니다.");
			  return false;
		  }
	  </c:if>

	  if(guencode == mecode || guencode == wicode ) {
		  alert("<spring:message code='MSG.E.E15.0021' />"); //alert("이미 신청하셨습니다.")
	      return false;
	  }

	  if( document.form1.HOSP_CODE[form1.HOSP_CODE.selectedIndex].value == "" ) {
		    validText = "<spring:message code='LABEL.E.E28.0009' />";
		    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("검진희망병원을 선택하세요.");
		    document.form1.HOSP_CODE.focus();
		    return false;
	  }

	  if( document.form1.to_date.value==""){
	    validText = "<spring:message code='LABEL.E.E28.0003' />";
	    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("검진희망일자를 입력해주세요.");
	    document.form1.to_date.focus();
	    return false;
	  }
	  var to_yy =removePoint(document.form1.to_date.value.substring(0,4));
	  var to_mm =removePoint(document.form1.to_date.value.substring(5,7));
	  var to_dd =removePoint(document.form1.to_date.value.substring(8,10));
	  var to_ymd =new Date(to_yy,to_mm-1,to_dd);
	 //   alert(to_yy+to_mm+to_dd+"to_ymd.getDay():"+to_ymd.getDay()+"to_mm :"+ parseInt(to_mm)  +"to_mm-1:"+(to_mm-1));

	  if( to_ymd.getDay() == 0){
		  alert("<spring:message code='MSG.E.E15.0022' />"); //alert("일요일은 예약하실수 없습니다.");
	      document.form1.to_date.focus();
	      return false;
	  }

	  if( to_yy > '${f:getCurrentYear()}' ){
		  alert("<spring:message code='MSG.E.E15.0023' />"); //alert("당해년도 예약만 가능합니다.");
	      document.form1.to_date.focus();
	      return false;
	  }

	  var to_date = removePoint( document.form1.to_date.value.substring(0,7));
	  var HOSP_CODE = document.form1.HOSP_CODE[form1.HOSP_CODE.selectedIndex].value;

	  var toDate = to_yy+to_mm+to_dd;
	  var STMC_CODE = document.form1.STMC_CODE[form1.STMC_CODE.selectedIndex].value;

	  def  = dayDiff(document.form1.BEGDA.value,document.form1.to_date.value);
	  if( def < 0 ) {
		  alert("<spring:message code='MSG.E.E15.0024' />"); // alert("검진희망일자가 신청일의 이전 일자 입니다.");
	      return ;
	 }

	  if( dateFormat(document.form1.to_date) == false ) {
	    return ;
	  }
	       //if( !(HOSP_CODE == "11" || HOSP_CODE == "12" ||HOSP_CODE == "13" ) ){
	       //     if( document.form1.STMC_CODE[form1.STMC_CODE.selectedIndex].value == "" ) {
	       //       alert("소화기검사를 선택하세요.");
	       //       document.form1.STMC_CODE.focus();
	       //       return false;
	       //     }
	       //}

	   if( document.form1.STMC_CODE[form1.STMC_CODE.selectedIndex].value == "" &&
	        document.form1.STMC_CODE[form1.STMC_CODE.selectedIndex].text != "해당사항없음" ) {
		    validText = "<spring:message code='LABEL.E.E28.0010' />";
		    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("소화기검사를 선택하세요.");
	        document.form1.STMC_CODE.focus();
	        return ;
	    }


	    if( document.form1.SELT_CODE[form1.SELT_CODE.selectedIndex].value == "" && document.form1.SELT_CODE[form1.SELT_CODE.selectedIndex].text !="해당사항없음" ) {
	    	validText = "<spring:message code='LABEL.E.E28.0012' />";
		    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("선택검사를 선택하세요.");
	        document.form1.SELT_CODE.focus();
	        return ;
	    }

	  if( document.form1.ZHOM_NUMB.value==""){
	  		validText = "<spring:message code='LABEL.E.E28.0011' />";
		    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("휴대전화번호를 입력해주세요.");
	    	document.form1.ZHOM_NUMB.focus();
	    	return false;
	  }

	//여수 CSR ID:1228051,대산
	<c:if test="${PersonData.e_GRUP_NUMB eq '02' || PersonData.e_GRUP_NUMB eq '09' }">
		if( document.form1.STRAS.value==""){
			validText = "<spring:message code='LABEL.E.E28.0015' />";
		    alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("문진표받으실 주소지를 입력해주세요.");
	        document.form1.STRAS.focus();
	        return ;
	      }else{
	          if( !confirm("<spring:message code='MSG.E.E15.0025' />")){  // "문진표 받으실 주소지 입력이 정확합니까?"
	            return ;
	          }
	      }
	</c:if>

	// 대산
	<c:if test="${PersonData.e_GRUP_NUMB eq '09' }">
       if( !confirm("<spring:message code='MSG.E.E15.0026' />") ) {  // "병원으로 부터 연락받으실 휴대폰 번호는 맞습니까?
         document.form1.ZHOM_NUMB.focus();
         return ;
       }
	</c:if>

	  //@v1.0병원선택시 선택 검사항목 체크
	  return true;
	}


	//@v1.1 병원선택시 소화기검사  setting
	function sel_hidden(gubun) {
	    var HOSP_CODE = document.form1.HOSP_CODE[document.form1.HOSP_CODE.selectedIndex].value;
	    var STMC_CODE = document.form1.STMC_CODE[document.form1.STMC_CODE.selectedIndex].value;
	    var SELT_CODE = document.form1.SELT_CODE[document.form1.SELT_CODE.selectedIndex].value;
	    document.form2.HOSP_CODE.value = HOSP_CODE;
	    document.form2.STMC_CODE.value = STMC_CODE;
	    document.form2.SELT_CODE.value = SELT_CODE;
	    document.form2.GUBUN.value = gubun;
	    document.form2.target = "ifHidden";

	    document.form2.action = "<c:out value='${g.jsp}'/>E/E15General/E15HiddenSelect.jsp";
	    document.form2.submit();
	} // @v1.1 end function

	function check_guen(){
		  document.form1.GUEN_CODE.value = document.form1.GUEN_CODE[form1.GUEN_CODE.selectedIndex].value;

			  if(document.form1.GUEN_CODE.value == "0002"){
			    if(document.form1.F_FLAG.value =="N"){
			      alert('${PERNR}'+"<spring:message code='MSG.E.E15.0027' />");  // 사번의 배우자는 해당년도의 검진대상자가 아닙니다.
			      form1.GUEN_CODE[0].selected = true;
			    }
		  }
	}

	function fn_openCal(Objectname){
		  var HOSP_CODE = document.form1.HOSP_CODE[form1.HOSP_CODE.selectedIndex].value;
		  var STMC_CODE = document.form1.STMC_CODE[form1.STMC_CODE.selectedIndex].value;
		  var STMCCHECK = "";

		  if( HOSP_CODE == "" ) {
			  var validText = "<spring:message code='LABEL.E.E28.0009' />";
			  alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("검진희망병원을 선택하세요.");
		      document.form1.HOSP_CODE.focus();
		      return;
		  }

		<c:forEach var="row" items="${E15HospCodeData_opt}" varStatus="inx">
		<c:set var="index" value="${inx.index}"/>

		 if (HOSP_CODE ==  "<c:out value='${row.HOSP_CODE}'/>" && "<c:out value='${row.STMC_CODE}'/>" == STMC_CODE) {
	         STMCCHECK ="<c:out value='${row.STMC_CODE}'/>";
	     }
		//[CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 start
		//if (HOSP_CODE ==  "<c:out value='${row.HOSP_CODE}'/>" && "<c:out value='${row.STMC_CODE1}'/>}" == STMC_CODE) {
	     if (HOSP_CODE ==  "<c:out value='${row.HOSP_CODE}'/>" && "<c:out value='${row.STMC_CODE1}'/>" == STMC_CODE) {
	    //[CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 end
	         STMCCHECK ="<c:out value='${row.STMC_CODE1}'/>";
	     }
		</c:forEach>

		  var lastDate;
		  lastDate = eval("document.form1." + Objectname + ".value");

		  var sWidth = "450";// 띄울 창의 너비
		//[CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 start
		// var sHeight = "440";// 띄울 창의 높이
		//[CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 end
		  var sHeight = "500";// 띄울 창의 높이
		  var ml = (screen.availWidth - sWidth) / 2;// 가운데 띄우기위한 창의 x위치
		  var mt = (screen.availHeight - sHeight) / 2;// 가운데 띄우기위한 창의 y위치

		  small_window  = window.open("<c:out value='${g.jsp}'/>E/E15General/Hospitalcalendar.jsp?formname=form1&fieldname="+ Objectname + "&curDate=" + lastDate + "&iflag=0&PERNR=<c:out value='${PERNR}'/>"+STMCCHECK+"&HOSP_CODE="+document.form1.HOSP_CODE.value,"essCal", "toolbar=0,location=0,status=0,menubar=0,resizable=0,width="+sWidth+",height="+sHeight+",left="+ml+",top="+mt);//[CSR ID:3000327]width 변경
		  small_window.focus();
	}

	//-->

	</script>
	</tags:script>

	<!-- 상단 입력 테이블 시작-->
	<%--@elvariable id="resultData" type="hris.E.E17Hospital.E17HospitalDetailData1"--%>

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
	                <th><span class="textPink">*</span><!--검진년도--><spring:message code="LABEL.E.E28.0001" /></th>
	                <td>
	                	<input type="hidden" name="BEGDA" value="<c:out value='${f:printDate(approvalHeader.RQDAT)}'/>"  />
	                	<input type="text" name="EXAM_YEAR" size="10" class="noBorder" value="<c:out value='${f:getCurrentYear()}'/>" readonly />
	                </td>
	                <th><span class="textPink">*</span><!--구분--><spring:message code="LABEL.E.E28.0002" /></th>
	                <td>
	                	<select name="GUEN_CODE" style="width:135px;" onChange="javascript:check_guen();">
	                    ${f:printCodeOption(getGuenCodeVt, GUEN_CODE)}
	                    </select>
                    </td>
                </tr>

                <tr>
                   <th><span class="textPink">*</span><!--검진희망병원--><spring:message code="LABEL.E.E28.0009" /></th>
                   <td colspan="3">
                       <select name="HOSP_CODE" id="HOSP_CODE" style="width:200px;" onChange="javascript:sel_hidden('HOSP_CODE')">
                       <option value="">-------------</option>
                       <c:forEach var="row" items="${E15HospCodeData_opt}" varStatus="inx">
                       <c:set var="index" value="${inx.index}"/>
                       <option value="<c:out value='${row.HOSP_CODE}'/>" <c:if test="${row.HOSP_CODE eq HOSP_CODE }" > selected </c:if> ><c:out value='${row.HOSP_NAME}'/></option>
					   </c:forEach>
                       </select>
                   </td>
               </tr>

               <tr>
                   <th><!--검진지역--><spring:message code="LABEL.E.E28.0006" /></th>
                   <td>
                   	   <input type="hidden" name="AREA_CODE" value="<c:out value='${AreaEntity.code }'/>" />
                       <input type="text" name="AREA_NAME" size="20" class="noBorder" value="<c:out value='${AreaEntity.value}'/>" readonly />
                   </td>
                   <th><span class="textPink">*</span><!--소화기검사선택--><spring:message code="LABEL.E.E28.0010" /></th>
                   <td>
                       <select name="STMC_CODE" style="width:135px;" onChange="javascript:sel_hidden('STMC_CODE');">

                       <c:choose>
                       		<c:when test="${ fn:length(E15StmcData_opt) eq 0 }">
								<option value=""><!--해당사항없음--><spring:message code="LABEL.E.E28.0013" /></option>
                       		</c:when>
                       		<c:otherwise>
								<option value="">-------------</option>
                       		</c:otherwise>
                       </c:choose>

                       <c:if test="${HOSP_CODE ne '' }" >
	                       <c:forEach var="row" items="${E15StmcData_opt}" varStatus="inx">
	                       <c:set var="index" value="${inx.index}"/>
	                       <option value="<c:out value='${row.STMC_CODE}'/>" ><c:out value='${row.STMC_TEXT}'/></option>
						   </c:forEach>
                       </c:if>
                       </select>

                    </td>
                </tr>

                <tr>
                    <th><!--전화(회사)--><spring:message code="LABEL.E.E28.0011" /></th>
                    <td>
                    	<input type="text" name="COMP_NUMB" size="20" value="<c:out value='${PersonData.e_PHONE_NUM}'/>" >
                    </td>

                    <th><span class="textPink">*</span><!--선택검사--><spring:message code="LABEL.E.E28.0012" /></th>
                    <td>
                    	<select name="SELT_CODE" style="width:135px;" onChange="javascript:sel_hidden('SELT_CODE');">

                    	<c:choose>
                       		<c:when test="${fn:length(E15SeltData_opt) eq 0 }">
								<option value=""><!--해당사항없음--><spring:message code="LABEL.E.E28.0013" /></option>
                       		</c:when>
                       		<c:otherwise>
								<option value="">-------------</option>
                       		</c:otherwise>
                        </c:choose>

                        <c:if test="${HOSP_CODE ne '' }" >
	                       <c:forEach var="row" items="${E15SeltData_opt}" varStatus="inx">
	                       <c:set var="index" value="${inx.index}"/>
	                       <option value="<c:out value='${row.SELT_CODE}'/>" ><c:out value='${row.SELT_TEXT}'/></option>
						   </c:forEach>
                        </c:if>
                    	</select>
                    </td>
                </tr>

                <tr>
	                <th><span class="textPink">*</span><!--휴대전화--><spring:message code="LABEL.E.E28.0014" /></th>
	                <td>
	                	<input type="text" name="ZHOM_NUMB" size="20" value="<c:out value='${PersonData.e_CELL_PHONE}'/>" maxlength="14" onblur="phone_1(this)">
	                </td>

	                <th><span class="textPink">*</span><!--검진희망일--><spring:message code="LABEL.E.E28.0003" /></th>
	                <td>
	                	<input type="hidden" name="EZAM_DATE" value="">
	                	<input type="text" name="to_date" id="to_date" value="<c:out value='${EZAM_DATE}'/>" size="10" onBlur="javascript:dateFormat(this);" readonly />
                        <a href="javascript:fn_openCal('to_date')"><img src="<c:out value='${g.image}'/>sshr/ico_calendar.gif" align="absmiddle" border="0"></a>
	                </td>
                </tr>

                <tr>
	                <th><c:if test="${PersonData.e_GRUP_NUMB eq '02' || PersonData.e_GRUP_NUMB eq '09' }" ><span class="textPink">*</span></c:if><!--문진표받으실 주소지--><spring:message code="LABEL.E.E28.0015" />
	                </th>
	                <td colspan="3"> <input type="text" name="STRAS" size="105"  value="<c:out value='${PersonData.e_STRAS}'/> <c:out value='${PersonData.e_LOCAT}'/>" >
	                </td>
              	</tr>

              	<!-- 여수,나주  -->
              	<c:if test="${PersonData.e_GRUP_NUMB eq '02' || PersonData.e_GRUP_NUMB eq '07' }" >
                 <tr>
	                 <th><!--기타요구사항--><spring:message code="LABEL.E.E28.0016" /></th>
	                 <td colspan="3"><input type="text" name="BIGO" size="68" value="" >
	                 </td>
                 </tr>
                 </c:if>

				 <!-- 대산  -->
              	 <c:if test="${PersonData.e_GRUP_NUMB eq '09' }" >
                 <tr>
                     <th><!--추가 검사 항목 (개인비용부담)--><spring:message code="LABEL.E.E28.0017" /></th>
                     <td colspan="3"> <input type="text" name="BIGO" size="68" value="" >
                     </td>
                 </tr>
                 </c:if>

            </table>

        </div> <!-- end class="table" -->

       	<span class="inlineComment">
		<span class="textPink">*</span><!--는 필수 입력사항입니다.--><spring:message code="LABEL.E.E05.0017" />
		</span>
		<!-- 상단 입력 테이블 끝-->

		<c:if test="${PersonData.e_GRUP_NUMB eq '03' || PersonData.e_GRUP_NUMB eq '10' || PersonData.e_GRUP_NUMB eq '02' || PersonData.e_GRUP_NUMB eq '07' }" >
		<br/><br/>
		<div class="table">
			<table class="tableGeneral">
				<colgroup>
            		<col width="" />
            	</colgroup>

            	<c:if test="${PersonData.e_GRUP_NUMB eq '03' || PersonData.e_GRUP_NUMB eq '10' }" >
            	<tr>
	            	<td>
	            	<font color="green"><b>&nbsp;▶</b> <spring:message code="MSG.E.E15.0004" /><!--위내시경이나 수면내시경시 의사의 판단하에 조직검사가 필요한 경우에는 조직검사비용 2만원~5만원 개인부담있습니다.--></font>
	            	</td>
            	</tr>
            	<tr>
		            <td>
		            <font color="green"><b>&nbsp;▶</b> <spring:message code="MSG.E.E15.0005" /><!--수면내시경 검진시 필히 보호자 동행해야 하며 당일운전은  금지하여주시기 바랍니다.--> </font>
		            </td>
	          	</tr>
	          	</c:if>

	          	<c:if test="${PersonData.e_GRUP_NUMB eq '02' }" >
	          	<tr>
		              <td> <font color="red"><b>&nbsp;▶</b> <spring:message code="MSG.E.E15.0006" /><!--1. 검진예약 후 수정방법--></font>
		              </td>
		         </tr>
		         <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> ■ <spring:message code="MSG.E.E15.0007" /><!--검진 예약 확정 메일을 받기 전(검진 예약 확정은 신청 다음날까지 확정메일 발송됨)--></font>
		              </td>
		         </tr>
		         <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> : <spring:message code="MSG.E.E15.0008" /><!--Elian → HR center → 결재함 → 결재진행중인 문서 → 종합검진 삭제 클릭 후 재신청(신청방법 처음부터 다시 시작 함)--></font>
		              </td>
		         </tr>

		         <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> ■ <spring:message code="MSG.E.E15.0009" /><!--검진 예약 확정 메일을 받은 경우--></font>
		              </td>
		         </tr>
		         <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> : <spring:message code="MSG.E.E15.0010" /><!--검진 대상자가 병원에 직접 전화하여 검진예약사항 변경 해야 함--> </font>
		              </td>
		         </tr>
		         <tr>
		              <td> <font color="red"><b>&nbsp;▶</b> <spring:message code="MSG.E.E15.0011" /><!--2. 정밀형 검진 안내--></font>
		              </td>
		         </tr>
		         <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> <spring:message code="MSG.E.E15.0012" /><!--① MRI정밀 : 신경 및 근육질환 진단--></font>
		              </td>
		         </tr>
		         <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> <spring:message code="MSG.E.E15.0013" /><!--② 뇌정밀MRA+MRI추가 : 뇌혈관 및 종양과 뇌구조 축소등 진단.(방사선 노출없음)--> </font>
		              </td>
		          </tr>
		          <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> <spring:message code="MSG.E.E15.0014" /><!--③ 심장정밀M-SPECT : 심장혈관 흐름상태진단(스탠드삽입 하신분. 심장혈관 협착소견 있는 분)--></font>
		              </td>
		          </tr>

	          	 </c:if>

	          	 <c:if test="${PersonData.e_GRUP_NUMB eq '07' }" ><!-- 나주 -->
	          	 <tr>
		              <td> <font color="red"><b>&nbsp;▶</b> <spring:message code="MSG.E.E15.0006" /><!--1. 검진예약 후 수정방법--></font>
		              </td>
		          </tr>
		          <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> ■ <spring:message code="MSG.E.E15.0007" /><!--검진 예약 확정 메일을 받기 전(검진 예약 확정은 신청 다음날까지 확정메일 발송됨)--></font>
		              </td>
		          </tr>
		          <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> : <spring:message code="MSG.E.E15.0008" /><!--Elian → HR center → 결재함 → 결재진행중인 문서 → 종합검진 삭제 클릭 후 재신청(신청방법 처음부터 다시 시작 함)--></font>
		              </td>
		          </tr>

		          <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> ■ <spring:message code="MSG.E.E15.0009" /><!--검진 예약 확정 메일을 받은 경우--></font>
		              </td>
		          </tr>
		          <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> : <spring:message code="MSG.E.E15.0010" /><!--검진 대상자가 병원에 직접 전화하여 검진예약사항 변경 해야 함--> </font>
		              </td>
		          </tr>
		          <tr>
		              <td> <font color="red"><b>&nbsp;▶</b> <spring:message code="MSG.E.E15.0015" /><!--2. 12년 정밀형 검진 안내--></font>
		              </td>
		          </tr>
		          <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> <spring:message code="MSG.E.E15.0016" /><!--① 뇌정밀MRA+MRI추가 : 뇌혈관 및 종양과 뇌구조 축소등 진단② 심장정밀MDCT : 심장혈관 진단--></font>
		              </td>
		          </tr>
		          <tr>
		              <td> <font color="red"><b>&nbsp;▶</b> <spring:message code="MSG.E.E15.0017" /><!--3. 기본형을 신청하실 경우 희망하는 병원선택 후--></font>
		              </td>
		          </tr>
		          <tr>
		              <td> <font color="black"><b>&nbsp;&nbsp;&nbsp;</b> <spring:message code="MSG.E.E15.0018" /><!--기본 선택 1가지 선택 후 추가 검사 원하는 경우--> <font color="red"><!--기타요구사항--><spring:message code="LABEL.E.E28.0016" /></font><spring:message code="MSG.E.E15.0019" /><!--에 입력바랍니다(추가비용있음)--></font>
		              </td>
		          </tr>

	          	 </c:if>

           	</table>
       	</div> <!-- end class="table" -->

       	</c:if>

	<!-- Hidden Field -->
	<input type="hidden" name = "ZCONFIRM" value="<c:out value='${ZCONFIRM}'/>" />
	<input type="hidden" name="HOSP_NAME" value="" />
	<input type="hidden" name="GUEN_NAME" value="" />
	<input type="hidden" name="M_FLAG" value="<c:out value='${E15General.e_M_FLAG}'/>">
	<input type="hidden" name="F_FLAG" value="<c:out value='${E15General.e_F_FLAG}'/>">
	<input type="hidden" name="ME_FLAG" value="<c:out value='${E15GeneralFlagData.ME_FLAG}'/>">
	<input type="hidden" name="WI_FLAG" value="<c:out value='${E15GeneralFlagData.WI_FLAG}'/>">
	<input type="hidden" name="ME_CODE" value="<c:out value='${E15GeneralFlagData.ME_CODE}'/>">
	<input type="hidden" name="WI_CODE" value="<c:out value='${E15GeneralFlagData.WI_CODE}'/>">
	<input type="hidden" name="F_FLAG_REQYN" value="">
	<input type="hidden" name="STMC_TEXT" value="">
	<input type="hidden" name="SELT_TEXT" value="">

	<!-- Hidden Field -->

    </div>  <!-- end class="tableArea" -->

</tags-approval:request-layout>
</tags:layout>

<form name="form2" method="post">
      <input type="hidden" name = "PERNR"     value="<c:out value='${PERNR }'/>">
      <input type="hidden" name = "HOSP_CODE" value="">
      <input type="hidden" name = "STMC_CODE" value="">
      <input type="hidden" name = "SELT_CODE" value="">
      <input type="hidden" name = "GUBUN"     value="">
      <input type="hidden" name = "E_GRUP_NUMB"     value="<c:out value='${PersonData.e_GRUP_NUMB}'/>">
  </form>
<iframe name="ifHidden" width="0" height="0" style="visibility:hidden;" >
