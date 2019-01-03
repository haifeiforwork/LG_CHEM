<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustPerson.jsp                                      */
/*   Description  : 인적공제 입력 및 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                  2005-11-23  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
/*                  2006-11-21  @v1.2 lsa 부녀자공제추가                        */
/*                  2008-11-20  CSR ID:1361257 2008년말정산반영                 */
/*                  2013-11-25  CSR ID:2013_9999 2013년말정산반영               */
/*                              1.인적공제:한부모가족 필드추가 ,장애코드 추가   */
/*                  2014/12/03 @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제                                                         */
/*					2018/01/07   rdcamel [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건*/
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
<%@ page import="hris.A.A12Family.rfc.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear");
    Vector person_vt  = (Vector)request.getAttribute("person_vt" );
//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentYear = DataUtil.getCurrentYear();
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));
    String Gubn = "Tax01";

    String Sex = user.e_regno.substring(6,7); //@v1.2
    D11TaxAdjustHouseEssentialChkRFC HouseEChkRFC           = new D11TaxAdjustHouseEssentialChkRFC();
    String E_CHECK = HouseEChkRFC.getYn( user.empNo,targetYear);

%>

<jsp:include page="/include/header.jsp" />
<style type="text/css">
  .td03_s {  font-size: 8pt;background-color: #F0EEDF; text-align: center; color: #585858; padding-top: 3px; height:20px;}

  .td04_s {font-size: 8pt;
    background-color: #FFFFFF;
    text-align: center;
    padding-top: 3px;
    height:20px;
    color: #585858;
    }
</style>

<SCRIPT LANGUAGE="JavaScript">
<!--
/*자녀양육 @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제*/
/*
function checkMoney(obj, cnt) {
    var hap = 0;

    if( eval("document.form1.CHILD"+ cnt + ".checked == false") ) {

        eval("document.form1.BETRG05"+cnt+".value = '';");

        for( k = 0 ; k < < %=person_vt.size()-1%>; k++){
            val = eval("removeComma(document.form1.BETRG05"+k+".value)");

            hap = hap + Number(val);
        }
        if( hap > 0 ) {
            hap = pointFormat(hap, 0);

            eval("document.form1.BETRG05"+< %=person_vt.size()-1%>+".value = insertComma(hap);") ;
        }else if( hap == 0 ){
            eval("document.form1.BETRG05"+< %=person_vt.size()-1%>+".value = '';");
        }
    } else {
        eval("document.form1.BETRG05"+cnt+".value = '1,000,000';");

        for( k = 0 ; k < < %=person_vt.size()-1%>; k++){
            val = eval("removeComma(document.form1.BETRG05"+k+".value)");

            hap = hap + Number(val);
        }
        if( hap > 0 ) {
            hap = pointFormat(hap, 0);

            eval("document.form1.BETRG05"+< %=person_vt.size()-1%>+".value = insertComma(hap);") ;
        }else if( hap == 0 ){
            eval("document.form1.BETRG05"+< %=person_vt.size()-1%>+".value = '';");
        }
    }
}
*/

//위탁아동체크시
function checkMoney2(obj, cnt) {
    var hap = 0;

    if( eval("document.form1.FSTID"+ cnt + ".checked == false") ) {
        eval("document.form1.BETRG01"+cnt+".value = '';");
        for( k = 0 ; k < <%=person_vt.size()-1%>; k++){
            val = eval("removeComma(document.form1.BETRG01"+k+".value)");

            hap = hap + Number(val);
        }
        if( hap > 0 ) {
            hap = pointFormat(hap, 0);

            eval("document.form1.BETRG01"+<%=person_vt.size()-1%>+".value = insertComma(hap);") ;
        }else if( hap == 0 ){
            eval("document.form1.BETRG01"+<%=person_vt.size()-1%>+".value = '';");
        }
    } else {

        eval("document.form1.BETRG01"+cnt+".value = '1,500,000';");
        for( k = 0 ; k < <%=person_vt.size()-1%>; k++){
            val = eval("removeComma(document.form1.BETRG01"+k+".value)");

            hap = hap + Number(val);
        }
        if( hap > 0 ) {
            hap = pointFormat(hap, 0);

            eval("document.form1.BETRG01"+<%=person_vt.size()-1%>+".value = insertComma(hap);") ;
        }else if( hap == 0 ){
            eval("document.form1.BETRG01"+<%=person_vt.size()-1%>+".value = '';");
        }
    }
}
//@v1.1      부녀자공제 체크시
function checkMoney1(obj, cnt) {
    var hap = 0;

    if( eval("document.form1.WOMEE"+ cnt + ".checked == false") ) {

        eval("document.form1.BETRG04"+cnt+".value = '';");

        for( k = 0 ; k < <%=person_vt.size()-1%>; k++){
            val = eval("removeComma(document.form1.BETRG04"+k+".value)");

            hap = hap + Number(val);
        }
        if( hap > 0 ) {
            hap = pointFormat(hap, 0);

            eval("document.form1.BETRG04"+<%=person_vt.size()-1%>+".value = insertComma(hap);") ;
        }else if( hap == 0 ){
            eval("document.form1.BETRG04"+<%=person_vt.size()-1%>+".value = '';");
        }
    } else {
        eval("document.form1.BETRG04"+cnt+".value = '500,000';");

        for( k = 0 ; k < <%=person_vt.size()-1%>; k++){
            val = eval("removeComma(document.form1.BETRG04"+k+".value)");

            hap = hap + Number(val);
        }
        if( hap > 0 ) {
            hap = pointFormat(hap, 0);

            eval("document.form1.BETRG04"+<%=person_vt.size()-1%>+".value = insertComma(hap);") ;
        }else if( hap == 0 ){
            eval("document.form1.BETRG04"+<%=person_vt.size()-1%>+".value = '';");
        }
    }
}
//CSR ID:2013_9999 한부모자녀  체크시  ---아직 안함.. 해야함.
function checkMoneyOne(obj, cnt) {
    var hap = 0;

    if( eval("document.form1.BETRG04"+ cnt + ".value != '0.0' ") && eval("document.form1.BETRG04"+ cnt + ".value != '' ")  ) {
        if( eval("document.form1.ONE_2013"+ cnt + ".checked == true")  ) {
        alert("<spring:message code='MSG.D.D11.0081' />");  //부녀자 공제와 한부모 가족 중복공제를 받을 수 없으며, \n한부모 가족 공제가 더 크므로 한부모 가족 공제만 적용합니다.
            eval("document.form1.BETRG04"+cnt+".value = '';");//부녀자공제

        //} else {
          //  eval("document.form1.BETRG04"+cnt+".value = '500,000';");
    }
    }

        for( k = 0 ; k < <%=person_vt.size()-1%>; k++){
            val = eval("removeComma(document.form1.BETRG04"+k+".value)");

            hap = hap + Number(val);
        }
        if( hap > 0 ) {
            hap = pointFormat(hap, 0);

            eval("document.form1.BETRG04"+<%=person_vt.size()-1%>+".value = insertComma(hap);") ;
        }else if( hap == 0 ){
            eval("document.form1.BETRG04"+<%=person_vt.size()-1%>+".value = '';");
        }

}

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
    //ageYear  = d.getYear() - birthYear;
    ageYear  = <%=targetYear%> - birthYear;
    return ageYear;
}

// 자녀양육
function do_build() {

    if ("<%=E_CHECK%>"=="X" && document.form1.FSTID.checked != true) {
         alert("<spring:message code='MSG.D.D11.0080' />"); //주택자금 관련공제는 세대주이어야 합니다.\n(단, 주택자금 저당차입금 이자상환액은 반드시 세대주가 아니여도 됨)\n다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.
         return;
    }

    for( var i = 0 ; i < "<%= person_vt.size()-1 %>" ; i++ ) {


        //CSR ID:2013_9999 장애인인 경우 장애코드 필수체크
        if ( eval("document.form1.BETRG03"+ i + ".value != '0.0' ")  && eval("document.form1.HNDCD"+ i + ".value == '' ") ) {
                alert("<spring:message code='MSG.D.D11.0082' />"); //장애코드를 입력하세요
                return;
        }
        /*자녀양육 @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제*/
        /*
        if( eval("document.form1.CHILD"+ i + ".checked == true") ) {
            eval("document.form1.CHILD"+ i + ".value ='X';");

            var regno  =  eval("document.form1.REGNO"+i+".value");
            if( checkAge( regno ) > 6 ){
                alert("2002년 1월 1일 이후 출생자만 자녀양육 신청가능합니다");
                eval("document.form1.CHILD"+ i + ".checked = false")
                return;
            }
        }*/

    }

    for( var i = 0 ; i < "<%= person_vt.size() %>" ; i++ ) {

        /*eval("document.form1.CHILD"+ i + ".disabled = false;") ;//자녀양육 삭제
        if( eval("document.form1.CHILD"+ i + ".checked == true") ) {//자녀양육 삭제
            eval("document.form1.CHILD"+ i + ".value ='X';");
        } else {
            eval("document.form1.BETRG01"+ i + ".value ='';");
        }*/

        eval("document.form1.FSTID"+ i + ".disabled = false;") ;
        if( eval("document.form1.FSTID"+ i + ".checked == true") )
            eval("document.form1.FSTID"+ i + ".value ='X';");

        if ( eval("document.form1.BETRG01"+ i + ".value == '' ") ) {
            eval("document.form1.BETRG01"+ i + ".value = '0.0' ;")
        } else {
            eval("document.form1.BETRG01"+i+".value = removeComma(document.form1.BETRG01"+i+".value);");
        }

        if ( eval("document.form1.BETRG02"+ i + ".value == '' ") ) {
            eval("document.form1.BETRG02"+ i + ".value = '0.0' ;")
        }  else {
            eval("document.form1.BETRG02"+i+".value = removeComma(document.form1.BETRG02"+i+".value);");
        }

        if ( eval("document.form1.BETRG03"+ i + ".value == '' ") ) {
            eval("document.form1.BETRG03"+ i + ".value = '0.0' ;")
        } else {
            eval("document.form1.BETRG03"+i+".value = removeComma(document.form1.BETRG03"+i+".value);");
        }

        if ( eval("document.form1.BETRG04"+ i + ".value == '' ") ) {
            eval("document.form1.BETRG04"+ i + ".value = '0.0' ;")
        } else {
            eval("document.form1.BETRG04"+i+".value = removeComma(document.form1.BETRG04"+i+".value);");
        }

        if ( eval("document.form1.BETRG07"+ i + ".value == '' ") ) {
            eval("document.form1.BETRG07"+ i + ".value = '0.0' ;")
        } else {
            eval("document.form1.BETRG07"+i+".value = removeComma(document.form1.BETRG07"+i+".value);");
        }

        /*자녀양육 @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제*/
        /*
        if ( eval("document.form1.BETRG05"+ i + ".value == '' ") ) {
            eval("document.form1.BETRG05"+ i + ".value = '0.0' ;")
        } else {
            eval("document.form1.BETRG05"+i+".value = removeComma(document.form1.BETRG05"+i+".value);");
        }
        if ( eval("document.form1.BETRG06"+ i + ".value == '' ") ) {
            eval("document.form1.BETRG06"+ i + ".value = '0.0' ;")
        } else {
            eval("document.form1.BETRG06"+i+".value = removeComma(document.form1.BETRG06"+i+".value);");
        }*/
    }

    eval("document.form1.FSTID.disabled = false;") ; //세대주여부
    if( eval("document.form1.FSTID.checked == true") )
        eval("document.form1.FSTID.value ='X';");

    document.form1.jobid.value = "build";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustPersonSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}

function first(){
<%
    for( int i = 0 ; i < (person_vt.size()-1) ; i++ ) {
        D11TaxAdjustPersonData data = (D11TaxAdjustPersonData)person_vt.get(i);

        String regno =   DataUtil.removeStructur(data.REGNO,"-");
        if (data.REGNO.length()>=8){
        	regno =  regno.substring(6, 7);
        }
        String birthYear  = "";
        String birthMonth = "";
        String birthDate  = "";
        int    ageYear    = 0;
        int    ageMonth   = 0;
        int    ageDate    = 0;
        if (data.REGNO.length()>=6){
        	birthYear  = data.REGNO.substring(0, 2);
        	birthMonth = data.REGNO.substring(2, 4);
        	birthDate  = data.REGNO.substring(4, 6);
        }
        if( regno.equals("1") || regno.equals("2") ){
            birthYear = "19" + birthYear;
        } else {
            birthYear = "20" + birthYear;
        }
        ageYear  = Integer.parseInt(targetYear) - Integer.parseInt(birthYear);
%>
/*자녀양육 @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제*/
/*
        if ( !data.SUBTY.equals("2") || ageYear > 6 ) {
     eval("document.form1.CHILD"+ <%=i%> + ".disabled = true;") ;
        } else {
     eval("document.form1.CHILD"+ <%=i%> + ".disabled = false;") ;

        }*/

<%
    }
%>

}

$(document).ready(function(){
	first();
 });
//-->
</SCRIPT>
</head>

 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>
<form name="form1" method="post">

    <%@ include file="D11TaxAdjustButton.jsp" %>

    <!--인적공제 테이블 시작-->
    <div class="listArea">
        <div class="table">
        <table class="listTable"  id="table">
        <thead>
          <tr>
            <th rowspan="2"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
            <th rowspan="2"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></th>
            <th rowspan="2"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></th>
            <th rowspan="2"><spring:message code="LABEL.D.D11.0015" /><!-- 기본공제 --></th>
            <th colspan="5"><spring:message code="LABEL.D.D11.0209" /><!-- 추가공제 --></th>
            <th rowspan="2"><spring:message code="LABEL.A.A12.0051" /><!-- 자녀순위 --></th>
            <th rowspan="2" class="lastCol"><spring:message code="LABEL.D.D11.0210" /><!-- 위탁아동 --></th>
            <!-- @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제
            <th rowspan="2" width="40">자녀<br>양육</th>  -->
          </tr>
          <tr>
            <th><spring:message code="LABEL.D.D11.0011" /><!-- 경로우대 --></th>
            <th><spring:message code="LABEL.D.D11.0012" /><!-- 장애자 --></th>
            <th><spring:message code="LABEL.D.D11.0211" /><!-- 장애인코드 --></th><!--CSR ID: 2013_9999-->
            <th><spring:message code="LABEL.D.D11.0013" /><!-- 부녀자 --></th>
            <th><spring:message code="LABEL.D.D11.0212" /><!-- 한부모 --></th><!--CSR ID: 2013_9999-->
            <!-- @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제
            <th width="70" nowrap>자녀<br>양육비</th>
            <th width="70" nowrap>출산·<br>입양</th>
             -->
          </tr>
          </thead>
<%
    for( int i = 0 ; i < person_vt.size() ; i++ ){
        D11TaxAdjustPersonData data = (D11TaxAdjustPersonData)person_vt.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }

        if( data.STEXT.equals("합계") ) {
%>
          <tr class="sumRow">
            <td colspan="3"><%= data.STEXT %></td>
            <td class="align_right">
                <input size="10" style="border-width:0;text-align:right" type="text" name="BETRG01<%= i %>" value="<%= data.BETRG01.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG01) %>" readonly><!-- 기본공제 -->
            </td>
            <td  class="align_right"><%= data.BETRG02.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG02) %></td><!-- 경로우대 -->
            <td  class="align_right"><%= data.BETRG03.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG03) %></td><!-- 장애자 -->
            <td>&nbsp;</td><!--CSR ID: 2013_9999 장애인공제add-->
            <td class="align_right">
                <input size="10" style="border-width:0;text-align:right" type="text" name="BETRG04<%= i %>" value="<%= data.BETRG04.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG04) %>" readonly><!-- 부녀자 -->
            </td>
            <td class="align_right"><!--CSR ID:9999한부모가족-->
                <input size="10" style="border-width:0;text-align:right" type="text" name="BETRG07<%= i %>" value="<%= data.BETRG07.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG07) %>" readonly><!-- 한부모 -->
          <input type="hidden" name="SUBTY<%= i %>"   value="<%= data.SUBTY %>">
          <input type="hidden" name="STEXT<%= i %>"   value="<%= data.STEXT %>">
          <input type="hidden" name="REGNO<%= i %>"   value="<%= data.REGNO %>">
          <input type="hidden" name="BETRG02<%= i %>" value="<%= data.BETRG02 %>">
          <input type="hidden" name="BETRG03<%= i %>" value="<%= data.BETRG03 %>">
          <input type="hidden" name="CHILD<%= i %>"   value="<%= data.CHILD %>">
          <input type="hidden" name="WOMEE<%= i %>"   value="<%= data.WOMEE %>">
          <input type="hidden" name="FSTID<%= i %>"   value="<%= data.FSTID %>">
            </td>
            <!-- @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제
            <td class="align_right">
                <input size="10" style="background-color: F1EED8;border-width:0;text-align:right" type="text" name="BETRG05<%= i %>" value="<%= data.BETRG05.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG05) %>" readonly>
            </td>
            <td class="align_right">
            <input size="10" style="background-color: F1EED8;border-width:0;text-align:right" type="text" name="BETRG06<%= i %>" value="<%= data.BETRG06.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG06) %>" readonly>
            </td>
             -->
            <td class="lastCol" colspan="2">&nbsp;</td>
            <!-- @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제
            <td class="td03" style="text-align:right">&nbsp;</td> -->
          </tr>

<%
        } else {
%>
          <tr class="<%=tr_class%>">
            <td><%= data.STEXT %></td>
            <td><%= data.ENAME %></td>
            <td><%= data.REGNO.equals("") ? "&nbsp;" : DataUtil.addSeparate(data.REGNO) %></td>
            <td class="align_right">
                <input size="10" style="background:none; border-width:0;text-align:right" type="text" name="BETRG01<%= i %>" value="<%= data.BETRG01.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG01) %>" readonly>
            </td>
            <td class="align_right"><%= data.BETRG02.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG02) %></td>
            <td class="align_right"><%= data.BETRG03.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG03) %></td>
            <td >
            <!-- style="width=100px"  select box에 삭제함. -->
        <select auto id="d_hndcd<%=i%>" style="background:none;" onChange="javascript:js_HndcdClick(<%=i%>)" name="HNDCD<%=i%>"  class="<%= data.BETRG03.equals("0.0")  ? "td03_s" : "td04_s" %>" <%= data.BETRG03.equals("0.0") ? "disabled" : "" %>>
                <option value="" >-----------</option>
                <option value="1" <%= data.HNDCD.equals("1") ? "selected" : "" %>><spring:message code="LABEL.D.D11.0213" /><!-- 장애인복지법에 따른 장애인 --></option>
                <option value="2" <%= data.HNDCD.equals("2") ? "selected" : "" %>><spring:message code="LABEL.D.D11.0214" /><!-- 상이자 및 이와 유사한 자로서 근로능력이 없는 자 --></option>
                <option value="3" <%= data.HNDCD.equals("3") ? "selected" : "" %>><spring:message code="LABEL.D.D11.0215" /><!-- 그 밖에 항시 치료를 요하는 중증환자 --></option>
              </select>

            </td><!--CSR ID: 2013_9999 장애인공제add-->

            <td class="align_right">
                <input size="10" style="background:none; border-width:0;text-align:right" type="text" name="BETRG04<%= i %>" value="<%= data.BETRG04.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG04) %>" readonly>
            </td>

            <!--CSR ID:2013_9999 한부모가족-->
            <td class="align_right">
                <input size="10" style="background:none; border-width:0;text-align:right" type="text" name="BETRG07<%= i %>" value="<%= data.BETRG07.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG07) %>" readonly>
            <input type="hidden" name="SUBTY<%= i %>"      value="<%= data.SUBTY %>">
            <input type="hidden" name="STEXT<%= i %>"      value="<%= data.STEXT %>">
            <input type="hidden" name="REGNO<%= i %>"      value="<%= data.REGNO %>">
            <input type="hidden" name="BETRG02<%= i %>"    value="<%= data.BETRG02 %>">
            <input type="hidden" name="BETRG03<%= i %>"    value="<%= data.BETRG03 %>">
            <input type="hidden" name="WOMEE<%= i %>"      value="<%= data.WOMEE %>">

            </td>
            <!-- @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제
            <td class="td04" nowrap style="text-align:right">
            <input class="input02" size="10" style="border-width:0;text-align:right" type="text" name="BETRG05<%= i %>" value="111<%= data.BETRG05.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG05) %>" readonly>
            </td>
<!--CSR ID:-- >
            <td class="td04" nowrap style="text-align:right">
                <input size="10" style="border-width:0;text-align:right" type="text" name="BETRG06<%= i %>" value="222<%= data.BETRG06.equals("0.0") ? "" : WebUtil.printNumFormat(data.BETRG06) %>" readonly>
            </td>  -->

            <!-- [CSR ID:3569665] 2017 연말정산 자녀 수 -->
            <td>
	            <select name="KDBSL<%= i %>" <%=data.SUBTY.equals("2") && Double.parseDouble(data.BETRG06) > 0 ? "":"disabled"%>>
		            <option value="">-------------</option>
		            <%= WebUtil.printOption((new A12FamilyAusprRFC()).getFamilyAuspr( ), data.KDBSL) %>
	        	</select>
            </td>
            <td class="lastCol">

<%
            if(  data.SUBTY.equals("8")&& data.STEXT.equals("위탁아동")) { //위탁아동
%>
              <input type="checkbox" name="FSTID<%= i %>" value="<%= data.FSTID == null ? "" : data.FSTID %>" <%= data.FSTID.equals("X")  ? "checked" : "" %>  onClick="javascript:checkMoney2(this,<%= i %>);" >
<%
            } else {
%>
              <input type="checkbox" name="FSTID<%= i %>" value="<%= data.FSTID == null ? "" : data.FSTID %>" <%= data.FSTID.equals("X")  ? "checked" : "" %>  disabled>
<%
            }
%>
            </td>
<!--  @2014 연말정산   자녀양육비, 출산입양, 자녀양육 컬럼 삭제
            <td>
< %
            if( data.SUBTY.equals("2") ) {
% >
             <input type="checkbox" name="CHILD<%= i %>" value="<%= data.CHILD == null ? "" : data.CHILD %>" <%= data.CHILD.equals("X")  ? "checked" : "" %> onClick="javascript:checkMoney(this,<%= i %>);" >
< %
            } else {
% >
             <input type="checkbox" name="CHILD<%= i %>" value="<%= data.CHILD == null ? "" : data.CHILD %>" <%= data.CHILD.equals("X")  ? "checked" : "" %>>
< %
            }
% >
            </td>
 -->



          </tr>
<%
        }
    }
%>
        </table>
        </div>
        <div class="commentsMoreThan2">
        	<div><spring:message code="LABEL.D.D11.0290" /><!-- 1. <span class="textPink">자녀순위 : '17년 출생(또는 '17년에 입양)한 자녀가 총 자녀인원 기준으로 몇번째 자녀</span>인지를 선택하시기 바랍니다. --></div>
            <div><spring:message code="LABEL.D.D11.0216" /><!-- 1. 부녀자 : 근로소득금액 3,000만원이하(총급여 4,000만원 수준)인 배우자가 있는 여성(맞벌이 부부)은 부녀자란 "○"표시 후 주민등록등본 및 가족관계증명서를 첨부해야 함 --></div>
            <div><spring:message code="LABEL.D.D11.0217" /><!-- 2. 한부모 : 배우자가 없는 자로서 기본공제대상 직계비속이 있는 경우 : 한부모란에 수기로 “○” 표시후 가족관계증명서 첨부해야 함 --></div>
            <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 @위탁아동 문구 삭제 -->
            <%-- <div><spring:message code="LABEL.D.D11.0218" /><!-- 3. 위탁아동 : 올해에 6개월 이상(만 18세 미만) 직접 양육한 위탁아동일 경우 "□"에 체크 후 저장 --></div> --%>
            <span><spring:message code="LABEL.D.D11.0219" /><!-- ※ 부녀자 공제와 한부모 공제는 중복공제가 안되므로 한부모 공제만 적용됨 --></span>
        </div>
    </div>
    <!--인적공제 테이블 끝-->

<%
    //if( appl_from <= 0 && appl_toxx >= 0 && !o_flag.equals("X") ) {
    if(  !o_flag.equals("X") ) {
%>

    <div class="buttonArea underList">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_build();"><span><spring:message code="LABEL.D.D11.0220" /><!-- 저장 --></span></a></li>
        </ul>
    </div>

<%
    }
%>

</div>
<!-- 숨겨진 필드 -->
    <input type="hidden" name="jobid"      value="">
    <input type="hidden" name="targetYear" value="<%=targetYear%>">
    <input type="hidden" name="rowCount"   value="<%= person_vt.size() %>">
<!-- 숨겨진 필드 -->
</form>


<script>

function js_HndcdClick(inx){
    document.getElementById( 'd_hndcd'+inx ).options[1].text='장애인복지법에 따른 장애인';
    document.getElementById( 'd_hndcd'+inx ).options[2].text='상이자 및 이와 유사한 자로서 근로능력이 없는 자';
    document.getElementById( 'd_hndcd'+inx ).options[3].text='그 밖에 항시 치료를 요하는 중증환자';
    refresh_selectbox(document.getElementById('d_hndcd'+inx ));
    document.getElementById('d_hndcd'+inx ).focus();

}
/***********************************************************
* 자동으로 사이즈가 변하는 select box Ver20070423박규선
* 사용법: <select style="width=100px" auto></select>
* 제약조건  onmouseover onclick onmouseout onblur 를 정의하지 말것
* 구현은   onchange 이벤트에 구현하세요
************************************************************/
function autoselectboxsize(){
 var _obj ;
 var arr = document.getElementsByTagName('select');
 var w,h;
 for(var i=0;i<arr.length;i++){
   _obj = arr[i];
   if(_obj.getAttribute("auto")!=null){
    w=_obj.offsetWidth-1;
    h=_obj.offsetHeight;
    _obj.onmouseover="if(this.ow==undefined){this.ow=this.offsetWidth}if(this.n==undefined||this.n==false){this.style.width='';if(this.offsetWidth<=this.ow){this.n=true;this.style.width=this.ow+'px';}}";
    _obj.onclick="this.b=true;if(this.n==true){return;}if(this.n==undefined||this.n==false){this.style.width='';if(this.offsetWidth<=this.ow){this.n=true;this.style.width=this.ow+'px';this.onclick=null;}}";
    _obj.onmouseout="if(this.b==true){return;}if(this.n==undefined||this.n==false){this.style.width=this.ow+'px';}";
    _obj.onblur="this.b=false;if(this.ow!=undefined){this.style.width=this.ow+'px';}";
    _obj.outerHTML="<div  nowrap style='width:" + w + ";height:" + h + "px;overflow:hidden;text-overflow:ellipsis;padding-top:0px;'>" +_obj.outerHTML+"</div>";
    _obj.removeAttribute("auto");
   }
 }
}
/***********************************************************
* 사이즈 내용이 변경된 경우 호출 select box Ver20070423박규선
* 사용법: refresh_selectbox(selectbox_objects_instance)

************************************************************/
function refresh_selectbox(obj){
 obj.ow=undefined;
 obj.n=undefined;
}
autoselectboxsize(); //맨 아래에서 호출하세요.

</SCRIPT>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
