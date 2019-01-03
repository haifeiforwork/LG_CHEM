<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태그룹관리												*/
/*   Program Name	:   근태그룹 인원 지정	(엑셀다운로드)					*/
/*   Program ID		: D40TmGroupPersExcel.jsp							*/
/*   Description		: 근태그룹 인원 지정(엑셀다운로드)						*/
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
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	Vector resultList    = (Vector)request.getAttribute("resultList");
	String paramTIME_GRUP = WebUtil.nvl(request.getParameter("paramTIME_GRUP"));
	String paramBEGDA = WebUtil.nvl(request.getParameter("paramBEGDA"));

	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

// 	String fileName = java.net.URLEncoder.encode("근태그룹인원지정","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0062"),"UTF-8");

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
		      	<col width=100px/>
	    		<col width=120px/>
	      	</colgroup>
			<tr>
	        	<th><spring:message code='LABEL.D.D40.0004' /><!-- 근태그룹 --> </th>
	          	<td><%=paramTIME_GRUP%></td>
	        </tr>
	        <tr>
	          	<th><spring:message code='LABEL.D.D40.0016' /><!-- 입력자 --></th>
	          	<td><%=user.ename %></td>
	        </tr>
<!-- 	        <tr> -->
<%-- 	          	<th><spring:message code='LABEL.D.D40.0006' /><!-- 적용일자 --></th> --%>
<%-- 	          	<td><%=paramBEGDA %></td> --%>
<!-- 	        </tr> -->
	    </table>
		<table>
			<tr><th></th><td></td></tr>
		</table>
    	<table border="1" cellpadding="0" cellspacing="1" class="table02">
    		<colgroup>
	    		<col width=100px/>	<!-- 사번-->
	    		<col width=120px/>	<!-- 이름-->
	    		<col width=100px/>	<!-- 지정일자-->
<!-- 	    		<col width=200px/>	부서 -->
	    		<col width=200px/>	<!-- 현부서-->
<!-- 	    		<col width=100px/>	현부서일자 -->
<!-- 	    		<col width=100px/>	퇴직일자 -->
    		</colgroup>

            <tr>
              <th colspan="3" class="title02"><spring:message code="LABEL.D.D40.0011" /><!-- 근태그룹 인원 지정 --></th>
              <td><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(resultList)}' /><!--총 건--></td>
            </tr>
			<tr>
       			<th><!-- 사번 --><spring:message code='LABEL.D.D12.0017' /></th>
       			<th><!-- 이름 --><spring:message code='LABEL.D.D12.0018' /></th>
       			<th><!-- 지정일자 --><spring:message code='LABEL.D.D40.0012' /></th>
<%--        			<th style="display: none;"><!-- 부서 --><spring:message code='LABEL.D.D12.0051' /></th> --%>
       			<th class="lastCol"><spring:message code="LABEL.COMMON.0029"/><%--소속--%></th>
<%--        			<th style="display: none;"><!-- 현부서일자 --><spring:message code='LABEL.D.D40.0014' /></th> --%>
<%--       			<th style="display: none;" class="lastCol"><!-- 퇴직일자 --><spring:message code='LABEL.D.D40.0015' /></th> --%>
			</tr>
<%
				if ( resultList.size() > 0 ) {
					if( resultList != null & resultList.size() > 0 ){
						for( int i = 0; i < resultList.size(); i++ ) {
							D40TmGroupPersData data = (D40TmGroupPersData)resultList.get(i);

%>
			<tr>
				<td><%=WebUtil.printString( data.SPERNR )%></td>
				<td><%=WebUtil.printString( data.SPERNR_TX )%></td>
				<td><%=WebUtil.printString( data.OBEGDA ).replace("-",".")%></td>
<%-- 				<td style="display: none;"><%=WebUtil.printString( data.SORGEH_TX )%></td> --%>
				<td><%=WebUtil.printString( data.ORGEH_TX )%></td>
<!-- 				<td style="display: none;"> -->
<%-- 					<% if(!"0000-00-00".equals(data.ORGEH_DT)){ %> --%>
<%-- 						<%=WebUtil.printString( data.ORGEH_DT ).replace("-",".")%> --%>
<%-- 					<%} %> --%>
<!-- 				</td> -->
<!-- 				<td style="display: none;" class="lastCol"> -->
<%-- 					<% if(!"0000-00-00".equals(data.PERSG_DT)){ %> --%>
<%-- 						<%=WebUtil.printString( data.PERSG_DT ).replace("-",".")%> --%>
<%-- 					<%} %> --%>
<!-- 				</td> -->
			</tr>
<%
			} //end for
		}
%>
<%
    } else {
%>
			<tr align="center">
				<td  colspan="4"><spring:message code="MSG.COMMON.0004"/></td>
            </tr>
<%
    }
%>
        </table>
	</form>
</body>
</html>

