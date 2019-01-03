<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 부서별 휴가 사용 현황                                       		*/
/*   Program ID   : F41DeptVacationExcel.jsp                                    */
/*   Description  : 부서별 휴가 사용 현황 Excel 저장을 위한 jsp 파일            		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2005-02-01 유용원                                           		*/
/*   Update       : 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/*				  : 2018-05-18 성환희 [WorkTime52] 보상휴가 추가 건 				*/
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
    Vector DeptVacation_vt = (Vector)request.getAttribute("DeptVacation_vt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptVacation.xls");
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
    	double sumOCCUR1 = 0.0;
    	double sumABWTG1 = 0.0;
    	double sumZKVRB1 = 0.0;
    	String allAVG1 = "0.00";
    	double sumOCCUR2 = 0.0;
    	double sumABWTG2 = 0.0;
    	double sumZKVRB2 = 0.0;
    	String allAVG2 = "0.00";
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* <!-- 휴가 사용 현황 --><%=g.getMessage("LABEL.F.F41.0001")%></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="12" class="td09">&nbsp;<%=g.getMessage("LABEL.F.FCOMMON.0001")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">(<!-- 총--><%=g.getMessage("LABEL.F.FCOMMON.0006")%> <%=DeptVacation_vt.size()%> <!-- 건--><%=g.getMessage("LABEL.F.FCOMMON.0007")%>)&nbsp;</td>
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
			<tr align="center">
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 사번 --><%=g.getMessage("LABEL.F.F41.0004")%></td>
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 이름 --><%=g.getMessage("LABEL.F.F41.0005")%></td>
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 소속 --><%=g.getMessage("LABEL.F.F41.0006")%></td>
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 직책 --><%=g.getMessage("LABEL.F.F41.0007")%></td>
				<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
				<%--<td bgcolor="#e1e1e1" ><!-- 직위 --><%=g.getMessage("LABEL.F.F41.0008")%></td> --%>
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 직위/직급호칭 --><%=g.getMessage("MSG.A.A01.0083")%></td>
				<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 직급 --><%=g.getMessage("LABEL.F.F41.0009")%></td>
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 호봉 --><%=g.getMessage("LABEL.F.F41.0010")%></td>
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 연차 --><%=g.getMessage("LABEL.F.F41.0011")%></td>
				<td rowspan="2" bgcolor="#e1e1e1" ><!-- 입사일자 --><%=g.getMessage("LABEL.F.F41.0012")%></td>
				<td colspan="4" bgcolor="#e1e1e1" ><!-- 연차휴가 --><%=g.getMessage("LABEL.F.F41.0034")%></td>
				<td colspan="4" bgcolor="#e1e1e1" ><!-- 보상휴가 --><%=g.getMessage("LABEL.F.F41.0035")%></td>
			</tr>
			<tr align="center">
				<td bgcolor="#e1e1e1" ><!-- 발생일수 --><%=g.getMessage("LABEL.F.F41.0013")%></td>
				<td bgcolor="#e1e1e1" ><!--사용일수 --><%=g.getMessage("LABEL.F.F41.0014")%></td>
				<td bgcolor="#e1e1e1" ><!--잔여일수 --><%=g.getMessage("LABEL.F.F41.0015")%></td>
				<td bgcolor="#e1e1e1" ><!-- 휴가사용율 --><%=g.getMessage("LABEL.F.F41.0016")%>(%)</td>
				<td bgcolor="#e1e1e1" ><!-- 발생일수 --><%=g.getMessage("LABEL.F.F41.0013")%></td>
				<td bgcolor="#e1e1e1" ><!--사용일수 --><%=g.getMessage("LABEL.F.F41.0014")%></td>
				<td bgcolor="#e1e1e1" ><!--잔여일수 --><%=g.getMessage("LABEL.F.F41.0015")%></td>
				<td bgcolor="#e1e1e1" ><!-- 휴가사용율 --><%=g.getMessage("LABEL.F.F41.0016")%>(%)</td>
			</tr>
<%
			//전체 합계를 구함//[CSR ID:3038270]
			for( int i = 0; i < DeptVacation_vt.size(); i++ ){
			    F41DeptVacationData data = (F41DeptVacationData)DeptVacation_vt.get(i);
				sumOCCUR1 += Double.parseDouble(data.OCCUR1);
				sumABWTG1 += Double.parseDouble(data.ABWTG1);
				sumZKVRB1 += Double.parseDouble(data.ZKVRB1);
				sumOCCUR2 += Double.parseDouble(data.OCCUR2);
				sumABWTG2 += Double.parseDouble(data.ABWTG2);
				sumZKVRB2 += Double.parseDouble(data.ZKVRB2);
			}

			//평균 값 계산//[CSR ID:3038270]
			if(sumABWTG1 >0 && sumOCCUR1>0){
				allAVG1 = WebUtil.printNumFormat((sumABWTG1 / sumOCCUR1 )*100,2);
			}else{
				allAVG1 = "0.00";
			}
			if(sumABWTG2 >0 && sumOCCUR2>0){
				allAVG2 = WebUtil.printNumFormat((sumABWTG2 / sumOCCUR2 )*100,2);
			}else{
				allAVG2 = "0.00";
			}


            for( int i = 0; i < DeptVacation_vt.size(); i++ ){
                F41DeptVacationData data = (F41DeptVacationData)DeptVacation_vt.get(i);

              //[CSR ID:3038270]
                String class1 = "";

    			if (Double.parseDouble(data.CONSUMRATE1)>=Double.parseDouble(allAVG1)) {
					class1 = "bgcolor='#FFFFFF'";
				} else {
					class1 = "bgcolor='#f8f5ed'";
				}
%>
          <tr align="center">
            <td <%=class1%>><%= data.PERNR %></td>
            <td <%=class1%>><%= data.KNAME %></td>
            <td <%=class1%>><%= data.ORGTX %></td>
            <td <%=class1%>><%= data.TITL2 %></td>
            <td <%=class1%>><%= data.TITEL %></td>
            <td <%=class1%>><%= data.TRFGR %></td>
            <td <%=class1%>><%= data.TRFST %></td>
            <td <%=class1%>><%= data.VGLST %></td>
            <td <%=class1%>><%= (data.DAT01).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT01) %></td>
            <td <%=class1%>><%= data.OCCUR1 %></td>
            <td <%=class1%>><%= data.ABWTG1 %></td>
            <td <%=class1%>><%= data.ZKVRB1 %></td>
            <td <%=class1%>><%= data.CONSUMRATE1 %></td>
            <td <%=class1%>><%= data.OCCUR2 %></td>
            <td <%=class1%>><%= data.ABWTG2 %></td>
            <td <%=class1%>><%= data.ZKVRB2 %></td>
            <td <%=class1%>><%= data.CONSUMRATE2 %></td>
          </tr>
<%
            } //end for...
%>
			<!-- //[CSR ID:3038270]  -->
		  <tr align="center">
		  <td bgcolor="#fdebfb" colspan="9"><!-- 팀 휴가 사용율 --><%=g.getMessage("LABEL.F.F41.0017")%></td>
		  <td bgcolor="#fdebfb"><%=sumOCCUR1 %></td>
		  <td bgcolor="#fdebfb"><%=sumABWTG1 %></td>
		  <td bgcolor="#fdebfb"><%=sumZKVRB1 %></td>
		  <td bgcolor="#fdebfb"><%=allAVG1 %></td>
		  <td bgcolor="#fdebfb"><%=sumOCCUR2 %></td>
		  <td bgcolor="#fdebfb"><%=sumABWTG2 %></td>
		  <td bgcolor="#fdebfb"><%=sumZKVRB2 %></td>
		  <td bgcolor="#fdebfb"><%=allAVG2 %></td>
		  </tr>
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
    <td  class="td04" align="center" height="25" ><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.F.FCOMMON.0002")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

