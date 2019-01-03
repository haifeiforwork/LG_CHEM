<!doctype html>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<jsp:include page="/web/common/includeLocation.jsp" />

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">


<script language="JavaScript">


<!--

// moveTo(screen.width/2-200, screen.height/2-110);// 화면가운데로 이동 // 듈얼모니터에서 주화면으로 감.
resizeTo( 270,270);

function setTime() {
  hh = document.form1.HH[document.form1.HH.selectedIndex].value;
  mm = document.form1.MM[document.form1.MM.selectedIndex].value;

  opener.document.<%=request.getParameter("formname")%>.<%=request.getParameter("fieldname")%>.value=hh+":"+mm;
  opener.check_Time();
  self.close();
}
//-->
</script>
<style type="text/css">
body {font-family:malgun gothic;}
.ment {font-size:12px;color:#666;padding:0 0 0 10px;}
.timeDiv {background:#f6f6f6;border:solid 1px #ddd;padding:10px 0 10px 0;text-align:center;margin:10px auto 10px auto;font-size:11px;}
</style>
</head>

<!-- <body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onBlur="window.close()"> -->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">
<div class="winPop">
	<div class="header">
		<span> <spring:message code="LABEL.COMMON.0036"/><!-- 선택시간 --></span>
		<a href="javascript:window.close();"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png"/></a>
	</div>
	<div class="body">
		<p><spring:message code="LABEL.COMMON.0037"/><!-- 입력할 시간을 선택해 주세요. --></p>

		<div class="timeDiv">
			<select name="HH">
<%
    for( int i = 0 ; i < 24 ; i++ ) {
      String temp = Integer.toString(i);
%>
                      <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
			</select>
                    <spring:message code="LABEL.COMMON.0038"/><!-- 시 -->&nbsp;&nbsp;

			<select name="MM">
<%
      //for( int i = 0 ; i < 60 ; i++ ) {
      //String temp = Integer.toString(i*1);
      // workTime52수정
      for( int i = 0 ; i < 6 ; i++ ) {
      String temp = Integer.toString(i*10);
%>
                      <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
			</select>
                    <spring:message code="LABEL.COMMON.0039"/><!-- 분 -->
		</div>



	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" href="javascript:setTime();"><span><spring:message code="BUTTON.COMMON.CONFIRM"/><!-- 확인 --></span></a></li>
			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CANCEL"/><!-- 취소 --></span></a></li>
		</ul>
		<div class="clear"></div>
	</div>
	</div>
</div>

</form>
</body>
</html>
