<%/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                             */
/*   2Depth Name  : 연급여                                                      */
/*   Program Name : 연급여                                                      */
/*   Program ID   : D06YpayEastSV                                   */
/*   Description  : 2003/01/13 연말정산으로 인한 연급여 생성. (연말정산용)      */
/*                  개인의 연급여에 대한 상세내용을 조회하여 값을 넘겨주는 class*/
/*   Note         :                                                             */
/*   Creation     : 2003-01-13  최영호                                          */
/*   Update       : 2005-01-20  최영호                                          */
/*   Update       : 2007-01-22  @v1.0 lsa 변수 clear 안되어 오류로 수정         */
/*                  2007-10-22  huang peng xiao globalehr update                 */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="hris.D.D06Ypay.*" %>
<%@ page import="hris.D.D06Ypay.rfc.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="hris.common.util.*" %>

<%
    WebUserData user  = (WebUserData)session.getAttribute("user");

    Vector D06YpayDetailData_vt = ( Vector ) request.getAttribute( "D06YpayDetailData_vt" ) ; // 연급여 내역 리스트
    //D06YpayTaxDetailData  d06YpayTaxDetailData = (D06YpayTaxDetailData) request.getAttribute( "d06YpayTaxDetailData"  ) ; //
    //Vector D06YpayTaxDetailData_vt = ( Vector ) request.getAttribute( "D06YpayTaxDetailData_vt" ) ; // 연말정산내역
    //Vector D06YpayDetailData3_vt = ( Vector ) request.getAttribute( "D06YpayDetailData3_vt" ) ; // 과세반영 내역 조회

    //String from_year  = ( String ) request.getAttribute("from_year");
    // String from_month = ( String ) request.getAttribute("from_month");
    // String to_year    = ( String ) request.getAttribute("to_year");
    // String to_month   = ( String ) request.getAttribute("to_month");

    //WebUserData user = (WebUserData)session.getAttribute("user");
    //String year      = (String)request.getAttribute("year");
    int endYear    = Integer.parseInt( DataUtil.getCurrentYear() );
    int startYear  = 2006;

    /*if(user.e_dat03 == null || user.e_dat03.equals("") || user.e_dat03.equals("0000-00-00")){
        startYear = endYear - 5;
    }else{
        startYear = Integer.parseInt( (user.e_dat03).substring(0,4) );
    }*/
    //if( startYear < 2003 ){
    //    startYear = 2003;
    //}

    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    if(user.e_area == null || user.e_area.equals(""))
        user.e_area = "28";

    //@v1.2 하드코딩내용변경 조회가능일을 가져 온다.
    D05LatestPaidRFC rfc_paid = new D05LatestPaidRFC();
    String paydt = rfc_paid.getLatestPaid1(user.empNo, user.webUserId);
    String ableyear  = paydt.substring(0,4);

    String yyyy      = ( String ) request.getAttribute("yyyy");
    String year      = ( String ) request.getAttribute("year");
    String backBtn  = ( String ) request.getAttribute("backBtn");  // new function
    String from_year = ( String ) request.getAttribute("from_year");


%>

<jsp:include page="/include/header.jsp">
	<jsp:param name="script" value="tr_odd_even_row.js" />
</jsp:include>
<script language="JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
    window.open(theURL,winName,features);
}

/*function kubya() {
    <%//if(D06YpayDetailData_vt.size() == 1){  %>
        alert('No data');
        return;
    <%//}%>
    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=650,height=660");
    document.form2.jobid.value  = "kubya_1";
    document.form2.target = "essPrintWindow";
    document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayEastSV";
    document.form2.method = "post";
    document.form2.submit();
}*/

function doSubmit() {
    if( check_data() ) {
        blockFrame();
        date1 = new Date();
        n_month = date1.getMonth()+1;

        document.form1.jobid.value  = "search";
//        document.form1.from_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//      document.form1.from_month1.value = document.form1.from_month.options[document.form1.from_month.selectedIndex].text;
//        document.form1.from_month1.value = "01";   // 시작월은 항상 01월로 한다.
//        document.form1.to_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//      document.form1.to_month1.value = document.form1.to_month.options[document.form1.to_month.selectedIndex].text;
/*        if(n_month < 10) {
            document.form1.to_month1.value = "0"+n_month;  // 현재월까지를 보낸다.
        }else{
            document.form1.to_month1.value = n_month;  // 현재월까지를 보낸다.
        }
*/
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayEastSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function foriegn() {
    date3 = new Date();
    n_month = date3.getMonth()+1;
    document.form4.jobid.value  = "foriegn";
    document.form4.from_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
    //document.form4.from_month1.value = document.form1.from_month.options[document.form1.from_month.selectedIndex].text;
    document.form4.from_month1.value = "01";
    document.form4.to_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
    //document.form4.to_month1.value = document.form1.to_month.options[document.form1.to_month.selectedIndex].text;
    document.form4.to_month1.value = "0"+n_month;  // 현재월까지를 보낸다
    document.form4.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayDetailSV";
    document.form4.method = "post";
    document.form4.submit();
}

function month_kubyo(zyymm) {//month salary
    //document.form2.jobid.value  = "month_kubyo";
    if(zyymm == 'TOTAL')
        return;
    document.form3.jobid.value  = "search_back";
    document.form3.year1.value  = zyymm.substring(0,4);
    document.form3.month1.value  = zyymm.substring(4,6);
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailSV";
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
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D08RetroDetailSV";
    document.form3.method = "post";
    blockFrame();
    document.form3.submit();
}

function doPrint() {
    date2 = new Date();
    n_month = date2.getMonth()+1;

    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=850,height=660");

    document.form3.jobid.value  = "print";
    document.form3.target = "essPrintWindow";
//  document.form3.from_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//  document.form3.from_month1.value = document.form1.from_month.options[document.form1.from_month.selectedIndex].text;
//  document.form3.from_month1.value = "01";   // 시작월은 항상 01월로 한다.
//  document.form3.to_year1.value  = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;
//  document.form3.to_month1.value = document.form1.to_month.options[document.form1.to_month.selectedIndex].text;
//  if(n_month < 10) {
//      document.form3.to_month1.value = "0"+n_month;  // 현재월까지를 보낸다.
//  }else{
//      document.form3.to_month1.value = n_month;  // 현재월까지를 보낸다.
//  }
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayDetailSV";
    document.form3.method = "post";
    document.form3.submit();
}

function check_data(){
    var date = new Date();
    var c_year = date.getFullYear();

    var from_year1  = document.form1.year.options[document.form1.year.selectedIndex].text;

    if(from_year1 > c_year){
        alert("<%=g.getMessage("MSG.D.D05.0001")%>");
        form1.from_year.focus();
        return false;
    }
    return true;
}
//-->
</script>


<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_ANNU_PAY"/>
    <jsp:param name="help" value="D06Ypay.html"/>
</jsp:include>

<form name="form1" method="post" action="">

    <div class="commentsMoreThan2">
        <div><spring:message code="LABEL.D.D15.0119" /></div>
        <!-- Please do not share the information of compensation, or will be disciplined according to the working regulation. -->
    </div>

    <!-- 상단 검색테이블 시작-->
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
                    <td colspan="5">
                        <select name="year">
<%
    for( int i = 2006 ; i <= Integer.parseInt(ableyear) ; i++ ) {
        int year1 = Integer.parseInt(from_year);
        if(yyyy == null || yyyy.equals("")){
%>
                      <option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
        }else{
            int iyyyy =Integer.parseInt(yyyy);
%>
                      <option value="<%= i %>"<%= iyyyy == i ? " selected " : "" %>><%= i %></option>
<%
        }
    }
%>
                        </select>
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:doSubmit();"><span><spring:message code="BUTTON.COMMON.SEARCH" /></span></a>
                    </div>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D05.0004" /></th> <!-- Org.Unit -->
                    <td><%= user.e_orgtx %></td>
                    <th class="th02"><spring:message code="LABEL.D.D05.0005" /></th> <!--  Pers.No-->
                    <td><%= user.empNo %></td>
                    <th class="th02"><spring:message code="LABEL.D.D05.0006" /></td> <!-- Name -->
                    <td><%= user.ename %></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 검색테이블 끝-->

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
              <tr>
                <th rowspan="2"><spring:message code="LABEL.D.D05.0002" /></th> <!-- Period -->
                <th colspan="5"><spring:message code="LABEL.D.D05.0014" /></th><!-- Payment -->
                <th colspan="<%=user.e_area.equals("28")? "5" : user.e_area.equals("27")? "3" : "4" %>" >
                    <spring:message code="LABEL.D.D05.0016" /></th><!-- Deduction -->
                <th class="lastCol" rowspan="2" width="69" valign="center">
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
                <%if(user.e_area.equals("26") ){%>
                <th><spring:message code="LABEL.D.D06.0039" /></th><!-- Provident Fund -->
                <%}else{ %>
                <th><spring:message code="LABEL.D.D06.0005" /></th><!-- Others -->
                <%} %>
                <th><spring:message code="LABEL.D.D06.0011" /></th><!-- Total -->
              </tr>
<%
   //渤天法人不显示2011年2月以前的工资信息。  liukuo   2011.01.30
   if ( D06YpayDetailData_vt.size()> 1 ) {
       if(user.companyCode.equals("G370") ){
           for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
               D06YpayDetailData_to_year temp = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);
               if(!temp.ZYYMM.equals("TOTAL") && Integer.parseInt(temp.ZYYMM)<201102){
                    D06YpayDetailData_vt.remove(i);
                    i--;
                }
           }
        }
   }
    if ( D06YpayDetailData_vt.size()> 1 ) {
    for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
    D06YpayDetailData_to_year data = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);
    //AppUtil.initEntity(data,"6666666.6");
    String  zyy = data.ZYYMM.equals("TOTAL")?"TOTAL":data.ZYYMM.substring(0,4);
    String  zmm = data.ZYYMM.equals("TOTAL")?"":data.ZYYMM.substring(4);
    String salary = String.valueOf(Double.parseDouble(data.BET01) + Double.parseDouble(data.BET02) + Double.parseDouble(data.BET03));
    String others = String.valueOf(Double.parseDouble(data.BET12) + Double.parseDouble(data.BET14));
%>

          <tr <%=data.ZYYMM.equals("TOTAL")?"class='sumRow'":""%>>
            <td >
	            <%if(data.ZYYMM != null && data.ZYYMM.equals("TOTAL")){ %>
	                <%=data.ZYYMM%>
	            <%}else{%>
	                <a href="javascript:month_kubyo('<%= data.ZYYMM %>');"><font color="#6699FF"><%= zyy+"."+zmm %></font></a>
	            <%}%>
            </td>
            <td class="align_right"><%= data.BET01.equals("0") ? "" : WebUtil.printNumFormat(data.BET01,2) %></td>
            <td class="align_right"><%= data.BET02.equals("0") ? "" : WebUtil.printNumFormat(data.BET02,2) %></td>
            <td class="align_right"><%= data.BET03.equals("0") ? "" : WebUtil.printNumFormat(data.BET03,2) %></td>
            <td class="align_right"><%= data.BET04.equals("0") ? "" : WebUtil.printNumFormat(data.BET04,2) %></td>
            <td class="align_right"><%= data.BET06.equals("0") ? "" : WebUtil.printNumFormat(data.BET06,2) %></td>

            <%if(!user.e_area.equals("27")){ %><!-- not HK -->
            <td class="align_right"><%= data.BET13.equals("0") ? "" : WebUtil.printNumFormat(data.BET13,2) %></td><!-- income tax -->
            <%}%>
            <td class="align_right"> <%= data.BET09.equals("0") ? "" : WebUtil.printNumFormat(data.BET09,2) %></td>
            <%if(user.e_area.equals("28") ){%><!-- CN -->
            <td class="align_right"><%= data.BET10.equals("0") ? "" : WebUtil.printNumFormat(data.BET10,2) %></td><!-- PHF -->
            <%}%>
            <td class="align_right"><%= data.BET14.equals("0") ? "" : WebUtil.printNumFormat(data.BET14,2) %></td>
            <td class="align_right"><%= data.BET16.equals("0") ? "" : WebUtil.printNumFormat(data.BET16,2) %></td>
            <td class="align_right lastCol"><%= data.BET17.equals("0") ? "" : WebUtil.printNumFormat(data.BET17,2) %></td>
          </tr>

<%
    }
%>
<% } else {%>

         <tr class="oddRow">
             <td  colspan="12" class="lastCol"><spring:message code="MSG.COMMON.0004" /></td> <!-- No data-->
         </tr>
<%
 }
%>
            </table>
        </div>
    </div>

	<%if("Y".equals(backBtn)){ %>
	<div class="buttonArea">

	    <ul class="btn_crud">
	        <li><a href="javascript:history.back()"><span><spring:message code="BUTTON.COMMON.BACK"></spring:message></span></a></li>
	    </ul>

	</div>
	<div class="clear"> </div>
	<%} %>

</div>


      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="from_year1" value="">
      <input type="hidden" name="from_month1" value="">
      <input type="hidden" name="to_year1" value="">
      <input type="hidden" name="to_month1" value="">
</form>

<form name="form2" method="post" action="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="yyyy" value="">
      <input type="hidden" name="mm" value="">
      <input type="hidden" name="oo" value="ZZ00000">
</form>

<form name="form3" method="post" action="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="year1" value="">
      <input type="hidden" name="month1" value="">
  	  <input type="hidden" name="ocrsn" value="ZZ00000">    <!--Total -->
</form>

<form name="form4" method="post" action="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="from_year1" value="">
      <input type="hidden" name="from_month1" value="">
      <input type="hidden" name="to_year1" value="">
      <input type="hidden" name="to_month1" value="">
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
