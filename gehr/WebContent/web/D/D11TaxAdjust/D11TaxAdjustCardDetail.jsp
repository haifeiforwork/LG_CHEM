<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustCardDetail.jsp                                  */
/*   Description  : 신용카드.현금영수증.보험료 입력 및 조회                     */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2006-11-23                                                  */
/*                    2008-11-20  CSR ID:1361257 2008년말정산반영               */
/*                  2012-12-13  C20121213_34842 2012 년말정산  전통시장여부추가 */
/*                  2013-11-25  CSR ID:2013_9999 2013년말정산반영 대중교통추가  */
/*                                               신용카드: 지로영수증 삭제      */
/*                   2014-12-03 @2014 연말정산                                                         */
/*  				2018-01-07 cykim [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC            = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData  = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector card_vt    = (Vector)request.getAttribute("card_vt" );
    String tab_gubun  = (String)request.getAttribute("tab_gubun" );
    //@2016연말정산 sort 추가 start
    String sortField = (String)request.getAttribute("sortField");
    String sortValue = (String)request.getAttribute("sortValue");
    //@2016연말정산 sort 추가 end
//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax09";
    if ( tab_gubun.equals("2") )
         Gubn = "Tax10";
    else
         Gubn = "Tax09";
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
// onLoad시 호출됨.
function first(){
   return;
}
// 특별공제 교육비 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}
$(function() {
	 first()
});
//@2016연말정산 sort 추가 start
function get_Page(){
    document.form1.action = '<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV';
    document.form1.method = "post";
    document.form1.submit();
}

function sortPage( FieldName, FieldValue ){
	  if(document.form1.sortField.value==FieldName){
	      if(document.form1.sortValue.value == 'asc') {
	        document.form1.sortValue.value = 'desc';
	      } else {
	        document.form1.sortValue.value = 'asc';
	      }
	  } else {
	    document.form1.sortField.value = FieldName;
	    document.form1.sortValue.value = FieldValue;
	  }
	  get_Page();
	}
//@2016연말정산 sort 추가 end
//-->
</SCRIPT>

 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>

<form name="form1" method="post">
        <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

<%      if (tab_gubun.equals("1")) { //신용카드/현금
%>

  <div class="listArea">
          <div class="table">
            <table class="listTable" id="table">
        <!--특별공제 테이블 시작-->
		<thead>
          <tr>
            <th><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
            <th onClick="javascript:sortPage('F_ENAME','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --><%= WebUtil.printSort("F_ENAME",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('F_REGNO','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --><%= WebUtil.printSort("F_REGNO",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('GU_NAME','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --><%= WebUtil.printSort("GU_NAME",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('BETRG','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0048" /><!-- 공제대상액 --><%= WebUtil.printSort("BETRG",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('TRDMK','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0074" /><!-- 전통<br>시장 --><%= WebUtil.printSort("TRDMK",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('CCTRA','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0075" /><!-- 대중<br>교통 --><%= WebUtil.printSort("CCTRA",sortField,sortValue)%></th>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  -->
            <%--
            <th onClick="javascript:sortPage('EXSTX','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0051" /><!-- 사용기간 --><%= WebUtil.printSort("EXSTX",sortField,sortValue)%></th><!-- @2014 연말정산 -->
             --%>
             <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end  -->
            <th onClick="javascript:sortPage('BETRG_B','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0052" /><!-- 회사비용 정리금 --><%= WebUtil.printSort("BETRG_B",sortField,sortValue)%></th>
            <th class="<%=!"Y".equals(pdfYn) ? "lastCol": ""%>" onClick="javascript:sortPage('CHNTS','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0076" /><!-- 국세청<br>자료 --><%= WebUtil.printSort("CHNTS",sortField,sortValue)%></th>
            <% if("Y".equals(pdfYn)) {%>
            <th onClick="javascript:sortPage('GUBUN','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --><%= WebUtil.printSort("GUBUN",sortField,sortValue)%></th>
            <th class="lastCol"  onClick="javascript:sortPage('OMIT_FLAG','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0077" /><!-- 연말<br>정산<br>삭제 --><%= WebUtil.printSort("OMIT_FLAG",sortField,sortValue)%></th>
            <%} %>
          </tr>
         </thead>



<%
    for( int i = 0 ; i < card_vt.size() ; i++ ){
        D11TaxAdjustCardData data = (D11TaxAdjustCardData)card_vt.get(i);
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td ><%= WebUtil.printOptionText((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
            <td ><%= data.F_ENAME %></td>
            <td ><%= data.F_REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.F_REGNO) %></td>
            <td><%= data.GU_NAME %></td>
            <td  style="text-align:right"><%= data.BETRG.equals("")  ? "" : WebUtil.printNumFormat(data.BETRG) %>&nbsp;</td>
            <!--C20121213_34842 2012  전통시장여부 -->
            <td >
             <input type="checkbox" name="TRDMK<%= i %>" value="" class="input03" style="text-align:right" <%= data.TRDMK.equals("X")  ? "checked" : "" %> disabled>
            </td>
             <!--CSR ID:2013_9999 대중교통추가 -->
            <td >
             <input type="checkbox" name="CCTRA<%= i %>" value="" class="input03" style="text-align:right" <%= data.CCTRA.equals("X")  ? "checked" : "" %> disabled>
            </td>
            <!--@2014 연말정산 사용기간추가 -->
            <!-- [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 start -->
            <%--
            <td  style="text-align:left">
             &nbsp;&nbsp;&nbsp;<%= data.EXSTX %>
            </td>
            --%>
            <!-- [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 end -->
            <td  style="text-align:right"><%= data.BETRG_B.equals("")  ? "" : WebUtil.printNumFormat(data.BETRG_B) %>&nbsp;</td>
            <td >
             <input type="checkbox" name="CHNTS<%= i %>" value="" class="input03" style="text-align:right" <%= data.CHNTS.equals("X")  ? "checked" : "" %> disabled>
            </td>
            <% if("Y".equals(pdfYn)) {%>
            <td >
             <input type="checkbox" name="GUBUN<%=i%>" value="<%=  data.GUBUN.equals("9") ? "X" : "" %>" <%= data.GUBUN.equals("9")  ? "checked" : "" %> class="input03" disabled>
            </td>
            <td class="lastCol">
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> class="input03" disabled>
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
        <!--[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  -->
        <p><span class="bold"><spring:message code="LABEL.D.D11.0285" /><!-- 1. 중도 입사자의 경우 근로기간의 카드 사용액만 입력 --></span></p>
        <p><span class="bold"><spring:message code="LABEL.D.D11.0060" /><!-- 2. 입력하는 방법 --></span></p>
        <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
        <p><span class="bold">&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0080" /><!-- <b>ⓐ 구분</b> : 신용카드/직불(선불카드)/현금영수증을 정확하게 입력해야 함 --></span></p>
    	<p><span class="bold">&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0081" /><!-- <b>ⓑ 공제대상액</b> : 신용카드 영수증 및 현금영수증은 일반 공제 대상 금액이라고 나와있는 부분을 그대로 입력 --></span></p>
    	<p><span class="bold"><font color=red>&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0082" /><!-- <b>ⓒ 전통시장/대중교통</b> : <u>신용카드 영수증 및 현금영수증에 전통시장으로 구분 되어 있는 경우 반드시 체크 --></u></font></span></p>
    	<p><span class="bold"><font color=red>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><spring:message code="LABEL.D.D11.0064" /><!-- →하나의 영수증에 일반공제/전통시장/대중교통으로 구분되어 있는 경우 각각 구분해서 입력해야 함 --></b></font></span></p>
    	<!--[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  -->
    	<%-- <p><span class="bold"><font color=red>&nbsp;&nbsp;&nbsp;<b><spring:message code="LABEL.D.D11.0065" /><!-- ⓓ 사용기간 : 본인이 사용한 신용카드, 직불카드, 현금영수증은 반드시 2014년, 2015년 사용액으로 구분하여 입력해야함 --></b></font></span></p> --%> <!-- @2015 연말정산 -->
    	<p><span class="bold">&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0083" /><!-- <b>ⓓ 회사비용 정리금</b> : 개인카드 사용 후 회사비용으로 정리한 경우 관할 부서에서 일괄 반영할 예정임 --></span></p>
    	<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
    	<p><span class="bold"><spring:message code="LABEL.D.D11.0067" /><!-- 2. 신용카드가 연급여(HR Center > 인사정보 > 급여 > 연급여)에서 지급계의 25% 이하인 경우 공제 안되므로 입력할 필요 없음 --></span></p>
    	<p><span class="bold"><spring:message code="LABEL.D.D11.0068" /><!-- ※ 온누리 상품권 사용만으로는 공제 불가능 하며, 반드시 현금영수증으로 처리해야 함 --></span></p>
  		<!--[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  -->
    	<p><span class="bold"><spring:message code="LABEL.D.D11.0284" /><!-- ※ 중도 입사자의 경우 근로기간의 카드 사용액만 입력 --></span></p>
    	<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
  </div>

<% } //신용카드
   else { //보험료
%>
  <div class="listArea">
          <div class="table">
            <table class="listTable">
        <!--특별공제 테이블 시작-->
        <%--@2016연말정산 sort  수정 start --%>
		<thead>
          <tr>
            <th ><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
            <th onClick="javascript:sortPage('F_ENAME','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --><%= WebUtil.printSort("F_ENAME",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('F_REGNO','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --><%= WebUtil.printSort("F_REGNO",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('GU_NAME','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --><%= WebUtil.printSort("GU_NAME",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('BETRG','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --><%= WebUtil.printSort("BETRG",sortField,sortValue)%></th>
            <th class="<%=!"Y".equals(pdfYn) ? "lastCol": ""%>" onClick="javascript:sortPage('CHNTS','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0053" /><!-- 국세청자료 --><%= WebUtil.printSort("CHNTS",sortField,sortValue)%></th>
            <% if("Y".equals(pdfYn)) {%>
            <th onClick="javascript:sortPage('GUBUN','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --><%= WebUtil.printSort("GUBUN",sortField,sortValue)%></th>
            <th class="lastCol"  onClick="javascript:sortPage('OMIT_FLAG','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --><%= WebUtil.printSort("OMIT_FLAG",sortField,sortValue)%></th>
            <%} %>
          </tr>
         </thead>
         <%--@2016연말정산 sort  수정 end --%>
<%
    for( int i = 0 ; i < card_vt.size() ; i++ ){
        D11TaxAdjustCardData data = (D11TaxAdjustCardData)card_vt.get(i);
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td ><%= WebUtil.printOptionText((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
            <td ><%= data.F_ENAME %></td>
            <td ><%= data.F_REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.F_REGNO) %></td>
            <td><%= data.GU_NAME %></td>
            <td  style="text-align:right"><%= data.BETRG.equals("")  ? "" : WebUtil.printNumFormat(data.BETRG) %>&nbsp;</td>
            <td class="<%=!"Y".equals(pdfYn) ? "lastCol": ""%>">
             <input type="checkbox" name="CHNTS<%= i %>" value="" class="input03" style="text-align:right" <%= data.CHNTS.equals("X")  ? "checked" : "" %> disabled>
            </td>
            <% if("Y".equals(pdfYn)) {%>
            <td >
             <input type="checkbox" name="PDF<%= i %>" value="" class="input03" style="text-align:right" <%= data.GUBUN.equals("9")  ? "checked" : "" %> disabled>
            </td>
            <td class="lastCol" >
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> class="input03" disabled>
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
    }
%>

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
    <input type="hidden" name="targetYear" value="<%=targetYear%>">
    <input type="hidden" name="tab_gubun"  value="<%= tab_gubun %>">
    <%--@2016연말정산 sort 추가 start --%>
      <input type="hidden" name="sortField" value="<%= sortField %>">
      <input type="hidden" name="sortValue" value="<%= sortValue %>">
     <%--@2016연말정산 sort 추가 end --%>

<!-- 숨겨진 필드 -->
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
