<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData     user               = (WebUserData)session.getAttribute("user");

//  휴가신청
    Vector          d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    D03VocationData data               = (D03VocationData)d03VocationData_vt.get(0);

//  결제정보를 vector로 받는다
    Vector          AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess3.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function do_list(){
  document.form1.jobid.value = "first";

  document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A16Appl.A16ApplListSV";
  document.form1.method = "post";
  document.form1.submit();
}

function do_change(){
  if( chk_APPR_STAT(0) ){
    document.form1.jobid.value = "first";
    document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D07Maternity.D07MaternityChangeSV";
    document.form1.method = "post";
    document.form1.submit();
  }
}

function do_delete(){
    if( chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value = "delete";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D07Maternity.D07MaternityDetailSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<form name="form1" method="post" action="">
<div class="subWrapper">

    <div class="title"><h1>산전후 휴가신청 조회</h1></div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일</th>
                    <td>
                        <input type="text" name="BEGDA" value="<%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th>신청기간</th>
                    <td>
                        <input type="text" name="APPL_FROM" value="<%= data.APPL_FROM.equals("0000-00-00") ? "" : WebUtil.printDate(data.APPL_FROM) %>" size="20" readonly>
                        부터
                        <input type="text" name="APPL_TO"   value="<%= data.APPL_TO.equals("0000-00-00")   ? "" : WebUtil.printDate(data.APPL_TO)   %>" size="20" readonly>
                        까지
                    </td>
                </tr>
                <tr>
                    <th>출산예정일</th>
                    <td>
                        <input type="text" name="RMDDA" value="<%= data.RMDDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.RMDDA) %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th>휴가일수</th>
                    <td>
                        <input type="radio" name="PBEZ4" value="90" <%= WebUtil.printNumFormat(data.PBEZ4).equals("90") ? "checked" : "" %> disabled>90일
                        &nbsp;
                        <input type="radio" name="PBEZ4" value="45" <%= WebUtil.printNumFormat(data.PBEZ4).equals("45") ? "checked" : "" %> disabled>45일
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppDetail(AppLineData_vt) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%
/*  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분   */
  String ThisJspName = (String)request.getAttribute("ThisJspName");
  Logger.debug.println(this, "ThisJspName : "+ ThisJspName);
  if ( ThisJspName.equals("A16ApplList.jsp")  ) {

%>
            <li><a href="javascript:do_list();"><span>목록</span></a></li>
<%
  }
/*  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분   */
%>
            <li><a href="javascript:do_change();"><span>수정</span></a></li>
            <li><a href="javascript:do_delete();"><span>삭제</span></a></li>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="jobid"       value="">
      <input type="hidden" name="AINF_SEQN"   value="">
      <input type="hidden" name="ThisJspName" value="<%=ThisJspName%>">
<!--  HIDDEN  처리해야할 부분 끝-->

</div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

