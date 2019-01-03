<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 직무별/인정학력별
*   Program ID   : F08DeptDutyConfirmSchoolExcel.jsp
*   Description  : 직무별/인정학력별 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

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
    Vector DeptDutySchoolTitle_vt = (Vector)request.getAttribute("F08DeptDutySchoolTitle_vt");   //제목
    HashMap meta = (HashMap)request.getAttribute("meta");          //내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Org_Unit_Recognizable_Scholarship.xls");
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
    if ( DeptDutySchoolTitle_vt != null && DeptDutySchoolTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="500" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="2" class="title02">* <spring:message code='LABEL.F.FCOMMON.0001'/>/<spring:message code='LABEL.F.F08.0028'/><!-- Education(Admitted) --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="2" class="td09">
            &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td ></td>
        </tr>
        <tr><td height="17">&nbsp;※ <spring:message code='MSG.F.F00.0003'/><!-- Expatriate is not included. -->   </td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
          <td class="td03" colspan="2" style="width: 60;text-align: center;"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F08.0019'/><!-- Doctor`s<br>Course --></th>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F08.0021'/><!-- Master`s<br>Course --></th>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F08.0022'/><!-- University --></th>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F08.0023'/><!-- College --></th>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F08.0024'/><!-- High --></th>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F08.0026'/><!-- Middle --></th>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F08.0027'/><!-- Primary --></th>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
		</tr>
<%
	String temp = "";
	String tmpCode = "";
	for(int i = 0 ; i < DeptDutySchoolTitle_vt.size() ; i ++){
		F08DeptDutySchoolTitleGlobalData entity = (F08DeptDutySchoolTitleGlobalData) DeptDutySchoolTitle_vt
					.get(i);
%>
	<tr>
		<%
			if(!temp.equals(entity.STEXT) || !tmpCode.equals(entity.OBJID)){
		%>
		<td rowspan="<%=meta.get(entity.STEXT + entity.OBJID) %>" class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"td05" %>' <%=entity.STEXT.equals("TOTAL")?"colspan='2'":""%> style="text-align: <%=entity.STEXT.equals("TOTAL")?"center":"left"%>;vertical-align: text-top;" nowrap>
			<%
				if(entity.ZLEVEL.equals(""))
					entity.ZLEVEL = "0";
				//for( int j = 0 ; j < Integer.parseInt(entity.ZLEVEL); j ++){
			%>
				&nbsp;&nbsp;&nbsp;&nbsp;
			<%
				//}
			%>
			<%=entity.STEXT %>
		</td>
		<%
			}if(!entity.STEXT.equals("TOTAL")){
		%>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"td05" %>' style="text-align: left" nowrap="nowrap" width="60">
		&nbsp;&nbsp;<%=entity.JIKGT%>
		</td>
		<%} %>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F1)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F2)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F3)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F4)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F5)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F6)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F7)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F8)%>
		</td>
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


