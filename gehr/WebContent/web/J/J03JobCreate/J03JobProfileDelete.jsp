<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    String jobid   = request.getParameter("jobid");
    if( jobid == null || jobid.equals("") ) { jobid = "first"; }
//  Objective ID, Job ID
    String i_objid = request.getParameter("OBJID");
    String i_sobid = request.getParameter("SOBID");
//  사원번호 - 팀원의 사번
    String i_pernr = request.getParameter("PERNR");
//  Job 최초 시작일
    J03JobBegdaRFC  rfc_Begda = new J03JobBegdaRFC();
    String          E_BEGDA   = rfc_Begda.getBegda( "T", i_sobid );

    String i_begda = request.getParameter("BEGDA");       //적용일자
//  Header Stext - Function Name, Objective Name, Job Name
    J01HeaderStextData dStext        = new J01HeaderStextData();
    J01HeaderStextRFC  rfc_Stext     = new J01HeaderStextRFC();
    Vector             j01Stext_vt   = rfc_Stext.getDetail( i_objid, i_sobid, user.empNo, i_begda );
    if( j01Stext_vt.size() > 0 ) {
        dStext = (J01HeaderStextData)j01Stext_vt.get(0);
    }
//  Job 삭제를 펑션을 실행시킨다.
    J03CUDDeleteObjectsRFC rfc           = new J03CUDDeleteObjectsRFC();
    Vector                 ret           = new Vector();
    Vector                 j03Message_vt = new Vector();
    String                 E_SUBRC       = "0";
    int                    count_E       = 0;
      
    if( !jobid.equals("first") ) {
        ret           = rfc.Delete( "T", i_sobid, i_begda, user.empNo );

        j03Message_vt = (Vector)ret.get(0);
        E_SUBRC       = (String)ret.get(1);
        if( j03Message_vt != null ) { count_E = j03Message_vt.size(); }
    }
%>

<html>
<head>
<title>LG화학 - ESS </title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!-- 
function on_Load() {
<%
    if( !jobid.equals("first") ) {
        if( !E_SUBRC.equals("0") && count_E > 0 ) {
%>
    error_window=window.open("","errorWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=480,height=380,left=100,top=100");
    error_window.focus();

    document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03ErrorWindow.jsp";
    document.form1.target = "errorWindow";
    document.form1.submit();

    self.close();
<%
        } else {
%>
    alert("해당 Job이 삭제되었습니다.");
//  Matrix 조회화면으로 이동한다.
    parent.opener.goMatrix('<%= i_pernr %>', '<%= i_objid %>');
    self.close();
<%
        }
    }
%>
}

// 달력 사용
function fn_openCal(obj){
    var lastDate;
    lastDate = eval("document.form1." + obj + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+obj+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300,left=100,top=100");
    small_window.focus();
}

// Job 삭제
function goDelete() {
  if( checkNull(document.form1.BEGDA_D, "적용일자를") == false ) {
    return;
  } else {
//  한계결정 시 Job 시작일 보다 이전 날짜로 한계결정이 되는 경우에는 다음의 error 메시지를 display 한다.
    var beg_date = "<%= E_BEGDA %>";
    var end_date = removePoint(document.form1.BEGDA_D.value);

    diff = dayDiff(addSlash(beg_date), addSlash(end_date));
    if(diff < 0){
      alert("Job 시작일의 이전 날짜로 한계결정이 될 수는 없습니다.\n인사담당자에게 문의하여 처리하시기 바랍니다."); 
      return;
    }
  } 

  document.form1.jobid.value = "delete";
  document.form1.BEGDA.value = removePoint(document.form1.BEGDA_D.value);

  if( confirm("Job과 관련된 모든 데이터가 삭제됩니다.\n삭제하시겠습니까?") ){
    document.form1.action      = "<%= WebUtil.JspURL %>J/J03JobCreate/J03JobProfileDelete.jsp";    
    document.form1.method      = "post";
    document.form1.submit();
  }
}
//-->
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="javascript:on_Load();">
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="OBJID" value="<%= i_objid %>">
  <input type="hidden" name="SOBID" value="<%= i_sobid %>">
  <input type="hidden" name="PERNR" value="<%= i_pernr %>">
  <input type="hidden" name="BEGDA" value="">

<!-- 생성 Error시 메시지 받아서 보여주기 -->
  <input type="hidden" name="count_E" value="<%= count_E %>">     <!-- BDC MESSAGE TEXT        -->
<%
    for( int i = 0 ; i < count_E ; i++ ) {
        J03MessageData errData = (J03MessageData)j03Message_vt.get(i);
%>
  <input type="hidden" name="MSGSPRA<%= i %>" value="<%= errData.MSGSPRA %>">     <!-- 메세지 언어 ID          -->
  <input type="hidden" name="MSGID<%= i %>"   value="<%= errData.MSGID   %>">     <!-- Batch 입력 메세지 ID    -->
  <input type="hidden" name="MSGNR<%= i %>"   value="<%= errData.MSGNR   %>">     <!-- Batch 입력 메세지번호   -->
  <input type="hidden" name="MSGTEXT<%= i %>" value="<%= errData.MSGTEXT %>">     <!-- BDC MESSAGE TEXT        -->
<%
    }
%>

<table width=100%>
  <tr height=20>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20></td>
  </tr>
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>
  <tr height=232>
    <td valign=top align=center>
     <br>
      <table cellpadding=0 cellspacing=0 border=0 width=460>
        <tr height=30>
          <td colspan=4 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job 삭제</td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td width=119></td>
          <td width=1></td>
          <td width=74></td>
          <td width=326></td>
        </tr>
        <tr>
          <td class=ct align=center>Job 시작일</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2><%= WebUtil.printDate(E_BEGDA) %></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>적용일자</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc><input type=text name="BEGDA_D" size=10 class=formset1 value="<%= WebUtil.printDate(i_begda) %>" onBlur="javascript:dateFormat(this);"></td>
          <td><a href="javascript:fn_openCal('BEGDA_D');"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" border=0 alt="달력보기"></a></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>Job 명</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2><%= dStext.STEXT_JOB %></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr height=40>
          <td colspan=4 align=center valign=bottom>
           <a href="javascript:goDelete();"><img src="<%= WebUtil.ImageURL %>jms/btn_delete.gif" border=0 hspace=5 alt="삭 제"></a>
           <a href="javascript:parent.window.close();"><img src="<%= WebUtil.ImageURL %>jms/btn_close.gif" border=0 hspace=5 alt="닫 기"></a>
          </td>
        </tr>
      </table>	
     <br>	
    </td>
  </tr>  
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>  
  <tr height=10>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=10></td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
