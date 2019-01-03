<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess_m.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<jsp:include page="/web/common/includeLocation.jsp" />

<%
    String i_pernr     = request.getParameter("I_PERNR");
    String i_year      = request.getParameter("I_YEAR");
    String bet02       = request.getParameter("BET02");
    String e_sum_betrg = "";

//  작년을 구한다.
    i_year             = Integer.toString(Integer.parseInt(i_year) - 1);

    try {
        e_sum_betrg = ( new D05HealthInsuranceRFC() ).getE_SUM_BETRG( i_pernr, i_year );
    } catch(Exception ex) {
        e_sum_betrg = "";
    }

    double betrg_d = Double.parseDouble(e_sum_betrg) * 100;           //납부금액 * 100(r/3 금액이므로)
    double bet02_d = Double.parseDouble(bet02);                       //정상금액
    double result  = betrg_d + bet02_d;                               //확정금액 = 납부금액 + 정산금액
%>


<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D05.0101"/>  
    <jsp:param name="help" value="D05Mpay.html"/>    
</jsp:include>

<table width="420" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" onsubmit="return false">
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>
      <table width="391" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td align="center" ><b><u><%= i_year %><spring:message code="LABEL.D.D05.0117"/><!-- 년 건강보험 정산내역 -->
          </u></b></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td align="right">        
            <table width="390" border="0" cellspacing="1" cellpadding="2" class="table01">
              <tr> 
                <td  width="130"><spring:message code="LABEL.D.D05.0118"/><!--납부금액--></td>
                <td  width="130"><spring:message code="LABEL.D.D05.0119"/><!--확정금액--></td>
                <td  width="130"><spring:message code="LABEL.D.D05.0120"/><!--정산금액--></td>
              </tr>
              <tr> 
                <td ><%= WebUtil.printNumFormat(betrg_d) %></td>
                <td ><%= WebUtil.printNumFormat(result)  %></td>
                <td ><%= WebUtil.printNumFormat(bet02_d) %></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td align="center">
            <a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>btn_close.gif" width="49" height="20" border="0"></a>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</form>                
</table>


<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->