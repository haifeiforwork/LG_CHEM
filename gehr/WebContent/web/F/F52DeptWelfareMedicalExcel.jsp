<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));
    Vector DeptWelfareMedical_vt = (Vector)request.getAttribute("DeptWelfareMedical_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Overview_Medical_Fee.xls");
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
    //부서명, 조회된 건수.
    if ( DeptWelfareMedical_vt != null && DeptWelfareMedical_vt.size() > 0 ) {
%>
<table width="1000" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* <!--Benefit Overview-Expatriate--><%=g.getMessage("LABEL.F.F52.0000")%> > <!-- Medical Fee--><%=g.getMessage("LABEL.F.F52.0013")%></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="11" class="td09">&nbsp;<!--Org.Unit--><%=g.getMessage("LABEL.F.FCOMMON.0001")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">&lt;<!--Total Count--><%=g.getMessage("LABEL.F.FCOMMON.0008")%> : <%=DeptWelfareMedical_vt.size()%> &gt;&nbsp;</td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
         <table  border="1" cellspacing="1" cellpadding="4" class="table02">
          <tr>
            <td class="td03" style="text-align:center"><!--Corp.--><%=g.getMessage("LABEL.F.F52.0001")%></td>
            <td class="td03" style="text-align:center"><!--Pers. No--><%=g.getMessage("LABEL.F.F52.0002")%></td>
            <td class="td03" style="text-align:center"><!--Emp. Name--><%=g.getMessage("LABEL.F.F52.0003")%></td>
            <td class="td03" style="text-align:center"><!--Org. Unit--><%=g.getMessage("LABEL.F.F52.0004")%></td>
            <td class="td03" style="text-align:center"><!--Payment Date--><%=g.getMessage("LABEL.F.F52.0005")%></td>
            <td class="td03" style="text-align:center"><!--Medical Type--><%=g.getMessage("LABEL.F.F52.0006")%></td>
            <td class="td03" style="text-align:center"><!--Name--><%=g.getMessage("LABEL.F.F52.0007")%></td>
            <td class="td03" style="text-align:center"><!--Disease--><%=g.getMessage("LABEL.F.F52.0008")%></td>
            <td class="td03" style="text-align:center"><!--Medical Expense--><%=g.getMessage("LABEL.F.F52.0009")%></td>
            <td class="td03" style="text-align:center"><!--Payment Amount--><%=g.getMessage("LABEL.F.F52.0010")%></td>
            <td class="td03" style="text-align:center"><!--Approved Date--><%=g.getMessage("LABEL.F.F52.0011")%></td>
            <td class="td03" style="text-align:center"><!--Refund Amt.--><%=g.getMessage("LABEL.F.F52.0012")%></td>

          </tr>
<%
            for( int i = 0; i < DeptWelfareMedical_vt.size(); i++ ){
                F52DeptWelfareMedicalData data = (F52DeptWelfareMedicalData)DeptWelfareMedical_vt.get(i);
%>
          <tr align="center">

            <td class="td09_1" nowrap>&nbsp;<%= data.PBTXT %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.PERNR %>&nbsp;</td>
            <td class="td09_1" nowrap style="text-align:left">&nbsp;<%= data.ENAME %>&nbsp;</td>
            <td class="td09_1" nowrap style="text-align:left">&nbsp;<%= data.ORGTX %>&nbsp;</td>

            <td class="td04" nowrap>&nbsp;<%= (data.DAT01).replace("-","").replace(".","").equals("00000000")  ? "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>

            <td class="td09_1" nowrap style="text-align:left">&nbsp;<%= data.MTEXT %>&nbsp;</td>
            <td class="td09_1" nowrap style="text-align:left">&nbsp;<%= data.PNAME %>&nbsp;</td>
            <td class="td09_1" nowrap style="text-align:left">&nbsp;<%= data.DSEAS %>&nbsp;</td>
            <td class="td09_1" nowrap style="text-align:right">&nbsp;<%= data.EXPNS.equals("0") ? "" : WebUtil.printNumFormat(data.EXPNS, 2) +" "+ data.WAERS %>&nbsp;</td>

            <td class="td09_1" nowrap style="text-align:right">&nbsp;<%= data.PAYM_AMNT.equals("0")? "" : WebUtil.printNumFormat(data.PAYM_AMNT, 2)  +" "+ data.WAERS %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= (data.APVDT).replace("-","").replace(".","").equals("00000000")  ? "" : WebUtil.printDate(data.APVDT) %>&nbsp;</td>
            <td class="td09_1" nowrap style="text-align:right">&nbsp;<%= data.REFU_AMNT.equals("0") ? "" : WebUtil.printNumFormat(data.REFU_AMNT, 2) +" "+ data.WAERS %>&nbsp;</td>

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
    <td  class="td04" align="center" height="25" ><!--No data--><%=g.getMessage("MSG.F.FCOMMON.0002")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>
