<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    // 첫 화면에 리스트되는 데이터들..
    Vector                   A08LicenseDetailAllo_vt = (Vector)request.getAttribute("A08LicenseDetailAllo_vt");
    A08LicenseDetailAlloData data                    = (A08LicenseDetailAlloData)A08LicenseDetailAllo_vt.get(0); 
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<!--
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<!--법정선임 click시 보여지는 부분시작 -->
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="15">&nbsp; </td>
    <td> 
      <table width="520" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td class="tr01">
            <table width="500" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    기본사항</td>
              </tr>
              <tr> 
                <td class="font01"> 
                  <table width="500" border="0" cellspacing="1" cellpadding="3" class="table02">
                    <tr> 
                      <td class="td03" width="80">자격증</td>
                      <td class="td09"><%= data.LICN_NAME %></td>
                    </tr>
                    <tr> 
                      <td class="td03">자격 등급</td>
                      <td class="td09"><%= data.GRAD_NAME %></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td class="font01">&nbsp;</td>
              </tr>
              <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    수 당</td>
              </tr>
              <tr> 
                <td class="font01"> 
                  <table width="500" border="0" cellspacing="1" cellpadding="3" class="table02">
                    <tr> 
                      <td width="80" class="td03">지급율</td>
                      <td class="td09"><%= data.GIVE_RATE1 + " %" %></td>
                    </tr>
                    <tr> 
                      <td class="td03">자격수당</td>
                      <td class="td09"><%= WebUtil.printNumFormat(data.LICN_AMNT) + " 원" %></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td class="font01">&nbsp;</td>
              </tr>
              <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    법정선임정보</td>
              </tr>
              <tr> 
                <td class="font01"> 
                  <table width="500" border="0" cellspacing="1" cellpadding="3" class="table02">
                    <tr> 
                      <td width="80" class="td03">조직단위</td>
                      <td class="td09"><%= data.ORGTX %></td>
                    </tr>
                    <tr> 
                      <td class="td03">설비 / 위치</td>
                      <td class="td09"><%= data.EQUI_NAME %></td>
                    </tr>
                    <tr> 
                      <td class="td03">선임사유</td>
                      <td class="td09"><%= data.ESTA_AREA %></td>
                    </tr>
                    <tr> 
                      <td class="td03">비고</td>
                      <td class="td09"><%= data.PRIZ_TEXT %></td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <!--법정선임 click시 보여지는 부분끝-->
    </td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td class="style01" align="center" colspan="2">
      <a href="javascript:self.close()">
        <img src="<%= WebUtil.ImageURL %>btn_close.gif" align="absmiddle" border="0">
      </a>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
