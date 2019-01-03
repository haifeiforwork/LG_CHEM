<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %> 
<%@ page import="hris.J.J01JobMatrix.*" %>

<%@ page import="com.sns.jdf.util.*" %>

<%
    
     Vector j02Result_vt  = (Vector)request.getAttribute("j02Result_vt");    
     String i_gubun       = (String)request.getAttribute("i_gubun");     
     String i_inx_s       = (String)request.getAttribute("i_inx_s");
     String i_inx_e       = (String)request.getAttribute("i_inx_e");            
     String i_find        = (String)request.getAttribute("i_find");            
     String paging        = (String)request.getAttribute("paging");

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
  	PageUtil pu = null;
  	if( i_gubun != null ) {
      	try {
      		pu = new PageUtil(j02Result_vt.size(), paging , 10, 10);
          Logger.debug.println(this, "page : "+paging);
      	} catch (Exception ex) {
      		Logger.debug.println(DataUtil.getStackTrace(ex));
      	}
    }
%>

<html>
<head>
<title>컴피턴시 리스트 검색</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
function doSearch(page) {

    document.form1.I_FIND.value  = "<%= i_find %>";
    document.form1.I_INX_S.value = "<%= i_inx_s %>";
    document.form1.I_INX_E.value = "<%= i_inx_e %>";
     
    if ( "<%= i_gubun %>" == "1" ) {
      document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J02CompetencyList.J02CompetencyListSV?I_GUBUN=<%= i_gubun %>&PAGING="+page;
    } else if ( "<%= i_gubun %>" == "2" ) {      
      document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J02CompetencyList.J02CompetencyListSV?I_GUBUN=<%= i_gubun %>&PAGING="+page;
    } else {
      return;
    }
    document.form1.method      = "post";
    document.form1.target="CompetencyMain";    
    document.form1.submit();
}     

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    doSearch(page);
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}

function goCompetencyListDetail(sobid) {

    document.form1.I_FIND.value  = "<%= i_find %>";
    document.form1.I_INX_S.value = "<%= i_inx_s %>";
    document.form1.I_INX_E.value = "<%= i_inx_e %>";

    document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J02CompetencyList.J02CompetencyListDetailSV?I_GUBUN=<%= i_gubun %>&PAGING=<%= paging %>&SOBID="+sobid;
    document.form1.method      = "post";
    document.form1.submit();
}
//-->
</SCRIPT>
</head>

<body bgcolor="#ffffff" leftmargin="16" topmargin="0" rightmargin="0" bottommargin="16">
<form name="form1" method="post">
  <input type="hidden" name="I_FIND" value="">
  <input type="hidden" name="I_INX_S" value="">
  <input type="hidden" name="I_INX_E" value="">

<table cellspacing=1 cellpadding=0 border=0 width=789>
  <tr>
    <td align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=614 bgcolor=#ffffff>
       <tr>
<% 
    if ( j02Result_vt != null && j02Result_vt.size() > 0 ) {
%>
          <td colspan=3 align=right><%= pu == null ? "" : pu.pageInfo() %></td>
       </tr>
        <tr bgcolor=#999999 height=2>
	        <td width=80></td>
          <td width=1></td>          
          <td width=533></td>
        </tr>
        <tr align=center>
          <td class=ct>No</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct>Competency</td>
        </tr>      	      
<%
    } else {
%>
          <td colspan=3 align=right>&nbsp;</td>
        </tr>	        
        <tr bgcolor=#999999 height=2>
	    <td width=80></td>
          <td width=1></td>
          <td width=533></td>
        </tr>
        <tr align=center height=10>
          <td colspan=3 class=ct></td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
	  <tr height=44>
          <td colspan=3 align=center>
	   <img src="<%= WebUtil.ImageURL %>jms/icon_Error.gif" align=absmiddle hspace=2>  해당 단어를 포함하는 Competency가 존재하지 않습니다.
	    </td>
	  </tr>
<%
    } 
%>

        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
<%
        if( j02Result_vt != null && j02Result_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                J01JobMatrixData data = (J01JobMatrixData)j02Result_vt.get(i);
%>
    	  <tr>
          <td class=ct1 align=center><%= i+1 %></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc><a href="javascript:goCompetencyListDetail('<%= data.OBJID %>');">&nbsp;&nbsp;<%=data.STEXT %></a></td>
    	  </tr>
          <tr>
           <td colspan=3 bgcolor=#999999></td>
          </tr>
    	  
<%
            }
%>
<!-- PageUtil 관련 - 반드시 써준다. -->
    	  <tr>
	        <td colspan=3 align=center>
<%= pu == null ? "" : pu.pageControl() %>
	        </td>
	      </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
<%
       }
%>
    	  </tr>
	    </table>
    </td>
  </tr>
</table>
</form>                
<%@ include file="/web/common/commonEnd.jsp" %>
