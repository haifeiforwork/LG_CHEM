<%/***************************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Continuous
*   Program ID   		: F06DeptPositionCalssServiceExcel.jsp
*   Description  		: 소속별/직급별 평균근속 Excel 저장을 위한 jsp 파일
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

    WebUserData user = (WebUserData)session.getAttribute("user");         	// 세션
    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"));			// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));   // 부서명

    Vector F06DeptServiceTitle_vt = (Vector)request.getAttribute("F06DeptServiceTitle_vt");   		// 제목

    HashMap meta = (HashMap)request.getAttribute("meta");          											// 내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition", "attachment;filename=Org_Unit_Continuous.xls");
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
    if (F06DeptServiceTitle_vt != null && F06DeptServiceTitle_vt.size() > 0 ) {

        // 전체 테이블 크기 조절.
        int tableSize = 0;
        //tableSize = F06DeptServiceTitle_vt.size()*50 + 250;
%>
<table width="500" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colsapn="2" class="title02">* <spring:message code='LABEL.F.FCOMMON.0001'/>/<spring:message code='LABEL.F.F06.0009'/><!-- Length of Service --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colsapn="2" class="td09">&nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %>
          </td>
        </tr>
        <tr><td height="17">&nbsp;※ <spring:message code='MSG.F.F00.0003'/><!-- Expatriate and Contractor is not included. -->   </td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
   <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" align="left" width="300">
        <tr>
          <td colspan="2" style="text-align:center"><spring:message code='LABEL.F.FCOMMON.0001'/></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F06.0001'/><!-- 1 YR.Under --></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F06.0002'/><!-- 1~2 YR. --></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F06.0003'/><!-- 2~3 YR. --></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F06.0004'/><!-- 3~5 YR. --></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F06.0005'/><!-- 5~7 YR. --></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F06.0006'/><!-- 7~9 YR. --></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F06.0007'/><!-- 9~11 YR. --></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F06.0008'/><!-- 11 YR.Over --></td>
          <td width="25" style="text-align:center"><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></td>
		</tr>
<%
	String temp = "";
    String tmpCode = "";
	for (int i = 0 ; i < F06DeptServiceTitle_vt.size() ; i ++) {
		F06DeptPositionClassServiceTitleGlobalData entity = (F06DeptPositionClassServiceTitleGlobalData) F06DeptServiceTitle_vt.get(i);
%>
	<tr>
		<%
			if ((!temp.equals(entity.STEXT)) || (!tmpCode.equals(entity.OBJID))) {
            //내용 타이틀 병합.
            int noteCnt     = 1;
            int setCnt       = 0;

             for( int inx = i; inx < F06DeptServiceTitle_vt.size(); inx++ ){
             	F06DeptPositionClassServiceTitleGlobalData dataTitl = (F06DeptPositionClassServiceTitleGlobalData)F06DeptServiceTitle_vt.get(inx);

                 //병합을 위한 비교.
                 if( !dataTitl.JIKGT.equals("Sub-sum") ){
                     noteCnt++;
                 }else{
                     break;
                 } //end if
             } //end for.
		%>
		<td rowspan="<%=noteCnt%>" class='<%= entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"td05" %>' <%= entity.STEXT.equals("TOTAL")?"colspan='2'":"" %> style="text-align: <%= entity.STEXT.equals("TOTAL")?"center":"left" %>;vertical-align: text-top;" nowrap>
			<%
				if (entity.ZLEVEL.equals(""))
					entity.ZLEVEL = "0";
				//for( int j = 0 ; j < Integer.parseInt(entity.ZLEVEL); j ++){

				//}
			%>
			<%= entity.STEXT %>
		</td>
		<%
			}

			if (!entity.STEXT.equals("TOTAL")) {
		%>
		<td width="50">
		<%= entity.JIKGT %>
		</td>
		<%} %>
		<td><%= WebUtil.printNumFormat(entity.F1) %></td>
		<td><%= WebUtil.printNumFormat(entity.F2) %></td>
		<td><%= WebUtil.printNumFormat(entity.F3) %></td>
		<td><%= WebUtil.printNumFormat(entity.F4) %></td>
		<td><%= WebUtil.printNumFormat(entity.F5) %></td>
		<td><%= WebUtil.printNumFormat(entity.F6) %></td>
		<td><%= WebUtil.printNumFormat(entity.F7) %></td>
		<td><%= WebUtil.printNumFormat(entity.F8) %></td>
		<td><%= WebUtil.printNumFormat(entity.F9) %></td>
	</tr>
<%
		temp = entity.STEXT;
        tmpCode = entity.OBJID;
	}
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

