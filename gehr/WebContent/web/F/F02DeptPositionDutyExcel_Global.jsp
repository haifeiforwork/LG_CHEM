<%/***************************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Job Family
*   Program ID   		: F02DeptPositionDutyExcel.jsp
*   Description  		: 소속별/직무별 인원현황 Excel 저장을 위한 jsp 파일
*   Note         		:
*   Creation     		:
*	  Update				:
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%
	request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");           	// 세션
    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"));          	// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));		// 부서명

    Vector F02DeptPositionDutyTitle_vt = (Vector)request.getAttribute("F02DeptPositionDutyTitle_vt");   // 제목
    Vector F02DeptPositionDutyNote_vt  = (Vector)request.getAttribute("F02DeptPositionDutyNote_vt");	// 내용

    HashMap meta = (HashMap)request.getAttribute("meta");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition", "attachment;filename=Org_Unit_Job_Family.xls");
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
    if (F02DeptPositionDutyTitle_vt != null && F02DeptPositionDutyTitle_vt.size() > 0) {

        // 전체 테이블 크기 조절.
        int tableSize = 0;
        tableSize = F02DeptPositionDutyTitle_vt.size()*60 + 250;

%>
<table width="<%= tableSize %>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* Org.Unit/Job Family</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td width="50%" class="td09">&nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %></td>
          <td></td>
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
          <td style="text-align:center" rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team --></td>
<%
		String tmp = "";
		for (int k = 0; k < F02DeptPositionDutyTitle_vt.size(); k++) {
			F02DeptPositionDutyTitleGlobalData entity = (F02DeptPositionDutyTitleGlobalData)F02DeptPositionDutyTitle_vt.get(k);
			int cols = ((Integer)meta.get(entity.PERST)).intValue();
			if (!tmp.equals(entity.PERST))
				if (cols != 1 || entity.PERST.equals("EXP.")) {
%>
					<td colspan="<%= cols %>" style="text-align:center" nowrap><%= entity.PERST %></td>
<%
				} else if (cols == 1) {
%>
					<td style="text-align:center" rowspan="2" nowrap width="60"><%= entity.PERST %></td>
<%
				}
			tmp = entity.PERST;
		}
%>
        </tr>
        <tr>
<%
        // 타이틀.
        for (int k = 0; k < F02DeptPositionDutyTitle_vt.size(); k++) {
        	F02DeptPositionDutyTitleGlobalData titleData = (F02DeptPositionDutyTitleGlobalData)F02DeptPositionDutyTitle_vt.get(k);
 			int cols = ((Integer)meta.get(titleData.PERST)).intValue();
            if (cols != 1 || titleData.PERST.equals("EXP.")) {
%>
          <td width="60" style="text-align:center" ><%= titleData.JIKGT %></td>
<%
			}
        }//end for
%>
	</tr>
<%
        // 타이틀에 맞추어 내용영역 보여주기위한 개수.
        int noteSize = F02DeptPositionDutyTitle_vt.size();

        // 내용.
        for (int i = 0; i < F02DeptPositionDutyNote_vt.size(); i++) {
            F02DeptPositionDutyNoteGlobalData data = (F02DeptPositionDutyNoteGlobalData)F02DeptPositionDutyNote_vt.get(i);

            String strBlank = "";
            String titlClass = "";
            String noteClass = "";
            int blankSize = Integer.parseInt(WebUtil.nvl(data.ZLEVEL, "0"));

            // 클래스 설정.
  			if (!data.STEXT.equals("TOTAL")) {
                titlClass = "class=td09";
                noteClass = "class=td05";
            } else {
                titlClass = "class=td11 style='text-align:center'";
                noteClass = "class=td12";
            }

            // 부서명 앞에 공백넣기.
            for (int h = 0; h < blankSize; h++) {
                strBlank = strBlank+"&nbsp;&nbsp;";
            }
%>
        <tr>
          <td <%= titlClass %>><%= strBlank %><%= data.STEXT %></td>
          <td <%= noteClass %>><%= data.F1 %></td>
          <td <%= noteClass %>><%= data.F2 %></td>
          <% if (noteSize >= 3)   out.println("<td>"+WebUtil.printNumFormat(data.F3) +"</td>"); %>
          <% if (noteSize >= 4)   out.println("<td>"+WebUtil.printNumFormat(data.F4) +"</td>"); %>
          <% if (noteSize >= 5)   out.println("<td>"+WebUtil.printNumFormat(data.F5) +"</td>"); %>
          <% if (noteSize >= 6)   out.println("<td>"+WebUtil.printNumFormat(data.F6) +"</td>"); %>
          <% if (noteSize >= 7)   out.println("<td>"+WebUtil.printNumFormat(data.F7) +"</td>"); %>
          <% if (noteSize >= 8)   out.println("<td>"+WebUtil.printNumFormat(data.F8) +"</td>"); %>
          <% if (noteSize >= 9)   out.println("<td>"+WebUtil.printNumFormat(data.F9) +"</td>"); %>
          <% if (noteSize >= 10)  out.println("<td>"+WebUtil.printNumFormat(data.F10)+"</td>"); %>
          <% if (noteSize >= 11)  out.println("<td>"+WebUtil.printNumFormat(data.F11)+"</td>"); %>
          <% if (noteSize >= 12)  out.println("<td>"+WebUtil.printNumFormat(data.F12)+"</td>"); %>
          <% if (noteSize >= 13)  out.println("<td>"+WebUtil.printNumFormat(data.F13)+"</td>"); %>
          <% if (noteSize >= 14)  out.println("<td>"+WebUtil.printNumFormat(data.F14)+"</td>"); %>
          <% if (noteSize >= 15)  out.println("<td>"+WebUtil.printNumFormat(data.F15)+"</td>"); %>
          <% if (noteSize >= 16)  out.println("<td>"+WebUtil.printNumFormat(data.F16)+"</td>"); %>
          <% if (noteSize >= 17)  out.println("<td>"+WebUtil.printNumFormat(data.F17)+"</td>"); %>
          <% if (noteSize >= 18)  out.println("<td>"+WebUtil.printNumFormat(data.F18)+"</td>"); %>
          <% if (noteSize >= 19)  out.println("<td>"+WebUtil.printNumFormat(data.F19)+"</td>"); %>
          <% if (noteSize >= 20)  out.println("<td>"+WebUtil.printNumFormat(data.F20)+"</td>"); %>
        </tr>
<%
                } //end for
%>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>

<%
    } else {
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.F.FCOMMON.0002'/></td>

  </tr>
</table>
<%
    } //end if
%>
</form>
</body>
</html>

