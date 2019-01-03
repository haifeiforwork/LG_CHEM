<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C10Education.*" %>
<%@ page import="hris.C.C10Education.rfc.*" %>

<%
    WebUserData user = (WebUserData)session.getAttribute( "user" );
    
    C10EducationMenuListRFC rfc = new C10EducationMenuListRFC();
    
    Vector ret             = rfc.getList(user.companyCode);
    Vector c10MenuList1_vt = (Vector) ret.get(0);         // 교육 구분
    Vector c10MenuList2_vt = (Vector) ret.get(1);         // 교육 메뉴
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
//교육 과정 list 조회
function go_course(objid_L) {
	document.form1.OBJID_L.value = objid_L;
	document.form1.action      = "<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationCourseListSV";
	document.form1.target      = "menuContentIframe";
	document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif','<%= WebUtil.ImageURL %>icon_Darrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_next_o.gif','<%= WebUtil.ImageURL %>icon_Darrow_next_o.gif')" onSubmit="return;">
<form name="form1" method="post" action="">
  <input type="hidden" name="OBJID_L" value="">
</form>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="15">&nbsp; </td>
    <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
          <td align="right">
            &nbsp;<a href="javascript:open_help('C02Curri.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
          </td>
          </tr>
          <tr> 
            <td class="title01">교육과정 안내/신청</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
    </td>
  </tr>
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="15">&nbsp; </td>
    <td> 
      <!--검색 테이블 시작-->
      <table width="790" border="0" cellspacing="1" cellpadding="0" class="table01">
        <tr> 
          <td class="tr01"> 
<%
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    int l_remain = 0;                               // 나머지
    int l_share  = 0;                               // 몫
    int l_min    = 0, l_max    = 0;                 // colspan 할 위치 min ~ max
    
    l_remain = c10MenuList1_vt.size() % 3;          // 가로 column 개수 => 3
    l_share  = c10MenuList1_vt.size() / 3;          // 가로 column 개수 => 3

    l_max    = 3 * l_share;
    l_min    = l_max - (3 - l_remain);
////////////////////////////////////////////////////////////////////////////////////////////////////////////

    String l_strMain = "", l_strSub = "";
    
    l_strMain  = "<table width='770' border='0' cellspacing='1' cellpadding='2'>";
    l_strMain += "<tr>";
    for( int i = 0 ; i < c10MenuList1_vt.size() ; i++ ) {
        C10EducationMenuListData data1 = (C10EducationMenuListData)c10MenuList1_vt.get(i);
        if( i > 0 && (i % 3) == 0 ) {
            l_strMain += "</tr><tr>";
            l_strMain += l_strSub;
            l_strMain += "</tr><tr>";

            l_strSub = "";
        }
        l_strMain += "<td class='td03' width='250'>";
        l_strMain += data1.MENU_NAME;
        l_strMain += "</td>";

        if( (i + 1) > l_min && (i + 1) <= l_max ) {
            l_strSub += "<td class='td02' rowspan='3' valign='top'><table>";
        } else {
            l_strSub += "<td class='td02' valign='top'><table>";
        }
        for( int j = 0 ; j < c10MenuList2_vt.size() ; j++ ) {
            C10EducationMenuListData data2 = (C10EducationMenuListData)c10MenuList2_vt.get(j);
            if( data1.MENU_CODE.equals(data2.MENU_CODE) ) {
                l_strSub += "<tr><td class='td02'>&nbsp;<img src='" + WebUtil.ImageURL + "dot.gif' border='0'>&nbsp;<a href='javascript:go_course(\"" + data2.BUNID + "\");' onMouseOver=\"this.style.fontWeight='bold';this.style.color='#0000FF'\" onMouseOut=\"this.style.fontWeight='normal';this.style.color='#000000'\">" + data2.STEXT + "</a><br></td></tr>";
            }
        }
        l_strSub += "</table></td>";
    }
      
    if( !l_strSub.equals("") ) {
        l_strMain += "</tr><tr>";
        l_strMain += l_strSub;
        l_strMain += "</tr>";
    } else {
        l_strMain += "</tr>";
    } 
    l_strMain += "</table>";
%>

<%= l_strMain %>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<%@ include file="/web/common/commonEnd.jsp" %>
