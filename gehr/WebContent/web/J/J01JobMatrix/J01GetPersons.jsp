<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    Vector j01Persons_vt = (Vector)request.getAttribute("j01Persons_vt");
    String i_objid       = (String)request.getAttribute("i_objid");
    String gubun         = (String)request.getAttribute("gubun");
    String i_begda       = (String)request.getAttribute("i_begda");    
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
//onLoad시마다 Matrix 정보를 보여준다. - 해당팀원이 없어도 기본정보를 보여준다.
function on_Load() {
    document.form1.i_pernr.value = "00000000";
    document.form1.i_sobid.value = "<%= i_objid %>";
    document.form1.BEGDA.value   = "<%= i_begda %>";

<%
    if( gubun.equals("R") ) {
%>
    document.form1.action        = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01JobMatrixSV";
<%
    } else if( gubun.equals("C") ) {
%>
    document.form1.action        = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobMatrixSV";
<%
    } 
%>
    document.form1.method        = "post";
    document.form1.target        = "J_right";
    document.form1.submit();
}

function goMatrix(pernr, objid) {
    document.form1.i_pernr.value = pernr;               //사번
    document.form1.i_sobid.value = objid;               //Objective ID
    document.form1.BEGDA.value   = "<%= i_begda %>";    //적용일자

<%
    if( gubun.equals("R") ) {
%>
    document.form1.action        = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01JobMatrixSV";
<%
    } else if( gubun.equals("C") ) {
%>
    document.form1.action        = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobMatrixSV";
<%
    } 
%>
    document.form1.method        = "post";
    document.form1.target        = "J_right";
    document.form1.submit();
}
//-->
</script>
</head>

<body text="#000000" leftmargin="8" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:on_Load();">
<form name="form1" method="post" action="">
  <input type="hidden" name="i_pernr" value="">
  <input type="hidden" name="i_sobid" value="">
  <input type="hidden" name="BEGDA"   value="">    

  <table width="228" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="1" bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="1"></td>
      <td width="227" valign="top" background="<%= WebUtil.ImageURL %>jms/GetPersonsbg.gif">
        <!--Job Matrix 리스트 테이블 Header 시작-->
        <table width="227" border="0" cellspacing="0" cellpadding="0">
          <tr height=1>
            <td bgcolor="#999999" colspan="5"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="1"></td>
          </tr>
          <tr height=28 align=center class=tt1 bgcolor=#ffffff>
            <td class="td03" width="58">사번</td>
            <td class="td03" width="49">성명</td>
            <td class="td03" width="60">부서</td>
            <td class="td03" width="43">직위</td>
            <td class="td03" width="17">&nbsp;</td>
          </tr>
          <tr height="1">
            <td colspan="5" background="<%= WebUtil.ImageURL %>jms/dotlinebg.gif"></td>
          </tr>
        </table>
        <!--Job Matrix 리스트 테이블 Header 끝-->
        <span style="height: 182px; width: 227px; overflow:auto;">
          <html>
            <!--Job Matrix 리스트 테이블 시작-->
            <table width="210" border="0" cellspacing="0" cellpadding="0">
<%
    if( j01Persons_vt.size() > 0 ) {
        for( int i = 0 ; i < j01Persons_vt.size() ; i++ ) {
            J01PersonsData data = (J01PersonsData)j01Persons_vt.get(i);
%>
    	        <tr height=23 align=center valign=top class=c01>
    	          <td class="bas" width="58"><a href="javascript:goMatrix('<%= data.PERNR %>', '<%= data.OBJID %>');" class="bas"><%= data.PERNR %></a></td>
                <td class="bas" width="49"><a href="javascript:goMatrix('<%= data.PERNR %>', '<%= data.OBJID %>');" class="bas"><%= data.ENAME %></a></td>
                <td class="bas" width="60"><a href="javascript:goMatrix('<%= data.PERNR %>', '<%= data.OBJID %>');" class="bas"><%= data.ORGTX %></a></td>
                <td class="bas" width="43"><a href="javascript:goMatrix('<%= data.PERNR %>', '<%= data.OBJID %>');" class="bas"><%= data.TITEL %></a></td>
    	        </tr>
<%
        }
    } else {
%>
    	        <tr height=23 align=center valign=top class=c01>
    	          <td class="bas" colspan="4">해당하는 팀원이 존재하지 않습니다.</td>
    	        </tr>
<%
    } 
%>
            </table>
            <!--Job Matrix 리스트 테이블 끝-->
          </html>
        </span>
      </td>
    </tr>
	  <tr height=4>
	    <td colspan=3><img src="<%= WebUtil.ImageURL %>jms/maintoplinebg02.gif"></td>
	  </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
