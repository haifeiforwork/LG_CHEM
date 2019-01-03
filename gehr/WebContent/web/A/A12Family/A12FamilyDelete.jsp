<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A12Family.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector                 a12FamilyListData_vt = (Vector)request.getAttribute("a12FamilyListData_vt");
    A12FamilyListData      data                 = (A12FamilyListData)a12FamilyListData_vt.get(0);
%>


<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function do_delete(){
	if( confirm("정말 삭제하시겠습니까?") ) {
    document.form1.jobid.value = "delete";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12FamilyBuild01SV";
    document.form1.method = "post";
    document.form1.submit();
	}
}

function do_preview(){
  document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A04FamilyDetailSV";
  document.form1.method = "post";
  document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<form name="form1" method="post" action="">
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
              &nbsp;<a href="javascript:open_help('A12Family.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
            </td>
          </tr>
          <tr> 
            <td class="title01">가족사항삭제확인</td>
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
        <!-- 상단 입력 테이블 시작-->
        <table width="656" border="0" cellspacing="1" cellpadding="0" class="table01">
          <tr> 
            <td class="tr01"> 
              <table width="630" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr> 
                  <td class="font01"><font color="#7897FC">■</font> 대상자</td>
                </tr>
                <tr> 
                  <td class="font01"> 
                    <table width="630" border="0" cellspacing="1" cellpadding="3" class="table02">
                      <tr> 
                        <td class="td01" width="90">성명(한글)</td>
                        <td class="td02" width="222">
                          <input type="text" name="LNMHG" value="<%= data.LNMHG %> <%= data.FNMHG %>" class="input04" size="20" readonly>
                        </td>
                        <td class="td01" width="80">가족유형</td>
                        <td class="td02" width="221"> 
                          <input type="text" name="STEXT"  value="<%= data.STEXT %>" class="input04" size="20" readonly>
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">주민등록번호</td>
                        <td class="td02" width="222">
                          <input type="text" name="REGNO"  value="<%= DataUtil.addSeparate(data.REGNO) %>" class="input04" size="20" readonly>
                        </td>
                        <td width="80" class="td01">관 계</td>
                        <td class="td02" width="221"> 
                          <input type="text" name="ATEXT"  value="<%= data.ATEXT %>" class="input04" size="20" readonly>
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">생년월일</td>
                        <td class="td02">
                          <input type="text" name="year"  value="<%= data.FGBDT.substring(0, 4) %>" class="input04" size="4" readonly>
                          년 
                          <input type="text" name="month" value="<%= data.FGBDT.substring(5, 7) %>" class="input04" size="2" readonly>
                          월 
                          <input type="text" name="day"   value="<%= data.FGBDT.substring(8, 10) %>" class="input04" size="2" readonly>
                          일 
                        </td>
                        <td class="td01">성 별</td>
                        <td class="td02">
                          <input type="radio" name="FASEX" value="1" <%= data.FASEX.equals("1") ? "checked" : "" %> disabled>
                          남
                          <input type="radio" name="FASEX" value="2" <%= data.FASEX.equals("2") ? "checked" : "" %> disabled>
                          여
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">출생지</td>
                        <td class="td02">
                          <input type="text" name="FGBOT" value="<%= data.FGBOT %>" class="input04" size="20" readonly>
                        </td>
                        <td class="td01">학 력</td>
                        <td class="td02">
                          <input type="text" name="STEXT1"  value="<%= data.STEXT1 %>" class="input04" size="20" readonly>
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">출생국</td>
                        <td class="td02">
                          <input type="text" name="LANDX"  value="<%= data.LANDX %>" class="input04" size="20" readonly>
                        </td>
                        <td class="td01">교육기관</td>
                        <td class="td02">
                          <input type="text" name="FASIN"  value="<%= data.FASIN %>" class="input04" size="20" readonly>
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">국 적</td>
                        <td class="td02">
                          <input type="text" name="NATIO"  value="<%= data.NATIO %>" class="input04" size="20" readonly>
                        </td>
                        <td class="td01">직 업</td>
                        <td class="td02">
                          <input type="text" name="FAJOB"  value="<%= data.FAJOB %>" class="input04" size="20" readonly>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td class="font01">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="font01"><font color="#FF0000">선택한 가족의 데이타가 영구적으로 삭제됩니다.</font></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!--상단 입력 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
        <table width="656" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td align="center">
              <a href="javascript:do_delete();">
                <img src="<%= WebUtil.ImageURL %>btn_delete.gif" width="49" height="20" name="image2" align="absmiddle" border="0"></a> 
              <a href="javascript:do_preview();">
                <img src="<%= WebUtil.ImageURL %>btn_cancel.gif"  width="49" height="20" name="image2" align="absmiddle" border="0"></a> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="jobid"       value="">
      <input type="hidden" name="SUBTY"       value="<%= data.SUBTY %>">
      <input type="hidden" name="OBJPS"       value="<%= data.OBJPS %>">
      <input type="hidden" name="BEGDA"       value="<%= data.BEGDA %>">
      <input type="hidden" name="ENDDA"       value="<%= data.ENDDA %>">
      <input type="hidden" name="FGBDT"       value="<%= data.FGBDT %>">
      <input type="hidden" name="KDSVH"       value="<%= data.KDSVH %>">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

