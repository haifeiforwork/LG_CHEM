<%@ page contentType="text/html; charset=utf-8" %>  
<%@ include file="/web/common/popupPorcess.jsp" %>
 
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<% 
//  Job Leveling Sheet 정보
    Vector             j01Result_vt     = (Vector)request.getAttribute("j01Result_vt");
    Vector             j01Result_D_vt   = (Vector)request.getAttribute("j01Result_D_vt");
    Vector             j01Result_L_vt   = (Vector)request.getAttribute("j01Result_L_vt");
//  Job Leveling 결과 점수관리
    Vector             j01LevelList_vt  = (Vector)request.getAttribute("j01LevelList_vt");

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

//  Header Stext - Function Name, Objective Name, Job Name
//  사원번호(팀원), image index
    String i_pernr                   = (String)request.getAttribute("i_pernr"); 
    String i_begda                   = (String)request.getAttribute("i_begda");   

//  Objective ID, Job ID
    String i_objid                   = (String)request.getAttribute("i_objid");
    String i_sobid                   = (String)request.getAttribute("i_sobid");

    J01HeaderStextData dStext        = new J01HeaderStextData();
    J01HeaderStextRFC  rfc_Stext     = new J01HeaderStextRFC();
    Vector             j01Stext_vt   = rfc_Stext.getDetail( i_objid, i_sobid, i_pernr, i_begda );
    if( j01Stext_vt.size() > 0 ) {
        dStext = (J01HeaderStextData)j01Stext_vt.get(0);
    }

//  Job Profile화면에서 이미 선택된 Job Leveling 정보를 가져온다.
    String SOBID_L                   = (String)request.getAttribute("SOBID_L");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
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

//저장버튼 클릭시 입력 값을 check하고 값을 setting한다.
function setLevelingSheet() {
  var count       = 0;
  var htmlLEVELING = "", htmlLEVELING_TEXT = "";

  if( document.form1.inputChk.value == "" ) {
    alert("모든 직무평가요소에 대하여 Grade를 선택해야 합니다.");
    return;
  }
  if( document.form1.levelList.selectedIndex == 0 ) {
    alert("Job Leveling 결과를 선택하세요.");
    return;
  } else {
    htmlLEVELING_TEXT = "<a href='javascript:setJobLeveling();'>" + document.form1.levelList[document.form1.levelList.selectedIndex].text + "</a>";
    parent.opener.document.form1.SOBID_TEXT.value = document.form1.levelList[document.form1.levelList.selectedIndex].text;
  }

  for( i = 0 ; i < <%= j01Result_vt.size() %> ; i++ ) {
    htmlLEVELING += "<input type=hidden name='SUBTY_L"+count+"' value='" + eval("document.form1.SUBTY"+i+".value")      + "'>"
                 +  "<input type=hidden name='LCODE_L"+count+"' value='" + eval("document.form1.LEVEL_CODE"+i+".value") + "'>";
    
    count += 1;
  }

  parent.opener.LEVELING.innerHTML           = htmlLEVELING;
  parent.opener.LEVELING_TEXT.innerHTML      = htmlLEVELING_TEXT;
  parent.opener.document.form1.SOBID_L.value = document.form1.levelList.value;
  parent.opener.document.form1.count_L.value = count;

  parent.opener.fn_inputCheck();         //Leveling 저장을 check한다.

  self.close();
}
//-->
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">
<form name="form1" method="post" action="">
  <input type="hidden" name="inputChk" value="<%= SOBID_L.equals("") ? "" : "Y" %>">                     <!-- Job Leveling 입력 여부 -->

<table width=100%>
  <tr height=20>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20></td>
  </tr>
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>
  <tr>
    <td valign=top align=center><br>
      <table cellspacing=0 cellpadding=0 border=0 width=760>
        <tr>
          <td colspan=10 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job Leveling Sheet 생성</td>
          <td colspan=3 valign=bottom align=right>적용일자 : <%= WebUtil.printDate(i_begda) %></td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td width=30></td>
          <td width=1></td>
          <td width=149></td>
          <td width=1></td>
          <td width=299></td>
          <td width=1></td>
          <td width=69></td>
          <td width=1></td>
          <td width=69></td>
          <td width=1></td>
          <td width=69></td>
          <td width=1></td>
          <td width=69></td>
        </tr>
        <tr align=center>
          <td class=ct rowspan=3></td>
          <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td rowspan=3 class=ct>직무평가 요소</td>
          <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct rowspan=3>정의</td>
          <td width=1 bgcolor=#999999 rowspan=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct colspan=7>Grade</td>
        </tr>
        <tr>
          <td colspan=7 bgcolor=#999999></td>
        </tr>
        <tr align=center>
<%
    for( int i = 0 ; i < j01Result_L_vt.size() ; i ++ ) {
        J01LevelingSheetData data_L = (J01LevelingSheetData)j01Result_L_vt.get(i);
%>
          <td class=ct1><%= data_L.LEVEL_NAME %></td>
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
          <td class=ct1 rowspan="<%= (l_count * 2) - 1 %>" align=center style="writing-mode:tb-rl"><%= data.DSORT_NAME %></td>
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
            <input type=radio  name="R<%= i %>"      value="<%= data_L.LEVEL_GRAD %>" <%= data.LEVEL_CODE0.equals(data_L.LEVEL_CODE) ? "checked" : "" %> class=formset2 onclick="javascript:setResult();">
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
            <select name="levelList" <%= SOBID_L.equals("") ? "disabled" : "" %>>
              <option value="">-----------------------</option>
<%
    for( int i = 0 ; i < j01LevelList_vt.size() ; i++ ) {
        J01LevelListData data_List = (J01LevelListData)j01LevelList_vt.get(i);
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
            <a href="javascript:setLevelingSheet()"><img src="<%= WebUtil.ImageURL %>jms/btn_save.gif" border=0 hspace=5 alt="저 장"></a>
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
