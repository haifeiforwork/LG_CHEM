<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : 신청
*   2Depth Name  : 부서근태
*   Program Name : 부서일일근태관리
*   Program ID   : D12Rotation|D12RotationDetail.jsp
*   Description  : 부서일일근태관리 엑셀 저장화면
*   Note         :
*   Update       :
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D12Rotation.D12RotationCnData" %>

<%
	WebUserData user    = (WebUserData)session.getAttribute("user");                                          //세션.
	String I_DATE  = WebUtil.nvl(request.getParameter("I_DATE"));          //기간
	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                  //부서코드
	String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                                //부서명
	Vector D12RotationData_vt = (Vector)request.getAttribute("D12RotationData_vt");

	if( I_DATE == null|| I_DATE.equals("")) {
	    I_DATE = DataUtil.getCurrentDate();           //1번째 조회시
	}

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=RotationDetail.xls");
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
    if ( D12RotationData_vt != null && D12RotationData_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
        tableSize = D12RotationData_vt.size()*50 + 250;

%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* <spring:message code="TAB.COMMON.0046"/><!-- 일 근태관리 --></td>
        </tr>
        <tr>
          <td class="title02" colSpan="16"><spring:message code='LABEL.D.D14.0003'/> : <%= WebUtil.printDate(I_DATE)%></td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
   <%
   String tempDept = "";
   for( int i=0; i < D12RotationData_vt.size(); i++ ){
	   D12RotationCnData deptData = (D12RotationCnData) D12RotationData_vt.get(i);

	   if( !deptData.ORGEH.equals(tempDept) ){
	%>
  <tr>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
  	<td width="50%" class="td09">
      &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%=deptData.ORGTX%>
    </td>
    <td></td>
    </tr>
    <tr>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr>
			<td><spring:message code="LABEL.D.D12.0017"/><!-- Pers.No --></td>
			<td><spring:message code="LABEL.D.D12.0018"/><!-- Name --></td>
			<td><spring:message code="LABEL.D.D12.0053"/><!-- Daily Work Schedule --></td>
			<td><spring:message code="LABEL.D.D12.0054"/><!-- DWS.Begin Time --></td>
			<td><spring:message code="LABEL.D.D12.0055"/><!-- DWS.End Time --></td>
			<td><spring:message code="LABEL.D.D12.0056"/><!-- Act.Begin Time --></td>
			<td><spring:message code="LABEL.D.D12.0057"/><!-- Act.End Time --></td>
			<td><spring:message code="LABEL.D.D12.0058"/><!-- Act.Begin Time(Gate) --></td>
			<td><spring:message code="LABEL.D.D12.0059"/><!-- Act.End Time(Gate) --></td>
			<td><spring:message code="LABEL.D.D12.0060"/><!-- Remark --></td>
			<td><spring:message code="LABEL.D.D12.0061"/><!-- O/T(Night) --></td>
			<td><spring:message code="LABEL.D.D12.0062"/><!-- O/T(Workday) --></td>
			<td><spring:message code="LABEL.D.D12.0063"/><!-- O/T(offday) --></td>
			<td><spring:message code="LABEL.D.D12.0064"/><!-- O/T(Holiday) --></td>
			<td><spring:message code="LABEL.D.D12.0065"/><!-- Absence --></td>
			<td><spring:message code="LABEL.D.D12.0066"/><!-- Attendance --></td>
        </tr>
<%
for( int j = 0; j < D12RotationData_vt.size(); j++ ){
	D12RotationCnData data = (D12RotationCnData)D12RotationData_vt.get(j);
	if( data.ORGEH.equals(deptData.ORGEH) ){
%>
		<tr>
        	<td class="td09" nowrap style='text-align: center;mso-number-format:"\@";'><%= data.PERNR %></td>
        	<td class="td09"><%= data.ENAME %></td>
        	<td class="td09"><%= data.TPROG %> </td>
        	<td class="td09"><%= data.PL_BEG %> </td>
        	<td class="td09"><%= data.PL_END %> </td>
        	<td class="td09"><%= data.AC_BEG %> </td>
        	<td class="td09"><%= data.AC_END %> </td>
        	<td class="td09"><%= data.ZC_BEG %> </td>
        	<td class="td09"><%= data.ZC_END %> </td>
        	<td class="td09"><%= data.REMARK %> </td>
        	<td class="td09"><%= data.OT1 %> </td>
        	<td class="td09"><%= data.OT2 %> </td>
        	<td class="td09"><%= data.OT3 %> </td>
        	<td class="td09"><%= data.OT4 %> </td>
        	<td class="td09"><%= data.AB_TEXT %> </td>
        	<td class="td09"><%= data.AT_TEXT %></td>
        </tr>
<%
	}
}
%>
     </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>
<%
	tempDept = deptData.ORGEH;
	}
}
%>
<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.A.A01.0012'/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>

