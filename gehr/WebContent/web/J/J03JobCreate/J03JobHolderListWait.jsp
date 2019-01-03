<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    WebUserData user            = (WebUserData)session.getAttribute("user");

//  생성, 수정 화면을 구분하기위해서 추가된 argument 
    String      jobidPop        = request.getParameter("jobidPop");

//  선택된 조직 코드를 읽는다.
    String      i_objid         = request.getParameter("OBJID_S");

    String      count           = request.getParameter("count");
    
    long        l_count         = 0;
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }

    Vector              j01SelectPers_vt    = new Vector();

//  Job Profile화면에서 이미 선택된 Job Holder 정보를 check한다.
    for( int i = 0 ; i < l_count ; i++ ) {
        J01PersonsData data_S = new J01PersonsData();

        data_S.PERNR = request.getParameter("PERNR_S"+i);                                 // 사번
        data_S.OBJID = request.getParameter("SOBID_S"+i);                                 // 포지션
        data_S.BEGDA = request.getParameter("BEGDA_S"+i);   // Job 시작일

        j01SelectPers_vt.addElement(data_S);
    }
%>  

<html>
<head>
<title>Job Holder 지정</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
//Job Holder 지정화면을 Open한다.
function on_Load() {
  document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03JobHolderList.jsp";
  document.form1.target = "setJobHolder";
  document.form1.submit();
}
//-->
</script>
</head>

<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:on_Load();">
<form name="form1" method="post" action="">
  <input type="hidden" name="jobidPop" value="<%= jobidPop %>">

  <input type="hidden" name="count"    value="<%= l_count %>">

  <input type="hidden" name="jobid"    value="">
  <input type="hidden" name="OBJID_S"  value="<%= i_objid %>">      <!-- Job Holder Popup창으로 보내줄 Objectives ID -->
  <input type="hidden" name="IMGIDX"   value="1">                   <!-- Menu Index   -->     

<%
//  Page 이동을 위해서 정보를 저장함.
    for( int i = 0 ; i < j01SelectPers_vt.size(); i++ ) {
        J01PersonsData data_P = (J01PersonsData)j01SelectPers_vt.get(i);
%>
   <input type="hidden" name="PERNR_S<%= i %>" value="<%= data_P.PERNR %>">
   <input type="hidden" name="SOBID_S<%= i %>" value="<%= data_P.OBJID %>">
   <input type="hidden" name="BEGDA_S<%= i %>" value="<%= data_P.BEGDA %>">
<%
    }
%>
<table width=100% border=0>
  <tr height=20>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20></td>
  </tr>
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>
  <tr height=332>
    <td valign=top align=center>
      <br>
      <table cellpadding=0 cellspacing=0 border=0 width=360>
        <tr height=30>
          <td colspan=3 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job Holder 지정</td>
          <td align="right" class="cc">&nbsp;</td>
		    </tr>         
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=40></td>
          <td width=1></td>
          <td width=200></td>
          <td width=119></td>
        </tr>
        <tr height="60">
          <td colspan=4 bgcolor=#ffffff align="center"><font color="#0000FF">조회중입니다. 잠시만 기다려주십시요.</font></td>
        </tr>
      </table>	
      <br>
    </td>
  </tr>  
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>  
  <tr height=10>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=10></td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
