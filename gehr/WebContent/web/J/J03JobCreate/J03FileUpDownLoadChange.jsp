<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/popupPorcess.jsp" %> 

<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
//  DownLoad할 PPT화일명
    Vector j01Result_vt   = (Vector)request.getAttribute("j01Result_vt");
    J01ImageFileNameData data = (J01ImageFileNameData)j01Result_vt.get(0);
    
//  Job Process일경우 Job Objectives와 Position
    Vector j01Result_D_vt = (Vector)request.getAttribute("j01Result_D_vt");
    Vector j01Result_P_vt = (Vector)request.getAttribute("j01Result_P_vt");
    String e_match        = (String)request.getAttribute("e_match");
%>
  
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!-- 
//UpLoad Popup창에서 첨부 클릭시 호출된다.
function goUpLoad() {        //idx == 3이면 KSEA, idx == 4이면 Process
    document.form1.jobid.value  = "first";
  
    small_window=window.open("","FileUpLoad","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=478,height=300,left=100,top=100");
    small_window.focus();
  
    document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03FileUpLoadPopupFrame.jsp?jobidPop=change";
    document.form1.target = "FileUpLoad";
    document.form1.submit();
}  

//Job Unit별 KSEA에서 다음 버튼 클릭시
function goJobProcess() {
    document.form1.IMGIDX.value = "4";
    document.form1.action       = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03FileUpDownLoadBuildSV";
    document.form1.method       = "post";
    document.form1.target       = "J_right";
    document.form1.submit();
}

//Download시 페이지 액세스를 못하는 문제로 iframe을 사용하도록 함
function fnDownload(param) {
    frmdownload.location.href = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03FileDownLoadSV?" + param;
}
//-->
</script>
</head>
    
<%@ include file="J03JobMatrixMenu.jsp" %>

<form name="form1" method="post" action="">
  <input type="hidden" name="jobid"  value="">                      <!-- Servlet 작업 구분 -->

  <input type="hidden" name="OBJID"  value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="SOBID"  value="<%= i_sobid %>">        <!-- 다음화면이동시 Job에 대한 정보를 보여주기 위해서 필요함 -->
  <input type="hidden" name="BEGDA"  value="<%= i_begda %>">
  <input type="hidden" name="e_match"  value="<%= e_match %>">      <!-- 업로드 파일 존재여부-->
  <input type="hidden" name="IMGIDX" value="<%= i_imgidx %>">

<table cellspacing=0 cellpadding=0 border=0 width=746>
  <tr>
    <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr height=26>
          <td colspan=3 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle><%= i_imgidx.equals("3") ? "Job Unit별 KSEA 수정" : "Job Process 수정" %></td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td width=160></td>
          <td width=1></td>
          <td width=585></td>
        </tr>
        <tr>
          <td class=ct align=center>Job Name</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc><%= dStext.STEXT_JOB %></td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>Job ID</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc><%= i_sobid %></td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
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
            <table align=center>
              <tr valign=top>
                <td width=20><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=2><br>※</td>
                <td width=600>
                 기 작성된 <%= i_imgidx.equals("3") ? "KSEA" : "Job Process" %> 파일을 download받아 <%= i_imgidx.equals("3") ? "Job Unit별 KSEA" : "Job Process" %>를 수정하신 후 다시 upload해 주시기 바랍니다.<br>
                 Upload 후 인사팀으로 "적용일자"와 "Job ID"를 메일로 보내 주시면 반영해 드리도록 하겠습니다.
                </td>
              </tr>
              <tr height=40>
                <td colspan=2 align=center>
                 <a href="javascript:fnDownload('IMGIDX=<%= i_imgidx %>&SOBID=<%= i_sobid %>&OBJID=<%= i_objid %>');"><img src="<%= WebUtil.ImageURL %>jms/<%= i_imgidx.equals("3") ? "btn_KSEAdownload.gif" : "btn_processDownload.gif" %>" border=0 hspace=5 alt="<%= i_imgidx.equals("3") ? "KSEA" : "Process" %> Download"></a>
                 <a href="javascript:goUpLoad();"><img src="<%= WebUtil.ImageURL %>jms/<%= i_imgidx.equals("3") ? "btn_KSEAupload.gif" : "btn_processUpload.gif" %>" border=0 hspace=5 alt="KSEA Upload"></a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>		  
        <tr height=30 valign=bottom>
          <td colspan=3 align=center>
      	    <a href="javascript:goMenu('<%= i_sobid %>','<%= i_imgidx %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_cancel.gif" border=0 hspace=5 alt="취 소"></a>
          </td>
        </tr>
      </table>	
      <!-- 표가 닫혔습니다 -->
    </td>
  </tr>
</table>
</form>
<iframe name="frmdownload" frameborder="0" width="0" height="0"></iframe>
<%@ include file="/web/common/commonEnd.jsp" %>
