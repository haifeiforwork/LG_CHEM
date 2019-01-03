<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색 wait 창                                            */
/*   Program ID   : SearchDeptPersonsWait_m.jsp                                 */
/*   Description  : 사원검색 wait 창                                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%--@ include file="/web/common/commonProcess.jsp" --%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.Logger"%>

<%
    WebUserData user = (WebUserData)session.getAttribute("epuser");

    String jobid     = request.getParameter("jobid");
    String i_dept    = user.empNo;
    String e_retir   = user.e_retir;
    String retir_chk = request.getParameter("retir_chk");

    Logger.debug.println(this, "jobid:"+jobid);
    Logger.debug.println(this, "i_dept:"+i_dept);
    Logger.debug.println(this, "e_retir:"+e_retir);



    String i_value1  = request.getParameter("I_VALUE1");
    String i_gubun   = request.getParameter("I_GUBUN");
%>

<html>
<head>
<title>사원 검색중...</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<link href="<%= WebUtil.ImageURL %>css/ehr.css" rel="stylesheet" type="text/css">

<script language="javascript">
<!--
function doSubmit(){
    document.form1.action = "/web/ep/SearchDeptPersonsPop_ep.jsp";
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
                <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">사원검색</td>
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
                <td class="td03" width="30">선택</td>
                <td class="td03" width="60">사번</td>
                <td class="td03" width="70">성명</td>
                <td class="td03" width="170">부서</td>
                <td class="td03" width="70">직위/직급호칭</td><!-- [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 -->
                <td class="td03" width="70">직책</td>
                <td class="td03" width="80">직무</td>
                <td class="td03" width="80">근무지</td>
<%
    if( e_retir.equals("Y") ) {
%>
                <td class="td03" width="60">구분</td>
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
          <td align="center" class="td04"><font color="#006699">검색중입니다. 잠시만 기다려주십시요.</font></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<%@ include file="/web/common/commonEnd.jsp" %>
