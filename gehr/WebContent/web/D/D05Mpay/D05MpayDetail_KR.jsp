<%/******************************************************************************/
/*                                                                                      */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR 정보                                                        */
/*   2Depth Name  : 월급여                                                                     */
/*   Program Name : 월급여                                                                 */
/*   Program ID   : D05MpayDetail.jsp                                           */
/*   Description  : 개인의 월급여내역 조회                                                */
/*   Note         :                                                                     */
/*   Creation     : 2002-01-21  chldudgh                                        */
/*   Update       : 2005-01-24  윤정현                                                      */
/*                  2005-12-15  LSA @v1.1 EP메뉴로 인하여 수정                  */
/*                  2006-01-24  lsa @v1.2 조회년도 하드코딩내용 변경                */
/*   Update       : 2006-03-17  @v1.3 lsa 급여작업으로 막음                             */
/*   Update       : 2013-06-24 [CSR ID:2353407] sap에 추가암검진 추가 건     */
/*   Update       : 2013-09-10 [CSR ID:9999] 해외급여명세서 변경                     */
/*        2014-06-18 [CSR ID:2559989] 급여명세서 문구 수정요청                         */
/*                 2014-07-18 [CSR ID:2575929] 해외주재원 급여명세서 수정요청   */
/*                 2014-07-24 [CSR ID:2583411] 7월 급여명세서 문구 반영 요청   */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/*                  2014-08-13  [CSR ID:2591949] 해외주재원 급여명세서 수정요청   /  각주수정         */
/*                  2015-04-30  [CSR ID:2763588] E-HR 급여명세표 출력관련 변경 요청의 건   */
/*                  2015-05-22  [CSR ID:2782595] 5월 급여 공지사항 문구 삽입 요청 */
/*                  2015-05-27  [CSR ID:2785904] 월급여 공지사항 수정 요청 건  */
/*                  2016-02-24  [CSR ID:2993988] 월급여명세서 문구 추가 요청    */
/*                  2016-02-26  [CSR ID:2995203] 보상명세서 적용(Total Compensation)   */
/*                  2016-03-15  [CSR ID:3010670] 임금인상 관련 작업 시 월/연급여 조회 사용불가 기능 해제요청   */
/*                  2016-03-23  [CSR ID:3018046] 급여명세서 문구 수정요청   */
/*                  2016-04-19  [CSR ID:3038224] 총보상명세서 수정 요청   */
/*                  2016-04-29  [CSR ID:3043406] 급여명세표 내 공수 현황 기준 변경 요청  */
/*   Update   : 2016-08-30 GEHR통합작업     ksc  */
/*                  2017-05-29  [CSR ID:3391262] 급여명세서 내용 수정요처의 건  */
/*                  2017-07-24 [CSR ID:3440096] 급여명세표 과세반영 로직 수정   */
/*                  2018-01-23 rdcamel [CSR ID:3589279] 계약직(생산기술직) 월급여명세서 조회 화면 변경요청의 건   */
/* 				 2018-01-29 cykim	[CSR ID:3447340] 급여 수정 상태(PA03) 급여명세표 출력 문구 수정 요청   */
/*					2018-07-19  rdcamel [CSR ID:3744002] 사무직 급여명세서 추가 문구 표기 요청 */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %><!--@v1.2-->
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.rfc.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector d05MpayDetailData1_vt = ( Vector ) request.getAttribute( "d05MpayDetailData1_vt" ) ; // 해외급여 반영내역(항목) 내역

    Vector d05MpayDetailData2_vt = ( Vector ) request.getAttribute( "d05MpayDetailData2_vt" ) ; // 지급내역/공제내역
    Vector d05ZocrsnTextData_vt  = ( Vector ) request.getAttribute( "d05ZocrsnTextData_vt" ) ;   // 급여사유 코드와 TEXT

    Vector d05MpayDetailData3_vt = ( Vector ) request.getAttribute( "d05MpayDetailData3_vt" ) ; // 과세추가내역
    Vector d05MpayDetailData4_vt = ( Vector ) request.getAttribute( "d05MpayDetailData4_vt" ) ; // 변형 과세추가내역

    Vector d05MpayDetailData5_vt = ( Vector ) request.getAttribute( "d05MpayDetailData5_vt" ) ; // 지급내역text
    Vector d05MpayDetailData6_vt = ( Vector ) request.getAttribute( "d05MpayDetailData6_vt" ) ; // 해외지급내역수정

    D05MpayDetailData4 d05MpayDetailData4 = (D05MpayDetailData4) request.getAttribute( "d05MpayDetailData4"  ) ; // 급여명세표 - 개인정보/환율 내역
    D05MpayDetailData5 d05MpayDetailData5 = (D05MpayDetailData5) request.getAttribute( "d05MpayDetailData5"  ) ; // 지급내역/공제내역의 합

    //@v1.2 하드코딩내용변경 조회가능일을 가져 온다.

    String paydt = ( String ) request.getAttribute("paydt");//*ksc
    if (paydt==null){
	    D05LatestPaidRFC rfc_paid = new D05LatestPaidRFC();
	    paydt = rfc_paid.getLatestPaid1(user.empNo,user.webUserId);//[CSR ID:2353407]
    }
    Logger.debug.println("----------paydt:"+paydt);
    String ableyear  = paydt.substring(0,4);

    String year      = ( String ) request.getAttribute("year");
    String month     = ( String ) request.getAttribute("month");
    String ocrsn     = ( String ) request.getAttribute("ocrsn");
    String seqnr     = ( String ) request.getAttribute("seqnr");  // 5월 21일 순번 추가
    String backBtn  = ( String ) request.getAttribute("backBtn");  // new function
    String k_yn      = "";
    String ocrsn_t   = ocrsn.substring(0,2);
    String dis_play  = "";

    int    startYear = Integer.parseInt( (user.e_dat03).substring(0,4) );
    int    endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

    //[CSR ID:3447340] 급여 수정 상태(PA03) 급여명세표 출력 문구 수정 요청 start
    //매년 1월 급여 릴리즈 상태일때 sap에서 최근 급여지급일자를 return해 주므로 현재월이 2018/01월이면
    //2017-12월을 리턴해줌. 이럴경우 웹에서는 2018년도가 조회가 안되므로 아래와 같은 로직을 추가함.
    String ableMonth = paydt.substring(5,7);
    String currMonth = DataUtil.getCurrentMonth();

    if(ableMonth.equals("12") && currMonth.equals("01")){
    	int ableyear01 = Integer.parseInt(ableyear) + 1;
    	ableyear = Integer.toString(ableyear01);
    }
    //[CSR ID:3447340] 급여 수정 상태(PA03) 급여명세표 출력 문구 수정 요청 end

//    if( startYear < 2004 ){
//        startYear = 2004;
//    }

    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
       D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);

       if(!data4.BET01.equals("0") ) {
          dis_play = "Y";
       }
    }
    //총공수
    D02KongsuHourRFC rfcH       = new D02KongsuHourRFC();
    String yymm = year+ month ;
    //String KONGSU_HOUR = rfcH.getHour(user.empNo,yymm);
    //[CSR ID:3043406]
    Vector kongsuVec = rfcH.getHour2(user.empNo,yymm);
    String KONGSU_HOUR = (String)kongsuVec.get(0);
    String KONGSU_PAY = (String)kongsuVec.get(1);

    String overSeaYn = user.e_werks.substring(0,1); //해외급여자여부 :E


    //-------------------------------------------------------------------------------
    // [CSR ID:2995203]@v1.4 총보상명세내역
    String begym  = year + "01" ;
    String endym  = year + month ;

    D05CompensationRFC   rfc                = new D05CompensationRFC();

    D05CompensationData d05CompensationData = (D05CompensationData)rfc.getDetail(user.empNo, begym, endym);
    String CurrYear =  DataUtil.getCurrentYear();
    //-------------------------------------------------------------------------------

    //[CSR ID:3589279] 예외 사번 5명의 시간 값
    double temp_time = 0.0;// 일급계 값이 있어서, 시간 저장한 값
    double temp_times = 0.0;// 일급계 값이 있어서, 시간 저장한 값의 계

%>

<jsp:include page="/include/header.jsp" />

<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_MONT_PAY"/>
    <jsp:param name="help" value="D05Mpay.html"/>
</jsp:include>

<script language="JavaScript">
<!--
$(function (){
	//window.onKeyDown=ClipBoardClear();
});

function doOverSeaETC() { //해외국내 기타

    win_prgid = window.open("",'D05MpayHI',"toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=430,height=390,left=200,top=250");

    document.form4.year.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form4.month.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form4.action = "<%= WebUtil.JspURL %>D/D05Mpay/D05OverseaEtcPop.jsp";
    document.form4.target = "D05MpayHI" ;
    document.form4.submit();
    win_prgid.focus();

}
function doSubmit() {
    if( check_data() ) {
        document.form2.jobid.value  = "<%="Y".equals(backBtn)?"search_back":"search" %>";
        document.form2.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
        document.form2.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
        document.form2.ocrsn.value  = document.form1.ZOCRSN.value;
//      document.form2.seqnr.value  = document.form1.seqnr.value;
        document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailSV";
        document.form2.target = "menuContentIframe";
        document.form2.method = "post";
       // document.f.form2.target = "menuContentIframe";
        blockFrame();
        document.form2.submit();
    }
}

function doSogub() {    // 소급내역
    document.form3.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form3.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form3.ocrsn1.value = document.form1.ZOCRSN.value;
//  document.form3.seqnr1.value = document.form1.seqnr.value;
    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D08RetroDetailSV";
    document.form3.method = "post";
    document.form3.submit();
}

//2003.04.22 - 석유화학 요청으로 사원건강보험료조정 (최종)이 있는경우 임금유형 텍스트를 클릭시 정산세부내역을 POP-UP창으로 보여줌.
function doPopupDis(bet02) {
    small_window=window.open("<%= WebUtil.JspURL %>D/D05Mpay/D05HealthInsPop.jsp?I_PERNR=<%= user.empNo %>&I_YEAR=<%= year %>&BET02="+bet02,"D05MpayHI",
    		"toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=420,height=148,left=200,top=250");
    small_window.focus();
}
//2003.04.22 - 석유화학 요청으로 사원건강보험료조정 (최종)이 있는경우 임금유형 텍스트를 클릭시 정산세부내역을 POP-UP창으로 보여줌.

function kubya() {
    window.open('', 'mpayPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=680,height=660");
    document.form2.jobid.value  = "kubya_1";
    document.form2.target = "mpayPrintWindow";
    document.form2.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form2.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form2.ocrsn.value  = document.form1.ZOCRSN.value;
//  document.form2.seqnr.value  = document.form1.seqnr.value;
    document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailSV";
    document.form2.method = "post";
    document.form2.submit();
}

function zocrsn_get() {
    document.form1.jobid.value = "getcode";
    document.form1.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D05Mpay.D05MpayDetailSV";
    document.form1.target = "hidden";
    document.form1.method = "post";
    document.form1.submit();
}

function check_data(){
    c_year = "<%=DataUtil.getCurrentYear()%>";

    c_month = "<%=DataUtil.getCurrentMonth()%>";
    year1 = document.form1.year.options[document.form1.year.selectedIndex].text;
    month1 = document.form1.month.value;

    if(year1 > c_year){
        alert("<%=g.getMessage("MSG.D.D05.0001")%> ");  //현재 년도보다 큽니다.
        form1.year.focus();
        return false;
    } else if(year1 == c_year && month1 > parseFloat(c_month)){
        alert("<%=g.getMessage("MSG.D.D05.0002")%>");    //현재 월보다 큽니다.
        form1.month.focus();
        return false;
    }

    return true;
}

// [CSR ID:2995203]@v1.4 연급여 링크
function doPayment() {

    date1 = new Date();
    n_month = date1.getMonth()+1;

    document.form3.jobid.value  =  "<%="Y".equals(backBtn)?"search_back":"search" %>";
    document.form3.from_year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form3.from_month1.value = "01";   // 시작월은 항상 01월로 한다.
    document.form3.to_year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    if(n_month < 10) {
        document.form3.to_month1.value = "0"+n_month;  // 현재월까지를 보낸다.
    }else{
        document.form3.to_month1.value = n_month;  // 현재월까지를 보낸다.
    }

    document.form3.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayDetail_to_yearSV";
    document.form3.method = "post";
    document.form3.submit();
}
// [CSR ID:2995203]@v1.4 보상명세서  링크
function doTotCompensation() {
    document.form2.target = "_self";
    document.form2.year1.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form2.month1.value = document.form1.month.options[document.form1.month.selectedIndex].text;
    //alert("document.form2.year1.value:"+document.form2.year1.value);
    //alert("document.form2.month1.value:"+document.form2.month1.value);
    document.form2.action = "<%= WebUtil.JspURL %>D/D05Mpay/D05CompensationDetail.jsp?type=I";//본인결과 조회 시 파라미터 넘겨서 본인정보 조회할 수 있게 함.
    document.form2.method = "post";
    document.form2.submit();
}
//-->
</script>

<style type="text/css">
  .tds2 {  font-size: 7pt;background-color: #FFFFFF; text-align: right; color: #585858; padding-top: 0px; padding-left: 5px; height:12px; vertical-align: text-top;}
  .commentImportant{width:920px;}
  .subWrapper {width:950px;}
</style>


<form name="form1" method="post">

<% //@v1.3
   String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( user.empNo );
  //[CSR ID:3010670] 임금인상 관련 작업 시 월/연급여 조회 사용불가 기능 해제요청
  //O_CHECK_FLAG = "Do not Use";//해당 flag 월급여 화면에서 사용하지 않음.

   if ("N".equals(O_CHECK_FLAG) ) {
       // ※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.
       // 하단으로 이동
%>
<p><spring:message code="LABEL.D.D05.0099" /></p>		<!-- 급여작업으로 인해 메뉴 사용을 일시 중지합니다. -->
<%
   } else {  //@v1.3 else
%>


  <!-- 상단 검색테이블 시작-->
  <div class="tableArea" >
    <div class="table">
      <table class="tableGeneral">
      	<colgroup>
      	<col width=15%/>
      	<col width=25%/>
      	<col width=15%/>
      	<col width=15%/>
      	<col width=15%/>
      	<col width=15%/>
      	</colgroup>
        <tr>
          <th width="100"><spring:message code="LABEL.D.D05.0002"/></th> <!-- 해당년월 -->
          <td colspan="4">
            <select name="year" onChange="javascript:zocrsn_get();">
              <%--= WebUtil.printOption(CodeEntity_vt, year ) --%>
<%
    for( int i = 2001 ; i <= Integer.parseInt(ableyear) ; i++ ) {
        int year1 = Integer.parseInt(year);
%>
              <option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>
            </select>
            <select name="month" onChange="javascript:zocrsn_get();">
<%
    for( int i = 1 ; i < 13 ; i++ ) {
        String temp = Integer.toString(i);
        int mon = Integer.parseInt(month);
%>
              <option value="<%= i %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
            </select>
            <select name="ZOCRSN">
<%
    for ( int i = 0 ; i < d05ZocrsnTextData_vt.size() ; i++ ) {
        D05ZocrsnTextData data4 = (D05ZocrsnTextData)d05ZocrsnTextData_vt.get(i);
        if("급여+정산".equals(data4.ZOCRTX)) {
            continue;
        } else {
%>
              <option value="<%= data4.ZOCRSN + data4.SEQNR %>" <%= ocrsn.equals(data4.ZOCRSN + data4.SEQNR) ? "selected" : ""%>><%= data4.ZOCRTX %></option>

<%
        }
    }
%>

            </select>
            <a href="javascript:doSubmit();"><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png"/></a>
          </td>
          <td class="align_right">
            <a class="inlineBtn" href="javascript:kubya();">
                <span><spring:message code="LABEL.D.D05.0003"/></span></a></td><!-- 급여명세표 -->
        </tr>
        <tr>
          <th><spring:message code="LABEL.D.D05.0004"/></th><!-- 부서명 -->
          <td><%= user.e_orgtx %></td>
          <th class="th02" width="100"><spring:message code="LABEL.D.D05.0005"/></th><!--사번  -->
          <td><%= user.empNo %></td>
          <th class="th02" width="100"><spring:message code="LABEL.D.D05.0006"/></th><!-- 성 명 -->
          <td><%= user.ename %></td>
        </tr>
        <% if (user.e_persk.equals("38")) { %>
        <!--[CSR ID:1438060][CSR ID:2583411]-->
        <tr>
          <th><spring:message code="LABEL.D.D05.0007"/></th><!--급호  -->
          <td><%= d05MpayDetailData4.TRFNM %></td>
          <!-- CSRID : 2559989 일당 -> 일급 -->
          <!-- <td  width="100">일당</td> -->
          <th class='th02' width="100"><spring:message code="LABEL.D.D05.0008"/></th><!--  기본급-->
          <td colspan=3><%= d05MpayDetailData4.DYBET.equals("") ? " " : WebUtil.printNumFormat(d05MpayDetailData4.DYBET) %></td>
        </tr>
<%  } %>
      </table>
    </div>

  <!-- 상단 검색테이블 끝-->

  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="year1" value="">
  <input type="hidden" name="month1" value="">
  <input type="hidden" name="backBtn" value="<%=backBtn%>">

<!-- [CSR ID:3447340] 급여 수정 상태(PA03) 급여명세표 출력 문구 수정 요청 start -->
<%-- [CSR ID:3447340] 수정요청으로 E_RETURN의 M or F 에 따라 문구 출력되도록 수정함.
<%
    if ( d05MpayDetailData2_vt.size() == 0 ) {
%> --%>
<%
	String E_CODE = (String) request.getAttribute("E_CODE");

	if("M".equals(E_CODE)){
%>

<!-- 상단 검색테이블 시작-->
  <div class="align_center">
    <p><spring:message code="MSG.D.D05.0005" /></p> <!-- 급여작업으로 인해 일시적으로 명세표 조회가 되지 않습니다. <br>문의사항은 각 사업장 급여 담당 부서로 연락 주시기 바랍니다. -->
  </div>

<%
    } else if("F".equals(E_CODE)){
%>

	<div class="align_center">
    	<p><spring:message code="MSG.D.D05.0006" /></p> <!-- 급여결과데이터가 없습니다. -->
  	</div>

  <%-- <!-- 상단 검색테이블 시작-->
  <div class="align_center">
    <p><spring:message code="MSG.COMMON.0004" /></p> <!-- 해당하는 데이타가 존재하지 않습니다. -->
  </div> --%>
<!-- [CSR ID:3447340] 급여 수정 상태(PA03) 급여명세표 출력 문구 수정 요청 end -->
<%
    } else {
%>

<!--- [CSR ID:9999] 해외급여자  명세내역  START-->
<%
    //if( overSeaYn.equals("E") ){
    if(d05MpayDetailData1_vt.size() > 0 ){


      double bet01=0;  //총지급액 현지화
      double bet02=0;  //공제총액 현지화
      double bet03=0;  //차감지급액 현지화
      double kbet03=0;  //차감지급액 현지화
  bet01 =  Double.parseDouble(d05MpayDetailData4.BET01) / Double.parseDouble(d05MpayDetailData4.ZRATE) ;
  bet02 =  Double.parseDouble(d05MpayDetailData4.BET02) / Double.parseDouble(d05MpayDetailData4.ZRATE) ;
  bet03 =  bet01 -  bet02;
  kbet03 = Double.parseDouble(d05MpayDetailData4.BET01) - Double.parseDouble(d05MpayDetailData4.BET02);

%>

  <!--  [CSR ID:2575929] 기준환율 USD 추가 -->

  <p class="align_right"><spring:message code="LABEL.D.D05.0009" /> <!-- 기준환율 -->
    <%=d05MpayDetailData4.ZCURR%>1=KRW
    <%= WebUtil.printNum( Double.parseDouble(d05MpayDetailData4.ZRATE),"###,###.00")%>
    /<%=d05MpayDetailData4.ZCURR1%>1=KRW
    <%= WebUtil.printNum( Double.parseDouble(d05MpayDetailData4.ZRATE1),"###,###.00")%> )</p>

  <!--급여명세 테이블 시작-->
    <div class="table">
      <table class="tableGeneral">
      	<colgroup>
      	<col width=15%/>
      	<col width=25%/>
      	<col width=15%/>
      	<col width=15%/>
      	<col width=15%/>
      	<col width=15%/>
      	</colgroup>
        <tr>
          <th width="100"><spring:message code="LABEL.D.D05.0010" /></th><!-- 총지급액 -->
          <td class="align_right"><b><%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet01,"###,###.00") %></b>&nbsp;<br>(KRW <%= WebUtil.printNumFormat(d05MpayDetailData4.BET01) %>)</td>
          <th class="th02" width="100"><spring:message code="LABEL.D.D05.0011" /></th><!-- 공제총액 -->
          <td class="align_right"><b><%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet02,"###,###.00") %></b>&nbsp;<br>(KRW <%= WebUtil.printNumFormat(d05MpayDetailData5.BET02) %>)</td>
          <th class="th02" width="100"><spring:message code="LABEL.D.D05.0012" /></th><!-- 차감지급액 -->
          <td class="align_right"><b><%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet03,"###,###.00") %></b>&nbsp;<br>(KRW <%= WebUtil.printNumFormat(kbet03) %>)</td>
        </tr>
      </table>
      <p class="align_right"><spring:message code="LABEL.D.D05.0013" /></p> <!-- ( 단위 : KRW ) -->
    </div>

    <div class="table">
      <table class="mpayTable">
      	<colgroup>
      	<col width=25%/>
      	<col width=15%/>
      	<col width=25%/>
      	<col width=15%/>
      	</colgroup>
      <thead>
        <tr >
          <th><spring:message code="LABEL.D.D05.0014" /></th><!--  지급내역-->
          <th class="divide"><spring:message code="LABEL.D.D05.0015" /></th><!-- 금액 -->
          <th ><spring:message code="LABEL.D.D05.0016" /></th><!-- 공제내역 -->
          <th class="lastCol"><spring:message code="LABEL.D.D05.0015" /></th><!--금액  -->
        </tr>
        <tr>
          <td style="vertical-align:top" class="align_left" >
  <%
          for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {

              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if( !data5.LGTXT.equals("소급분총액") ) {
                if ( data5.LGTXT.equals("국내 기타")) { //
  %>
          <a href="javascript:doOverSeaETC();"><%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %></a>
                <font class="tds2"><spring:message code="LABEL.D.D05.0024" /><!--註1)--></font><br>

  <%
                }else if(data5.LGTXT.equals("익월 공제 예정액")) {// [CSR ID:2993988]
   %>
          <font color="#CC3300"><%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %></font><br>
   <%
                }else if ( data5.LGTXT.equals("해외생계비")||data5.LGTXT.equals("국외일정액")||data5.LGTXT.equals("급지휴가비")) { //  외화표시
  %>
                  <%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %><br><br>
  <%              }else  {
  %>
                      <%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %><br>
  <%
            }
              }
          }
  %>
  <%

          for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if(data5.BET01.equals("0")){
  %>
                      <!--&nbsp;<br><br>-->
  <%
              } else {
                  if( data5.LGTXT.equals("소급분총액") ) {
  %>
                      &nbsp;<br><br>
                      <a href="javascript:doSogub();"><font color="#CC3300" weight="900">
                      <%= data5.LGTXT.equals("") ? "" : data5.LGTXT%></font></a><br>
  <%
                  }
              }
          }
  %>
          </td>
          <td class="align_right divide" style="vertical-align:top" >
  <%
          for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if(!data5.LGTXT.equals("소급분총액")) {
  %>
                   <%= data5.ANZHL.equals("0") ? "　" : "("+WebUtil.printNumFormat(data5.ANZHL,1)+"시간)" %>
                   <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
  <%
          if ( data5.LGTXT.equals("해외생계비")||data5.LGTXT.equals("국외일정액")) { //  외화표시  // [CSR ID:2575929] 급지휴가비 추가(SAP데이터 해외휴가비→급지휴가비로 변경
  %>
          <%= data5.BET01.equals("0") ? "　" : "("+ d05MpayDetailData4.ZCURR + " "+WebUtil.printNum(Double.parseDouble(data5.BET01) / Double.parseDouble(d05MpayDetailData4.ZRATE),"#,###.00")+")" %>&nbsp;<br>
  <%
          }else if(data5.LGTXT.equals("급지휴가비")){//무조건 USD로 보일 수 있게 USD 환율이 적용될 수 있도록 ZCURR1, ZRATE1 추가
  %>
        <%= data5.BET01.equals("0") ? "　" : "("+ d05MpayDetailData4.ZCURR1 + " "+WebUtil.printNum(Double.parseDouble(data5.BET01) / Double.parseDouble(d05MpayDetailData4.ZRATE1),"#,###.00")+")" %>&nbsp;<br>
  <%
          }
              }
          }

          for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if(data5.LGTXT.equals("소급분총액")) {
  %>
                      &nbsp;<br><br>
                    <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
  <%
              }
          }
  %>
          </td>
          <td style="vertical-align:top"  class=" align_left">
  <%
          int v = 0;      //주택자금이자 count
          int v_cnt = 0;  //첫번째 주택자금이자 위치
          double ga = 0;  //주택자금이자 합계
          for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
              D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
              if( data2.LGTX1.equals("") && data2.BET02.equals("0") ) {
                  continue;
              } else if( data2.BET02.equals("0") ){
  %>
                      <%= data2.LGTX1 %><br>
  <%
              } else if( data2.LGTX1.equals("소급분공제총액") ) {
  %>
                      <a href="javascript:doSogub();"><font color="#CC3300" weight="900"><%= data2.LGTX1.equals("") ? "　" :  data2.LGTX1%></font></a>
  <%
              } else if (user.companyCode.equals("C100")&&( data2.LGTX1.equals("주택자금전세 (이자)") || data2.LGTX1.equals("주택자금구입(이자)") || data2.LGTX1.equals("주택자금이자공제(은행)") || data2.LGTX1.equals("주택자금이자공제_회사환원") )) {
                  v++;
                  ga += Double.parseDouble(data2.BET02);
                  if( v == 1 ) {
                      v_cnt = i;
  %>
                      <spring:message code="LABEL.D.D05.0017" /><br> <!-- 주택자금이자 -->
  <%
                  }
              } else {
                if ( data2.LGTX1.equals("사원 국민 보험료")) {
  %>
  <!--[CSR : 2591949] 각주 2번 (국민연금, 고용보험) 삭제 및 소득세, 주민세를 각주 2로 변경  -->
          <spring:message code="LABEL.D.D05.0018" /> <!--국민연금 <font class="tds2">註2)</font>--><br>
  <%              }else if ( data2.LGTX1.equals("사원 고용 보험료")) {
  %>
            <spring:message code="LABEL.D.D05.0019" /> <!--고용보험<font class="tds2">註2)</font>--><br>
  <%              }else if ( data2.LGTX1.equals("국내갑근세(해외)_개인부담")) {
  %>
            <spring:message code="LABEL.D.D05.0020" /><!--소득세--> <font class="tds2">註2)</font><br>
  <%              }else if ( data2.LGTX1.equals("국내주민세(해외)_개인부담")) {
  %>
            <spring:message code="LABEL.D.D05.0021" /><!--주민세--> <font  class="tds2">註2)</font><br>

  <%              }else if ( data2.LGTX1.equals("해외급여 국외입금분")) {//  외화표시
  %>
                      <%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %><br><br>

  <%
              }else if(data2.LGTX1.equals("전월 이월 공제액")) {// [CSR ID:3018046]
%>                  <font color="#CC3300"><%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %></font><br>
<%          }else  {
  %>
                      <%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %><br>
  <%
                  }
              }
          }
  %>
          </td>
          <td class="align_right" style="vertical-align:top" >
  <%
          for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
              D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
              if( data2.LGTX1.equals("") && data2.BET02.equals("0") ) {
                  continue;
              } else if (user.companyCode.equals("C100")&&( data2.LGTX1.equals("주택자금전세 (이자)") || data2.LGTX1.equals("주택자금구입(이자)") || data2.LGTX1.equals("주택자금이자공제(은행)") || data2.LGTX1.equals("주택자금이자공제_회사환원")) ) {
                  if( i == v_cnt ) {
  %>
                    <%= WebUtil.printNumFormat(Double.toString(ga)) %>&nbsp;<br>
  <%
                  }
              } else {
  %>
                     <%= data2.BET02.equals("0") ? "0" :WebUtil.printNumFormat(data2.BET02) %>&nbsp;<br>
  <%               if ( data2.LGTX1.equals("해외급여 국외입금분")) { //  외화표시

  %>
          <%= data2.BET02.equals("0") ? "　" : "("+ d05MpayDetailData4.ZCURR + " "+WebUtil.printNum(Double.parseDouble(data2.BET02) / Double.parseDouble(d05MpayDetailData4.ZRATE),"###,###.00")+")" %>&nbsp;<br>
  <%
             }
              }
          }
  %>
          </td>
        </tr>
        <tr class="sumRow">
          <td><spring:message code="LABEL.D.D05.0022" /></td><!--  지급계-->
          <td class="align_right divide">
            <%= WebUtil.printNumFormat(d05MpayDetailData5.BET01) %>&nbsp;<br>
            (<%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet01,"###,###.00") %>)</b>&nbsp;
          </td>
          <td ><spring:message code="LABEL.D.D05.0023" /></td><!-- 공제계 -->
          <td class="lastCol align_right">
            <%= WebUtil.printNumFormat(d05MpayDetailData5.BET02) %>&nbsp;<br>
            (<%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet02,"###,###.00") %>)</b>&nbsp;
          </td>
        </tr>
        </thead>
      </table>
    </div>

  <table>
    <tr>
      <td width="400" valign=top>
        <font class="tds2"><spring:message code="LABEL.D.D05.0024" /></font> <!--  주1) -->
        <spring:message code="LABEL.D.D05.0025" /><br><br>           <!-- 국내 기본급 및 상여금 - (국내 생계비 + 국내 주택비) -->
        <spring:message code="LABEL.D.D05.0026" />                       <!-- ※ 자세한 내역은 클릭하시면 확인할 수 있습니다. --></font>
      </td>
      <td width="480">
        <!--   [CSR ID:2591949] 2번 각주 삭제 및 3번 각주가 2번 각주로 수정.            註2)</font> 국민연금/고용보험 : 연중 2회 합산 납부(6, 12월)<br> -->
        <font  class="tds2"><spring:message code="LABEL.D.D05.0027" /></font>
        <spring:message code="LABEL.D.D05.0028" /> <br>         <!--  주2) 해외발생 개인 소득세는 회사에서 전액 보전.-->
        <span style="padding:5px"><spring:message code="LABEL.D.D05.0029" /></span><br><br>      <!-- 단, 국내 연봉을 기준으로 소득세/주민세를 산정하여 매월 원천징수. -->
        <spring:message code="LABEL.D.D05.0030" /><!-- ※ 건강보험은 해외파견시 지역보험으로 전환되며, 해외 파견기간 동안 -->
        <span style="padding:8px"></span><br></font>    <!-- 한시적 면제 -->
<%
if(d05MpayDetailData4.ABROAD.equals("B") || d05MpayDetailData4.ABROAD.equals("C")){
%>
        <b>
        <font color="#CC3300">
            <spring:message code="LABEL.D.D05.0032" /><br>                                               <!-- ※ 국민연금/고용보험 : 당사에서 공단에 선납부후, 연중 2회 -->
            <span style="padding:8px"></span><spring:message code="LABEL.D.D05.0033" />      <!-- (상반기,하반기) 개인에게 송금요청 함 -->
        </font></b><br>
<%} %>
      </td>
    </tr>
  </table>

  <div class="commentsMoreThan2">
<%
//[CSR ID:2993988] 월급여명세서 문구 추가 요청
//[CSR ID:3018046] 급여명세서 문구 수정요청
String addTaxInfo = "N";//익월 공제 예정액
String carriedForward = "N";//전월 이월 공제액
for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
  D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
  if( data5.LGTXT.equals("익월 공제 예정액") ) {
    addTaxInfo = "Y";
  }
}

for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
  D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
  if( data2.LGTX1.equals("전월 이월 공제액") ) {
    carriedForward = "Y";
  }
}
if(addTaxInfo.equals("Y")){
%>
    <div><spring:message code="LABEL.D.D05.0034" /> </div>   <!-- 익월 공제 예정액 : 당월 지급액 대비 공제액이 초과하여 익월로 공제액이 이월되는 금액임 -->
<%}
if(carriedForward.equals("Y")){
%>
    <div><spring:message code="LABEL.D.D05.0035" /> </div>   <!-- 전월 이월 공제액 : 전월 급/상여 명세서에 반영된 익월 공제 예정액으로 당월 급여에 조정되는 금액임 -->
<%} %>



<!--- [CSR ID:9999] 해외급여자  명세내역    END-->
<%
    } else {  //국내사용자 : 해외급여자 아닌경우  START
%>
  <!--2014-07-24-->
<%
    if ( user.e_persk.equals("38")  &&year.equals("2014") && month.equals("07") ) {
%>
    <div><spring:message code="LABEL.D.D05.0036" /></div>    <!-- 월급제 시행에 따른 급여기산일 변경으로 6월 21일부터 6월 30일까지 근로에 대한 임금(기본급, 직책수당, 자격수당)은 7월 급여에 합산 지급함 -->
<%
     }
%>
  </div>

  <!--급여명세 테이블 시작-->
    <div class="table">
      <table class="tableGeneral">
      	<colgroup>
      	<col width=15%/>
      	<col width=25%/>
      	<col width=15%/>
      	<col width=15%/>
      	<col width=15%/>
      	<col width=15%/>
      	</colgroup>
        <tr>
          <th width="100"><spring:message code="LABEL.D.D05.0010" /></th>                        <!-- 총지급액 -->
          <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData4.BET01) %>&nbsp;</td>
          <th class="th02" width="100"><spring:message code="LABEL.D.D05.0011" /></th>       <!-- 공제총액 -->
          <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02) %>&nbsp;</td>
          <th class="th02" width="100"><spring:message code="LABEL.D.D05.0012" /></th>       <!--차감지급액 -->
          <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData4.BET03) %>&nbsp;</td>
        </tr>
      </table>
    </div>

    <div class="table">
      <table class="mpayTable">
      	<colgroup>
      	<col width=30%/>
      	<col width=10%/>
      	<col width=15%/>
      	<col width=30%/>
      	<col width=15%/>
      	</colgroup>
      <thead>
        <tr>
          <th><spring:message code="LABEL.D.D05.0014" /></th>        				<!--지급내역 -->
          <th><spring:message code="LABEL.D.D05.0037" /></th>						<!-- 시간, % -->
          <th class="divide"><spring:message code="LABEL.D.D05.0015" /></th>   	<!-- 금액 -->
          <th><spring:message code="LABEL.D.D05.0016" /></th>                    	<!--  공제내역-->
          <th class="lastCol"><spring:message code="LABEL.D.D05.0015" /></th>    <!-- 금액 -->
        </tr>
        <tr >
          <td class="align_left" style="vertical-align: top;">
  <%
          for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if( !data5.LGTXT.equals("소급분총액") ) {
  %>

  <%              // 성과급 중, 30만원 해당임금에 대해 생산성향상금으로 표시(임시). 2004.7.20. mkbae.
                  if(data5.LGTXT.equals("성과급")&&data5.BET01.equals("300000.00")) {
  %>
                      <spring:message code="LABEL.D.D05.0100" /> <!--생산성향상금--><br>
  <%
                  }else if(data5.LGTXT.equals("익월 공제 예정액")) {// [CSR ID:2993988]

  %>
                    <font color="#CC3300" ><%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %></font><br>

  <%//--------------------------------예외 시작--------------------------------- [CSR ID:3589279] 임시적용
                  }else if(data5.LGTXT.equals("일급계")&& Integer.parseInt(year) >=  2018 && (user.empNo.equals("00219375")||user.empNo.equals("00219376")||user.empNo.equals("00219377")||user.empNo.equals("00224131")||user.empNo.equals("00224132"))) {
  %>
                    		<%= data5.LGTXT.equals("") ? "　" : "월급" %><br>
  <%//----------------------예외 끝---------------------------------
                  }else {
  %>
                      <%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %><br>
  <%
                  }
              }
          }
  %>
  <%

          for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              String kibon_text = "";
              if( data5.LGTXT.length() > 3 ) {
                  kibon_text = data5.LGTXT.substring(0,3);
              } else {
                  kibon_text = data5.LGTXT;
              }

              if( kibon_text.equals("기본급") || kibon_text.equals("급여소") || kibon_text.equals("청구") ) {
                  k_yn = "Y";
              }
          }

          for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if(data5.BET01.equals("0")){
  %>
                      &nbsp;<br><br>
  <%
              } else {
                  if( data5.LGTXT.equals("소급분총액") ) {  //k_yn.equals("Y") && 제거.
  %>
                      &nbsp;<br><br>
                      <a href="javascript:doSogub();"><font color="#CC3300" weight="900"><%= data5.LGTXT.equals("") ? "" : data5.LGTXT%></font></a><br>
  <%
                  }
              }
          }
  %>
            </td>
            <td class="align_right" style="vertical-align: top;">
  <%
          for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if(!data5.LGTXT.equals("소급분총액")) {
            	//--------------------------------예외 시작--------------------------------- [CSR ID:3589279] 임시적용
              	if(data5.LGTXT.equals("일급계")&& Integer.parseInt(year) >=  2018 && (user.empNo.equals("00219375")||user.empNo.equals("00219376")||user.empNo.equals("00219377")||user.empNo.equals("00224131")||user.empNo.equals("00224132"))) {
              		temp_time = Double.parseDouble(data5.ANZHL);
%>
					<%= data5.ANZHL.equals("0")||data5.ANZHL.equals("0.0") ? "　" : "  " %>&nbsp;<br>
<%
              	}else {//--------------------------------예외 끝-----------------------------------
  %>
                      <%= data5.ANZHL.equals("0")||data5.ANZHL.equals("0.0") ? "　" : WebUtil.printNumFormat(data5.ANZHL,1) %>&nbsp;<br>
  <%
              	}//else  [CSR ID:3589279] 임시적용
              }//if 소급분 총액 X
          }//for

          for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if(data5.LGTXT.equals("소급분총액")) {
  %>
                      <%= data5.ANZHL.equals("0") ? "　" : WebUtil.printNumFormat(data5.ANZHL,1) %>&nbsp;<br>
  <%
              }
          }
  %>
            </td>
            <td class="divide align_right" style="vertical-align: top;">
  <%
          for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if(!data5.LGTXT.equals("소급분총액")) {
  %>
                      <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
  <%
              }
          }

          for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
              D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
              if(data5.LGTXT.equals("소급분총액")) {
  %>
                      &nbsp;<br><br>
                      <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
  <%
              }
          }
  %>
            </td>
            <td class="align_left" style="vertical-align: top;">
  <%
          int v = 0;      //주택자금이자 count
          int v_cnt = 0;  //첫번째 주택자금이자 위치
          double ga = 0;  //주택자금이자 합계
          for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
              D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
              if( data2.LGTX1.equals("") && data2.BET02.equals("0") ) {
                  continue;
              } else if( data2.BET02.equals("0") ){
  %>
                      <%= data2.LGTX1 %><br>
  <%
              } else if( data2.LGTX1.equals("소급분공제총액") ) {
  %>
                      <a href="javascript:doSogub();"><font color="#CC3300" weight="900"><%= data2.LGTX1.equals("") ? "　" :  data2.LGTX1%></font></a>
  <%
  //2003.04.22 - 석유화학 요청으로 사원건강보험료조정 (최종)이 있는경우 임금유형 텍스트를 클릭시 정산세부내역을 POP-UP창으로 보여줌.
              } else if ( user.companyCode.equals("N100") && data2.LGTX1.equals("사원건강보험료조정 (최종)") ) {
  %>
                      <a href="javascript:doPopupDis(<%= data2.BET02 %>);"><font color="#CC3300" weight="900"><%= data2.LGTX1.equals("") ? "　" :  data2.LGTX1%></font></a>
  <%
              } else if (user.companyCode.equals("C100")&&( data2.LGTX1.equals("주택자금전세 (이자)") || data2.LGTX1.equals("주택자금구입(이자)") || data2.LGTX1.equals("주택자금이자공제(은행)") || data2.LGTX1.equals("주택자금이자공제_회사환원") )) {
                  v++;
                  ga += Double.parseDouble(data2.BET02);
                  if( v == 1 ) {
                      v_cnt = i;
  %>
                      <spring:message code="LABEL.D.D05.0017" /><br> <!-- 주택자금이자 -->
  <%
                  }
              }else if(data2.LGTX1.equals("전월 이월 공제액")) {// [CSR ID:3018046]
%>                <font color="#CC3300"><%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %></font><br>
<%
              } else {
  %>
                      <%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %><br>
  <%
              }
          }
  %>
            </td>
            <td class="lastCol align_right" style="vertical-align: top;">
  <%
          for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
              D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
              if( data2.LGTX1.equals("") && data2.BET02.equals("0") ) {
                  continue;
              } else if (user.companyCode.equals("C100")&&( data2.LGTX1.equals("주택자금전세 (이자)") || data2.LGTX1.equals("주택자금구입(이자)") || data2.LGTX1.equals("주택자금이자공제(은행)") || data2.LGTX1.equals("주택자금이자공제_회사환원")) ) {
                  if( i == v_cnt ) {
  %>
                      <%= WebUtil.printNumFormat(Double.toString(ga)) %>&nbsp;<br>
  <%
                  }
              } else {
  %>
                      <%= data2.BET02.equals("0") ? "0" :WebUtil.printNumFormat(data2.BET02) %>&nbsp;<br>

  <%
              }
          }
  %>
          </td>
        </tr>
        <tr class="sumRow">
          <td><spring:message code="LABEL.D.D05.0022" /></td>		<!-- 지급계 -->
<%
//--------------------------------예외 시작--------------------------------- [CSR ID:3589279] 임시적용
	if(temp_time > 0.0) {// 일급계 값이 있어서, 시간 값을 저장 하였을 경우,
		temp_times = Double.parseDouble(d05MpayDetailData5.ANZHL);
		temp_times -= temp_time;
%>
		 <td class="align_right"><%= d05MpayDetailData5.ANZHL.equals("0") ? "" : WebUtil.printNumFormat(temp_times,1) %></td>
<%
}else{//------------------예외 끝---------------------------------------------%>
          <td class="align_right"><%= d05MpayDetailData5.ANZHL.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData5.ANZHL,1) %></td>
<%}//[CSR ID:3589279] 임시적용 %>

          <td class="divide align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET01) %>&nbsp;</td>
          <td><spring:message code="LABEL.D.D05.0023" /></td>		<!--  공제계-->
          <td class="lastCol align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02) %><%--= WebUtil.printNumFormat(d05MpayDetailData5.BET02) --%>&nbsp;</td>
        </tr>
        </thead>
      </table>


  <div class="commentsMoreThan2">
<%
//[CSR ID:2993988] 월급여명세서 문구 추가 요청
//[CSR ID:3018046] 급여명세서 문구 수정요청
String addTaxInfo = "N";//익월 공제 예정액
String carriedForward = "N";//전월 이월 공제액
for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
    D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
    if( data5.LGTXT.equals("익월 공제 예정액") ) {
      addTaxInfo = "Y";
    }
}

for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
    D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
    if( data2.LGTX1.equals("전월 이월 공제액") ) {
      carriedForward = "Y";
    }
}
if(addTaxInfo.equals("Y")){
%>
    <div><spring:message code="LABEL.D.D05.0034" /><!-- 익월 공제 예정액 : 당월 지급액 대비 공제액이 초과하여 익월로 공제액이 이월되는 금액임 -->
    </div>
<%}
if(carriedForward.equals("Y")){
%>
    <div><spring:message code="LABEL.D.D05.0035" /><!-- 전월 이월 공제액 : 전월 급/상여 명세서에 반영된 익월 공제 예정액으로 당월 급여에 조정되는 금액임 -->
    </div>
<%} %>

  </div>


<%
    }  //해외급여자 아닌경우  END
%>


<!--   //[CSR ID:3744002]  start-->
<%
	if(Integer.parseInt(yymm) >= 201807 ){
        if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {//월급여 + TOTAL
            if(user.e_persk.equals("21") || user.e_persk.equals("22") || (user.e_persk.equals("24") && !user.e_jikkb.equals("AC0")) ){//계약직 중, 사외이사는 제외
%>            	
  <div class="commentsMoreThan2">
       <div>기본급은 고정O/T수당(20시간)이 포함된 금액입니다.</div>
  </div>

<%            
    }}}
%>
<!--   //[CSR ID:3744002]  end-->

<%
    if ( user.e_persk.equals("38")  &&year.equals("2014") && month.equals("07") ) {
%>
  <div class="commentsMoreThan2">
       <div><spring:message code="LABEL.D.D05.0038" /><!-- 기본급, 직책수당, 자격수당 : 6/21~6/30 기준 + 7/1~7/31 기준 --></div>
       <div><spring:message code="LABEL.D.D05.0039" /><!-- 시간외 근로수당 : 6/21~7/20 기준--></div>
       <div><spring:message code="LABEL.D.D05.0040" /><!-- 소급분총액 : 2/21~6/20 기준--></div>
  </div>
<%
     }
%>
  </div>



<%
        if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {//월급여 + TOTAL
            if(d05MpayDetailData4_vt.size() != 0 && dis_play.equals("Y") && d05MpayDetailData5_vt.size() != 0){
%>

  <h2 class="subtitle"> <spring:message code="LABEL.D.D05.0050" /></h2>		<!-- 과세추가 내역 -->

    <div class="table">
      <table class="tableGeneral">
      <colgroup>
	      <col width=25% />
	      <col width=25% />
	      <col width=25% />
	      <col />
      </colgroup>
      <tbody>
        <tr>
<%
			String tax10_text = "";
			String tax10_value = "";
			String refond_txt="";
			String refond_value="";
          	for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
	              D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
	              String kase_text = "";
	              String kase_text2 = "";

	              if( data4.LGTX1.length() > 3 ) {
	                  kase_text = data4.LGTX1.substring(0,4);
	                  kase_text2 = data4.LGTX1.substring(0,3);
	              } else {
	                  kase_text = data4.LGTX1 ;
	                  kase_text2 = data4.LGTX1 ;
	              }

	              //[CSR ID:3393138]
	              //[CSR ID:3493623]
	              //if ( kase_text.equals("과세반영") ||  kase_text.equals("G6 상")) {//[CSR ID:3440096]
	              if ( kase_text.equals("과세반영") || (!kase_text2.equals("소급분") && data4.LGTX1.indexOf("과세반영")>-1)) {
	            	  if(!data4.BET01.equals("0")) {
		            	  tax10_text += data4.LGTX1.equals("") ? "" : (data4.LGTX1 + "&nbsp;<br>");
		            	  tax10_value += data4.BET01.equals("0") ? "" : (WebUtil.printNumFormat(data4.BET01)+"&nbsp;<br>");
	            	  }
	              }

	              if ( kase_text2.equals("소급분")) {
	                  if(!data4.BET01.equals("0")) {
	                	  refond_txt += data4.LGTX1.equals("") ? "" : (data4.LGTX1 +"&nbsp;<br>");
	                	  refond_value += data4.LGTX1.equals("") ? "" : (WebUtil.printNumFormat(data4.BET01) +"&nbsp;<br>");
	                  }
	              } else {
	                  continue;
	              }

          }
          %>
          <th  >          	<%=tax10_text%>          </th>
          <td class="align_right th02">          	<%=tax10_value %>       </td>

          <th class="th02">		<%=refond_txt%>          </th>
          <td class="align_right lastCol">						<%=refond_value %>          </td>


        </tr>
        </tbody>
      </table>
    </div>

<%
            }
        }
%>

<%
        // [CSR ID:9999] 2013.09.10 부터 해외급여자는 이부분 제거
    if( overSeaYn.equals("E999") ){
      // if(d05MpayDetailData1_vt.size() == 9999){
%>

  <h2 class="subtitle"><spring:message code="LABEL.D.D05.0060" /><!--  해외급여 반영내역 --></h2>

<%
            if(d05MpayDetailData4.ZRATE.equals("0")) {
%>
                  <td  width="150"><spring:message code="LABEL.D.D05.0061" />&nbsp;</td>		<!-- 환율 :  -->
<%
            } else {
                String zrate = d05MpayDetailData4.ZRATE.substring(0,5)+d05MpayDetailData4.ZRATE.substring(5,7);
%>
                  <td  width="150"><spring:message code="LABEL.D.D05.0061" />&nbsp;<%= zrate %></td>
<%
            }
%>
                  <td ><spring:message code="LABEL.D.D05.0062" /><!-- 사용통화 :  -->&nbsp;<%= d05MpayDetailData4.ZCURR %></td>

    <div class="table">
      <table class="tableGeneral">
        <tr>
          <th width="140"><spring:message code="LABEL.D.D05.0063" /></th>		<!-- 국내생계비 -->
          <td class="align_right"><%= d05MpayDetailData4.BET04.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET04) %>&nbsp;</td>
          <th class="th02" width="140"><spring:message code="LABEL.D.D05.0064" /></th>	<!--  국내주택비-->
          <td class="align_right"><%= d05MpayDetailData4.BET05.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET05) %>&nbsp;</td>
          <th class="th02" width="140"><spring:message code="LABEL.D.D05.0065" /></th>		<!-- 국내총액 -->
          <td class="align_right"><%= d05MpayDetailData4.BET06.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET06) %>&nbsp;</td>
        </tr>
        <tr>
          <th><spring:message code="LABEL.D.D05.0066" /></th>	<!-- 국내갑근세(개인부담) -->
          <td class="align_right"><%= d05MpayDetailData4.BET07.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET07) %>&nbsp;</td>
          <th class="th02"><spring:message code="LABEL.D.D05.0067" /></th>	<!-- 국내주민세(개인부담) -->
          <td class="align_right"><%= d05MpayDetailData4.BET08.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET08) %>&nbsp;</td>
          <th class="th02" rowspan=2><spring:message code="LABEL.D.D05.0068" /></th>	<!--세후총액  -->
          <td rowspan=2 align="right"><%= d05MpayDetailData4.BET09.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET09) %>&nbsp;</td>
        </tr>
        <tr>
          <th><spring:message code="LABEL.D.D05.0069" /></th>	<!-- 국내갑근세(회사부담) -->
          <td class="align_right"><font color="blue"><%= d05MpayDetailData4.BET20.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET20) %></font>&nbsp;</td>
          <th class="th02"><spring:message code="LABEL.D.D05.0070" /></th>	<!-- 국내주민세(회사부담) -->
          <td class="align_right"><font color="blue"><%= d05MpayDetailData4.BET21.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET21) %></font>&nbsp;</td>
        </tr>

        <!-- 급여명세표에서 출력부분되는 월급여 화면에도 출력. 2008-07-29 김정인. -->
        <tr>
          <th><spring:message code="LABEL.D.D05.0071" /></th>	<!--  해외수당-->
          <td class="align_right"><%= d05MpayDetailData4.BET10.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET10) %>&nbsp;</td>
          <th class="th02"><spring:message code="LABEL.D.D05.0072" /></th>	<!--급지수당  -->
          <td class="align_right"><%= d05MpayDetailData4.BET11.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET11) %>&nbsp;</td>
          <th class="th02"><spring:message code="LABEL.D.D05.0073" /></th>	<!--국내NET  -->
          <td class="align_right"><%= d05MpayDetailData4.BET12.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET12) %>&nbsp;</td>
        </tr>
        <!-- ------------------------------------------------------------------- -->

        <tr>
          <td ><spring:message code="LABEL.D.D05.0080" /></td>		<!-- 항목-->
          <td ><spring:message code="LABEL.D.D05.0015" /></td>		<!-- 금액 -->
          <td ><spring:message code="LABEL.D.D05.0074" /></td>		<!-- 현지화-->
          <td ><spring:message code="LABEL.D.D05.0080" /></td>		<!-- 항목 -->
          <td ><spring:message code="LABEL.D.D05.0015" /></td>		<!-- 금액  -->
          <td ><spring:message code="LABEL.D.D05.0074" /></td>		<!-- 현지화 -->
        </tr>
        <tr>
          <td width="140" height="80" >
<%
            for ( int i = 0 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
                D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                    <%= data6.LGTXT %><br>
<%
            }
%>
                  </td>
                  <td  height="80" align="right">
<%
            for ( int i = 0 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
                D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                    <%= data6.BET01.equals("0") ? "" : WebUtil.printNumFormat(data6.BET01) %>&nbsp;<br>
<%
            }
%>
                  </td>
                  <td  height="80" align="right">
<%
            for ( int i = 0 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
                D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                    <%= data6.BET03.equals("0") ? "" : WebUtil.printNumFormat(data6.BET03,2) %>&nbsp;<br>
<%
            }
%>
                  </td>
                  <td  height="80">
<%
            for ( int i = 1 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
                D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                    <%= data6.LGTXT %>&nbsp;<br>
<%
            }
%>
                  </td>
                  <td  height="80" align="right">
<%
            for ( int i = 1 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
                D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                    <%= data6.BET01.equals("0") ? "" : WebUtil.printNumFormat(data6.BET01) %>&nbsp;<br>
<%
            }
%>
                  </td>
                  <td  height="80" align="right">
<%
            for ( int i = 1 ; i < d05MpayDetailData6_vt.size() ; i = i+2 ) {
                D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
                    <%= data6.BET03.equals("0") ? "" : WebUtil.printNumFormat(data6.BET03,2) %>&nbsp;<br>
<%
            }
%>
          </td>
        </tr>
        <tr>
          <th><spring:message code="LABEL.D.D05.0010" /></th>		<!--  총지급액-->
          <td class="align_right"><%= d05MpayDetailData4.BET01.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET01) %>&nbsp;</td>
          <td>&nbsp;</td>
          <th class="th02"><spring:message code="LABEL.D.D05.0076" /></th>		<!-- 국내입금액 -->
          <td class="align_right"><%= d05MpayDetailData4.BET13.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET13) %>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <th><spring:message code="LABEL.D.D05.0077" /></th>		<!-- 총공제액 -->
          <td class="align_right"><%= d05MpayDetailData4.BET02.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET02) %>&nbsp;</td>
          <td>&nbsp;</td>
          <th><spring:message code="LABEL.D.D05.0078" /></th>		<!-- 해외송금액 -->
          <td class="align_right"><%= d05MpayDetailData4.BET14.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET14) %>&nbsp;</td>
          <td class="align_right"><%= d05MpayDetailData4.BET15.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData4.BET15) %>&nbsp;</td>
        </tr>
      </table>
      <span class="commentOne"><spring:message code="LABEL.D.D05.0079" /></span>		<!-- 국내갑근세(회사부담)&국내주민세(회사부담)은 세금보전액에 합산되어짐 -->
    </div>

<%
        }
%>


<%
    String DispFlag="false";
    // 공수 : 33:기능직,34 && 가공공장만 조회
    //[CSR ID:2583929] 생산기술직 38 추가
    if ( (user.e_persk.equals("33") || user.e_persk.equals("38") ||user.e_persk.equals("34") ) && user.e_werks.equals("BB00")   ) {
          DispFlag = "true";
    }
        if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {//월급여 + TOTAL
%>

  <h2 class="subtitle"><spring:message code="LABEL.D.D05.0081" /></h2></td>	<!-- 근태현황 -->

    <div class="table">
      <table class="tableGeneral">
      	<colgroup>
<%    if ( DispFlag.equals("true")  ) {  %>
      	<col width=12.5%/>
      	<col width=12.5%/>
      	<col width=12.5%/>
      	<col width=12.5%/>
      	<col width=12.5%/>
      	<col width=12.5%/>
      	<col width=12.5%/>
      	<col width=12.5%/>
<%    }else{  %>
      	<col width=16.6%/>
      	<col width=16.6%/>
      	<col width=16.6%/>
      	<col width=16.6%/>
      	<col width=16.6%/>
      	<col width=16.6%/>
<%} %>
      	</colgroup>
        <tr>
          <th><spring:message code="LABEL.D.D05.0082" /></th>	<!-- 근태일수 -->
          <td class="align_right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK01),0) %>&nbsp;</td>
<%    if ( DispFlag.equals("true")  ) {  %>
          <th class="th02"><spring:message code="LABEL.D.D05.0083" /></th>	<!-- 공수 -->
          <!-- [CSR ID:3043406]<td  width="130" align="right">< %= WebUtil.printNumFormat(Double.parseDouble(KONGSU_HOUR),1) %>&nbsp;</td> -->
          <td class="align_right"><%= WebUtil.printNumFormat(Double.parseDouble(KONGSU_PAY),1) %>&nbsp;</td>
<%    }  %>
          <th class="th02"><spring:message code="LABEL.D.D05.0084" /></th>	<!-- 사용휴가일수 -->
          <td class="align_right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK02),1) %>&nbsp;</td>
          <th class="th02"><spring:message code="LABEL.D.D05.0085" /></th>	<!-- 잔여휴가일수 -->
<%
if (month.equals("12")) {
%>
          <td class="lastCol align_right">0.0&nbsp;</td>
<%
} else {
%>
          <td class="lastCol align_right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK03),1) %>&nbsp;</td>
<%
}
%>
        </tr>
      </table>
    </div>

<% }%>

<%
//------- [CSR ID:2995203]@v1.4---------------------------------------------------------------------------------------------------------
if ( Long.parseLong(year) >= 2012 ) {
          double ytot = 0;
          if ( d05CompensationData  != null ) {

            ytot    = Double.parseDouble(d05CompensationData.BET01) +Double.parseDouble(d05CompensationData.BET19);
%>

  <h2 class="subtitle"><%=g.getMessage("LABEL.D.D05.0086", year, month)%></h2>	<!-- [CSR ID:3038224] 년월 추가 -->
								<!-- LABEL.D.D05.0086 = 총 보상 명세표    ({0}년 01월 ~ {1}월) -->
    <div class="table">
      <table class="tableGeneral">
      <colgroup>
	      <col width=25% />
	      <col width=30% />
	      <col width=25% />
	      <col />
      </colgroup>
        <tr>
          <th><spring:message code="LABEL.D.D05.0087" /></th>	<!-- 급여/복리후생 총액 -->
          <td class="align_right" colspan=3><a href="javascript:doTotCompensation();"><font color="#CC3300" weight="900"><%= WebUtil.printNumFormat((ytot+Double.parseDouble(d05CompensationData.BET02))*100,0) %>&nbsp;</font></a></td>
        </tr>
        <tr>
          <th ><spring:message code="LABEL.D.D05.0088" /></th>	<!-- 연급여 -->
          <td class="align_right"><%= WebUtil.printNumFormat(ytot*100,0) %>&nbsp;</td>
          <th class="th02"><spring:message code="LABEL.D.D05.0089" /></th>	<!-- 복리후생 총액 -->
          <td class="align_right"><%= WebUtil.printNumFormat(DataUtil.changeLocalAmount(d05CompensationData.BET02, user.area),0)%>&nbsp;</td>
        </tr>
		</thead>
      </table>
    </div>

  <div class="commentImportant">
    <p><spring:message code="LABEL.D.D05.0090" /></p>		<!-- 상기 <B>복리후생 총액</B>은, 법정 복리후생을 포함하여 법정 外 복리후생 항목 中 개인 別로 지원된<br/>연간 누계액을 표기한 것입니다. 자세한 내역은 해당항목을 클릭하여 조회 바랍니다. -->
  </div>


<%
        }
   }

//---------------------------------------------------------------------------------------------------------------
%>

<%
    // [CSR ID:2763588] 급여명세표 수정 start
%>
<!-- 급여 공지사항 시작 -->
<%
if(yymm.equals("201506")){
  if(user.e_persk.equals("31")){
%>

  <div class="commentsMoreThan2">
    <p><strong><spring:message code="LABEL.D.D05.0091" /></strong></p>		<!-- 공지사항 -->

<%
    // 31:전문기술직,32:지도직,33:기능직
    // [CSR ID:2583929] 생산기술직 38 추가
    if( !"N".equals(O_CHECK_FLAG) && (user.e_persk.equals("31") ||user.e_persk.equals("32")||user.e_persk.equals("33") || user.e_persk.equals("38") )) {
%>

  <div><spring:message code="LABEL.D.D15.0119" />
    <!-- 근태, 월급여, 연급여 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며,<br>이를 위반 시에는 취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려 드립니다. -->
  </div>

    }

    if("N".equals(O_CHECK_FLAG)){
%>

  <div><spring:message code="LABEL.D.D05.0093" /><!-- 급여작업으로 인해 메뉴 사용을 일시 중지합니다. --></div>

<%
    }
%>


<%}//38생산기술직만 추가되게...
}else if(1==1){ //급여명세표 안보이게...
}else{ //기존 로직
%>

  <div class="commentImportant">
    <p><span class="bold"><spring:message code="LABEL.D.D05.0091" /></span></p>			<!-- 공지사항< -->

<%if(yymm.equals("201505")){//[CSR ID:2785904] 월급여 공지사항 수정 요청 건 %>
    <p><span class="bold"><spring:message code="LABEL.D.D05.0094" /></span></p>	<!-- 차감환급소득세(급여) / 차감환급주민세(급여) -->
    <p><spring:message code="LABEL.D.D05.0095" /></p>											<!-- - 소득세법 개정에 따른 연말정산 재정산 결과 반영 -->
    <p><spring:message code="LABEL.D.D05.0096" /></p>											<!-- - 기존 추가납부 분할공제 대상자는 추가납부 금액과 재정산 금액이 합산 기표됨. -->
    <p><span class="bold"><spring:message code="LABEL.D.D05.0097" /></span></p>	<!-- 연말정산 재정산 결과 확인방법 -->
    <p><spring:message code="LABEL.D.D05.0098" /></p>											<!-- - G Portal ▶ HR Center ▶ 연말정산 ▶ "연말정산 내역조회“ -->

<%
}//5월 급여 조회때만 공지사항이 보이도록 조건 추가.

    if( !"N".equals(O_CHECK_FLAG) && (user.e_trfar.equals("02") || user.e_trfar.equals("03") || user.e_trfar.equals("04"))  ) {
%>
                                                <font color="#CC3300"><!-- ※ 개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며, <br>
                                                                                    &nbsp;&nbsp;&nbsp;&nbsp; 이를 위반시에는 취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려드립니다.<br>&nbsp;
                                                                                    //-->
                                                </font>
<%
    }

    // 31:전문기술직,32:지도직,33:기능직
    // [CSR ID:2583929] 생산기술직 38 추가
    if( !"N".equals(O_CHECK_FLAG) && (user.e_persk.equals("31") ||user.e_persk.equals("32")||user.e_persk.equals("33") || user.e_persk.equals("38") )) {
%>
                                                <font color="#CC3300"><!-- ※ 근태, 월급여, 연급여 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며,<br>
                                                                                    &nbsp;&nbsp;&nbsp;&nbsp; 이를 위반 시에는 취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려 드립니다.<br>&nbsp;
                                                                                    //-->
                                                </font>
<%
    }

    if("N".equals(O_CHECK_FLAG)){
%>
    <p><spring:message code="LABEL.D.D05.0099" /></p>		<!-- 급여작업으로 인해 메뉴 사용을 일시 중지합니다. -->
<%
    }
%>


  </div>

<%} %>
<!-- 급여  공지사항 끝 -->

<%
// [CSR ID:2763588] 급여명세표 수정 end
%>


<%
    }
%>

    <!--급여명세 테이블 시작-->

  <% } //@v1.3 end %>

<%if("Y".equals(backBtn)){ %>
<div class="buttonArea">

    <ul class="btn_crud">
        <li><a href="javascript:history.back()"><span><spring:message code="BUTTON.COMMON.BACK"></spring:message></span></a></li>
    </ul>

</div>
<div class="clear"> </div>
<%} %>

</div>
</div>
</form>

<form name="form2" method="post" action="">
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="year1" value="">
  <input type="hidden" name="month1" value="">
  <input type="hidden" name="ocrsn" value="">
  <input type="hidden" name="seqnr" value="">
  <input type="hidden" name="paydt" value="<%=paydt%>">    <!--Total -->
</form>

<form name="form3" method="post" action="">
  <input type="hidden" name="year1" value="">
  <input type="hidden" name="month1" value="">
  <input type="hidden" name="ocrsn1" value="">
  <input type="hidden" name="seqnr1" value="">

      <!--  [CSR ID:2995203]@v1.4 보상명세서 항목추가 -->
  <input type="hidden" name="from_year1" value="">
  <input type="hidden" name="from_month1" value="">
  <input type="hidden" name="to_year1" value="">
  <input type="hidden" name="to_month1" value="">
  <input type="hidden" name="jobid" value="search">
</form>

<form name="form4" method="post" action="">
  <input type="hidden" name="year" value="">
  <input type="hidden" name="month" value="">
  <input type="hidden" name="pernr" value="<%= user.empNo %>">
  <input type="hidden" name="ename" value="<%= user.ename %>">
<%
            for ( int i = 0 ; i < d05MpayDetailData6_vt.size() ; i++ ) {
                D05MpayDetailData1 data6 = (D05MpayDetailData1)d05MpayDetailData6_vt.get(i);
%>
  <input type="hidden" name="LGTXT" value="<%=data6.LGTXT%>">
  <input type="hidden" name="LGTX1" value="<%=data6.LGTX1%>">
  <input type="hidden" name="BET01" value="<%=data6.BET01%>">
  <input type="hidden" name="BET02" value="<%=data6.BET02%>">
  <input type="hidden" name="BET03" value="<%=data6.BET03%>">
<%
            }
%>
</form>

<!-- @v1.1-->
<iframe name="hidden" id="hidden" src="" width="0" height="0"></iframe>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
