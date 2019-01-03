<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.N.EHRCommonUtil"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%


	String command = request.getParameter("command");
	String I_ITEM       = WebUtil.nvl(request.getParameter("I_ITEM"));
	String I_ITEMTXT       = WebUtil.nvl(request.getParameter("I_ITEMTXT"));
	if(I_ITEMTXT.equals("")){
		I_ITEMTXT = g.getMessage("LABEL.N.N02.0012"); //전체
	}

	String hName= g.getMessage("MSG.N.N02.0004"); //- 영어우수자
    String tabNo =  "1";
	if(command.equals("PIS0041")){
		tabNo =  "2";
		hName= g.getMessage("MSG.N.N02.0005"); //- 중국어우수자
      }else if(command.equals("PIS0042")){
    	  tabNo =  "3";
    	  hName=g.getMessage("MSG.N.N02.0006"); //- 특수언어우수자
       	}


		/*----- Excel 파일 저장하기 --------------------------------------------------- */
	response.setHeader("Content-Disposition","attachment;filename=Language"+I_ITEM+"Prsn"+tabNo+".xls");
	response.setContentType("application/vnd.ms-excel;charset=utf-8");
	/*----------------------------------------------------------------------------- */

	String viewGubun =	 request.getParameter("viewGubun");
	WebUserData user    = (WebUserData)session.getAttribute("user");


	 if(command.equals("PIS0040")){
		 command ="1";
	  }else if(command.equals("PIS0041")){
		 command =  "2";
	   }else if(command.equals("PIS0042")){
		 command =  "3";
	   }

	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	Vector orgVT = (Vector)qlHM.get("T_EXPORT"+Integer.parseInt(command));

	int qlSize = orgVT.size();
	HashMap<String, String> T_EXPORT = new HashMap<String, String>();

	String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                              //부서명
	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                //부서코드
	String sCommand = WebUtil.nvl(request.getParameter("command"));


    String chck_sub = WebUtil.nvl(request.getParameter("chck_sub"));

//	  Subcode tab 추가
		Vector itemVT = (Vector)qlHM.get("T_ITEM");
		int itemSize = itemVT.size();

		if(I_ITEM.equals("")){
			if(itemSize > 0 ){
				T_EXPORT = (HashMap)itemVT.get(0);
				I_ITEM = T_EXPORT.get("CODE");
			}
		}

		String sMenuText = EHRCommonUtil.nullToEmpty((String)request.getParameter("sMenuText"));
		String tabName = EHRCommonUtil.nullToEmpty((String)request.getParameter("tabName"));
		String I_INOUTXT = EHRCommonUtil.nullToEmpty((String)request.getParameter("I_INOUTXT"));
		String selectRegTxt = EHRCommonUtil.nullToEmpty((String)request.getParameter("selectRegTxt"));
		String searchNation = EHRCommonUtil.nullToEmpty((String)request.getParameter("searchNation"));
		if(searchNation.equals("")){
			searchNation= g.getMessage("LABEL.N.N02.0012"); //전체
		}
		String searchYear =  EHRCommonUtil.nullToEmpty(request.getParameter("searchYear"));
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
<head>
<meta http-equiv=Content-Type content="text/html; charset=ks_c_5601-1987">
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
<div>
	<div class="contentBody" >
			<!-- TAB END -->
	<!-- TAB sub menu START -->
			<div class="tabSub">

		</div>
		<div>
	  </div>
	<div style="height:5px">&nbsp;</div>
	<div class="orgStats_tb"  >
<table width="1000" >
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
				<table width="880">
					<tr>
						<td  height="20" colspan="10"></td>
					</tr>
					<tr>
						<td height="30" colspan="10" align="center" class="excelTitle"><h3>■ <%=sMenuText %><%=hName %></h3></td>
					</tr>

				</table>
				<table width="880">

					<tr>
						<td height="20" colspan="10" style="text-align: left" ><b><spring:message code="LABEL.N.N02.0007" /><!-- 구분 -->: <font color="#4169E1"><%=I_ITEMTXT %></font></b></td>
					</tr>
					<tr>
						<td height="20" colspan="10" class=""><h5><spring:message code="LABEL.N.N02.0004" /><!-- 부서명 -->: <%=deptNm %></h5></td>
					</tr>

				</table>

				<!-- 테이블 시작 -->
				<table class="tb_def" summary="" val>
					<caption></caption>

					<thead>
						<tr>
							<th width="190"><spring:message code="LABEL.N.N02.0007" /><!-- 구분 --></th>
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
	     		if(h == 0){
					if(!GUBUN.equals("")){
%>
							<th><%=COUNT %></th>

<%       		}
				}else{
					if(!GUBUN.equals("")){
%>
                           	<%if(j == 0){ %>
                           	<tr <%if(qlSize-1 == h){ %>class="colSum" <%} %>>
                           	<td  width="190"><%= CODTX %></td>
                           	<%} %>
							<td  width="190"><%=COUNT %></td>

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
</form>
</body>
</html>