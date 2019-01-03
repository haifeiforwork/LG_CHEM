<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>

<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>

<%
    WebUserData user                = (WebUserData)session.getAttribute("user");
    Vector      C02CurriApplData_vt = (Vector)request.getAttribute( "C02CurriApplData_vt" );

    C02CurriApplData data           = (C02CurriApplData)C02CurriApplData_vt.get(0);

    String i_objid_L = (String)request.getAttribute("i_objid_L");
    String idx_Radio = (String)request.getAttribute("idx_Radio");         // 과정 목록에서 선택된 래디오 버튼
    String paging    = (String)request.getAttribute("page");              // 과정 목록에서 선택된 page
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function go_delete() {
    if( chk_APPR_STAT(1) && confirm("교육과정 참가신청을 취소하시겠습니까?") ) {
        document.form1.jobid.value = "delete";
        document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationDetailSV";
    document.form1.method      = "post";
        document.form1.submit();
    }
}

// 앞화면
function do_preview(){
  document.form1.action        = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationCourseListSV";
  document.form1.target        = "menuContentIframe";
  document.form1.submit();
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<div class="subWrapper">>

    <div class="title"><h1>교육과정 신청 조회</h1></div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>과정명</th>
                    <td><%= data.GWAJUNG %></td>
                    <th class="th02">교육기간</th>
                    <td> <%= WebUtil.printDate(data.GBEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(data.GBEGDA,".") + "~" %><%= WebUtil.printDate(data.GENDDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(data.GENDDA,".") %></td>
                </tr>
                <tr>
                    <th>신청차수명</th>
                    <td><%= data.CHASU %></td>
                    <th class="th02">차수 ID</th>
                    <td><%= data.CHAID %></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppDetail(data.AINF_SEQN) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:go_delete();" ><span>삭제</span></a></li>
<%
    String ThisJspName = (String)request.getAttribute("ThisJspName");
    Logger.debug.println(this, "ThisJspName : "+ ThisJspName);
    if ( ThisJspName.equals("A16ApplList.jsp")  ) {
%>
            <li><a href="javascript:history.back();"><span>목록</span></a></li>
<%
    } else {
%>
            <li><a href="javascript:do_preview();"><span>목록</span></a></li>
<%
    }
%>
        </ul>
    </div>

<!---- hidden ------>
  <input type="hidden" name="jobid"       value="">
  <input type="hidden" name="AINF_SEQN"   value="<%= data.AINF_SEQN %>">
  <input type="hidden" name="ThisJspName" value="<%= ThisJspName %>">
  <input type="hidden" name="OBJID_L"     value="<%= i_objid_L %>">
  <input type="hidden" name="page"        value="<%= paging %>">
  <input type="hidden" name="idx_Radio"   value="<%= idx_Radio %>">
<!---- hidden ------>
  </form>
</div>

<%@ include file="/web/common/commonEnd.jsp" %>
