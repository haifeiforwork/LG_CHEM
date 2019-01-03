<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    
    // 첫 화면에 리스트되는 데이터들..
    Vector      A08LicenseDetailData_vt = (Vector)request.getAttribute("A08LicenseDetail_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}

MM_reloadPage(true);

function view_detail(idx) {
	licn_code = eval("document.form1.LICN_CODE" + idx + ".value");
	flag      = eval("document.form1.FLAG"      + idx + ".value");
    
  if( flag == "X" ) {    // 자격수당이 있는 경우..
		window.open('', 'essPopup', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=552,height=365,left=100,top=100");
    
    document.form1.jobid.value     = "pop";
    document.form1.licn_code.value = licn_code;
    
    document.form1.target = "essPopup";
    document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A08LicenseDetailSV_m';
    document.form1.method = "post";
    document.form1.submit();
  }
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="36">
      <td width="15">&nbsp;</td>
      <td class="td02">
        <font color="#0000FF"><%= "▶ " + user_m.ename + " " + user_m.e_titel + "의 HR정보입니다." + ( user_m.i_stat2.equals("0") ? " (퇴직자)" : "" ) %></font>
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="title01">자격면허 조회</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td class="font01"><font color="#7897FC">■</font> 자격면허</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td>
        <!--자격면허 테이블 시작-->
        <table width="765" border="0" cellspacing="1" cellpadding="4" class="table02">
          <tr> 
            <td class="td03" width="180">자격면허</td>
            <td class="td03" width="85">취득일</td>
            <td class="td03" width="85">등급</td>
            <td class="td03" width="165">발행기관</td>
            <td class="td03" width="250">법정선임사유</td>
          </tr>
<% 
    if( A08LicenseDetailData_vt.size() > 0 ) {
    	  for ( int i = 0 ; i < A08LicenseDetailData_vt.size() ; i++ ) {
            A08LicenseDetailData data = (A08LicenseDetailData)A08LicenseDetailData_vt.get(i); 
%>
          <tr> 
<%
            if( data.FLAG.equals("X") ) {
%>

            <td class="td04"><a href="javascript:view_detail(<%=i%>)"><%= data.LICN_NAME %></a></td>
<%
            } else {
%>
            <td class="td04"><%= data.LICN_NAME %></td>
<%
            } 
%>
            <td class="td04"><%= data.OBN_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.OBN_DATE) %></td>
            <td class="td04"><%= data.GRAD_NAME %></td>
            <td class="td04"><%= data.PUBL_ORGH %></td>
            <td class="td04"><%= data.ESTA_AREA %></td>
            <input type="hidden" name="LICN_CODE<%= i %>" value="<%= data.LICN_CODE %>">
            <input type="hidden" name="FLAG<%= i %>"      value="<%= data.FLAG %>">
          </tr>
<%
        }
    } else {
%>
          <tr align="center"> 
            <td class="td04" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
          </tr>
<%
    }
%>
        </table>
        <!--자격면허 테이블 끝-->
      </td>
    </tr>
  </table>
  <input type="hidden" name="jobid"     value="">
  <input type="hidden" name="licn_code" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
