<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.N.EHRCommonUtil" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>
<%@ page import="com.sns.jdf.util.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<% HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	 String deptNm = WebUtil.nvl((String)request.getAttribute("deptNm"));
	  Vector detailVT = (Vector)qlHM.get("T_EXPORT");
	  HashMap<String, String> qlhm = new HashMap<String, String>();
	  Vector datavt = new Vector();
//

	//암호화 추가
	//	 웹로그 메뉴 코드명 2015-09-08
	    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
		String command = WebUtil.nvl((String)request.getAttribute("command"));
	    String viewGubun = EHRCommonUtil.nullToEmpty((String)request.getParameter("viewGubun"));
	    /*----- Excel 파일 저장하기 --------------------------------------------------- */
	    response.setHeader("Content-Disposition","attachment;filename=OrgDetail"+command+"Information"+viewGubun+".xls");
	    response.setContentType("application/vnd.ms-excel;charset=utf-8");
	    /*----------------------------------------------------------------------------- */


	//평가3개년 컬럼 이름
	String  I_YEAR = ((String)request.getAttribute("I_YEAR")).substring(2);
	int yearN1 = Integer.parseInt(I_YEAR);

	if(I_YEAR.equals(DataUtil.getCurrentYear().substring(2))){
		 yearN1 =  Integer.parseInt(I_YEAR) -1 ;
	}
	int yearN2 = yearN1  -1;
	int yearN3 = yearN1 -2;


//	엑셀 데이터제목들
	String I_INOUT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUT"));

	String sMenuText = EHRCommonUtil.nullToEmpty((String)request.getParameter("sMenuText"));
	String tabName = EHRCommonUtil.nullToEmpty((String)request.getParameter("tabName"));
	String I_INOUTXT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUTXT"));
	String selectRegTxt = EHRCommonUtil.nullToEmpty((String)request.getParameter("selectRegTxt"));
	String searchNation = EHRCommonUtil.nullToEmpty((String)request.getParameter("searchNation"));
	if(searchNation.equals("")){
		searchNation=g.getMessage("LABEL.N.N02.0012"); //전체
	}

	String I_ITEMTXT =  EHRCommonUtil.nullToEmpty(request.getParameter("I_ITEMTXT"));
	String searchYear =  EHRCommonUtil.nullToEmpty(request.getParameter("searchYear"));
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

<table >
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
				<table width="880">
					<tr>
						<td  height="20" colspan="10"></td>
					</tr>
					<tr>
						<td height="30" colspan="29" align="center" class="excelTitle"><h3>■ <%=sMenuText %> <spring:message code="LABEL.N.N02.0017" /><!-- 인원 상세 정보 --> <%= tabName%>&nbsp;<spring:message code="LABEL.N.N02.0018" arguments="<%=detailVT.size() %>"/><%-- (총 : <%=detailVT.size() %>건) --%><%if(viewGubun.equals("LF")){ %>&nbsp;<b><spring:message code="LABEL.N.N02.0019" /><!-- - 계약직 포함 --></b><%} %></h3></td>
					</tr>
<%if(viewGubun.equals("GD")){ %>
					<tr>
						<td height="20" colspan="29" style="text-align: left" ><b> <spring:message code="LABEL.N.N02.0007" /><!-- 구분 -->:  <font color="#4169E1"><%=I_INOUTXT %></font><%if(I_INOUT.equals("2")){ %> <spring:message code="LABEL.N.N02.0052" /><!-- 해외지역 -->: <font color="#4169E1"><%=selectRegTxt %></font> <spring:message code="LABEL.N.N02.0015" /><!-- 국가 --> : <font color="#4169E1"><%=searchNation %></font><%} %></b></td>
					</tr>
<%}else if(viewGubun.equals("GP") || viewGubun.equals("LF")){ %>
					<tr>
						<td height="20" colspan="29" style="text-align: left" ><b><spring:message code="LABEL.N.N02.0014" /><!-- 지역 -->: <font color="#4169E1"><%=selectRegTxt %></font> <spring:message code="LABEL.N.N02.0015" /><!-- 국가 --> : <font color="#4169E1"><%=searchNation %></font></b></td>
					</tr>
<%}else if(viewGubun.equals("LA") ){ %>
					<tr>
						<td height="20" colspan="29" style="text-align: left" ><b><spring:message code="LABEL.N.N02.0007" /><!-- 구분 -->: <font color="#4169E1"><%=I_ITEMTXT %></font></b></td>
					</tr>
<%}else if(viewGubun.equals("BP") ){ %>
					<tr>
						<td height="20" colspan="29" style="text-align: left" ><b><spring:message code="LABEL.N.N02.0053" /><!-- 조회년도 -->: <font color="#4169E1"><%=searchYear %></font></b></td>
					</tr>
<%} %>
				</table>
				<table width="880">

					<tr>
						<td height="20" colspan="29" style="text-align: left" ><h4> <spring:message code="LABEL.N.N02.0004" /><!-- 부서명 --> : <%=deptNm %></h4></td>
					</tr>

				</table>
				<table class="tb_def" summary="" >

<thead>
	<tr>
		  <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0054" /><!-- NO --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0055" /><!-- 사번 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0024" /><!-- 성명 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0025" /><!-- 부서 --></th>
          <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
          <%--<th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0026" /><!-- 직위 --></th> --%>
          <th class="td03" rowspan="2"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
           <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0027" /><!-- 연차 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0028" /><!-- 직책 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0029" /><!-- 성별 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0030" /><!-- 입사일 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0031" /><!-- 직무 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0032" /><!-- 근무지 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0033" /><!-- 연령 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0034" /><!-- 근속 --></th>
          <th class="td03" colspan="3"><spring:message code="LABEL.N.N02.0035" /><!-- 학력사항 --></th>
          <th class="td03" colspan="3"><spring:message code="LABEL.N.N02.0041" /><!-- 평가 --></th>
          <th class="td03" colspan="4"><spring:message code="LABEL.N.N02.0042" /><!-- 어학 --></th>
        <!--  <th class="td03" rowspan="2">사업가</th> -->
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0048" /><!-- 차세대 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0049" /><!-- HPI --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0050" /><!-- 국적 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0001" /><!-- 학위 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0002" /><!-- 주재원 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0051" /><!-- 연수파견 --></th>
          <th class="td03" rowspan="2"><spring:message code="LABEL.N.N02.0003" /><!-- 지역전문가 --></th>
		</tr>
        <tr>

          <th class="td03" ><spring:message code="LABEL.N.N02.0036" /><!-- 학력 --></th>
          <th class="td03" ><spring:message code="LABEL.N.N02.0037" /><!-- 학교 --></th>
          <th class="td03" ><spring:message code="LABEL.N.N02.0038" /><!-- 전공 --></th>
          <th class="td03" ><%=yearN1 %><spring:message code="LABEL.N.N02.0043" /><!-- 년 --></th>
          <th class="td03" ><%=yearN2 %><spring:message code="LABEL.N.N02.0043" /><!-- 년 --></th>
          <th class="td03" ><%=yearN3 %><spring:message code="LABEL.N.N02.0043" /><!-- 년 --></th>
          <th class="td03" ><spring:message code="LABEL.N.N02.0044" /><!-- LAP --></th>
          <th class="td03" ><spring:message code="LABEL.N.N02.0045" /><!-- TOEIC --></th>
          <th class="td03" ><spring:message code="LABEL.N.N02.0046" /><!-- HSK --></th>
          <th class="td03" ><spring:message code="LABEL.N.N02.0047" /><!-- JPT --></th>

</tr>
</thead>

 <% for(int i = 0 ; i < detailVT.size() ; i++){
	  		qlhm = (HashMap)detailVT.get(i);
	  		String tyear = qlhm.get("TITLE_YEAR").substring(1);
			if(tyear.equals("00")){
				tyear = "";
			}
%>

<tr>
								<td width=""> <%= i+1 %> </td>
								<td> <%= qlhm.get("PERNR") %> </td>
								<td ><%= qlhm.get("ENAME") %></td>
								<td><%= qlhm.get("STEXT") %></td>
								<td><%= qlhm.get("TITEL") %></td>
								<td><%=tyear %></td>
								<td><%= qlhm.get("TITL2") %></td>
								<% if(qlhm.get("GENDER").equals("M")){ %>
								<td><spring:message code="LABEL.N.N02.0039" /><!-- 남자 --></td>
							<%}else{ %>
								<td><spring:message code="LABEL.N.N02.0040" /><!-- 여자 --></td>
							<%} %>
								<td><%= WebUtil.printDate(qlhm.get("LDAT")) %></td>
								<td><%= qlhm.get("STELL_TEXT") %></td>
								<td><%= qlhm.get("BTEXT") %></td>
								<td><%= qlhm.get("OLDS") %></td>
								<td><%= qlhm.get("GNSOK")%></td>
								<td><%= qlhm.get("FMCNTXT") %></td>
								<td><%= qlhm.get("LART_TEXT") %></td>
								<td><%= qlhm.get("FTEXT1") %></td>
								<td><%= qlhm.get("PERS_APP1") %></td>
								<td><%= qlhm.get("PERS_APP2") %></td>
								<td><%= qlhm.get("PERS_APP3") %></td>
								<td><%= qlhm.get("LGAX_SCOR") %></td>
								<td><%= WebUtil.nvl(qlhm.get("TOEI_SCOR")) %></td>
								<td><%= WebUtil.nvl(qlhm.get("LANG_LEVL")) %></td>
								<td><%	if (!"000".equals(qlhm.get("JPT_SCOR"))) {%>
									  <%=qlhm.get("JPT_SCOR")%>
									 <% } %>
								</td>
							<!--<td><%= qlhm.get("BIZ_CAN") %></td>  -->
								<td><%= qlhm.get("FGLEADER") %></td>
								<td><%= qlhm.get("HPI") %></td>
								<td><%=qlhm.get("NATIO")%></td>
								<td ><%= qlhm.get("OSDEGR") %></td>
								<td><%= qlhm.get("RESIDENT") %></td>
								<td><%= qlhm.get("LEDU_DEGR") %></td>
								<td><%= qlhm.get("AMASTER") %></td>
							</tr>
<%} %>
						</tbody>
					</table>
      </li>

  </ul>
	<div class="clear"></div>


	</div><!-- /contentBody -->
	</div><!-- /wrapWidth -->
</div><!-- /subWrapper -->
</body>
</html>


