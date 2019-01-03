<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                          */
/*   1Depth Name    : Personal HR Info                                                                                                              */
/*   2Depth Name    : Payroll                                                                                                                       */
/*   Program Name   : Annual Salary                                                                                                                 */
/*   Program ID         : D06YpayEast.jsp                                                                                          */
/*   Description        : 개인의 연급여내역 조회 (유럼,USA)                                                                                                */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-11-01 jungin @v1.0                                                                                                   */
/***************************************************************************************/%>

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
    WebUserData user = (WebUserData)session.getAttribute("user");

    D06YpayDetailData_to_year personInfo = (D06YpayDetailData_to_year)request.getAttribute("person");
    Vector D06YpayDetailData_vt2 = (Vector)request.getAttribute("D06YpayDetailData_vt2"); // 연급여 내역 리스트

    int endYear = Integer.parseInt(DataUtil.getCurrentYear());
    int startYear = 2006;

    Vector CodeEntity_vt = new Vector();
    for (int i = startYear; i <= endYear; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    // 년도조회
    // 이 함수는 오직 여기서만 사용. 2010.08.04 yji
    D05LatestPaidRFCEurp rfc_paid = new D05LatestPaidRFCEurp();
    Vector paydt_vt = rfc_paid.getLatestPaid1(user.empNo);

    String ableyear = "";

    if (paydt_vt.size() > 0) {

        if (paydt_vt.size() > 0) {
            for (int i=0; i < paydt_vt.size(); i++) {
                D05MpayDetailData6Eurp data = (D05MpayDetailData6Eurp)paydt_vt.get(i);
                ableyear = data.CODE;
            }
        }

    } else {
        ableyear  = "2010";
    }

    String yyyy = (String)request.getAttribute("yyyy");
    String year = (String)request.getAttribute("year");
    String from_year = ( String ) request.getAttribute("from_year");
%>


<jsp:include page="/include/header.jsp">
	<jsp:param name="script" value="tr_odd_even_row.js" />
</jsp:include>

<style>
td{text-align:right !important;}
</style>


<script language="JavaScript">
<!--


function doSubmit() {
    if (check_data()) {
        blockFrame();
        date1 = new Date();
        n_month = date1.getMonth() + 1;

        document.form1.jobid.value = "search";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayWestSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

/** 해외에서는 불필요(해외근무자국내급여내역) ksc
function foriegn() {
    date3 = new Date();
    n_month = date3.getMonth()+1;
    document.form4.jobid.value = "foriegn";
    document.form4.from_year1.value = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form4.from_month1.value = "01";
    document.form4.to_year1.value = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form4.to_month1.value = "0"+n_month;  // 현재월까지를 보낸다
    document.form4.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayKoreaSV";
    document.form4.method = "post";
    document.form4.submit();
}
***/

function month_kubyo(zyymm, zocrsn, zseqnr) {       // month salary
    if (zyymm == "TOTAL")
        return;
    document.form2.jobid.value  = "search_back";
    document.form2.year1.value = zyymm.substring(0,4);
    document.form2.month1.value = zyymm.substring(4,6);
    document.form2.ocrsn.value = zocrsn + zseqnr;
    document.form2.zseqnr.value = zseqnr;
    document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailSV";
    document.form2.method = "post";
    blockFrame();
    document.form2.submit();
}

/** 상세내역 불필요 ksc
function month_kubyo_2(zyymm) {
    if (zyymm == "TOTAL")
        return;
    document.form3.year1.value = zyymm.substring(0,4);
    document.form3.month1.value = zyymm.substring(4,6);
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D08RetroDetailSV";
    document.form3.method = "post";
    blockFrame();
    document.form3.submit();
}
**/

function doPrint() {
    date2 = new Date();
    n_month = date2.getMonth()+1;

    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=850,height=660");

    document.form3.jobid.value  = "print";
    document.form3.target = "essPrintWindow";
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayDetailSV";
    document.form3.method = "post";
    document.form3.submit();
}

function check_data(){
    var date = new Date();
    var c_year = date.getFullYear();
    var from_year1 = document.form1.year.options[document.form1.year.selectedIndex].text;

    if (from_year1 > c_year) {
        alert("<%=g.getMessage("MSG.D.D05.0001")%>");
        form1.year.focus();
        return false;
    }
    return true;
}
//-->
</script>



<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_ANNU_PAY"/>
    <jsp:param name="help" value="D06YpayEurp_m.html"/>
</jsp:include>


<form name="form1" method="post" action="">

	<div class="commentsMoreThan2">
    	<div><spring:message code="LABEL.D.D15.0119" /><!-- please do not share the information of compensation, or will be disciplined according to the working regulation.-->
    	</div>
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
                    <td class="align_left" colspan="5">
                        <select name="year">
                    <%
                        for (int i = 2006; i <= Integer.parseInt(ableyear); i++ ) {
                            int year1 = Integer.parseInt(from_year);
                            if (yyyy == null || yyyy.equals("")) {
                    %>
                        <option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
                    <%
                            } else {
                                int iyyyy =Integer.parseInt(ableyear);
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
                   <td class="align_left" ><%= personInfo.ORGTX %></td>
                   <th class="th02"><spring:message code="LABEL.D.D05.0005" /></th> <!--  Pers.No-->
                   <td class="align_left" ><%= personInfo.PERNR %></td>
                   <th class="th02"><spring:message code="LABEL.D.D05.0006" /></td> <!-- Name -->
                   <td class="align_left" ><%= personInfo.ENAME %></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 검색테이블 끝-->

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
                <tr>
                    <th rowspan="2" width="60" valign="center"><spring:message code="LABEL.D.D05.0002" /></th> <!-- Period -->
                    <th colspan="5"><spring:message code="LABEL.D.D05.0014" /></th><!-- Payment -->
                    <th colspan="4"><spring:message code="LABEL.D.D05.0016" /></th><!-- Deduction -->
                    <th class="lastCol" rowspan="2"><spring:message code="LABEL.D.D05.0012" /></th><!-- Net Payment -->
                </tr>
                <tr>
	                <th><spring:message code="LABEL.D.D06.0022" /></th><!-- Salary -->
	                <th><spring:message code="LABEL.D.D06.0024" /></th><!-- Allowance -->
	                <th><spring:message code="LABEL.D.D06.0025" /></th><!--Overtime  -->
	                <th><spring:message code="LABEL.D.D06.0023" /></th><!--Incentive  -->
	                <th><spring:message code="LABEL.D.D06.0011" /></th><!-- Total -->
                    <th><spring:message code="LABEL.D.D06.0026" /></th><!-- Tax -->
                    <th><spring:message code="LABEL.D.D06.0028" /></th><!--Social Insurance  -->
                    <th><spring:message code="LABEL.D.D06.0005" /></th><!-- Others -->
                    <th><spring:message code="LABEL.D.D06.0011" /></th><!-- Total -->
                </tr>
            <%
               if (D06YpayDetailData_vt2.size()> 1) {

                    for (int i = 0; i < D06YpayDetailData_vt2.size(); i++ ) {
                        D06YpayDetailData_to_year data = (D06YpayDetailData_to_year)D06YpayDetailData_vt2.get(i);

                        String  zyy = data.ZYYMM.equals("TOTAL")?"TOTAL":data.ZYYMM.substring(0,4);
                        String  zmm = data.ZYYMM.equals("TOTAL")?"":data.ZYYMM.substring(4);
            %>
                <tr <%=data.ZYYMM.equals("TOTAL")?"class='sumRow'":""%>>
                    <td class=" align_center">
            <%  if (data.ZYYMM != null && data.ZYYMM.equals("TOTAL")){ %>
                <%=data.ZYYMM%>
            <%  } else { %>
                   <a href="javascript:month_kubyo('<%= data.ZYYMM %>', '<%= data.ZOCRSN %>', '<%= data.SEQNR %>');"><font color="#6699FF"><%= zyy+"."+zmm %></font></a>
            <%  }%>
                    </td>
                    <td ><%= data.BET01.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET01,2) %></td>
                    <td ><%= data.BET02.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET02,2) %></td>
                    <td ><%= data.BET03.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET03,2) %></td>
                    <td ><%= data.BET04.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET04,2) %></td>
                    <td ><%= data.BET06.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET06,2) %></td>
                    <td ><%= data.BET13.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET13,2) %></td>
                    <td ><%= data.BET09.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET09,2) %></td>
                    <td ><%= data.BET14.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET14,2) %></td>
                    <td ><%= data.BET16.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET16,2) %></td>
                    <td class=" lastCol"><%= data.BET17.equals("0") ? "0.00" : WebUtil.printNumFormat(data.BET17,2) %></td>
                </tr>
            <%
                    }
                } else {
            %>
                 <tr class="oddRow ">
                     <td  colspan="12" class="lastCol align_center"><spring:message code="MSG.COMMON.0004" /></td> <!-- No data-->
                 </tr>
            <%
                }
            %>
            </table>
        </div>
        
        
    </div>


      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="from_year1" value="">
      <input type="hidden" name="from_month1" value="">
      <input type="hidden" name="to_year1" value="">
      <input type="hidden" name="to_month1" value="">
</form>

<form name="form2" method="post" action="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="year1" value="">
      <input type="hidden" name="month1" value="">
      <input type="hidden" name="oo" value="ZZ00000">
      <input type="hidden" name="zocrsn" value="">
      <input type="hidden" name="zseqnr" value="">
      <input type="hidden" name="ocrsn" value="ZZ00000">    <!--Total -->
</form>

<form name="form3" method="post" action="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="year1" value="">
      <input type="hidden" name="month1" value="">
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