<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="commonProcess.jsp" %>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" />
<script language="javascript">
    function f_print(){
        // if( confirm("① [파일]->[페이지 설정]에서 다음과 같이 설정하시기 바랍니다.  \n\n용지크기\t\t: A4\n머리글/바닥글\t: 내용 삭제\n방향\t\t: 세로\n여백(밀리미터)\t: 왼쪽 19.05 위쪽 19.05\n용지옵션\t\t: 배경색 및 이미지 인쇄  체크") ) {
           if( confirm("<%=g.getMessage("MSG.COMMON.0059")%>") ) {
              parent.beprintedpage.focus();
              parent.beprintedpage.print();
        }

    }
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
	<div class="buttonArea">
		<ul class="btn_crud">
		    <li><a class="darken" href="javascript:f_print();"><span><%=g.getMessage("LABEL.COMMON.0001")%></span></a></li>
		    <li><a href="javascript:top.close();"><span><%=g.getMessage("LABEL.COMMON.0002")%></span></a></li>
		</ul>
	</div>
<!-- <table width="97%" border="0" cellspacing="0" cellpadding="0" height="30">
  <tr>
    <td align="right" valign="bottom">
      <a href="javascript:f_print();">
      <img src="<%= WebUtil.ImageURL %>btn_print.gif" border="0"></a>
      <a href="javascript:top.close();">
      <img src="<%= WebUtil.ImageURL %>btn_close.gif" border="0"></a>
    </td>
  </tr>
</table>-->
<%@ include file="commonEnd.jsp" %>
