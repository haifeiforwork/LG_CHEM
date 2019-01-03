<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustGibuDetail.jsp                                  */
/*   Description  : 특별공제기부금 입력 및 조회                                 */
/*   Note         : 없음                                                        */
/*   Creation     :   2005.11.17 lsa                                            */
/*   Update       :   2005.12.08 lsa  @v1.1  사업자등록번호 정치자금인경우 비활성화처리*/
/*                    2006.11.22 lsa  @v1.2  국체청자료 체크추가                */
/*                    2008-11-20  CSR ID:1361257 2008년말정산반영               */
/*                    2018/01/05 rdcamel [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건                                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>

<%@ page import="hris.common.rfc.*" %>
<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC            = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData  = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector gibu_vt    = (Vector)request.getAttribute("gibu_vt" );
	Vector gibuCarried_vt = (Vector)request.getAttribute("gibuCarried_vt" );//[CSR ID:3569665]
	int gibuCarried_vt_size = gibuCarried_vt.size();//[CSR ID:3569665]

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax06";
    String Prev_YN="";
    //  전근무지 메뉴를 해당년도 입사자인 경우에만 메뉴를 보여준다.
    if( user.e_dat03.substring(0,4).equals(targetYear) ) {
    	Prev_YN ="Y";
    }

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
// 특별공제기부금 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}
//@v2007  대리 신청 추가
function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
    frm.target = "";
    frm.submit();
}
</SCRIPT>


 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>
  <form name="form1" method="post">
<%@ include file="D11TaxAdjustButton.jsp" %>

    <!--특별공제 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable" id="table">
            <thead>
              <tr>
                <th colspan="3"><spring:message code="LABEL.D.D11.0131" /><!-- 기부자 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0132" /><!-- 기부금유형 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0133" /><!-- 기부년월 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0134" /><!-- 기부금 내용 --></th>
                <th colspan="2"><spring:message code="LABEL.D.D11.0135" /><!-- 기부처 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
             <% if ( Prev_YN.equals("Y") ){ %>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0136" /><!-- 이월<BR>공제 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0137" /><!-- 이월<BR>공제<BR>년도 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0138" /><!-- 전년까지<BR>공제액 --></th>
             <% } %>
                <% if("Y".equals(pdfYn)) {%>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                <th class="lastCol" rowspan="2"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></th>
                <%} %>
              </tr>

              <tr>
                <th><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>    <!--CSR ID:1361257-->
                <th><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></th>     <!--CSR ID:1361257-->
                <th><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></th><!--CSR ID:1361257-->
                <th><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></th>
                <th><spring:message code="LABEL.D.D11.0140" /><!-- 상호(법인명) --></th>
              </tr>
          </thead>
    <%
        for( int i = 0 ; i < gibu_vt.size() ; i++ ){
            D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibu_vt.get(i);
    %>
              <tr class="<%=WebUtil.printOddRow(i) %>">
                <td  nowrap><%= WebUtil.printOptionText((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %></td>
                <td  style="text-align:left" nowrap><%= data.F_ENAME %></td>
                <td  nowrap><%= data.F_REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.F_REGNO) %></td>

                <td  style="text-align:left"><%= data.DONA_NAME %></td>
                <td  nowrap><%= data.DONA_YYMM.equals("") ? "&nbsp;" : data.DONA_YYMM.substring(0,4)+"."+data.DONA_YYMM.substring(4,6)%></td>
                <td  style="text-align:left">&nbsp;<%= data.DONA_DESC %></td>
                <td  nowrap><%= data.DONA_NUMB.equals("") ? "&nbsp;" : DataUtil.addSeparate2(data.DONA_NUMB) %></td>
                <td  nowrap style="text-align:left">&nbsp;<%= data.DONA_COMP %></td>
                <td  style="text-align:right"><%= data.DONA_AMNT.equals("")  ? "" : WebUtil.printNumFormat(data.DONA_AMNT) %>&nbsp;</td>
                 <input type="hidden" name="CHNTS<%= i %>" value="" class="input03" style="text-align:right" <%= data.CHNTS.equals("X")  ? "checked" : "" %> disabled>
             <% if ( Prev_YN.equals("Y") ){ //@2011 %>
                <td >
                 <input type="checkbox" name="DONA_CRVIN<%= i %>" value="" class="input03" style="text-align:right" <%= data.DONA_CRVIN.equals("X")  ? "checked" : "" %> disabled>
                </td><!--이월공제-->
                <td ><%= data.DONA_CRVYR.equals("0000") ? "" : data.DONA_CRVYR %></td><!--이월공제년도-->
                <td  style="text-align:right"><%= data.DONA_DEDPR.equals("")||data.DONA_DEDPR.equals("0.0")  ? "" : WebUtil.printNumFormat(data.DONA_DEDPR) %>&nbsp;</td>
                <!--전년까지공제액-->
             <% }  %>
             <% if("Y".equals(pdfYn)) {%>
	            <td >
	             <input type="checkbox" name="GUBUN<%=i%>" <%= data.GUBUN.equals("9")  ? "checked" : "" %> disabled>
	            </td>
	            <td class="lastCol" >
	            <input type="checkbox" name="OMIT_FLAG<%=i%>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> class="input03" disabled>
	            </td>
	            <%}%>
              </tr>
    <%
        }
    %>
            </table>
        </div>
    </div>
    <!--특별공제 테이블 끝-->
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
    
<!-- 여기에 [CSR ID:3569665] 추가 -->
<% if( gibuCarried_vt_size > 0 ){%>
	<jsp:include page="/web/D/D11TaxAdjust/D11TaxAdjustGibuCarriedList.jsp" /> 
<%} %>

<!-- 숨겨진 필드 -->
    <input type="hidden" name="jobid"      value="">
    <input type="hidden" name="targetYear" value="<%=targetYear%>">
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
