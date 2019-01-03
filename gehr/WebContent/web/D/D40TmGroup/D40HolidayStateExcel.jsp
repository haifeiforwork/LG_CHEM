<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 휴가사용현황 엑셀다운로드			*/
/*   Program ID		: D40HolidayStateExcel.jsp								*/
/*   Description		: 근태집계표 - 휴가사용현황 엑셀다운로드				*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%

	WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                  //부서명
    Vector T_EXPORTA = (Vector)request.getAttribute("T_EXPORTA");         //제목

    Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

// 	String fileName = java.net.URLEncoder.encode("휴가사용현황","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("TAB.D.D40.0017"),"UTF-8");
	fileName = fileName+time;
	fileName = fileName.replace("\r","").replace("\n","");
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename="+fileName+".xls");
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
    if ( T_EXPORTA != null && T_EXPORTA.size() > 0 ) {
    	//[CSR ID:3038270]
    	double sumOCCUR = 0.0;
    	double sumABWTG = 0.0;
    	double sumZKVRB = 0.0;
    	String allAVG = "0.00";
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* <!-- 휴가 사용 현황 --><%=g.getMessage("LABEL.D.D40.0059")%></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="7" class="td09">&nbsp;<%=g.getMessage("LABEL.F.FCOMMON.0001")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%> [ <%=WebUtil.nvl(deptId, user.e_objid)%> ]</td>
	      <td colspan="2" class="td09">&nbsp;<%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %></td>
          <td colspan="1"  class="td08">(<!-- 총--><%=g.getMessage("LABEL.F.FCOMMON.0006")%> <%=T_EXPORTA.size()%> <!-- 건--><%=g.getMessage("LABEL.F.FCOMMON.0007")%>)&nbsp;</td>
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
            <td bgcolor="#e1e1e1" ><!-- 이름 --><%=g.getMessage("LABEL.F.F41.0005")%></td>
            <td bgcolor="#e1e1e1" ><!-- 사번 --><%=g.getMessage("LABEL.F.F41.0004")%></td>
            <td bgcolor="#e1e1e1" ><!-- 소속 --><%=g.getMessage("LABEL.F.F41.0006")%></td>
            <td bgcolor="#e1e1e1" ><!-- 직책 --><%=g.getMessage("LABEL.F.F41.0007")%></td>
		    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    	    <%--<td bgcolor="#e1e1e1" ><!-- 직위 --><%=g.getMessage("LABEL.F.F41.0008")%></td> --%>
			<td bgcolor="#e1e1e1" ><!-- 직위/직급호칭 --><%=g.getMessage("MSG.A.A01.0083")%></td>
             <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
<%--             <td bgcolor="#e1e1e1" ><!-- 직급 --><%=g.getMessage("LABEL.F.F41.0009")%></td> --%>
<%--             <td bgcolor="#e1e1e1" ><!-- 호봉 --><%=g.getMessage("LABEL.F.F41.0010")%></td> --%>
<%--             <td bgcolor="#e1e1e1" ><!-- 연차 --><%=g.getMessage("LABEL.F.F41.0011")%></td> --%>
            <td bgcolor="#e1e1e1" ><!-- 입사일자 --><%=g.getMessage("LABEL.F.F41.0012")%></td>
            <td bgcolor="#e1e1e1" ><!-- 발생일수 --><%=g.getMessage("LABEL.F.F41.0013")%></td>
            <td bgcolor="#e1e1e1" ><!--사용일수 --><%=g.getMessage("LABEL.F.F41.0014")%></td>
            <td bgcolor="#e1e1e1" ><!--잔여일수 --><%=g.getMessage("LABEL.F.F41.0015")%></td>
            <td bgcolor="#e1e1e1" ><!-- 휴가사용율 --><%=g.getMessage("LABEL.F.F41.0016")%>(%)</td>
          </tr>
<%
			//전체 합계를 구함//[CSR ID:3038270]
			for( int i = 0; i < T_EXPORTA.size(); i++ ){
				D40HolidayStateData data = (D40HolidayStateData)T_EXPORTA.get(i);
				sumOCCUR += Double.parseDouble(data.OCCUR);
				sumABWTG += Double.parseDouble(data.ABWTG);
				sumZKVRB += Double.parseDouble(data.ZKVRB);
			}

			//평균 값 계산//[CSR ID:3038270]
			if(sumABWTG >0 && sumOCCUR>0){
				allAVG = WebUtil.printNumFormat((sumABWTG / sumOCCUR )*100,2);
			}else{
				allAVG = "0.00";
			}


            for( int i = 0; i < T_EXPORTA.size(); i++ ){
            	D40HolidayStateData data = (D40HolidayStateData)T_EXPORTA.get(i);

              //[CSR ID:3038270]
                String class1 = "";

    			if (Double.parseDouble(data.CONSUMRATE)>=Double.parseDouble(allAVG)) {
					class1 = "bgcolor='#FFFFFF'";
				} else {
					class1 = "bgcolor='#f8f5ed'";
				}
%>
          <tr align="center">
            <td <%=class1%>><%= data.KNAME %></td>
            <td <%=class1%>><%= data.PERNR %></td>
            <td <%=class1%>><%= data.ORGTX %></td>
            <td <%=class1%>><%= data.TITL2 %></td>
            <td <%=class1%>><%= data.TITEL %></td>
<%--             <td <%=class1%>><%= data.TRFGR %></td> --%>
<%--             <td <%=class1%>><%= data.TRFST %></td> --%>
<%--             <td <%=class1%>><%= data.VGLST %></td> --%>
            <td <%=class1%>><%= (data.DAT01).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT01) %></td>
            <td <%=class1%>><%= data.OCCUR %></td>
            <td <%=class1%>><%= data.ABWTG %></td>
            <td <%=class1%>><%= data.ZKVRB %></td>
            <td <%=class1%>><%= data.CONSUMRATE %></td>
          </tr>
<%
            } //end for...
%>
			<!-- //[CSR ID:3038270]  -->
		  <tr align="center">
		  <td bgcolor="#fdebfb" colspan="6"><!-- 휴가 사용율 --><%=g.getMessage("LABEL.D.D40.0058")%></td>
		  <td bgcolor="#fdebfb"><%=sumOCCUR %></td>
		  <td bgcolor="#fdebfb"><%=sumABWTG %></td>
		  <td bgcolor="#fdebfb"><%=sumZKVRB %></td>
		  <td bgcolor="#fdebfb"><%=allAVG %></td>
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