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
<%@ page import="com.common.constant.Area" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.A14Bank.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%--@elvariable id="g" type="com.common.Global"--%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>

<%
    String      message = (String)request.getAttribute("message"); //C20111121_02206

    if( message == null ){
      message = "";
    }
    //if( message.equals("") ){
    //  message = "인증결과값을 CNS에 확인하세요";
    //}

    /* 현재 등록된 급여계좌를 가져간다. */
    A03AccountDetail1Data  adata = (A03AccountDetail1Data)request.getAttribute("A03AccountDetail1Data");
    if( adata == null ) {
	      adata = new A03AccountDetail1Data();
	      DataUtil.fixNull(adata);
    }
    
    /* 급여계좌 레코드를 vector로 받는다*/
    Vector              a14BankStockFeeData_vt = (Vector)request.getAttribute("a14BankStockFeeData_vt");
    A14BankStockFeeData b_data                   = (A14BankStockFeeData)Utils.indexOf(a14BankStockFeeData_vt,0);


    /* 급여계좌 리스트를 vector로 받는다*/
    Vector  a14BankCodeData_vt = (Vector)request.getAttribute("a14BankCodeData_vt");

    /* 결제정보를 vector로 받는다*/
    //Vector          AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
   
%>


<c:set var="adata" value="<%=b_data==null?adata:b_data %>"/>

<tags:layout css="ui_library_approval.css"  script="dialog.js" >

    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PY_BANK_DETAIL" representative="false">
        <!-- 상단 입력 테이블 시작-->

        <tags:script>
            <script>
        	   $(".btn_crud").html($(".btn_crud").html()+" <li><a href='javascript:history.back();''><span><spring:message code='BUTTON.COMMON.BACK'/><!--이전화면--></span></a></li> ");    
            
            /* 해당 업무에서 사용되는 script */

            <%-- 기본 validation 은 jquery validation 사용 --%>
            <%-- 신청 버튼 이전에 실행 될 로직 - 필요시 주석 해제 후 사용--%>
            <%-- return 값 진행 여부--%>
            function beforeSubmit() {
            	return check_data();
/*                if( check_data() ) {
                    //buttonDisabled();
                        document.form1.jobid.value = "create";
                        document.form1.action = "${g.servlet}hris.A.A14Bank.A14BankBuildSV";
                        document.form1.method = "post";
                        document.form1.submit();
                    }
*/                    
            }
            
			function bank_get(obj) {
			    var p_idx = obj.selectedIndex - 1;
			    if( p_idx >= 0 ) {
			        eval("document.form1.BANK_CODE.value = document.form1.BANK_CODE" + p_idx + ".value");
			        eval("document.form1.BANK_NAME.value = document.form1.BANK_NAME" + p_idx + ".value");
			        document.form1.BANK_CODE.value =="${adata.BANK_CODE }" ? document.form1.BANKN.value = "${ adata.BANKN }"  :document.form1.BANKN.value = "";
			    } else {
			        document.form1.BANK_CODE.value = "";
			        document.form1.BANK_NAME.value = "";
			        document.form1.BANKN.value     = "";
			    }
			}
			
			
			function check_data(){
					  if( checkNull(document.form1.bankcode, "<spring:message code="MSG.A.A14.0003"/>" ) == false ) { //은행코드를
					    return false;
					  }
					
					  if( checkNull(document.form1.BANKN, "<spring:message code="MSG.A.A14.0004"/>" ) == false ) { //계좌번호를
					    return false;
					  } else {
						    if( isNaN(document.form1.BANKN.value) ) {
						      alert("<spring:message code="MSG.COMMON.0043"/>");<!--숫자만 입력가능합니다.-->
						      document.form1.BANKN.focus();
						      return false;
						    }
					  }
				
//				  if ( check_empNo() ){
	//			    return false;
	//		  }
			
			  //document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value);
			  document.form1.BANK_FLAG.value = "01";      // 급여계좌
			
			  return true;
			}
			
			function do_preview(){
			  document.form1.action = "${g.servlet}hris.A.A03AccountDetailSV";
			  document.form1.method = "post";
			  document.form1.submit();
			}
			
			function reload() {
			    frm =  document.form1;
			    frm.action = "${g.servlet}hris.A.A03AccountDetailSV";
			    frm.target = "";
			    frm.submit();
			}
			
			//-->
		</script>
</tags:script>

			
		
		    <!-- 상단 입력 테이블 시작-->
		    <div class="tableArea">
		        <div class="table">
		            <table class="tableGeneral">
		               
		                <tr>
		                    <th><span class="textPink">*</span><spring:message code="MSG.A.A14.0005"/><!-- 은행코드--></th>
		                    <td>
		                        <select name="bankcode"  class="required"   onChange="javascript:bank_get(this);">
		                            <option value="">-------------</option>
		                            <%--${f:printCodeOption(a14BankCodeData_vt, resultData.LICN_GRAD)} --%>
		                            <%--@elvariable id="a14BankCodeData_vt" type="java.util.Vector<hris.A.A14Bank.A14BankCodeData>"--%>
		
		                            <c:forEach var="row"  items="${a14BankCodeData_vt}" varStatus="status">
		                            <option value="${row.BANK_CODE}" ${row.BANK_CODE==adata.BANK_CODE ? "selected" : "" }>
		                                ${ row.BANK_NAME }
		                             </option>
		                            </c:forEach>
		
		                        </select>
		                    </td>
		                    <th class="th02"><span class="textPink">*</span><spring:message code="MSG.A.A14.0006"/><!--계좌번호--></th>
		                    <td><input type="text" name="BANKN"  class="required"   size="20" maxlength="18" value="${ adata.BANKN }" ></td><!-- onfocus="javascript:BANKN.select()" -->
		                </tr>
		            </table>
		            <div class="commentsMoreThan2">
		                <div><spring:message code="MSG.A.A14.0007"/><!--통장사본 1부는 담당자에게 제출하시기 바랍니다.--></div>
		                <div>
		                  <spring:message code="MSG.COMMON.0061"/>
		                  <spring:message code="MSG.A.A14.0008"/><!--는 필수입력사항입니다(계좌번호 입력시 '-'은 입력하지 마시기 바랍니다).-->
	                    </div>
		            </div>
		
		        </div>
		    </div>
		   
		
		    <!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="BEGDA"       value="${f:currentDate()}">
		    <!-- input type="hidden" name="jobid"       value=""-->
		    <input type="hidden" name="BANK_FLAG"   value="">
		    <input type="hidden" name="BANK_CODE"   value="${ adata.BANK_CODE }">
		    <input type="hidden" name="BANK_NAME"   value="${ adata.BANK_NAME }">
		
		     <%--@elvariable id="a14BankCodeData_vt" type="java.util.Vector<hris.A.A14Bank.A14BankCodeData>"--%>
		     <c:forEach var="row" items="${ a14BankCodeData_vt}" varStatus="status">
		      <!--  은행계좌(코드, 명) 리스트를 저장한다. -->
		      <input type="hidden" name="BANK_CODE${ status.index }" value="${ row.BANK_CODE }">
		      <input type="hidden" name="BANK_NAME${ status.index }" value="${ row.BANK_NAME }">
		     </c:forEach>
		      <!--  HIDDEN  처리해야할 부분 끝-->


   </tags-approval:request-layout>

</tags:layout>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

