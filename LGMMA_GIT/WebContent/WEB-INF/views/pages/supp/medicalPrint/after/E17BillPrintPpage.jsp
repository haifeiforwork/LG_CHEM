<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>

<%
    E17BillData e17BillData = (E17BillData)request.getAttribute("e17BillData");
    
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

    s1_money =  WebUtil.printNumFormat(t1_money).equals("0") ? "" : WebUtil.printNumFormat(t1_money);
    s2_money =  WebUtil.printNumFormat(t2_money).equals("0") ? "" : WebUtil.printNumFormat(t2_money);
    s_money  =  WebUtil.printNumFormat(t_money).equals("0")  ? "" : WebUtil.printNumFormat(t_money);
%>
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

<body>
<div class="printForm">
<form name="form1" method="post" action="">
<div class="printTitle">진료비 계산서</div>
<table class="printTB">
  <tr> 
    <th width="15%" class="bold">수진자성명</th>
    <td width="18%" >&nbsp;</td>
    <th width="15%" class="bold">주민등록번호</th>
    <td width="18%" >&nbsp;</td>
    <th width="15%" class="bold">병력번호</th>
    <td width="19%" >&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" rowspan="2" class="txtcenter bold">적용구분 </td>
    <td colspan="2"> 
      <input type="checkbox" name="checkbox" value="checkbox">
      보 험</td>
    <td colspan="2"> 
      <input type="checkbox" name="checkbox2" value="checkbox">
      일 반 </td>
  </tr>
  <tr> 
    <td>일 부</td>
    <td>전 액(초과,기타)</td>
    <td colspan="2">&nbsp;</td>
  </tr>
</table>
<table class="printTB mb0">
  <tr> 
    <th rowspan="2" width="15%" class="bold">보험급여</th>
    <td width="18%" class="bold">본인 부담금 ①</td>
    <td width="33%" class="bold">조합 부담금</td>
    <td width="33%" class="bold">총 진료비</td>
  </tr>
  <tr> 
    <td><%= s1_money %>&nbsp;</td>
    <td><%= WebUtil.printNumFormat(e17BillData.ASSO_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ASSO_WONX) %>&nbsp;</td>
    <td><%= WebUtil.printNumFormat(e17BillData.TOTL_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.TOTL_WONX) %>&nbsp;</td>
  </tr>
  <tr> 
    <th rowspan="12" class="bold">보험비급여</th>
    <td class="bold">식 대</td>
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.MEAL_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.MEAL_WONX) %>
    </td>
  </tr>
  <tr> 
    <td class="bold">지정 진료비</td>
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.APNT_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.APNT_WONX) %>
    </td>
  </tr>
  <tr> 
    <td class="bold">입원료</td>
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.ROOM_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ROOM_WONX) %>
    </td>
  </tr>                                                        
  <tr>                                                         
    <td class="bold">C T</td>                           
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.CTXX_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.CTXX_WONX) %>
    </td>
  </tr>                                                        
  <tr>                                                         
    <td class="bold">MRI</td>                           
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.MRIX_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.MRIX_WONX) %>
    </td>
  </tr>                                                       
  <tr>                                                        
    <td class="bold">초음파</td>                       
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.SWAV_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.SWAV_WONX) %>
    </td>
  </tr>                                                       
  <tr> 
    <td class="bold"><%= e17BillData.ETC1_TEXT %>&nbsp;</td>
    <td colspan="2">
     <%= WebUtil.printNumFormat(e17BillData.ETC1_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC1_WONX) %>
    </td>
  </tr>
  <tr> 
    <td class="bold"><%= e17BillData.ETC2_TEXT %>&nbsp;</td>
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.ETC2_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC2_WONX) %>
    </td>
  </tr>
  <tr> 
    <td class="bold"><%= e17BillData.ETC3_TEXT %>&nbsp;</td>
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.ETC3_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC3_WONX) %>
    </td>
  </tr>
  <tr> 
    <td class="bold"><%= e17BillData.ETC4_TEXT %>&nbsp;</td>
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.ETC4_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC4_WONX) %>
    </td>
  </tr>
  <tr> 
    <td class="bold"><%= e17BillData.ETC5_TEXT %>&nbsp;</td>
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.ETC5_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC5_WONX) %>
    </td>
  </tr>
  <tr> 
    <td class="bold">소 계 ②</td>
    <td colspan="2">
      <%= s2_money %>
    </td>
  </tr>
  <tr> 
    <td colspan="2" class="bold">할인금액 ③</td>
    <td colspan="2">
      <%= WebUtil.printNumFormat(e17BillData.DISC_WONX).equals("0") ? "" : WebUtil.printNumFormat(e17BillData.DISC_WONX) %>
    </td>
  </tr>
  <tr> 
    <td colspan="2" class="bold">본인 부담금 총액 ① + ② - ③</td>
    <td colspan="2">
      <%= s_money %>&nbsp;&nbsp;<%= e17BillData.WAERS %>
    </td>
  </tr>
  <tr> 
    <td colspan="2" class="bold">납부확인</td>
    <td colspan="2"> 
      <table class="printTBIN">
        <tr> 
          <td>(의료기관명)</td>
          <td class="txtright">(담당자)</td>
          <td width="100px">&nbsp;</td>
          <td class="txtright">(인)</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<div class="txtEtc mb20">※ 전산발행된 종합병원 영수증 등 영수증상으로 세부내역을 확인할 수 있는 경우는 작성하지 않음</div>
<div class="tableTitle">[진료비계산서 지원 제외대상]</div>
 <div class="listDot">
	<ul>             
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
	</ul>        
</div>
</form>
</div>
</body>
</html>
