<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D06Ypay.*" %>
<%@ page import="hris.D.D06Ypay.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector D06YpayDetailData_vt = ( Vector ) request.getAttribute( "D06YpayDetailData_vt" ) ; // 연급여 내역 리스트
//  D06YpayTaxDetailData  d06YpayTaxDetailData = (D06YpayTaxDetailData) request.getAttribute( "d06YpayTaxDetailData"  ) ; // 
    Vector D06YpayTaxDetailData_vt = ( Vector ) request.getAttribute( "D06YpayTaxDetailData_vt" ) ; // 연말정산내역
    Vector D06YpayDetailData3_vt = ( Vector ) request.getAttribute( "D06YpayDetailData3_vt" ) ; // 과세반영 내역 조회
    
    String from_year                       = ( String ) request.getAttribute("from_year");
    String from_month                      = ( String ) request.getAttribute("from_month");
    String to_year                         = ( String ) request.getAttribute("to_year");
    String to_month                        = ( String ) request.getAttribute("to_month");
    String total1                          = ( String ) request.getAttribute("total1");
    String total2                          = ( String ) request.getAttribute("total2");
    String total3                          = ( String ) request.getAttribute("total3");
    String total4                          = ( String ) request.getAttribute("total4");
    String total5                          = ( String ) request.getAttribute("total5");
    String total6                          = ( String ) request.getAttribute("total6");
    String total7                          = ( String ) request.getAttribute("total7");
    String total8                          = ( String ) request.getAttribute("total8");
    String total9                          = ( String ) request.getAttribute("total9");
    String total13                         = ( String ) request.getAttribute("total13");
    String total14                         = ( String ) request.getAttribute("total14");
    String total15                         = ( String ) request.getAttribute("total15");
    String total90                         = ( String ) request.getAttribute("total90");
    
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
    int sum10 = 0;
    int sum11 = 0;
%>

<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_ANNU_PAY"/>  
    <jsp:param name="help" value="D06Mpay.html"/>    
</jsp:include>

<SCRIPT LANGUAGE="JavaScript"> 
<!--
            function f_print(){
                self.print();
                window.close();
                }
//-->
</SCRIPT> 

<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="center"><img src="<%= WebUtil.ImageURL %>img_Ypay.gif" width="151" height="20"></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td> 
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02" align="center" bordercolor="#CCCCCC">
          <tr> 
            <td  rowspan="2" width="60" valign="center">
                <spring:message code="LABEL.D.D05.0002" /></td><!-- 해당년월 -->
            <td  colspan="3">
                <spring:message code="LABEL.D.D05.0014" /></td><!--  지급내역-->
            <td  colspan="7" style="border-left:1.5pt solid windowtext; border-color: #80B0F0">
                <spring:message code="LABEL.D.D05.0016" /></td><!--  공제내역-->
            <td  rowspan="2" width="69" valign="center">
                <spring:message code="LABEL.D.D05.0012" /></td><!-- 차감지급액 -->
          </tr>
          <tr> 
            <td  width="66"><spring:message code="LABEL.D.D06.0022" /></td><!-- 급여 -->
            <td  width="63"><spring:message code="LABEL.D.D06.0023" /></td><!-- 상여 -->
            <td  width="63"><spring:message code="LABEL.D.D05.0022" /></td><!-- 지급계 -->
            <td  width="71" style="border-left:1.5pt solid windowtext; border-color: #80B0F0">
                   <spring:message code="LABEL.D.D06.0020" /></td><!--  "갑근세"였으나 소득세로 통일됨 -->
            <td  width="71"><spring:message code="LABEL.D.D05.0021" /></td><!--주민세  -->
            <td  width="72"><spring:message code="LABEL.D.D06.0007" /></td><!--  건강<br>보험료-->
            <td  width="71"><spring:message code="LABEL.D.D05.0019" /></td><!-- 고용<br>보험료 -->
            <td  width="66"><spring:message code="LABEL.D.D05.0018" /></td><!-- 국민연금 -->
            <td  width="63"><spring:message code="LABEL.D.D06.0005" /></td><!-- 기타 -->
            <td  width="55"><spring:message code="LABEL.D.D05.0023" /></td><!--  공제계-->
          </tr>
<% 
    for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
        D06YpayDetailData data = (D06YpayDetailData)D06YpayDetailData_vt.get(i);
        int j = 0;
        String  zyy = data.ZYYMM.substring(0,4);
        String  zmm = data.ZYYMM.substring(4);
        double sangyo = Double.parseDouble(data.BET02) + Double.parseDouble(data.BET03);
        String sangyo1 = Double.toString(sangyo);
        double kupya = Double.parseDouble(data.BET04) - Double.parseDouble(data.BET02);
        String kupya1 = Double.toString(kupya);
        double kita =  Double.parseDouble(data.BET11) - (Double.parseDouble(data.BET05) + Double.parseDouble(data.BET06) + Double.parseDouble(data.BET07) + Double.parseDouble(data.BET08) + Double.parseDouble(data.BET09));
        String kita1 = Double.toString(kita);
%>
          <tr> 
            <td ><%= zyy+"."+zmm %></td>
            <td ><%= kupya1.equals("0") ? "" : WebUtil.printNumFormat(kupya1) %>&nbsp;</td>
            <td ><%= data.BET02.equals("0") ? "" : WebUtil.printNumFormat(data.BET02) %>&nbsp; </td>
            <td ><%= data.BET04.equals("0") ? "" : WebUtil.printNumFormat(data.BET04) %>&nbsp; </td>
            <td  style="border-left:1.5pt solid windowtext; border-color: #80B0F0"><%= data.BET05.equals("0") ? "" : WebUtil.printNumFormat(data.BET05) %>&nbsp; </td>
            <td ><%= data.BET06.equals("0") ? "" : WebUtil.printNumFormat(data.BET06) %>&nbsp;</td>
            <td ><%= data.BET07.equals("0") ? "" : WebUtil.printNumFormat(data.BET07) %>&nbsp;</td>
            <td ><%= data.BET08.equals("0") ? "" : WebUtil.printNumFormat(data.BET08) %>&nbsp;</td>
            <td ><%= data.BET09.equals("0") ? "" : WebUtil.printNumFormat(data.BET09) %>&nbsp;</td>
            <td ><%= kita1.equals("0") ? "" : WebUtil.printNumFormat(kita1) %>&nbsp;</td>
            <td ><%= data.BET11.equals("0") ? "" : WebUtil.printNumFormat(data.BET11) %>&nbsp;</td>
            <td ><%= data.BET12.equals("0") ? "" : WebUtil.printNumFormat(data.BET12) %>&nbsp;</td>
         </tr>
<%      if(zmm.equals("12")){
            yno = "Y" ;
            D06YpayTaxDetailData data1 = (D06YpayTaxDetailData)D06YpayTaxDetailData_vt.get(j);
%>
          <tr>
            <td ><spring:message code="LABEL.D.D06.0009" /></td><!-- 연말정산 -->
            <td  colspan="2" align="right"><%= data1.YIC == null ? "" : "인정이자 -->" %></td>
            <td ><%= data1.YIC == null ? "" : WebUtil.printNumFormat(data1.YIC) %>&nbsp;</td>
            <td  style="border-left:1.5pt solid windowtext; border-color: #80B0F0"><%= data1.YAI == null ? "" : WebUtil.printNumFormat(data1.YAI) %>&nbsp;</td>
            <td ><%= data1.YAR == null ? "" : WebUtil.printNumFormat(data1.YAR) %>&nbsp;</td>
            <td ><%= data1.YAS == null ? "" : WebUtil.printNumFormat(data1.YAS) %>&nbsp;</td>
            <td >&nbsp;</td>
            <td >&nbsp;</td>
            <td >&nbsp;</td>
            <td >&nbsp;</td>
            <td >&nbsp;</td>
          </tr>
<%  
            j++ ;
        }     
    }

    if( yno.equals("Y")){               
        String total10                         = ( String ) request.getAttribute("total10");
        String total11                         = ( String ) request.getAttribute("total11");
        String total12                         = ( String ) request.getAttribute("total12");
        double kabgn = Double.parseDouble(total10);
        double jumin = Double.parseDouble(total11);
        double kabgn_tot = Double.parseDouble(total5);
        double jumin_tot = Double.parseDouble(total6);
        String kabgn_tot1 = Double.toString(kabgn + kabgn_tot);
        String jumin_tot1 = Double.toString(jumin + jumin_tot);
        double sangya_tot = Double.parseDouble(total2) + Double.parseDouble(total3);
        String sangya_totl = Double.toString(sangya_tot);
        double kupya_tot = Double.parseDouble(total4) - Double.parseDouble(total2);
        String kupya_tot1 = Double.toString(kupya_tot);
        double kita_totl = Double.parseDouble(total14) - (Double.parseDouble(jumin_tot1) + Double.parseDouble(total7) + Double.parseDouble(total8) + Double.parseDouble(total9));
        String kita_totl1 = Double.toString(kita_totl);
        
        D06YpayTaxDetailData data1 = (D06YpayTaxDetailData)D06YpayTaxDetailData_vt.get(0);
        double inja = Double.parseDouble(total4) + Double.parseDouble(data1.YIC == null ? "0" : data1.YIC);
        String inja1 = Double.toString(inja);
%>
          <tr> 
            <td ><spring:message code="LABEL.D.D06.0011" /></td><!-- TOTAL -->
            <td ><%= kupya_tot1.equals("0") ? "" : WebUtil.printNumFormat(kupya_tot1) %>&nbsp;</td>
            <td ><%= total2.equals("0") ? "" : WebUtil.printNumFormat(total2) %>&nbsp;</td>
            <td ><%= inja1.equals("0") ? "" : WebUtil.printNumFormat(inja1) %>&nbsp;</td>
            <td  style="border-left:1.5pt solid windowtext; border-color: #80B0F0"><%= kabgn_tot1.equals("0") ? "" : WebUtil.printNumFormat(kabgn_tot1) %>&nbsp;</td>
            <td ><%= jumin_tot1.equals("0") ? "" : WebUtil.printNumFormat(jumin_tot1) %>&nbsp;</td>
            <td ><%= total7.equals("0") ? "" : WebUtil.printNumFormat(total7) %>&nbsp;</td>
            <td ><%= total8.equals("0") ? "" : WebUtil.printNumFormat(total8) %>&nbsp;</td>
            <td ><%= total9.equals("0") ? "" : WebUtil.printNumFormat(total9) %>&nbsp;</td>
            <td ><%= kita_totl1.equals("0") ? "" : WebUtil.printNumFormat(kita_totl1) %>&nbsp;</td>
            <td ><%= total14.equals("0") ? "" : WebUtil.printNumFormat(total14) %>&nbsp;</td>
            <td ><%= total15.equals("0") ? "" : WebUtil.printNumFormat(total15) %>&nbsp;</td>
          </tr>
<%
    } else {    
        String total12                         = ( String ) request.getAttribute("total12");
        double sangya_tot = Double.parseDouble(total2) + Double.parseDouble(total3);
        String sangya_totl = Double.toString(sangya_tot);
        double kupya_tot = Double.parseDouble(total4) - Double.parseDouble(total2);
        String kupya_tot1 = Double.toString(kupya_tot);
        double kita_totl = Double.parseDouble(total14) - (Double.parseDouble(total5) + Double.parseDouble(total6) + Double.parseDouble(total7) + Double.parseDouble(total8) + Double.parseDouble(total9));
        String kita_totl1 = Double.toString(kita_totl);
%>
          <tr> 
            <td ><spring:message code="LABEL.D.D06.0011" /></td><!-- TOTAL -->
            <td ><%= kupya_tot1.equals("0") ? "" : WebUtil.printNumFormat(kupya_tot1) %>&nbsp;</td>
            <td ><%= total2.equals("0") ? "" : WebUtil.printNumFormat(total2) %>&nbsp;</td>
            <td ><%= total4.equals("0") ? "" : WebUtil.printNumFormat(total4) %>&nbsp;</td>
            <td  style="border-left:1.5pt solid windowtext; border-color: #80B0F0"><%= total5.equals("0") ? "" : WebUtil.printNumFormat(total5) %>&nbsp;</td>
            <td ><%= total6.equals("0") ? "" : WebUtil.printNumFormat(total6) %>&nbsp;</td>
            <td ><%= total7.equals("0") ? "" : WebUtil.printNumFormat(total7) %>&nbsp;</td>
            <td ><%= total8.equals("0") ? "" : WebUtil.printNumFormat(total8) %>&nbsp;</td>
            <td ><%= total9.equals("0") ? "" : WebUtil.printNumFormat(total9) %>&nbsp;</td>
            <td ><%= kita_totl1.equals("0") ? "" : WebUtil.printNumFormat(kita_totl1) %>&nbsp;</td>
            <td ><%= total14.equals("0") ? "" : WebUtil.printNumFormat(total14) %>&nbsp;</td>
            <td ><%= total15.equals("0") ? "" : WebUtil.printNumFormat(total15) %>&nbsp;</td>
          </tr>
<%
    }
%>
        </table>
      </td>
    </tr>
  </table>
  <table>
    <tr>
      <td>
         &nbsp;
      </td>
    </tr>
  </table>
<%-- 
    if(!total90.equals("0")){ 
--%>  
  <table align="center">
    <tr>
      <td>
        <table width="750" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td  align="left">■ <spring:message code="LABEL.D.D06.0012" />&nbsp;&nbsp;</td><!-- 기타사항 -->
            <td></td>
          </tr>
        </table>
      </td>  
    </tr>
    <tr>
      <td>
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02">
          <tr> 
            <td  rowspan="2" width="60" valign="center">
                <spring:message code="LABEL.D.D05.0002" /></td> <!--  해당년월-->
            <td  rowspan="2" width="85">
                 <spring:message code="LABEL.D.D06.0036" /></td><!--생산직비과세  -->
            <td  rowspan="2" width="50">
                <spring:message code="LABEL.D.D06.0008" /></td><!-- 노조비 -->
            <td  colspan="9" style="border-left:1.5pt solid windowtext; border-color: #80B0F0" valign="center">
                <spring:message code="LABEL.D.D06.0014" /></td><!-- 과세반영 -->
          </tr>
          <tr> 
            <td  width="60" style="border-left:1.5pt solid windowtext; border-color: #80B0F0">
                <spring:message code="LABEL.D.D06.0015" /></td><!--  의료비-->
            <td  width="70"><spring:message code="LABEL.D.D06.0037" /></td><!--입학축하금  -->
            <td  width="60"><spring:message code="LABEL.D.D06.0016" /></td><!-- 학자금 -->
            <td  width="70"><spring:message code="LABEL.D.D06.0017" /></td><!--  장학금-->
            <td  width="65"><spring:message code="LABEL.D.D06.0018" /></td><!-- 포상비 -->
            <td  width="70"><spring:message code="LABEL.D.D06.0019" /></td><!-- 장기<br>근속상 -->
            <td  width="70"><spring:message code="LABEL.D.D06.0038" /></td><!-- 인정이자 -->
            <td  width="70"><spring:message code="LABEL.D.D06.0005" /></td><!-- 기타 -->
            <td  width="60"><spring:message code="LABEL.D.D15.0070" /></td><!-- 계 -->
          </tr>
<% 
     for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
      D06YpayDetailData data = (D06YpayDetailData)D06YpayDetailData_vt.get(i);
      String  zyy = data.ZYYMM.substring(0,4);
      String  zmm = data.ZYYMM.substring(4);
      String  yymm = zyy + zmm;
      String c_yymm = "";
      String d_yymm = "";
      int sum12 = 0;
%>      
          <tr> 
            <td ><%= zyy+"."+zmm %></td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
                   if(yymm.equals(data9.YYMMDD) && data9.BET02 != null) {  
                      if(c_yymm.equals(data9.YYMMDD)) {                     
                         continue;      
                   }else{
                 	c_yymm = data9.YYMMDD;
            %>       
                    <%= data9.BET02.equals("0") ? "　" : WebUtil.printNumFormat(data9.BET02) %>
                    <% sum1 += Double.parseDouble(data9.BET02); %>
            <%     }      %>
            <%    }    %>
             <%  }  %>
            &nbsp;</td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            
                  if(yymm.equals(data9.YYMMDD) && data9.BET03 != null) {  
                    if(d_yymm.equals(data9.YYMMDD)) {                     
                       continue;               
                    }else{                                                
                         d_yymm = data9.YYMMDD; 
            %>
                      <%= data9.BET03.equals("0") ? "　" : WebUtil.printNumFormat(data9.BET03) %>
                      <% sum2 += Double.parseDouble(data9.BET03); %>
            <%      }      %>
            <%    }    %>
            <%  }      %>
            &nbsp;</td>
            <td  style="border-left:1.5pt solid windowtext; border-color: #80B0F0">
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%    if(yymm.equals(data9.YYMMDD) && (data9.LGTX1.equals("과세반영(의료비)") || data9.LGTX1.equals("소급분과세반영(의료비)")) && data9.LGTX1 != null) {  %>
                   <%     if(data9.BET01.equals("0.0")) {      
                    continue;     
                   }else{             %> 
                    <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>
                    <% sum3 += Double.parseDouble(data9.BET01); %>&nbsp;
            <%     }      %>
            <%    }    %>
            <%  }  %> 
            </td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%    if(yymm.equals(data9.YYMMDD) && (data9.LGTX1.equals("과세반영(입학축하금)") || data9.LGTX1.equals("소급분과세반영(입학축하금)")) && data9.LGTX1 != null) {  %>
            <%     if(data9.BET01.equals("0.0")) {      
                    continue;     
                   }else{             %>
                    <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>
                    <% sum4 += Double.parseDouble(data9.BET01); %>&nbsp;
            <%     }      %>
            <%    }    %>
            <%  }  %> 
            </td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%    if(yymm.equals(data9.YYMMDD) && (data9.LGTX1.equals("과세반영(학자금)") || data9.LGTX1.equals("소급분과세반영(학자금)")) && data9.LGTX1 != null) {  %>
            <%     if(data9.BET01.equals("0.0")) {      
                    continue;     
                   }else{             %>
                    <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>
                    <% sum5 += Double.parseDouble(data9.BET01); %>&nbsp;
            <%     }      %>
            <%    }    %>
            <%  }  %> 
            </td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%    if(yymm.equals(data9.YYMMDD) && (data9.LGTX1.equals("과세반영(장학금)") || data9.LGTX1.equals("소급분과세반영(장학금)")) && data9.LGTX1 != null) {  %>
            <%     if(data9.BET01.equals("0.0")) {      
                    continue;     
                   }else{             %>
                    <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>
                    <% sum6 += Double.parseDouble(data9.BET01); %>&nbsp;
            <%     }      %>
            <%    }    %>
            <%  }  %> 
            </td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%    if(yymm.equals(data9.YYMMDD) && (data9.LGTX1.equals("과세반영(포상금)") || data9.LGTX1.equals("소급분과세반영(포상금)")) && data9.LGTX1 != null) {  %>
            <%     if(data9.BET01.equals("0.0")) {      
                    continue;     
                   }else{             %>
                    <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>
                    <% sum7 += Double.parseDouble(data9.BET01); %>&nbsp;
            <%     }      %>
            <%    }    %>
            <%  }  %> 
            </td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%    if(yymm.equals(data9.YYMMDD) && (data9.LGTX1.equals("과세반영(장기근속상)") || data9.LGTX1.equals("소급분과세반영(장기근속상)")) && data9.LGTX1 != null) {  %>
            <%     if(data9.BET01.equals("0.0")) {      
                    continue;     
                   }else{             %>
                    <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>
                    <% sum8 += Double.parseDouble(data9.BET01); %>&nbsp;
            <%     }      %>
            <%    }    %>
            <%  }  %> 
            </td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%    if(yymm.equals(data9.YYMMDD) && (data9.LGTX1.equals("과세반영(인정이자)") || data9.LGTX1.equals("소급분과세반영(인정이자)")) && data9.LGTX1 != null) {  %>
            <%     if(data9.BET01.equals("0.0")) {      
                    continue;     
                   }else{             %>
                    <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>
                    <% sum9 += Double.parseDouble(data9.BET01); %>&nbsp;
            <%     }      %>
            <%    }    %>
            <%  }  %> 
            </td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%    if(yymm.equals(data9.YYMMDD) && (data9.LGTX1.equals("과세반영(기타)") || data9.LGTX1.equals("소급분과세반영(기타)")) && data9.LGTX1 != null) {  %>
            <%     if(data9.BET01.equals("0.0")) {      
                    continue;     
                   }else{             %>
                    <%= data9.BET01.equals("0.0") ? "　" : WebUtil.printNumFormat(data9.BET01) %>
                    <% sum10 += Double.parseDouble(data9.BET01); %>&nbsp;
            <%     }      %>
            <%    }    %>
            <%  }  %> 
            </td>
            <td >
            <% 
                for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
                   D06YpayDetailData2 data9 = (D06YpayDetailData2)D06YpayDetailData3_vt.get(j);
            %>
            <%  if(yymm.equals(data9.YYMMDD)) { %>
            <%   if(data9.LGTX1 != null) {      %>
            <%    if(data9.LGTX1.equals("과세반영(의료비)") || data9.LGTX1.equals("과세반영(입학축하금)") || data9.LGTX1.equals("과세반영(학자금)") || data9.LGTX1.equals("과세반영(장학금)") || data9.LGTX1.equals("과세반영(포상금)") || data9.LGTX1.equals("과세반영(장기근속상)") || data9.LGTX1.equals("과세반영(인정이자)") || data9.LGTX1.equals("과세반영(기타)") ||
                     data9.LGTX1.equals("소급분과세반영(의료비)") || data9.LGTX1.equals("소급분과세반영(입학축하금)") || data9.LGTX1.equals("소급분과세반영(학자금)") || data9.LGTX1.equals("소급분과세반영(장학금)") || data9.LGTX1.equals("소급분과세반영(포상금)") || data9.LGTX1.equals("소급분과세반영(장기근속상)") || data9.LGTX1.equals("소급분과세반영(인정이자)") || data9.LGTX1.equals("소급분과세반영(기타)")) {  
            %>
                    <% sum12 += Double.parseDouble(data9.BET01); %>
            <%    }    %>
            <%   }     %>
            <%  }  %>
            <%  }  %> 
                    <%= WebUtil.printNumFormat(sum12).equals("0") ? " " : WebUtil.printNumFormat(sum12) %>
            &nbsp;</td>
          </tr>
<%   }  %>
          <tr> 
            <td ><spring:message code="LABEL.D.D06.0011" /></td><!-- TOTAL -->
            <td ><%= WebUtil.printNumFormat(sum1).equals("0") ? " " : WebUtil.printNumFormat(sum1) %>&nbsp;&nbsp;</td>
            <td ><%= WebUtil.printNumFormat(sum2).equals("0") ? " " : WebUtil.printNumFormat(sum2) %>&nbsp;&nbsp;</td>
            <td  style="border-left:1.5pt solid windowtext; border-color: #80B0F0"><%= WebUtil.printNumFormat(sum3).equals("0") ? " " : WebUtil.printNumFormat(sum3) %>&nbsp;&nbsp;</td>
            <td ><%= WebUtil.printNumFormat(sum4).equals("0") ? " " : WebUtil.printNumFormat(sum4) %>&nbsp;&nbsp;</td>
            <td ><%= WebUtil.printNumFormat(sum5).equals("0") ? " " : WebUtil.printNumFormat(sum5) %>&nbsp;&nbsp;</td>
            <td ><%= WebUtil.printNumFormat(sum6).equals("0") ? " " : WebUtil.printNumFormat(sum6) %>&nbsp;&nbsp;</td>
            <td ><%= WebUtil.printNumFormat(sum7).equals("0") ? " " : WebUtil.printNumFormat(sum7) %>&nbsp;&nbsp;</td>
            <td ><%= WebUtil.printNumFormat(sum8).equals("0") ? " " : WebUtil.printNumFormat(sum8) %>&nbsp;&nbsp;</td>
            <td ><%= WebUtil.printNumFormat(sum9).equals("0") ? " " : WebUtil.printNumFormat(sum9) %>&nbsp;&nbsp;</td>
            <td ><%= WebUtil.printNumFormat(sum10).equals("0") ? " " : WebUtil.printNumFormat(sum10) %>&nbsp;&nbsp;</td>
            <td ><%= total90.equals("0") ? "" : WebUtil.printNumFormat(total90) %>&nbsp;&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td ><font color="#0000FF"><b><spring:message code="MSG.D.D06.0005" /></span>
      <!--  
                 ※ 근로소득원천징수영수증의 총급여액은 연간 급여/상여 합계금액과 과세반영액을 합산한 금액임.
       --> 
      </b></font></td>
    </tr>
  </table>
<%-- 
    } 
--%>  
</form>


<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
