<%/******************************************************************************/
/*                                                                              */
/*   System Name  : EHR                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustFamily.jsp                                      */
/*   Description  : 부양가족공제 입력 및 조회                                   */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-11-24  lsa   C2005111701000000551                      */
/*                  2005-11-30  lsa   인적공제대상자만 선택가능하게             */
/*                  2006-11-22  lsa   @v1.2   현금영수증,기부금,구분 추가       */
/*                  2012-12-21  C20121213_34842 2012 년말정산  전통시장사용분추가 */
/*   Update       : 2013-11-25  CSR ID:2013_9999 2013년말정산반영               */
/*                  교통카드  추가                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.io.* " %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear");
    Vector family_vt  = (Vector)request.getAttribute("family_vt" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentYear = DataUtil.getCurrentYear();
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));
    String Gubn = "Tax07";
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
function checkAge(resno) {
    birthYear  = resno.substr(0, 2);
    birthMonth = resno.substr(2, 2);
    birthDate  = resno.substr(4, 2);
    if( resno.charAt(6) == '1' || resno.charAt(6) == '2'){
        birthYear = "19" + birthYear;
    } else {
        birthYear = "20" + birthYear;
    }
    ageYear  = 0;
    ageMonth = 0;
    ageDate  = 0;

    d = new Date();
    ageYear  = <%=targetYear%> - birthYear;
    return ageYear;
}

// 저장
function do_build() {
    for( var i = 0 ; i < "<%= family_vt.size()%>" ; i++ ) {
    //    if( eval("document.form1.FAMI_F001"+ i + ".checked == true") ) {
    //        eval("document.form1.FAMI_F001"+ i + ".value = 'X';");
    //    } else {
    //        eval("document.form1.FAMI_F001"+ i + ".value = '';");
    //    }
    //    if( eval("document.form1.FAMI_F004"+ i + ".checked == true") ) {
    //        eval("document.form1.FAMI_F004"+ i + ".value = 'X';");
    //    } else {
    //        eval("document.form1.FAMI_F004"+ i + ".value = '';");
    //    }
          eval("document.form1.INSUR"+i+".value   = removeComma(document.form1.INSUR"+i+".value);");
          eval("document.form1.MEDIC"+i+".value   = removeComma(document.form1.MEDIC"+i+".value);");
          eval("document.form1.EDUCA"+i+".value   = removeComma(document.form1.EDUCA"+i+".value);");
          eval("document.form1.CREDIT"+i+".value   = removeComma(document.form1.CREDIT"+i+".value);");
          eval("document.form1.CASHR"+i+".value   = removeComma(document.form1.CASHR"+i+".value);");
          eval("document.form1.GIBU"+i+".value   = removeComma(document.form1.GIBU"+i+".value);");

    }

    document.form1.jobid.value = "build";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustFamilySV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}

//-->
</SCRIPT>


 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>
<form name="form1" method="post">


    <%@ include file="D11TaxAdjustButton.jsp" %>

    <!--부양가족공제 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable" id="table">
            <thead>
              <tr>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></th>
                <th class="lastCol" colspan="9"><spring:message code="LABEL.D.D11.0126" /><!-- 공제대상 --></th>
              </tr>
              <tr>
                <th><spring:message code="LABEL.D.D11.0032" /><!-- 보험료 --></th>
                <th><spring:message code="LABEL.D.D11.0033" /><!-- 의료비 --></th>
                <th><spring:message code="LABEL.D.D11.0034" /><!-- 교육비 --></th>
                <th><spring:message code="LABEL.D.D11.0127" /><!-- 신용카드등 --></th>
                <th><spring:message code="LABEL.D.D11.0128" /><!-- 직불카드등 --></th>
                <th><spring:message code="LABEL.D.D11.0056" /><!-- 현금영수증 --></th>
                <th><spring:message code="LABEL.D.D11.0129" /><!-- 전통시장분 --></th>
                <th><spring:message code="LABEL.D.D11.0130" /><!-- 대중교통분 --></th><!--CSR ID:2013_9999 -->
                <th class="lastCol"><spring:message code="LABEL.D.D11.0036" /><!-- 기부금 --></th>
              </tr>
             </thead>
<%
    String f01Disabled = "";
    String f04Disabled = "";
    for( int i = 0 ; i < family_vt.size() ; i++ ){
        D11TaxAdjustFamilyData data = (D11TaxAdjustFamilyData)family_vt.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }

//      보험료 check box : 인적공제자인 경우에만 선택가능하게 한다.
        if( data.FAMI_B001.equals("X") ) {
            f01Disabled = "";
        } else {
            f01Disabled = "disabled";
        }
//      신용카드등 check box : 형제자매가 아닌 경우에만 선택가능하게 한다.
        if( data.FAMI_RLAT.equals("07") || data.FAMI_RLAT.equals("08") || data.FAMI_RLAT.equals("09") ||
            data.FAMI_RLAT.equals("10") || data.FAMI_RLAT.equals("24") || data.FAMI_RLAT.equals("25") ||
            data.FAMI_RLAT.equals("28") || data.FAMI_RLAT.equals("29") ) {
            f04Disabled = "disabled";
        } else {
            f04Disabled = "";
        }
        //if ( !(data.INSUR.equals("0.0") && data.MEDIC.equals("0.0") && data.EDUCA.equals("0.0") && data.CREDIT.equals("0.0") && data.CASHR.equals("0.0") && data.GIBU.equals("0.0") ) ) {
%>
          <tr class="<%=tr_class%>">
            <td><%= data.FAMI_RLNM %></td>
            <td><%= data.FAMI_NAME %></td>
            <td><%= data.FAMI_REGN.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.FAMI_REGN) %></td>
            <td><%= data.E_GUBUN %></td><!--@v1.2-->
            <td class="align_right"><%= data.INSUR.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.INSUR)   %></td>
            <td class="align_right"><%= data.MEDIC.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.MEDIC)   %></td>
            <td class="align_right"><%= data.EDUCA.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.EDUCA)   %></td>
            <td class="align_right"><%= data.CREDIT.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.CREDIT) %></td>
            <td class="align_right"><%= data.DEBIT.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.DEBIT) %></td>
            <td class="align_right"><%= data.CASHR.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.CASHR)   %></td>
            <td class="align_right"><%= data.CCREDIT.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.CCREDIT)     %></td><!--C20121213_34842-->
            <td class="align_right"><%= data.PCREDIT.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.PCREDIT)     %></td><!--CSR ID:2013_9999 대중교통사용분-->
            <td class="align_right lastCol"><%= data.GIBU.equals("")  ? "&nbsp;" : WebUtil.printNumFormat(data.GIBU)     %>


            <input type="hidden" name="WORK_YEAR<%= i %>" value="<%= data.WORK_YEAR%>">  <!--연말정산 연도-->
            <input type="hidden" name="BEGDA<%= i %>"     value="<%= data.BEGDA    %>">  <!--시작일       -->
            <input type="hidden" name="ENDDA<%= i %>"     value="<%= data.ENDDA    %>">  <!--종료일       -->
            <input type="hidden" name="PERNR<%= i %>"     value="<%= data.PERNR    %>">  <!--사원번호     -->
            <input type="hidden" name="SEQNR<%= i %>"     value="<%= data.SEQNR    %>">  <!--순번         -->
            <input type="hidden" name="FAMI_RLAT<%= i %>" value="<%= data.FAMI_RLAT%>">  <!--관계         -->
            <input type="hidden" name="FAMI_RLNM<%= i %>" value="<%= data.FAMI_RLNM%>">  <!--관계 명칭    -->
            <input type="hidden" name="FAMI_OBJP<%= i %>" value="<%= data.FAMI_OBJP%>">  <!--관계의 순번  -->
            <input type="hidden" name="FAMI_NAME<%= i %>" value="<%= data.FAMI_NAME%>">  <!--이름         -->
            <input type="hidden" name="FAMI_REGN<%= i %>" value="<%= data.FAMI_REGN%>">  <!--주민등록번호 -->
            </td>
          </tr>
<%
         //}
    }
%>
            </table>
        </div>
    </div>
    <!--부양가족공제 테이블 끝-->

</div>
<!-- 숨겨진 필드 -->
    <input type="hidden" name="jobid"      value="">
    <input type="hidden" name="targetYear" value="<%=targetYear%>">
    <input type="hidden" name="rowCount"   value="<%= family_vt.size() %>">
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

