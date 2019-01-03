<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustPreWorkDetail.jsp                               */
/*   Description  : 전근무지 입력 및 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2005.12.02 kds                                              */
/*   Update       :                                                             */
/* 					2018.01.04 cykim   [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건  */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC            = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData  = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector preWork_vt = (Vector)request.getAttribute("preWork_vt" );
    Vector preWorkHeadNm_vt = (Vector)request.getAttribute("preWorkHeadNm_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax08";
    int preWork_count = 3;
    Vector preWorkModify_vt = new Vector();
    D11TaxAdjustPreWorkData dataD11TaxAdjustPreWorkData = new D11TaxAdjustPreWorkData();

    for ( int j = 0 ; j < preWork_vt.size()  ; j++ ) {
        D11TaxAdjustPreWorkData data = (D11TaxAdjustPreWorkData)preWork_vt.get(j);
            preWorkModify_vt.addElement(data);
    }

    for ( int j = preWork_vt.size() ; j < preWork_count  ; j++ ) {
            dataD11TaxAdjustPreWorkData.BEGDA="";
            dataD11TaxAdjustPreWorkData.ENDDA="";
            dataD11TaxAdjustPreWorkData.PERNR="";
            dataD11TaxAdjustPreWorkData.SEQNR="";
            dataD11TaxAdjustPreWorkData.BIZNO="";
            dataD11TaxAdjustPreWorkData.COMNM="";
            dataD11TaxAdjustPreWorkData.TXPAS="";
            dataD11TaxAdjustPreWorkData.PABEG="";
            dataD11TaxAdjustPreWorkData.PAEND="";
            dataD11TaxAdjustPreWorkData.EXBEG="";
            dataD11TaxAdjustPreWorkData.EXEND="";
            dataD11TaxAdjustPreWorkData.LGA01="";
            dataD11TaxAdjustPreWorkData.BET01="";
            dataD11TaxAdjustPreWorkData.LGA02="";
            dataD11TaxAdjustPreWorkData.BET02="";
            dataD11TaxAdjustPreWorkData.LGA03="";
            dataD11TaxAdjustPreWorkData.BET03="";
            dataD11TaxAdjustPreWorkData.LGA04="";
            preWorkModify_vt.addElement(dataD11TaxAdjustPreWorkData);
    }

    D11TaxAdjustPreWorkData data1 = new D11TaxAdjustPreWorkData();


%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
// 전근무지 - 수정
function do_change() {
    document.form1.jobid.value = "change_first";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPreWorkSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}
</SCRIPT>
 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>

<form name="form1" method="post">
    <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

<!-- @2016연말정산 -->
    <div class="commentsMoreThan2">
    	<div>	<spring:message code="LABEL.D.D11.0232" arguments="<%= targetYear %>" /><%-- <%= targetYear %>년 자매사 전입자, 경력입사자, 신규입사자 중 전근무지 소득이 있었던 해당자는 전근무지에서 발급받은 --%>
    	<spring:message code="LABEL.D.D11.0233" /><!-- 근로소득원천징수영수증에 표시된 각 항목에 대하여 입력 후 저장하시기 바랍니다. --></p></div>
    </div>
<!-- @2016연말정산 끝 -->

    <!--전근무지 테이블 시작-->
 <div class="listArea">
        <div class="table">
           <table class="tableGeneral">
        <tr>

<%

    String BET00[] = new String[45];
    String Inx = "";
    for( int i = 0 ; i < preWorkModify_vt.size() ; i++ ){
        D11TaxAdjustPreWorkData data = (D11TaxAdjustPreWorkData)preWorkModify_vt.get(i);

%>


      <td width="260">
       <input type="hidden" name="SEQNR<%=i%>" value="<%= data.SEQNR %>">
        <table class="tableGeneral">

          <tr>
            <th width="100"><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></td>
            <td class="td04" width="160"><%= data.BIZNO.equals("") ? "&nbsp;" : DataUtil.addSeparate2(data.BIZNO) %>
            <%  if (!data.BIZNO.equals("")) { %>
            <input type="checkbox" name="TXPAS<%=i%>" value="X" <%= data.TXPAS.equals("X") ? "checked" : "" %>><spring:message code="LABEL.D.D11.0247" /><!-- 납세조합 -->
            <%  }else{ %>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="TXPAS<%=i%>" value="X" <%= data.TXPAS.equals("X") ? "checked" : "" %>><spring:message code="LABEL.D.D11.0247" /><!-- 납세조합 -->
            <% }%>
            </td>
          </tr>

          <tr>
            <th><spring:message code="LABEL.D.D11.0221" /><!-- 회사이름 --></td>
            <td class="td04"><%= data.COMNM %>
            <!--<a href="javascript:fn_openSearch(<%=i%>)"><img src="<%= WebUtil.ImageURL %>btn_Taxserch.gif" border="0" align="absmiddle"></a>
            --></td>
          </tr>
          <tr>
            <th><spring:message code="LABEL.D.D11.0245" /><!-- 근무기간 --></td>
            <td class="td04" wrap><%= data.PABEG.equals("0000-00-00")||data.PABEG.equals("") ? "" : WebUtil.printDate(data.PABEG)+" - " %>
            <%= data.PAEND.equals("0000-00-00") ? "" : WebUtil.printDate(data.PAEND) %></td>
          </tr>
          <tr>
            <th><spring:message code="LABEL.D.D11.0246" /><!-- 감면기간 --></td>
            <td class="td04" wrap><%= data.EXBEG.equals("0000-00-00")||data.EXBEG.equals("") ? "" : WebUtil.printDate(data.EXBEG)+" - " %>
            <%= data.EXEND.equals("0000-00-00") ? "" : WebUtil.printDate(data.EXEND) %></td>
          </tr>
<%
         BET00[0]  = WebUtil.nvl(data.BET01,"");
         BET00[1]  = WebUtil.nvl(data.BET02,"");
         BET00[2]  = WebUtil.nvl(data.BET03,"");
         BET00[3]  = WebUtil.nvl(data.BET04,"");
         BET00[4]  = WebUtil.nvl(data.BET05,"");
         BET00[5]  = WebUtil.nvl(data.BET06,"");
         BET00[6]  = WebUtil.nvl(data.BET07,"");
         BET00[7]  = WebUtil.nvl(data.BET08,"");
         BET00[8]  = WebUtil.nvl(data.BET09,"");
         BET00[9]  = WebUtil.nvl(data.BET10,"");
         BET00[10] = WebUtil.nvl(data.BET11,"");
         BET00[11] = WebUtil.nvl(data.BET12,"");
         BET00[12] = WebUtil.nvl(data.BET13,"");
         BET00[13] = WebUtil.nvl(data.BET14,"");
         BET00[14] = WebUtil.nvl(data.BET15,"");
         BET00[15] = WebUtil.nvl(data.BET16,"");
         BET00[16] = WebUtil.nvl(data.BET17,"");
         BET00[17] = WebUtil.nvl(data.BET18,"");
         BET00[18] = WebUtil.nvl(data.BET19,"");
         BET00[19] = WebUtil.nvl(data.BET20,"");
         BET00[20] = WebUtil.nvl(data.BET21,"");
         BET00[21] = WebUtil.nvl(data.BET22,"");
         BET00[22] = WebUtil.nvl(data.BET23,"");
         BET00[23] = WebUtil.nvl(data.BET24,"");
         BET00[24] = WebUtil.nvl(data.BET25,"");
         BET00[25] = WebUtil.nvl(data.BET26,"");
         BET00[26] = WebUtil.nvl(data.BET27,"");
         BET00[27] = WebUtil.nvl(data.BET28,"");
         BET00[28] = WebUtil.nvl(data.BET29,"");
         BET00[29] = WebUtil.nvl(data.BET30,"");
         BET00[30] = WebUtil.nvl(data.BET31,"");
         BET00[31] = WebUtil.nvl(data.BET32,"");
         BET00[32] = WebUtil.nvl(data.BET33,"");
         BET00[33] = WebUtil.nvl(data.BET34,"");
         BET00[34] = WebUtil.nvl(data.BET35,"");
         BET00[35] = WebUtil.nvl(data.BET36,"");
         BET00[36] = WebUtil.nvl(data.BET37,"");
         BET00[37] = WebUtil.nvl(data.BET38,"");
         BET00[38] = WebUtil.nvl(data.BET39,"");
         BET00[39] = WebUtil.nvl(data.BET40,"");
         BET00[40] = WebUtil.nvl(data.BET41,"");
         BET00[41] = WebUtil.nvl(data.BET42,"");
         BET00[42] = WebUtil.nvl(data.BET43,"");
         BET00[43] = WebUtil.nvl(data.BET44,"");
         BET00[44] = WebUtil.nvl(data.BET45,"");

         for( int j = 1 ; j < preWorkHeadNm_vt.size() +1; j++ ){
             D11TaxAdjustPreWorkNmData dataNm = (D11TaxAdjustPreWorkNmData)preWorkHeadNm_vt.get(j-1);
             Inx = Integer.toString(j);
             Inx = DataUtil.fixEndZero(Inx , 2);
%>
          <tr>
            <th wrap><%= dataNm.LGTXT %></td>
            <td class="td04" wrap><%= BET00[j-1].equals("0.0") || BET00[j-1].equals("") ? "" : WebUtil.printNumFormat(BET00[j-1]) %>
            <input type="hidden" name="LGA<%=Inx%><%=i%>" value="<%= dataNm.LGART %>">
            </td>

          </tr>
<%       } %>

      </table>
    </td>
<%
    }
%>
        </tr>
        </table>
       </div>
      </div>

  <!--전근무지 테이블 종료-->

<%
    if(   !o_flag.equals("X") ) {
%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_change();"><span><spring:message code="BUTTON.COMMON.UPDATE" /><!-- 수정 --></span></a></li>
        </ul>
    </div>
<%
    }
%>

    <div class="commentImportant" >
     <%-- <p><spring:message code="LABEL.D.D11.0232" arguments="<%= targetYear %>" />1. <%= targetYear %>년 자매사 전입자, 경력입사자, 신규입사자 중 전근무지 소득이 있었던 해당자는 전근무지에서 발급받은</p>
     <p>　<spring:message code="LABEL.D.D11.0233" /><!-- 근로소득원천징수영수증에 표시된 각 항목에 대하여 입력 후 저장하시기 바랍니다. --></p> --%>
     <p>1. <spring:message code="LABEL.D.D11.0234" /><!-- 입력 시 주의사항 --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0235" /><!-- -. 사업자 번호/회사이름 : 근로소득원천징수영수증의 <b>1.법인명 / 3.사업자등록번호</b> 입력 --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0236" /><!-- -. 근무기간 : 근로소득원천징수영수증의 <b>11.근무기간</b> 입력 --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0237" /><!-- -. 정규급여/상여/인정상여 : 근로소득원천징수영수증의 <b>13.급여 / 14.상여 / 15.인정상여</b> 해당금액 입력 --></p>
     <!-- [CSR ID:3569665] 2017년 연말정산 -->
     <%-- <p>&nbsp;<spring:message code="LABEL.D.D11.0238" /><!-- -. 결정세액 소득세/지방소득세 : 근로소득원천징수영수증의 <b>64.결정세액 소득세/지방소득세</b> 각 해당금액 입력 --></p> --%>
     <p>&nbsp;-. 결정세액 소득세/지방소득세 : 근로소득원천징수영수증의 <b>72. 결정세액 소득세/지방소득세</b> 각 해당금액 입력 </p>
     <%-- <p>&nbsp;<spring:message code="LABEL.D.D11.0239" /><!-- -. 국민연금보험료 : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>국민연금</b> 금액 입력 (또는 32.국민연금보험료공제 금액 입력) --></p> --%>
     <p>&nbsp;-. 국민연금보험료: 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>국민연금</b> 금액 입력 (또는 31. 국민연금보험료공제 금액 입력)</p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0240" /><!-- -. 건강보험료 : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>건강보험</b> 금액 입력 --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0241" /><!-- -. 고용보험 : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>고용보험</b> 금액 입력 --></p>
     <p>2. <spring:message code="LABEL.D.D11.0242" /><!-- 각 항목별 금액 입력 후 전근무지 근로소득원천징수영수증을 첨부하여 주시기 바랍니다. --></p>
     <p>&nbsp;<spring:message code="LABEL.D.D11.0243" /><!-- -. 국민연금/건강보험/고용보험이 근로소득원천징수영수증의 왼쪽하단부분에 표시가 안되어있는 경우 --></p>
     <p>&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0244" /><!-- 근로소득원천징수부도 첨부하여 주시기 바랍니다. --></p>
    </div>

<!-- 숨겨진 필드 -->
  <input type="hidden" name="jobid"      value="">
  <input type="hidden" name="targetYear" value="<%=targetYear%>">
<!-- 숨겨진 필드 -->
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

