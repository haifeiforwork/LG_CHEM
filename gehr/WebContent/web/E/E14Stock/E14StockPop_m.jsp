<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E14Stock.*" %>

<%
    E14StockData data          = (E14StockData)request.getAttribute("E14StockData");
	Vector       InchulData_vt = (Vector)request.getAttribute("InchulData_vt");
%>
	
<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
</head>
<!--[CSR ID:2389767] [정보보안] e-HR MSS시스템 수정-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()">
<form name="form1" method="post" action="">
  <table width="400" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table width="381" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"><img src="<%= WebUtil.ImageURL %>img_stock.gif" width="179" height="20"></td>
          </tr>
          <tr> 
            <td align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> 
              <table width="381" border="0" cellspacing="1" cellpadding="2">
                <tr> 
                  <td width="80" class="td03">증자회차</td>
                  <td class="td02" width="100"> 
                    <input type="text" name="INCS_NUMB" size="10" class="input04" value="<%= WebUtil.printNum(data.INCS_NUMB) %>" readonly>
                  </td>
                  <td width="80" class="td03">주식구분</td>
                  <td class="td02" width="100"> 
                    <input type="text" name="SHAR_TEXT" size="10" class="input04" value="<%= data.SHAR_TEXT %>" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03">예탁주수</td>
                  <td class="td02"> 
                    <input type="text" name="DEPS_QNTY" size="10" class="input04" value="<%= WebUtil.printNum(data.DEPS_QNTY) %>" readonly>
                  </td>
                  <td class="td03">예탁일자</td>
                  <td class="td02"> 
                    <input type="text" name="BEGDA" size="10" class="input04" value="<%=WebUtil.printDate(data.BEGDA) %>" readonly>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> 
              <table width="381" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr> 
                  <td class="td03" width="105">인출일자</td>
                  <td class="td03" width="130">인출주수</td>
                  <td class="td03" width="130">인출사유</td>
                </tr>
<% 
        for( int i = 0 ; i < InchulData_vt.size(); i++ ) {
            InchulData inchuldata = (InchulData)InchulData_vt.get(i);
%>                     
				<tr> 
                  <td class="td04"><%= WebUtil.printDate(inchuldata.CINS_DATS) %></td>
                  <td class="td04"><%= WebUtil.printNum(inchuldata.DRAW_QNTY) %></td>
                  <td class="td04"><%= inchuldata.DRAW_NAME %></td>
                </tr>
<%
    }
%>
             </table>
            </td>
          </tr>
          <tr>
            <td align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="right"><a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>btn_close.gif" width="49" height="20" align="absmiddle" border="0"></a></td>
          </tr>
          <tr>
            <td align="center">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
