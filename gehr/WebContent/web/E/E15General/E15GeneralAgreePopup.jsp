<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진 동의화면                                           */
/*   Program ID   : E15GeneralAgreePopup.jsp                                    */
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
<title>건강검진 결과 제공 동의서 </title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script LANGUAGE="JavaScript">
<!--
function init(){
     
}
function f_confirm() { 
    dialogArguments.f_build('X'); 
    self.close();
}

function f_not_confirm() { 
    dialogArguments.f_build(''); 
    
//     var arr = window.dialogArguments; 
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
        <!--<tr>
          <td class="font01">
            <img src="<%= WebUtil.ImageURL %>icon_3spot.gif" width="10" height="15" align="absmiddle"> 
            건강검진 결과 제공 동의서
          </td>
        </tr>-->
 	<tr>
          <td class="font01">
            <img src="<%=WebUtil.ImageURL%>../E/E15General/e15_agree.gif"  align="absmiddle"> 
          </td>
        </tr> 
       <!-- <tr> 
          <td height=100% width=100%>
          
          <table bgcolor="#cccccc" border=0 valign=middle width=750 cellspacing="4"  cellpadding="4" align=center>
          <tr bgcolor="#FFFFFF">
          	<tr>
          	<td class="td03"><font color=blue>건강검진 후 질병예방과 건강 증진을 위해 제공되는 회사의 건강관리지원 서비스(건강상담 등) 와 관련하여 
          	<br>본인의 건강검진 결과를 이와 같은 용도로 사용할 수 있도록 회사에 제공하는 것에 동의합니다. </font>
          	</td>
           </tr>
          </table>

          </td>
        </tr>-->
        <tr>
          <td height=15>        
          </td>
        </tr>
        <!--<tr> 
          <td align="center" valign="bottom">
            <a href="javascript:f_confirm()">
              <img src="<%= WebUtil.ImageURL %>btn_ok.gif" border="0">&nbsp;</a>
          </td>
        </tr>-->
  <tr>
          <td align="center" valign="bottom">
    <input type='button'  value='동의합니다.'  onclick='f_confirm();' >
    <input type='button'  value='동의하지 않습니다.'  onclick='f_not_confirm();' ></td>    
        
          </td>
  </tr>        
        <tr>
          <td height=15>        
          </td>
        </tr>              
        <tr>
          <td class="td04">
 ※ 귀하의 건강검진 결과는 법적 의무실시 사항인 건강검진 실시 여부 확인 및  임직원의 건강관리 방안마련과 
 <br>원활한 건강지원 서비스 제공을 위한 자료로만 사용될 것이며 그 외의 용도로는 사용되지는 않을 것입니다.
          </td>
        </tr>
        <tr>
          <td background="<%= WebUtil.ImageURL %>bg_pixel02.gif">&nbsp;</td>
        </tr>        
      </table>
    </td>
  </tr>
</form>                
</table>
<%@ include file="/web/common/commonEnd.jsp" %>
