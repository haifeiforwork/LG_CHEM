<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색 wait 창                                            */
/*   Program ID   : SearchDeptPersonsWait.jsp                                   */
/*   Description  : 사원검색 wait 창                                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

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
    String i_gubun   = request.getParameter("I_GBN");
    String i_deptTime  = request.getParameter("I_DeptTime");
%>

<html>
<head>
<title>사원 검색중...</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">

<!--
function doSubmit(){
    document.form1.action = "<%=WebUtil.JspURL%>"+"D/D12Rotation/SearchDeptPersonsPop_Rot.jsp";
    document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="doSubmit()">
<div class="winPop">
<form name="form1" method="post" action="" onsubmit="return false">
<!--  HIDDEN  처리해야할 부분 시작-->
<input type="hidden" name="jobid"     value="<%= jobid    %>">
<input type="hidden" name="I_DEPT"    value="<%= user.empNo   %>">
<input type="hidden" name="E_RETIR"   value="<%= user.e_retir  %>">
<input type="hidden" name="retir_chk" value="<%= retir_chk %>">
<input type="hidden" name="I_VALUE1"  value="<%= i_value1 %>">
<input type="hidden" name="I_GBN"   value="<%= i_gubun %>">
<input type="hidden" name="I_DeptTime"   value="<%= i_deptTime  %>">
<!--  HIDDEN  처리해야할 부분 시작-->
</form>

    <div class="header">
        <span><!-사원검색--><%=g.getMessage("LABEL.D.D12.0050")%></span>
        <a href="javascript:self.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
    </div>

    <div class="body">
        <div class="listArea">
            <div class="table">
                <table class="listTable">
                  <tr>
                    <th><!--  선택--><%=g.getMessage("LABEL.D.D12.0049")%></th>
                    <th><!--  사번--><%=g.getMessage("LABEL.D.D15.0149")%></th>
                    <th><!--  성명--><%=g.getMessage("LABEL.D.D12.0018")%></th>
                    <th class="lastCol"><!--  부서--><%=g.getMessage("LABEL.D.D12.0051")%></th>
                  </tr>
                </table>
            </div>
        </div>

        <div class="align_center">
            <p><!-- 검색중입니다. 잠시만 기다려주십시요--><%=g.getMessage("MSG.D.D12.0025")%></p>
        </div>

    </div>

</div>
<%@ include file="/web/common/commonEnd.jsp" %>
