<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 부서별 휴가 사용 현황                                       */
/*   Program ID   : F41DeptVacationExcel.jsp                                    */
/*   Description  : 부서별 휴가 사용 현황 Excel 저장을 위한 jsp 파일            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-01 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
	request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));  //부서명
    Vector DeptVacation_vt = (Vector)request.getAttribute("DeptVacation_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Leave.xls");
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
    if ( DeptVacation_vt != null && DeptVacation_vt.size() > 0 ) {
    	//[CSR ID:3038270]
    	double sumOCCUR = 0.0;
    	double sumABWTG = 0.0;
    	double sumZKVRB = 0.0;
    	String allAVG = "0.00";
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* The vacation use present state</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="12" class="td09">&nbsp;<!-- Org.Unit --><%=g.getMessage("LABEL.F.F41.0022")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">&lt;<!-- Total Count --><%=g.getMessage("LABEL.F.F41.0033")%>:<%=DeptVacation_vt.size()%> &gt;&nbsp;</td>
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
             <td class="td03" ><!--Pers.No --><%=g.getMessage("LABEL.F.F41.0020")%></td>
            <td class="td03" ><!-- Name --><%=g.getMessage("LABEL.F.F41.0021")%></td>
            <td class="td03" ><!-- Org.Unit --><%=g.getMessage("LABEL.F.F41.0022")%></td>
            <td class="td03" ><!-- Res of Office --><%=g.getMessage("LABEL.F.F41.0023")%></td>
            <td class="td03" ><!-- Title of Level--><%=g.getMessage("LABEL.F.F41.0024")%></td>
            <td class="td03" ><!-- Level--><%=g.getMessage("LABEL.F.F41.0025")%></td>
            <td class="td03" ><!-- Annual--><%=g.getMessage("LABEL.F.F41.0032")%></td>
            <td class="td03" ><!-- Hiring Date --><%=g.getMessage("LABEL.F.F41.0026")%></td>
            <td class="td03" > <!--Int Date of Conti. --><%=g.getMessage("LABEL.F.F41.0027")%></td>
            <td class="td03" ><!-- Generated(Days) --><%=g.getMessage("LABEL.F.F41.0028")%></td>
            <td class="td03" ><!--Used(Days) --><%=g.getMessage("LABEL.F.F41.0029")%></td>
            <td class="td03" ><!--Balance(Days) --><%=g.getMessage("LABEL.F.F41.0030")%></td>
            <td class="td03" ><!-- Use Rate(%) --><%=g.getMessage("LABEL.F.F41.0031")%></td>

          </tr>
<%

//전체 합계를 구함//[CSR ID:3038270]
		for( int i = 0; i < DeptVacation_vt.size(); i++ ){
    		F41DeptVacationData data = (F41DeptVacationData)DeptVacation_vt.get(i);
			sumOCCUR += Double.parseDouble(data.GENERATED);
			sumABWTG += Double.parseDouble(data.USED);
			sumZKVRB += Double.parseDouble(data.BALANCE);
		}

		//평균 값 계산//[CSR ID:3038270]
		if(sumABWTG >0 && sumOCCUR>0){
			allAVG = WebUtil.printNumFormat((sumABWTG / sumOCCUR )*100,2);
		}else{
			allAVG = "0.00";
		}

		for( int i = 0; i < DeptVacation_vt.size(); i++ ){
                F41DeptVacationData data = (F41DeptVacationData)DeptVacation_vt.get(i);
                //[CSR ID:3038270]
                String class1 = "";

    			if (Double.parseDouble(data.USERATE)>=Double.parseDouble(allAVG)) {
					class1 = "bgcolor='#FFFFFF'";
				} else {
					class1 = "bgcolor='#f8f5ed'";
				}
%>
          <tr align="center">
            <td  <%=class1%>><%= data.PERNR %></td>
            <td  <%=class1%>><%= data.ENAME %></td>
            <td  <%=class1%>><%= data.STEXT %></td>
            <td  <%=class1%>><%= data.JIKTX %></td>
            <td  <%=class1%>><%= data.JIWTX %></td>
            <td  <%=class1%>><%= data.JICTX %></td>
            <td  <%=class1%>><%= data.ANNUL %></td>
            <td  <%=class1%>><%= (data.HDATE).replace("-","").replace(".","").equals("00000000")  ? "" : WebUtil.printDate(data.HDATE) %></td>
            <td  <%=class1%>><%= (data.CSDAT).replace("-","").replace(".","").equals("00000000")  ? "" : WebUtil.printDate(data.CSDAT) %></td>
            <td  <%=class1%>><%= (data.GENERATED).equals("") ? "" : WebUtil.printNumFormat(data.GENERATED,2) %></td>
            <td  <%=class1%>><%= (data.USED).equals("") ? "" : WebUtil.printNumFormat(data.USED,2)%></td>
            <td  <%=class1%>><%= (data.BALANCE).equals("") ? "" : WebUtil.printNumFormat(data.BALANCE,2) %></td>
            <td  <%=class1%>><%= data.USERATE %></td>
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
    <td  class="td04" align="center" height="25" ><!--No data --><%=g.getMessage("LABEL.D.D04.0039")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

