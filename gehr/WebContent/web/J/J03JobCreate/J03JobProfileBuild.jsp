<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
//  생성 로직에서 error가 발생한 경우 다시 화면으로 돌아온다.
//  오브젝트 명, 대분류 ID
    String             STEXT         = (String)request.getAttribute("STEXT");
    String             SOBID_D       = (String)request.getAttribute("SOBID_D");
//  Job Holder
    Vector             j01Holder_vt  = (Vector)request.getAttribute("j01Holder_vt");
//  Leveling 결과 ID, TEXT
    String             SOBID_L       = (String)request.getAttribute("SOBID_L");
    String             SOBID_TEXT    = (String)request.getAttribute("SOBID_TEXT");
//  내역상세
    Vector             j03HRT1002_vt = (Vector)request.getAttribute("j03HRT1002_vt");
//  Job Leveling
    Vector             j03HRP9618_vt = (Vector)request.getAttribute("j03HRP9618_vt");

    int count   = 0;
    int count_D = 0;
    int count_L = 0;
    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    StringBuffer subtype5 = new StringBuffer();
    StringBuffer subtype6 = new StringBuffer();

    if( STEXT      == null ) { STEXT      = ""; }
    if( SOBID_D    == null ) { SOBID_D    = ""; }
    if( SOBID_L    == null ) { SOBID_L    = ""; }
    if( SOBID_TEXT == null ) { SOBID_TEXT = ""; }
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
    if( j03HRP9618_vt != null ) { count_L = j03HRP9618_vt.size(); }
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<%@ include file="J03JobMatrixMenu.jsp" %>
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

  small_window=window.open("","setJobHolder","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=400,height=380,left=100,top=100");
  small_window.focus();

  document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03JobHolderListWait.jsp?jobidPop=build";
  document.form1.target = "setJobHolder";
  document.form1.submit();
}

// Job Leveling Sheet 입력
function setJobLeveling(){
//적용일자 필수
  if( checkNull(document.form1.BEGDA_O, "적용일자를") == false ) {
    return;
  }

  small_window=window.open("","setJobLeveling","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=600,left=100,top=100");
  small_window.focus();

  document.form1.BEGDA.value = removePoint(document.form1.BEGDA_O.value);
  document.form1.action = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03LevelingSheetBuildSV";
  document.form1.target = "setJobLeveling";
  document.form1.submit();
}

// Job Profile 저장
function saveObject(){
  if( check_data() ) {
	  document.form1.jobid.value = "create";

    document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobProfileBuildSV";
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
        var beg_date = document.form1.BEGDA.value;
        var end_date = removePoint(begda_obj.value);

        diff = dayDiff(addSlash(beg_date), addSlash(end_date));
        if(diff < 0){
          ename = eval("document.form1.ENAME_S"+i+".value");
          titel = eval("document.form1.TITEL_S"+i+".value");
          begda_obj.value = document.form1.BEGDA_O.value;
          alert("Job Holder(" + ename + " " + titel + ")의 시작일을 허용된 최소일 " + document.form1.BEGDA_O.value + "일로 수정했습니다."); 
        }
      }
    }
  } else {
    alert("Main Job Holder를 지정하세요.");
    return false;
  }

//Job Leveling Sheet 입력 필수
  if( document.form1.SOBID_L.value == "" ) {
    alert("Job Leveling 결과를 입력하세요.");
    return false;
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
//-->
</script>
  
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid"      value="">                      <!-- Servlet 작업 구분 -->

  <input type="hidden" name="OBJID"      value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="OBJID_S"    value="<%= i_objid %>">        <!-- Job Holder Popup창으로 보내줄 Objectives ID -->
  <input type="hidden" name="BEGDA"      value="">
  <input type="hidden" name="SOBID"      value="<%= i_sobid %>">        <!-- 다음화면이동시 Job에 대한 정보를 보여주기 위해서 필요함 -->
  <input type="hidden" name="count"      value="<%= count   %>">        <!-- Job Holder count(초기값 = 0 : Open시 값이 없으면 에러) -->
  <input type="hidden" name="SOBID_L"    value="<%= SOBID_L %>">        <!-- Job Leveling 결과 -->
  <input type="hidden" name="SOBID_TEXT" value="<%= SOBID_TEXT %>">     <!-- Job Leveling 결과 TEXT -->
  <input type="hidden" name="count_L"    value="<%= count_L %>">        <!-- Job Leveling count(초기값 = 0 : Open시 값이 없으면 에러) -->
  <input type="hidden" name="count_D"    value="<%= count_D %>">        <!-- 내역 입력 count -->

<table cellspacing=0 cellpadding=0 border=0 width=760>
  <tr>
    <td width=14 height=26><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr>
          <td colspan=11 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job Profile 생성</td>
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
                <td width=85><input type="text" name="BEGDA_O" value="<%= WebUtil.printDate(i_begda) %>" size="10" onBlur="javascript:dateFormat(this);" onKeyDown="javascript:fn_inputCheck();"></td>
                <td><a href="javascript:fn_openCal('BEGDA_O');fn_inputCheck();"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" border=0 alt='달력보기'></td>
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
            <input type="text"   name="STEXT" value="<%= STEXT %>" size="80" maxlength="40" onKeyDown="javascript:fn_inputCheck();">
            <input type="hidden" name="SHORT" value="">
          </td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>Job ID</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=7>※ Job이 생성되면 자동으로 부여됩니다.</td>
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
<%= SOBID_D.equals("") ? WebUtil.printOption((new J03ObjectPEntryRFC()).getPEntry("2", i_objid, "")) : WebUtil.printOption((new J03ObjectPEntryRFC()).getPEntry("2", i_objid, ""), SOBID_D) %>
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
<table cellspacing=0 cellpadding=0><tr><td><input type=text name="TITEL_S<%= i %>" size=8  value="<%= data.TITEL %>" style="border:0;text-align:center"></td><td>&nbsp;<img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20 border=0></td></tr></table>
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
<table cellspacing=0 cellpadding=0><tr><td><input type=text name="ENAME_S<%= i %>" size=10 value="<%= data.ENAME %>" style="border:0;text-align:center"></td><td>&nbsp;<img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20 border=0></td></tr></table>
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
%>
<table cellspacing=0 cellpadding=0><tr><td width=85><input type=text name="BEGDA_S<%= i %>" size=10 value="<%= WebUtil.printDate(data.BEGDA) %>" onBlur="javascript:dateFormat(this);" onKeyDown="javascript:fn_inputCheck();"></td><td><a href="javascript:fn_openCal('BEGDA_S<%= i %>');fn_inputCheck();"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" width=19 height=20 border=0 alt="달력보기"></a></td></tr></table>
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
          <td class=cc align=center id="LEVELING_TEXT">
            <a href="javascript:setJobLeveling();">
<%
    if( SOBID_TEXT.equals("") ) {
%>
              <img src="<%= WebUtil.ImageURL %>jms/btn_joblevelingsheet.gif" border='0' alt='Job Leveling Sheet'>
<%
    } else {
%>
              <%= SOBID_TEXT %>
<%
    }
%>
            </a>
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
            <a href="javascript:saveObject();"><img src="<%= WebUtil.ImageURL %>jms/btn_save.gif" border=0 hspace=5 alt="저 장"></a>
            <a href="javascript:goMatrix('<%= i_pernr %>', '<%= i_objid %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_goback.gif" border=0 hspace=5 alt="이전"></a>
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
<!--      Job Leveling Sheet Popup 창에서 선택된 직무평가요소 정보를 저장한다. -->
          <td colspan=2 id="LEVELING">
<%
    if( count_L > 0 ) {
        for( int i = 0 ; i < count_L ; i++ ) {
            J03ObjectCreData data = (J03ObjectCreData)j03HRP9618_vt.get(i);
%>
<input type=hidden name="SUBTY_L<%= i %>" value="<%= data.SUBTY      %>">
<input type=hidden name="LCODE_L<%= i %>" value="<%= data.LEVEL_CODE %>">
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
