<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 학력조회
*   Program ID   : F22DeptScholarshipExcel.jsp
*   Description  : 부서별 학력조회 Excel저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptScholarship_vt = (Vector)request.getAttribute("DeptScholarship_vt");

    HashMap empCnt1 = (HashMap)request.getAttribute("empCnt1");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptScholarship.xls");
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
    if ( DeptScholarship_vt != null && DeptScholarship_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* <spring:message code="LABEL.F.F22.0008"/><!-- 부서별 학력조회 --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="14" class="td09">&nbsp;<spring:message code="LABEL.F.FCOMMON.0001"/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
	      <td colspan="1" class="td08">(<spring:message code="LABEL.F.FCOMMON.0006"/><!-- 총 --> <%=DeptScholarship_vt.size()%> <spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건 -->)&nbsp;</td>
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
<%
	if( user.area == Area.KR ){
%>
				<td><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></td>
				<td><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></td>
				<td><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></td>
				<td><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></td>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha start --%>
				<%--<td><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></td> --%>
				<td><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha end --%>
				<td><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></td>
				<td><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></td>
				<td><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></td>
				<td><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></td>
				<td><spring:message code="LABEL.F.F22.0001"/><!-- 기간 --></td>
				<td><spring:message code="LABEL.F.F22.0002"/><!-- 학교명--></td>
				<td><spring:message code="LABEL.F.F22.0003"/><!-- 전공 --></td>
				<td><spring:message code="LABEL.F.F22.0004"/><!-- 졸업구분 --></td>
				<td><spring:message code="LABEL.F.F22.0005"/><!-- 소재지 --></td>
				<td><spring:message code="LABEL.F.F22.0006"/><!-- 입사시 학력 --></td>
<%}else{ %>
				<td><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></td>
				<td><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></td>
				<td><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></td>
				<td><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></td>
				<td><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></td>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha start --%>
				<%--<td><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></td> --%>
				<td><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha end --%>
				<td><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></td>
				<td><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></td>
				<td><spring:message code="LABEL.F.F22.0001"/><!-- 기간 --></td>
				<td><spring:message code="LABEL.F.F22.0002"/><!-- 학교명--></td>
				<td><spring:message code="LABEL.F.F22.0003"/><!-- 전공 --></td>
				<td><spring:message code="LABEL.F.F22.0004"/><!-- 졸업구분 --></td>
				<td><spring:message code="LABEL.F.F22.0005"/><!-- 소재지 --></td>
				<td><spring:message code="LABEL.F.F22.0006"/><!-- 입사시 학력 --></td>
<%} %>
          </tr>
<%
	if( user.area == Area.KR ){
			String oldPer="";
			String sRow = "";

	        for( int i = 0; i < DeptScholarship_vt.size(); i++ ){
                F22DeptScholarshipData data = (F22DeptScholarshipData)DeptScholarship_vt.get(i);
                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(data.PERNR);
                }
                oldPer = data.PERNR;
%>
          <tr align="center">
          <%if (!sRow.equals("")) {%>
            	<td nowrap <%= sRow %> style='mso-number-format:"\@";'><%= data.PERNR %></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.JIKCT %></td>
				<td nowrap <%= sRow %>><%= data.TRFST %></td>
				<td nowrap <%= sRow %>><%= data.VGLST %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
				<td><%= data.PERIOD %></td>
				<td><%= data.SCHTX %></td>
				<td><%= data.SLTP1X %></td>
				<td><%= data.SLATX %></td>
				<td><%= data.SOJAE %></td>
				<td><%= data.EMARK %></td>
          </tr>
<%
	        } //end for...
	}else{
		String oldPer="";
		String sRow = "";

		 for( int i = 0; i < DeptScholarship_vt.size(); i++ ){
             F22DeptScholarshipGlobalData dataG = (F22DeptScholarshipGlobalData)DeptScholarship_vt.get(i);
             if(oldPer.equals(dataG.PERNR)){
             	sRow = "";
             }else{
             	sRow = "rowspan=" + empCnt1.get(dataG.PERNR);
             }
             oldPer = dataG.PERNR;
%>
			<tr>
          <%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><%= dataG.NAME1 %></td>
				<td nowrap <%= sRow %> style='mso-number-format:"\@";'><%= dataG.PERNR %></td>
				<td nowrap <%= sRow %>><%= dataG.ENAME %></td>
				<td nowrap <%= sRow %>><%= dataG.ORGTX %></td>
				<td nowrap <%= sRow %>><%= dataG.JIKKT %></td>
				<td nowrap <%= sRow %>><%= dataG.JIKWT %></td>
				<td nowrap <%= sRow %>><%= dataG.VGLST %></td>
				<td nowrap <%= sRow %>><%= (dataG.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(dataG.DAT01) %></td>
			<%} %>
				<td><%= dataG.PERIOD %></td>
				<td><%= dataG.SCHTX %></td>
				<td><%= dataG.SLTP1X %></td>
				<td><%= dataG.SLATX %></td>
				<td><%= dataG.SOJAE %></td>
				<td><%= dataG.EMARK %></td>
			</tr>

<%
	        } //end for...
	}
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
