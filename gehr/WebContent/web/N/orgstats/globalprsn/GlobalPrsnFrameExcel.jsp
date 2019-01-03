<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.N.EHRCommonUtil"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%

	String hName=g.getMessage("MSG.N.N02.0001"); //- 학위
	String command = request.getParameter("command");

    String tabNo =  "0";
    if(command.equals("E")){
    	tabNo =  "1";
    	hName=g.getMessage("MSG.N.N02.0002"); //- 주재원
    }else if(command.equals("0002")){
    	tabNo =  "2";
    	hName=g.getMessage("MSG.N.N02.0003"); //- 지역전문가
    }

 	/*----- Excel 파일 저장하기 --------------------------------------------------- */
	response.setHeader("Content-Disposition","attachment;filename=GlobalPrsn"+command+".xls");
	response.setContentType("application/vnd.ms-excel;charset=utf-8");
	/*----------------------------------------------------------------------------- */


	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	Vector orgVT = (Vector)qlHM.get("T_EXPORT"+(Integer.parseInt(tabNo)+1));

	int qlSize = orgVT.size();
	HashMap<String, String> T_EXPORT = new HashMap<String, String>();

//	코드의 text를 찾고 서브그룹이 몇개인지 체크한다.
	String subTemp ="";
	int subcount = 0;

	Vector codeVT = new Vector();
	Vector codeSizeVT = new Vector();

	if(qlSize > 0){
		for(int h=0; h < 1 ; h ++){
			 T_EXPORT = (HashMap)orgVT.get(h);

		     for( int j =0 ; j < 20 	; j++){
					String idx ="";
					if(j < 9){
						idx = "0"+(j+1);
					}else{
						idx =""+(j+1);
					}
					String SUBTY =  T_EXPORT.get("SUBTY"+idx);
					String SUBTX =  T_EXPORT.get("SUBTX"+idx);
					if(!SUBTY.equals(subTemp)){
						if(!SUBTY.equals("")){
							codeVT.add(SUBTX);
						}
						if(j !=0){
							codeSizeVT.add(subcount+"");
							subcount =0;
						}
					}
					subTemp = SUBTY;
					subcount ++;

		     }
		}
	}
	 String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                              //부서명
	 String sMenuText = WebUtil.nvl(request.getParameter("sMenuText"));
	 String tabName = EHRCommonUtil.nullToEmpty((String)request.getParameter("tabName"));
	 String I_INOUTXT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUTXT"));
	 String selectRegTxt = EHRCommonUtil.nullToEmpty((String)request.getParameter("selectRegTxt"));
	 if(selectRegTxt.equals("")){
		 selectRegTxt=g.getMessage("LABEL.N.N02.0012"); //전체
	}
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
<div class="" >

	<div class="" >
		<div class="" >
			<div class="orgStats_tb"  >
				<!-- 테이블 시작 -->
<table width="1000">
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
				<table width="880">
					<tr>
						<td  height="20" colspan="14"></td>
					</tr>
					<tr>
						<td height="30" colspan="14" align="center" class="excelTitle"><h3>■ <%=sMenuText %><%=hName %></h3></td>
					</tr>

				</table>
				<table width="880">

					<tr>
						<td height="30" colspan="14" style="text-align: left" ><b><spring:message code="LABEL.N.N02.0014" /><!-- 지역 -->: <font color="#4169E1"><%=selectRegTxt %></font> <spring:message code="LABEL.N.N02.0015" /><!-- 국가 --> : <font color="#4169E1"><%=searchNation %></font></b></td>
					</tr>
					<tr>
						<td height="30" colspan="14" class=""><h5><spring:message code="LABEL.N.N02.0004" /><!-- 부서명 -->: <%=deptNm %></h5></td>
					</tr>
				</table>



				<!-- 테이블 시작 -->
				<table class="tb_def" summary="" >
					<caption></caption>

					<thead>
						<tr>
							<th width="190" rowspan="2"><spring:message code="LABEL.N.N02.0007" /><!-- 구분 --></th>

<%                      // 헤더중 top헤더를 만든다.
							int hSize = codeVT.size();

							for(int n = 0; n < hSize ; n ++){
								String sText =(String)codeVT.get(n);
								String sCol = (String)codeSizeVT.get(n);


								if(sCol.equals("1")){
%>

							<th rowspan="2" > <%=sText %></th>
<%
							}else {
%>

							<th colspan="<%= sCol%>">	<%=sText %></th>

	<%					}
   						}
	%>
					</tr>
					<tr>

<%
	for(int h=0; h < qlSize ; h ++){
		 T_EXPORT = (HashMap)orgVT.get(h);
	     String  CODTX = T_EXPORT.get("CODTX");
	     for( int j =0 ; j < 20 	; j++){
				String idx ="";
				if(j < 9){
					idx = "0"+(j+1);
				}else{
					idx =""+(j+1);
				}
				String GUBUN =  T_EXPORT.get("GUBUN"+idx);
				String COUNT =  T_EXPORT.get("COUNT"+idx);
				String SUBTY =  T_EXPORT.get("SUBTY"+idx);
	     		if(h == 0){
					if(!GUBUN.equals("")){
%>
							<th width="190" ><%=COUNT %></th>

<%       		}
				}else{
					if(!SUBTY.equals("")){
%>
                           	<%if(j == 0){ %>
                           	<tr <%if(qlSize-1 == h){ %>class="colSum" <%} %>>
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