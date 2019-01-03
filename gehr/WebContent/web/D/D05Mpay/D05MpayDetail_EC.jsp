<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                          */
/*   1Depth Name    : Personal HR Info                                                                                                              */
/*   2Depth Name    : Monthly Salary                                                                                                                */
/*   Program Name   : Monthly Salary                                                                                                                */
/*   Program ID         : D05MpayDetailEurp.jsp                                                                                                         */
/*   Description        : 개인의 월급여내역 조회    [유럽용]                                                                                                         */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-07-01 yji                                                                                                        */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %><!--@v1.2-->

<%
    WebUserData user  = (WebUserData)session.getAttribute("user");

    boolean bFlag = false;
    Vector PAYLST = new Vector();
    Vector SOCIAL = new Vector();
    Vector d05MpayDetailData1_vt = (Vector)request.getAttribute("d05MpayDetailData1_vt");       // 지급내역/공제내역

    if(d05MpayDetailData1_vt == null){
      d05MpayDetailData1_vt = new Vector();
    }else{
       PAYLST = (Vector)d05MpayDetailData1_vt.get(1);
       SOCIAL = (Vector)d05MpayDetailData1_vt.get(0);
    }

    if(PAYLST.size() == 0){
      bFlag = false;
    }else{
      bFlag = true;
    }

    Vector d05ZocrsnTextData_vt = (Vector)request.getAttribute("d05ZocrsnTextData_vt");         // 과세추가내역

    if(d05ZocrsnTextData_vt == null){
      d05ZocrsnTextData_vt = new Vector();
    }

    D05MpayDetailData1 data2 = new D05MpayDetailData1();
    if(SOCIAL.size() != 0){
        data2 = (D05MpayDetailData1)SOCIAL.get(0);
    }

    D05MpayDetailData4 d05MpayDetailData4 = (D05MpayDetailData4) request.getAttribute("d05MpayDetailData4") ;
    D05MpayDetailData5 d05MpayDetailData5 = (D05MpayDetailData5) request.getAttribute("d05MpayDetailData5") ;

    //@v1.2 하드코딩내용변경 조회가능일을 가져 온다.
    D05LatestPaidRFC rfc_paid = new D05LatestPaidRFC();
    String paydt        = rfc_paid.getLatestPaid1(user.empNo, user.webUserId);
    String ableyear = paydt.substring(0,4);

    String yyyy         = (String)request.getAttribute("yyyy");
    String mm           = (String)request.getAttribute("mm");
    String year         = (String)request.getAttribute("year");
    String month        = (String)request.getAttribute("month");
    String ocrsn        = (String)request.getAttribute("ocrsn");
    String seqnr        = (String)request.getAttribute("seqnr");  // 5월 21일 순번 추가
    String backBtn  = ( String ) request.getAttribute("backBtn");  // new function

    //double money  = Double.parseDouble(d05MpayDetailData5.BET01) - Double.parseDouble(d05MpayDetailData5.BET02) ;

double money =  Double.parseDouble(d05MpayDetailData4.BET03);

    double money2 = 0.00;
    for(int i = 0 ; i < PAYLST.size() ; i++) {
        D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
        money2 = money2 + Double.parseDouble(data.BET01);
    }

    double money3 = 0.00;
    for(int i = 0 ; i < PAYLST.size() ; i++) {
        D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
        money3 = money3 + Double.parseDouble(data.BET02);
    }

%>


<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_MONT_PAY"/>
    <jsp:param name="help" value="D05Mpay.html"/>
</jsp:include>

<style type="text/css">
  .subWrapper{width:950px;}
</style>

<script language="JavaScript">
<!--
function doSubmit() {
    if( check_data() ) {
        blockFrame();
        document.form2.jobid.value      =  "<%="Y".equals(backBtn)?"search_back":"search" %>";
        document.form2.year1.value      = document.form1.year.options[document.form1.year.selectedIndex].text;
        document.form2.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
        document.form2.ocrsn.value          = document.form1.ZOCRSN.value;

        document.form2.action               = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailEurpSV";
        document.form2.target               = "menuContentIframe";
        document.form2.method           = "post";
        document.form2.method           = "post";
        document.form2.submit();
    }
}

function doSogub() {
    document.form3.year1.value              = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form3.month1.value         = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form3.ocrsn1.value         = document.form1.ZOCRSN.value;
    document.form3.action                   = "<%= WebUtil.ServletURL %>hris.D.D08RetroDetailSV";
    document.form3.method               = "post";
    document.form3.submit();
}

function zocrsn_get() {
    document.form1.jobid.value          = "getcode";
    document.form1.year1.value              = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.month1.value         = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form1.action                   = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailEurpSV";
    document.form1.target                   = "hidden";
    document.form1.method               = "post";
    document.form1.submit();
}

function kubya() {
    if(document.form1.year.options.length == 0){
        alert("<spring:message code='MSG.D.D05.0003'/>");//Please select year.
        document.form1.year.focus();
        return ;
    }

    if(document.form1.ZOCRSN.options.length == 0){
        alert("<spring:message code='MSG.D.D05.0004'/>");//Please select salary type.
        document.form1.ZOCRSN.focus();
        return ;
    }

    window.open('', 'essPrintWindow',
    		"toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=650,height=470");
    document.form2.jobid.value          = "kubya_1";
    document.form2.target               = "essPrintWindow";
    document.form2.year1.value          = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form2.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form2.ocrsn.value          = document.form1.ZOCRSN.value;
    document.form2.action               = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailEurpSV";
    document.form2.method           = "post";
    document.form2.submit();
}

function check_data(){
    if(document.form1.year.options.length == 0){
        alert("<spring:message code='MSG.D.D05.0003'/>");//Please select year.
        document.form1.year.focus();
        return false;
    }

    if(document.form1.ZOCRSN.options.length == 0){
        alert("<spring:message code='MSG.D.D05.0004'/>");//Please select salary type.
        document.form1.ZOCRSN.focus();
        return false;
    }

    date        = new Date();
    c_year  = date.getFullYear();
    c_month = date.getMonth()+1;
    year1   = document.form1.year.options[document.form1.year.selectedIndex].text;
    month1  = document.form1.month.value;

    if(year1 > c_year){
        alert("<spring:message code='MSG.D.D05.0001'/>");//Select year can't be later than current year.
        form1.year.focus();
        return false;
    } else if(year1 == c_year && month1 > c_month){
        alert("<spring:message code='MSG.D.D05.0002'/>");//Select month can't be later than current month.
        form1.month.focus();
        return false;
    }

    return true;
}

function f_onload(){
    number(d05MpayDetailData5.BET01) - number(d05MpayDetailData5.BET02)
}
//-->
</script>

<form name="form1" method="post">

<!--     <div class="title"><h1>Monthly Salary</h1></div> -->

    <!-- 상단 검색테이블 시작-->
    <div class="tableInquiry">
        <table>
            <tr style="line-height:0px ">
                <th><spring:message code="LABEL.D.D05.0002"/><!--Report Period--></th>
                <td>
                    <select name="year" onChange="javascript:zocrsn_get();">
						<%
						    for( int i = 2006 ; i <= Integer.parseInt(ableyear) ; i++ ) {
						        int year1 = Integer.parseInt(year);
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
                    <select name="month" onChange="javascript:zocrsn_get();">
						<%
						    for( int i = 1 ; i < 13 ; i++ ) {
						        String temp = Integer.toString(i);
						        int mon = Integer.parseInt(month);
						        if(mm == null || mm.equals("")){
						%>
						                      <option value="<%= i %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
						<%
						        }else{
						            int imm = Integer.parseInt(mm);
						%>
						                      <option value="<%= i %>"<%= imm == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
						<%
						        }
						    }
						%>
                    </select>
                    <select name="ZOCRSN">
					<%
					    for ( int i = 0 ; i < d05ZocrsnTextData_vt.size() ; i++ ) {
					        D05ZocrsnTextData data4 = (D05ZocrsnTextData)d05ZocrsnTextData_vt.get(i);

					%>
					    <option value="<%= data4.ZOCRSN + data4.SEQNR %>" <%= (ocrsn+seqnr).equals(data4.ZOCRSN + data4.SEQNR) ? "selected" : ""%>><%= data4.ZOCRTX %></option>
					<%

					    }
					%>
                    </select>
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:doSubmit();">
                        	<span><spring:message code="BUTTON.COMMON.SEARCH"/></span></a>
                    </div>
                  </td>
          <%
            if(bFlag){

         %>
            <td class="align_right" >
                <ul class="btn_mdl">
                    <li><a href="javascript: kubya() ;">
                    	<span><spring:message code="LABEL.D.D05.0003"/><!-- 급여명세표 --></span></a></li>
                </ul>
            </td>
           <%
            }else{
          %>
            <td class="align_right" >
                <ul class="btn_mdl">
                    <li style="display:none;"><a href="javascript: kubya() ;">
                    	<span><spring:message code="LABEL.D.D05.0003"/><!-- 급여명세표 --></span></a></li>
                </ul>
            </td>
          <%
            }
          %>

            </tr>
        </table>
    </div>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <colgroup>
                    <col width="13%" />
                    <col width="20%" />
                    <col width="13%" />
                    <col width="20%" />
                    <col width="10%" />
                    <col />
                </colgroup>
                <tr>
                  <th><%=g.getMessage("LABEL.D.D05.0004")%></th> <!-- Org.Unit -->
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

    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="year1" value="">
    <input type="hidden" name="month1" value="">
  <input type="hidden" name="backBtn" value="<%=backBtn%>">
 </form>

  <form name="form2" method="post" action="">
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="year1" value="">
    <input type="hidden" name="month1" value="">
    <input type="hidden" name="ocrsn" value="">
    <input type="hidden" name="seqnr" value="">
  </form>

  <form name="form3" method="post" action="">
    <input type="hidden" name="year1" value="">
    <input type="hidden" name="month1" value="">
    <input type="hidden" name="ocrsn1" value="">
    <input type="hidden" name="seqnr1" value="">
  </form>

<%
    if ( PAYLST.size() == 0 ) {
%>

    <!--급여명세 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral" onLoad="f_onload()">
                <colgroup>
                    <col width="13%" />
                    <col width="20%" />
                    <col width="13%" />
                    <col width="20%" />
                    <col width="10%" />
                    <col />
                </colgroup>
                <tr>
                    <th><spring:message code="LABEL.D.D05.0010" /><!-- Total Payment --></th>
                    <td class="align_right"></td>
                    <th class="th02"><spring:message code="LABEL.D.D05.0011" /><!--Total Deduction--></th>
                    <td class="align_right"></td>
                    <th class="th02"><spring:message code="LABEL.D.D05.0012" /><!--Net Payment--></th>
                    <td class="align_right"></td>
                </tr>
            </table>
        </div>
    </div>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
            <thead>
                <tr>
                    <th><spring:message code="LABEL.D.D05.0014" /></th><!-- Payment -->
                    <th><spring:message code="LABEL.D.D05.0037" /><!--Hours, %--></th>
                    <th><spring:message code="LABEL.D.D05.0015" /><!-- Amount --></th>
                    <th><spring:message code="LABEL.D.D05.0016" /></th><!-- Deduction -->
                    <th class="lastCol"><spring:message code="LABEL.D.D05.0015" /><!-- Amount --></th>
                </tr>
                <tr class="borderRow" valign="top">
                  <td class="align_left" height="120" style="vertical-align: top;"></td>
                  <td class="align_right" height="120" style="vertical-align: top;"></td>
                  <td class="align_right" height="120" style="vertical-align: top;"></td>
                  <td class="align_right" height="120" style="vertical-align: top;"></td>
                  <td class="align_right lastCol" height="120" style="vertical-align: top;"></td>
                </tr>
                <tr class="sumRow">
                    <th><spring:message code="LABEL.D.D06.0011" /><!--Total --></td>
                    <td class="align_right"></td>
                    <td class="align_right"></td>
                    <th><spring:message code="LABEL.D.D06.0011" /><!--Total --> </td>
                    <td class="lastCol align_right"></td>
                </tr>
            </table>
        </div>
    </div>


<%
    } else {
%>

    <!--급여명세 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral" onLoad="f_onload()">
                <colgroup>
                    <col width="13%" />
                    <col width="20%" />
                    <col width="13%" />
                    <col width="20%" />
                    <col width="10%" />
                    <col />
                </colgroup>
                <tr>
                  <th><spring:message code="LABEL.D.D05.0010" /><!-- Total Payment --></th>
                  <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET01,2) %></td>
                  <th class="th02"><spring:message code="LABEL.D.D05.0011" /><!--Total Deduction--></th>
                  <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02,2) %></td>
                  <th class="th02"><spring:message code="LABEL.D.D05.0012" /><!--Net Payment--></th>
                  <td class="align_right"><%= WebUtil.printNumFormat(money,2)%></td>
                </tr>
            </table>
        </div>
    </div>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
            <thead>
                <tr>
                  <th><spring:message code="LABEL.D.D05.0014" /></th><!-- Payment -->
                  <th><spring:message code="LABEL.D.D05.0037" /><!--Hours, %--></th>
                  <th><spring:message code="LABEL.D.D05.0015" /><!-- Amount --></th>
                  <th><spring:message code="LABEL.D.D05.0016" /></th><!-- Deduction -->
                  <th class="lastCol"><spring:message code="LABEL.D.D05.0015" /><!-- Amount --></th>
                </tr>
                <tr class="borderRow" valign="top">
                  <td class="align_left" height="120" style="vertical-align: top;">
            <%
                   for( int i = 0 ; i < PAYLST.size() ; i++ ) {
                    D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);

                    if(  !data.ANZHL.equals("0") && data.LGTXT.equals("Recalc.pay.total") ) {
            %>

                    <a href="javascript:doSogub();"><font color="#CC3300" weight="900"><%= data.LGTXT.equals("") ? "" : data.LGTXT%></font></a>&nbsp;<br>
            <%
                  }else{
            %>
                     <%= data.LGTXT.equals("") ? "" : data.LGTXT%>&nbsp;<br>
            <%
                  }
                 }
            %>
                  </td>
                  <td class="align_right" height="120" style="vertical-align: top;">
            <%
                   for( int i = 0 ; i < PAYLST.size() ; i++ ) {
                    D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
            %>
                   <%= data.ANZHL.equals("0") ? "" : data.ANZHL%>&nbsp;<br>
            <%
                 }
            %>
                  </td>
                  <td class="align_right" height="120" style="vertical-align: top;">
            <%
                   for( int i = 0 ; i < PAYLST.size() ; i++ ) {
                    D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
            %>
                 <%= data.BET01.equals("0") ? "" : WebUtil.printNumFormat(data.BET01,2) %>&nbsp;<br>
            <%
                 }
            %>
                  </td>
                  <td class="align_left" height="120"  style="vertical-align: top;;" >
           <%

                  for( int i = 0 ; i < PAYLST.size() ; i++ ) {
                   D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
                   if(  !data.ANZHL.equals("0") && data.LGTX1.equals("Recalc.deduc.total")) {
           %>
                    <a href="javascript:doSogub();"><font color="#CC3300" weight="900"><%= data.LGTX1.equals("") ? "　" :  data.LGTX1%></font></a>
           <%
                   } else {
           %>
                    <%= data.LGTX1.equals("") ? "" : data.LGTX1 %><br>
           <%
                        }
                    }
           %>
                  </td>
                  <td class="align_right lastCol" height="120" style="vertical-align: top;">
           <%
                  for( int i = 0 ; i < PAYLST.size() ; i++ ) {
                  D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
           %>
                   <%= data.BET02.equals("0") ? "" :WebUtil.printNumFormat(data.BET02,2) %>&nbsp;<br>

           <%
                   }
           %>
                  </td>
                </tr>
                <tr class="sumRow">
                  <th><spring:message code="LABEL.D.D06.0011" /><!--Total --></td>
                  <td class="align_right"></td>
                  <td class="align_right"><%= WebUtil.printNumFormat(money2,2) %></td>
                  <th><spring:message code="LABEL.D.D06.0011" /><!--Total --></td>
                  <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02,2) %></td>
                </tr>
            </table>
        </div>


    </div>

    <div class="commentsMoreThan2">
        <div><spring:message code="LABEL.D.D15.0119" />
        <%--Please do not share the HR information such as compensation, evaluation, etc.
                                                                            not only with any other company members,<br>
                                                                            but also with any person outside company.
                                                                             --%>
        </div>
    </div>

    <!--급여명세 테이블 시작-->

  <% } //@v1.3 end %>

<%if("Y".equals(backBtn)){ %>
<div class="buttonArea">

    <ul class="btn_crud">
        <li><a href="javascript:history.back()"><span><spring:message code="BUTTON.COMMON.BACK"></spring:message></span></a></li>
    </ul>

</div>
<div class="clear"> </div>
<%} %>


<!-- @v1.1-->
<iframe name="hidden" id="hidden" src="" width="0" height="0"></iframe>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
