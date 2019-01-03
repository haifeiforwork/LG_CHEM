<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustEduDetail.jsp                                   */
/*   Description  : 특별공제 교육비 입력 및 조회                                */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-01  윤정현                                          */
/*                  2005-11-24  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
/*                  2006-11-23  @v1.4 lsa 국세청자료 추가                       */
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
    Vector edu_vt     = (Vector)request.getAttribute("edu_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));
//out.println("dd:"+edu_vt.toString());
    String Gubn = "Tax03";   //@v1.1

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
// 특별공제 교육비 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEduSV";
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
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
    <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

    <tr>
      <td>
        <!--특별공제 테이블 시작-->
        <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02" bordercolor="#999999">
          <tr>
            <td class="td03" rowspan="2" width="90"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" rowspan="2" width="70"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" rowspan="2" width="100"><spring:message code="LABEL.D.D11.0018" /><!-- 학력 --></td>
            <td class="td03" rowspan="2" width="90"><spring:message code="LABEL.D.D11.0111" /><!-- 개인추가분 --></td>
            <td class="td03" rowspan="2" width="90"><spring:message code="LABEL.D.D11.0112" /><!-- 재활비 --></td>
            <td class="td03" colspan="2"><spring:message code="LABEL.D.D11.0113" /><!-- 자동반영분 --></td>
            <td class="td03" rowspan="2" width="45"><spring:message code="LABEL.D.D11.0119" /><!-- 교복<BR>구입비 --></td>
            <td class="td03" rowspan="2" width="50"><spring:message code="LABEL.D.D11.0076" /><!-- 국세청<BR>자료 --></td>
            <td class="td03" rowspan="2" nowrap width="30"><spring:message code="LABEL.D.D11.0122" /><!-- 연말정산<br>삭제 --></td>
          </tr>
          <tr>
            <td class="td03" width="90"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></td>
            <td class="td03" width="200"><spring:message code="LABEL.D.D11.0115" /><!-- 내용 --></td>
          </tr>
<%
    for( int i = 0 ; i < edu_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)edu_vt.get(i);
%>
          <tr>
            <td class="td04"><%= data.STEXT %></td>
            <td class="td04"><%= data.ENAME %></td>
            <td class="td04"><%= data.FATXT %></td>
            <td class="td04" style="text-align:right"><%= data.ADD_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ADD_BETRG)  %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= data.ACT_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ACT_BETRG)  %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= data.AUTO_BETRG.equals("0.0") ? "&nbsp;" : WebUtil.printNumFormat(data.AUTO_BETRG) %>&nbsp;</td>
            <td class="td04" style="text-align:left">&nbsp;<%=  data.AUTO_BETRG.equals("0.0")  ? "&nbsp;" :data.AUTO_TEXT %></td>
            <td class="td04"><!--@2011교복구입비-->
             <input type="checkbox" name="EXSTY<%= i %>" value="" class="input03" style="text-align:right" <%= data.EXSTY.equals("X")  ? "checked" : "" %> disabled>
            </td>
            <td class="td04"><!--@v1.4-->
             <input type="checkbox" name="CHNTS<%= i %>" value="" class="input03" style="text-align:right" <%= data.CHNTS.equals("X")  ? "checked" : "" %> disabled>
            </td>
            <td class="td04">
             <input type="checkbox" name="OMIT_FLAG<%= i %>" value="" class="input03" style="text-align:right" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> disabled>
            </td>

          </tr>
<%
    }
%>
        </table>
        <!--특별공제 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td height="8"></td>
    </tr>

    <tr>
      <td class="td02" style="text-align:left"><font color=blue><spring:message code="LABEL.D.D11.0079" /><!-- *주의사항* --></font></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=green><spring:message code="LABEL.D.D11.0116" /><!-- 1. 교육비(장/학자금) 中 회사지원분은 전산 자동반영 됨 --></font></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=green>&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0117" /><!-- -. 연말정산 간소화 서비스의 교육비 지출액에 자동반영 회사지원분이 포함되어 있을시에는 회사지원분을 차감하고 입력 --></font></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=green>&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0118" /><!-- -. 자동반영된 회사지원액을 제외하고자 하는 경우에는 제외하고자 하는 해당항목의 "연말정산삭제" 체크박스에 체크 후 저장 --></font></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
<%
    if( !o_flag.equals("X") ) {
%>
    <tr>
      <td>
        <table width="780" border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td align="center">
              <a href="javascript:do_change();">
              <img src="<%= WebUtil.ImageURL %>btn_change.gif" border="0" align="absmiddle"></a>
          </tr>
        </table>
      </td>
    </tr>
<%
    }
%>
  </table>
<!-- 숨겨진 필드 -->
  <input type="hidden" name="jobid"      value="">
  <input type="hidden" name="targetYear" value="<%=targetYear%>">
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->