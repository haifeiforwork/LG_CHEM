<%/**********************************************************************************
*	  System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Level (Staff Present State Detail)
*   Program ID   		: F00DeptDetailListExcel.jsp
*   Description  		: 인원현황 각각의 상세화면 Excel 저장을 위한 jsp 파일
*   Note         		: 없음
*   Creation     		:
*   Update       		:
***********************************************************************************/%>

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
    WebUserData user	= (WebUserData)session.getAttribute("user");                            			//세션

    String deptId       	= WebUtil.nvl(request.getParameter("hdn_deptId"));                  				//부서코드
    String deptNm       	= (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  			//부서명
    Vector F00DeptDetailListData_vt  = (Vector)request.getAttribute("F00DeptDetailListData_vt");  //내용

    String gubun = request.getParameter("hdn_gubun");

    String fileName = "";
    String [][]hardList = {
    						{"21", "Org_Unit_Level"},
    					   	{"10", "Org_Unit_Job_Family"},
    					   	{"16", "Working_area_Level"},
    					   	{"17", "Job_Family_Level"},
    					   	{"18", "Responsibility_of_Office_Level"},
    					   	{"11", "Org_Unit_Continuous"},
    					   	{"12", "Org_Unit_Age"},
    					   	{"13", "Org_Unit_Recognizable_Scholarship"},
    					   	{"14", "Org_Unit_Final_Scholarship"},
    					   	{"15", "Org_Unit_Ethnic_Group"}
    					   };

    for(int i = 0 ; i < hardList.length ; i ++ ){
    	if(hardList[i][0].equals(gubun)){
    		fileName = hardList[i][1];
    	}
    }
    fileName += "_DetailList";

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename="+ fileName +".xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*--------------------------------------------------------------------------- */
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
          <td class="title02">* <spring:message code='LABEL.F.F00.0001'/><!-- Staff Present State Detail --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="10" class="td09">
          </td>
          <td class="td08">&lt;Total Count <%=F00DeptDetailListData_vt.size()%>&gt;&nbsp;</td>
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
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0029'/><!-- Corp. --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.COMMON.0005'/><!-- Pers.No --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.COMMON.0004'/><!-- Name --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F00.0004'/><!-- Org.Unit --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0030'/><!-- Emp. Subgroup --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0031'/><!-- Res. of Office --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0032'/><!-- Title of Level --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0033'/><!-- Level --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0034'/><!-- Annual --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0035'/><!-- Job Title --></td>
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0036'/><!-- Hiring Date --></td>
          <!-- <td class="td03" nowrap style="text-align: center">Birth Date</td> -->
          <td class="td03" nowrap style="text-align: center"><spring:message code='LABEL.F.F01.0037'/><!-- Area --></td>
        </tr>

<%
        //내용.
        for( int i = 0; i < F00DeptDetailListData_vt.size(); i++ ){
            F00DeptDetailListGlobalData data = (F00DeptDetailListGlobalData)F00DeptDetailListData_vt.get(i);
%>
        <tr align="center">
          <td class="td09" nowrap style="text-align: center">&nbsp;<%= data.PBTXT %>&nbsp;</td>
          <td class="td09" nowrap style='text-align: center;mso-number-format:"\@";'>&nbsp;<%= data.PERNR %>&nbsp;</td>
          <td class="td09" nowrap style="text-align: left">&nbsp;<%= data.ENAME %>&nbsp;</td>
          <td class="td09" nowrap style="text-align: left">&nbsp;<%= data.STEXT %>&nbsp;</td>
          <td class="td09" nowrap style="text-align: left">&nbsp;<%= data.PTEXT %>&nbsp;</td>
          <td class="td09" nowrap style="text-align: left">&nbsp;<%= data.JIKKT %>&nbsp;</td>
          <td class="td09" nowrap style="text-align: center">&nbsp;<%= data.JIKWT %>&nbsp;</td>
          <td class="td09" nowrap style="text-align: center">&nbsp;<%= data.JIKCT %>&nbsp;</td>
          <td class="td09" nowrap style="text-align: center">&nbsp;<%= data.ANNUL %>&nbsp;&nbsp;</td>
          <td class="td09" nowrap style="text-align: left">&nbsp;<%= data.STELL_TEXT %>&nbsp;</td>
          <td class="td04" nowrap style="text-align: center">&nbsp;<%= (data.DAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT) %>&nbsp;</td>
          <!-- <td class="td04" nowrap style="text-align: center">&nbsp;<%= (data.GBDAT).equals("0000-00-00") ?  "" : WebUtil.printDate(data.GBDAT) %>&nbsp;</td> -->
          <td class="td09" nowrap style="text-align: left">&nbsp;<%= data.BTEXT %>&nbsp;</td>
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
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.F.FCOMMON.0002'/></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>

