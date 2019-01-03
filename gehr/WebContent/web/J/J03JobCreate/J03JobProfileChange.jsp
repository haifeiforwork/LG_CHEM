<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 
<%@ page import="com.sns.jdf.util.*" %> 
<%@ page import="java.util.*" %>
<%
//  생성 로직에서 error가 발생한 경우 다시 화면으로 돌아온다.
//  오브젝트 명, 대분류 ID, Leveling Grade
    String             STEXT         = (String)request.getAttribute("STEXT");
    String             SOBID_F       = (String)request.getAttribute("SOBID_F");
    String             SOBID_O       = (String)request.getAttribute("SOBID_O");
    String             SOBID_D       = (String)request.getAttribute("SOBID_D");
    String             E_STEXT_L     = (String)request.getAttribute("E_STEXT_L");
//  Job Holder
    Vector             j01Holder_vt  = (Vector)request.getAttribute("j01Holder_vt");
//  내역상세
    Vector             j03HRT1002_vt = (Vector)request.getAttribute("j03HRT1002_vt");

    int count   = 0;
    int count_D = 0;
    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    StringBuffer subtype5 = new StringBuffer();
    StringBuffer subtype6 = new StringBuffer();

    if( STEXT   == null ) { STEXT   = ""; }
    if( SOBID_F == null ) { SOBID_F = ""; }
    if( SOBID_O == null ) { SOBID_O = ""; }
    if( SOBID_D == null ) { SOBID_D = ""; }
    if( j01Holder_vt  != null ) { count   = j01Holder_vt.size(); }
    if( j03HRT1002_vt != null ) { 
        count_D = j03HRT1002_vt.size(); 
     
//      subty별 직무요건 내역을 조회한다.
        for( int i = 0 ; i < count_D ; i++ ) {  
            J03ContentsCreData data = (J03ContentsCreData)j03HRT1002_vt.get(i);
        
            if( data.SUBTY.equals("9040") ) {
                subtype1.append(data.TLINE+"\n");
            } else if( data.SUBTY.equals("9041") ) {
                subtype2.append(data.TLINE+"\n");
            } else if( data.SUBTY.equals("9042") ) {
                subtype3.append(data.TLINE+"\n");
            } else if( data.SUBTY.equals("9043") ) {
                subtype4.append(data.TLINE+"\n");
            } else if( data.SUBTY.equals("9044") ) {
                subtype5.append(data.TLINE+"\n");
            } else if( data.SUBTY.equals("9045") ) {
                subtype6.append(data.TLINE+"\n");
            }
        }
    }
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<%@ include file="J03JobMatrixMenu.jsp" %>
<%
//  Function, Objectives, 대분류 List를 조회한다.
    J03ObjectPEntryRFC rfc_List         = new J03ObjectPEntryRFC();
    Vector             j03PEntryList_vt = rfc_List.getPEntry("1", "", user.empNo);

    if( SOBID_F.equals("") && !SOBID_O.equals("") && !SOBID_D.equals("") ) {
        for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
            J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
            if( data_List.OBJID_O.equals(SOBID_O) && data_List.OBJID_D.equals(SOBID_D) ) {
                SOBID_F = data_List.OBJID_F;
            }
        }
    }
%>
<script language="JavaScript">
<!-- 
var htmlTLINE = "";           // 내역 html 생성시 사용 변수
var lineCnt   = 0;

// Main Job Holder 지정
function setJobHolder(){
//적용일자 필수
  if( checkNull(document.form1.BEGDA_O, "적용일자를") == false ) {
    return;
  }

//현재 선택된 Objectives ID를 Job Holder Popup화면에 띄운다.
  if( document.form1.SOBID_O.selectedIndex==0 ) {
    alert("Objectives를 선택하세요.");
    document.form1.SOBID_O.focus();
    return;
  }
  document.form1.OBJID_S.value = document.form1.SOBID_O[document.form1.SOBID_O.selectedIndex].value;

  small_window=window.open("","setJobHolder","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=400,height=380,left=100,top=100");
  small_window.focus();

  document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03JobHolderListWait.jsp?jobidPop=change";
  document.form1.target = "setJobHolder";
  document.form1.submit();
}

// Job Profile 저장
function saveObject(){
///////////////////////////////////////////////////////////////////////////////
  if( document.form0.inputCheck.value == "" ) {
    alert("변경된 내용이 존재하지 않습니다.");
    return;
  }
///////////////////////////////////////////////////////////////////////////////

  if( check_data() ) {
	  document.form1.jobid.value = "change";

    document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobProfileChangeSV";
    document.form1.method      = "post";
    document.form1.target      = "J_right";
    document.form1.submit();
  } 
}

// 입력 항목 check
function check_data(){
//적용일자 필수
  if( checkNull(document.form1.BEGDA_O, "적용일자를") == false ) {
    return false;
  } else {
//  Job 시작일 보다 이전 날짜로 적용일자를 설정할수 없다. - error 메시지를 display 한다.
    var beg_date = "<%= E_BEGDA %>";
    var end_date = removePoint(document.form1.BEGDA_O.value);

    diff = dayDiff(addSlash(beg_date), addSlash(end_date));
    if(diff < 0){
      document.form1.BEGDA_O.value = "<%= WebUtil.printDate(E_BEGDA) %>";
      alert("적용일자를 허용된 최소일 <%= WebUtil.printDate(E_BEGDA) %>일로 수정했습니다."); 
    }
  }
  document.form1.BEGDA.value = removePoint(document.form1.BEGDA_O.value);

//Job Name - 한글 20자, 영문 40자 내로 입력 
  x_obj = document.form1.STEXT;
  xx_value = x_obj.value;
  if( checkNull(x_obj, "Job Name을") == false ) {
    return false;
  } else {
    if( xx_value != "" && checkLength(xx_value) > 40 ){
      x_obj.value = limitKoText(xx_value, 40);
      alert("Job Name은 한글 20자, 영문 40자 이내여야 합니다.");
      x_obj.focus();
      x_obj.select();
      return false;
    } else {
//    SHORT명을 구한다. CHAR 12(한글 6자, 영문 12자)
      document.form1.SHORT.value = limitKoText(xx_value, 12);
    }
  }

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

//대분류 필수
  if( document.form1.SOBID_D.selectedIndex==0 ) {
    alert("대분류를 선택하세요.");
    document.form1.SOBID_D.focus();
    return false;
  }

//Main Job Holder 지정 필수
  var count = document.form1.count.value;
  if( count > 0 ) {
    for( var i = 0 ; i < count ; i++ ) {
      begda_obj = eval("document.form1.BEGDA_S"+i);
      if( checkNull(begda_obj, "Job 시작일을") == false ) {
        return false;
      } else {
//      Job 시작일 보다 이전 날짜로 Job Holder의 시작일을 지정할수 없다. - error 메시지를 display 한다.
        var beg_date = "<%= E_BEGDA %>";
        var end_date = removePoint(begda_obj.value);

        diff = dayDiff(addSlash(beg_date), addSlash(end_date));
        if(diff < 0){
          ename = eval("document.form1.ENAME_S"+i+".value");
          titel = eval("document.form1.TITEL_S"+i+".value");
          begda_obj.value = "<%= WebUtil.printDate(E_BEGDA) %>";
          alert("Job Holder(" + ename + " " + titel + ")의 시작일을 허용된 최소일 <%= WebUtil.printDate(E_BEGDA) %>일로 수정했습니다."); 
        }
      }
    }
  }

//변수 선언, 초기화
  var count_D = 0;
  htmlTLINE = "";
  lineCnt   = 0;
//직무목적(Job Objectives) 필수
  if( checkNull(document.form1.SUBTY_9040, "직무목적을") == false ) {
    return false;
  } else {
    count_D = CheckLen(document.form1.SUBTY_9040, "9040", 70);
  }

//주요책임 및 활동(Main task & Responsibilites) 필수
  if( checkNull(document.form1.SUBTY_9041, "주요책임 및 활동을") == false ) {
    return false;
  } else {
    count_D = CheckLen(document.form1.SUBTY_9041, "9041", 70);
  }

//직무요건(Job Requirements) - 지식 필수
  if( checkNull(document.form1.SUBTY_9042, "직무요건의 지식을") == false ) {
    return false;
  } else {
    count_D = CheckLen(document.form1.SUBTY_9042, "9042", 70);
  }

//직무요건(Job Requirements) - 스킬 필수
  if( checkNull(document.form1.SUBTY_9043, "직무요건의 스킬을") == false ) {
    return false;
  } else {
    count_D = CheckLen(document.form1.SUBTY_9043, "9043", 70);
  }

//직무요건(Job Requirements) - 경험 필수
  if( checkNull(document.form1.SUBTY_9044, "직무요건의 경험을") == false ) {
    return false;
  } else {
    count_D = CheckLen(document.form1.SUBTY_9044, "9044", 70);
  }

//직무요건(Job Requirements) - 태도 필수
  if( checkNull(document.form1.SUBTY_9045, "직무요건의 태도를") == false ) {
    return false;
  } else {
    count_D = CheckLen(document.form1.SUBTY_9045, "9045", 70);
  }

  document.form1.count_D.value = count_D;

//Job 시작일의 comma를 remove한다.
  for( var i = 0 ; i < count ; i++ ) {
    eval("document.form1.BEGDA_S"+i+".value = removePoint(document.form1.BEGDA_S"+i+".value);");
  }

  return true;
}

//TextArea의 입력정보를 길이만큼 끊어준다.
function CheckLen(str, subty, str1){
  var seqno = 0;
  var temp,memocount,len,allstr,onestr;
  memocount = 0;
	
  len = str.value.length;
  allstr = "";
	
  for( var i = 0 ; i < len ; i++ ){
    temp = str.value.charAt(i);
    if(str.value.charCodeAt(i) == 13) {
      if( allstr != "" ) {
        seqno     += 1;
        htmlTLINE += "<input type=hidden name='SUBTY_D"+lineCnt+"' value='" + subty + "'>"
                  +  "<input type=hidden name='SEQNO_D"+lineCnt+"' value='" + seqno + "'>"
                  +  "<input type=hidden name='TLINE_D"+lineCnt+"' value='" + allstr + "'>";

        lineCnt   += 1;
      }
      memocount = 0;
      allstr    = "";
    } else if(str.value.charCodeAt(i) == 10) {
//    10인경우는 제외시킨다. - new Line(??)
    } else {
      if(escape(temp).length > 4)
        memocount += 2;
      else
        memocount++;
				
      if ( memocount >= str1) {
        allstr  += temp;
        if( allstr != "" ) {
          seqno     += 1;
          htmlTLINE += "<input type=hidden name='SUBTY_D"+lineCnt+"' value='" + subty + "'>"
                    +  "<input type=hidden name='SEQNO_D"+lineCnt+"' value='" + seqno + "'>"
                    +  "<input type=hidden name='TLINE_D"+lineCnt+"' value='" + allstr + "'>";

          lineCnt   += 1;
        }
        memocount = 0;
        allstr    = "";
      } else {
        allstr += temp;
      }			
    }
  }
//Enter로 끝나지 않았을경우 마지막 내역을 추가한다.
  if( allstr != "" ) {
    seqno     += 1;
    htmlTLINE += "<input type=hidden name='SUBTY_D"+lineCnt+"' value='" + subty + "'>"
              +  "<input type=hidden name='SEQNO_D"+lineCnt+"' value='" + seqno + "'>"
              +  "<input type=hidden name='TLINE_D"+lineCnt+"' value='" + allstr + "'>";

    lineCnt   += 1;
  }

  TLINE1002.innerHTML = htmlTLINE;

  return lineCnt;
}

//Function List 변경시 Objectives를 변경한다.
function changeFunc(obj) {
  var val = obj[obj.selectedIndex].value;
  var inx = 1, index = 0;

//대분류 List를 clear한다.
  document.form1.SOBID_D.length = 1;
  document.form1.SOBID_D[0].selected = true;

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

//Objectives List 변경시 대분류를 변경한다.
function changeObjec(obj) {
  var val = obj[obj.selectedIndex].value;
  var inx = 1, index = 0;

  if( val == "" ) {
    document.form1.SOBID_D.length = 1;
  } else {
<%
    String Dsort_ID = "";
    for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
        J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
%>
    if( val == '<%= data_List.OBJID_O %>' ) {
<%
        if( !data_List.OBJID_D.equals(Dsort_ID) ) {
            Dsort_ID = data_List.OBJID_D;
%>
      inx++;

      index = inx - 1;

      document.form1.SOBID_D.length = inx;
      eval("document.form1.SOBID_D["+index+"].value = '<%= data_List.OBJID_D %>';");
      eval("document.form1.SOBID_D["+index+"].text  = '<%= data_List.STEXT_D %>';");
<%
        }
%>
    }
<%
    }
%>
  }
  document.form1.SOBID_D[0].selected = true;
}

//Function, Objectives가 변경되면 Job Holder를 비워준다.
function changeHolder() {
  var htmlINFO = "";

  if( document.form1.count.value > 0 ) {
    if( document.form1.BEGDA_S0.value == "0000.00.00" ) {
//    메시지를 보여주지 않는다.
    } else {
      alert("Job Holder 지정이 삭제 되었습니다.\nJob Holder를 재지정해 주시기 바랍니다.");

      TITEL_S.innerHTML = "";
      ENAME_S.innerHTML = "";
      BEGDA_S.innerHTML = "";

      htmlINFO += "<input type=hidden name='BEGDA_S0' value='0000.00.00'>"
               +  "<input type=hidden name='SOBID_S0' value=''>";
      INFO_S.innerHTML = htmlINFO;

      document.form1.count.value = 1;
    }
  }
}
//-->
</script>
  
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid"       value="">                      <!-- Servlet 작업 구분 -->

  <input type="hidden" name="OBJID"       value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="OBJID_S"     value="">                      <!-- Job Holder Popup창으로 보내줄 Objectives ID -->
  <input type="hidden" name="BEGDA"       value="">
  <input type="hidden" name="SOBID"       value="<%= i_sobid %>">        <!-- 다음화면이동시 Job에 대한 정보를 보여주기 위해서 필요함 -->
  <input type="hidden" name="count"       value="<%= count   %>">        <!-- Job Holder count(초기값 = 0 : Open시 값이 없으면 에러) -->
  <input type="hidden" name="count_D"     value="<%= count_D %>">        <!-- 내역 입력 count -->

<!-- Leveling 수정으로 이동시 전 페이지를 check하기위해서 필요 -->
  <input type="hidden" name="backFromJSP" value="">

<table cellspacing=0 cellpadding=0 border=0 width=760>
  <tr>
    <td width=14 height=26><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr>
          <td colspan=11 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job Profile 수정</td>
        </tr>
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=80></td>
          <td width=1></td>
          <td width=90></td>
          <td width=1></td>
          <td width=113></td>
          <td width=1></td>
          <td width=133></td>
          <td width=1></td>
          <td width=183></td>
          <td width=1></td>
          <td width=142></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>적용일자</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=7> 
            <table cellpadding=0 cellspacing=0 border=0>
              <tr>
                <td width=85><input type="text" name="BEGDA_O" value="<%= WebUtil.printDate(i_begda) %>" size="10" onBlur="javascript:dateFormat(this);"></td>
                <td><a href="javascript:fn_openCal('BEGDA_O');"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" border=0 alt='달력보기'></td>
              </tr>
            </table> 
          </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>Job Name</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=7>
            <input type="text"   name="STEXT" value="<%= STEXT.equals("") ? dStext.STEXT_JOB : STEXT %>" size="80" maxlength="40" onKeyDown="javascript:fn_inputCheck();">
            <input type="hidden" name="SHORT" value="">
          </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>Job ID</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=7><%= i_sobid %></td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>Function</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=7> 
            <select name="SOBID_F" onChange="javascript:changeFunc(this);fn_inputCheck();changeHolder();">
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
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>Objectives</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=7> 
            <select name="SOBID_O" onChange="javascript:changeObjec(this);fn_inputCheck();changeHolder();">
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
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>대분류</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=7> 
            <select name="SOBID_D" onChange="javascript:fn_inputCheck();">
              <option value="">-------------------------------------------</option>
<%
    Dsort_ID = "";
    for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
        J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
        if( data_List.OBJID_F.equals(SOBID_F) && data_List.OBJID_O.equals(SOBID_O) && !data_List.OBJID_D.equals(Dsort_ID) ) {
            Dsort_ID = data_List.OBJID_D;
%>
              <option value="<%= data_List.OBJID_D %>" <%= data_List.OBJID_D.equals(SOBID_D) ? "selected" : "" %>><%= data_List.STEXT_D %></option>
<%
        }
    }
%>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr height=30>
          <td colspan=11 class=cc>
           <img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=2 height=2><br>
           <a href="javascript:setJobHolder();"><img src="<%= WebUtil.ImageURL %>jms/btn_jobholder.gif" border='0'></a> 
          </td>
        </tr>
        <tr height=2>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr align=center>
          <td class=ct colspan=3 rowspan="3">Main<br>Job Holder</td>
          <td width=1 bgcolor=#999999 rowspan="3"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1>직위&nbsp;</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1>성명&nbsp;</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1>Job 시작일</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1> Job Grade </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=cc align=center id="TITEL_S">
<%
    if( count > 0 ) {
        for( int i = 0 ; i < count ; i++ ) {
            J01PersonsData data = (J01PersonsData)j01Holder_vt.get(i);
%>
<table height=22 cellspacing=0 cellpadding=0><tr><td conspan=2><input type=<%= data.TITEL.equals("") ? "hidden" : "text" %> name="TITEL_S<%= i %>" size=8  value="<%= data.TITEL %>" style="border:0;text-align:center"></td></tr></table>
<%
        }
    } else {
%>
            &nbsp;
<%
    }
%>
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align=center id="ENAME_S">
<%
    if( count > 0 ) {
        for( int i = 0 ; i < count ; i++ ) {
            J01PersonsData data = (J01PersonsData)j01Holder_vt.get(i);
%>
<table height=22 cellspacing=0 cellpadding=0><tr><td conspan=2><input type=<%= data.ENAME.equals("") ? "hidden" : "text" %> name="ENAME_S<%= i %>" size=10 value="<%= data.ENAME %>" style="border:0;text-align:center"></td></tr></table>
<%
        }
    } else {
%>
            &nbsp;
<%
    }
%>
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align=center id="BEGDA_S">
<%
    if( count > 0 ) {
        for( int i = 0 ; i < count ; i++ ) {
            J01PersonsData data = (J01PersonsData)j01Holder_vt.get(i);
            if( data.BEGDA.equals("00000000") ) {
%>
<table height=22 cellspacing=0 cellpadding=0><tr><td width=85><input type=hidden name="BEGDA_S<%= i %>" size=10 value="<%= WebUtil.printDate(data.BEGDA) %>" onBlur="javascript:dateFormat(this);" onKeyDown="javascript:fn_inputCheck();"></td><td>&nbsp;</td></tr></table>
<%
            } else {
%>
<table height=22 cellspacing=0 cellpadding=0><tr><td width=85><input type=text   name="BEGDA_S<%= i %>" size=10 value="<%= WebUtil.printDate(data.BEGDA) %>" onBlur="javascript:dateFormat(this);" onKeyDown="javascript:fn_inputCheck();"></td><td><a href="javascript:fn_openCal('BEGDA_S<%= i %>');fn_inputCheck();"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" width=19 height=20 border=0 alt="달력보기"></a></td></tr></table>
<%
            }
        }
    } else {
%>
            &nbsp;
<%
    }
%>
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align=center>
            <a href="javascript:goLeveling('<%= i_sobid %>', 'JobProfile');"><%= E_STEXT_L %></a>
            <input type=hidden name="E_STEXT_L" value="<%= E_STEXT_L %>">
          </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr> 
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=11 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->	  
        <tr height=2>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>직무목적<br>(Job Objectives)</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=8 class=cc>
            <textarea name="SUBTY_9040" wrap="VIRTUAL" cols=115 rows=3 onKeyDown="javascript:fn_inputCheck();"><%= subtype1.toString() %></textarea>
          </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>		  
        <tr>
          <td class=ct colspan=3 align=center>주요책임 및 활동<br>(Main task & Responsibilites)</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=8 class=cc>
            <textarea name="SUBTY_9041" wrap="VIRTUAL" cols=115 rows=3 onKeyDown="javascript:fn_inputCheck();"><%= subtype2.toString() %></textarea>
          </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>		  
        <tr>
          <td class=ct rowspan=7 align=center style="writing-mode:tb-rl">직무요건<br>(Job Requirements)</td>
          <td width=1 bgcolor=#999999 rowspan=7><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td align="center" class=ct1>지식</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=8 class=cc>
            <textarea name="SUBTY_9042" wrap="VIRTUAL" cols=115 rows=2 onKeyDown="javascript:fn_inputCheck();"><%= subtype3.toString() %></textarea>
          </td>
        </tr>
        <tr>
          <td colspan=10 bgcolor=#999999></td>
        </tr>
        <tr>
          <td align="center" class=ct1>스킬</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=8 class=cc>
            <textarea name="SUBTY_9043" wrap="VIRTUAL" cols=115 rows=2 onKeyDown="javascript:fn_inputCheck();"><%= subtype4.toString() %></textarea>
          </td>
        </tr>
        <tr>
          <td colspan=10 bgcolor=#999999></td>
        </tr>
        <tr>
          <td align="center" class=ct1>경험</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=8 class=cc>
            <textarea name="SUBTY_9044" wrap="VIRTUAL" cols=115 rows=2 onKeyDown="javascript:fn_inputCheck();"><%= subtype5.toString() %></textarea>
          </td>
        </tr>
        <tr>
          <td colspan=10 bgcolor=#999999></td>
        </tr>
        <tr>
          <td align="center" class=ct1>태도</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=8 class=cc>
            <textarea name="SUBTY_9045" wrap="VIRTUAL" cols=115 rows=2 onKeyDown="javascript:fn_inputCheck();"><%= subtype6.toString() %></textarea>
          </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr height=30 valign=bottom>
          <td colspan=11 align=center>
           <a href="javascript:saveObject();"><img src="<%= WebUtil.ImageURL %>jms/btn_save.gif" border=0 hspace=5 alt="저장"></a>
           <a href="javascript:goMenu('<%= i_sobid %>','1');"><img src="<%= WebUtil.ImageURL %>jms/btn_cancel.gif" border=0 hspace=5 alt="취소"></a>
          </td>
        </tr>
<!------------------------------------------------------------------------------>
        <tr height=1>
<!--      내역 정보를 저장한다. -->
          <td colspan=6 id="TLINE1002">
<%
    if( count_D > 0 ) {
        for( int i = 0 ; i < count_D ; i++ ) {
            J03ContentsCreData data = (J03ContentsCreData)j03HRT1002_vt.get(i);
%>
<input type=hidden name="SUBTY_D<%= i %>" value="<%= data.SUBTY %>">
<input type=hidden name="SEQNO_D<%= i %>" value="<%= data.SEQNO %>">
<input type=hidden name="TLINE_D<%= i %>" value="<%= data.TLINE %>">
<%
        }
    }
%>
          </td>
<!--      Job Holder Popup 창에서 선택된 position 정보를 저장한다. -->
          <td colspan=3 id="INFO_S">
<%
    if( count > 0 ) {
        for( int i = 0 ; i < count ; i++ ) {
            J01PersonsData data = (J01PersonsData)j01Holder_vt.get(i);
%>
<input type=hidden name="PERNR_S<%= i %>" value="<%= data.PERNR %>">
<input type=hidden name="SOBID_S<%= i %>" value="<%= data.OBJID %>">
<%
        }
    }
%>
          </td>
        </tr>
<!------------------------------------------------------------------------------>
      </table>
      <!-- 표가 닫혔습니다 -->
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
