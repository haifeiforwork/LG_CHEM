<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.D.*" %>

<%
    D14TaxAdjustData data       = (D14TaxAdjustData)request.getAttribute("d14TaxAdjustData") ;
    String           targetYear = (String)request.getAttribute("targetYear") ;
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
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td class="title01">연말정산 Simulation 결과</td>
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
      <td class="font01">연도 : <%=targetYear%></td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td> 
        <!--연말정산 내역 테이블 시작-->
        <table width="486" border="0" cellspacing="1" cellpadding="2" bordercolor="#999999" class="table01">
          <tr> 
            <td class="xtd01" colspan="4">급여총액</td>
            <td class="xtr01" align="right">
<%=(data._급여총액               ==0)?"0 원":(WebUtil.printNumFormat(data._급여총액               ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="xtd01" colspan="4">상여총액</td>
            <td class="xtr01" align="right">
<%=(data._상여총액               ==0)?"0 원":(WebUtil.printNumFormat(data._상여총액               ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="xtd01" colspan="4">총급여</td>
            <td class="xtr01" align="right">
<%=(data._총급여                 ==0)?"0 원":(WebUtil.printNumFormat(data._총급여                 ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" colspan="4">비과세소득</td>
            <td class="tr01" align="right">
<%=(data._비과세소득_국외근로    ==0)?""    :(WebUtil.printNumFormat(data._비과세소득_국외근로    ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" colspan="4">근로소득공제</td>
            <td class="tr01" align="right">
<%=(data._근로소득공제           ==0)?""    :(WebUtil.printNumFormat(data._근로소득공제           ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="xtd01" colspan="4">과세대상근로소득금액</td>
            <td class="xtr01" align="right">
<%=(data._과세대상근로소득금액   ==0)?"0 원":(WebUtil.printNumFormat(data._과세대상근로소득금액   ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" rowspan="3">기본공제</td>
            <td class="td01" colspan="3">본인</td>
            <td class="tr01" align="right">
<%=(data._기본공제_본인          ==0)?""    :(WebUtil.printNumFormat(data._기본공제_본인          ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" colspan="3">배우자</td>
            <td class="tr01" align="right">
<%=(data._기본공제_배우자        ==0)?""    :(WebUtil.printNumFormat(data._기본공제_배우자        ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" colspan="3">부양가족</td>
            <td class="tr01" align="right">
<%=(data._기본공제_부양가족      ==0)?""    :(WebUtil.printNumFormat(data._기본공제_부양가족      ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" rowspan="4">추가공제</td>
            <td class="td01" colspan="3">경로우대</td>
            <td class="tr01" align="right">
<%=(data._추가공제_경로우대      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_경로우대      ,0)+" 원")%>&nbsp;
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
            <td class="td01" rowspan="6">특별공제</td>
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
            <td class="xtd01" colspan="3">계 (또는 표준공제)</td>
            <td class="xtr01" align="right">
<%=(data._특별공제계             ==0)?"0 원":(WebUtil.printNumFormat(data._특별공제계             ,0)+" 원")%>&nbsp;
            </td>
          </tr>
<!--
          <tr> 
            <td class="td01" colspan="4">차감소득금액</td>
            <td class="tr01" align="right">
<?=(data._차감소득금액           ==0)?"0 원":(WebUtil.printNumFormat(data._차감소득금액           ,0)+" 원")?>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" colspan="4">개인연금저축 소득공제</td>
            <td class="tr01" align="right">
<?=(data._개인연금저축소득공제   ==0)?""    :(WebUtil.printNumFormat(data._개인연금저축소득공제   ,0)+" 원")?>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" colspan="4">연금저축 소득공제</td>
            <td class="tr01" align="right">
<?=(data._연금저축소득공제       ==0)?""    :(WebUtil.printNumFormat(data._연금저축소득공제       ,0)+" 원")?>&nbsp;
            </td>
          </tr>
-->
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
<%=(data._종합소득과세표준       ==0)?"0 원":(WebUtil.printNumFormat(data._종합소득과세표준       ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="xtd01" colspan="4">산출세액</td>
            <td class="xtr01" align="right">
<%=(data._산출세액               ==0)?"0 원":(WebUtil.printNumFormat(data._산출세액               ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="td01" rowspan="6">세액공제</td>
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
            <td class="td01" colspan="3">외국납부</td>
            <td class="tr01" align="right">
<%=(data._세액공제_외국납부      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_외국납부      ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="xtd01" colspan="3">세액공제계</td>
            <td class="xtr01" align="right">
<%=(data._세액공제합계           ==0)?"0 원":(WebUtil.printNumFormat(data._세액공제합계           ,0)+" 원")%>&nbsp;
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
<%=(data._결정세액_갑근세        ==0)?"0 원":(WebUtil.printNumFormat( data._결정세액_갑근세 ,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_주민세        ==0)?"0 원":(WebUtil.printNumFormat( data._결정세액_주민세 ,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_농특세        ==0)?"0 원":(WebUtil.printNumFormat( data._결정세액_농특세 ,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액합계           ==0)?"0 원":(WebUtil.printNumFormat( data._결정세액합계    ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="xtd01">기납부세액</td>
            <td class="tr01" align="right">
<%=(data._기납부세액_갑근세      ==0)?"0 원":(WebUtil.printNumFormat( data._기납부세액_갑근세 ,0)+" 원")%>&nbsp;
            </td>                                                     
            <td class="tr01" align="right">                           
<%=(data._기납부세액_주민세      ==0)?"0 원":(WebUtil.printNumFormat( data._기납부세액_주민세 ,0)+" 원")%>&nbsp;
            </td>                                                     
            <td class="tr01" align="right">                           
<%=(data._기납부세액_농특세      ==0)?"0 원":(WebUtil.printNumFormat( data._기납부세액_농특세 ,0)+" 원")%>&nbsp;
            </td>                                                     
            <td class="xtr01" align="right">                          
<%=(data._기납부세액합계         ==0)?"0 원":(WebUtil.printNumFormat( data._기납부세액합계    ,0)+" 원")%>&nbsp;
            </td>
          </tr>
          <tr> 
            <td class="xtd01" width="100">차감징수세액</td><!-- 원단위 절사 -->
            <td class="xtr01" width="90" align="right">
<%=(data._차감징수세액_갑근세    ==0)?"0 원":(WebUtil.printNumFormat( data._차감징수세액_갑근세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" width="90" align="right">
<%=(data._차감징수세액_주민세    ==0)?"0 원":(WebUtil.printNumFormat( data._차감징수세액_주민세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" width="90" align="right">
<%=(data._차감징수세액_농특세    ==0)?"0 원":(WebUtil.printNumFormat( data._차감징수세액_농특세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" width="90" align="right">
<%=(data._차감징수세액합계       ==0)?"0 원":(WebUtil.printNumFormat( data._차감징수세액합계   ,0)+" 원")%>&nbsp;
            </td>
          </tr>
        </table>
        <!--연말정산 내역 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="486" border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td align="center">
              <a href="javascript:history.back();">
              <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" width="59" height="20" border="0" align="absmiddle"></a> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
