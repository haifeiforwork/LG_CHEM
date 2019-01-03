<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/web/commonProcess.jsp" %>

<%@ page import="hris.B.B05JobProfile.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector b05Result_vt   = (Vector)request.getAttribute("b05Result_vt");
    Vector b05Result_Q_vt = (Vector)request.getAttribute("b05Result_Q_vt");
    Vector b05Result_D_vt = (Vector)request.getAttribute("b05Result_D_vt");
    String i_objid        = (String)request.getAttribute("i_objid");
    String i_sobid        = (String)request.getAttribute("i_sobid");
    
    B05CompetencyReqData data = new B05CompetencyReqData();
    
    if( b05Result_vt.size() > 0 ) {
        data = (B05CompetencyReqData)b05Result_vt.get(0);
    }
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess5.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function goMatrix() {
    document.form1.jobid.value = "";
    document.form1.i_sobid.value = "<%= i_objid %>";  // Objective ID
    
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.B.B05JobProfile.B05JobMatrixSV";
    document.form1.method      = "post";
    document.form1.submit();
}

function goProfile() {
    document.form1.jobid.value = "";
    document.form1.OBJID.value = "<%= i_objid %>";  // Objective ID
    document.form1.SOBID.value = "<%= i_sobid %>";  // Job ID
    
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.B.B05JobProfile.B05JobProfileSV";
    document.form1.method      = "post";
    document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" background="<%= WebUtil.ImageURL %>left/bg_gray.gif">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td class="title01">Competency Requirements</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td width="790" align="right"> 
      <!--타이틀 테이블 시작-->
        <table width="250" border="0" cellspacing="1" cellpadding="3" class="table02">
          <tr> 
            <td class="td03" width="90">Function</td>
            <td class="td04" width="160"><%= data.STEXT_FUNC %></td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
        <!-- 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="3" class="table02">
	        <tr>
	          <td class="td03" width="130">Objective</td>
	          <td class="td04" colspan="4" style="text-align:left">&nbsp;<%= data.STEXT_OBJ %></td>
      	  </tr>
	        <tr>
	          <td class="td03">Job Name</td>
	          <td class="td04" colspan="4" style="text-align:left">&nbsp;<%= data.STEXT_JOB %></td>
      	  </tr>
        </table>
        <!-- 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
        <!-- 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="3" class="table02">
	        <tr>
	          <td class="td03" colspan="2">요구역량</td>
	          <td class="td03" width="45">요구<br>수준</td>
	          <td class="td03" width="165">Key Words</td>
	          <td class="td03" width="455">행동지표</td>
	        </tr>
<%
    String old_objid = "";
    long   l_count   = 0;
    for( int i = 0 ; i < b05Result_Q_vt.size() ; i ++ ) {
        B05CompetencyReqData data_Q = (B05CompetencyReqData)b05Result_Q_vt.get(i);
        if( !data_Q.OBJID_G.equals(old_objid) ) { 

//          자격요건 Group 명 td를 rowspan할 count를 구한다. -----------------------------
            l_count = 0;
            for( int j = 0 ; j < b05Result_Q_vt.size() ; j++ ) {
                B05CompetencyReqData data_t = (B05CompetencyReqData)b05Result_Q_vt.get(j);
                if( data_Q.OBJID_G.equals(data_t.OBJID_G) ) {
                    l_count += 1;
                }
            }
//          -----------------------------------------------------------------------------
%>
	        <tr>
	          <td class="td03" width="35" rowspan="<%= l_count %>" style="writing-mode:tb-rl"><%= data_Q.STEXT %></td>
<%
            old_objid = data_Q.OBJID_G;
        } else {
%>
	        <tr>
<%
        }
%>
	          <td class="td04" width="90"><%= data_Q.STEXT_Q %></td>
	          <td class="td04"><%= data_Q.ZLEVEL %></td>
	          <td class="td04"><%= data_Q.STEXT_KEY %></td>
<%
        StringBuffer subtype = new StringBuffer();
        for( int j = 0 ; j < b05Result_D_vt.size() ; j++ ) {
            B05CompetencyReqData data_D = (B05CompetencyReqData)b05Result_D_vt.get(j);
            if( data_Q.SOBID.equals(data_D.OBJID) ) {
                subtype.append("&nbsp;"+data_D.TLINE+"<br>");
            }
        }
%>
	          <td class="td04" style="text-align:left"><%= subtype.toString() %></td>
	        </tr>
<%
    }
%>
        </table>
        <!-- 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
        <!-- 테이블 시작-->
        <table width="200" border="0" cellspacing="1" cellpadding="3" class="table02">
	        <tr>
            <td class="td04" width="100"><a href="javascript:goMatrix();">Job Matrix</a></td>
            <td class="td04" width="100"><a href="javascript:goProfile();">Job Profile</a></td>
          </tr>
        </table>
        <!-- 테이블 끝-->
      </td>
    </tr>
  </table>

  <input type="hidden" name="jobid"   value="">
  <input type="hidden" name="OBJID"   value="">
  <input type="hidden" name="SOBID"   value="">

  <input type="hidden" name="i_sobid" value="">
</form>
<%@ include file="/web/common/web/commonEnd.jsp" %>
