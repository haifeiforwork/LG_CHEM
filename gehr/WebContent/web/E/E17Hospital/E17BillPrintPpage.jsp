<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E17Hospital.*" %>

<%
    E17BillData e17BillData = (E17BillData)request.getAttribute("e17BillData");
    
//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e17BillData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다

    String s1_money = "";
    String s2_money = "";
    String s_money  = "";

    double t1_money = Double.parseDouble(e17BillData.TOTL_WONX) - Double.parseDouble(e17BillData.ASSO_WONX) ;
    double t2_money = Double.parseDouble(e17BillData.MEAL_WONX) +
                      Double.parseDouble(e17BillData.APNT_WONX) +
                      Double.parseDouble(e17BillData.ROOM_WONX) +
                      Double.parseDouble(e17BillData.CTXX_WONX) +
                      Double.parseDouble(e17BillData.MRIX_WONX) +
                      Double.parseDouble(e17BillData.SWAV_WONX) +
                      Double.parseDouble(e17BillData.ETC1_WONX) +
                      Double.parseDouble(e17BillData.ETC2_WONX) +
                      Double.parseDouble(e17BillData.ETC3_WONX) +
                      Double.parseDouble(e17BillData.ETC4_WONX) +
                      Double.parseDouble(e17BillData.ETC5_WONX);
    double t_money =  t1_money + t2_money - Double.parseDouble(e17BillData.DISC_WONX);

    s1_money =  WebUtil.printNumFormat(t1_money).equals("0") ? "" : WebUtil.printNumFormat(t1_money, currencyValue);
    s2_money =  WebUtil.printNumFormat(t2_money).equals("0") ? "" : WebUtil.printNumFormat(t2_money, currencyValue);
    s_money  =  WebUtil.printNumFormat(t_money).equals("0")  ? "" : WebUtil.printNumFormat(t_money,  currencyValue);
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript"> 
            function f_print(){
                self.print();
                }
        </SCRIPT> 
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table width="620" border="0" cellspacing="1" cellpadding="2" align="center">
    <tr> 
      <td width="810" align="center"> <font size="5" face="굴림, 굴림체"><u>진료비 계산서</u></font></td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810"> 
        <table width="620" border="1" cellspacing="0" cellpadding="4" bordercolor="#000000">
          <tr> 
            <td class="td04" width="90"><b>수진자성명</b></td>
            <td class="td04" width="100">&nbsp;</td>
            <td class="td04" width="100"><b>주민등록번호</b></td>
            <td class="td04" width="150">&nbsp;</td>
            <td class="td04" width="80"><b>병력번호</b></td>
            <td class="td04" width="100">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04" colspan="2" rowspan="2"><b>적용구분</b> </td>
            <td class="td04" colspan="2"> 
              <input type="checkbox" name="checkbox" value="checkbox">
              보 험</td>
            <td class="td04" colspan="2"> 
              <input type="checkbox" name="checkbox2" value="checkbox">
              일 반 </td>
          </tr>
          <tr> 
            <td class="td04">일 부</td>
            <td class="td04">전 액(초과,기타)</td>
            <td class="td04" colspan="2">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810"> 
        <table width="620" border="1" cellspacing="0" cellpadding="4" bordercolor="#000000">
          <tr> 
            <td rowspan="2" class="td04" width="100"><b>보험급여</b></td>
            <td class="td04" width="160"><b>본인 부담금 ①</b></td>
            <td class="td04" width="180"><b>조합 부담금</b></td>
            <td class="td04" width="180"><b>총 진료비</b></td>
          </tr>
          <tr> 
            <td class="td04"><%= s1_money %>&nbsp;</td>
            <td class="td04"><%= WebUtil.printNumFormat(e17BillData.ASSO_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ASSO_WONX, currencyValue) %>&nbsp;</td>
            <td class="td04"><%= WebUtil.printNumFormat(e17BillData.TOTL_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.TOTL_WONX, currencyValue) %>&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04" rowspan="12"><b>보험비급여</b></td>
            <td class="td04"><b>식 대</b></td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.MEAL_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.MEAL_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04"><b>지정 진료비</b></td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.APNT_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.APNT_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04"><b>상급병실료차액</b></td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.ROOM_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ROOM_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>                                                        
          <tr>                                                         
            <td class="td04"><b>C T</b></td>                           
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.CTXX_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.CTXX_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>                                                        
          <tr>                                                         
            <td class="td04"><b>MRI</b></td>                           
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.MRIX_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.MRIX_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>                                                       
          <tr>                                                        
            <td class="td04"><b>초음파</b></td>                       
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.SWAV_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.SWAV_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>                                                       
          <tr> 
            <td class="td04"><%= e17BillData.ETC1_TEXT %>&nbsp;</td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.ETC1_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC1_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04"><%= e17BillData.ETC2_TEXT %>&nbsp;</td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.ETC2_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC2_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04"><%= e17BillData.ETC3_TEXT %>&nbsp;</td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.ETC3_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC3_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04"><%= e17BillData.ETC4_TEXT %>&nbsp;</td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.ETC4_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC4_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04"><%= e17BillData.ETC5_TEXT %>&nbsp;</td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.ETC5_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC5_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04"><b>소 계 ②</b></td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= s2_money %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04" colspan="2"><b>할인금액 ③</b></td>
            <td class="td02" colspan="2">
              <table width="110" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= WebUtil.printNumFormat(e17BillData.DISC_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.DISC_WONX, currencyValue) %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04" colspan="2"><b>본인 부담금 총액 ① + ② - ③</b></td>
            <td class="td02" colspan="2">
              <table width="143" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td05"><%= s_money %>&nbsp;&nbsp;<%= e17BillData.WAERS %></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class="td04" width="90"><b>납부확인</b></td>
            <td class="td04" colspan="3"> 
              <table width="510" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="td04" width="80">(의료기관명)</td>
                  <td class="td04" width="240">&nbsp;</td>
                  <td class="td04" width="80">(담당자)</td>
                  <td class="td04" width="80">&nbsp;</td>
                  <td class="td04" width="30">(인)</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="810" class="td02">
        ※ 전산발행된 종합병원 영수증 등 영수증상으로 세부내역을 확인할 수 있는 경우는 작성하지 않음
      </td>
    </tr>
    <tr> 
      <td width="810">&nbsp;</td>
    </tr>
    <tr> 
      <td width="810" class="font01">[진료비계산서 지원 제외대상]</td>
    </tr>
    <tr>
      <td width="810">
        <table width="620" border="1" cellspacing="0" cellpadding="4" bordercolor="#000000" class="td02">
          <tr> 
            <ul>
              <td>
                <li>산재, 자동차 사고, 제3자의 가해행위 등</li>
                <li>업무나 일상생활에 지장이 없는 치료 및 수술<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;(성형, 예방접종, 건강진단 등)</li>
                <li>치과의 경우 미용목적의 부정교합의 교정, 스켈링 등</li>
                <li>한의원의 경우 건강보험 비급여 대상의 투약, 건강증진을 위한 보약</li>
                <li>약국의 경우 의사처방전에 근거하지 않은 단순투약, 영양제 복용 등</li>
                <li>단순 피로 및 권태</li>
                <li>보조기, 보청기, 의수, 족, 의안, 콘택트 렌즈 등의 재료비</li>
                <li>마약중독 등 향정신성 의약품 중독증</li>
                <li>친자확인을 위한 진단 등</li>
              </td>
            </ul>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
