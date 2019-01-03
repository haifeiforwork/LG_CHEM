<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 장학금/학자금 결재                                          */
/*   Program ID   : G015ApprovalExpense.jsp                                     */
/*   Description  : 장학금/학자금 결재                                          */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*                  2012-06-28  ※C20120620_30404 담당자인경우 1. 신청금액 2. 분기/학기 3. 학년 4. 신규분/추가분수정 가능하게 */
/*                  2013-09-23  [CSR ID:@999] 동일학년, 동일분기에 기 신규분으로 지원을 받은 경우에만 추가분 신청가능  */
/*                  2014/05/19 CSRID : 2545905 이지은D @CSR1 시간선택제 (사무직(4H), 사무직(6H), 계약직(4H), 계약직(6H)) 의료비/학자금 신청 시 알림 popup 추가 */
/*				     2014-10-24  @v.1.5 SJY 신청유형:장학금인 경우에만 시스템 수정 [CSR ID:2634836] 학자금 신청 시스템 개발 요청	*/
/*  				 2015-05-07  [CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정  */
/*                  2017-04-03  김은하C [CSR ID:3393142] 학자금 신청 관련 로직 수정요청의 건  */
/* 				 2018-01-08  cykim	  [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건*/
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
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    E21ExpenseData e21ExpenseData        = (E21ExpenseData)request.getAttribute("e21ExpenseData");

    String      RequestPageName     = (String)request.getAttribute("RequestPageName");

// @CSR1 : 시간제의 경우 사전 popup 추가 2014.05.21 (사무직(4H) : 50% 지급, 사무직(6H) : 75% 지급)
    //String      E_COUPLEYN          = (String)request.getAttribute("E_COUPLEYN");   //Y: 시간제 근무의 경우
    //String      E_MESSAGE           = (String)request.getAttribute("E_MESSAGE");   //Y: 시간제 근무의 경우 메세지 처리

    //  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize  = 2;
    double currencyDecimalSize1 = 2;
    int    currencyValue  = 0;
    int    currencyValue1 = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
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

     //  현재년도 기준으로 일년전부터, 일년후까지 (2년간)
    int i_date          = Integer.parseInt( DataUtil.getCurrentDate().substring(0,4) );
    String         selType                = "";

    Vector CodeEntity_vt = new Vector();
    for( int i = i_date - 1 ; i <= i_date  ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    //  신청유형을 체크하여 신청분기ㆍ학기를 설정해준다.
    Vector CodeEntityType_vt = new Vector();
    if( e21ExpenseData.SUBF_TYPE.equals("2") ) {          //학자금
        // 분기 - CodeEntity구성하기
        for( int i = 1 ; i <= 4 ; i++ ){
            CodeEntity entity = new CodeEntity();
            entity.code  = Integer.toString(i);
            entity.value = Integer.toString(i) + "분기";
            CodeEntityType_vt.addElement(entity);
        }

        selType = e21ExpenseData.PERD_TYPE;
    } else if( e21ExpenseData.SUBF_TYPE.equals("3") ) {   //장학금
        // 학기 - CodeEntity구성하기
        for( int i = 1 ; i <= 3 ; i++ ){
            CodeEntity entity = new CodeEntity();
            entity.code  = Integer.toString(i);
            entity.value = Integer.toString(i) + "학기";
            CodeEntityType_vt.addElement(entity);
        }

        selType = e21ExpenseData.HALF_TYPE;
    }

%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="CodeEntityType_vt" value="<%=CodeEntityType_vt %>" />
<c:set var="selType" value="<%=selType %>" />
<c:set var="currencyValue" value="<%=currencyValue%>" />
<c:set var="currencyValue1" value="<%=currencyValue1%>" />
<c:set var="e_persk" value="<%=user.e_persk%>" />

<tags:layout css="ui_library_approval.css" script="dialog.js" >
<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
<tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_TUTI_FEE" button="${buttonBody}" updateUrl="${g.servlet}hris.E.E21Expense.E21ExpenseChangeSV">
	<tags:script>
		<script>

		//alert('333='+'${E_COUPLEYN}' );
		//alert('444='+'${E_MESSAGE}' );

		jQuery(function(){
			on_Load();
		});

		function beforeAccept()  {
	        var frm = document.form1;

		    if( check_data() ){

	    		<c:if test="${E_COUPLEYN eq 'Y'}">
	             if (!confirm("${E_MESSAGE}")) { // 시간제의 경우 메세지 처리
	                 return;
	             }
		        </c:if>

			// [[CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정요청] 결재시 사원서브그룹체크(주택신규,장학자금)
			// 사원서브그룹 : 14-계약직(자문고문), 24-계약직, 34-계약직(생산기술직), 35-계약직(전문기술직), 36-계약직(4H), 37-계약직(6H)

		       	<c:if test="${(e_persk eq '14') || (e_persk eq '24') || (e_persk eq '34')  || (e_persk eq '35') || (e_persk eq '36')  || (e_persk eq '37')}">

	    	    if (!confirm("계약직이므로 계약처우 내용을 확인후 결재를 진행해주시기 바랍니다.\n계속 진행하시겠습니까?")) {
	                 return;
	            }
		    	</c:if>

		        frm.PAID_AMNT.value = removeComma(frm.PAID_AMNT.value);
		        frm.PAID_DATE.value = removePoint(frm.PAID_DATE.value);
		        frm.YTAX_WONX.value = removeComma(frm.YTAX_WONX.value);
		        frm.PROP_AMNT.value = removeComma(frm.PROP_AMNT.value);
		        //return;

		        return true;
		    }

	    }

		function beforeReject()  {

			var frm = document.form1;

	        frm.PAID_DATE.value = "";
	        frm.PAID_AMNT.value = "0";
	        frm.YTAX_WONX.value = "0";
	        frm.PROP_AMNT.value = removeComma(frm.PROP_AMNT.value);

	    	return true;
	    }

		function check_data(){
		    <c:if test="${approvalHeader.DMANFL ne '01'}"> //부서담당자인경우만 체크 %>
			return true;

		    </c:if>

		    var frm = document.form1;

		    command ="" ;
		    size ="" ;
		    if( isNaN( document.form1.radiobutton.length ) ){
		      size = 1;
		    } else {
		      size = document.form1.radiobutton.length;
		    }
		    for (var i = 0; i < size ; i++) {
		        if ( size == 1 ){
		            command = 0;
		        } else if ( document.form1.radiobutton[i].checked == true ) {
		            command = document.form1.radiobutton[i].value;
		        }
		    }
		    if( command =="신규분" ) {
		        document.form1.PAY1_TYPE.value ="X";
		        document.form1.PAY2_TYPE.value ="";
		    }else if( command =="추가분" ){
		        document.form1.PAY1_TYPE.value ="";
		        document.form1.PAY2_TYPE.value ="X";
		    }else{
		        alert("신청구분을 선택하세요");
		        return false;
		    }

		//  2002.10.18. 신청년도, 신청분기ㆍ학기 선택
		    if(document.form1.selType.selectedIndex==0){
		        alert("신청분기ㆍ학기를 선택하세요");
		        document.form1.selType.focus();
		        return false;
		    }

		//  기입력된 년도-분기ㆍ학기가 있는지 체크하고 있으면 신청을 막는다.    /////////////////
		    if( command == "신규분" ) {
		        if( document.form1.SUBF_TYPE.value == "2") {              //학자금 - 분기

					<c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
					<c:set var="index" value="${inx.index}"/>

		            if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) &&  //@v1.4
		                ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
		                ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
		                ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
		                ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
		                ("${row.PERD_TYPE}" == document.form1.selType.value)   &&
		                ("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}" )  &&
		                ("${row.PAY1_TYPE}" == "X") ) {

		            	alert("<spring:message code='MSG.E.E22.0004' />"); //  alert("현재 분기에 이미 지급 받았거나 신청중입니다.");
		                return false;
		            }

		            </c:forEach>

		            document.form1.PERD_TYPE.value = document.form1.selType.value;
		        } else if( document.form1.SUBF_TYPE.value == "3") {       //장학금 - 학기

					<c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
					<c:set var="index" value="${inx.index}"/>

					 if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) && //@v1.4
	                        ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
	                        ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
	                        ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
	                        ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
	                        ("${row.HALF_TYPE}" == document.form1.selType.value) &&
			                ("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}" )  &&
			                ("${row.PAY1_TYPE}" == "X") ) {

	                        alert("<spring:message code='MSG.E.E22.0005' />"); // alert("해당 학기에 이미 지급 받았거나  신청중인 건이 있습니다.");
	                        return false;
	                    }
					</c:forEach>
		            document.form1.HALF_TYPE.value = document.form1.selType.value;

		        }
		    }


		////////////////////////////////////////////////////////////////
		    var PRE_count =0;

		    var PRE_NEW_count =0;	//@999 동일분기,동일학기의 신규분 신청건수
		    // 장학금 추가분" 신청은 1회까지로 제한  C20101022_59637
		    if( command == "추가분" ) {
		        if( document.form1.SUBF_TYPE.value == "2") {              //학자금 - 분기
		            document.form1.PERD_TYPE.value = document.form1.selType.value;

		            //@999  학자금 동일분기,동일학기 신규분 신청내역건수 확인

		        <c:forEach var="row" items="${E22ExpenseListDataFinish_vt}" varStatus="inx">
				<c:set var="index" value="${inx.index}"/>
				 if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) &&  //@v1.4
                        ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
                        ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
                        ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
                        ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
                        ("${row.PERD_TYPE}" == document.form1.selType.value)   &&
                        ("${row.PAY1_TYPE}" == "X") &&
    		       		("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}") ) {
		                PRE_NEW_count++;
	                    }
				</c:forEach>

		        } else if( document.form1.SUBF_TYPE.value == "3") {       //장학금 - 학기
		            document.form1.HALF_TYPE.value = document.form1.selType.value;

		            <c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
					<c:set var="index" value="${inx.index}"/>

					if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) && //@v1.4
	                        ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
	                        ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
	                        ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
	                        ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
	                        ("${row.HALF_TYPE}" == document.form1.selType.value) &&
	                        ("${row.PAY2_TYPE}" == "X") &&
	    		       		("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}") ) {
	                        PRE_count++;
	                    }
					</c:forEach>

			//@999  장학금 동일분기,동일학기의 신규분 신청건수
					<c:forEach var="row" items="${E22ExpenseListDataFinish_vt}" varStatus="inx">
					<c:set var="index" value="${inx.index}"/>

					if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) && //@v1.4
		                    ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
		                    ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
		                    ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
		                    ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
		                    ("${row.HALF_TYPE}" == document.form1.selType.value) &&
		                    ("${row.PAY1_TYPE}" == "X") &&
	    		       		("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}") ) {
		                    PRE_NEW_count++;
		                }
					</c:forEach>

		        }

			    //@999 장학자금  동일분기,동일학기의 신규분 신청건수
			    if ( PRE_NEW_count < 1 ) {
			    	alert("<spring:message code='MSG.E.E22.0017' />"); //alert("장학금 추가분은 신규분 결재완료 되어야 결재 가능합니다.!\n동일학년 동일분기 신규분을 먼저 신청 및 결재완료후  결재 진행하세요");
			        return false;
			    }

		    }
		 // [CSR ID:3393142] 학자금 신청 관련 로직 수정요청의 건  2017/04/03 by eunha  start
		  /*  if ( PRE_count>= 1 ) {
		    	alert("<spring:message code='MSG.E.E22.0007' />"); // alert("장학금 추가분은 1회만 신청 가능합니다.!");
		        return false;
		    }*/
		 // [CSR ID:3393142] 학자금 신청 관련 로직 수정요청의 건 2017/04/03 by eunha  end
	        if(frm.PAID_AMNT.value == "" ) {
	            alert("지급액을 입력하세요");
	            frm.PAID_AMNT.focus();
	            return false;
	        } // end if
	        if(frm.PAID_DATE.value == "" ) {
	            alert("증빙제출일을 입력하세요");
	            frm.PAID_DATE.focus();
	            return false;
	        } // end if
	        if(frm.YTAX_WONX.value == "" ) {
	            alert("연말 정산 반영액을 입력하세요");
	            frm.YTAX_WONX.focus();
	            return false;
	        } // end if
	        if( checkNull(document.form1.PROP_AMNT,"신청액을") == false ) {
	          return false;
	        }
		    return true;
		}

		//신청유형:장학금인 경우에만 시스템 수정 START
		function on_Load(){

			 <c:if test="${resultData.SUBF_TYPE eq '3'}"> //부서담당자인경우만 체크 %>
				document.getElementById("TYPE_3").style.display="";
		        document.getElementById("TYPE_3_1").style.display="";
		        /* [CSR ID:3569058] 신청유형:장학금인 경우에만 학과필드 display */
				$("#FRTXT").show();
			 </c:if>
		}
		//신청유형:장학금인 경우에만 시스템 수정 END

		</script>
	</tags:script>

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
	           		<th><!-- 가족선택 --><spring:message code="LABEL.E.E22.0038" /></th>
	           		<td colspan="3">
                     	<input type="text" value="${resultData.FAMSA}" size="5" class="noBorder" readonly/>
                     	<input type="text" value="${resultData.ATEXT}" size="10" class="noBorder" readonly/>
	           		</td>
	           	</tr>
	           	<tr>
               		<th><!-- 신청유형 --><spring:message code="LABEL.E.E22.0039" /></th>
               		<td>
              			<c:choose>
               			<c:when test="${ resultData.SUBF_TYPE eq '2'  }">
               				<spring:message code="LABEL.E.E22.0040" /><!--학자금 -->
               			</c:when>
               			<c:otherwise>
               				<spring:message code="LABEL.E.E22.0041" /><!--장학금 -->
               			</c:otherwise>
              			</c:choose>
               		</td>
               		<th class="th02"><!-- 신청년도 --><spring:message code="LABEL.E.E22.0024" /></th>
               		<td>
               			<input type="text" value="${resultData.PROP_YEAR}" style="text-align:center" size="10" class="noBorder" readonly/>
               		</td>
               	</tr>

               	<c:choose>

               	<c:when test="${approvalHeader.DMANFL eq '01'}">
               	<tr>
                    <th><span class="textPink">*</span><!-- 신청구분 --><spring:message code="LABEL.E.E22.0042" /></th>
                    <td>
                      <input type="hidden" name="HALF_TYPE"    value="${resultData.HALF_TYPE}">
				 	  <input type="hidden" name="PAY1_TYPE"    value="${resultData.PAY1_TYPE}">

                      <input type="radio" name="radiobutton" value="신규분" <c:if test = "${resultData.PAY1_TYPE eq 'X' }" >checked</c:if>>
                      	<!-- 신규분 --><spring:message code="LABEL.E.E22.0022" />
                      <input type="radio" name="radiobutton" value="추가분" <c:if test = "${resultData.PAY2_TYPE eq 'X' }" >checked</c:if>>
                      	<!-- 추가분 --><spring:message code="LABEL.E.E22.0023" />
                    </td>
                    <th class="th02"><span class="textPink">*</span><!-- 신청분기ㆍ학기 --><spring:message code="LABEL.E.E22.0025" /></th>
                    <td>
                        <select name="selType" style="width:135px;">
                        <option>-----------</option>
                             ${f:printCodeOption(CodeEntityType_vt, selType)}
                        </select>
                     </td>
                 </tr>

                 </c:when>

                 <c:otherwise>
                 <tr>
                    <th><!-- 신청구분 --><spring:message code="LABEL.E.E22.0042" /></th>
                    <td>
                    	<input type="hidden" name="HALF_TYPE"    value="${resultData.HALF_TYPE}">
				 		<input type="hidden" name="PAY1_TYPE"    value="${resultData.PAY1_TYPE}">
                        <input type="radio" name="radiobutton" value="신규분" <c:if test = "${resultData.PAY1_TYPE eq 'X' }" >checked</c:if> disabled />
                      	<!-- 신규분 --><spring:message code="LABEL.E.E22.0022" />
                        <input type="radio" name="radiobutton" value="추가분" <c:if test = "${resultData.PAY2_TYPE eq 'X' }" >checked</c:if> disabled />
                      	<!-- 추가분 --><spring:message code="LABEL.E.E22.0023" />
                    </td>
                    <th class="th02"><!-- 신청분기ㆍ학기 --><spring:message code="LABEL.E.E22.0025" /></th>
                    <td>
                    <c:choose>
            			<c:when test="${ resultData.SUBF_TYPE eq '2'  }">
           					<input type="text" name="TYPE" value="${resultData.PERD_TYPE} 분기" style="text-align:center" size="10" class="noBorder" readonly/>
            			</c:when>
            			<c:otherwise>
           					<input type="text" name="TYPE" value="${resultData.HALF_TYPE} 학기" style="text-align:center" size="10" class="noBorder" readonly/>
            			</c:otherwise>
           			 </c:choose>
                     </td>
                 </tr>
                 </c:otherwise>

               	 </c:choose>

               	 <tr>
                     <th><!-- 이름 --><spring:message code="LABEL.E.E22.0017" /></th>
                     <td colspan="3">
                     	  <input type="text" name="full_name" value="<c:out value='${fn:trim(resultData.LNMHG)}'/> <c:out value='${fn:trim(resultData.FNMHG)}'/>" size="14" class="noBorder" readonly/>
                     </td>
                  </tr>
                  <tr>
            		  <th><!-- 학력 --><spring:message code="LABEL.E.E22.0026" /></th>
            		  <td colspan="3">
                      	  <input type="text" value="${resultData.ACAD_CARE}" size="5" class="noBorder" readonly />
                      	  <input type="text" value="${resultData.STEXT}" size="20" class="noBorder" readonly />
            		  </td>
           		  </tr>


           		  <tr>
            		  <th><!-- 교육기관 --><spring:message code="LABEL.E.E22.0027" /></th>
            		  <td>
            		  	   <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                    	   <input type="text" value="${resultData.SCHCODE}" class="noBorder" size="9" readonly />
                    	   <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                      	   <input type="text" value="${resultData.FASIN}" class="noBorder" size="30" readonly />
            		  </td>
            		  <th class="th02"><!-- 학년 --><spring:message code="LABEL.E.E22.0029" /></th>
            		  <td>

            		  <c:choose>
               		  <c:when test="${approvalHeader.DMANFL eq '01'}">
               		  	   <input type="text" name="ACAD_YEAR" value="${resultData.ACAD_YEAR eq '0' ? '' : resultData.ACAD_YEAR}" style="text-align:center" size="10"  onBlur="javascript:usableChar(this,'123456890');" maxlength="1"  />
           		  	  </c:when>
               		  <c:otherwise>
               		  		<input type="text" name="ACAD_YEAR" value="${resultData.ACAD_YEAR eq '0' ? '' : resultData.ACAD_YEAR}" style="text-align:center" size="10" class="noBorder" readonly />
               		  </c:otherwise>
               		  </c:choose>
            		  	  <!-- 학년 --><spring:message code="LABEL.E.E22.0029" />
            		  </td>
           		  </tr>
				  <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 start -->
				  <tr id="FRTXT" style="display:none;">
                      <th><!-- 학과 --><spring:message code="LABEL.E.E22.0047" /></th>
                      <td colspan="3">
	               	  		<input type="text" name="FRTXT" value="${resultData.FRTXT}" style="text-align:left" size="40" class="noBorder" readonly/>
                      </td>
                  </tr>
				  <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 end -->
           		  <tr>
                      <th><!-- 신청액 --><spring:message code="LABEL.E.E22.0018" /></th>
                      <td>

                          <c:choose>
	               		  <c:when test="${approvalHeader.DMANFL eq '01'}">
	               		  	   <input type="text" name="PROP_AMNT" value="${f:printNumFormat(resultData.PROP_AMNT, currencyValue) }" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS');" style="text-align:right" size="20">
	                          <select name="WAERS" onChange="javascript:moneyChkForLGchemR3(document.form1.PROP_AMNT,'WAERS');javascript:moneyChkReSetting();">
	                          <!-- 통화키 가져오기-->
	                           ${f:printCodeOption(currencyCodeList,resultData.WAERS)}
	                           <!-- 통화키 가져오기-->
	           		  	  </c:when>
	               		  <c:otherwise>
	               		  		<input type="text" name="PROP_AMNT" value="${f:printNumFormat(resultData.PROP_AMNT, currencyValue) }" style="text-align:right" size="12" class="noBorder" readonly/> ${resultData.WAERS}
	               		  </c:otherwise>
	               		  </c:choose>

                      </td>
                      <th class="th02"><!-- 수혜횟수 --><spring:message code="LABEL.E.E22.0030" /></th>
                      <td>
                      	  <input type="text" name="P_COUNT" value="${f:printNum(resultData.p_COUNT)}" style="text-align:center" size="10" class="noBorder" readonly/> <!-- 회 --><spring:message code="LABEL.E.E22.0037" />
                      </td>
                  </tr>

                  <tr>
                      <th><!-- 입학금 --><spring:message code="LABEL.E.E22.0028" /></th>
                      <td>
                      	  <c:choose>
	               		  <c:when test="${approvalHeader.DMANFL eq '01'}">
	               		  		<input type="checkbox" name="ENTR_FIAG" value="X" <c:if test = "${resultData.ENTR_FIAG eq 'X' }" >checked</c:if> >
	               		  </c:when>
	               		  <c:otherwise>
	               		  		<input type="checkbox" <c:if test = "${resultData.ENTR_FIAG eq 'X' }" >checked</c:if> disabled />
	               		  		<input type="hidden" name="ENTR_FIAG"    value="${resultData.ENTR_FIAG}">
	               		  </c:otherwise>
	               		  </c:choose>
                      </td>

                      <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                      <th class="th02" ><div  id="TYPE_3" style="display:none;"><!-- 유학 학자금 --><spring:message code="LABEL.E.E22.0031" /></div></th>
                      <td>
                      	   <div id="TYPE_3_1" style="display:none;" >
                      	  <input type="checkbox" name="ABRSCHOOL" value="X" size="20" class="noBorder" <c:if test = "${resultData.ABRSCHOOL eq 'X' }" >checked</c:if> disabled />
                      	  </div>
                      </td>
                      <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                  </tr>

                  <tr>
                  	  <td colspan="4"><h2 class="subtitle">담당자 정보</h2></td>
                  </tr>

                  <c:choose>
           		  <c:when test="${approvalHeader.DMANFL eq '01'}">

           		  <tr>
                      <th><!-- 회사지급액 --><spring:message code="LABEL.E.E22.0019" /></th>
                      <td width="240">
                          <input name="PAID_AMNT" type="text" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS1');" onBlur="if (this.value == '') this.value = '0' ;" style="text-align:right" size="20" value="${f:printNumFormat(resultData.PROP_AMNT, currencyValue) }">
                          <select name="WAERS1">
                           <option>------</option>
							${f:printCodeOption(currencyCodeList,  "KRW")}
			              </select>
                       </td>
                       <th class="th02"><!-- 연말정산반영액 --><spring:message code="LABEL.E.E22.0032" /></th>
                       <td>
                       	  <input name="YTAX_WONX" type="text" style="text-align:right" onKeyUp="javascript:moneyChkEvent(this,'KRW');" onBlur="if (this.value == '') this.value = '0' ;" size="20" value="${f:printNumFormat(resultData.PROP_AMNT, currencyValue) }">
                       </td>
                  </tr>

                  <tr>
	                  <th>증빙제출일</th>
	                  <td colspan="3">
	                    <!-- 날짜검색-->
	                    <input type="text" name="PAID_DATE" id="PAID_DATE" size="10" class="date" maxlength="10">
	                    <!-- 날짜검색-->
	                  </td>
                  </tr>

           		  </c:when>

           		  <c:when test="${approvalHeader.DMANFL eq '02'}">
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

           		  </c:otherwise>

           		  </c:choose>

     		</table>
     	</div>


	    <!-- Hidden Field -->
	    <input type="hidden" name="APPU_TYPE" value="" >

		<input type="hidden" name="BUKRS" value="${user.companyCode}">

		<input type="hidden" name="PERNR"        value="${resultData.PERNR}">
		<input type="hidden" name="BEGDA"        value="${resultData.BEGDA}">
		<input type="hidden" name="FAMSA"        value="${resultData.FAMSA}">
		<input type="hidden" name="ATEXT"        value="${resultData.ATEXT}">
		<input type="hidden" name="SUBF_TYPE"    value="${resultData.SUBF_TYPE}">
		<input type="hidden" name="PAY2_TYPE"    value="${resultData.PAY2_TYPE}">
		<input type="hidden" name="PERD_TYPE"    value="${resultData.PERD_TYPE}">
		<input type="hidden" name="PROP_YEAR"    value="${resultData.PROP_YEAR}">
		<input type="hidden" name="LNMHG"        value="${resultData.LNMHG}">
		<input type="hidden" name="FNMHG"        value="${resultData.FNMHG}">
		<input type="hidden" name="ACAD_CARE"    value="${resultData.ACAD_CARE}">
		<input type="hidden" name="STEXT"        value="${resultData.STEXT}">
		<input type="hidden" name="FASIN"        value="${resultData.FASIN}">
		<input type="hidden" name="WAERS"        value="${resultData.WAERS}">
		<input type="hidden" name="BIGO_TEXT1"   value="${resultData.BIGO_TEXT1}">
		<input type="hidden" name="BIGO_TEXT2"   value="${resultData.BIGO_TEXT2}">
		<input type="hidden" name="OBJC_CODE"    value="${resultData.OBJC_CODE}">

		<input type="hidden" name="P_COUNT"      value="${resultData.p_COUNT}">

		<input type="hidden" name="GESC2"        value="${resultData.GESC2}">
		<input type="hidden" name="KDSVH"        value="${resultData.KDSVH}">
		<input type="hidden" name="REGNO"        value="${resultData.REGNO}">
		<input type="hidden" name="POST_DATE"    value="${resultData.POST_DATE}">
		<input type="hidden" name="BELNR"        value="${resultData.BELNR}">
		<input type="hidden" name="ZPERNR"       value="${resultData.ZPERNR}">
		<input type="hidden" name="ZUNAME"       value="${resultData.ZUNAME}">
		<input type="hidden" name="AEDTM"        value="${resultData.AEDTM}">
		<input type="hidden" name="UNAME"       value="${resultData.UNAME}">

		<!-- 신청유형:장학금인 경우에만 시스템 수정 START  -->
		<input type="hidden" name="SCHCODE"       value="${resultData.SCHCODE}">
		<input type="hidden" name="ABRSCHOOL"       value="${resultData.ABRSCHOOL}">
		<!-- 신청유형:장학금인 경우에만 시스템 수정 END -->

		<input type="hidden" name="SUBTY"       value="${resultData.FAMSA}">        <!-- 가족유형 -->

	    <!-- Hidden Field -->

    <!-- 상단 입력 테이블 끝-->
    </div> <!--  end tableArea -->

</tags-approval:detail-layout>
</tags:layout>



