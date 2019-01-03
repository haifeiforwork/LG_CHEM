<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 인원현황 각각의 상세화면
*   Program ID   : F00DeptDetailListExcel.jsp
*   Description  : 인원현황 각각의 상세화면 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
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
    Vector F00DeptDetailListData_vt  = (Vector)request.getAttribute("F00DeptDetailListData_vt");    //내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptDetailList.xls");
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
    if ( F00DeptDetailListData_vt != null && F00DeptDetailListData_vt.size() > 0 ) {
%>
<table width="900" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* <spring:message code='LABEL.F.F00.0001'/><!-- 인원현황 상세목록 --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="13" class="td09">
            &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td class="td08">(총 <%=F00DeptDetailListData_vt.size()%> 건)&nbsp;</td>
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
          <td class="td03" ><spring:message code='LABEL.F.F00.0002'/><!-- 사번 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0003'/><!-- 이름 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0004'/><!-- 소속 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0005'/><!-- 소속약어 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0006'/><!-- 신분 --></td>
          <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
          <%--<td class="td03" ><spring:message code='LABEL.F.F00.0007'/><!-- 직위 --></td> --%>
          <td class="td03" ><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
          <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
          <td class="td03" ><spring:message code='LABEL.F.F00.0008'/><!-- 직책 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0009'/><!-- 직급 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0010'/><!-- 호봉 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0011'/><!-- 년차 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0012'/><!-- 직무 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0013'/><!-- 입사일자 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0014'/><!-- 생년월일 --></td>
          <td class="td03" ><spring:message code='LABEL.F.F00.0015'/><!-- 근무지 --></td>
        </tr>
<%
        //내용.
        for( int i = 0; i < F00DeptDetailListData_vt.size(); i++ ){
            F00DeptDetailListData data = (F00DeptDetailListData)F00DeptDetailListData_vt.get(i);
%>
        <tr align="center">
          <td style='mso-number-format:"\@";'><%= data.PERNR    %></td>
          <td class="td04"><%= data.ENAME    %></td>
          <td class="td04"><%= data.STEXT    %></td>
          <td class="td04"><%= data.ORGTX    %></td>
          <td class="td04"><%= data.PTEXT    %></td>
          <td class="td04"><%= data.TITEL    %></td>
          <td class="td04"><%= data.TITL2    %></td>
          <td class="td04"><%= data.TRFGR    %></td>
          <td class="td04"><%= data.TRFST    %></td>
          <td class="td04"><%= data.VGLST    %></td>
          <td class="td04"><%= data.STELL_TEXT %></td>
          <td class="td04"><%= (data.DAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT) %></td>
          <td class="td04"><%= (data.GBDAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.GBDAT) %></td>
          <td class="td04"><%= data.BTEXT    %></td>
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

