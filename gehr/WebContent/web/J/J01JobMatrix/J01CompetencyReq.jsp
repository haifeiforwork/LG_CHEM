<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
//  Competency Requirements
    Vector             j01Result_Q_vt = (Vector)request.getAttribute("j01Result_Q_vt");
    Vector             j01Result_D_vt = (Vector)request.getAttribute("j01Result_D_vt");
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
          <td width=79></td>
          <td width=1></td> 
          <td width=49></td>
          <td width=1></td>
          <td width=109></td>
          <td width=1></td>
          <td width=476></td>
        </tr>
        <tr>
          <td colspan=3 class=ct align="center">Job Name</td>
          <td width=1 bgcolor=#999999></td>
          <td colspan=5 class=cc><%= dStext.STEXT_JOB %></td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=11 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->	  
        <tr height=2>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td colspan=3 class=ct align="center">요구역량</td>
          <td width=1 bgcolor=#999999></td>
          <td class=ct1 align="center">요구<br>수준</td>
          <td width=1 bgcolor=#999999></td>
          <td class=ct1 align="center">Key Words</td>
          <td width=1 bgcolor=#999999></td>
          <td class=ct1 align="center">행동지표</td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
<%
    String old_objid = "";
    long   l_count   = 0;
    for( int i = 0 ; i < j01Result_Q_vt.size() ; i ++ ) {
        J01CompetencyReqData data_Q = (J01CompetencyReqData)j01Result_Q_vt.get(i);
        if( !data_Q.OBJID_G.equals(old_objid) ) { 

//          자격요건 Group 명 td를 rowspan할 count를 구한다. -----------------------------
            l_count = 0;
            for( int j = 0 ; j < j01Result_Q_vt.size() ; j++ ) {
                J01CompetencyReqData data_t = (J01CompetencyReqData)j01Result_Q_vt.get(j);
                if( data_Q.OBJID_G.equals(data_t.OBJID_G) ) {
                    l_count += 1;
                }
            }
%>
        <tr>
          <td rowspan="<%= (l_count * 2) - 1 %>" class=ct style="writing-mode:tb-rl" align="center"><%= data_Q.STEXT %></td>
          <td rowspan="<%= (l_count * 2) - 1 %>" width=1 bgcolor=#999999></td>
<%
            old_objid = data_Q.OBJID_G;
        } else {
%>
        <tr>
<%
        }
%>
          <td class=ct1><a href="javascript:goCompetencyDetail('<%= data_Q.SOBID %>','<%= i_imgidx %>');"><%= data_Q.STEXT_Q %></td>
          <td width=1 bgcolor=#999999></td>
          <td class=cc align=center><%= data_Q.ZLEVEL %></td>
          <td width=1 bgcolor=#999999></td>
          <td class=cc><%= data_Q.STEXT_KEY %></td>
          <td width=1 bgcolor=#999999></td>
<%
        StringBuffer subtype = new StringBuffer();
        for( int j = 0 ; j < j01Result_D_vt.size() ; j++ ) {
            J01CompetencyReqData data_D = (J01CompetencyReqData)j01Result_D_vt.get(j);
            if( data_Q.SOBID.equals(data_D.OBJID) ) {
                subtype.append(data_D.TLINE+"<br>");
            }
        }

%>
          <td class=cc><%= subtype.toString() %></td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
<%
    }
%>
        <tr>
          <td colspan=11 class=cc><b>※ 요구역량을 click하시면 상세내용을 확인하실 수 있습니다.</b></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
 