<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="./../../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.G.G20Outpt.*" %>
<%@ page import="hris.G.G20Outpt.rfc.*" %>
 
<% 

    WebUserData user = WebUtil.getSessionUser(request);
    Vector G20EcmtPrintData_Header_vt = (Vector)request.getAttribute("G20EcmtPrintData_Header_vt");
    Vector G20EcmtPrintData_Income_vt = (Vector)request.getAttribute("G20EcmtPrintData_Income_vt");
    Vector G20EcmtPrintData_Item_vt = (Vector)request.getAttribute("G20EcmtPrintData_Item_vt");
    Vector G20EcmtPrintData_Family_vt = (Vector)request.getAttribute("G20EcmtPrintData_Family_vt");
    Vector G20EcmtPrintData_NTX_vt = (Vector)request.getAttribute("G20EcmtPrintData_NTX_vt");
    Vector G20EcmtPrintData_NTX_PRV_vt = (Vector)request.getAttribute("G20EcmtPrintData_NTX_PRV_vt");
    
    String ainf_seqn 			= (String)request.getAttribute("i_ainf_seqn");
    String print 			= (String)request.getAttribute("i_print");
    String print_num 			= (String)request.getAttribute("i_print_num");        
         try { 

    G20EcmtPrintHeaderData HData = (G20EcmtPrintHeaderData)G20EcmtPrintData_Header_vt.get(0);
    G20EcmtPrintItemData ItData = (G20EcmtPrintItemData)G20EcmtPrintData_Item_vt.get(0); 
    Date today = new Date();
    SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMdd");
    String strdate = simpleDate.format(today);
	
	String Year	 = strdate.substring(0,4);
	String Month = strdate.substring(4,6);
	String Day	 = strdate.substring(6,8);	

	 
%>

<html>
<head>
<title>ESS</title>
<style type="text/css">
  .tb_top {  
		border-style:solid;
		border-width:2px;
		border-color:#000000; 
		border-collapse: collapse;
		border-bottom-width:0;
  		}
  .tb_middle {  
		border-style:solid;
		border-width:2px;
		border-color:black; 
		border-collapse: collapse;
		border-bottom-width:0;
		border-top-width:0;
  		}
  .tb_bottom {  
		border-style:solid;
		border-width:2px;
		border-color:black; 
		border-collapse: collapse;
		border-bottom-width:1;
		border-top-width:0;
  		}
  .tb_all {  
		border-style:solid;
		border-width:2px;
		border-color:black; 
		border-collapse: collapse;
  		}  		
  .tb_in {  
		border-style:solid;
		border-width:1px;
		border-color:black; 
		border-collapse: collapse;
  		}  		
  .td1 {  text-align: center; font-family: "굴림", "굴림체"; font-size:9pt; height:21px;}
  .td2 {  text-align: left; font-family: "굴림", "굴림체"; font-size:9pt; height:21px; padding-left: 10px;}
  .td3 {  text-align: left; font-family: "굴림", "굴림체"; font-size:10pt; padding: 5 15 5 30; } 
  .td5 {  text-align: left; font-family: "굴림", "굴림체"; font-size:8pt; line-height:9pt; padding: 0 15 0 30; }  
  .td5s{  text-align: left; font-family: "굴림", "굴림체"; font-size:7pt; padding: 10 15 10 15; }   
  .td4 {  text-align: center; font-family: "굴림", "굴림체"; font-size:8pt; height:21px;} 
  .td7 {  text-align: left; font-family: "굴림", "굴림체"; font-size:8pt; height:21px; padding-left:5px; } 
  .td4s{  text-align: center; font-family: "굴림", "굴림체"; font-size:7pt; height:21px;} 
  .td7s{  text-align: left; font-family: "굴림", "굴림체"; font-size:7pt; height:21px; padding-left:5px; }   
  .td6 {  text-align: right; font-family: "굴림", "굴림체"; font-size:8pt; height:21px; padding-right:3px; }   
  .td8 {  text-align: left; font-family: "굴림", "굴림체"; font-size:8pt; height:21px; padding-left:3px; } 
  .td9 {  text-align: center; font-family: "굴림", "굴림체"; font-size:8pt;} 
  .td10{  text-align: right; font-family: "굴림", "굴림체"; font-size:8pt; height:21px; padding-right:3px; }   
  .td10s{ text-align: right; font-family: "굴림", "굴림체"; font-size:7pt; height:21px; padding-right:3px; }     
  .title1{padding-left:15px; font-family: "굴림", "굴림체";font-size:13pt;letter-spacing:0.5pt;font-weight:"bold";line-height:130%; }

  .p2_td4 {  text-align: center; font-family: "굴림", "굴림체"; font-size:8pt; height:33px;} 
  .p2_td7 {  text-align: left; font-family: "굴림", "굴림체"; font-size:8pt; height:33px; padding-left:5px; } 
  .p2_td4s {  text-align: center; font-family: "굴림", "굴림체"; font-size:6pt; height:33px;} 
  .p2_td7s {  text-align: left; font-family: "굴림", "굴림체"; font-size:7pt; height:33px; padding-left:5px; }   
  .p2_td10 {  text-align: right; font-family: "굴림", "굴림체"; font-size:8pt; height:33px; padding-right:3px; }   
  .p2_td10s{  text-align: right; font-family: "굴림", "굴림체"; font-size:7pt; height:33px; padding-right:3px; }     
  

</style>  
<link  type="text/css" rel="stylesheet" media="screen">
<link rel="stylesheet" href="<%//= WebUtil.ImageURL %>css/ess_tax.css" type="text/css">
<script language="JavaScript" src="<%//= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function f_print(){ 

        parent.beprintedpage.focus();
        parent.beprintedpage.print();  
//  본인발행 1회 인쇄 여부를 설정한다.
    parent.opener.document.form1.PRINT_END.value = "X";
    parent.close();
}
function close() {
    parent.opener.document.form1.PRINT_END.value = "X";
    parent.close();
}

//    function f_print(){
//        self.print();
//    }

//	function setDefault() {
//	   factory.printing.header = ""
//	   factory.printing.footer = ""
//	   factory.printing.portrait = true
//	   factory.printing.leftMargin = 5
//	   factory.printing.topMargin = 15
//	   factory.printing.rightMargin = 5
//	   factory.printing.bottomMargin = 15
//	}
//	 
//	function printWindow() {
//	  // Print 첫번째 파라메터는 프린트 대화상자를 표시할 것인지 여부 설정한다. 
//	  //       - false로 되어있는 경우기본 프린터로 바로 출력한다. 
//	  //       두번째 파라메터는 전체 HTML 페이지를 인쇄할 것인지  특정 프레임만 출력할 것인지를 설정한다
//	 factory.printing.Print(false, window)
//	}
//	
//	function pageSetup() {
//	 factory.printing.PageSetup();
//	}  
//	
//	function printWindow() {
//	  // Print 첫번째 파라메터는 프린트 대화상자를 표시할 것인지 여부 설정한다. 
//	  //       - false로 되어있는 경우기본 프린터로 바로 출력한다. 
//	  //       두번째 파라메터는 전체 HTML 페이지를 인쇄할 것인지  특정 프레임만 출력할 것인지를 설정한다
//	  factory.printing.Print(false, window);
//	  nextPrint();
//	}    
//	
//	function nextPrint() {
//		var page = 0;
//	    page	 =	<%= print_num %>-1;
//	
//		if(<%= print_num %> > 1) {
//	        document.form1.jobid.value 			= "print";
//		    document.form1.i_gubun.value 		= "1";
//		    document.form1.i_ainf_seqn.value 	= "<%= ainf_seqn %>";
//		    document.form1.i_print.value 		= "Y";  
//	        document.form1.i_print_num.value 	= page;
//	
//	        document.form1.action = "<%= WebUtil.ServletURL %>hris.G.G20Outpt.G20EcmtPrintSV";
//	        document.form1.target = "_self";
//	        document.form1.method = "post";
//	        document.form1.submit();
//	     } else {
//	     	self.close();
//	     }
//    }
-->
</SCRIPT>
</head>

<body onload="//setDefault();printWindow();" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="<%= WebUtil.JspPath %>ScriptX/ScriptX.cab#Version=6,1,431,8">
</object>

<form name="form1">
<input type="hidden" name="jobid" value="">
<input type="hidden" name="i_gubun" value="">
<input type="hidden" name="i_ainf_seqn" value="">
<input type="hidden" name="i_print" value="">
<input type="hidden" name="i_print_num" value="">

<div align="center">
<p style="page-break-after:always;">
<% if ( G20EcmtPrintData_Income_vt.size() >0 ) { %>
<table class="tb_top" width="650"  height=130 cellpadding="0" cellspacing="0" border="0"  style="table-layout:fixed">
                    <col class="td4" width="128" >      
                    <col class="title1" width="300">      
                    <col class="td4" width="200" >   
<!--650-20해야 프린트 기본19.05를 수정하지 않아도 전체 출력이 됨

                    <col class="td4" width="130" >      
                    <col class="title1" width="320">      
                    <col class="td4" width="200" >   -->
                    
<tr>
	<td style="padding:10 5 10 5">
		<table class="tb_in" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
		<TR>
			<TD class="td4" width="50" valign="middle">관리번호</TD>
			<TD class="td4" width="80" valign="middle">&nbsp;</TD>
		</TR>
		</table>
	</td>
	<td class="title1">□ <b>근로소득원천징수영수증</b><br><br>□ <b>근로소득 지급명세서</b>
	</td>
	<td align="right" style="padding:3 3 3 3">
		<table class="tb_in" width="200" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
		<TR>
			<TD class="td7s" width="80" colspan="3" valign="middle">거주구분</TD>
			<TD class="td4s" width="120" colspan="3" valign="middle">거주자<%=(!"".equals(HData.RESIDNT) )?"<b>①</b>":"1" %>/비거주자<%=(!"".equals(HData.N_RESID) )?"<b>②</b>":"2" %></TD>
		</TR>
		
		<TR>
			<TD class="td7s" colspan="3" valign="middle">내ㆍ외국인</TD>
			<TD class="td4s" colspan="3">내국인<%=(!"".equals(HData.KOREAN) )?"<b>①</b>":"1" %>/외국인<%=(!"".equals(HData.FOREIGN) )?HData.FOREIGN+"<b>⑨</b>":"9" %></TD>
		</TR>
		<TR>
			<TD class="td7s" colspan="4" valign="middle">외국인단일세율적용</TD>
			<TD class="td4s" colspan="2" valign="middle">여 <%=(!"".equals(HData.FLAT_RATE) )?"<b>①</b>":"1" %>/ 부 <%=(!"".equals(HData.N_FLAT_RATE) )?"<b>②</b>":"2" %></TD>
		</TR>
		<TR>
			<TD class="td7s" width="40" colspan="2" valign="middle">거주지국</TD>
			<TD class="td4s" valign="middle"><%=HData.COUNTRY %></TD>
			<TD class="td7s" colspan="2" valign="middle">거주지국코드</TD>
			<TD class="td4s" valign="middle"><%=HData.CURCD %></TD>
		</TR>	
		</table>
	</td>
</tr>
</table><table class="tb_bottom" width="650" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" style="table-layout:fixed">
                    <col class="td4" width="58" >      
                    <col class="td4" width="115">      
                    <col class="td4" width="182" >      
                    <col class="td4" width="113" >      
                    <col class="td4" width="160" > 
<!--650-20해야 프린트 기본19.05를 수정하지 않아도 전체 출력이 됨
                    <col class="td4" width="60" >      
                    <col class="td4" width="120">      
                    <col class="td4" width="176" >      
                    <col class="td4" width="120" >      
                    <col class="td4" width="174" > -->
<TR>
	<TD class="td4" rowspan="3" width="57" valign="middle">징&nbsp;수<br>의무자</TD>
	<TD class="td7" width="120" valign="middle">1.법인명(상&nbsp;&nbsp;호)</TD>
	<TD class="td4" width="176" valign="middle"><%=HData.COMNM %></TD>
	<TD class="td7" width="120" valign="middle">2.대 표 자(성&nbsp;&nbsp;명)</TD>
	<TD class="td4" width="177" valign="middle"><%=HData.REPRES %></TD>
</TR>
<TR>
	<TD class="td7" valign="middle">3.사업자등록번호</TD>
	<TD class="td4" valign="middle"><%=HData.STCD2 %></TD>
	<TD class="td7" valign="middle">4.주 민 등 록 번 호</TD>
	<TD class="td4" valign="middle"><%=HData.STCD1 %></TD>
</TR>
<TR>
	<TD class="td7" valign="middle">5.소 재 지 (주소)</TD>
	<TD class="td7" colspan="3" valign="middle"><%=HData.ADDRESS_LINE %></TD>
</TR>
<TR>
	<TD class="td4" rowspan="2" valign="middle">소득자</TD>
	<TD class="td7" valign="middle">6.성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</TD>
	<TD class="td4" valign="middle"><%=HData.ENAME %></TD>
	<TD class="td7" valign="middle">7.주 민 등 록 번 호</TD>
	<TD class="td4" valign="middle"><%=HData.REGNO %></TD>
</TR>
<TR>
	<TD class="td7" valign="middle">8.주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</TD>
	<TD class="td7" colspan="3" valign="middle"><%=HData.ADDRE %></TD>
</TR>
</table><table class="tb_bottom" width="650" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" style="table-layout:fixed">
<% 
	// 현 근무처는 Seq No.0 을 가지며, 납세조합은 중간에 들어올 수 있다.
	// T_INCOME 테이블의 데이터는 4행의 데이터만 들어오는걸 염두로 한다.

	G20EcmtPrintIncomeData Seqno0 = (G20EcmtPrintIncomeData)G20EcmtPrintData_Income_vt.get(0);
	G20EcmtPrintIncomeData Seqno1 = new G20EcmtPrintIncomeData();  
	G20EcmtPrintIncomeData Seqno2 = new G20EcmtPrintIncomeData();
	G20EcmtPrintIncomeData S_TXPAS  = new G20EcmtPrintIncomeData();
	G20EcmtPrintIncomeData temp  = new G20EcmtPrintIncomeData();  

        Seqno0.PERNR      =WebUtil.nvl(Seqno0.PERNR      );		
        Seqno0.SEQNO      =WebUtil.nvl(Seqno0.SEQNO      );		
        Seqno0.TXPAS      =WebUtil.nvl(Seqno0.TXPAS      );		
        Seqno0.WORKPLACE  =WebUtil.nvl(Seqno0.WORKPLACE  );		
        Seqno0.BUZINUM    =WebUtil.nvl(Seqno0.BUZINUM    );		
        Seqno0.RTBEG      =WebUtil.nvl(Seqno0.RTBEG      );		
        Seqno0.RTEND      =WebUtil.nvl(Seqno0.RTEND      );		
        Seqno0.EXBEG      =WebUtil.nvl(Seqno0.EXBEG      );		
        Seqno0.EXEND      =WebUtil.nvl(Seqno0.EXEND      );		
        Seqno0.REGULAR_AMT=WebUtil.nvl(Seqno0.REGULAR_AMT);		
        Seqno0.BONUS_AMT  =WebUtil.nvl(Seqno0.BONUS_AMT  );		
        Seqno0.ACKBN_AMT  =WebUtil.nvl(Seqno0.ACKBN_AMT  );		
        Seqno0.STKBN_AMT  =WebUtil.nvl(Seqno0.STKBN_AMT  );		
        Seqno0.ESTOK_AMT  =WebUtil.nvl(Seqno0.ESTOK_AMT  );		
        Seqno0.TOTAL_AMT  =WebUtil.nvl(Seqno0.TOTAL_AMT  );		
        Seqno0.INTAX_AMT  =WebUtil.nvl(Seqno0.INTAX_AMT  );		
        Seqno0.RETAX_AMT  =WebUtil.nvl(Seqno0.RETAX_AMT  );		
        Seqno0.SPTAX_AMT  =WebUtil.nvl(Seqno0.SPTAX_AMT  );		
        Seqno0.TLTAX_AMT  =WebUtil.nvl(Seqno0.TLTAX_AMT  );		

        Seqno1.PERNR      =WebUtil.nvl(Seqno1.PERNR      );		
        Seqno1.SEQNO      =WebUtil.nvl(Seqno1.SEQNO      );		
        Seqno1.TXPAS      =WebUtil.nvl(Seqno1.TXPAS      );		
        Seqno1.WORKPLACE  =WebUtil.nvl(Seqno1.WORKPLACE  );		
        Seqno1.BUZINUM    =WebUtil.nvl(Seqno1.BUZINUM    );		
        Seqno1.RTBEG      =WebUtil.nvl(Seqno1.RTBEG      );		
        Seqno1.RTEND      =WebUtil.nvl(Seqno1.RTEND      );		
        Seqno1.EXBEG      =WebUtil.nvl(Seqno1.EXBEG      );		
        Seqno1.EXEND      =WebUtil.nvl(Seqno1.EXEND      );		
        Seqno1.REGULAR_AMT=WebUtil.nvl(Seqno1.REGULAR_AMT);		
        Seqno1.BONUS_AMT  =WebUtil.nvl(Seqno1.BONUS_AMT  );		
        Seqno1.ACKBN_AMT  =WebUtil.nvl(Seqno1.ACKBN_AMT  );		
        Seqno1.STKBN_AMT  =WebUtil.nvl(Seqno1.STKBN_AMT  );		
        Seqno1.ESTOK_AMT  =WebUtil.nvl(Seqno1.ESTOK_AMT  );		
        Seqno1.TOTAL_AMT  =WebUtil.nvl(Seqno1.TOTAL_AMT  );		
        Seqno1.INTAX_AMT  =WebUtil.nvl(Seqno1.INTAX_AMT  );		
        Seqno1.RETAX_AMT  =WebUtil.nvl(Seqno1.RETAX_AMT  );		
        Seqno1.SPTAX_AMT  =WebUtil.nvl(Seqno1.SPTAX_AMT  );		
        Seqno1.TLTAX_AMT  =WebUtil.nvl(Seqno1.TLTAX_AMT  );		

        Seqno2.PERNR      =WebUtil.nvl(Seqno2.PERNR      );		
        Seqno2.SEQNO      =WebUtil.nvl(Seqno2.SEQNO      );		
        Seqno2.TXPAS      =WebUtil.nvl(Seqno2.TXPAS      );		
        Seqno2.WORKPLACE  =WebUtil.nvl(Seqno2.WORKPLACE  );		
        Seqno2.BUZINUM    =WebUtil.nvl(Seqno2.BUZINUM    );		
        Seqno2.RTBEG      =WebUtil.nvl(Seqno2.RTBEG      );		
        Seqno2.RTEND      =WebUtil.nvl(Seqno2.RTEND      );		
        Seqno2.EXBEG      =WebUtil.nvl(Seqno2.EXBEG      );		
        Seqno2.EXEND      =WebUtil.nvl(Seqno2.EXEND      );		
        Seqno2.REGULAR_AMT=WebUtil.nvl(Seqno2.REGULAR_AMT);		
        Seqno2.BONUS_AMT  =WebUtil.nvl(Seqno2.BONUS_AMT  );		
        Seqno2.ACKBN_AMT  =WebUtil.nvl(Seqno2.ACKBN_AMT  );		
        Seqno2.STKBN_AMT  =WebUtil.nvl(Seqno2.STKBN_AMT  );		
        Seqno2.ESTOK_AMT  =WebUtil.nvl(Seqno2.ESTOK_AMT  );		
        Seqno2.TOTAL_AMT  =WebUtil.nvl(Seqno2.TOTAL_AMT  );		
        Seqno2.INTAX_AMT  =WebUtil.nvl(Seqno2.INTAX_AMT  );		
        Seqno2.RETAX_AMT  =WebUtil.nvl(Seqno2.RETAX_AMT  );		
        Seqno2.SPTAX_AMT  =WebUtil.nvl(Seqno2.SPTAX_AMT  );		
        Seqno2.TLTAX_AMT  =WebUtil.nvl(Seqno2.TLTAX_AMT  );		
          
        S_TXPAS.PERNR      =WebUtil.nvl(S_TXPAS.PERNR      );		
        S_TXPAS.SEQNO      =WebUtil.nvl(S_TXPAS.SEQNO      );		
        S_TXPAS.TXPAS      =WebUtil.nvl(S_TXPAS.TXPAS      );		
        S_TXPAS.WORKPLACE  =WebUtil.nvl(S_TXPAS.WORKPLACE  );		
        S_TXPAS.BUZINUM    =WebUtil.nvl(S_TXPAS.BUZINUM    );		
        S_TXPAS.RTBEG      =WebUtil.nvl(S_TXPAS.RTBEG      );		
        S_TXPAS.RTEND      =WebUtil.nvl(S_TXPAS.RTEND      );		
        S_TXPAS.EXBEG      =WebUtil.nvl(S_TXPAS.EXBEG      );		
        S_TXPAS.EXEND      =WebUtil.nvl(S_TXPAS.EXEND      );		
        S_TXPAS.REGULAR_AMT=WebUtil.nvl(S_TXPAS.REGULAR_AMT);		
        S_TXPAS.BONUS_AMT  =WebUtil.nvl(S_TXPAS.BONUS_AMT  );		
        S_TXPAS.ACKBN_AMT  =WebUtil.nvl(S_TXPAS.ACKBN_AMT  );		
        S_TXPAS.STKBN_AMT  =WebUtil.nvl(S_TXPAS.STKBN_AMT  );		
        S_TXPAS.ESTOK_AMT  =WebUtil.nvl(S_TXPAS.ESTOK_AMT  );		
        S_TXPAS.TOTAL_AMT  =WebUtil.nvl(S_TXPAS.TOTAL_AMT  );		
        S_TXPAS.INTAX_AMT  =WebUtil.nvl(S_TXPAS.INTAX_AMT  );		
        S_TXPAS.RETAX_AMT  =WebUtil.nvl(S_TXPAS.RETAX_AMT  );		
        S_TXPAS.SPTAX_AMT  =WebUtil.nvl(S_TXPAS.SPTAX_AMT  );		
        S_TXPAS.TLTAX_AMT  =WebUtil.nvl(S_TXPAS.TLTAX_AMT  );	
	for(int i=1;i < G20EcmtPrintData_Income_vt.size();i++) {
		temp = (G20EcmtPrintIncomeData)G20EcmtPrintData_Income_vt.get(i);
	
	
		if("X".equals(temp.TXPAS)){
			S_TXPAS = temp;
		}else if(Seqno1 == null||Seqno1.BUZINUM =="" ){
			Seqno1 = temp;
		}else if(Seqno2 == null||Seqno2.BUZINUM =="") {
			Seqno2 = temp;
		}
	}		
%>
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->   

                    <col class="td4" width="19" >      
                    <col class="td4" width="154">      
                    <col class="td4" width="91" >      
                    <col class="td4" width="91" >      
                    <col class="td4" width="91" >
                    <col class="td4" width="91" >
                    <col class="td4" width="91" > 
<!--650-20해야 프린트 기본19.05를 수정하지 않아도 전체 출력이 됨
                    <col class="td4" width="22" >      
                    <col class="td4" width="158">      
                    <col class="td4" width="94" >      
                    <col class="td4" width="94" >      
                    <col class="td4" width="94" >
                    <col class="td4" width="94" >
                    <col class="td4" width="94" > -->

<TR>
	<TD class="td4" rowspan="13" width="22" valign="middle"><b>Ⅰ<br>근<br>무<br>처<br>별<br>소<br>득<br>명<br>세<br></b></TD>
	<TD class="td4" width="158" valign="middle">구&nbsp;분</TD>
	<TD class="td4" width="94" valign="middle">주(현)</TD>
	<TD class="td4" width="94" valign="middle">종(전)</TD>
	<TD class="td4" width="94" valign="middle">종(전)</TD>
	<TD class="td4" width="94" valign="middle">16-1.납세조합</TD>
	<TD class="td4" width="94" valign="middle">합&nbsp;계</TD>
</TR>
<TR>
	<TD class="td7" valign="middle">9.근&nbsp; 무&nbsp; 처&nbsp; 명</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td4" valign="middle"><%=Seqno1.WORKPLACE %></TD>
	<TD class="td4" valign="middle"><%=Seqno2.WORKPLACE %></TD>
	<TD class="td4" valign="middle"><%=S_TXPAS.WORKPLACE %></TD>
	<TD class="td7" valign="middle"></TD>	
</TR>
<TR>
	<TD class="td7" valign="middle">10.사업자등록번호</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle"><%=Seqno1.BUZINUM %></TD>
	<TD class="td7" valign="middle"><%=Seqno2.BUZINUM %></TD>
	<TD class="td7" valign="middle"><%=S_TXPAS.BUZINUM %></TD>
	<TD class="td7" valign="middle">&nbsp;</TD>				
</TR>
<TR>
	<TD class="td7" valign="middle">11.근무기간</TD>
	<TD class="td7s" valign="middle"  style="font-size:5pt"><%=Seqno0.RTBEG.equals("") || Seqno0.RTBEG.equals("0000-00-00")   ? "" : Seqno0.RTBEG+"~" %><%=Seqno0.RTEND %></TD>
	<TD class="td7s" valign="middle"  style="font-size:5pt"><%=Seqno1.RTBEG.equals("") || Seqno1.RTBEG.equals("0000-00-00")   ? "" : Seqno1.RTBEG+"~" %><%=Seqno1.RTEND %></TD>
	<TD class="td7s" valign="middle"  style="font-size:5pt"><%=Seqno2.RTBEG.equals("") || Seqno2.RTBEG.equals("0000-00-00")   ? "" : Seqno2.RTBEG+"~" %><%=Seqno2.RTEND %></TD>
	<TD class="td7s" valign="middle"  style="font-size:5pt"><%=S_TXPAS.RTBEG.equals("")||S_TXPAS.RTBEG.equals("0000-00-00")   ? "" :S_TXPAS.RTBEG+ "~"%><%=S_TXPAS.RTEND %></TD>
	<TD class="td7s" valign="middle"  style="font-size:5pt"><%=WebUtil.startDatePrint(Seqno0.RTBEG, Seqno1.RTBEG, Seqno2.RTBEG, S_TXPAS.RTBEG) %>~<%=WebUtil.endDatePrint(Seqno0.RTEND, Seqno1.RTEND, Seqno2.RTEND, S_TXPAS.RTEND) %></TD>			
</TR>
<TR>
	<TD class="td7" valign="middle">12.감면기간</TD>
	<TD class="td7s" valign="middle" style="font-size:5pt"><%= Seqno0.EXBEG.equals("") || Seqno0.EXBEG.equals("0000-00-00") ? "" : Seqno0.EXBEG+"~"+Seqno0.EXEND  %></TD>
	<TD class="td7s" valign="middle" style="font-size:5pt"><%= Seqno1.EXBEG.equals("") || Seqno1.EXBEG.equals("0000-00-00") ? "" : Seqno1.EXBEG+"~"+Seqno1.EXEND  %></TD>
	<TD class="td7s" valign="middle" style="font-size:5pt"><%= Seqno2.EXBEG.equals("") || Seqno2.EXBEG.equals("0000-00-00") ? "" : Seqno2.EXBEG+"~"+Seqno2.EXEND  %></TD>
	<TD class="td7s" valign="middle" style="font-size:5pt"><%=S_TXPAS.EXBEG.equals("") ||S_TXPAS.EXBEG.equals("0000-00-00") ? "" : S_TXPAS.EXBEG+"~"+S_TXPAS.EXEND %></TD>
	<TD class="td7s" valign="middle" style="font-size:5pt"><%=WebUtil.startDatePrint(Seqno0.EXBEG, Seqno1.EXBEG, Seqno2.EXBEG, S_TXPAS.EXBEG) %><%= (Seqno0.EXBEG.equals("")||Seqno0.EXBEG.equals("0000-00-00"))&&(Seqno1.EXBEG.equals("")||Seqno1.EXBEG.equals("0000-00-00"))&&(Seqno2.EXBEG.equals("")||Seqno2.EXBEG.equals("0000-00-00"))&&(S_TXPAS.EXBEG.equals("")||S_TXPAS.EXBEG.equals("0000-00-00")) ? "":"~"%><%=WebUtil.endDatePrint(Seqno0.EXEND, Seqno1.EXEND, Seqno2.EXEND, S_TXPAS.EXEND) %></TD>			
</TR>
<TR>
	<TD class="td7" valign="middle">13.급&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 여</TD>
	<TD class="td10s" valign="middle"><%=Seqno0.REGULAR_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno1.REGULAR_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno2.REGULAR_AMT %></TD>
	<TD class="td10s" valign="middle"><%=S_TXPAS.REGULAR_AMT %></TD>
	<TD class="td10s" valign="middle"><%=WebUtil.printNumFormat(Integer.parseInt(Seqno0.REGULAR_AMT == "" ? "0" : WebUtil.replace(Seqno0.REGULAR_AMT,",",""))+Integer.parseInt(Seqno1.REGULAR_AMT == "" ? "0" : WebUtil.replace(Seqno1.REGULAR_AMT,",",""))+Integer.parseInt(Seqno2.REGULAR_AMT == "" ? "0" : WebUtil.replace(Seqno2.REGULAR_AMT,",",""))+Integer.parseInt(S_TXPAS.REGULAR_AMT == "" ? "0" : WebUtil.replace(S_TXPAS.REGULAR_AMT,",",""))) %></TD>				
</TR>
<TR>
	<TD class="td7" valign="middle">14.상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 여</TD>
	<TD class="td10s" valign="middle"><%=Seqno0.BONUS_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno1.BONUS_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno2.BONUS_AMT %></TD>
	<TD class="td10s" valign="middle"><%=S_TXPAS.BONUS_AMT %></TD>
	<TD class="td10s" valign="middle"><%=WebUtil.printNumFormat(Integer.parseInt(Seqno0.BONUS_AMT == "" ? "0" : WebUtil.replace(Seqno0.BONUS_AMT,",",""))+Integer.parseInt(Seqno1.BONUS_AMT == "" ? "0" : WebUtil.replace(Seqno1.BONUS_AMT,",",""))+Integer.parseInt(Seqno2.BONUS_AMT == "" ? "0" : WebUtil.replace(Seqno2.BONUS_AMT,",",""))+Integer.parseInt(S_TXPAS.BONUS_AMT == "" ? "0" : WebUtil.replace(S_TXPAS.BONUS_AMT,",",""))) %>&nbsp;</TD>				
</TR>
<TR>
	<TD class="td7" valign="middle">15.인&nbsp; 정&nbsp; 상&nbsp; 여</TD>
	<TD class="td10s" valign="middle"><%=Seqno0.ACKBN_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno1.ACKBN_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno2.ACKBN_AMT %></TD>
	<TD class="td10s" valign="middle"><%=S_TXPAS.ACKBN_AMT %></TD>
	<TD class="td10s" valign="middle"><%=WebUtil.printNumFormat(Integer.parseInt(Seqno0.ACKBN_AMT  == "" ? "0" : WebUtil.replace(Seqno0.ACKBN_AMT ,",",""))+Integer.parseInt(Seqno1.ACKBN_AMT  == "" ? "0" : WebUtil.replace(Seqno1.ACKBN_AMT ,",",""))+Integer.parseInt(Seqno2.ACKBN_AMT  == "" ? "0" : WebUtil.replace(Seqno2.ACKBN_AMT ,",",""))+Integer.parseInt(S_TXPAS.ACKBN_AMT  == "" ? "0" : WebUtil.replace(S_TXPAS.ACKBN_AMT ,",",""))) %>&nbsp;</TD>				
</TR>
<TR>
	<TD class="td7s" valign="middle">15-1.주식매수선택권 행사이익</TD>
	<TD class="td10s" valign="middle"><%=Seqno0.STKBN_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno1.STKBN_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno2.STKBN_AMT %></TD>
	<TD class="td10s" valign="middle"><%=S_TXPAS.STKBN_AMT %></TD>
	<TD class="td10s" valign="middle"><%=WebUtil.printNumFormat(Integer.parseInt(Seqno0.STKBN_AMT == "" ? "0" : WebUtil.replace(Seqno0.STKBN_AMT,",",""))+Integer.parseInt(Seqno1.STKBN_AMT == "" ? "0" : WebUtil.replace(Seqno1.STKBN_AMT,",",""))+Integer.parseInt(Seqno2.STKBN_AMT == "" ? "0" : WebUtil.replace(Seqno2.STKBN_AMT,",",""))+Integer.parseInt(S_TXPAS.STKBN_AMT == "" ? "0" : WebUtil.replace(S_TXPAS.STKBN_AMT,",",""))) %>&nbsp;</TD>				
</TR>
<TR>
	<TD class="td7" valign="middle">15-2.우리사주조합인출금</TD>
	<TD class="td10s" valign="middle"><%=Seqno0.ESTOK_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno1.ESTOK_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno2.ESTOK_AMT %></TD>
	<TD class="td10s" valign="middle"><%=S_TXPAS.ESTOK_AMT %></TD>
	<TD class="td10s" valign="middle"><%=WebUtil.printNumFormat(Integer.parseInt(Seqno0.ESTOK_AMT == "" ? "0" : WebUtil.replace(Seqno0.ESTOK_AMT,",",""))+Integer.parseInt(Seqno1.ESTOK_AMT == "" ? "0" : WebUtil.replace(Seqno1.ESTOK_AMT,",",""))+Integer.parseInt(Seqno2.ESTOK_AMT == "" ? "0" : WebUtil.replace(Seqno2.ESTOK_AMT,",",""))+Integer.parseInt(S_TXPAS.ESTOK_AMT == "" ? "0" : WebUtil.replace(S_TXPAS.ESTOK_AMT,",",""))) %>&nbsp;</TD>				
</TR>
<TR>
	<TD class="td7" valign="middle">15-3</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>				
</TR>
<TR>
	<TD class="td7" valign="middle">15-4</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td7" valign="middle">&nbsp;</TD>				
</TR>
<TR>
	<TD class="td7" valign="middle">16.계</TD>
	<TD class="td10s" valign="middle"><%=Seqno0.TOTAL_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno1.TOTAL_AMT %></TD>
	<TD class="td10s" valign="middle"><%=Seqno2.TOTAL_AMT %></TD>
	<TD class="td10s" valign="middle"><%=S_TXPAS.TOTAL_AMT %></TD>
	<TD class="td10s" valign="middle"><%=WebUtil.printNumFormat(Integer.parseInt(Seqno0.TOTAL_AMT == "" ? "0" : WebUtil.replace(Seqno0.TOTAL_AMT,",",""))+Integer.parseInt(Seqno1.TOTAL_AMT == "" ? "0" : WebUtil.replace(Seqno1.TOTAL_AMT,",",""))+Integer.parseInt(Seqno2.TOTAL_AMT == "" ? "0" : WebUtil.replace(Seqno2.TOTAL_AMT,",",""))+Integer.parseInt(S_TXPAS.TOTAL_AMT == "" ? "0" : WebUtil.replace(S_TXPAS.TOTAL_AMT,",",""))) %>&nbsp;</TD>		
</TR>			
</table>
<table class="tb_bottom" width="650" height=150 cellpadding="0" cellspacing="0" border="1" bordercolor="#000000"  style="table-layout:fixed">
                    <col class="td4" width="19">      
                    <col class="td4" width="134">      
                    <col class="td4" width="20">      
                    <col class="td4" width="91">      
                    <col class="td4" width="91">      
                    <col class="td4" width="91">
                    <col class="td4" width="91">
                    <col class="td4" width="91"> 
<!--650-20해야 프린트 기본19.05를 수정하지 않아도 전체 출력이 됨

                    <col class="td4" width="22">      
                    <col class="td4" width="135">      
                    <col class="td4" width="23">      
                    <col class="td4" width="94">      
                    <col class="td4" width="94">      
                    <col class="td4" width="94">
                    <col class="td4" width="94">
                    <col class="td4" width="94"> -->
                    
<TR>
	<TD class="td4" rowspan="9" width="22" valign="middle"><b>Ⅱ<br>비<br>과<br>세<br>소<br>득</b></TD>
<% 
    if ( G20EcmtPrintData_NTX_vt.size() > 0) {
     
	// 현 근무처는 Seq No.0 을 가지며, 납세조합은 중간에 들어올 수 있다.
	// T_INCOME 테이블의 데이터는 4행의 데이터만 들어오는걸 염두로 한다.

	G20EcmtPrintNtxData S_INDIC  = null;
	G20EcmtPrintNtxData S_Seq    = null;
	G20EcmtPrintNtxData tmp      = null;
	int chk = 0;
	
        String l_prev1  = "";
        String l_prev2  = "";
        String l_txpas  = "";
        String l_prev1_hap = "";
        String l_prev2_hap = "";
        String l_txpas_hap = "";

	for(int i=0;i < 8;i++) {
		if(i < G20EcmtPrintData_NTX_vt.size()) {
			tmp = (G20EcmtPrintNtxData)G20EcmtPrintData_NTX_vt.get(i);
		}
		
		if(chk != 0) {
%>
<TR>    
<%  	        } 	// if End.	
	
		if("T".equals(tmp.INDIC)){
			S_INDIC = tmp;
			
		} else if(i < G20EcmtPrintData_NTX_vt.size()){
			S_Seq = tmp;
			chk++;
%>
<%                      for (int k = 0; k < G20EcmtPrintData_NTX_PRV_vt.size(); k++) {  
	                   hris.G.G20Outpt.G20EcmtPrintNtxPrvData data = (hris.G.G20Outpt.G20EcmtPrintNtxPrvData)G20EcmtPrintData_NTX_PRV_vt.get(k);
                           if ( Seqno1.BUZINUM.equals(data.BIZNO)&&  data.INDIC.equals("T")) {
                                l_prev1_hap  =  data.AMT  ;
	                   }
                           if ( Seqno2.BUZINUM.equals(data.BIZNO)&&   data.INDIC.equals("T")) {
                                l_prev2_hap  =  data.AMT  ;    
	                   }
                           if ( S_TXPAS.BUZINUM.equals(data.BIZNO)&&  data.INDIC.equals("T")) {
                                l_txpas_hap  =  data.AMT  ;    
	                   }	      
                           if ( Seqno1.BUZINUM.equals(data.BIZNO) && S_Seq.NTCOD.equals(data.NTCOD) ) { 
                               l_prev1 = data.AMT;
                           }
                           if ( Seqno2.BUZINUM.equals(data.BIZNO) && S_Seq.NTCOD.equals(data.NTCOD) ) { 
                               l_prev2 = data.AMT;
                           }  
                           if ( S_TXPAS.BUZINUM.equals(data.BIZNO) && S_Seq.NTCOD.equals(data.NTCOD) ) { 
                               l_txpas = data.AMT;
                           }                  
                        }
%>
	<TD class="td7" width="135"  valign="middle"><%=S_Seq.NTFTX %></TD>
	<TD class="td4s" width="23" valign="middle"><%=S_Seq.NTCOD %></TD>
	<TD class="td10s" width="94" valign="middle"><%=((S_Seq.AMT_CUR != null) && (!"".equals(S_Seq.AMT_CUR)) && "-".equals(S_Seq.AMT_CUR.substring(S_Seq.AMT_CUR.length()-1,S_Seq.AMT_CUR.length()))?S_Seq.AMT_CUR.substring(S_Seq.AMT_CUR.length()-1,S_Seq.AMT_CUR.length())+S_Seq.AMT_CUR.substring(0,S_Seq.AMT_CUR.length()-1):S_Seq.AMT_CUR) %></TD>
	<TD class="td10s" width="94" valign="middle"><%=l_prev1 %></TD>
	<TD class="td10s" width="94" valign="middle"><%=l_prev2 %></TD>
	<TD class="td10s" width="94" valign="middle"><%=l_txpas %></TD>
	<TD class="td10s" width="94" valign="middle"><%=((S_Seq.AMT_TOT != null) && (!"".equals(S_Seq.AMT_TOT)) && "-".equals(S_Seq.AMT_TOT.substring(S_Seq.AMT_TOT.length()-1,S_Seq.AMT_TOT.length()))?S_Seq.AMT_TOT.substring(S_Seq.AMT_TOT.length()-1,S_Seq.AMT_TOT.length())+S_Seq.AMT_TOT.substring(0,S_Seq.AMT_TOT.length()-1):S_Seq.AMT_TOT) %></TD>	
</TR>

<%
	    } else {	
	    	chk++;
%>	    
	<TD height=15  valign="middle">&nbsp;</TD>
	<TD valign="middle">&nbsp;</TD>
	<TD  valign="middle">&nbsp;</TD>
	<TD  valign="middle">&nbsp;</TD>
	<TD  valign="middle">&nbsp;</TD>
	<TD  valign="middle">&nbsp;</TD>
	<TD  valign="middle">&nbsp;</TD>	
</TR>	    
<%	        
	    } // else End
	} // for End 
%>    
<TR>
	<TD class="td7" colspan=2 valign="middle">20.비과세소득 계</TD>
	<TD class="td10s" valign="middle"><%=((S_INDIC.AMT_CUR != null) && (!"".equals(S_INDIC.AMT_CUR)) && "-".equals(S_INDIC.AMT_CUR.substring(S_INDIC.AMT_CUR.length()-1,S_INDIC.AMT_CUR.length()))?S_INDIC.AMT_CUR.substring(S_INDIC.AMT_CUR.length()-1,S_INDIC.AMT_CUR.length())+S_INDIC.AMT_CUR.substring(0,S_INDIC.AMT_CUR.length()-1):S_INDIC.AMT_CUR) %></TD>
	<TD class="td10s" valign="middle"><%=l_prev1_hap%></TD>
	<TD class="td10s" valign="middle"><%=l_prev2_hap%></TD>
	<TD class="td10s" valign="middle"><%=l_txpas_hap%></TD>
	<TD class="td10s" valign="middle"><%=((S_INDIC.AMT_TOT != null) && (!"".equals(S_INDIC.AMT_TOT)) && "-".equals(S_INDIC.AMT_TOT.substring(S_INDIC.AMT_TOT.length()-1,S_INDIC.AMT_TOT.length()))?S_INDIC.AMT_TOT.substring(S_INDIC.AMT_TOT.length()-1,S_INDIC.AMT_TOT.length())+S_INDIC.AMT_TOT.substring(0,S_INDIC.AMT_TOT.length()-1):S_INDIC.AMT_TOT) %></TD>				
</TR>	
<%    }else{ //비과세 소득 없는 경우%>
	<TD class="td7" valign="middle">18.국외근로</TD>
	<TD class="td4s" valign="middle">M01</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>	
</TR>	
<TR> 
	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td4s" valign="middle">&nbsp;</TD>
	
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>	
</TR>
<TR>	<TD class="td7" valign="middle">&nbsp;</TD>
	<TD class="td4s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>	
</TR>
<TR>	<TD class="td7" valign="middle">19.그 밖의 비과세</TD>
	<TD class="td4s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>	
</TR>	    
<TR>
	<TD class="td7" colspan=2 valign="middle">20.비과세소득 계</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>
	<TD class="td10s" valign="middle">&nbsp;</TD>				
</TR>
<%    } %>
</table>
<table class="tb_bottom" width="650" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" style="table-layout:fixed">
                    <col class="td4" width="20">      
                    <col class="td4" width="38">      
                    <col class="td4" width="68">       
                    <col class="td4" width="43">       
                    <col class="td4" width="95">     
                    <col class="td4" width="91">      
                    <col class="td4" width="91">
                    <col class="td4" width="91">
                    <col class="td4" width="91">  
<!--650-20해야 프린트 기본19.05를 수정하지 않아도 전체 출력이 됨
                    <col class="td4" width="22">      
                    <col class="td4" width="40">      
                    <col class="td4" width="70">       
                    <col class="td4" width="45">       
                    <col class="td4" width="97">     
                    <col class="td4" width="94">      
                    <col class="td4" width="94">
                    <col class="td4" width="94">
                    <col class="td4" width="94">  -->

<TR>
	<TD class="td4" rowspan="7" width="22" valign="middle"><b>Ⅲ<br>세<br>액<br>명<br>세</b></TD>
	<TD class="td4" colspan="4" valign="middle">구분</TD>
	<TD class="td4" width="90" valign="middle">소득세</TD>
	<TD class="td4" width="90" valign="middle">주민세</TD>
	<TD class="td4" width="90" valign="middle">농어촌특별세</TD>
	<TD class="td4" width="90" valign="middle">계</TD>	
</TR>
<TR>
	<TD class="td7" colspan="4" valign="middle">64.결정세액</TD>
	<TD class="td10s" width="90" valign="middle"><%=ItData.DTR_ITAX %></TD>
	<TD class="td10s" width="90" valign="middle"><%=ItData.DTR_RTAX %></TD>
	<TD class="td10s" width="90" valign="middle"><%=ItData.DTR_STAX %></TD>
	<TD class="td10s" width="90" valign="middle"><%=ItData.DTR_TOT %></TD>	
</TR>
<TR>
	<TD class="td4" rowspan="4" valign="middle">기납부<br>세액</TD>
	<TD class="td4s" rowspan="3" valign="middle">65.종(전)근무지<br>(결정세액란의<br>세액 기재)</TD>
	<TD class="td4" rowspan="3" valign="middle">사업자<br>등록<br>번호</TD>
	<TD class="td10s" valign="middle"><%=Seqno1.BUZINUM %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno1.INTAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno1.RETAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno1.SPTAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno1.TLTAX_AMT %></TD>	
</TR>
<TR>
	<TD class="td10s" valign="middle"><%=Seqno2.BUZINUM %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno2.INTAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno2.RETAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno2.SPTAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno2.TLTAX_AMT %></TD>	
</TR>
<TR>
	<TD class="td10s" valign="middle"><%=S_TXPAS.BUZINUM %></TD>
	<TD class="td10s" width="90" valign="middle"><%=S_TXPAS.INTAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=S_TXPAS.RETAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=S_TXPAS.SPTAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=S_TXPAS.TLTAX_AMT %></TD>	
</TR>
<TR>
	<TD class="td7" colspan="3" valign="middle">66.주(현)근무지</TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno0.INTAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno0.RETAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno0.SPTAX_AMT %></TD>
	<TD class="td10s" width="90" valign="middle"><%=Seqno0.TLTAX_AMT %></TD>	
</TR>
<TR>
	<TD class="td7" colspan="4" valign="middle">67.차 감 징 수 세 액</TD>
	<TD class="td10s" width="90" valign="middle"><%=ItData.REM_ITAX %></TD>
	<TD class="td10s" width="90" valign="middle"><%=ItData.REM_RTAX %></TD>
	<TD class="td10s" width="90" valign="middle"><%=ItData.REM_STAX %></TD>
	<TD class="td10s" width="90" valign="middle"><%=ItData.REM_TOT %></TD>	
</TR>
</table><table class="tb_bottom" width="650" height=150 cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" style="table-layout:fixed">
<col class="td4" width="630">      
                    
<TR>
	<TD class="td4" valign="middle">
	<br><br>
	<span style="padding:9px"></span>건강보험 : <%= ItData.Y42 %></span><span style="text-align:right; word-spacing:20px; padding-left:150px;"> 위의 원천징수액(근로소득)을 영수(지급)합니다.</span><br><br>
        <span style="padding:9px"></span>고용보험 : <%= ItData.Y44 %></span><span style="text-align:right; word-spacing:20px; padding-left:330px;"><%=HData.DATUM %></span><br><br>
        <span style="padding:9px"></span>국민연금 : <%= ItData.Y43 %></span><span style="text-align:right; word-spacing:10px; padding-left:150px;">징수(보고)의무자   <%=HData.DUTYM %> (</span><span style="padding-right:38px;">서명 또는 인)</span><br><br><br>
	<span align="right" style="padding-left:385px; word-spacing:30px"><%=HData.ENAME %> 귀하</span><br><br><br><br>
	</TD>
</TR>
</table>

</p>

<p style="page-break-after:always;"> 

<!-- 2Page  -->
<table class="tb_all" width="650" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" style="table-layout:fixed">
<col class="td4" width="20">      
<col class="td4" width="20">      
<col class="td4" width="20">      
<col class="td4" width="180">      
<col class="td4" width="88">     
<col class="td4" width="20">      
<col class="td4" width="194">
<col class="td4" width="88">      
<!--650-20해야 프린트 기본19.05를 수정하지 않아도 전체 출력이 됨

<col class="td4" width="22">      
<col class="td4" width="22">      
<col class="td4" width="22">      
<col class="td4" width="182">      
<col class="td4" width="90">     
<col class="td4" width="22">      
<col class="td4" width="200">
<col class="td4" width="90">  -->    
      
      

<TR>
	<TD class="p2_td4" rowspan="28" ehight=width="22" valign="middle"><b>Ⅳ<br>정<br>산<br>명<br>세</b></TD>
	<TD class="p2_td7" colspan="3" valign="middle">21.총급여(16 또는 16 - 18-3)</TD>
	<TD class="p2_td10" width="90" valign="middle"><%=ItData.TAX_GROSS %></TD>
	<TD class="p2_td4" rowspan="11" width="22" valign="middle">그<br>&nbsp;<br>밖<br>의<br>&nbsp;<br>소<br>득<br>공<br>제</TD>
	<TD class="p2_td7" width="200" valign="middle">43.개인연금저축소득공제</TD>
	<TD class="p2_td10" width="90" valign="middle"><%=ItData.DED_INDIV %></TD>
</TR>
<TR>
	<TD class="p2_td7" colspan="3" valign="middle">22.근로소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_EARND %></TD>
	<TD class="p2_td7" valign="middle">44.연금저축소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_PPS %></TD>
</TR>
<TR>
	<TD class="p2_td7" colspan="3" valign="middle">23.근로소득금액</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.EARND_AMT %></TD>
	<TD class="p2_td7s" valign="middle">44-1.소기업ㆍ소상공인 공제부금 소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_BIZ %></TD>
</TR>
<TR>	
	<TD class="p2_td4" rowspan="23" width="22" valign="middle">종<br>합<br>소<br>득<br>공<br>제</TD>
	<TD class="p2_td4" rowspan="3" width="22" valign="middle">기<br>본<br>공<br>제</TD>	
	<TD class="p2_td7" width="180" valign="middle">24.본인</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.BASE_EE %></TD>
	<TD class="p2_td7" valign="middle">44-2.주택마련저축소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.HOUS_SAV %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">25.배우자</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.BASE_SPOS %></TD>
	<TD class="p2_td7" valign="middle">45.투자조합출자등소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DD_INVEST %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">26.부양가족(<%=ItData.BAS_DP_N %>명)</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.BASE_DP %></TD>
	<TD class="p2_td7" valign="middle">46.신용카드등소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_CARD %></TD>
</TR>
<TR>	
	<TD class="p2_td4" rowspan="6" width="22" valign="middle">추<br>가<br>공<br>제</TD>	
	<TD class="p2_td7" valign="middle">27.경로우대(<%=ItData.ADD_OLD_N %>명)</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.ADD_OLD %></TD>
	<TD class="p2_td7" valign="middle">47.우리사주조합소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_STCK %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">28.장애인(<%=ItData.ADD_HAND_N %>명)</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.ADD_HAND %></TD>
	<TD class="p2_td7" valign="middle">48.장기주식형저축소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_LTSFI %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">29.부녀자</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.ADD_WOMAN %></TD>
	<TD class="p2_td7" valign="middle">&nbsp;</TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">30.자녀양육비(<%=ItData.ADD_CHILD_N %>명)</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.ADD_CHILD %></TD>
	<TD class="p2_td7" valign="middle">&nbsp;</TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">30-1.출산ㆍ입양자(<%=ItData.ADD_BACHD_N %>명)</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.ADD_BACHD %></TD>
	<TD class="p2_td7" valign="middle">49.그 밖의 소득공제 계</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_SPE_TAX_ACT %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">&nbsp;</TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
	<TD class="p2_td7" colspan="2" valign="middle">50.종합소득 과세표준</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.TAX_BASE %></TD>
</TR>
<TR>	
	<TD class="p2_td7" colspan="2" valign="middle">31.다자녀추가공제(<%=ItData.MUL_CHILD_N %>명)</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.MUL_CHILD %></TD>
	<TD class="p2_td7" colspan="2" valign="middle">51.산출세액</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.CALC_TAX %></TD>
</TR>
<TR>	
	<TD class="p2_td4" rowspan="3" width="22" valign="middle">연<br>금<br>보<br>험<br>료<br>공<br>제</TD>	
	<TD class="p2_td7" valign="middle">32.국민연금보험료공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_NPI %></TD>
	<TD class="p2_td4" rowspan="5" width="22" valign="middle">세<br>액<br>감<br>면</TD>		
	<TD class="p2_td7" valign="middle">52.「소득세법」</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.FOR_ITAX %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">32-1.기타 연금보험료공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_NP %></TD>
	<TD class="p2_td7" valign="middle">53.「조세특례제한법」</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.FOR_ETAX %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">33.퇴직연금소득공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.RET_PEN %></TD>
	<TD class="p2_td7" valign="middle"></TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
</TR>
<TR>	
	<TD class="p2_td4" rowspan="10" width="22" valign="middle">특<br>별<br>공<br>제</TD>	
	<TD class="p2_td7" valign="middle">34.보험료</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_SI %></TD>
	<TD class="p2_td7" valign="middle">&nbsp;</TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">35.의료비</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_MEDI %></TD>
	<TD class="p2_td7" valign="middle">55.세액감면 계</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.FOR_TOT %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">36.교육비</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_EDU %></TD>
	<TD class="p2_td4" rowspan="8" width="22" valign="middle">세<br>액<br>공<br>제</TD>	
	<TD class="p2_td7" valign="middle">56.근로소득</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.EARN_CRET %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">37.주택임차차입금원리금상환액</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.HOUS_PAID %></TD>
	<TD class="p2_td7" valign="middle">57.납세조합공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.TAX_ASSOC %></TD>
</TR>
<TR>	
	<TD class="p2_td7s" valign="middle">37-1.장기주택저당차입금이자상환액</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.HOUS_LOAN %></TD>
	<TD class="p2_td7" valign="middle">58.주택차입금</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.CRET_HOUS %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">38.기부금</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_DONA %></TD>
	<TD class="p2_td7" valign="middle">59.기부 정치자금</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.POLITICAL %></TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle"></TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
	<TD class="p2_td7" valign="middle">60.외국납부</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.ABROD_INC %></TD>
</TR>

<TR>	
	<TD class="p2_td7" valign="middle">&nbsp;</TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
	<TD class="p2_td7" valign="middle"></TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">40.계</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_TOTAL %></TD>
	<TD class="p2_td7" valign="middle"></TD>
	<TD class="p2_td4" valign="middle">&nbsp;</TD>
</TR>
<TR>	
	<TD class="p2_td7" valign="middle">41.표준공제</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DED_SPEC %></TD>
	<TD class="p2_td7" valign="middle">63.세액공제 계</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.CRET_TOT %></TD>
</TR>
<TR>	
	<TD class="p2_td7" colspan="3" valign="middle">42.차감소득금액</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.AFTER_SPEC %></TD>
	<TD class="p2_td7" colspan="2" valign="middle">결정세액(51 - 55 - 63)</TD>
	<TD class="p2_td10" valign="middle"><%=ItData.DTR_ITAX %></TD>
</TR>
</table>
</p> 

<!-- 3Page  -->
<% 
	for(int i=0;i < (G20EcmtPrintData_Family_vt.size() / 5)+1;i++) {
%>
<% 
		if( i != (G20EcmtPrintData_Family_vt.size() / 5) ) {
%>
<p style="page-break-after:always;">

<% 
		}
%>

<table class="tb_all" width="650" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
<TR>
	<TD class=td8 colspan="100%" valign="middle" bgcolor="#e5e5e5">
	<P>68.소득공제 명세(인적공제항목은 해당란에 "○"표시를 하며, 각종 소득공제 항목은 공제를 위하여 실제 지출한 금액을 적습니다)</P>
	</TD>
</TR>
<TR>
	<TD class=td9 width="90" height="35" valign="middle">관계<br>코드</TD>
	<TD class=td4 width="135" valign="middle">성&nbsp;명</TD>
	<TD class=td4 colspan="5" width="144" valign="middle">인적공제 항목</TD>
	<TD class=td9 rowspan="3" width="90" valign="middle">자료<br>구분</TD>
	<TD class=td4 colspan="6" width="370" valign="middle">각종 소득공제 항목</TD>
</TR>
<TR>
	<TD class=td4 rowspan="2" height="75" valign="middle">내ㆍ외<br>국인</TD>
	<TD class=td4 rowspan="2" width="95" valign="middle">주민등록<br>번&nbsp;&nbsp;호</TD>
	<TD class=td4 width="50" valign="middle">기본<br>공제</TD>
	<TD class=td4 rowspan="2" width="50" valign="middle">경로<br>우대<br>공제</TD>
	<TD class=td4 rowspan="2" width="50" valign="middle">출산<br>ㆍ<br>입양<br>자<br>공제</TD>
	<TD class=td4 rowspan="2" width="50" valign="middle">장애<br>인<br>공제</TD>
	<TD class=td4 rowspan="2" width="50" valign="middle">자녀<br>양육비<br>공제</TD>
	<TD class=td4 rowspan="2" width="" valign="middle">보험료<br>(건강보험료<br>등 포함)</TD>
	<TD class=td4 rowspan="2" width="50" valign="middle">의료비</TD>
	<TD class=td4 rowspan="2" width="50" valign="middle">교육비</TD>
	<TD class=td4 colspan="2" width="120" valign="middle">신용카드 등<br>사용액공제</TD>
	<TD class=td4 rowspan="2" width="60" valign="middle">기부금</TD>
</TR>
<TR>
	<TD class=td4 valign="middle">부녀<br>자<br>공제</TD>
	<TD class=td4 valign="middle">신용카드<br>ㆍ<br>직불카드 등</TD>
	<TD class=td4 valign="middle">현금<br>영수증</TD>
</TR>
<TR>
	<TD class=td9 rowspan="2" colspan="2" height="60" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;border-bottom:double #000000 1.4pt;'>
	인적공제 항목에<br>해당하는<br>인원수를 기재<br>(다자녀&nbsp;<%=ItData.MUL_CHILD_N %>명)
	</TD>
	<TD class=td9 height="30" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;'>
	<%=G20EcmtPrintData_Family_vt.size() -1 %>
	</TD>
	<TD class=td9 rowspan="2" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.ADD_OLD_N %>
	</TD>
	<TD class=td9 rowspan="2" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.ADD_BACHD_N %>
	</TD>
	<TD class=td9 rowspan="2" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.ADD_HAND_N %>
	</TD>
	<TD class=td9 rowspan="2" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.ADD_CHILD_N %>
	</TD>
	<TD class=td9 valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;'>
	국세청
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;'>
	<%=ItData.DL_INNSU %>
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;'>
	<%=ItData.DL_MENSU %>
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;'>
	<%=ItData.DL_EDNSU %>
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;'>
	<%=ItData.DL_CRNSU %>
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;'>
	<%=ItData.DL_CANSU %>
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:double #000000 1.4pt;'>
	<%=ItData.DL_DONSU %>
	</TD>
</TR>
<TR>
	<TD class=td9 height="25" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.ADD_WOMAN_N %>
	</TD>
	<TD class=td9 valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-bottom:double #000000 1.4pt;'>
	기타
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.DL_INOSU %>
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.DL_MEOSU %>
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.DL_EDOSU %>
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.DL_CROSU %>
	</TD>
	<TD class=td10s valign="middle" bgcolor="#bcbcbc" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-bottom:double #000000 1.4pt;'>
	&nbsp;
	</TD>
	<TD class=td10s valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-bottom:double #000000 1.4pt;'>
	<%=ItData.DL_DOOSU %>
	</TD>
</TR>

<% 
	int cnt = i * 5;
	for(int j=0;j < 5;j++) {

 		if(cnt < G20EcmtPrintData_Family_vt.size() && (j % 5 != 0 || j == 0)) {
			G20EcmtPrintFamilyData F_Seq = (G20EcmtPrintFamilyData)G20EcmtPrintData_Family_vt.get(cnt);
			cnt++;
%>

<TR>
	<TD class=td9 height="27" valign="middle"><%=F_Seq.RELAT %></TD>
	<TD class=td9 valign="middle"><%=F_Seq.FNAME %></TD>	
	<TD class=td9 valign="middle"><%=F_Seq.DPTID %></TD>
	<TD class=td9 rowspan="2" valign="middle"><%=F_Seq.OLDII %></TD>
	<TD class=td9 rowspan="2" valign="middle"><%=F_Seq.BACHD %></TD>
	<TD class=td9 rowspan="2" valign="middle"><%=F_Seq.HNDID %></TD>
	<TD class=td9 rowspan="2" valign="middle"><%=F_Seq.CHDID %></TD>
	<TD class=td9 valign="middle">국세청</TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.INSNA,100) ))?WebUtil.printNumFormatSap(F_Seq.INSNA,100):"" %></TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.MEDNA,100) ))?WebUtil.printNumFormatSap(F_Seq.MEDNA,100):"" %></TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.EDUNA,100) ))?WebUtil.printNumFormatSap(F_Seq.EDUNA,100):"" %></TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.CRENA,100) ))?WebUtil.printNumFormatSap(F_Seq.CRENA,100):"" %></TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.CASNA,100) ))?WebUtil.printNumFormatSap(F_Seq.CASNA,100):"" %></TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.DONNA,100) ))?WebUtil.printNumFormatSap(F_Seq.DONNA,100):"" %></TD>
</TR>
<TR>
	<TD class=td9 height="25" valign="middle"><%=F_Seq.FOREI %></TD>
	<TD class=td9 valign="middle" <%=("0".equals(F_Seq.RELAT))?"bgcolor='#bcbcbc'":"" %>><%=("0".equals(F_Seq.RELAT))?"(근로자 본인)":( (!"".equals(F_Seq.REGNO) && F_Seq.REGNO != null)?F_Seq.REGNO.substring(0,6)+"-"+F_Seq.REGNO.substring(6,13):"" ) %></TD>	
	<TD class=td9 valign="middle"><%=F_Seq.WOMEE %></TD>
	<TD class=td9 valign="middle">기타</TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.INSOT,100) ))?WebUtil.printNumFormatSap(F_Seq.INSOT,100):"" %></TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.MEDOT,100) ))?WebUtil.printNumFormatSap(F_Seq.MEDOT,100):"" %></TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.EDUOT,100) ))?WebUtil.printNumFormatSap(F_Seq.EDUOT,100):"" %></TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.CREOT,100) ))?WebUtil.printNumFormatSap(F_Seq.CREOT,100):"" %></TD>
	<TD class=td10s valign="middle" bgcolor="#bcbcbc">&nbsp;</TD>
	<TD class=td10s valign="middle"><%=( !("0").equals( WebUtil.printNumFormatSap(F_Seq.DONOT,100) ))?WebUtil.printNumFormatSap(F_Seq.DONOT,100):"" %></TD>
</TR>
<% 
		} else {
%>		
<TR>
	<TD class=td9 height="27" valign="middle">&nbsp;</TD>
	<TD class=td9 valign="middle">&nbsp;</TD>	
	<TD class=td9 valign="middle">&nbsp;</TD>
	<TD class=td9 rowspan="2" valign="middle">&nbsp;</TD>
	<TD class=td9 rowspan="2" valign="middle">&nbsp;</TD>
	<TD class=td9 rowspan="2" valign="middle">&nbsp;</TD>
	<TD class=td9 rowspan="2" valign="middle">&nbsp;</TD>
	<TD class=td9 valign="middle">국세청</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
</TR>
<TR>
	<TD class=td9 height="25" valign="middle">&nbsp;</TD>
	<TD class=td9 valign="middle" <%=(j % 5 == 0)?"bgcolor='#bcbcbc'":"" %>><%=(j % 5 == 0)?"(근로자 본인)":"" %></TD>	
	<TD class=td9 valign="middle"></TD>
	<TD class=td9 valign="middle">기타</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
	<TD class=td10 valign="middle" bgcolor="#bcbcbc">&nbsp;</TD>
	<TD class=td10 valign="middle">&nbsp;</TD>
</TR>		
<%		
		} 	// if-else End
	}		// for End
%>

<TR>
	<TD class=td5s colspan="100%" height="495">
	※ 작성방법
	<br>
	1. 거주지국과 거주지국코드는 비거주자에 해당하는 경우에만  적으며, 국제표준화기구(ISO)가 정한 ISO코드 중 국명약어 및 국가코드를 적습니다(※ ISO국가코드: 국세청홈페이지→국세정보→국제조세정보→국세조세자료실에서 조회할 수 있습니다). 예) 대한민국:KR, 미국:US<br><br>
	2. 원천징수의무자는 지급일이 속하는 연도의 다음 연도 3월 10일(휴업 또는 폐업한 경우에는 휴업일 또는 폐업일이 속하는 달의 다음 다음 달 말일을 말합니다)까지 지급명세서를 제출하여야 합니다.<br><br>
	3. Ⅰ근무처별소득명세란은 비과세소득(외국인근로자 30% 비과세 제외)을 제외한 금액을  Ⅱ.비과세 소득란에는 지급명세서 작성대상 비과세소득을 비과세소득명과 해당코드별로 구분하여 적습니다(비과세항목이 많은 경우 Ⅱ.비과세 소득란의 (20)적고Ⅱ.비과세 소득란을 별지로 작성 가능합니다.)<br><br>
	4. 갑종근로소득과 을종근로소득을 더하여 연말정산하는 때에는 (16)-1납세조합란에 각각 을종근로소득납세조합과 을종근로소득을 적고,「소득세법 시행령」 제150조에 따른 납세조합공제금액을 (57)납세조합공제란에 적습니다. 합병, 기업형태 변경 등으로 해당 법인이 연말정산을 하는 경우에 피합병법인, 기업형태변경전의 소득은 근무처별소득명세 종(전)란에 별도로 적습니다.<br><br>
	5. "(18)-3"란은 외국인근로자가「조세특례제한법」 제18조의2제1항을 적용하는 경우에만 적으며, "(16)계"란의 금액에 100분의 30을 곱한 금액을 적습니다. <br><br>
	6. (21) 총급여란에는 "(16)계" 란의 금액을 적되, "(18)-3"란의 금액이 있는 경우에는 "(16)걔"란의 금액에서 "(18)-3"란의 금액을 뺀 금액을 적으며, 외국인근로자로가「조세특례제한법」 제18조의2 제2항에 따라 단일세율을 적용하는 경우에는 "(16)계"의 금액과 비과세소득금액을 더한 금액을 적고, 소득세와 관련한 비과세ㆍ공제ㆍ감면 및 세액공제에 관한 규정은 적용하지 않습니다.<br><br>
	7. 종합소득 특별공제(34~39)란과 그 밖의 소득공제(43~47)란은 별지 제37호서식의 공제액을 적습니다.<br><br>
	8. 이 서식에 적는 금액 중 소수점 이하 값만 버리며, (67)차감징수세액이 소액부징수(1천원 미만을 말합니다)에 해당하는 경우 세액을 "0"으로 적습니다.<br><br>
	9. (68)소득공제 명세란은 2006년 이후 발생하는 근로소득 연말정산분부터 사용합니다.<br><br>
	&nbsp;&nbsp;가. 관계코드란: 소득자 본인=0, 소득자의 직계존속=1, 배우자의 직계존속=2, 배우자=3, 직계비속 자녀=4, 직계비속 자녀 외 = 5 형제자매=6, 기타=7을 적습니다(4ㆍ5ㆍ6ㆍ7의 경우 소득자와 배우자의 각각의 관계를 포함합니다).<br><br>
	&nbsp;&nbsp;나. 내ㆍ외국인란: 내국인의 경우 “1”로, 외국인의 경우 “9”로 적습니다.<br><br>
	&nbsp;&nbsp;다. 인적공제항목란: 인적공제사항이 있는 경우 해당란에 “○” 표시를 합니다(해당 사항이 없을 경우 비워둡니다).<br><br>
	&nbsp;&nbsp;라. 국세청 자료란: 「소득세법」 제165조에 따라 국세청 홈페이지에서 제공하는 각 소득공제 항목의 금액 중 소득공제대상이 되는 금액을 적습니다.<br><br>
	&nbsp;&nbsp;마. 그 밖의 자료란: 국세청에서 제공하는 증빙서류 외의 것을 말합니다(예를 들면, 학원비 지로납부영수증은 "신용카드 등"란에, 시력교정용 안경구입비는 의료비란에 각각 적습니다). <br><br>
	&nbsp;&nbsp;바. 각종 소득공제 항목란: 소득공제항목에 해당하는 실제 지출금액을 적습니다(소득공제액이 아닌 실제 사용금액을 공제항목별로 구분된 범위 안에 적습니다).<br>
	</TD>
</TR>
</table>


<% 
		if( i != (G20EcmtPrintData_Family_vt.size() / 5) ) {
%>
<!--<br>
<SPAN style="page-break-after:always"></SPAN>-->
</p>

<% 
		}
%>

<%		
	}	
%>
<!-- 3Page End -->
<% } 
%>

</div>
</form>
<img id="layer2" src="<%= WebUtil.ImageURL %>doDojang.jpg" width="80" height="79" style="position:absolute; left:537; top:855; z-index:-1; filter:alpha(opacity=60, style=0, finishopacity=60);">

<% 
         }catch (Exception e) {
            //out.println(  "DATA가 존재하지 않습니다.");    

         }
%>

<%@ include file="./../../common/commonEnd.jsp" %>
