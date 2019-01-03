<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 포상/징계 내역
*   Program ID   : F27DeptRewardNPunishExcel.jsp
*   Description  : 부서별 포상/징계 내역 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update      :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
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
    Vector DeptReward_vt = (Vector)request.getAttribute("DeptReward_vt");
    Vector DeptPunish_vt = (Vector)request.getAttribute("DeptPunish_vt");
    HashMap  empCnt1                = (HashMap)request.getAttribute("empCnt1");
    HashMap  empCnt2                = (HashMap)request.getAttribute("empCnt2");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptRewardNPunish.xls");
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

<!-- 화면에 보여줄 영역 시작 -->
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
<%
    //부서명, 조회된 건수.
    if ( DeptReward_vt != null && DeptReward_vt.size() > 0 ) {
%>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* <spring:message code="LABEL.F.F27.0010"/><!-- 부서별 포상/징계 내역 --></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="13" class="td09">&nbsp;<spring:message code="LABEL.F.FCOMMON.0001"/><!-- 부서 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="12" class="f01">&nbsp;<spring:message code="LABEL.F.F27.0011"/><!-- 포상내역 --></td>
	      <td colspan="1" class="td08">(<spring:message code="LABEL.F.FCOMMON.0006"/><!-- 총 --> <%=DeptReward_vt.size()%> <spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건 -->)&nbsp;</td>
	    </tr>
	    <tr><td height="5"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
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
				<td><spring:message code="LABEL.F.F41.0008"/><!-- 직급/연차 --></td>
				<td><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></td>
<%} %>
				<td><spring:message code="LABEL.F.F27.0001"/><!-- 포상일 --></td>
				<td><spring:message code="LABEL.F.F27.0002"/><!-- 포상유형 --></td>
				<td><spring:message code="LABEL.F.F27.0003"/><!-- 포상사유 --></td>
				<td><spring:message code="LABEL.F.F27.0004"/><!-- 비고 --></td>
			</tr>

<%
		if( user.area == Area.KR ){
			String oldPer="";
			String sRow = "";
	        for( int i = 0; i < DeptReward_vt.size(); i++ ){
                F27DeptRewardNPunish01Data data = (F27DeptRewardNPunish01Data)DeptReward_vt.get(i);
                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(data.PERNR);
                }
                oldPer = data.PERNR;
%>
          <tr>
          	<%if (!sRow.equals("")) {%>
	            <td <%= sRow %> style='mso-number-format:"\@";'><%= data.PERNR %></td>
				<td <%= sRow %>><%= data.ENAME %></td>
				<td <%= sRow %>><%= data.ORGTX %></td>
				<td <%= sRow %>><%= data.JIKKT %></td>
				<td <%= sRow %>><%= data.JIKWT %></td>
				<td <%= sRow %>><%= data.JIKCT %></td>
				<td <%= sRow %>><%= data.TRFST %></td>
				<td <%= sRow %>><%= data.VGLST %></td>
				<td <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
            <td><%= WebUtil.printDate(data.BEGDA) %></td>
            <td><%= data.PRZTX %></td>
            <td><%= data.PRZRN %></td>
            <td><%= data.COMNT %></td>
          </tr>
<%
			} //end for...
		}else{
			String oldPer="";
			String sRow = "";
	        for( int i = 0; i < DeptReward_vt.size(); i++ ){
                F27DeptRewardNPunish01GlobalData dataG = (F27DeptRewardNPunish01GlobalData)DeptReward_vt.get(i);
                if(oldPer.equals(dataG.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(dataG.PERNR);
                }
                oldPer = dataG.PERNR;
%>
          <tr>
          <%if (!sRow.equals("")) {%>
				<td <%= sRow %>><%= dataG.NAME1 %></td>
				<td <%= sRow %> style='mso-number-format:"\@";'><%= dataG.PERNR %></td>
				<td <%= sRow %>><%= dataG.ENAME %></td>
				<td <%= sRow %>><%= dataG.ORGTX %></td>
				<td <%= sRow %>><%= dataG.JIKKT %></td>
				<td <%= sRow %>><%= dataG.JIKWT %></td>
				<td <%= sRow %>><%= dataG.VGLST %></td>
				<td <%= sRow %>><%= (dataG.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(dataG.DAT01) %></td>
			<%} %>
            <td><%= WebUtil.printDate(dataG.BEGDA) %></td>
            <td><%= dataG.AWRD_NAME %></td>
            <td><%= dataG.AWDTP %></td>
            <td><%= dataG.AWRD_DESC %></td>
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

<%
    } //end if...

    //부서명, 조회된 건수.
    if ( DeptPunish_vt != null && DeptPunish_vt.size() > 0 ) {
%>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="11" class="f01">&nbsp;<spring:message code="LABEL.F.F27.0008"/><!-- 징계내역 --></td>
          <td colspan="1" class="td08">(<spring:message code="LABEL.F.FCOMMON.0006"/><!-- 총 --> <%=DeptPunish_vt.size()%> <spring:message code="LABEL.F.FCOMMON.0007"/><!-- 건 -->)&nbsp;</td>
        </tr>
        <tr><td height="5"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
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
				<td><spring:message code="LABEL.F.F41.0008"/><!-- 직급/연차 --></td>
				<td><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></td>
<%} %>
				<td><spring:message code="LABEL.F.F27.0005"/><!-- 징계시작일 --></td>
				<td><spring:message code="LABEL.F.F27.0006"/><!-- 징계종료일 --></td>
				<td><spring:message code="LABEL.F.F27.0007"/><!-- 징계유형 --></td>
				<td><spring:message code="LABEL.F.F27.0008"/><!-- 징계내역 --></td>
			</tr>

<%
		if( user.area == Area.KR ){
			String oldPer="";
			String sRow = "";
	        for( int i = 0; i < DeptPunish_vt.size(); i++ ){
	        	F27DeptRewardNPunish02Data punishData = (F27DeptRewardNPunish02Data)DeptPunish_vt.get(i);
                if(oldPer.equals(punishData.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt2.get(punishData.PERNR);
                }
                oldPer = punishData.PERNR;
%>
          <tr>
          	<%if (!sRow.equals("")) {%>
	            <td <%= sRow %> style='mso-number-format:"\@";'><%= punishData.PERNR %></td>
				<td <%= sRow %>><%= punishData.ENAME %></td>
				<td <%= sRow %>><%= punishData.ORGTX %></td>
				<td <%= sRow %>><%= punishData.JIKKT %></td>
				<td <%= sRow %>><%= punishData.JIKWT %></td>
				<td <%= sRow %>><%= punishData.JIKCT %></td>
				<td <%= sRow %>><%= punishData.TRFST %></td>
				<td <%= sRow %>><%= punishData.VGLST %></td>
				<td <%= sRow %>><%= (punishData.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(punishData.DAT01) %></td>
			<%} %>
            <td><%= WebUtil.printDate(punishData.BEGDA) %></td>
            <td><%= WebUtil.printDate(punishData.ENDDA) %></td>
            <td><%= punishData.PUNTX %></td>
            <td><%= punishData.PTEXT %></td>
          </tr>
<%
			} //end for...
		}else{
			String oldPer="";
			String sRow = "";
	        for( int i = 0; i < DeptPunish_vt.size(); i++ ){
	        	F27DeptRewardNPunish02GlobalData punishDataG = (F27DeptRewardNPunish02GlobalData)DeptPunish_vt.get(i);
                if(oldPer.equals(punishDataG.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt2.get(punishDataG.PERNR);
                }
                oldPer = punishDataG.PERNR;
%>
          <tr>
          	<%if (!sRow.equals("")) {%>
				<td <%= sRow %>><%= punishDataG.NAME1 %></td>
				<td <%= sRow %> style='mso-number-format:"\@";'><%= punishDataG.PERNR %></td>
				<td <%= sRow %>><%= punishDataG.ENAME %></td>
				<td <%= sRow %>><%= punishDataG.ORGTX %></td>
				<td <%= sRow %>><%= punishDataG.JIKKT %></td>
				<td <%= sRow %>><%= punishDataG.JIKWT %></td>
				<td <%= sRow %>><%= punishDataG.VGLST %></td>
				<td <%= sRow %>><%= (punishDataG.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(punishDataG.DAT01) %></td>
			<%} %>
	            <td><%= WebUtil.printDate(punishDataG.BEGDA) %></td>
	            <td><%= WebUtil.printDate(punishDataG.ENDDA) %></td>
	            <td><%= punishDataG.PUNTX %></td>
	            <td><%= punishDataG.PUNRS %></td>
          </tr>
<%
			} //end for...
		}
%>

        </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
<%
    } //end if...
%>
  <tr><td height="16"></td></tr>
</table>
<!-- 화면에 보여줄 영역 끝 -->

<%
    //조회된 데이터가 존재하지 않을경우.
    if (( DeptReward_vt == null || DeptReward_vt.size() < 0 ) && ( DeptPunish_vt == null || DeptPunish_vt.size() < 0 )) {
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