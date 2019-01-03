<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 장학자금/입학축하금지원내역                                 */
/*   Program Name : 장학자금/입학축하금지원내역                                 */
/*   Program ID   : E22ExpenseList_m.jsp                                        */
/*   Description  : 입학축하금/학자금/장학금 조회                               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  최영호                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                       2014-10-24  @v.1.2 SJY 신청유형:장학금인 경우에만 시스템 수정   [CSR ID:2634836] 학자금 신청 시스템 개발 요청   */
/*                  2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)     */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E22Expense.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector E22ExpenseListData_vt = (Vector)request.getAttribute("E22ExpenseListData_vt");
    String paging_m                = (String)request.getAttribute("page_m");
    String sortField             = (String)request.getAttribute("sortField");
    String sortValue             = (String)request.getAttribute("sortValue");

    PageUtil pu_m = null;
    if ( E22ExpenseListData_vt != null && E22ExpenseListData_vt.size() != 0 ) {
      try {
        pu_m = new PageUtil(E22ExpenseListData_vt.size(), paging_m , 10, 10 );//Page 관련사항
        Logger.debug.println(this, "page_m : "+paging_m);
      } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
      }
    }

  //[CSR ID:2995203]
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");
%>

<jsp:include page="/include/header.jsp" />

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E22Expense.E22ExpenseListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function doSubmit() {//입학축하금/학자금/장학금 상세조회 페이지로
    trans_form();
    document.form2.jobid.value = "detail";
    document.form2.action = '<%= WebUtil.JspURL %>E/E22Expense/E22ExpenseDetail_m.jsp';
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

    //신청유형:장학금인 경우에만 시스템 수정 START
    eval("document.form2.SCHCODE.value      = document.form1.SCHCODE"+command+".value");
    eval("document.form2.ABRSCHOOL.value      = document.form1.ABRSCHOOL"+command+".value");
    //신청유형:장학금인 경우에만 시스템 수정 END
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page_m){
    document.form3.page_m.value = page_m;
    get_Page2();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page2(){
    document.form3.action = '<%= WebUtil.ServletURL %>hris.E.E22Expense.E22ExpenseListSV_m';
    document.form3.method = "get";
    document.form3.submit();
}

function sortPage( FieldName, FieldValue ){
  if(document.form3.sortField.value==FieldName){
    if(FieldName == 'POST_DATE' || FieldName == 'BEGDA') {
      if(document.form3.sortValue.value == 'desc') {        //최종결재일, 신청일 sort시
        document.form3.sortValue.value = 'asc';
      } else {
        document.form3.sortValue.value = 'desc';
      }
    } else if(FieldName == 'LNMHG,FNMHG,STEXT,POST_DATE') {      //성명 sort시
      if(document.form3.sortValue.value == 'asc,asc,asc,desc') {
        document.form3.sortValue.value = 'desc,desc,asc,desc';
      } else {
        document.form3.sortValue.value = 'asc,asc,asc,desc';
      }
    } else if(FieldName == 'STEXT,LNMHG,FNMHG,POST_DATE') {      //지급유형 sort시
      if(document.form3.sortValue.value == 'asc,asc,asc,desc') {
        document.form3.sortValue.value = 'desc,asc,asc,desc';
      } else {
        document.form3.sortValue.value = 'asc,asc,asc,desc';
      }
    }
  } else {
    document.form3.sortField.value = FieldName;
    document.form3.sortValue.value = FieldValue;
  }
  get_Page2();
}
//-->
</SCRIPT>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="X03PersonInfo.html'"/>
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">
          <%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

<%
    if( E22ExpenseListData_vt.size() > 0 ) {
%>


    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
    	<div class="listTop">
    		<span class="listCnt"><%= pu_m == null ?  "" : pu_m.pageInfo() %></span>
    		<div class="buttonArea">
    			<ul class="btn_mdl clearfix">
    				<li><a href="javascript:doSubmit();"><span><!--조회--><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a></li>
    			</ul>
    		</div>
    	</div>
        <div class="table">
            <table class="listTable">
            <thead>
              <tr>
                <th><!--선택--><%=g.getMessage("LABEL.E.E22.0013")%></th>
                <th onClick="javascript:sortPage('BEGDA','desc')" style="cursor:hand"><!--신청일--><%=g.getMessage("LABEL.E.E22.0014")%><%= sortField.equals("BEGDA") ? ( sortValue.toLowerCase() ).equals("desc")  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                <th onClick="javascript:sortPage('STEXT,LNMHG,FNMHG,POST_DATE','asc,asc,asc,desc')" style="cursor:hand"><!--지급유형 --><%=g.getMessage("LABEL.E.E22.0015")%><%= sortField.equals("STEXT,LNMHG,FNMHG,POST_DATE") ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,desc")  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                <th><!--지급구분--><%=g.getMessage("LABEL.E.E22.0016")%></th>
                <th onClick="javascript:sortPage('LNMHG,FNMHG,STEXT,POST_DATE','asc,asc,asc,desc')" style="cursor:hand"><!--성명--><%=g.getMessage("LABEL.E.E22.0017")%><%= sortField.equals("LNMHG,FNMHG,STEXT,POST_DATE") ? ( sortValue.toLowerCase() ).equals("desc,desc,asc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                <th><!--신청액--><%=g.getMessage("LABEL.E.E22.0018")%></th>
            	<th><!--회사지급액--><%=g.getMessage("LABEL.E.E22.0019")%></th>
                <th class="lastCol" onClick="javascript:sortPage('POST_DATE','desc')" style="cursor:hand"><!--최종결재일--><%=g.getMessage("LABEL.E.E22.0020")%><%= sortField.equals("POST_DATE") ? ( sortValue.toLowerCase() ).equals("desc")              ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
              </tr>
              </thead>
<%
        int k = 0;//내부 카운터용
        for( int i = pu_m.formRow() ; i < pu_m.toRow(); i++ ) {
            E22ExpenseListData data = (E22ExpenseListData)E22ExpenseListData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

//      통화키에 따른 소수자리수를 가져온다
        double currencyDecimalSize  = 2;
        double currencyDecimalSize1 = 2;
        int    currencyValue  = 0;
        int    currencyValue1 = 0;
        Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
        for( int j = 0 ; j < currency_vt.size() ; j++ ) {
            CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
            if( data.WAERS.equals(codeEnt.code) ){
                currencyDecimalSize = Double.parseDouble(codeEnt.value);
            }

            if( data.WAERS1.equals(codeEnt.code) ){
                currencyDecimalSize1 = Double.parseDouble(codeEnt.value);
            }
        }
        currencyValue  = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
        currencyValue1 = (int)currencyDecimalSize1; //???  KRW -> 0, USDN -> 5
//      통화키에 따른 소수자리수를 가져온다


%>
             <tr class="<%=tr_class%>">
                <td>
                  <input type="radio" name="radiobutton" value="<%= k %>" <%=(k==0) ? "checked" : ""%>>
                </td>
                <td><%=data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA)%></td>
                <td><%=data.STEXT%></td>
                <td><%=data.SUBF_TYPE.equals("1") ? "" : data.PAY1_TYPE.equals("X") ? "신규분" : "추가분"%></td>
                <td><%=data.LNMHG%><%=data.FNMHG%></td>
                <td class="align_right"><%= data.SUBF_TYPE.equals("1") ? "" : (WebUtil.printNumFormat(data.PROP_AMNT).equals("0") ? "" : WebUtil.printNumFormat(data.PROP_AMNT,currencyValue)) %>&nbsp;<font color="#006699"><%= WebUtil.printNumFormat(data.PROP_AMNT).equals("0") ? "" : data.WAERS %></font>&nbsp;</td>
                <td class="align_right"><%= WebUtil.printNumFormat(data.PAID_AMNT).equals("0") ? "" : WebUtil.printNumFormat(data.PAID_AMNT,currencyValue1) %>&nbsp;<font color="#006699"><%= WebUtil.printNumFormat(data.PAID_AMNT).equals("0") ? "" : data.WAERS1 %></font>&nbsp;</td>
                <td class="lastCol"><%= data.POST_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.POST_DATE) %></td>
              </tr>
                <input type="hidden" name="SUBF_TYPE<%= k %>"  value="<%= data.SUBF_TYPE %>">
                <input type="hidden" name="STEXT<%= k %>"      value="<%= data.STEXT %>">
                <input type="hidden" name="FAMSA<%= k %>"      value="<%= data.FAMSA %>">
                <input type="hidden" name="ATEXT<%= k %>"      value="<%= data.ATEXT %>">
                <input type="hidden" name="GESC1<%= k %>"      value="<%= data.GESC1 %>">
                <input type="hidden" name="GESC2<%= k %>"      value="<%= data.GESC2 %>">
                <input type="hidden" name="ACAD_CARE<%= k %>"  value="<%= data.ACAD_CARE %>">
                <input type="hidden" name="TEXT4<%= k %>"      value="<%= data.TEXT4 %>">
                <input type="hidden" name="FASIN<%= k %>"      value="<%= data.FASIN %>">
                <input type="hidden" name="REGNO<%= k %>"      value="<%= data.REGNO %>">
                <input type="hidden" name="ACAD_YEAR<%= k %>"  value="<%= data.ACAD_YEAR %>">
                <input type="hidden" name="PROP_AMNT<%= k %>"  value="<%= WebUtil.printNumFormat(data.PROP_AMNT,currencyValue) %>">
                <input type="hidden" name="P_COUNT<%= k %>"    value="<%= WebUtil.printNumFormat(data.P_COUNT) %>">
                <input type="hidden" name="ENTR_FIAG<%= k %>"  value="<%= data.ENTR_FIAG %>">
                <input type="hidden" name="PAY1_TYPE<%= k %>"  value="<%= data.PAY1_TYPE %>">
                <input type="hidden" name="PAY2_TYPE<%= k %>"  value="<%= data.PAY2_TYPE %>">
                <input type="hidden" name="PERD_TYPE<%= k %>"  value="<%= data.PERD_TYPE %>">
                <input type="hidden" name="HALF_TYPE<%= k %>"  value="<%= data.HALF_TYPE %>">
                <input type="hidden" name="PROP_YEAR<%= k %>"  value="<%= data.PROP_YEAR %>">
                <input type="hidden" name="LNMHG<%= k %>"      value="<%= data.LNMHG %>">
                <input type="hidden" name="FNMHG<%= k %>"      value="<%= data.FNMHG %>">
                <input type="hidden" name="PAID_AMNT<%= k %>"  value="<%= WebUtil.printNumFormat(data.PAID_AMNT,currencyValue1) %>">
                <input type="hidden" name="YTAX_WONX<%= k %>"  value="<%= WebUtil.printNumFormat(data.YTAX_WONX) %>">
                <input type="hidden" name="RFUN_AMNT<%= k %>"  value="<%= WebUtil.printNumFormat(data.RFUN_AMNT,currencyValue1) %>">
                <input type="hidden" name="PAID_DATE<%= k %>"  value="<%= data.PAID_DATE %>">
                <input type="hidden" name="BEGDA<%= k %>"      value="<%= data.BEGDA %>">
                <input type="hidden" name="ENDDA<%= k %>"      value="<%= data.ENDDA %>">
                <input type="hidden" name="BIGO_TEXT1<%= k %>" value="<%= data.BIGO_TEXT1 %>">
                <input type="hidden" name="BIGO_TEXT2<%= k %>" value="<%= data.BIGO_TEXT2 %>">
                <input type="hidden" name="RFUN_DATE<%= k %>"  value="<%= data.RFUN_DATE %>">
                <input type="hidden" name="RFUN_RESN<%= k %>"  value="<%= data.RFUN_RESN %>">
                <input type="hidden" name="WAERS<%= k %>"      value="<%= data.WAERS %>">
                <input type="hidden" name="WAERS1<%= k %>"     value="<%= data.WAERS1 %>">

                <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                <input type="hidden" name="SCHCODE<%= k %>"     value="<%= data.SCHCODE %>">
                <input type="hidden" name="ABRSCHOOL<%= k %>"     value="<%= data.ABRSCHOOL %>">
                <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
<%
        k++;
        }
    } else {
%>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
              <tr>
                  <th><!--선택 --><%=g.getMessage("LABEL.E.E22.0013")%></th>
		          <th><!--신청일 --><%=g.getMessage("LABEL.E.E22.0014")%></th>
		          <th><!--지급유형 --><%=g.getMessage("LABEL.E.E22.0015")%></th>
		          <th><!--지급구분 --><%=g.getMessage("LABEL.E.E22.0016")%></th>
		          <th><!--성명 --><%=g.getMessage("LABEL.E.E22.0017")%></th>
		          <th><!--신청액 --><%=g.getMessage("LABEL.E.E22.0018")%></th>
		          <th><!--회사지급액 --><%=g.getMessage("LABEL.E.E22.0019")%></th>
		          <th class="lastCol"><!--최종결재일 --><%=g.getMessage("LABEL.E.E22.0020")%></th>
              </tr>
              <tr class="oddRow">
                <td class="align_center lastCol" colspan="8"><!--해당하는 데이터가 존재하지 않습니다.--><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
              </tr>
<%
    }
%>
            </table>
        </div>

        <!-- PageUtil 관련 - 반드시 써준다. -->
        <div class="align_center">
            <%= pu_m == null ? "" : pu_m.pageControl() %>
        </div>
        <!-- PageUtil 관련 - 반드시 써준다. -->

    </div>
    <!-- 조회 리스트 테이블 끝-->


  <%//[CSR ID:2995203] 보상명세서 용 뒤로가기.
    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
    if (isCanGoList) {  %>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back()"><span><!-- 뒤로가기 --><%=g.getMessage("BUTTON.COMMON.BACK")%></span></a></li>
        </ul>
    </div>

</div>
<%  }  %>
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

    <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
    <input type="hidden" name="SCHCODE"     value="">
    <input type="hidden" name="ABRSCHOOL"     value="">
    <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page_m" value="<%= paging_m %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
<%
}
%>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->