<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    Vector j02Result_vt   = (Vector)request.getAttribute("j02Result_vt");
    Vector j02Result_D_vt = (Vector)request.getAttribute("j02Result_D_vt");
    String E_STEXT_Q      = (String)request.getAttribute("E_STEXT_Q");    
    String i_gubun        = (String)request.getAttribute("i_gubun");     
    String i_inx_s        = (String)request.getAttribute("i_inx_s");
    String i_inx_e        = (String)request.getAttribute("i_inx_e");            
    String i_find         = (String)request.getAttribute("i_find");            
    String paging         = (String)request.getAttribute("paging");
    
     
    StringBuffer subtype  = new StringBuffer();
    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    
    for( int i = 0 ; i < j02Result_D_vt.size() ; i++ ) {
        J01CompetencyDetailData data_D = (J01CompetencyDetailData)j02Result_D_vt.get(i);    
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

<script language="JavaScript">
<!--
function goList() {

    document.form1.I_FIND.value  = "<%= i_find %>";
    document.form1.I_INX_S.value = "<%= i_inx_s %>";
    document.form1.I_INX_E.value = "<%= i_inx_e %>";
     
    if ( "<%= i_gubun %>" == "1" ) {
      document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J02CompetencyList.J02CompetencyListSV?I_GUBUN=<%= i_gubun %>&PAGING=<%= paging %>";
    } else if ( "<%= i_gubun %>" == "2" ) {      
      document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J02CompetencyList.J02CompetencyListSV?I_GUBUN=<%= i_gubun %>&PAGING=<%= paging %>";
    } else {
      return;
    }
    document.form1.method = "post";
    document.form1.target = "CompetencyMain";    
    document.form1.submit();
}     
//-->
</script>

<body bgcolor="#ffffff" leftmargin="18" topmargin="0" rightmargin="0" bottommargin="20">
<form name="form1" method="post" action="">
  <input type="hidden" name="I_FIND" value="">
  <input type="hidden" name="I_INX_S" value="">
  <input type="hidden" name="I_INX_E" value="">

<table cellspacing=1 cellpadding=0 border=0 width=789>
  <tr>
    <Td align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=624 bgcolor=#ffffff>
        <tr bgcolor=#999999 height=2>
          <td width=79></td>
          <td width=1></td>
          <td width=79></td>
          <td width=1></td>
          <td width=464></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center><%= E_STEXT_Q %></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc>
<%  
    for( int j = 0 ; j < j02Result_D_vt.size() ; j++ ) {
        J01CompetencyDetailData data_T = (J01CompetencyDetailData)j02Result_D_vt.get(j);
        if( data_T.SUBTY.equals("0000") ) {
            subtype.append("&nbsp;"+data_T.TLINE+"<br>");
        }
    }
%>
              <%= subtype.toString()%>
          </td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
        <!-- JMS 시스템은 일괄 좌측 정렬입니다.-->
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=5 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>	  
        <tr bgcolor=#999999 height=2>
          <td width=79></td>
          <td width=1></td>
          <td width=79></td>
          <td width=1></td>
          <td width=464></td>
        </tr>
        <tr align=center>
          <td class=ct>숙련도수준</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct>Key Words</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct>Behavior Indicator</td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>	  
<%  
    for( int i= 0 ; i < j02Result_vt.size() ; i++ ) {
        J01CompetencyDetailData data = (J01CompetencyDetailData)j02Result_vt.get(i);
%>
        <tr>
          <td class=ct1 align=center><%= data.ZLEVEL %><br>(<%= data.ZLEVEL_RAT %>)</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1><%= data.STEXT_KEY %></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
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
          <td colspan=5 align=center>
	    <br>
           <a href="javascript:goList();"><img src="<%= WebUtil.ImageURL %>jms/btn_list.gif" border=0 alt="목록"></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
