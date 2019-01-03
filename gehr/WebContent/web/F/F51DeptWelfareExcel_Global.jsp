<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 복리후생                                                    */
/*   Program Name : 부서별 복리후생 현황                                        */
/*   Program ID   : F51DeptWelfareExcel.jsp                                     */
/*   Description  : 부서별 복리후생 현황 Excel 저장을 위한 jsp 파일             */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.common.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));
    Vector DeptWelfare_vt = (Vector)request.getAttribute("DeptWelfare_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptWelfare.xls");
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
    if ( DeptWelfare_vt != null && DeptWelfare_vt.size() > 0 ) {
%>
<table width="1000" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* Benefit Overview<!--Benefit Overview --><%=g.getMessage("LABEL.F.F51.0016")%></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="10" class="td09">&nbsp;Org.Unit<!--Org.Unit--><%=g.getMessage("LABEL.F.F51.0030")%> :<%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">&lt;<!--Total Count--><%=g.getMessage("LABEL.F.FCOMMON.0008")%> <%=DeptWelfare_vt.size()%>&gt;&nbsp;</td>
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
            <td class="td03"><!--Corp. --><%=g.getMessage("LABEL.F.F51.0018")%></td>
            <td class="td03"><!--Pers. No --><%=g.getMessage("LABEL.F.F51.0019")%></td>
            <td class="td03"><!--Emp. Name --><%=g.getMessage("LABEL.F.F51.0020")%></td>
            <td class="td03"><!--Org. Unit --><%=g.getMessage("LABEL.F.F51.0021")%></td>
            <td class="td03"><!--Payment Date --><%=g.getMessage("LABEL.F.F51.0022")%></td>
            <td class="td03"><!--Cel/Con Type --><%=g.getMessage("LABEL.F.F51.0023")%></td>
            <td class="td03"><!--Family Type --><%=g.getMessage("LABEL.F.F51.0024")%></td>
            <td class="td03"><!--Name --><%=g.getMessage("LABEL.F.F51.0025")%></td>
            <td class="td03"><!--Payment Amount --><%=g.getMessage("LABEL.F.F51.0026")%></td>
            <td class="td03"><!--Approved Date --><%=g.getMessage("LABEL.F.F51.0027")%></td>
            <td class="td03"><!--Refund Amt. --><%=g.getMessage("LABEL.F.F51.0028")%></td>
          </tr>
<%
            for( int i = 0; i < DeptWelfare_vt.size(); i++ ){
                F51DeptWelfareData data = (F51DeptWelfareData)DeptWelfare_vt.get(i);
%>
          <tr align="center">
            <td class="td09_1" nowrap>&nbsp;<%= data.PBTXT %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.PERNR %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.ORGTX %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= (data.DAT01).replace("-","").replace(".","").equals("00000000") ? "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.CELTX %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.FAMY_TEXT %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.FNAME %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.PAYM_AMNT.equals("0")?"":WebUtil.printNumFormat(data.PAYM_AMNT,2) +" "+ data.WAERS %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= (data.APVDT).replace("-","").replace(".","").equals("00000000") ? "" : WebUtil.printDate(data.APVDT) %>&nbsp;</td>
            <td class="td09_1" nowrap>&nbsp;<%= data.REFU_AMNT.equals("0")?"":WebUtil.printNumFormat(data.REFU_AMNT,2) +" "+ data.WAERS %>&nbsp;</td>

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
    <td  class="td04" align="center" height="25" ><!--No data --><%=g.getMessage("LABEL.F.F51.0029")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>

