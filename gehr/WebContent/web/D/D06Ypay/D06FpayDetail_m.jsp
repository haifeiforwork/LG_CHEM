<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연급여                                                      */
/*   Program Name : 연급여                                                      */
/*   Program ID   : D06FpayDetail_m.jsp                                         */
/*   Description  : 해외근무자 국내급여 내역                                    */
/*   Note         :                                                             */
/*   Creation     : 2003-01-30  최영호                                          */
/*   Update       : 2005-03-16  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D06Ypay.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    WebUserData user_m = WebUtil.getSessionMSSUser(request);

    Vector D06YpayDetailData_vt    = ( Vector ) request.getAttribute( "D06YpayDetailData_vt" ) ; // 연급여 내역 리스트
    Vector D06FpayDetailData_vt    = ( Vector ) request.getAttribute( "d06FpayDetailData_vt" ) ; // 해외근무자 국내급여 내역

    Vector D06YpayTaxDetailData_vt = ( Vector ) request.getAttribute( "D06YpayTaxDetailData_vt" ) ; // 연말정산내역

    String from_year  = ( String ) request.getAttribute("from_year");
    String from_month = ( String ) request.getAttribute("from_month");
    String to_year    = ( String ) request.getAttribute("to_year");
    String to_month   = ( String ) request.getAttribute("to_month");
    String total1     = ( String ) request.getAttribute("total1");
    String total2     = ( String ) request.getAttribute("total2");
    String total3     = ( String ) request.getAttribute("total3");
    String total4     = ( String ) request.getAttribute("total4");
    String total16    = ( String ) request.getAttribute("total16");
    String total17    = ( String ) request.getAttribute("total17");
    String total18    = ( String ) request.getAttribute("total18");
    String total19    = ( String ) request.getAttribute("total19");
    String total20    = ( String ) request.getAttribute("total20");

    double tol_kubyo1 = Double.parseDouble(total1);
    double tol_sanyo1 = Double.parseDouble(total4);
    String kuknae1 = Double.toString(tol_kubyo1 - tol_sanyo1);

    String yno = "" ;

%>

<jsp:include page="/include/header.jsp" >
	<jsp:param name="script" value="tr_odd_even_row.js" />
</jsp:include>

<style>
td{text-align:right !important;}
  .subWrapper {width:950px;}

</style>

<!-- body header 부 title 및 body 시작 부 선언 : 해외근무자 국내급여 내역-->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D06.0033"/>  
    <jsp:param name="help" value="X03PersonInfo.html"/>    
</jsp:include>

<script language="JavaScript">
<!--

function  doSearchDetail() {

    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayKoreaSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
//-->
</script>

<form name="form1" method="post" action="">

          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          
    <div class="tableArea">
      <div class="table">
        
          <%
           // 사원 검색한 사람이 있을때
           if ( user_m != null ) {
           %>
         

        <table class="mpayTable">
          
              <!--급여명세 테이블 시작-->
                <tr>
                  <th class="align_center" rowspan="2" width="64" valign="bottom">
                        <spring:message code="LABEL.D.D05.0002" /></td><!--해당년월  -->
                  <th class="align_center" colspan="5">
                        <spring:message code="LABEL.D.D05.0014" /></td><!-- 지급내역 -->
                  <th class="align_center lastCol" colspan="2" >
                        <spring:message code="LABEL.D.D05.0016" /></td><!-- 공제내역 -->
                </tr>
                <tr>
                  <th  width="90"><spring:message code="LABEL.D.D06.0022" /></td>
                  <th  width="90"><spring:message code="LABEL.D.D06.0023" /></td>
                  <th  width="90"><spring:message code="LABEL.D.D06.0029" /></td><!-- 국내생계비 -->
                  <th  width="90"><spring:message code="LABEL.D.D06.0030" /></td><!-- 국내주택비 -->
                  <th  width="90"><spring:message code="LABEL.D.D05.0022" /></td>
                  <th  width="90"><spring:message code="LABEL.D.D06.0031" /></td><!--  국내갑근세-->
                  <th class="lastCol" width="90"><spring:message code="LABEL.D.D06.0032" /></td><!-- 국내주민세  -->
                </tr>
<%
    for ( int i = 0 ; i < D06FpayDetailData_vt.size() ; i++ ) {
    D06FpayDetailData data   = (D06FpayDetailData)D06FpayDetailData_vt.get(i);
    int j = 0;
     String fyymm = data.FYYMM.substring(0,6);
     double tol_kubyo = Double.parseDouble(data.BET01);
     double tol_sanyo = Double.parseDouble(data.BET15.equals("") ? "0" : data.BET15);
     String kuknae = Double.toString(tol_kubyo - tol_sanyo);
     String  zyy = data.FYYMM.substring(0,4);
     String  zmm = data.FYYMM.substring(4,6);
// 지급계 = 급여 + 상여 + 국내생계비 + 국내주택비
     double jigb = Double.parseDouble(data.BET16) + Double.parseDouble(data.BET17) 
     + Double.parseDouble(data.BET04) + Double.parseDouble(data.BET05);
     String jigb_1 = Double.toString(jigb);

%>
<%  if(!data.BET01.equals("0")) {  %>
                <tr>
                  <td class="align_center" ><%= zyy+"."+zmm %></td>
                  <td ><%= data.BET16.equals("0") ? "" : WebUtil.printNumFormat(data.BET16) %>&nbsp;</td>
                  <td ><%= data.BET17.equals("") ? "" : WebUtil.printNumFormat(data.BET17) %>&nbsp;</td>
                  <td ><%= data.BET04.equals("") ? "" : WebUtil.printNumFormat(data.BET04) %>&nbsp;</td>
                  <td ><%= data.BET05.equals("0") ? "" : WebUtil.printNumFormat(data.BET05) %>&nbsp;</td>
                  <td ><%= jigb_1.equals("0") ? "" : WebUtil.printNumFormat(jigb_1) %>&nbsp;</td>
                  <td ><%= data.BET07.equals("0") ? "" : WebUtil.printNumFormat(data.BET07) %>&nbsp;</td>
                  <td class="lastCol"><%= data.BET08.equals("0") ? "" : WebUtil.printNumFormat(data.BET08) %>&nbsp;</td>
                </tr>
<%  }  %>
<%      if(zmm.equals("12") && !data.BET01.equals("0")){
        yno = "Y" ;
        D06YpayTaxDetailData data1 = (D06YpayTaxDetailData)D06YpayTaxDetailData_vt.get(j);
%>
                <tr>
                  <td class="align_center"><spring:message code="LABEL.D.D06.0009" /></td><!-- 연말정산 -->
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td  ><%= data1.YAI == null ? "" : WebUtil.printNumFormat(data1.YAI) %>&nbsp;</td>
                  <td class="lastCol"><%= data1.YAR == null ? "" : WebUtil.printNumFormat(data1.YAR) %>&nbsp;</td>
                </tr>
<%
          j++ ;
    }

%>


<%  }   %>
<%      if( yno.equals("Y")){
        String total10                         = ( String ) request.getAttribute("total10");
        String total11                         = ( String ) request.getAttribute("total11");

        double kabgn = Double.parseDouble(total10);
        double jumin = Double.parseDouble(total11);
        double kabgn_tot = Double.parseDouble(total2);
        double jumin_tot = Double.parseDouble(total3);
        String kabgn_tot1 = Double.toString(kabgn + kabgn_tot);
        String jumin_tot1 = Double.toString(jumin + jumin_tot);
%>

                <tr class="sumRow">
                  <th ><spring:message code="LABEL.D.D06.0011" /></td><!-- TOTAL -->
                  <td ><%= total16.equals("0") ? "" : WebUtil.printNumFormat(total16) %>&nbsp;</td>
                  <td ><%= total17.equals("0") ? "" : WebUtil.printNumFormat(total17) %>&nbsp;</td>
                  <td ><%= total18.equals("0") ? "" : WebUtil.printNumFormat(total18) %>&nbsp;</td>
                  <td ><%= total19.equals("0") ? "" : WebUtil.printNumFormat(total19) %>&nbsp;</td>
                  <td ><%= total20.equals("0") ? "" : WebUtil.printNumFormat(total20) %>&nbsp;</td>
                  <td  ><%= kabgn_tot1.equals("0") ? "" : WebUtil.printNumFormat(kabgn_tot1) %>&nbsp;</td>
                  <td class="lastCol"><%= jumin_tot1.equals("0") ? "" : WebUtil.printNumFormat(jumin_tot1) %>&nbsp;</td>
                </tr>
<%     } else {     %>
                <tr class="sumRow">
                  <th ><spring:message code="LABEL.D.D06.0011" /></td><!-- TOTAL -->
                  <td ><%= total16.equals("0") ? "" : WebUtil.printNumFormat(total16) %>&nbsp;</td>
                  <td ><%= total17.equals("0") ? "" : WebUtil.printNumFormat(total17) %>&nbsp;</td>
                  <td ><%= total18.equals("0") ? "" : WebUtil.printNumFormat(total18) %>&nbsp;</td>
                  <td ><%= total19.equals("0") ? "" : WebUtil.printNumFormat(total19) %>&nbsp;</td>
                  <td ><%= total20.equals("0") ? "" : WebUtil.printNumFormat(total20) %>&nbsp;</td>
                  <td  ><%= total2.equals("0") ? "" : WebUtil.printNumFormat(total2) %></td>
                  <td class="lastCol"><%= total3.equals("0") ? "" : WebUtil.printNumFormat(total3) %></td>
                </tr>
<%     }    %>
              </table>
              
          
<%  }  %>    
      
      
            <div class="buttonArea">

                <ul class="btn_crud">
                    <!-- 			        <li><a href="javascript:parent.hidePop();"> -->
                    <li><a href="javascript:history.back();">
                        <span><spring:message code="BUTTON.COMMON.BACK"></spring:message></span></a></li>
                </ul>

            </div>
            
         </div>
	</div>
  </form>


<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
