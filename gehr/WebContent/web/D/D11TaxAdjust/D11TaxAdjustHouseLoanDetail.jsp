<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustPensionBuild.jsp                                */
/*   Description  : 연금/저축공제 입력 및 조회                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-12-08                                                  */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector houseLoan_vt     = (Vector)request.getAttribute("houseLoan_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax13";    //@v1.1
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

// 연금/저축공제 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustHouseLoanSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}


</SCRIPT>


 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>

 <form name="form1" method="post">
    <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

    <!--특별공제 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable" id="table">
              <thead>
                <tr>
                  <th><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></th>
                  <th><spring:message code="LABEL.D.D11.0163" /><!-- 최초차입일 --></th>
                  <th><spring:message code="LABEL.D.D11.0164" /><!-- 최종상환예정일 --></th>
                  <th><spring:message code="LABEL.D.D11.0283" /><!-- 대출기한(년) --></th><!-- @2016연말정산 -->
                  <th><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                  <th><spring:message code="LABEL.D.D11.0165" /><!-- 고정금리 --></th>
                  <th><spring:message code="LABEL.D.D11.0166" /><!-- 비거치 --></th>
                  <% if("Y".equals(pdfYn)) {%>
                  <th><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                  <th class="lastCol"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></th>
                  <%} %>
                </tr>
               </thead>

<%
    for( int i = 0 ; i < houseLoan_vt.size() ; i++ ){
    	D11TaxAdjustHouseLoanData data = (D11TaxAdjustHouseLoanData)houseLoan_vt.get(i);
%>
        <tr class="<%=WebUtil.printOddRow(i) %>">
          <td ><%= WebUtil.printOptionText((new D11TaxAdjustPensionCodeRFC()).getHouseLoanType(targetYear,"3",""), data.SUBTY) %>
          </td>
		  <td ><%=data.RCBEG.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCBEG, ".") %>
          </td>
          <td ><%=data.RCEND.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCEND, ".") %>
          </td>
          <!-- @2016연말정산 -->
          <td ><%= data.LNPRD.equals("000")  ? "" : WebUtil.printNumFormat(data.LNPRD) %>&nbsp;
          </td>
          <td style="text-align:right"><%= data.NAM01.equals("")  ? "" : WebUtil.printNumFormat(data.NAM01) %>&nbsp;
          </td>
          <td >
            <input type="checkbox" name="FIXRT_<%=i%>" value="<%=data.FIXRT%>" <%= data.FIXRT.equals("X")  ? "checked" : "" %> disabled>
          </td>
          <td >
            <input type="checkbox" name="NODEF_<%=i%>" value="<%=data.NODEF%>" <%= data.NODEF.equals("X")  ? "checked" : "" %> disabled>
          </td>
<!--           <td >< %= data.LSREG.equals("")  ? "" : WebUtil.printNumFormat(data.LSREG) %>
          </td>
          <td >< %= data.INRAT.equals("")  ? "" : WebUtil.printNumFormat(data.INRAT) %>
          </td>
          <td >< %= data.INTRS.equals("")  ? "" : WebUtil.printNumFormat(data.INTRS) %>
          </td> -->
          <% if("Y".equals(pdfYn)) {%>
            <td >
            <input type="checkbox" name="PDF_FLAG<%=i%>"  <%= data.GUBUN.equals("9")  ? "checked" : "" %> disabled>
            </td>
            <td class="lastCol">
             <input type="checkbox" name="OMIT_FLAG<%=i%>"  <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> disabled>
            </td>
	        <%} %>
         </tr>
<%
    }
%>
            </table>
        </div>
    </div>
    <!--특별공제 테이블 끝-->

<%
    if(  !o_flag.equals("X") ) {
%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_change();"><span><spring:message code="BUTTON.COMMON.UPDATE" /><!-- 수정 --></span></a></li>
        </ul>
    </div>
<%
    }
%>
    <div class="commentImportant" style="width:700px;">
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <p><spring:message code="LABEL.D.D11.0167" /><!-- 1. 연말정산 최초 신청시 증빙서류 제출 --></p>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0168" /><!-- - 임차차입금 원리금상환액 : 주민등록등본 --></p>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0169" /><!-- - 장기주택저당차입금 이자상환액 : 주민등록등본, 건물등기부등본, 개별(공동)주택가격확인서 또는 분양계약서사본 --></p>
        <p><spring:message code="LABEL.D.D11.0170" /><!-- 2. 회사에서 대출 받은 주택구입 자금의 원리금 상환액은 상기 공제 대상에 포함되지 않음 --></p>
    </div>
<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<input type="hidden" name="rowCount"   value="<%= houseLoan_vt.size() %>">

<!-- 숨겨진 필드 -->
</form>

  <form name="code" method="post">
      <input type="hidden" name="targetYear" value="<%= targetYear %>">
      <input type="hidden" name = "SUBTY" value="">
      <input type="hidden" name = "i"   value="">
  </form>
<iframe name="ifHidden" width="0" height="0" />
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->