<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : Global육성POOL                                              */
/*   Program Name : HPI 외. Global육성POOL                                      */
/*   Program ID   : F70GlobalClassExcel.jsp                                     */
/*   Description  : HPI 외. Global육성POOL Excel 저장을 위한 jsp 파일           */
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
    WebUserData user    = (WebUserData)session.getAttribute("user");                            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                  //부서명
    String pool         = WebUtil.nvl(request.getParameter("pool"));                                //부서명
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
    Title[ 7]="확보MBA";
    Title[ 8]="해외학위자";
    Title[ 9]="R&D박사              ";
    Title[10]="국내외국인근무자     ";
    Title[11]="중국지역경험자       ";
    Title[12]="중국外지역경험자     ";
    Title[13]="TOEIC 800점 이상자   ";
    Title[14]="HSK 5등급 이상자     ";
    Title[15]="LGA 3.5점 이상자     ";
    Title[16]="중국어 전공자        ";
    Title[17]="영어&중국어 가능자   ";
    
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=GlobalPositionClass.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */        
%>
 
<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=ks_c_5601-1987">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">      
  
<% 
    if ( F70GlobalClassTitle_vt != null && F70GlobalClassTitle_vt.size() > 0 ) {  
           
        //전체 테이블 크기 조절.
        int tableSize = 0;
        tableSize = F70GlobalClassTitle_vt.size()*50 + 250;
       
%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* <%=Title[Integer.parseInt(pool)]%></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td width="50%" class="td09">
            &nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td ></td>
        </tr> 
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>    
  <tr> 
    <td width="16">&nbsp;</td> 
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr> 
          <td width="250" rowspan="2" class="td03">구분</td>       
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
<%                          tempCnt = 1;
                    }
                }
                tempTitleCode = titleData.TITLACD;
                tempTitleName = titleData.TITLATXT;
            }//end for
%>          
          <td width="50" class="td03" rowspan="2">합 계</td>
        </tr>
        <tr> 
<%                
            //하위 타이틀.
            for( int k = 0; k < F70GlobalClassTitle_vt.size()-1; k++ ){
                F70GlobalClassTitleData titleData = (F70GlobalClassTitleData)F70GlobalClassTitle_vt.get(k);   
%>           
          <td width="50" class="td03" ><%=titleData.TITLBTXT%></td>
<%
            }//end for
                        
            //타이틀에 맞추어 내용영역 보여주기위한 개수.
            int noteSize = F70GlobalClassTitle_vt.size();
            //내용.
            for( int i = 0; i < F70GlobalClassNote_vt.size(); i++ ){
                F70GlobalClassNoteData data = (F70GlobalClassNoteData)F70GlobalClassNote_vt.get(i);
                
                String strBlank  = "";
                int blankSize = Integer.parseInt(WebUtil.nvl(data.ZLEVEL, "0")) ;  
                //부서명 앞에 공백넣기.
                for (int h = 0; h < blankSize; h++) { 
                    strBlank = strBlank+"&nbsp;&nbsp;";
                } 
%>
        <tr> 
          <td><%=strBlank%><%=data.STEXT%></td>
          <td><%=WebUtil.printNumFormat(data.F1)%></td>
          <td><%=WebUtil.printNumFormat(data.F2)%></td> 
          <td><%=WebUtil.printNumFormat(data.F3)%></td>   
          <% if( noteSize >= 4 )   out.println("<td>"+WebUtil.printNumFormat(data.F4) +"</td>"); %>     
          <% if( noteSize >= 5 )   out.println("<td>"+WebUtil.printNumFormat(data.F5) +"</td>"); %>     
          <% if( noteSize >= 6 )   out.println("<td>"+WebUtil.printNumFormat(data.F6) +"</td>"); %>     
          <% if( noteSize >= 7 )   out.println("<td>"+WebUtil.printNumFormat(data.F7) +"</td>"); %>     
          <% if( noteSize >= 8 )   out.println("<td>"+WebUtil.printNumFormat(data.F8) +"</td>"); %>     
          <% if( noteSize >= 9 )   out.println("<td>"+WebUtil.printNumFormat(data.F9) +"</td>"); %>     
          <% if( noteSize >= 10 )  out.println("<td>"+WebUtil.printNumFormat(data.F10)+"</td>"); %>     
          <% if( noteSize >= 11 )  out.println("<td>"+WebUtil.printNumFormat(data.F11)+"</td>"); %>     
          <% if( noteSize >= 12 )  out.println("<td>"+WebUtil.printNumFormat(data.F12)+"</td>"); %>     
          <% if( noteSize >= 13 )  out.println("<td>"+WebUtil.printNumFormat(data.F13)+"</td>"); %>     
          <% if( noteSize >= 14 )  out.println("<td>"+WebUtil.printNumFormat(data.F14)+"</td>"); %>     
          <% if( noteSize >= 15 )  out.println("<td>"+WebUtil.printNumFormat(data.F15)+"</td>"); %>     
          <% if( noteSize >= 16 )  out.println("<td>"+WebUtil.printNumFormat(data.F16)+"</td>"); %>     
          <% if( noteSize >= 17 )  out.println("<td>"+WebUtil.printNumFormat(data.F17)+"</td>"); %>     
          <% if( noteSize >= 18 )  out.println("<td>"+WebUtil.printNumFormat(data.F18)+"</td>"); %>     
          <% if( noteSize >= 19 )  out.println("<td>"+WebUtil.printNumFormat(data.F19)+"</td>"); %>     
          <% if( noteSize >= 20 )  out.println("<td>"+WebUtil.printNumFormat(data.F20)+"</td>"); %>     
          <% if( noteSize >= 21 )  out.println("<td>"+WebUtil.printNumFormat(data.F21)+"</td>"); %>     
          <% if( noteSize >= 22 )  out.println("<td>"+WebUtil.printNumFormat(data.F22)+"</td>"); %>     
          <% if( noteSize >= 23 )  out.println("<td>"+WebUtil.printNumFormat(data.F23)+"</td>"); %>     
          <% if( noteSize >= 24 )  out.println("<td>"+WebUtil.printNumFormat(data.F24)+"</td>"); %>     
          <% if( noteSize >= 25 )  out.println("<td>"+WebUtil.printNumFormat(data.F25)+"</td>"); %>     
          <% if( noteSize >= 26 )  out.println("<td>"+WebUtil.printNumFormat(data.F26)+"</td>"); %>     
          <% if( noteSize >= 27 )  out.println("<td>"+WebUtil.printNumFormat(data.F27)+"</td>"); %>     
          <% if( noteSize >= 28 )  out.println("<td>"+WebUtil.printNumFormat(data.F28)+"</td>"); %>     
          <% if( noteSize >= 29 )  out.println("<td>"+WebUtil.printNumFormat(data.F29)+"</td>"); %>     
          <% if( noteSize >= 30 )  out.println("<td>"+WebUtil.printNumFormat(data.F30)+"</td>"); %>     
          <% if( noteSize >= 31 )  out.println("<td>"+WebUtil.printNumFormat(data.F31)+"</td>"); %>     
          <% if( noteSize >= 32 )  out.println("<td>"+WebUtil.printNumFormat(data.F32)+"</td>"); %>     
          <% if( noteSize >= 33 )  out.println("<td>"+WebUtil.printNumFormat(data.F33)+"</td>"); %>     
          <% if( noteSize >= 34 )  out.println("<td>"+WebUtil.printNumFormat(data.F34)+"</td>"); %>     
          <% if( noteSize >= 35 )  out.println("<td>"+WebUtil.printNumFormat(data.F35)+"</td>"); %>     
          <% if( noteSize >= 36 )  out.println("<td>"+WebUtil.printNumFormat(data.F36)+"</td>"); %>     
          <% if( noteSize >= 37 )  out.println("<td>"+WebUtil.printNumFormat(data.F37)+"</td>"); %>     
          <% if( noteSize >= 38 )  out.println("<td>"+WebUtil.printNumFormat(data.F38)+"</td>"); %>     
          <% if( noteSize >= 39 )  out.println("<td>"+WebUtil.printNumFormat(data.F39)+"</td>"); %>     
          <% if( noteSize >= 40 )  out.println("<td>"+WebUtil.printNumFormat(data.F40)+"</td>"); %>     
          <% if( noteSize >= 41 )  out.println("<td>"+WebUtil.printNumFormat(data.F41)+"</td>"); %>     
          <% if( noteSize >= 42 )  out.println("<td>"+WebUtil.printNumFormat(data.F42)+"</td>"); %>     
          <% if( noteSize >= 43 )  out.println("<td>"+WebUtil.printNumFormat(data.F43)+"</td>"); %>     
          <% if( noteSize >= 44 )  out.println("<td>"+WebUtil.printNumFormat(data.F44)+"</td>"); %>     
          <% if( noteSize >= 45 )  out.println("<td>"+WebUtil.printNumFormat(data.F45)+"</td>"); %>     
          <% if( noteSize >= 46 )  out.println("<td>"+WebUtil.printNumFormat(data.F46)+"</td>"); %>     
          <% if( noteSize >= 47 )  out.println("<td>"+WebUtil.printNumFormat(data.F47)+"</td>"); %>     
          <% if( noteSize >= 48 )  out.println("<td>"+WebUtil.printNumFormat(data.F48)+"</td>"); %>     
          <% if( noteSize >= 49 )  out.println("<td>"+WebUtil.printNumFormat(data.F49)+"</td>"); %>     
          <% if( noteSize >= 50 )  out.println("<td>"+WebUtil.printNumFormat(data.F50)+"</td>"); %> 
        </tr>     
<%                   
                } //end for...
%>                     
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>    
  <tr><td height="16"></td></tr>   
</table>           

<%     
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center"> 
    <td  class="td04" align="center" height="25" >해당하는 데이터가 존재하지 않습니다.</td>
  </tr>
</table>  
<%
    } //end if...
%>      
</form>
</body>
</html>

