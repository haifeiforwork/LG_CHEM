<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustPensionBuild.jsp                                */
/*   Description  : 연금/저축공제 입력 및 조회                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-12-08                                                  */
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
<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector pension_vt     = (Vector)request.getAttribute("pension_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String rowCount   = (String)request.getAttribute("rowCount" );
    String Gubn = "Tax11";    //@v1.1
    int pension_count = 8;

    if( pension_vt.size() > pension_count ) {
        pension_count = pension_vt.size();
    }
    if ( Integer.parseInt(rowCount) != 8  ) {
        pension_count = Integer.parseInt(rowCount);
    }
    D11TaxAdjustHouseEssentialChkRFC HouseEChkRFC           = new D11TaxAdjustHouseEssentialChkRFC();
    String E_CHECK = HouseEChkRFC.getYn( user.empNo,targetYear);

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

// 연금/저축공제 - 신청
function do_build() {
    for( var i = 0 ; i < "<%= pension_count %>" ; i++ ) {
        SUBTY = eval("document.form1.SUBTY_"+i+".value");
        PNSTY = eval("document.form1.PNSTY_"+i+".value");
        FINCO = eval("document.form1.FINCO_"+i+".value");
        ACCNO = eval("document.form1.ACCNO_"+i+".value");
        RCBEG = removePoint(eval("document.form1.RCBEG_"+i+".value"));//@2015연말정산 가입일 추가
        eval("document.form1.RCBEG_"+i+".value = RCBEG;");
        NAM01 = eval("document.form1.NAM01_"+i+".value");
        PREIN_FLAG= eval("document.form1.PREIN_FLAG_"+i+".value"); //종(전)근무지필수 체크
        FINCO_FLAG= eval("document.form1.FINCO_FLAG_"+i+".value"); //금융기관코드필수 체크
        ACCNO_FLAG= eval("document.form1.ACCNO_FLAG_"+i+".value"); //계좌번호필수 체크

        if( eval("document.form1.PREIN_"+ i + ".checked == true") )  {
            eval("document.form1.PREIN_"+ i + ".value ='X';");
            PREIN = "X";
        } else{
            PREIN = "";
        }
        SUBTYNM = eval("document.form1.SUBTY_"+i+"[document.form1.SUBTY_"+i+".selectedIndex].text");
        PNSTYNM = eval("document.form1.PNSTY_"+i+"[document.form1.PNSTY_"+i+".selectedIndex].text");

        if ( SUBTY != "" || PNSTY != "" || FINCO != "" || ACCNO != "" || NAM01 != "") {
             if ( SUBTY == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0074' />"); //구분은 필수 항목입니다.
                 eval("document.form1.SUBTY_"+i+".focus()");
                 return;
             }
             if ( PNSTY == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0075' />"); //유형은 필수 항목입니다.
                 eval("document.form1.PNSTY_"+i+".focus()");
                 return;
             }
             if ( FINCO == ""  && FINCO_FLAG=="X") {
                 alert(SUBTYNM+"/"+PNSTYNM+" <spring:message code='MSG.D.D11.0076' />");  // 항목은 금융기간은 필수 입니다.
                 eval("document.form1.FINCO_"+i+".focus()");
                 return;
             }
             if ( ACCNO == ""  && ACCNO_FLAG=="X") {
                 alert(SUBTYNM+"/"+PNSTYNM+" <spring:message code='MSG.D.D11.0077' />"); // 항목은 계좌번호는 필수 항목입니다.
                 eval("document.form1.ACCNO_"+i+".focus()");
                 return;
             }
             if ( NAM01 == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0044' />"); //금액은 필수 항목입니다.
                 eval("document.form1.NAM01_"+i+".focus()");
                 return;
             }
        }

        //@2015 연말정산 추가, 구분 값이 청약저축(E3)일 경우, 가입일 필수
        if (SUBTY == "E3" && RCBEG == ""){
            alert(SUBTYNM+"/"+PNSTYNM+" <spring:message code='MSG.D.D11.0078' />"); // 항목은 가입일은 필수 항목입니다.
            eval("document.form1.RCBEG_"+i+".focus()");
            return;
        }

        E_HOLD= eval("document.form1.E_HOLD_"+i+".value");
        if (E_HOLD=="X" && document.form1.FSTID.checked != true) {
            alert(PNSTYNM+ " <spring:message code='MSG.D.D11.0079' />");  // 항목은 세대주이어야 합니다.\n세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.
            //eval("document.form1.betrg"+i+".focus();");
            return;
        }
    }
    if ("<%=E_CHECK%>"=="X" && document.form1.FSTID.checked != true) {
         alert("<spring:message code='MSG.D.D11.0080' />");  //주택자금 관련공제는 세대주이어야 합니다.\n(단, 주택자금 저당차입금 이자상환액은 반드시 세대주가 아니여도 됨)\n다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.
         return;
    }
    for( var i = 0 ; i < "<%= pension_count %>" ; i++ ) {

        eval("document.form1.NAM01_"+i+".value  = removeComma(document.form1.NAM01_"+i+".value);");
        eval( "document.form1.PREIN_"+i+".disabled = false;");
        eval( "document.form1.FINCO_"+i+".disabled = false;");
        eval( "document.form1.ACCNO_"+i+".disabled = false;");
        eval( "document.form1.RCBEG_"+i+".disabled = false;");
    }
    
    eval("document.form1.FSTID.disabled = false;") ; //세대주여부
    if( eval("document.form1.FSTID.checked == true") )
        eval("document.form1.FSTID.value ='X';");
    
    document.form1.jobid.value = "build";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPensionSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}

function changeSubty(obj,i,gubn )
{
     if (gubn=="1") {
         //@2015 연말정산 수정 청약저축을 제외하고 나머지는 가입일을 disable 시킴
         if( !(obj.value == "E3")){
             eval( "document.form1.RCBEG_"+i+".value  = '';");
             eval( "document.form1.RCBEG_"+i+".disabled  = true;");
         }else{
             eval( "document.form1.RCBEG_"+i+".disabled  = false;");
         }

        document.code.GUBUN.value = "1";
        document.code.SUBTY.value = obj.value;
        document.code.i.value = i;
        document.code.target = "ifHidden";
        document.code.action = "<%=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustPensionHiddenGubn.jsp";
        document.code.submit();
     } else if (gubn=="3") {
        eval("document.code.SUBTY.value =  document.form1.SUBTY_"+i+"[document.form1.SUBTY_"+i+".selectedIndex].value ;");
        document.code.PNSTY.value = obj.value;
        document.code.GUBUN.value = "3";
        document.code.i.value = i;
        document.code.target = "ifHidden";
        document.code.action = "<%=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustPensionHiddenGubn.jsp";
        document.code.submit();

     } else if (gubn=="2") {
           eval("document.form1.INSNM_"+i+".value =  document.form1.FINCO_"+i+"[document.form1.FINCO_"+i+".selectedIndex].text ;");

     }

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
            <table class="listTable"  id="table">
              <thead>
                <tr>
                  <th><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></th>
                  <th><spring:message code="LABEL.D.D11.0199" /><!-- 유형 --></th>
                  <th><spring:message code="LABEL.D.D11.0200" /><!-- 금융기관 --></th>
                  <th><spring:message code="LABEL.D.D11.0201" /><!-- 가입일 --></th><!-- @2015 연말정산 -->
                  <th><spring:message code="LABEL.D.D11.0202" /><!-- 증권보험 -->/<spring:message code="LABEL.D.D11.0203" /><!-- 계좌번호 --></th>
                  <th><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                  <th><spring:message code="LABEL.D.D11.0204" /><!-- 종(전)근무지 --></th>
                  <% if("Y".equals(pdfYn)) {%>
                  <th><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                  <th class="lastCol"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></th>
                   <%} %>
                </tr>
              </thead>
<%
    for( int i = 0 ; i < pension_count ; i++ ){

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>
        <tr class="<%=tr_class%>">
           <td>
            <select name="SUBTY_<%= i %>" onChange="javascript:changeSubty(this,<%= i %>,'1');">
              <option value="">---------------</option>
<%= WebUtil.printOption((new D11TaxAdjustPensionCodeRFC()).getPension(targetYear,"1",""), "") %>

            </select>
          </td>
          <td>
              <select name="PNSTY_<%= i %>" onChange="javascript:changeSubty(this,<%= i %>,'3' );">
                <option value="">---------</option>
              </select>
          </td>
           <td>
            <select name="FINCO_<%= i %>" onChange="javascript:changeSubty(this,<%= i %>,'2' );">
              <option value="">------------------------------</option>
<%= WebUtil.printOption((new D11TaxAdjustFincoCodeRFC()).getPension(""), "") %>

            </select>
          </td>
            <input type="hidden" name="REQ_H_<%= i %>" value="">
            <input type="hidden" name="INSNM_<%= i %>" value="">
          <!-- @2015연말정산 가입일 추가 -->
          <td>
            <input type="text" name="RCBEG_<%= i %>" value="" maxlength=18 size="18" onblur="javascript:dateFormat(this);">
          </td>
          <td>
            <input type="text" name="ACCNO_<%= i %>" value="" maxlength=20 size="20">
          </td>
          <td>
            <input type="text" name="NAM01_<%= i %>" value="" size="18" maxlength="11" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()">
          </td>
          <td>
            <input type="checkbox" name="PREIN_<%=i%>" value="">
          </td>
          <% if("Y".equals(pdfYn)) {%>
            <td>
            <input type="checkbox" name="PDF_FLAG<%=i%>" value="" disabled>
             </td>
            <td class="lastCol">
             <input type="checkbox" name="OMIT_FLAG<%=i%>" value="" disabled>
            </td>
            <%} else {%>
            <div style="display:none">
            <input type="checkbox" name="PDF_FLAG<%=i%>">
            <input type="checkbox" name="OMIT_FLAG<%=i%>">
            </div>
            <%} %>
            <input type="hidden" name="PDF_FLAG<%=i%>"     value="">
            <input type="hidden" name="E_HOLD_<%=i%>"     value="">
            <input type="hidden" name="PREIN_FLAG_<%=i%>" value=""><!--종(전)근무지필수 체크 -->
            <input type="hidden" name="FINCO_FLAG_<%=i%>" value=""><!--금융기관코드필수 체크 -->
            <input type="hidden" name="ACCNO_FLAG_<%=i%>" value=""><!--계좌번호필수 체크     -->
        </tr>
<%
    }
%>
            </table>
        </div>
        <span class="commentOne"><spring:message code="LABEL.D.D11.0058" /><!-- PDF를 통하여 업로드 된 경우에는 “PDF”열에 표시되며, 반영을 취소할 경우에는 “연말정산 삭제”열에 체크 --></span>
    </div>
    <!--특별공제 테이블 끝-->

<%
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

    <div class="commentImportant" >
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <p><spring:message code="LABEL.D.D11.0205" /><!-- 1. 청약저축/주택청약종합저축을 입력하고자 하는 경우 구분을 "청약저축"으로 선택 후 유형에서 해당저축을 선택하여 주시기 바랍니다. --></p>
        <p><spring:message code="LABEL.D.D11.0206" /><!-- 2. 개인연금저축/연금저축을 입력하고자 하는 경우 구분을 "연금저축"으로 선택 후 유형에서 해당저축을 선택하여 주시기 바랍니다. --></p>
    </div>

</div>
<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<input type="hidden" name="rowCount"   value="<%= pension_vt.size() %>">
<input type="hidden" name="pension_count" value="<%= pension_count %>">
  <input type="hidden" name="curr_job" value="change">

<!-- 숨겨진 필드 -->
</form>

  <form name="code" method="post">
      <input type="hidden" name="targetYear" value="<%= targetYear %>">
      <input type="hidden" name = "SUBTY" value="">
      <input type="hidden" name = "i"   value="">
      <input type="hidden" name = "GUBUN"      value="">
      <input type="hidden" name = "PNSTY"      value="">
  </form>
<iframe name="ifHidden" width="0" height="0" />
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->