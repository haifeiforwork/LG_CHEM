<%@ page contentType="text/html; charset=utf-8" %>  
<%@ include file="/web/common/popupPorcess.jsp" %>
 
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %>     
<%@ page import="java.util.*" %>
<% 
//  Job Leveling Sheet 정보
    Vector             j01Result_vt    = (Vector)request.getAttribute("j01Result_vt");
    Vector             j01Result_D_vt  = (Vector)request.getAttribute("j01Result_D_vt");
    Vector             j01Result_L_vt  = (Vector)request.getAttribute("j01Result_L_vt");
//  Job Leveling 결과
    String             E_LEVEL         = (String)request.getAttribute("E_LEVEL");
//  Job Leveling 결과- ID
    String             SOBID_L         = (String)request.getAttribute("SOBID_L");
//  Job Leveling 결과 점수관리
    Vector             j01LevelList_vt = (Vector)request.getAttribute("j01LevelList_vt");

    int count_L = 0;
    if( j01Result_vt != null ) { count_L = j01Result_vt.size(); }

    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    StringBuffer subtype5 = new StringBuffer();
    StringBuffer subtype6 = new StringBuffer();
    for( int i = 0 ; i < j01Result_D_vt.size() ; i++ ) {
        J01LevelingSheetData data_P = (J01LevelingSheetData)j01Result_D_vt.get(i);
        
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
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>
    
<%@ include file="J03JobMatrixMenu.jsp" %>

<script language="JavaScript">
<!-- 
function setResult() {
  var max_inx = 0;
  var sum     = 0;
  var chk_ok  = "";

  for( var i = 0 ; i < <%= j01Result_vt.size() %> ; i ++ ) {
    max_inx = eval("document.form1.R"+i+".length");
    chk_ok = "";
    for( var j = 0 ; j < max_inx ; j++ ) {
      if( eval("document.form1.R"+i+"["+j+"].checked") ) {
//      radio button의 value를 더한다.
        sum += Number(eval("document.form1.R"+i+"["+j+"].value"));
        eval("document.form1.LEVEL_CODE"+i+".value = document.form1.R_CODE"+i+"["+j+"].value");
        chk_ok = "Y";
        break;
      }
    }
//  check되지 않은 것이 있으면 for loop를 빠져나온다.
    if( chk_ok != "Y" ) {
      break;
    }
  }

//radio button이 모두 check되었으면 leveling 결과를 변경한다.
  if( chk_ok == "Y" ) {
<%
    for( int i = 0 ; i < j01LevelList_vt.size() ; i++ ) {
        J01LevelListData data_List = (J01LevelListData)j01LevelList_vt.get(i);
%>
    if( sum >= <%= data_List.MIN_VALUE %> && sum <= <%= data_List.MAX_VALUE %> ) {
        document.form1.inputChk.value     = chk_ok;
        document.form1.levelList.disabled = 0;
        eval("document.form1.levelList["+<%= i + 1 %>+"].selected = 'true';");
    }
<%
    }
%>
  }
}

//Job Unit별 KSEA에서 다음 버튼 클릭시
function saveObject() {
///////////////////////////////////////////////////////////////////////////////
  if( document.form0.inputCheck.value == "" ) {
    alert("변경된 내용이 존재하지 않습니다.");
    return;
  }
///////////////////////////////////////////////////////////////////////////////

//적용일자 필수
  if( checkNull(document.form1.BEGDA_L, "적용일자를") == false ) {
    return;
  } else {
//  Job 시작일 보다 이전 날짜로 적용일자를 설정할수 없다. - error 메시지를 display 한다.
    var beg_date = "<%= E_BEGDA %>";
    var end_date = removePoint(document.form1.BEGDA_L.value);

    diff = dayDiff(addSlash(beg_date), addSlash(end_date));
    if(diff < 0){
      document.form1.BEGDA_L.value = "<%= WebUtil.printDate(E_BEGDA) %>";
      alert("적용일자를 허용된 최소일 <%= WebUtil.printDate(E_BEGDA) %>일로 수정했습니다."); 
    }
  }

  if( document.form1.inputChk.value == "" ) {
    alert("모든 직무평가요소에 대하여 Grade를 선택해야 합니다.");
    return;
  }
  if( document.form1.levelList.selectedIndex == 0 ) {
    alert("Job Leveling 결과를 선택하세요.");
    return;
  }

  document.form1.jobid.value   = "change";
  document.form1.SOBID_L.value = document.form1.levelList.value;
  document.form1.BEGDA.value   = removePoint(document.form1.BEGDA_L.value);

  document.form1.action        = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03LevelingSheetChangeSV";
  document.form1.method        = "post";
  document.form1.target        = "J_right";
  document.form1.submit();
}
//-->
</script>

<form name="form1" method="post" action="">
  <input type="hidden" name="jobid"       value="">                      <!-- Servlet 작업 구분 -->

  <input type="hidden" name="OBJID"       value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="BEGDA"       value="<%= i_begda %>">        <!-- Job 시작일 -->
  <input type="hidden" name="SOBID"       value="<%= i_sobid %>">        <!-- 다음화면이동시 Job에 대한 정보를 보여주기 위해서 필요함 -->
  <input type="hidden" name="IMGIDX"      value="<%= i_imgidx %>">
  <input type="hidden" name="SOBID_L"     value="">                      <!-- Job Leveling 결과 -->
  <input type="hidden" name="count_L"     value="<%= count_L %>">        <!-- Job Leveling count(초기값 = 0 : Open시 값이 없으면 에러) -->

<!-- Leveling 수정으로 이동시 전 페이지를 check하기위해서 필요 -->
  <input type="hidden" name="backFromJSP" value="<%= backFromJSP %>">

  <input type="hidden" name="inputChk"    value="<%= E_LEVEL.equals("") ? "" : "Y" %>">                     <!-- Job Leveling 입력 여부 -->

<table cellspacing=0 cellpadding=0 border=0 width=746>
  <tr>
    <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr height=26>
          <td colspan=3 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job Leveling Sheet 수정</td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td width=29></td>
          <td width=1></td>
          <td width=145></td>
          <td width=1></td>
          <td width=305></td>
          <td width=1></td>
          <td width=60></td>
          <td width=1></td>
          <td width=60></td>
          <td width=1></td>
          <td width=60></td>
          <td width=1></td>
          <td width=60></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>Job Name</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=9><%= dStext.STEXT_JOB %></td>
    	  </tr>
        <tr>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=13 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->	  
        <tr height=2>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align=center>적용일자</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=9> 
            <table cellpadding=0 cellspacing=0>
              <tr>
                <td width=85><input type="text" name="BEGDA_L" value="<%= WebUtil.printDate(i_begda) %>" size="10" onBlur="javascript:dateFormat(this);"></td>
                <td><a href="javascript:fn_openCal('BEGDA_L');"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" border=0 alt='달력보기'></td>
              </tr>
            </table> 
          </td>
        </tr>
        <tr>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=13 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->	  
        <tr height=2>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
        <tr>
    	    <td class=ct rowspan=3></td>
	        <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td rowspan=3 class=ct align=center>직무평가 요소</td>
          <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct rowspan=3 align=center>정의</td>
          <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct colspan=7 align=center>Grade</td>
        </tr>
        <tr>
          <td colspan=7 bgcolor=#999999></td>
        </tr>
    	  <tr>
<%
    for( int i = 0 ; i < j01Result_L_vt.size() ; i ++ ) {
        J01LevelingSheetData data_L = (J01LevelingSheetData)j01Result_L_vt.get(i);
%>
    	    <td class=ct1 align=center><%= data_L.LEVEL_NAME %></td>
<%
        if( i != (j01Result_L_vt.size() - 1) ) {
%>
    	    <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
        }
    }
%>
    	  </tr>
        <tr>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
<%
    String old_code = "";
    long   l_count  = 0;
    for( int i = 0 ; i < j01Result_vt.size() ; i ++ ) {
        J01LevelingSheetData data = (J01LevelingSheetData)j01Result_vt.get(i);
        if( !data.DSORT_CODE.equals(old_code) ) { 
            l_count = 0;
            for( int j = 0 ; j < j01Result_vt.size() ; j++ ) {
                J01LevelingSheetData data_t = (J01LevelingSheetData)j01Result_vt.get(j);
                if( data.DSORT_CODE.equals(data_t.DSORT_CODE) ) {
                    l_count += 1;
                }
            }
%>
        <tr>
          <td class=ct1 rowspan="<%= (l_count * 2) - 1 %>" style="writing-mode:tb-rl" align="center"><%= data.DSORT_NAME %></td>
          <td width=1   rowspan="<%= (l_count * 2) - 1 %>" bgcolor=#999999></td>
<%
            old_code = data.DSORT_CODE;
        } else {
%>
       <tr>
<%
        }
%>
          <td class=cc><%= data.ELEME_NAME %></td>
          <td width=1 bgcolor=#999999></td>
<%
        StringBuffer subtype = new StringBuffer();
        for( int j = 0 ; j < j01Result_D_vt.size() ; j++ ) {
            J01LevelingSheetData data_D = (J01LevelingSheetData)j01Result_D_vt.get(j);
            if( data.TDNAME.equals(data_D.SUBTY) ) {
                subtype.append(data_D.TLINE+"<br>");
            }
        }
%>
          <td class=cc><%= subtype.toString() %></td>
          <td width=1 bgcolor=#999999></td>
<%
        for( int j = 0 ; j < j01Result_L_vt.size() ; j++ ) {
            J01LevelingSheetData data_L = (J01LevelingSheetData)j01Result_L_vt.get(j);
%>
          <td class=cc align=center>
            <input type=radio  name="R<%= i %>"      value="<%= data_L.LEVEL_GRAD %>" <%= data.LEVEL_CODE0.equals(data_L.LEVEL_CODE) ? "checked" : "" %> class=formset2 onclick="javascript:setResult();fn_inputCheck();">
            <input type=hidden name="R_CODE<%= i %>" value="<%= data_L.LEVEL_CODE %>">
          </td>
<%
            if( j != (j01Result_L_vt.size() - 1) ) {
%>
          <td width=1 bgcolor=#999999></td>
<%
            }
        }
%>
        </tr>
        <tr>
          <td bgcolor=#999999 colspan=13></td>
        </tr>
        <input type="hidden" name="SUBTY<%= i %>"      value="<%= data.DSORT_CODE + data.ELEME_CODE %>">
        <input type="hidden" name="LEVEL_CODE<%= i %>" value="<%= data.LEVEL_CODE0                  %>">
<%
    }
%>
        <tr>
          <td colspan=13><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=2 height=5></td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td colspan=13></td>
        </tr>
        <tr bgcolor=#efefef height=25>
          <td colspan=10 align=right>Job Leveling 결과</td>
          <td colspan=3 class=ct1>
            <select name="levelList" <%= E_LEVEL.equals("") ? "disabled" : "" %> onChange="javascript:fn_inputCheck();">
              <option value="">-----------------------</option>
<%
    for( int i = 0 ; i < j01LevelList_vt.size() ; i++ ) {
        J01LevelListData data_List = (J01LevelListData)j01LevelList_vt.get(i);
        if( SOBID_L == null ) { SOBID_L = ""; }
        if( SOBID_L.equals("") && data_List.STEXT.equals(E_LEVEL) ) {
            SOBID_L = data_List.OBJID;
        }
%>
              <option value="<%= data_List.OBJID %>" <%= data_List.OBJID.equals(SOBID_L) ? "selected" : "" %>><%= data_List.STEXT %></option>
<%
    }
%>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan=13 bgcolor=#999999></td>
        </tr>
        <tr height=30 valign=bottom>
          <td colspan=13 align=center>
           <a href="javascript:saveObject();"><img src="<%= WebUtil.ImageURL %>jms/btn_save.gif" border=0 hspace=5 alt="저 장"></a>
      	   <a href="javascript:goLeveling('<%= i_sobid %>', '<%= backFromJSP %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_cancel.gif" border=0 hspace=5 alt="취 소"></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
