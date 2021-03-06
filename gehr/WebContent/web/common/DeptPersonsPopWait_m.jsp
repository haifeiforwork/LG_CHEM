<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색 wait 창                                            */
/*   Program ID   : DeptPersonsWait_m.jsp                                       */
/*   Description  : 사원검색 wait 창                                            */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-03-29  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>
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
    WebUserData user = WebUtil.getSessionUser(request);

    String jobid     = request.getParameter("jobid");
    String i_dept    = user.empNo;
    String e_retir   = user.e_retir;
    String retir_chk = request.getParameter("retir_chk");

    String i_value1  = request.getParameter("I_VALUE1");
    String i_gubun   = request.getParameter("I_GUBUN");
%>

<html>
<head>
<title>사원 검색중...</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="javascript">
<!--
function doSubmit(){
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/DeptPersonsPop_m.jsp";
    document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="doSubmit()">
<table width="<%= e_retir.equals("Y") ? "720" : "660" %>" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" action="" onsubmit="return false">
<!--  HIDDEN  처리해야할 부분 시작-->
<input type="hidden" name="jobid"     value="<%= jobid    %>">
<input type="hidden" name="I_DEPT"    value="<%= user.empNo   %>">
<input type="hidden" name="E_RETIR"   value="<%= user.e_retir  %>">
<input type="hidden" name="retir_chk" value="<%= retir_chk %>">
<input type="hidden" name="I_VALUE1"  value="<%= i_value1 %>">
<input type="hidden" name="I_GUBUN"   value="<%= i_gubun  %>">
<!--  HIDDEN  처리해야할 부분 시작-->
</form>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>
      <table width="<%= e_retir.equals("Y") ? "680" : "620" %>" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif"><spring:message code="LABEL.SEARCH.PERSON" /><!-- 사원검색 --></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
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
          <td align="center" class="td04"><font color="#006699"><spring:message code="LABEL.APPROVAL.0009" /><!-- 검색중입니다. 잠시만 기다려주십시요. --></font></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<%@ include file="commonEnd.jsp" %>
