<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 4개년 상대화 평가                                    */
/*   Program ID   : F31Dept4YearValuationExcel.jsp                              */
/*   Description  : 부서별 4개년 상대화 평가 Excel 저장을 위한 jsp 파일         */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-01 유용원                                           */
/*   Update       :                                                             */
/*                  2013-05-24  CSR ID:99999 현장직( 전문기술직(실장 포함) 31 , 기능직33)은 무조건 조회   */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/*                  2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.common.constant.Area" %>
<%@ page import="hris.B.db.B01ValuateDetailDB" %>
<%@ page import="hris.F.F31Dept4YearValuationData" %>
<%@ page import="java.util.Vector" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector Dept4YearValuation_vt = (Vector)request.getAttribute("Dept4YearValuation_vt");

    B01ValuateDetailDB valuateDetailDB = new B01ValuateDetailDB();
    String StartDate  = valuateDetailDB.getBossStartDate();
    String DB_YEAR    = valuateDetailDB.getYEAR();
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Dept4YearValuation.xls");
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
    if ( Dept4YearValuation_vt != null && Dept4YearValuation_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* 부서별 4개년 상대화 평가</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="12" class="td09">&nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">(총 <%=Dept4YearValuation_vt.size()%> 건)&nbsp;</td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >

        <% if( user.area == Area.KR ){ %>

        <table  border="1" cellspacing="1" cellpadding="4" class="table02">
          <tr>
            <td class="td03" >사번</td>
            <td class="td03" >이름</td>
            <td class="td03" >소속</td>
            <td class="td03" >직책</td>
			<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
            <%--<td class="td03" >직위</td> --%>
            <td class="td03" ><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
            <td class="td03" >직급</td>
            <td class="td03" >호봉</td>
            <td class="td03" >연차</td>
            <td class="td03" >입사일자</td>
            <td class="td03" >P</td>
            <td class="td03" >P-1</td>
            <td class="td03" >P-2</td>
            <td class="td03" >P-3</td>
          </tr>
<%
            for( int i = 0; i < Dept4YearValuation_vt.size(); i++ ){
                F31Dept4YearValuationData data = (F31Dept4YearValuationData)Dept4YearValuation_vt.get(i);
%>
          <tr align="center">
            <td class="td04"><%= data.PERNR %></td>
            <td class="td04">&nbsp;<%= data.ENAME %>&nbsp;</td>
            <td class="td04">&nbsp;<%= data.ORGTX %>&nbsp;</td>
            <td class="td04">&nbsp;<%= data.JIKKT %>&nbsp;</td>
            <td class="td04">&nbsp;<%= data.JIKWT %>&nbsp;</td>
            <td class="td04">&nbsp;<%= data.JIKCT %>&nbsp;</td>
            <td class="td04">&nbsp;<%= data.TRFST %>&nbsp;</td>
            <td class="td04">&nbsp;<%= data.VGLST %>&nbsp;</td>
            <td class="td04"><%= (data.DAT01).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT01) %></td>

<%--<%          //CSR ID:99999 전무기술직,기능직은 무조건 조회하기, [CSR ID:2583929] 생산기술직 38 추가 --%>
            <%--if( ( data.PERSK.equals("31")||data.PERSK.equals("33") ||data.PERSK.equals("38") ) || ( Long.parseLong(StartDate) <= Long.parseLong(DataUtil.getCurrentDate()) ) ) {--%>
<%--%>            --%>
            <td class="td04"><%= data.D1 %></td>
<%--<%          } else {--%>
<%--%>         --%>
            <%--<td class="td04"> </td>  --%>
<%--<%          }--%>
<%--%>                                                             --%>
            <td class="td04"><%= data.D2 %></td>
            <td class="td04"><%= data.D3 %></td>
            <td class="td04"><%= data.D4 %></td>
          </tr>
<%
	        } //end for...
%>
        </table>
        <% } else { %>
        <table  border="1" cellspacing="1" cellpadding="4" class="table02">
            <tr>
                <td class="td03" style="text-align:center">Pers.No</td>
                <td class="td03" style="text-align:center">Name</td>
                <td class="td03" style="text-align:center">Org.Unit</td>
                <td class="td03" style="text-align:center">Res.of Office</td>
                <td class="td03" style="text-align:center">Title of Level</td>
                <td class="td03" style="text-align:center">Level/Annu.</td>
                <td class="td03" style="text-align:center">Hiring Date</td>
                <td class="td03" style="text-align:center">P-1</td>
                <td class="td03" style="text-align:center">P-2</td>
                <td class="td03" style="text-align:center">P-3</td>
                <td class="td03" style="text-align:center">P-4</td>
            </tr>
            <%
                for( int i = 0; i < Dept4YearValuation_vt.size(); i++ ){
                    F31Dept4YearValuationData data = (F31Dept4YearValuationData)Dept4YearValuation_vt.get(i);
            %>
            <tr align="center">
                <td class="td09_1" style="text-align:left">&nbsp;<%= data.PERNR %>&nbsp;</td>
                <td class="td09_1" >&nbsp;<%= data.ENAME %>&nbsp;</td>
                <td class="td09_1" >&nbsp;<%= data.ORGTX %>&nbsp;</td>
                <td class="td09_1" >&nbsp;<%= data.JIKKT %>&nbsp;</td>
                <td class="td09_1" >&nbsp;<%= data.JIKWT %>&nbsp;</td>
                <td class="td09_1" >&nbsp;<%= data.VGLST %>&nbsp;</td>
                <td class="td04" style="text-align:center">&nbsp;<%= (data.DAT01).replace("-","").replace(".","").equals("00000000") ? "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
                <td class="td09_1" style="text-align:center">&nbsp;<%= data.D1 %>&nbsp;</td>
                        <td class="td09_1" style="text-align:center">&nbsp;<%= data.D2 %>&nbsp;</td>
                <td class="td09_1" style="text-align:center">&nbsp;<%= data.D3%>&nbsp;</td>
                <td class="td09_1" style="text-align:center">&nbsp;<%= data.D4 %>&nbsp;</td>
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

