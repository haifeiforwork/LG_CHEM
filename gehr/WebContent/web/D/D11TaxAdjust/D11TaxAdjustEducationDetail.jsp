<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustEducationBuild.jsp                              */
/*   Description  : 특별공제 교육비 조회                                        */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2013-07-01  손혜영                                          */
/*                  2013-11-25  CSR ID:2013_9999 2013년말정산반영               */
/*                              재활비삭제후 장애인교육비 항목추가              */
/* 				    2018-01-04 cykim [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건*/
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
<%@ page import=" java.lang.reflect.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(user.companyCode, user.empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector edu_vt     = (Vector)request.getAttribute("edu_vt" );
	//연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );
    String jobid     = (String)request.getAttribute("jobid" );
	//내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    //교육비
    String Gubn = "Tax03";

    //@v1.3
    D11TaxAdjustPePersonRFC   rfcPeP   = new D11TaxAdjustPePersonRFC();
    Vector EduPeP_vt = new Vector();
    EduPeP_vt      = rfcPeP.getPePerson( "3",user.empNo, targetYear  ); //I_GUBUN :1 - 보험료 2- 의료비  3-교육비 4-신용카드
    //관계 선택시 비교용
    String old_Name = "";

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

	//특별공제 교육비 - 수정
	function do_build(){
			document.form1.jobid.value = "change";
		    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEducationSV";
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
            <table id = "table1" class="listTable">
                <thead>
                    <tr  >
                      <th><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
                      <th><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></th>
                      <th><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></th>
                      <th><spring:message code="LABEL.D.D11.0018" /><!-- 학력 --></th>
                      <th><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                      <th><spring:message code="LABEL.D.D11.0119" /><!-- 교복<BR/>구입비 --></th>
                      <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
					  <th><spring:message code="LABEL.D.D11.0287" /><!-- 현장<BR/>학습비 --></th>
                      <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
                      <th><spring:message code="LABEL.D.D11.0120" /><!-- 장애인<br>교육비 --></th><!--CSR ID:2013_9999 -->
                      <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
                      <th><spring:message code="LABEL.D.D11.0288" /><!-- 학자금<br>상환 --></th>
                      <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
                      <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
                      <%--<th><spring:message code="LABEL.D.D11.0121" /><!-- 회사<br>지원분 --></th> --%>
                      <th><spring:message code="LABEL.D.D11.0076" /><!-- 국세청<BR/>자료 --></th>
                      <% if("Y".equals(pdfYn)) {%>
                      <th><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                      <%} %>
                      <th class="lastCol"><spring:message code="LABEL.D.D11.0122" /><!-- 연말정산<BR/>삭제 --></th>
                    </tr>
                </thead>
<tbody>
	<%
	for( int i = 0 ; i < edu_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)edu_vt.get(i);
%>
		<tr class="<%=WebUtil.printOddRow(i) %>">
		  <td  nowrap><%= WebUtil.printOptionText((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
            <td  nowrap><%= data.F_ENAME %></td>
            <td  nowrap><%= data.F_REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.F_REGNO) %></td>
            <td style="text-align:left" nowrap><%= data.FATXT %></td>
            <td  style="text-align:right"><%= data.BETRG.equals("")  ? "" : WebUtil.printNumFormat(data.BETRG) %>&nbsp;</td><!--금액-->
          <td><!--@2011 교복구입비 -->
            <input type="checkbox" <%= data.EXSTY.equals("X")  ? "checked" : "" %> class="input03" disabled>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
			<td><!--@2017 현장학습비 -->
            <input type="checkbox" <%= data.EXSTY.equals("F")  ? "checked" : "" %> class="input03" disabled>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
          <!--@2011 재활비 -->
          <!--CSR ID:2013_9999  장애인 교육비-->
          <td>
          	<input type="checkbox" <%= data.ACT_CHECK.equals("X")  ? "checked" : "" %> class="input03" disabled>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
          <td><!--@2017 학자금상환 -->
            <input type="checkbox" <%= data.LOAN.equals("X")  ? "checked" : "" %> class="input03" disabled>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
          <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
          <td style="display:none"><!--@2011 자동반영분 -->
          	<input type="checkbox" <%= data.GUBUN.equals("1")  ? "checked" : "" %> class="input03" disabled>
          </td>
          <td><!--@국세청자료-->
          	<input type="checkbox" <%= data.CHNTS.equals("X")  ? "checked" : "" %> class="input03" disabled>
          </td>
          <% if("Y".equals(pdfYn)) {%>
          <td >
          	<input type="checkbox" <%= data.GUBUN.equals("9")  ? "checked" : "" %> class="input03" disabled>
          </td>
          <%} %>
          <td class="lastCol"><!--@삭제-->
          	<input type="checkbox" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> class="input03" disabled>
          </td>
        </tr>
<%
    }
%>



</tbody>
      </table>
      <!--특별공제 테이블 끝-->
</div>
</div>

    <div class="commentImportant" style="width:720px;">
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
        <%--<p><spring:message code="LABEL.D.D11.0123" /><!-- 1. 회사에서 지원 받은 교육비 내역이 보여지며, 연말정산 공제 적용하기 위해서는 "연말정산삭제"열 체크 된 부분을 해지해야 함 --></p> --%>
        <p><spring:message code="LABEL.D.D11.0124" /><!-- 2. 중/고등학교의 교복(체육복)구입비 입력시 “교복구입비”체크란에 반드시 체크해야 함 --></p>
        <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
		<p><spring:message code="LABEL.D.D11.0286" /><!-- 2. 체험학습비(초/중/고생 30만원 한도) --></p>
		<p><spring:message code="LABEL.D.D11.0289" /><!-- 3. 학자금 상환 : 든든학자금 등의 학자금대출 원리금 상환액<br>&nbsp;&nbsp;(‘17.1.1 이후 상환하는 학자금 대출분에 한하여 공제 가능,<br>&nbsp;&nbsp;&nbsp;旣 이미 연말정산 공제 받은 금액에 대해서 중복공제 불가) --></p>
		<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
    </div>
  <%
    if(  !o_flag.equals("X") ) {
%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_build();"><span><spring:message code="BUTTON.COMMON.UPDATE" /><!-- 수정 --></span></a></li>
        </ul>
    </div>
<%
    }
%>
<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->