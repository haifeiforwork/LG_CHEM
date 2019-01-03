<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 월급여                                                      */
/*   Program Name : 월급여                                                      */
/*   Program ID   : D05Mpayhwahak_m.jsp                                           */
/*   Description  : 급여명세표 조회                                             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  chldudgh                                        */
/*   Update       : 2005-02-01  윤정현                                          */
/* 				2014-06-18 [CSR ID:2559989] 급여명세서 문구 수정요청 */
/*                 2014-07-18 [CSR ID:2575929] 해외주재원 급여명세서 수정요청   */
/*                 2014-07-24 [CSR ID:2583411] 7월 급여명세서 문구 반영 요청   */
/*                 2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/*                 2014-07-31  [CSR ID:2584987] HR Center 경조금 신청 화면 문구 수정                                            */
/*                  2014-08-13  [CSR ID:2591949] 해외주재원 급여명세서 수정요청   /  각주수정         */
/*                  2015-04-30  [CSR ID:2763588] E-HR 급여명세표 출력관련 변경 요청의 건   */
/*                  2015-05-21  [CSR ID:2781737] 급여명세표 문구 삭제  */
/*                  2015-05-22  [CSR ID:2782595] 5월 급여 공지사항 문구 삽입 요청 */
/*                  2015-05-27  [CSR ID:2785904] 월급여 공지사항 수정 요청 건  */
/*                  2015-06-10  [CSR ID:2797885] 급여명세서 출력 화면 수정 */
/*                  2016-02-24  [CSR ID:2993988] 월급여명세서 문구 추가 요청   */
/*                  2016-02-26  [CSR ID:2995203] 보상명세서 적용(Total Compensation)   */
/*                  2016-03-23  [CSR ID:3018046] 급여명세서 문구 수정요청   */
/*                  2016-04-15  [CSR ID:3038224] 총보상명세서 수정 요청  */
/*                  2017-05-29  [CSR ID:3391262] 급여명세서 내용 수정요처의 건  */
/*                  2017-07-24 [CSR ID:3440096] 급여명세표 과세반영 로직 수정   */
/*                  2017-09-25 [CSR ID:3493623] 급여명세표 과세반영 표시 출력부분 수정요청   */
/*                  2018-01-23 rdcamel [CSR ID:3589279] 계약직(생산기술직) 월급여명세서 조회 화면 변경요청의 건   */
/*					2018-07-19  rdcamel [CSR ID:3744002] 사무직 급여명세서 추가 문구 표기 요청 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %><!--@v1.4-->
<%@ page import="hris.D.rfc.*" %>
<%
WebUserData user_m = WebUtil.getSessionMSSUser(request);

    Vector d05MpayDetailData1_vt = ( Vector ) request.getAttribute( "d05MpayDetailData1_vt" ) ; // 해외급여 반영내역(항목) 내역

    Vector d05MpayDetailData2_vt = ( Vector ) request.getAttribute( "d05MpayDetailData2_vt" ) ; // 지급내역/공제내역
//  Vector d05ZocrsnTextData_vt = ( Vector ) request.getAttribute( "d05ZocrsnTextData_vt" ) ;   // 급여사유 코드와 TEXT

    Vector d05MpayDetailData3_vt = ( Vector ) request.getAttribute( "d05MpayDetailData3_vt" ) ; // 과세추가내역
    Vector d05MpayDetailData4_vt = ( Vector ) request.getAttribute( "d05MpayDetailData4_vt" ) ; // 변형 과세추가내역

    Vector d05MpayDetailData5_vt = ( Vector ) request.getAttribute( "d05MpayDetailData5_vt" ) ; // 지급내역text
    Vector d05MpayDetailData6_vt = ( Vector ) request.getAttribute( "d05MpayDetailData6_vt" ) ; // 해외지급내역수정

    D05MpayDetailData4  d05MpayDetailData4 = (D05MpayDetailData4) request.getAttribute( "d05MpayDetailData4"  ) ; // 급여명세표 - 개인정보/환율 내역
    D05MpayDetailData5  d05MpayDetailData5 = (D05MpayDetailData5) request.getAttribute( "d05MpayDetailData5"  ) ; // 지급내역/공제내역의 합

    String year                       = ( String ) request.getAttribute("year");
    String month                      = ( String ) request.getAttribute("month");
    String ocrsn                      = ( String ) request.getAttribute("ocrsn");
    String ocrsn_t  = ocrsn.substring(0,2);

    //총공수  [CSR ID:2584987]
    D02KongsuHourRFC rfcH       = new D02KongsuHourRFC();
    String yymm = year+ month ;
    //String KONGSU_HOUR = rfcH.getHour(user.empNo,yymm);
    //[CSR ID:3043406]
    Vector kongsuVec = rfcH.getHour2(user_m.empNo,yymm);
    String KONGSU_HOUR = (String)kongsuVec.get(0);
    String KONGSU_PAY = (String)kongsuVec.get(1);

    String overSeaYn = user_m.e_werks.substring(0,1); //해외급여자여부 :E


    //-------------------------------------------------------------------------------
    // [CSR ID:2995203]@v1.4 총보상명세내역
    String begym  = year + "01" ;
    String endym  = year + month ;

    D05CompensationRFC   rfc                = new D05CompensationRFC();

    D05CompensationData d05CompensationData = (D05CompensationData)rfc.getDetail(user_m.empNo, begym, endym);
    String CurrYear =  DataUtil.getCurrentYear();
    //-------------------------------------------------------------------------------

	//[CSR ID:3589279] 예외 사번 5명의 시간 값
   	double temp_time = 0.0;// 일급계 값이 있어서, 시간 저장한 값
   	double temp_times = 0.0;// 일급계 값이 있어서, 시간 저장한 값의 계
%>


<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D05.0003"/>
    <jsp:param name="help" value="D05Mpay.html"/>
</jsp:include>

<SCRIPT LANGUAGE="JavaScript">
<!--
    function f_print(){
        self.print();
    }
//-->
</SCRIPT>


<style type="text/css">
<!--[CSR ID:2797885]-->
    body {background:#f0f0f0;}
    .payWrap {width:628px;margin:10px 0 0 5px;background:#fff url(<%= WebUtil.ImageURL %>/pay_top.jpg) no-repeat top center;padding-bottom:20px;border:solid 1px #cecece;}
    .contentWrap {width:600px;margin:0;padding-left:15px;}
    h2 {padding:60px 0 110px 0;font-family:Malgun Gothic;color;text-align:center;font-weight:normal;margin:0;font-size:29px;line-height:29px;}
    .topMent {font-family:Malgun Gothic;font-size:17px;line-height:25px;padding:0 0 50px 60px;color:#696969;}
    .topMent strong {font-weight:bold;color:#333;}
    .fixed {table-layout:fixed;}
    .table02 {background:#bababa;}
    .table02 td {background:#fff;font-family: Malgun Gothic;font-size:12px;color:#333;vertical-align:middle;padding-left:10px;}
    .table02 td.td03 {background:#f6f6f4;padding-left:0px;text-align:center;}
    .table02 td.center {padding-left:0px;text-align:center;}
    .font01 {font-family:Malgun Gothic; color:#333;font-weight:bold;font-size:14px;}
    .font02 {font-family:Malgun Gothic; color:#333;font-size:14px;}
    .font03 {font-family:Malgun Gothic; color:#CC3300;font-size:14px;}
    .font04 {font-family:Malgun Gothic; color:#CC3300;font-size:10px;}

  .tds2 {  font-size: 7pt;background-color: #FFFFFF; text-align: right; color: #585858; padding-top: 0px; padding-left: 5px; height:12px; vertical-align: middle;}

   // CSR ID:2763588 높이 20 -> 30 재정의
  /* 표사이 간격 */
  .tdSpace { height:25px;}
</style>


<div class="payWrap">
    <h2><spring:message code="LABEL.D.D05.0003"/></h2><!-- 급여명세표 -->
    <p class="topMent"><spring:message code="LABEL.D.D05.0121"/><!-- 행복한 가정과 풍요로운 삶,<br /><strong>LG화학이 항상 함께 하겠습니다.</strong> -->
    </p>
	<div class="contentWrap">

<!-- [CSR ID:2781737] 급여명세표 문구 삭제 급여 문구 부분 삭제 -->
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
	            <colgroup>
		            <col width=15%/>
		            <col width=10%/>
		            <col />
		            <col width=11%/>
		            <col width=10%/>
		            <col width=11%/>
            	</colgroup>
            <tr>
                <td><%= year %><spring:message code="LABEL.D.D15.0020"/> 
                <%= month %><spring:message code="LABEL.D.D15.0021"/></td>
                
                <th class="th02"><spring:message code="LABEL.D.D05.0004"/><!-- 부서명 --></th>
                <td><%= user_m.e_orgtx %></td>
                <th class="th02"><spring:message code="LABEL.D.D05.0005"/><!-- 사번 --></th>
                <td><%= user_m.empNo %></td>
                <th class="th02"><spring:message code="LABEL.D.D05.0006"/><!-- 성명 --></th>
                <td><%= user_m.ename %></td>
            </tr>
            <% if (user_m.e_persk.equals("38")) { %>
            <!--[CSR ID:1438060][CSR ID:2583411]-->
            <tr>
                <th><spring:message code="LABEL.D.D05.0007"/><!--급호 --></th>
                <td colspan="2"><%= d05MpayDetailData4.TRFNM %></td>
                <!-- CSRID : 2559989 일당 -> 일급 -->
                <!-- <<td width="120" >일당&nbsp;</td> -->
                <th class="th02"><spring:message code="LABEL.D.D05.0008"/><!--기본급--></th>
                <td colspan="3"><%= d05MpayDetailData4.DYBET.equals("") ? " " : WebUtil.printNumFormat(d05MpayDetailData4.DYBET) %></td>
            </tr>
                <%  } %>
        </table>
    </div>
</div>

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

<!--급여명세 테이블 시작-->
<!--  [CSR ID:2575929] 기준환율 USD 추가 -->
<div class="buttonArea">
	<spring:message code="LABEL.D.D05.0009" /> <!-- 기준환율 -->
	<%=d05MpayDetailData4.ZCURR%>1=KRW<%= WebUtil.printNum( Double.parseDouble(d05MpayDetailData4.ZRATE),"###,###.00")%>/<%=d05MpayDetailData4.ZCURR1%>1=KRW<%= WebUtil.printNum( Double.parseDouble(d05MpayDetailData4.ZRATE1),"###,###.00")%> )
	</div>

<!--급여명세 테이블 시작-->
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
            <tr>
                  <th><spring:message code="LABEL.D.D05.0010" /></th><!-- 총지급액 -->
                  <td class="align_right"><b><%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet01,"###,###.00") %></b>&nbsp;<br>(KRW <%= WebUtil.printNumFormat(d05MpayDetailData4.BET01) %>)&nbsp;</td>
                  <th class="th02"><spring:message code="LABEL.D.D05.0011" /></th><!-- 공제총액 -->
                  <td class="align_right"><b><%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet02,"###,###.00") %></b>&nbsp;<br>(KRW <%= WebUtil.printNumFormat(d05MpayDetailData5.BET02) %>)&nbsp;</td>
                  <th class="th02"><spring:message code="LABEL.D.D05.0012" /></th><!-- 차감지급액 -->
                  <td class="align_right"><b><%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet03,"###,###.00") %></b>&nbsp;<br>(KRW <%= WebUtil.printNumFormat(kbet03) %>)&nbsp;</td>
            </tr>
        </table>
    </div>
</div>

<div class="listArea">
    <div class="listTop">
        <span class="listCnt"><spring:message code="LABEL.D.D05.0013" /><!-- ( 단위 : KRW ) --></span>
    </div>
    <div class="table">
        <table class="mpayTable">
        <thead>
            <tr>
              <th><spring:message code="LABEL.D.D05.0014" /><!-- 지급내역 --></th>
              <th class="divider"><spring:message code="LABEL.D.D05.0015" /><!-- 금액 --></th>
              <th><spring:message code="LABEL.D.D05.0016" /><!-- 공제내역 --></th>
              <th class="lastCol"><spring:message code="LABEL.D.D05.0015" /><!-- 금액 --></th>
            </tr>
            <tr valign="top">
              <td class="align_left divider"  height="120" style="vertical-align: top;">
    <%
            for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
                D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
                if( !data5.LGTXT.equals("소급분총액") ) {
                    if ( data5.LGTXT.equals("국내 기타")) { //
    %>
                <%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %><font class="tds2">
                    <spring:message code="LABEL.D.D05.0024" /><!--註1)--></font><br>

    <%
                    }else if(data5.LGTXT.equals("익월 공제 예정액")) {// [CSR ID:2993988]
     %>
                    <font color="#CC3300" ><%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %></font><br>
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
                        <a href="javascript:doSogub();"><font color="#CC3300" weight="900"><%= data5.LGTXT.equals("") ? "" : data5.LGTXT%></font></a><br>
    <%
                    }
                }
            }
    %>
                      </td>
                      <td class="divider align_right" height="120" style="vertical-align: top;">
    <%
            for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
                D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
                if(!data5.LGTXT.equals("소급분총액")) {
    %>
                      <%= data5.ANZHL.equals("0") ? "　" : "("+WebUtil.printNumFormat(data5.ANZHL,1)+"시간)" %>
                        <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
    <%
                    if ( data5.LGTXT.equals("해외생계비")||data5.LGTXT.equals("국외일정액")) { //  외화표시 // [CSR ID:2575929] 급지휴가비 추가(SAP데이터 해외휴가비→급지휴가비로 변경
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
                      <td  class="align_left " height="120" style="vertical-align: top;">
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
                } else if (user_m.companyCode.equals("C100")&&( data2.LGTX1.equals("주택자금전세 (이자)") || data2.LGTX1.equals("주택자금구입(이자)") || data2.LGTX1.equals("주택자금이자공제(은행)") || data2.LGTX1.equals("주택자금이자공제_회사환원") )) {
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
                국민연금 <!--<font class="tds2">註2)</font>  --><br>
    <%              }else if ( data2.LGTX1.equals("사원 고용 보험료")) {
    %>
                고용보험 <!--<font class="tds2">註2)</font>  --><br>
    <%              }else if ( data2.LGTX1.equals("국내갑근세(해외)_개인부담")) {
    %>
                소득세 <font class="tds2">註2)</font><br>
    <%              }else if ( data2.LGTX1.equals("국내주민세(해외)_개인부담")) {
    %>
                주민세 <font class="tds2">註2)</font><br>

    <%              }else if ( data2.LGTX1.equals("해외급여 국외입금분")) {//  외화표시
    %>
                        <%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %><br><br>

    <%
                        }else if(data2.LGTX1.equals("전월 이월 공제액")) {// [CSR ID:3018046]
%>                      <font color="#CC3300"><%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %></font><br>
<%                  }else  {
    %>
                        <%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %><br>
    <%
                    }
                }
            }
    %>
                      </td>
                      <td class="align_right lastCol" height="120" style="vertical-align: top;">
    <%
            for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                if( data2.LGTX1.equals("") && data2.BET02.equals("0") ) {
                    continue;
                } else if (user_m.companyCode.equals("C100")&&( data2.LGTX1.equals("주택자금전세 (이자)") || data2.LGTX1.equals("주택자금구입(이자)") || data2.LGTX1.equals("주택자금이자공제(은행)") || data2.LGTX1.equals("주택자금이자공제_회사환원")) ) {
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
                      <td class="divider align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET01) %><br>
                      (<%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet01,"###,###.00") %>)</b>
                      </td>
                      <td><spring:message code="LABEL.D.D05.0023" /></td><!-- 공제계 -->
                      <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02) %><br>
                      (<%=d05MpayDetailData4.ZCURR%> <%= WebUtil.printNum(bet02,"###,###.00") %>)</b></td>
                    </tr>
        </thead>
        </table>
    </div>
</div>

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
<div><spring:message code="LABEL.D.D05.0035" /><!-- 전월 이월 공제액 : 전월 급/상여 명세서에 반영된 익월 공제 예정액으로 당월 급여에 조정되는 금액임-->
</div>
<%} %>

</div>

<div class="commentsMoreThan2">
    <div><spring:message code="LABEL.D.D05.0024" /> <spring:message code="LABEL.D.D05.0025" />
    <!-- 註1) 국내 기본급 및 상여금 - (국내 생계비 + 국내 주택비) -->
    </div>

	<!--     [CSR ID:2591949] 2번 각주 삭제 및 3번 각주가 2번 각주로 수정.            註2)</font> 국민연금/고용보험 : 연중 2회 합산 납부(6, 12월)<br> -->
    <div><spring:message code="LABEL.D.D05.0027" /> <spring:message code="LABEL.D.D05.0028" />
    <!-- 註2)해외발생 개인 소득세는 회사에서 전액 보전. --></div>
          <span style="padding:5px"><spring:message code="LABEL.D.D05.0029" /></span>
          <font class="font02">
          <!-- 단, 국내 연봉을 기준으로 소득세/주민세를 산정하여 매월 원천징수. -->
          <br><br>
          <spring:message code="LABEL.D.D05.0030" />
          <!-- 
                  ※ 건강보험은 해외파견시 지역보험으로 전환되며, 해외 파견기간 동안 한시적 면제 
          -->
          <br></font>
<%
if(d05MpayDetailData4.ABROAD.equals("B") || d05MpayDetailData4.ABROAD.equals("C")){
%>
                    <b><font class="font03"><spring:message code="LABEL.D.D05.0122" /><!-- ※ 국민연금/고용보험 : 당사에서 공단에 선납부후, 연중 2회(상반기,하반기) 개인에게 송금요청 함 -->
                    </font></b><br>
<%} %>

</div>


<!--- [CSR ID:9999] 해외급여자  명세내역    END-->
<%
    } else {  //국내사용자 : 해외급여자 아닌경우  START
%>

    <!--2014-07-24  [CSR ID:2584987] -->
<%

    if ( user_m.e_persk.equals("38")  &&year.equals("2014") && month.equals("07") ) {
%>

    <font color="black"><spring:message code="LABEL.D.D05.0036" />
    <!-- ▣ 월급제 시행에 따른 급여기산일 변경으로 6월 21일부터 6월 30일까지 근로에 대한 임금(기본급, 직책수당, 자격수당)은 7월 급여에 합산 지급함 -->
    </font>

<%
     }
%>


<!--급여명세 테이블 시작-->
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
            <tr>
                <th><spring:message code="LABEL.D.D05.0010" /></th>     <!--  총지급액-->
                <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData4.BET01) %></td>
                <th class="th02"><spring:message code="LABEL.D.D05.0077" /></th>        <!-- 총공제액 -->
                <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData4.BET02) %></td>
                <th class="th02"><spring:message code="LABEL.D.D05.0012" /></th><!-- 차감지급액 -->
                <td class="align_right"><%= WebUtil.printNumFormat(d05MpayDetailData4.BET03) %></td>
            </tr>
        </table>
    </div>
</div>

<div class="listArea">
    <div class="table">
        <table class="mpayTable">
        <thead>
          <tr>
            <th><spring:message code="LABEL.D.D05.0014" /></th><!--  지급내역-->
            <th><spring:message code="LABEL.D.D05.0037" /></th>                     <!-- 시간, % -->
            <th class="divide"><spring:message code="LABEL.D.D05.0015" /></th><!-- 금액 -->
            <th><spring:message code="LABEL.D.D05.0016" /></th><!-- 공제내역 -->
            <th class="lastCol"><spring:message code="LABEL.D.D05.0015" /></th><!-- 금액 -->
          </tr>
          <tr valign="top">
            <td  class="align_left" height="120" style="vertical-align: top;">
<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
    D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
%>

<%    if(!data5.LGTXT.equals("소급분총액")) {  %>
  <% // 성과급 중, 30만원 해당임금에 대해 생산성향상금으로 표시(임시). 2004.7.20. mkbae.
     if(data5.LGTXT.equals("성과급")&&data5.BET01.equals("300000.00")) {%>
         생산성향상금<br>
<%
     }else if(data5.LGTXT.equals("익월 공제 예정액")) {// [CSR ID:2993988]

%>
                    <font color="#CC3300" ><%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %></font><br>
<%//--------------------------------예외 시작--------------------------------- [CSR ID:3589279] 임시적용
                  }else if(data5.LGTXT.equals("일급계")&& Integer.parseInt(year) >=  2018 && (user_m.empNo.equals("00219375")||user_m.empNo.equals("00219376")||user_m.empNo.equals("00219377")||user_m.empNo.equals("00224131")||user_m.empNo.equals("00224132"))) {
  %>
                    		<%= data5.LGTXT.equals("") ? "　" : "월급" %><br>                    
<%//----------------------예외 끝---------------------------------
      }else { %>
         <%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %><br>
  <% } %>
<%    }   %>
<%
    }
%>
<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
    D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
%>
<%   if(data5.BET01.equals("0")){  %>
        &nbsp;<br><br>
<%   }else{
%>
<%    if(data5.LGTXT.equals("소급분총액")) {  %>
        &nbsp;<br><br>
        <%= data5.LGTXT.equals("") ? "" : data5.LGTXT%><br>
<%    }    %>
<%   }  %>
<%  }  %>
                </td>
                <td class="align_right" height="120" style="vertical-align: top;">
<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
    D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
%>
<%  if(!data5.LGTXT.equals("소급분총액")) { 
		//--------------------------------예외 시작--------------------------------- [CSR ID:3589279] 임시적용
	  	if(data5.LGTXT.equals("일급계")&& Integer.parseInt(year) >=  2018 && (user_m.empNo.equals("00219375")||user_m.empNo.equals("00219376")||user_m.empNo.equals("00219377")||user_m.empNo.equals("00224131")||user_m.empNo.equals("00224132"))) {
	  		temp_time = Double.parseDouble(data5.ANZHL);
	%>
			<%= data5.ANZHL.equals("0") ? "　" : "  " %>&nbsp;<br>
	<%              	
	  	}else {//--------------------------------예외 끝-----------------------------------

%>
                <%= data5.ANZHL.equals("0") ? "　" : WebUtil.printNumFormat(data5.ANZHL,1) %>&nbsp;<br>

<%	}//else  [CSR ID:3589279] 임시적용
	}//if 소급분 총액 X
}//for
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
    D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
%>
<%    if(data5.LGTXT.equals("소급분총액")) {  %>
               <%= data5.ANZHL.equals("0") ? "　" : WebUtil.printNumFormat(data5.ANZHL,1) %>&nbsp;<br>
<%    }    %>
<%  }  %>
                </td>
                <td class="align_right" height="120" style="vertical-align: top;">
<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
    D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
%>
<%    if(!data5.LGTXT.equals("소급분총액")) { 
	%>

                <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
<%    }    %>
<%
    }
%>
<%
    for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
    D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
%>

<%    if(data5.LGTXT.equals("소급분총액")) {  %>
               &nbsp;<br><br>
               <%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %>&nbsp;<br>
<%    }    %>

<%  }  %>
                </td>
                <td class="align_left" height="120" style="vertical-align: top;">
<%
    for ( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
    D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
        if ( data2.LGTX1.equals("")) {
            if ( data2.BET02.equals("0")) {
                continue;
            }
        }else{
%>
<%       if(data2.BET02.equals("0")){       %>

<%       }else{     %>
          <% if ( data2.LGTX1.equals("소급분공제총액")) { %>
                <%= data2.LGTX1.equals("") ? "　" :  data2.LGTX1%>
          <%}else if(data2.LGTX1.equals("전월 이월 공제액")) {// [CSR ID:3018046]
              %> <font color="#CC3300"><%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %></font><br>
              <%
          } else { %>
                <%= data2.LGTX1.equals("") ? "　" :  data2.LGTX1%><br>
          <% }  %>
<%       }       %>
<%      }       %>
<%
    }
%>&nbsp;
                </td>
                <td class="align_right lastCol" height="120" style="vertical-align: top;">
<%
    for ( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
    D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);

      if ( data2.LGTX1.equals("")) {
        if ( data2.BET02.equals("0")) {
                continue;
        }
      }else{
%>
                <%= data2.BET02.equals("0") ? "　" :WebUtil.printNumFormat(data2.BET02) %>&nbsp;<br>

<%    }    %>
<%
    }
%>&nbsp;
                </td>
              </tr>
              <tr class="sumRow">
                <td>지급계</td>
<%//--------------------------------예외 시작--------------------------------- [CSR ID:3589279] 임시적용
	if(temp_time > 0.0) {// 일급계 값이 있어서, 시간 값을 저장 하였을 경우,
		temp_times = Double.parseDouble(d05MpayDetailData5.ANZHL);
		temp_times -= temp_time;
%>
		 <td class="align_right" align="right"><%= d05MpayDetailData5.ANZHL.equals("0") ? "" : WebUtil.printNumFormat(temp_times,1) %>&nbsp;</td>
<%
}else{//------------------예외 끝---------------------------------------------%>                  
                <td class="align_right" align="right"><%= d05MpayDetailData5.ANZHL.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData5.ANZHL,1) %>&nbsp;</td>
<%}//[CSR ID:3589279] 임시적용 %>                 
                <td class="align_right" align="right"><%= d05MpayDetailData5.BET01.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData5.BET01) %>&nbsp;</td>
                <td>공제계</td>
                <td class="align_right" align="right"><%= d05MpayDetailData5.BET02.equals("0") ? "" : WebUtil.printNumFormat(d05MpayDetailData5.BET02) %>&nbsp;</td>
              </tr>
        </thead>
        </table>
    </div>
</div>

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
<div><spring:message code="LABEL.D.D05.0034" /><!-- 익월 공제 예정액 : 당월 지급액 대비 공제액이 초과하여 익월로 공제액이 이월되는 금액임-->
</div>
<%}
if(carriedForward.equals("Y")){
%>
<div><spring:message code="LABEL.D.D05.0035" /><!-- 전월 이월 공제액 : 전월 급/상여 명세서에 반영된 익월 공제 예정액으로 당월 급여에 조정되는 금액임-->
</div>
<%} %>
</div>




<%
    }  //해외급여자 아닌경우  END
%>

<!--   //[CSR ID:3744002] start -->
<%
	if(Integer.parseInt(yymm) >= 201807 ){
        if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {//월급여 + TOTAL
            if(user_m.e_persk.equals("21") || user_m.e_persk.equals("22") || (user_m.e_persk.equals("24") && !user_m.e_jikkb.equals("AC0")) ){//계약직 중, 사외이사는 제외spd
%>            	
  <div class="commentsMoreThan2">
       <div>기본급은 고정O/T수당(20시간)이 포함된 금액입니다.</div>
  </div>

<%            
    }}}
%>
<!--   //[CSR ID:3744002] end -->


<%
    //[CSR ID:2583411]  [CSR ID:2584987]
    if ( user_m.e_persk.equals("38")  &&year.equals("2014") && month.equals("07") ) {
%>

         <font color="black"><spring:message code="LABEL.D.D05.0038" /><!-- ※ 기본급, 직책수당, 자격수당 : 6/21~6/30 기준 + 7/1~7/31 기준-->
         <br><spring:message code="LABEL.D.D05.0039" /><!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;시간외 근로수당 : 6/21~7/20 기준-->
         <br><spring:message code="LABEL.D.D05.0040" /><!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소급분총액 : 2/21~6/20 기준-->
         </font>

<%
     }
%>

<% if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {  %>
<%  if(d05MpayDetailData4_vt.size() != 0 && d05MpayDetailData5_vt.size() != 0){ %>

<h2 class="subtitle"><spring:message code="LABEL.D.D05.0050" /></h2>        <!-- 과세추가 내역 -->

<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
<%  if(d05MpayDetailData4_vt.size() == 0){ %>

              <tr>
                <td width="30%">&nbsp;</td>
                <td width="20%">&nbsp;</td>
                <td width="30%">&nbsp;</td>
                <td width="20%">&nbsp;</td>
              </tr>

<%  } else {   %>
              <tr>
                <th width="30%">
<%
    for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
    String kase_text ;
    String kase_text2 = "";
    
    if( data4.LGTX1.length() > 4 )
    {
         kase_text = data4.LGTX1.substring(0,4);
         kase_text2 = data4.LGTX1.substring(0,3);
    }
    else
    {
         kase_text = data4.LGTX1 ;
    }
%>
<%     //[CSR ID:3393138]
		  //[CSR ID:3493623] 
		 //if ( kase_text.equals("과세반영"))   %>
<%     //if ( kase_text.equals("과세반영")||  kase_text.equals("G6 상")) {  //[CSR ID:3440096]
         if ( kase_text.equals("과세반영") || (!kase_text2.equals("소급분") && data4.LGTX1.indexOf("과세반영")>-1)) {
	%>
          <%= data4.LGTX1.equals("") ? "" : data4.LGTX1 %>&nbsp;<br>
<%
       }else{
               continue;
       }
%>
<%
    }
%>
                </th>
                <td class="align_right" width="20%">
<%
    for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
    String kase_text ;
    String kase_text2 = "";
    if( data4.LGTX1.length() > 4 )
    {
         kase_text = data4.LGTX1.substring(0,4);
         kase_text2 = data4.LGTX1.substring(0,3);
         
    }
    else
    {
         kase_text = data4.LGTX1 ;
    }
%>
<%     //[CSR ID:3393138] 
         //[CSR ID:3493623]
		 //if ( kase_text.equals("과세반영")) {   %>
<%     //if ( kase_text.equals("과세반영")||  kase_text.equals("G6 상")) {   //[CSR ID:3440096]
		 if ( kase_text.equals("과세반영") || (!kase_text2.equals("소급분") && data4.LGTX1.indexOf("과세반영")>-1)) {
%>
          <%= data4.BET01.equals("0") ? "" : WebUtil.printNumFormat(data4.BET01) %>&nbsp;<br>
<%
       }else{
               continue;
       }
%>
<%
    }
%>
                </td>
                <th class="th02" width="30%">
<%
    for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
    String kase_text ;
    if( data4.LGTX1.length() > 4 )
    {
         kase_text = data4.LGTX1.substring(0,3);
    }
    else
    {
         kase_text = data4.LGTX1 ;
    }
%>
<%     if ( kase_text.equals("소급분")) {   %>
         <%  if(!data4.BET01.equals("0")) { %>
          <%= data4.LGTX1.equals("") ? "" : data4.LGTX1 %>&nbsp;<br>
         <%  }  %>
<%
       }else{
               continue;
       }
%>
<%
    }
%>
                </th>
                <td class="align_right" width="20%">
<%
    for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
    String kase_text ;
    if( data4.LGTX1.length() > 4 )
    {
         kase_text = data4.LGTX1.substring(0,3);
    }
    else
    {
         kase_text = data4.LGTX1 ;
    }
%>
<%     if ( kase_text.equals("소급분")) {   %>
         <%  if(!data4.BET01.equals("0")) { %>
          <%= data4.BET01.equals("0") ? "" : WebUtil.printNumFormat(data4.BET01) %>&nbsp;<br>
         <%  }  %>
<%
       }else{
               continue;
       }
%>
<%
    }
%>
                </td>
              </tr>
<% }  %>
        </table>
    </div>
</div>

<%  } }  %>




    <%
    String DispFlag="false";
    // 공수 : 33:기능직,34 && 가공공장만 조회
    //[CSR ID:2583929] 생산기술직 38 추가  [CSR ID:2584987]
    if ( (user_m.e_persk.equals("33") || user_m.e_persk.equals("38") ||user_m.e_persk.equals("34") ) && user_m.e_werks.equals("BB00")   ) {
          DispFlag = "true";
    }

%>

<% if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {  %>

<h2 class="subtitle"> <spring:message code="LABEL.D.D05.0081" /><!-- 근태현황 --></h2>

<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
      	<colgroup>
<%    if ( DispFlag.equals("true")  ) {  %>
      	<col width=12.5%/>
      	<col width=10%/>
      	<col width=12.5%/>
      	<col width=10%/>
      	<col width=17.5%/>
      	<col width=10%/>
      	<col width=17.5%/>
      	<col width=10%/>
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
                <th><spring:message code="LABEL.D.D05.0082" /></th> <!-- 근태일수 -->
                <td class="align_right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK01),0) %></td>
<!-- [CSR ID:2584987] -->
<%    if ( DispFlag.equals("true")  ) {  %>
                  <th class="th02"><spring:message code="LABEL.D.D05.0083" /></th>  <!-- 공수 --> 
                  <!-- [CSR ID:3043406]<td  align="right">< %= WebUtil.printNumFormat(Double.parseDouble(KONGSU_HOUR),1) %>&nbsp;</td> -->
                  <td class="align_right"><%= WebUtil.printNumFormat(Double.parseDouble(KONGSU_PAY),1) %></td>
<%    }  %>
                <th class="th02"><spring:message code="LABEL.D.D05.0084" /></th>    <!-- 사용휴가일수 -->
                <td class="align_right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK02),1) %></td>
                <th class="th02"><spring:message code="LABEL.D.D05.0085" /></th>    <!-- 잔여휴가일수 -->
              <%  if (month.equals("12")) { %>
                <td class="align_right">0.0</td>
              <%  }  else  {%>
                <td class="align_right"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK03),1) %></td>
              <%  }  %>
            </tr>
        </table>
    </div>
</div>

<% }   %>

<!-- [CSR ID:3038224] 총보상명세서 출력 페이지에는 제외시킴
<%
//------- [CSR ID:2995203]@v1.4---------------------------------------------------------------------------------------------------------
/*if ( Long.parseLong(year) >= 2012 ) {
      double  bettot =0;
      if ( d05CompensationData  != null ) {

          bettot =Double.parseDouble(d05CompensationData.BET01) +Double.parseDouble(d05CompensationData.BET02);
%>
    <tr>
      <td><table width="600" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td class="font01" style="padding-bottom:10px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 총 보상 명세표</td>
          </tr>
        </table>
        <table width="600" border="0" cellspacing="1" cellpadding="2" class="table02">
          <tr>
            <td  width="200">급여/복리후생 총액</td>
            <td  width="600" align="right" colspan=3><%= WebUtil.printNumFormat(bettot*100,0) %>&nbsp;</td>
          </tr>
          <tr>
            <td  width="200">연급여</td>
            <td  width="200" align="right"><%= WebUtil.printNumFormat(Double.parseDouble(d05CompensationData.BET01)*100,0) %>&nbsp;</td>
            <td  width="200">복리후생 총액</td>
            <td  width="200" align="right"><%= WebUtil.printNumFormat(Double.parseDouble(d05CompensationData.BET02)*100,0) %>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>

    <tr>
      <td><table width="600" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td> <font class="font04">※ 상기 <B>복리후생 총액</B>은, 법정 복리후생을 포함하여 법정 外 복리후생 항목 中 개인 別로 지원된 연간 누계액을 표기한 것입니다.<br>
            </font></td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td height="7">&nbsp;</td>
    </tr>

<%
    }
}*/
//---------------------------------------------------------------------------------------------------------------
%>
 -->

      <!--급여명세 테이블 시작-->



<%
    // [CSR ID:2763588] 급여명세표 수정 start
%>
<!-- 급여 공지사항 시작 -->
<%
if(yymm.equals("201506")){
    if(user_m.e_persk.equals("31")){
%>


        <table width="600" border="0" cellspacing="1" cellpadding="2" class="table02" height="100"  visible="hidden">
            <tr>
                <td  width="100"><spring:message code="LABEL.D.D05.0091" /><!-- 공지사항 --></td>
                <td  style="vertical-align: top; padding-top:15px">
                <font color="#CC3300">
                            <br><br>
                </font>
<%
    // 31:전문기술직,32:지도직,33:기능직
    // [CSR ID:2583929] 생산기술직 38 추가
    if( user_m.e_persk.equals("31") ||user_m.e_persk.equals("32")||user_m.e_persk.equals("33") || user_m.e_persk.equals("38")) {
%>
                    <font color="#CC3300"><!-- ※ 근태, 월급여, 연급여 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 <br>
                                                        &nbsp;&nbsp;&nbsp;&nbsp; 절대로 공개하지 마시기 바라며, 이를 위반시에는 취업규칙상의 규정과 절차에 따라 <br>
                                                        &nbsp;&nbsp;&nbsp;&nbsp; 징계조치 됨을 알려드립니다.<br>&nbsp;
                                                        //-->
                    </font>
<%
    }
%>
                </td>
            </tr>
        </table>

<%}//38생산기술직만 추가되게...
}else if(1==1){ //급여명세표 안보이게...
}else{ //기존 로직%>

<div class="tableArea">
    <div class="table">
            <table class="tableGeneral" height="100">
                <tr>
                    <th width="100"><spring:message code="LABEL.D.D05.0091" /><!-- 공지사항 --></th>
                    <td style="vertical-align: top; padding-top:15px">
<%if(yymm.equals("201505")){ //[CSR ID:2785904] 월급여 공지사항 수정 요청 건%>
                    <!--  [CSR ID:2782595] 5월 급여 공지사항 문구 삽입 요청 -->
    <p><span class="bold"><spring:message code="LABEL.D.D05.0094" /></span></p> <!-- 차감환급소득세(급여) / 차감환급주민세(급여) -->
    <p><spring:message code="LABEL.D.D05.0095" /></p>                                           <!-- - 소득세법 개정에 따른 연말정산 재정산 결과 반영 -->
    <p><spring:message code="LABEL.D.D05.0096" /></p>                                           <!-- - 기존 추가납부 분할공제 대상자는 추가납부 금액과 재정산 금액이 합산 기표됨. -->
    <p><span class="bold"><spring:message code="LABEL.D.D05.0097" /></span></p> <!-- 연말정산 재정산 결과 확인방법 -->
    <p><spring:message code="LABEL.D.D05.0098" /></p>                                           <!-- - G Portal ▶ HR Center ▶ 연말정산 ▶ "연말정산 내역조회“ -->

<%
}//5월 급여 조회때만 공지사항이 보이도록 조건 추가.

    if( user_m.e_trfar.equals("02") || user_m.e_trfar.equals("03") || user_m.e_trfar.equals("04")) {
%>
                        <font color="#CC3300"><!-- ※ 개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 <br>
                                                            &nbsp;&nbsp;&nbsp;&nbsp; 절대로 공개하지 마시기 바라며, 이를 위반시에는 취업규칙상의 규정과 절차에 따라 <br>
                                                            &nbsp;&nbsp;&nbsp;&nbsp; 징계조치 됨을 알려드립니다.<br>&nbsp;
                                                            //-->
                        </font>
<%
    }

    // 31:전문기술직,32:지도직,33:기능직
    // [CSR ID:2583929] 생산기술직 38 추가
    if( user_m.e_persk.equals("31") ||user_m.e_persk.equals("32")||user_m.e_persk.equals("33") || user_m.e_persk.equals("38")) {
%>
                        <font color="#CC3300"><!-- ※ 근태, 월급여, 연급여 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 <br>
                                                            &nbsp;&nbsp;&nbsp;&nbsp; 절대로 공개하지 마시기 바라며, 이를 위반시에는 취업규칙상의 규정과 절차에 따라 <br>
                                                            &nbsp;&nbsp;&nbsp;&nbsp; 징계조치 됨을 알려드립니다.<br>&nbsp;
                                                            //-->
                        </font>
<%
    }
%>
                    </td>
                </tr>
            </table>

</div>

<%} %>
<!-- 급여  공지사항 끝 -->

<div class="buttonArea">
<%
    if(user_m.companyCode.equals("C100")) {
%>
    <img src="<%= WebUtil.ImageURL %>img_logopay_hwahak.gif" width="122" height="27" align="absmiddle">
<%  } else {%>
    <img src="<%= WebUtil.ImageURL %>img_logopay_oil.gif" width="122" height="27" align="absmiddle">
<%  }%>
</div>
<%
// [CSR ID:2763588] 급여명세표 수정 end
%>



<jsp:include page="/include/pop-body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
