<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                          */
/*   1Depth Name    : Personal HR Info                                                                                                              */
/*   2Depth Name    : Payroll                                                                                                                       */
/*   Program Name   : Monthly Salary                                                                                                                */
/*   Program ID         : D05MpayhwahakUsa.jsp                                                                                                  */
/*   Description        : 급여명세표 조회 (USA)                                                                                                        */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-10-29 jungin @v1.0                                                                                               */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="com.common.constant.Area" %>
<%
    Vector PAYLST = new Vector();
    Vector SOCIAL    = new Vector();

    WebUserData user = (WebUserData)session.getAttribute("user");

    Vector d05MpayDetailData1_vt = (Vector)request.getAttribute("d05MpayDetailData1_vt");   // 지급내역/공제내역
    Vector d05ZocrsnTextData_vt = (Vector)request.getAttribute("d05ZocrsnTextData_vt");         // 과세추가내역

    if (d05MpayDetailData1_vt == null) {
      d05MpayDetailData1_vt = new Vector();
    } else {
       PAYLST = (Vector)d05MpayDetailData1_vt.get(1);
       SOCIAL = (Vector)d05MpayDetailData1_vt.get(0);
    }

    if (d05ZocrsnTextData_vt == null) {
        d05ZocrsnTextData_vt = new Vector();
    }

    D05MpayDetailData4 d05MpayDetailData4 = (D05MpayDetailData4) request.getAttribute("d05MpayDetailData4");    // 급여명세표 - 개인정보/환율 내역
    D05MpayDetailData5 d05MpayDetailData5 = (D05MpayDetailData5) request.getAttribute("d05MpayDetailData5");    // 지급내역/공제내역의 합

    String year = (String)request.getAttribute("year");
    String month = (String)request.getAttribute("month");
    String ocrsn = (String)request.getAttribute("ocrsn");
    String seqnr = (String)request.getAttribute("seqnr");

    String zocrsnTxt = "";
    for (int i = 0 ; i < d05ZocrsnTextData_vt.size() ; i ++) {
        D05ZocrsnTextData data4 = (D05ZocrsnTextData)d05ZocrsnTextData_vt.get(i);
        if ((user.area.equals(Area.DE) || user.area.equals(Area.PL)) && (ocrsn.equals(data4.ZOCRSN))){	        
            zocrsnTxt = data4.ZOCRTX;
        }else{	         
	        if(ocrsn.equals(data4.ZOCRSN) && seqnr.equals(data4.SEQNR)) 
   	        zocrsnTxt = data4.ZOCRTX;
       	}
    }

    D05MpayDetailData1 data2 = new D05MpayDetailData1();
    if (SOCIAL.size() != 0) {
       data2 = (D05MpayDetailData1)SOCIAL.get(0);
    }

    double NetPayment = Double.parseDouble(d05MpayDetailData5.BET01) - Double.parseDouble(d05MpayDetailData5.BET02);
    //double NetPayment = Double.parseDouble(d05MpayDetailData4.BET03);
    double incomeTotal = 0.00;
    
    if (user.area.equals(Area.DE) || user.area.equals(Area.PL)){          
        for (int i = 0; i < PAYLST.size(); i++ ) {
            D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
            incomeTotal = incomeTotal + Double.parseDouble(data.BET01);
        }
    }   else{
    	incomeTotal = Double.parseDouble(d05MpayDetailData5.BET01);
    }
    
%>

<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D05.0003"/>
    <jsp:param name="help" value="D05Mpay.html"/>
</jsp:include>


<SCRIPT LANGUAGE="JavaScript">
<!--
    function f_print() {
        self.print();
    }
//-->
</SCRIPT>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
	            <colgroup>
		            <col width=30%/>
		            <col />
		            <col width=10%/>
		            <col width=20%/>
            	</colgroup>
            <thead>
              <tr>
                <th><spring:message code="LABEL.D.D05.0002"/><!--Report Period--></th>
                <th><spring:message code="LABEL.D.D05.0004"/><!-- 부서명 --></th>
                <th><spring:message code="LABEL.D.D05.0005"/><!-- 사번 --></th>
                <th class="lastCol"><spring:message code="LABEL.D.D05.0006"/><!-- 성명 --></th>
              </tr>
              <tr >
                <td><%= year %>.<%= month %>.<%= zocrsnTxt %></td>
                <td><%= user.e_orgtx %></td>
                <td><%= user.empNo %></td>
                <td class="lastCol"><%= user.ename %></td>
              </tr>
              </thead>
            </table>
        </div>
    </div>

    <!--급여명세 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral" onLoad="f_onload()">
                <tr>
                  <th><spring:message code="LABEL.D.D05.0010" /><!-- Total Payment --></th>
                  <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET01,2) %></td>
                  <th class="th02"><spring:message code="LABEL.D.D05.0011" /><!--Total Deduction--></th>
                  <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02,2) %></td>
                  <th class="th02"><spring:message code="LABEL.D.D05.0012" /><!--Net Payment--></th>
                  <td class="align_right"><%= WebUtil.printNumFormat(NetPayment,2)%></td>
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
                <tr valign="top">
                  <td class="align_left" height="120" style="vertical-align: top;">
                    <%
                        for (int i = 0; i < PAYLST.size(); i++ ) {
	                            D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
	                            if(!data.BET01.equals("0") ){
		                            if (data.LGTXT.equals("Recalc.pay.total")) {
		                    %>
		                            <font color="#CC3300" weight="900"><%= data.LGTXT.equals("") ? "" : data.LGTXT %></font><br>
		                    <%
		                            } else {
		                    %>
		                             <%= data.LGTXT.equals("") ? "" : data.LGTXT %><br>
		                    <%
		                           }
	                            }
                         }
                    %>
                  </td>

                  <td class="align_right" height="120" style="vertical-align: top;">
                    <%
                           for (int i = 0; i < PAYLST.size(); i++ ) {
                            D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
                    %>
                           <%= data.ANZHL.equals("0") ? "" : data.ANZHL %><br>
                    <%
                            }
                    %>
                  </td>

                  <td class="align_right" height="120" style="vertical-align: top;">
                    <%
                           for (int i = 0; i < PAYLST.size(); i++ ) {
                            D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
                    %>
                         <%= data.BET01.equals("0") ? "" : WebUtil.printNumFormat(data.BET01,2) %><br>
                    <%
                            }
                    %>
                  </td>



                  <td class="align_left" height="120" style="vertical-align: top;">
                   <%
                          for (int i = 0; i < PAYLST.size(); i++ ) {
	                           D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
	                            if(!data.BET02.equals("0") ){
			                           if (data.LGTX1.equals("Recalc.deduc.total")) {
			                   %>
			                            <font color="#CC3300" weight="900"><%= data.LGTX1.equals("") ? "　" :  data.LGTX1 %></font>
			                   <%
			                           } else {
			                   %>
			                            <%= data.LGTX1.equals("") ? "" : data.LGTX1 %><br>
			                   <%
			                                }
			                            }
                          }
                   %>
                  </td>

                  <td class="align_right lastCol" height="120" style="vertical-align: top;">
                   <%
                          for (int i = 0; i < PAYLST.size(); i++ ) {
                          D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
                   %>
                           <%= data.BET02.equals("0") ? "" :WebUtil.printNumFormat(data.BET02,2) %><br>
                   <%
                           }
                   %>
                  </td>

                </tr>
                <tr class="sumRow">
                  <td><spring:message code="LABEL.D.D06.0011" /><!-- Total --></td>
                  <td class="align_right"></td> 
                  <td class="align_right"><%= WebUtil.printNumFormat(incomeTotal,2) %></td>
                  <td><spring:message code="LABEL.D.D06.0011" /><!-- Total --></td>
                  <td class="align_right lastCol"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02,2) %></td>
                </tr>
                </thead>
            </table>
        </div>
    </div>


<%
    if(user.e_area.equals("28")){ // 선진특화
%>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
            <thead>
                <tr>
                   <th rowspan="2"><spring:message code="LABEL.D.D05.0123" /><!--Employer<br>Social Insurance--></th>
                   <th><spring:message code="LABEL.D.D05.0124" /><!--Pension--></th>
                   <th><spring:message code="LABEL.D.D05.0125" /><!--Medical Care--></th>
                   <th><spring:message code="LABEL.D.D05.0126" /><!--Unemployment--></th>
                   <th><spring:message code="LABEL.D.D05.0127" /><!--On-Job Injury--></th>
                   <th><spring:message code="LABEL.D.D05.0128" /><!--Maternity--></th>
                   <th ><spring:message code="LABEL.D.D05.0129" /><!--Public Housing Fund--></th>
                </tr>
                <tr class="borderRow">
                   <td class="align_right"><%= data2.BET01.equals("0") ? "" :WebUtil.printNumFormat(data2.BET01,2) %></td>
                   <td class="align_right"><%= data2.BET02.equals("0") ? "" :WebUtil.printNumFormat(data2.BET02,2) %></td>
                   <td class="align_right"><%= data2.BET03.equals("0") ? "" :WebUtil.printNumFormat(data2.BET03,2) %></td>
                   <td class="align_right"><%= data2.BET04.equals("0") ? "" :WebUtil.printNumFormat(data2.BET04,2) %></td>
                   <td class="align_right"><%= data2.BET05.equals("0") ? "" :WebUtil.printNumFormat(data2.BET05,2) %></td>
                   <td class="align_right lastCol"><%= data2.BET06.equals("0") ? "" :WebUtil.printNumFormat(data2.BET06,2) %></td>
                </tr>
                <tr >
                   <th ><spring:message code="LABEL.D.D05.0135" /><!--<br>Insurance Number--></th>
                   <td colspan="3"><%= data2.INNUM %></td>
                   <td ><spring:message code="LABEL.D.D05.0136" /></td>
                   <td colspan="2" class="lastCol"><%= data2.PHFNO %></td>
                </tr>
            </table>
        </div>
    </div>

<%

   }
    if(user.e_area.equals("27")){
%>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
		        <tr>
		          <th  class="align_left"  width="200">
		                <spring:message code="LABEL.D.D05.0130" /><!--MPF(Employer)-->
		          </th>
		          <td  ><%= data2.BET01.equals("0") ? "" :WebUtil.printNumFormat(data2.BET01,2) %></td>
		        </tr>
		    </table>
        </div>
    </div>


        <%
            }
            if(user.e_area.equals("42")){
        %>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
                <tr>
                   <th  rowspan="2"><spring:message code="LABEL.D.D05.0123" /><!--Employer<br>Social Insurance--></th>
                   <th><spring:message code="LABEL.D.D05.0131" /><!--Labor--></th>
                   <th><spring:message code="LABEL.D.D05.0132" /><!--Employment--></th>
                   <th><spring:message code="LABEL.D.D05.0133" /><!--National Heath--></th>
                   <th class="lastCol"><spring:message code="LABEL.D.D05.0134" /><!--New Pension--></th>
                </tr>
                <tr class="borderRow">
                   <td class="align_right"><%= data2.BET01.equals("0") ? "" :WebUtil.printNumFormat(data2.BET01,2) %></td>
                   <td class="align_right"><%= data2.BET02.equals("0") ? "" :WebUtil.printNumFormat(data2.BET02,2) %></td>
                   <td class="align_right"><%= data2.BET03.equals("0") ? "" :WebUtil.printNumFormat(data2.BET03,2) %></td>
                   <td class="align_right lastCol"><%= data2.BET04.equals("0") ? "" :WebUtil.printNumFormat(data2.BET04,2) %></td>
                </tr>
            </table>
        </div>
    </div>

<%
    }
%>


    <div class="textDiv">
      <table  width=100% class="tableGeneral" >
      <colgroup>
     		<col width="80%" />
     		<col />
      </colgroup>
        <tr>
          <td ><spring:message code="LABEL.D.D15.0085" /><!--Thank you for your service and workmanship very much.-->
          <%             if(user.companyCode.equals("G260")){          %>
            <td width="160"  class="align_right"><img src="<%= WebUtil.ImageURL %>img_logo_chem.gif" width="159" height="30" align="absmiddle"></td>
          <%}else     if(user.companyCode.equals("G290")){          %>
            <td width="160" class="align_right"><img src="<%= WebUtil.ImageURL %>img_logo_cewr.gif" width="159" height="30" align="absmiddle"></td>
          <%}else      if (user.companyCode.equals("G340")) {          %>
            <td width="122"><img src="<%= WebUtil.ImageURL %>img_logo_cai.gif" align="absmiddle"></td>
          <%}else       if (user.companyCode.equals("G400")) {          %>
            <td width="122"><img src="<%= WebUtil.ImageURL %>img_logo_cpi.gif" align="absmiddle"></td>
          <%} else          {%>
            <td width="160"  class="align_right"><img src="<%= WebUtil.ImageURL %>img_logo_chem.gif" width="159" height="30" align="absmiddle"></td>
          <%}%>
        </tr>
      </table>
    </div>


    <div class="commentsMoreThan2">
        <div><spring:message code="LABEL.D.D15.0119" />
        <!-- please do not share the HR information such as compensation, evaluation ,
                           etc. not only with any other company members, but also with any person outside company.-->
        </div>
    </div>


<jsp:include page="/include/pop-body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
