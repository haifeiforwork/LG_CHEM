<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustGuideTop.jsp                                    */
/*   Description  : 연말정산 입력 및 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                  2005-11-17  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="hris.common.rfc.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = request.getParameter("targetYear");

//  2002.12.03 연말정산 입력, 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "TaxGuide";

    //@v2007대리신청로직
    //PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
    String PERNR = request.getParameter("PERNR");
%>
<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
//@v2007  대리 신청 추가
function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxFirstSV";
    frm.target = "";
    frm.submit();
}
</script>

 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="always" value="true"/>
        <jsp:param name="title" value="LABEL.D.D11.0001"/>
 </jsp:include>

<form name="form1" method="post">
<!--  @v2007  대리 신청 추가-->
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="PERNR" value="<%=PERNR%>">


<%@ include file="D11TaxAdjustButton.jsp" %>
 </form>
<script>
//CSR ID:2013_9999
if ("<%=pdfYn%>"!="Y") {
	var msg ="<spring:message code='LABEL.D.D11.0160' arguments='<%=targetYear%>'/>" ; <%-- //년 중도 입사자의  경우에는  입사  이후 사용한 비용만  가능하므로, PDF 업로드가 불가능함 \n --%>
	msg += "<spring:message code='LABEL.D.D11.0161' />"; <%--  //→ 국세청 간소화서비스(http://www.yest.one.go.kr)에서  월별로 자료를 출력하여  직접 입력 \n --%>
	msg += "<spring:message code='LABEL.D.D11.0162' arguments='<%=targetYear%>'/>"; <%--  //(단, 기부금/연금저축 공제는 '<%=targetYear%>년도 전체에 대해서 공제 적용 가능)\n --%>
	alert(msg);
}
</script>
<!--임시     &nbsp;&nbsp;&nbsp;&nbsp;●&nbsp;연말정산 본인내역조회안내 <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1) 연말정산 내역조회기간(1/11~1/17) <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) 상기관련하여 문의사항이 있으시면 각 사업장별 담당부서로 연락주시기 바랍니다. <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
    -->
<!--     &nbsp;&nbsp;&nbsp;&nbsp;●&nbsp;연말정산 마감일정안내 <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1) 연말정산 개인별 시스템 입력(12/4~12/27) 마감. <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) 교육비(장/학자금), 의료비 中 회사지원분은 전산자동반영되오니, 전산입력시 중복되어 입력되지 않도록 주의해주시기 바랍니다.	<br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
     -->
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->