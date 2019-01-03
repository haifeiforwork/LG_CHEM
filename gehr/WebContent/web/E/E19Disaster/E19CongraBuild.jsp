<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해신청                                                    */
/*   Program ID   : E19CongraBuild.jsp                                          */
/*   Description  : 재해를 신청할 수 있도록 하는 화면                           */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*                  2006-03-17  @v1.1 lsa 급여작업으로 막음                     */
/*                              @v1.1 lsa 5월급여작업으로 막음  전문기술직만    */
/*                  2006-06-16 @v1.1 kdy 임금인상관련 급여화면 제어              */
/*  CSR ID : 2511881 재해신청 시스템 수정요청 20140327 이지은D  1) 재해신청일자 < 신청일 validation
 *                                                                                    2) 신청일이 시작일이 아니고, 재해신청일자가 BEGDA
 *                                                                                    3) 재해신청일자 입력 화면 변경(재해피해신고서로 옮김)  */
 /*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
 /*                  2015-04-16  이지은D [CSR ID:2753943] 고문실 복리후생 신청 권한 제한 요청 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.E.E19Disaster.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>

<%
    WebUserData      user            = (WebUserData)session.getAttribute("user");

    /* 재해피해신고서 입력된 vector를 받는다*/
    Vector E19DisasterData_vt = (Vector)request.getAttribute("E19DisasterData_vt");

    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    Vector      AccountData_pers_vt = (Vector)request.getAttribute("AccountData_pers_vt");
    AccountData AccountData_hidden  = (AccountData)request.getAttribute("AccountData_hidden");

    String PERNR = (String)request.getAttribute("PERNR");

    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");

    //CSR ID : 2511881 추가
    Vector E19DisasterData_rate = (Vector)request.getAttribute("E19DisasterData_rate");
    Vector E19DisasterData_rat2 = (Vector)request.getAttribute("E19DisasterData_rat2");
    String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( PERNR);
    int rowCount_report =E19DisasterData_vt.size();
    String  rowCount_account = AccountData_pers_vt.size()+"";

%>
<c:set var="E19DisasterData_vt" value="<%=E19DisasterData_vt %>"/>
<c:set var="O_CHECK_FLAG" value="<%=O_CHECK_FLAG %>"/>
<c:set var="AccountData_pers_vt" value="<%=AccountData_pers_vt %>"/>
<c:set var="rowCount_report" value="<%=rowCount_report %>"/>
<c:set var="rowCount_account" value="<%=rowCount_account %>"/>
<c:set var="user" value="<%=user %>"/>
<c:set var="title" value="<%=g.getMessage("COMMON.MENU.ESS_BE_ADDI_FEE")%>"/>

<tags:layout css="ui_library_approval.css">
    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_BE_ADDI_FEE"  title="${title}"  requestURL ="${g.servlet}hris.E.E19Disaster.${isUpdate ? 'E19CongraChangeSV' : 'E19CongraBuildSV'}" disable="${O_CHECK_FLAG eq 'N'}" disableApprovalLine="${O_CHECK_FLAG eq 'N' }">

        <!-- 상단 입력 테이블 시작-->
        <%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>

                <tags:script>
                    <script>

function moneyChkEventForWon(obj){
    val = obj.value;
    if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
        addComma(obj);
    }
    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}
var report = null;



function beforeSubmit() {
    if (check_data()) return true;
}


function check_data(){



//은행 관련자료도 필수 항목이다
    if( document.form1.BANK_NAME.value == "" || document.form1.BANKN.value == "" ) {
        //alert("입금될 계좌정보가 명확하지 않습니다.\n\n  인사담당자에게 문의해 주세요");
        alert("<spring:message code="MSG.E.E19.0006"/>");
        return false;
    }
//은행 관련자료도 필수 항목이다

    vt_size ="${rowCount_report}";
    if( vt_size == 0 ) {
        //if( confirm("재해 경조시에는 재해피해신고서 등록을 하셔야 합니다.\n\n 재해신고서를 작성하시겠습니까?") ){
        	if( confirm("<spring:message code="MSG.E.E19.0007"/>") ){
            open_report_build();
            return false;
        }else {
            return false;
        }
    }


    x_CONG_WONX = removeComma(document.form1.CONG_WONX.value);
    if( isNaN(x_CONG_WONX) ){
        //alert(" 입력값이 적합하지 않습니다. ");
        alert("<spring:message code="MSG.E.E19.0008"/>");
        document.form1.CONG_WONX.focus();
        return false;
    } else if( x_CONG_WONX == "0" ){
        //alert(" 입력값이 적합하지 않습니다. ");
         alert("<spring:message code="MSG.E.E19.0008"/>");
        document.form1.CONG_WONX.focus();
        return false;
    }

    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);

    betw = getAfterMonth(addSlash(congra_date), 3);
    dif = dayDiff(addSlash(begin_date), addSlash(betw));

    //betw2 = getAfterMonth(addSlash(begin_date), 1);
    dif2 = dayDiff(addSlash(congra_date), addSlash(begin_date));

    //경조사 발생 3개월초과시 에러처리
    if(dif < 0){
        //str = '        재해를 신청할수 없습니다.\n\n 재해발생일로부터 3개월 이전까지 신청할수 있습니다. ';
        str = '       "<spring:message code="MSG.E.E19.0004"/>"';
        alert(str);
        return false;
    }

    //재해 발생 전에 신청할 수 없음
    if(dif2 < 0) {
        //str = '        재해를 신청할수 없습니다.\n\n 재해발생 전에는 미리 신청할수 없습니다. ';
        str = '        "<spring:message code="MSG.E.E19.0005"/>" ';
//str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
        alert(str);
        return false;
    }

    // 재해발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다.
    event_CONG_DATE(document.form1.CONG_DATE);
    // 재해발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다.

    document.form1.BEGDA.value = begin_date;
    document.form1.CONG_DATE.value = congra_date;

    document.form1.CONG_WONX.value = x_CONG_WONX;
    document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value);

    return true;
}

//재해피해신고서입력 버튼 클릭시 호출 MM_openBrWindow('E19ReportBuild.htm','','width=550,height=500')"
function open_report_build(){
    document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value);
    document.form1.CONG_WONX.value = removeComma(document.form1.CONG_WONX.value);
    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);
    document.form1.BEGDA.value = begin_date;
    document.form1.CONG_DATE.value = congra_date;
    document.form1.jobid.value = "";
    document.form1.action = "${g.servlet}hris.E.E19Disaster.E19ReportControlSV";
    document.form1.method = "post";

    document.form1.submit();
}

//onClick="MM_openBrWindow('E19ReportBuild.htm','','width=550,height=500')"
function MM_openBrWindow(theURL,winName,features) {//v2.0
  window.open(theURL,winName,features);
}



//LG화학, LG석유화학 구분없이 1000 미만 단수절상
function money_olim(val_int){
    var money = 0;
    var compCode = 0;
    var rate = 0;
        money = olim(val_int, -3);

    return money;
}
function after_event_CONG_DATE(){
    event_CONG_DATE(document.form1.CONG_DATE);
}

function event_CONG_DATE(obj){
     if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() ){
        document.form3.CONG_DATE.value = removePoint(document.form1.CONG_DATE.value);
        document.form3.action="${g.jsp}E/E19Disaster/E19Hidden4WorkYear.jsp";
        document.form3.target="ifHidden";
        document.form3.submit();
     }

}

function event_CONG_DATE_ReadOnly(){
    //alert("재해발생일자는 재해피해 신고서에서 입력해주시기 바랍니다.");
    alert("<spring:message code="MSG.E.E19.0009"/>");
    return;
}

function chkInvalidDate(){

    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);

    betw = getAfterMonth(addSlash(congra_date), 3);
    dif = dayDiff(addSlash(begin_date), addSlash(betw));

    //betw2 = getAfterMonth(addSlash(begin_date), 1);
    dif2 = dayDiff(addSlash(congra_date), addSlash(begin_date));

    //경조사 발생 3개월초과시 에러처리
    if(dif < 0){
       // str = '        재해를 신청할수 없습니다.\n\n 재해발생일로부터 3개월 이전까지 신청할수 있습니다. ';
       str = '       <spring:message code="MSG.E.E19.0004"/>';
        alert(str);
        return false;
    }

    //재해 발생 전에 신청할 수 없음
    if(dif2 < 0) {
       // str = '        재해를 신청할수 없습니다.\n\n 재해발생 전에는 미리 신청할수 없습니다. ';
        str = '        <spring:message code="MSG.E.E19.0005"/> ';
//str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
        alert(str);
        return false;
    }
    return true;
}
$(function() {
	 if( "${user.e_persk}"== "14" ){$(".-request-button").hide();}
});
		</script>
   </tags:script>

   <c:choose>
   <c:when  test="${ O_CHECK_FLAG  eq  'N'}" >
       <div class="align_center">
        <p><spring:message code='LABEL.E.E19.0019' /><!-- ※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다. --></p><!--@v1.1-->
        <!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="CONG_CODE"       value="0005">
      <input type="hidden" name="RELA_CODE"       value="">
      <input type="hidden" name="EREL_NAME"       value="">
      <input type="hidden" name="CONG_RATE"       value="0">
      <input type="hidden" name="HOLI_CONT"       value="0">
      <input type="hidden" name="fromJsp"         value="E19CongraBuild.jsp">
      <input type="hidden" name="RowCount_report" value="${rowCount_report}">
      <input type="hidden" name="checkSubmit"     value="">
      <input type="hidden" name="isUpdate"     value="${isUpdate}">

    </div>
   </c:when>
   <c:otherwise>
        <div class="tableArea">
            <div class="table">
    <!-- 상단 입력 테이블 시작-->
            <table class="tableGeneral tableApproval">
            	<colgroup>
            		<col width="15%" />
            		<col  />
            	</colgroup>
              <tr>
                <th><!-- 경조내역--><spring:message code="LABEL.E.E20.0002"/></th>
                <td>
                <input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" size="20" >
                <input type="text" name="disa_name" value="재해" size="20" readonly>
                    <a href="javascript:open_report_build();" class="inlineBtn"><span><!-- 재해피해신고서 --><spring:message code="LABEL.E.E19.0001"/></span></a>
                    <span class="commentOne">
                    <c:choose>
                    <c:when  test="${ rowCount_report >0}" >
                    	${rowCount_report }<!-- 건 --><spring:message code="LABEL.E.E19.0007"/>
                    </c:when>
   					<c:otherwise>
                    	<!--※ 재해피해 신고서를 반드시 입력해 주세요 --><spring:message code="LABEL.E.E19.0008"/>
                    </c:otherwise>
                    </c:choose>
                    </span>
                </td>
              </tr>
              <tr>
                <th><span class="textPink">*</span><spring:message code="LABEL.E.E19.0003"/></th>
                <td>
                  <input type="text" name="CONG_DATE"  class="required"   placeholder="<spring:message code="LABEL.E.E19.0003"/>" value="${f:printDate(resultData.CONG_DATE)}" size="20" onClick="event_CONG_DATE_ReadOnly();" onBlur="event_CONG_DATE(this);" readonly>
                </td>
              </tr>
            </table>
        </div>
    </div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
            	<colgroup>
            		<col width="15%" />
            		<col width="35%" />
            		<col width="15%" />
            		<col width="35%" />
            	</colgroup>
<%--
                      <tr>
                        <td width="100" class="td01">통상임금</td>
                        <td class="td09" colspan="3">
                          <input type="text" name="WAGE_WONX" value="<%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%>" style="text-align:right" size="20" class="input04" readonly> 원
                        </td>
                      </tr>
                      <tr>
                        <td class="td01">지급율</td>
                         <td class="td09" colspan="3">
                           <input type="hidden" name="xCONG_RATE" value="${resultData.CONG_RATE.equals("") ? "" : WebUtil.printNumFormat(e19CongcondData.CONG_RATE, 1) %>" >
                           <input type="text" name="CONG_RATE" value="${resultData.CONG_RATE.equals("") ? "" : WebUtil.printNumFormat(e19CongcondData.CONG_RATE, 1)  %>" class="input04" size="20" style="text-align:right" readonly> %
                        </td>
                      </tr>
--%>


                <tr>
                    <th><!-- 경조금액 --><spring:message code="LABEL.E.E20.0006"/></th>
                    <td colspan="3">
                                    <input type="hidden" name="WAGE_WONX"  value="${resultData.WAGE_WONX}">
                <input type="hidden" name="xCONG_RATE" value="${empty resultData.CONG_RATE ? '' : f:printNumFormat(resultData.CONG_RATE, 1) }">
                <input type="hidden" name="CONG_RATE"  value="${empty resultData.CONG_RATE ? '' : f:printNumFormat(resultData.CONG_RATE, 1)  }">
                      <input type="hidden" name="xCONG_WONX" value="${empty resultData.CONG_WONX? '' : f:printNumFormat(resultData.CONG_WONX,0)  }">
                      <input type="text" name="CONG_WONX" value="${empty resultData.CONG_WONX? '' : f:printNumFormat(resultData.CONG_WONX,0)  }" size="30" style="text-align:right" readonly> <!-- 원 --><spring:message code="LABEL.E.E19.0009"/>
                    </td>
                </tr>
                <tr>
                    <th><!-- 이체은행명 --><spring:message code="LABEL.E.E20.0012"/></th>
                    <td><input type="text" name="BANK_NAME" value="${resultData.BANK_NAME}" size="30" readonly></td>
                    <th class="th02"><!--은행계좌번호 --><spring:message code="LABEL.E.E20.0013"/></th>
                    <td><input type="text" name="BANKN" value="${resultData.BANKN }" size="30" readonly></td>
                </tr>
                <tr>
                    <th><!-- 근속년수 --><spring:message code="LABEL.E.E20.0015"/></th>
                    <td colspan="3">
                      <input type="text" name="WORK_YEAR" value="${empty resultData.WORK_YEAR || resultData.WORK_YEAR eq '00'  ? '' : f:printNum(resultData.WORK_YEAR)}" size="11" style="text-align:right" readonly> <!-- 년 --><spring:message code="LABEL.E.E20.0017"/>
                      <input type="text" name="WORK_MNTH" value="${empty resultData.WORK_MNTH || resultData.WORK_MNTH eq '00'  ? '' : f:printNum(resultData.WORK_MNTH)}"  size="12" style="text-align:right" readonly> <!-- 개월 --><spring:message code="LABEL.E.E20.0018"/>
                    </td>
                </tr>
            </table>
        </div>
        <span class="commentOne"><span class="textPink">*</span><!-- 는 필수 입력사항입니다. --><spring:message code="LABEL.E.E05.0017"/></span>
        </div>
<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="CONG_CODE"       value="0005">
      <input type="hidden" name="RELA_CODE"       value="">
      <input type="hidden" name="EREL_NAME"       value="">
      <input type="hidden" name="CONG_RATE"       value="0">
      <input type="hidden" name="HOLI_CONT"       value="0">
      <input type="hidden" name="fromJsp"         value="E19CongraBuild.jsp">
      <input type="hidden" name="fromJsp2"         value="E19CongraBuild.jsp">
      <input type="hidden" name="checkSubmit"     value="">
      <input type="hidden" name="RowCount_report" value="${rowCount_report}">
      <input type="hidden" name="isUpdate"     value="${isUpdate}">

   <c:forEach var="row" items="${E19DisasterData_vt}" varStatus="status">
      <input type="hidden" name="DISA_RESN${status.index}" value="${row.DISA_RESN}">
      <input type="hidden" name="DISA_CODE${status.index}" value="${row.DISA_CODE}">
      <input type="hidden" name="DREL_CODE${status.index}" value="${row.DREL_CODE}">
      <input type="hidden" name="DISA_RATE${status.index}" value="${row.DISA_RATE}">
      <input type="hidden" name="CONG_DATE${status.index}" value="${f:deleteStr(row.CONG_DATE,'-')}">
      <input type="hidden" name="DISA_DESC1${status.index}" value="${row.DISA_DESC1}">
      <input type="hidden" name="DISA_DESC2${status.index}" value="${row.DISA_DESC2}">
      <input type="hidden" name="DISA_DESC3${status.index}" value="${row.DISA_DESC3}">
      <input type="hidden" name="DISA_DESC4${status.index}" value="${row.DISA_DESC4 }">
      <input type="hidden" name="DISA_DESC5${status.index}" value="${row.DISA_DESC5}">
      <input type="hidden" name="EREL_NAME${status.index}" value="${row.EREL_NAME}">
      <input type="hidden" name="INDX_NUMB${status.index}" value="${row.INDX_NUMB}">
      <input type="hidden" name="PERNR${status.index}" value="${row.PERNR}">
      <input type="hidden" name="REGNO${status.index}" value="${row.REGNO}">
      <input type="hidden" name="STRAS${status.index}" value="${row.STRAS }">
      <input type="hidden" name="AINF_SEQN${status.index}" value="${row.AINF_SEQN}">
</c:forEach>

      <input type="hidden" name="AccountData_pers_RowCount" value="${rowCount_Account}">

   <c:forEach var="row" items="${AccountData_pers_vt}" varStatus="status">

      <input type="hidden" name="p_LIFNR${status.index}" value="${row.LIFNR}">
      <input type="hidden" name="p_BANKN${status.index}" value="${row.BANKN}">
      <input type="hidden" name="p_BANKA${status.index}" value="${row.BANKA}">
      <input type="hidden" name="p_BANKL${status.index}" value="${row.BANKL}">
</c:forEach>
<!--  HIDDEN  처리해야할 부분 끝-->
   </c:otherwise>
  </c:choose>
   </tags-approval:request-layout>
</tags:layout>


  <form name="form3" method="post">
    <input type="hidden" name = "CONG_DATE" value="">
    <input type="hidden" name = "PERNR" value="${resultData.PERNR}">
  </form>
  <iframe name="ifHidden" width="0" height="0" />