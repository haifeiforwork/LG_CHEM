<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 경력입사자
*   Program ID   : F26DeptExperiencedEmpExcel.jsp
*   Description  : 부서별 경력입사자 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptExperiencedEmp_vt = (Vector)request.getAttribute("DeptExperiencedEmp_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptExperiencedEmp.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */

    HashMap empCnt1 = (HashMap)request.getAttribute("empCnt1");
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
    if ( DeptExperiencedEmp_vt != null && DeptExperiencedEmp_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* <spring:message code="LABEL.F.F26.0003"/><!-- 부서별 경력입사자 --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="14" class="td09">&nbsp;<spring:message code="LABEL.F.FCOMMON.0001"/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">(<spring:message code="LABEL.F.FCOMMON.0006"/> <!-- 총 --> <%=DeptExperiencedEmp_vt.size()%> <spring:message code="LABEL.F.FCOMMON.0007"/><!--  건 -->)&nbsp;</td>
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
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<td><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></td> --%>
                <td><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<td><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></td>
				<td><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></td>
				<td><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></td>
				<td><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></td>
<%}else{%>
				<td><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></td>
				<td><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></td>
				<td><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></td>
				<td><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></td>
				<td><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></td>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<td><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></td> --%>
                <td><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<td><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></td>
				<td><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></td>
<%} %>
				<td><spring:message code="LABEL.F.F26.0001"/><!-- 근무기간 --></td>
				<td><spring:message code="LABEL.F.F26.0002"/><!-- 근무처 --></td>
			    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<td><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></td> --%>
                <td><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<td class="lastCol"><spring:message code="LABEL.F.F00.0012"/><!-- 직무 --></td>
			</tr>
<%
		if( user.area == Area.KR ){
			String oldPer="";
			String sRow = "";
            for( int i = 0; i < DeptExperiencedEmp_vt.size(); i++ ){
        		F26DeptExperiencedEmpData data = (F26DeptExperiencedEmpData)DeptExperiencedEmp_vt.get(i);
                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(data.PERNR);
                }
                oldPer = data.PERNR;

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
			<tr class="<%=tr_class%>">
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
				<td nowrap><%= data.PERIOD %></td>
				<td nowrap><%= data.ARBGB %></td>
				<td nowrap><%= data.CJIKWT %></td>
				<td nowrap class="lastCol"><%= data.CSTLTX %></td>
			</tr>
<%		}
		}else{
			String oldPer="";
			String sRow = "";
		    for( int i = 0; i < DeptExperiencedEmp_vt.size(); i++ ){
		    	F26DeptExperiencedEmpGlobalData dataG = (F26DeptExperiencedEmpGlobalData)DeptExperiencedEmp_vt.get(i);
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
				<td nowrap><%= dataG.PERIOD %></td>
				<td nowrap><%= dataG.ARBGB %></td>
				<td nowrap><%= dataG.CJIKWT %></td>
				<td nowrap class="lastCol"><%= dataG.CSTLTX %></td>
			</tr>
<%		}
		}%>
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
    <td  class="td04" align="center" height="25" ><spring:message code="MSG.F.FCOMMON.0002"/> <!-- 해당하는 데이터가 존재하지 않습니다. --></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>

</body>
</html>
