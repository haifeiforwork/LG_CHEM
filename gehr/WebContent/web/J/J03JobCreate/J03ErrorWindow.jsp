<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    Vector j01Error_vt = new Vector();
    String count_E     = request.getParameter("count_E");
    
    long        l_count         = 0;
    if( count_E != null ) {
        l_count                 = Long.parseLong(count_E);
    }
    
    for( int i = 0 ; i < l_count ; i++ ) {    
        J03MessageData errData = new J03MessageData();

        errData.MSGSPRA = request.getParameter("MSGSPRA"+i);
        errData.MSGID   = request.getParameter("MSGID"+i);
        errData.MSGNR   = request.getParameter("MSGNR"+i);
        errData.MSGTEXT = request.getParameter("MSGTEXT"+i);

        j01Error_vt.addElement(errData);
    }
%>

<html>  
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
<table width=100% border=0>
  <tr height=20>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20></td>
  </tr>
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>
  <tr height=315>
    <td valign=top align=center>
      <br>
      <table cellpadding=0 cellspacing=0 border=0 width=440>
        <tr height=30>
          <td colspan=5 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Error Message List</td>
		    </tr>         
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=40></td>
          <td width=1></td>
          <td width=40></td>
          <td width=1></td>
          <td width=358></td>
        </tr>
        <tr>
          <td class=ct align=center>MSGID</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct align=center>MSGNR</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct>&nbsp;MSGTEXT</td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
<%
    for( int i = 0 ; i < l_count ; i++ ) {
        J03MessageData errData = (J03MessageData)j01Error_vt.get(i);
%>
        <tr>
          <td class=ct1 align=center><%= errData.MSGID %></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1 align=center><%= errData.MSGNR %></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc>&nbsp;<%= errData.MSGTEXT %></td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
<%
    }
%>
        <tr height=40>
          <td colspan=5 align=center valign=bottom>
           <a href="javascript:parent.window.close();"><img src="<%= WebUtil.ImageURL %>jms/btn_close.gif" border=0 hspace=5 alt="삭제"></a>
          </td>
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
