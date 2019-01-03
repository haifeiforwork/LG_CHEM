<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.B.B05JobProfile.*" %>

<%
    Vector b05Result_vt   = (Vector)request.getAttribute("b05Result_vt");
    Vector b05Result_P_vt = (Vector)request.getAttribute("b05Result_P_vt");
    Vector b05Result_D_vt = (Vector)request.getAttribute("b05Result_D_vt");
    String i_objid        = (String)request.getAttribute("i_objid");
    String i_sobid        = (String)request.getAttribute("i_sobid");
    
    B05JobProfileData data = new B05JobProfileData();
    
    if( b05Result_vt.size() > 0 ) {
        data = (B05JobProfileData)b05Result_vt.get(0);
    }

    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    StringBuffer subtype5 = new StringBuffer();
    StringBuffer subtype6 = new StringBuffer();
    for( int i = 0 ; i < b05Result_D_vt.size() ; i++ ) {
        B05JobProfileData data_P = (B05JobProfileData)b05Result_D_vt.get(i);
        
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

function goCompetency() {
    document.form1.jobid.value = "";
    document.form1.OBJID.value = "<%= i_objid %>";  // Objective ID
    document.form1.SOBID.value = "<%= i_sobid %>";  // Job ID
    
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.B.B05JobProfile.B05CompetencyReqSV";
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
            <td class="title01">Job Profile</td>
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
	          <td class="td03" width="140">Objective</td>
	          <td class="td04" colspan="4" style="text-align:left">&nbsp;<%= data.STEXT_OBJ %></td>
      	  </tr>
	        <tr>
	          <td class="td03">Job Name</td>
	          <td class="td04" colspan="4" style="text-align:left">&nbsp;<%= data.STEXT_JOB %></td>
      	  </tr>
	        <tr>
	          <td class="td03" rowspan="<%= b05Result_P_vt.size() + 1 %>">Main<br>Job Holder</td>
	          <td class="td03" width="145">직급호칭</td>
	          <td class="td03" width="145">성명</td>
	          <td class="td03" width="230">Job Grade</td>
	          <td class="td03" width="130">현 보직 발령일</td>
	        </tr>
<%
    for( int i = 0 ; i < b05Result_P_vt.size() ; i ++ ) {
        B05JobProfileData data_P = (B05JobProfileData)b05Result_P_vt.get(i);
%>
          <tr>
	          <td class="td04"><%= data_P.TITEL %></td>
	          <td class="td04"><%= data_P.ENAME %></td>
	          <td class="td04"><%= data_P.STEXT_LEV %></td>
	          <td class="td04"><%= data_P.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data_P.BEGDA, ".") %></td>
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
        <!--상세내역 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="3" class="table02">
	        <tr>
	          <td class="td03" colspan="2">직무목적<br>(Job Objectives)</td>
	          <td class="td04" width="660" style="text-align:left"><%= subtype1.toString() %></td>
      	  </tr>
	        <tr>
	          <td class="td03" colspan="2">주요 책임<br>및 활동<br>(Main task &<br>Responsibilities)</td>
	          <td class="td04" style="text-align:left"><%= subtype2.toString() %></td>
      	  </tr>
	        <tr>
	          <td class="td03" width="80" rowspan="4" style="writing-mode:tb-rl;height:100pt">직무요건<br>(Job Requirements)</td>
	          <td class="td03" width="50">지식</td>
	          <td class="td04" style="text-align:left"><%= subtype3.toString() %></td>
      	  </tr>
	        <tr>
	          <td class="td03">스킬</td>
	          <td class="td04" style="text-align:left"><%= subtype4.toString() %></td>
      	  </tr>
	        <tr>
	          <td class="td03">경험</td>
	          <td class="td04" style="text-align:left"><%= subtype5.toString() %></td>
      	  </tr>
	        <tr>
	          <td class="td03">태도</td>
	          <td class="td04" style="text-align:left"><%= subtype6.toString() %></td>
      	  </tr>
        </table>
        <!--상세내역 테이블 끝-->
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
            <td class="td04" width="100"><a href="javascript:goCompetency();">Competency Requirements</a></td>
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
