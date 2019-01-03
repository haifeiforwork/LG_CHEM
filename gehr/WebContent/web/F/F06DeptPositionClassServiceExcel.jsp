<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 소속별/직급별 평균근속
*   Program ID   : F06DeptPositionCalssServiceExcel.jsp
*   Description  : 소속별/직급별 평균근속 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :2017-07-06  [CSR ID:3427173] 직위/직급(호칭) 변경에 따른 소스 수정
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
    Vector F06DeptServiceTitle_vt = (Vector)request.getAttribute("F06DeptServiceTitle_vt");   //제목
    Vector F06DeptServiceNote_vt  = (Vector)request.getAttribute("F06DeptServiceNote_vt");    //내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptPositionClassService.xls");
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
    if ( F06DeptServiceTitle_vt != null && F06DeptServiceTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
        tableSize = F06DeptServiceTitle_vt.size()*50 + 250;
%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colsapn="2" class="title02">* <spring:message code='LABEL.F.F43.0010'/><!-- 소속 -->/<spring:message code='TAB.COMMON.0071'/><!-- 직급별 --> <spring:message code='TAB.COMMON.0076'/><!-- 평균근속 --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colsapn="2" class="td09">
            &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
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
          <td width="250" rowspan="2" class="td03"><spring:message code='LABEL.F.F04.0001'/></td>
<%
            String tempTitleCode = ""; //임시 타이틀코드
            String tempTitleName = ""; //임시 타이틀명
            int    tempCnt       = 1;

            //상위 타이틀.
            for( int h = 0; h < F06DeptServiceTitle_vt.size(); h++ ){
                F06DeptPositionClassServiceTitleData titleData = (F06DeptPositionClassServiceTitleData)F06DeptServiceTitle_vt.get(h);

                if( titleData.PERSK.equals(tempTitleCode) ){
                    tempCnt++;
                }else{
                    if( h > 0 ){
%>
          <td class="td03" colspan="<%=tempCnt%>" ><%=tempTitleName%></td>
<%                          tempCnt = 1;
                    }
                }
                tempTitleCode = titleData.PERSK;
                tempTitleName = titleData.PTEXT;
            }//end for
%>
          <td width="50" class="td03" rowspan="2"><spring:message code='LABEL.F.F04.0008'/><!-- 평균 --></td>
        </tr>
        <tr>
<%
            //하위 타이틀.
            for( int k = 0; k < F06DeptServiceTitle_vt.size()-1; k++ ){
                F06DeptPositionClassServiceTitleData titleData = (F06DeptPositionClassServiceTitleData)F06DeptServiceTitle_vt.get(k);
%>
          <td width="50" class="td03" ><%=titleData.TRFGR%></td>
<%
            }//end for

            //타이틀에 맞추어 내용영역 보여주기위한 개수.
            int noteSize = F06DeptServiceTitle_vt.size();
            //내용.
            for( int i = 0; i < F06DeptServiceNote_vt.size(); i++ ){
                F06DeptPositionClassServiceNoteData data = (F06DeptPositionClassServiceNoteData)F06DeptServiceNote_vt.get(i);
%>

<!-- [CSR ID:3427173] 직위/직급(호칭) 변경에 따른 소스 수정  -->
        <tr>
          <td><%=data.STEXT%></td>
          <td style='mso-number-format:"00\.00";'><%=WebUtil.printNumFormat(data.F1,2)%></td>
          <td style='mso-number-format:"00\.00";'><%=WebUtil.printNumFormat(data.F2,2)%></td>
          <td style='mso-number-format:"00\.00";'><%=WebUtil.printNumFormat(data.F3,2)%></td>
          <% if( noteSize >= 4 )   {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F4 ,2)%></td><%}%>
          <% if( noteSize >= 5 )   {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F5 ,2)%></td><%}%>
          <% if( noteSize >= 6 )   {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F6 ,2)%></td><%}%>
          <% if( noteSize >= 7 )   {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F7 ,2)%></td><%}%>
          <% if( noteSize >= 8 )   {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F8 ,2)%></td><%}%>
          <% if( noteSize >= 9 )   {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F9 ,2)%></td><%}%>
          <% if( noteSize >= 10 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F10,2)%></td><%}%>
          <% if( noteSize >= 11 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F11,2)%></td><%}%>
          <% if( noteSize >= 12 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F12,2)%></td><%}%>
          <% if( noteSize >= 13 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F13,2)%></td><%}%>
          <% if( noteSize >= 14 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F14,2)%></td><%}%>
          <% if( noteSize >= 15 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F15,2)%></td><%}%>
          <% if( noteSize >= 16 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F16,2)%></td><%}%>
          <% if( noteSize >= 17 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F17,2)%></td><%}%>
          <% if( noteSize >= 18 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F18,2)%></td><%}%>
          <% if( noteSize >= 19 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F19,2)%></td><%}%>
          <% if( noteSize >= 20 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F20,2)%></td><%}%>
          <% if( noteSize >= 21 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F21,2)%></td><%}%>
          <% if( noteSize >= 22 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F22,2)%></td><%}%>
          <% if( noteSize >= 23 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F23,2)%></td><%}%>
          <% if( noteSize >= 24 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F24,2)%></td><%}%>
          <% if( noteSize >= 25 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F25,2)%></td><%}%>
          <% if( noteSize >= 26 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F26,2)%></td><%}%>
          <% if( noteSize >= 27 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F27,2)%></td><%}%>
          <% if( noteSize >= 28 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F28,2)%></td><%}%>
          <% if( noteSize >= 29 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F29,2)%></td><%}%>
          <% if( noteSize >= 30 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F30,2)%></td><%}%>
          <% if( noteSize >= 31 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F31,2)%></td><%}%>
          <% if( noteSize >= 32 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F32,2)%></td><%}%>
          <% if( noteSize >= 33 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F33,2)%></td><%}%>
          <% if( noteSize >= 34 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F34,2)%></td><%}%>
          <% if( noteSize >= 35 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F35,2)%></td><%}%>
          <% if( noteSize >= 36 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F36,2)%></td><%}%>
          <% if( noteSize >= 37 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F37,2)%></td><%}%>
          <% if( noteSize >= 38 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F38,2)%></td><%}%>
          <% if( noteSize >= 39 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F39,2)%></td><%}%>
          <% if( noteSize >= 40 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F40,2)%></td><%}%>
          <% if( noteSize >= 41 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F41,2)%></td><%}%>
          <% if( noteSize >= 42 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F42,2)%></td><%}%>
          <% if( noteSize >= 43 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F43,2)%></td><%}%>
          <% if( noteSize >= 44 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F44,2)%></td><%}%>
          <% if( noteSize >= 45 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F45,2)%></td><%}%>
          <% if( noteSize >= 46 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F46,2)%></td><%}%>
          <% if( noteSize >= 47 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F47,2)%></td><%}%>
          <% if( noteSize >= 48 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F48,2)%></td><%}%>
          <% if( noteSize >= 49 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F49,2)%></td><%}%>
          <% if( noteSize >= 50 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F50,2)%></td><%}%>
          <% if( noteSize >= 51 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F51,2)%></td><%}%>
          <% if( noteSize >= 52 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F52,2)%></td><%}%>
          <% if( noteSize >= 53 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F53,2)%></td><%}%>
          <% if( noteSize >= 54 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F54,2)%></td><%}%>
          <% if( noteSize >= 55 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F55,2)%></td><%}%>
          <% if( noteSize >= 56 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F56,2)%></td><%}%>
          <% if( noteSize >= 57 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F57,2)%></td><%}%>
          <% if( noteSize >= 58 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F58,2)%></td><%}%>
          <% if( noteSize >= 59 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F59,2)%></td><%}%>
          <% if( noteSize >= 60 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F60,2)%></td><%}%>
          <% if( noteSize >= 61 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F61,2)%></td><%}%>
          <% if( noteSize >= 62 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F62,2)%></td><%}%>
          <% if( noteSize >= 63 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F63,2)%></td><%}%>
          <% if( noteSize >= 64 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F64,2)%></td><%}%>
          <% if( noteSize >= 65 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F65,2)%></td><%}%>
          <% if( noteSize >= 66 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F66,2)%></td><%}%>
          <% if( noteSize >= 67 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F67,2)%></td><%}%>
          <% if( noteSize >= 68 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F68,2)%></td><%}%>
          <% if( noteSize >= 69 )  {%><td style='mso-number-format:"00\.00";'><%= WebUtil.printNumFormat(data.F69,2)%></td><%}%>
          
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
    <td  class="td04" align="center" height="25" ><spring:message code="MSG.F.FCOMMON.0002"/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>

