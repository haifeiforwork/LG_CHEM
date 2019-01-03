<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustTaxBuild.jsp                                    */
/*   Description  : 기타/세액공제 입력 및 조회                                  */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-01  윤정현                                          */
/*                  2005-11-24  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
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
    Vector tax_vt     = (Vector)request.getAttribute("tax_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax04";   //@v1.1

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

// 특별공제 - 신청
function do_build() {
    var betrg_sum = 0;
    for( var i = 0 ; i < "<%= tax_vt.size() %>" ; i++ ) {
        goje_flag = eval("document.form1.GOJE_FLAG"+i+".value");
        goje_gubn = eval("document.form1.goje_gubn"+i+".value");
        if( goje_flag == "1" ) {
          eval("document.form1.ADD_BETRG"+i+".value  = removeComma(document.form1.betrg"+i+".value);");
        }
        if (goje_gubn=="35000100"||goje_gubn=="35000200")
            betrg_sum = Number(betrg_sum) + Number(eval("removeComma(document.form1.betrg"+i+".value);"));
    }
    if ( betrg_sum >  12000000) {
       alert("<spring:message code='MSG.D.D11.0100' />"); //[장기주식형저축소득공제금액]은 연간 1200만원 이내로 입력해야 합니다.
       return;
    }
    eval("document.form1.FSTID.disabled = false;") ; //세대주여부
    if( eval("document.form1.FSTID.checked == true") )
        eval("document.form1.FSTID.value ='X';");

    document.form1.jobid.value = "build";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustTaxSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}

// 값이 변경되었는지 체크한다
function chk_change() {
    flag = false;
    for( var i = 0 ; i < "<%= tax_vt.size() %>" ; i++ ) {
        goje_flag = eval("document.form1.GOJE_FLAG"+i+".value");
        if( goje_flag == "1" ) {
            old_value = Number(eval("document.form1.ADD_BETRG"+i+".value;"));
            new_value = Number(eval("removeComma(document.form1.betrg"+i+".value);"));
            if( old_value != new_value ) {
                flag = true;
            }
        }
    }

//2003.12.26.mkbae.    if( flag ) {
//        if( confirm( "변경된 내용이 존재합니다.\n저장하시겠습니까?") ){
//            return true;
//        } else {
//            return false;
//        }
//    }
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
              </tr>
              <tr>
                <th><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                <th class="lastCol" width="290"><spring:message code="LABEL.D.D11.0115" /><!-- 내용 --></th>
              </tr>
             </thead>
<%
    for( int i = 0 ; i < tax_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)tax_vt.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>
          <tr class="<%=tr_class%>">
            <td class="align_left"><%= data.GUBN_TEXT %></td>
            <input type="hidden" name="goje_gubn<%= i %>"  value="<%= data.GOJE_CODE  %>">
<%
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
            <td class="align_left lastCol"><%= data.AUTO_TEXT %></td>
          </tr>
<%
    }
%>
            </table>
        </div>
    </div>
    <!--특별공제 테이블 끝-->

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
    <input type="hidden" name="rowCount"   value="<%= tax_vt.size() %>">
<%
    for( int i = 0 ; i < tax_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)tax_vt.get(i);
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
<%
    }
%>
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->