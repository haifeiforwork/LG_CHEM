<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 Print                                                */
/*   Program ID   : E17HospitalPrintpage.jsp                                    */
/*   Description  : 의료비를 Print할 수 있도록 하는 창                          */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김성일                                          */
/*   Update       : 2005-02-24  윤정현                                          */
/*                  2005-12-27  @v1.1 C2005121301000001097 신용카드/현금구분추가*/
/*                  2008-11-13  CSR ID:1357074 의료비담당자결재관련 보완        */
/*                  2014-06-03  [CSR ID:2548667] 의료비관련 개선 요청의 건        */
/*                  2017-11-28  김주영 [CSR ID:3540182] 의료비지원 신청서 문구 수정요청의 건       */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.rfc.PersonInfoRFC" %>
<%@ page import="org.apache.tools.ant.util.StringUtils" %>

<%
    WebUserData user               = (WebUserData)session.getAttribute("user");
    E17SickData e17SickData        = (E17SickData)request.getAttribute("e17SickData");
    Vector      E17HospitalData_vt = (Vector)request.getAttribute("E17HospitalData_vt");
    Vector     a01SelfDetailData_vt = (Vector)request.getAttribute("A01SelfDetailData_vt");//DAT03(자사입사일) [CSR ID:2548667]
    A01SelfDetailData humanData      = (A01SelfDetailData)a01SelfDetailData_vt.get(0);//DAT03(자사입사일) [CSR ID:2548667]
    String      E_LASTDAY          = (String)request.getAttribute("E_LASTDAY");
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

//    PersonData personData2 = (PersonData)request.getAttribute("PersonData");

    PersonInfoRFC personInfoRFC = new PersonInfoRFC();
    PersonData personData2 = personInfoRFC.getPersonInfo(e17SickData.PERNR);

%>


<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function f_print(){
    self.print();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table width="649" border="0" cellspacing="1" cellpadding="0" align="center">
    <tr>
      <td>
        <table width="645" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top" align="center"><font face="굴림, 굴림체" size="5"><b><u><spring:message code="LABEL.E.E17.0020" /><!-- 의료비 지원 신청서 --></u></b></font></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="td02">1. <spring:message code="LABEL.E.E19.0033" /></td>
    </tr>
    <tr>
      <td>
        <table width="645" border="1" cellspacing="0" cellpadding="3" bordercolor="#000000">
          <tr>

            <td class="td04"><spring:message code="LABEL.COMMON.0029" /><!-- 소속 --></td>
            <td class="td04" colspan="2" ><%=personData2.E_ORGTX%>&nbsp;</td>
            <td class="td04" ><%-- //[CSR ID:3456352]<spring:message code="LABEL.COMMON.0008" /><!-- 직위 --> --%>
            <spring:message code="MSG.APPROVAL.0024" /><!-- 직책/직급호칭 -->
            </td>
            <td class="td04"><%-- //[CSR ID:3456352]<%=personData2.E_JIKWT%> --%>
            <%=personData2.E_JIKWT.equals("책임") && !personData2.E_JIKKT.equals("") ? personData2.E_JIKKT : personData2.E_JIKWT %>&nbsp;</td>
            <td class="td04"><spring:message code="LABEL.E.E16.0004" /><!-- 사번 --></td>
            <td class="td04" ><%=personData2.E_PERNR%>&nbsp;</td>
          </tr>
          <tr>
            <td class="td04"><spring:message code="LABEL.E.E17.0022" /><!-- 사내전화 --></td>
            <td class="td04" colspan="2"><%=personData2.E_PHONE_NUM  %>&nbsp;</td>
            <td class="td04"><spring:message code="LABEL.E.E19.0033" /><!-- 신청자 --></td>
            <!--  [CSR ID:2548667] <td colspan="3" class="td04"><%=personData2.E_ENAME %>&nbsp;</td> -->
            <td class="td04"><%=personData2.E_ENAME %>&nbsp;</td>
            <td class="td04"><spring:message code="LABEL.E.E17.0023" /><!-- 입사일자 --></td>
            <td class="td04"><%= (humanData.DAT02).equals("0000-00-00") ? "" : WebUtil.printDate(humanData.DAT02) %>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
   <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="td02"><spring:message code="LABEL.E.E17.0024" /><!-- 2. 지급대상자 및 신청내역 --></td>
    </tr>
    <tr>
      <td>
        <table width="645" border="1" cellspacing="0" cellpadding="3" bordercolor="#000000">
          <tr>
            <td class="td04"><spring:message code="LABEL.E.E18.0017" /><!-- 구분 --></td>
            <td class="td04" colspan="2"><%= WebUtil.printOptionText((new E17GuenCodeRFC()).getGuenCode(e17SickData.PERNR).get("T_RESULT"), e17SickData.GUEN_CODE) %>&nbsp;</td>
            <td class="td04"><spring:message code="LABEL.E.E21.0001" /><!-- 이름 --></td>
            <td colspan="4" class="td04"><%= e17SickData.GUEN_CODE.equals("0001") ? personData2.E_ENAME : e17SickData.ENAME %>&nbsp;</td>
          </tr>
          <tr>
            <td class="td04"><spring:message code="LABEL.E.E18.0022" /><!-- 진료과 --></td>
            <td class="td04" colspan="2" style="text-align:left">&nbsp;<%= WebUtil.printOptionText((new E17MedicTreaRFC()).getMedicTrea(), e17SickData.TREA_CODE) %>&nbsp;
            <td class="td04" colspan="3" ><spring:message code="LABEL.E.E18.0021" /><!-- 연말정산반영여부 --></td>
            <td class="td04" colspan="2" style="text-align:left">&nbsp;
                        &nbsp;<%= e17SickData.PROOF.equals("X") ? "V" : "" %>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td04"><spring:message code="LABEL.E.E17.0012" /><!-- 상병명 --></td>
            <td class="td04" colspan="7" style="text-align:left">&nbsp;<%= e17SickData.SICK_NAME %>&nbsp;</td>
          </tr>

          <tr>
            <td class="td04"><spring:message code="LABEL.E.E17.0025" /><!-- 동일진료여부 --></td>
<%
    String LASTDAY = "";
    if( e17SickData.CTRL_NUMB.substring(7, 9).equals("01") ) {
           LASTDAY="";
%>
            <td colspan="2" class="td04"><spring:message code="LABEL.E.E17.0002" /><!-- 최초진료 --></td>
<%
    } else {
           LASTDAY=E_LASTDAY;
%>
            <td colspan="2" class="td04"><spring:message code="LABEL.E.E17.0003" /><!-- 동일진료 --></td>
<%
    }
%>
            <td colspan="3" class="td04"><spring:message code="LABEL.E.E17.0026" /><!-- 동일진료시 마지막 신청일 --></td>
            <td colspan="2" class="td04">&nbsp;<%=LASTDAY%>
            </td>
          </tr>
          <tr>
            <td class="td04">
              <p><spring:message code="LABEL.E.E17.0027" /><!-- 구체적 증상 --></p>
              <p><spring:message code="LABEL.E.E17.0028" /><!-- (상세히 기술) --></p>
            </td>
              <%
                  String desc = e17SickData.SICK_DESC1 + e17SickData.SICK_DESC2 + e17SickData.SICK_DESC3 + e17SickData.SICK_DESC4;
        desc = StringUtils.replace(desc, "\n", "<br>");
              %>
            <td colspan="7" class="td04" style="text-align:left"><%=desc %>&nbsp;</td>
          </tr>
        <TR>
          <TD class=td04 width=132><spring:message code="LABEL.E.E17.0029" /><!-- 병원명 --></TD>
          <TD class=td04 width=85 ><spring:message code="LABEL.E.E18.0029" /><!-- 사업자<BR>등록번호 --></TD>
          <TD class=td04 width=76 ><spring:message code="LABEL.E.E18.0030" /><!-- 전화번호 --></TD>
          <TD class=td04 width=70 ><spring:message code="LABEL.E.E17.0030" /><!-- 진료일자 --></TD>
          <TD class=td04 width=33 ><spring:message code="LABEL.E.E17.0031" /><!-- 입원<BR>/<BR>외래 --></TD>
          <TD class=td04 width=94 ><spring:message code="LABEL.E.E18.0033" /><!-- 영수증구분 --></TD>
          <TD class=td04 width=80 ><spring:message code="LABEL.E.E18.0035" /><!-- 결재수단 --></TD>
          <TD class=td04 width=75 ><spring:message code="LABEL.E.E17.0032" /><!-- 본인부담<BR>금액 --></TD></TR>

        <!--  </table>
        <table width="645" border="1" cellspacing="0" cellpadding="3" bordercolor="#000000">

        <TR>
          <TD class=td04 width=124>1</TD>
          <TD class=td04 width=85 >2<BR></TD>
          <TD class=td04 width=76 >3</TD>
          <TD class=td04 width=70 >4</TD>
          <TD class=td04 width=33 >/<BR></TD>
          <TD class=td04 width=94 >4</TD>
          <TD class=td04 width=80 >5</TD>
          <TD class=td04 width=75 >5<BR></TD>
          </tr>
          </table>
        <table width="645" border="1" cellspacing="0" cellpadding="3" bordercolor="#000000">-->
<%          String MEDI_MTHD_TEXT = ""; //@v1.1
            for( int i = 0 ; i < E17HospitalData_vt.size() ; i++ ){
                E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
		//@v1.1
		if (e17HospitalData.MEDI_MTHD.equals("1"))
                    MEDI_MTHD_TEXT = g.getMessage("LABEL.E.E18.0040");  //현금
                else if (e17HospitalData.MEDI_MTHD.equals("2"))
                    MEDI_MTHD_TEXT = g.getMessage("LABEL.E.E18.0041");  //신용카드
                else if (e17HospitalData.MEDI_MTHD.equals("3"))
                    MEDI_MTHD_TEXT = g.getMessage("LABEL.E.E18.0042");  //현금영수증
                else  MEDI_MTHD_TEXT = "";

%>
          <tr>
            <td noWrap class="td04"><%= e17HospitalData.MEDI_NAME %></td>
            <td noWrap class="td04"><%= e17HospitalData.MEDI_NUMB.equals("") ? "&nbsp;" : DataUtil.addSeparate2(e17HospitalData.MEDI_NUMB) %></td>
            <td noWrap class="td04"><%= e17HospitalData.TELX_NUMB %></td>
            <td noWrap class="td04"><%=  e17HospitalData.EXAM_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(e17HospitalData.EXAM_DATE) %></td>
            <td noWrap class="td04"><%= e17HospitalData.MEDI_TEXT %></td>
            <td noWrap class="td04"><%= e17HospitalData.RCPT_TEXT %></td>
            <td noWrap class="td04"><%= MEDI_MTHD_TEXT %></td>
            <td noWrap class="td05"><%= WebUtil.printNumFormat(e17HospitalData.EMPL_WONX, currencyValue) %></td>
          </tr>
<%
            }
            for( int i = E17HospitalData_vt.size() ; i < 5 ; i++ ){
%>
          <tr>
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
            <td class="td04">&nbsp;</td>
          </tr>
<%
            }
%>
          <tr>
            <td class="td04" colspan="5"> <spring:message code="LABEL.E.E17.0033" /><!-- 총 본인 부담 금액 --></td>
            <td class="td05" colspan="3"><%= WebUtil.printNumFormat(EMPL_WONX_tot, currencyValue) %>&nbsp;&nbsp;<%= e17SickData.WAERS %></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="td02"><!-- 3. 유첨서류 : 의료비영수증(약국이용시 의사처방전 유첨) --></td>
    </tr>
    <tr>
      <td class="td02"><spring:message code="LABEL.E.E17.0035" /><!-- 4. 신청시 유의사항 --></td>
    </tr>
    <tr>
      <td>
        <table width="600" border="0" cellspacing="0" cellpadding="3" align="right">
          <tr>
            <td class="td02">
              <p><spring:message code="LABEL.E.E17.0036" /><!-- ① 의료비 지원은 동일 진료건당 10만원 초과시 --><br>
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.E.E17.0037" /><!-- (10만원 이하는 지원되지 않음) --><br>
                 &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.E.E17.0038" /><!-- - 본인의 경우 초과금액의 전액을 지원함(년간 2,000만원 한도). --><br>
                 <!-- [CSR ID:2633966] 학자금 및 의료비 문구 수정
                 &nbsp;&nbsp;&nbsp;- 배우자의 경우 초과금액의 전액을 지원함(년간 500만원 한도).<br>
                 &nbsp;&nbsp;&nbsp;- 자녀의 경우 초과금액의 50%를 지원함(년간 500만원 한도).<br>-->
                 <%-- 2017-11-28  cykim [CSR ID:3540182] 의료비지원 신청서 문구 수정요청의 건 start --%>
                 &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.E.E17.0039" /><!-- - 배우자, 자녀의 경우 초과금액의 전액을 지원함(년간 배우자,자녀 합산 1000만원 한도). --><br>
                <!-- &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.E.E17.0040" /> --><!-- - 자녀의 경우 초과금액의 50%를 지원함(년간 배우자,자녀 합산 1000만원 한도). -->
                <%-- 2017-11-28  cykim [CSR ID:3540182] 의료비지원 신청서 문구 수정요청의 건 end --%>
                 <spring:message code="LABEL.E.E17.0041" /><!-- ② 일반 영수증인 경우는 영수증 상에 진료일자, 진료항목, 금액, 등이 상세하게 기재된 것이어야 함. --><br>
                <spring:message code="LABEL.E.E17.0042" /><!--  ③ 한의원의 첩약, 건강진단, 치과의 보철료 등은 지원대상에서 제외됨. --><br>
                 &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.E.E17.0043" /><!-- - 의료보험의 적용을 받아 치료하는데 소용된 비용(급여항목 중 본인 부담금)에 한함 --><br>
                 <spring:message code="LABEL.E.E17.0044" /><!-- ④ 입원시의 상급병실료 차액은 50%만 지원함. --><br>
                 <spring:message code="LABEL.E.E17.0045" /><!-- ⑤ 치료가 병행되지 않는 검사료는 의료비 지원대상이 아님. --><br>
                 <%-- 2017-11-28  cykim [CSR ID:3540182] 의료비지원 신청서 문구 수정요청의 건 start --%>
                 <spring:message code="LABEL.E.E17.0046" /><!-- ⑥ <b>의료비를 지급한 날로부터 1년 이내에 신청해야 함.</b> --><br>
                 <%-- 2017-11-28  cykim [CSR ID:3540182] 의료비지원 신청서 문구 수정요청의 건 end --%>
                 <spring:message code="LABEL.E.E17.0047" /><!-- ⑦ 입원 및 장기진료 등의 경우에는 반드시 근태를 정리하여야 함. --></p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>
        <table width="250" border="0" cellspacing="0" cellpadding="3" align="right">
          <tr>
            <td class="font01" width="86" align="right"><spring:message code="LABEL.E.E18.0015" /><!-- 신청일 -->&nbsp;:</td>
            <td class="font01"><%=YYYY%>&nbsp;<spring:message code="LABEL.E.E20.0017" /><!-- 년 -->&nbsp;&nbsp;<%=MM%>&nbsp;<spring:message code="LABEL.E.E29.0012" /><!-- 월 -->&nbsp;&nbsp;<%=DD%>&nbsp;<spring:message code="LABEL.E.E20.0016" /><!-- 일 --></td>
          </tr>
          <tr>
            <td class="font01" width="86" align="right"><spring:message code="LABEL.E.E19.0033" /><!-- 신청자 -->&nbsp;:</td>
            <td class="font01"><%= personData2.E_ENAME %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.E.E17.0048" /><!-- (인) --></td>
          </tr>
        </table>
      </td>
    </tr>

</form>
<%@ include file="/web/common/commonEnd.jsp" %>
