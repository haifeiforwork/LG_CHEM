<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   일일 근태 입력 현황										*/
/*   Program Name	:   일일 근태 입력 현황	Excel download				*/
/*   Program ID		: D40TmDailyExcel.jsp									*/
/*   Description		: 일일 근태 입력 현황	Excel download				*/
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
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	Vector T_EXLIST    = (Vector)request.getAttribute("T_EXLIST");

	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

// 	String fileName = java.net.URLEncoder.encode("일일 근태 입력 현황","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0097"),"UTF-8");
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
	    		<col width=100px/>	<!-- 사번  -->
	    		<col width=150px/>	<!-- 이름  -->
	    		<col width=150px/>	<!-- 유형  -->
	    		<col width=150px/>	<!-- 시작일  -->
	    		<col width=100px/>	<!-- 종료일  -->
	    		<col width=100px/>	<!-- 시작시간  -->
	    		<col width=100px/>	<!-- 종료시간  -->
	    		<col width=100px/>	<!-- 휴식시간1  -->
	    		<col width=100px/>	<!-- 휴식종료1  -->
	    		<col width=100px/>	<!-- 휴식시간2  -->
	    		<col width=100px/>	<!-- 휴식종료2  -->
<!-- 	    		<col width=100px/>	근무시간 수  -->
	    		<col width=150px/>	<!-- 사유  -->
	    		<col width=400px/>	<!-- 상세사유  -->
	    		<col width=400px/>	<!-- 최종변경일  -->
	    		<col width=100px/>	<!-- 최종변경자  -->
    		</colgroup>

            <tr>
              <th colspan="14" class="title02"><spring:message code="LABEL.D.D40.0096"/><!-- 사원지급정보 조회 --></th>
              <td><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(T_EXLIST)}' /><!--총 건--></td>
            </tr>
			<tr>
				<th><!-- 사번--><spring:message code="LABEL.D.D12.0017"/></th>
				<th><!-- 이름--><spring:message code="LABEL.D.D12.0018"/></th>
        		<th><!-- 유형 --><spring:message code='LABEL.D.D40.0052' /></th>
         		<th><!-- 시작일--><spring:message code="LABEL.D.D15.0152"/></th>
				<th><!-- 종료일--><spring:message code="LABEL.D.D15.0153"/></th>
          		<th><!-- 시작시간--><spring:message code="LABEL.D.D12.0020"/></th>
				<th><!-- 종료시간--><spring:message code="LABEL.D.D12.0021"/></th>
				<th><!-- 휴식시간1--><spring:message code="LABEL.D.D12.0068"/></th>
				<th><!-- 휴식종료1--><spring:message code="LABEL.D.D12.0069"/></th>
				<th><!-- 휴식시간2--><spring:message code="LABEL.D.D12.0070"/></th>
				<th><!-- 휴식종료2--><spring:message code="LABEL.D.D12.0071"/></th>
<%-- 				<th><!-- 근무시간 수--><spring:message code="LABEL.D.D40.0124"/></th> --%>
				<th><!-- 사유--><spring:message code="LABEL.D.D12.0024"/></th>
				<th><!-- 상세사유--><spring:message code="LABEL.D.D40.0053"/></th>
				<th><!-- 최종변경일--><spring:message code="LABEL.D.D40.0054"/></th>
         		<th class="lastCol"><spring:message code="LABEL.D.D40.0055"/><!-- 최종변경자 --></th>
			</tr>
<%
				if(T_EXLIST.size() > 0){
					for ( int i = 0 ; i < T_EXLIST.size() ; i++ ) {
						   D40TmDailyData data = ( D40TmDailyData ) T_EXLIST.get( i ) ;

						   String BEGUZ = "";
							if(!"".equals(data.BEGUZ)){
								if(data.BEGUZ.length() > 3){
									String bun = (!"24".equals(data.BEGUZ.substring(0,2)))?data.BEGUZ.substring(0,2):"00";
									BEGUZ = bun+":"+data.BEGUZ.substring(2,4);
								}
							}
							String ENDUZ = "";
							if(!"".equals(data.ENDUZ)){
								if(data.ENDUZ.length() > 3){
									String bun = (!"24".equals(data.ENDUZ.substring(0,2)))?data.ENDUZ.substring(0,2):"00";
									ENDUZ = bun+":"+data.ENDUZ.substring(2,4);
								}
							}
							String PBEG1 = "";
							if(!"".equals(data.PBEG1)){
								if(data.PBEG1.length() > 3){
									String bun = (!"24".equals(data.PBEG1.substring(0,2)))?data.PBEG1.substring(0,2):"00";
									PBEG1 = bun+":"+data.PBEG1.substring(2,4);
								}
							}
							String PEND1 = "";
							if(!"".equals(data.PEND1)){
								if(data.PEND1.length() > 3){
									String bun = (!"24".equals(data.PEND1.substring(0,2)))?data.PEND1.substring(0,2):"00";
									PEND1 = bun+":"+data.PEND1.substring(2,4);
								}
							}
							String PBEG2 = "";
							if(!"".equals(data.PBEG2)){
								if(data.PBEG2.length() > 3){
									String bun = (!"24".equals(data.PBEG2.substring(0,2)))?data.PBEG2.substring(0,2):"00";
									PBEG2 = bun+":"+data.PBEG2.substring(2,4);
								}
							}
							String PEND2 = "";
							if(!"".equals(data.PEND2)){
								if(data.PEND2.length() > 3){
									String bun = (!"24".equals(data.PEND2.substring(0,2)))?data.PEND2.substring(0,2):"00";
									PEND2 = bun+":"+data.PEND2.substring(2,4);
								}
							}
%>
			<tr >
            	<td><%=data.PERNR %></td>
                <td><%=data.ENAME %></td>
                <td><%=data.WTMCODE_TX %></td>
                <td>
                	<%if(!"0000-00-00".equals(data.BEGDA)){ %>
                  		<%=data.BEGDA.replace("-",".") %>
                  	<%} %>
                </td>
                <td>
                	<%if(!"0000-00-00".equals(data.ENDDA)){ %>
                  		<%=data.ENDDA.replace("-",".") %>
                  	<%} %>
                </td>
                <td><%=BEGUZ%></td>
                <td><%=ENDUZ%></td>
                <td><%=PBEG1%></td>
                <td><%=PEND1%></td>
                <td><%=PBEG2%></td>
                <td><%=PEND2%></td>
<!--                 <td> -->
<%--                 	<%if(!"0".equals(data.STDAZ)){ %> --%>
<%--                 		<%=data.STDAZ%> --%>
<%--                 	<%}else{ %> --%>
<!--                 		- -->
<%--                 	<%} %> --%>
<!--                 </td> -->
                <td><%=data.REASON_TX %></td>
                <td><%=data.DETAIL%></td>
                <td>
                	<%if(!"0000-00-00".equals(data.AEDTM_TX)){ %>
                		<%=data.AEDTM_TX.replace("-",".")%>
                	<%} %>
                </td>
               	<td class="lastCol"><%=data.UNAME_TX %></td>
            </tr>
<%
			} //end for
	    } else {
%>
			<tr class="oddRow" >
				<td class="lastCol" colspan="15"><spring:message code="MSG.COMMON.0004"/></td>
			</tr>
<%
    	}
%>
        </table>
	</form>
</body>
</html>

