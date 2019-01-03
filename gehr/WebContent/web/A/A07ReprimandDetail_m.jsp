<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    Vector      PunishData_vt = (Vector)request.getAttribute("PunishData_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess1.css" type="text/css">

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="36">
      <td width="15">&nbsp;</td>
      <td class="td02">
        <font color="#0000FF"><%= "▶ " + user_m.ename + " " + user_m.e_titel + "의 HR정보입니다." + ( user_m.i_stat2.equals("0") ? " (퇴직자)" : "" ) %></font>
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="title01">징계내역 조회</td>
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
      <td width="15">&nbsp; </td>
      <td> 
        <!--가족사항 리스트 테이블 시작-->
        <table width="656" border="0" cellspacing="1" cellpadding="4" class="table02">
          <tr> 
            <td class="td03" width="100">징계유형</td>
            <td class="td03" width="80">징계일자</td>
            <td class="td03" width="439">징계내역</td>
          </tr>
<% 
    if( PunishData_vt.size() > 0 ) {
        for( int i = 0; i < PunishData_vt.size(); i++ ) {
            A07PunishResultData data = (A07PunishResultData)PunishData_vt.get(i);
            DataUtil.fixNull(data);
            StringBuffer sb = new StringBuffer();
            sb.append(data.TEXT1);
            sb.append(data.TEXT2);
            sb.append(data.TEXT3);
            String TEXT = sb.toString();
%>
          <tr> 
            <td class="td04"><%= data.PUNTX %></td>
            <td class="td04"><%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %></td>
            <td class="td04" style="text-align:left"><%= data.PUNRS%><br><%= TEXT %></td>
          </tr>
<%
        }
    } else {
%>
          <tr align="center"> 
            <td class="td04" colspan="3">해당하는 데이터가 존재하지 않습니다.</td>
          </tr>
<%
    }
%>
        </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
