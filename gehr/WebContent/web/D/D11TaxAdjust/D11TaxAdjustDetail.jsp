<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    TaxAdjustFlagData taxAdjustFlagData = ((TaxAdjustFlagData)session.getAttribute("taxAdjust"));

    String targetYear     = (String)request.getAttribute("targetYear"    );
    Vector personalRed_vt = (Vector)request.getAttribute("personalRed_vt");
    Vector specialRed_vt  = (Vector)request.getAttribute("specialRed_vt" );
    Vector etcRed_vt      = (Vector)request.getAttribute("etcRed_vt"     );

    Vector D13_personalRed_vt = DataUtil.clone(personalRed_vt);
    Vector D13_specialRed_vt  = DataUtil.clone(specialRed_vt );
    Vector D13_etcRed_vt      = DataUtil.clone(etcRed_vt     );

    for( int i = 0 ; i < personalRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)personalRed_vt.get(i);

        data.REGNO    =(data.REGNO.equals("")       ?"":DataUtil.addSeparate(data.REGNO)        );// 주민등록번호
        data.BASIC_RED=(data.BASIC_RED.equals("0.0")?"":WebUtil.printNumFormat(data.BASIC_RED,0));// 기본공제
        data.OLD_RED  =(data.OLD_RED.equals("0.0")  ?"":WebUtil.printNumFormat(data.OLD_RED  ,0));// 경로우대
        data.HANDY_RED=(data.HANDY_RED.equals("0.0")?"":WebUtil.printNumFormat(data.HANDY_RED,0));// 장애자
        data.WOMEN_RED=(data.WOMEN_RED.equals("0.0")?"":WebUtil.printNumFormat(data.WOMEN_RED,0));// 부녀자
        data.CHILD_RED=(data.CHILD_RED.equals("0.0")?"":WebUtil.printNumFormat(data.CHILD_RED,0));// 자녀양육비
    }
    for( int i = 0 ; i < specialRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)specialRed_vt.get(i);

        data.REGNO   =( data.REGNO.equals("")      ?"":DataUtil.addSeparate(data.REGNO)       );// 주민등록번호
        data.ADD_AMT =( data.ADD_AMT.equals("0.0") ?"":WebUtil.printNumFormat(data.ADD_AMT ,0));// 개인추가분
        data.AUTO_AMT=( data.AUTO_AMT.equals("0.0")?"":WebUtil.printNumFormat(data.AUTO_AMT,0));// 자동반영분
    }
    for( int i = 0 ; i < etcRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)etcRed_vt.get(i);

        data.REGNO   =( data.REGNO.equals("")      ?"":DataUtil.addSeparate(data.REGNO)       );// 주민등록번호
        data.ADD_AMT =( data.ADD_AMT.equals("0.0") ?"":WebUtil.printNumFormat(data.ADD_AMT ,0));// 개인추가분
        data.AUTO_AMT=( data.AUTO_AMT.equals("0.0")?"":WebUtil.printNumFormat(data.AUTO_AMT,0));// 자동반영분
    }

// Simulation 을 위한 세팅
    D13TaxAdjustData d13Data = new D13TaxAdjustData();

    double _기본공제_본인      = 0;
    double _기본공제_배우자    = 0;
    double _기본공제_부양가족  = 0;
    double _추가공제_경로우대  = 0;
    double _추가공제_장애인    = 0;
    double _추가공제_부녀자    = 0;
    double _추가공제_자녀양육비= 0;
    double _소수공제자추가공제 = 0;
    double _인적공제총액       = 0;
    for( int i = 0 ; i < D13_personalRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)D13_personalRed_vt.get(i);
        double BASIC_RED = 0;
        double OLD_RED   = 0;
        double HANDY_RED = 0;
        double WOMEN_RED = 0;
        double CHILD_RED = 0;
        if( ! data.BASIC_RED.equals("")) BASIC_RED = Double.parseDouble(data.BASIC_RED);
        if( ! data.OLD_RED.equals("")  ) OLD_RED   = Double.parseDouble(data.OLD_RED  );
        if( ! data.HANDY_RED.equals("")) HANDY_RED = Double.parseDouble(data.HANDY_RED);
        if( ! data.WOMEN_RED.equals("")) WOMEN_RED = Double.parseDouble(data.WOMEN_RED);
        if( ! data.CHILD_RED.equals("")) CHILD_RED = Double.parseDouble(data.CHILD_RED);

Logger.debug.println(this, "data.RELA.trim() : "+data.RELA.trim());

        if( BASIC_RED != 0 && data.RELA.trim().equals("본인") ){
            _기본공제_본인   += BASIC_RED ;
Logger.debug.println(this, "data.RELA.trim() : "+data.RELA.trim());
        } else if( BASIC_RED != 0 && data.RELA.trim().equals("배우자") ){
            _기본공제_배우자 += BASIC_RED ;
Logger.debug.println(this, "data.RELA.trim() : "+data.RELA.trim());
        } else {
            _기본공제_부양가족 += BASIC_RED ;
Logger.debug.println(this, "data.RELA.trim() : "+data.RELA.trim());
        }
        if( OLD_RED   != 0 ) _추가공제_경로우대   += OLD_RED   ;
        if( HANDY_RED != 0 ) _추가공제_장애인     += HANDY_RED ;
        if( WOMEN_RED != 0 ) _추가공제_부녀자     += WOMEN_RED ;
        if( CHILD_RED != 0 ) _추가공제_자녀양육비 += CHILD_RED ;
    }
    // 소수공제자 추가공제
    if( D13_personalRed_vt.size() == 1 ){
        _소수공제자추가공제 = 100 * 10000;
    } else if( D13_personalRed_vt.size() == 2 ){
        _소수공제자추가공제 =  50 * 10000;
    }
/*
    d13Data._기본공제_본인       = _기본공제_본인      ;
    d13Data._기본공제_배우자     = _기본공제_배우자    ;
    d13Data._기본공제_부양가족   = _기본공제_부양가족  ;
    d13Data._추가공제_경로우대   = _추가공제_경로우대  ;
    d13Data._추가공제_장애인     = _추가공제_장애인    ;
    d13Data._추가공제_부녀자     = _추가공제_부녀자    ;
    d13Data._추가공제_자녀양육비 = _추가공제_자녀양육비;
    d13Data._소수공제자추가공제  = _소수공제자추가공제 ;
*/
    double hap  = _기본공제_본인      ;
           hap += _기본공제_배우자    ;
           hap += _기본공제_부양가족  ;
           hap += _추가공제_경로우대  ;
           hap += _추가공제_장애인    ;
           hap += _추가공제_부녀자    ;
           hap += _추가공제_자녀양육비;
           hap += _소수공제자추가공제 ;   // 소수공제자추가공제를 인적공제총액에 추가시켰다.
    d13Data._인적공제총액 = hap ;

    double _의료비경로장애 = 0;


    double _교육비영유아 = 0;
    double _교육비초중고 = 0;
    double _교육비대학   = 0;
    for( int i = 0 ; i < D13_specialRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)D13_specialRed_vt.get(i);
        double ADD_AMT  = 0;
        double AUTO_AMT = 0;
        if( ! data.ADD_AMT.equals("")  ) ADD_AMT  = Double.parseDouble(data.ADD_AMT) ;
        if( ! data.AUTO_AMT.equals("") ) AUTO_AMT = Double.parseDouble(data.AUTO_AMT);
        double total_AMT = ADD_AMT + AUTO_AMT;


Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());

        if(data.GUBUN.trim().equals("의료보험"          )) {
            d13Data._의료보험료           = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("고용보험"          )) {
            d13Data._고용보험료           = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("보험료(일반)"      )) {
            d13Data._보험료일반           = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(장애자)"          )) {
            d13Data._보험료장애자         = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("의료비(일반)"      )) {
            d13Data._의료비일반           = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());


        } else if(data.GUBUN.trim().equals("(경로+장애)") || data.GUBUN.trim().equals("(장애재활비)")) {
            _의료비경로장애 += total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());


        } else if(data.GUBUN.trim().equals("주택자금(저축금액)")) {
            d13Data._주택자금저축금액     = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(차입원리금)"      )) {
            d13Data._주택자금차입원리금   = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(차입이자상환)"    )) {
            d13Data._주택자금차입이자상환 = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("기부금(법정)"      )) {
            d13Data._기부금법정           = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(지정)"            )) {
            d13Data._기부금지정           = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("교육비 본인"       )) {
            d13Data._교육비본인           = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else {
            if( data.FASAR.equals("A1") || data.FASAR.equals("B1")){
                _교육비영유아 += total_AMT;

            } else if( data.FASAR.equals("C1") || data.FASAR.equals("D1") || data.FASAR.equals("E1") ){ // 초중고
                _교육비초중고 += total_AMT;

            } else if( data.FASAR.equals("F1") || data.FASAR.equals("G1")
                    || data.FASAR.equals("G2") || data.FASAR.equals("H1")){
                _교육비대학   += total_AMT;
            }
        }
    }

    d13Data._의료비경로장애= _의료비경로장애;
    d13Data._교육비영유아  = _교육비영유아;
    d13Data._교육비초중고  = _교육비초중고;
    d13Data._교육비대학    = _교육비대학  ;


    for( int i = 0 ; i < D13_etcRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)D13_etcRed_vt.get(i);
        double ADD_AMT  = 0;
        double AUTO_AMT = 0;
        if( ! data.ADD_AMT.equals("")  ) ADD_AMT  = Double.parseDouble(data.ADD_AMT) ;
        if( ! data.AUTO_AMT.equals("") ) AUTO_AMT = Double.parseDouble(data.AUTO_AMT);
        double total_AMT = ADD_AMT + AUTO_AMT;

Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());

        if(data.GUBUN.trim().equals("기타공제(개인연금 I)"         )) {
            d13Data._개인연금I       = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(개인연금 II)"        )) {
            d13Data._개인연금II      = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(국민연금)"          )) {
            d13Data._국민연금        = total_AMT;
 Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
       } else if(data.GUBUN.trim().equals("(투자조합공제 I)"     )) {
            d13Data._투자조합공제I   = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(투자조합공제 II)"    )) {
            d13Data._투자조합공제II  = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(신용카드 공제)"      )) {
            d13Data._신용카드공제    = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("세액공제(주택자금이자상환)"  )) {
            d13Data._주택자금이자상환= total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(근로자주식저축)"    )) {
            d13Data._근로자주식저축  = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(장기증권저축)"      )) {
            d13Data._장기증권저축    = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(해외원천소득)"      )) {
            d13Data._국외원천근로소득금액    = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(외국납부세[당년])"  )) {
            d13Data._외국납부세당년 = total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        } else if(data.GUBUN.trim().equals("(외국납부세[이월분])")) {
            d13Data._외국납부세이월분= total_AMT;
Logger.debug.println(this, "data.GUBUN.trim() : "+data.GUBUN.trim());
        }
    }
    String spaceArea = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess2.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function go_change(){
    if( <%= taxAdjustFlagData.canBuild %> ){

        document.form1.jobid.value = "pre_change";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustDetailSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    } else {
        alert("<spring:message code='MSG.D.D11.0029' />"); //소득공제신고서를 수정할 수 있는 기간이 아닙니다.
    }
}
function go_printPage(){
  window.open('<%=WebUtil.ServletURL%>hris.D.D12IncomePrintSV?targetYear=<%= taxAdjustFlagData.targetYear %>', 'essPrintWindow', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650');
}
function go_simulation(){
    if( <%= taxAdjustFlagData.canSimul %> ){
        //document.form1.jobid.value = "simulate";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D13TaxAdjustSimulSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    } else {
        alert("<spring:message code='MSG.D.D11.0028' />"); //연말정산 Simulation을 할 수 있는 기간이 아닙니다.
    }
}
function go_prevview(){
    location.href = "<%= WebUtil.JspURL %>D/D10Yeartex/D10YeartexGuide.jsp";
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="title01"><spring:message code="LABEL.D.D11.0110" /><!-- 연말정산공제신청 조회 --></td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01"><spring:message code="LABEL.D.D11.0002" /><!-- 연도 --> : <%= targetYear %> &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0003" /><!-- 신청기간 --> : <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-")) %> ~ <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-")) %></td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--개인정보 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table01" bordercolor="#999999">
          <tr>
            <td class="td01" rowspan="2" width="60"><spring:message code="LABEL.D.D11.0004" /><!-- 소득자 --></td>
            <td class="td01" width="50"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td02" width="199">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;</td>
            <td class="td01" width="90"><spring:message code="LABEL.D.D11.0006" /><!-- 주민등록번호 --></td>
            <td class="td02" width="199">&nbsp;&nbsp;<%= DataUtil.addSeparate(((WebUserData)session.getAttribute("user")).e_regno) %>&nbsp;</td>
          </tr>
          <tr>
            <td class="td01"><spring:message code="LABEL.D.D11.0007" /><!-- 주소 --></td>
            <td class="td02" colspan="3">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_stras %>&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_locat %></td>
          </tr>
        </table>
        <!--개인정보 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01"><font color="#6699FF">■</font> <spring:message code="LABEL.D.D11.0008" /><!-- 인적공제 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--인적공제 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02" bordercolor="#999999">
          <tr>
            <td class="td03" width="50"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" width="63"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" width="110"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0015" /><!-- 기본공제 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0011" /><!-- 경로우대 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0012" /><!-- 장애자 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0013" /><!-- 부녀자 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0014" /><!-- 자녀양육비 --></td>
          </tr>
<%
        for( int i = 0 ; i < personalRed_vt.size() ; i++ ){
          D11TaxAdjustData d11TaxAdjustData = (D11TaxAdjustData)personalRed_vt.get(i);
%>
          <tr>
            <td class="td04">&nbsp;<%= d11TaxAdjustData.RELA.trim() %></td>
            <td class="td04"><%= d11TaxAdjustData.ENAME.trim() %>&nbsp;</td>
            <td class="td04"><%= d11TaxAdjustData.REGNO.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.BASIC_RED.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.OLD_RED.trim()   %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.HANDY_RED.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.WOMEN_RED.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.CHILD_RED.trim() %>&nbsp;</td>
          </tr>
<%    }%>
        </table>
        <!--인적공제 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01"><font color="#6699FF">■</font> <spring:message code="LABEL.D.D11.0016" /><!-- 특별공제 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--특별공제 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02" bordercolor="#999999">
          <tr>
            <td class="td03" width="140"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></td>
            <td class="td03" width="55" ><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" width="70" ><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" width="120"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>
            <td class="td03" width="110"><spring:message code="LABEL.D.D11.0018" /><!-- 학력 --></td>
            <td class="td03" width="90" ><spring:message code="LABEL.D.D11.0019" /><!-- 개인추가 --></td>
            <td class="td03" width="95" ><spring:message code="LABEL.D.D11.0020" /><!-- 자동반영분금액 --></td>
            <td class="td03" width="110"><spring:message code="LABEL.D.D11.0021" /><!-- 자동반영분내용 --></td>
          </tr>
<%
        for( int i = 0 ; i < specialRed_vt.size() ; i++ ){
          D11TaxAdjustData d11TaxAdjustData = (D11TaxAdjustData)specialRed_vt.get(i);
          if( d11TaxAdjustData.RELA.equals("")    &&
              d11TaxAdjustData.ENAME.equals("")   &&
              d11TaxAdjustData.REGNO.equals("")   &&
              d11TaxAdjustData.ADD_AMT.equals("") &&
              d11TaxAdjustData.AUTO_AMT.equals("")   ){
              continue;
          }
%>
          <tr>
            <td class="td04" style="text-align:left"><%=d11TaxAdjustData.GUBUN.trim().substring(0,1).equals("(") ? spaceArea : "" %><%=d11TaxAdjustData.GUBUN.trim().substring(0,1).equals("부") ? spaceArea : "" %><%= WebUtil.printString(d11TaxAdjustData.GUBUN.trim())%></td>
            <td class="td04">&nbsp;<%= d11TaxAdjustData.RELA.trim() %></td>
            <td class="td04"><%= d11TaxAdjustData.ENAME.trim() %>&nbsp;</td>
            <td class="td04"><%= d11TaxAdjustData.REGNO.trim() %>&nbsp;</td>
            <td class="td04">
<%
          if(d11TaxAdjustData.GUBUN.trim().equals("교육비 본인") || d11TaxAdjustData.GUBUN.trim().substring(0,4).equals("부양가족")){

            String stext = "";
            Logger.debug.println(this,"d11TaxAdjustData.FASAR : "+d11TaxAdjustData.FASAR);
            Vector vet = (new A12FamilyScholarshipRFC()).getFamilyScholarship();
            Logger.debug.println(this,"vet : "+vet.toString());
            for(int j = 0 ; j < vet.size() ; j++ ){
                CodeEntity ent = (CodeEntity)vet.get(j);
            Logger.debug.println(this,"ent : "+ent.toString());
                if(ent.code.equals(d11TaxAdjustData.FASAR)){
                    stext = ent.value;
                }
            }
%>
            <%= stext %>&nbsp;</td>
<%        }%>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.ADD_AMT.trim()   %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.AUTO_AMT.trim()  %>&nbsp;</td>
            <td class="td04"><%= d11TaxAdjustData.AUTO_AMT.equals("")? "" : d11TaxAdjustData.AUTO_TEXT %>&nbsp;</td>
          </tr>
<%    }%>
        </table>
        <!--특별공제 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01"><font color="#6699FF">■</font> <spring:message code="LABEL.D.D11.0022" /><!-- 기타/세액공제 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--기타/세액공제 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02" bordercolor="#999999">
          <tr>
            <td class="td03" width="200"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></td>
            <td class="td03" width="55" ><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" width="70" ><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" width="120"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>
            <td class="td03" width="90" ><spring:message code="LABEL.D.D11.0019" /><!-- 개인추가 --></td>
            <td class="td03" width="95" ><spring:message code="LABEL.D.D11.0020" /><!-- 자동반영분금액 --></td>
            <td class="td03" width="160"><spring:message code="LABEL.D.D11.0021" /><!-- 자동반영분내용 --></td>
          </tr>
<%
        for( int i = 0 ; i < etcRed_vt.size() ; i++ ){
          D11TaxAdjustData d11TaxAdjustData = (D11TaxAdjustData)etcRed_vt.get(i);
          //d11TaxAdjustData.GUBUN = d11TaxAdjustData.GUBUN.substring(0,d11TaxAdjustData.GUBUN.length()-6);
%>
          <tr>
            <td class="td04" style="text-align:left"><%=d11TaxAdjustData.GUBUN.trim().substring(0,1).equals("(") ? spaceArea : "" %><%= WebUtil.printString(d11TaxAdjustData.GUBUN.trim())%></td>
            <td class="td04">&nbsp;<%= d11TaxAdjustData.RELA.trim() %></td>
            <td class="td04"><%= d11TaxAdjustData.ENAME.trim() %>&nbsp;</td>
            <td class="td04"><%= d11TaxAdjustData.REGNO.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.ADD_AMT.trim()   %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.AUTO_AMT.trim()  %>&nbsp;</td>
            <td class="td04"><%= d11TaxAdjustData.AUTO_AMT.equals("")? "" : d11TaxAdjustData.AUTO_TEXT %>&nbsp;</td>
          </tr>
<%
        }
%>
        </table>
        <!--기타/세액공제 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="790" border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td align="center">
              <a href="javascript:go_change();">
              <img src="<%= WebUtil.ImageURL %>btn_change.gif" width="49" height="20" border="0" align="absmiddle"></a>
              <a href="javascript:go_prevview();">
              <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" width="59" height="20" border="0" align="absmiddle"></a>
              <a href="javascript:go_simulation();">
              <img src="<%= WebUtil.ImageURL %>btn_simulation01.gif" width="81" height="20" align="absmiddle" border="0"></a>
              <a href="javascript:go_printPage();">
              <img src="<%= WebUtil.ImageURL %>btn_incomePrint.gif" width="137" height="20" align="absmiddle" border="0"></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>

  <input type="hidden" name="jobid"      value="">
  <input type="hidden" name="targetYear" value="<%=targetYear%>">

  <input type="hidden" name="_국외원천근로소득금액"   value="<%= d13Data._국외원천근로소득금액  %>">

  <input type="hidden" name="_기본공제_본인"          value="<%= _기본공제_본인       %>">
  <input type="hidden" name="_기본공제_배우자"        value="<%= _기본공제_배우자     %>">
  <input type="hidden" name="_기본공제_부양가족"      value="<%= _기본공제_부양가족   %>">
  <input type="hidden" name="_추가공제_경로우대"      value="<%= _추가공제_경로우대   %>">
  <input type="hidden" name="_추가공제_장애인"        value="<%= _추가공제_장애인     %>">
  <input type="hidden" name="_추가공제_부녀자"        value="<%= _추가공제_부녀자     %>">
  <input type="hidden" name="_추가공제_자녀양육비"    value="<%= _추가공제_자녀양육비 %>">
  <input type="hidden" name="_소수공제자추가공제"     value="<%= _소수공제자추가공제  %>">

  <input type="hidden" name="_인적공제총액"           value="<%= d13Data._인적공제총액         %>">

  <input type="hidden" name="_의료보험료"             value="<%= d13Data._의료보험료           %>">
  <input type="hidden" name="_고용보험료"             value="<%= d13Data._고용보험료           %>">
  <input type="hidden" name="_보험료일반"             value="<%= d13Data._보험료일반           %>">
  <input type="hidden" name="_보험료장애자"           value="<%= d13Data._보험료장애자         %>">
  <input type="hidden" name="_의료비일반"             value="<%= d13Data._의료비일반           %>">
  <input type="hidden" name="_의료비경로장애"         value="<%= d13Data._의료비경로장애       %>">
  <input type="hidden" name="_주택자금저축금액"       value="<%= d13Data._주택자금저축금액     %>">
  <input type="hidden" name="_주택자금차입원리금"     value="<%= d13Data._주택자금차입원리금   %>">
  <input type="hidden" name="_주택자금차입이자상환"   value="<%= d13Data._주택자금차입이자상환 %>">
  <input type="hidden" name="_기부금법정"             value="<%= d13Data._기부금법정           %>">
  <input type="hidden" name="_기부금지정"             value="<%= d13Data._기부금지정           %>">

  <input type="hidden" name="_교육비본인"             value="<%= d13Data._교육비본인           %>">
  <input type="hidden" name="_교육비영유아"           value="<%= d13Data._교육비영유아         %>">
  <input type="hidden" name="_교육비초중고"           value="<%= d13Data._교육비초중고         %>">
  <input type="hidden" name="_교육비대학"             value="<%= d13Data._교육비대학           %>">

  <input type="hidden" name="_개인연금I"              value="<%= d13Data._개인연금I            %>">
  <input type="hidden" name="_개인연금II"             value="<%= d13Data._개인연금II           %>">
  <input type="hidden" name="_국민연금"               value="<%= d13Data._국민연금             %>">
  <input type="hidden" name="_투자조합공제I"          value="<%= d13Data._투자조합공제I        %>">
  <input type="hidden" name="_투자조합공제II"         value="<%= d13Data._투자조합공제II       %>">
  <input type="hidden" name="_신용카드공제"           value="<%= d13Data._신용카드공제         %>">
  <input type="hidden" name="_주택자금이자상환"       value="<%= d13Data._주택자금이자상환     %>">
  <input type="hidden" name="_근로자주식저축"         value="<%= d13Data._근로자주식저축       %>">
  <input type="hidden" name="_장기증권저축"           value="<%= d13Data._장기증권저축         %>">
  <input type="hidden" name="_외국납부세당년"         value="<%= d13Data._외국납부세당년       %>">
  <input type="hidden" name="_외국납부세이월분"       value="<%= d13Data._외국납부세이월분     %>">

</form>

<%@ include file="/web/common/commonEnd.jsp" %>
<!--
    d13TaxAdjustData._총급여                   = 2800*MANWON;
    d13TaxAdjustData._과세대상근로소득         = 2800*MANWON;
    d13TaxAdjustData._근로소득금액             = 0*MANWON;
    d13TaxAdjustData._당해과세연도종합소득금액 = 0*MANWON;
    d13TaxAdjustData._국외원천근로소득금액     = 0*MANWON;
    d13TaxAdjustData._기납부세액               = 50*MANWON;

    d13TaxAdjustData._인적공제총액             = 650*MANWON;
    d13TaxAdjustData._의료보험료               = 30*MANWON;
    d13TaxAdjustData._고용보험료               = 70*MANWON;
    d13TaxAdjustData._보험료일반               = 10*MANWON;
    d13TaxAdjustData._보험료장애자             = 10*MANWON;
    d13TaxAdjustData._의료비일반               = 123*MANWON;
    d13TaxAdjustData._의료비경로장애           = 123*MANWON;
    d13TaxAdjustData._주택자금저축금액         = 30*MANWON;
    d13TaxAdjustData._주택자금차입원리금       = 10*MANWON;
    d13TaxAdjustData._주택자금차입이자상환     = 10*MANWON;
    d13TaxAdjustData._기부금법정               = 100*MANWON;
    d13TaxAdjustData._기부금지정               = 0*MANWON;
    d13TaxAdjustData._교육비본인               = 12*MANWON;
    d13TaxAdjustData._교육비영유아             = 80*MANWON;
    d13TaxAdjustData._교육비초중고             = 100*MANWON;
    d13TaxAdjustData._교육비대학               = 0*MANWON;
    d13TaxAdjustData._개인연금I                = 10*MANWON;
    d13TaxAdjustData._개인연금II               = 10*MANWON;
    d13TaxAdjustData._국민연금                 = 10*MANWON;
    d13TaxAdjustData._투자조합공제I            = 10*MANWON;
    d13TaxAdjustData._투자조합공제II           = 10*MANWON;
    d13TaxAdjustData._신용카드공제             = 1000*MANWON
    d13TaxAdjustData._주택자금이자상환         = 10*MANWON;
    d13TaxAdjustData._근로자주식저축           = 10*MANWON;
    d13TaxAdjustData._장기증권저축             = 10*MANWON;
    d13TaxAdjustData._외국납부세당년           = 0*MANWON;
    d13TaxAdjustData._외국납부세이월분         = 0*MANWON;
-->
