<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A13Address.*" %>
<%@ page import="hris.A.A13Address.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-address" tagdir="/WEB-INF/tags/A/A13Address" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    WebUserData        user_m                = (WebUserData)session.getAttribute("user_m");
    Vector             a13AddressListData_vt = (Vector)request.getAttribute("a13AddressListData_vt");
    A13AddressListData data                  = (A13AddressListData) a13AddressListData_vt.get(0);
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit() {
    document.form1.jobid.value = "first";
    document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A13Address.A13AddressListSV_m';
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="36">
      <td width="15">&nbsp;</td>
      <td class="td02">
        <font color="#0000FF"><%= "▶ " + g.getMessage("LABEL.A.A04.0011", user_m.ename + " " + user_m.e_titel) + ( user_m.i_stat2.equals("0") ? " (" + g.getMessage("LABEL.SEARCH.POP.0002") + ")" : "" ) %></font>

      <%-- <font color="#0000FF"><%= "▶ " + user_m.ename + " " + user_m.e_titel + "의 HR정보입니다." + ( user_m.i_stat2.equals("0") ? " (퇴직자)" : "" ) %></font> --%>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="title01"><spring:message code="LABEL.A.A13.0009"/><!-- 주소 조회 --></td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
    </td>
  </tr>
  <tr>
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <form name="form1" method="post" action="">
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!-- 상단 입력 테이블 시작-->
        <table width="750" border="0" cellspacing="1" cellpadding="0" class="table01">
          <tr>
            <td class="tr01">
              <table width="730" border="0" cellspacing="1" cellpadding="2">
                <tr>
                  <td width="100" class="td01"><spring:message code="MSG.A.A13.010"/><!-- 주소유형 --></td>
                  <td class="td02">
                    <input type="text" name="STEXT" size="10" class="input04" value="<%= data.STEXT %>" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code="MSG.A.A13.011"/><!-- 국가 --></td>
                  <td class="td02">
                    <input type="text" name="LANDX" size="20" class="input04" value="<%= data.LANDX %>" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td02">&nbsp;</td>
                  <td class="td02">&nbsp; </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code="MSG.A.A13.012"/><!-- 우편번호 --></td>
                  <td class="td02">
                    <input type="text" name="PSTLZ" size="10" class="input04" value="<%= data.PSTLZ %>" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code="MSG.A.A13.013"/><!-- 주소 --></td>
                  <td class="td02">
                    <input type="text" name="STRAS" size="60" class="input04" value="<%= data.STRAS %>" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td02">&nbsp;</td>
                  <td class="td02">
                    <input type="text" name="LOCAT" size="60" class="input04" value="<%= data.LOCAT %>" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td02">&nbsp;</td>
                  <td class="td02">&nbsp;</td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code="MSG.A.A13.014"/><!-- 전화번호 --></td>
                  <td class="td02">
                    <input type="text" name="TELNR" size="20" class="input04" value="<%= data.TELNR %>" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code="MSG.A.A13.015"/><!-- 주거형태 --></td>
                  <td class="td02">
                    <input type="text" name="LIVE_TEXT" size="10" class="input04" value="<%= data.LIVE_TEXT %>" readonly>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!-- 상단 입력 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <table width="750" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <a href="javascript:doSubmit();"><img src="<%= WebUtil.ImageURL %>btn_list.gif" width="49" height="20" align="absmiddle" border="0"></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>

    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="subty" value="<%= data.SUBTY %>">

  </form>
  </table>

<%@ include file="/web/common/commonEnd.jsp" %>
