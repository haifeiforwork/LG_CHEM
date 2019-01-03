<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                          */
/*   1Depth Name    : Application                                                                                                                   */
/*   2Depth Name    : Time Management                                                                                                           */
/*   Program Name   : Time Sheet                                                                                                                */
/*   Program ID         : D07TimeSheetMemoPop.jsp                                                                                               */
/*   Description        : Time Sheet 신청시 Memo 입력 팝업 화면 (USA - LG CPI(G400))                                                 */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-10-11 jungin @v1.0 LG CPI Time Sheet 신규 개발                                                           */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.D07TimeSheet.*" %>
<%@ page import="hris.D.D07TimeSheet.rfc.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");

    int rowIndex = Integer.parseInt(request.getParameter("rowIndex"));

    String wtext = (String)request.getParameter("wtext");
    //
    //

    String count = request.getParameter("count");
    long l_count = 0;
    if (count != null) {
        l_count = Long.parseLong(count);
    }

    String PERNR = request.getParameter("PERNR");
    if (PERNR == null || PERNR.equals("")) {
        PERNR = user.empNo;
    } // end if
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<link href="../images/css/ehr.css" rel="stylesheet" type="text/css">

<SCRIPT LANGUAGE="JavaScript">
<!--

function init() {
    var frm = document.form1;
    frm.I_WTEXT.focus();
}

function f_saveMemo() {
    var frm = document.form1;

    // opener form Array index 0~
    opener.form1.WTEXT[<%= rowIndex %>].value = frm.I_WTEXT.value;
    opener.sp1[<%= rowIndex %>].style.display = "";
    window.close();
}
$(function() {
    var frm = document.form1;
    frm.I_WTEXT.focus();
});

//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init();">
<div class="winPop">
<form name="form1" method="post">

    <div class="header">
        <span>Memo</span>
        <a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" border="0" /></a>
    </div>

    <div class="body">
        <textarea name="I_WTEXT" rows="5" style="width:100%;"><%= wtext %></textarea></td>

        <div class="buttonArea">
            <ul class="btn_crud" id="sc_button">
                <li><a class="darken" href="javascript:f_saveMemo();"><span><!-- 저장 --><spring:message code='BUTTON.COMMON.SAVE'/></span></a></li>
                <li><a href="javascript:self.close()"><span><!-- 닫기 --><spring:message code='BUTTON.COMMON.CLOSE'/></span></a></li>
            </ul>
        </div>

    </div>

    <input type="hidden" name="empNo" value="">
    <input type="hidden" name="PERNR" value="<%= PERNR %>">
</form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>
