<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.E.E17Hospital.*" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>LG MMA</title>
<!-- basic -->
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_jquery.css" />
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-1.9.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-ui-1.10.0.js"></script>
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
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04" rowspan="12"><b>보험비급여</b></td>
            <td class="td04"><b>식 대</b></td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04"><b>지정 진료비</b></td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04"><b>입원료</b></td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>                                                        
          <tr>                                                         
            <td class="td04"><b>C T</b></td>                           
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>                                                        
          <tr>                                                         
            <td class="td04"><b>MRI</b></td>                           
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>                                                       
          <tr>                                                        
            <td class="td04"><b>초음파</b></td>                       
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>                                                       
          <tr> 
            <td class="td04">&nbsp;</td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04">&nbsp;</td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04">&nbsp;</td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04">&nbsp;</td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04">&nbsp;</td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04"><b>소 계 ②</b></td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04" colspan="2"><b>할인금액 ③</b></td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04" colspan="2"><b>본인 부담금 총액 ① + ② - ③</b></td>
            <td class="td02" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="td04"><b>납부확인</b></td>
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
</body>
</html>