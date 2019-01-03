<%@ page contentType="text/html; charset=utf-8" %>  
<%@ include file="/web/common/popupPorcess.jsp" %>
 
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %> 
<%@ page import="java.util.*" %>    
<% 
//  Job Leveling Sheet 정보
    Vector             j01Result_vt   = (Vector)request.getAttribute("j01Result_vt");
    Vector             j01Result_D_vt = (Vector)request.getAttribute("j01Result_D_vt");
    Vector             j01Result_L_vt = (Vector)request.getAttribute("j01Result_L_vt");
//  Job Leveling 결과
    String E_LEVEL        = (String)request.getAttribute("E_LEVEL");

    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    StringBuffer subtype5 = new StringBuffer();
    StringBuffer subtype6 = new StringBuffer();
    for( int i = 0 ; i < j01Result_D_vt.size() ; i++ ) {
        J01LevelingSheetData data_P = (J01LevelingSheetData)j01Result_D_vt.get(i);
        
        if( data_P.SUBTY.equals("9040") ) {
            subtype1.append("&nbsp;"+data_P.TLINE+"<br>");
        } else if( data_P.SUBTY.equals("9041") ) {
            subtype2.append("&nbsp;"+data_P.TLINE+"<br>");
        } else if( data_P.SUBTY.equals("9042") ) {
            subtype3.append("&nbsp;"+data_P.TLINE+"<br>");
        } else if( data_P.SUBTY.equals("9043") ) {
            subtype4.append("&nbsp;"+data_P.TLINE+"<br>");
        } else if( data_P.SUBTY.equals("9044") ) {
            subtype5.append("&nbsp;"+data_P.TLINE+"<br>");
        } else if( data_P.SUBTY.equals("9045") ) {
            subtype6.append("&nbsp;"+data_P.TLINE+"<br>");
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
          <td width=29></td>
          <td width=1></td>
          <td width=145></td>
          <td width=1></td>
          <td width=305></td>
          <td width=1></td>
          <td width=60></td>
          <td width=1></td>
          <td width=60></td>
          <td width=1></td>
          <td width=60></td>
          <td width=1></td>
          <td width=60></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>Job Name</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=9 class=cc><%= dStext.STEXT_JOB %></td>
    	  </tr>
        <tr>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=13 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->	  
        <tr height=2>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
        <tr>
    	    <td class=ct rowspan=3></td>
	        <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td rowspan=3 class=ct align=center>직무평가 요소</td>
          <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct rowspan=3 align=center>정의</td>
          <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct colspan=7 align=center>Grade</td>
        </tr>
        <tr>
          <td colspan=7 bgcolor=#999999></td>
        </tr>
    	  <tr>
<%
    for( int i = 0 ; i < j01Result_L_vt.size() ; i ++ ) {
        J01LevelingSheetData data_L = (J01LevelingSheetData)j01Result_L_vt.get(i);
%>
    	    <td class=ct1 align=center><%= data_L.LEVEL_NAME %></td>
<%
        if( i != (j01Result_L_vt.size() - 1) ) {
%>
    	    <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
        }
    }
%>
    	  </tr>
        <tr>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
<%
    String old_code = "";
    long   l_count  = 0;
    for( int i = 0 ; i < j01Result_vt.size() ; i ++ ) {
        J01LevelingSheetData data = (J01LevelingSheetData)j01Result_vt.get(i);
        if( !data.DSORT_CODE.equals(old_code) ) { 
            l_count = 0;
            for( int j = 0 ; j < j01Result_vt.size() ; j++ ) {
                J01LevelingSheetData data_t = (J01LevelingSheetData)j01Result_vt.get(j);
                if( data.DSORT_CODE.equals(data_t.DSORT_CODE) ) {
                    l_count += 1;
                }
            }
%>
        <tr>
          <td class=ct1 rowspan="<%= (l_count * 2) - 1 %>" style="writing-mode:tb-rl" align="center"><%= data.DSORT_NAME %></td>
          <td width=1   rowspan="<%= (l_count * 2) - 1 %>" bgcolor=#999999></td>
<%
            old_code = data.DSORT_CODE;
        } else {
%>
       <tr>
<%
        }
%>
          <td class=cc><%= data.ELEME_NAME %></td>
          <td width=1 bgcolor=#999999></td>
<%
        StringBuffer subtype = new StringBuffer();
        for( int j = 0 ; j < j01Result_D_vt.size() ; j++ ) {
            J01LevelingSheetData data_D = (J01LevelingSheetData)j01Result_D_vt.get(j);
            if( data.TDNAME.equals(data_D.SUBTY) ) {
                subtype.append(data_D.TLINE+"<br>");
            }
        }
%>
          <td class=cc><%= subtype.toString() %></td>
          <td width=1 bgcolor=#999999></td>
<%
        for( int j = 0 ; j < j01Result_L_vt.size() ; j++ ) {
            J01LevelingSheetData data_L = (J01LevelingSheetData)j01Result_L_vt.get(j);
            if( data.LEVEL_CODE0.equals(data_L.LEVEL_CODE) ) {
%>
          <td class=cc align="center">○</td>
<%
            } else {
%>
          <td class=cc>&nbsp;</td>
<%
            }
            if( j != (j01Result_L_vt.size() - 1) ) {
%>
          <td width=1 bgcolor=#999999></td>

<%
            }
        }
%>
        </tr>
    	  <tr>
    	    <td bgcolor=#999999 colspan=13></td>
    	  </tr>
<%
    }
%>
        <tr>
          <td colspan=13><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=2 height=5></td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td colspan=13></td>
        </tr>
        <tr bgcolor=#efefef height=25>
          <td colspan=10 align=right>Job Leveling 결과 : </td>
          <td colspan=3 class=ct1><%= E_LEVEL %></td>
        </tr>
        <tr>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
