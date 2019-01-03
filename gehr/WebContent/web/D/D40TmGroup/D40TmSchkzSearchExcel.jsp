<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정												*/
/*   Program Name	:   계획근무일정	(일괄)	 엑셀템플릿다운로드			*/
/*   Program ID		: D40TmSchkzPlanningChartPrint.jsp					*/
/*   Description		: 계획근무일정(개별)	엑셀템플릿다운로드				*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	Vector resultList    = (Vector)request.getAttribute("resultList");
// 	String paramTIME_GRUP = WebUtil.nvl(request.getParameter("paramTIME_GRUP"));
// 	String paramBEGDA = WebUtil.nvl(request.getParameter("paramBEGDA"));

	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

// 	String fileName = java.net.URLEncoder.encode("계획근무일정","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0019"),"UTF-8");
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
		<table>
			<tr><th></th><td></td></tr>
		</table>
    	<table border="1" cellpadding="0" cellspacing="1" class="table02">
    		<colgroup>
	    		<col width=100px/>	<!-- 사번-->
	    		<col width=120px/>	<!-- 이름-->
	    		<col width=100px/>	<!-- 입력일자-->
	    		<col width=200px/>	<!-- 부서-->
<!-- 	    		<col width=200px/>	현부서 -->
	    		<col width=100px/>	<!-- 현부서일자-->
<!-- 	    		<col width=100px/>	퇴직일자 -->
    		</colgroup>

            <tr>
              <th colspan="7" class="title02"><spring:message code="TAB.D.D40.0005"/><!-- 계획근무일정 조회/변경(개별) --></th>
              <td><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(resultList)}' /><!--총 건--></td>
            </tr>
			<tr>
				<th rowspan="2"><!-- 구분--><spring:message code='LABEL.F.F42.0055'/></th>
				<th rowspan="2"><!-- 사번--><spring:message code='LABEL.D.D05.0005'/></th>
				<th rowspan="2"><!-- 이름--><spring:message code='LABEL.D.D05.0006'/></th>
				<th colspan="4"><!-- 기준일--><spring:message code='LABEL.D.D40.0031'/></th>
<%-- 				<th colspan="4"><!-- 변경--><spring:message code='LABEL.D.D40.0032'/></th> --%>
				<th rowspan="2" class="lastCol"><!-- 비고--><spring:message code='LABEL.D.D14.0017'/></th>
<%-- 				<th rowspan="2" class="lastCol"><!-- 오류메세지--><spring:message code='LABEL.D.D40.0023'/></th> --%>
			</tr>
			<tr>
				<th><!-- 시작일--><spring:message code='LABEL.D.D15.0152'/></th>
				<th><!-- 종료일--><spring:message code='LABEL.D.D15.0153'/></th>
				<th><!-- 근무일정--><spring:message code='LABEL.D.D40.0033'/></th>
				<th><!-- 근무일정명--><spring:message code='LABEL.D.D13.0016'/></th>
<%-- 				<th><!-- 시작일--><spring:message code='LABEL.D.D15.0152'/></th> --%>
<%-- 				<th><!-- 종료일--><spring:message code='LABEL.D.D15.0153'/></th> --%>
<%-- 				<th><!-- 근무일정--><spring:message code='LABEL.D.D40.0033'/></th> --%>
<%-- 				<th><!-- 근무일정명--><spring:message code='LABEL.D.D13.0016'/></th> --%>
			</tr>
<%
				if ( resultList.size() > 0 ) {
					if( resultList != null & resultList.size() > 0 ){
						for( int i = 0; i < resultList.size(); i++ ) {
							D40TmSchkzFrameData data = (D40TmSchkzFrameData)resultList.get(i);

%>
			<tr>
				<td><%= i+1%></td>
				<td><%=WebUtil.printString( data.PERNR )%></td>
				<td><%=WebUtil.printString( data.ENAME )%></td>
				<td><%=WebUtil.printString( data.BEGDA ).replace("-",".")%></td>
				<td><%=WebUtil.printString( data.ENDDA ).replace("-",".")%></td>
				<td><%=WebUtil.printString( data.SCHKZ )%></td>
				<td><%=WebUtil.printString( data.SCHKZ_TX )%></td>
<!-- 				<td> -->
<%-- 					<% if(!"0000-00-00".equals(data.NBEGDA)){ %> --%>
<%-- 						<%=WebUtil.printString( data.NBEGDA ).replace("-",".")%> --%>
<%-- 					<%} %> --%>
<!-- 				</td> -->
<!-- 				<td> -->
<%-- 					<% if(!"0000-00-00".equals(data.NENDDA)){ %> --%>
<%-- 						<%=WebUtil.printString( data.NENDDA ).replace("-",".")%> --%>
<%-- 					<%} %> --%>
<!-- 				</td> -->
<%-- 				<td><%=WebUtil.printString( data.NSCHKZ )%></td> --%>
<%-- 				<td><%=WebUtil.printString( data.NSCHKZ_TX )%></td> --%>
				<td class="lastCol"><%=WebUtil.printString( data.ETC )%></td>
<%-- 				<td class="lastCol"><%=WebUtil.printString( data.MSG )%></td> --%>
			</tr>
<%
			} //end for
		}
%>
<%
    } else {
%>
			<tr align="center">
				<td  colspan="9"><spring:message code="MSG.COMMON.0004"/></td>
            </tr>
<%
    }
%>
        </table>
	</form>
</body>
</html>

