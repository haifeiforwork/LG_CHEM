<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연급여                                                      */
/*   Program Name : 연급여                                                      */
/*   Program ID   : D06YpayPrint_to_year.jsp                                    */
/*   Description  : 연급여 Print                                                */
/*   Note         :                                                             */
/*   Creation     : 2003-01-13  최영호                                          */
/*   Update       : 2005-02-02  윤정현                                          */
/*                  2006-01-23  lsa @v1.1  과세반영(산학자금) 추가              */
/*                  2007-01-23 @v1.0 lsa 과세반영(기타) 금액이 LGTX2,LGTX3 있는 경우 처리함*/
/*                  2007-02-13 @v1.3 lsa 과세반영(선택적복리후생) 추가, 과세반영(입학축하금)삭제 */
/*                  2007-02-26 @v1.4 lsa 오류로 수정  */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/*                  2016-03-23 [CSR ID:2995203] 보상명세서 적용(Total Compensation)  */
/*                  2018-02-28 rdcamel [CSR ID:3621578] 연급여 화면 수정요청의 건 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D06Ypay.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector D06YpayDetailData_vt = ( Vector ) request.getAttribute( "D06YpayDetailData_vt" ) ; // 연급여 내역 리스트
//  D06YpayTaxDetailData  d06YpayTaxDetailData = (D06YpayTaxDetailData) request.getAttribute( "d06YpayTaxDetailData"  ) ; //
    Vector D06YpayTaxDetailData_vt = ( Vector ) request.getAttribute( "D06YpayTaxDetailData_vt" ) ; // 연말정산내역
    Vector D06YpayDetailData3_vt = ( Vector ) request.getAttribute( "D06YpayDetailData3_vt" ) ; // 과세반영 내역 조회

    String from_year  = ( String ) request.getAttribute("from_year");
    String from_month = ( String ) request.getAttribute("from_month");
    String to_year    = ( String ) request.getAttribute("to_year");
    String to_month   = ( String ) request.getAttribute("to_month");
    String total1     = ( String ) request.getAttribute("total1");
    String total2     = ( String ) request.getAttribute("total2");
    String total3     = ( String ) request.getAttribute("total3");
    String total4     = ( String ) request.getAttribute("total4");
    String total5     = ( String ) request.getAttribute("total5");
    String total6     = ( String ) request.getAttribute("total6");
    String total7     = ( String ) request.getAttribute("total7");
    String total8     = ( String ) request.getAttribute("total8");
    String total9     = ( String ) request.getAttribute("total9");
    String total13    = ( String ) request.getAttribute("total13");
    String total14    = ( String ) request.getAttribute("total14");
    String total15    = ( String ) request.getAttribute("total15");
    String total21    = ( String ) request.getAttribute("total21");
    String total30    = ( String ) request.getAttribute("total30");
    String total90    = ( String ) request.getAttribute("total90");
    String totalBet13   = ( String ) request.getAttribute("totalBet13");// 노조비 합계[CSR ID:2995203]

    String yno = "" ;

    int sum1 = 0;
    int sum2 = 0;
    int sum3 = 0;
    int sum4 = 0;
    int sum5 = 0;
    int sum6 = 0;
    int sum7 = 0;
    int sum8 = 0;
    int sum9 = 0;
    int sum_san = 0; //@v1.1
    int sum_sanae = 0; //@v1.1
    int sum10 = 0;
    int sum11 = 0;
%>

<jsp:include page="/include/header.jsp" />

<style>
td{text-align:right !important;}
</style>


<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_ANNU_PAY"/>  
    <jsp:param name="help" value="D06Mpay.html"/>    
</jsp:include>

<SCRIPT LANGUAGE="JavaScript">
<!--
$(    function (){
        self.print();
        window.close();
    });
//-->
</SCRIPT>

<form name="form1" method="post" action="">
 
    <div class="tableArea">
      <div class="table">
        <table class="tableGeneral">
          <th><%=g.getMessage("LABEL.D.D05.0004")%></th><!-- 부서명 -->
          <td colspan="3" class="align_left" ><%= user.e_orgtx %></td>
          <th class="th02"><%=g.getMessage("LABEL.D.D05.0005")%></th><!-- 사번 -->
          <td class="align_left" ><%= user.empNo %></td>
          <th class="th02"><%=g.getMessage("LABEL.D.D06.0006")%></th><!-- 성명 -->
          <td class="align_left" ><%= user.ename %></td>
        </table>
      </div>
    </div>

    <div class="listArea">
          <div class="table">
            <table class="mpayTable">
            	<thead>
              <tr>
                <th rowspan="2" width="51" valign="center"><spring:message code="LABEL.D.D05.0002" /></th> <!--  해당년월-->
                <th colspan="3"><spring:message code="LABEL.D.D05.0014" /></th><!--  지급내역-->
                <th colspan="8"><spring:message code="LABEL.D.D05.0016" /></th><!--  공제내역-->
                <th class="lastCol" rowspan="2" width="69" valign="center"><spring:message code="LABEL.D.D05.0012" /></th><!-- 차감지급액 -->
              </tr>
              <tr>
                <th width="9%"><spring:message code="LABEL.D.D06.0022" /></th><!-- 급여 -->
                      <th width="9%"><spring:message code="LABEL.D.D06.0023" /></th><!-- 상여 -->
                      <th width="9%"><spring:message code="LABEL.D.D05.0022" /></th><!-- 지급계 -->
                      <!-- [CSR ID:2995203] 명칭변경<th width="70" style="border-left:1.5pt solid windowtext; border-color: #B7A68A">갑근세</th> -->
                      <th width="7%"><spring:message code="LABEL.D.D05.0020" /></th><!-- 소득세 -->
                      <th width="7%"><spring:message code="LABEL.D.D05.0021" /></th><!--주민세  -->
                      <th width="7%"><spring:message code="LABEL.D.D06.0007" /></th><!--  건강<br>보험료-->
                      <th width="7%"><spring:message code="LABEL.D.D05.0019" /></th><!-- 고용<br>보험료 -->
                      <th width="7%"><spring:message code="LABEL.D.D05.0018" /></th><!-- 국민연금 -->
                      <th width="7%"><spring:message code="LABEL.D.D06.0008" /></th><!-- 노조비[CSR ID:2995203] -->
                      <th width="7%"><spring:message code="LABEL.D.D06.0005" /></th><!-- 기타 -->
                      <th width="7%"><spring:message code="LABEL.D.D05.0023" /></th><!--  공제계-->
              </tr>
              </thead>
    <%
        for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
            D06YpayDetailData_to_year data = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

            int j = 0;
            String  zyy = data.ZYYMM.substring(0,4);
            String  zmm = data.ZYYMM.substring(4);
            double sangyo = Double.parseDouble(data.BET02) + Double.parseDouble(data.BET03);
            String sangyo1 = Double.toString(sangyo);
            double kupya = Double.parseDouble(data.BET04) - Double.parseDouble(data.BET02);
            String kupya1 = Double.toString(kupya);
            double kita =  Double.parseDouble(data.BET11) - (Double.parseDouble(data.BET05) + Double.parseDouble(data.BET06) + Double.parseDouble(data.BET07) + Double.parseDouble(data.BET08) + Double.parseDouble(data.BET09));
            String kita1 = Double.toString(kita);
            double chagam = Double.parseDouble(data.BET04) - Double.parseDouble(data.BET11);
            String chagam1 = Double.toString(chagam);
    %>
              <tr class="<%=tr_class%>">
                <td class="align_center" ><%= zyy+"."+zmm %></td>
                <td><%= kupya1.equals("0") ? "" : WebUtil.printNumFormat(kupya1) %>&nbsp;</td>
                <td><%= data.BET02.equals("0") ? "" : WebUtil.printNumFormat(data.BET02) %>&nbsp;</td>
                <td><%= data.BET04.equals("0") ? "" : WebUtil.printNumFormat(data.BET04) %>&nbsp;</td>
                <td><%= data.BET05.equals("0") ? "" : WebUtil.printNumFormat(data.BET05) %>&nbsp;</td>
                <td><%= data.BET06.equals("0") ? "" : WebUtil.printNumFormat(data.BET06) %>&nbsp;</td>
                <td><%= data.BET07.equals("0") ? "" : WebUtil.printNumFormat(data.BET07) %>&nbsp;</td>
                <td><%= data.BET08.equals("0") ? "" : WebUtil.printNumFormat(data.BET08) %>&nbsp;</td>
                <td><%= data.BET09.equals("0") ? "" : WebUtil.printNumFormat(data.BET09) %>&nbsp;</td>
                <td><%= data.BET13.equals("0") ? "" : WebUtil.printNumFormat(data.BET13) %>&nbsp;</td><!-- [CSR ID:2995203] -->
                <td><%= kita1.equals("0") ? "" : WebUtil.printNumFormat(kita1) %>&nbsp;</td>
                <td><%= data.BET11.equals("0") ? "" : WebUtil.printNumFormat(data.BET11) %>&nbsp;</td>
                <td class="lastCol"><%= chagam1.equals("0") ? "" : WebUtil.printNumFormat(chagam1) %>&nbsp;</td>
             </tr>
    <%      
        	}
    			/* if(zmm.equals("12")){
    			yno = "YX";//[CSR ID:3621578] 연급여 화면 수정요청의 건
                D06YpayTaxDetailData_to_year data1 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(j); */
    %>
    <%--  [CSR ID:3621578] 연급여 화면 수정요청의 건 아래 별도 테이블로 뺌
              <tr>
                <td ><spring:message code="LABEL.D.D06.0009" /></td><!-- 연말정산 -->
                <td  colspan="2" align="right"><%= data1.YIC == null ? "" :g.getMessage("LABEL.D.D06.0010") %></td> <!-- 인정이자 -->
                <td ><%= data1.YIC == null ? "" : WebUtil.printNumFormat(data1.YIC) %>&nbsp;</td>
                <td ><%= data1.YAI == null ? "" : WebUtil.printNumFormat(data1.YAI) %>&nbsp;</td>
                <td ><%= data1.YAR == null ? "" : WebUtil.printNumFormat(data1.YAR) %>&nbsp;</td>
                <td ><%= data1.YAS == null ? "" : WebUtil.printNumFormat(data1.YAS) %>&nbsp;</td>
                <td ><%= data1.YFE == null ? "" : WebUtil.printNumFormat(data1.YFE) %>&nbsp;</td>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
              </tr> --%>
    <%
                /* j++ ;
            }
        }

        if( yno.equals("Y")){//[CSR ID:3621578] 안쓰는 화면
            String total10 = ( String ) request.getAttribute("total10");
            String total11 = ( String ) request.getAttribute("total11");
            String total12 = ( String ) request.getAttribute("total12");
            double kabgn = Double.parseDouble(total10);
            double jumin = Double.parseDouble(total11);
            double kabgn_tot = Double.parseDouble(total5);
            double jumin_tot = Double.parseDouble(total6);
            String kabgn_tot1 = Double.toString(kabgn + kabgn_tot);
            String jumin_tot1 = Double.toString(jumin + jumin_tot);
            double sangya_tot = Double.parseDouble(total2) + Double.parseDouble(total3);
            String sangya_totl = Double.toString(sangya_tot);
            double kupya_tot = Double.parseDouble(total4) - Double.parseDouble(total2) + Double.parseDouble(total21);
            String kupya_tot1 = Double.toString(kupya_tot);
            double goyong = Double.parseDouble(total8) + Double.parseDouble(total30);;
            String goyong1 = Double.toString(goyong);
          //[CSR ID:2995203] 노조비 total 값 차감
            double kita_totl = Double.parseDouble(total14) - (Double.parseDouble(jumin_tot1) + Double.parseDouble(total7) + Double.parseDouble(goyong1) + Double.parseDouble(total9) + Double.parseDouble(totalBet13));
            String kita_totl1 = Double.toString(kita_totl);

            D06YpayTaxDetailData_to_year data1 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(0);
            double inja = Double.parseDouble(total4) + Double.parseDouble(data1.YIC == null ? "0" : data1.YIC) + Double.parseDouble(total21);
            String inja1 = Double.toString(inja);

            double chgam_total = Double.parseDouble(total4) - Double.parseDouble(total14) ;
            String chgam_total1 = Double.toString(chgam_total); */
    %>
              <%-- <tr class="sumRow">
                <td class="align_center" ><spring:message code="LABEL.D.D06.0011" /></td><!-- TOTAL -->
                <td><%= kupya_tot1.equals("0") ? "" : WebUtil.printNumFormat(kupya_tot1) %>&nbsp;</td>
                <td><%= total2.equals("0") ? "" : WebUtil.printNumFormat(total2) %>&nbsp;</td>
                <td><%= inja1.equals("0") ? "" : WebUtil.printNumFormat(inja1) %>&nbsp;</td>
                <td><%= kabgn_tot1.equals("0") ? "" : WebUtil.printNumFormat(kabgn_tot1) %>&nbsp;</td>
                <td><%= jumin_tot1.equals("0") ? "" : WebUtil.printNumFormat(jumin_tot1) %>&nbsp;</td>
                <td><%= total7.equals("0") ? "" : WebUtil.printNumFormat(total7) %>&nbsp;</td>
                <td><%= goyong1.equals("0") ? "" : WebUtil.printNumFormat(goyong1) %>&nbsp;</td>
                <td><%= total9.equals("0") ? "" : WebUtil.printNumFormat(total9) %>&nbsp;</td>
                <td><%= totalBet13.equals("0") ? "" : WebUtil.printNumFormat(totalBet13) %>&nbsp;</td><!-- [CSR ID:2995203] -->
                <td><%= kita_totl1.equals("0") ? "" : WebUtil.printNumFormat(kita_totl1) %>&nbsp;</td>
                <td><%= total14.equals("0") ? "" : WebUtil.printNumFormat(total14) %>&nbsp;</td>
                <td><%= chgam_total1.equals("0") ? "" : WebUtil.printNumFormat(chgam_total1) %>&nbsp;</td>
              </tr> --%>
    <%
        //} else {
            String total12                         = ( String ) request.getAttribute("total12");
            double sangya_tot = Double.parseDouble(total2) + Double.parseDouble(total3);
            String sangya_totl = Double.toString(sangya_tot);
            double kupya_tot = Double.parseDouble(total4) - Double.parseDouble(total2) + Double.parseDouble(total21);
            String kupya_tot1 = Double.toString(kupya_tot);
            double kita_totl = Double.parseDouble(total14) - (Double.parseDouble(total5) + Double.parseDouble(total6) + Double.parseDouble(total7) + Double.parseDouble(total8) + Double.parseDouble(total9));
            String kita_totl1 = Double.toString(kita_totl);
            double chgam_total = Double.parseDouble(total4) - Double.parseDouble(total14) ;
            String chgam_total1 = Double.toString(chgam_total);
            double kupya_tot2 = Double.parseDouble(total4) + Double.parseDouble(total21);
            String kupya_tot3 = Double.toString(kupya_tot2);
    %>
              <tr class="sumRow">
                <td class="align_center"><spring:message code="LABEL.D.D06.0011" /></td><!-- TOTAL -->
                <td><%= kupya_tot1.equals("0") ? "" : WebUtil.printNumFormat(kupya_tot1) %>&nbsp;</td>
                <td><%= total2.equals("0") ? "" : WebUtil.printNumFormat(total2) %>&nbsp;</td>
                <td><%= kupya_tot3.equals("0") ? "" : WebUtil.printNumFormat(kupya_tot3) %>&nbsp;</td>
                <td><%= total5.equals("0") ? "" : WebUtil.printNumFormat(total5) %>&nbsp;</td>
                <td><%= total6.equals("0") ? "" : WebUtil.printNumFormat(total6) %>&nbsp;</td>
                <td><%= total7.equals("0") ? "" : WebUtil.printNumFormat(total7) %>&nbsp;</td>
                <td><%= total8.equals("0") ? "" : WebUtil.printNumFormat(total8) %>&nbsp;</td>
                <td><%= total9.equals("0") ? "" : WebUtil.printNumFormat(total9) %>&nbsp;</td>
                <td><%= totalBet13.equals("0") ? "" : WebUtil.printNumFormat(totalBet13) %>&nbsp;</td><!-- [CSR ID:2995203] -->
                <td><%= kita_totl1.equals("0") ? "" : WebUtil.printNumFormat(kita_totl1) %>&nbsp;</td>
                <td><%= total14.equals("0") ? "" : WebUtil.printNumFormat(total14) %>&nbsp;</td>
                <td><%= chgam_total1.equals("0") ? "" : WebUtil.printNumFormat(chgam_total1) %>&nbsp;</td>
              </tr>
    <%
       // }
    %>
            </table>
        </div>
    </div>

<!-- [CSR ID:3621578] 연급여 화면 수정요청의 건 -->

<%
	D06YpayTaxDetailData_to_year data1 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(0);
	if(!(data1.YAI == null || data1.YAR == null)){
%>
<h2 class="subtitle"><spring:message code="LABEL.D.D06.0009" /></h2><!-- 연말정산 -->

    <div class="table">
      <table class="mpayTable">
      	<colgroup>
      		<col width="11%"/>
      		<col width="11%"/>
      		<col width="11%"/>
      		<col width="11%"/>
      		<col width="11%"/>
      		<col width="11%"/>
      		<col width="34%"/>
      	</colgroup>
      <thead>
      <tr>
      	<th class="divide" colspan="2">기납부세액</th><!-- LABEL.D.D14.0093 기납부세액 -->
	    <th class="divide" colspan="2"><spring:message code="LABEL.D.D14.0082" /></th><!-- 결정세액 -->
	    <th class="divide" colspan="2"><spring:message code="LABEL.D.D06.0009" />&nbsp;<spring:message code="LABEL.F.F79.0015" /></th><!-- 연말정산 결과 -->
	    <th class="lastCol" rowspan="2"><spring:message code="LABEL.A.A12.0030" /></th><!-- 비고 -->
        </tr>
        <tr>
          <th><spring:message code="LABEL.D.D05.0020" /></th><!-- 소득세 -->
          <th class="divide"><spring:message code="LABEL.D.D05.0021" /></th><!--주민세  -->
          <th><spring:message code="LABEL.D.D05.0020" /></th><!-- 소득세 -->
          <th class="divide"><spring:message code="LABEL.D.D05.0021" /></th><!--주민세  -->
          <th><spring:message code="LABEL.D.D05.0020" /></th><!-- 소득세 -->
          <th class="divide"><spring:message code="LABEL.D.D05.0021" /></th><!--주민세  -->
        </tr>
        </thead>
        <tr >
          <td class="align_right"  style="background-color:#fff"><%= total5.equals("0") ? "" : WebUtil.printNumFormat(total5) %>&nbsp;</td>
          <td class="align_right divide"  style="background-color:#fff"><%= total6.equals("0") ? "" : WebUtil.printNumFormat(total6) %>&nbsp;</td>
          <td class="align_right"  style="background-color:#f9f9f9"><%= data1.YAI == null ? "" : WebUtil.printNumFormat(Double.parseDouble(total5)+Double.parseDouble(data1.YAI)) %>&nbsp;</td>
          <td class="align_right divide" style="background-color:#f9f9f9"><%= data1.YAR == null ? "" : WebUtil.printNumFormat(Double.parseDouble(total6)+Double.parseDouble(data1.YAR)) %>&nbsp;</td>
          <td class="align_right" style="background-color:#fff"><%= data1.YAI == null ? "" : WebUtil.printNumFormat(data1.YAI) %>&nbsp;</td>
          <td class="align_right divide" style="background-color:#fff"><%= data1.YAR == null ? "" : WebUtil.printNumFormat(data1.YAR) %>&nbsp;</td>
          <td class="align_left lastCol" style="background-color:#fff">&nbsp;연말정산 결과가 (-)는 환급, (+)는 추징임<br>&nbsp;이는 익년도 2월급여에 지급 또는 공제 되었음</td> <!-- LABEL.D.D14.0094 연말정산 결과가 (-)는 환급, (+)는 추징임<br>&nbsp;이는 익년도 2월급여에 지급 또는 공제 되었음 -->
        </tr>
	</table>
    </div>
<%}%><!-- [CSR ID:3621578] 연급여 화면 수정요청의 건 -->


    <h2 class="subtitle"><spring:message code="LABEL.D.D06.0012" /></h2><!-- 기타사항 -->

    <div class="listArea">
      <div class="table">
        <table class="mpayTable">
          <tr>
            <th rowspan="2" width="8%"><spring:message code="LABEL.D.D05.0002" /></th><!-- 해당년월 -->
            <!-- <th rowspan="2" width="60">생산직<br>비과세</th>
            <th rowspan="2" width="50">노조비</th>  [CSR ID:2995203]-->
            <th rowspan="2" width="10%"><spring:message code="LABEL.D.D06.0013" /></th><!--  주택자금<br>이자지원-->
            <th colspan="8" ><spring:message code="LABEL.D.D06.0014" /></th><!-- 과세반영 -->
            <th class="lastCol" rowspan="2" width="10%"><spring:message code="LABEL.D.D15.0070" /></th><!-- 계 -->
          </tr>
          <tr>
            <th width="9%"><spring:message code="LABEL.D.D06.0015" /></th><!--  의료비-->
            <th width="9%"><spring:message code="LABEL.D.D06.0016" /></th><!-- 학자금 -->
            <th width="9%"><spring:message code="LABEL.D.D06.0017" /></th><!--  장학금-->
            <th width="9%"><spring:message code="LABEL.D.D06.0018" /></th><!-- 포상비 -->
            <th width="9%"><spring:message code="LABEL.D.D06.0019" /></th><!-- 장기근속상 -->
            <th width="9%"><spring:message code="LABEL.D.D06.0020" /></th><!-- 선택적<br>복리후생 -->
            <!--<th width="60">인정이자</th>[CSR ID:2995203] -->
            <th width="9%"><spring:message code="LABEL.D.D06.0021" /></th><!--산학자금 @v1.1-->
            <!--<th width="60">사내<br>강사료</th><!--@v1.1[CSR ID:2995203]-->
            <th width="9%"><spring:message code="LABEL.D.D06.0005" /></th><!-- 기타 -->
          </tr>
<%
     for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
      D06YpayDetailData_to_year data = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);

      String tr_class = "";

      if(i%2 == 0){
          tr_class="oddRow";
      }else{
          tr_class="";
      }

      String  zyy = data.ZYYMM.substring(0,4);
      String  zmm = data.ZYYMM.substring(4);
      String  yymm = zyy + zmm;
      String c_yymm = "";
      String d_yymm = "";
      int sum12 = 0;
%>
          <tr class="<%=tr_class%>">
            <td class="align_center" ><%= zyy+"."+zmm %></td>
            <td>
            <%
          //[CSR ID:2995203] 보상명세서 적용(Total Compensation)
      for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
          D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);

          if(yymm.equals(data9.YYMMDD)&& data9.LGTX1 != null && data9.LGTX1.equals("주택자금이자 지원액") ) {
              if(data9.BET01.equals("0.0")) {
                  continue;
              } else {
      %>
          <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
      <%
                  sum1 += Double.parseDouble(data9.BET01);
              }
          }
      }%>
            &nbsp;</td>
            <!--    [CSR ID:2995203]      <td >
<%          for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                    if( yymm.equals(data9.YYMMDD) && data9.LGTX4 != null &&data9.LGTX4.equals("생산직비과세")&& data9.BET04 != null  ) { //@v1.4
                        if(d_yymm.equals(data9.YYMMDD)) {
                            continue;
                        }else{
                            d_yymm = data9.YYMMDD;
%>
                  <%= data9.BET04.equals("0") ? "　" : WebUtil.printNumFormat(data9.BET04) %>&nbsp;
<%
                            //sum2 += Double.parseDouble(data9.BET04);//@v1.4
                            //sum12 += Double.parseDouble(data9.BET04);//@v1.4
                        }
                    }
                }
%>
                  </td>  -->
                  <td>
<%
               int cnt = 0;
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD) && data9.LGTX1 != null &&(data9.LGTX1.equals("과세반영(의료비)") || data9.LGTX1.equals("과세반영(의료비지원)") || data9.LGTX1.equals("소급분과세반영(의료비)"))) {
                       if(data9.BET01.equals("0.0")) {
                           continue;
                       }else{
%>
                  <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
<%
                           sum3 += Double.parseDouble(data9.BET01);
                       }
                   }
               }
%>
                  </td>

                  <td>
<%
               int cntb = 0;
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD)&& data9.LGTX1 != null && (data9.LGTX1.equals("과세반영(학자금)") || data9.LGTX1.equals("소급분과세반영(학자금)")) ) {
                       if(data9.BET01.equals("0.0")) {
                           continue;
                       }else{
%>
                  <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
<%
                           sum5 += Double.parseDouble(data9.BET01);

                       }
                   /* 이 로직 왜 있는지 모르겠음 2016.03.30 이지은D total sum 안맞아서 제외함
                   } else if(yymm.equals(data9.YYMMDD) && data9.LGTX3 != null && (data9.LGTX3.equals("과세반영(학자금)") || data9.LGTX3.equals("소급분과세반영(학자금)")))  {
                       cntb ++;
                       if(cntb==1) {
%>
                  <%= data9.BET03.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET03) %>&nbsp;
<%
                           sum5 += Double.parseDouble(data9.BET03);

                       }*/
                   }
               }
%>
                  </td>

                  <td>
<%
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD) && data9.LGTX1 != null && (data9.LGTX1.equals("과세반영(장학금)") || data9.LGTX1.equals("소급분과세반영(장학금)"))) {
                       if(data9.BET01.equals("0.0")) {
                           continue;
                       }else{
%>
                  <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
<%
                                sum6 += Double.parseDouble(data9.BET01);

                       }
                   }
               }
%>
                  </td>

                  <td>
<%
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD) && data9.LGTX1 != null && (data9.LGTX1.equals("과세반영(포상금)") || data9.LGTX1.equals("소급분과세반영(포상금)"))) {
                       if(data9.BET01.equals("0.0")) {
                           continue;
                       }else{
%>
                  <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
<%
                           sum7 += Double.parseDouble(data9.BET01);

                       }
                   }
               }
%>
                  </td>

                  <td>
<%
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD)  && data9.LGTX1 != null&& (data9.LGTX1.equals("과세반영(장기근속상)") || data9.LGTX1.equals("소급분과세반영(장기근속상)") || data9.LGTX1.equals("과세반영(장기근속포상)"))) {
                       if(data9.BET01.equals("0.0")) {
                           continue;
                       } else {
%>
                  <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
<%
                           sum8 += Double.parseDouble(data9.BET01);
                       }
                   }
               }
%>
                  </td>

                  <!--선택적복리후생 @v1.3-->
                  <td> <%
            String tLGTX1 = "";
            String tBET01 = "";
            String FlagYM_SuntagBugli = "";
            for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                if( yymm.equals(data9.YYMMDD) ) {
                     if (data9.LGTX1 != null &&FlagYM_SuntagBugli.equals("")&& ( data9.LGTX1.equals("과세반영(선택적복리후생)") || data9.LGTX1.equals("소급분과세반영(선택적복리후생)") )  ) {
                         tBET01 = data9.BET01;
                         tLGTX1 = data9.LGTX1;
                         FlagYM_SuntagBugli = "Y";
                     }
                     else {
                         tBET01 = data9.BET01;
                         tLGTX1 = data9.LGTX1;
                     }
                }else {
                     FlagYM_SuntagBugli = "";
                     tLGTX1 ="";
                     tBET01 ="0.0";
                }
                if(yymm.equals(data9.YYMMDD) && tLGTX1 != null&& (tLGTX1.equals("과세반영(선택적복리후생)") || tLGTX1.equals("소급분과세반영(선택적복리후생)") ) ) {
                    if(tBET01.equals("0.0")||tBET01.equals("0")) {
                        continue;
                    }else{
%> <%= tBET01.equals("0.0") ? "　" : WebUtil.printNumFormat(tBET01) %> <%
                        sum11 += Double.parseDouble(tBET01);
%> &nbsp; <%
                    }
                }
            }
%> </td>

           <!--   [CSR ID:2995203]     <td >
<%
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD) && data9.LGTX1 != null && (data9.LGTX1.equals("과세반영(인정이자)") || data9.LGTX1.equals("소급분과세반영(인정이자)"))) {
                       if(data9.BET01.equals("0.0")) {
                           continue;
                       } else {
%>
                   <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
<%
                           sum9 += Double.parseDouble(data9.BET01);

                       }
                   }
               }
%>
                  </td> -->
                  <!--@v1.1-->
                  <td>
<%
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD) && data9.LGTX1 != null && (data9.LGTX1.equals("과세반영(산학자금)") || data9.LGTX1.equals("소급분과세반영(산학자금)"))) {
                       if(data9.BET01.equals("0.0")) {
                           continue;
                       } else {
%>
                   <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
<%
                           sum_san += Double.parseDouble(data9.BET01);

                       }
                   }
               }
%>
                  </td>
                  <!-- [CSR ID:2995203]<td >
<%
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD)&& data9.LGTX1 != null && (data9.LGTX1.equals("과세반영(사내강사료)") || data9.LGTX1.equals("소급분과세반영(사내강사료)")) ) {
                       if(data9.BET01.equals("0.0")) {
                           continue;
                       } else {
%>
                   <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>&nbsp;
<%
                           sum_sanae += Double.parseDouble(data9.BET01);

                       }
                   }
               }
%>
                  </td> -->
                  <td>
<%
             tLGTX1 = ""; //@v1.0
             tBET01 = ""; //@v1.0

               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                //@v1.0 start
                if( yymm.equals(data9.YYMMDD) ) {
                     if (data9.LGTX1 != null && ( data9.LGTX1.equals("과세반영(기타)") || data9.LGTX1.equals("소급분과세반영(기타)") )  ) {
                         tBET01 = data9.BET01;
                         tLGTX1 = data9.LGTX1;
                     }
                     else {
                         tBET01 = "";
                         tLGTX1 = "";
                     }
                }
                //@v1.0 end
                if(yymm.equals(data9.YYMMDD) && tLGTX1 != null&& (tLGTX1.equals("과세반영(기타)") || tLGTX1.equals("소급분과세반영(기타)") ) ) {
                    if(tBET01.equals("0.0")||tBET01.equals("0")) {
                        continue;
                    }else{
%> <%= tBET01.equals("0.0") ? "　" : WebUtil.printNumFormat(tBET01) %> <%
                        sum10 += Double.parseDouble(tBET01);
%> &nbsp; <%
                    }
                }

               }
%>
                  </td>

                  <!--계-->
                  <td class="lastCol">
<%
               int cnta = 0;
               FlagYM_SuntagBugli = "";
               for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2_to_year data9 = (D06YpayDetailData2_to_year)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD)) {
                       if(data9.LGTX1 != null) {
                           if(data9.LGTX1.equals("과세반영(의료비)") || data9.LGTX1.equals("과세반영(의료비지원)") || data9.LGTX1.equals("과세반영(선택적복리후생)") || data9.LGTX1.equals("과세반영(학자금)")
                          || data9.LGTX1.equals("과세반영(장학금)") || data9.LGTX1.equals("과세반영(포상금)") || data9.LGTX1.equals("과세반영(장기근속상)") || data9.LGTX1.equals("과세반영(장기근속포상)")
                          || data9.LGTX1.equals("소급분과세반영(산학자금)") || data9.LGTX1.equals("과세반영(기타)") || data9.LGTX1.equals("소급분과세반영(의료비)") || data9.LGTX1.equals("소급분과세반영(선택적복리후생)")
                          || data9.LGTX1.equals("소급분과세반영(학자금)") || data9.LGTX1.equals("소급분과세반영(장학금)") || data9.LGTX1.equals("소급분과세반영(포상금)") || data9.LGTX1.equals("소급분과세반영(장기근속상)")
                          || data9.LGTX1.equals("과세반영(산학자금)") || data9.LGTX1.equals("소급분과세반영(기타)")
                            //||data9.LGTX1.equals("소급분과세반영(인정이자)") || data9.LGTX1.equals("과세반영(인정이자)")
                            ||data9.LGTX1.equals("주택자금이자 지원액")
                            //||data9.LGTX1.equals("과세반영(사내강사료)") || data9.LGTX1.equals("소급분과세반영(사내강사료)")
                            ) {
                               sum12 += Double.parseDouble(data9.BET01);
                               /* 이 로직 왜 있는지 모르겠음 2016.03.30 이지은D total sum 안맞아서 제외함
                                   if(data9.LGTX3.equals("과세반영(의료비)") || data9.LGTX3.equals("과세반영(의료비지원)") || data9.LGTX3.equals("소급분과세반영(의료비)") || data9.LGTX3.equals("과세반영(학자금)") || data9.LGTX3.equals("소급분과세반영(학자금)")) {
                                   cnta ++;
                                   if(cnta==1) {
                                       sum12 += Double.parseDouble(data9.BET03);
                                  }
                               }*/
                           }
                       }
                    //if(data9.LGTX3 != null) {
                    //    if( data9.LGTX3.equals("과세반영(선택적복리후생)")&&FlagYM_SuntagBugli.equals("")) {
                    //        sum12 += Double.parseDouble(data9.BET03);
                    //        FlagYM_SuntagBugli = "Y";
                    //    }
                    //}

                   }else {
                       FlagYM_SuntagBugli = "";
                   }

               }  %>
                    <%= WebUtil.printNumFormat(sum12).equals("0") ? " " : WebUtil.printNumFormat(sum12) %>
            &nbsp;</td>
          </tr>
<%   }  %>
          <tr class="sumRow">
            <td class="align_center" ><spring:message code="LABEL.D.D06.0011" /></td><!-- TOTAL -->
            <td><%= WebUtil.printNumFormat(sum1).equals("0") ? " " : WebUtil.printNumFormat(sum1) %>&nbsp;&nbsp;</td>
            <!-- [CSR ID:2995203] <td><%= WebUtil.printNumFormat(sum2).equals("0") ? " " : WebUtil.printNumFormat(sum2) %>&nbsp;</td> -->
            <td><%= WebUtil.printNumFormat(sum3).equals("0") ? " " : WebUtil.printNumFormat(sum3) %>&nbsp;&nbsp;</td>
            <td><%= WebUtil.printNumFormat(sum5).equals("0") ? " " : WebUtil.printNumFormat(sum5) %>&nbsp;&nbsp;</td>
            <td><%= WebUtil.printNumFormat(sum6).equals("0") ? " " : WebUtil.printNumFormat(sum6) %>&nbsp;&nbsp;</td>
            <td><%= WebUtil.printNumFormat(sum7).equals("0") ? " " : WebUtil.printNumFormat(sum7) %>&nbsp;&nbsp;</td>
            <td><%= WebUtil.printNumFormat(sum8).equals("0") ? " " : WebUtil.printNumFormat(sum8) %>&nbsp;&nbsp;</td>
            <td><%= WebUtil.printNumFormat(sum11).equals("0") ? " " : WebUtil.printNumFormat(sum11) %>&nbsp;</td><!--@v1.3선택적복리후생추가-->
            <!-- [CSR ID:2995203]<td><%= WebUtil.printNumFormat(sum9).equals("0") ? " " : WebUtil.printNumFormat(sum9) %>&nbsp;&nbsp;</td>-->
            <td><%= WebUtil.printNumFormat(sum_san).equals("0") ? " " : WebUtil.printNumFormat(sum_san) %>&nbsp;&nbsp;</td><!--@v1.1산학자금-->
            <!-- [CSR ID:2995203]<td><%= WebUtil.printNumFormat(sum_sanae).equals("0") ? " " : WebUtil.printNumFormat(sum_sanae) %>&nbsp;</td><!--@v1.1사내강사료추가-->
            <td><%= WebUtil.printNumFormat(sum10).equals("0") ? " " : WebUtil.printNumFormat(sum10) %>&nbsp;&nbsp;</td>
        <% int tsum = sum1+sum2+sum3+sum11+sum5+sum6+sum7+sum8+sum_san+sum10;//[CSR ID:2995203] sum_sanae+sum9+
           if (tsum != Integer.parseInt(total90)) { %>
            <td class="lastCol"><%= WebUtil.printNumFormat(tsum) %>&nbsp;&nbsp;</td>
        <% } else {%>
            <td class="lastCol"><%= WebUtil.printNumFormat(total90).equals("0") ? " " : WebUtil.printNumFormat(total90) %>&nbsp;&nbsp;</td>
        <% } %>
          </tr>
        </table>

<%  if(user.e_trfar.equals("02") || user.e_trfar.equals("03") || user.e_trfar.equals("04")) {   %>
    <div class="commentsMoreThan2">
      <div><%=g.getMessage("MSG.D.D06.0002")%><!-- 개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며, 이를 위반시에는 취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려드립니다.-->
      </div>
          </div>
    
<%  }     %>

<%
    //31:전문기술직,32:지도직,33:기능직
    //[CSR ID:2583929] 생산기술직 38 추가
    if ( user.e_persk.equals("31") ||user.e_persk.equals("32")||user.e_persk.equals("33") ||user.e_persk.equals("38") ) {
%>
    <div class="commentsMoreThan2">
      <div><%=g.getMessage("LABEL.D.D15.0119")%><!-- 근태, 월급여, 연급여 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며,<br>이를 위반 시에는 취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려 드립니다.-->
      </div>
    </div>
<%  }     %>

      </div>
    </div>
	</div>
</form>


<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

