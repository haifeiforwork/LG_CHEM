<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
  
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %> 
<%
    Vector j01Result_vt   = (Vector)request.getAttribute("j01Result_vt");
    Vector j01Result_D_vt = (Vector)request.getAttribute("j01Result_D_vt");
    String c_sobid        = (String)request.getAttribute("c_sobid");     
    String E_STEXT_Q      = (String)request.getAttribute("E_STEXT_Q"); 

    StringBuffer subtype  = new StringBuffer();
    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    
    for( int i = 0 ; i < j01Result_D_vt.size() ; i++ ) {
        J01CompetencyDetailData data_D = (J01CompetencyDetailData)j01Result_D_vt.get(i);    
        if( data_D.SUBTY.equals("0001") ) {
            subtype1.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("0002") ) {
            subtype2.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("0003") ) {
            subtype3.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("0004") ) {
            subtype4.append(data_D.TLINE+"<br>");
        } 
    }
%>
 
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<%@ include file="J01JobMatrixMenu.jsp" %>

<form name="form1" method="post" action="">

<table cellspacing=0 cellpadding=0 border=0 width=746>
  <tr>
    <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr bgcolor=#999999 height=2>
          <td width=109></td>
          <td width=1 bgcolor=#999999></td>
          <td colspan=3 width=636></td>
        </tr>
        <tr>
          <td class=ct align=center><%= E_STEXT_Q %></td>
          <td width=1 bgcolor=#999999></td>
<%  
    for( int j = 0 ; j < j01Result_D_vt.size() ; j++ ) {
        J01CompetencyDetailData data_T = (J01CompetencyDetailData)j01Result_D_vt.get(j);
        if( data_T.SUBTY.equals("0000") ) {
            subtype.append("&nbsp;"+data_T.TLINE+"<br>");
        }
    }
%>
          <td colspan=3 class=cc><%= subtype.toString()%></td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=11 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td width=109></td>
          <td width=1 bgcolor=#999999></td>
          <td width=119></td>
          <td width=1 bgcolor=#999999></td>
          <td width=516></td>
        </tr>
        <tr>
          <td class=ct align=center>숙련도 수준</td>
          <td width=1 bgcolor=#999999></td>
          <td class=ct align=center>Key Words</td>
          <td width=1 bgcolor=#999999></td>
          <td class=ct align=center>Behavioral Indicator</td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
<%  
    for( int i= 0 ; i < j01Result_vt.size() ; i++ ) {
        J01CompetencyDetailData data = (J01CompetencyDetailData)j01Result_vt.get(i);
%>
        <tr>
          <td class=ct1 align=center><%= data.ZLEVEL %><br>(<%= data.ZLEVEL_RAT %>)</td>
          <td width=1 bgcolor=#999999></td>
          <td class=cc><%= data.STEXT_KEY %></td>
          <td width=1 bgcolor=#999999></td>
<%      if( data.ZLEVEL_RAT.equals("1") ) {               %>
          <td class=cc><%= subtype1.toString() %></td>
<%      } else if ( data.ZLEVEL_RAT.equals("2") ) {       %>
          <td class=cc><%= subtype2.toString() %></td>
<%      } else if ( data.ZLEVEL_RAT.equals("3") ) {       %>
          <td class=cc><%= subtype3.toString() %></td>
<%      } else if ( data.ZLEVEL_RAT.equals("4") ) {       %>
          <td class=cc><%= subtype4.toString() %></td>
<%      }                                                 %>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
<%
    }
%>
        <tr>
          <td colspan=5 align=center><br><a href="javascript:history.back();"><img src="<%= WebUtil.ImageURL %>jms/btn_goback.gif" border=0></a></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
