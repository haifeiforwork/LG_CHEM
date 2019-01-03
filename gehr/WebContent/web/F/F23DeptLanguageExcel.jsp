<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 어학 인정점수 조회                                   */
/*   Program ID   : F23DeptLanguageExcel.jsp                                    */
/*   Description  : 부서별 어학 인정점수 조회를 위한 jsp 파일                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-28 유용원                                           */
/*   Update       : 2012-12-20 신HSK추가  C20121218_37795                                                             */
/*                      2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건   */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.common.constant.Area" %>
<%@ page import="hris.F.F23DeptLanguageData" %>
<%@ page import="java.util.Vector" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptLanguage_vt = (Vector)request.getAttribute("DeptLanguage_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptScholarship.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<%
    //부서명, 조회된 건수.
    if ( DeptLanguage_vt != null && DeptLanguage_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* 외국어 현황조회</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="14" class="td09">&nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">(총 <%=DeptLanguage_vt.size()%> 건)&nbsp;</td>
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
    <% if( user.area == Area.KR ){ %>
        <table  border="1" cellspacing="1" cellpadding="4" class="table02">
          <tr>
            <td class="td03" >사번</td>
            <td class="td03" >이름</td>
            <td class="td03" >소속</td>
            <td class="td03" >직책</td>
            <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha start --%>
     		<%--<td class="td03">직위</td> --%>
			<td class="td03"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
			<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha end --%>
            <td class="td03" >직급</td>
            <td class="td03" >호봉</td>
            <td class="td03" >연차</td>
            <td class="td03" >입사일자</td>
            <td class="td03" >LAP ORA</td>
            <td class="td03" >LAP WR</td>
            <td class="td03" >TOEIC</td>
            <td class="td03" >TOEFL</td>
            <td class="td03" >JPT</td>
            <td class="td03" >HSK</td>
            <td class="td03" >SEPT</td>
            <td class="td03" >신HSK</td><!--C20121218_37795-->
          </tr>
<%
	        for( int i = 0; i < DeptLanguage_vt.size(); i++ ){
                F23DeptLanguageData data = (F23DeptLanguageData)DeptLanguage_vt.get(i);
%>
          <tr align="center">
              <td nowrap>&nbsp;<%= data.PERNR %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.ORGTX %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.JIKKT %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.JIKWT %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.JIKCT %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.TRFST %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.VGLST %>&nbsp;</td>
              <td nowrap>&nbsp;<%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.LGA_LAP_ORAL%>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.LGA_LAP_WR  %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.TOEIC %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.TOEFL %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.JPT   %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.HSK.equals("") ? "" : Integer.parseInt( data.HSK )  %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.SEPT  %>&nbsp;</td>
              <td nowrap>&nbsp;<%= data.NHSK.equals("") ? "" : Integer.parseInt(data.NHSK)   %>&nbsp;</td> <!--C20121218_37795-->
          </tr>
<%
	        } //end for...
%>
        </table>
        <% } else { %>

        <table  border="1" cellspacing="1" cellpadding="4" class="table02">
            <tr>
                <td class="td03"><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></td>
                <td class="td03"><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></td>
                <td class="td03"><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></td>
                <td class="td03"><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></td>
                <td class="td03"><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></td>
                <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha start --%>
				<%--<td class="td03"><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></td> --%>
				<td class="td03"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha end --%>
                <td class="td03"><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></td>
                <td class="td03"><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></td>
                <td class="td03" nowrap>CET</td>
                <td class="td03" nowrap>TOEIC</td>
                <td class="td03" nowrap>JLPT</td>
                <td class="td03" nowrap>NSS</td>
                <td class="td03" nowrap>KPT</td>
                <td class="td03" nowrap>TOPIK</td>  <!--2013-05-10 dongxiaomian@v1.0 [C20130503_24510] 显示TOPIK数据   -->
            </tr>
            <%
                for( int i = 0; i < DeptLanguage_vt.size(); i++ ){
                    F23DeptLanguageData data = (F23DeptLanguageData)DeptLanguage_vt.get(i);
            %>
            <tr align="center">
                <td nowrap>&nbsp;<%= data.NAME1 %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.PERNR %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.ORGTX %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.JIKKT %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.JIKWT %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.VGLST %>&nbsp;</td>
                <td nowrap>&nbsp;<%= (data.DAT01).replace("-","").replace(".","").equals("00000000") ? "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.LGT01 %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.LGT03 %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.LGT07 %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.LGT08 %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.LGT09 %>&nbsp;</td>
                <td nowrap>&nbsp;<%= data.LGT12 %>&nbsp;</td> <!-- 2013-05-10 dongxiaomian@v1.0 [C20130503_24510] 显示TOPIK数据 -->
            </tr>
            <%
                } //end for...
            %>
        </table>
        <% } %>
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
    <td  class="td04" align="center" height="25" >해당하는 데이터가 존재하지 않습니다.</td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>

