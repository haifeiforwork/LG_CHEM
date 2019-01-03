<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>
    
<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    Vector      A02SchoolData_vt = (Vector)request.getAttribute("A02SchoolData_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
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
            <td class="title01">학력사항 조회</td>
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
        <!--학력 사항 리스트 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="4" class="table02">
          <tr> 
            <td class="td03" width="130">기 간</td>
            <td class="td03" width="110">학교명</td>
            <td class="td03" width="110">전 공</td>
            <td class="td03" width="110">졸업구분</td>
            <td class="td03" width="250">소재지</td>
            <td class="td03" width="80">입사시 학력</td>
          </tr>
<%
    if( A02SchoolData_vt.size() > 0 ) {
        for( int i = 0; i < A02SchoolData_vt.size(); i++ ){
		        A02SchoolData data = (A02SchoolData)A02SchoolData_vt.get(i);
%>
          <tr align="center"> 
            <td class="td04"><%= data.PERIOD    %></td>
            <td class="td04"><%= data.LART_TEXT %></td>
            <td class="td04"><%= data.FTEXT     %></td>
            <td class="td04"><%= data.STEXT     %></td>
            <td class="td04" style="text-align:left">&nbsp;&nbsp;<%= data.SOJAE.equals("") ? "" : data.SOJAE %></td>
            <td class="td04"><%= ( (data.EMARK).toUpperCase() ).equals("N") ? "" : data.EMARK %></td>
          </tr>
<%
        }
    } else {
%>
          <tr align="center"> 
            <td class="td04" colspan="6">해당하는 데이터가 존재하지 않습니다.</td>
          </tr>
<%
    }
%>
        </table>
        <!--학력 사항 리스트 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

