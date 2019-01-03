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
/*   Update       : 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
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
          <td colspan="5" class="title02">* <!-- 복리후생 현황 --><%=g.getMessage("LABEL.F.F51.0001")%></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="11" class="td09">&nbsp;<!-- 부서명 --><%=g.getMessage("LABEL.F.F41.0002")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">(<!-총 --><%=g.getMessage("LABEL.F.F41.0003")%> <%=DeptWelfare_vt.size()%> <!--건 --><%=g.getMessage("LABEL.F.F41.0018")%>)&nbsp;</td>
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
            <td class="td03" nowrap><!--사번 --><%=g.getMessage("LABEL.F.F41.0004")%></td>
            <td class="td03" nowrap><!--이름 --><%=g.getMessage("LABEL.F.F41.0005")%></td>
            <td class="td03" nowrap><!-- 소속 --><%=g.getMessage("LABEL.F.F51.0008")%></td>
		    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    	    <%--<td class="td03" nowrap><!-- 직위 --><%=g.getMessage("LABEL.F.F41.0008")%></td>--%>
    	    <td class="td03" nowrap><!-- 직책/직급호칭 --><%=g.getMessage("MSG.APPROVAL.0024")%></td>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
            <td class="td03" nowrap><!-- 구분 --><%=g.getMessage("LABEL.F.F42.0055")%></td>
            <td class="td03" nowrap><!-- 내역 --><%=g.getMessage("LABEL.F.F51.0009")%></td>
            <td class="td03" nowrap><!-- 대상구분 --><%=g.getMessage("LABEL.F.F51.0010")%></td>
            <td class="td03" nowrap><!-- 대상자 --><%=g.getMessage("LABEL.F.F51.0011")%></td>
            <td class="td03" nowrap><!-- 지원액 --><%=g.getMessage("LABEL.F.F51.0012")%></td>
            <td class="td03" nowrap><!--통화 --><%=g.getMessage("LABEL.F.F51.0013")%></td>
            <td class="td03" nowrap><!-- 신청일자 --><%=g.getMessage("LABEL.F.F51.0014")%></td>
            <td class="td03" nowrap><!-- 결재일자 --><%=g.getMessage("LABEL.F.F51.0015")%></td>
          </tr>
<%
            for( int i = 0; i < DeptWelfare_vt.size(); i++ ){
                F51DeptWelfareData data = (F51DeptWelfareData)DeptWelfare_vt.get(i);
%>
          <tr align="center">
            <td class="td04"><%= data.PERNR %></td>
            <td class="td04"><%= data.KNAME %></td>
            <td class="td04"><%= data.STEXT %></td>
           <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
           <%-- <td class="td04"><%= data.TITEL %></td> --%>
            <td class="td04"><%=data.TITEL_T.equals("EBA") && !data.TITL2.equals("")? data.TITL2 : data.TITEL %></td>
           <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>

            <td class="td04"><%= data.GUBUN %></td>
            <td class="td04"><%= data.DESCRIPTION %></td>
            <td class="td04"><%= data.RELA_CODE %></td>
            <td class="td04"><%= data.EREL_NAME %></td>
            <td class="td04"><%= data.WAERS %></td>
            <td class="td04"><%= WebUtil.printNumFormat(Double.parseDouble(data.PAID_AMNT)*100) %></td>
            <td class="td04"><%= (data.APPL_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.APPL_DATE) %></td>
            <td class="td04"><%= (data.APPR_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.APPR_DATE) %></td>
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
    <td  class="td04" align="center" height="25" ><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.COMMON.0004")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>

