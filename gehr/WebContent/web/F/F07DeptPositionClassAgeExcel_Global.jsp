<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 소속별/직급별 평균연령
*   Program ID   : F07DeptPositionClassAgeExcel_Global.jsp
*   Description  : 소속별/직급별 평균연령 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/%>
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
    WebUserData user    = (WebUserData)session.getAttribute("user");                            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드

    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  //부서명
    Vector F07DeptAgeTitle_vt = (Vector)request.getAttribute("F07DeptAgeTitle_vt");         //제목
   	HashMap meta = (HashMap)request.getAttribute("meta");          //내용           //내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Org_Unit_Age.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");/*KSC5601*/
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
<input type="hidden" name="hdn_excel"   value="">

<%
    if ( F07DeptAgeTitle_vt != null && F07DeptAgeTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="500" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colsapn="2" class="title02">* <spring:message code='LABEL.F.FCOMMON.0001'/>/<spring:message code='LABEL.F.F06.0018'/><!-- Age --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colsapn="2" class="td09">
            &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
        </tr>
        <tr><td height="17">&nbsp;※ <spring:message code='MSG.F.F00.0003'/><!-- Expatriate and Contractor is not included. -->  </td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
		<table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
          <td class="td03" colspan="2" style="width: 70;text-align: center;"><spring:message code='LABEL.F.FCOMMON.0001'/></td>
          <td class="td03" style="width: 70;text-align: center;"><spring:message code='LABEL.F.F06.0010'/><!-- 18 Age.Under --></td>
          <td class="td03" style="width: 70;text-align: center;"><spring:message code='LABEL.F.F06.0011'/><!-- 18~19 Age. --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F06.0012'/><!-- 20~24 Age. --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F06.0013'/><!-- 25~29 Age. --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F06.0014'/><!-- 30~34 Age. --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F06.0015'/><!-- 35~39 Age. --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F06.0016'/><!-- 40 Age.Over --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></td>
		</tr>
<%
	String temp = "";
	String tmpCode = "";
	for(int i = 0 ; i < F07DeptAgeTitle_vt.size() ; i ++){
		F07DeptPositionClassAgeTitleGlobalData entity = (F07DeptPositionClassAgeTitleGlobalData) F07DeptAgeTitle_vt.get(i);
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
		&nbsp;&nbsp;&nbsp;&nbsp;<%=entity.JIKGT%>
		</td>
		<%} %>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: center;">
		<%=WebUtil.printNumFormat(entity.F1)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: center;">
		<%=WebUtil.printNumFormat(entity.F2)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: center;">
		<%=WebUtil.printNumFormat(entity.F3)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: center;">
		<%=WebUtil.printNumFormat(entity.F4)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: center;">
		<%=WebUtil.printNumFormat(entity.F5)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: center;">
		<%=WebUtil.printNumFormat(entity.F6)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: center;">
		<%=WebUtil.printNumFormat(entity.F7)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: center;">
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

