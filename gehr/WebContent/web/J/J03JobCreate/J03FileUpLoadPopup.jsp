<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/popupPorcess.jsp" %> 

<%@ page import="java.io.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

//  처음 jsp 에서 받는 부분
    String jobid      = request.getParameter("jobid");
    String imgidx     = request.getParameter("IMGIDX");       //IMGIDX == 3이면 KSEA, IMGIDX == 4이면 Process
    String i_sobid    = request.getParameter("SOBID");
    String i_filename = request.getParameter("FILENAME1");
    String i_begda    = request.getParameter("BEGDA");        //Job 시작일

//  업로드 파일 존재여부 
    String e_match    = request.getParameter("e_match");    

//  생성, 수정 구분
    String jobidPop   = request.getParameter("jobidPop");

//  Job 최초 시작일
    J03JobBegdaRFC  rfc_Begda = new J03JobBegdaRFC();
    String          E_BEGDA   = rfc_Begda.getBegda( "T", i_sobid );
    
//  이전에 파일업로드 된건이 하나도 없을 경우 JOB의 최초 시작일을 적용일자로 ..    
    if ( e_match.equals("N")) {
      i_begda = E_BEGDA;
    }
  
//  File UpLoad
    J03FileUpLoadRFC rfc           = new J03FileUpLoadRFC();
    Vector           ret           = new Vector();
    Vector           j03Message_vt = new Vector();
    String           E_SUBRC       = "0";
    int              count_E       = 0;
    
    if ( jobid.equals("UpLoad")) {
        ret = rfc.UpLoad(imgidx, i_sobid, i_filename, i_begda, user.empNo);

        j03Message_vt = (Vector)ret.get(0);
        E_SUBRC       = (String)ret.get(1);

        count_E       = j03Message_vt.size();
        if( E_SUBRC.equals("0") ) {
%>
<script>
          alert("정상적으로 업로드 되었습니다.");
<%
            if( jobidPop.equals("build") ) {
                if( imgidx.equals("3") ) {
%>     
          parent.opener.goJobProcess();
<%
                } else if( imgidx.equals("4") ) {
%>
          parent.opener.goMenu('<%= i_sobid %>','5');
<%
                }
            } else if( jobidPop.equals("change") ) {
%>     
          parent.opener.goMenu('<%= i_sobid %>','<%= imgidx %>');
<%
            }
%>
          parent.self.close();
</script>
<%
        }
    }
%>
  
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!-- 
function on_Load() {
<%
    if( !jobid.equals("first") ) {
        if( !E_SUBRC.equals("0") ) {
%>
    error_window=window.open("","errorWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=480,height=380,left=100,top=100");
    error_window.focus();

    document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03ErrorWindow.jsp";
    document.form1.target = "errorWindow";
    document.form1.submit();

    parent.self.close();
<%
        }
    }
%>
}

// 달력 사용
function fn_openCal(obj){
    var lastDate;
    lastDate = eval("document.form2." + obj + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form2&fieldname="+obj+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300,left=100,top=100");
    small_window.focus();
}

function goUpLoad2(){
<%
  if ( imgidx.equals("3") ) {
%>
    document.form2.action       = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03KSEAUpLoadPopupSV";
    document.form2.method       = "post";
    document.form2.target       = "UpPopBottom";  
    document.form2.submit();
<%    
  } else if  ( imgidx.equals("4") ) {  
%>  
    document.form2.action       = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03PRCUpLoadPopupSV";
    document.form2.method       = "post";
    document.form2.target       = "UpPopBottom";  
    document.form2.submit();
<%    
   }
%>
}

function goUpLoad3() {
//2003.07.30 - 다시 J03FileUpLoadPopup.jsp를 호출하므로 e_match의 값은 'Y'로 넣어준다.
//           - 초기생성시 적용일자를 변경하여도 Job 시작일로 화일이 생성되므로 수정해준다.
  document.form1.action       = "<%= WebUtil.JspURL %>J/J03JobCreate/J03FileUpLoadPopup.jsp?e_match=Y";
  document.form1.method       = "post";
  document.form1.target       = "UpPopMain";    
  document.form1.submit();
}

function goUpLoad() {
<%
//  수정일 경우 BEGDA를 적용일자로 변경해준다.
    if( jobidPop.equals("change") ) {
%>
//적용일자 필수
  if( checkNull(document.form2.BEGDA_F, "적용일자를") == false ) {
    return;
  }
    
  document.form1.BEGDA.value = removePoint(document.form2.BEGDA_F.value);
<%
    }
%>

  if( checkNull(document.form2.FILENAME, "파일명을") == false ) {
    return;
  } else {
    var filesize = document.form2.FILENAME.value;
    if( filesize.length > 128 ) {
      alert("파일경로가 너무 깁니다.\n다시 작업해 주시기 바랍니다.");
      return;
    }

    if( !LimitAttach(document.form2.FILENAME.value) ) {
      return;
    }
  }

  document.form1.jobid.value     = "UpLoad";
  document.form1.FILENAME1.value = document.form2.FILENAME.value;

//대문자로 변환한다.
  document.form1.FILENAME1.value = document.form1.FILENAME1.value.toUpperCase();
//대문자로 변환한다.
  
  document.form1.action          = "<%= WebUtil.JspURL %>J/J03JobCreate/J03FileUpLoadHidden.jsp?wkid=<%= imgidx %>";
  document.form1.method          = "post";
  document.form1.target          = "UpPopBottom";  
  document.form1.submit();
}

extArray = new Array(".ppt");
function LimitAttach(file) {
  allowSubmit = false;
  if (!file) return;

  while (file.indexOf("\\") != -1) {
    file = file.slice(file.indexOf("\\") + 1);
  }
  ext = file.slice(file.indexOf(".")).toLowerCase();
  for (var i = 0; i < extArray.length; i++) {
    if (extArray[i] == ext) { allowSubmit = true; break; }
  }

  if (allowSubmit) {
    return true;
  } else {
    alert("\".PPT\" 형태의 파일만 업로드 할 수 있습니다.\n다시 선택하세요.");
    return false;
  }
}
//-->
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="javascript:on_Load();">
<form name="form1" method="post" action="" >
  <input type="hidden" name="jobid"     value="<%= jobid   %>">        <!-- Servlet 작업 구분 -->

  <input type="hidden" name="SOBID"     value="<%= i_sobid %>">        <!-- 다음화면이동시 Job에 대한 정보를 보여주기 위해서 필요함 -->
  <input type="hidden" name="BEGDA"     value="<%= i_begda %>">
  <input type="hidden" name="IMGIDX"    value="<%= imgidx  %>">
  <input type="hidden" name="FILENAME1" value="">  

  <input type="hidden" name="jobidPop"  value="<%= jobidPop %>">

<!-- 생성 Error시 메시지 받아서 보여주기 -->
  <input type="hidden" name="count_E"   value="<%= count_E %>">     <!-- BDC MESSAGE TEXT        -->
   
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
</form>
<form name="form2" method="post" action="" ENCTYPE="multipart/form-data">
<table width=100%>
  <tr height=20>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20></td>
  </tr>
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>
  <tr height=250>
    <td valign=top align=center>
    <br>
      <table cellpadding=0 cellspacing=0 border=0 width=470>
        <tr height=30>
          <td colspan=4 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle><%= imgidx.equals("3") ? "Job Unit별 KSEA Upload" : "Job Process Upload" %></td>
        </tr>
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=105></td>
          <td width=1></td>
          <td width=100></td>
          <td width=187></td>
          <td width=77></td>
        </tr>
        <tr>
          <td class=ct align=center>Job 시작일</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=3><%= WebUtil.printDate(E_BEGDA) %></td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
<%
    if( jobidPop.equals("change") ) {
%>
        <tr>
          <td class=ct align=center>적용일자</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=3> 
            <table cellpadding=0 cellspacing=0>
              <tr>
                <td width=85><input type="text" name="BEGDA_F" value="<%= WebUtil.printDate(i_begda) %>" size="10" onBlur="javascript:dateFormat(this);"></td>
                <td><a href="javascript:fn_openCal('BEGDA_F');"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" border=0 alt='달력보기'></td>
              </tr>
            </table> 
          </td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
<%
    }
%>
        <tr>
          <td class=ct align=center>파일</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=3>
            <input type="file" name="FILENAME" size="50">
          </td>
        </tr>       
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
        <tr height=40>
          <td colspan=5 align=center valign=bottom>
           <a href="javascript:goUpLoad();"><img src="<%= WebUtil.ImageURL %>jms/btn_attach.gif" border=0 hspace=5 alt="첨부"></a>
           <a href="javascript:parent.window.close();"><img src="<%= WebUtil.ImageURL %>jms/btn_close.gif" border=0 hspace=5 alt="닫기"></a>
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
