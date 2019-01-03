<%/***************************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Quota Plan/Result Status
*   Program ID   		: F79QuotaPlanResultStatusExcel.jsp
*   Description  		: 월별/조직별 인원계획 대비 실적 현황 정보 Excel 저장을 위한 jsp 파일 (USA - LGCPI(G400))
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

    WebUserData user = (WebUserData)session.getAttribute("user");            		// 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"));            		// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));			// 부서명
    String searchYear = WebUtil.nvl((String)request.getAttribute("searchYear"));	// 대상년월

    Vector F79QuotaPlanResultStatusData_vt = (Vector)request.getAttribute("F79QuotaPlanResultStatusData_vt");   	// 내용

    List list = (List)request.getAttribute("metaNote");
    HashMap meta = null;
    HashMap meta1 = null;
    if (list != null) {
	    meta = (HashMap)list.get(0);
	    meta1 = (HashMap)list.get(1);
	}

    F79QuotaPlanResultStatusData total = new F79QuotaPlanResultStatusData();
    AppUtilEurp.initEntity(total,"0");
    if (F79QuotaPlanResultStatusData_vt != null && F79QuotaPlanResultStatusData_vt.size() > 0)
	    total = (F79QuotaPlanResultStatusData)F79QuotaPlanResultStatusData_vt.get(F79QuotaPlanResultStatusData_vt.size() - 1 );
    AppUtilEurp.nvlEntity(total);

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Quota_Plan_Result_Status.xls");
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
    if (F79QuotaPlanResultStatusData_vt != null && F79QuotaPlanResultStatusData_vt.size() > 0) {

        // 전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="<%= tableSize %>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="2" class="title02">* <spring:message code='LABEL.F.F79.0017'/><!-- Quota Plan -->/<spring:message code='LABEL.F.F79.0018'/><!-- Result Status --></td>
        </tr>
        <tr><td colspan="2" height="10"></td></tr>
        <tr>
          <td colspan="2" class="td09">&nbsp;<spring:message code='LABEL.F.F42.0052'/><!-- Year --> : <%= searchYear %></td>
          <td></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="2" class="td09">&nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %></td>
          <td></td>
        </tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td valign="top" width="">
		<table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
        	<td class="td03" rowspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --></td>
        	<td class="td03" rowspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0001'/><!-- Contract Type Text --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0002'/><!-- January --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0003'/><!-- February --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0004'/><!-- March --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0005'/><!-- April --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0006'/><!-- May --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0007'/><!-- June --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0008'/><!-- July --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0009'/><!-- August --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0010'/><!-- September --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0011'/><!-- October --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0012'/><!-- November --></td>
          	<td class="td03" width="80" colspan="2" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0013'/><!-- December --></td>
        </tr>
        <tr>
        	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></td>
          	<td class="td03" width="40" style="text-align:center" nowrap><spring:message code='LABEL.F.F79.0015'/><!-- Result --></td>
        </tr>
        <%
        	String temp = "";
        	String temp1 = "";
        	//String temp2 = "";

        	for (int i = 0; i < F79QuotaPlanResultStatusData_vt.size(); i ++) {
        		F79QuotaPlanResultStatusData entity = (F79QuotaPlanResultStatusData)F79QuotaPlanResultStatusData_vt.get(i);
        %>
        <tr>
        	<%
        		if (!temp.equals(entity.ORGTX)) {
        	%>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05"%>" rowspan="<%= meta.get(entity.ORGTX) %>" nowrap colspan="<%=  entity.ORGTX.equals("TOTAL")?"2":"0" %>" style="text-align:<%=  entity.ORGTX.equals("TOTAL")?"center":"left" %>">&nbsp;&nbsp;&nbsp;&nbsp;<%=  entity.ORGTX %></td>

        	<%
        		}
        		if (!entity.ORGTX.equals("TOTAL")) {
        			if (!temp.equals(entity.ORGTX) || !temp1.equals(entity.CTTXT)/*&& !temp2.equals(entity.CTTXT) */) {
        				int rows = ((Integer)meta1.get(entity.ORGTX + entity.CTTXT)).intValue();

        	%>
        	<td class="<%=  entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" nowrap="nowrap" rowspan="<%=  rows %>" style="text-align:left">&nbsp;&nbsp;&nbsp;&nbsp;<%=  entity.CTTXT %></td>
			<%
					}
        		}
			%>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN01.equals("0") ? "" : entity.PLN01 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT01.equals("0") ? "" : entity.RLT01 %></td>
			<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN02.equals("0") ? "" : entity.PLN02 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT02.equals("0") ? "" : entity.RLT02 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN03.equals("0") ? "" : entity.PLN03 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT03.equals("0") ? "" : entity.RLT03 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN04.equals("0") ? "" : entity.PLN04 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT04.equals("0") ? "" : entity.RLT04 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN05.equals("0") ? "" : entity.PLN05 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT05.equals("0") ? "" : entity.RLT05 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN06.equals("0") ? "" : entity.PLN06 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT06.equals("0") ? "" : entity.RLT06 %></td>
			<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN07.equals("0") ? "" : entity.PLN07 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT07.equals("0") ? "" : entity.RLT07 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN08.equals("0") ? "" : entity.PLN08 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT08.equals("0") ? "" : entity.RLT08 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN09.equals("0") ? "" : entity.PLN09 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT09.equals("0") ? "" : entity.RLT09 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN10.equals("0") ? "" : entity.PLN10 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT10.equals("0") ? "" : entity.RLT10 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN11.equals("0") ? "" : entity.PLN11 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT11.equals("0") ? "" : entity.RLT11 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.PLN12.equals("0") ? "" : entity.PLN12 %></td>
        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"td05" %>" ><%=  entity.RLT12.equals("0") ? "" : entity.RLT12 %></td>
        </tr>
        <%
	      	temp = entity.ORGTX;
	    	temp1 = entity.CTTXT;
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
    } //end if.
%>
</form>
</body>
</html>
