<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>

<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>
<%@ page import="hris.C.C10Education.*" %>
<%@ page import="hris.C.C10Education.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector      c10Inform01_vt      = (Vector)request.getAttribute("c10Inform01_vt");
    C10EducationInformData dataInfo = (C10EducationInformData)c10Inform01_vt.get(0);

    Vector      c10Inform02_vt      = (Vector)request.getAttribute("c10Inform02_vt");
    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    for(int i = 0 ; i < c10Inform02_vt.size() ; i++){
        C02CurriEventInfoData data = (C02CurriEventInfoData)c10Inform02_vt.get(i);
        if( data.SUBTY.equals("9001") && !data.TLINE.equals("") ) {             // 교육대상
            subtype1.append(data.TLINE+"<br>");
        } else if( data.SUBTY.equals("9002") && !data.TLINE.equals("") ) {      // 교육목표
            subtype2.append(data.TLINE+"<br>");
        } else if( data.SUBTY.equals("9003") && !data.TLINE.equals("") ) {      // 교육내용
            subtype3.append(data.TLINE+"<br>");
        } else if( data.SUBTY.equals("9004") && !data.TLINE.equals("") ) {      // 기타
            subtype4.append(data.TLINE+"<br>");
        }
    }

    String i_objid_L = (String)request.getAttribute("i_objid_L");
    String i_objid_D = (String)request.getAttribute("i_objid_D");
    String idx_Radio = (String)request.getAttribute("idx_Radio");         // 과정 목록에서 선택된 래디오 버튼
    String paging    = (String)request.getAttribute("page");              // 과정 목록에서 선택된 page
    String CNT_REM   = (String)request.getAttribute("CNT_REM");           // 잔여강좌 count
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
// 신청화면으로 이동
function doSubmit() {
  buttonDisabled();
  document.form1.jobid.value = "first";
  document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationBuildSV";
  document.form1.method      = "post";
  document.form1.target      = "menuContentIframe";
  document.form1.submit();
}

// 앞화면
function do_preview(){
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationCourseListSV";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<div class="subWrapper">

    <div class="title"><h1>교육과정 안내</h1></div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>교육분야</th>
                    <td><%= dataInfo.ZGROUP %></td>
                    <th class="th02">과정명</th>
                    <td><%= dataInfo.GWAJUNG %></td>
                </tr>
                <tr>
                    <th>교육대상</th>
                    <td colspan="3"><%= subtype1.toString() %></td>
                </tr>
                <tr>
                    <th>교육목표</th>
                    <td colspan="3"><%= subtype2.toString() %></td>
                </tr>
                <tr>
                    <th>교육내용</th>
                    <td colspan="3"><%= subtype3.toString() %></td>
                </tr>
                <tr>
                    <th>진급필수</th>
                    <td colspan="3"><%= dataInfo.PELSU.equals("") ? "" : dataInfo.PELSU %></td>
                </tr>
                <tr>
                    <th>기타</th>
                    <td colspan="3"><%= subtype4.toString() %></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%
    if( CNT_REM.equals("Y") ) {
%>
            <li id="sc_button"><a href="javascript:doSubmit();"><span>신청</span></a></li>
<%
    }
%>
            <li><a href="javascript:do_preview();"><span>목록</span></a></li>
        </ul>
    </div>

    <!--------hidden Field ---------->
  <input type="hidden" name="jobid"     value="">
  <input type="hidden" name="OBJID_L"   value="<%= i_objid_L %>">
  <input type="hidden" name="OBJID_D"   value="<%= i_objid_D %>">
  <input type="hidden" name="page"      value="<%= paging %>">
  <input type="hidden" name="idx_Radio" value="<%= idx_Radio %>">
</form>
</div>

<%@ include file="/web/common/commonEnd.jsp" %>


