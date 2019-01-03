<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E31InfoStatus.*" %>
<%@ page import="hris.E.E31InfoStatus.rfc.*" %>

<%
    Vector E31InfoMemberData_vt = (Vector)request.getAttribute("E31InfoMemberData_vt");
	String S_INFTY = (String)request.getAttribute("S_INFTY");
	String S_STEXT = (String)request.getAttribute("S_STEXT");
	String S_MGART = (String)request.getAttribute("MGART");

	/*----- Excel 파일 저장하기 --------------------------------------------------- */
	response.setHeader("Content-Disposition","attachment;filename=informalpart.xls");
	response.setContentType("application/vnd.ms-excel;charset=utf-8");
	/*----------------------------------------------------------------------------- */
%>
<html>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
<head>
<title>ESS</title>

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
<%
    // 전체 선택 후 조회시 ----------------------------------------------------------------
    if ( S_MGART == null || S_MGART.equals("") ) {
%>
        <table width="740" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="700" colspan="5" align="left"><%= E31InfoMemberData_vt == null ? 0 : E31InfoMemberData_vt.size() %>&nbsp;<!-- 건 --><%=g.getMessage("LABEL.E.E13.0006")%></td>
          </tr>
        </table>
        <table width="740" border="1" cellspacing="1" cellpadding="2">
          <tr>
            <td width="220"><!-- 소속부서 --><%=g.getMessage("LABEL.E.E16.0011")%></td>
            <td width="220"><!-- 동호회 --><%=g.getMessage("LABEL.E.E26.0002")%></td>
            <td width="100"><!-- 성명 --><%=g.getMessage("LABEL.E.E29.0001")%></td>
            <td width="100"><!-- 회비 --><%=g.getMessage("LABEL.E.E13.0007")%></td>
            <td width="100"><%= S_INFTY.equals("0") ? g.getMessage("LABEL.E.E26.0001") : g.getMessage("LABEL.E.E13.0009") %></td>
          </tr>
<%
        if( E31InfoMemberData_vt != null && E31InfoMemberData_vt.size() > 0 ) {
            for ( int i = 0 ; i < E31InfoMemberData_vt.size() ; i++ ) {
                E31InfoMemberData data = (E31InfoMemberData)E31InfoMemberData_vt.get(i);

                double i_betrg = Double.parseDouble(data.BETRG) * 100;
%>
           <tr>
            <td><%= data.ORGTX %></td>
            <td><%= data.STEXT %></td>
            <td><%= data.ENAME %></td>
            <td><%= WebUtil.printNumFormat(i_betrg, 0) %></td>
            <td><%= S_INFTY.equals("0") ? WebUtil.printDate(data.BEGDA) : WebUtil.printDate(data.ENDDA) %></td>
          </tr>
<%
            }
        } else {
%>
          <tr align="center">
            <td colspan="5"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
          </tr>
<%
	    }
    // 동호회 하나 선택 후 조회시 ----------------------------------------------------------------
    } else {
%>
        <table width="640" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="600" colspan="5" align="left"><%= E31InfoMemberData_vt == null ? 0 : E31InfoMemberData_vt.size() %>&nbsp;건</td>
          </tr>
        </table>
        <table width="640" border="1" cellspacing="1" cellpadding="2">
          <tr>
            <td width="250"><!-- 소속부서 --><%=g.getMessage("LABEL.E.E16.0011")%></td>
            <td width="130"><!-- 성명 --><%=g.getMessage("LABEL.E.E29.0001")%></td>
            <td width="130"><!-- 회비 --><%=g.getMessage("LABEL.E.E13.0007")%></td>
            <td width="130"><%= S_INFTY.equals("0") ? g.getMessage("LABEL.E.E26.0001") : g.getMessage("LABEL.E.E13.0009") %></td>
          </tr>
<%
        if( E31InfoMemberData_vt != null && E31InfoMemberData_vt.size() > 0 ) {
            for ( int i = 0 ; i < E31InfoMemberData_vt.size() ; i++ ) {
                E31InfoMemberData data = (E31InfoMemberData)E31InfoMemberData_vt.get(i);

                double i_betrg = Double.parseDouble(data.BETRG) * 100;
%>
           <tr>
            <td><%= data.ORGTX %></td>
            <td><%= data.ENAME %></td>
            <td><%= WebUtil.printNumFormat(i_betrg, 0) %></td>
            <td><%= S_INFTY.equals("0") ? WebUtil.printDate(data.BEGDA) : WebUtil.printDate(data.ENDDA) %></td>
          </tr>
<%
            }
        } else {
%>
          <tr align="center">
            <td colspan="4"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
          </tr>
<%
	    }
    }
%>
        </table>
      </td>
    </tr>
  </table>
<input type="hidden" name="jobid" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
