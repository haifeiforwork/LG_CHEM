<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 의료비지원내역                                              */
/*   Program Name : 의료비지원내역                                              */
/*   Program ID   : E18HospitalList_m.jsp                                       */
/*   Description  : 사원의 의료비 내역을 조회                                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  한성덕                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                  2005-11-09  lsa @v1.1:C2005110201000000339(의료비 조회시 이름포함 )*/
/*                  2006-03-07  lsa @v1.2:주민번호추가*/
/*                                                                              */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                  2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)     */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E18Hospital.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector E18HospitalListData_vt = (Vector)request.getAttribute("E18HospitalListData_vt") ;
    String paging_m    = (String)request.getAttribute("page_m" ) ;
    String sortField = (String)request.getAttribute("sortField");
    String sortValue = (String)request.getAttribute("sortValue");
    double COMP_sum  = 0.0;

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu_m = null ;
    if ( E18HospitalListData_vt != null && E18HospitalListData_vt.size() != 0 ) {
        try {
            pu_m = new PageUtil( E18HospitalListData_vt.size(), paging_m , 10, 10 ) ;
            Logger.debug.println( this, "page_m : " + paging_m ) ;
        } catch( Exception ex ) {
            Logger.debug.println( DataUtil.getStackTrace( ex ) ) ;
        }
    }

    //[CSR ID:2995203]
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");

%>

<jsp:include page="/include/header.jsp" />
<script language="javascript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E18Hospital.E18HospitalListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function goDetail(){
    arguSetting() ;
    document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E18Hospital.E18HospitalDetailSV_m' ;
    document.form2.method = 'get' ;
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

    eval("document.form2.ENAME.value      = document.form1.ENAME"     +command+".value ;"); //@v1.1
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
    for ( int i = 0 ; i < E18HospitalListData_vt.size() ; i++ ) {
      E18HospitalListData data = ( E18HospitalListData ) E18HospitalListData_vt.get( i ) ;
%>
      if( tguen=="<%= data.GUEN_CODE%>" && "<%= data.GUEN_CODE%>"=="0002" && tyear=="<%= data.CTRL_NUMB.substring(0,4)%>" ) {
          tcom += <%= Double.parseDouble( data.COMP_WONX )%>;
      }
<%
    }
%>
      document.form2.COMP_sum.value = tcom;
} // 2004.02.12

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page_m){
    document.form3.page_m.value = page_m;
//  doSubmit();
    get_Page2();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page2(){
    document.form3.action = '<%= WebUtil.ServletURL %>hris.E.E18Hospital.E18HospitalListSV_m';
    document.form3.method = 'get';
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
    get_Page2();
}
//-->
</script>

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
    if( E18HospitalListData_vt.size() > 0 ) {
%>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu_m == null ?  "" : pu_m.pageInfo() %></span>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:goDetail();"><span><!--조회--><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a></li>
                </ul>
            </div>
        </div>
        <div class="table">
            <table class="listTable">
            <thead>
                <tr>
                  <th><!--선택--><%=g.getMessage("LABEL.E.E18.0014")%></th>
                  <th onClick="javascript:sortPage('BEGDA')" style="cursor:hand"><!--신청일--><%=g.getMessage("LABEL.E.E18.0015")%><%= sortField.equals("BEGDA") ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                  <th><!--관리번호--><%=g.getMessage("LABEL.E.E18.0016")%></th>
		          <th><!--구분--><%=g.getMessage("LABEL.E.E18.0017")%></th>
		          <th><!--성명--><%=g.getMessage("LABEL.E.E18.0004")%></th><!--@v1.1-->
		          <th><!--상병명--><%=g.getMessage("LABEL.E.E18.0006")%></th>
		          <th><!--본인 납부액--><%=g.getMessage("LABEL.E.E18.0018")%></th>
		          <th><!--회사 지원액--><%=g.getMessage("LABEL.E.E18.0019")%></th>
                  <th class="lastCol" onClick="javascript:sortPage('POST_DATE')" style="cursor:hand"><!--최종결재일--><%=g.getMessage("LABEL.E.E18.0020")%><%= sortField.equals("POST_DATE") ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                </tr>
                </thead>
<%
        int k = 0;//내부 카운터용
        for ( int i = pu_m.formRow() ; i < pu_m.toRow() ; i++ ) {
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
            Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
            for( int j = 0 ; j < currency_vt.size() ; j++ ) {
                CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
                if( data.WAERS.equals(codeEnt.code) ){
                    currencyDecimalSize = Double.parseDouble(codeEnt.value);
                }
            }
            currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다
%>
                <tr class="<%=tr_class%>">
                  <td>
                    <input type="radio"  name="radiobutton" value="<%= k %>" <%=(k==0) ? "checked" : ""%>>
                    <input type="hidden" name="CTRL_NUMB<%= k %>"  value="<%= data.CTRL_NUMB  %>">
                    <input type="hidden" name="GUEN_CODE<%= k %>"  value="<%= data.GUEN_CODE  %>">
                    <input type="hidden" name="PROOF<%= k %>"      value="<%= data.PROOF  %>">
                    <input type="hidden" name="ENAME<%= k %>"      value="<%= data.ENAME  %>"><!--@v1.1-->
                    <input type="hidden" name="SICK_NAME<%= k %>"  value="<%= data.SICK_NAME  %>">
                    <input type="hidden" name="SICK_DESC1<%= k %>" value="<%= data.SICK_DESC1 %>">
                    <input type="hidden" name="SICK_DESC2<%= k %>" value="<%= data.SICK_DESC2 %>">
                    <input type="hidden" name="SICK_DESC3<%= k %>" value="<%= data.SICK_DESC3 %>">
                    <input type="hidden" name="EMPL_WONX<%= k %>"  value="<%= data.EMPL_WONX  %>">
                    <input type="hidden" name="COMP_WONX<%= k %>"  value="<%= data.COMP_WONX  %>">
                    <input type="hidden" name="YTAX_WONX<%= k %>"  value="<%= data.YTAX_WONX  %>">
                    <input type="hidden" name="BIGO_TEXT1<%= k %>" value="<%= data.BIGO_TEXT1 %>">
                    <input type="hidden" name="BIGO_TEXT2<%= k %>" value="<%= data.BIGO_TEXT2 %>">
                    <input type="hidden" name="WAERS<%= k %>"      value="<%= data.WAERS      %>">
                    <input type="hidden" name="RFUN_DATE<%= k %>"  value="<%= data.RFUN_DATE  %>">
                    <input type="hidden" name="RFUN_RESN<%= k %>"  value="<%= data.RFUN_RESN  %>">
                    <input type="hidden" name="RFUN_AMNT<%= k %>"  value="<%= data.RFUN_AMNT  %>">
                    <input type="hidden" name="TREA_CODE<%= k %>"  value="<%= data.TREA_CODE  %>">
                    <input type="hidden" name="TREA_TEXT<%= k %>"  value="<%= data.TREA_TEXT  %>">
                    <input type="hidden" name="REGNO<%= k %>"  value="<%= data.REGNO  %>"><!--@v1.2-->
                  </td>
                  <td><%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %></td>
                  <td><%= data.CTRL_NUMB %></td>
                  <td><%= data.GUEN_CODE.equals("0001") ? "본인" : data.GUEN_CODE.equals("0002") ? "배우자" : "자녀" %></td>
                  <td><%= data.ENAME %></td><!--@v1.1-->
                  <td><%= data.SICK_NAME %></td>
                  <td class="align_right"><%= WebUtil.printNumFormat(data.EMPL_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.EMPL_WONX,currencyValue) %>&nbsp;<font color="#006699"><%= WebUtil.printNumFormat(data.EMPL_WONX).equals("0") ? "" : data.WAERS %></font>&nbsp;</td>
                  <td class="align_right"><%= WebUtil.printNumFormat(data.COMP_WONX).equals("0") ? "" : WebUtil.printNumFormat(data.COMP_WONX,currencyValue) %>&nbsp;<font color="#006699"><%= WebUtil.printNumFormat(data.COMP_WONX).equals("0") ? "" : data.WAERS %></font>&nbsp;</td>
                  <td class="lastCol"><%= data.POST_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.POST_DATE) %></td>
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
                <tr>
                  <th><!--선택--><%=g.getMessage("LABEL.E.E18.0014")%></th>
		          <th><!--신청일--><%=g.getMessage("LABEL.E.E18.0015")%></th>
		          <th><!--관리번호--><%=g.getMessage("LABEL.E.E18.0016")%></th>
		          <th><!--구분--><%=g.getMessage("LABEL.E.E18.0017")%></th>
		          <th><!--성명--><%=g.getMessage("LABEL.E.E18.0004")%></th>
		          <th><!--상병명--><%=g.getMessage("LABEL.E.E18.0006")%></th>
		          <th><!--본인 납부액--><%=g.getMessage("LABEL.E.E18.0018")%></th>
		          <th><!--회사 지원액--><%=g.getMessage("LABEL.E.E18.0019")%></th>
		          <th class="lastCol"><!--최종결재일--><%=g.getMessage("LABEL.E.E18.0020")%></th>

                </tr>
                <tr class="oddRow">
                  <td class="lastCol align_center" colspan="9"><!--해당하는 데이터가 존재하지 않습니다.--><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
                </tr>
<%
    }
%>
            </table>
        </div>
	</div>

        <!-- PageUtil 관련 - 반드시 써준다. -->
        <div class="align_center">
            <%= pu_m == null ? "" : pu_m.pageControl() %>
        </div>
        <!-- PageUtil 관련 - 반드시 써준다. -->

    </div>
    <!-- 조회 리스트 테이블 끝-->

<%
}
%>

<% //[CSR ID:2995203] 보상명세서 용 뒤로가기.
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
<%  }  %>
</form>
</div>
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
  <input type="hidden" name="COMP_sum"   value="<%= COMP_sum %>">
  <input type="hidden" name="TREA_CODE"  value="">
  <input type="hidden" name="TREA_TEXT"  value="">
  <input type="hidden" name="REGNO"  value=""><!--@v1.2-->
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page_m"      value="<%= paging_m %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->