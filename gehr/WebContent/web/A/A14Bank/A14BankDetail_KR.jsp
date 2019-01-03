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
/*                  : 2016-09-21 통합구축(A14BankDetail_PL포함) - 김승철                      */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.common.constant.Area" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.A.A14Bank.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-util" tagdir="/WEB-INF/tags/util" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
   
    
    /* 급여계좌 레코드를 vector로 받는다*/
    Vector<A14BankStockFeeData>              a14BankStockFeeData_vt = (Vector)request.getAttribute("a14BankStockFeeData_vt");
    A14BankStockFeeData data                   =null;
    data  = Utils.indexOf(a14BankStockFeeData_vt,0, A14BankStockFeeData.class);
    Logger.debug.println(this, "a14BankStockFeeData_vt ::data : " + data);
    // 현재 결재자 구분
//     DocumentInfo docinfo = new DocumentInfo(ss ,user.empNo);
//     int approvalStep = docinfo.getApprovalStep();

//    data = new A14BankStockFeeData();
//    data.AINF_SEQN="0000011562";

    /* 결제정보를 vector로 받는다
    Vector    AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");*/
    String RequestPageName = (String)request.getAttribute("RequestPageName");

%>

<c:set var="user" value="<%=user %>"/>
<c:set var="data" value="<%=data %>"/>
<c:set var="area" value="<%=WebUtil.getSessionUser(request).area %>"/>

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_PY_BANK_DETAIL" updateUrl="${g.servlet}hris.A.A14Bank.A14BankChangeSV">

        <%-- 신청 내역 조회 부분 --%>

        <tags:script>
                            <script>

<!--
function do_change(){
  if( chk_APPR_STAT(0) ){
    document.form1.jobid.value = "first";
    document.form1.AINF_SEQN.value = "${ data.AINF_SEQN }";

    document.form1.action = "${ WebUtil.ServletURL}hris.A.A14Bank.A14BankChangeSV";
    document.form1.method = "post";
    document.form1.submit();
  }
}

function do_delete(){
    if( chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value = "delete";
        document.form1.AINF_SEQN.value = "${ data.AINF_SEQN }";

        document.form1.action = "${ WebUtil.ServletURL }hris.A.A14Bank.A14BankDetailSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function do_list(){
    document.form1.action = "{RequestPageName.replace('|','&')}";
    document.form1.submit();
}

function do_preview(){
  document.form1.action = "${ WebUtil.ServletURL}hris.A.A03AccountDetailSV";
  document.form1.method = "post";
  document.form1.submit();
}
//-->
</script>
</tags:script>

<%--
<c:if test="${approvalHeader.showManagerArea}">
    <!--   사원검색 보여주는 부분 시작   -->
    <jsp:include page="/web/common/PersonInfo.jsp" />
    <!--   사원검색 보여주는 부분  끝    -->

</c:if>
 --%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
            
            
            <c:if  test="${area == 'KR'}">
            
                <tr>
                    <th><spring:message code="MSG.A.A14.0005"/><!-- 은행코드--></th>
                    <td>
                        <input type="text" name="BANK_NAME" value="${ data.BANK_NAME }" size="20" class="noBorder" readonly>
                    </td>
                    <th class="th02"><spring:message code="MSG.A.A14.0006"/><!--계좌번호--></th>
                    <td>
                        <input type="text" name="BANKN" value="${ data.BANKN }" size="20" maxlength="18" class="noBorder" readonly>
                    </td>
                </tr>
                
                </c:if>
                
                
                <c:if test="${area == 'PL'}">
	                 
	                <tr> 
	                  <td ><spring:message code="MSG.A.A14.0005"/><!--Bank Code--></td>
	                  <td >
	                    <input type="text" name="ZBANKA" value="${ data.ZBANKA }" size="30" class="noBorder" readonly>
	                  </td>
	                  <td ><spring:message code="MSG.A.A14.0006"/><!--Account Number--></td>
	                  <td >
	                    <input type="text" name="ZBANKNZBKREF" value="${ data.ZBANKN+data.ZBKREF }" size="50" maxlength="20" class="noBorder"  readonly>
	                    <input type="hidden" name="ZBANKN" value="${ data.ZBANKN }">
	                    <input type="hidden" name="ZBKREF" value="${ data.ZBKREF }">
	                  </td>
	                </tr>
	                
                </c:if>
                
                
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->
 <%--
    <h2 class="subtitle">결재정보</h2>

    결재자 입력 테이블 시작-->
    ${ hris.common.util.AppUtil.getAppDetail(AppLineData_vt) --%>
    <%-- 결재자 입력 테이블 시작

    <div class="buttonArea">
        <ul class="btn_crud">

            <%  if ( RequestPageName != null && !RequestPageName.equals("")) { %>
            <li><a href="javascript:do_list();"><span>목록</span></a></li>
            <%  } else { %>
            <li><a href="javascript:do_preview();"><span>초기화면</span></a></li>
            <%  } // end if %>
            <%  if (docinfo.isModefy()) { %>
            <li><a class="darken" href="javascript:do_change();"><span>수정</span></a></li>
            <li><a href="javascript:do_delete();"><span>삭제</span></a></li>
            <%  } // end if %>
        </ul>
    </div>
        </table>
      </td>
    </tr>
    --%>
    
<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name = "BNKSA" value="${data.BNKSA}">
      <input type="hidden" name="BEGDA" value="${ data.BEGDA }" >    <!-- 상단 입력 테이블 시작-->

<!--  HIDDEN  처리해야할 부분 끝-->
  
   </tags-approval:detail-layout>

</tags:layout>


