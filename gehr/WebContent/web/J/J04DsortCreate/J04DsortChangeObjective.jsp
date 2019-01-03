<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    WebUserData user    = (WebUserData)session.getAttribute("user");

    String      i_objid = request.getParameter("OBJID");       //Objective ID
    String      i_sobid = request.getParameter("SOBID");       //대분류 ID
    String      i_pernr = request.getParameter("PERNR");       //사원번호 - 팀원의 사번
    String      i_begda = request.getParameter("BEGDA");       //적용일자

    String      STEXT   = request.getParameter("STEXT_D");     //아래 조회페이지에서 대분류명칭을 읽어온다. - 항상 한건이상있다고 본다.

//  대분류 최초 시작일
    J03JobBegdaRFC  rfc_Begda = new J03JobBegdaRFC();
    String          E_BEGDA   = rfc_Begda.getBegda( "15", i_sobid );

//  Header Stext - Function Name, Objective Name, Job Name
    J01HeaderStextData dStext        = new J01HeaderStextData();
    J01HeaderStextRFC  rfc_Stext     = new J01HeaderStextRFC();

    Vector             j01Stext_vt   = rfc_Stext.getDetail( i_objid, i_sobid, i_pernr, i_begda );
    if( j01Stext_vt.size() > 0 ) {
        dStext = (J01HeaderStextData)j01Stext_vt.get(0);
    }
    String SOBID_F = dStext.OBJID_FUNC;
    String SOBID_O = dStext.OBJID_OBJ;

//  Function, Objectives, 대분류 List를 조회한다.
    J03ObjectPEntryRFC rfc_List         = new J03ObjectPEntryRFC();
    Vector             j03PEntryList_vt = rfc_List.getPEntry("1", "", user.empNo);

    if( SOBID_F.equals("") && !SOBID_O.equals("") ) {
        for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
            J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
            if( data_List.OBJID_O.equals(SOBID_O) ) {
                SOBID_F = data_List.OBJID_F;
            }
        }
    }

//  error message Vector 받기
    int count_E = 0;
    Vector j03Message_vt = (Vector)request.getAttribute("j03Message_vt");
    if( j03Message_vt != null ) { count_E = j03Message_vt.size(); }
%>

<html>
<head>
<title>LG화학 - ESS </title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function on_Load() {
  if( "<%= (String)request.getAttribute("i_error") %>" == "Y" ) {
    error_window=window.open("","errorWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=480,height=380,left=100,top=100");
    error_window.focus();

    document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03ErrorWindow.jsp";
    document.form1.target = "errorWindow";
    document.form1.submit();

    self.close();
  }
}

// 달력 사용
function fn_openCal(obj){
    var lastDate;
    lastDate = eval("document.form1." + obj + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+obj+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300,left=100,top=100");
    small_window.focus();
}

//항목들의 값이 변경되었는지 check한다. - 다른메뉴로 이동시 메시지를 보여주도록한다.
function fn_inputCheck() {
    document.form1.inputCheck.value = "Y";
}

//작업사항을 저장한다.
function saveObject() {
  if( document.form1.inputCheck.value != "Y" ) {
    alert("변경된 내용이 존재하지 않습니다.");
    return;
  }

  if( check_data() ) {
	  document.form1.jobid.value = "changeObjective";

    document.form1.OBJID.value = document.form1.SOBID_O.value;        //변경된 Objective ID..

    document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J04DsortCreate.J04DsortChangeSV";
    document.form1.method      = "post";
    document.form1.submit();
  } 
}

// 입력 항목 check
function check_data(){
//적용일자 필수
  if( checkNull(document.form1.BEGDA_D, "적용일자를") == false ) {
    return false;
  } else {
//  대분류 시작일 보다 이전 날짜로 적용일자를 설정할수 없다. - error 메시지를 display 한다.
    var beg_date = "<%= E_BEGDA %>";
    var end_date = removePoint(document.form1.BEGDA_D.value);

    diff = dayDiff(addSlash(beg_date), addSlash(end_date));
    if(diff < 0){
      document.form1.BEGDA_D.value = "<%= WebUtil.printDate(E_BEGDA) %>";
      alert("적용일자를 허용된 최소일 <%= WebUtil.printDate(E_BEGDA) %>일로 수정했습니다."); 
    }
  }
  document.form1.BEGDA.value = removePoint(document.form1.BEGDA_D.value);

//Function 필수
  if( document.form1.SOBID_F.selectedIndex==0 ) {
    alert("Function을 선택하세요.");
    document.form1.SOBID_F.focus();
    return false;
  }

//Objectives 필수
  if( document.form1.SOBID_O.selectedIndex==0 ) {
    alert("Objectives를 선택하세요.");
    document.form1.SOBID_O.focus();
    return false;
  }

  return true;
}

//Function List 변경시 Objectives를 변경한다.
function changeFunc(obj) {
  var val = obj[obj.selectedIndex].value;
  var inx = 1, index = 0;

  if( val == "" ) {
    document.form1.SOBID_O.length = 1;
  } else {
<%
    String Objec_ID = "";
    for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
        J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
%>
    if( val == '<%= data_List.OBJID_F %>' ) {
<%
        if( !data_List.OBJID_O.equals(Objec_ID) ) {
            Objec_ID = data_List.OBJID_O;
%>
      inx++;

      index = inx - 1;

      document.form1.SOBID_O.length = inx;
      eval("document.form1.SOBID_O["+index+"].value = '<%= data_List.OBJID_O %>';");
      eval("document.form1.SOBID_O["+index+"].text  = '<%= data_List.STEXT_O %>';");
<%
        }
%>
    }
<%
    }
%>
  }
  document.form1.SOBID_O[0].selected = true;
}

//닫기전에 변경된내용이 있는지 check한다.
function goClose() {
///////////////////////////////////////////////////////////////////////////////
    if( document.form1.inputCheck.value == "Y" ) {
        if( confirm( "변경된 내용이 존재합니다.\n저장하시겠습니까?") ){
            saveObject();
            return;
        }
    }
///////////////////////////////////////////////////////////////////////////////
    
    parent.window.close();
}
//-->
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="javascript:on_Load();">
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid"      value="">                      <!-- 작업구분 -->

  <input type="hidden" name="OBJID"      value="">                      <!-- Objective ID -->
  <input type="hidden" name="SOBID"      value="<%= i_sobid %>">        <!-- 대분류 ID -->
  <input type="hidden" name="PERNR"      value="<%= i_pernr %>">
  <input type="hidden" name="BEGDA"      value="">                      <!-- 적용일자 -->
  <input type="hidden" name="STEXT"      value="<%= STEXT %>">        <!-- 대분류 명 -->

  <input type="hidden" name="inputCheck" value="">                      <!-- 화면의 값 입력 check -->

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

<table width=540>
  <tr height=20>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20></td>
  </tr>
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>
  <tr height=340>
    <td valign=top align=center>
      <br>
      <table cellpadding=0 cellspacing=0 border=0 width=500>
        <tr height=30>
          <td colspan=4 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Objective 수정</td>
        </tr>
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=119></td>
          <td width=1></td>
          <td width=54></td>
          <td width=326></td>
        </tr>
        <tr height=25>
          <td colspan=4 bgcolor=#efefef> ※ 대분류를 Objective 간에 이동하는 화면입니다.</td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td colspan=4><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=2 height=5></td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td width=119></td>
          <td width=1></td>
          <td width=74></td>
          <td width=326></td>
        </tr>
        <tr>
          <td class=ct align=center>대분류 시작일</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2><%= WebUtil.printDate(E_BEGDA) %></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>적용일자</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2>
            <table cellpadding=0 cellspacing=0 border=0>
              <tr>
                <td width=85><input type="text" name="BEGDA_D" value="<%= WebUtil.printDate(i_begda) %>" size="10" onBlur="javascript:dateFormat(this);"></td>
                <td><a href="javascript:fn_openCal('BEGDA_D');"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" border=0 alt='달력보기'></td>
              </tr>
            </table> 
          </td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>대분류</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2><%= STEXT %></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>Function</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2>
            <select name="SOBID_F" onChange="javascript:changeFunc(this);fn_inputCheck();">
              <option value="">-------------------------------------------</option>
<%
    String Func_ID = "";
    for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
        J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
        if( !data_List.OBJID_F.equals(Func_ID) ) {
            Func_ID = data_List.OBJID_F;
%>
              <option value="<%= data_List.OBJID_F %>" <%= data_List.OBJID_F.equals(SOBID_F) ? "selected" : "" %>><%= data_List.STEXT_F %></option>
<%
        }
    }
%>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct align=center>Objective</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2> 
            <select name="SOBID_O" onChange="javascript:fn_inputCheck();">
              <option value="">-------------------------------------------</option>
<%
    Objec_ID = "";
    for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
        J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
        if( data_List.OBJID_F.equals(SOBID_F) && !data_List.OBJID_O.equals(Objec_ID) ) {
            Objec_ID = data_List.OBJID_O;
%>
              <option value="<%= data_List.OBJID_O %>" <%= data_List.OBJID_O.equals(SOBID_O) ? "selected" : "" %>><%= data_List.STEXT_O %></option>
<%
        }
    }
%>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
        <tr height="40">
          <td colspan=4>
            <table>
              <tr valign=top>
                <td><font color="#0000FF">※ 권한밖의 Objective로 이동하고자 할 경우에는 본사 인사팀으로 연락해 주시기 바랍니다.</font></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr height=40>
          <td colspan=4 align=center valign=bottom>
           <a href="javascript:saveObject();"><img src="<%= WebUtil.ImageURL %>jms/btn_save.gif" border=0 hspace=5 alt="저장"></a>
           <a href="javascript:goClose();"><img src="<%= WebUtil.ImageURL %>jms/btn_close.gif" border=0 hspace=5 alt="삭제"></a>
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
