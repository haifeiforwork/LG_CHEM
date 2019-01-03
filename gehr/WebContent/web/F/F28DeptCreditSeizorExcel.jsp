<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 채권 압류자
*   Program ID   : F28DeptCreditSeizorExcel.jsp
*   Description  : 부서별 채권 압류자 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptCreditSeizor_vt = (Vector)request.getAttribute("DeptCreditSeizor_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptCreditSeizor.xls");
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
    if ( DeptCreditSeizor_vt != null && DeptCreditSeizor_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* <spring:message code="LABEL.F.F28.0014"/><!--부서별 채권 압류자--></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="11" class="td09">&nbsp;<spring:message code="LABEL.F.FCOMMON.0001"/><!--부서명--> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">(<spring:message code="LABEL.F.FCOMMON.0006"/><!--총--><%=DeptCreditSeizor_vt.size()%> <!--건--><spring:message code="LABEL.F.FCOMMON.0007"/>)&nbsp;</td>
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
				<td><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></td>
				<td><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></td>
				<td><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></td>
				<td><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></td>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<td><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></td> --%>
                <td><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<td><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></td>
				<td><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></td>
				<td><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></td>
				<td><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></td>
				<td><spring:message code="LABEL.F.F28.0011"/><!-- 압류일 --></td>
				<td><spring:message code="LABEL.F.F28.0012"/><!-- 압류금액 --></td>
				<td><spring:message code="LABEL.F.F28.0013"/><!-- 사유 --></td>
          </tr>
<%
            for( int i = 0; i < DeptCreditSeizor_vt.size(); i++ ){
                F28DeptCreditSeizorData data = (F28DeptCreditSeizorData)DeptCreditSeizor_vt.get(i);
%>
          <tr align="center">
				<td nowrap style='mso-number-format:"\@";'><%= data.PERNR %></td>
				<td nowrap><%= data.ENAME %></td>
				<td nowrap><%= data.ORGTX %></td>
				<td nowrap><%= data.JIKKT %></td>
				<td nowrap><%= data.JIKWT %></td>
				<td nowrap><%= data.JIKCT %></td>
				<td nowrap><%= data.TRFST %></td>
				<td nowrap><%= data.VGLST %></td>
				<td nowrap><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
	            <td><%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %></td>
	            <td><%= WebUtil.printNumFormat(Double.parseDouble(data.CRED_AMNT)*100) %></td>
	            <td><%= data.CRED_TEXT %></td>
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
    <td  class="td04" align="center" height="25" ><spring:message code="MSG.F.FCOMMON.0002"/> <!-- 해당하는 데이터가 존재하지 않습니다. --></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>

</body>
</html>
