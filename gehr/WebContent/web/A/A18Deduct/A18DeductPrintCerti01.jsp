<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.A.A18Deduct.*" %>
<%@ page import="hris.common.*" %>
 
<% 
    
    A18CertiPrintPreWorkData dataPre  = (A18CertiPrintPreWorkData)request.getAttribute("dataPre");
    PersonData publicdata  = (PersonData)request.getAttribute("publicdata");
    A18CertiPrintBusiData    dataBus  = (A18CertiPrintBusiData)request.getAttribute("dataBus");
    A18CertiPrint01Data      data     = (A18CertiPrint01Data)request.getAttribute("data");
    String                   E_PERIOD = (String)request.getAttribute("E_PERIOD");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript"> 
function setDefault() {
	  //factory.printing.header       = ""
	  //factory.printing.footer       = ""
          //factory.printing.portrait     = true;
	  //factory.printing.leftMargin   = 2.0
	  //factory.printing.topMargin    = 3.0
	  //factory.printing.rightMargin  = 1.5
	  //factory.printing.bottomMargin = 3.0
}

function f_print(){
    //factory.printing.Print(false, window);

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
</SCRIPT> 
<style type="text/css">
.font02 {  font-family: "굴림", "굴림체"; font-size: 10pt; background-color: #FFFFFF; color: #333333}
.font03 {  font-family: "굴림", "굴림체"; font-size: 18pt; background-color: #FFFFFF; color: #333333}
.font04 {  font-family: "굴림", "굴림체"; font-size: 9pt; background-color: #FFFFFF; color: #333333}
</style>
</head>

<body class="td11" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="//setDefault();//f_print();">

<form name="form1" method="post" action="">
<table width="650" border="1" bordercolordark="white" bordercolorlight="#000000" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <table width="650" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="142" valign="top">
            <table width="142" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
            </table>
          </td>
          <td width="280" align="center"> 
            <table width="280" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="20">&nbsp;</td>
                <td width="260"><b>&nbsp;</b></td>
              </tr>
              <tr>
                <td> 
                  <input type="checkbox" name="checkbox" value="checkbox" checked="true" disabled>
                </td>
                <td class="font04"><b>근로소득원천징수영수증</b></td>
              </tr>
              <tr>
                <td> 
                  <input type="checkbox" name="checkbox2" value="checkbox" disabled >
                </td>
                <td class="font04"><b>근로소득지급조서</b></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td><b>&nbsp;</b></td>
              </tr>
            </table>
          </td>
          <td width="228" align="right"> 
            <table width="228" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
              <tr> 
                <td class="td09" height=10>&nbsp;거주구분</td>
                <td class="td11" colspan="3">
                  &nbsp;거주자<img src="<%= WebUtil.ImageURL %>check.jpg"> 
                  &nbsp;비거주자<img src="<%= WebUtil.ImageURL %>checkun.jpg"> 
                
                <!--
                  &nbsp;거주자 <input type="radio" name="radiobutton" value="radiobutton" checked disabled>
                  &nbsp;비거주자 <input type="radio" name="radiobutton" value="radiobutton" disabled>	
                  -->
                </td>
              </tr>
              <tr> 
                <td class="td09">&nbsp;내,외국인</td>
                <td class="td11" colspan="3">
                  &nbsp;내국인 <img src="<%= WebUtil.ImageURL %>check.jpg"> <!--input type="radio" name="radiobutton1" value="radiobutton" checked disabled-->
                  &nbsp;외국인 <img src="<%= WebUtil.ImageURL %>checkun.jpg"> <!--input type="radio" name="radiobutton1" value="radiobutton" disabled-->
                </td>
              </tr>
              <tr> 
                <td class="td09" colspan="2">&nbsp;외국인단일세율적용</td>
                <td class="td11" colspan="2">
                  &nbsp;여 <img src="<%= WebUtil.ImageURL %>checkun.jpg"> <!--input type="radio" name="radiobutton1" value="radiobutton" disabled--> 
                  &nbsp;부 <img src="<%= WebUtil.ImageURL %>checkun.jpg"> <!--input type="radio" name="radiobutton1" value="radiobutton" disabled-->
                </td>
              </tr>
              <tr> 
                <td class="td09" width="78">&nbsp;거주지국</td>
                <td class="td11" width="50">&nbsp;</td>
                <td class="td09" width="50">&nbsp;코드</td>
                <td class="td11" width="50">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <table width="650" borderColorDark=white cellspacing="0" cellpadding="0" borderColorLight=#000000 border=1>
        <tr>               
          <td width="40" rowspan="3" align="center" class="td09">징수<br> 의무자</td>                
          <td width="130" class="td09">1. 법인명(상호) </td>               
          <td width="170" class="td11">&nbsp;<%= dataBus.NAME %></td>               
          <td width="140" class="td09">2. 대표자(성명) </td>             
          <td width="170" class="td11">&nbsp;<%= dataBus.KR_REPRES %></td>
        </tr>        <tr> 
          <td class="td09">3. 사업자등록번호</td>                
          <td class="td11">&nbsp;<%= dataBus.STCD2.substring(0,3) + "-" + dataBus.STCD2.substring(3,5) + "-" + dataBus.STCD2.substring(5,10) %></td>                
          <td class="td09">4. 주민(법인)등록번호</td>
          <td class="td11">&nbsp;<%= DataUtil.addSeparate(dataBus.STCD1) %></td>
        </tr>
        <tr> 
          <td class="td09">5. 소재지(주소)</td>
          <td class="td11" colspan="3">&nbsp;<%= dataBus.ADDRESS_LINE %></td>
        </tr>
        <tr> 
          <td class="td09" align="center" rowspan="2">소득자</td>               
          <td class="td09">6. 성명</td>
          <td class="td11">&nbsp;<%= publicdata.E_ENAME %></td>
          <td class="td09">7. 주민등록번호</td>
          <td class="td11">&nbsp;<%= DataUtil.addSeparate(publicdata.E_REGNO) %></td>
        </tr>
        <tr>
          <td class="td09">8. 주소</td>
          <td class="td11" colspan="3">&nbsp;<%= publicdata.E_STRAS + " " + publicdata.E_LOCAT %></td>
        </tr>       
      </table>
      <table width="650" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
        <tr>               
          <td colspan="2" class="td09">9. 귀속년도</td>                
          <td colspan="2" class="td11">&nbsp;<%= E_PERIOD %></td>              
          <td class="td09">10. 감면기간</td>
          <td colspan="2" class="td11">&nbsp;&nbsp;&nbsp;&nbsp;..&nbsp;&nbsp;&nbsp;부터 &nbsp;&nbsp;&nbsp;..&nbsp;&nbsp;&nbsp; 까지</td>                
        </tr>
        <tr>               
          <td width="20" rowspan="8"  class="td09" align="center">근<br>무<br>처<br>벌<br>소<br>득<br>명<br>세</td>              
          <td width="175" class="td09">구분</td>
          <td width="95" align="right" class="td09">주(현)&nbsp;</td>
          <td width="100" align="right" class="td09">종(전)&nbsp;</td>
          <td width="85" align="right" class="td09">종(전)&nbsp;</td>
          <td width="85" align="right" class="td09">납세조항&nbsp;</td>
          <td width="90" align="right" class="td09">합계&nbsp;</td>
        </tr>
        <tr>               
          <td class="td09">11. 근무처명</td>
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.COM01 == null ? "" : dataPre.COM01 %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.COM02 == null ? "" : dataPre.COM02 %>&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
        </tr>
        <tr>                 
          <td class="td09">12. 사업자등록번호</td>                
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.BUS01 == null ? "" : dataPre.BUS01 %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.BUS02 == null ? "" : dataPre.BUS02 %>&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
        </tr>
<%
// 주(현) 급여액, 상여액, 인정상여액
   double l_sal01 = data._급여총액 - (Double.parseDouble(dataPre.SAL01 == null ? "0" : dataPre.SAL01) + Double.parseDouble(dataPre.SAL02 == null ? "0" : dataPre.SAL02));
   double l_bon01 = data._상여총액 - (Double.parseDouble(dataPre.BON01 == null ? "0" : dataPre.BON01) + Double.parseDouble(dataPre.BON02 == null ? "0" : dataPre.BON02));
   double l_abn01 = data._인정상여 - (Double.parseDouble(dataPre.ABN01 == null ? "0" : dataPre.ABN01) + Double.parseDouble(dataPre.ABN02 == null ? "0" : dataPre.ABN02));
   //CSR ID:1457577
   double l_stk01 = data._주식매수선택권행사이익 - (Double.parseDouble(dataPre.STK01 == null ? "0" : dataPre.STK01) + Double.parseDouble(dataPre.STK02 == null ? "0" : dataPre.STK02));
   
//  종전근무지의 스톡 옵션
// 주(현), 종(전), 종(전)2 급여+상여+인정상여
    double l_hap01 = l_sal01 + l_bon01 + l_abn01+l_stk01;
    double l_hap02 = Double.parseDouble(dataPre.SAL01 == null ? "0" : dataPre.SAL01) + Double.parseDouble(dataPre.BON01 == null ? "0" : dataPre.BON01) + Double.parseDouble(dataPre.ABN01 == null ? "0" : dataPre.ABN01) + Double.parseDouble(dataPre.STK01 == null ? "0" : dataPre.STK01);
    double l_hap03 = Double.parseDouble(dataPre.SAL02 == null ? "0" : dataPre.SAL02) + Double.parseDouble(dataPre.BON02 == null ? "0" : dataPre.BON02) + Double.parseDouble(dataPre.ABN02 == null ? "0" : dataPre.ABN02) + Double.parseDouble(dataPre.STK02 == null ? "0" : dataPre.STK02);
    double l_hap04 = data._급여총액 + data._상여총액 + data._인정상여+data._주식매수선택권행사이익 ;
%>
        <tr>               
          <td class="td09">13. 급여</td>                
          <td align="right" class="td11"><%= WebUtil.printNumFormat(l_sal01) %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.SAL01 == null ? "" : WebUtil.printNumFormat(dataPre.SAL01) %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.SAL02 == null ? "" : WebUtil.printNumFormat(dataPre.SAL02) %>&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(data._급여총액) %>&nbsp;</td>
        </tr>
        <tr>               
          <td class="td09">14. 상여</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(l_bon01) %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.BON01 == null ? "" : WebUtil.printNumFormat(dataPre.BON01) %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.BON02 == null ? "" : WebUtil.printNumFormat(dataPre.BON02) %>&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(data._상여총액) %>&nbsp;</td>             
        </tr>
        <tr>               
          <td class="td09">15. 인정상여</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(l_abn01) %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.ABN01 == null ? "" : WebUtil.printNumFormat(dataPre.ABN01) %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.ABN02 == null ? "" : WebUtil.printNumFormat(dataPre.ABN02) %>&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(data._인정상여) %>&nbsp;</td>             
        </tr>
        <tr>   <!--CSR ID:1457577-->            
          <td class="td09">15-1. 주식매수선택권행사이익</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(l_stk01) %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.STK01 == null ? "" : WebUtil.printNumFormat(dataPre.STK01) %>&nbsp;</td>
          <td align="right" class="td11"><%= dataPre.STK02 == null ? "" : WebUtil.printNumFormat(dataPre.STK02) %>&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(data._주식매수선택권행사이익) %>&nbsp;</td>             
        </tr>        
        <tr>               
          <td class="td09">16. 계</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(l_hap01) %>&nbsp;</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(l_hap02) %>&nbsp;</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(l_hap03) %>&nbsp;</td>
          <td align="right" class="td11">&nbsp;</td>
          <td align="right" class="td11"><%= WebUtil.printNumFormat(l_hap04) %>&nbsp;</td>             
        </tr>
      </table>
      <table width="650" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
       <tr> 
          <td width="92" class="td09" align="center" rowspan="2" >비과세소득</td>               
          <td width="105" class="td09">17. 국외근로</td>
          <td width="115" class="td09">18. 야간근로수당</td>
          <td width="113" class="td09">18-1. 외국인근로자</td>
          <td width="110" class="td09">19. 기타비과세</td>
          <td width="115" class="td09">20. 계(17+18+19) </td>
       </tr>
       <tr>
          <td class="td11" align="center"><%= WebUtil.printNumFormat(data._비과세소득_국외근로) %>&nbsp;</td>
          <td class="td11" align="center"><%= WebUtil.printNumFormat(data._비과세소득_야간근로수당) %>&nbsp;</td>
          <td class="td11" align="center"><%= WebUtil.printNumFormat(data._비과세소득_외국인근로자) %>&nbsp;</td>
          <td class="td11" align="center"><%= WebUtil.printNumFormat(data._비과세소득_기타비과세) %>&nbsp;</td>
          <td class="td11" align="center"><%= WebUtil.printNumFormat(data._비과세소득_합계) %>&nbsp;</td>
       </tr>
      </table>
      
      
      <table width="650" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
       <tr> 
          <td class="td09" width="20" rowspan="24" align="center">정<br><br><br><br><br><br><br><br>산<br><br><br><br><br><br><br><br>명<br><br><br><br><br><br><br><br>세</td>                
          <td class="td09" colspan="3">21. 총급여17</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._총급여) %>&nbsp;</td>
          <td class="td09" width="23" align="center" rowspan="8">조<br>특<br>소<br>득<br>고<br>제</td>              
          <td class="td09">43. 개인연금저축소득공제</td>               
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._개인연금저축소득공제) %>&nbsp;</td>                
       </tr>
       <tr>                 
          <td colspan="3" class="td09">22. 근로소득공제</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._근로소득공제) %>&nbsp;</td>          
          <td class="td09">44. 연금저축소득공제</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._연금저축소득공제) %>&nbsp;</td>
       </tr>
       <tr>                 
          <td colspan="3" class="td09">23. 근로 소득금액 </td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._근로소득금액) %>&nbsp;</td>          
        
          <td class="td09">44-1. 주택마련저축소득공제</td><!--CSR ID:1457577-->
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._주택마련저축소득공제) %>&nbsp;</td>    
       </tr>
       <tr> 
          <td rowspan="20" align="center" class="td09" width="20">종<br> 합<br> 소<br> 득<br> 공<br> 제</td> 
          <td rowspan="3" align="center" class="td09" width="25">기<br> 본<br> 공<br> 제</td> 
          <td class="td09" width="210">24. 본인</td>
          <td class="td11" width="95" align="right"><%= WebUtil.printNumFormat(data._기본공제_본인) %>&nbsp;</td>
      
          <td class="td09" width="160">45. 투자조합출자등소득공제</td>
          <td class="td11" width="95" align="right"><%= WebUtil.printNumFormat(data._투자조합출자등소득공제) %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">25. 배우자</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._기본공제_배우자) %>&nbsp;</td>
          
          <td class="td09">46. 신용카드등 소득공제</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._신용카드공제) %>&nbsp;</td>   
       </tr>
       <tr> 
          <td class="td09">26. 부양가족</td>               
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._기본공제_부양가족) %>&nbsp;</td>
       
          <td class="td09">47. 우리사주조합 소득공제</td>
          <td class="td11" align="right" ><%= "" %>&nbsp;</td>  
       </tr>
       <tr> 
          <td rowspan="5" align="center" class="td09">추<br> 가<br> 공<br> 제</td>               
          <td class="td09">27. 경로우대</td>               
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._추가공제_경로우대) %>&nbsp;</td>
        
          <td class="td09">48. 장기주식형저축소득공제</td>               
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._장기주식형저축소득공제) %>&nbsp;</td>   
       </tr>
       <tr> 
          <td class="td09">28. 장애인</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._추가공제_장애인) %>&nbsp;</td>
       
          <td class="td09">49. 조특소득공제 계</td>         
          <td class="td11" align="right"><%= "" %><%= WebUtil.printNumFormat(data._그밖의소득공제계) %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">29. 부녀자</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._추가공제_부녀자) %>&nbsp;</td>           
          <td colspan="2" class="td09">50. 종합소득과세표준</td>               
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._종합소득과세표준) %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">30. 자녀양육비</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._추가공제_자녀양육비) %>&nbsp;</td>     
          <td class="td09" colspan="2">51. 산출세액</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._산출세액) %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">30-1. 출산.입양자</td>  <!-CSR ID:1457577-->              
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._추가공제_출산입양자) %>&nbsp;</td>             
          <td rowspan="4" align="center" class="td09">세<br> 액<br> 감<br> 면</td>                                  
          <td class="td09">52. 소득세법</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._세액감면_소득세법정산) %>&nbsp;</td>
       </tr>       
       <tr> 
          <td colspan="2" class="td09">31. 다자녀추가공제</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._소수공제자추가공제) %>&nbsp;</td>                
          <td class="td09">53. 조세특례제한법</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._세액감면_조세특례제한법) %>&nbsp;</td>
       </tr>
       <tr> 
          <td colspan="2" class="td09">32. 연금보험료공제</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._연금보험료공제) %>&nbsp;</td>                
          <td class="td09">54. </td>
          <td class="td11" align="right">&nbsp;</td>
       </tr>
       <tr> 
          <td rowspan="10" align="center" class="td09">특<br> 별<br> 공<br> 제</td>                
          <td class="td09">33. 보험료</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_보험료) %>&nbsp;</td>                
          <td class="td09">55. 감면세액계</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._세액감면_감면세액계) %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">34. 의료비</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_의료비) %>&nbsp;</td>                
          <td rowspan="09" align="center" class="td09">세<br> 액<br> 공<br> 제</td>                
          <td class="td09">56. 근로소득</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._세액공제_근로소득) %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">35. 교육비</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_교육비) %>&nbsp;</td>                
          <td class="td09">57. 납세조합공제</td>                
          <td class="td11" align="right"><%= "" %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">36. 주택자금</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_주택자금) %>&nbsp;</td>                
          <td class="td09">58. 주택차입금</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._세액공제_주택차입금) %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">36-1.주택임차차입금원리금상환액</td><!-CSR ID:1457577-->         
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_주택임차차입금원리금상환액) %>&nbsp;</td>              
          <td class="td09">59. 외국납부</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._세액공제_외국납부) %>&nbsp;</td>   
       </tr>
       <tr> 
          <td class="td09">36-2.장기주택저당차입금이자상환액</td><!-CSR ID:1457577-->              
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_장기주택저당차입금이자상환액) %>&nbsp;</td>             
          <td class="td09">60. 기부 정치자금</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._세액공제_기부정치자금) %>&nbsp;</td>
       </tr>              
       <tr> 
          <td class="td09">37. 기부금</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_기부금) %>&nbsp;</td>               
          <td class="td09">61. </td>                
          <td class="td11" align="right">&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">38. 혼인이사장례비</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_혼인이사장례비) %>&nbsp;</td>                   
          <td class="td09">&nbsp;</td>                
          <td class="td11" align="right">&nbsp;</td>
       </tr>
       <!--
       <tr>                 
          <td class="td09">39. </td>                
          <td class="td11" align="right">&nbsp;</td>                
          <td class="td09">61. </td>                
          <td class="td11" align="right">&nbsp;</td>
       </tr>-->
       <tr> 
          <td class="td09">40. 계</td>               
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._특별공제_계) %>&nbsp;</td>
                        
          <td class="td09">62. </td>                
          <td class="td11" align="right">&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09">41. 표준공제</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._표준공제) %>&nbsp;</td>
                         
          <td class="td09">63. 세액공제계</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._세액공제_세액공제계) %>&nbsp;</td>
       </tr>
       <tr> 
          <td class="td09" colspan="3">42. 차감소득금액</td> 
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._차감소득금액) %>&nbsp;</td>
          
          <td class="td09" colspan="2"><b>결정세액 51-55-63. </b></td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._결정세액_갑근세) %>&nbsp;</td>
       </tr>
      </table>
    
	    
	    
      <table width="650" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
       <tr>                
          <td class="td09" width="20" rowspan="5" align="center">세<br>액<br>명<br>세</td>                
          <td class="td09" colspan="2" align="center">구분</td>                
          <td class="td09" align="center">소득세</td>               
          <td class="td09" align="center">주민세</td>                
          <td class="td09" align="center">농어촌특별세</td>                
          <td class="td09" align="center">계</td>
        </tr>
        <tr>
          <td class="td09" colspan="2">64. 결정세액</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._결정세액_갑근세) %>&nbsp;</td>      
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._결정세액_주민세) %>&nbsp;</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._결정세액_농특세) %>&nbsp;</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._결정세액_합계) %>&nbsp;</td>                
        </tr>
        <tr>
          <td class="td09" width="45" rowspan="2" align="center">기납부<br>세 &nbsp;액</td> 
          <td class="td09" width="115">65. 종(전)근무지</td>
          <td class="td11" width="117" align="right"><%= WebUtil.printNumFormat(data._종전_소득세) %>&nbsp;</td>
          <td class="td11" width="117" align="right"><%= WebUtil.printNumFormat(data._종전_주민세) %>&nbsp;</td>
          <td class="td11" width="118" align="right"><%= "" %>&nbsp;</td>
          <td class="td11" width="118" align="right"><%= WebUtil.printNumFormat(data._종전_합계) %>&nbsp;</td>  
        </tr>
        <tr>
          <td class="td09">66. 주(현)근무지</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._기납부세액_갑근세) %>&nbsp;</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._기납부세액_주민세) %>&nbsp;</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._기납부세액_농특세) %>&nbsp;</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._기납부세액_합계) %>&nbsp;</td>
        </tr>
        <tr>
          <td class="td09" colspan="2">67. 차감징수세액</td>                
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._차감징수세액_갑근세) %>&nbsp;</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._차감징수세액_주민세) %>&nbsp;</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._차감징수세액_농특세) %>&nbsp;</td>
          <td class="td11" align="right"><%= WebUtil.printNumFormat(data._차감징수세액_합계) %>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="7" class="td09">
			      <table border="0" cellpadding="0" align="right" cellspacing="0" width="100%">
			        <tr>
			          <td>
					        <table border="0" align="right" cellpadding="0" cellspacing="0" width="100%">
					          <tr>
          					  <td width="30" height="70" class="td11">&nbsp;</td>
          					  <td width="120" height="70" class="td11">
          					  건강보험 : <%= WebUtil.printNumFormat(data._건강보험) %><br>
          					  고용보험 : <%= WebUtil.printNumFormat(data._고용보험) %></td>
          					  <td width="500" height="20" align="center" class="td11">
          					    <table border="0" width="100%">
          					      <tr height="20">
          					        <td class="td11" nowrap width="300">위의 원천징수액(근로소득)을 정히 영수 (지급)합니다.</td>
          					        <!--<td class="td11" valign=center  width="80" rowspan="4" style="background:url(<%= WebUtil.ImageURL %>doDojang.gif) no-repeat;text-align: center; 100% 100%">(서명 또는 인)</td>-->
          					        <td width="200">&nbsp;</td>
          					      </tr>
          					    </table>
          					    <table border="0" width="100%">
          					      <tr height="30">
          					        <td class="td11" width="240">
          					          　　　　　　　　<%= E_PERIOD.substring(0,4) %>&nbsp;년&nbsp;&nbsp;12&nbsp;월&nbsp;&nbsp;31&nbsp;일
          					        </td>
          					        <td class="td11" width="100" rowspan="3" style="background:url(<%= WebUtil.ImageURL %>doDojang.jpg) no-repeat 0% 0%;background-position: center;">(서명 또는 인)</td>
          					        <td width="160">&nbsp;</td>
          					      </tr>
          					      <tr height="20">
          					        <td class="td11">
          					          　징수(보고) 의무자 <%= dataBus.NAME %> &nbsp;<%= dataBus.KR_REPRES %>
          					        </td>
          					      </tr>
          					      <tr height="20">
          					        <td class="td11">
          					          　　　　　　　　　　<%= publicdata.E_ENAME %> &nbsp;&nbsp;귀하
          					        </td>
          					      </tr>
          					    </table>
          					  </td>
          				  </tr>
          			  </table>
          			</td>
          	  </tr>
			      </table>
          </td>
        </tr>
        <tr>
          <td colspan="7" height="120" class="td11">
          1. 거주지국고하 거주지국코드는 외국민에 해당하는 경우에 한하여기재하며, 국제표준화기구(ISO) 가 정한<br> &nbsp;&nbsp;&nbsp;&nbsp;ISO코드 중 국명약어 및 국가코드를 기재합니다.<br>
          2. 원천징수의무자는 지금일이 속하는 연도의 다음 년도 2월말일휴업 또는 폐업한 경우에는 휴업일또는 폐업일이<br> &nbsp;&nbsp;&nbsp;&nbsp;속하는 달의 다음 다음달 말일)까지 기급조서를 제출해야 합니다.<br>
          3. 갑종근로소득과 을종근로소득을 합산하여 연말정산시 납세조합란에 을근로납세조합과 을종근로소득을 가재하고,<br> &nbsp;&nbsp;&nbsp;&nbsp;57.납세조합공제란을 기재합니다.<br>
          4. 종합소득 특별공제(33 ~ 38) 과 조세특례제한법상의 소득공제(43 ~ 47) 는 제 37호 서식의 공제액을 기재합니다.<br>
          5. 67,차감징수세액이 소액부징수에 해당하는 경우 &quot;0&quot;으로 기재합니다.</td>
        </tr>
       </table>
    </td>
  </tr>
</table>
<table width="640" border="0" cellspacing="0" cellpadding="0" align="center" style="background:url(<%= WebUtil.JspURL %>A/A15Certi/bg_lg_logo.gif) no-repeat 50% 50%">
  <tr>
    <td class="font01">
      <b>※ 본 서류는 외부기관 제출용 증빙서류로서, 당사의 On-Line 인사 시스템을 통해 발급되었습니다.</b>
    </td>
  </tr>
</table>  
</form>
<%@ include file="/web/common/commonEnd.jsp" %>