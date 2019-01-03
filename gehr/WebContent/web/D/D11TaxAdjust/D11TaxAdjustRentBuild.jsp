<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustRentBuild.jsp                                    */
/*   Description  : 월세공제 입력 및 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-12-03 lsa                                              */
/*   Update       : 2013-11-25  CSR ID:2013_9999 2013년말정산반영               */
/*                  임대인성명, 임대인주민등록번호, 입대차계약서 상 주소지  추가 */
/*                  2014-12-03 @2014 연말정산 주택유형 주택계약면적 추가                                                            */
/*   				 2018/01/07 rdcamel [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건*/
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
    Vector rent_vt     = (Vector)request.getAttribute("rent_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String rowCount   = (String)request.getAttribute("rowCount" );
    String Gubn = "Tax12";
    int rent_count = 8;

    if( rent_vt.size() > rent_count ) {
        rent_count = rent_vt.size();
    }
    if ( Integer.parseInt(rowCount) != 8  ) {
        rent_count = Integer.parseInt(rowCount);
    }
    //부양가족체크
    Vector person_vt  = new Vector();
    D11TaxAdjustPersonRFC    rfcP   = new D11TaxAdjustPersonRFC();
    person_vt = rfcP.getPerson( user.empNo, targetYear );

    double Gibonhap = 0.0;

    for( int i = 0 ; i < person_vt.size() ; i++ ){
       D11TaxAdjustPersonData data = (D11TaxAdjustPersonData)person_vt.get(i);
       if (!data.STEXT.equals("본인")&&!data.STEXT.equals("합계")){ //본인이 아니면
          Gibonhap+=Double.parseDouble(data.BETRG01);
       }
    }
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

// 월세 - 신청
function do_build() {
    var row=0;
    /* @2014 연말정산
    if (document.form1.FSTID.checked != true) {
        alert("월세공제는 세대주이어야 합니다.\n세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
        return;
    } */

    //if (<%=Gibonhap%> <= 0) {
    //    alert("월세공제는 부양가족이 등록되어 있는 경우만 가능합니다.\n");
    //    return;
    //}
    for( var i = 0 ; i < "<%= rent_count %>" ; i++ ) {
        if(checkMaxNum( eval("document.form1.FLRAR_"+i))) return ;
        LDNAM = eval("removePoint(document.form1.LDNAM_"+i+".value)"); //임대인성명
        LDREG = eval("removePoint(document.form1.LDREG_"+i+".value)"); //등록번호
        ADDRE = eval("removePoint(document.form1.ADDRE_"+i+".value)"); //주소지

        RCBEG = eval("removePoint(document.form1.RCBEG_"+i+".value)");
        RCEND = eval("removePoint(document.form1.RCEND_"+i+".value)");
        NAM01 = eval("document.form1.NAM01_"+i+".value");

        HOUTY = eval("document.form1.HOUTY_"+i+".value"); //@2014 연말정산 주택유형
        FLRAR = eval("document.form1.FLRAR_"+i+".value"); //@2014 연말정산 주택계약면적

        RCBEGYear = RCBEG.substring(0,4);
        RCENDYear = RCEND.substring(0,4);
        if ( LDNAM != "" ||LDREG != "" || ADDRE != "" ||  RCBEG != "" ||RCEND != "" || NAM01 != "" || HOUTY != "" || FLRAR != "") {

             if ( LDNAM == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0088' />"); //임대인성명은 필수 항목입니다.
                 eval("document.form1.LDNAM_"+i+".focus()");
                 return;
             }

             if ( LDREG == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0089' />");//등록번호는 필수 항목입니다.
                 eval("document.form1.LDREG_"+i+".focus()");
                 return;
             }

             if ( ADDRE == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0090' />"); //주소지는 필수 항목입니다.
                 eval("document.form1.ADDRE_"+i+".focus()");
                 return;
             }
              //@2014 연말정산 추가
              if ( HOUTY == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0091' />"); //주택유형은 필수 항목입니다.
                 eval("document.form1.HOUTY_"+i+".focus()");
                 return;
             }

             //[CSR ID:3569665] 2017년 연말정산 고시원은 면적 필수 제외
             var gosiwonYN = eval("document.form1.HOUTY_"+i+"[document.form1.HOUTY_"+i+".selectedIndex].value;");
              if ( FLRAR == "" && gosiwonYN != 7 ) {
                 alert("<spring:message code='MSG.D.D11.0092' />"); //주택계약면적은 필수 항목입니다.
                 eval("document.form1.FLRAR_"+i+".focus()");
                 return;
             }
             //@2014 연말정산 추가 끝
             if ( RCBEG == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0093' />"); //계약시작일은 필수 항목입니다.
                 eval("document.form1.RCBEG_"+i+".focus()");
                 return;
             }
             if ( RCEND == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0094' />"); //계약종료일은 필수 항목입니다.
                 eval("document.form1.RCEND_"+i+".focus()");
                 return;
             }
             if ( RCBEG  >= RCEND ) {
                 alert("<spring:message code='MSG.D.D11.0095' />"); //계약시작일은 계약종료일보다 이전으로 입력하여야 합니다.
                 eval("document.form1.RCEND_"+i+".focus()");
                 return;
             }
             if (RCBEGYear >  RCENDYear ) {
                 alert("<spring:message code='MSG.D.D11.0096' />"); //계약시작 년도를 확인하세요.
                 eval("document.form1.RCEND_"+i+".focus()");
                 return;
             }
             if (RCBEGYear>"<%=targetYear%>" ||  RCENDYear <"<%=targetYear%>") {
                 alert("<spring:message code='MSG.D.D11.0097' arguments='<%=targetYear%>' />"); <%-- 계약년도는 [<%=targetYear%>]년도가 포함되어야 합니다. --%>
                 eval("document.form1.RCEND_"+i+".focus()");
                 return;
             }
             if ( NAM01 == ""  ) {
                 alert("<spring:message code='MSG.D.D11.0044' />"); //금액은 필수 항목입니다.
                 eval("document.form1.NAM01_"+i+".focus()");
                 return;
             }

        }

    }

    for( var i = 0 ; i < "<%= rent_count %>" ; i++ ) {
        eval("document.form1.RCBEG_"+i+".value  = removePoint(document.form1.RCBEG_"+i+".value);");
        eval("document.form1.RCEND_"+i+".value  = removePoint(document.form1.RCEND_"+i+".value);");
        eval("document.form1.NAM01_"+i+".value  = removeComma(document.form1.NAM01_"+i+".value);");
        /* <!--CSR ID:2013_9999 2013 등록번호--> */
        eval("document.form1.LDREG_"+i+".value  = removebar(document.form1.LDREG_"+i+".value);");
        //@2014 연말정산 추가
        if(eval("document.form1.RCBEG_"+i+".value") != ""){
            eval("document.form1.HOSTX_"+i+".value  =  document.form1.HOUTY_"+i+"[document.form1.HOUTY_"+i+".selectedIndex].text;");
            eval("document.form1.FLRAR_"+i+".value  = removeComma(document.form1.FLRAR_"+i+".value);");
        }
        row++;
    }
    if (row==0 ) {
        alert("<spring:message code='MSG.D.D11.0098' />"); //저장할 data가 없습니다
        return;
    }else{
    	
    	
    	eval("document.form1.FSTID.disabled = false;") ; //세대주여부
        if( eval("document.form1.FSTID.checked == true") )
            eval("document.form1.FSTID.value ='X';");
    	
    document.form1.jobid.value = "build";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustRentSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
    }
}

 function fn_openCal(Objectname, moreScriptFunction){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?moreScriptFunction="+moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    small_window.focus();
}
function after_remainSetting(){
   // remainSetting(document.form1.APPL_FROM);
}
function remainSetting(obj) {
    if( obj.value != "" && dateFormat(obj) ) {
        document.form3.APPL_FROM.value = removePoint(obj.value);
    }
}
//CSR ID:2013_9999
function resno_chk(obj){
    if( chkResnoObj_1(obj) == false ) {
        return false;
    }
}

    //전체 공통 이벤트 적용
    $(document).ready(function(){

        //체크박스가 선택될 때 값 세팅 function
        $(':checkbox').click(function(){
            var nm = this.name;
            var nm1 = nm.split('_')[0];
            var nm2 = nm.split('_')[1];
            if(nm1!="chkedit"){ //선택 체크박스는 제외:삭제 시 값이 셋팅되어야함
            //reset()
            $("input[name=LDNAM_"+nm2 + "]").val('');
            $("input[name=LDREG_"+ nm2 + "]").val('');
            $("input[name=ADDRE_"+ nm2 + "]").val('');
            $("input[name=RCBEG_"+ nm2 + "]").val('');
            $("input[name=RCEND_"+ nm2 + "]").val('');
            $("input[name=NAM01_"+ nm2 + "]").val('');

            $("input[name=FLRAR_"+ nm2 + "]").val(''); //@2014 연말정산
            $("select[name=HOUTY_"+ nm2 + "]").val(''); //@2014 연말정산
            }
        });

        //select change
        $('select').change(function(){
            var nm = this.name;
            var nm1 = nm.split('_')[0];
        });
    });


</SCRIPT>
 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include><form name="form1" method="post">


    <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

    <!--특별공제 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table  id = "table1" class="listTable">
                <colgroup>
                    <col width="5%" />
                    <col width="5%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="20%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="10%" />
                </colgroup>
                <thead>
                    <tr>
                      <th><spring:message code="LABEL.D.D11.0046" /><!-- 삭제 --></th><!--CSR ID:2013_9999 2013-->
                      <th><spring:message code="LABEL.D.D11.0199" /><!-- 유형 --></th><!--CSR ID:2013_9999 2013-->
                      <th><spring:message code="LABEL.D.D11.0252" /><!-- 임대인성명 --></th><!--CSR ID:2013_9999 2013-->
                      <th>임대인 주민등록번호<!-- 등록번호 --></th><!--CSR ID:2013_9999 2013--><!-- LABEL.D.D11.0291 로 변경 필요-->
                      <th><spring:message code="LABEL.D.D11.0254" /><!-- 임대계약서 상 주소지 --></th><!--CSR ID:2013_9999 2013-->
                      <th><spring:message code="LABEL.D.D11.0255" /><!-- 주택유형 --></th><!--@2014 연말정산 주택유형 주택계약면적추가 -->
                      <th><spring:message code="LABEL.D.D11.0256" /><!-- 주택계약면적(m²) --></th><!--@2014 연말정산 주택유형 주택계약면적추가 -->
                      <th><spring:message code="LABEL.D.D11.0257" /><!-- 계약시작일 --></th>
                      <th><spring:message code="LABEL.D.D11.0258" /><!-- 계약종료일 --></th>
                      <th class="lastCol"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                    </tr>
                </thead>
                <tbody>
<%
    for( int i = 0 ; i < rent_count ; i++ ){

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>
        <tr class="<%=tr_class%>">
          <td><!--CSR ID:2013_9999 2013 주소지-->
              <input type="checkbox" name="delCheck_<%= i %>" value="">
          </td>
      <!--CSR ID:2013_9999 2013-->
              <input type="hidden" name="PNSTX_<%= i %>" value="월세">
          <td><!--CSR ID:2013_9999 2013 주소지-->
              <select name="PNSTY_<%=i%>">
                <option value="01"><spring:message code="LABEL.D.D11.0259" /><!-- 월세 --></option>
              </select>
          </td>
          <td><!--CSR ID:2013_9999 2013 임대인성명-->
            <input type="text" name="LDNAM_<%= i %>" value="" size="13" maxlength=20>
          </td>
          <td><!--CSR ID:2013_9999 2013 등록번호-->
            <input type="text" name="LDREG_<%= i %>" value="" size="14" maxlength=14 onBlur="javascript:resno_chk(this);" >
          </td>
          <td><!--CSR ID:2013_9999 2013 주소지-->
            <input type="text" name="ADDRE_<%= i %>" value="" size="30" maxlength=100>
          </td><!--코드 CSR ID:1361257-->
          <td><!--@2014 연말정산 주택유형 text/code 추가-->
          <select style="width=80px" name="HOUTY_<%= i %>" >
             <option value="">-------------</option>
    <%= WebUtil.printOption((new D11TaxAdjustRentTypeRFC()).getRentType()) %>
            </select>
            <input type="hidden" name="HOSTX_<%= i %>" value="" size="30" maxlength=100 >
          </td>
          <td><!--@2014 연말정산 주택면적 추가-->
            <input style="width=100px" style="text-align:right" type="text" name="FLRAR_<%= i %>" value="" size="30" maxlength=6  onKeyUp="javascript:checkMaxNum(this);">
          </td>
          <td nowrap>
            <input type="text" name="RCBEG_<%= i %>" value="" class="date" onchange="javascript:dateFormat(this);">
          </td>
          <td nowrap>
            <input type="text" name="RCEND_<%= i %>"  value=""  class="date" onchange="javascript:dateFormat(this);">
          </td>
          <td class="lastCol">
            <input type="text" name="NAM01_<%= i %>" value="" size="20" maxlength="11"  onKeyUp="javascript:moneyChkEventForWon(this);"  style="text-align:right" onFocus="this.select()">
          </td>
        </tr>
<%
    }
%>
                </tbody>
            </table>
        </div>
        <!-- [CSR ID:3569665] 2017년 연말정산 문구 삭제 요청으로 주석처리 -->
        <%-- <span class="commentOne"><spring:message code="LABEL.D.D11.0260" /><!-- 금액은 계약기간에 납부한 월세액 총액을 입력해야 함 --></span> --%>
 </div>
 <!-- [CSR ID:3569665] -->
	<div class="commentImportant" style="width:700px;">
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <p>1. 공제요건</p>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;-.  12.31 현재 무주택 세대의 세대주 또는 세대원 이며, 총 급여액이 7,000만원 이하</p>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;-. 본인 또는 기본공제대상자 (배우자/부양가족) 명의로 임대차계약을 체결하고, 본인이 지급한 월세액</p>
        <p>2. 공제금액 : 월세액 (연 750만원 한도) X 10%</p>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;-. 임대차계약서와 주민등록 등본 주소지가 같을 것</p>
        <p>3. 제출서류 : 주민등록등본, 월세 지급증명서류(현금영수증, 계좌이체 영수증 등), 임대차 계약증서 사본</p>
        <p>4. 계약 시작일 종료일 : 2017.01.01~2017.12.31 사이 근무기간 중 전입기간에  임차한 기간을 입력</p>
        <p>5. 금액 : 2017.01.01~2017.12.31 사이 근무기간 중 전입기간 중 임차기간에  납부한 월세액 총액을 입력. (③기간에 납입한 금액)</p>
    </div>


    <!--특별공제 테이블 끝-->

<%
    if(  !o_flag.equals("X") ) {
%>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:do_build();" class="darken"><span><spring:message code="LABEL.D.D11.0073" /><!-- 입력 --></span></a></li>
        </ul>
    </div>

<%
    }
%>
<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<input type="hidden" name="rowCount"   value="<%= rent_vt.size() %>">
<input type="hidden" name="rent_count" value="<%= rent_count %>">
<input type="hidden" name="curr_job" value="change">
<!-- input type="hidden" name="HOUTY"     value="">  -->
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->