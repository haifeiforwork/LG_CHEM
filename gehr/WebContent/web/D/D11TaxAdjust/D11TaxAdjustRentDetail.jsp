<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustRentDetail.jsp                                   */
/*   Description  : 월세공제 입력 및 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-12-03 lsa                                              */
/*   Update       : 2013-11-25  CSR ID:2013_9999 2013년말정산반영               */
/*                  임대인성명, 임대인주민등록번호, 입대차계약서 상 주소지  추가 */
/*                  2014-12-03 @2014 연말정산 주택유형 주택계약면적추가   */
/*   				 2018/01/07 rdcamel [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건*/
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
    Vector rent_vt     = (Vector)request.getAttribute("rent_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax12";
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

// 연금/저축공제 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustRentSV";
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
            <table  id = "table1" class="listTable">
                <colgroup>
                    <col width="5%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="25%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="10%" />
                </colgroup>
                <thead>
                    <tr>
                      <th><spring:message code="LABEL.D.D11.0199" /><!-- 유형 --></th><!--CSR ID:2013_9999 2013-->
                      <th><spring:message code="LABEL.D.D11.0252" /><!-- 임대인성명 --></th><!--CSR ID:2013_9999 2013-->
                      <th>임대인 주민등록번호<!-- 등록번호 --></th><!--CSR ID:2013_9999 2013--><!-- LABEL.D.D11.0291 로 변경 필요-->
                      <th><spring:message code="LABEL.D.D11.0254" /><!-- 임대계약서 상 주소지 --></th><!--CSR ID:2013_9999 2013-->
                      <th><spring:message code="LABEL.D.D11.0255" /><!-- 주택유형 --></th><!--@2014 연말정산 주택유형 주택계약면적추가 -->
                      <th><spring:message code="LABEL.D.D11.0256" /><!-- 주택계약면적(m²) --></th><!--@2014 연말정산 주택유형 주택계약면적추가 -->
                      <th><spring:message code="LABEL.D.D11.0257" /><!-- 계약시작일 --></th>
                      <th><spring:message code="LABEL.D.D11.0258" /><!-- 계약종료일 --></th>
                      <th class="lastCol"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                    </tr>
                </thead>
<%
    for( int i = 0 ; i < rent_vt.size() ; i++ ){
        D11TaxAdjustRentData data = (D11TaxAdjustRentData)rent_vt.get(i);
%>
        <tr class="<%=WebUtil.printOddRow(i) %>">
	  <!--CSR ID:2013_9999 2013-->

          <td ><%= data.PNSTX %></td>
          <td ><%= data.LDNAM %></td> <!--CSR ID:2013_9999 2013 임대인성명-->
          <td ><%= data.LDREG.equals("") ? "&nbsp;" : DataUtil.addSeparate2(data.LDREG) %></td> <!--CSR ID:2013_9999 2013 등록번호-->
          <td  style="text-align:left">&nbsp;&nbsp;&nbsp;<%= data.ADDRE %></td> <!--CSR ID:2013_9999 2013 주소지-->
          <td  style="text-align:left">&nbsp;&nbsp;&nbsp;<%= data.HOSTX %></td>  <!-- @2014 연말정산 주택유형 주택계약면적 추가 -->
          <td  style="text-align:right"><%= data.FLRAR.equals("") || data.FLRAR.equals("0") || data.FLRAR.equals("0.00") ? "&nbsp;" :  data.FLRAR %>&nbsp;&nbsp;&nbsp;</td>  <!-- @2014 연말정산 주택유형 주택계약면적 추가 -->
          <td ><%= data.RCBEG.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCBEG) %></td>
          <td ><%= data.RCEND.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCEND) %>
          </td>
          <td  style="text-align:right"  class="lastCol"><%= data.NAM01.equals("")  ? "" : WebUtil.printNumFormat(data.NAM01) %>&nbsp;&nbsp;&nbsp;</td>

         </tr>
<%
    }
%>
                </tbody>
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

<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<input type="hidden" name="rowCount"   value="<%= rent_vt.size() %>">

<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->