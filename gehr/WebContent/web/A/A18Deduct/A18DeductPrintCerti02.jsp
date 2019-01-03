<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.A.A18Deduct.*" %>
<%@ page import="hris.common.*" %>

<%
    
    A18DeductData         dataA18            = (A18DeductData)request.getAttribute("dataA18");
    PersonData publicdata  = (PersonData)request.getAttribute("publicdata");
    A18CertiPrintBusiData dataBus            = (A18CertiPrintBusiData)request.getAttribute("dataBus");
    Vector                A18CertiPrint02_vt = (Vector)request.getAttribute("A18CertiPrint02_vt");
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
</SCRIPT> 
<style type="text/css">
.font02 {  font-family: "굴림", "굴림체"; font-size: 10pt; background-color: #FFFFFF; color: #333333}
.font03 {  font-family: "굴림", "굴림체"; font-size: 19pt; background-color: #FFFFFF; color: #333333}
.font04 {  font-family: "굴림", "굴림체"; font-size: 12pt; background-color: #FFFFFF; color: #333333}

</style>
</head>

<body class="td02" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="//setDefault();//f_print();">
<form name="form1" method="post" action="">
<br><br>
<table width="650" border="1" bordercolordark="white" bordercolorlight="#000000" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <table width="650" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="100" valign="top">
            <table width="100" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
              <tr>
                <td class="td02" align="center">발급번호</td>
              </tr>
              <tr>
                <td class="td02" align="center">&nbsp;<%= dataA18.PUBLIC_NUM %>&nbsp;</td>
              </tr>
            </table>
          </td>
          <td width="450" align="center"> 
            <table width="450" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="center" class="font04"><b>갑종근로소득에 대한 소득세 원천징수증명서</b></td>
              </tr>
              <tr>
                <td><b>&nbsp;</b></td>
              </tr>
            </table>
          </td>
          <td width="100" align="right"> 
            <table width="100" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
              <tr> 
                <td class="td02" align="center">처리기간</td>
              </tr>
              <tr> 
                <td class="td02" align="center">즉　　시</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
<BR>
	    <table width="650" borderColorDark=white cellspacing="0" cellpadding="0" borderColorLight=#000000 border=1>
        <tr height="30"> 
          <td class="td06" width="20" rowspan="2" align="center">납<br>세<br>자</td>               
          <td class="td06" width="120">① 성명</td>
          <td class="td02"><%= publicdata.E_ENAME %></td>
          <td class="td06" colspan="2">② 주민등록번호</td>
          <td class="td02" colspan="2"><%= DataUtil.addSeparate(publicdata.E_REGNO) %></td>
        </tr>
        <tr height="30">
          <td class="td06">③ 주소 또는 거소</td>
          <td class="td02" colspan="5"><%= publicdata.E_STRAS + " " + publicdata.E_LOCAT %></td>
        </tr>       
        <tr height="30">               
          <td class="td06" align="center" rowspan="3">징<br>수<br>의<br>무<br>자</td>                
          <td class="td06">④ 상호또는명칭 </td>               
          <td class="td02"><%= dataBus.NAME %></td>               
          <td class="td06" colspan="2">⑤ 사업자등록번호</td>             
          <td class="td02" colspan="2"><%= dataBus.STCD2.substring(0,3) + "-" + dataBus.STCD2.substring(3,5) + "-" + dataBus.STCD2.substring(5,10) %></td>
        </tr>
        <tr height="30"> 
          <td class="td06">⑥ 사업장소재지</td>
          <td class="td02" colspan="3"><%= dataBus.ADDRESS_LINE %>&nbsp;</td>
          <td class="td02" colspan="2"><%= "☎ " + dataBus.PHONE_NUMBER %></td>
        </tr>
        <tr height="30"> 
          <td class="td06">⑦ 대표자</td>                
          <td class="td02"><%= dataBus.KR_REPRES %></td>                
          <td class="td06" colspan="2">⑧ 주민(법인) 등록번호</td>
          <td class="td02" colspan="2"><%= DataUtil.addSeparate(dataBus.STCD1) %></td>
        </tr>
        <tr height="30">               
          <td class="td06" colspan="2">⑨ 증명서의 사용목적</td>                
          <td class="td02" width="160"><%= dataA18.USE_PLACE %></td>               
          <td class="td06" width="70">⑩ 제출처</td>             
          <td class="td02" width="110"><%= dataA18.SUBMIT_PLACE %></td>
          <td class="td06" width="100">⑪ 소요수량</td>             
          <td class="td02" width="70" align="center"><%= dataA18.PRINT_NUM == null ? "" : WebUtil.printNumFormat(dataA18.PRINT_NUM) %></td>
        </tr>
      </table>
      <table width="650" borderColorDark=white cellspacing="0" cellpadding="0" bgColor=white borderColorLight=#000000 border=1>
        <tr height="30">               
          <td class="td06" width="73" align="center">연월</td>                
          <td class="td06" width="85" align="center">⑫ 급여액</td>                
          <td class="td06" width="82" align="center">⑬ 세액</td>                
          <td class="td06" width="95" align="center">⑭ 납부연월일</td>                
          <td class="td06" width="73" align="center">연월</td>                
          <td class="td06" width="85" align="center">급여액</td>                
          <td class="td06" width="82" align="center">세액</td>                
          <td class="td06" width="80" align="center">납부연월일</td>                
        </tr>
<%
    A18CertiPrint02Data data00 = new A18CertiPrint02Data();
    A18CertiPrint02Data data01 = new A18CertiPrint02Data();
    A18CertiPrint02Data data02 = new A18CertiPrint02Data();
    A18CertiPrint02Data data03 = new A18CertiPrint02Data();
    A18CertiPrint02Data data04 = new A18CertiPrint02Data();
    A18CertiPrint02Data data05 = new A18CertiPrint02Data();
    A18CertiPrint02Data data06 = new A18CertiPrint02Data();
    A18CertiPrint02Data data07 = new A18CertiPrint02Data();
    A18CertiPrint02Data data08 = new A18CertiPrint02Data();
    A18CertiPrint02Data data09 = new A18CertiPrint02Data();
    A18CertiPrint02Data data10 = new A18CertiPrint02Data();
    A18CertiPrint02Data data11 = new A18CertiPrint02Data();
    A18CertiPrint02Data data12 = new A18CertiPrint02Data();
    A18CertiPrint02Data data13 = new A18CertiPrint02Data();
    
    for( int i = 0 ; i < A18CertiPrint02_vt.size() ; i++ ) {
        if( i ==  0 ) {     data00 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }       // 오른쪽
        if( i ==  1 ) {     data01 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i ==  2 ) {     data02 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i ==  3 ) {     data03 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i ==  4 ) {     data04 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i ==  5 ) {     data05 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i ==  6 ) {     data06 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i ==  7 ) {     data07 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }        // 왼쪽
        if( i ==  8 ) {     data08 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i ==  9 ) {     data09 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i == 10 ) {     data10 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i == 11 ) {     data11 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i == 12 ) {     data12 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
        if( i == 13 ) {     data13 = (A18CertiPrint02Data)A18CertiPrint02_vt.get(i);     }
    }
%>
        <tr height="30">               
          <td class="td02"><%= data00.YYYYMM == null ? "&nbsp;" : data00.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data00.TOT_PAY == null || data00.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data00.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data00.TOT_TAX == null || data00.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data00.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data00.YYYYMMDD == null ? "&nbsp;" : data00.YYYYMMDD %>&nbsp;</td>                
          <td class="td02"><%= data07.YYYYMM == null ? "&nbsp;" : data07.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data07.TOT_PAY == null || data07.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data07.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data07.TOT_TAX == null || data07.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data07.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data07.YYYYMMDD == null ? "&nbsp;" : data07.YYYYMMDD %>&nbsp;</td>                
        </tr>
        <tr height="30">               
          <td class="td02"><%= data01.YYYYMM == null ? "&nbsp;" : data01.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data01.TOT_PAY == null || data01.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data01.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data01.TOT_TAX == null || data01.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data01.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data01.YYYYMMDD == null ? "&nbsp;" : data01.YYYYMMDD %>&nbsp;</td>                
          <td class="td02"><%= data08.YYYYMM == null ? "&nbsp;" : data08.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data08.TOT_PAY == null || data08.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data08.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data08.TOT_TAX == null || data08.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data08.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data08.YYYYMMDD == null ? "&nbsp;" : data08.YYYYMMDD %>&nbsp;</td>                
        </tr>
        <tr height="30">               
          <td class="td02"><%= data02.YYYYMM == null ? "&nbsp;" : data02.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data02.TOT_PAY == null || data02.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data02.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data02.TOT_TAX == null || data02.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data02.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data02.YYYYMMDD == null ? "&nbsp;" : data02.YYYYMMDD %>&nbsp;</td>                
          <td class="td02"><%= data09.YYYYMM == null ? "&nbsp;" : data09.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data09.TOT_PAY == null || data09.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data09.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data09.TOT_TAX == null || data09.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data09.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data09.YYYYMMDD == null ? "&nbsp;" : data09.YYYYMMDD %>&nbsp;</td>                
        </tr>
        <tr height="30">               
          <td class="td02"><%= data03.YYYYMM == null ? "&nbsp;" : data03.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data03.TOT_PAY == null || data03.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data03.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data03.TOT_TAX == null || data03.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data03.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data03.YYYYMMDD == null ? "&nbsp;" : data03.YYYYMMDD %>&nbsp;</td>                
          <td class="td02"><%= data10.YYYYMM == null ? "&nbsp;" : data10.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data10.TOT_PAY == null || data10.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data10.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data10.TOT_TAX == null || data10.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data10.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data10.YYYYMMDD == null ? "&nbsp;" : data10.YYYYMMDD %>&nbsp;</td>                
        </tr>
        <tr height="30">               
          <td class="td02"><%= data04.YYYYMM == null ? "&nbsp;" : data04.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data04.TOT_PAY == null || data04.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data04.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data04.TOT_TAX == null || data04.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data04.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data04.YYYYMMDD == null ? "&nbsp;" : data04.YYYYMMDD %>&nbsp;</td>                
          <td class="td02"><%= data11.YYYYMM == null ? "&nbsp;" : data11.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data11.TOT_PAY == null || data11.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data11.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data11.TOT_TAX == null || data11.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data11.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data11.YYYYMMDD == null ? "&nbsp;" : data11.YYYYMMDD %>&nbsp;</td>                
        </tr>
        <tr height="30">               
          <td class="td02"><%= data05.YYYYMM == null ? "&nbsp;" : data05.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data05.TOT_PAY == null || data05.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data05.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data05.TOT_TAX == null || data05.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data05.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data05.YYYYMMDD == null ? "&nbsp;" : data05.YYYYMMDD %>&nbsp;</td>                
          <td class="td02"><%= data12.YYYYMM == null ? "&nbsp;" : data12.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data12.TOT_PAY == null || data12.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data12.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data12.TOT_TAX == null || data12.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data12.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data12.YYYYMMDD == null ? "&nbsp;" : data12.YYYYMMDD %>&nbsp;</td>                
        </tr>
        <tr height="30">               
          <td class="td02"><%= data06.YYYYMM == null ? "&nbsp;" : data06.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data06.TOT_PAY == null || data06.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data06.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data06.TOT_TAX == null || data06.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data06.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data06.YYYYMMDD == null ? "&nbsp;" : data06.YYYYMMDD %>&nbsp;</td>                
          <td class="td02"><%= data13.YYYYMM == null ? "&nbsp;" : data13.YYYYMM   %>&nbsp;</td>                
          <td class="td02" align="right"><%= data13.TOT_PAY == null || data13.TOT_PAY.equals("") ? "" : WebUtil.printNumFormat(data13.TOT_PAY) %>&nbsp;</td>                
          <td class="td02" align="right"><%= data13.TOT_TAX == null || data13.TOT_TAX.equals("") ? "" : WebUtil.printNumFormat(data13.TOT_TAX) %>&nbsp;</td>                
          <td class="td02" align="center"><%= data13.YYYYMMDD == null ? "&nbsp;" : data13.YYYYMMDD %>&nbsp;</td>                
        </tr>
        <tr>               
          <td class="td02" colspan="8" height="110"><br><br><br>
            　　　　　　　　　　　　　　　　　<%= DataUtil.getCurrentDate().substring(0,4) + " 년　　" + DataUtil.getCurrentDate().substring(4,6) + " 월　　" + DataUtil.getCurrentDate().substring(6,8) + " 일" %><br><br>
            　　　　　　　　　　　　　　　　　　　　신　청　인　　　<%= publicdata.E_ENAME %>　　　(서명 또는 인)
          <br> </td>                
        </tr>
        <tr>               
          <td class="td02" colspan="8">
            <table width="100%" border="0">
              <tr>
                <td class="td02" colspan="4">
            　    위와 같이 원천징수 하였음을 증명합니다.
                </td>
              </tr>
              <tr>
                <td class="td02" colspan="4">&nbsp;</td>
              </tr>
              <tr>
                <td class="td02" colspan="4">
            　　　　　　　　　　　　　　　　<%= DataUtil.getCurrentDate().substring(0,4) + " 년　　" + DataUtil.getCurrentDate().substring(4,6) + " 월　　" + DataUtil.getCurrentDate().substring(6,8) + " 일" %>
                </td>
              </tr>
              <!--tr>
                <td class="td02" colspan="4">&nbsp;</td>
              </tr-->
              <tr>
                <td class="td02" colspan="4">
            　　　　　　　　　　　　　　　　　<%= dataBus.ADDRESS_LINE %>
                </td>
              </tr>
              <!--tr>
                <td class="td02" colspan="4">&nbsp;</td>
              </tr-->              
              <tr height="104">
                <td class="td02" width="200" style="text-align:center">
            　　　증명자(원천징수의무자)
                </td>
                <td class="font04" width="250" style="text-align:center">
                <b><%= dataBus.NAME %></b>
                </td>
                <td class="td02" width="90" style="background:url(<%= WebUtil.ImageURL %>doDojang.jpg) no-repeat 70% 70%">
                  (서명 또는 인)
                </td>
                <td class="td02" width="110">&nbsp;<br><br>  </td>
              </tr>
              <tr>
                <td class="td02" colspan="4">&nbsp;</td>
              </tr>
              <tr>
                <td class="td02" colspan="4">
            　　　　　　　　　　　　　　대　표　이　사　　사　장　　<%= dataBus.KR_REPRES %>
                <br></td>
              </tr>
              <tr>
                <td class="td02" colspan="4">&nbsp;</td>
              </tr>
              <tr>
                <td class="td02" colspan="4">&nbsp;</td>
              </tr>
            </table>
          </td>                
        </tr>

      </table>
    </td>
  </tr>
</table>
<table width="640" border="0" cellspacing="0" cellpadding="0" align="center" style="background:url(<%= WebUtil.JspURL %>A/A15Certi/bg_lg_logo.gif) no-repeat 50% 50%">
  <tr height=1><td class="font05">&nbsp;</td></tr>
  <tr>
    <td class="font01">
      <b>※ 본 서류는 외부기관 제출용 증빙서류로서, 당사의 On-Line 인사 시스템을 통해 발급되었습니다.</b>
    </td>
  </tr>
</table>  
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
