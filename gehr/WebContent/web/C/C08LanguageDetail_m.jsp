<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.C.C07Language.*" %>
<%@ page import="hris.C.C07Language.rfc.*" %>

<%
    WebUserData     user_m = (WebUserData)session.getAttribute("user_m");
    Box             box    = WebUtil.getBox(request);
    C07LanguageData data   = new C07LanguageData();
    box.copyToEntity(data);

//  학습형태 TEXT를 읽어온다.
    C07StudTypeRFC func      = new C07StudTypeRFC();
    Vector         type_vt   = func.getDetail();
    String         STUD_TEXT = "";
    for( int i = 0; i < type_vt.size(); i++ ){
        CodeEntity entity = (CodeEntity)type_vt.get(i);
        
        if( ( data.STUD_TYPE ).equals( entity.code ) ){
            STUD_TEXT = entity.value;
            break;
        }
    }
//  학습형태 TEXT를 읽어온다.
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function f_print()
{
     self.print();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="36">
      <td width="15">&nbsp;</td>
      <td class="td02">
        <font color="#0000FF"><%= "▶ " + user_m.ename + " " + user_m.e_titel + "의 HR정보입니다." + ( user_m.i_stat2.equals("0") ? " (퇴직자)" : "" ) %></font>
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="title01">어학지원비 상세조회</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
    </td>
  </tr>
  <tr><td width="15">&nbsp;</td><td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="15">&nbsp; </td>
    <td> 
        <!-- 상단 검색테이블 시작-->
        <table width="624" border="0" cellspacing="1" cellpadding="0" class="table01">
          <tr> 
            <td class="tr01"> 
              <table width="604" border="0" cellspacing="1" cellpadding="2">
                <tr> 
                  <td class="td01" width="60">부서명</td>
                  <td class="td02" width="260" colspan="2"><%= user.e_orgtx %></td>
                  <td class="td01" width="60">사 번</td>
                  <td class="td02" width="60"><%= user.empNo %></td>
                  <td class="td01" width="60">성 명</td>
                  <td class="td02" width="60"><%= user.ename %></td>
                  <td><a href="javascript:f_print()"><img src="<%= WebUtil.ImageURL %>btn_print.gif" width="59" height="20" border="0"></a></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!-- 상단 검색테이블 끝-->
    </td>
  </tr>
  <form name="form1" method="post" action="">
    <tr><td width="15">&nbsp; </td>
      <td>
        <!-- 상단 입력 테이블 시작-->
      <table width="600" border="0" cellspacing="1" cellpadding="0" class="table01">
        <tr> 
          <td class="tr01">
            <table width="600" border="0" cellspacing="1" cellpadding="2" class="table02">
              <tr> 
                <td class="td01">신청일자</td>
                <td class="td02" colspan="3">
                  <input type="text" name="BEGDA" class="input04" value="<%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA,".") %>" size="20" readonly>
                </td>
              </tr>
              <tr>
                <td width="100" class="td01">학습시작일</td>
                <td width="200" class="td02">
                  <input type="text" name="SBEG_DATE" class="input04" value="<%= WebUtil.printDate(data.SBEG_DATE,".") %>" size="20" readonly>
                </td>
                <td width="100" class="td01">학습종료일</td>
                <td width="200" class="td02">
                  <input type="text" name="SEND_DATE" class="input04" value="<%= WebUtil.printDate(data.SEND_DATE,".") %>" size="20" readonly>
                </td>
              </tr>
              <tr>
                <td class="td01">학습형태</td>
                <td class="td02">
                  <input type="text" name="STUD_TEXT" class="input04" value="<%= STUD_TEXT %>" size="20" readonly>
                </td>
                <td class="td01">수강시간</td>
                <td class="td02">
                  <input type="text" name="LECT_TIME" class="input04" value="<%= WebUtil.printNumFormat(data.LECT_TIME).equals("0") ? "" : WebUtil.printNumFormat(data.LECT_TIME) + " " %>" size="20" style="text-align:right" readonly>
                </td>
              </tr>
              <tr>
                <td class="td01">학습기관</td>
                <td class="td02" colspan="3">
                  <input type="text" name="STUD_INST" class="input04" value="<%= data.STUD_INST %>" size="50" readonly>
                </td>
              </tr>
              <tr>
                <td class="td01">수강과목</td>
                <td class="td02" colspan="3">
                  <input type="text" name="LECT_SBJT" class="input04" value="<%= data.LECT_SBJT %>" size="50" readonly>
                </td>
              </tr>
              <tr>
                <td class="td01">결제금액</td>
                <td class="td02">
                  <input type="text" name="SETL_WONX" class="input04" value="<%= WebUtil.printNumFormat(data.SETL_WONX) + " " %>" size="20" style="text-align:right" readonly>
                </td>
                <td class="td01">결제일</td>
                <td class="td02">
                  <input type="text" name="SELT_DATE" class="input04" value="<%= WebUtil.printDate(data.SELT_DATE,".") %>" size="20" readonly>
                </td>
              </tr>
              <tr>
                <td class="td01">카드번호</td>
                <td class="td02" colspan="3">
                  <input type="text" name="CARD_NUMB" class="input04" value="<%= data.CARD_NUMB %>" size="20" readonly>
                </td>
              </tr>
              <tr>
                <td class="td01">카드회사</td>
                <td class="td02" colspan="3">
                  <input type="text" name="CARD_CMPY" class="input04" value="<%= data.CARD_CMPY %>" size="50" readonly>
                </td>
              </tr>
              <tr>
                <td class="td01">회사지원금액</td>
                <td class="td02" colspan="3">
                  <input type="text" name="CMPY_WONX" class="input04" value="<%= WebUtil.printNumFormat(data.CMPY_WONX) + " " %>" style="text-align:right" readonly>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
        <!-- 상단 입력 테이블 끝-->
      </td>
    </tr>
    <tr><td width="15" colspan="2">&nbsp;</td></tr>
    <tr><td width="15">&nbsp; </td>
      <td> 
        <table width="600" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td align="center"> <a href="javascript:history.back();"><img src="<%= WebUtil.ImageURL %>btn_list.gif" width="49" height="20" name="image3" border="0" align="absmiddle"></a></td>
          </tr>
        </table>
      </td>
    </tr>
  </form>
</table>
<%@ include file="/web/common/commonEnd.jsp" %>
