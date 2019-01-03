<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 법정선임 내역                                        */
/*   Program ID   : F25DeptLegalAssignmentExcel.jsp                             */
/*   Description  : 부서별 법정선임 내역 Excel 저장을 위한 jsp 파일             */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-31 유용원                                           */
/*   Update       :  :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptLegalAssignment_vt = (Vector)request.getAttribute("DeptLegalAssignment_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptLegalAssignment.xls");
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
    if ( DeptLegalAssignment_vt != null && DeptLegalAssignment_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* <spring:message code="LABEL.F.F25.0006"/><!-- 부서별 법정선임 내역 --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="13" class="td09">&nbsp;<spring:message code="LABEL.F.FCOMMON.0001"/><!-- 부서명 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">(<spring:message code="LABEL.F.FCOMMON.0006"/><!-- 총 --> <%=DeptLegalAssignment_vt.size()%> <spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건 -->)&nbsp;</td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
        <!-- 화면에 보여줄 영역 시작 -->
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
				<td><spring:message code="LABEL.F.F25.0001"/><!-- 자격면허 --></td>
				<td><spring:message code="LABEL.F.F25.0002"/><!-- 취득일 --></td>
				<td><spring:message code="LABEL.F.F25.0003"/><!-- 등급 --></td>
				<td><spring:message code="LABEL.F.F25.0004"/><!-- 발행기관 --></td>
				<td><spring:message code="LABEL.F.F25.0005"/><!-- 선임부서 --></td>
          </tr>
<%
            for( int i = 0; i < DeptLegalAssignment_vt.size(); i++ ){
                F25DeptLegalAssignmentData data = (F25DeptLegalAssignmentData)DeptLegalAssignment_vt.get(i);
%>
          <tr align="center">
	            <td style='mso-number-format:"\@";'><%= data.PERNR %></td>
				<td><%= data.ENAME %></td>
				<td><%= data.ORGTX %></td>
				<td><%= data.JIKKT %></td>
				<td><%= data.JIKWT %></td>
				<td><%= data.JIKCT %></td>
				<td><%= data.TRFST %></td>
				<td><%= data.VGLST %></td>
				<td><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
				<td><%= data.LICNNM%></td>
				<td><%= (data.OBNDAT).equals("0000-00-00") ? "" : WebUtil.printDate(data.OBNDAT) %></td>
				<td><%= data.LGRDNM  %></td>
				<td><%= data.PBORGH  %></td>
				<td><%= data.LAW %></td>
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
  <!-- 화면에 보여줄 영역 끝 -->

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><spring:message code="MSG.F.FCOMMON.0002"/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>

</body>
</html>
