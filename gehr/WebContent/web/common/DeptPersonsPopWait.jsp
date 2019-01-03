<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    String jobid     = request.getParameter("jobid");
    String i_dept    = request.getParameter("I_DEPT");
    String e_retir   = request.getParameter("E_RETIR");
    String retir_chk = request.getParameter("retir_chk");

    String i_value1  = request.getParameter("I_VALUE1");
    String i_value2  = request.getParameter("I_VALUE2");

    String i_gubun   = request.getParameter("I_GUBUN");

    String count     = request.getParameter("count");
%>

<html>
<head>
<title>사원 검색중...</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function doSubmit(){
<%
    if( jobid != null && jobid.equals("pernr") ) {
%>
        document.form1.I_VAL1.disabled = 1;
        document.form1.I_VAL1.readonly = 1;
        document.form1.I_VAL1.value    = "";
        document.form1.I_VAL1.style.backgroundColor = "#C0C0C0";
        document.form1.I_VAL2.focus();
<%
    } else {
%>
        document.form1.I_VAL1.disabled = 0;
        document.form1.I_VAL1.readonly = 0;
        document.form1.I_VAL1.style.backgroundColor = "#FFFFFF";
        document.form1.I_VAL1.focus();
<%
    }
%>

		document.form1.action = "<%=WebUtil.JspURL%>"+"common/DeptPersonsPop.jsp";
    document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:doSubmit()">
<table width="<%= e_retir.equals("Y") ? "720" : "660" %>" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" action="" onsubmit="return false">
<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid"     value="<%= jobid     %>">
    <input type="hidden" name="I_DEPT"    value="<%= i_dept    %>">
    <input type="hidden" name="E_RETIR"   value="<%= e_retir   %>">
    <input type="hidden" name="retir_chk" value="<%= retir_chk %>">
    <input type="hidden" name="I_VALUE1"  value="<%= i_value1  %>">
    <input type="hidden" name="I_VALUE2"  value="<%= i_value2  %>">
    <input type="hidden" name="I_GUBUN"   value="<%= i_gubun   %>">
<!--  HIDDEN  처리해야할 부분 시작-->
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>
      <table width="<%= e_retir.equals("Y") ? "680" : "620" %>" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="p_find01"><spring:message code="LABEL.SEARCH.PERSON" /><!-- 사원 검색 --></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="<%= e_retir.equals("Y") ? "680" : "620" %>" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="315">
                  <table width="315" border="0" cellspacing="1" cellpadding="2" class="table01">
                    <tr>
                      <td class="td03" width="60"><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></td>
                      <td class="td03" width="70">
                        <select name="GUBUN" class="input03" readonly>
                          <option value="2" <%= i_gubun.equals("2") ? "selected" : "" %>><spring:message code="LABEL.COMMON.0020" /><!-- 성명별 --></option>
                          <option value="1" <%= i_gubun.equals("1") ? "selected" : "" %>><spring:message code="LABEL.COMMON.0005" /><!-- 사번별 --></option>
                        </select>
                      </td>
                      <td class="td03" width="135">
                        <input type="text" name="I_VAL1" size="5"  maxlength="5"  class="input03" value="<%= ( i_value1 == null || i_value1.equals("") ) ? "" : i_value1 %>"  style="ime-mode:active" readonly>
                        <input type="text" name="I_VAL2" size="10" maxlength="10" class="input03" value="<%= ( i_value2 == null || i_value2.equals("") ) ? "" : i_value2 %>"  style="ime-mode:active" readonly>
                      </td>
                      <td class="td03" width="50" style="padding-top: 5px">
                        <img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" border="0">
                      </td>
                    </tr>
                  </table>
                </td>
<%
    if( e_retir.equals("Y") ) {
%>
                <td class="td02" width="100">
                  <input type="checkbox" name="RETIR" <%= retir_chk.equals("X") ? "checked" : "" %> size="20">&nbsp;<font color="#0000FF"><spring:message code="LABEL.COMMON.0021" /><!-- 퇴직자 포함 --></font>
                </td>
<%
    } else {
%>
                <td class="td02" width="100">&nbsp;</td>
<%
    }
%>
                <td align="right" valign="bottom"><a href="javascript:self.close()">
                <img src="<%= WebUtil.ImageURL %>btn_close.gif" width="49" height="20" border="0"></a></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="td02" height="30" align="bottom"><spring:message code="LABEL.COMMON.0022" /><!-- 성명별로 검색시 성과 이름을 구분하여 입력하시기 바랍니다.(선우 혁신 -> "선우", "혁신") --></td>
        </tr>
        <tr>
          <td background="<%= WebUtil.ImageURL %>bg_pixel02.gif">&nbsp;</td>
        </tr>
<%
    if ( !count.equals("0") ) {
%>
		    <tr>
          <td align="right" class="td02">&nbsp;</td>
		    </tr>
<%
    } else {
%>
		    <tr>
          <td align="right" class="td02">&nbsp;</td>
		    </tr>
<%
    }
%>
        <tr>
          <td>
            <table width="<%= e_retir.equals("Y") ? "690" : "630" %>" border="0" cellspacing="1" cellpadding="2" class="table01">
              <tr>
                <td class="td03" width="30"><spring:message code="LABEL.COMMON.0014" /><!-- 선택 --></td>
                <td class="td03" width="60"><spring:message code="MSG.A.A01.0005" /><!-- 사번 --></td>
                <td class="td03" width="70"><spring:message code="MSG.APPROVAL.0013" /><!-- 성명 --></td>
                <td class="td03" width="170"><spring:message code="MSG.APPROVAL.0015" /><!-- 부서 --></td>
                <td class="td03" width="70"><%-- //[CSR ID:3456352]<spring:message code="MSG.APPROVAL.0014" /><!-- 직위 --> --%>
                <spring:message code="LABEL.COMMON.0051" /><!-- 직위/직급호칭 -->
                </td>
                <td class="td03" width="70"><spring:message code="LABEL.COMMON.0009" /><!-- 직책 --></td>
                <td class="td03" width="80"><spring:message code="MSG.A.A01.0013" /><!-- 직무 --></td>
                <td class="td03" width="80"><spring:message code="MSG.A.A01.0018" /><!-- 근무지 --></td>
<%
    if( e_retir.equals("Y") ) {
%>
                <td class="td03" width="60"><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></td>
<%
    }
%>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td align="center">&nbsp;</td>
        </tr>
        <tr>
          <td align="center">&nbsp;</td>
        </tr>
        <tr>
          <td align="center" class="td02"><font color="#0000FF"><spring:message code="LABEL.APPROVAL.0009" /><!-- 검색중입니다. 잠시만 기다려주십시요. --></font></td>
        </tr>
      </table>
    </td>
  </tr>
</form>
</table>
<%@ include file="commonEnd.jsp" %>
