<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 안내/신청                                          */
/*   Program ID   : C02CurriWait.jsp                                            */
/*   Description  : 교육과정 정보를 가져오는 화면                               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  박영락                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    C02CurriInfoData key = (C02CurriInfoData)request.getAttribute("C02CurriInfoData");
    String PERNR         =  request.getParameter("PERNR");
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function doSubmit(){
    document.form1.jobid.value = "search";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoListSV";
    document.form1.submit();
}
//-->
</script>
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onLoad="doSubmit()" >
<form name="form1" method="post" action="" onsubmit="return false">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>No</th>
                    <th>과정명</th>
                    <th>차수</th>
                    <th>교육기간</th>
                    <th>신청기간</th>
                    <th>상태</th>
                    <th>정원/예약</th>
                    <th>장소</th>
                    <th class="lastCol">주관부서</th>
                </tr>
            </table>
        </div>
    </div>

    <div class="align_center">
        <p>조회중입니다. 잠시만 기다려주십시요.</p>
    </div>

  </div>
<!--  HIDDEN  처리해야할 부분 시작-->
  <input type="hidden" name="jobid"         value="search">
  <input type="hidden" name="I_FDATE"       value="<%= key.I_FDATE %>">
  <input type="hidden" name="I_TDATE"       value="<%= key.I_TDATE %>">
  <input type="hidden" name="I_BUSEO"       value="<%= key.I_BUSEO %>">
  <input type="hidden" name="I_GROUP"       value="<%= key.I_GROUP %>">
  <input type="hidden" name="I_LOCATE"      value="<%= key.I_LOCATE %>">
  <input type="hidden" name="I_DESCRIPTION" value="<%= key.I_DESCRIPTION %>">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">

<!--  HIDDEN  처리해야할 부분 시작-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
