<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.J.J02CompetencyList.rfc.*" %>
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%
     J02CompetencyListRFC rfc           = new J02CompetencyListRFC();

     Vector              j02Result_vt   = new Vector();
     j02Result_vt  = rfc.getDetail( "2", "", "", "%", "" );

	/*----- Excel 파일 저장하기 --------------------------------------------------- */
	 response.setContentType("application/vnd.ms-excel; charset=utf-8");
	 response.setHeader("Content-Disposition","attachment; filename=untitled.xls");

	/*----- Excel 파일 저장하기 --------------------------------------------------- */
%>

<html>
<head>
<title>컴피턴시 리스트 검색</title>
<!--<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">-->

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
//-->
</SCRIPT>
</head>

<body bgcolor="#ffffff" leftmargin="16" topmargin="0" rightmargin="0" bottommargin="16">
<form name="form1" method="post">
<table cellspacing=1 cellpadding=0 border=0 width=801>
  <tr>
    <td align=center>
      <table cellpadding=0 cellspacing=0 border=1 width=800 bgcolor=#ffffff>
       <tr>
<%
    if ( j02Result_vt != null && j02Result_vt.size() > 0 ) {
%>
       </tr>
        <tr align=center>
          <td class=ct>No</td>
          <td class=ct>Competency</td>
          <td width=530>상세내용</td>
        </tr>
<%
    }
%>
<%
        if( j02Result_vt != null && j02Result_vt.size() > 0 ){
            for( int i = 0 ; i < j02Result_vt.size(); i++ ) {
                J01JobMatrixData data = (J01JobMatrixData)j02Result_vt.get(i);
%>
    	  <tr>
          <td class=ct1 align=center><%= i+1 %></td>
          <td class=cc><%=data.STEXT %></a></td>
    	  <td>

<%
            J01CompetencyDetailRFC rfc22  = new J01CompetencyDetailRFC();

            Vector ret            = new Vector();
            Vector j02Result_D_vt = new Vector();
            String E_STEXT_Q      = "";

//          적용일자(조회기준일)를 현재날짜로 넣어준다.
            ret            = rfc22.getDetail( data.OBJID, DataUtil.getCurrentDate() );
            j02Result_D_vt = (Vector)ret.get(1);
            E_STEXT_Q      = (String)ret.get(2);
            StringBuffer subtype  = new StringBuffer();


%>
<%
           for( int j = 0 ; j < j02Result_D_vt.size() ; j++ ) {
                J01CompetencyDetailData data_T = (J01CompetencyDetailData)j02Result_D_vt.get(j);
                if( data_T.SUBTY.equals("0000") ) {
                    subtype.append("&nbsp;"+data_T.TLINE);
                }
            }
%>
              <%= subtype.toString()%>

    	  </td>
    	  </tr>
<%
            }
       }
%>
    	  </tr>
	    </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
