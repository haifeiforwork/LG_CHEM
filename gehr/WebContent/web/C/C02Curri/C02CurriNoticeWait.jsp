<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 안내/신청                                          */
/*   Program ID   : C02CurriNoticeWait.jsp                                      */
/*   Description  : 교육과정 정보를 가져오는 화면                               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  박영락                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function doSubmit(){
		document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoSV";
    document.form1.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onLoad="javascript:doSubmit();">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
        <!--타이틀 테이블 시작-->
          <table width="790" border="0" cellspacing="0" cellpadding="0">
            <tr> 
            <td align="right">
              &nbsp;<a href="javascript:open_help('C02Curri.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
            </td>
            </tr>
            <tr> 
              <td class="title01">교육과정 안내</td>
            </tr>
          </table>
        <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr><td>&nbsp;</td></tr>
          <tr><td>&nbsp;</td></tr>
          <tr> 
            <td class="td04" align="center"><font color="#006699">조회중입니다. 잠시만 기다려주십시요.</font></td>
          </tr>
        </table>
      </td>
    </tr>  
  </table>
    <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
