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
    Vector pension_vt     = (Vector)request.getAttribute("pension_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax11";    //@v1.1
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

// 연금/저축공제 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPensionSV";
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
    <div class="listArea">
        <div class="table">
            <table class="listTable"  id="table">
              <thead>
                <tr>
                  <th><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></th>
                  <th><spring:message code="LABEL.D.D11.0199" /><!-- 유형 --></th>
                  <th><spring:message code="LABEL.D.D11.0200" /><!-- 금융기관 --></th>
                  <th><spring:message code="LABEL.D.D11.0201" /><!-- 가입일 --></th><!-- @2015 연말정산 -->
                  <th><spring:message code="LABEL.D.D11.0202" /><!-- 증권보험 -->/<spring:message code="LABEL.D.D11.0203" /><!-- 계좌번호 --></th>
                  <th><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                  <th><spring:message code="LABEL.D.D11.0204" /><!-- 종(전)근무지 --></th>
                  <% if("Y".equals(pdfYn)) {%>
                  <th><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                  <th class="lastCol"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></th>
                   <%} %>
                </tr>
              </thead>
<%
    for( int i = 0 ; i < pension_vt.size() ; i++ ){
        D11TaxAdjustPensionData data = (D11TaxAdjustPensionData)pension_vt.get(i);
%>
        <tr class="<%=WebUtil.printOddRow(i) %>">
          <td style="text-align:left"><%= WebUtil.printOptionText((new D11TaxAdjustPensionCodeRFC()).getPension(targetYear,"1",""), data.SUBTY) %>
          </td>
          <td style="text-align:left">
<%
        Vector D11TaxAdjustPensionCodeData_vt  =     (new D11TaxAdjustPensionCodeRFC()).getPensionGubn(targetYear,"2",data.SUBTY);
        for( int j = 0 ; j < D11TaxAdjustPensionCodeData_vt.size() ; j++ ) {
            D11TaxAdjustPensionCodeData data1 = (D11TaxAdjustPensionCodeData)D11TaxAdjustPensionCodeData_vt.get(j);
            if (data.PNSTY.equals(data1.GOJE_CODE)) {
%>
            <%= data1.GOJE_TEXT%>
<%          }
        }
%>
          </td>
          <td style="text-align:left">
          <%= WebUtil.printOptionText((new D11TaxAdjustFincoCodeRFC()).getPension(""), data.FINCO) %>
          </td>
          <td><%=data.RCBEG.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCBEG, ".")  %>
          </td>
          <td><%=data.ACCNO%>
          </td>
          <td style="text-align:right"><%= data.NAM01.equals("")  ? "" : WebUtil.printNumFormat(data.NAM01) %>&nbsp;</td>
          <td>
            <input type="checkbox" name="PREIN_<%=i%>" value="<%=data.PREIN%>"<%= data.PREIN.equals("X")  ? "checked" : "" %> disabled>
          </td>
          <% if("Y".equals(pdfYn)) {%>
            <td>
             <input type="checkbox" name="PDF_FLAG<%=i%>" class="input03" <%= data.PDF_FLAG.equals("X")  ? "checked" : "" %> disabled>
            </td>
            <td class="lastCol">
             <input type="checkbox" name="OMIT_FLAG<%=i%>" class="input03" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> disabled>
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
     <div class="commentImportant" >
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <p><spring:message code="LABEL.D.D11.0205" /><!-- 1. 청약저축/주택청약종합저축을 입력하고자 하는 경우 구분을 "청약저축"으로 선택 후 유형에서 해당저축을 선택하여 주시기 바랍니다. --></p>
        <p><spring:message code="LABEL.D.D11.0206" /><!-- 2. 개인연금저축/연금저축을 입력하고자 하는 경우 구분을 "연금저축"으로 선택 후 유형에서 해당저축을 선택하여 주시기 바랍니다. --></p>
    </div>
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

<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<input type="hidden" name="rowCount"   value="<%= pension_vt.size() %>">

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