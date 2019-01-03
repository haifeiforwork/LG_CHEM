<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
//  생성 로직에서 error가 발생한 경우 다시 화면으로 돌아온다.
//  대분류 명, Function ID, Objectives ID
    String STEXT   = (String)request.getAttribute("STEXT");
    String SOBID_F = (String)request.getAttribute("SOBID_F");
    String SOBID_O = (String)request.getAttribute("SOBID_O");   
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<%@ include file="J04DsortMenu.jsp" %>
<%
    if( STEXT   == null ) { STEXT   = ""; }
    if( SOBID_F == null ) { SOBID_F = dStext.OBJID_FUNC; }
    if( SOBID_O == null ) { SOBID_O = dStext.OBJID_OBJ; }

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
%>
<script language="JavaScript">
<!-- 
// 대분류 저장
function saveObject(){
  if( check_data() ) {
	  document.form1.jobid.value = "create";

    document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J04DsortCreate.J04DsortBuildSV";
    document.form1.method      = "post";
    document.form1.target      = "J_right";
    document.form1.submit();
  } 
}

// 입력 항목 check
function check_data(){
//적용일자 필수
  if( checkNull(document.form1.BEGDA_T, "적용일자를") == false ) {
    return false;
  }
  document.form1.BEGDA.value = removePoint(document.form1.BEGDA_T.value);

//대분류명 - 한글 20자, 영문 40자 내로 입력 
  x_obj = document.form1.STEXT;
  xx_value = x_obj.value;
  if( checkNull(x_obj, "대분류명을") == false ) {
    return false;
  } else {
    if( xx_value != "" && checkLength(xx_value) > 40 ){
      x_obj.value = limitKoText(xx_value, 40);
      alert("대분류명은 한글 20자, 영문 40자 이내여야 합니다.");
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

//Objective 필수
  if( document.form1.SOBID_O.selectedIndex==0 ) {
    alert("Objective를 선택하세요.");
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
//-->
</script>
  
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid"   value="">                      <!-- Servlet 작업 구분 -->

  <input type="hidden" name="OBJID"   value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="SOBID"   value="<%= i_sobid %>">        <!-- 다음화면이동시 Job에 대한 정보를 보여주기 위해서 필요함 -->
  <input type="hidden" name="PERNR"   value="<%= i_pernr %>">
  <input type="hidden" name="BEGDA"   value="">                      <!-- 적용일자 -->

<table cellspacing=0 cellpadding=0 border=0 width=760>
  <tr>
    <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top align=center>
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr height=30>
          <td colspan=3 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>대분류 생성</td>
        </tr>
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=130></td>
          <td width=1></td>
          <td width=615></td>
        </tr>
        <tr align=center>
          <td colspan=3 class=ct height=5></td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>		  
        <tr>
          <td class=ct1 align=center>적용일자</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc> 
            <table border=0 cellpadding=0 cellspacing=0>
              <tr>
                <td width=85><input type="text" name="BEGDA_T" value="<%= WebUtil.printDate(i_begda) %>" size="10" onBlur="javascript:dateFormat(this);" onKeyDown="javascript:fn_inputCheck();"></td>
                <td><a href="javascript:fn_openCal('BEGDA_T');fn_inputCheck();"><img src="<%= WebUtil.ImageURL %>jms/btn_searchs.gif" border=0 alt='달력보기'></td>
              </tr>
            </table> 
          </td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct1 align=center>대분류명</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc>
            <input type="text"   name="STEXT" value="<%= STEXT %>" size="80" maxlength="40" onKeyDown="javascript:fn_inputCheck();">
            <input type="hidden" name="SHORT" value="">
          </td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct1 align=center>대분류 ID</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc>※ 대분류가 생성되면 자동으로 부여됩니다.</td>
        </tr>
        <tr>
          <td colspan=3 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct1 align=center>Function</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc>
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
          <td colspan=3 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct1 align=center>Objective</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc> 
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
          <td colspan=3 bgcolor=#999999></td>
        </tr>
        <tr height=40>
          <td colspan=3 align=center valign=bottom>
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
