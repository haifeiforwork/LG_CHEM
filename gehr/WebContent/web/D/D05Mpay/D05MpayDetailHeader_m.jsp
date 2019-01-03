<%/******************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Employee Data                                              */
/*   2Depth Name  : Payroll                                                      */
/*   Program Name : Monthly Salary                                                      */
/*   Program ID   : D05MpayDetailHeader_m.jsp                                         */
/*   Description  : 개인의 월급여내역 조회[NonChina -국내사용자페이지]                                      */
/*   Note         :                                                             */
/*   Creation     : 2010-08-04  yji                                        */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %><!--@v1.2-->
<%@ page import="com.sns.jdf.util.*" %>

<%
	WebUserData user_m = (WebUserData)session.getAttribute("user_m");
	WebUserData user = (WebUserData)session.getAttribute("user");

    Vector d05MpayDetailData1_vt = (Vector)request.getAttribute( "d05MpayDetailData1_vt" ); // 해외급여 반영내역(항목) 내역 
    Vector d05ZocrsnTextData_vt  = (Vector)request.getAttribute( "d05ZocrsnTextData_vt" );  // 급여사유 코드와 TEXT

    D05MpayDetailData4 d05MpayDetailData4 = (D05MpayDetailData4) request.getAttribute( "d05MpayDetailData4"  ) ; // 급여명세표 - 개인정보/환율 내역
    D05MpayDetailData5 d05MpayDetailData5 = (D05MpayDetailData5) request.getAttribute( "d05MpayDetailData5"  ) ; // 지급내역/공제내역의 합

    String yyyy      = ( String ) request.getAttribute("yyyy");
    String mm        = ( String ) request.getAttribute("mm");
    String year     = (String)request.getAttribute("year");
    String month    = (String)request.getAttribute("month");
    String ocrsn    = (String)request.getAttribute("ocrsn");
    String seqnr    = (String)request.getAttribute("seqnr");  // 5월 21일 순번 추가
    String k_yn     = "";
    String dis_play = "";
    String ocrsn_t  = "";
    
    boolean bFlag = false;
    
    if ( !ocrsn.equals("") ) {
        ocrsn_t  = ocrsn.substring(0,2);
    }

    int startYear = Integer.parseInt( DataUtil.getCurrentYear() );
    int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );
 
	Vector PAYLST = new Vector();
	Vector SOCIAL = new Vector();

    D05MpayDetailData1 data2 = new D05MpayDetailData1();
     
     if(d05MpayDetailData1_vt == null){
         d05MpayDetailData1_vt = new Vector();
	}else{
     	    PAYLST = (Vector)d05MpayDetailData1_vt.get(1);
     	    
     	    if (PAYLST.size() != 0 ) {
     	    	SOCIAL = (Vector)d05MpayDetailData1_vt.get(0);
     	    		if (SOCIAL.size() != 0 ) {
     	   				data2 = (D05MpayDetailData1)SOCIAL.get(0);
     	    		}
     	    }
	}
     
	if(PAYLST.size() == 0){
	    bFlag = false;
	}else{
	    bFlag = true;
	}
    
	double money =  Double.parseDouble(d05MpayDetailData5.BET01) - Double.parseDouble(d05MpayDetailData5.BET02) ;
    
    double money2 = 200.00;
    for( int i = 0 ; i < PAYLST.size() ; i++ ) {
		D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
        //money2 = money2 + Double.parseDouble(data.BET01);
    } 
    
    double money3 = 300.00;
    for( int i = 0 ; i < PAYLST.size() ; i++ ) {
		D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
        //money3 = money3 + Double.parseDouble(data.BET02);
    } 
    
    //@v1.2 하드코딩내용변경 조회가능일을 가져 온다.
    D05LatestPaidRFC rfc_paid = new D05LatestPaidRFC();
    String paydt = rfc_paid.getLatestPaid1(user_m.empNo, user_m.webUserId);
    String ableyear = paydt.substring(0,4);
    
    String curYear = DataUtil.getCurrentYear();
%>

<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D05.0101"/>  
    <jsp:param name="help" value="D05Mpay.html"/>    
</jsp:include>

<style type="text/css">
  .subWrapper{width:950px;}
</style>

<script language="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {

    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailHeaderSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function doSubmit() {
    if( check_data() ) {
        blockFrame();
        document.form2.jobid_m.value  = "search";
        
        if(document.form1.year.value !=""){
        	document.form2.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
        }else{
        	document.form2.year1.value = "<%= curYear%>";
        }
        
        document.form2.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
        document.form2.ocrsn.value  = document.form1.ZOCRSN.value;
        document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailHeaderSV_m";
        document.form1.target = "menuContentIframe";
        document.form2.method = "post";
        document.form2.submit();
    }
}

function doSogub() {

        if(document.form1.year.value !=""){
	        document.form3.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
        }else{
        	document.form3.year1.value = "<%= curYear%>";
        }
    
    document.form3.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form3.ocrsn1.value = document.form1.ZOCRSN.value;
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D08RetroDetailSV_m";
    document.form3.method = "post";
    document.form1.target = "menuContentIframe";
    document.form3.submit();
}

 
//2003.04.22 - 석유화학 요청으로 사원건강보험료조정 (최종)이 있는경우 임금유형 텍스트를 클릭시 정산세부내역을 POP-UP창으로 보여줌.

function kubya() {
    if(document.form1.ZOCRSN.options.length == 0){
    	alert("Please select salary type.");
    	document.form1.ZOCRSN.focus();
    	return ;
    }
 
    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=650,height=660");
    document.form2.jobid_m.value  = "kubya_1";
    document.form2.target = "essPrintWindow";
    
        if(document.form1.year.value !=""){
	        document.form2.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
        }else{
        	document.form2.year1.value = "<%= curYear%>";
        }
            
    document.form2.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form2.ocrsn.value  = document.form1.ZOCRSN.value;
    document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailHeaderSV_m";
    document.form2.method = "post";
    document.form2.submit();
}

function zocrsn_get() { 
    document.form1.jobid_m.value = "getcode";

        if(document.form1.year.value !=""){
	        document.form1.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
        }else{
        	document.form1.year1.value = "<%= curYear%>";
        }
                
    document.form1.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailHeaderSV_m";
    document.form1.target = "hidden";
    document.form1.method = "post";
    document.form1.submit();
}

function check_data(){
    if(document.form1.ZOCRSN.options.length == 0){
    	alert("Please select salary type.");
    	document.form1.ZOCRSN.focus();
    	return ;
    }
    date = new Date();
    c_year = date.getFullYear();
    c_month = date.getMonth()+1;
    
    if(document.form1.year.value !=""){
      	year1 = document.form1.year.options[document.form1.year.selectedIndex].text;
    }else{
       	year1 = "<%= curYear%>";
    }
    
    month1 = document.form1.month.value;
 
    if(year1 > c_year){
        alert("Select year can't be later than current year.");
        form1.year.focus();
        return false;
    } else if(year1 == c_year && month1 > c_month){
        alert("Select month can't be later than current month.");
        form1.month.focus();
        return false;
    }

    return true;
}
//-->
</script>

  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <form name="form1" method="post" action="">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">Monthly Salary</td>
                  <td align="right"><a href="javascript:open_help('X03PersonInfo.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"><img name="Image6" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="Guide"></a></td>
                </tr>
                <tr> 
                  <td height="3" colspan="2" align="left" valign="top" background="/web/images/maintitle_line.gif"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table></td>
          </tr>
          
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
 

<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>
    <tr>
            <td>
              <!-- 상단 검색테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr>
                  <td width="80" >Report Period</td>
                  <td  colspan="5">
                    <select name="year" class="input03" onChange="javascript:zocrsn_get();"> 
<%
    for( int i = 2001 ; i <= Integer.parseInt(ableyear) ; i++ ) {
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
                    <select name="month" class="input03" onChange="javascript:zocrsn_get();">
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
                    <select name="ZOCRSN" class="input03" >
<%
    for ( int i = 0 ; i < d05ZocrsnTextData_vt.size() ; i++ ) {
        D05ZocrsnTextData data4 = (D05ZocrsnTextData)d05ZocrsnTextData_vt.get(i);
 
%>
    <option value="<%= data4.ZOCRSN + data4.SEQNR %>" <%= (ocrsn+seqnr).equals(data4.ZOCRSN + data4.SEQNR) ? "selected" : ""%>><%= data4.ZOCRTX %></option>

<%
 
    }
%>

                    </select>
					<a href="javascript:doSubmit();"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif"  align="absmiddle" border="0"> </a>
				  </td>
				  <%
				  	if(bFlag){ 
				 %> 	
			         <td  ><a href="javascript: kubya() ;"><img src="<%= WebUtil.ImageURL %>btn_pay.gif" border="0" align="absmiddle"></a></td>
				   <%
				  	}else{
				  %>
				  	 <td  ><a href="javascript: kubya() ;"><img style="display:none" src="<%= WebUtil.ImageURL %>btn_pay.gif" border="0" align="absmiddle"></a></td>
				  <%	
				  	}
				  %>
                </tr>
                <tr>
                  <td  width="80">Org.Unit</td>
                  <td  ><%= user_m.e_orgtx %></td>
                  <td  width="80">Pers.No</td>
                  <td  width="100"><%= user_m.empNo %></td>
                  <td  width="80" colspan="2">Name</td>
                  <td  width="100"><%= user_m.ename %></td>
                </tr>
              </table>
              <!-- 상단 검색테이블 끝-->
            </td>
          </tr>
     <input type="hidden" name="jobid_m" value="">
    <input type="hidden" name="year1" value="">
    <input type="hidden" name="month1" value="">
 </form>

  <form name="form2" method="post" action="">
    <input type="hidden" name="jobid_m" value="">
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
         <tr>
            <td height="10">&nbsp;</td>
          </tr>
          
          <tr>
            <td>
              <!--급여명세 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02" onLoad="f_onload()">
                <tr>
                  <td  width="100">Total Payment</td>
                  <td  width="160" align="right"></td>
                  <td  width="100">Total Deduction</td>
                  <td  width="160" align="right"></td>
                  <td  width="100">Net Payment</td>
                  <td  width="160" align="right"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr>
                  <td  width="250">Payment</td>
                  <td  width="80">Hours, %</td>
                  <td  width="100">Amount</td>
                  <td  width="250">Deduction</td>
                  <td  width="100">Amount</td>
                </tr>
                <tr valign="top">
                  <td  height="120" style="vertical-align: top;text-align:left"></td>
                  <td  height="120" align="right" style="vertical-align: top;"></td>
                  <td  height="120" align="right" style="vertical-align: top;"></td>
                  <td  height="120" align="right" style="vertical-align: top;"></td>
                  <td  height="120" align="right" style="vertical-align: top;"></td>
                </tr>
                <tr>
                  <td >Total </td> 
                  <td  align="right"></td>
                  <td  align="right"></td>
                  <td  >Total </td>
                  <td  align="right"></td>
                </tr>
              </table>
            </td>
          </tr>
          
<%
    } else {
%>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          
          <tr>
            <td>
              <!--급여명세 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02" onLoad="f_onload()">
                <tr>
                  <td  width="100">Total Payment</td>
                  <td  width="160" align="right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET01,2) %>&nbsp;</td>
                  <td  width="100">Total Deduction</td>
                  <td  width="160" align="right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02,2) %>&nbsp;</td>
                  <td  width="100">Net Payment</td>
                  <td  width="160" align="right"><%= WebUtil.printNumFormat(money,2)%>  &nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
          
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr>
                  <td  width="250">Payment</td>
                  <td  width="80">Hours, %</td>
                  <td  width="100">Amount</td>
                  <td  width="250">Deduction</td>
                  <td  width="100">Amount</td>
                </tr>
                <tr valign="top">
                  <td  height="120" style="vertical-align: top;">
			<% 
				   for( int i = 0 ; i < PAYLST.size() ; i++ ) {
				    D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
		  
			        if( data.LGTXT.equals("Recalc.pay.total") ) {  
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
                  <td  height="120" align="right" style="vertical-align: top;">
            <% 
				   for( int i = 0 ; i < PAYLST.size() ; i++ ) {
				    D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
			%>
			       <%= data.ANZHL.equals("0") ? "" : data.ANZHL%>&nbsp;<br>
		    <%
                 } 
			%>
                  </td>
                  <td  height="120" align="right" style="vertical-align: top;">
            <% 
				   for( int i = 0 ; i < PAYLST.size() ; i++ ) {
				    D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
			%>
			     <%= data.BET01.equals("0") ? "" : WebUtil.printNumFormat(data.BET01,2) %>&nbsp;<br>
		    <%
                 } 
			%>
 
                  </td>
                  <td  height="120"  style="vertical-align: top;" >
	       <%

	              for( int i = 0 ; i < PAYLST.size() ; i++ ) {
	               D05MpayDetailData2 data = (D05MpayDetailData2)PAYLST.get(i);
	               if( data.LGTX1.equals("Recalc.deduc.total") ) {
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
                  <td  height="120" align="right" style="vertical-align: top;">
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
                <tr>
                  <td >Total Payment</td> 
                  <td  align="right"></td>
                  <td  align="right"><%= WebUtil.printNumFormat(money2,2) %>&nbsp;</td>
                  <td  >Total Deduction</td>
                  <td  align="right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02,2) %>&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
		<%
		    if(user_m.e_area.equals("28")){
	    %>
          <tr>
            <td>
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr>
                  <td  width="180" rowspan="2">Employer<br>Social&nbsp;Insurance</td>
 				   <td  width="180"> Pension </td>
 				   <td  width="180"> Medical Care </td>
 				   <td  width="180"> Unemployment </td>
 				   <td  width="180"> On-Job Injury </td>
 				   <td  width="180"> Maternity  </td>
 				   <td  width="180"> Public Housing Fund </td>
                </tr>
                <tr> 
 				   <td  width="180"> <%= data2.BET01.equals("0") ? "" :WebUtil.printNumFormat(data2.BET01,2) %> </td>
 				   <td  width="180"> <%= data2.BET02.equals("0") ? "" :WebUtil.printNumFormat(data2.BET02,2) %> </td>
 				   <td  width="180"> <%= data2.BET03.equals("0") ? "" :WebUtil.printNumFormat(data2.BET03,2) %> </td>
 				   <td  width="180"> <%= data2.BET04.equals("0") ? "" :WebUtil.printNumFormat(data2.BET04,2) %> </td>
 				   <td  width="180"> <%= data2.BET05.equals("0") ? "" :WebUtil.printNumFormat(data2.BET05,2) %> </td>
 				   <td  width="180"> <%= data2.BET06.equals("0") ? "" :WebUtil.printNumFormat(data2.BET06,2) %> </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
		<%      
		   }
		    if(user_m.e_area.equals("27")){
		%>
		   <tr>
            <td>
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr>
                  <td >MPF(Employer)</td>
 				  <td><%= data2.BET01.equals("0") ? "" :WebUtil.printNumFormat(data2.BET01,2) %></td>
 				</tr>  
 		      </table>
            </td>
          </tr>  
 				
		<%
		    }
		    if(user_m.e_area.equals("42") ){
	    %>
         <tr>
            <td>
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr>
                  <td  width="180" rowspan="2">Employer<br>Social&nbsp;Insurance</td>
 				   <td  width="180"> Labor </td>
 				   <td  width="180"> Employment </td>
 				   <td  width="180"> National Heath </td>
 				   <td  width="180"> New Pension</td> 
                </tr>
                <tr>
 				   <td  width="180"> <%= data2.BET01.equals("0") ? "" :WebUtil.printNumFormat(data2.BET01,2) %> </td>
 				   <td  width="180"> <%= data2.BET02.equals("0") ? "" :WebUtil.printNumFormat(data2.BET02,2) %> </td>
 				   <td  width="180"> <%= data2.BET03.equals("0") ? "" :WebUtil.printNumFormat(data2.BET03,2) %> </td>
 				   <td  width="180"> <%= data2.BET04.equals("0") ? "" :WebUtil.printNumFormat(data2.BET04,2) %> </td> 
                </tr>
              </table>
            </td>
          </tr>
	<%
	    }
	%>
                <tr>
                  <td>&nbsp;</td>
                </tr>
<%
    }
%>
              </table>
              
            </td>
          </tr>
          <tr>
            <td height="30">&nbsp;</td>
          </tr>
		  <%
		  	if(yyyy==null||yyyy.equals("")){
		  	}else{
		  %>       
		    <tr> 
		      <td align="center" colspan=2><a href="javascript:history.back()"><img src="<%= WebUtil.ImageURL %>btn_prevview.gif" border="0"></a> 
		      </td>
		    </tr>
		  <%} %>
        </table>

 
  <% } //@v1.3 end %>              

 
<!-- @v1.1-->
<iframe name="hidden" id="hidden" src="" width="0" height="0"></iframe>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

