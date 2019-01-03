<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진 여수공장 안내                                      */
/*   Program ID   : E15GeneralBuildPopup.jsp                                    */
/*   Description  : 종합검진 동의팝업                                           */
/*   Note         :                                                             */
/*   Creation     : 2010-01-18                                                  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
 
<%
    String PERNR = (String)request.getParameter("PERNR");
%>
 <html>
<head>
<title>LG Chem</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script LANGUAGE="JavaScript">
<!--
function init(){
     
}
function f_confirm() { 
     
    self.close();
}


//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" onsubmit="return false"> 
  <input type="hidden" name ="PERNR" value="<%=PERNR%>">
  <input type="hidden" name ="jobid" value="">  
    
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      <table width="500" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="font01">
            <img src="<%= WebUtil.ImageURL %>icon_3spot.gif" width="10" height="15" align="absmiddle"> 
            폐정밀 선택
          </td>
        </tr>
        <tr> 

        <tr>
          <td height=15>        
          </td>
        </tr>
        <tr> 
          <td align="center" valign="bottom">
              <img src="<%=WebUtil.JspURL%>E/E15General/e15build_pop_02.gif" border="0"> 
          </td>
        </tr>
        <tr>
                <td align="center" valign="bottom">
          <input type='button'  value='닫 기'  onclick='f_confirm();' ></td>    
              
                </td>
        </tr>        
        <tr>
          <td height=15>        
          </td>
        </tr>        
      </table>
    </td>
  </tr>
</form>                
</table>
<%@ include file="/web/common/commonEnd.jsp" %>
