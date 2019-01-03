<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : .                                               */
/*   2Depth Name  : 연말정산 결과 조회                                               */
/*   Program Name : 연말정산 결과 조회(onload 시 생성 팝업)                                               */
/*   Program ID   : D14TaxAdjustReTaxGuidepopup.jsp                                                */
/*   Description  : 2014 연말정산 재정산 시 변경사항 알림 popup                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2015-05-18  [CSR ID:2778743] 연말정산 내역조회 화면 수정                                           */
/*   Update       :   */
/*                     */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*"%>
<%@ page session="false" %>


<HTML>
<HEAD>
<TITLE> 2014 연말정산 재정산 안내 </TITLE>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>


</HEAD>

<BODY>
<form method=post name=form1>

 <image src="<%=WebUtil.ImageURL%>/D14TaxAdjustDetailPopup.jpg" height ="443" width="537">
<table>              
     <tr><td align="center"><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:this.close()">
     <IMG src="<%= WebUtil.ImageURL %>jms/btn_close.gif" BORDER=0></a></td>
     </tr>
 </table>
</form>
</BODY>
</HTML>
