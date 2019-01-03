<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/commonProcess.jsp" %>  
<%@ page import="java.util.Vector" %>  
<%@ page import="hris.N.EHRCommonUtil" %>       
<%@ page import="com.sns.jdf.util.*"%>   
           
<%   
	
/*----- Excel 파일 저장하기 --------------------------------------------------- */
response.setHeader("Content-Disposition","attachment;filename=DeptPositionClass.xls");
response.setContentType("application/vnd.ms-excel;charset=utf-8");
/*----------------------------------------------------------------------------- */        
	HashMap qlHM = (HashMap)request.getAttribute("resultVT"); 

	Vector orgVT = (Vector)qlHM.get("T_EXPORT"); 
	Vector totalVT = (Vector)qlHM.get("T_TOTAL"); 
	int qlSize = orgVT.size();
	
	//년도로 몇년치 인지 구분한다.
	int countYear = 0;
	HashMap<String, String> qlhm = new HashMap<String, String>();
	String sDa = "";
	Vector datavt = new Vector();
	if(qlSize > 0  ){
		for(int k = 0 ; k < qlSize ; k++){ 
			qlhm = (HashMap)orgVT.get(k);
			String sDATUM = qlhm.get("DATUM");
			if(!sDATUM.equals(sDa)){
				datavt.add(sDATUM);
				countYear ++; 
			}
			sDa = sDATUM;
		}
	}	

	int columSize = datavt.size();
	int reSize = qlSize / countYear;
	
	Vector allCountVT = new Vector(); //  인원 Vector [[2014],[2015]]
	Vector allRationVT = new Vector(); // 구성비 Vector [[2014],[2015]]
	Vector allWorktVT = new Vector(); //  평균근속 Vector [[2014],[2015]]
	Vector allOldVT = new Vector();    //   평균연령 Vector [[2014],[2015
	for(int y = 0 ; y < columSize ; y++){ // 2개년 표시
		Vector yCountVT = new Vector(); 
		Vector yRationVT = new Vector(); 
		Vector avWorkVT = new Vector();                                                  
		Vector avOldVT = new Vector();                                                  
		for(int a = 0 ; a < qlSize ; a++){ //   26개 
			qlhm = (HashMap)orgVT.get(a);
			String sDATUM = qlhm.get("DATUM").substring(0,4);		
			String sCount = qlhm.get("COUNT");		
			String sRatio = qlhm.get("RATIO");		
			
			String sWork = qlhm.get("GNSOK");		
			String sOld = qlhm.get("OLDS");		

			String dataY =  (String)datavt.get(y);		
			dataY = dataY.substring(0,4);		
			
			if(dataY.equals(sDATUM)){
				yCountVT.add(sCount);
				yRationVT.add(sRatio);
				avWorkVT.add(sWork);
				avOldVT.add(sOld);
			}							
		}
		allCountVT.add(yCountVT);
		allRationVT.add(yRationVT);
		allWorktVT.add(avWorkVT);
		allOldVT.add(avOldVT);	
	}

	Vector rowspanVT = new Vector();
	String tempRow ="";
	int rcount = 0; 
	for(int z = 0 ; z < reSize ; z++){ // 년도의 수만큼 잘라서 표시 13개
		qlhm = (HashMap)orgVT.get(z);
		String zcode = qlhm.get("ZCODE");		
		if(!zcode.equals(tempRow)){
			if(z!=0){
				rowspanVT.add(rcount);
			}
			rcount = 0;
		}	
		tempRow = zcode;
		rcount++;
		if(z ==(reSize-1)){
			rowspanVT.add(rcount);
		}
	}
	// [1, 4, 4, 4]
	//
%>

<html>
<head>
<meta http-equiv=Content-Type content="text/html; charset=ks_c_5601-1987">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">

<meta http-equiv="X-UA-Compatible" content="IE=9" />


<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript" src="<%= WebUtil.ImageURL %>js/N/rowspan.js"></script>

			<style type="text/css">
				.orgStats_tb {padding-left:20px;}
				.excelTitle {text-align:center;font-family:malgun gothic;font-size:15px;font-weight:bold;}
				.tb_def {table-layout:fixed;}
				.tb_def th {font-family:malgun gothic;color:#000;font-size:12px;font-weight:bold;border:solid 1px #000;background:#dfdfdf}
				.tb_def td {font-family:malgun gothic;color:#000;font-size:12px;font-weight:normal;border:solid 1px #000;text-align:center;}
			</style>
</head>
 <body id="subBody" >  
<div class="subWrapper"> 
	
	<div class="" >
		<div class="">
			<!-- 탭 시작 -->
			<div class="">	
				<table width="880">
					<tr>
						<td colspan="2" height="20"></td>
					</tr>
					<tr>
						<td></td>
						<td height="40" class="excelTitle"><h2>직급별 인원현황</h2></td>
					</tr>
					<tr>
						<td colspan="2" height="20"></td>
					</tr>
					<tr>
						<td width="80"></td>
						<td>
				<!-- 테이블 시작 -->
				<table width="100%"  class="tb_def" border="0">
						<tr>
							<th width="200" rowspan="2" colspan="2">구분</th>
<%
	for(int y = 0 ; y < columSize ; y++){
%>							
							<th width="200" colspan="2"><%= (String)datavt.get(y) %></th>
						
<%} %>				
						<th rowspan="2" width="80" >평균<br />근속<br />(년,월)</th>
							<th rowspan="2" width="80" >평균<br />연령<br />(년,월)</th>			
						</tr>
						<tr>
<%
	for(int y = 0 ; y < columSize ; y++){
%>						
							<th>인원<br />(명)</th>
							<th>구성비<br />(%)</th>
<%} %>							
						</tr>
					
<%
	String tempcode = "";
	for(int z = 0 ; z < reSize ; z++){ // 년도의 수만큼 잘라서 표시 13개
		qlhm = (HashMap)orgVT.get(z);
		
		String zcode = qlhm.get("ZCODE");		
		String subcd = qlhm.get("SUBCD");		
		String codtx = qlhm.get("CODTX");		
		String subtx = qlhm.get("SUBTX");		
		String className ="";
%>
			
					<tr>
						<%
						if(zcode.equals("01") && subcd.equals("99")){ //임원
						%>
							
							<td colspan="2"  class="col01"><%= codtx%></td>
							
						
				    	<%
				    	}else{//부장 차장 .....               
						%>	
							<%
								if(!zcode.equals(tempcode)){
									int izcode =(Integer.parseInt(zcode)-1);
							%>
							   <td  class="col02"  rowspan="<%= rowspanVT.get(izcode)%>"><%= codtx%></td>
							   
						   <%} 
								
								if(subcd.equals("99")){
									className = "colSum";
									subtx = "계";
								}
						   %>
														   
						   <td class="<%= className%>"><%= subtx%></td>
						<%
								} %>
		
<%

			for(int a = 0 ; a < columSize ; a++){ 
				Vector acvt = (Vector)allCountVT.get(a);
				Vector arvt = (Vector)allRationVT.get(a);
				Vector awvt = (Vector)allWorktVT.get(a);
				Vector aovt = (Vector)allOldVT.get(a);
%>			
	<!-- 사무 -->
						<%if(zcode.equals("01") && subcd.equals("99")){ %>
							<td class="col01 noLline" ><%= WebUtil.printNumFormat((String)acvt.get(z) ) %></td>
							<td class="col01"><%= EHRCommonUtil.dotCheck((String)arvt.get(z)) %></td>
						
						<%}else{	%>	
							<td  class="<%= className%>"><%= WebUtil.printNumFormat((String)acvt.get(z) ) %></td>
							<td class="<%= className%>"><%= EHRCommonUtil.dotCheck((String)arvt.get(z)) %></td>
						<%} %>
				<%
				if( a == (columSize -1)){ %>
						<%if(zcode.equals("01") && subcd.equals("99")){ %>
							<td class="col01"><%=awvt.get(z)%></td>
							<td class="col01"><%= aovt.get(z) %></td>
						
						<%}else{ %>	
						
							<td class="<%= className%>"><%=awvt.get(z)%></td>
							<td class="<%= className%>"><%= aovt.get(z) %></td>
						
						<%} %>
	
<%			}
			}

%>
					</tr>
			
<%  tempcode = zcode;
		}
	%>						
				
				</table>
			</td>
		</tr>
				<!-- 테이블 끝 -->	
					<tr>
						<td colspan="2" height="20"></td>
					</tr>
				<tr>
					<td></td>
					<td>
				<!-- 테이블 시작 -->
				<table class="tb_def" summary=""  >
					
					
<%
	HashMap<String, String> tatalhm = new HashMap<String, String>();
	int toSize =totalVT.size();
	
	for(int i = 0 ; i < toSize ; i++){
		tatalhm = (HashMap)totalVT.get(i);
		String sCODTX = tatalhm.get("CODTX");
		String sCOUNT1 = tatalhm.get("COUNT1");
		String sRATIO1 = tatalhm.get("RATIO1");
		String sCOUNT = tatalhm.get("COUNT");
		String sRATIO = tatalhm.get("RATIO");
		String sGNSOK = tatalhm.get("GNSOK");
		String sOLDS = tatalhm.get("OLDS");
%>								
					<tr <%if(i==2){ %> class="colSum2" <%}else{ %>class="col01"<%} %>>
						<td colspan="2"><%=sCODTX %></td>
						<td><%=WebUtil.printNumFormat(sCOUNT1) %></td>
						<td><%=sRATIO1 %></td>
						<td><%=WebUtil.printNumFormat(sCOUNT) %></td>
						<td><%=sRATIO %></td>
						<td><%=sGNSOK %></td>
						<td><%=sOLDS %></td>
					</tr>

<%}
	%>
				</table>
				<!-- 테이블 끝 -->	
				<div class="bottomMent">
				</div>
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