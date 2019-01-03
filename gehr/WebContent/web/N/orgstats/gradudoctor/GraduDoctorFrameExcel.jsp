<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
 <%@ page import="hris.N.EHRCommonUtil"%>
 <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	String sMenuText = WebUtil.nvl(request.getParameter("sMenuText"));
	String hName= g.getMessage("MSG.N.N02.0007"); //- 박사 인원현황
	String command = request.getParameter("command");
	if(command.equals("02")){
		hName= g.getMessage("MSG.N.N02.0008"); //- 석사 인원현황
	}else if(command.equals("03")){
		hName= g.getMessage("MSG.N.N02.0009"); //- LG MBA 인원현황
	}

	/*----- Excel 파일 저장하기 --------------------------------------------------- */
	response.setHeader("Content-Disposition","attachment;filename=GraduDoctor"+command+".xls");
	response.setContentType("application/vnd.ms-excel;charset=utf-8");
	/*----------------------------------------------------------------------------- */


	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	Vector VT1 = (Vector)qlHM.get("T_EXPORT"+Integer.parseInt(command));


	int vtSize1 = VT1.size();

	HashMap<String, String> T_EXPORT1 = new HashMap<String, String>();

	 String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                              //부서명
//		엑셀 데이터제목들
		String I_INOUT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUT"));


		String tabName = EHRCommonUtil.nullToEmpty((String)request.getParameter("tabName"));
		String I_INOUTXT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUTXT"));
		String selectRegTxt = EHRCommonUtil.nullToEmpty((String)request.getParameter("selectRegTxt"));
		String searchNation = EHRCommonUtil.nullToEmpty((String)request.getParameter("searchNation"));
		if(searchNation.equals("")){
			searchNation=g.getMessage("LABEL.N.N02.0012"); //전체
		}
%>


<html >
<head>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
	<style type="text/css">
		.orgStats_tb {padding-left:20px;}
		.excelTitle {text-align:center;font-family:malgun gothic;font-size:15px;font-weight:bold;color:#ee8aa3}
		.tb_def {table-layout:fixed;}
		.tb_def th {font-family:malgun gothic;color:#000;font-size:12px;font-weight:bold;border:solid 1px #000;background:#dfdfdf}
		.tb_def td {font-family:malgun gothic;color:#000;font-size:12px;font-weight:normal;border:solid 1px #000;text-align:center;}
		.colSum {font-family:malgun gothic;color:#000;font-size:12px;font-weight:bold;border:solid 1px #000;background:#f4eeff}

	</style>
</head>

<body id="" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="subWrapper" >

	<div class="contentBody" >
		<div class="orgStatsWrap" >
			<div class="orgStats_tb"  >
				<!-- 테이블 시작 -->
<table width="1000" >
	<tr>
		<td>&nbsp;</td>
		<td>
				<table width="880">
					<tr>
						<td  height="20" colspan="10"></td>
					</tr>
					<tr>
						<td height="30" colspan="10" align="center" class="excelTitle"><h3>■ <%=g.getMessage("COMMON.MENU.MSS_TALE_DOCT")%><%=hName %></h3></td>
					</tr>

				</table>
				<table width="880">
					<tr>
						<td height="20" colspan="10" style="text-align: left" ><b> <spring:message code="LABEL.N.N02.0007" /><!-- 구분 -->:  <font color="#4169E1"><%=I_INOUTXT %></font><%if(I_INOUT.equals("2")){ %> <spring:message code="LABEL.N.N02.0052" /><!-- 해외지역 -->: <font color="#4169E1"><%=selectRegTxt %></font> <spring:message code="LABEL.N.N02.0015" /><!-- 국가 --> : <font color="#4169E1"><%=searchNation %></font><%} %></b></td>
					</tr>


					<tr>
						<td height="10" colspan="10" class=""><h5><spring:message code="LABEL.N.N02.0004" /><!-- 부서명 -->: <%=deptNm %></h5></td>
					</tr>
				</table>
				<table class="tb_def" summary="" >
					<caption></caption>
					<thead>

						<tr>
							<th width="190"><spring:message code="LABEL.N.N02.0007" /><!-- 구분 --></th>
<%
	for(int h=0; h < vtSize1 ; h ++){
		 T_EXPORT1 = (HashMap)VT1.get(h);
	     String  CODTX = T_EXPORT1.get("CODTX");
	     for( int j =0 ; j < 20 	; j++){
				String idx ="";
				if(j < 9){
					idx = "0"+(j+1);
				}else{
					idx =""+(j+1);
				}
				String GUBUN =  T_EXPORT1.get("GUBUN"+idx);
				String COUNT =  T_EXPORT1.get("COUNT"+idx);
	     		if(h == 0){
					if(!GUBUN.equals("")){
%>
							<th><%=COUNT %></th>

<%       		}
				}else{
					if(!GUBUN.equals("")){
%>
                           	<%if(j == 0){ %>
                           	<tr <%if(vtSize1-1 == h){ %>class="colSum" <%} %>>
                           	<td width="190"><%= CODTX %></td>
                           	<%} %>
							<td width="190"><%=COUNT %></td>

<%				}
				}
		}

	    %>
	    </tr>
	    <%
	}
%>
				</table>
				<!-- 테이블 끝 -->


	</td>
	</tr>
	</table>

			</div><!-- /orgStats_tb -->
		</div><!-- /orgStatsWrap -->

	</div><!-- /contentBody -->
</div><!-- /subWrapper -->
</body>
</html>