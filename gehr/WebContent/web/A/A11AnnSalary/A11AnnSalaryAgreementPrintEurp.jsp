<%/***************************************************************************************/      																				
/*   System Name  	: g-HR              																												*/                                           																	
/*   1Depth Name  	: Personal HR Info                                               																*/
/*   2Depth Name  	: Personal Info                                               																	*/
/*   Program Name 	: Annual Salary Agreement                                  																				*/
/*   Program ID   		: A11AnnSalaryAgreementPrintEurp.jsp[독일용]                            																*/
/*   Description  		: Agreement                                            																	*/
/*   Note         		:                                                         																			*/
/*   Creation     		: 2010-07-20 yji                                          																		*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.A10Annual.*" %>
<%@ page import="hris.C.*" %>
<%@ page import="hris.common.util.*" %>

<%
	WebUserData user		= (WebUserData)session.getAttribute("user");

	//연봉정보
    Vector a11AnnSalaryAgreementData_vt = (Vector)request.getAttribute("a11AnnSalaryAgreementData_vt");
	

	//연봉정보
    Vector a11AnnSalaryAgreementData_vt2 = (Vector)request.getAttribute("a11AnnSalaryAgreementData_vt2");

//    String ES_RETURN 	= (Vector)request.getAttribute("ES_RETURN");
    String E_YEAR 	= (String)request.getAttribute("E_YEAR");
    String E_DEAR 	= (String)request.getAttribute("E_DEAR");    
%>

<html>
<head>
<title></title>

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<!-- Page Skip 해서 프린트 하기 -->
<style type = "text/css">
P.breakhere {page-break-before: always}
</style>

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--

function prevDetail() {
	switch (location.hash)  {
		case "#page2":
			location.hash="#page1";
		break;
	} // end switch
}

function nextDetail() {
	switch (location.hash)  {
		case "":
		case "#page1":
			location.hash ="#page2";
		break;
	} // end switch
}

function click() {
    if (event.button==2) {
      alert('Can\'t use the right button.');
      
   return false;
    }
  }
  
function keypressed() { 
       return false;
  }
  
	document.onmousedown=click;
	document.onkeydown=keypressed;
	
//-->
</SCRIPT>

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
<table width="635" border="0" cellspacing="1" cellpadding="0" align="center" bgcolor="#d4d4d4">
  <tr>
	<td>
<table width="635" border="0" cellspacing="1" cellpadding="4" align="center" bgcolor="#ffffff">

<!--   ***************** 연봉협의서 시작 *****************  -->
  <tr>
	<td>
	  <table width="635" border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td>&nbsp;</td>
	   </tr>
		<tr>
		  <td>&nbsp;</td>
	   </tr>	   
		<tr>
		  <td align="center" style="font-family:굴림, 굴림체;font-size: 26px;height:30px;line-height: 30px;"><u><b><%=E_YEAR %>&nbsp;Annual Salary Agreement<b></u><a name="page1">&nbsp;</a></td>
	   </tr>
	  </table>
	</td>
  </tr>
  <tr>
	<td>
	  <table width="635" border=0 cellspacing="1" cellpadding="0">
		<tr>
		  <td class="td03_p" width="400" style="text-align:left">&nbsp;<td>
		</tr>
		<tr>
		  <td class="td03_p" width="400" style="text-align:left">&nbsp;<td>
		</tr>
		<tr>
		  <td class="td04" style="text-align:left;font-family:굴림, 굴림체;font-size:15px;"><b>Dear&nbsp;<%=E_DEAR %></b>
		  </td>
		</tr>

		<tr>
		  <td class="td03_p" width="400" style="text-align:left">&nbsp;<td>
		</tr>
				
		<tr>
			<td class="td04" style="text-align:left;font-family:굴림, 굴림체;font-size:14px;">
			LG Chem Europe GmbH("Company") and employee agree with&nbsp;<%=E_YEAR %>&nbsp;annual salary of the following.
		</tr>

		<tr>
		  <td class="td03_p" width="400" style="text-align:left">&nbsp;<td>
		</tr>		
	  </table>
	</td>
  </tr>
  <tr>
	<td>
	  <table width="635" border="0" cellspacing="0" cellpadding="0">
		<tr> 
		  <td style="vertical-align: top;">	
			<table  width="590" height="120" border="0" cellspacing="1" cellspacing="1" cellpadding="3" class="table02">

              <tr>
                <td class="td03" colspan="3" height="100">Annual Gross Salary</td>
              </tr>
<%
if( a11AnnSalaryAgreementData_vt.size() > 0 ) {
	
	for ( int i = 0 ; i < a11AnnSalaryAgreementData_vt.size() ; i++ ) {
		A11AnnSalaryAgreementDataEurp data = ( A11AnnSalaryAgreementDataEurp ) a11AnnSalaryAgreementData_vt.get( i ) ;
    	
%>
			 <t>
				<td class="td04" width="33%"><%= data.PREVIOUS.equals(null) ? ""	: data.PREVIOUS %></td>
				<td class="td04" width="33%"><%= data.PRESENT.equals(null) ? "" 	: data.PRESENT %></td>
				<td class="td04" width="33%"><%= data.INCREASE.equals(null) ? "" 	: data.INCREASE %></td>
			 </tr>
<%
	}
}
%>
			</table>
						
			<table>
			  <tr>
				<td bgcolor="#FFFFFF" height="5"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
			  </tr>
			</table>
			
			<table width="590" border="0" cellspacing="1" cellpadding="0">
  			  <tr>
	  			<br>
	  			<br>
  			  	<td class="td04" style="text-align:left;font-family:굴림, 굴림체;font-size:14px;">
				This amendment by provision of the German labor law, will be use to nullify and to replace 
				<br>
				<br>
				any corresponding clauses in your employment contract with LG Chem Europe GmbH.
				<br>
				<br>
				All other clauses remain unchanged.
				<br>
				<br>
				This amendment shall be governedby the Law of German and under the competent 
				<br>
				<br>
				jurisdiction of Frankfurt am Main.
				<br>
				<br>
				<br>
				<br>				
				<span style ="text-align:left;font-family:굴림, 굴림체;font-size:15px;"><b>LG Chem Europe GmbH</b></span>
				<br>
				<br>
				<br>
				<br>
				Frankfurt am Main
				<u>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</u>
				<br>
				<br>
				<br>
				<u>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;				
				</u>
				<br>
				<br>
				<br>
				<I>Read, understood and accepted</I>
				<br>
				<br>				
				<br>
				<span style ="text-align:left;font-family:굴림, 굴림체;font-size:15px;"><b><%= E_DEAR %></b></span>
				<br>
				<br>
				<br>
			    </td>
			    <td>
			    </td>
			  </tr>
			</table>	
 		    <table border=0>
		        <tr> 
					<td width="476" height=27>
						<u>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;				
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;								
						</u>
					</td>
			        <td width="159">
			        	<img src="<%= WebUtil.ImageURL %>img_logo_chem.gif" width="159" height="30" align="right">
			        </td>
		        </tr>
		    </table>				
		</td>
 	</tr>
</table>
	</td>
  </tr>
  <tr>	
	<td>
</td>
</tr>
</table>
</td>
</tr>
</table>
<input type="hidden" name="jobid2" value="">
</form>
<%@ include file="../../common/commonEnd.jsp" %>
