<%/******************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Employee Data                                                            */
/*   2Depth Name  : Payroll                                                      */
/*   Program Name : Annual Salary                                                      */
/*   Program ID   : D06YpayDetail_to_yearHeader_m.jsp                                 */
/*   Description  : 개인의 연급여에 대한 상세내용을 조회[NonChina -국내사용자페이지]                        */
/*   Note         :                                                             */
/*   Creation     : 2010-08-04  yji                                          */
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

<script language="JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
    window.open(theURL,winName,features);
}

function  doSearchDetail() {
    //무조건 헤더용SV으로 분기하여, 내부에서 처리
	document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayDetail_to_yearHeaderSV_m";
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

        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayDetail_to_yearHeaderSV_m";
        document.form1.method = "post";
        document.form1.submit();
    }
}

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

function month_kubyo(zyymm) {
    //document.form2.jobid.value  = "month_kubyo";
    if(zyymm == 'TOTAL')
    	return;
    document.form2.yyyy.value  = zyymm.substring(0,4);
    document.form2.mm.value  = zyymm.substring(4,6);
    document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailHeaderSV_m";
    document.form2.method = "post";
    document.form2.submit();
}
function month_kubyo_2(zyymm) {
    //document.form2.jobid.value  = "month_kubyo";
    if(zyymm == 'TOTAL')
    	return;
    document.form3.year1.value  = zyymm.substring(0,4);
    document.form3.month1.value  = zyymm.substring(4,6);
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D08RetroDetailSV_m";
    document.form3.method = "post";
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

    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayDetail_to_yearHeaderSV_m";
    document.form3.method = "post";
    document.form3.submit();
}

function check_data(){
    date = new Date();
    c_year = date.getFullYear();

    from_year1 = document.form1.from_year.options[document.form1.from_year.selectedIndex].text;

    if(from_year1 > c_year){
        alert("현재 년도보다 큽니다.");
        form1.from_year.focus();
        return false;
    }
    return true;
}
//-->
</script>


<jsp:include page="/include/header.jsp" />

<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_ANNU_PAY"/>  
    <jsp:param name="help" value="D06Ypay.html"/>    
</jsp:include>

<form name="form1" method="post" action="">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="" border="0" cellpadding="0" cellspacing="0">
            <tr>
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" ></td>
                </tr>
                <tr>
                  <td width="624" class="title02">&nbsp;&nbsp;<img src="<%= WebUtil.ImageURL %>ehr/title01.gif" />Annual Salary</td>
                  <td align="right"><a href="javascript:open_help('X03PersonInfo.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"><img name="Image6" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="Guide"></a></td>
                </tr>
              </table></td>
    </tr>
          
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
       <tr>
            <td><table width="" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td> <font color="#CC3300">
                  ※ Please do not share the information of compensation, or will be disciplined according to the working regulation.
                    </font></td>
                </tr>
              </table>
            </td>
          </tr>

          <tr>
            <td>
              <!--조회기간 테이블 시작-->
              <table width="780" border="0" cellpadding="2" cellspacing="1" class="table02">
                <tr>
                  <td  width="100">Report Period</td>
                  <td colspan="6" > <select name="from_year">
                      <%= WebUtil.printOption(CodeEntity_vt, from_year ) %>
                      <%-- 테스트 위해서 임시코딩 --%>
                    </select> <a href="javascript:doSubmit();"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif" border="0" align="absmiddle" /></a>
                  </td>
                </tr>
                <tr>
                  <td >Org.Unit</td>
                  <td  ><%= user_m.e_orgtx %></td>
                  <td  width="80">Pers.No</td>
                  <td  width="100"><%= user_m.empNo %></td>
                  <td  width="80">Name</td>
                  <td  width="100"><%= user_m.ename %></td>
                </tr>
              </table>
              </table>
              <!--조회기간 테이블 끝-->
            </td>
          </tr>
           <tr>
 	           <td height="10">&nbsp;</td>
          </tr>
<%--           
          <%
          if ( D06YpayDetailData_vt.size() == 1 ) {
          %>
          <tr>
			<td width="16">&nbsp;</td>	         
			   <td height="10">&nbsp;</td>
          </tr>
          <tr>
          <td width="16">&nbsp;</td>
            <td>
              <!-- 상단 검색테이블 시작-->
              <table width="780" border="0" cellspacing="0" cellpadding="0" class="table02">
                <tr>
            		<td  style="text-indent: 350px;text-align:left; ">No data</td>
                </tr>
               </table>
             </td>
          </tr>
          <% }
          else {
          %>
--%>    
    
    <tr>
      <td width="15" nowrap="nowrap">&nbsp;</td>
      <td>
        	<table width="" border="0" cellspacing="1" cellpadding="2" class="table02">
          <tr>
            <td  rowspan="2" width="60" valign="center">Period</td>
            <td  colspan="5">Payment</td>
            <td  colspan="<%=user.e_area.equals("28")? "5" : user.e_area.equals("42")? "4" : "3" %>" >Deduction</td>
            <td  rowspan="2" width="69" valign="center">Net Payment</td>
            <td  rowspan="2" width="55">Total</td>
          </tr>
          <tr>
            <td  width="66">Salary</td>
            <td  width="63">Allowance</td>
            <td  width="63">Overtime</td>
            <td  width="71">Incentive</td>
            <td  width="72">Total</td>
            
            <%if(!user.e_area.equals("27")){ %>
            <td  width="55">Tax</td>
            <%}%>
            <td  width="71">Social Insurance</td>
            <%if(user.e_area.equals("28") ){%>
            <td  width="66">PHF</td>
            <%}%>
            <td  width="55">Others</td>
          </tr>
<%
    if ( D06YpayDetailData_vt.size() > 1 ) {  
  
    for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
    D06YpayDetailData_to_year data = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);
    String  zyy = data.ZYYMM.equals("TOTAL")?"TOTAL":data.ZYYMM.substring(0,4);
    String  zmm = data.ZYYMM.equals("TOTAL")?"":data.ZYYMM.substring(4);
    String salary = String.valueOf(Double.parseDouble(data.BET01) + Double.parseDouble(data.BET02) + Double.parseDouble(data.BET03));
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
            <td ><%= data.BET17.equals("0") ? "" : WebUtil.printNumFormat(data.BET17,2) %></td>
          </tr>
<%
    } //end for
%> 
<%   
  }else{
%>

    <tr align="center">
             <td  colspan="12"  align="center" height="25" >No data</td>      
    </tr>
   

<%
  } //end if
%>

</table>
</td>
</tr>
</table>
  <input type="hidden" name="jobid_m" value="">
</form>
<form name="form2" method="post" action="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="yyyy" value="">
      <input type="hidden" name="mm" value="">
</form>
<form name="form3" method="post" action="">
      <input type="hidden" name="jobid_m" value="">
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="year1" value="">
      <input type="hidden" name="month1" value="">
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
