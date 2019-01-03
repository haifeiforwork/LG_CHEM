<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>
<%@ page import="hris.E.E18Hospital.*" %>
<%@ page import="hris.E.E18Hospital.rfc.*" %>
<%
	WebUserData user   = (WebUserData)session.getValue("user");
    E17SickData e17SickData        = (E17SickData)request.getAttribute("e17SickData");
    Vector      E17HospitalData_vt = (Vector)request.getAttribute("E17HospitalData_vt");
    String      BEGDA              = e17SickData.BEGDA ;
    String      YYYY               = null;
    String      MM                 = null;
    String      DD                 = null;
    
    if(BEGDA!= null && BEGDA.equals("") && BEGDA.equals("0000-00-00") ){
        YYYY = "";
        MM   = "";
        DD   = "";
    }else{
        YYYY = BEGDA.substring(0,4);
        MM   = BEGDA.substring(5,7);
        DD   = BEGDA.substring(8,10);
    }

//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e17SickData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다

//  본인부담금 총액을 구한다.
    double EMPL_WONX_tot = 0.0;
    for( int i = 0 ; i < E17HospitalData_vt.size() ; i++ ){
        E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
        EMPL_WONX_tot = EMPL_WONX_tot + Double.parseDouble(e17HospitalData.EMPL_WONX);
    }

// 동일진료시 최초 신청날짜 구하기 (2005.07.05)
    E18HospitalListRFC func_E18           = new E18HospitalListRFC();
    Vector             E18HospitalData_vt = new Vector();
    String             l_CTRL_NUMB        = "";
    String             l_BEGDA            = "";

    if( !e17SickData.CTRL_NUMB.substring(7, 9).equals("01") ) {              // 동일진료이면..
        E18HospitalData_vt = func_E18.getHospitalList( user.empNo );
    
        for ( int i = 0 ; i < E18HospitalData_vt.size() ; i++ ) {
            E18HospitalListData data_18 = ( E18HospitalListData ) E18HospitalData_vt.get( i );
    
            l_CTRL_NUMB = e17SickData.CTRL_NUMB.substring(0, 7) + "01";
            if( data_18.GUEN_CODE.equals(e17SickData.GUEN_CODE) && data_18.OBJPS_21.equals(e17SickData.OBJPS_21)
                                                                && data_18.REGNO_21.equals(e17SickData.REGNO_21)
                                                                && data_18.CTRL_NUMB.equals(l_CTRL_NUMB) ) {
                l_BEGDA = data_18.BEGDA;
            }
        }
    }
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
    <table class="appTB">
      <tr>
        <th>담당자</th>
        <th>책임자</th>
      </tr>
      <tr>
        <td></td>
        <td></td>
      </tr>
    </table>
    <div class="clear"> </div>
    <div class="printTitle">의료비 지원 신청서</div>
    <div class="tableTitle">1. 신청자</div>
    <table class="printTB printbd">
      <tr>
        <th width="15%">소속</th>
        <td width="18%" colspan="2"><%= user.e_orgtx %>&nbsp;</td>
        <th width="15%">직위</th>
        <td width="18%"><%= user.e_titel %>&nbsp;</td>
        <th width="15%">사번</th>
        <td width="19%"><%= user.empNo %>&nbsp;</td>
      </tr>
      <tr>
        <th>사내전화</th>
        <td colspan="2"><%= user.e_phone_num %>&nbsp;</td>
        <th>신청자</th>
        <td colspan="3"><%= user.ename %>&nbsp;</td>
      </tr>
    </table>
    <div class="tableTitle">2. 지급대상자 및 신청내역</div>
    <table class="printTB printbd">
      <tr>
        <th>구분</th>
        <td colspan="2"><%= WebUtil.printOptionText((new E17GuenCodeRFC()).getGuenCode(user.empNo), e17SickData.GUEN_CODE) %>&nbsp;</td>
        <th colspan="2"" >이름</th>
        <td colspan="3"><%= e17SickData.GUEN_CODE.equals("0001") ? user.ename : e17SickData.ENAME %>&nbsp;</td>
      </tr>
      <tr>
        <th>연말정산반영여부</th>
        <td colspan="7">&nbsp;<%= e17SickData.PROOF.equals("X") ? "V" : "" %>&nbsp;</td>
      </tr>
      <tr>
        <th>상병명</th>
        <td colspan="7">&nbsp;<%= e17SickData.SICK_NAME %>&nbsp;</td>
      </tr>
      <tr>
        <th>동일진료여부</th>
<%
    if( e17SickData.CTRL_NUMB.substring(7, 9).equals("01") ) {
%>
        <td colspan="2">최초진료</td>
        <%
    } else {
%>
        <td colspan="2">동일진료</td>
        <%
    } 
%>
        <th colspan="2">동일진료시<br>
          최초 신청날짜</th>
        <td colspan="3">&nbsp;<%= WebUtil.printDate(l_BEGDA) %>&nbsp;</td>
      </tr>
      <tr>
        <th> 구체적 증상<br>
          (상세히 기술) </th>
        <td colspan="7">&nbsp;<%= e17SickData.SICK_DESC1 +"<BR>&nbsp;"+ e17SickData.SICK_DESC2 +"<BR>&nbsp;"+ e17SickData.SICK_DESC3 +"<BR>&nbsp;"+ e17SickData.SICK_DESC4  %>&nbsp;</td>
      </tr>
      <tr>
        <th width="16%">병원명</th>
        <th noWrap width="14%">사업자등록번호</th>
        <th noWrap width="11%">전화번호</th>
        <th width="11%">진료일자</th>
        <th width="9%">입원/외래</th>
        <th noWrap width="15%">영수증구분</th>
        <th width="10%">결재수단</th>
        <th width="15%">본인부담금액</th>
      </tr>
<%
          String MEDI_MTHD_TEXT = ""; //@v1.1    
            for( int i = 0 ; i < E17HospitalData_vt.size() ; i++ ){
                E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
		//@v1.1
		if (e17HospitalData.MEDI_MTHD.equals("1")) 
                    MEDI_MTHD_TEXT = "현금";
                else if (e17HospitalData.MEDI_MTHD.equals("2"))
                    MEDI_MTHD_TEXT = "신용카드";
                else if (e17HospitalData.MEDI_MTHD.equals("3"))
                    MEDI_MTHD_TEXT = "현금영수증";
                else  MEDI_MTHD_TEXT = "";                
%>
      <tr>
        <td class="txtcenter"><%= e17HospitalData.MEDI_NAME %></td>
        <td class="txtcenter"><%= e17HospitalData.MEDI_NUMB.equals("") ? "" : DataUtil.addSeparate2(e17HospitalData.MEDI_NUMB) %></td>
        <td class="txtcenter"><%= e17HospitalData.TELX_NUMB.equals("") ? "&nbsp;" : e17HospitalData.TELX_NUMB %></td>
        <td class="txtcenter"><%= e17HospitalData.EXAM_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(e17HospitalData.EXAM_DATE) %></td>
        <td class="txtcenter"><%= e17HospitalData.MEDI_TEXT %></td>
        <td class="txtcenter"><%= e17HospitalData.RCPT_TEXT %></td>
        <td class="txtcenter"><%= MEDI_MTHD_TEXT %></td>
        <td class="alignright"><%= WebUtil.printNumFormat(e17HospitalData.EMPL_WONX, currencyValue) %>&nbsp;</td>
      </tr>
<%
            }
            for( int i = E17HospitalData_vt.size() ; i < 6 ; i++ ){
%>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
<%
            }
%>
      <tr>
        <th colspan="5"> 총 본인 부담 금액</th>
        <td colspan="3" class="alignright"><%= WebUtil.printNumFormat(EMPL_WONX_tot, currencyValue) %>&nbsp;&nbsp;<%= e17SickData.WAERS %></td>
      </tr>
    </table>
    <div class="tableTitle">3. 유첨서류 : 의료비영수증(약국이용시 의사처방전 유첨)</div>
    <div class="tableTitle">4. 신청시 유의사항</div>
    <div class="numberList">
	  <ul>
	    <li>① 의료비 지원은 동일 진료건당 10만원 초과시<br>
           &nbsp;&nbsp;&nbsp;&nbsp;(10만원 이하는 지원되지 않음)<br>
           &nbsp;&nbsp;&nbsp;&nbsp;- 본인의 경우 초과금액의 전액을 지원함(년간 2,000만원 한도).<br>
           &nbsp;&nbsp;&nbsp;&nbsp;- 배우자는 10만원 초과금액의 100%를.<br>
           &nbsp;&nbsp;&nbsp;&nbsp;- 자녀는 10만원 초과금액의 100%를 지원(년간 배우자 자녀 합산 1000만원
           한도).<li>           
           <!-- [CSR ID:2610222] 의료비 지원 신청서 포맷 변경  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;단, 회사지원 총액은 <font color="#FF0000">년간 500만원 한도로 제한</font>하고 한도 초과자 발생시 별도지원<br>                  --> 
           <li>② 일반 영수증인 경우는 영수증 상에 진료일자, 진료항목, 금액, 등이 상세하게 기재된 것이어야 함.</li>
           <li>③ 한의원의 첩약, 건강진단, 치과의 보철료 등은 지원대상에서 제외됨.<br>
           &nbsp;&nbsp;&nbsp;&nbsp;- 의료보험의 적용을 받아 치료하는데 소용된 비용(급여항목 중 본인 부담금)에 한함</li>
           <li>④ 입원시의 상급병실료 차액은 50% 지원함.</li>
           <li>⑤ <span class="bold">의료비를 지급한 날로부터 1년 이내에 신청하여야 함.</span></li>
           <li>⑥ 입원 및 장기진료 등의 경우에는 반드시 근태를 정리하여야 함. </li>
       </ul>
     </div>
     <table class="printSG">
       <tr>
         <td>신청일 : <%=YYYY%> 년 <%=MM%> 월 <%=DD%> 일</td>
       </tr>
       <tr>
         <td>신청자 : <%= user.ename %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</td>
       </tr>
     </table>
  </form>
</div>
</body>
</html>