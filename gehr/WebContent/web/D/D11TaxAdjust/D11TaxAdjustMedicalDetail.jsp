<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustMedicalDetail.jsp                               */
/*   Description  : 특별공제 의료비 입력 및 조회                                */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-01  윤정현                                          */
/*                  2005-11-23  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
/*                  2006-11-21  @v1.4 lsa 1.금액 -> 의료비총액/신용카드분/현금영수증분/현금으로 나누어 입력 */
/*                                        2.자동반영분 확인 플래그 추가         */
/*                  2008-11-20  CSR ID:1361257 2008년말정산반영                 */
/*                  2009-12-20  CSR ID:1361257 2009년말정산반영                 */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC            = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData  = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector medi_vt    = (Vector)request.getAttribute("medi_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax05";   //@v1.1

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

// 특별공제 교육비 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV";
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

     <div class="listArea">
        <div class="table">
            <table class="listTable"  id="table">
              <thead>
            <tr>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0171" /><!-- 의료비 내용 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0172" /><!-- 의료증빙유형 --></th><!--CSR ID:1361257-->
                <th rowspan="2"><spring:message code="LABEL.D.D11.0173" /><!-- 안경<br>콘택트 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0174" /><!-- 난임<br>시술비 --></th><!-- @2015연말정산 -->
                <th colspan="2"><spring:message code="LABEL.D.D11.0175" /><!-- 요양기관 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0176" /><!-- 건수 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0177" /><!-- 만65세<br>이상자 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0178" /><!-- 장애<br>자 --></th>
                <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
                <%--<th rowspan="2"><spring:message code="LABEL.D.D11.0121" /><!-- 회사<br>지원분 --></th> --%>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0076" /><!-- 국세청<br>자료 --></th>
                <% if("Y".equals(pdfYn)) {%>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                <%} %>
                <th class="lastCol" rowspan="2"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></th>
              </tr>
              <tr>
                <th><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></th>
                <th><spring:message code="LABEL.D.D11.0179" /><!-- 상호 --></th>
              </tr>
          </thead>
<%
    for( int i = 0 ; i < medi_vt.size() ; i++ ){
        D11TaxAdjustMedicalData data = (D11TaxAdjustMedicalData)medi_vt.get(i);
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td  nowrap><%= WebUtil.printOptionText((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
            <td  nowrap><%= data.F_ENAME %></td>
            <td  nowrap><%= data.F_REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.F_REGNO) %></td>
            <td  nowrap  style="text-align:left"><%= data.CONTENT %></td>
            <td  style="text-align:left" nowrap><%= data.METYP_NAME %></td><!--의료증빙유형  CSR ID:1361257-->
            <td >
             <input type="checkbox" name="GLASS_CHK<%= i %>" value="" class="input03" style="text-align:right" <%= data.GLASS_CHK.equals("X")  ? "checked" : "" %> disabled>
            </td><!--안경콘택트-->
            <td >
             <input type="checkbox" name="DIFPG_CHK<%= i %>" value="" class="input03" style="text-align:right" <%= data.DIFPG_CHK.equals("X")  ? "checked" : "" %> disabled>
            </td><!--@2015 연말정산-->
            <td  nowrap><%= data.BIZNO.equals("") ? "&nbsp;" : DataUtil.addSeparate2(data.BIZNO) %></td><!--사업자번호-->
            <td  nowrap  style="text-align:left"><%= data.BIZ_NAME %></td><!--상호-->
            <td  style="text-align:right"><%= Integer.parseInt(data.CA_CNT) %>&nbsp;</td><!--건수-->
            <td  style="text-align:right"><%= data.CA_BETRG.equals("")  ? "" : WebUtil.printNumFormat(data.CA_BETRG) %>&nbsp;</td><!--금액-->

            <td >
             <input type="checkbox" name="OLDD<%= i %>" value="" class="input03" style="text-align:right" <%= data.OLDD.equals("X")  ? "checked" : "" %> disabled>
            </td>
            <td >
             <input type="checkbox" name="OBST<%= i %>" value="" class="input03" style="text-align:right" <%= data.OBST.equals("X")  ? "checked" : "" %> disabled>
            </td>
	<!--  회사지원분삭제 2017.1.6 김지수k요청 -->
            <td  style="display:none">
             <input type="checkbox" name="GUBUN<%= i %>" value="" class="input03" style="text-align:right" <%= data.GUBUN.equals("1")  ? "checked" : "" %> disabled>
            </td>

            <td >
             <input type="checkbox" name="CHNTS<%= i %>" value="" class="input03" style="text-align:right" <%= data.CHNTS.equals("X")  ? "checked" : "" %> disabled>
            </td>
<%
   if (pdfYn.equals("Y")){
%>
            <td >
             <input type="checkbox" name="PDF<%= i %>" value="" class="input03" style="text-align:right" <%= data.GUBUN.equals("9")  ? "checked" : "" %> disabled>
            </td>
<%
   }
%>
            <td class="lastCol">
             <input type="checkbox" name="OMIT_FLAG<%= i %>" value="" class="input03" style="text-align:right" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> disabled>
            </td>
          </tr>
<%
    }
%>
                   </table>
        </div>
    </div>
<%
    if( !o_flag.equals("X") ) {
%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_change();"><span><spring:message code="BUTTON.COMMON.UPDATE" /><!-- 수정 --></span></a></li>
        </ul>
    </div>

<%
    }
%>
    <div class="commentImportant" style="width:740px;">
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <p><spring:message code="LABEL.D.D11.0180" /><!-- 1. 연말정산 간소화 서비스를 통한 증빙 제출시에는 요양기관(사업자번호 및 상호) 입력없이 건수와 금액만 입력 --></p>
        <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
        <%--<p><spring:message code="LABEL.D.D11.0181" /><!-- 2. 회사에서 지원 받은 의료비 내역이 보여지며, 연말정산 공제 적용하기 위해서는 "연말정산삭제"열 체크 된 부분을 해지해야 함 --></p> --%>
        <p><spring:message code="LABEL.D.D11.0182" /><!-- 2. 시력보정용 안경 또는 콘택트렌즈 구입시 발생한 비용은 “안경콘택트”에 반드시 체크해야 함 --></p>
        <p><spring:message code="LABEL.D.D11.0183" /><!-- 3. 난임시술비 의료비의 경우 난임시술비용만 별도로 입력후 "난임시술비"에 반드시 체크해야 함 --></p>
        <p class="small">  - <spring:message code="LABEL.D.D11.0184" /><!--  국세청 PDF로 올릴 경우 난임시술비로 자동으로 체크가 안되므로 난임시술비용이 있는 경우에는 PDF로 입력하지 마시고 직접 입력하여 주시기 바랍니다. --></p>
   </div>

<!-- 숨겨진 필드 -->
    <input type="hidden" name="jobid"      value="">
    <input type="hidden" name="targetYear" value="<%=targetYear%>">
<!-- 숨겨진 필드 -->
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->