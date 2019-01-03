<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.security.SecureRandom" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.J.J01JobMatrix.*" %>
 <%@ page import="java.util.*" %>
<%
//  Job Unit별 KSEA, Job Process Image FileName
    Vector             j01Result_vt   = (Vector)request.getAttribute("j01Result_vt");
//  Job Process일경우 Job Objectives와 Position
    Vector             j01Result_D_vt = (Vector)request.getAttribute("j01Result_D_vt");
    Vector             j01Result_P_vt = (Vector)request.getAttribute("j01Result_P_vt");
//  현재 page 번호를 받는다.
    String      paging              = (String)request.getAttribute("page");

//  eloffice Server에서 Image를 불러오기 위해서 - port를 난수를 발생시켜서 접속을 분할해준다.
    SecureRandom num   = new SecureRandom();
    int    R_num = num.nextInt(5);             // 0부터 4까지의 난수 발생

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if ( j01Result_vt != null && j01Result_vt.size() != 0 ) {
        try {
          pu = new PageUtil(j01Result_vt.size(), paging , 1, 10 );//Page 관련사항
        } catch (Exception ex) {
          Logger.debug.println(DataUtil.getStackTrace(ex));
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
<SCRIPT LANGUAGE="JavaScript">
<!--
//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form3.page.value = page;
  get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
    document.form3.action       = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01ImageFileNameSV";
    document.form3.method       = "post";
    document.form3.submit();
}
//-->
</SCRIPT>

<form name="form1" method="post" action="">
<table cellspacing=0 cellpadding=0 border=0 width=746>
  <tr>
    <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr bgcolor=#999999 height=2>
          <td width=160></td>
          <td width=1></td>
          <td width=585></td>
        </tr>
        <tr>
          <td class=ct align=center>Job Name</td>
          <td width=1 bgcolor=#999999></td>
          <td class=cc><%= dStext.STEXT_JOB %></td>
        </tr>
        <tr bgcolor=#999999>
          <td colspan=3></td>
        </tr>
<%
    if( i_imgidx.equals("4") ) {           // Job Process
//      Job Objectives
        StringBuffer subtype = new StringBuffer();
        for( int i = 0 ; i < j01Result_D_vt.size() ; i++ ) {
            J01ImageFileNameData data_D = (J01ImageFileNameData)j01Result_D_vt.get(i);
            subtype.append(data_D.TLINE+"<br>");
        }
%>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->
        <tr>
          <td colspan=11 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->
        <tr height=2>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>Job Objective</td>
	        <td width=1 bgcolor=#999999></td>
          <td class=cc><%= subtype.toString() %></td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
<%
//      Position
        String p_Info = "";

        for( int i = 0 ; i < j01Result_P_vt.size() ; i++ ) {
            J01ImageFileNameData data_P = (J01ImageFileNameData)j01Result_P_vt.get(i);
            if( i == 0 ) {
                p_Info = data_P.ENAME + " " + data_P.TITEL;
            } else if( ((i + 1) % 7) == 0 ) {         //7개씩 한줄에 보여준다.
                p_Info = p_Info + ", " + data_P.ENAME + " " + data_P.TITEL + ",<br>";
            } else if( (i % 7) == 0 ) {               //새줄 시작에서 ", "를 빼준다.
                p_Info = p_Info + data_P.ENAME + " " + data_P.TITEL;
            } else {
                p_Info = p_Info + ", " + data_P.ENAME + " " + data_P.TITEL;
            }
        }
%>
        <tr>
          <td class=ct align=center>Position</td>
	        <td width=1 bgcolor=#999999></td>
          <td class=cc><%= p_Info %></td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
<%
    }

    if( j01Result_vt.size() > 0 ) {
%>
        <!-- 이미지가 들어가는 table입니다 -->
        <tr>
          <td align=center colspan=3 class=cc>
            <table cellspacing=0 cellpadding=0 border=0>
              <tr height=15>
                <td></td>
              </tr>
<%
        if( i_imgidx.equals("4") ) {           // Job Process
%>
              <tr>
                <td align=right><%= pu == null ?  "" : pu.pageInfo() %></td>
              </tr>
<%
        } else {
%>
              <tr>
                <td align=right>&nbsp;</td>
              </tr>
<%
        }
%>
              <tr>
<%
        for( int i = pu.formRow() ; i < pu.toRow() ; i++ ) {
            J01ImageFileNameData data = (J01ImageFileNameData)j01Result_vt.get(i);

//          '1'이면 Job Unit별 KSEA, '2'이면 Job Process
            if( data.GUBN_CODE.equals("1") ) {
%>
                <td><img src="http://165.244.234.<%= user.clientNo.equals("310") ? "72" : "69" %>:300<%= user.clientNo.equals("310") ? 0 : R_num %>/j-image/ksea/<%= data.IMAG_NAME %>" ></td>
<%
            } else if( data.GUBN_CODE.equals("2") ) {
%>
                <td><img src="http://165.244.234.<%= user.clientNo.equals("310") ? "72" : "69" %>:300<%= user.clientNo.equals("310") ? 0 : R_num %>/j-image/process/<%= data.IMAG_NAME %>" ></td>
<%
            }
%>
              </tr>
<%
        }
%>
<!-- PageUtil 관련 - 반드시 써준다. -->
              <tr>
                <td align=center>
<%= pu == null ? "" : pu.pageControl() %>
                </td>
              </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
            </table>
          </td>
        </tr>
<%
    } else {
%>
        <tr>
          <td colspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=5></td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td width=129></td>
          <td width=1></td>
          <td width=600></td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#efefef>
            <table align=center border=0>
              <tr valign=top>
                <td width=20><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=2><br>※</td>
                <td width=600>
                해당 파일이 존재하지 않습니다.
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
<%
    }
%>
      </table>
    </td>
  </tr>
</table>
</form>

<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page"       value="<%= paging     %>">
  <input type="hidden" name="OBJID"      value="<%= i_objid    %>">
  <input type="hidden" name="SOBID"      value="<%= i_sobid    %>">
  <input type="hidden" name="PERNR"      value="<%= i_pernr    %>">
  <input type="hidden" name="BEGDA"      value="<%= i_begda    %>">        <!-- 적용일자 -->
  <input type="hidden" name="i_link_chk" value="<%= i_link_chk %>">
  <input type="hidden" name="IMGIDX"     value="<%= i_imgidx   %>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
