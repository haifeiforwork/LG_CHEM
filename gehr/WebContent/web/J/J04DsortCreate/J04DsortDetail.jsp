<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%
    Vector j04Result_vt = (Vector)request.getAttribute("j04Result_vt");
%>

<html>
<head>
<title>LG화학 - ESS </title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!-- 
//Objective 수정
function changeObjective(sobid) {
    job_window=window.open("","changeObjective","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=540,height=386,left=100,top=100");
    job_window.focus();

    document.form1.SOBID.value  = sobid;
    document.form1.BEGDA.value  = "<%= DataUtil.getCurrentDate() %>";

    document.form1.action = "<%= WebUtil.JspURL %>J/J04DsortCreate/J04DsortChangeObjective.jsp";
    document.form1.target = "changeObjective";
    document.form1.submit();
}

//대분류 명 수정
function changeDsort(sobid) {
    job_window=window.open("","changeDsort","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=600,height=306,left=100,top=100");
    job_window.focus();

    document.form1.SOBID.value  = sobid;
    document.form1.BEGDA.value  = "<%= DataUtil.getCurrentDate() %>";

    document.form1.action = "<%= WebUtil.JspURL %>J/J04DsortCreate/J04DsortChangeName.jsp";
    document.form1.target = "changeDsort";
    document.form1.submit();
}

//대분류 삭제
function goDelete(sobid) {
<%
//  대분류에 속해있는 과업이 하나도 없을때만 대분류를 삭제가능하도록 메시지를 띄운다.
    for( int i = 0 ; i < j04Result_vt.size() ; i++ ) {
        J01JobMatrixData data = (J01JobMatrixData)j04Result_vt.get(i);
        if( data.SCLAS.equals("T") && !data.SOBID.equals("") ) {
%>
    alert("삭제하려고 하는 대분류에 속한 Job이 있습니다.\n먼저 해당 Job에 대한 수정화면에서 대분류를 이동한 후 대분류를 삭제해 주시기 바랍니다.");
    return;
<%
        }
    }
%>
    job_window=window.open("","deleteWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=500,height=280,left=100,top=100");
    job_window.focus();

    document.form1.SOBID.value  = sobid;
    document.form1.BEGDA.value  = "<%= DataUtil.getCurrentDate() %>";

    document.form1.action = "<%= WebUtil.JspURL %>J/J04DsortCreate/J04DsortDelete.jsp";
    document.form1.target = "deleteWindow";
    document.form1.submit();
}

//-->
</script>
</head>

<%@ include file="J04DsortMenu.jsp" %>
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid"   value="">                      <!-- Servlet 작업 구분 -->

  <input type="hidden" name="OBJID"   value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="SOBID"   value="<%= i_sobid %>">        <!-- 대분류 ID -->
  <input type="hidden" name="PERNR"   value="<%= i_pernr %>">
  <input type="hidden" name="BEGDA"   value="">                      <!-- 적용일자 -->

  <input type="hidden" name="count"   value="<%= j04Result_vt.size() %>">     <!-- 삭제할 대분류와 Job List count -->

<%
//  대분류 삭제시 기간한정할 Object List
    for( int i = 0 ; i < j04Result_vt.size() ; i++ ) {
        J01JobMatrixData data = (J01JobMatrixData)j04Result_vt.get(i);
        if( i == 0 ) {
%>
  <input type="hidden" name="OTYPE_D" value="<%= data.OTYPE %>">
  <input type="hidden" name="OBJID_D" value="<%= data.OBJID %>">
  <input type="hidden" name="STEXT_D" value="<%= data.STEXT %>">
  <input type="hidden" name="SCLAS_D" value="<%= data.SCLAS %>">
  <input type="hidden" name="SOBID_D" value="<%= data.SOBID %>">
  <input type="hidden" name="BEGDA_D" value="<%= data.BEGDA %>">
<%
        }
    }
%>

<table cellspacing=0 cellpadding=0 border=0 width=760>
  <tr>
    <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr height=30>
          <td colspan=4 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>대분류 조회</td>
        </tr>
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=119></td>
          <td width=1></td>
          <td width=136></td>
          <td width=490></td>
        </tr>
        <!-- 
        실제 테이블을 사용하실때, 제목칸에는 ct클래스를 사용하시고 내용칸에는 cc클래스를 사용하세요. 
        사이사이에 width=1인 td를 삽입하세요.         
        -->
        <tr>
          <td class=ct align=center>Function</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2><%= dStext.STEXT_FUNC == null ? "" : dStext.STEXT_FUNC %></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>Objective</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc><a href="javascript:changeObjective('<%= i_sobid %>');"><%= dStext.STEXT_OBJ == null ? "" : dStext.STEXT_OBJ %></a></td>
          <td class=cc>※ 대분류를 Objective 간 이동하고자 하는 경우에는 Objective 명을 Click 하십시오.</td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
<%
    for( int i = 0 ; i < j04Result_vt.size() ; i++ ) {
        J01JobMatrixData data = (J01JobMatrixData)j04Result_vt.get(i);
        if( i == 0 ) {
%>
        <tr>
          <td class=ct align=center>대분류명</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc><a href="javascript:changeDsort('<%= i_sobid %>');"><%= data.STEXT %></a></td>
          <td class=cc>※ 대분류명을 수정하고자 하는 경우에는 대분류명을 Click 하십시오.</td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>대분류 ID</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2><%= data.OBJID %></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct rowspan="<%= (j04Result_vt.size() * 2) - 1 %>" align=center>Job</td>
          <td width=1 bgcolor=#999999 rowspan="<%= (j04Result_vt.size() * 2) - 1 %>"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
        } else {
%>
        <tr>
<%
        }
%>
          <td class=cc colspan=2><%= data.STEXT_OBJ %></td>
        </tr>
<%
        if( i != (j04Result_vt.size() - 1) ) {
%>
        <tr>
          <td colspan=2 bgcolor=#999999></td>
        </tr>
<%
        } else {
%>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
<%
        }
    }
%>
        <tr height=40>
          <td colspan=4 align=center valign=bottom>
            <a href="javascript:goDelete('<%= i_sobid %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_delCategory.gif" border=0 hspace=5 alt="대분류 삭제"></a>
            <a href="javascript:goMatrix('<%= i_pernr %>', '<%= i_objid %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_goback.gif" border=0 hspace=5 alt="이동"></a>
          </td>
        </tr>
      </table>	
      <!-- 표가 닫혔습니다 -->
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
