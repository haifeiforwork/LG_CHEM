<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/commonProcess.jsp" %>  
<%@ page import="java.util.Vector" %>  
<%@ page import="hris.N.EHRCommonUtil" %>       
<%@ page import="com.sns.jdf.util.*"%>   
           
<%   

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
	
    
%>


<SCRIPT LANGUAGE="JavaScript"> 
<!-- 


//Execl Down 하기.
function excelDown() {
    frm = document.form1; 
    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.DeptPositionSV?command=EXC";
    frm.target = "hidden";
    frm.submit();
}

	function tabMove(idName, gubun){
		var aform = document.form1;
		var urlName ="<%= WebUtil.ServletURL %>hris.N.orgstats.DeptPositionSV?command="+gubun;
      	var tl = eval("document.all.tl" + idName);
      	var tc = eval("document.all.tc" + idName);
      	var tr = eval("document.all.tr" + idName);
      
      	for(i = 0; i < 3; i++){
         	var tls = eval("document.all.tl" + i);
        	var tcs = eval("document.all.tc" + i);
         	var trs = eval("document.all.tr" + i);
         
	        tls.className="tl";
	        tcs.className="tc";
	        trs.className="tr";
      	}
      	
		tl.className="tl_on";
		tc.className="tc_on";		 
	 	tr.className="tr_on";
	 	
	 	aform.action = urlName;
		aform.target = "chartFrame";
	    aform.submit();
	 	
	}
		
	
//--> 
</SCRIPT>  
  
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9" />

<title>MSS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">


<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript" src="<%= WebUtil.ImageURL %>js/N/rowspan.js"></script>
</head>
 
<body id="subBody" >  
<form name="form1" method="post" > 
<div class="subWrapper"> 
	<div class="subHead"><h2>직급별 인원현황 </h2></div>
	<div class="contentBody">
	
		<div class="orgStatsWrap">
			<!-- 탭 시작 -->
			<div class="tabLine">
				<div  id="tl0" class="tl_on"></div>
				<div  id="tc0" class="tc_on"><a href="javascript:tabMove('0','PSN')"><span>인원 </span></a></div>
				<div  id="tr0" class="tr_on"></div>
				
				<div  id="tl1" class="tl"></div>
				<div  id="tc1" class="tc"><a href="javascript:tabMove('1','WRK')"><span>평균근속</span></a></div>
				<div  id="tr1" class="tr"></div>
				
				<div  id="tl2" class="tl"></div>
				<div  id="tc2" class="tc"><a href="javascript:tabMove('2','OLD')"><span>평균연령</span></a></div>
				<div  id="tr2" class="tr"></div>
				
				<div class="clear"></div>
			</div>
			
			<!-- 탭 끝 --> 
			<div class="orgStats_graph">
				<!-- <h3>직급별 인원구성 추이</h3> -->
				<iframe name='chartFrame' id="chartFrame"  src="<%=WebUtil.ServletURL %>hris.N.orgstats.DeptPositionSV?command=PSN" width='100%' height='390' frameborder='0' marginwidth='0' marginheight='0' style="border:#ddd solid 0px"></iframe>
				
			</div><!-- /orgStats_graph -->
			<div class="orgStats_tb">	
				<h3>직급별 인원현황</h3>	
				<h4 style="text-align:right;background:none;margin-top:-25px;"><a href="javascript:excelDown();"><img src="<%=WebUtil.ImageURL %>btn_EXCELdownload.gif" ></a></h4>
					
				<!-- 테이블 시작 -->
			<table width ="780"   class="tb_def" border="0">
						<tr>
							<th width="240" rowspan="2" colspan="2">구분</th>
<%
	for(int y = 0 ; y < columSize ; y++){
%>							
							<th width="180" colspan="2"><%= (String)datavt.get(y) %></th>
						
<%} %>				
						<th rowspan="2" width="90" >평균<br />근속<br />(년,월)</th>
							<th rowspan="2" width="90" >평균<br />연령<br />(년,월)</th>			
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

				<!-- 테이블 시작 -->
				<table width="780" class="tb_def fixed" summary=""  style="border-top:1px solid #e1e1e1;" >
<%
	HashMap<String, String> tatalhm = new HashMap<String, String>();
	int toSize =totalVT.size();
	
	
	String zero ="";
	for(int i = 0 ; i < toSize ; i++){
		tatalhm = (HashMap)totalVT.get(i);
		String sCODTX = tatalhm.get("CODTX");
		
		String sCOUNT1 = "";
		String sRATIO1 = "";
		String sCOUNT = tatalhm.get("COUNT");
		String sRATIO = tatalhm.get("RATIO");
		
		String sGNSOK = tatalhm.get("GNSOK");
		String sOLDS = tatalhm.get("OLDS");
		String test = "";
		for(int a = columSize-1 ; a >= 0; a--){ 
			zero = a+"";
			if (a==0){
				zero = "";
			}
			sCOUNT1 = tatalhm.get("COUNT"+zero);
			sRATIO1 = tatalhm.get("RATIO1");
			//
		}
		
		
%>								
						<tr <%if(i==2){ %> class="colSum2" <%}else{ %>class="col01"<%} %>>
						
							<td width="239"><%=sCODTX %></td>
							
							
							
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
			</div><!-- /orgStats_tb -->
		</div><!-- /orgStatsWrap -->
		
	</div><!-- /contentBody -->
</div><!-- /subWrapper -->
</form>
</body>
</html>