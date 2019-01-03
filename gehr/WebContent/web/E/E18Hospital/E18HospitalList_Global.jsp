<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 조회                                                 */
/*   Program ID   : E18HospitalList.jsp                                         */
/*   Description  : 의료비 조회                                                 */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                  2005-11-09  lsa @v1.1:C2005110201000000339(의료비 조회시 이름포함 )*/
/*                  2006-03-07  lsa @v1.2:주민번호추가*/
/*                  2007-10-05  huang peng xiao globalehr update                */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.Global.E18Hospital.E18HospitalListData" %>

<%
    Vector E18HospitalListData_vt = (Vector)request.getAttribute("E18HospitalListData_vt") ;
    String paging                 = (String)request.getAttribute("page" ) ;
    String sortField              = (String)request.getAttribute("sortField");
    String sortValue              = (String)request.getAttribute("sortValue");

    double COMP_sum               = 0.0;

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null ;
    if ( E18HospitalListData_vt != null && E18HospitalListData_vt.size() != 0 ) {
        try {
            pu = new PageUtil( E18HospitalListData_vt.size(), paging , 10, 10 ) ;
            Logger.debug.println( this, "page : " + paging ) ;
        } catch( Exception ex ) {
            Logger.debug.println( DataUtil.getStackTrace( ex ) ) ;
        }
    }
%>

<jsp:include page="/include/header.jsp" />

<script language="javascript">
<!--
function goDetail(){
    arguSetting() ;
    document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E18Hospital.E18HospitalDetailSV' ;
    document.form2.method = 'post' ;
    document.form2.submit() ;
}

function arguSetting(){
    var command = "";
    var size = "";

    if( isNaN( document.form1.radiobutton.length ) ){
      size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }

    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = document.form1.radiobutton[i].value;
        }
    }
    eval("document.form2.CTRL_NUMB.value  = document.form1.CTRL_NUMB" +command+".value ;");
    eval("document.form2.GUEN_CODE.value  = document.form1.GUEN_CODE" +command+".value ;");

    chk = eval("document.form1.PROOF" +command+".value");

    if( chk ) {
        document.form2.PROOF.value        = "X";
    } else {
        document.form2.PROOF.value        = "";
    }

    eval("document.form2.ENAME.value      = document.form1.ENAME" +command+".value ;"); //@v1.1
    eval("document.form2.SICK_NAME.value  = document.form1.SICK_NAME" +command+".value ;");
    eval("document.form2.SICK_DESC1.value = document.form1.SICK_DESC1"+command+".value ;");
    eval("document.form2.SICK_DESC2.value = document.form1.SICK_DESC2"+command+".value ;");
    eval("document.form2.SICK_DESC3.value = document.form1.SICK_DESC3"+command+".value ;");
    eval("document.form2.EMPL_WONX.value  = document.form1.EMPL_WONX" +command+".value ;");
    eval("document.form2.COMP_WONX.value  = document.form1.COMP_WONX" +command+".value ;");
    eval("document.form2.YTAX_WONX.value  = document.form1.YTAX_WONX" +command+".value ;");
    eval("document.form2.BIGO_TEXT1.value = document.form1.BIGO_TEXT1"+command+".value ;");
    eval("document.form2.BIGO_TEXT2.value = document.form1.BIGO_TEXT2"+command+".value ;");
    eval("document.form2.WAERS.value      = document.form1.WAERS"     +command+".value ;");
    eval("document.form2.RFUN_DATE.value  = document.form1.RFUN_DATE" +command+".value ;");
    eval("document.form2.RFUN_RESN.value  = document.form1.RFUN_RESN" +command+".value ;");
    eval("document.form2.RFUN_AMNT.value  = document.form1.RFUN_AMNT" +command+".value ;");
    eval("document.form2.TREA_CODE.value  = document.form1.TREA_CODE" +command+".value ;");
    eval("document.form2.TREA_TEXT.value  = document.form1.TREA_TEXT" +command+".value ;");
    eval("document.form2.REGNO.value      = document.form1.REGNO" +command+".value ;");

// 해당연도만 계산되도록 수정. 2004.02.12 mkbae.
    var tyear = eval("document.form1.CTRL_NUMB" +command+".value.substring(0,4) ;");
    var tguen = eval("document.form1.GUEN_CODE" +command+".value ;");
    var tcom = 0.0;
<%
// 배우자일 경우 회사지원총액을 보여주기 위해서 총액을 계산한다.
    //for ( int i = 0 ; i < E18HospitalListData_vt.size() ; i++ ) {
    //  E18HospitalListData data = ( E18HospitalListData ) E18HospitalListData_vt.get( i ) ;
%>
      /*if( tguen=="<%//= data.GUEN_CODE%>" && "<%//= data.GUEN_CODE%>"=="0002" && tyear=="<%//= data.CTRL_NUMB.substring(0,4)%>" ) {
          tcom += <%//= Double.parseDouble( data.COMP_WONX )%>;
      }*/
<%
   // }
%>
      document.form2.COMP_sum.value = tcom;
} // 2004.02.12

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form3.page.value = page;
//doSubmit();
  get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
  document.form3.action = '<%= WebUtil.ServletURL %>hris.E.Global.E18Hospital.E18HospitalListSV';
  document.form3.method = 'post';
  document.form3.submit();
}

function sortPage( FieldName ){
  if(document.form3.sortField.value==FieldName){
    if(document.form3.sortValue.value=='desc'){
      document.form3.sortValue.value = 'asc';
    } else {
      document.form3.sortValue.value = 'desc';
    }
  } else {
    document.form3.sortField.value = FieldName;
    document.form3.sortValue.value = 'desc';
  }
  get_Page();
}
//-->
</script>

   <jsp:include page="/include/body-header.jsp">
       <jsp:param name="click" value="Y"/>
   </jsp:include>
<form name="form1" method="post">

<%
    if( Utils.getSize(E18HospitalListData_vt) > 0 ) {
%>

    <h2 class="subtitle"><!--Currency--><%=g.getMessage("LABEL.E.COMMON.0001")%>:<%=(( E18HospitalListData ) E18HospitalListData_vt.get(0)).WAERS %></h2>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
        </div>
        <div class="table">
            <table class="listTable">
            <thead>
              <tr>
                <th><!--Payment Date--><%=g.getMessage("LABEL.E.E18.0011")%></th>
                <th><!--Medical Type--><%=g.getMessage("LABEL.E.E18.0012")%></th>
                <th><!--Name--><%=g.getMessage("LABEL.E.E18.0004")%></th><!--@v1.1-->
                <th onClick="javascript:sortPage('EXDATE')" style="cursor:hand"><!--Examination Date--><%=g.getMessage("LABEL.E.E18.0005")%><%= sortField.equals("EXDATE") ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                <th><!--Disease Name--><%=g.getMessage("LABEL.E.E18.0006")%></th>
                <th><!--Medical Expens--><%=g.getMessage("LABEL.E.E18.0007")%></th>
                <th><!--Payment Amount--><%=g.getMessage("LABEL.E.E21.0030")%></th>
                <th><!--Approved Date--><%=g.getMessage("LABEL.E.E18.0009")%></th>
                <th class="lastCol"><!--Refund Amt.--><%=g.getMessage("LABEL.E.E18.0010")%></th>
                <%--
                <td class="td03" width="90" onClick="javascript:sortPage('POST_DATE')" style="cursor:hand"><%= sortField.equals("POST_DATE") ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></td>
                --%>
              </tr>
              </thead>
<%
        int k = 0;//내부 카운터용
        for ( int i = pu.formRow() ; i < pu.toRow() ; i++ ) {
            E18HospitalListData data = ( E18HospitalListData ) E18HospitalListData_vt.get( i ) ;

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

//  통화키에 따른 소수자리수를 가져온다
            double currencyDecimalSize = 2;
            int    currencyValue = 0;
            /*Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
            for( int j = 0 ; j < currency_vt.size() ; j++ ) {
                CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
                if( data.WAERS.equals(codeEnt.code) ){
                    currencyDecimalSize = Double.parseDouble(codeEnt.value);
                }
            }
            currencyValue = (int)currencyDecimalSize;*/ //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다
%>
          <tr class="<%=tr_class%>">
            <td><%= data.PDATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.PDATE) %></td>
            <td><%= data.MTEXT %></td>
            <td><%= data.ENAME %></td><!--@v1.1-->
            <td><%= data.EXDATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.EXDATE) %></td>
            <td ><%= data.DISEASE  %></td>
            <td class="align_right"><%= data.EXPENSE.equals("0")? "" :WebUtil.printNumFormat(data.EXPENSE,2)  %></td>
            <td class="align_right"><%= data.CERT_BETG.equals("0")? "" :WebUtil.printNumFormat(data.CERT_BETG,2)  %></td>
            <td><%= data.CERT_DATE.replace("-","").replace(".","").equals("00000000") ? "" : WebUtil.printDate(data.CERT_DATE) %></td>
            <td class="lastCol"><%= data.RFAMT.equals("0")?"":WebUtil.printNumFormat(data.RFAMT,2)  %></td>
          </tr>
<%
        k++;
        }
    } else {
%>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
              <thead>
              <tr>
                <th><!--Payment Date--><%=g.getMessage("LABEL.E.E18.0011")%></th>
                <th><!--Medical Type--><%=g.getMessage("LABEL.E.E18.0012")%></th>
                <th><!--Name--><%=g.getMessage("LABEL.E.E18.0004")%></th><!--@v1.1-->
                <th><!--Examination Date--><%=g.getMessage("LABEL.E.E18.0005")%></th>
                <th><!--Disease Name--><%=g.getMessage("LABEL.E.E18.0006")%></th>
                <th><!--Medical Expense--><%=g.getMessage("LABEL.E.E18.0007")%></th>
                <th><!--Payment Amount--><%=g.getMessage("LABEL.E.E21.0030")%></th>
                <th><!--Approved Date--><%=g.getMessage("LABEL.E.E18.0009")%></th>
                <th class="lastCol"><!--Refund Amt.--><%=g.getMessage("LABEL.E.E18.0010")%></th>
              </tr>
              </thead>
              <tr class="oddRow">
                <td class="lastCol" colspan="10"><!--No data--><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
              </tr>
<%
    }
%>
            </table>
            <div class="align_center">
                <%= pu == null ? "" : pu.pageControl() %>
            </div>
        </div>
    </div>
    <!-- 조회 리스트 테이블 끝-->

</div>
</form>
<form name="form2">
<!-----   hidden field ---------->
  <input type="hidden" name="CTRL_NUMB"  value="">
  <input type="hidden" name="GUEN_CODE"  value="">
  <input type="hidden" name="PROOF"      value="">
  <input type="hidden" name="ENAME"      value="">
  <input type="hidden" name="SICK_NAME"  value="">
  <input type="hidden" name="SICK_DESC1" value="">
  <input type="hidden" name="SICK_DESC2" value="">
  <input type="hidden" name="SICK_DESC3" value="">
  <input type="hidden" name="EMPL_WONX"  value="">
  <input type="hidden" name="COMP_WONX"  value="">
  <input type="hidden" name="YTAX_WONX"  value="">
  <input type="hidden" name="BIGO_TEXT1" value="">
  <input type="hidden" name="BIGO_TEXT2" value="">
  <input type="hidden" name="WAERS"      value="">
  <input type="hidden" name="RFUN_DATE"  value="">
  <input type="hidden" name="RFUN_RESN"  value="">
  <input type="hidden" name="RFUN_AMNT"  value="">
  <input type="hidden" name="COMP_sum"   value="">
  <input type="hidden" name="TREA_CODE"  value="">
  <input type="hidden" name="TREA_TEXT"  value="">
  <input type="hidden" name="REGNO"  value=""><!--@v1.2-->
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page"      value="<%= paging %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
</body>
<jsp:include page="/include/footer.jsp"/>
