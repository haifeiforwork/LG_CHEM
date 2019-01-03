<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 자격 소지자 조회                                     */
/*   Program ID   : F24DeptQualificationExcel.jsp                               */
/*   Description  : 부서별 자격 소지자 조회를 위한 jsp 파일                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-31 유용원                                           */
/*   Update      :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 */
/*                    //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel                                                           */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.common.constant.Area" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptQualification_vt = (Vector)request.getAttribute("DeptQualification_vt");
    HashMap empCnt = (HashMap)request.getAttribute("empCnt");

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptQualification.xls");
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
    if ( DeptQualification_vt != null && DeptQualification_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* <!--부서별 자격 소지자  --><spring:message code='LABEL.F.F24.0001'/></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="16" class="td09">&nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!--부서명  --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
	    </tr>
        <tr>
	      <td colspan="16" class="td09">(<!--총--><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptQualification_vt.size()%> <!--건--><spring:message code='LABEL.F.FCOMMON.0007'/>)&nbsp;</td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >

<%
	if( user.area == Area.KR ){
%>
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
                <td><spring:message code="MSG.A.A01.0070"/><!-- 자격면허 --></td>
                <td><spring:message code="MSG.A.A01.0071"/><!-- 취득일 --></td>
                <td><spring:message code="MSG.A.A01.0072"/><!-- 등급 --></td>
                <td><spring:message code="MSG.A.A01.0073"/><!-- 발행기관 --></td>
                <th class="lastCol"><spring:message code="MSG.A.A01.0074"/><!-- 법정선임여부 --></td>
          </tr>
<%

				String oldPer="";
				String sRow = "";
            for( int i = 0; i < DeptQualification_vt.size(); i++ ){
                F24DeptQualificationData data = (F24DeptQualificationData)DeptQualification_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작
                if(data.PERNR.equals(oldPer) ){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt.get(data.PERNR);
                }
                oldPer = data.PERNR;

%>
                <tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><%= data.PERNR %></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.JIKCT %></td>
				<td nowrap <%= sRow %>><%= data.TRFST %></td>
				<td nowrap <%= sRow %>><%= data.VGLST %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
                    <td ><%= data.LICNNM%></td>
                    <td><%= (data.OBNDAT).equals("0000-00-00") ? "" : WebUtil.printDate(data.OBNDAT) %></td>
                    <td><%= data.LGRDNM  %></td>
                    <td><%= data.PBORGH  %></td>
                    <td class="lastCol"><%= data.LAW   %></td>
                </tr>
<%
            } //end for...
	}else{
%>
        <!-- 화면에 보여줄 영역 시작 -->
        <table  border="1" cellspacing="1" cellpadding="4" class="table02">
          <tr>
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
                <td><spring:message code="MSG.A.A01.0070"/><!-- 자격면허 --></td>
                <td><spring:message code="MSG.A.A01.0071"/><!-- 취득일 --></td>
                <td><spring:message code="MSG.A.A01.0072"/><!-- 등급 --></td>
                <!-- //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  -->
                <td class=<%=(user.area== Area.US || user.area== Area.MX) ? "lastCol" :"" %> ><spring:message code="MSG.A.A01.0073"/><!-- 발행기관 --></td>
<%
                if( user.area != Area.US && user.area != Area.MX ){
%>

                <td class="lastCol"><spring:message code="MSG.A.A01.0074"/><!-- 법정선임여부 --></td>
<%
				}
%>
<%

				String oldPer="";
				String sRow = "";
            for( int i = 0; i < DeptQualification_vt.size(); i++ ){
                F24DeptQualificationData data = (F24DeptQualificationData)DeptQualification_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작
                if(data.PERNR.equals(oldPer) ){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt.get(data.PERNR);
                }
                oldPer = data.PERNR;

%>
 <tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><%= data.NAME1 %></td>
				<td nowrap <%= sRow %>><font color=blue><%= data.PERNR %></font></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.ANNUL %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
                    <td ><%= data.LICNNM%></td>
                    <td><%= (data.OBNDAT).equals("0000-00-00") ? "" : WebUtil.printDate(data.OBNDAT) %></td>
                    <td><%= data.LGRDNM  %></td>
                    <!-- //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  -->
                    <td class=<%=(user.area== Area.US || user.area== Area.MX) ? "lastCol" :"" %>><%= data.PBORGH  %></td>
<%
                if( user.area != Area.US || user.area != Area.MX ){
%>
                    <td class="lastCol"><%= data.LAW %></td>
<%
				}
%>
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
    <td  class="td04" align="center" height="25" >해당하는 데이터가 존재하지 않습니다.</td>
  </tr>
</table>
<%
    } //end if...
%>
</form>

</body>
</html>
