<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : Global육성POOL                                              */
/*   Program Name : HPI Global육성POOL                                          */
/*   Program ID   : F70GlobalClass.jsp                                          */
/*   Description  : HPI Global육성POOL 조회를 위한 jsp 파일                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-03-15 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/commonProcess.jsp" %>  
    
<%@ page import="java.util.Vector" %>  
<%@ page import="hris.common.*" %>     
<%@ page import="hris.common.rfc.*" %>  
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>          
           
<%   
    WebUserData user    = (WebUserData)session.getAttribute("user");                              //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);      //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                    //부서명
    String pool         = WebUtil.nvl(request.getParameter("pool"));                          //메뉴구분
    pool                = pool.substring(0,2);;                          //메뉴구분
    String jobid        = WebUtil.nvl(request.getParameter("jobid"));                         //
    Vector F70GlobalClassTitle_vt = (Vector)request.getAttribute("F70GlobalClassTitle_vt");   //제목
    Vector F70GlobalClassNote_vt  = (Vector)request.getAttribute("F70GlobalClassNote_vt");    //내용    

    String Title [];
    Title = new String [18];
    Title[ 1]="HPI                  ";        
    Title[ 2]="지역전문가           ";
    Title[ 3]="HPI&지역전문가       ";
    Title[ 4]="육성MBA              ";
    Title[ 5]="HPI&육성MBA          ";
    Title[ 6]="법인장교육이수자     ";
    Title[ 7]="확보MBA              ";
    Title[ 8]="해외학위자           ";
    Title[ 9]="R&D박사              ";
    Title[10]="국내외국인근무자     ";
    Title[11]="중국지역경험자       ";
    Title[12]="중국外지역경험자     ";
    Title[13]="TOEIC 800점 이상자   ";
    Title[14]="HSK 5등급 이상자     ";
    Title[15]="LGA 3.5점 이상자     ";
    Title[16]="중국어 전공자        ";
    Title[17]="영어&중국어 가능자   ";
%>
 
<SCRIPT LANGUAGE="JavaScript"> 
<!-- 
  
//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){ 
    frm = document.form1; 
    if (deptNm=="")
        return;
    frm.hdn_deptId.value = deptId;  
    frm.hdn_deptNm.value = deptNm; 
    frm.hdn_excel.value = ""; 
    frm.jobid.value = "search"; 
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F70GlobalClassSV";
    frm.target = "_self";
    frm.submit();
}        
   
//상세화면으로 이동. 
function goDetail(paramA, paramB, paramC, paramD, value){
    frm = document.form1; 
  
    if( value!= "" && value!= "0"){
	    frm.hdn_gubun.value  = "<%= pool %>";             //HPI  
	    frm.hdn_deptId.value = "<%= deptId %>";  //조회된 부서코드.   
	    frm.hdn_paramA.value = paramA;           //선택된 부서코드.
      frm.hdn_paramB.value = paramB;           //선택된 부서명
	    frm.hdn_paramC.value = paramC;
	    frm.hdn_paramD.value = paramD;
	    frm.hdn_excel.value = ""; 
	    frm.action = "<%= WebUtil.ServletURL %>hris.F.F71GlobalDetailListSV";
	    frm.target = "_self";
	    frm.submit();
    }
}  

//Execl Down 하기.
function excelDown() {
    frm = document.form1; 
    
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F70GlobalClassSV";
    frm.target = "ifHidden";
    frm.submit();
}
//--> 
</SCRIPT>  
  
<html>
<head>
<title>MSS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>
 
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" onsubmit="return false"> 
<input type="hidden" name="jobid"       value="search">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">  
<input type="hidden" name="hdn_excel"   value=""> 
<!--//01: HPI02: 지역전문가03: HPI&지역전문가04: 육성MBA05: HPI&육성MBA06: 법인장교육이수자07: 확보MBA08: 해외학위자09: R&D박사10: 국내외국인근무자11: 중국지역경험자12: 중국外지역경험자13: TOEIC 800점 이상자14: HSK 5등급 이상자15: LGA 3.5점 이상자16: 중국어 전공자17: 영어&중국어 가능자-->
<input type="hidden" name="pool"       value="<%=pool%>"> 

<input type="hidden" name="hdn_gubun"   value=""> 
<input type="hidden" name="hdn_paramA"  value=""> 
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="">
          
<table width="796" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="780" border="0" cellpadding="0" cellspacing="0" align="left">
        <tr>
          <td height="10" colspan="2"></td> 
        </tr>  
        <tr>
          <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif"><%=Title[Integer.parseInt(pool)]%></td>
          <!--<td class="titleRight"><a href="javascript:open_help('X04Statistics.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>-->
        </tr>
         <tr>
          <td height="10" colspan="2"></td> 
        </tr>
      </table>
    </td>
  </tr>   
          
<!--   부서검색 보여주는 부분 시작   -->
  <tr>
    <td width="16">&nbsp;</td>
    <td >     
      <%@ include file="/web/common/SearchDeptInfo.jsp" %>
    </td> 
  </tr>      
<!--   부서검색 보여주는 부분  끝    -->

</table>

<% 
    if ( F70GlobalClassTitle_vt != null && F70GlobalClassTitle_vt.size() > 0 ) {  
%>
<table border="0" cellspacing="0" cellpadding="0" align="left">
<%  //comment
    if ( pool.equals("17") ) {  //영어&중국어 가능자
%>
  <tr>
    <td width="16" nowrap>&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
	      <td width="50%" class="td09">
	        &nbsp;※ 영어:TOEIC 700점 이상 or LGA 3 이상, 중국어: HSK 5등급 이상 or 중국어 전공자&nbsp;
          </td>
	      <td ></td>
	    </tr> 
	    <tr><td height="10"></td></tr>
      </table>
    </td>
  </tr>     
<%  }  %>   

  <tr>
    <td width="16" nowrap>&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
	      <td width="50%" class="td09">
	        &nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
            &nbsp;&nbsp;<a href="javascript:excelDown();"><img src="<%= WebUtil.ImageURL %>btn_EXCELdownload.gif" border="0" align="absmiddle"></a>
          </td>
	      <td ></td>
	    </tr> 
	    <tr><td height="10"></td></tr>
      </table>
    </td>
  </tr>     
  <tr> 
    <td width="16" nowrap>&nbsp;</td> 
    <td colspan="2" valign="top">
      <table border="0" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr> 
          <td rowspan="2" class="td03">구분</td>       
<%               
            String tempTitleCode = ""; //임시 타이틀코드
            String tempTitleName = ""; //임시 타이틀명
            int    tempCnt       = 1;
            
		    //상위 타이틀.
		    for( int h = 0; h < F70GlobalClassTitle_vt.size(); h++ ){
		        F70GlobalClassTitleData titleData = (F70GlobalClassTitleData)F70GlobalClassTitle_vt.get(h); 			             
		        
		        if( titleData.TITLACD.equals(tempTitleCode) ){
		            tempCnt++;			            
		        }else{
		            if( h > 0 ){
%>                      
          <td class="td03" colspan="<%=tempCnt%>" ><%=tempTitleName%></td>
<%    				        tempCnt = 1;
                    }
		        }
		        tempTitleCode = titleData.TITLACD;
		        tempTitleName = titleData.TITLATXT;
            }//end for
%>          
          <td width="60" class="td03" rowspan="2" nowrap>합 계</td>
        </tr>
        <tr> 
<%                
            //하위 타이틀.
            for( int k = 0; k < F70GlobalClassTitle_vt.size()-1; k++ ){
                F70GlobalClassTitleData titleData = (F70GlobalClassTitleData)F70GlobalClassTitle_vt.get(k);   
%>           
          <td width="50" class="td03" nowrap ><%=titleData.TITLBTXT%></td>
<%
            }//end for
                        
            //타이틀에 맞추어 내용영역 보여주기위한 개수.
            int noteSize = F70GlobalClassTitle_vt.size();
            //내용.
			for( int i = 0; i < F70GlobalClassNote_vt.size(); i++ ){
			    F70GlobalClassNoteData data = (F70GlobalClassNoteData)F70GlobalClassNote_vt.get(i);
			    
			    String strBlank  = "";
			    String titlClass = "";
			    String noteClass = "";
                int blankSize = Integer.parseInt(WebUtil.nvl(data.ZLEVEL, "0")) ;  
                
                //클래스 설정.
                if (blankSize != 0) {
					titlClass = "class=td09";
					noteClass = "class=td05";
				} else {
                    titlClass = "class=td11";
                    noteClass = "class=td12";
				}
				
				//부서명 앞에 공백넣기.
                for (int h = 0; h < blankSize; h++) { 
                    strBlank = strBlank+"&nbsp;&nbsp;";
                } 
    
%>
        <tr> 
          <td <%=titlClass%> nowrap ><%=strBlank%><%=data.STEXT%>&nbsp;&nbsp;</td>
          <td <%=noteClass%> ><a href="javascript:goDetail('<%=data.OBJID%>','<%=data.STEXT%>','<%=data.TITLACD1%>','<%=data.TITLBCD1%>', '<%=data.F1%>');"><%=WebUtil.printNumFormat(data.F1)%></a></td>
          <td <%=noteClass%> ><a href="javascript:goDetail('<%=data.OBJID%>','<%=data.STEXT%>','<%=data.TITLACD2%>','<%=data.TITLBCD2%>', '<%=data.F2%>');"><%=WebUtil.printNumFormat(data.F2)%></a></td> 
          <td <%=noteClass%> ><a href="javascript:goDetail('<%=data.OBJID%>','<%=data.STEXT%>','<%=data.TITLACD3%>','<%=data.TITLBCD3%>', '<%=data.F3%>');"><%=WebUtil.printNumFormat(data.F3)%></a></td>   
          <% if( noteSize >= 4 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD4 +"','"+data.TITLBCD4 +"','"+data.F4+"');\">" +WebUtil.printNumFormat(data.F4)+"</a></td>"); %>     
          <% if( noteSize >= 5 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD5 +"','"+data.TITLBCD5 +"','"+data.F5+"');\">" +WebUtil.printNumFormat(data.F5)+"</a></td>"); %>     
          <% if( noteSize >= 6 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD6 +"','"+data.TITLBCD6 +"','"+data.F6+"');\">" +WebUtil.printNumFormat(data.F6)+"</a></td>"); %>     
          <% if( noteSize >= 7 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD7 +"','"+data.TITLBCD7 +"','"+data.F7+"');\">" +WebUtil.printNumFormat(data.F7)+"</a></td>"); %>     
          <% if( noteSize >= 8 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD8 +"','"+data.TITLBCD8 +"','"+data.F8+"');\">" +WebUtil.printNumFormat(data.F8)+"</a></td>"); %>     
          <% if( noteSize >= 9 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD9 +"','"+data.TITLBCD9 +"','"+data.F9+"');\">" +WebUtil.printNumFormat(data.F9)+"</a></td>"); %>     
          <% if( noteSize >= 10 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD10+"','"+data.TITLBCD10+"','"+data.F10+"');\">"+WebUtil.printNumFormat(data.F10)+"</a></td>"); %>     
          <% if( noteSize >= 11 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD11+"','"+data.TITLBCD11+"','"+data.F11+"');\">"+WebUtil.printNumFormat(data.F11)+"</a></td>"); %>     
          <% if( noteSize >= 12 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD12+"','"+data.TITLBCD12+"','"+data.F12+"');\">"+WebUtil.printNumFormat(data.F12)+"</a></td>"); %>     
          <% if( noteSize >= 13 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD13+"','"+data.TITLBCD13+"','"+data.F13+"');\">"+WebUtil.printNumFormat(data.F13)+"</a></td>"); %>     
          <% if( noteSize >= 14 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD14+"','"+data.TITLBCD14+"','"+data.F14+"');\">"+WebUtil.printNumFormat(data.F14)+"</a></td>"); %>     
          <% if( noteSize >= 15 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD15+"','"+data.TITLBCD15+"','"+data.F15+"');\">"+WebUtil.printNumFormat(data.F15)+"</a></td>"); %>     
          <% if( noteSize >= 16 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD16+"','"+data.TITLBCD16+"','"+data.F16+"');\">"+WebUtil.printNumFormat(data.F16)+"</a></td>"); %>     
          <% if( noteSize >= 17 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD17+"','"+data.TITLBCD17+"','"+data.F17+"');\">"+WebUtil.printNumFormat(data.F17)+"</a></td>"); %>     
          <% if( noteSize >= 18 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD18+"','"+data.TITLBCD18+"','"+data.F18+"');\">"+WebUtil.printNumFormat(data.F18)+"</a></td>"); %>     
          <% if( noteSize >= 19 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD19+"','"+data.TITLBCD19+"','"+data.F19+"');\">"+WebUtil.printNumFormat(data.F19)+"</a></td>"); %>     
          <% if( noteSize >= 20 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD20+"','"+data.TITLBCD20+"','"+data.F20+"');\">"+WebUtil.printNumFormat(data.F20)+"</a></td>"); %>     
          <% if( noteSize >= 21 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD21+"','"+data.TITLBCD21+"','"+data.F21+"');\">"+WebUtil.printNumFormat(data.F21)+"</a></td>"); %>     
          <% if( noteSize >= 22 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD22+"','"+data.TITLBCD22+"','"+data.F22+"');\">"+WebUtil.printNumFormat(data.F22)+"</a></td>"); %>     
          <% if( noteSize >= 23 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD23+"','"+data.TITLBCD23+"','"+data.F23+"');\">"+WebUtil.printNumFormat(data.F23)+"</a></td>"); %>     
          <% if( noteSize >= 24 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD24+"','"+data.TITLBCD24+"','"+data.F24+"');\">"+WebUtil.printNumFormat(data.F24)+"</a></td>"); %>     
          <% if( noteSize >= 25 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD25+"','"+data.TITLBCD25+"','"+data.F25+"');\">"+WebUtil.printNumFormat(data.F25)+"</a></td>"); %>     
          <% if( noteSize >= 26 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD26+"','"+data.TITLBCD26+"','"+data.F26+"');\">"+WebUtil.printNumFormat(data.F26)+"</a></td>"); %>     
          <% if( noteSize >= 27 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD27+"','"+data.TITLBCD27+"','"+data.F27+"');\">"+WebUtil.printNumFormat(data.F27)+"</a></td>"); %>     
          <% if( noteSize >= 28 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD28+"','"+data.TITLBCD28+"','"+data.F28+"');\">"+WebUtil.printNumFormat(data.F28)+"</a></td>"); %>     
          <% if( noteSize >= 29 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD29+"','"+data.TITLBCD29+"','"+data.F29+"');\">"+WebUtil.printNumFormat(data.F29)+"</a></td>"); %>     
          <% if( noteSize >= 30 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD30+"','"+data.TITLBCD30+"','"+data.F30+"');\">"+WebUtil.printNumFormat(data.F30)+"</a></td>"); %>     
          <% if( noteSize >= 31 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD31+"','"+data.TITLBCD31+"','"+data.F31+"');\">"+WebUtil.printNumFormat(data.F31)+"</a></td>"); %>     
          <% if( noteSize >= 32 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD32+"','"+data.TITLBCD32+"','"+data.F32+"');\">"+WebUtil.printNumFormat(data.F32)+"</a></td>"); %>     
          <% if( noteSize >= 33 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD33+"','"+data.TITLBCD33+"','"+data.F33+"');\">"+WebUtil.printNumFormat(data.F33)+"</a></td>"); %>     
          <% if( noteSize >= 34 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD34+"','"+data.TITLBCD34+"','"+data.F34+"');\">"+WebUtil.printNumFormat(data.F34)+"</a></td>"); %>     
          <% if( noteSize >= 35 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD35+"','"+data.TITLBCD35+"','"+data.F35+"');\">"+WebUtil.printNumFormat(data.F35)+"</a></td>"); %>     
          <% if( noteSize >= 36 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD36+"','"+data.TITLBCD36+"','"+data.F36+"');\">"+WebUtil.printNumFormat(data.F36)+"</a></td>"); %>     
          <% if( noteSize >= 37 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD37+"','"+data.TITLBCD37+"','"+data.F37+"');\">"+WebUtil.printNumFormat(data.F37)+"</a></td>"); %>     
          <% if( noteSize >= 38 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD38+"','"+data.TITLBCD38+"','"+data.F38+"');\">"+WebUtil.printNumFormat(data.F38)+"</a></td>"); %>     
          <% if( noteSize >= 39 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD39+"','"+data.TITLBCD39+"','"+data.F39+"');\">"+WebUtil.printNumFormat(data.F39)+"</a></td>"); %>     
          <% if( noteSize >= 40 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD40+"','"+data.TITLBCD40+"','"+data.F40+"');\">"+WebUtil.printNumFormat(data.F40)+"</a></td>"); %>     
          <% if( noteSize >= 41 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD41+"','"+data.TITLBCD41+"','"+data.F41+"');\">"+WebUtil.printNumFormat(data.F41)+"</a></td>"); %>     
          <% if( noteSize >= 42 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD42+"','"+data.TITLBCD42+"','"+data.F42+"');\">"+WebUtil.printNumFormat(data.F42)+"</a></td>"); %>     
          <% if( noteSize >= 43 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD43+"','"+data.TITLBCD43+"','"+data.F43+"');\">"+WebUtil.printNumFormat(data.F43)+"</a></td>"); %>     
          <% if( noteSize >= 44 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD44+"','"+data.TITLBCD44+"','"+data.F44+"');\">"+WebUtil.printNumFormat(data.F44)+"</a></td>"); %>     
          <% if( noteSize >= 45 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD45+"','"+data.TITLBCD45+"','"+data.F45+"');\">"+WebUtil.printNumFormat(data.F45)+"</a></td>"); %>     
          <% if( noteSize >= 46 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD46+"','"+data.TITLBCD46+"','"+data.F46+"');\">"+WebUtil.printNumFormat(data.F46)+"</a></td>"); %>     
          <% if( noteSize >= 47 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD47+"','"+data.TITLBCD47+"','"+data.F47+"');\">"+WebUtil.printNumFormat(data.F47)+"</a></td>"); %>     
          <% if( noteSize >= 48 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD48+"','"+data.TITLBCD48+"','"+data.F48+"');\">"+WebUtil.printNumFormat(data.F48)+"</a></td>"); %>     
          <% if( noteSize >= 49 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD49+"','"+data.TITLBCD49+"','"+data.F49+"');\">"+WebUtil.printNumFormat(data.F49)+"</a></td>"); %>     
          <% if( noteSize >= 50 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD50+"','"+data.TITLBCD50+"','"+data.F50+"');\">"+WebUtil.printNumFormat(data.F50)+"</a></td>"); %> 
        </tr>     
<%
		        } //end for...
%>                     
      </table>
    </td>
    <td width="16" nowrap>&nbsp;</td>
  </tr>    
  <tr><td height="16"></td></tr>   
</table>           

<%     
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr align="center"> 
    <td  class="td04" align="center" height="25" ><%= jobid.equals("") ? "" :  "해당하는 데이터가 존재하지 않습니다." %></td>
  </tr>
</table>  
<%
    } //end if...
%>      
</form>
<iframe name="ifHidden" width="0" height="0" />
</body>
</html>

