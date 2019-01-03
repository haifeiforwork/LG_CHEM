<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustSpecialDetail.jsp                               */
/*   Description  : 특별공제 입력 및 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                  2005-11-23  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
/* 					2018-01-15 cykim [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 */
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

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector special_vt = (Vector)request.getAttribute("special_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));
    String Gubn = "Tax02";

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

// 특별공제 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustSpecialSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}
//-->
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
                    <th rowspan="2"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></th>
                    <th rowspan="2"><spring:message code="LABEL.D.D11.0111" /><!-- 개인추가분 --></th>
                    <th class="lastCol" colspan="2"><spring:message code="LABEL.D.D11.0113" /><!-- 자동반영분 --></th>
                    <% if("@".equals(pdfYn)) {%><!-- @2015 연말정산 사용안함. -->
                    <th class="lastCol" rowspan="2"><spring:message code="LABEL.D.D11.0122" /><!-- 연말정산<br>삭제 --></th>
                    <%} %>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                    <th class="lastCol"><spring:message code="LABEL.D.D11.0115" /><!-- 내용 --></th>
                </tr>
               </thead>
<%
    for( int i = 0 ; i < special_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)special_vt.get(i);
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td  style="text-align:left">&nbsp;<%= data.GUBN_TEXT %></td>
            <td  style="text-align:right"><%= data.ADD_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ADD_BETRG)  %>&nbsp;</td>
            <td  style="text-align:right"><%= data.AUTO_BETRG.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.AUTO_BETRG) %>&nbsp;</td>
            <td  class="lastCol" style="text-align:left">&nbsp;<%= data.AUTO_TEXT %></td>
            <% if("@".equals(pdfYn)) {%><!-- @2015 연말정산 사용안함. -->
            <td >
             <input type="checkbox" class="input03" style="text-align:right" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> disabled>
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

    <!--[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건  4대보험 하단 문구 추가 요청 -->
    <span class="commentOne">소득월액(건강보험료) 및 지역 국민연금 보험료가 있는 경우에는  [4대보험] 탭에 해당 보험료 금액을 입력 해주셔야 합니다.</span>

<!-- @2015 연말정산 문구삭제
    <tr>
      <td class="td02" style="text-align:left"><font color=blue>*주의사항*</font></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=green>1. 장기주택저당차입금이자상환액 : 국민주택규모(85㎡)이하의 1주택 보유인 경우에만 가능(’06년 이후 대출인 경우에는 기준시가 3억원 이하여야 함)</font></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=green>2. 임차차입원리금상환액 : 무주택인 경우에만 가능</font></td>
    </tr>
    -->
    <tr>
      <td>&nbsp;</td>
    </tr>

<%
    if(   !o_flag.equals("X") ) {
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
    <input type="hidden" name="targetYear" value="<%=targetYear%>">
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
