<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.C.C10Education.*" %>
<%@ page import="hris.C.C10Education.rfc.*" %>

<%
//  defult 정렬값 신청일 역정렬
    WebUserData user                 = (WebUserData)session.getAttribute("user");
    Vector      c10CourseListData_vt = (Vector)request.getAttribute("c10CourseListData_vt");
    String      paging               = (String)request.getAttribute("page");
    String      i_objid_L            = (String)request.getAttribute("i_objid_L");         // 비즈니스 이벤트 그룹 ID (L)
    String      idx_Radio            = (String)request.getAttribute("idx_Radio");
    if( idx_Radio == null || idx_Radio.equals("") ) {     idx_Radio = "0";     }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if ( c10CourseListData_vt != null && c10CourseListData_vt.size() != 0 ) {
        try {
          pu = new PageUtil(c10CourseListData_vt.size(), paging , 10, 10 );  //Page 관련사항
        } catch (Exception ex) {
          Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
// 조회
function doSearch() {
  var command = getRadio();

  document.form1.jobid.value = "detail";

  document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationBuildSV";
  document.form1.method = "post";
  document.form1.target = "menuContentIframe";
  document.form1.submit();
}

// 신청
function doSubmit() {
  var command = getRadio();

  if( document.form1.CNT_REM.value == "Y" ) {
    buttonDisabled();
    document.form1.jobid.value = "first";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationBuildSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
  } else {
    alert("잔여차수가 존재하지 않습니다. 조회만 가능합니다.");
  }
}

// 현재 radio button의 index 얻기
function getRadio() {
  var command = "";
  var size = "";

  if( isNaN( document.form1.radiobutton.length ) ){
    size = 1;
  } else {
    size = document.form1.radiobutton.length;
  }
  for (var i = 0; i < size ; i++) {
      if ( size == 1 ){
          command = 0;
      } else if ( document.form1.radiobutton[i].checked == true ) {
          command = document.form1.radiobutton[i].value;
      }
  }

  eval("document.form1.OBJID_D.value = document.form1.OBJID_D"+command+".value");
  eval("document.form1.CNT_REM.value = document.form1.CNT_REM"+command+".value");
  document.form1.idx_Radio.value     = command;

  return command;
}

// 앞화면
function do_preview(){
  document.form1.action = "<%= WebUtil.JspURL %>C/C10Education/C10EducationMatrix.jsp";
  document.form1.method = "post";
  document.form1.target = "menuContentIframe";
  document.form1.submit();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value      = page;
  document.form1.idx_Radio.value = "0";
  get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
  document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationCourseListSV";
  document.form1.method = "post";
  document.form1.submit();
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif','<%= WebUtil.ImageURL %>icon_Darrow_next_o.gif','<%= WebUtil.ImageURL %>icon_arrow_next_o.gif','<%= WebUtil.ImageURL %>icon_Darrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_prev_o.gif')">
<form name="form1">
  <input type="hidden" name="jobid"     value="">
  <input type="hidden" name="OBJID_D"   value="">
  <input type="hidden" name="OBJID_L"   value="<%= i_objid_L %>">
  <input type="hidden" name="page"      value="<%= paging %>">
  <input type="hidden" name="CNT_REM"   value="">
  <input type="hidden" name="idx_Radio" value="<%= idx_Radio %>">

<div class="subWrapper">

    <div class="title01"><h1><%= DataUtil.getCurrentYear() + "년" %> 교육과정 안내/신청</h1></div>

<%
    if( c10CourseListData_vt.size() > 0 ) {
%>
    <td>
      <table width="650" border="0" cellspacing="0" cellpadding="0" height="23">
        <tr>
          <td valign="top">


          </td>
        </tr>
      </table>
    </td>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:doSearch();"><span>조회</span></a></li>
                    <li id="sc_button"><a href="javascript:doSubmit();"><span>신청</span></a></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>선택</th>
                    <th>과정명</th>
                    <th>총차수</th>
                    <th>종료차수</th>
                    <th class="lastCol">잔여차수</th>
                </tr>
<%
        int j = 0;//내부 카운터용
        int i_idx_Radio = 0;
        i_idx_Radio = Integer.parseInt(idx_Radio);
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            C10EducationCourseListData data = (C10EducationCourseListData)c10CourseListData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td><input type="radio" name="radiobutton" value="<%= j %>" <%=(j==i_idx_Radio) ? "checked" : ""%>></td>
                    <td><%= data.STEXT   %></td>
                    <td class="align_right"><%= data.CNT_TOT %></td>
                    <td class="align_right"><%= data.CNT_END %></td>
                    <td class="align_right lastCol"><%= data.CNT_REM %></td>
                </tr>
          <input type="hidden" name="OBJID_D<%= j %>" value="<%= data.OBJID %>">
          <input type="hidden" name="CNT_REM<%= j %>" value="<%= data.CNT_REM.equals("0") ? "N" : "Y" %>">
<%
        j++;
        }
    } else {
%>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>선택</th>
                    <th>과정명</th>
                    <th>총차수</th>
                    <th>종료차수</th>
                    <th class="lastCol">잔여차수</th>
                </tr>
                <tr class="oddRow">
                    <td class="lastCol" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
<%
    }
%>
            </table>
            <!-- PageUtil 관련 - 반드시 써준다. -->
            <div class="align_center">
                <%= pu == null ? "" : pu.pageControl() %>
            </div>
        </div>
    </div>
    <!-- 조회 리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:do_preview();"><span>이전화면</span></a></li>
        </ul>
    </div>

</div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>



