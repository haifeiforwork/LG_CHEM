<%@ page contentType="text/html; charset=utf-8" %>  
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<html>
<head>
<title>ESS </title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<%@ include file="J05JobMoveMenu.jsp" %>
<%
    Vector j05Result_vt = (Vector)request.getAttribute("j05Result_vt");

//  현재 page 번호를 받는다.
    String      paging              = (String)request.getAttribute("page");

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if ( j05Result_vt != null && j05Result_vt.size() != 0 ) {       
        try {
          pu = new PageUtil(j05Result_vt.size(), paging , 10, 10 );//Page 관련사항
        } catch (Exception ex) {
          Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>

<script language="JavaScript">
<!-- 
// 달력 사용
function fn_openCal(obj){
    var lastDate;
    lastDate = eval("document.form1." + obj + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+obj+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300,left=100,top=100");
    small_window.focus();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value = page;
  get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){  
  if( check_data() ) {
    document.form1.jobid.value      = "pageChange";
    document.form1.inputCheck.value = document.form0.inputCheck.value;

    document.form1.action       = "<%= WebUtil.ServletURL %>hris.J.J05JobMove.J05JobMoveSV";
    document.form1.method       = "post";
    document.form1.submit();
  }
}

//Function List 변경시 Objectives를 변경한다.
function changeFunc_L(obj, lineCnt) {
  var val = obj[obj.selectedIndex].value;
  var inx = 1, index = 0;

//대분류 List를 clear한다.
  eval("document.form1.OBJID_D"+lineCnt+".length = 1;");
  eval("document.form1.OBJID_D"+lineCnt+"[0].selected = true;");

  if( val == "" ) {
    eval("document.form1.OBJID_O"+lineCnt+".length = 1;");
  } else {
<%
    Objec_ID = "";
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

      eval("document.form1.OBJID_O"+lineCnt+".length = "+inx+";");
      eval("document.form1.OBJID_O"+lineCnt+"["+index+"].value = '<%= data_List.OBJID_O %>';");
      eval("document.form1.OBJID_O"+lineCnt+"["+index+"].text  = '<%= data_List.STEXT_O %>';");
<%
        }
%>
    }
<%
    }
%>
  }
  eval("document.form1.OBJID_O"+lineCnt+"[0].selected = true;");
}

//Objectives List 변경시 대분류를 변경한다.
function changeObjec_L(obj, lineCnt) {
  var val = obj[obj.selectedIndex].value;
  var inx = 1, index = 0;

  if( val == "" ) {
    eval("document.form1.OBJID_D"+lineCnt+".length = 1;");
  } else {
<%
    Dsort_ID = "";
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

      eval("document.form1.OBJID_D"+lineCnt+".length = "+inx+";");
      eval("document.form1.OBJID_D"+lineCnt+"["+index+"].value = '<%= data_List.OBJID_D %>';");
      eval("document.form1.OBJID_D"+lineCnt+"["+index+"].text  = '<%= data_List.STEXT_D %>';");
<%
        }
%>
    }
<%
    }
%>
  }
  eval("document.form1.OBJID_D"+lineCnt+"[0].selected = true;");
}

//Objective가 변경된 경우를 check하여 Job Holder를 한계결정한다.
function deleteHolder(lineCnt) {
//    eval("document.form1.J_HOLDER_FLAG"+lineCnt+".value = 'Y';");
}

//변경된 사항을 저장한다.
function saveObject(){
///////////////////////////////////////////////////////////////////////////////
  if( document.form0.inputCheck.value == "" ) {
    alert("변경된 내용이 존재하지 않습니다.");
    return;
  }
///////////////////////////////////////////////////////////////////////////////

  if( check_data() ) {
	  document.form1.jobid.value = "create";

    document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J05JobMove.J05JobMoveSV";
    document.form1.method      = "post";
    document.form1.target      = "J_right";
    document.form1.submit();
  } 
}

// 입력 항목 check
function check_data(){
//Header의 선택조건 Function 필수
  if( document.form0.SOBID_F.selectedIndex==0 ) {
    alert("선택조건 Function을 선택하세요.");
    document.form0.SOBID_F.focus();
    return false;
  }
//Header의 선택조건 Objective 필수
  if( document.form0.SOBID_O.selectedIndex==0 ) {
    alert("선택조건 Objective를 선택하세요.");
    document.form0.SOBID_O.focus();
    return false;
  }

<%
    for( int i = pu.formRow() ; i < pu.toRow() ; i++ ) {
%>
//Function 필수
  if( eval("document.form1.OBJID_F<%= i %>.selectedIndex==0") ) {
    alert("Function을 선택하세요.");
    eval("document.form1.OBJID_F<%= i %>.focus();");
    return false;
  }
  eval("document.form1.J_OBJID_F<%= i %>.value = document.form1.OBJID_F<%= i %>.value;");
//Objective 필수
  if( eval("document.form1.OBJID_O<%= i %>.selectedIndex==0") ) {
    alert("Objective를 선택하세요.");
    eval("document.form1.OBJID_O<%= i %>.focus();");
    return false;
  }
  eval("document.form1.J_OBJID_O<%= i %>.value = document.form1.OBJID_O<%= i %>.value;");
//대분류 필수
  if( eval("document.form1.OBJID_D<%= i %>.selectedIndex==0") ) {
    alert("대분류를 선택하세요.");
    eval("document.form1.OBJID_D<%= i %>.focus();");
    return false;
  }
  eval("document.form1.J_OBJID_D<%= i %>.value = document.form1.OBJID_D<%= i %>.value;");
//Job 시작일 필수
  if( checkNull(eval("document.form1.BEGDA_J<%= i %>"), "적용일자를") == false ) {
    return false;
  }
  eval("document.form1.J_BEGDA<%= i %>.value = removePoint(document.form1.BEGDA_J<%= i %>.value);");
<%
    }
%>

  return true;
}
//-->
</script>

<form name="form1" method="post" action="">
  <input type="hidden" name="jobid" value="">

  <input type="hidden" name="page"  value="<%= paging  %>">
  <input type="hidden" name="OBJID" value="<%= i_objid %>">
  <input type="hidden" name="SOBID" value="<%= i_sobid %>">
  <input type="hidden" name="PERNR" value="<%= i_pernr %>">
  <input type="hidden" name="BEGDA" value="<%= i_begda %>">        <!-- 적용일자 -->

  <input type="hidden" name="count" value="<%= j05Result_vt.size() %>">

  <input type="hidden" name="inputCheck" value="">     <!-- 화면의 값 입력 check -->

<%
//  Page 이동을 위해서 정보를 저장함.
    for( int i = 0 ; i < j05Result_vt.size() ; i++ ) {
        J05JobMoveData data = (J05JobMoveData)j05Result_vt.get(i);
%>
   <input type="hidden" name="J_OBJID_F<%= i %>"     value="<%= data.OBJID_F     %>">
   <input type="hidden" name="J_OBJID_O<%= i %>"     value="<%= data.OBJID_O     %>">
   <input type="hidden" name="J_OBJID_D<%= i %>"     value="<%= data.OBJID_D     %>">
   <input type="hidden" name="J_OBJID<%= i %>"       value="<%= data.OBJID       %>">
   <input type="hidden" name="J_STEXT<%= i %>"       value="<%= data.STEXT       %>">
   <input type="hidden" name="J_BEGDA<%= i %>"       value="<%= data.BEGDA       %>">
<%
    }
%>

<table cellspacing=0 cellpadding=0 border=0 width=760>
  <tr>
    <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr height=26>
          <td colspan=5 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job 이동</td>
          <td colspan=5 align=right><%= pu == null ?  "" : pu.pageInfo() %></td>
        </tr>
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=119></td>
          <td width=1></td>
          <td width=119></td>
          <td width=1></td>
          <td width=119></td>
          <td width=1></td>
          <td width=270></td>
          <td width=1></td>
          <td width=69></td>
          <td width=30></td>
        </tr>
        <!-- 
        실제 테이블을 사용하실때, 제목칸에는 ct클래스를 사용하시고 내용칸에는 cc클래스를 사용하세요. 
        사이사이에 width=1인 td를 삽입하세요.         
        -->
        <tr align=center>
          <td class=ct>Function</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct>Objective</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct>대분류</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct>Job</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct colspan=2>적용일자</td>
        </tr>
        <tr>
          <td colspan=10 bgcolor=#999999></td>
        </tr>
<%
    for( int i = pu.formRow() ; i < pu.toRow() ; i++ ) {
        J05JobMoveData data = (J05JobMoveData)j05Result_vt.get(i);
%>
        <tr>
          <td class=cc>
            <select name="OBJID_F<%= i %>" onChange="javascript:changeFunc_L(this, '<%= i %>');fn_inputCheck();">
              <option value="">------------------------------</option>
<%
        Func_ID = "";
        for( int j = 0 ; j < j03PEntryList_vt.size() ; j++ ) {
            J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(j);
            if( !data_List.OBJID_F.equals(Func_ID) ) {
                Func_ID = data_List.OBJID_F;
%>
              <option value="<%= data_List.OBJID_F %>" <%= data_List.OBJID_F.equals(data.OBJID_F) ? "selected" : "" %>><%= data_List.STEXT_F %></option>
<%
            }
        }
%>
            </select>

          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc>
            <select name="OBJID_O<%= i %>" onChange="javascript:changeObjec_L(this, '<%= i %>');fn_inputCheck();">
              <option value="">------------------------------</option>
<%
        Objec_ID = "";
        for( int j = 0 ; j < j03PEntryList_vt.size() ; j++ ) {
            J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(j);
            if( data_List.OBJID_F.equals(data.OBJID_F) && !data_List.OBJID_O.equals(Objec_ID) ) {
                Objec_ID = data_List.OBJID_O;
%>
              <option value="<%= data_List.OBJID_O %>" <%= data_List.OBJID_O.equals(data.OBJID_O) ? "selected" : "" %>><%= data_List.STEXT_O %></option>
<%
            }
        }
%>
            </select>
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc>
            <select name="OBJID_D<%= i %>" onChange="javascript:fn_inputCheck();">
              <option value="">------------------------------</option>
<%
        Dsort_ID = "";
        for( int j = 0 ; j < j03PEntryList_vt.size() ; j++ ) {
            J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(j);
            if( data_List.OBJID_F.equals(data.OBJID_F) && data_List.OBJID_O.equals(data.OBJID_O) && !data_List.OBJID_D.equals(Dsort_ID) ) {
                Dsort_ID = data_List.OBJID_D;
%>
              <option value="<%= data_List.OBJID_D %>" <%= data_List.OBJID_D.equals(data.OBJID_D) ? "selected" : "" %>><%= data_List.STEXT_D %></option>
<%
            }
        }
%>
            </select>
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc><%= data.STEXT %></td>
            <input type="hidden" name="OBJID<%= i %>" value="<%= data.OBJID %>">
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc><input type="text" name="BEGDA_J<%= i %>" value="<%= data.BEGDA.equals("") || data.BEGDA.equals("0000-00-00") ? WebUtil.printDate(i_begda) : WebUtil.printDate(data.BEGDA) %>" size="10" onBlur="javascript:dateFormat(this);"></td>
          <td><a href="javascript:fn_openCal('BEGDA_J<%= i %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" border=0 alt='달력보기'></a></td>
        </tr>
        <tr>
          <td colspan=10 bgcolor=#999999></td>
        </tr>
<%
    }
%>
        <tr height=40>
          <td colspan=10 class=cc><font color="#0000FF">※ 권한 밖의 Function, Objective 내의 대분류에서/로 Job을 이동하고자 하는 경우에는 본사 인사팀으로 연락해 주시기 바랍니다.</font></td>
        </tr>
        <tr height=5>
          <td colspan=10><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=5></td>
        </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
        <tr>
          <td colspan=10 align=center>
<%= pu == null ? "" : pu.pageControl() %>
          </td>
        </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
        <tr height=10>
          <td colspan=10></td>
        </tr>
        <tr>
          <td colspan=10 align=center>
            <a href="javascript:saveObject();"><img src="<%= WebUtil.ImageURL %>jms/btn_save.gif" border=0 hspace=5 alt="저장"></a>
            <a href="javascript:goMatrix('<%= i_pernr %>', '<%= i_objid %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_goback.gif" border=0 hspace=5 alt="이전"></a>
          </td>
        </tr>
      </table>	
      <!-- 표가 닫혔습니다 -->
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
