<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 연급여                                                      */
/*   Program Name : 연급여                                                      */
/*   Program ID   : D06YpayDetail_to_year_m.jsp                                 */
/*   Description  : 개인의 연급여에 대한 상세내용을 조회                        */
/*   Note         :                                                             */
/*   Creation     : 2003-01-13  최영호                                          */
/*   Update       : 2005-01-20  윤정현                                          */
/*                  2006-01-24  lsa @v1.1  과세반영(산학자금) 추가 and 조회년도 하드코딩수정*/
/*   Update       : 2006-03-17  @v1.2 lsa 급여작업으로 막음                     */
/*                              @v1.2 lsa 5월급여작업으로 막음  전문기술직만    */
/*                  2006-06-16 @v1.2 kdy 임금인상관련 급여화면 제어              */
/*                  2007-01-23 @v1.0 lsa 과세반영(기타) 금액이 LGTX2,LGTX3 있는 경우 처리함*/
/*                  2007-02-13 @v1.3 lsa 과세반영(선택적복리후생) 추가, 과세반영(입학축하금)삭제 */
/*                  2018-03-29 [요청번호]C20180329_48084 | [서비스번호]3648084  태국법인(회사코드 G530) MSS 화면 수정 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D06Ypay.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>

<%
    WebUserData user_m = (WebUserData)session.getAttribute("user_m");
    WebUserData user   = (WebUserData)session.getAttribute("user");
//  D06YpayTaxDetailData  d06YpayTaxDetailData = (D06YpayTaxDetailData) request.getAttribute( "d06YpayTaxDetailData"  ) ; //
    Vector D06YpayDetailData_vt    = ( Vector ) request.getAttribute( "D06YpayDetailData_vt" );    // 연급여 내역 리스트


    String from_year  = (String)request.getAttribute("from_year");

    //String year = (String)request.getAttribute("year");

    // 2018-03-26 태국법인(Area.TH("26")) Roll-Out 요구사항 추가 [요청번호]C20180329_48084 | [서비스번호]3648084
    String salary = "";

    String ableyear  = "";
    int endYear    = Integer.parseInt( DataUtil.getCurrentYear() );
    int startYear  = 0;
    if ( user_m != null ) {
        if(user_m.e_dat03 == null || user_m.e_dat03.equals("")|| user.e_dat03.equals("0000-00-00")){
            startYear = endYear - 5;
        }else{
            startYear = Integer.parseInt( (user_m.e_dat03).substring(0,4) );
        }
        startYear = Integer.parseInt( (user_m.e_dat03).substring(0,4) );
        //@v1.1 하드코딩내용변경 조회가능일을 가져 온다.
    }


        Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }
%>

<jsp:include page="/include/header.jsp">
	<jsp:param name="script" value="tr_odd_even_row.js" />
</jsp:include>

<script language="JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
    window.open(theURL,winName,features);
}

function  doSearchDetail() {

    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayEastSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function doSubmit() {
    if( check_data() ) {
        blockFrame();
        date1 = new Date();
        n_month = date1.getMonth()+1;

        document.form1.jobid_m.value  = "search";
//        document.form1.from_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//        document.form1.from_month1.value = document.form1.from_month.options[document.form1.from_month.selectedIndex].text;
//       document.form1.from_month1.value = "01";   // 시작월은 항상 01월로 한다.
//        document.form1.to_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//        document.form1.to_month1.value = document.form1.to_month.options[document.form1.to_month.selectedIndex].text;
 //       if(n_month < 10) {
 //           document.form1.to_month1.value = "0"+n_month;  // 현재월까지를 보낸다.
 //       }else{
 //           document.form1.to_month1.value = n_month;  // 현재월까지를 보낸다.
 //       }

        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayEastSV_m";
        document.form1.method = "post";
        document.form1.submit();
    }
}

/** not needress
function foriegn() {
    date3 = new Date();
    n_month = date3.getMonth()+1;
    document.form4.jobid_m.value  = "foriegn";
    document.form4.from_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//  document.form4.from_month1.value = document.form1.from_month.options[document.form1.from_month.selectedIndex].text;
    document.form4.from_month1.value = "01";
    document.form4.to_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//  document.form4.to_month1.value = document.form1.to_month.options[document.form1.to_month.selectedIndex].text;
    document.form4.to_month1.value = "12"  // "0"+n_month;  // 현재월까지를 보낸다
    document.form4.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayDetailSV_m";
    document.form4.method = "post";
    document.form4.submit();
}
*/

function month_kubyo(zyymm) {
    //document.form3.jobid.value  = "month_kubyo";
    if(zyymm == 'TOTAL')
        return;
    document.form3.jobid_m.value  = "search_back";
    document.form3.year1.value  = zyymm.substring(0,4);
    document.form3.month1.value  = zyymm.substring(4,6);
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailSV_m";
    document.form3.method = "post";
    blockFrame();
    document.form3.submit();
}

function month_kubyo_2(zyymm) {
    //document.form2.jobid.value  = "month_kubyo";
    if(zyymm == 'TOTAL')
        return;
    document.form3.year1.value  = zyymm.substring(0,4);
    document.form3.month1.value  = zyymm.substring(4,6);
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D08RetroDetailSV_m";
    document.form3.method = "post";
    blockFrame();
    document.form3.submit();
}

function doPrint() {
    date2 = new Date();
    n_month = date2.getMonth()+1;

    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=850,height=660");

    document.form3.jobid_m.value  = "print";
    document.form3.target = "essPrintWindow";
    document.form3.from_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//  document.form3.from_month1.value = document.form1.from_month.options[document.form1.from_month.selectedIndex].text;
    document.form3.from_month1.value = "01";   // 시작월은 항상 01월로 한다.
    document.form3.to_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//  document.form3.to_month1.value = document.form1.to_month.options[document.form1.to_month.selectedIndex].text;
    if(n_month < 10) {
        document.form3.to_month1.value = "0"+n_month;  // 현재월까지를 보낸다.
    }else{
        document.form3.to_month1.value = n_month;  // 현재월까지를 보낸다.
    }

    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayEastSV_m";
    document.form3.method = "post";
    document.form3.submit();
}

function check_data(){
    date = new Date();
    c_year = date.getFullYear();

    from_year1 = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;

    if(from_year1 > c_year){
        alert("<%=g.getMessage("MSG.D.D05.0001")%>");
        form1.from_year.focus();
        return false;
    }
    return true;
}
//-->
</script>

<style>
.mpayTable td{text-align:right;}
</style>

<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_ANNU_PAY"/>
    <jsp:param name="help" value="D06Ypay.html"/>
</jsp:include>

<form name="form1" method="post" action="">

    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->

    <div class="commentsMoreThan2">
        <div><spring:message code="LABEL.D.D15.0119" /></div>
        <!-- Please do not share the information of compensation, or will be disciplined according to the working regulation. -->
    </div>

    <!--조회기간 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <colgroup>
                    <col width="13%" />
                    <col width="20%" />
                    <col width="13%" />
                    <col width="20%" />
                    <col width="13%" />
                    <col />
                </colgroup>
                <tr>
                  <th><spring:message code="LABEL.D.D05.0002" /></th> <!-- Report Period -->
                  <td colspan="6">
                    <select name="from_year">
                      <%= WebUtil.printOption(CodeEntity_vt, from_year ) %>
                      <%-- 테스트 위해서 임시코딩 --%>
                    </select>

                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:doSubmit();"><span><spring:message code="BUTTON.COMMON.SEARCH" /></span></a>
                    </div>

                  </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D05.0004" /></th> <!-- Org.Unit -->
                    <td><%= user_m.e_orgtx %></td>
                    <th class="th02"><spring:message code="LABEL.D.D05.0005" /></th> <!--  Pers.No-->
                    <td><%= user_m.empNo %></td>
                    <th class="th02"><spring:message code="LABEL.D.D05.0006" /></td> <!-- Name -->
                    <td><%= user_m.ename %></td>
            </table>
        </div>
    </div>
    <!--조회기간 테이블 끝-->


    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
                <tr>
                <th rowspan="2"><spring:message code="LABEL.D.D05.0002" /></th> <!-- Period -->
                <th colspan="5"><spring:message code="LABEL.D.D05.0014" /></th><!-- Payment -->
<%--                     <th colspan="<%=user.e_area.equals("28")? "5" : user.e_area.equals("42")? "4" : "3" %>" > --%>
                <th colspan="<%=user.e_area.equals("28")? "5" : user.e_area.equals("27")? "3" : "4" %>" >
						<spring:message code="LABEL.D.D05.0016" /></th><!-- Deduction -->
                    <th class="lastCol" rowspan="2">
                    	<spring:message code="LABEL.D.D05.0012" /></th><!-- Net Payment -->
                </tr>

                <tr>
                <th><spring:message code="LABEL.D.D06.0022" /></th><!-- Salary -->
                <th><spring:message code="LABEL.D.D06.0024" /></th><!-- Allowance -->
                <th><spring:message code="LABEL.D.D06.0025" /></th><!--Overtime  -->
                <th><spring:message code="LABEL.D.D06.0023" /></th><!--Incentive  -->
                <th><spring:message code="LABEL.D.D06.0011" /></th><!-- Total -->
                <%if(!user.e_area.equals("27")){ %>
                <th><spring:message code="LABEL.D.D06.0026" /></th><!-- Tax -->
                <%}%>
                <th><spring:message code="LABEL.D.D06.0028" /></th><!--Social Insurance  -->
                <%if(user.e_area.equals("28") ){%>
                <th><spring:message code="LABEL.D.D06.0027" /></th><!--PHF  -->
                <%}%>
                <!-- 2018-03-26 태국법인 RollOut 요구사항 반영 [요청번호]C20180329_48084 | [서비스번호]3648084 시작-->
                <%if(user.e_area.equals("26") ){%>
                <th><spring:message code="LABEL.D.D06.0039" /></th><!-- Provident Fund -->
                <%}else{%>
                <th><spring:message code="LABEL.D.D06.0005" /></th><!-- Others -->
                <%}%>
                <!-- 2018-03-26 태국법인 RollOut 요구사항 반영 [요청번호]C20180329_48084 | [서비스번호]3648084 끝-->
                <th><spring:message code="LABEL.D.D06.0011" /></th><!-- Total -->
              </tr>
<%
    if ( D06YpayDetailData_vt.size() > 1 ) {

    for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
    D06YpayDetailData_to_year data = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);
    String  zyy = data.ZYYMM.equals("TOTAL")?"TOTAL":data.ZYYMM.substring(0,4);
    String  zmm = data.ZYYMM.equals("TOTAL")?"":data.ZYYMM.substring(4);
    //String salary = String.valueOf(Double.parseDouble(data.BET01) + Double.parseDouble(data.BET03));

	// 2018-03-26 태국법인(Area.TH("26")) Roll-Out 요구사항 추가 시작
    if(user.e_area.equals("26") ){
    	salary = String.valueOf(Double.parseDouble(data.BET01) + Double.parseDouble(data.BET03));
    }else{
    	salary = String.valueOf(Double.parseDouble(data.BET01) + Double.parseDouble(data.BET02) + Double.parseDouble(data.BET03));
    }
 // 2018-03-26 태국법인(Area.TH("26")) Roll-Out 요구사항 추가 끝

    String others = String.valueOf(Double.parseDouble(data.BET12) + Double.parseDouble(data.BET14));
%>
              <tr <%=data.ZYYMM.equals("TOTAL")?"class='sumRow'":""%>>
                <td class="align_center">
                <%if(data.ZYYMM != null && data.ZYYMM.equals("TOTAL")){ %>
                    <%=data.ZYYMM%>
                <%}else{%>
                    <a href="javascript:month_kubyo('<%= data.ZYYMM %>');"><font color="#6699FF"><%= zyy+"."+zmm %></font></a>
                <%}%>
                </td>
                <td ><%= salary.equals("0") ? "" : WebUtil.printNumFormat(salary,2) %></td>
                <td ><%= data.BET02.equals("0") ? "" : WebUtil.printNumFormat(data.BET02,2) %></td>
                <td ><%= data.BET03.equals("0") ? "" : WebUtil.printNumFormat(data.BET03,2) %></td>
                <td ><%= data.BET04.equals("0") ? "" : WebUtil.printNumFormat(data.BET04,2) %></td>
                <td ><%= data.BET06.equals("0") ? "" : WebUtil.printNumFormat(data.BET06,2) %></td>

                <%if(!user.e_area.equals("27")){ %>
                <td ><%= data.BET13.equals("0") ? "" : WebUtil.printNumFormat(data.BET13,2) %></td>
                <%}%>
                <td > <%= data.BET09.equals("0") ? "" : WebUtil.printNumFormat(data.BET09,2) %></td>
                <%if(user.e_area.equals("28") ){%>
                <td ><%= data.BET10.equals("0") ? "" : WebUtil.printNumFormat(data.BET10,2) %></td>
                <%}%>
                <td ><%= data.BET14.equals("0") ? "" : WebUtil.printNumFormat(data.BET14,2) %></td>
                <td ><%= data.BET16.equals("0") ? "" : WebUtil.printNumFormat(data.BET16,2) %></td>
                <td class=" lastCol"><%= data.BET17.equals("0") ? "" : WebUtil.printNumFormat(data.BET17,2) %></td>
              </tr>
<%
    } //end for
%>
<%
  }else{
%>

            <tr class="oddRow">
                <td  colspan="12" class="lastCol"><spring:message code="MSG.COMMON.0004" /></td> <!-- No data-->
            </tr>


<%
  } //end if
%>

            </table>
        </div>
    </div>

</div>
  <input type="hidden" name="jobid_m" value="">
</form>
<form name="form2" method="post" action="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="yyyy" value="">
      <input type="hidden" name="mm" value="">
      <input type="hidden" name="oo" value="ZZ00000">
</form>
<form name="form3" method="post" action="">
      <input type="hidden" name="jobid_m" value="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="year1" value="">
      <input type="hidden" name="month1" value="">
  	  <input type="hidden" name="ocrsn" value="ZZ00000">    <!--Total -->
</form>
<form name="form4" method="post" action="">
  <input type="hidden" name="jobid_m" value="">
  <input type="hidden" name="from_year1" value="">
  <input type="hidden" name="from_month1" value="">
  <input type="hidden" name="to_year1" value="">
  <input type="hidden" name="to_month1" value="">
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
