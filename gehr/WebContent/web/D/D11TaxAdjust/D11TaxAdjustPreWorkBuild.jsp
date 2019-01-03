<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustPreWorkBuild.jsp                                */
/*   Description  : 전근무지 입력 및 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2005.12.02 kds                                              */
/*   Update       : 2009.12.22 CSR ID:1577160                                   */
/* 					2018.01.04 cykim   [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건  */
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
    Vector preWork_vt = (Vector)request.getAttribute("preWork_vt" );
    String rowCount   = (String)request.getAttribute("rowCount" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));

    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    int preWork_count = 3;
    if( preWork_vt.size() > preWork_count ) {
        preWork_count = preWork_vt.size();
    }

    if ( Integer.parseInt(rowCount) != 8  ) {
        preWork_count = Integer.parseInt(rowCount);
    }
    String Gubn = "Tax08";
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
// 전근무지 - 신청
function do_build() {
    for( var i = 0 ; i < "<%= preWork_count %>" ; i++ ) {
        bizno  = eval("document.form1.BIZNO"+i+".value");
        sal01  = eval("document.form1.BET01"+i+".value");
        com01  = eval("document.form1.COMNM"+i+".value");

        sal01  = eval("document.form1.BET01"+i+".value");
        bon01  = eval("document.form1.BET02"+i+".value");
        out01  = eval("document.form1.BET03"+i+".value");
        ovr01  = eval("document.form1.BET04"+i+".value");
        oth01  = eval("document.form1.BET05"+i+".value");
        int01  = eval("document.form1.BET06"+i+".value");
        ret01  = eval("document.form1.BET07"+i+".value");
        npm01  = eval("document.form1.BET08"+i+".value");
        med01  = eval("document.form1.BET09"+i+".value");
        eim01  = eval("document.form1.BET10"+i+".value");

        if ( sal01 != "" && ( bizno == "" ) )  {
            alert("<spring:message code='MSG.D.D11.0046' />"); //사업자번호는 필수 항목입니다.
            return;
        }
        if ( com01 == "" &&
             (sal01!=""||bon01!=""||out01!=""||ovr01!=""||oth01!=""||int01!=""||ret01!=""||npm01!=""||med01!=""||eim01!="")){
            alert("<spring:message code='MSG.D.D11.0083' />"); //회사이름은 필수 항목입니다.
            return;
        }
    }

    for( var i = 0 ; i < "<%= preWork_count %>" ; i++ ) {
        eval("document.form1.BET01"+i+".value = removeComma(document.form1.BET01"+i+".value);");
        eval("document.form1.BET02"+i+".value = removeComma(document.form1.BET02"+i+".value);");
        eval("document.form1.BET03"+i+".value = removeComma(document.form1.BET03"+i+".value);");
        eval("document.form1.BET04"+i+".value = removeComma(document.form1.BET04"+i+".value);");
        eval("document.form1.BET05"+i+".value = removeComma(document.form1.BET05"+i+".value);");
        eval("document.form1.BET06"+i+".value = removeComma(document.form1.BET06"+i+".value);");
        eval("document.form1.BET07"+i+".value = removeComma(document.form1.BET07"+i+".value);");
        eval("document.form1.BET08"+i+".value = removeComma(document.form1.BET08"+i+".value);");
        eval("document.form1.BET09"+i+".value = removeComma(document.form1.BET09"+i+".value);");
        eval("document.form1.BET10"+i+".value = removeComma(document.form1.BET10"+i+".value);");
    }

    eval("document.form1.FSTID.disabled = false;") ; //세대주여부
    if( eval("document.form1.FSTID.checked == true") )
        eval("document.form1.FSTID.value ='X';");

    document.form1.jobid.value = "build";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPreWorkSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}


// 전근무지 검색버튼 클릭시 전근무지를 찾는 창이 뜬다.
function fn_openSearch(row){
   small_window=window.open("<%=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustPreWorkSearch.jsp?row="+row,"essPost","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=no,width=370,height=425");
   small_window.focus();
}

function preWorkSearchData(BIZNO,COMNM,row){
   eval("document.form1.BIZNO"+row+".value = '"+BIZNO+"';");
   eval("document.form1.COMNM"+row+".value = '"+COMNM+"';");
}
//@v1.1 사업자번호 명칭검색
function name_search(obj,i)
{
    val1 = obj.value;
    val1 = rtrim(ltrim(val1));

    if ( val1 == "" ) {
        return;
    }
    document.form1.BIZNO.value = val1;
    document.form1.INX.value = i;
    document.form1.target = "ifHidden";
    document.form1.action = "<%=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustPreWorkHiddenName.jsp";
    document.form1.submit();
} // @v1.1 end function

//-->
</SCRIPT>
 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>

<form name="form1" method="post">
    <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

  <!--전근무지 테이블 시작-->
    <div class="listArea">
       <%-- <div class="listTop">
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:add_field();""><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><!-- 추가 --></span></a></li>
                    <li><a href="javascript:remove_field();"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><!-- 삭제 --></span></a></li>
                </ul>
            </div>
        </div>
         --%>
        <div class="table">
            <table  id = "table1" class="listTable">
                <thead>
                    <tr>
  <!--전근무지 테이블 시작-->
            <th rowspan="2"><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></th>
            <th rowspan="2"><spring:message code="LABEL.D.D11.0221" /><!-- 회사이름 --></th>
            <th><spring:message code="LABEL.D.D11.0222" /><!-- 급여 --></th>
            <th><spring:message code="LABEL.D.D11.0223" /><!-- 상여 --></th>
            <th><spring:message code="LABEL.D.D11.0224" /><!-- 해외소득 --></th>
            <th><spring:message code="LABEL.D.D11.0225" /><!-- 생산직비과세 --></th>
            <th class="lastCol"><spring:message code="LABEL.D.D11.0226" /><!-- 기타비과세 --></th>
          </tr>
          <tr>
            <th><spring:message code="LABEL.D.D11.0227" /><!-- 소득세 --></th>
            <th><spring:message code="LABEL.D.D11.0228" /><!-- 주민세 --></th>
            <th><spring:message code="LABEL.D.D11.0229" /><!-- 국민연금 --></th>
            <th><spring:message code="LABEL.D.D11.0230" /><!-- 건강보험료 --></th>
            <th class="lastCol"><spring:message code="LABEL.D.D11.0231" /><!-- 고용보험료 --></th>
          </tr>
          </thead>
<%
    for( int i = 0 ; i < preWork_vt.size() ; i++ ){
        D11TaxAdjustPreWorkData data = (D11TaxAdjustPreWorkData)preWork_vt.get(i);
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td><input type="text" name="BIZNO<%=i%>" value="<%= data.BIZNO %>" size="11" class="input03 " maxlength="20"  style="text-align:center"  onBlur="name_search(this,<%=i%>);"></td>
            <td><input type="text" name="COMNM<%=i%>" value="<%= data.COMNM %>" size="18" class="input03 " maxlength="20"></td>
            <td><input type="text" name="BET01<%=i%>" value="<%= data.BET01.equals("") ? "" : WebUtil.printNumFormat(data.BET01) %>" size="15" maxlength="11"  class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET02<%=i%>" value="<%= data.BET02.equals("") ? "" : WebUtil.printNumFormat(data.BET02) %>" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET03<%=i%>" value="<%= data.BET03.equals("") ? "" : WebUtil.printNumFormat(data.BET03) %>" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET04<%=i%>" value="<%= data.BET04.equals("") ? "" : WebUtil.printNumFormat(data.BET04) %>" size="15" maxlength="11"class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td class="lastCol"><input type="text" name="BET05<%=i%>" value="<%= data.BET05.equals("") ? "" : WebUtil.printNumFormat(data.BET05) %>" size="15" maxlength="11"  class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
          </tr>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td colspan="2">
            <a href="javascript:fn_openSearch(<%=i%>);" class="inlineBtn unloading"><span><!-- 전근무지검색 --><spring:message code="LABEL.D.D11.0262"/></span></a>
            </td>
            <td><input type="text" name="BET06<%=i%>" value="<%= data.BET06.equals("") ? "" : WebUtil.printNumFormat(data.BET06) %>" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET07<%=i%>" value="<%= data.BET07.equals("") ? "" : WebUtil.printNumFormat(data.BET07) %>" size="15" maxlength="11"  class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET08<%=i%>" value="<%= data.BET08.equals("") ? "" : WebUtil.printNumFormat(data.BET08) %>" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET09<%=i%>" value="<%= data.BET09.equals("") ? "" : WebUtil.printNumFormat(data.BET09) %>" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td class="lastCol"><input type="text" name="BET10<%=i%>" value="<%= data.BET10.equals("") ? "" : WebUtil.printNumFormat(data.BET10) %>" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
          </tr>
<%
    }
    for( int i = preWork_vt.size() ; i < preWork_count ; i++ ){
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td><input type="text" name="BIZNO<%=i%>" value="" size="15" class="input03 " maxlength="20"  style="text-align:center" onBlur="name_search(this,<%=i%>);"></td>
            <td><input type="text" name="COMNM<%=i%>" value="" size="19" class="input03 " maxlength="20"></td>
            <td><input type="text" name="BET01<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET02<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET03<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET04<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET05<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
          </tr>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td colspan="2">
<a href="javascript:fn_openSearch(<%=i%>);" class="inlineBtn unloading"><span><!-- 전근무지검색 --><spring:message code="LABEL.D.D11.0262"/></span></a>
            </td>
            <td><input type="text" name="BET06<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET07<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET08<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET09<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
            <td><input type="text" name="BET10<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()"></td>
          </tr>
<%
    }
%>
                </tbody>
            </table>
        </div>
    </div>

        <!--전근무지 테이블 끝-->
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

    <div class="commentImportant" style="width:740px;">
     <p><spring:message code="LABEL.D.D11.0232" arguments="<%= targetYear %>" /><%-- 1. <%= targetYear %>년 자매사 전입자, 경력입사자, 신규입사자 중 전근무지 소득이 있었던 해당자는 전근무지에서 발급받은 --%></p>
     <p>　<spring:message code="LABEL.D.D11.0233" /><!-- 근로소득원천징수영수증에 표시된 각 항목에 대하여 입력 후 저장하시기 바랍니다. --></p>
     <p><spring:message code="LABEL.D.D11.0234" /><!-- 2. 입력시 주의사항 --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0235" /><!-- -. 사업자 번호/회사이름 : 근로소득원천징수영수증의 <b>1.법인명 / 3.사업자등록번호</b> 입력 --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0236" /><!-- -. 근무기간 : 근로소득원천징수영수증의 <b>11.근무기간</b> 입력 --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0237" /><!-- -. 정규급여/상여/인정상여 : 근로소득원천징수영수증의 <b>13.급여 / 14.상여 / 15.인정상여</b> 해당금액 입력 --></p>
     <!-- [CSR ID:3569665] 2017년 연말정산 -->
     <%-- <p>&nbsp;<spring:message code="LABEL.D.D11.0238" /><!-- -. 결정세액 소득세/지방소득세 : 근로소득원천징수영수증의 <b>64.결정세액 소득세/지방소득세</b> 각 해당금액 입력 --></p> --%>
     <p>&nbsp;-. 결정세액 소득세/지방소득세 : 근로소득원천징수영수증의 <b>72. 결정세액 소득세/지방소득세</b> 각 해당금액 입력 </p>
     <%-- <p>&nbsp;<spring:message code="LABEL.D.D11.0239" /><!-- -. 국민연금보험료 : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>국민연금</b> 금액 입력 (또는 32.국민연금보험료공제 금액 입력) --></p> --%>
     <p>&nbsp;-. 국민연금보험료: 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>국민연금</b> 금액 입력 (또는 31. 국민연금보험료공제 금액 입력)</p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0240" /><!-- -. 건강보험료 : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>건강보험</b> 금액 입력 --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0241" /><!-- -. 고용보험 : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>고용보험</b> 금액 입력 --></p>
     <p><spring:message code="LABEL.D.D11.0242" /><!-- 3. 각 항목별 금액 입력 후 전근무지 근로소득원천징수영수증을 첨부하여 주시기 바랍니다. --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0243" /><!-- -. 국민연금/건강보험/고용보험이 근로소득원천징수영수증의 왼쪽하단부분에 표시가 안되어있는 경우 --></p>
     <p>&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0244" /><!-- 근로소득원천징수부도 첨부하여 주시기 바랍니다. --></p>
    </div>

<!-- 숨겨진 필드 -->
  <input type="hidden" name="jobid"         value="">
  <input type="hidden" name="targetYear"    value="<%= targetYear %>">
  <input type="hidden" name="rowCount"      value="<%= preWork_vt.size() %>">
  <input type="hidden" name="preWork_count" value="<%= preWork_count %>">
  <input type="hidden" name="curr_job"      value="build">

  <input type="hidden" name="BIZNO"         value="">
  <input type="hidden" name="INX"           value="">

<!-- 숨겨진 필드 -->
</form>
<iframe name="ifHidden" width="0" height="0" />


<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

