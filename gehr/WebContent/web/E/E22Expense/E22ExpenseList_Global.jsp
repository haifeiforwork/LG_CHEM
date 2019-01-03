<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금/입학축하금                                         */
/*   Program Name : 입학축하금/학자금/장학금 조회                               */
/*   Program ID   : E22ExpenseList.jsp                                          */
/*   Description  : 입학축하금/학자금/장학금 조회                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.Global.E22Expense.*" %>

<%
    WebUserData user             = (WebUserData)session.getAttribute("user");
    Vector E22ExpenseListData_vt = (Vector)request.getAttribute("E22ExpenseListData_vt");
    String paging                = (String)request.getAttribute("page");
    String sortField             = (String)request.getAttribute("sortField");
    String sortValue             = (String)request.getAttribute("sortValue");

    PageUtil pu = null;
    if ( Utils.getSize(E22ExpenseListData_vt) != 0 ) {
      try {
        pu = new PageUtil(E22ExpenseListData_vt.size(), paging , 10, 10 );//Page 관련사항
        Logger.debug.println(this, "page : "+paging);
      } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
      }
    }
%>

<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit() {//입학축하금/학자금/장학금 상세조회 페이지로
    trans_form();
    document.form2.jobid.value = "detail";
    document.form2.action = '<%= WebUtil.JspURL %>E/E22Expense/E22ExpenseDetail.jsp';
    document.form2.method = "get";
    document.form2.submit();
}

function trans_form() {
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

    eval("document.form2.SUBF_TYPE.value  = document.form1.SUBF_TYPE"+command+".value");
    eval("document.form2.STEXT.value      = document.form1.STEXT"+command+".value");
    eval("document.form2.FAMSA.value      = document.form1.FAMSA"+command+".value");
    eval("document.form2.ATEXT.value      = document.form1.ATEXT"+command+".value");
    eval("document.form2.GESC1.value      = document.form1.GESC1"+command+".value");
    eval("document.form2.GESC2.value      = document.form1.GESC2"+command+".value");
    eval("document.form2.ACAD_CARE.value  = document.form1.ACAD_CARE"+command+".value");
    eval("document.form2.TEXT4.value      = document.form1.TEXT4"+command+".value");
    eval("document.form2.FASIN.value      = document.form1.FASIN"+command+".value");
    eval("document.form2.REGNO.value      = document.form1.REGNO"+command+".value");
    eval("document.form2.ACAD_YEAR.value  = document.form1.ACAD_YEAR"+command+".value");
    eval("document.form2.PROP_AMNT.value  = document.form1.PROP_AMNT"+command+".value");
    eval("document.form2.P_COUNT.value    = document.form1.P_COUNT"+command+".value");
    eval("document.form2.ENTR_FIAG.value  = document.form1.ENTR_FIAG"+command+".value");
    eval("document.form2.PAY1_TYPE.value  = document.form1.PAY1_TYPE"+command+".value");
    eval("document.form2.PAY2_TYPE.value  = document.form1.PAY2_TYPE"+command+".value");
    eval("document.form2.PERD_TYPE.value  = document.form1.PERD_TYPE"+command+".value");
    eval("document.form2.HALF_TYPE.value  = document.form1.HALF_TYPE"+command+".value");
    eval("document.form2.PROP_YEAR.value  = document.form1.PROP_YEAR"+command+".value");
    eval("document.form2.LNMHG.value      = document.form1.LNMHG"+command+".value");
    eval("document.form2.FNMHG.value      = document.form1.FNMHG"+command+".value");
    eval("document.form2.PAID_AMNT.value  = document.form1.PAID_AMNT"+command+".value");
    eval("document.form2.YTAX_WONX.value  = document.form1.YTAX_WONX"+command+".value");
    eval("document.form2.RFUN_AMNT.value  = document.form1.RFUN_AMNT"+command+".value");
    eval("document.form2.PAID_DATE.value  = document.form1.PAID_DATE"+command+".value");
    eval("document.form2.BEGDA.value      = document.form1.BEGDA"+command+".value");
    eval("document.form2.ENDDA.value      = document.form1.ENDDA"+command+".value");
    eval("document.form2.BIGO_TEXT1.value = document.form1.BIGO_TEXT1"+command+".value");
    eval("document.form2.BIGO_TEXT2.value = document.form1.BIGO_TEXT2"+command+".value");
    eval("document.form2.RFUN_DATE.value  = document.form1.RFUN_DATE"+command+".value");
    eval("document.form2.RFUN_RESN.value  = document.form1.RFUN_RESN"+command+".value");
    eval("document.form2.WAERS.value      = document.form1.WAERS"+command+".value");
    eval("document.form2.WAERS1.value     = document.form1.WAERS1"+command+".value");
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form3.page.value = page;
  get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
  document.form3.action = '<%= WebUtil.ServletURL %>hris.E.Global.E22Expense.E22ExpenseListSV';
  document.form3.method = "get";
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
</SCRIPT>

   <jsp:include page="/include/body-header.jsp">
       <jsp:param name="click" value="Y"/>
   </jsp:include>
<form name="form1" method="post">

<%
    if( Utils.getSize(E22ExpenseListData_vt) > 0 ) {
%>

    <h2 class="subtitle"><!--Currency--><%=g.getMessage("LABEL.E.COMMON.0001")%>:<%=((E22ExpenseListData)E22ExpenseListData_vt.get(0)).REIM_WAERS %></h2>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
        </div>
        <div class="table">
            <table class="listTable">
            <thead>
              <tr>
                <th onClick="javascript:sortPage('PDATE')" style="cursor:hand"><!--Payment Date--><%=g.getMessage("LABEL.E.E22.0004")%><%= sortField.equals("PDATE") ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                <th onClick="javascript:sortPage('CHLD_NAME')" style="cursor:hand"><!--Name--><%=g.getMessage("LABEL.E.E22.0005")%><%= sortField.equals("CHLD_NAME") ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                <th ><!--School--><%=g.getMessage("LABEL.E.E22.0006")%></th>
                <th ><!--School Type--><%=g.getMessage("LABEL.E.E22.0007")%></th>
                <th ><!--School Name--><%=g.getMessage("LABEL.E.E22.0008")%></th>
                <th ><!--Grade--><%=g.getMessage("LABEL.E.E22.0009")%></th>
    <!--
                <td class="td03" >Entrance Fee</td>
                <td class="td03" >Tuition Fee</td>
                <td class="td03" >Lesson Fee</td>
                <td class="td03" >Attending Fee</td>
                <td class="td03" >Contribution</td>
     -->
                <th><!--Total Payment--><%=g.getMessage("LABEL.E.E22.0010")%></th>
                <th><!--회사 지급--><%=g.getMessage("LABEL.E.E21.0030")%></th>
                <th><!--Approved Date--><%=g.getMessage("LABEL.E.E22.0011")%></th>
                <th class="lastCol" ><!--Refund Amt.--><%=g.getMessage("LABEL.E.E22.0012")%></th>
              </tr>
              </thead>
    <%

        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            E22ExpenseListData data = (E22ExpenseListData)E22ExpenseListData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
                  double currencyDecimalSize  = 2;
                  double currencyDecimalSize1 = 2;
                  int    currencyValue  = 0;
                  int    currencyValue1 = 0;



%>
         <tr class="<%=tr_class%>">
            <td><%=data.PDATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.PDATE)%></td>
            <td><%=data.CHLD_NAME%></td>
            <td><%=data.STEXT%></td>
            <td><%=data.SCHL_TEXT%></td>
            <td><%=data.SCHL_NAME%></td>
            <td><%=data.SCHL_GRAD%></td>
<%--
            <td><%=data.REIM_BET1.equals("0")?"":WebUtil.printNumFormat(data.REIM_BET1,2) /*+" "+ data.REIM_WAR1*/  %></td>
            <td><%=data.REIM_BET2.equals("0")?"":WebUtil.printNumFormat(data.REIM_BET2,2) /*+" "+ data.REIM_WAR2*/  %></td>
            <td><%=data.REIM_BET3.equals("0")?"":WebUtil.printNumFormat(data.REIM_BET3,2) /*+" "+ data.REIM_WAR3*/  %></td>
            <td><%=data.REIM_BET4.equals("0")?"":WebUtil.printNumFormat(data.REIM_BET4,2) /*+" "+ data.REIM_WAR4*/  %></td>
            <td><%=data.REIM_BET5.equals("0")?"":WebUtil.printNumFormat(data.REIM_BET5,2) /*+" "+ data.REIM_WAR5*/  %></td>
--%>
            <td><%=data.REIM_TOTL.equals("0")?"":WebUtil.printNumFormat(data.REIM_TOTL,2) /*+" "+ data.REIM_WAERS*/  %></td>
            <td><%=data.CERT_BETG.equals("0")?"":WebUtil.printNumFormat(data.CERT_BETG,2)  %></td>
            <td><%=data.CERT_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.CERT_DATE)%></td>
            <td class="lastCol"><%=data.RFAMT.equals("0")?"":WebUtil.printNumFormat(data.RFAMT,2) /*+" "+ data.WAERS*/  %></td>
          </tr>

<%
     } //end for

    } else {
%>

    <div class="listArea">
        <div class="table">
            <table class="listTable">
              <tr>
                <th><!--Payment Date--><%=g.getMessage("LABEL.E.E22.0004")%></th>
                <th ><!--Name--><%=g.getMessage("LABEL.E.E22.0005")%></th>
                <th ><!--School--><%=g.getMessage("LABEL.E.E22.0006")%></th>
                <th ><!--School Type--><%=g.getMessage("LABEL.E.E22.0007")%></th>
                <th ><!--School Name--><%=g.getMessage("LABEL.E.E22.0008")%></th>
                <th ><!--Grade--><%=g.getMessage("LABEL.E.E22.0009")%></th>
    <!--
                <th >Entrance Fee</th>
                <th >Tuition Fee</th>
                <th >Lesson Fee</th>
                <th >Attending Fee</th>
                <th >Contribution</th>
    -->
                <th ><!--Total Payment--><%=g.getMessage("LABEL.E.E22.0010")%></th>
                <th><!--회사 지급--><%=g.getMessage("LABEL.E.E21.0030")%></th>
                <th ><!--Approved Date--><%=g.getMessage("LABEL.E.E22.0011")%></th>
                <th class="lastCol"><!--Refund Amt.--><%=g.getMessage("LABEL.E.E22.0012")%></th>
              </tr>
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


</div>


</form>
<form name="form2">
<!-----   hidden field ---------->
    <input type="hidden" name="jobid" value="">

    <input type="hidden" name="SUBF_TYPE"   value="">
    <input type="hidden" name="STEXT"       value="">
    <input type="hidden" name="FAMSA"       value="">
    <input type="hidden" name="ATEXT"       value="">
    <input type="hidden" name="GESC1"       value="">
    <input type="hidden" name="GESC2"       value="">
    <input type="hidden" name="ACAD_CARE"   value="">
    <input type="hidden" name="TEXT4"       value="">
    <input type="hidden" name="FASIN"       value="">
    <input type="hidden" name="REGNO"       value="">
    <input type="hidden" name="ACAD_YEAR"   value="">
    <input type="hidden" name="PROP_AMNT"   value="">
    <input type="hidden" name="P_COUNT"     value="">
    <input type="hidden" name="ENTR_FIAG"   value="">
    <input type="hidden" name="PAY1_TYPE"   value="">
    <input type="hidden" name="PAY2_TYPE"   value="">
    <input type="hidden" name="PERD_TYPE"   value="">
    <input type="hidden" name="HALF_TYPE"   value="">
    <input type="hidden" name="PROP_YEAR"   value="">
    <input type="hidden" name="LNMHG"       value="">
    <input type="hidden" name="FNMHG"       value="">
    <input type="hidden" name="PAID_AMNT"   value="">
    <input type="hidden" name="YTAX_WONX"   value="">
    <input type="hidden" name="RFUN_AMNT"   value="">
    <input type="hidden" name="PAID_DATE"   value="">
    <input type="hidden" name="BEGDA"       value="">
    <input type="hidden" name="ENDDA"       value="">
    <input type="hidden" name="BIGO_TEXT1"  value="">
    <input type="hidden" name="BIGO_TEXT2"  value="">
    <input type="hidden" name="RFUN_DATE"   value="">
    <input type="hidden" name="RFUN_RESN"   value="">
    <input type="hidden" name="WAERS"       value="">
    <input type="hidden" name="WAERS1"      value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page" value="<%= paging %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>

</body>
<jsp:include page="/include/footer.jsp"/>
