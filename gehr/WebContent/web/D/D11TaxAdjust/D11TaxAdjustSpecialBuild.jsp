<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustSpecialBuild.jsp                               */
/*   Description  : 특별공제(주택자금상환) 입력 및 조회                                       */
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
    D11TaxAdjustHouseEssentialChkRFC HouseEChkRFC           = new D11TaxAdjustHouseEssentialChkRFC();
    String E_CHECK = HouseEChkRFC.getYn( user.empNo,targetYear);

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
// 특별공제 - 신청
function do_build() {

    for( var i = 0 ; i < "<%= special_vt.size() %>" ; i++ ) {
        goje_flag = eval("document.form1.GOJE_FLAG"+i+".value");

        req_h = eval("document.form1.REQ_H"+i+".value");

        gubn_text = eval("document.form1.GUBN_TEXT"+i+".value");

        if ( eval("document.form1.GOJE_CODE"+i+".value == '19200000'") ||
            eval("document.form1.GOJE_CODE"+i+".value == '19300000'") ||
            eval("document.form1.GOJE_CODE"+i+".value == '19400000'") ) {

            eval("document.form1.ADD_BETRG"+i+".value = document.form1.betrg"+i+"[document.form1.betrg"+i+".selectedIndex].text;");

        } else if ( goje_flag == "1" ) {
            eval("document.form1.ADD_BETRG"+i+".value = removeComma(document.form1.betrg"+i+".value);");
            betrg = eval("document.form1.ADD_BETRG"+i+".value");
            //삭제하지 않은 주택자금항목인경우 세대주여부 체크
            /*@2014 연말정산 주택자금 관련 alert 모두 삭제요청(박난이S)
            if (betrg!="" && req_h=="X" && document.form1.FSTID.checked != true) {
                alert(gubn_text+ " 항목은 세대주이어야 합니다.\n(단, 주택자금 저당차입금 이자상환액은 반드시 세대주가 아니여도 됨)\n세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
                eval("document.form1.betrg"+i+".focus();");

                return;
               }
            */
        }

    }

     /*@2014 연말정산
    if ("<%=E_CHECK%>"=="X" && document.form1.FSTID.checked != true) {
         alert("<spring:message code='MSG.D.D11.0080' />"); //주택자금 관련공제는 세대주이어야 합니다.\n(단, 주택자금 저당차입금 이자상환액은 반드시 세대주가 아니여도 됨)\n다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.
         return;
    }

    */
    eval("document.form1.FSTID.disabled = false;") ; //세대주여부
    if( eval("document.form1.FSTID.checked == true") )
        eval("document.form1.FSTID.value ='X';");

    document.form1.jobid.value = "build";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustSpecialSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}

// 값이 변경되었는지 체크한다
function chk_change() {
    flag = false;
    for( var i = 0 ; i < "<%= special_vt.size() %>" ; i++ ) {
        goje_flag = eval("document.form1.GOJE_FLAG"+i+".value");
        if( goje_flag == "1" ) {
            old_value = Number(eval("document.form1.ADD_BETRG"+i+".value;"));
            new_value = Number(eval("removeComma(document.form1.betrg"+i+".value);"));
            if( old_value != new_value ) {
                flag = true;
            }
        }
    }

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

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>
          <tr class="<%=tr_class%>">
            <td class="align_left"><%= data.GUBN_TEXT %></td>
<%
        if ( data.GOJE_CODE.equals("19200000") || data.GOJE_CODE.equals("19300000") || data.GOJE_CODE.equals("19400000") ) {
%>
            <td class="align_right">
              <select name="betrg<%= i %>" style="text-align:right">
<%
            for( int x = 0 ; x < 11 ; x++ ) {
%>
                <option value="<%= x %>" ><%= x %></option>
<%
            }
%>
              </select><spring:message code="LABEL.D.D11.0261" /><!-- 회 -->&nbsp;
            </td>
            <td class="align_right"><%= data.AUTO_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.AUTO_BETRG) %></td>
            <td class="align_left"><%= data.AUTO_TEXT %></td>
<%
        } else {

            if( data.GOJE_FLAG.equals("1") ) {
%>
            <td>
              <input type="text" name="betrg<%= i %>" value="<%= data.ADD_BETRG.equals("0.0")  ? "" : WebUtil.printNumFormat(data.ADD_BETRG) %>" size="15" maxlength="11" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()">
            </td>
<%
            } else {
%>
            <td class="align_right"><%= data.ADD_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ADD_BETRG)  %></td>
<%
            }
%>
            <td class="align_right"><%= data.AUTO_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.AUTO_BETRG) %></td>
            <td class="lastCol"><%= data.AUTO_TEXT %></td>
            <% if("@".equals(pdfYn)) {%><!-- @2015 연말정산 사용안함. -->
            <td class="lastCol">
             <input type="checkbox" style="text-align:right" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> disabled>
            </td>
            <%} %>
          </tr>
<%
        }
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
      <td class="td02" style="text-align:left"><font color=blue>※ PDF를 통하여 업로드 된 경우에는 “PDF”열에 표시되며, 반영을 취소할 경우에는 “연말정산 삭제”열에 체크</font></td>
    </tr>

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

<%
    //if( appl_from <= 0 && appl_toxx >= 0 && !o_flag.equals("X") ) {
    if(  !o_flag.equals("X") ) {
%>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_build();"><span><spring:message code="LABEL.D.D11.0073" /><!-- 입력 --></span></a></li>
        </ul>
    </div>

<%
    }
%>
</div>
<!-- 숨겨진 필드 -->
    <input type="hidden" name="jobid"      value="">
    <input type="hidden" name="targetYear" value="<%= targetYear %>">
    <input type="hidden" name="rowCount"   value="<%= special_vt.size() %>">
<%
    for( int i = 0 ; i < special_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)special_vt.get(i);
%>
    <input type="hidden" name="GUBN_CODE<%= i %>"  value="<%= data.GUBN_CODE  %>">
    <input type="hidden" name="GOJE_CODE<%= i %>"  value="<%= data.GOJE_CODE  %>">
    <input type="hidden" name="GUBN_TEXT<%= i %>"  value="<%= data.GUBN_TEXT  %>">
    <input type="hidden" name="SUBTY<%= i %>"      value="<%= data.SUBTY      %>">
    <input type="hidden" name="STEXT<%= i %>"      value="<%= data.STEXT      %>">
    <input type="hidden" name="ENAME<%= i %>"      value="<%= data.ENAME      %>">
    <input type="hidden" name="REGNO<%= i %>"      value="<%= data.REGNO      %>">
    <input type="hidden" name="FASAR<%= i %>"      value="<%= data.FASAR      %>">
    <input type="hidden" name="ADD_BETRG<%= i %>"  value="<%= data.ADD_BETRG  %>">
    <input type="hidden" name="ACT_BETRG<%= i %>"  value="<%= data.ACT_BETRG  %>">
    <input type="hidden" name="AUTO_BETRG<%= i %>" value="<%= data.AUTO_BETRG %>">
    <input type="hidden" name="AUTO_TEXT<%= i %>"  value="<%= data.AUTO_TEXT  %>">
    <input type="hidden" name="GOJE_FLAG<%= i %>"  value="<%= data.GOJE_FLAG  %>">
    <input type="hidden" name="FTEXT<%= i %>"      value="<%= data.FTEXT      %>">
    <input type="hidden" name="FLAG<%= i %>"       value="<%= data.FLAG       %>">
    <input type="hidden" name="REQ_H<%= i %>"       value="<%= data.REQ_H       %>">
<%
    }
%>
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
