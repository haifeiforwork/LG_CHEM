<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 월급여                                                      */
/*   Program Name : 월급여                                                      */
/*   Program ID   : D08RetroDetail_m.jsp                                        */
/*   Description  : 개인의 소급내역조회 조회                                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-23  최영호                                          */
/*   Update       : 2005-01-18  윤정현                                          */
/*                                                                              */
/*                 2014-07-18 [CSR ID:2575929] 해외주재원 급여명세서 수정요청   */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector D08RetroDetailData_vt  = (Vector)request.getAttribute("D08RetroDetailData_vt"); //전체데이터를 담은 백터
    D08RetroDetailData_vt = SortUtil.sort( D08RetroDetailData_vt, "1", "asc" );

    Vector D08RetroDetailData1_vt = (Vector)request.getAttribute("D08RetroDetailData1_vt"); // 공제내역을 담은 백터
    D08RetroDetailData1_vt = SortUtil.sort( D08RetroDetailData1_vt, "1", "asc" );

    Vector D08RetroDetailData2_vt = (Vector)request.getAttribute("D08RetroDetailData2_vt"); // 지급내역을 담은 백터
    D08RetroDetailData2_vt = SortUtil.sort( D08RetroDetailData2_vt, "1", "asc" );

    Vector D08RetroDetailData3_vt = (Vector)request.getAttribute("D08RetroDetailData3_vt"); // 해당월을 1개씩만 담은 백터(단 지급유형이 다른것은 제외)
    D08RetroDetailData3_vt = SortUtil.sort( D08RetroDetailData3_vt, "1", "asc" );

    String total1 = ( String ) request.getAttribute( "total1" ) ; // 공제내역의 소급액합
    String total2 = ( String ) request.getAttribute( "total2" ) ; // 지급내역의 소급액합

    int total = Integer.parseInt(total2)-Integer.parseInt(total1); // 전체소급액
    String yno    = "" ;
    String choi   = "";
    String minwoo = "";
    int amt_decimal = user.area==Area.KR ? 0:2;
%>

<jsp:include page="/include/header.jsp" />

<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D08.0001"/>  
</jsp:include>

<style type="text/css">
  .subWrapper{width:950px;}
</style>

<form name="form1" method="post" action="">
          <!--   사원검색 보여주는 부분 시작   -->
          <%@include file="/web/common/SearchDeptPersons_m.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          
          <%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>
    <!--개인정보 테이블 시작-->
<div class="listArea">
 <div class="table">
          <table class="tableGeneral">
          	<colgroup>
          	<col width=80px/>
          	<col width=260px/>
          	<col width=80px/>
          	<col width=140px/>
          	<col width=80px/>
          	<col width=140px/>
          	</colgroup>
            <thead>
            <tr> 
              <th width="80"><spring:message code="LABEL.D.D05.0004" /></th>	<!-- 부서명 -->
              <td class="th02" width="260"><%= user_m.e_orgtx %></td>
              <th class="th02" width="80"><spring:message code="LABEL.D.D05.0005" /></th>		<!-- 사번 -->
              <td class="th02" width="140"><%= user_m.empNo %></td>
              <th class="th02" width="80"><spring:message code="LABEL.D.D05.0006" /></th>		<!-- 이름 -->
              <td class="lastCol th02" width="140"><%= user_m.ename %></td>
            </tr>
            </thead>
            <%  // 해당월을 for문으로 돌림
    double sum7 = 0;
    int    sum8 = 0;

    for ( int i = 0 ; i < D08RetroDetailData3_vt.size() ; i++ ) {
        D08RetroDetailData data4 = (D08RetroDetailData)D08RetroDetailData3_vt.get(i);
        int month = Integer.parseInt(data4.FPPER.substring(4));

        // 지급총액
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
            D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
            String kase_text ;
            String imgi_text = data3.LGTXT;
            if( data3.LGTXT.length() > 4 ) {
                kase_text = data3.LGTXT.substring(0,4);
            } else {
               kase_text = data3.LGTXT ;
            }
            if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){
                if(kase_text.equals("과세반영")){
 //                 choi = data3.PAYDT;
                    continue;
                }else{
//                	 [CSR ID:2575929] 급지휴가비 추가(SAP데이터 해외휴가비→급지휴가비로 변경 if(imgi_text.equals("해외생계비(현지화)") || imgi_text.equals("해외주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("해외휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) {
                   if(imgi_text.equals("해외생계비(현지화)") || imgi_text.equals("해외주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("급지휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) { 	
                        continue;
                    }else{
                        sum7 += Double.parseDouble(data3.SOGUP_AMNT);
                    }
                }
            }
        }

        // 공제총액
        for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
            D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k);

            if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){
                sum8 += Double.parseDouble(data2.SOGUP_AMNT);
            }
        }
    }
%>
                <tr>
                  <th ><spring:message code="LABEL.D.D05.0022" /></th>	<!-- 지급계 -->
                  <td class="th02 align_right"><%= WebUtil.printNumFormat(sum7, amt_decimal) %>&nbsp;</td>
                  <th class="th02"><spring:message code="LABEL.D.D05.0023" /></th>	<!-- 공제계 -->
                  <td class="th02 align_right"><%= WebUtil.printNumFormat(sum8, amt_decimal) %>&nbsp;</td>
                  <th class="th02"><spring:message code="LABEL.D.D08.0002" /></th>	<!-- 차액계 -->
                  <td class="lastCol align_right"> 
                    <%= WebUtil.printNumFormat(sum7 - sum8, amt_decimal) %>
                  </td>
                </tr>
              </table> 
        </div>
        </div>
        
        <!--개인정보 테이블 끝-->
        <!--소급내역 테이블 시작-->
  <div class="tableArea">
    <div class="table">
              <!--소급내역 테이블 시작-->
              <table class="mpayTable">
              <thead>
                <tr> 
             <th  rowspan="2" width="85"><spring:message code="LABEL.D.D08.0003" /></th>		<!-- 대상월 -->
            <th  rowspan="2" width="65"><spring:message code="LABEL.D.D15.0122" /></th>		<!-- 구 분 -->
            <th  rowspan="2" width="170"><spring:message code="LABEL.D.D08.0004" /></th>	<!-- 항 목 -->
            <th  colspan="2"><spring:message code="LABEL.D.D08.0005" /></th>						<!-- 소 급 전 -->
            <th  colspan="2"><spring:message code="LABEL.D.D08.0006" /></th>						<!-- 소 급 후 -->
            <th class="lastCol" rowspan="2" width="110"><spring:message code="LABEL.D.D08.0007" /></th>	<!--소 급 액  -->
          </tr>
          <tr> 
            <th  width="50"><spring:message code="LABEL.D.D12.0043" /></th>		<!--시 간  -->
            <th  width="100"><spring:message code="LABEL.D.D05.0015" /></th>		<!-- 금 액 -->
            <th  width="50"><spring:message code="LABEL.D.D12.0043" /></th>		<!-- 시 간 -->
            <th  width="100"><spring:message code="LABEL.D.D05.0015" /></th>		<!-- 금 액 -->
          </tr>
                <%
    // 해당월을 for문으로 돌림
    for ( int i = 0 ; i < D08RetroDetailData3_vt.size() ; i++ ) {
        D08RetroDetailData data4 = (D08RetroDetailData)D08RetroDetailData3_vt.get(i);
        int    month = Integer.parseInt(data4.FPPER.substring(4));
        double sum1  = 0;
        double sum2  = 0;
        double sum3  = 0;
        double sum4  = 0;
        double sum5  = 0;
        double sum6  = 0;
        double sum10 = 0;
        double sum11 = 0;

 // 10월 28일 추가내용 -------------------------------------------------**
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
            D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
            String kase_text ;
            String imgi_text = data3.LGTXT;
            if( data3.LGTXT.length() > 4 ) {
                kase_text = data3.LGTXT.substring(0,4);
            } else {
                kase_text = data3.LGTXT ;
            }

            if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){
                if(kase_text.equals("과세반영")){
                    choi = data3.PAYDT;
                    minwoo = data3.OCRTX;
                }else{
                    continue;
                }
            }
        }
//------------------------------------------------------------------------**
%>
               <tr class="borderRow">  
                  <%
        if(choi.equals(data4.PAYDT) && minwoo.equals(data4.OCRTX)) {
%>
                  <th  rowspan="6"> <p><%= month %><spring:message code="LABEL.D.D15.0021" /></p><!-- 월 -->
                    <br>
                    (<%= data4.OCRTX %>) 
                    <%-- choi = "X" ;--%> </td>
                  <%
        }else{
%>
                  <th  rowspan="5"> <p><%= month %><spring:message code="LABEL.D.D15.0021" /></p><!-- 월 -->
                    <br>
                    (<%= data4.OCRTX %>) </td>
                  <%
        }
%>
                  <th ><spring:message code="LABEL.D.D05.0014" /></td>	<!-- 지급내역 -->
                  <th  height="50">
 <%
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
            D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
            String kase_text ;
            if( data3.LGTXT.length() > 4 ) {
                kase_text = data3.LGTXT.substring(0,4);
            } else {
                kase_text = data3.LGTXT ;
            }

            if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){
                if(kase_text.equals("과세반영")){
                    yno = data3.PAYDT;
                    continue;
                } else {
%> <%= data3.LGTXT %><br> <%
                }
            }
        }
%> </td>
                  <td  align="right" class="th02 align_right"> <%
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
            D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
            String kase_text ;
            if( data3.LGTXT.length() > 4 ) {
                kase_text = data3.LGTXT.substring(0,4);
            } else {
                kase_text = data3.LGTXT ;
            }

            if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                if(kase_text.equals("과세반영")){
                    yno = data3.PAYDT;
                    continue;
                } else {
%> <%= data3.ANZHL.equals("0") ? "" : data3.ANZHL %>&nbsp;<br> <%
                    sum11 += Double.parseDouble(data3.ANZHL);
                }
            }
        }
%> </td>
                  <td  align="right" class="th02 align_right"> <%
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
            String kase_text ;
            D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
            String imgi_text = data3.LGTXT;
            double SOGUP_BEFORE = Double.parseDouble(data3.SOGUP_BEFORE) / 100;
            String SOGUP_BEFORE1 = Double.toString(SOGUP_BEFORE);
            if( data3.LGTXT.length() > 4 ) {
                kase_text = data3.LGTXT.substring(0,4);
            } else {
                kase_text = data3.LGTXT ;
            }

            if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                if(kase_text.equals("과세반영")){
                    continue;
                }else{
                    if(imgi_text.equals("해외생계비(현지화)") || imgi_text.equals("해외주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("해외휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) {
%> <%= SOGUP_BEFORE1.equals("0.0") ? "" : WebUtil.printNumFormat(SOGUP_BEFORE1,2) %>&nbsp;<br> <%
                    }else{
%> <%= data3.SOGUP_BEFORE.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_BEFORE, amt_decimal) %>&nbsp;<br> <%
                    }

                    if(!imgi_text.equals("해외생계비(현지화)") && !imgi_text.equals("해외주택비차액(현지화)") && !imgi_text.equals("국외일정액(현지화)") && !imgi_text.equals("해외휴가비(현지화)") && !imgi_text.equals("해외학자금(현지화)")) {
                        sum4 += Double.parseDouble(data3.SOGUP_BEFORE);
                    }
                }
            }
        }
%> </td>
                  <td class="th02 align_right" align="right"> <%
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
            D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
            String kase_text ;
            if( data3.LGTXT.length() > 4 ) {
                kase_text = data3.LGTXT.substring(0,4);
            } else {
                kase_text = data3.LGTXT ;
            }

            if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                if(kase_text.equals("과세반영")){
                    continue;
                    }else{
%> <%= data3.ANZHL1.equals("0") ? "" : data3.ANZHL1 %>&nbsp;<br> <%
                        sum10 += Double.parseDouble(data3.ANZHL1);
                }
            }
        }
%> </td>
                  <td class="th02 align_right" align="right"> <%
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
            D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
            String kase_text ;
            String imgi_text = data3.LGTXT;
            double SOGUP_AFTER = Double.parseDouble(data3.SOGUP_AFTER) / 100;
            String SOGUP_AFTER1 = Double.toString(SOGUP_AFTER);
            if( data3.LGTXT.length() > 4 ) {
                kase_text = data3.LGTXT.substring(0,4);
            } else {
                kase_text = data3.LGTXT ;
            }

            if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                if(kase_text.equals("과세반영")){
                    continue;
                }else{

                    if(imgi_text.equals("해외생계비(현지화)") || imgi_text.equals("해외주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("해외휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) {
%> <%= SOGUP_AFTER1.equals("0.0") ? "" : WebUtil.printNumFormat(SOGUP_AFTER1,2) %>&nbsp;<br> <%
                    }else{
%> <%= data3.SOGUP_AFTER.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_AFTER, amt_decimal) %>&nbsp;<br> <%
                    }

                    if(!imgi_text.equals("해외생계비(현지화)") && !imgi_text.equals("해외주택비차액(현지화)") && !imgi_text.equals("국외일정액(현지화)") && !imgi_text.equals("해외휴가비(현지화)") && !imgi_text.equals("해외학자금(현지화)")) {
                        sum5 += Double.parseDouble(data3.SOGUP_AFTER);
                    }
                }
            }
        }
%> </td>
                  <td class="lastCol align_right" align="right"> <%
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
            D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
            String kase_text ;
            String imgi_text = data3.LGTXT;
            double SOGUP_AMNT = Double.parseDouble(data3.SOGUP_AMNT) / 100;
            String SOGUP_AMNT1 = Double.toString(SOGUP_AMNT);
            if( data3.LGTXT.length() > 4 ) {
                kase_text = data3.LGTXT.substring(0,4);
            } else {
                kase_text = data3.LGTXT ;
            }
            if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                if(kase_text.equals("과세반영")){
                    continue;
                }else{
                    if(imgi_text.equals("해외생계비(현지화)") || imgi_text.equals("해외주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("해외휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) {
%> <%= SOGUP_AMNT1.equals("0.0") ? "" : WebUtil.printNumFormat(SOGUP_AMNT1,2) %>&nbsp;<br> <%
                    }else{
%> <%= data3.SOGUP_AMNT.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_AMNT, amt_decimal) %>&nbsp;<br> <%
                    }
                    if(!imgi_text.equals("해외생계비(현지화)") && !imgi_text.equals("해외주택비차액(현지화)") && !imgi_text.equals("국외일정액(현지화)") && !imgi_text.equals("해외휴가비(현지화)") && !imgi_text.equals("해외학자금(현지화)")) {
                        sum6 += Double.parseDouble(data3.SOGUP_AMNT);
                    }
                }
            }
        }
%> </td>
                </tr>
                <tr> 
		            <th colspan="2" class="th04" align="center"><spring:message code="LABEL.D.D08.0008" /></th><!-- 소 계 -->
                  <th  align="right"><%= WebUtil.printNumFormat(sum11).equals("0") ? "" : WebUtil.printNumFormat(sum11,2) %>&nbsp;</th>
                  <th  align="right"><%= WebUtil.printNumFormat(sum4).equals("0") ? "" : WebUtil.printNumFormat(sum4, amt_decimal) %>&nbsp;</th>
                  <th  align="right"><%= WebUtil.printNumFormat(sum10).equals("0") ? "" : WebUtil.printNumFormat(sum10,2) %>&nbsp;</th>
                  <th  align="right"><%= WebUtil.printNumFormat(sum5).equals("0") ? "" : WebUtil.printNumFormat(sum5, amt_decimal) %>&nbsp;</th>
                  <th class="lastCol align_right" align="right"><%= WebUtil.printNumFormat(sum6).equals("0") ? "" : WebUtil.printNumFormat(sum6, amt_decimal) %>&nbsp;</th>
                </tr>
                <%
        Logger.debug.println(this, yno);
        if(yno.equals(data4.PAYDT) && minwoo.equals(data4.OCRTX)) {
%>
               <tr class="borderRow"> 
                  <th colspan="2"  align="center"> <%
            for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
                String kase_text ;
                D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
                if( data3.LGTXT.length() > 4 ) {
                    kase_text = data3.LGTXT.substring(0,4);
                } else {
                    kase_text = data3.LGTXT ;
                }

                if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                    if(!kase_text.equals("과세반영")){
                        continue;
                    }else{
%> <%= data3.LGTXT %><br> <%
                    }
                }
            }
%> </td>
                  <td align="right">&nbsp;</td>
                  <td  align="right"> <%
            for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
                String kase_text ;
                D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
                if( data3.LGTXT.length() > 4 ) {
                    kase_text = data3.LGTXT.substring(0,4);
                } else {
                    kase_text = data3.LGTXT ;
                }
                if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                    if(!kase_text.equals("과세반영")){
                        continue;
                    }else{
%> <%= data3.SOGUP_BEFORE.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_BEFORE, amt_decimal) %>&nbsp;<br> <%-- sum4 += Double.parseDouble(data3.SOGUP_BEFORE); --%> <%
                    }
                }
            }
%> </td>
                  <td  align="right">&nbsp;</td>
                  <td align="right"> <%
            for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
                D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
                String kase_text ;
                if( data3.LGTXT.length() > 4 ) {
                    kase_text = data3.LGTXT.substring(0,4);
                } else {
                    kase_text = data3.LGTXT ;
                }

                if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                    if(!kase_text.equals("과세반영")){
                        continue;
                    }else{
%> <%= data3.SOGUP_AFTER.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_AFTER, amt_decimal) %>&nbsp;<br> <%-- sum5 += Double.parseDouble(data3.SOGUP_AFTER); --%> <%
                    }
                }
            }
%> </td>
                  <td class="lastCol align_right" align="right"> <%
            for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
                D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j);
                String kase_text ;
                if( data3.LGTXT.length() > 4 ) {
                    kase_text = data3.LGTXT.substring(0,4);
                } else {
                    kase_text = data3.LGTXT ;
                }

                if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){

                    if(!kase_text.equals("과세반영")){
                        continue;
                    }else{
%> <%= data3.SOGUP_AMNT.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_AMNT, amt_decimal) %>&nbsp;<br> <%-- sum6 += Double.parseDouble(data3.SOGUP_AMNT); --%> <%
                    }
                }
            }
%> </td>
                </tr>
                <%
        }
%>
                <tr> 
                  <th ><spring:message code="LABEL.D.D05.0016" /></td>	<!-- 공제내역 -->
                  <th  height="50"> <%
        for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
            D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k);

            if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){
%> <%= data2.LGTXT %><br> <%
            }
        }
%> </td>
                  <td  align="right" class="th02 align_right">&nbsp;</td>
                  <td  align="right" class="th02 align_right"> <%
        for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
            D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k);

            if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){
%> <%= data2.SOGUP_BEFORE.equals("0.0") ? "" : WebUtil.printNumFormat(data2.SOGUP_BEFORE, amt_decimal) %>&nbsp;<br> <%
                sum1 += Double.parseDouble(data2.SOGUP_BEFORE);
            }
        }
%> </td>
                  <td  align="right" class="th02 align_right">&nbsp;</td>
                  <td  align="right" class="th02 align_right"> <%
        for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
            D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k);

            if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){
%> <%= data2.SOGUP_AFTER.equals("0.0") ? "" : WebUtil.printNumFormat(data2.SOGUP_AFTER, amt_decimal) %>&nbsp;<br> <%
                sum2 += Double.parseDouble(data2.SOGUP_AFTER);
            }
        }
%> </td>
                  <td class="lastCol align_right" align="right"> <%
        for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
            D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k);

            if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){
%> <%= data2.SOGUP_AMNT.equals("0.0") ? "" : WebUtil.printNumFormat(data2.SOGUP_AMNT, amt_decimal) %>&nbsp;<br> <%
                sum3 += Double.parseDouble(data2.SOGUP_AMNT);
            }
        }
%> </td>
                </tr>
                <tr> 
                  <th colspan="2"  align="center"><spring:message code="LABEL.D.D08.0008" /></th><!-- 소 계 -->
                  <th  align="right">&nbsp;</th>
                  <th  align="right"><%= WebUtil.printNumFormat(sum1).equals("0") ? "" : WebUtil.printNumFormat(sum1, amt_decimal) %>&nbsp;</th>
                  <th  align="right">&nbsp;</th>
                  <th  align="right"><%= WebUtil.printNumFormat(sum2).equals("0") ? "" : WebUtil.printNumFormat(sum2) %>&nbsp;</th>
                  <th class="lastCol" align="right"><%= WebUtil.printNumFormat(sum3).equals("0") ? "" : WebUtil.printNumFormat(sum3, amt_decimal) %>&nbsp;</th>
                </tr>
                <tr> 
                  <th colspan="2" class="th03 " ><spring:message code="LABEL.D.D08.0009" /></td> <!-- 차 액 -->
                  <td class="align_right commentImportantTD">&nbsp;</td>
                  <td class="align_right commentImportantTD" align="right"><%= WebUtil.printNumFormat(sum4-sum1).equals("0") ? "" :  WebUtil.printNumFormat(sum4-sum1, amt_decimal) %>&nbsp;</td>
                  <td class="align_right commentImportantTD">&nbsp;</td>
                  <td class="align_right commentImportantTD" align="right"><%= WebUtil.printNumFormat(sum5-sum2).equals("0") ? "" :  WebUtil.printNumFormat(sum5-sum2, amt_decimal) %>&nbsp;</td>
                  <td class="lastCol align_right commentImportantTD" align="right"><%= WebUtil.printNumFormat(sum6-sum3).equals("0") ? "" :  WebUtil.printNumFormat(sum6-sum3, amt_decimal) %>&nbsp;</td>
                </tr>
                <%
    }
%>
				</thead>
              </table>
              <!--소급내역 테이블 끝-->
            </td>
          </tr>
         
          <tr> 
            <td align="center">
		        <div class="buttonArea">
		
		            <ul class="btn_crud">
		                <li><a href="javascript:history.back()"><span><spring:message code="BUTTON.COMMON.BACK"></spring:message></span></a></li>
		            </ul>
		
		        </div>
		        <div class="clear"> </div> 
            </td>
          </tr>
        </table>
        <%
}
%>
      
  </div></div>
  
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
