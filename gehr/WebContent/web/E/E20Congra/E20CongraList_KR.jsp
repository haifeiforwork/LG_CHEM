<%/******************************************************************************/

/*                                                                              */

/*   System Name  : MSS                                                         */

/*   1Depth Name  : MY HR 정보                                                  */

/*   2Depth Name  : 경조금                                                      */

/*   Program Name : 경조금 조회                                                 */

/*   Program ID   : E20CongraList.jsp                                           */

/*   Description  : 경조금 조회                                                 */

/*   Note         : 없음                                                        */

/*   Creation     :                                                             */

/*   Update       : 2005-01-31  윤정현                                          */

/*                  2005/11/03  version @v1.1 C2005101901000000340 :회수내역추가 */

/*                  2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)                                                            */

/********************************************************************************/%>





<%@ page contentType="text/html; charset=utf-8" %>

<%@ include file="/web/common/commonProcess.jsp" %>



<%@ page import="java.util.Vector" %>

<%@ page import="hris.E.E20Congra.*" %>



<%

//  defult 정렬값 18번 field 신청일 역정렬

    WebUserData user                = (WebUserData)session.getAttribute("user");

    Vector      E20CongcondData_dis = (Vector)request.getAttribute("E20CongcondData_dis");

    String      paging              = (String)request.getAttribute("page");

    String      sortField           = (String)request.getAttribute("sortField");

    String      sortValue           = (String)request.getAttribute("sortValue");

    Logger.debug.println(this, E20CongcondData_dis.toString());



//  PageUtil 관련 - Page 사용시 반드시 써줄것.

    PageUtil pu = null;

    if ( E20CongcondData_dis != null && E20CongcondData_dis.size() != 0 ) {

        try {

          pu = new PageUtil(E20CongcondData_dis.size(), paging , 10, 10 );//Page 관련사항

        } catch (Exception ex) {

          Logger.debug.println(DataUtil.getStackTrace(ex));

        }

    }


  //[CSR ID:2995203]
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");

%>

<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">

<!--

function doSubmit() {//경조금 상세조회 페이지로

    trans_form();

    document.form2.jobid.value = "detail";

    document.form2.action = '<%= WebUtil.JspURL %>E/E20Congra/E20CongraDetail.jsp';

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

    eval("document.form2.CONG_CODE.value = document.form1.CONG_CODE"+command+".value");

    eval("document.form2.RELA_CODE.value = document.form1.RELA_CODE"+command+".value");

    eval("document.form2.HOLI_CONT.value = document.form1.HOLI_CONT"+command+".value");

    eval("document.form2.RELA_NAME.value = document.form1.RELA_NAME"+command+".value");

    eval("document.form2.EREL_NAME.value = document.form1.EREL_NAME"+command+".value");

    eval("document.form2.CONG_DATE.value = document.form1.CONG_DATE"+command+".value");

    eval("document.form2.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX"+command+".value)");

    eval("document.form2.CONG_RATE.value = document.form1.CONG_RATE"+command+".value");

    eval("document.form2.CONG_WONX.value = removeComma(document.form1.CONG_WONX"+command+".value)");

    eval("document.form2.PROV_DATE.value = document.form1.PROV_DATE"+command+".value");

    eval("document.form2.BANK_NAME.value = document.form1.BANK_NAME"+command+".value");

    eval("document.form2.BANKN.value     = document.form1.BANKN"+command+".value");

    eval("document.form2.WORK_YEAR.value = document.form1.WORK_YEAR"+command+".value");

    eval("document.form2.WORK_MNTH.value = document.form1.WORK_MNTH"+command+".value");

    eval("document.form2.RTRO_MNTH.value = document.form1.RTRO_MNTH"+command+".value");

    eval("document.form2.RTRO_WONX.value = removeComma(document.form1.RTRO_WONX"+command+".value)");

    eval("document.form2.CONG_NAME.value = document.form1.CONG_NAME"+command+".value");

    eval("document.form2.BEGDA.value     = document.form1.BEGDA"+command+".value");

    eval("document.form2.POST_DATE.value = document.form1.POST_DATE"+command+".value");

    //@v1.1

    eval("document.form2.RFUN_DATE.value = document.form1.RFUN_DATE"+command+".value");

    eval("document.form2.RFUN_RESN.value = document.form1.RFUN_RESN"+command+".value");

    eval("document.form2.RFUN_AMNT.value = removeComma(document.form1.RFUN_AMNT"+command+".value)");

    eval("document.form2.BELNR1.value    = document.form1.BELNR1"+command+".value");



}



//PageUtil 관련 script - page처리시 반드시 써준다...

function pageChange(page){

  document.form3.page.value = page;

  get_Page();

}



//PageUtil 관련 script - page처리시 반드시 써준다...

function get_Page(){

  document.form3.action = '<%= WebUtil.ServletURL %>hris.E.E20Congra.E20CongraListSV';

  document.form3.method = "get";

  document.form3.submit();

}



function sortPage( FieldName, FieldValue ){

  if(document.form3.sortField.value==FieldName){

    if(FieldName == 'BEGDA,POST_DATE,CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE') {      //신청일 sort시

      if(document.form3.sortValue.value == 'desc,desc,asc,asc,asc,desc') {

        document.form3.sortValue.value = 'asc,desc,asc,asc,asc,desc';

      } else {

        document.form3.sortValue.value = 'desc,desc,asc,asc,asc,desc';

      }

    } else if(FieldName == 'CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE') {

      if(document.form3.sortValue.value == 'asc,asc,asc,desc') {                      //경조내역 sort시

        document.form3.sortValue.value = 'desc,asc,asc,desc';

      } else {

        document.form3.sortValue.value = 'asc,asc,asc,desc';

      }

    } else if(FieldName == 'RELA_NAME,CONG_NAME,EREL_NAME,CONG_DATE') {               //경조대상자 관계 sort시

      if(document.form3.sortValue.value == 'asc,asc,asc,desc') {

        document.form3.sortValue.value = 'desc,asc,asc,desc';

      } else {

        document.form3.sortValue.value = 'asc,asc,asc,desc';

      }

    } else if(FieldName == 'EREL_NAME,CONG_NAME,RELA_NAME,CONG_DATE') {                //대상자 sort시

      if(document.form3.sortValue.value == 'asc,asc,asc,desc') {

        document.form3.sortValue.value = 'desc,asc,asc,desc';

      } else {

        document.form3.sortValue.value = 'asc,asc,asc,desc';

      }

    } else if(FieldName == 'CONG_DATE') {                                             //경조발생일 sort시

      if(document.form3.sortValue.value == 'desc') {

        document.form3.sortValue.value = 'asc';

      } else {

        document.form3.sortValue.value = 'desc';

      }

    } else if(FieldName == 'CONG_WONX') {                                             //경조금액 sort시

      if(document.form3.sortValue.value == 'desc') {

        document.form3.sortValue.value = 'asc';

      } else {

        document.form3.sortValue.value = 'desc';

      }

    } else if(FieldName == 'POST_DATE,CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE') {          //최종결재일 sort시

      if(document.form3.sortValue.value == 'desc,asc,asc,asc,desc') {

        document.form3.sortValue.value = 'asc,asc,asc,asc,desc';

      } else {

        document.form3.sortValue.value = 'desc,asc,asc,asc,desc';

      }

    }

  } else {

    document.form3.sortField.value = FieldName;

    document.form3.sortValue.value = FieldValue;

  }

  get_Page();

}
$(document).ready(function(){
	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
 });

//-->

</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">
<%

    if( E20CongcondData_dis.size() > 0 ) {

%>


  <!-- 조회 리스트 테이블 시작-->
  <div class="listArea">
  	<div class="listTop">
  		<span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
  		<div class="buttonArea">
  			<ul class="btn_mdl">
  				<li><a href="javascript:doSubmit();"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a></li>
  			</ul>
  		</div>
  		<div class="clear"></div>
  	</div>
    <div class="table">
      <table class="listTable">
        <thead>
        <tr>
                 <th><!-- 선택 --><%=g.getMessage("LABEL.E.E20.0008")%></td>
                  <th onClick="javascript:sortPage('BEGDA,POST_DATE,CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE','desc,desc,asc,asc,asc,desc')" style="cursor:hand"><!-- 신청일 --><%=g.getMessage("LABEL.E.E20.0001")%><%= sortField.equals("BEGDA,POST_DATE,CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE") ? ( sortValue.toLowerCase() ).equals("desc,desc,asc,asc,asc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                  <th onClick="javascript:sortPage('CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE','asc,asc,asc,desc')"                style="cursor:hand"><!-- 신청일 --><%=g.getMessage("LABEL.E.E20.0002")%><%= sortField.equals("CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE")            ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,desc")     ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                  <th onClick="javascript:sortPage('RELA_NAME,CONG_NAME,EREL_NAME,CONG_DATE','asc,asc,asc,desc')"                style="cursor:hand"><!-- 경조대상자 관계 --><%=g.getMessage("LABEL.E.E20.0003")%><%= sortField.equals("RELA_NAME,CONG_NAME,EREL_NAME,CONG_DATE")           ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,desc")     ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                  <th onClick="javascript:sortPage('EREL_NAME,CONG_NAME,RELA_NAME,CONG_DATE','asc,asc,asc,desc')"                style="cursor:hand"><!-- 대상자 --><%=g.getMessage("LABEL.E.E20.0004")%><%= sortField.equals("EREL_NAME,CONG_NAME,RELA_NAME,CONG_DATE")            ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,desc")     ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                  <th onClick="javascript:sortPage('CONG_DATE','desc')"                                                          style="cursor:hand"><!-- 경조발생일 --><%=g.getMessage("LABEL.E.E20.0005")%><%= sortField.equals("CONG_DATE")                                         ? ( sortValue.toLowerCase() ).equals("desc")                  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                  <th onClick="javascript:sortPage('CONG_WONX','desc')"                                                          style="cursor:hand"><!-- 경조금액 --><%=g.getMessage("LABEL.E.E20.0006")%><%= sortField.equals("CONG_WONX")                                         ? ( sortValue.toLowerCase() ).equals("desc")                  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                  <th class="lastCol" onClick="javascript:sortPage('POST_DATE,CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE','desc,asc,asc,asc,desc')" style="cursor:hand"><!-- 최종결재일 --><%=g.getMessage("LABEL.E.E20.0007")%><%= sortField.equals("POST_DATE,CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE") ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,asc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
        </tr>
        </thead>

<%

        int j = 0;//내부 카운터용

        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            E20CongcondData data = (E20CongcondData)E20CongcondData_dis.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

%>

          <tr class="<%=tr_class%>">

            <td><input type="radio" name="radiobutton" value="<%= j %>" <%=(j==0) ? "checked" : ""%>></td>
            <td><%=data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA)%></td>
            <td><%=data.CONG_NAME%></td>
            <td><%=data.RELA_NAME%></td>
            <td><%=data.EREL_NAME%></td>
            <td><%=data.CONG_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.CONG_DATE)%></td>

<%
//  2002.07.09. 경조발생일자가 2002.01.01. 이전이면 통상임금, 경조금액을 보여주지 않는다.
    String dateCheck = "Y";
        long dateLong = Long.parseLong(DataUtil.removeStructur(data.CONG_DATE, "-"));

        if( dateLong < 20020101 ) {
            dateCheck = "N";
        }
        if( dateCheck.equals("Y") ) {
%>
                  <td class="align_right"><%= WebUtil.printNumFormat(data.CONG_WONX) %></td>
<%
        } else {
%>
                  <td class="align_right">&nbsp;</td>
<%
        }
%>

            <td class="lastCol"><%=data.POST_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.POST_DATE)%>
            <input type="hidden" name="CONG_CODE<%= j %>" value="<%= data.CONG_CODE %>">
            <input type="hidden" name="RELA_CODE<%= j %>" value="<%= data.RELA_CODE %>">
            <input type="hidden" name="HOLI_CONT<%= j %>" value="<%= data.HOLI_CONT %>">
            <input type="hidden" name="RELA_NAME<%= j %>" value="<%= data.RELA_NAME %>">
            <input type="hidden" name="EREL_NAME<%= j %>" value="<%= data.EREL_NAME %>">
            <input type="hidden" name="CONG_DATE<%= j %>" value="<%= data.CONG_DATE %>">
            <input type="hidden" name="WAGE_WONX<%= j %>" value="<%= WebUtil.printNumFormat( data.WAGE_WONX ) %>">
            <input type="hidden" name="CONG_RATE<%= j %>" value="<%= data.CONG_RATE %>">
            <input type="hidden" name="CONG_WONX<%= j %>" value="<%= WebUtil.printNumFormat( data.CONG_WONX ) %>">
            <input type="hidden" name="PROV_DATE<%= j %>" value="<%= data.PROV_DATE %>">
            <input type="hidden" name="BANK_NAME<%= j %>" value="<%= data.BANK_NAME %>">
            <input type="hidden" name="BANKN<%= j %>"     value="<%= data.BANKN     %>">
            <input type="hidden" name="WORK_YEAR<%= j %>" value="<%= WebUtil.printNum(data.WORK_YEAR) %>">
            <input type="hidden" name="WORK_MNTH<%= j %>" value="<%= data.WORK_MNTH %>">
            <input type="hidden" name="RTRO_MNTH<%= j %>" value="<%= data.RTRO_MNTH %>">
            <input type="hidden" name="RTRO_WONX<%= j %>" value="<%= WebUtil.printNumFormat( data.RTRO_WONX ) %>">
            <input type="hidden" name="CONG_NAME<%= j %>" value="<%= data.CONG_NAME %>">
            <input type="hidden" name="BEGDA<%= j %>"     value="<%= data.BEGDA     %>">
            <input type="hidden" name="POST_DATE<%= j %>" value="<%= data.POST_DATE     %>">
            <input type="hidden" name="RFUN_DATE<%= j %>" value="<%= data.RFUN_DATE %>">  <!--반납일자     v1.1-->
            <input type="hidden" name="RFUN_RESN<%= j %>" value="<%= data.RFUN_RESN %>">  <!--반납사유     v1.1-->
            <input type="hidden" name="RFUN_AMNT<%= j %>" value="<%= WebUtil.printNumFormat( data.RFUN_AMNT ) %>">  <!--지급액       v1.1-->
            <input type="hidden" name="BELNR1<%= j %>"    value="<%= data.BELNR1 %>">     <!--회계전표번호 v1.1-->
            </td>

<%

        j++;

        }

    } else {

%>

      <td class="lastCol">&nbsp;</td>

    </tr>

  <!-- 조회 리스트 테이블 시작-->
  <div class="listArea">
    <div class="table">
      <table class="listTable">
                <tr>
                  <th><!-- 선택 --><%=g.getMessage("LABEL.E.E20.0008")%></th>
                  <th><!-- 신청일 --><%=g.getMessage("LABEL.E.E20.0001")%></th>
                  <th><!-- 경조내역 --><%=g.getMessage("LABEL.E.E20.0002")%></th>
                  <th><!-- 경조대상자 관계 --><%=g.getMessage("LABEL.E.E20.0003")%></th>
                  <th><!-- 대상자 --><%=g.getMessage("LABEL.E.E20.0004")%></th>
                  <th><!-- 경조발생일 --><%=g.getMessage("LABEL.E.E20.0005")%></th>
                  <th><!-- 경조금액 --><%=g.getMessage("LABEL.E.E20.0006")%></th>
                  <th class="lastCol"><!-- 최종결재일 --><%=g.getMessage("LABEL.E.E20.0007")%></th>
                </tr>
                <tr class="oddRow">
                  <td class="lastCol align_center" colspan="8"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
                </tr>

<%

    }

%>

      </table>
    </div>
  </div>

  <!-- 조회 리스트 테이블 끝-->


  <!-- PageUtil 관련 - 반드시 써준다. -->

  <div class="align_center">
    <%= pu == null ? "" : pu.pageControl() %>
  </div>

<!-- PageUtil 관련 - 반드시 써준다. -->



<% ////[CSR ID:2995203] 보상명세서 용 뒤로가기
    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
    if (isCanGoList) {  %>

  <div class="buttonArea">
    <ul class="btn_crud">
      <li><a href="javascript:history.back()"><span><!-- 목록 --><%=g.getMessage("BUTTON.COMMON.BACK")%></span></a></li>
    </ul>
  </div>

<%  }  %>

</div>
</form>

<form name="form2">

<!-----   hidden field ---------->

    <input type="hidden" name="jobid"     value="">

    <input type="hidden" name="CONG_CODE" value="">

    <input type="hidden" name="RELA_CODE" value="">

    <input type="hidden" name="HOLI_CONT" value="">

    <input type="hidden" name="RELA_NAME" value="">

    <input type="hidden" name="EREL_NAME" value="">

    <input type="hidden" name="CONG_DATE" value="">

    <input type="hidden" name="WAGE_WONX" value="">

    <input type="hidden" name="CONG_RATE" value="">

    <input type="hidden" name="CONG_WONX" value="">

    <input type="hidden" name="PROV_DATE" value="">

    <input type="hidden" name="BANK_NAME" value="">

    <input type="hidden" name="BANKN"     value="">

    <input type="hidden" name="WORK_YEAR" value="">

    <input type="hidden" name="WORK_MNTH" value="">

    <input type="hidden" name="RTRO_MNTH" value="">

    <input type="hidden" name="RTRO_WONX" value="">

    <input type="hidden" name="CONG_NAME" value="">

    <input type="hidden" name="BEGDA"     value="">

    <input type="hidden" name="POST_DATE" value="">



    <input type="hidden" name="RFUN_DATE" value="">  <!--반납일자     v1.1-->

    <input type="hidden" name="RFUN_RESN" value="">  <!--반납사유     v1.1-->

    <input type="hidden" name="RFUN_AMNT" value="">  <!--지급액       v1.1-->

    <input type="hidden" name="BELNR1"    value="">  <!--회계전표번호 v1.1-->





<!--  HIDDEN  처리해야할 부분 끝-->

</form>

<!-- 페이지 처리를 위한 FORM -->

<form name="form3">

  <input type="hidden" name="page"      value="<%= paging %>">

  <input type="hidden" name="sortField" value="<%= sortField %>">

  <input type="hidden" name="sortValue" value="<%= sortValue %>">

</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->