<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 급여계좌정보                                                */
/*   Program Name : 급여계좌 수정                                               */
/*   Program ID   : A14BankDetail.jsp                                           */
/*   Description  : 급여계좌를 조회하는 화면                                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08 김도신                                           */
/*   Update       : 2005-03-03 윤정현                                           */
/*                      2016-09-20 GEHR통합작업 -KSC				*/
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.common.constant.Area" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.A.A14Bank.*" %>
<%@ page import="hris.A.A14Bank.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");

    /* 급여계좌 레코드를 vector로 받는다*/
    Vector              a14BankStockFeeData_vt = (Vector)request.getAttribute("a14BankStockFeeData_vt");
    A14BankStockFeeData data                   = (A14BankStockFeeData)Utils.indexOf(a14BankStockFeeData_vt,0);
    PersonData  phoneUser = (PersonData)request.getAttribute("PersonData");

    String pcode="";
    Vector  a14BankValueData_vt = (Vector)request.getAttribute("a14BankValueData_vt");

    if(a14BankValueData_vt!=null){
		for(int i=0;i<a14BankValueData_vt.size();i++){
			A14BankCodeData pdata =(A14BankCodeData)a14BankValueData_vt.get(i);
// 			Logger.debug.println(i+" pdata.ZBANKL data.ZBANKL::"+pdata.ZBANKL +" "+data.ZBANKL);
			if(pdata.ZBANKL.equals(data.ZBANKL)){
				pcode=pdata.ZBANKS;
				i = a14BankValueData_vt.size();

			}
		}
	}

    Vector provinceVt = (new A14BankProvinceRFC().getProvinceCode(pcode));
%>

<c:set var="user" value="<%=user %>"/>
<c:set var="data" value="<%=data %>"/>
<c:set var="area" value="<%=WebUtil.getSessionUser(request).area %>"/>
<c:set var="a14BankValueData_vt" value="<%=a14BankValueData_vt %>"/>
<c:set var="provinceVt" value="<%=provinceVt %>"/>
<c:set var="phoneUser" value="<%=phoneUser %>"/>


<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PY_BANK_DETAIL" updateUrl="${g.servlet}hris.A.A14Bank.A14BankChangeGlobalSV">

        <%-- 신청 내역 조회 부분 --%>

               <script>

<!--
function do_change(){
  if( chk_APPR_STAT(0) ){
    document.form1.jobid.value = "first";
    document.form1.AINF_SEQN.value = "${ data.AINF_SEQN }";

    document.form1.action = "${ g.servlet }hris.A.A14Bank.A14BankChangeGlobalSV";
    document.form1.method = "post";
    //document.form1.submit();
  }
}

function do_delete(){
	if( chk_APPR_STAT(1) && confirm("Are you sure to delete?") ) {
		document.form1.jobid.value = "delete";
		document.form1.AINF_SEQN.value = "${ data.AINF_SEQN }";

		document.form1.action = "${ g.servlet }hris.A.A14Bank.A14BankDetailGlobalSV";
		document.form1.method = "post";
	//	document.form1.submit();
	}
}


function do_preview(){
  document.form1.action = "${ g.servlet }hris.A.A03AccountGlobalSV";
  document.form1.method = "post";
//  document.form1.submit();
}

function beforeAccept()
{
var frm = document.form1;
if(frm.CERT_DATE != undefined){
   <c:if test="${disabled !='disabled'}">
 	 if (frm.CERT_DATE.value == "") {
       alert("<spring:message code='MSG.E.E19.0039' />"); //Please input submit date.
       frm.CERT_DATE.focus();
       return;
     } // end if

    var radios = document.getElementsByName('CERT_FLAG');
    for (var i =0; i<radios.length; i++){
    	if (radios[i].checked && radios[i].value=="N"){
    	  alert("<spring:message code='MSG.E.E19.0041' />"); //Please check document evidence.
          return;
    	}
    } // end if
  </c:if>

	frm.CERT_DATE.value	= removePoint(frm.CERT_DATE.value);
}
return true;
}

//-->
</script>

        <tags:script>
</tags:script>


<%--
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('${ g.image }btn_help_on.gif')">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16"> </td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780"> <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02"><img src="${ g.image }ehr/title01.gif">Bank Account Change</td>
                  <td align="right"> <a href="javascript:open_help('A03Account.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','${ g.image }btn_help_on.gif',1)"><img name="Image6" border="0" src="${ g.image }btn_help_off.gif" alt="Guide"></a>
                  </td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                 <td height="3" align="left" valign="top" background="/web/images/maintitle_line.gif"><img src="${ g.image }ehr/space.gif"></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td height="10"> </td>
          </tr>
<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="../../common/PersonInfo.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->

<%
    }
--%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
                 <colgroup>
                    <col width="15%"/>
                    <col width="35%"/>
                    <col width="15%"/>
                    <col width="35%"/>
                </colgroup>
                    <!-- 20151216 bankcard pangxiaolin start -->
                      <c:if test='${user.companyCode=="G100" && phoneUser.e_PERSG=="A" }'>

                          <c:choose>
                          <c:when test='${data.BNKSA=="0"}'>

		                      <tr>
		                        <th  ><spring:message code="MSG.A.A03.0005"/><!--Bank Type--></td>
		                        <td class="th02" colspan=3>
			                            <input type="text" name="BNKSA" value='<spring:message code="MSG.A.A03.0009"/>' size="7" class="noBorder" readonly>
		                        </td>
		                      </tr>

		                       <tr>
		                        <th ><spring:message code="MSG.A.A14.0014"/><!--Last Name--><font color="#006699"></font></td>
		                        <td class="th02">  <input type="text" name="NACHN" value="${data.NACHN }"  size="23" class="noBorder"  readonly > </td>
		                        <th ><spring:message code="MSG.A.A14.0015"/></span><!--First Name --><font color="#006699"></font></td>
		                        <td  ><input type="text" name="VORNA" value="${data.VORNA }"  size="23" class="noBorder"   readonly >
		                        	<input type="hidden" name="EMFTX" value="${ data.EMFTX }">
		                        </td>
		                      </tr>

                      </c:when>
                      <c:when test='${data.BNKSA=="7"}'>

	                      <tr>
	                      	<th  ><spring:message code="MSG.A.A03.0005"/><!--Bank Type--></td>
	                        	<td >
			                            <input type="text" name="BNKSA" value='<spring:message code="MSG.A.A03.0010"/>' size="7" class="noBorder" readonly>
	                        	</td>
	                     	<th class="th02"><spring:message code="MSG.A.A14.0016"/><!--Full Name--><font color="#006699"></font></td>
	                        <td  ><input type="text" name="EMFTX" value="${data.EMFTX }"  size="23" class="noBorder"   readonly >
	                     		<input type="hidden" name="NACHN" value="${ data.NACHN }">
	                     		<input type="hidden" name="VORNA" value="${ data.VORNA }"></td>
	                     	</tr>

                  	 </c:when>
                </c:choose>
                </c:if>


                <!-- 20151216 bankcard pangxiaolin end -->
                <tr>
                  <th ><spring:message code="MSG.A.A14.0005"/><!--Bank Code--></th>
                  <td >
                    <input type="text" name="ZBANKA" value="${ data.ZBANKA }" size="40" class="noBorder" readonly>
                  </td>
                  <th class="th02"><spring:message code="MSG.A.A14.0006"/><!--Account Number--></th>
                  <td >
                    <input type="text" name="ZBANKNZBKREF" value="${ data.ZBANKN}${data.ZBKREF }" size="43" maxlength="50" class="noBorder" readonly>
					<input type="hidden" name="ZBANKN" value="${ data.ZBANKN }">
					<input type="hidden" name="ZBKREF" value="${ data.ZBKREF }">
                  </td>
                </tr>



                <c:if test='${area != "PL" }'>
                       <tr>
                        <th ><spring:message code="MSG.A.A14.0012"/><!--Province--></th>
                        <td >
                            <input type="text" name="STATE1" size="20" maxlength="18" class="noBorder"
                            		value="${f:printOptionValueText(provinceVt, data.STATE1) }" readonly></td>

                        <th  class="th02"><spring:message code="MSG.A.A14.0013"/><!--Branch Name--> </th>
                        <td  >
                            <input type="text" name="BRANCH" size="20" maxlength="18" class="noBorder" value="${ data.BRANCH }" readonly>
                        </td>
                      </tr>

               </c:if>


            	<tr style="display:${(I_APGUB == '1') ? 'block':'none' }">
             	    <th ><spring:message code='LABEL.E.E18.0064' /><!-- Document Evidence --></th>
             		<td >
             			<input type="radio" name="CERT_FLAG" value="Y" ${ data.CERT_FLAG == 'Y' ? "checked":"" }>Yes
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       <input type="radio" name="CERT_FLAG" value="N"  ${ data.CERT_FLAG != 'Y' ? "checked":"" } >No

             		</td>
             		<th class="th02"><spring:message code='LABEL.E.E18.0065' /><!-- Submit Date --></th>
             		<td  >
                               <input type="text" name="CERT_DATE" size="10" maxlength="10"
                                value="${date.CERT_DATE }" class="date " onBlur="dateFormat(this);">
                   </td>
             	</tr>
             </table>
             <!-- 상단 입력 테이블 끝-->
       </div>
   </div>

<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name = "BNKSA" value="${data.BNKSA}">
	<input type="hidden" name="BEGDA" value="${ data.BEGDA }" >    <!-- 상단 입력 테이블 시작-->

<!--  HIDDEN  처리해야할 부분 끝-->

   </tags-approval:detail-layout>

</tags:layout>


