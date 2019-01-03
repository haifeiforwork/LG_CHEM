<%--
/********************************************************************************/
/*																				*/
/*   System Name	:  MSS														*/
/*   1Depth Name	:   부서근태													*/
/*   2Depth Name	:   초과근무													*/
/*   Program Name	:   초과근무(개별)	 엑셀다운로드								*/
/*   Program ID		: D40OverTimeEachExcel.jsp									*/
/*   Description	: 초과근무(개별) 엑셀다운로드									*/
/*   Note			:             												*/
/*   Creation		: 2017-12-08  정준현                                          		*/
/*   Update			: 2017-12-08  정준현                                          		*/
/*   				: 2018-06-18  성환희 [Worktime52]                            */
/*                                                                              */
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	Vector resultList    = (Vector)request.getAttribute("OBJPS_OUT2");
// 	String paramTIME_GRUP = WebUtil.nvl(request.getParameter("paramTIME_GRUP"));
// 	String paramBEGDA = WebUtil.nvl(request.getParameter("paramBEGDA"));

    Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0036"),"UTF-8");
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
	    		<col width=100px/>	<!-- 구분-->
	    		<col width=150px/>	<!-- 사번-->
	    		<col width=150px/>	<!-- 이름-->
	    		<col width=150px/>	<!-- 총근무시간(주)-->
	    		<col width=150px/>	<!-- 일자-->
	    		<col width=150px/>	<!-- 일자-->
	    		<col width=100px/>	<!-- 시작시간-->
	    		<col width=100px/>	<!-- 종료시간-->
	    		<col width=100px/>	<!-- 휴식시간1-->
	    		<col width=100px/>	<!-- 휴식종료2-->
	    		<col width=100px/>	<!-- 휴식시간2-->
	    		<col width=100px/>	<!-- 휴식종료2-->
	    		<col width=100px/>	<!-- 이전일-->
	    		<col width=100px/>	<!-- 사유코드-->
	    		<col width=100px/>	<!-- 사유텍스트-->
	    		<col width=400px/>	<!-- 사유상세-->
	    		<col width=100px/>	<!-- 일일근무일정-->
	    		<col width=400px/>	<!-- 비고-->
    		</colgroup>

            <tr>
              <th colspan="17" class="title02"><spring:message code='LABEL.D.D40.0041'/><!-- 초과근무 조회 --></th>
              <td><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(OBJPS_OUT2)}' /><!--총 건--></td>
            </tr>
			<tr>
				<th><!-- 구분--><spring:message code='LABEL.F.F42.0055'/></th>
				<th><!-- 사번--><spring:message code='LABEL.D.D05.0005'/></th>
				<th><!-- 이름--><spring:message code='LABEL.D.D05.0006'/></th>
				<th><!-- 실근무시간(주)--><spring:message code='LABEL.D.D12.0085'/></th>
				<th><!-- 시작일--><spring:message code="LABEL.D.D15.0152"/></th>
				<th><!-- 종료일--><spring:message code="LABEL.D.D15.0153"/></th>
				<th><!-- 시작시간--><spring:message code="LABEL.D.D12.0020"/></th>
				<th><!-- 종료시간--><spring:message code="LABEL.D.D12.0021"/></th>
				<th><!-- 휴식시간1--><spring:message code="LABEL.D.D12.0068"/></th>
				<th><!-- 휴식종료1--><spring:message code="LABEL.D.D12.0069"/></th>
				<th><!-- 휴식시간2--><spring:message code="LABEL.D.D12.0070"/></th>
				<th><!-- 휴식종료2--><spring:message code="LABEL.D.D12.0071"/></th>
				<th><!-- 이전일--><spring:message code="LABEL.D.D12.0023"/></th>
				<th><!-- 사유코드--><spring:message code="LABEL.D.D40.0038"/></th>
				<th><!-- 사유텍스트--><spring:message code="LABEL.D.D40.0039"/></th>
				<th><!-- 사유상세--><spring:message code="LABEL.D.D40.0040"/></th>
				<th><!-- 일일근무일정--><spring:message code="LABEL.D.D12.0053"/></th>
				<th class="lastCol"><!-- 비고--><spring:message code='LABEL.D.D14.0017'/></th>
			</tr>
<%
				if ( resultList.size() > 0 ) {
					if( resultList != null & resultList.size() > 0 ){
						for( int i = 0; i < resultList.size(); i++ ) {
							D40OverTimeFrameData data = (D40OverTimeFrameData)resultList.get(i);
							String BEGUZ = "";
							if(!"".equals(data.BEGUZ)){
								if(data.BEGUZ.length() > 4){
									BEGUZ = data.BEGUZ.substring(0,2)+":"+data.BEGUZ.substring(2,4);
								}
							}
							String ENDUZ = "";
							if(!"".equals(data.ENDUZ)){
								if(data.ENDUZ.length() > 4){
									ENDUZ = data.ENDUZ.substring(0,2)+":"+data.ENDUZ.substring(2,4);
								}
							}
							String PBEG1 = "";
							if(!"".equals(data.PBEG1)){
								if(data.PBEG1.length() > 4){
									PBEG1 = data.PBEG1.substring(0,2)+":"+data.PBEG1.substring(2,4);
								}
							}
							String PEND1 = "";
							if(!"".equals(data.PEND1)){
								if(data.PEND1.length() >4){
									PEND1 = data.PEND1.substring(0,2)+":"+data.PEND1.substring(2,4);
								}
							}
							String PBEG2 = "";
							if(!"".equals(data.PBEG2)){
								if(data.PBEG2.length() > 4){
									PBEG2 = data.PBEG2.substring(0,2)+":"+data.PBEG2.substring(2,4);
								}
							}
							String PEND2 = "";
							if(!"".equals(data.PEND2)){
								if(data.PEND2.length() > 4){
									PEND2 = data.PEND2.substring(0,2)+":"+data.PEND2.substring(2,4);
								}
							}
%>
			<tr>
				<td><%= i+1%></td>
				<td><%=data.PERNR%></td>
				<td><%=data.ENAME%></td>
				<td><%=Math.floor(Double.parseDouble(data.WWKTM) * 10) / 10%></td>
				<td>
					<% if(!"0000-00-00".equals(data.BEGDA)){ %>
						<%=data.BEGDA.replace("-",".")%>
					<%} %>
				</td>
				<td>
					<% if(!"0000-00-00".equals(data.ENDDA)){ %>
						<%=data.ENDDA.replace("-",".")%>
					<%} %>
				</td>
				<td><%=BEGUZ%></td>
				<td><%=ENDUZ%></td>
				<td><%=PBEG1%></td>
				<td><%=PEND1%></td>
				<td><%=PBEG2%></td>
				<td><%=PEND2%></td>
				<td>
				<%if("X".equals(data.VTKEN)){ %>
					√
				<%} %>
				</td><!-- 이전일 -->
				<td><%=data.REASON%></td><!-- 사유코드 -->
				<td><%=data.REASON_TX%></td><!-- 사유텍스트 -->
				<td><%=data.DETAIL%></td><!-- 상세사유 -->
				<td><%=data.TPROG%></td><!-- 일일근무일정 -->
				<td class="lastCol"><%=data.ETC%></td>
			</tr>
<%
			} //end for
		}
%>
<%
    } else {
%>
			<tr align="center">
				<td  colspan="18"><spring:message code="MSG.COMMON.0004"/></td>
            </tr>
<%
    }
%>
        </table>
	</form>
</body>
</html>

