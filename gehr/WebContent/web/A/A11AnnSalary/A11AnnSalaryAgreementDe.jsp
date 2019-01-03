<%/***************************************************************************************/                            																				
/*   System Name    : ESS                                                                                                                             */
/*   1Depth Name  	: Personal HR Info                                               																*/
/*   2Depth Name  	: Personal Info                                                  													*/
/*   Program Name 	: Annual Salary Agreement                                          																*/
/*   Program ID   		: A11AnnSalaryAgreementDe.jsp                                															    */
/*   Description  		: Annual Salary Agreement                                         																*/
/*   Note         		: 없음                                                       																					*/
/*   Creation     		: 2010-07-13 yji                                              																	*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../common/commonProcess.jsp" %>

<%@ page import="com.sns.jdf.security.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.A10Annual.*" %>

<%
    WebUserData user = (WebUserData)session.getAttribute("user");
    
    Vector A11AnnSalaryAgreementData_vt = (Vector)request.getAttribute("A11AnnSalaryAgreementData_vt");
    String E_BUTTON     	= (String)request.getAttribute("E_BUTTON");
    String R_num     	= (String)request.getAttribute("R_num");
    String empNo     	= DataUtil.fixEndZero(user.empNo, 8);
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--

function doOpenAgreement(){
	document.form1.i_ptype.value = "A";

    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=900,height=662,left=0,top=2");

    document.form1.target = "essPrintWindow";
    document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_AnnSalaryAgreeEurp.jsp";
    document.form1.method = "post";
    document.form1.submit();
}


//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
			<tr>
			  <td width="780">
			    <table width="780" border="0" cellpadding="0" cellspacing="0">
			      <tr>
			        <td height="5" colspan="2"></td>
			      </tr>
			      <tr>
			        <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">Annual Salary Agreement</td>
					<td align="right"><a href="javascript:open_help('A11AnnSalaryAgreementDe.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"><img name="Image6" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="Guide"></a></td>
			      </tr>
			    </table>
			  </td>
			</tr>
			<tr>
			  <td>
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			      <tr>
			        <td height="3" align="left" valign="top" background="/web/images/maintitle_line.gif"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
			      </tr>
			    </table>
			  </td>
			</tr>
			<tr>
			  <td height="2"></td>
			</tr>				
			<tr>
			   <% if(A11AnnSalaryAgreementData_vt.size() > 0 && E_BUTTON.equals("X") ){ %>
	  		   <td align="right">
	        	          <a href="javascript:doOpenAgreement();"><img src="<%= WebUtil.ImageURL %>btn_agree.gif" name="image" align="absmiddle" border="0"></a>
 	                   </td>
	           <% } %>					
			</tr>
			<tr>
			  <td height="2"></td>
			</tr>					
			<tr>		
			  <td>
			    <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">

					<tr>
						<td class="td03">Date</td>
						<td class="td03">Org.Unit</td>
					  	<td class="td03">Level/Annual</td>
					  	<td class="td03">Title of Level</td>
					  	<td class="td03">Annual Salary</td>
					 </tr>
<%

	if( A11AnnSalaryAgreementData_vt.size() > 0 ) {
		
		for ( int i = 0 ; i < A11AnnSalaryAgreementData_vt.size() ; i++ ) {
        	A11AnnSalaryAgreementDataEurp data = ( A11AnnSalaryAgreementDataEurp ) A11AnnSalaryAgreementData_vt.get( i ) ;
                   
%>   
				<tr>
					<td class="td04"><%= data.BEGDA.equals(null) ? ""	: data.BEGDA %></td>
					<td class="td04"><%= data.ORGEH.equals(null) ? "" 	: data.ORGEH %></td>
					<td class="td04"><%= data.JIKCT.equals(null) ? "" 	: data.JIKCT %></td>
					<td class="td04"><%= data.TTOUT.equals(null) ? "" 	: data.TTOUT %></td>
					<td class="td04"><%= data.ANSAL.equals(null) ? "" 	: data.ANSAL %></td>
				</tr>
<%          
		}
	
	} else {
%>
			   <tr align="center"> 
			       <td class="td04" colspan="5">No data</td>
			   </tr>
<%
	}
%>	
			    </table>
			  
			  </td>
			</tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
   </table>
   </td>
  </tr>
</table>
<input type="hidden" name="jobid2"   value="">
<input type="hidden" name="licn_code" value="">
<input type="hidden" name="i_ptype" value="D">   
</form>
<%@ include file="../../common/commonEnd.jsp" %>