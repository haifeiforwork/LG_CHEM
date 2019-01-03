<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 급여계좌정보                                                */
/*   Program Name : 급여계좌 신청                                               */
/*   Program ID   : A14BankBuild.jsp                                            */
/*   Description  : 급여계좌를 신청하는 화면                                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08 김도신                                           */
/*   Update       : 2005-03-03 윤정현                                           */
/*                  : 2016-09-20 통합구축 - 김승철                     */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.A14Bank.*" %>
<%@ page import="hris.A.A14Bank.rfc.*" %>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");

	Vector              a14BankStockFeeData_vt = (Vector)request.getAttribute("a14BankStockFeeData_vt");
	A14BankStockFeeData data                   = (A14BankStockFeeData)Utils.indexOf(a14BankStockFeeData_vt,0);

    String  acctype = (String)request.getAttribute("acctype");

    /* 현재 등록된 급여계좌를 가져간다. */
    A03AccountDetail1Data  adata = (A03AccountDetail1Data)request.getAttribute("A03AccountDetail1Data");// 신청시 자료있음. 수정시 자료없음.
    PersonData  phoneUser = (PersonData)request.getAttribute("PersonData");
    if( adata == null ) {
      adata = new A03AccountDetail1Data();
      DataUtil.fixNull(adata);
    }

    /* 급여계좌 리스트를 vector로 받는다*/
    String pcode="";
    Vector  a14BankCodeData_vt = (Vector)request.getAttribute("a14BankCodeData_vt");
    Vector  a14BankValueData_vt = (Vector)request.getAttribute("a14BankValueData_vt");
    Vector  a14BankTypeData_vt = (Vector)request.getAttribute("a14BankTypeData_vt");
    if(a14BankCodeData_vt!=null && adata.ZBANKL != null){
		for(int i=0;i<a14BankCodeData_vt.size();i++){
			A14BankCodeData pdata = (A14BankCodeData)Utils.indexOf(a14BankValueData_vt, i);
//          if(pdata.bank_code.equals(adata.ZBANKL)){
//            if(pdata.BANK_CODE.equals(adata.ZBANKL)){
            if(pdata.ZBANKL.equals(adata.ZBANKL)){
				pcode=pdata.ZBANKS;
			}
		}
	}

    /* 결제정보를 vector로 받는다*/
   // Vector          AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
//     Vector provinceVt = new A14BankProvinceRFC().getProvinceCode(pcode);
    String PERNR = adata.PERNR;
    Boolean isUpdate = (Boolean)request.getAttribute("isUpdate");
    if (isUpdate==null) isUpdate=false;


    String BNKSA_name = "";

	if(isUpdate==true){

		adata.BNKSA    = data.BNKSA   ;
		adata.ZBANKA    = data.ZBANKA   ; // 은행명
		adata.ZBANKL    = data.ZBANKL   ;// 은행코드
		adata.ZBANKN    = data.ZBANKN   ;
		adata.ZBKREF     = data.ZBKREF   ;
// 		adata.BRANCH    = data.BRANCH   ;
		adata.EMFTX     = data.EMFTX    ;
		adata.VORNA     = data.VORNA    ;
		adata.NACHN     = data.NACHN    ;
		adata.VORNA     = data.VORNA    ;
		adata.EMFTX     = data.EMFTX    ;

	}else{
		data = new A14BankStockFeeData();
		data.ZBANKA    = adata.ZBANKA   ; // 은행명
		data.ZBANKL    = adata.ZBANKL   ; // 은행코드
		data.BNKSA    = acctype   ;
		data.ZBANKN    = adata.ZBANKN   ;
		data.ZBKREF     = adata.ZBKREF   ;
// 		data.BRANCH    = adata.BRANCH   ;
		data.EMFTX     = adata.EMFTX    ;
		data.VORNA     = adata.VORNA    ;
		data.NACHN     = adata.NACHN    ;
		data.VORNA     = adata.VORNA    ;
		data.EMFTX     = adata.EMFTX    ;
	}

	if( data.BNKSA.equals("0")){
        BNKSA_name = g.getMessage("MSG.A.A03.0009") ;
    }else{
        BNKSA_name =g.getMessage("MSG.A.A03.0010") ;
    }


Logger.debug.println(">>>>>>>>> BNKSA_name::"+BNKSA_name);
%>

<c:set var="BNKSA_name" value="<%=BNKSA_name%>"/>
<c:set var="area" value="<%=WebUtil.getSessionUser(request).area %>"/>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="PERNR" value="<%=adata.PERNR%>"/>
<c:set var="adata" value="<%=adata %>"/>
<c:set var="isUpdate" value="<%=isUpdate %>"/>
<c:set var="data" value="<%=data %>"/>
<c:set var="pcode" value="<%=pcode %>"/>
<c:set var="a14BankCodeData_vt" value="<%=a14BankCodeData_vt %>"/>
<c:set var="a14BankValueData_vt" value="<%=a14BankValueData_vt %>"/>
<c:set var="a14BankTypeData_vt" value="<%=a14BankTypeData_vt %>"/>
<%-- <c:set var="provinceVt" value="<%=provinceVt %>"/> --%>
<c:set var="phoneUser" value="<%=phoneUser %>"/>

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  script="dialog.js" >


        	    <script language="JavaScript" src="/web/A/A14Bank/A14getProvince.js"></script>

	            <script>


	    $(function(){
	           	   if(${isUpdate!=true}){
	 	           	   $(".btn_crud").html($(".btn_crud").html()+" <li><a href='javascript:history.back();''><span><spring:message code='BUTTON.COMMON.BACK'/><!--이전화면--></span></a></li>");
	           	   }
		           		<%-- 기본값이 없을경우 선택하지않은값과 비동기방지 --%>
	           	   bank_get();
		           	get_bankname();
	           	   if(${isUpdate}){
		           	   $('#ZBANKL').val( document.form1.ZBANKL.options[document.form1.ZBANKL.selectedIndex].value);
	           		   $("#STATE1").val( '${data.STATE1}');
	           	   }
	    })       		;
						<!--
						//20151113
						function bankType_get() {
							document.form1.STEXT.value     = document.form1.STEXT.options[document.form1.STEXT.selectedIndex].text;
						 	ajax_change(document.form1.STEXT.options[document.form1.STEXT.selectedIndex].value);
						 	/*if(document.form1.STEXT.value="报销账号"){
						 	 document.form1.ZBANKL.options[document.form1.ZBANKL.selectedIndex].text="友利银行";
						 	bank_get();
						 	}else{
						 	document.form1.ZBANKL.value ="中国工商银行";
						 	bank_get();
						 	}*/
						}

						function get_bankname(){
							if(document.form1.STEXT!=undefined){

								if(document.form1.STEXT.value=='<spring:message code="MSG.A.A03.0010"/>' ){ // 报销账号'){
									bankname.style.visibility = 'hidden';
									bankname1.style.visibility = 'hidden';
									lastName.innerHTML = '<span class="textPink">*</span><spring:message code="MSG.A.A14.0016"/>';
									if(document.form1.EMFTX.value==''){
										document.form1.NACHN1.value = '';
										document.form1.ZBANKNZBKREF.value = '';
									}else{
										document.form1.NACHN1.value = document.form1.EMFTX.value;
										document.form1.ZBANKNZBKREF.value = document.form1.ZBANKN.value+document.form1.ZBKREF.value;
									}
								}else{
									bankname.style.visibility = '';
									bankname1.style.visibility = '';
									lastName.innerHTML = '<span class="textPink">*</span><spring:message code="MSG.A.A14.0014"/>';
									if(document.form1.NACHN.value==''){
										document.form1.NACHN1.value = '';
										document.form1.ZBANKNZBKREF.value = '';
									}else{
										document.form1.NACHN1.value = document.form1.NACHN.value;
										document.form1.ZBANKNZBKREF.value = document.form1.ZBANKN.value+document.form1.ZBKREF.value;
									}
								}
							}
						}
						//20151113

						function bank_get() {
							if (document.form1 !=  undefined){
								document.form1.ZBANKA.value     = document.form1.ZBANKL.options[document.form1.ZBANKL.selectedIndex].text;
							 	getProvince(
						 			document.form1.ZBANKL.options[document.form1.ZBANKL.selectedIndex].value,
						 			document.form1.PERNR.value,
						 			'${data.STATE1}' );
							}
						}



						function beforeSubmit() {
							if(check_data()){
								document.form1.ZBANKN.value = document.form1.ZBANKNZBKREF.value.substring(0,18);
								document.form1.ZBKREF.value = document.form1.ZBANKNZBKREF.value.substring(18);
								return true;
							} else{
								return false;
							}
						}

						function check_data1(){
							if(document.form1.ZBANKL.value==''){
								return false;
							}else if(document.form1.ZBANKNZBKREF.value==''){
								return false;
							}else if(isNaN(document.form1.ZBANKNZBKREF.value)){
								alert("please input number");
								document.form1.ZBANKNZBKREF.focus();
								return false;
							}else{
							document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value);
								return true;
							}
						}

						function check_data(){
						  if( checkNull(document.form1.ZBANKNZBKREF, "Bank Account" ) == false ) {
						    return false;
						  } else {
						    if( isNaN(document.form1.ZBANKNZBKREF.value) ) {
						      alert("please input number");
						      document.form1.ZBANKNZBKREF.focus();
						      return false;
						    }
						  }
						  <c:if test='${user.companyCode=="G100" && phoneUser.e_PERSG=="A" }'>
					      <c:choose>
					      <c:when test='${data.BNKSA=="0"}'>

						  if( checkNull(document.form1.NACHN1, "Last Name" ) == false ) {
						    return false;
						  }
						  if( checkNull(document.form1.VORNA1, "First Name" ) == false ) {
						    return false;
						  }
                          </c:when>

						  <c:when test='${adata.BNKSA==("7")}'>
						    if( checkNull(document.form1.NACHN1, "Full Name" ) == false ) {
						    return false;
						  }
						  </c:when>
						  </c:choose>

// 						   if(document.form1.STEXT.value==''){
// 						 	alert("Select bank type value");
// 						 	document.form1.STEXT.focus();
// 						 	return false;
// 						 }
						  </c:if>

						  <c:if test='${area != "PL" }'>

// 						 if(document.form1.STATE1.value==''){
// 						 	alert("Select province value");
// 						 	document.form1.STATE1.focus();
// 						 	return false;
// 						 }

						 </c:if>

						  //document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value);
						  return true;
						}

						function do_preview(){
						  document.form1.action = "${g.servlet}hris.A.A03AccountGlobalSV";
						  document.form1.method = "post";
						  document.form1.submit();
						}

						function reload() {
						    frm =  document.form1;
						    frm.action = "${g.servlet}hris.A.A03AccountGlobalSV";
						    frm.target = "";
						    frm.submit();
						}

						//-->
						</script>



   <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PY_BANK_DETAIL" representative="false">
        <!-- 상단 입력 테이블 시작-->

        <tags:script>
			</tags:script>

            <!-- 상단 입력 테이블 시작-->
            <div class="tableArea">
                <div class="table">
                    <table class="tableGeneral">
        	<colgroup>
                <col width="15%">
                <col width="35%">
                <col width="15%">
                <col width="35%">

        	</colgroup>



             <c:choose>
             <c:when test='${(user.companyCode=="G100" && phoneUser.e_PERSG =="A")}' >
                      <tr>
                        <th  ><span class="textPink">*</span><spring:message code="MSG.A.A03.0005"/><!--Bank Type-->
                            </th>
                        <td colspan=3><select name="STEXT"  class="required"  onChange="javascript:get_bankname();"
                        			placeholder='<spring:message code="MSG.A.A03.0005"/>'>
                        <option value=""><spring:message code="MSG.A.A03.0020"/><!--Select--></option>
                                 ${f:printOptionBankType(a14BankTypeData_vt, BNKSA_name)}
<%--                                  ${f:printOption(a14BankTypeData_vt, "SUBTY", "STEXT", adata.BNKTX)} --%>
                          </select>
                        </td>
                      </tr>

               </c:when>
               </c:choose>

                      <tr>
                        <th ><span class="textPink">*</span><spring:message code="MSG.A.A03.0006"/><!--Bank Key -->
                            </th>
                        <td >
                        <select id="ZBANKL"  name="ZBANKL"  class="required"  onChange="javascript:bank_get();">
								         ${f:printOption(a14BankCodeData_vt, "ZBANKL","ZBANKA", data.ZBANKL)}
                          </select> </td>

                        <th  class="th02" ><span class="textPink">*</span><spring:message code="MSG.A.A03.0008"/><!--Bank Account -->
                                </th>
                        <td  >
                        	<c:choose>
                        	<c:when test='$(isUpdate==true)'>
                        		<input type="number" name="ZBANKNZBKREF" size="33" maxlength="30" class="required number" value="${ data.ZBANKN }${data.ZBKREF }"
                        				placeholder='<spring:message code="MSG.A.A03.0008"/>'  >
                        	</c:when>
                        	<c:otherwise>
                        		<input type="text" name="ZBANKNZBKREF" size="33" maxlength="30" class="required number" value="${ adata.ZBANKN }${adata.ZBKREF }"
                        				placeholder='<spring:message code="MSG.A.A03.0008"/>'  >
                       		</c:otherwise>
                       		</c:choose>
                        <input type="hidden" name="ZBANKN" value="${ adata.ZBANKN }">
                        <input type="hidden" name="ZBKREF" value="${ adata.ZBKREF }">
                        </td>
                      </tr>

                <c:if test='${area != "PL" }'>
                       <tr>
                        <th ><spring:message code="MSG.A.A14.0012"/><!-- Province --></th>
                        <td >
                             <span id="province" name="province">
                             <select id="STATE1" name="STATE1" class="required" placeholder='<spring:message code="MSG.A.A14.0012"/>' >
                             	<c:if test='${  isUpdate == false}'>
                        		  <option value=""><spring:message code="MSG.A.A03.0005"/><!--Select--></option>
                        		 </c:if>
<%-- 								    ${f:printCodeOption(provinceVt, 'data.STATE1')} --%>
                              </select><input type="hidden" name="ZBANKS" value="${ pcode }"></span></td>
                        <th  class="th02"><spring:message code="MSG.A.A14.0013"/><!--Branch Name--> </th>
                        <td >
                            <input type="text" name="BRANCH" size="23" value="${ data.BRANCH }">
                        </td>
                      </tr>
                      <tr>
			</c:if>


             <c:if test='${user.companyCode=="G100" && phoneUser.e_PERSG=="A"}'>
                <c:choose>
 				 <c:when test='${ adata.BNKSA=="0" || adata.BNKSA==""}'>

                        <th >

                             <span id="lastName" name="lastName"   style={visibility:}; >
                             <spring:message code="MSG.A.A14.0014"/><!--Last Name--></span>
                             </th>
                        <td >
                            <input type="text" name="NACHN1" value="${data.NACHN }"  size="23" maxlength="20" class="required"
                            		placeholder='<spring:message code="MSG.A.A14.0014"/>'  > </td>
                        <th  class="th02">
                            <div id="bankname"  style={visibility:}; >
                            <span class="textPink">*</span>
                            <spring:message code="MSG.A.A14.0015"/></div><!--First Name-->
                            </th>
                        <td >
                            <span id="bankname1"  style={visibility:}; >
                            <input type="text" name="VORNA1" value="${ data.VORNA }"  size="23" maxlength="20" class="input03"  >
                        	<input type ="hidden" name="NACHN" value="${data.NACHN }">
                       		<input type ="hidden" name="VORNA" value="${data.VORNA }">
                        	<input type ="hidden" name="EMFTX" value="${data.EMFTX }">
                       </span></td>

                 </c:when>
               	<c:when test='${adata.BNKSA=="7"}'>

                        <th><span id="lastName" name="lastName"   style={visibility:}; >
                                <span class="textPink">*</span><spring:message code="MSG.A.A14.0016"/><!--Full Name--></span>
                                </th>
                        <td ><input type="text" name="NACHN1" value="${data.EMFTX }"  size="23" maxlength="20" class="required"
                        			placeholder='<spring:message code="MSG.A.A14.0016"/>'  ></td>
                        <th  class="th02"><div id="bankname"  style={visibility:hidden}; >
                                <span class="textPink">*</span>
                                <spring:message code="MSG.A.A14.0015"/> <!--First Name-->
                                </div>
                         </th>


                        <td ><span id="bankname1"  style={visibility:hidden}; >
                            <input type="text" name="VORNA1" value="${ data.VORNA }"  size="23" maxlength="20" class="input03"  >
                        	<input type ="hidden" name="NACHN" value="${data.NACHN }">
                       		<input type ="hidden" name="VORNA" value="${data.VORNA }">
                        	<input type ="hidden" name="EMFTX" value="${data.EMFTX }">
                       </span></td>

                 	</c:when>
                 	</c:choose>
     				</c:if>

          </tr>

 <%--
          <tr>
            <td> </td>
          </tr>
          <tr>
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="font01"><img src="${ WebUtil.ImageURL }ehr/icon_o.gif">
                    Approval Information</td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td align="center">
                    <span id="sc_button"><a href="javascript:doSubmit();"><img src="${ WebUtil.ImageURL %>btn_build.gif" align="absmiddle" border="0"></a></span>
                    <a href="javascript:do_preview();"> <img src="${ WebUtil.ImageURL %>btn_prevview.gif" border="0" align="absmiddle"></a>
                  </td>
                </tr>
              </table></td>
          </tr>
     --%>
          <!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="BEGDA"       value="${f:currentDate()}">
          <input type="hidden" name="ZBANKA"   value="${ adata.ZBANKA }">
          <input type="hidden" name="BNKSA"   value="${ adata.BNKSA }">
          <input type="hidden" name="BNKTX"   value="${ adata.BNKTX }">
          <!--  HIDDEN  처리해야할 부분 끝-->
        </table>
	    <div class="commentsMoreThan2">
             <div>

                <spring:message code="MSG.COMMON.0061"/><!-- *: Required Field-->
             </div>
        </div>
	</div></div>
   </tags-approval:request-layout>

</tags:layout>

