<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 소속별/직무별 인원현황
*   Program ID   : F02DeptPositionDutyExcel.jsp
*   Description  : 소속별/직무별 인원현황 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");                            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                  //부서명
    Vector F02DeptPositionDutyTitle_vt = (Vector)request.getAttribute("F02DeptPositionDutyTitle_vt");   //제목
    Vector F02DeptPositionDutyNote_vt  = (Vector)request.getAttribute("F02DeptPositionDutyNote_vt");    //내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptPositionDuty.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<%
    if ( F02DeptPositionDutyTitle_vt != null && F02DeptPositionDutyTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
        tableSize = F02DeptPositionDutyTitle_vt.size()*60 + 250;

%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* 소속별/직무별 인원현황</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td width="50%" class="td09">
            &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td ></td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr>
          <td width="250" class="td03"><spring:message code='LABEL.F.F04.0001'/><!-- 구분 --></td>
<%
        //타이틀.
        for( int k = 0; k < F02DeptPositionDutyTitle_vt.size(); k++ ){
            F02DeptPositionDutyTitleData titleData = (F02DeptPositionDutyTitleData)F02DeptPositionDutyTitle_vt.get(k);
%>
          <td width="60" class="td03" ><%=titleData.JIKL_TEXT%></td>
<%
        }//end for

        //타이틀에 맞추어 내용영역 보여주기위한 개수.
        int noteSize = F02DeptPositionDutyTitle_vt.size();
        //내용.
        for( int i = 0; i < F02DeptPositionDutyNote_vt.size(); i++ ){
            F02DeptPositionDutyNoteData data = (F02DeptPositionDutyNoteData)F02DeptPositionDutyNote_vt.get(i);

            String strBlank  = "";
            String titlClass = "";
            String noteClass = "";
            int blankSize = Integer.parseInt(WebUtil.nvl(data.ZLEVEL, "0")) ;

            //클래스 설정.
            if (blankSize != 0) {
                titlClass = "class=td09";
                noteClass = "class=td05";
            } else {
                titlClass = "class=td11";
                noteClass = "class=td12";
            }

            //부서명 앞에 공백넣기.
            for (int h = 0; h < blankSize; h++) {
                strBlank = strBlank+"&nbsp;&nbsp;";
            }
%>
        <tr>
          <td <%=titlClass%> ><%=strBlank%><%=data.STEXT%></td>
          <td <%=noteClass%> ><%=WebUtil.printNumFormat(data.F1)%></td>
          <td <%=noteClass%> ><%=WebUtil.printNumFormat(data.F2)%></td>
          <% if( noteSize >= 3 )   out.println("<td>"+WebUtil.printNumFormat(data.F3 )+"</td>"); %>
          <% if( noteSize >= 4 )   out.println("<td>"+WebUtil.printNumFormat(data.F4 )+"</td>"); %>
          <% if( noteSize >= 5 )   out.println("<td>"+WebUtil.printNumFormat(data.F5 )+"</td>"); %>
          <% if( noteSize >= 6 )   out.println("<td>"+WebUtil.printNumFormat(data.F6 )+"</td>"); %>
          <% if( noteSize >= 7 )   out.println("<td>"+WebUtil.printNumFormat(data.F7 )+"</td>"); %>
          <% if( noteSize >= 8 )   out.println("<td>"+WebUtil.printNumFormat(data.F8 )+"</td>"); %>
          <% if( noteSize >= 9 )   out.println("<td>"+WebUtil.printNumFormat(data.F9 )+"</td>"); %>
          <% if( noteSize >= 10 )  out.println("<td>"+WebUtil.printNumFormat(data.F10)+"</td>"); %>
          <% if( noteSize >= 11 )  out.println("<td>"+WebUtil.printNumFormat(data.F11)+"</td>"); %>
          <% if( noteSize >= 12 )  out.println("<td>"+WebUtil.printNumFormat(data.F12)+"</td>"); %>
          <% if( noteSize >= 13 )  out.println("<td>"+WebUtil.printNumFormat(data.F13)+"</td>"); %>
          <% if( noteSize >= 14 )  out.println("<td>"+WebUtil.printNumFormat(data.F14)+"</td>"); %>
          <% if( noteSize >= 15 )  out.println("<td>"+WebUtil.printNumFormat(data.F15)+"</td>"); %>
          <% if( noteSize >= 16 )  out.println("<td>"+WebUtil.printNumFormat(data.F16)+"</td>"); %>
          <% if( noteSize >= 17 )  out.println("<td>"+WebUtil.printNumFormat(data.F17)+"</td>"); %>
          <% if( noteSize >= 18 )  out.println("<td>"+WebUtil.printNumFormat(data.F18)+"</td>"); %>
          <% if( noteSize >= 19 )  out.println("<td>"+WebUtil.printNumFormat(data.F19)+"</td>"); %>
          <% if( noteSize >= 20 )  out.println("<td>"+WebUtil.printNumFormat(data.F20)+"</td>"); %>
          <% if( noteSize >= 21 )  out.println("<td>"+WebUtil.printNumFormat(data.F21)+"</td>"); %>
          <% if( noteSize >= 22 )  out.println("<td>"+WebUtil.printNumFormat(data.F22)+"</td>"); %>
          <% if( noteSize >= 23 )  out.println("<td>"+WebUtil.printNumFormat(data.F23)+"</td>"); %>
          <% if( noteSize >= 24 )  out.println("<td>"+WebUtil.printNumFormat(data.F24)+"</td>"); %>
          <% if( noteSize >= 25 )  out.println("<td>"+WebUtil.printNumFormat(data.F25)+"</td>"); %>
          <% if( noteSize >= 26 )  out.println("<td>"+WebUtil.printNumFormat(data.F26)+"</td>"); %>
          <% if( noteSize >= 27 )  out.println("<td>"+WebUtil.printNumFormat(data.F27)+"</td>"); %>
          <% if( noteSize >= 28 )  out.println("<td>"+WebUtil.printNumFormat(data.F28)+"</td>"); %>
          <% if( noteSize >= 29 )  out.println("<td>"+WebUtil.printNumFormat(data.F29)+"</td>"); %>
          <% if( noteSize >= 30 )  out.println("<td>"+WebUtil.printNumFormat(data.F30)+"</td>"); %>
          <% if( noteSize >= 31 )  out.println("<td>"+WebUtil.printNumFormat(data.F31)+"</td>"); %>
          <% if( noteSize >= 32 )  out.println("<td>"+WebUtil.printNumFormat(data.F32)+"</td>"); %>
          <% if( noteSize >= 33 )  out.println("<td>"+WebUtil.printNumFormat(data.F33)+"</td>"); %>
          <% if( noteSize >= 34 )  out.println("<td>"+WebUtil.printNumFormat(data.F34)+"</td>"); %>
          <% if( noteSize >= 35 )  out.println("<td>"+WebUtil.printNumFormat(data.F35)+"</td>"); %>
          <% if( noteSize >= 36 )  out.println("<td>"+WebUtil.printNumFormat(data.F36)+"</td>"); %>
          <% if( noteSize >= 37 )  out.println("<td>"+WebUtil.printNumFormat(data.F37)+"</td>"); %>
          <% if( noteSize >= 38 )  out.println("<td>"+WebUtil.printNumFormat(data.F38)+"</td>"); %>
          <% if( noteSize >= 39 )  out.println("<td>"+WebUtil.printNumFormat(data.F39)+"</td>"); %>
          <% if( noteSize >= 40 )  out.println("<td>"+WebUtil.printNumFormat(data.F40)+"</td>"); %>
          <% if( noteSize >= 41 )  out.println("<td>"+WebUtil.printNumFormat(data.F41)+"</td>"); %>
          <% if( noteSize >= 42 )  out.println("<td>"+WebUtil.printNumFormat(data.F42)+"</td>"); %>
          <% if( noteSize >= 43 )  out.println("<td>"+WebUtil.printNumFormat(data.F43)+"</td>"); %>
          <% if( noteSize >= 44 )  out.println("<td>"+WebUtil.printNumFormat(data.F44)+"</td>"); %>
          <% if( noteSize >= 45 )  out.println("<td>"+WebUtil.printNumFormat(data.F45)+"</td>"); %>
          <% if( noteSize >= 46 )  out.println("<td>"+WebUtil.printNumFormat(data.F46)+"</td>"); %>
          <% if( noteSize >= 47 )  out.println("<td>"+WebUtil.printNumFormat(data.F47)+"</td>"); %>
          <% if( noteSize >= 48 )  out.println("<td>"+WebUtil.printNumFormat(data.F48)+"</td>"); %>
          <% if( noteSize >= 49 )  out.println("<td>"+WebUtil.printNumFormat(data.F49)+"</td>"); %>
          <% if( noteSize >= 50 )  out.println("<td>"+WebUtil.printNumFormat(data.F50)+"</td>"); %>
          <% if( noteSize >= 51 )  out.println("<td>"+WebUtil.printNumFormat(data.F51)+"</td>"); %>
          <% if( noteSize >= 52 )  out.println("<td>"+WebUtil.printNumFormat(data.F52)+"</td>"); %>
          <% if( noteSize >= 53 )  out.println("<td>"+WebUtil.printNumFormat(data.F53)+"</td>"); %>
          <% if( noteSize >= 54 )  out.println("<td>"+WebUtil.printNumFormat(data.F54)+"</td>"); %>
          <% if( noteSize >= 55 )  out.println("<td>"+WebUtil.printNumFormat(data.F55)+"</td>"); %>
          <% if( noteSize >= 56 )  out.println("<td>"+WebUtil.printNumFormat(data.F56)+"</td>"); %>
          <% if( noteSize >= 57 )  out.println("<td>"+WebUtil.printNumFormat(data.F57)+"</td>"); %>
          <% if( noteSize >= 58 )  out.println("<td>"+WebUtil.printNumFormat(data.F58)+"</td>"); %>
          <% if( noteSize >= 59 )  out.println("<td>"+WebUtil.printNumFormat(data.F59)+"</td>"); %>
          <% if( noteSize >= 60 )  out.println("<td>"+WebUtil.printNumFormat(data.F60)+"</td>"); %>
        </tr>
<%
                } //end for...
%>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.F.FCOMMON.0002'/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>

