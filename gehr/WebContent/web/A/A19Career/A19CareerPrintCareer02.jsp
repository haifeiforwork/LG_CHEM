<%/********************************************************************************/
/*   Update       : 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/**********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.A.A15Certi.*" %>
<%@ page import="hris.A.A19Career.*" %>
<%@ page import="hris.common.*" %>

<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%
  WebUserData user = WebUtil.getSessionUser(request);

  PersonData phonenum  = (PersonData) request.getAttribute("PersInfoData");
  Vector T_RESULT    = (Vector)request.getAttribute("T_RESULT");
  String E_JUSO_TEXT = (String)request.getAttribute("E_JUSO_TEXT");
  String E_KR_REPRES = (String)request.getAttribute("E_KR_REPRES");

  A15CertiData data = (A15CertiData)T_RESULT.get(0);
  A19CareerData  a19CareerData  = (A19CareerData)request.getAttribute("a19CareerData");


  Vector a09CareerDetailData_vt = (Vector)request.getAttribute("a09CareerDetailData_vt");

%>
<html>
<head>
<title>LG화학-On-Line 경력증명서</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">

function f_print(){

    parent.beprintedpage.focus();
    parent.beprintedpage.print();
//  본인발행 1회 인쇄 여부를 설정한다.
    parent.opener.document.form1.PRINT_END.value = "X";
    parent.close();
}
function close() {
    parent.opener.document.form1.PRINT_END.value = "X";
    parent.close();
}
</SCRIPT>
<style type="text/css">
.font01 {  font-family: "굴림", "굴림체"; font-size: 10pt; background-color: #transparent; color: #333333}
.font02 {  font-family: "굴림", "굴림체"; font-size: 12pt; background-color: #transparent; color: #333333}
.font03 {  font-family: "굴림", "굴림체"; font-size: 21pt; background-color: #transparent; color: #333333}
.font04 {  font-family: "굴림", "굴림체"; font-size: 14pt; color: #333333}
.font05 {  font-family: "굴림", "굴림체"; font-size: 10pt; color: #333333}
body {
	background-attachment: fixed;
	background-image:  url('<%= WebUtil.ImageURL %>logobg.jpg');
	background-repeat: no-repeat;
	background-position: center;
}
table {
	background-color: transparent;
}
tr {
	background-color: transparent;
}
td {
	background-color: transparent;
}
	background-position: 100% 100%;

</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"   oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()" onload="//setDefault();//f_print();">
<form name="form1" method="post" action="">
<br><br>
<table width="640" border="1" bordercolordark="white" bordercolorlight="#000000" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <table width="580" border="0" cellspacing="1" cellpadding="2" align="center" style="background:url(<%= WebUtil.JspURL %>A/A15Certi/bg_lg_logo.gif) no-repeat 50% 50%">
        <tr>
          <td colspan="2" class="font02">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="font02">&nbsp;<img src="<%= WebUtil.ImageURL %>img_logopay_hwahak.gif"></td>
        </tr>
        <tr>
          <td colspan="2" class="font01">
            &nbsp;  엘화 제 <%= data.PUBLIC_NUM.equals("") ? "" : data.PUBLIC_NUM.substring(0,4) + "-" + data.PUBLIC_NUM.substring(4,9) %> 호
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font02">&nbsp;</td>
        </tr>
        <tr>
        <tr>
          <td colspan="2" class="font03" align="center">
            <u><b>경　력　증　명　서</b></u>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font02">&nbsp;</td>
        </tr>
        <tr>
        <tr>
          <td colspan="2" class="font02">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="font04">
            <b>성　　　　명 : <%= phonenum.E_ENAME %></b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="font04">
            <!-- [CSR ID:2596828]  <b>주민등록번호 : <%= phonenum.E_REGNO.equals("") ? "" : DataUtil.addSeparate(phonenum.E_REGNO) %></b>  -->
            <!-- [CSR ID:2599108] E-HR 제증명 생년월일 표시 형식 변경요청 -->
				<b>생<font color="FFFFFF">_</font>년　월<font color="FFFFFF">_</font>일 : <%= phonenum.E_GBDAT.equals("") ? "" : WebUtil.printDate(phonenum.E_GBDAT, ".") %></b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="font04">
            <b>주　　　　소 : <%= data.ADDRESS1 %></b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
<%
    if( !data.ADDRESS2.equals("") ) {
%>
        <tr>
          <td colspan="2" class="font04">
            <b>　　　　　　&nbsp;&nbsp;&nbsp;<%= data.ADDRESS2 %></b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
<%
    }
%>
        <tr>
          <td colspan="2" class="font04">
            <b>경<font color="FFFFFF">_</font>력　사<font color="FFFFFF">_</font>항 : ＊ 경력사항은 별첨 참조 ＊</b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>

        <tr>
          <td colspan="2" class="font04">
            <b>입<font color="FFFFFF">_</font>사　일<font color="FFFFFF">_</font>자 : <%= data.ENTR_DATE.equals("") ? "" : WebUtil.printDate(data.ENTR_DATE,". ") %></b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="font04">
            <b>용　　　　도 : <%= data.USE_PLACE %></b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="font04">
            <b>※ 용도외 사용을 금합니다.</b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
      </table>
      <br><br><br>
      <br><br><br>
      <table width="580" border="0" cellspacing="1" cellpadding="2" align="center" style="background:url(<%= WebUtil.JspURL %>A/A15Certi/bg_lg_logo.gif) no-repeat 50% 50%">
        <tr>
          <td width=140 class="font05">&nbsp;</td>
          <td class="font04" colspan=2>
            <b>상기 사실을 증명함</b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
        <tr>
          <td class="font05" width=140>&nbsp;</td>
          <td class="font05" width=30>&nbsp;</td>
          <td class="font04">
            <b><%= DataUtil.getCurrentDate().substring(0,4) + " 년 " + DataUtil.getCurrentDate().substring(4,6) + " 월 " + DataUtil.getCurrentDate().substring(6,8) + " 일" %></b>
          </td>
        </tr>
        <tr height="30">
          <td class="font05">&nbsp;</td>
          <td class="font05">&nbsp;</td>
          <td class="font04" colspan=2>
            <b><%= E_JUSO_TEXT %></b></td>
        </tr>
        <tr height=120><td colspan=3>
        <table border=0 width="580" height=100% style="background:url(<%= WebUtil.ImageURL %>doDojang.jpg) no-repeat 95% 5%">
        <tr>
          <td width=260 class="font05">&nbsp;</td>
          <td class="font04">
            <b>주　식　회　사　　L&nbsp;G&nbsp;&nbsp;화&nbsp;학</b>
          </td>
          <td valign=top rowspan=2></td>

        </tr>
        <tr>
          <td class="font05" width="170">&nbsp;</td>
<%
    String l_ename = "";
    if( E_KR_REPRES.length() == 3 ) {
        l_ename = E_KR_REPRES.substring(0,1) + "&nbsp;&nbsp;" + E_KR_REPRES.substring(1,2) +  "&nbsp;&nbsp;" + E_KR_REPRES.substring(2,3);
    } else {
        l_ename = E_KR_REPRES;
    }
%>
          <td class="font04" width="275">
            <b>대　표　이　사　　<%= l_ename %></b><br><br><br>
          </td>
        </tr>
        </table>
        </td>
        </tr>

        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<table width="640" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr height=1><td class="font05">&nbsp;</td></tr>
  <tr>
    <td class="font01">
      <b>※ 본 서류는 외부기관 제출용 증빙서류로서, 당사의 On-Line 인사 시스템을 통해 발급되었습니다.</b>
    </td>
  </tr>
</table>
<br><br>
<!---------2페이지 경력사항------------------------------------------------------------------------------->

<table width="640" border="1" bordercolordark="white" bordercolorlight="#000000" cellspacing="0" cellpadding="0" align="center"  style="page-break-before: always;">
  <tr>
    <td>
      <table width="580" border="0" cellspacing="1" cellpadding="2" align="center" style="background:url(<%= WebUtil.JspURL %>A/A15Certi/bg_lg_logo.gif) no-repeat 50% 50%">
        <tr>
          <td colspan="2" class="font02">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="font02">&nbsp;<img src="<%= WebUtil.ImageURL %>img_logopay_hwahak.gif"></td>
        </tr>
        <tr>
          <td colspan="2" class="font01">
            &nbsp;  엘화 제 <%= data.PUBLIC_NUM.equals("") ? "" : data.PUBLIC_NUM.substring(0,4) + "-" + data.PUBLIC_NUM.substring(4,9) %> 호
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font02">&nbsp;</td>
        </tr>
        <tr>
        <tr>
          <td colspan="2" class="font03" align="center">
            <u><b>경　력　사　항</b></u>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font02">&nbsp;</td>
        </tr>
        <tr>
        <tr>
          <td colspan="2" class="font02">&nbsp;</td>
        </tr>
<!----------------------------------------->
        <tr>
          <td colspan="2" width="228" align="right">
              <table width="650" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
                <tr height="30">
                  <td class="td06" width="150" align="center">기간</td>
                  <td class="td06" width="150" align="center">부서명</td>
                  <td class="td06" width="150" align="center">근무지</td>
                  <td class="td06" width="100" align="center">직무</td>
                  <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
				  <%--  <td class="td06" width="100" align="center">직위</td>--%>
				  <td class="td06" width="100" align="center">직위/직급호칭</td>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>

                </tr>
<%  int inx =0;
    if( a09CareerDetailData_vt.size() > 0 ) {
        for ( int i = 0 ; i < a09CareerDetailData_vt.size() ; i++ ) {
            A09CareerDetailData data1 = (A09CareerDetailData)a09CareerDetailData_vt.get(i);
            inx++;
%>

                <tr>
                  <td class="td06" align="center">
                    <%= data1.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data1.BEGDA) %>~<%= data1.ENDDA.equals("0000-00-00") ? "" : WebUtil.printDate(data1.ENDDA) %>
                  </td>
                  <td class="td06">&nbsp;</td>
                  <td class="td06"><%= data1.ARBGB %>&nbsp;</td>
                  <td class="td06"><%= data1.JIKWT %>&nbsp;</td>
                  <td class="td06"><%= data1.STLTX %>&nbsp;</td>
                </tr>

<%
        }
    }
%>
<%  for ( int j = inx ; j < 20 ; j++ ) {
%>
                <tr>
                  <td class="td06" align="center">&nbsp;</td>
                  <td class="td06">&nbsp;</td>
                  <td class="td06">&nbsp;</td>
                  <td class="td06">&nbsp;</td>
                  <td class="td06">&nbsp;</td>
                </tr>
<%
    }
%>

              </table>
          </td>
        </tr>
<!---------------------------------------------------------->
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>

      </table>

      <br><br><br>
      <table width="580" border="0" cellspacing="1" cellpadding="2" align="center" style="background:url(<%= WebUtil.JspURL %>A/A15Certi/bg_lg_logo.gif) no-repeat 50% 50%">
        <tr>
          <td width=140 class="font05">&nbsp;</td>
          <td class="font04" colspan=2>
            <b>상기 사실을 증명함</b>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
        <tr>
          <td class="font05" width=140>&nbsp;</td>
          <td class="font05" width=30>&nbsp;</td>
          <td class="font04">
            <b><%= DataUtil.getCurrentDate().substring(0,4) + " 년 " + DataUtil.getCurrentDate().substring(4,6) + " 월 " + DataUtil.getCurrentDate().substring(6,8) + " 일" %></b>
          </td>
        </tr>
        <tr height="30">
          <td class="font05">&nbsp;</td>
          <td class="font05">&nbsp;</td>
          <td class="font04" colspan=2>
            <b><%= E_JUSO_TEXT %></b></td>
        </tr>
        <tr height=120><td colspan=3>
        <table border=0 width="580" height=100% style="background:url(<%= WebUtil.ImageURL %>doDojang.jpg) no-repeat 94%  6%">
        <tr>
          <td width=260 class="font05">&nbsp;</td>
          <td class="font04">
            <b>주　식　회　사　　L&nbsp;G&nbsp;&nbsp;화&nbsp;학</b>
          </td>
          <td valign=top rowspan=2></td>

        </tr>
        <tr>
          <td class="font05" width="160">&nbsp;</td>
          <td class="font04" width="275">
            <b>대　표　이　사　　<%= l_ename %></b><br><br><br>
          </td>
        </tr>
        </table>
        </td>
        </tr>

        <tr>
          <td colspan="2" class="font05">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<table width="640" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr height=1><td class="font05">&nbsp;</td></tr>
  <tr>
    <td class="font01">
      <b>※ 본 서류는 외부기관 제출용 증빙서류로서, 당사의 On-Line 인사 시스템을 통해 발급되었습니다.</b>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>