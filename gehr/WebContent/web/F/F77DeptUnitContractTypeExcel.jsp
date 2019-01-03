<%/***************************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Contract Type
*   Program ID   		: F77DeptUnitContractTypeExcel.jsp
*   Description  		: 부서별 계약 유형 정보 Excel 저장을 위한 jsp 파일
*   Note         		: 없음
*   Creation     		:
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%
	request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");            	// 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"));            	// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));		// 부서명

    Vector F77DeptUnitContractTypeTitle_vt = (Vector)request.getAttribute("F77DeptUnitContractTypeTitle_vt");   // 제목
    Vector F77DeptUnitContractTypeNote_vt = (Vector)request.getAttribute("F77DeptUnitContractTypeNote_vt");   // 내용

    HashMap meta = (HashMap)request.getAttribute("meta");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Dept_Unit_Contract_Type.xls");
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
    if (F77DeptUnitContractTypeTitle_vt != null && F77DeptUnitContractTypeTitle_vt.size() > 0) {

        // 전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="<%= tableSize %>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="2" class="title02">* <spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit -->/<spring:message code='LABEL.F.F79.0016'/><!-- Contract Type --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="2" class="td09">&nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %></td>
          <td ></td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td valign="top" width="">
		<table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
        	<td class="td03"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --></td>
			<%
				String tmp = "";
		        // 타이틀.
		        for (int k = 0; k < F77DeptUnitContractTypeTitle_vt.size(); k++) {
		        	F77DeptUnitContractTypeTitleData titleData = (F77DeptUnitContractTypeTitleData)F77DeptUnitContractTypeTitle_vt.get(k);
		 			int cols = ((Integer)meta.get(titleData.CLSFY)).intValue();
			%>
        	<td width="70" class="td03" nowrap>&nbsp;&nbsp;<%= titleData.CTTXT %>&nbsp;&nbsp;</td>
			<%
				}
			%>
        </tr>
		<%
			int tok = 0;
			for (int i = 0 ; i < F77DeptUnitContractTypeNote_vt.size() ; i ++) {
				F77DeptUnitContractTypeNoteData entity = (F77DeptUnitContractTypeNoteData)F77DeptUnitContractTypeNote_vt.get(i);

	       		if ((entity.ZLEVEL != null && !entity.ZLEVEL.equals("") && Integer.parseInt(entity.ZLEVEL) != 0 && Integer.parseInt(entity.ZLEVEL) < tok) || i == 0) {
					tok = Integer.parseInt(entity.ZLEVEL);
	       		}

			}

	        // 타이틀에 맞추어 내용영역 보여주기위한 개수.
	        int noteSize = F77DeptUnitContractTypeTitle_vt.size();

	        // 내용.
			for (int i = 0; i < F77DeptUnitContractTypeNote_vt.size(); i++) {
				F77DeptUnitContractTypeNoteData data = (F77DeptUnitContractTypeNoteData)F77DeptUnitContractTypeNote_vt.get(i);

			    String strBlank = "";
			    String titlClass = "";
			    String noteClass = "";
	            int blankSize = Integer.parseInt(WebUtil.nvl(data.ZLEVEL, "0"));

				int bstyle = 0 ;
	        	if (blankSize >= tok)
	        		bstyle = 5 * (blankSize - tok) + 10;

	            // 클래스 설정.
	            if (!data.STEXT.equals("TOTAL")) {
					titlClass = "class=td09_1 style='padding-left:"+ bstyle +"'";
					noteClass = "class=td05";
				} else {
	                titlClass = "class=td11 style='text-align:center;padding-left:"+ bstyle +"'";
	                noteClass = "class=td11";
				}
				// 부서명 앞에 공백넣기.
		%>
        <tr>
          <td <%= titlClass %>><%= strBlank %><%= data.STEXT %></td>
          <td <%= noteClass %>><%= WebUtil.printNumFormat(data.CNT01) %></td>
          <td <%= noteClass %>><%= WebUtil.printNumFormat(data.CNT02) %></td>
          <% if (noteSize >= 3)   out.println("<td>"+WebUtil.printNumFormat(data.CNT03) +"</td>"); %>
          <% if (noteSize >= 4)   out.println("<td>"+WebUtil.printNumFormat(data.CNT04) +"</td>"); %>
          <% if (noteSize >= 5)   out.println("<td>"+WebUtil.printNumFormat(data.CNT05) +"</td>"); %>
          <% if (noteSize >= 6)   out.println("<td>"+WebUtil.printNumFormat(data.CNT06) +"</td>"); %>
          <% if (noteSize >= 7)   out.println("<td>"+WebUtil.printNumFormat(data.CNT07) +"</td>"); %>
          <% if (noteSize >= 8)   out.println("<td>"+WebUtil.printNumFormat(data.CNT08) +"</td>"); %>
          <% if (noteSize >= 9)   out.println("<td>"+WebUtil.printNumFormat(data.CNT09) +"</td>"); %>
          <% if (noteSize >= 10)  out.println("<td>"+WebUtil.printNumFormat(data.CNT10)+"</td>"); %>
          <% if (noteSize >= 11)  out.println("<td>"+WebUtil.printNumFormat(data.CNT11)+"</td>"); %>
          <% if (noteSize >= 12)  out.println("<td>"+WebUtil.printNumFormat(data.CNT12)+"</td>"); %>
          <% if (noteSize >= 13)  out.println("<td>"+WebUtil.printNumFormat(data.CNT13)+"</td>"); %>
          <% if (noteSize >= 14)  out.println("<td>"+WebUtil.printNumFormat(data.CNT14)+"</td>"); %>
          <% if (noteSize >= 15)  out.println("<td>"+WebUtil.printNumFormat(data.CNT15)+"</td>"); %>
          <% if (noteSize >= 16)  out.println("<td>"+WebUtil.printNumFormat(data.CNT16)+"</td>"); %>
          <% if (noteSize >= 17)  out.println("<td>"+WebUtil.printNumFormat(data.CNT17)+"</td>"); %>
          <% if (noteSize >= 18)  out.println("<td>"+WebUtil.printNumFormat(data.CNT18)+"</td>"); %>
          <% if (noteSize >= 19)  out.println("<td>"+WebUtil.printNumFormat(data.CNT19)+"</td>"); %>
          <% if (noteSize >= 20)  out.println("<td>"+WebUtil.printNumFormat(data.CNT20)+"</td>"); %>
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
    } //end if.
%>
</form>
</body>
</html>
