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
<%@ page import="hris.D.D12Rotation.D12RotationBuildCnData" %>

<%
	WebUserData user    = (WebUserData)session.getAttribute("user");                                          //세션.
	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                  //부서코드
	String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                                //부서명
	Vector D12RotationBuildDetailData_vt  = (Vector)request.getAttribute("D12RotationBuildDetailData_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=RotationBuildDetail.xls");
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
    if ( D12RotationBuildDetailData_vt != null && D12RotationBuildDetailData_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
        tableSize = D12RotationBuildDetailData_vt.size()*50 + 250;

%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* <spring:message code="TAB.COMMON.0048"/><!-- 초과근무조회 --></td>
        </tr>
        <tr>
	      <td colspan="18" class="td08" Style="text-align: right;">(<spring:message code="LABEL.F.FCOMMON.0006"/><!-- 총 --> <%=D12RotationBuildDetailData_vt.size()%> <spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건 -->)&nbsp;</td>
	    </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
  	<td>
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr>
            <td><spring:message code="LABEL.D.D12.0017"/> <!-- 사원번호--></td>
            <td><spring:message code="LABEL.D.D12.0018"/> <!-- 이름--></td>
            <td><spring:message code="LABEL.D.D12.0078"/> <!-- 시작일자--></td>
            <td><spring:message code="LABEL.D.D12.0079"/> <!-- 종료일자--></td>
            <td><spring:message code="LABEL.D.D12.0067"/> <!-- 전일지시자--></td>
            <td><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></td>
            <td><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></td>
            <td><spring:message code="LABEL.D.D12.0068"/> <!-- 휴식시간1--></td>
            <td><spring:message code="LABEL.D.D12.0069"/> <!-- 휴식종료1--></td>
            <td><spring:message code="LABEL.D.D12.0070"/> <!-- 휴식시간2--></td>
            <td><spring:message code="LABEL.D.D12.0071"/> <!-- 휴식종료2--></td>
            <td><spring:message code="LABEL.D.D12.0072"/> <!-- 사유--></td>
            <td><spring:message code="LABEL.D.D12.0073"/> <!-- 초과근무(hr)--></td>
            <td><spring:message code="LABEL.D.D12.0074"/> <!-- 근무일정규칙--></td>
            <td><spring:message code="LABEL.D.D12.0075"/> <!-- 일일근무일정--></td>
            <td><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></td>
            <td><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></td>
            <td><spring:message code="LABEL.D.D12.0076"/> <!-- 근무시간--></td>
        </tr>
        <% for( int i=0; i < D12RotationBuildDetailData_vt.size(); i++ ){
        	D12RotationBuildCnData data = (D12RotationBuildCnData) D12RotationBuildDetailData_vt.get(i);%>
        <tr>
        	<td class="td09" nowrap style='text-align: center;mso-number-format:"\@";'><%= data.PERNR %></td>
        	<td class="td09"><%= data.ENAME %></td>
        	<td class="td09"><%= WebUtil.printDate(data.BEGDA) %></td>
        	<td class="td09"><%= WebUtil.printDate(data.ENDDA) %></td>
        	<td class="td09"><%= data.VTKEN%></td>
        	<td class="td09"><%= data.BEGUZ %></td>
        	<td class="td09"><%= data.ENDUZ %></td>
        	<td class="td09"><%= data.PBEG1 %></td>
        	<td class="td09"><%= data.PEND1 %></td>
        	<td class="td09"><%= data.PBEG2 %></td>
        	<td class="td09"><%= data.PEND2 %></td>
        	<td class="td09"><%= data.REASON %></td>
        	<td class="td09" nowrap style='text-align: center;mso-number-format:"\@";'><%= WebUtil.printNumFormat(data.OTTIM, 2)%></td>
        	<td class="td09"><%= data.RTEXT %></td>
        	<td class="td09"><%= data.TTEXT %></td>
        	<td class="td09"><%= data.SOBEG %></td>
        	<td class="td09"><%= data.SOEND %></td>
        	<td class="td09" nowrap style='text-align: center;mso-number-format:"\@";'><%= WebUtil.printNumFormat(data.SOLLZ, 2) %></td>
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
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.A.A01.0012'/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>

