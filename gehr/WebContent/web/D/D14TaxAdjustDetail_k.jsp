<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    D14TaxAdjustData_k data       = (D14TaxAdjustData_k)request.getAttribute("d14TaxAdjustData_k") ;
    String             targetYear = (String)request.getAttribute("targetYear") ;

    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    TaxAdjustFlagData taxAdjustFlagData = ((TaxAdjustFlagData)session.getAttribute("taxAdjust"));

    if( disp_from <= 0 && disp_toxx >= 0 ) {
    } else {
        String curYear = "";
        if ( targetYear.equals(taxAdjustFlagData.targetYear) ) {
            curYear = Integer.toString(Integer.parseInt( taxAdjustFlagData.targetYear ) - 1);
            D14TaxAdjustDetail_k_RFC rfc  = new D14TaxAdjustDetail_k_RFC();
            data = null;
            data = (D14TaxAdjustData_k)rfc.detail( user.empNo, curYear );
        }
    }
    String Gubn = "Detail";   //@v1.1

 %>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess2.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<style>
<!--
.xtr01 {  font-family: "돋움", "돋움체"; font-size: 12px; background-color: #FFDECE}
.xtd01 {  font-family: "굴림", "굴림체"; font-size: 9pt; font-weight: normal; color: #333333; background-color: #FFC0A2; padding-left: 10px}
.xtd02 {  font-family: "굴림", "굴림체"; font-size: 9pt; color: #333333; padding-left: 5px; background-color: #FFC0A2; line-height: 14pt}
.xtd03 {  font-family: "굴림", "굴림체"; font-size: 9pt; background-color: #FFC0A2; font-weight: normal; text-align: center; line-height: 14pt}
-->
</style>
<SCRIPT LANGUAGE="JavaScript">

function showList() {
    var up = document.form1;
    var up1 = eval(up.year.options[up.year.options.selectedIndex].value);
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D14TaxAdjustDetail_k_SV?targetYear="+up1;
    document.form1.method = "post" ;
    document.form1.target = "menuContentIframe" ;
    document.form1.submit() ;
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1">
<input type="hidden" name="jobid"  value="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="title01">연말정산 내역 조회</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01">연도 :
        <select name="year">
<%
    String selectYear = taxAdjustFlagData.targetYear;
    if( disp_from <= 0 && disp_toxx >= 0 ) {
    } else {
        selectYear = Integer.toString(Integer.parseInt( taxAdjustFlagData.targetYear ) - 1);
        if ( targetYear.equals(taxAdjustFlagData.targetYear) ) {
            targetYear = Integer.toString(Integer.parseInt( targetYear ) - 1);
        }
    }

    for( int i = 2001 ; i <= Integer.parseInt( selectYear ) ; i++ ) {
%>
         <option value="<%= i %>" <%= i == Integer.parseInt(targetYear) ? "selected" : "" %>><%= i %></option>
<%
    }
%>
        </select>
      <a href="javascript:showList();"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif" width="52" height="20" border="0" align="absmiddle"></a>
      </td>
    </tr>



    <tr>
      <td width="15">&nbsp;</td>
      <td>

        <table width="789" border="0" cellspacing="0" cellpadding="0" height="22">
    <%@ include file="../D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

        </table>

      </td>
    </tr>
     <!--개인정보 테이블 끝-->
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--개인정보 테이블 시작-->
        <table width="789" border="0" cellspacing="0" cellpadding="0" height="22">
<%
    if(user.e_oversea.equals("X")||user.e_oversea.equals("L")) {
%>
          <tr>
            <td width="72"></td>
            <td width="72"> </td>
            <td width="72"> </td>
            <td width="109"></td>
            <td width="109"></td>
            <td width="102"></td>
            <td width="132"></td>
            <td width="121">
              <img src="<%= WebUtil.ImageURL %>k_on.gif" width="121" height="22">
            </td>
          </tr>
<%
    } else {
%>
          <tr>
            <td width="72">&nbsp;</td>
            <td width="72">&nbsp;</td>
            <td width="72">&nbsp;</td>
            <td width="109">&nbsp;</td>
            <td width="109">&nbsp;</td>
            <td width="102">&nbsp;</td>
            <td width="132">&nbsp;</td>
            <td width="121">&nbsp;</td>
          </tr>
<%
    }
%>
        </table>
        <!--개인정보 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
<%
    if(data.isUsableData.equals("NO")){
%>
        <table width="486" border="0" cellspacing="1" cellpadding="2" bordercolor="#999999" class="table01">
          <tr>
            <td class="td01" align="center"><br>해당연도에 연말정산 내역 데이타가 없습니다.<br>&nbsp;</td>
          </tr>
         </table>
<%
    } else {
%>
        <!--연말정산 내역 테이블 시작-->
        <table width="486" border="0" cellspacing="1" cellpadding="2" bordercolor="#999999" class="table01">
          <tr>
            <td class="xtd01" rowspan="4">전근무지</td>
            <td class="td01" colspan="3">급여총액</td>
            <td class="tr01" align="right">
<%=(data._전근무지_급여총액               ==0)?""    :(WebUtil.printNumFormat(data._전근무지_급여총액,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">상여총액</td>
            <td class="tr01" align="right">
<%=(data._전근무지_상여총액               ==0)?""    :(WebUtil.printNumFormat(data._전근무지_상여총액,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">인정상여</td>
            <td class="tr01" align="right">
<%=(data._전근무지_인정상여               ==0)?""    :(WebUtil.printNumFormat(data._전근무지_인정상여,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">비과세소득</td>
            <td class="tr01" align="right">
<% double bgs = data._전근무지_비과세해외소득 + data._전근무지_비과세초과근무 + data._전근무지_기타비과세대상; %>
<%=(bgs    ==0)?""                       :(WebUtil.printNumFormat(bgs                     ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" rowspan="4">현근무지</td>
            <td class="td01" colspan="3">급여총액</td>
            <td class="tr01" align="right">
<%=(data._급여총액               ==0)?""             :(WebUtil.printNumFormat(data._급여총액               ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">상여총액</td>
            <td class="tr01" align="right">
<%=(data._상여총액               ==0)?""             :(WebUtil.printNumFormat(data._상여총액               ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">인정상여</td>
            <td class="tr01" align="right">
<%=(data._인정상여               ==0)?""             :(WebUtil.printNumFormat(data._인정상여               ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">비과세소득</td>
            <td class="tr01" align="right">
<% double bgs2 = (data._비과세소득_국외근로 + data._비과세소득_야간근로수당 + data._비과세소득_기타비과세) - (data._전근무지_비과세해외소득 + data._전근무지_비과세초과근무 + data._전근무지_기타비과세대상); %>
<%=(bgs2    ==0)?""                       :(WebUtil.printNumFormat(bgs2                     ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" colspan="4">총급여</td>
            <td class="xtr01" align="right">
<%=(data._총급여                 ==0)?""             :(WebUtil.printNumFormat(data._총급여                 ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="4">근로소득공제</td>
            <td class="tr01" align="right">
<%=(data._근로소득공제           ==0)?""              :(WebUtil.printNumFormat(data._근로소득공제           ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" colspan="4">과세대상근로소득금액</td>
            <td class="xtr01" align="right">
<%=(data._과세대상근로소득금액   ==0)?""               :(WebUtil.printNumFormat(data._과세대상근로소득금액   ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" rowspan="3">기본공제</td>
            <td class="td01" colspan="3">본인</td>
            <td class="tr01" align="right">
<%=(data._기본공제_본인          ==0)?""               :(WebUtil.printNumFormat(data._기본공제_본인          ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">배우자</td>
            <td class="tr01" align="right">
<%=(data._기본공제_배우자        ==0)?""               :(WebUtil.printNumFormat(data._기본공제_배우자        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">부양가족</td>
            <td class="tr01" align="right">
<%=(data._기본공제_부양가족      ==0)?""    :(WebUtil.printNumFormat(data._기본공제_부양가족      ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" rowspan="5">추가공제</td>
            <td class="td01" colspan="3">경로우대(65~69세)</td>
            <td class="tr01" align="right">
<%=(data._추가공제_경로우대      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_경로우대      ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">경로우대(70세이상)</td>
            <td class="tr01" align="right">
<%=(data._추가공제_경로우대70      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_경로우대70      ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">장애인</td>
            <td class="tr01" align="right">
<%=(data._추가공제_장애인        ==0)?""    :(WebUtil.printNumFormat(data._추가공제_장애인        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">부녀자</td>
            <td class="tr01" align="right">
<%=(data._추가공제_부녀자        ==0)?""    :(WebUtil.printNumFormat(data._추가공제_부녀자        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">자녀양육비</td>
            <td class="tr01" align="right">
<%=(data._추가공제_자녀양육비    ==0)?""    :(WebUtil.printNumFormat(data._추가공제_자녀양육비    ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="4">소수공제자 추가공제</td>
            <td class="tr01" align="right">
<%=(data._소수공제자추가공제     ==0)?""    :(WebUtil.printNumFormat(data._소수공제자추가공제     ,0)+" 원")%>&nbsp;
            </td>
          </tr>

          <tr>
            <td class="td01" colspan="4">연금보험료공제</td>
            <td class="tr01" align="right">
<%=(data._연금보험료공제         ==0)?""    :(WebUtil.printNumFormat(data._연금보험료공제         ,0)+" 원")%>&nbsp;
            </td>
          </tr>

          <tr>
            <td class="td01" rowspan="7">특별공제</td>
            <td class="td01" colspan="3">보험료</td>
            <td class="tr01" align="right">
<%=(data._특별공제_보험료        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_보험료        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">의료비</td>
            <td class="tr01" align="right">
<%=(data._특별공제_의료비        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_의료비        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">교육비</td>
            <td class="tr01" align="right">
<%=(data._특별공제_교육비        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_교육비        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">주택자금</td>
            <td class="tr01" align="right">
<%=(data._특별공제_주택자금      ==0)?""    :(WebUtil.printNumFormat(data._특별공제_주택자금      ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">기부금</td>
            <td class="tr01" align="right">
<%=(data._특별공제_기부금        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_기부금        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">혼인·장례·이사비</td>
            <td class="tr01" align="right">
<%=(data._특별공제_경조사비        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_경조사비        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" colspan="3">계 (또는 표준공제)</td>
            <td class="xtr01" align="right">
<%=(data._특별공제계             ==0)?""   :(WebUtil.printNumFormat(data._특별공제계             ,0)+" 원")%>&nbsp;
            </td>
          </tr>
<%
// 개인연금저축소득공제필드는 삭제하고 금액은 연금저축소득공제에 합산한다
    double _연금저축 = data._연금저축소득공제 + data._개인연금저축소득공제 ;
%>
          <tr>
            <td class="td01" colspan="4">연금저축 소득공제</td>
            <td class="tr01" align="right">
<%=(_연금저축 == 0)?"":(WebUtil.printNumFormat(_연금저축,0)+" 원")%>&nbsp;
          <tr>
            <td class="td01" colspan="4">투자조합출자등 소득공제</td>
            <td class="tr01" align="right">
<%=(data._투자조합출자등소득공제 ==0)?""    :(WebUtil.printNumFormat(data._투자조합출자등소득공제 ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="4">신용카드공제</td>
            <td class="tr01" align="right">
<%=(data._신용카드공제           ==0)?""    :(WebUtil.printNumFormat(data._신용카드공제           ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" colspan="4">종합소득 과세표준</td>
            <td class="xtr01" align="right">
<%=(data._종합소득과세표준       ==0)?""    :(WebUtil.printNumFormat(data._종합소득과세표준       ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" colspan="4">산출세액</td>
            <td class="xtr01" align="right">
<%=(data._산출세액               ==0)?""    :(WebUtil.printNumFormat(data._산출세액               ,0)+" 원")%>&nbsp;
            </td>
          </tr>
<%
//  _감면세액계 = data._세액감면_소득세법정산 + data._세액감면_조세특례제한법
    double _감면세액계 = data._세액감면_소득세법정산 + data._세액감면_조세특례제한법 ;
%>
          <tr>
            <td class="td01" rowspan="3">세액감면</td>
            <td class="td01" colspan="3">소득세법</td>
            <td class="tr01" align="right">
<%=(data._세액감면_소득세법정산  ==0)?""    :(WebUtil.printNumFormat(data._세액감면_소득세법정산   ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">조세특례제한법</td>
            <td class="tr01" align="right">
<%=(data._세액감면_조세특례제한법==0)?""    :(WebUtil.printNumFormat(data._세액감면_조세특례제한법 ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" colspan="3">감면세액계</td>
            <td class="xtr01" align="right">
<%=(_감면세액계                 ==0)?""     :(WebUtil.printNumFormat(_감면세액계                   ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" rowspan="7">세액공제</td>
            <td class="td01" colspan="3">근로소득</td>
            <td class="tr01" align="right">
<%=(data._세액공제_근로소득      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_근로소득      ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">주택자금이자</td>
            <td class="tr01" align="right">
<%=(data._세액공제_주택차입금    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_주택차입금    ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">근로자주식저축</td>
            <td class="tr01" align="right">
<%=(data._세액공제_근로자주식저축==0)?""    :(WebUtil.printNumFormat(data._세액공제_근로자주식저축,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">장기증권저축</td>
            <td class="tr01" align="right">
<%=(data._장기증권저축==0)?""    :(WebUtil.printNumFormat(data._장기증권저축,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">정치기부금</td>
            <td class="tr01" align="right">
<%=(data._정치기부금==0)?""    :(WebUtil.printNumFormat(data._정치기부금,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">외국납부</td>
            <td class="tr01" align="right">
<%=(data._세액공제_외국납부      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_외국납부      ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" colspan="3">세액공제계</td>
            <td class="xtr01" align="right">
<%=(data._세액공제합계           ==0)?""    :(WebUtil.printNumFormat(data._세액공제합계           ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="td01">&nbsp;</td>
            <td class="td03">갑근세</td>
            <td class="td03">주민세</td>
            <td class="td03">농특세</td>
            <td class="xtd03">계</td>
          </tr>
          <tr>
            <td class="xtd01">결정세액</td>
            <td class="xtr01" align="right">
<%=(data._결정세액_갑근세        ==0)?""    :(WebUtil.printNumFormat(DataUtil.nelim(  data._결정세액_갑근세, -1 ),0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_주민세        ==0)?""    :(WebUtil.printNumFormat(DataUtil.nelim(  data._결정세액_주민세, -1 ),0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_농특세        ==0)?""    :(WebUtil.printNumFormat(DataUtil.nelim(  data._결정세액_농특세, -1 ),0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액합계           ==0)?""    :(WebUtil.printNumFormat(DataUtil.nelim(  data._결정세액합계, -1 ),0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01">기납부세액</td>
            <td class="tr01" align="right">
<%=(data._기납부세액_갑근세      ==0)?""    :(WebUtil.printNumFormat(data._기납부세액_갑근세      ,0)+" 원")%>&nbsp;
            </td>
            <td class="tr01" align="right">
<%=(data._기납부세액_주민세      ==0)?""    :(WebUtil.printNumFormat(data._기납부세액_주민세      ,0)+" 원")%>&nbsp;
            </td>
            <td class="tr01" align="right">
<%=(data._기납부세액_농특세      ==0)?""    :(WebUtil.printNumFormat(data._기납부세액_농특세      ,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._기납부세액합계         ==0)?""    :(WebUtil.printNumFormat(data._기납부세액합계         ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr>
            <td class="xtd01" width="100">차감징수세액</td><!-- 원단위 절사 -->
            <td class="xtr01" width="90" align="right">
<%=(data._차감징수세액_갑근세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_갑근세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" width="90" align="right">
<%=(data._차감징수세액_주민세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_주민세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" width="90" align="right">
<%=(data._차감징수세액_농특세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_농특세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" width="90" align="right">
<%=(data._차감징수세액합계       ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액합계,0)+" 원")%>&nbsp;
            </td>
          </tr>
        </table>
    <!--연말정산 내역 테이블 끝-->
<%
    }
%>
      </td>
    </tr>
  </table>
  <input type="hidden" name="selectYear"       value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
